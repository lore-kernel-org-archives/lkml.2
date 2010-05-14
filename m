Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab0ENUrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:47:53 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:50496 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab0ENUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:47:51 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <jens.axboe@oracle.com>,
       <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH RFC] virtio_blk: Use blk-iopoll for host->guest notify
Date: Fri, 14 May 2010 21:47:37 +0100
Message-Id: <1273870057-4287-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds blk-iopoll interrupt mitigation to virtio-blk.  Instead
of processing completed requests inside the virtqueue interrupt handler,
a softirq is scheduled to process up to a maximum number of completed
requests in one go.

If the number of complete requests exceeds the maximum number, then another
softirq is scheduled to continue polling.  Otherwise the virtqueue interrupt is
enabled again and we return to interrupt-driven mode.

The patch sets the maximum number of completed requests (aka budget, aka
weight) to 4.  This is a low number but reflects the expensive context
switch between guest and host virtio-blk emulation.

The blk-iopoll infrastructure is enabled system-wide by default:

kernel.blk_iopoll = 1

It can be disabled to always use interrupt-driven mode (useful for comparison):

kernel.blk_iopoll = 0

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
No performance figures yet.

 drivers/block/virtio_blk.c |   71 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2138a7a..1523895 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -6,6 +6,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
+#include <linux/blk-iopoll.h>
 
 #define PART_BITS 4
 
@@ -26,6 +27,9 @@ struct virtio_blk
 
 	mempool_t *pool;
 
+	/* Host->guest notify mitigation */
+	struct blk_iopoll iopoll;
+
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -42,16 +46,18 @@ struct virtblk_req
 	u8 status;
 };
 
-static void blk_done(struct virtqueue *vq)
+/* Assumes vblk->lock held */
+static int __virtblk_end_requests(struct virtio_blk *vblk, int weight)
 {
-	struct virtio_blk *vblk = vq->vdev->priv;
 	struct virtblk_req *vbr;
 	unsigned int len;
-	unsigned long flags;
+	int error;
+	int work = 0;
 
-	spin_lock_irqsave(&vblk->lock, flags);
-	while ((vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len)) != NULL) {
-		int error;
+	while (!weight || work < weight) {
+		vbr = vblk->vq->vq_ops->get_buf(vblk->vq, &len);
+		if (!vbr)
+			break;
 
 		switch (vbr->status) {
 		case VIRTIO_BLK_S_OK:
@@ -74,10 +80,53 @@ static void blk_done(struct virtqueue *vq)
 		__blk_end_request_all(vbr->req, error);
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
+		work++;
 	}
+
 	/* In case queue is stopped waiting for more buffers. */
 	blk_start_queue(vblk->disk->queue);
+	return work;
+}
+
+static int virtblk_iopoll(struct blk_iopoll *iopoll, int weight)
+{
+	struct virtio_blk *vblk =
+		container_of(iopoll, struct virtio_blk, iopoll);
+	unsigned long flags;
+	int work;
+
+	spin_lock_irqsave(&vblk->lock, flags);
+
+	work = __virtblk_end_requests(vblk, weight);
+	if (work < weight) {
+		/* Keep polling if there are pending requests. */
+		if (vblk->vq->vq_ops->enable_cb(vblk->vq))
+			__blk_iopoll_complete(&vblk->iopoll);
+		else
+			vblk->vq->vq_ops->disable_cb(vblk->vq);
+	}
+
 	spin_unlock_irqrestore(&vblk->lock, flags);
+	return work;
+}
+
+static void blk_done(struct virtqueue *vq)
+{
+	struct virtio_blk *vblk = vq->vdev->priv;
+	unsigned long flags;
+
+	if (blk_iopoll_enabled) {
+		if (!blk_iopoll_sched_prep(&vblk->iopoll)) {
+			spin_lock_irqsave(&vblk->lock, flags);
+			vblk->vq->vq_ops->disable_cb(vblk->vq);
+			spin_unlock_irqrestore(&vblk->lock, flags);
+			blk_iopoll_sched(&vblk->iopoll);
+		}
+	} else {
+		spin_lock_irqsave(&vblk->lock, flags);
+		__virtblk_end_requests(vblk, 0);
+		spin_unlock_irqrestore(&vblk->lock, flags);
+	}
 }
 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
@@ -289,11 +338,14 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vq;
 	}
 
+	blk_iopoll_init(&vblk->iopoll, 4 /* budget */, virtblk_iopoll);
+	blk_iopoll_enable(&vblk->iopoll);
+
 	/* FIXME: How many partitions?  How long is a piece of string? */
 	vblk->disk = alloc_disk(1 << PART_BITS);
 	if (!vblk->disk) {
 		err = -ENOMEM;
-		goto out_mempool;
+		goto out_iopoll;
 	}
 
 	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
@@ -401,13 +453,13 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	if (!err && opt_io_size)
 		blk_queue_io_opt(q, blk_size * opt_io_size);
 
-
 	add_disk(vblk->disk);
 	return 0;
 
 out_put_disk:
 	put_disk(vblk->disk);
-out_mempool:
+out_iopoll:
+	blk_iopoll_disable(&vblk->iopoll);
 	mempool_destroy(vblk->pool);
 out_free_vq:
 	vdev->config->del_vqs(vdev);
@@ -430,6 +482,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	del_gendisk(vblk->disk);
 	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);
+	blk_iopoll_disable(&vblk->iopoll);
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk);
-- 
1.7.1

