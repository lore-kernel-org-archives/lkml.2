Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1LTWSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:18:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:18:23 -0500
Date: Tue, 20 Dec 2011 14:18:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH for-3.3] mempool: clean up and document synchronization and
 memory barrier usage
Message-ID: <20111220221818.GJ10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempool_alloc/free() use undocumented smp_mb()'s.  While the code is
not necessarily incorrect, the usage is not minimal and misleading.

The lockless part is in mempool_free().  It wants to determine whether
the item being freed needs to be returned to the pool or backing
allocator without grabbing pool->lock.  Two things need to be
guaranteed for correct operation.

1. pool->curr_nr + #allocated should never dip below pool->min_nr.
2. Waiters shouldn't be left dangling.

For #1, The only necessary condition is that curr_nr visible at free
is from after the allocation of the element being freed (details in
the comment).  For most cases, this is true without any barrier but
there can be fringe cases where the allocated pointer is passed to the
freeing task without going through memory barriers.  To cover this
case, wmb is necessary before returning from allocation and rmb is
necessary before reading curr_nr.  IOW,

	ALLOCATING TASK			FREEING TASK

	update pool state after alloc;
	wmb();
	pass pointer to freeing task;
					read pointer;
					rmb();
					read pool state to free;

The wmb can be the implied one from unlocking pool->lock and smp_mb()
in mempool_free() can be replaced with smp_rmb().

For #2, the waiter needs to add itself to waitqueue and then check the
wait condition and the waker needs to update the wait condition and
then wake up.  Because waitqueue operations always go through full
spinlock synchronization, there is no need for extra memory barriers.

Furthermore, mempool_alloc() is already holding pool->lock when it
decides that it needs to wait.  There is no reason to do unlock - add
waitqueue - test condition again.  It can simply add itself to
waitqueue while holding pool->lock and then unlock and sleep.

This patch converts smp_mb() in mempool_free() with smp_rmb(), drops
superflous smp_mb() from mempool_alloc() and extend pool->lock over
waitqueue addition.  More importantly, it explains what memory
barriers do and how the lockless testing is correct.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
I was trying to make mempool useable for percpu and the undocumented
smp_mb()'s confused me.  I tried to chop it down to the minimum and
explain what's going on.  The previous code wasn't incorrect so this
isn't a fix per-se but it's always good to be explicit about barriers
and lockless tricks.

There probably is better way to word why the lockless testing is
correct.  It's a lot clearer ot me when drawn as stepping graph on a
piece of paper.  If somebody can think of better wording, please don't
be shy.

Oleg, I *think* this is correct but it would be great if you can go
over it.

Thank you.

 mm/mempool.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 13 deletions(-)

Index: work/mm/mempool.c
===================================================================
--- work.orig/mm/mempool.c
+++ work/mm/mempool.c
@@ -223,29 +223,31 @@ repeat_alloc:
 	spin_lock_irqsave(&pool->lock, flags);
 	if (likely(pool->curr_nr)) {
 		element = remove_element(pool);
+		/* implied wmb in unlock is faired with rmb in mempool_free() */
 		spin_unlock_irqrestore(&pool->lock, flags);
 		return element;
 	}
-	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* We must not sleep in the GFP_ATOMIC case */
-	if (!(gfp_mask & __GFP_WAIT))
+	if (!(gfp_mask & __GFP_WAIT)) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		return NULL;
+	}
 
-	/* Now start performing page reclaim */
+	/* Let's wait for someone else to return an element to @pool */
 	gfp_temp = gfp_mask;
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
-	smp_mb();
-	if (!pool->curr_nr) {
-		/*
-		 * FIXME: this should be io_schedule().  The timeout is there
-		 * as a workaround for some DM problems in 2.6.18.
-		 */
-		io_schedule_timeout(5*HZ);
-	}
-	finish_wait(&pool->wait, &wait);
 
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	/*
+	 * FIXME: this should be io_schedule().  The timeout is there as a
+	 * workaround for some DM problems in 2.6.18.
+	 */
+	io_schedule_timeout(5*HZ);
+
+	finish_wait(&pool->wait, &wait);
 	goto repeat_alloc;
 }
 EXPORT_SYMBOL(mempool_alloc);
@@ -265,7 +267,39 @@ void mempool_free(void *element, mempool
 	if (unlikely(element == NULL))
 		return;
 
-	smp_mb();
+	/*
+	 * Paired with implied wmb of @pool->lock in mempool_alloc().  The
+	 * preceding read is for @element and the following @pool->curr_nr.
+	 * This ensures that the visible value of @pool->curr_nr is from
+	 * after the allocation of @element.  This is necessary for fringe
+	 * cases where @element was passed to this task without going
+	 * through barriers.
+	 *
+	 * For example, assume @p is %NULL at the beginning and one task
+	 * performs "p = mempool_alloc(...);" while another task is doing
+	 * "while (!p) cpu_relax(); mempool_free(p, ...);".  This function
+	 * may end up using curr_nr value which is from before allocation
+	 * of @p without the following rmb.
+	 */
+	smp_rmb();
+
+	/*
+	 * For correctness, we need a test which is guaranteed to trigger
+	 * if curr_nr + #allocated == min_nr.  Testing curr_nr < min_nr
+	 * without locking achieves that and refilling as soon as possible
+	 * is desirable.
+	 *
+	 * Because curr_nr visible here is always a value after the
+	 * allocation of @element, any task which decremented curr_nr below
+	 * min_nr is guaranteed to see curr_nr < min_nr unless curr_nr gets
+	 * incremented to min_nr afterwards.  If curr_nr gets incremented
+	 * to min_nr after the allocation of @element, the elements
+	 * allocated after that are subject to the same guarantee.
+	 *
+	 * Waiters happen iff curr_nr is 0 and the above guarantee also
+	 * ensures that there will be frees which return elements to the
+	 * pool waking up the waiters.
+	 */
 	if (pool->curr_nr < pool->min_nr) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (pool->curr_nr < pool->min_nr) {
