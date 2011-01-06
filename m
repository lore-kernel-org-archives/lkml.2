Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1AFAe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:34:26 -0500
Received: from kroah.org ([198.145.64.141]:36133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1AFAbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:53 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.204493005@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [144/152] Sched: fix skip_clock_update optimization
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -272,6 +272,7 @@ static struct task_struct *dup_task_stru
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -566,7 +566,7 @@ void check_preempt_curr(struct rq *rq, s
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(p))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -3821,7 +3821,6 @@ static void put_prev_task(struct rq *rq,
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3883,7 +3882,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	clear_tsk_need_resched(prev);
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -3915,6 +3913,8 @@ need_resched_nonpreemptible:
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
+	clear_tsk_need_resched(prev);
+	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);


