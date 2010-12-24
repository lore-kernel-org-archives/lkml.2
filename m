Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0LXMoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:44:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:52595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0LXMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:23 -0500
Message-Id: <20101224123742.887559254@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 08/17] sched: Drop the rq argument to sched_class::select_task_rq()
References: <20101224122338.172750730@chello.nl>
Content-Disposition: inline; filename=sched-select_task_rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of calling select_task_rq() without rq->lock held, drop
the dependency on the rq argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h   |    3 +--
 kernel/sched.c          |   40 ++++++++++++++--------------------------
 kernel/sched_fair.c     |    2 +-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |   10 +++++++++-
 kernel/sched_stoptask.c |    3 +--
 6 files changed, 27 insertions(+), 33 deletions(-)

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
@@ -2138,13 +2138,14 @@ static int migration_cpu_stop(void *data
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
+	smp_rmb(); /* finish_lock_switch() */
+	return p->on_rq || p->on_cpu;
 }
 
 /*
@@ -2337,9 +2338,9 @@ static int select_fallback_rq(int cpu, s
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
@@ -2484,7 +2485,7 @@ static int try_to_wake_up(struct task_st
 		en_flags |= ENQUEUE_WAKING;
 	}
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 	__task_rq_unlock(rq);
@@ -2680,24 +2681,17 @@ void wake_up_new_task(struct task_struct
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
 
 #ifdef CONFIG_SMP
 	rq = task_rq_lock(p, &flags);
-	p->state = TASK_WAKING;
 
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
-	 *
-	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
-	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
-	set_task_cpu(p, cpu);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 
-	p->state = TASK_RUNNING;
 	task_rq_unlock(rq, &flags);
 #endif
 
@@ -2710,7 +2704,6 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
-	put_cpu();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -3416,27 +3409,22 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	unsigned long flags;
-	struct rq *rq;
 	int dest_cpu;
 
-	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
-	/*
-	 * select_task_rq() can race against ->cpus_allowed
-	 */
-	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
+	if (likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 
-		task_rq_unlock(rq, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #endif
@@ -5681,7 +5669,7 @@ int set_cpus_allowed_ptr(struct task_str
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
@@ -973,11 +973,18 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
+#if 0
+	/*
+	 * XXX without holding rq->lock the below is racy, need to
+	 * rewrite it in a racy but non-dangerous way so that we mostly
+	 * get the benefit of the heuristic but don't crash the kernel
+	 * if we get it wrong ;-)
+	 */
 	/*
 	 * If the current task is an RT task, then
 	 * try to see if we can wake this RT task up on another
@@ -1002,6 +1009,7 @@ select_task_rq_rt(struct rq *rq, struct 
 
 		return (cpu == -1) ? task_cpu(p) : cpu;
 	}
+#endif
 
 	/*
 	 * Otherwise, just let it ride on the affined RQ and the
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


