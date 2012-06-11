Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2FKLMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:12:42 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38945 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2FKLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:12:41 -0400
Date: Mon, 11 Jun 2012 12:11:53 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yehuda Sadeh <yehuda@hq.newdream.net>,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: Race condition during hotplug when dropping block queue lock
Message-ID: <20120611111153.GA1854@stefanha-thinkpad.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12061111-1948-0000-0000-0000020DC776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block drivers like nbd and rbd unlock struct request_queue->queue_lock in their
request_fn.  I'd like to do the same in virtio_blk.  After happily posting the
patch, Michael Tsirkin pointed out an issue that I can't explain.  This may
affect existing block drivers that unlock the queue_lock too.

What happens when the block device is removed (hot unplug or kernel module
unloaded) while a thread is in request_fn and queue_lock is not held?  If the
in-flight request is held in a driver-specific datastructure then the remove
operation can wait until all in-flight requests complete.

But here is the tricky case: what if the request actually completes during the
period where queue_lock is unlocked?  In this case we execute queue_lock
unlocked code while there are no requests in-flight.  It seems that the block
device could be removed during this window of time.  When we get around to
locking queue_lock again to return from the request_fn the queue no longer
exists.

What protects against this case?  I don't see significant protection in nbd/rbd
to prevent this so maybe there is a generic mechanism that I'm unaware of?

Here is the small patch to unlock virtio_blk during the guest->host notify
operation (which occasionally could take a long time so we don't want to keep
holding the queue_lock).  Imagine that the request completes just after
virtqueue_notify() and this virtio_blk device is being hot unplugged.  If hot
unplug completes before reacquiring the queue_lock and leaving this function
the result is a use-after-free of queue_lock.

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 774c31d..d674977 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -199,8 +199,14 @@ static void do_virtblk_request(struct request_queue *q)
               issued++;
       }

-       if (issued)
-               virtqueue_kick(vblk->vq);
+       if (!issued)
+               return;
+
+       if (virtqueue_kick_prepare(vblk->vq)) {
+               spin_unlock_irq(vblk->disk->queue->queue_lock);
+               virtqueue_notify(vblk->vq);
+               spin_lock_irq(vblk->disk->queue->queue_lock);
+       }
 }

 /* return id (s/n) string for *disk to *id_str

Stefan

