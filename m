Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1LUBCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:02:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44470 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1LUBBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:34 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>, Minchan Kim <minchan@redhat.com>
Subject: [PATCH 6/6] virtio-blk: Emulate Flush/FUA
Date: Wed, 21 Dec 2011 10:00:54 +0900
Message-Id: <1324429254-28383-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch emulates flush/fua on virtio-blk and pass xfstest on ext4.
But it needs more reviews.

Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 drivers/block/virtio_blk.c |   89 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e32c69e..6721b9d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -12,7 +12,6 @@
 #include <linux/idr.h>
 
 #define PART_BITS 4
-static int use_make_request = 1;
 
 static int major;
 static DEFINE_IDA(vd_index_ida);
@@ -77,6 +76,7 @@ struct virtblk_req
 	u8 kind;
 #define VIRTIO_BLK_REQUEST	0x00
 #define VIRTIO_BLK_BIO		0x01
+#define VIRTIO_BLK_BIO_FLUSH	0x02
 	u8 status;
 
 	struct scatterlist sg[];
@@ -160,6 +160,9 @@ static void blk_done(struct virtqueue *vq)
 			 */
         		blk_start_queue(vblk->disk->queue);
 			break;
+		case VIRTIO_BLK_BIO_FLUSH:
+			complete(vbr->private);
+			break;
 		case VIRTIO_BLK_BIO:
 			if (head) {
 				tail->next = vbr;
@@ -526,6 +529,59 @@ static void virtblk_add_buf_wait(struct virtio_blk *vblk,
         finish_wait(&vblk->queue_wait, &wait);
 }
 
+static int virtblk_flush(struct virtio_blk *vblk,
+			struct virtblk_req *vbr, struct bio *bio)
+{
+	int error;
+	bool retry, notify;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	vbr->private = &done;
+	vbr->next = NULL;
+	vbr->kind = VIRTIO_BLK_BIO_FLUSH;
+
+	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+	vbr->out_hdr.sector = 0;
+	if (bio)
+		vbr->out_hdr.ioprio = bio_prio(bio);
+	else
+		vbr->out_hdr.ioprio = 0;
+
+	sg_set_buf(&vbr->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_set_buf(&vbr->sg[1], &vbr->status, sizeof(vbr->status));
+
+	spin_lock_irq(&vblk->lock);
+	if (virtqueue_add_buf(vblk->vq, vbr->sg, 1, 1, vbr) < 0) {
+		retry = true;
+	} else {
+		retry = false;
+	}
+
+	notify = virtqueue_kick_prepare(vblk->vq);
+	spin_unlock_irq(&vblk->lock);
+
+	if (notify && !virtblk_plugged(vblk))
+		virtqueue_notify(vblk->vq);
+
+	if (retry)
+		virtblk_add_buf_wait(vblk, vbr, 1, 1);
+
+	wait_for_completion(&done);
+	error = virtblk_result(vbr);
+	return error;
+}
+
+void bq_flush(struct bio_queue *bq)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_bio __percpu *pcbio = per_cpu_ptr(bq->pcbio, cpu);
+		queue_work_on(cpu,
+			virtblk_wq, &pcbio->dwork.work);
+		flush_work_sync(&pcbio->dwork.work);
+	}
+}
+
 bool full_segment(struct per_cpu_bio __percpu *pcbio, struct bio *bio,
 		unsigned int max)
 {
@@ -616,9 +672,36 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct virtio_blk *vblk = q->queuedata;
 	struct per_cpu_bio __percpu *pcbio;
+	bool pre_flush, post_flush;
 
 	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
-	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+
+	pre_flush = bio->bi_rw & REQ_FLUSH;
+	post_flush = bio->bi_rw & REQ_FUA;
+
+	if (pre_flush) {
+		struct virtblk_req *dummy_vbr;
+		bq_flush(&vblk->bq);
+
+		dummy_vbr = alloc_virtblk_req(vblk, GFP_NOIO);
+		virtblk_flush(vblk, dummy_vbr, NULL);
+		mempool_free(dummy_vbr, vblk->pool);
+
+		if (bio->bi_sector && post_flush) {
+			int error;
+			struct virtblk_req *vbr;
+			vbr = alloc_virtblk_req(vblk, GFP_NOIO);
+			error = virtblk_flush(vblk, vbr, bio);
+			mempool_free(vbr, vblk->pool);
+
+			dummy_vbr = alloc_virtblk_req(vblk, GFP_NOIO);
+			virtblk_flush(vblk, dummy_vbr, NULL);
+			mempool_free(dummy_vbr, vblk->pool);
+
+			bio_endio(bio, error);
+			return;
+		}
+	}
 retry:
 	preempt_disable();
 	pcbio = this_cpu_ptr(vblk->bq.pcbio);
@@ -918,7 +1001,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->index = index;
 
 	/* configure queue flush support */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH) && !use_make_request)
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
 		blk_queue_flush(q, REQ_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
-- 
1.7.6.4

