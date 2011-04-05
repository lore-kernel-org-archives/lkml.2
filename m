Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1DEPgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:36:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:60419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1DEPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:30 -0400
Message-Id: <20110405152728.949545047@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/21] sched: Provide p->on_rq
References: <20110405152338.692966333@chello.nl>
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
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   37 +++++++++++++++++++------------------
 kernel/sched_debug.c    |    2 +-
 kernel/sched_rt.c       |   16 ++++++++--------
 kernel/sched_stoptask.c |    2 +-
 5 files changed, 30 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1208,6 +1208,7 @@ struct task_struct {
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
@@ -1788,7 +1788,6 @@ static void enqueue_task(struct rq *rq, 
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->se.on_rq = 1;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1796,7 +1795,6 @@ static void dequeue_task(struct rq *rq, 
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->se.on_rq = 0;
 }
 
 /*
@@ -2131,7 +2129,7 @@ static void check_preempt_curr(struct rq
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -2206,7 +2204,7 @@ static bool migrate_task(struct task_str
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->se.on_rq || task_running(rq, p);
+	return p->on_rq || task_running(rq, p);
 }
 
 /*
@@ -2266,7 +2264,7 @@ unsigned long wait_task_inactive(struct 
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->se.on_rq;
+		on_rq = p->on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -2502,7 +2500,7 @@ static int try_to_wake_up(struct task_st
 
 	cpu = task_cpu(p);
 
-	if (p->se.on_rq)
+	if (p->on_rq)
 		goto out_running;
 
 	orig_cpu = cpu;
@@ -2549,6 +2547,7 @@ static int try_to_wake_up(struct task_st
 out_activate:
 #endif /* CONFIG_SMP */
 	activate_task(rq, p, en_flags);
+	p->on_rq = 1;
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
 	ttwu_stat(rq, p, cpu, wake_flags);
@@ -2579,7 +2578,7 @@ static void try_to_wake_up_local(struct 
 	if (!(p->state & TASK_NORMAL))
 		return;
 
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
@@ -2616,19 +2615,21 @@ int wake_up_state(struct task_struct *p,
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
@@ -2746,6 +2747,7 @@ void wake_up_new_task(struct task_struct
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
+	p->on_rq = 1;
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -4047,7 +4049,7 @@ static inline void schedule_debug(struct
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->se.on_rq)
+	if (prev->on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4126,6 +4128,7 @@ asmlinkage void __sched schedule(void)
 					try_to_wake_up_local(to_wakeup);
 			}
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+			prev->on_rq = 0;
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -4687,7 +4690,7 @@ void rt_mutex_setprio(struct task_struct
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4735,7 +4738,7 @@ void set_user_nice(struct task_struct *p
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 
@@ -4869,8 +4872,6 @@ static struct task_struct *find_process_
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->se.on_rq);
-
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
@@ -5022,7 +5023,7 @@ static int __sched_setscheduler(struct t
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5939,7 +5940,7 @@ static int __migrate_task(struct task_st
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->se.on_rq) {
+	if (p->on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -7930,7 +7931,7 @@ static void normalize_task(struct rq *rq
 	int old_prio = p->prio;
 	int on_rq;
 
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8276,7 +8277,7 @@ void sched_move_task(struct task_struct 
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
@@ -1136,7 +1136,7 @@ static void put_prev_task_rt(struct rq *
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1287,7 +1287,7 @@ static struct rq *find_lock_lowest_rq(st
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->se.on_rq)) {
+				     !task->on_rq)) {
 
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -1321,7 +1321,7 @@ static struct task_struct *pick_next_pus
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->rt.nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->se.on_rq);
+	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1467,7 +1467,7 @@ static int pull_rt_task(struct rq *this_
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->se.on_rq);
+			WARN_ON(!p->on_rq);
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1538,7 +1538,7 @@ static void set_cpus_allowed_rt(struct t
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
+	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
 		if (!task_current(rq, p)) {
@@ -1608,7 +1608,7 @@ static void switched_from_rt(struct rq *
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->se.on_rq && !rq->rt.rt_nr_running)
+	if (p->on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1638,7 +1638,7 @@ static void switched_to_rt(struct rq *rq
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->se.on_rq && rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1657,7 +1657,7 @@ static void switched_to_rt(struct rq *rq
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


