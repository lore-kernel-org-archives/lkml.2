Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab2HGDnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:43:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59848 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964813Ab2HGDi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:56 -0400
Message-Id: <20120807032801.663389478@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 38/70] virtio-blk: Use block layer provided spinlock
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 2c95a3290919541b846bee3e0fbaa75860929f53 upstream.

Block layer will allocate a spinlock for the queue if the driver does
not provide one in blk_init_queue().

The reason to use the internal spinlock is that blk_cleanup_queue() will
switch to use the internal spinlock in the cleanup code path.

        if (q->queue_lock != &q->__queue_lock)
                q->queue_lock = &q->__queue_lock;

However, processes which are in D state might have taken the driver
provided spinlock, when the processes wake up, they would release the
block provided spinlock.

=====================================
[ BUG: bad unlock balance detected! ]
3.4.0-rc7+ #238 Not tainted
-------------------------------------
fio/3587 is trying to release lock (&(&q->__queue_lock)->rlock) at:
[<ffffffff813274d2>] blk_queue_bio+0x2a2/0x380
but there are no more locks to release!

other info that might help us debug this:
1 lock held by fio/3587:
 #0:  (&(&vblk->lock)->rlock){......}, at:
[<ffffffff8132661a>] get_request_wait+0x19a/0x250

Other drivers use block layer provided spinlock as well, e.g. SCSI.

Switching to the block layer provided spinlock saves a bit of memory and
does not increase lock contention. Performance test shows no real
difference is observed before and after this patch.

Changes in v2: Improve commit log as Michael suggested.

Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Asias He <asias@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/virtio_blk.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -20,8 +20,6 @@ struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
 {
-	spinlock_t lock;
-
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
 
@@ -62,7 +60,7 @@ static void blk_done(struct virtqueue *v
 	unsigned int len;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vblk->lock, flags);
+	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
 	while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 		int error;
 
@@ -97,7 +95,7 @@ static void blk_done(struct virtqueue *v
 	}
 	/* In case queue is stopped waiting for more buffers. */
 	blk_start_queue(vblk->disk->queue);
-	spin_unlock_irqrestore(&vblk->lock, flags);
+	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
 }
 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
@@ -384,7 +382,6 @@ static int __devinit virtblk_probe(struc
 	}
 
 	INIT_LIST_HEAD(&vblk->reqs);
-	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
@@ -410,7 +407,7 @@ static int __devinit virtblk_probe(struc
 		goto out_mempool;
 	}
 
-	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
+	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, NULL);
 	if (!q) {
 		err = -ENOMEM;
 		goto out_put_disk;


