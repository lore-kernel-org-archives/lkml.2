Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1DEPeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:34:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1DEPbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:33 -0400
Message-Id: <20110405152729.031077745@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/21] sched: Drop the rq argument to sched_class::select_task_rq()
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-select_task_rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of calling select_task_rq() without rq->lock held, drop
the dependency on the rq argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/linux/sched.h   |    3 +--
 kernel/sched.c          |   20 +++++++++++---------
 kernel/sched_fair.c     |    2 +-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |   38 ++++++++++++++++++++++++++------------
 kernel/sched_stoptask.c |    3 +--
 6 files changed, 41 insertions(+), 27 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1063,8 +1063,7 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
-			       int sd_flag, int flags);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2138,13 +2138,15 @@ static int migration_cpu_stop(void *data
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static bool migrate_task(struct task_struct *p, struct rq *rq)
+static bool need_migrate_task(struct task_struct *p)
 {
 	/*
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->on_rq || task_running(rq, p);
+	bool running = p->on_rq || p->on_cpu;
+	smp_rmb(); /* finish_lock_switch() */
+	return running;
 }
 
 /*
@@ -2337,9 +2339,9 @@ static int select_fallback_rq(int cpu, s
  * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2484,7 +2486,7 @@ static int try_to_wake_up(struct task_st
 		en_flags |= ENQUEUE_WAKING;
 	}
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 	__task_rq_unlock(rq);
@@ -2694,7 +2696,7 @@ void wake_up_new_task(struct task_struct
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3420,7 +3422,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
@@ -3428,7 +3430,7 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
+	    likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 
 		task_rq_unlock(rq, &flags);
@@ -5681,7 +5683,7 @@ int set_cpus_allowed_ptr(struct task_str
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, rq)) {
+	if (need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		__task_rq_unlock(rq);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1623,7 +1623,7 @@ static int select_idle_sibling(struct ta
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -973,13 +973,23 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct task_struct *curr;
+	struct rq *rq;
+	int cpu;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
+	cpu = task_cpu(p);
+	rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
+
 	/*
-	 * If the current task is an RT task, then
+	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
@@ -993,21 +1003,25 @@ select_task_rq_rt(struct rq *rq, struct 
 	 * lock?
 	 *
 	 * For equal prio tasks, we just let the scheduler sort it out.
+	 *
+	 * Otherwise, just let it ride on the affined RQ and the
+	 * post-schedule router will push the preempted task away
+	 *
+	 * This test is optimistic, if we get it wrong the load-balancer
+	 * will have to sort it out.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio) &&
+	if (curr && unlikely(rt_task(curr)) &&
+	    (curr->rt.nr_cpus_allowed < 2 ||
+	     curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
-		int cpu = find_lowest_rq(p);
+		int target = find_lowest_rq(p);
 
-		return (cpu == -1) ? task_cpu(p) : cpu;
+		if (target != -1)
+			cpu = target;
 	}
+	rcu_read_unlock();
 
-	/*
-	 * Otherwise, just let it ride on the affined RQ and the
-	 * post-schedule router will push the preempted task away
-	 */
-	return task_cpu(p);
+	return cpu;
 }
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -9,8 +9,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_stop(struct rq *rq, struct task_struct *p,
-		    int sd_flag, int flags)
+select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* stop tasks as never migrate */
 }


