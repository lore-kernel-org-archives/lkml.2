Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0LPPO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:14:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:40706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0LPPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:14:22 -0500
Message-Id: <20101216150920.968046926@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 16 Dec 2010 15:56:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
References: <20101216145602.899838254@chello.nl>
Content-Disposition: inline; filename=peter_zijlstra-re-_reduce_runqueue_lock_contention.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce rq->lock contention on try_to_wake_up() by changing the task
state using a cmpxchg loop.

Once the task is set to TASK_WAKING we're guaranteed the only one
poking at it, then proceed to pick a new cpu without holding the
rq->lock (XXX this opens some races).

Then instead of locking the remote rq and activating the task, place
the task on a remote queue, again using cmpxchg, and notify the remote
cpu per IPI if this queue was empty to start processing its wakeups.

This avoids (in most cases) having to lock the remote runqueue (and
therefore the exclusive cacheline transfer thereof) but also touching
all the remote runqueue data structures needed for the actual
activation.

As measured using: http://oss.oracle.com/~mason/sembench.c

$ echo 4096 32000 64 128 > /proc/sys/kernel/sem
$ ./sembench -t 2048 -w 1900 -o 0

unpatched: run time 30 seconds 537953 worker burns per second
patched:   run time 30 seconds 657336 worker burns per second

Still need to sort out all the races marked XXX (non-trivial), and its
x86 only for the moment.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/smp.c   |    1 
 include/linux/sched.h   |    7 -
 kernel/sched.c          |  241 ++++++++++++++++++++++++++++++++++--------------
 kernel/sched_fair.c     |    5 
 kernel/sched_features.h |    3 
 kernel/sched_idletask.c |    2 
 kernel/sched_rt.c       |    4 
 kernel/sched_stoptask.c |    3 
 8 files changed, 190 insertions(+), 76 deletions(-)

Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c
+++ linux-2.6/arch/x86/kernel/smp.c
@@ -205,6 +205,7 @@ void smp_reschedule_interrupt(struct pt_
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
+	sched_ttwu_pending();
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1020,6 +1020,7 @@ partition_sched_domains(int ndoms_new, c
 }
 #endif	/* !CONFIG_SMP */
 
+void sched_ttwu_pending(void);
 
 struct io_context;			/* See blkdev.h */
 
@@ -1063,12 +1064,11 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
-			       int sd_flag, int flags);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
@@ -1198,6 +1198,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
 	int oncpu;
 #endif
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -520,6 +520,8 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	struct task_struct *wake_list;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -953,7 +955,7 @@ static inline struct rq *__task_rq_lock(
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p)) && !task_is_waking(p))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -973,7 +975,7 @@ static struct rq *task_rq_lock(struct ta
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p)) && !task_is_waking(p))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -2282,9 +2284,9 @@ static int select_fallback_rq(int cpu, s
  * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2310,10 +2312,10 @@ static void update_avg(u64 *avg, u64 sam
 }
 #endif
 
-static void
-ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
+static void ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
 #ifdef CONFIG_SCHEDSTATS
+	struct rq *rq = this_rq();
 
 	schedstat_inc(rq, ttwu_count);
 	schedstat_inc(p, se.statistics.nr_wakeups);
@@ -2341,8 +2343,11 @@ ttwu_stat(struct rq *rq, struct task_str
 #endif /* CONFIG_SCHEDSTATS */
 }
 
+/*
+ * Mark the task runnable and perform wakeup-preemption.
+ */
 static void
-ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
+ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	trace_sched_wakeup(p);
 	check_preempt_curr(rq, p, wake_flags);
@@ -2368,6 +2373,109 @@ ttwu_post_activation(struct task_struct 
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+static void ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+	if (task_cpu(p) != cpu_of(rq))
+		set_task_cpu(p, cpu_of(rq));
+
+	activate_task(rq, p, ENQUEUE_WAKEUP
+#ifdef CONFIG_SMP
+			     | ENQUEUE_WAKING
+#endif
+			);
+	ttwu_do_wakeup(rq, p, wake_flags);
+}
+
+/*
+ * Called in case the task @p isn't fully descheduled from its runqueue,
+ * in this case we must do a full remote wakeup.
+ */
+static int ttwu_force(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	/*
+	 * Since we've already set TASK_WAKING this task's CPU cannot
+	 * change from under us.
+	 */
+	rq = task_rq(p);
+	raw_spin_lock(&rq->lock);
+	BUG_ON(rq != task_rq(p));
+
+	if (p->se.on_rq) {
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	} else if (task_running(rq, p)) {
+		ttwu_do_activate(rq, p, wake_flags);
+		ret = 1;
+	}
+
+	if (ret)
+		ttwu_stat(p, task_cpu(p), wake_flags);
+
+	raw_spin_unlock(&rq->lock);
+
+	return ret;
+}
+
+void sched_ttwu_pending(void)
+{
+#ifdef CONFIG_SMP
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, 0);
+	}
+
+	raw_spin_unlock(&rq->lock);
+#endif
+}
+
+#ifdef CONFIG_SMP
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	struct task_struct *next = NULL;
+	struct rq *rq = cpu_rq(cpu);
+
+	for (;;) {
+		struct task_struct *old = next;
+
+		p->wake_entry = next;
+		next = cmpxchg(&rq->wake_list, old, p);
+		if (next == old)
+			break;
+	}
+
+	if (!next)
+		smp_send_reschedule(cpu);
+}
+#endif
+
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+#ifdef CONFIG_SMP
+	if (!sched_feat(TTWU_FORCE) && cpu != smp_processor_id()) {
+		ttwu_queue_remote(p, cpu);
+		return;
+	}
+#endif
+
+	raw_spin_lock(&rq->lock);
+	ttwu_do_activate(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
+}
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2383,77 +2491,77 @@ ttwu_post_activation(struct task_struct 
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
+	int cpu = task_cpu(p);
 	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
-	struct rq *rq;
+	int success = 0;
+	int load;
 
-	this_cpu = get_cpu();
-
-	smp_wmb();
-	rq = task_rq_lock(p, &flags);
-	if (!(p->state & state))
-		goto out;
+	local_irq_save(flags);
+	for (;;) {
+		unsigned int task_state = p->state;
 
-	cpu = task_cpu(p);
+		if (!(task_state & state))
+			goto out;
 
-	if (p->se.on_rq)
-		goto out_running;
+		/*
+		 * We've got to store the contributes_to_load state before
+		 * modifying the task state.
+		 */
+		load = task_contributes_to_load(p);
 
-	orig_cpu = cpu;
-#ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
+			break;
+	}
 
 	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
+	 * Everything that changes p->state to TASK_RUNNING is a wakeup!
 	 */
-	if (task_contributes_to_load(p)) {
-		if (likely(cpu_online(orig_cpu)))
-			rq->nr_uninterruptible--;
-		else
-			this_rq()->nr_uninterruptible--;
-	}
-	p->state = TASK_WAKING;
-
-	if (p->sched_class->task_waking) {
-		p->sched_class->task_waking(rq, p);
-		en_flags |= ENQUEUE_WAKING;
-	}
+	success = 1;
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
+	/*
+	 * If p is prev in schedule() before deactivate_task() we
+	 * simply need to set p->state = TASK_RUNNING while
+	 * holding the rq->lock.
+	 */
+	if (p->se.on_rq && ttwu_force(p, wake_flags))
+		goto out;
 
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
+	/*
+	 * Now that we'll do a full wakeup, activate_task(), account the
+	 * contribute_to_load state.
+	 */
+	if (load) // XXX racy
+		this_rq()->nr_uninterruptible--;
 
+#ifdef CONFIG_SMP
 	/*
-	 * We migrated the task without holding either rq->lock, however
-	 * since the task is not on the task list itself, nobody else
-	 * will try and migrate the task, hence the rq should match the
-	 * cpu we just moved it to.
+	 * Catch the case where schedule() has done the dequeue but hasn't yet
+	 * scheduled to a new task, in that case p is still being referenced
+	 * by that cpu so we cannot wake it to any other cpu.
 	 */
-	WARN_ON(task_cpu(p) != cpu);
-	WARN_ON(p->state != TASK_WAKING);
+	if (sched_feat(TTWU_SPIN)) {
+		while (p->oncpu)
+			cpu_relax();
+	} else {
+		if (p->oncpu && ttwu_force(p, wake_flags))
+			goto out;
+	}
 
-out_activate:
-#endif /* CONFIG_SMP */
-	activate_task(rq, p, en_flags);
-out_running:
-	ttwu_post_activation(p, rq, wake_flags);
-	ttwu_stat(rq, p, cpu, wake_flags);
-	success = 1;
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(p);
+	/*
+	 * XXX: by having set TASK_WAKING outside of rq->lock, there
+	 * could be an in-flight change to p->cpus_allowed..
+	 */
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+#endif
+	ttwu_stat(p, cpu, wake_flags);
+	ttwu_queue(p, cpu);
 out:
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+	local_irq_restore(flags);
 
 	return success;
 }
@@ -2480,8 +2588,8 @@ static void try_to_wake_up_local(struct 
 	if (!p->se.on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
-	ttwu_post_activation(p, rq, 0);
-	ttwu_stat(rq, p, smp_processor_id(), 0);
+	ttwu_stat(p, smp_processor_id(), 0);
+	ttwu_do_wakeup(rq, p, 0);
 }
 
 /**
@@ -2634,7 +2742,7 @@ void wake_up_new_task(struct task_struct
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3360,7 +3468,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
@@ -3931,7 +4039,6 @@ asmlinkage void __sched schedule(void)
 	}
 
 	pre_schedule(rq, prev);
-
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1321,11 +1321,12 @@ static void yield_task_fair(struct rq *r
 
 #ifdef CONFIG_SMP
 
-static void task_waking_fair(struct rq *rq, struct task_struct *p)
+static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+	// XXX racy again,.. we need to read cfs_rq->min_vruntime atomically
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 
@@ -1606,7 +1607,7 @@ static int select_idle_sibling(struct ta
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
@@ -973,8 +973,10 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct rq *rq = task_rq(p); // XXX  racy
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
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
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -64,3 +64,6 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+SCHED_FEAT(TTWU_FORCE, 0)
+SCHED_FEAT(TTWU_SPIN, 1)


