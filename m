Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0FUKCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:02:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab0FUKCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:02:18 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100520204810.GA19188@think>
References: <20100520204810.GA19188@think>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 12:02:02 +0200
Message-ID: <1277114522.1875.469.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To return the favour, here's a scary patch that renders your machine a
doorstop :-) Sadly it just hangs, no splat, no sysrq, no nmi, no tripple
fault.

It looses the ttwu task_running() check, as I must admit I'm not quite
sure what it does.. Ingo?

It makes the whole TASK_WAKING thing very interesting again :-)

It also re-introduces a bunch of races because we now need to run
->select_task_rq() without holding the rq->lock. We cannot defer running
that because it really wants to know the cpu the wakeup originated from
(affine wakeups and the like).


---
 arch/x86/kernel/smp.c   |    1 +
 include/linux/sched.h   |    7 +-
 kernel/sched.c          |  225 ++++++++++++++++++++++++-----------------------
 kernel/sched_fair.c     |   10 +--
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    4 +-
 6 files changed, 127 insertions(+), 122 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d801210..1e487d6 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -202,6 +202,7 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
+	sched_ttwu_pending();
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a61c08c..9ae9fdb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1003,6 +1003,7 @@ partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 }
 #endif	/* !CONFIG_SMP */
 
+void sched_ttwu_pending(void);
 
 struct io_context;			/* See blkdev.h */
 
@@ -1046,12 +1047,11 @@ struct sched_class {
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
@@ -1174,6 +1174,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index b697606..ef90585 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -518,6 +518,8 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	struct task_struct *wake_list;
 #endif
 
 	/* calc_load related fields */
@@ -944,7 +946,7 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p)) && !task_is_waking(p))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -964,7 +966,7 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p)) && !task_is_waking(p))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -2257,9 +2259,9 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
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
@@ -2330,111 +2332,6 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 }
 
 /**
- * try_to_wake_up - wake up a thread
- * @p: the thread to be awakened
- * @state: the mask of task states that can be woken
- * @wake_flags: wake modifier flags (WF_*)
- *
- * Put it on the run-queue if it's not already there. The "current"
- * thread is always on the run-queue (except when the actual
- * re-schedule is in progress), and as such you're allowed to do
- * the simpler "current->state = TASK_RUNNING" to mark yourself
- * runnable without the overhead of this.
- *
- * Returns %true if @p was woken up, %false if it was already running
- * or @state didn't match @p's state.
- */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
-{
-	int cpu, orig_cpu, this_cpu, success = 0;
-	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
-	struct rq *rq;
-
-	this_cpu = get_cpu();
-
-	smp_wmb();
-	rq = task_rq_lock(p, &flags);
-	if (!(p->state & state))
-		goto out;
-
-	if (p->se.on_rq)
-		goto out_running;
-
-	cpu = task_cpu(p);
-	orig_cpu = cpu;
-
-#ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
-
-	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
-	 */
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
-
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
-
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
-
-	/*
-	 * We migrated the task without holding either rq->lock, however
-	 * since the task is not on the task list itself, nobody else
-	 * will try and migrate the task, hence the rq should match the
-	 * cpu we just moved it to.
-	 */
-	WARN_ON(task_cpu(p) != cpu);
-	WARN_ON(p->state != TASK_WAKING);
-
-#ifdef CONFIG_SCHEDSTATS
-	schedstat_inc(rq, ttwu_count);
-	if (cpu == this_cpu)
-		schedstat_inc(rq, ttwu_local);
-	else {
-		struct sched_domain *sd;
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-	}
-#endif /* CONFIG_SCHEDSTATS */
-
-out_activate:
-#endif /* CONFIG_SMP */
-	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
-		      cpu == this_cpu, en_flags);
-	success = 1;
-out_running:
-	ttwu_post_activation(p, rq, wake_flags, success);
-out:
-	task_rq_unlock(rq, &flags);
-	put_cpu();
-
-	return success;
-}
-
-/**
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened
  *
@@ -2465,6 +2362,112 @@ static void try_to_wake_up_local(struct task_struct *p)
 	ttwu_post_activation(p, rq, 0, success);
 }
 
+static int ttwu_running(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+
+	for (;;) {
+		rq = task_rq(p);
+		raw_spin_lock(&rq->lock);
+		if (likely(rq == task_rq(p)))
+			break;
+		raw_spin_unlock(&rq->lock);
+	}
+
+	if (!p->se.on_rq) {
+		raw_spin_unlock(&rq->lock);
+		return 0;
+	}
+
+	ttwu_post_activation(p, rq, 0, true);
+	return 1;
+}
+
+static void ttwu_do_activate(struct rq *rq, struct task_struct *p, bool local)
+{
+	set_task_cpu(p, cpu_of(rq));
+	ttwu_activate(p, rq, false, !local, local,
+			ENQUEUE_WAKEUP|ENQUEUE_WAKING);
+	ttwu_post_activation(p, rq, 0, true);
+}
+
+void sched_ttwu_pending(void)
+{
+	struct task_struct *list = xchg(&this_rq()->wake_list, NULL);
+	struct rq *rq = this_rq();
+
+	if (!list)
+		return;
+
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, false);
+	}
+
+	raw_spin_unlock(&rq->lock);
+}
+
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct task_struct *next = NULL;
+	struct rq *rq = cpu_rq(cpu);
+
+	if (cpu == smp_processor_id()) {
+		raw_spin_lock(&rq->lock);
+		ttwu_do_activate(rq, p, true);
+		raw_spin_unlock(&rq->lock);
+		return;
+	}
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
+		resched_cpu(cpu);
+}
+
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
+{
+	unsigned long flags;
+	int success = 0;
+	int cpu;
+
+	local_irq_save(flags);
+	for (;;) {
+		unsigned int task_state = p->state;
+
+		if (!(task_state & state))
+			goto out;
+
+		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
+			break;
+	}
+
+	success = 1;
+
+	if (unlikely(p->se.on_rq) && ttwu_running(p, wake_flags))
+		goto out;
+
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(p);
+
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	ttwu_queue(p, cpu);
+out:
+	local_irq_restore(flags);
+	return success;
+}
+
 /**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
@@ -2604,7 +2607,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3200,7 +3203,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5e8f98c..2bd145f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1128,11 +1128,12 @@ static void yield_task_fair(struct rq *rq)
 
 #ifdef CONFIG_SMP
 
-static void task_waking_fair(struct rq *rq, struct task_struct *p)
+static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+	// XXX racy again,.. we need to read cfs_rq->min_vruntime atomically
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 
@@ -1443,7 +1444,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1516,11 +1517,8 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
 			tmp = affine_sd;
 
-		if (tmp) {
-			raw_spin_unlock(&rq->lock);
+		if (tmp)
 			update_shares(tmp);
-			raw_spin_lock(&rq->lock);
-		}
 	}
 #endif
 
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f40..efaed8c 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d10c80e..1011cdc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -949,8 +949,10 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct rq *rq = task_rq(p); // XXX  racy
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 

