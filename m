Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1FSHsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 03:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1FSHsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 03:48:45 -0400
Date: Sun, 19 Jun 2011 10:48:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [RFC] virtio: Support releasing lock during kick
Message-ID: <20110619074841.GA8613@redhat.com>
References: <1277328242-10685-1-git-send-email-stefanha@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277328242-10685-1-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:24:02PM +0100, Stefan Hajnoczi wrote:
> The virtio block device holds a lock during I/O request processing.
> Kicking the virtqueue while the lock is held results in long lock hold
> times and increases contention for the lock.

As you point out the problem with dropping
and getting this lock in the request function is
that we double the number of atomics here.

How about we teach the block core to call a separate
function with spinlock not held? This way we don't need
to do extra lock/unlock operations, and kick can be
done with lock not held and interrupts enabled.


diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..a8672ec 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -433,6 +433,8 @@ void blk_run_queue(struct request_queue *q)
 	spin_lock_irqsave(q->queue_lock, flags);
 	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q->request_done)
+		q->request_done(q);
 }
 EXPORT_SYMBOL(blk_run_queue);
 

-- 
MST
