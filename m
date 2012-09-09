Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2IIXdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51178 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831Ab2IIXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:09 -0400
Message-Id: <20120909224202.366987058@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Asias He <asias@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 86/95] virtio-blk: Fix hot-unplug race in remove method
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

commit b79d866c8b7014a51f611a64c40546109beaf24a upstream.

If we reset the virtio-blk device before the requests already dispatched
to the virtio-blk driver from the block layer are finised, we will stuck
in blk_cleanup_queue() and the remove will fail.

blk_cleanup_queue() calls blk_drain_queue() to drain all requests queued
before DEAD marking. However it will never success if the device is
already stopped. We'll have q->in_flight[] > 0, so the drain will not
finish.

How to reproduce the race:
1. hot-plug a virtio-blk device
2. keep reading/writing the device in guest
3. hot-unplug while the device is busy serving I/O

Test:
~1000 rounds of hot-plug/hot-unplug test passed with this patch.

Changes in v3:
- Drop blk_abort_queue and blk_abort_request
- Use __blk_end_request_all to complete request dispatched to driver

Changes in v2:
- Drop req_in_flight
- Use virtqueue_detach_unused_buf to get request dispatched to driver

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0d39f2f..9d2223b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -583,6 +583,8 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int index = vblk->index;
+	struct virtblk_req *vbr;
+	unsigned long flags;
 
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vblk->config_lock);
@@ -598,6 +600,15 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	flush_work(&vblk->config_work);
 
 	del_gendisk(vblk->disk);
+
+	/* Abort requests dispatched to driver. */
+	spin_lock_irqsave(&vblk->lock, flags);
+	while ((vbr = virtqueue_detach_unused_buf(vblk->vq))) {
+		__blk_end_request_all(vbr->req, -EIO);
+		mempool_free(vbr, vblk->pool);
+	}
+	spin_unlock_irqrestore(&vblk->lock, flags);
+
 	blk_cleanup_queue(vblk->disk->queue);
 	put_disk(vblk->disk);
 	mempool_destroy(vblk->pool);


