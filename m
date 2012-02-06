Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2BFUgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:36:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2BFUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:36:09 -0500
Date: Mon, 6 Feb 2012 12:36:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120206203604.GC21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206172706.GB21292@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 09:27:06AM -0800, Tejun Heo wrote:
> It's one wq scheduling on exit for any task which has issued an IO.  I
> don't think it would matter except for task fork/exit microbenchs (or
> workloads which approximate to that).  I'll get some measurements and
> strip the optimization if it doesn't really show up.

I'm still playing with test methods and getting numbers but the
following is the simplified one of the three setups I'm playing with -
the current one, simplified and no optimization.  There *seems* to be
appreciable performance degradation on fork/exit w/ ioc microbenchs so
I'm likely to go with the following.  I'll post when I know more.

Thanks.
---
 block/blk-ioc.c |   50 +++++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -158,7 +158,6 @@ static void ioc_release_fn(struct work_s
  */
 void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
 {
-	struct request_queue *last_q = locked_q;
 	unsigned long flags;
 
 	if (ioc == NULL)
@@ -171,50 +170,27 @@ void put_io_context(struct io_context *i
 	if (!atomic_long_dec_and_test(&ioc->refcount))
 		return;
 
-	/*
-	 * Destroy @ioc.  This is a bit messy because icq's are chained
-	 * from both ioc and queue, and ioc->lock nests inside queue_lock.
-	 * The inner ioc->lock should be held to walk our icq_list and then
-	 * for each icq the outer matching queue_lock should be grabbed.
-	 * ie. We need to do reverse-order double lock dancing.
-	 *
-	 * Another twist is that we are often called with one of the
-	 * matching queue_locks held as indicated by @locked_q, which
-	 * prevents performing double-lock dance for other queues.
-	 *
-	 * So, we do it in two stages.  The fast path uses the queue_lock
-	 * the caller is holding and, if other queues need to be accessed,
-	 * uses trylock to avoid introducing locking dependency.  This can
-	 * handle most cases, especially if @ioc was performing IO on only
-	 * single device.
-	 *
-	 * If trylock doesn't cut it, we defer to @ioc->release_work which
-	 * can do all the double-locking dancing.
-	 */
 	spin_lock_irqsave_nested(&ioc->lock, flags,
 				 ioc_release_depth(locked_q));
 
-	while (!hlist_empty(&ioc->icq_list)) {
+	/*
+	 * Due to locking order between queue_lock and ioc lock, proper icq
+	 * shoot down requires reverse double locking dance from another
+	 * context.  As there usually is no or one icq, try to handle those
+	 * cases synchronously.
+	 */
+	if (!hlist_empty(&ioc->icq_list)) {
 		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
 						struct io_cq, ioc_node);
-		struct request_queue *this_q = icq->q;
-
-		if (this_q != last_q) {
-			if (last_q && last_q != locked_q)
-				spin_unlock(last_q->queue_lock);
-			last_q = NULL;
-
-			if (!spin_trylock(this_q->queue_lock))
-				break;
-			last_q = this_q;
-			continue;
+		if (locked_q) {
+			if (locked_q == icq->q)
+				ioc_exit_icq(icq);
+		} else if (spin_trylock(icq->q->queue_lock)) {
+			ioc_exit_icq(icq);
+			spin_unlock(icq->q->queue_lock);
 		}
-		ioc_exit_icq(icq);
 	}
 
-	if (last_q && last_q != locked_q)
-		spin_unlock(last_q->queue_lock);
-
 	spin_unlock_irqrestore(&ioc->lock, flags);
 
 	/* if no icq is left, we're done; otherwise, kick release_work */
