Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2BNSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:16:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2BNSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:16:28 -0500
Date: Tue, 14 Feb 2012 10:16:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH block/for-linus 2/3] block: simplify ioc_release_fn()
Message-ID: <20120214181623.GT12117@google.com>
References: <20120214181245.GS12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214181245.GS12117@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverse double lock dancing in ioc_release_fn() can be simplified by
just using trylock on the queue_lock and back out from ioc lock on
trylock failure.  Simplify it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-ioc.c |   44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -79,7 +79,6 @@ static void ioc_release_fn(struct work_s
 {
 	struct io_context *ioc = container_of(work, struct io_context,
 					      release_work);
-	struct request_queue *last_q = NULL;
 	unsigned long flags;
 
 	/*
@@ -93,44 +92,19 @@ static void ioc_release_fn(struct work_s
 	while (!hlist_empty(&ioc->icq_list)) {
 		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
 						struct io_cq, ioc_node);
-		struct request_queue *this_q = icq->q;
+		struct request_queue *q = icq->q;
 
-		if (this_q != last_q) {
-			/*
-			 * Need to switch to @this_q.  Once we release
-			 * @ioc->lock, it can go away along with @cic.
-			 * Hold on to it.
-			 */
-			__blk_get_queue(this_q);
-
-			/*
-			 * blk_put_queue() might sleep thanks to kobject
-			 * idiocy.  Always release both locks, put and
-			 * restart.
-			 */
-			if (last_q) {
-				spin_unlock(last_q->queue_lock);
-				spin_unlock_irqrestore(&ioc->lock, flags);
-				blk_put_queue(last_q);
-			} else {
-				spin_unlock_irqrestore(&ioc->lock, flags);
-			}
-
-			last_q = this_q;
-			spin_lock_irqsave(this_q->queue_lock, flags);
-			spin_lock_nested(&ioc->lock, 1);
-			continue;
+		if (spin_trylock(q->queue_lock)) {
+			ioc_exit_icq(icq);
+			spin_unlock(q->queue_lock);
+		} else {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			cpu_relax();
+			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 		}
-		ioc_exit_icq(icq);
 	}
 
-	if (last_q) {
-		spin_unlock(last_q->queue_lock);
-		spin_unlock_irqrestore(&ioc->lock, flags);
-		blk_put_queue(last_q);
-	} else {
-		spin_unlock_irqrestore(&ioc->lock, flags);
-	}
+	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	kmem_cache_free(iocontext_cachep, ioc);
 }
