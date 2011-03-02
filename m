Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1CBRuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:50:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:59225 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab1CBRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:23 -0500
Message-Id: <20110302174120.679612103@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/22] sched: Provide p->on_rq
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-onrq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a generic p->on_rq because the p->se.on_rq semantics are
unfavourable for lockless wakeups but needed for sched_fair.

In particular, p->on_rq is only cleared when we actually dequeue the
task in schedule() and not on any random dequeue as done by things
like __migrate_task() and __sched_setscheduler().

This also allows us to remove p->se usage from !sched_fair code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   36 ++++++++++++++++++------------------
 kernel/sched_debug.c    |    2 +-
 kernel/sched_rt.c       |   16 ++++++++--------
 kernel/sched_stoptask.c |    2 +-
 5 files changed, 29 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1201,6 +1201,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	int on_cpu;
 #endif
+	int on_rq;
 
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1790,7 +1790,6 @@ static void enqueue_task(struct rq *rq, 
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->se.on_rq = 1;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1798,7 +1797,6 @@ static void dequeue_task(struct rq *rq, 
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->se.on_rq = 0;
 }
 
 /*
@@ -1811,6 +1809,7 @@ static void activate_task(struct rq *rq,
 
 	enqueue_task(rq, p, flags);
 	inc_nr_running(rq);
+	p->on_rq = 1;
 }
 
 /*
@@ -2133,7 +2132,7 @@ static void check_preempt_curr(struct rq
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -2208,7 +2207,7 @@ static bool migrate_task(struct task_str
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->se.on_rq || task_running(rq, p);
+	return p->on_rq || task_running(rq, p);
 }
 
 /*
@@ -2268,7 +2267,7 @@ unsigned long wait_task_inactive(struct 
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->se.on_rq;
+		on_rq = p->on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -2499,7 +2498,7 @@ static int try_to_wake_up(struct task_st
 
 	cpu = task_cpu(p);
 
-	if (p->se.on_rq)
+	if (p->on_rq)
 		goto out_running;
 
 	orig_cpu = cpu;
@@ -2576,7 +2575,7 @@ static void try_to_wake_up_local(struct 
 	if (!(p->state & TASK_NORMAL))
 		return;
 
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
@@ -2613,19 +2612,21 @@ int wake_up_state(struct task_struct *p,
  */
 static void __sched_fork(struct task_struct *p)
 {
+	p->on_rq			= 0;
+
+	p->se.on_rq			= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
-	p->se.on_rq = 0;
-	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -4044,7 +4045,7 @@ static inline void schedule_debug(struct
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->se.on_rq)
+	if (prev->on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4123,6 +4124,7 @@ asmlinkage void __sched schedule(void)
 					try_to_wake_up_local(to_wakeup);
 			}
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+			prev->on_rq = 0;
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -4683,7 +4685,7 @@ void rt_mutex_setprio(struct task_struct
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4731,7 +4733,7 @@ void set_user_nice(struct task_struct *p
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 
@@ -4865,8 +4867,6 @@ static struct task_struct *find_process_
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->se.on_rq);
-
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
@@ -5015,7 +5015,7 @@ static int __sched_setscheduler(struct t
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5925,7 +5925,7 @@ static int __migrate_task(struct task_st
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->se.on_rq) {
+	if (p->on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -8296,7 +8296,7 @@ static void normalize_task(struct rq *rq
 	int old_prio = p->prio;
 	int on_rq;
 
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8642,7 +8642,7 @@ void sched_move_task(struct task_struct 
 	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
-	on_rq = tsk->se.on_rq;
+	on_rq = tsk->on_rq;
 
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -152,7 +152,7 @@ static void print_rq(struct seq_file *m,
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
+		if (!p->on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1132,7 +1132,7 @@ static void put_prev_task_rt(struct rq *
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1283,7 +1283,7 @@ static struct rq *find_lock_lowest_rq(st
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->se.on_rq)) {
+				     !task->on_rq)) {
 
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -1317,7 +1317,7 @@ static struct task_struct *pick_next_pus
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->rt.nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->se.on_rq);
+	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1463,7 +1463,7 @@ static int pull_rt_task(struct rq *this_
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->se.on_rq);
+			WARN_ON(!p->on_rq);
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1534,7 +1534,7 @@ static void set_cpus_allowed_rt(struct t
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
+	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
 		if (!task_current(rq, p)) {
@@ -1604,7 +1604,7 @@ static void switched_from_rt(struct rq *
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->se.on_rq && !rq->rt.rt_nr_running)
+	if (p->on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1634,7 +1634,7 @@ static void switched_to_rt(struct rq *rq
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->se.on_rq && rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1653,7 +1653,7 @@ static void switched_to_rt(struct rq *rq
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		return;
 
 	if (rq->curr == p) {
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -26,7 +26,7 @@ static struct task_struct *pick_next_tas
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->se.on_rq)
+	if (stop && stop->on_rq)
 		return stop;
 
 	return NULL;


