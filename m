Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2IIXdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51167 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab2IIXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:08 -0400
Message-Id: <20120909224202.631342741@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Asias He <asias@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 88/95] virtio-blk: Reset device after blk_cleanup_queue()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 483001c765af6892b3fc3726576cb42f17d1d6b5 upstream.

blk_cleanup_queue() will call blk_drian_queue() to drain all the
requests before queue DEAD marking. If we reset the device before
blk_cleanup_queue() the drain would fail.

1) if the queue is stopped in do_virtblk_request() because device is
full, the q->request_fn() will not be called.

blk_drain_queue() {
   while(true) {
      ...
      if (!list_empty(&q->queue_head))
        __blk_run_queue(q) {
	    if (queue is not stoped)
		q->request_fn()
	}
      ...
   }
}

Do no reset the device before blk_cleanup_queue() gives the chance to
start the queue in interrupt handler blk_done().

2) In commit b79d866c8b7014a51f611a64c40546109beaf24a, We abort requests
dispatched to driver before blk_cleanup_queue(). There is a race if
requests are dispatched to driver after the abort and before the queue
DEAD mark. To fix this, instead of aborting the requests explicitly, we
can just reset the device after after blk_cleanup_queue so that the
device can complete all the requests before queue DEAD marking in the
drain process.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Asias He <asias@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1bed517..b4fa2d7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -576,8 +576,6 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
-	struct virtblk_req *vbr;
-	unsigned long flags;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -585,21 +583,13 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	mutex_unlock(&vblk->config_lock);
 
 	del_gendisk(vblk->disk);
+	blk_cleanup_queue(vblk->disk->queue);
 
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
 	flush_work(&vblk->config_work);
 
-	/* Abort requests dispatched to driver. */
-	spin_lock_irqsave(&vblk->lock, flags);
-	while ((vbr = virtqueue_detach_unused_buf(vblk->vq))) {
-		__blk_end_request_all(vbr->req, -EIO);
-		mempool_free(vbr, vblk->pool);
-	}
-	spin_unlock_irqrestore(&vblk->lock, flags);
-
-	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);


