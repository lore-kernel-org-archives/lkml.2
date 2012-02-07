Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab2BGXAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:00:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab2BGXAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:00:16 -0500
Date: Tue, 7 Feb 2012 15:00:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: [PATCH] block: fix lockdep warning on io_context release
 put_io_context()
Message-ID: <20120207230011.GJ21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30C96F.1000905@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11a3122f6c "block: strip out locking optimization in put_io_context()"
removed ioc_lock depth lockdep annoation along with locking
optimization; however, while recursing from put_io_context() is no
longer possible, ioc_release_fn() may still end up putting the last
reference of another ioc through elevator, which wlil grab ioc->lock
triggering spurious (as the ioc is always different one) A-A deadlock
warning.

As this can only happen one time from ioc_release_fn(), using non-zero
subclass from ioc_release_fn() is enough.  Use subclass 1.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Jens, this one should go with the previous patch to avoid triggering
spurious lockdep warning.

Thanks.

 block/blk-ioc.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -80,8 +80,15 @@ static void ioc_release_fn(struct work_s
 	struct io_context *ioc = container_of(work, struct io_context,
 					      release_work);
 	struct request_queue *last_q = NULL;
+	unsigned long flags;
 
-	spin_lock_irq(&ioc->lock);
+	/*
+	 * Exiting icq may call into put_io_context() through elevator
+	 * which will trigger lockdep warning.  The ioc's are guaranteed to
+	 * be different, use a different locking subclass here.  Use
+	 * irqsave variant as there's no spin_lock_irq_nested().
+	 */
+	spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 
 	while (!hlist_empty(&ioc->icq_list)) {
 		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
@@ -103,15 +110,15 @@ static void ioc_release_fn(struct work_s
 			 */
 			if (last_q) {
 				spin_unlock(last_q->queue_lock);
-				spin_unlock_irq(&ioc->lock);
+				spin_unlock_irqrestore(&ioc->lock, flags);
 				blk_put_queue(last_q);
 			} else {
-				spin_unlock_irq(&ioc->lock);
+				spin_unlock_irqrestore(&ioc->lock, flags);
 			}
 
 			last_q = this_q;
-			spin_lock_irq(this_q->queue_lock);
-			spin_lock(&ioc->lock);
+			spin_lock_irqsave(this_q->queue_lock, flags);
+			spin_lock_nested(&ioc->lock, 1);
 			continue;
 		}
 		ioc_exit_icq(icq);
@@ -119,10 +126,10 @@ static void ioc_release_fn(struct work_s
 
 	if (last_q) {
 		spin_unlock(last_q->queue_lock);
-		spin_unlock_irq(&ioc->lock);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 		blk_put_queue(last_q);
 	} else {
-		spin_unlock_irq(&ioc->lock);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 	}
 
 	kmem_cache_free(iocontext_cachep, ioc);
