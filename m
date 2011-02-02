Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1BBApW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:43069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1BBApT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505376"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: efault@gmx.de, ak@linux.intel.com, yong.zhang0@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [130/139] Sched: fix skip_clock_update optimization
Message-Id: <20110202004529.C77683E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mike Galbraith <efault@gmx.de>

commit f26f9aff6aaf67e9a430d16c266f91b13a5bff64 upstream.

idle_balance() drops/retakes rq->lock, leaving the previous task
vulnerable to set_tsk_need_resched().  Clear it after we return
from balancing instead, and in setup_thread_stack() as well, so
no successfully descheduled or never scheduled task has it set.

Need resched confused the skip_clock_update logic, which assumes
that the next call to update_rq_clock() will come nearly immediately
after being set.  Make the optimization robust against the waking
a sleeper before it sucessfully deschedules case by checking that
the current task has not been dequeued before setting the flag,
since it is that useless clock update we're trying to save, and
clear unconditionally in schedule() proper instead of conditionally
in put_prev_task().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291802742.1417.9.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c  |    1 +
 kernel/sched.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/kernel/fork.c
===================================================================
--- linux-2.6.35.y.orig/kernel/fork.c
+++ linux-2.6.35.y/kernel/fork.c
@@ -272,6 +272,7 @@ static struct task_struct *dup_task_stru
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c
+++ linux-2.6.35.y/kernel/sched.c
@@ -564,7 +564,7 @@ void check_preempt_curr(struct rq *rq, s
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(p))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -3657,7 +3657,6 @@ static void put_prev_task(struct rq *rq,
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3720,7 +3719,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
@@ -3737,6 +3735,8 @@ need_resched_nonpreemptible:
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
+	clear_tsk_need_resched(prev);
+	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
