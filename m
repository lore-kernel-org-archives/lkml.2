Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2HMUrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:47:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2HMUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Asias He <asias@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [ 02/82] virtio-blk: Reset device after blk_cleanup_queue()
Date: Mon, 13 Aug 2012 13:18:38 -0700
Message-Id: <20120813201746.665355912@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Asias He <asias@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -576,8 +576,6 @@ static void __devexit virtblk_remove(str
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
-	struct virtblk_req *vbr;
-	unsigned long flags;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -585,21 +583,13 @@ static void __devexit virtblk_remove(str
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


