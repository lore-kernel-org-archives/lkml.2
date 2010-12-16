Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0LPUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:32:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:50787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab0LPUco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:32:44 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292528874.2708.85.camel@laptop>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl>  <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop>  <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 21:32:33 +0100
Message-ID: <1292531553.2708.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 20:47 +0100, Peter Zijlstra wrote:

> ... /me goes make a strong pot of tea


Just when the tea was setting my brain sparked (could be insanity,
dunno), anyway, how about the below?

It does the state and on_rq checks first, if we find on_rq, we do a
forced remote wakeup (rq->lock, recheck state, recheck on_rq, set
p->state to TASK_RUNNING), otherwise, we do the cmpxchg thing to
TASK_WAKING, (since !on_rq @p passed through schedule()) and proceed
like before.



---
Subject: sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 22 Jun 2010 15:33:06 +0200

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
LKML-Reference: <1277213586.1875.704.camel@laptop>
---
 arch/x86/kernel/smp.c   |    1 
 include/linux/sched.h   |    7 -
 kernel/sched.c          |  226 +++++++++++++++++++++++++++++++++---------------
 kernel/sched_fair.c     |    5 -
 kernel/sched_features.h |    2 
 kernel/sched_idletask.c |    2 
 kernel/sched_rt.c       |    4 
 kernel/sched_stoptask.c |    3 
 8 files changed, 175 insertions(+), 75 deletions(-)

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
@@ -2368,6 +2373,103 @@ ttwu_post_activation(struct task_struct 
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
+static int ttwu_force(struct task_struct *p, int state, int wake_flags)
+{
+	unsigned long flags;
+	struct rq *rq;
+	int ret = 0;
+
+	rq = task_rq_lock(p, &flags);
+
+	if (!(p->state & state))
+		goto out;
+
+	if (p->se.on_rq) {
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ttwu_stat(p, task_cpu(p), wake_flags);
+		ret = 1;
+	}
+
+out:
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
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
@@ -2383,79 +2485,69 @@ ttwu_post_activation(struct task_struct 
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
+	int cpu, load, ret = 0;
 	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
-	struct rq *rq;
 
-	this_cpu = get_cpu();
+	smp_mb();
 
-	smp_wmb();
-	rq = task_rq_lock(p, &flags);
 	if (!(p->state & state))
-		goto out;
-
-	cpu = task_cpu(p);
-
-	if (p->se.on_rq)
-		goto out_running;
+		return 0;
 
-	orig_cpu = cpu;
-#ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+	if (p->se.on_rq && ttwu_force(p, state, wake_flags))
+		return 1;
 
 	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
+	 * Since !on_rq, the task @p must have passed through schedule,
+	 * so now cmpxchg the state to TASK_WAKING to serialize concurrent
+	 * wakeups.
 	 */
-	if (task_contributes_to_load(p)) {
-		if (likely(cpu_online(orig_cpu)))
-			rq->nr_uninterruptible--;
-		else
-			this_rq()->nr_uninterruptible--;
-	}
-	p->state = TASK_WAKING;
 
-	if (p->sched_class->task_waking) {
-		p->sched_class->task_waking(rq, p);
-		en_flags |= ENQUEUE_WAKING;
+	local_irq_save(flags);
+	for (;;) {
+		unsigned int task_state = p->state;
+
+		if (!(task_state & state))
+			goto out;
+
+		load = task_contributes_to_load(p);
+
+		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
+			break;
 	}
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
+	ret = 1; /* we qualify as a proper wakeup now */
 
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
+	if (load) // XXX racy
+		this_rq()->nr_uninterruptible--;
+
+	cpu = task_cpu(p);
 
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
+	while (p->oncpu)
+		cpu_relax();
 
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
+	ttwu_queue(p, cpu);
+	ttwu_stat(p, cpu, wake_flags);
 out:
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+	local_irq_restore(flags);
 
-	return success;
+	return ret;
 }
 
 /**
@@ -2480,8 +2572,8 @@ static void try_to_wake_up_local(struct 
 	if (!p->se.on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
-	ttwu_post_activation(p, rq, 0);
-	ttwu_stat(rq, p, smp_processor_id(), 0);
+	ttwu_stat(p, smp_processor_id(), 0);
+	ttwu_do_wakeup(rq, p, 0);
 }
 
 /**
@@ -2634,7 +2726,7 @@ void wake_up_new_task(struct task_struct
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3360,7 +3452,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
@@ -3930,8 +4022,10 @@ asmlinkage void __sched schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
+	/*
+	 * Both pre_schedule() and idle_balance() can releaes rq->lock.
+	 */
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
+	struct rq *rq = task_rq(p);
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
@@ -64,3 +64,5 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+SCHED_FEAT(TTWU_FORCE, 0)

