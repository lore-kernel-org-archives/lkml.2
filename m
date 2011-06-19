Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1FSIkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:40:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1FSIkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:40:17 -0400
Date: Sun, 19 Jun 2011 10:39:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fixes
Message-ID: <20110619083959.GA16893@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

This is mainly the (functional) revert to softirqs, with no kthreads 
left. I'm sending this now after just one day of testing thinking 
that we'd probably want this in -rc4.

 Thanks,

	Ingo

------------------>
Paul E. McKenney (3):
      rcu: Simplify curing of load woes
      rcu: use softirq instead of kthreads except when RCU_BOOST=y
      rcu: Move RCU_BOOST #ifdefs to header file

Shaohua Li (1):
      rcu: Use softirq to address performance regression


 Documentation/filesystems/proc.txt  |    1 +
 include/linux/interrupt.h           |    1 +
 include/trace/events/irq.h          |    3 +-
 kernel/rcutree.c                    |  398 ++-------------------------------
 kernel/rcutree.h                    |   12 +-
 kernel/rcutree_plugin.h             |  419 ++++++++++++++++++++++++++++++++++-
 kernel/rcutree_trace.c              |   32 ++-
 kernel/softirq.c                    |    2 +-
 tools/perf/util/trace-event-parse.c |    1 +
 9 files changed, 466 insertions(+), 403 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f481780..db3b1ab 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -843,6 +843,7 @@ Provides counts of softirq handlers serviced since boot time, for each cpu.
  TASKLET:          0          0          0        290
    SCHED:      27035      26983      26971      26746
  HRTIMER:          0          0          0          0
+     RCU:       1678       1769       2178       2250
 
 
 1.3 IDE devices in /proc/ide
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 6c12989..f6efed0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -414,6 +414,7 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
+	RCU_SOFTIRQ,    /* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index ae045ca..1c09820 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -20,7 +20,8 @@ struct softirq_action;
 			 softirq_name(BLOCK_IOPOLL),	\
 			 softirq_name(TASKLET),		\
 			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER))
+			 softirq_name(HRTIMER),		\
+			 softirq_name(RCU))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 89419ff..7e59ffb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -87,6 +87,8 @@ static struct rcu_state *rcu_state;
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+#ifdef CONFIG_RCU_BOOST
+
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -98,8 +100,11 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
-static void invoke_rcu_cpu_kthread(void);
+static void invoke_rcu_core(void);
+static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
 #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
 
@@ -1088,14 +1093,8 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
-	struct task_struct *t;
 
-	/* Stop the CPU's kthread. */
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t != NULL) {
-		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
-		kthread_stop(t);
-	}
+	rcu_stop_cpu_kthread(cpu);
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -1231,7 +1230,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 }
 
 /*
@@ -1277,7 +1276,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 }
 
 #ifdef CONFIG_SMP
@@ -1442,13 +1441,14 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* If there are callbacks ready, invoke them. */
-	rcu_do_batch(rsp, rdp);
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		invoke_rcu_callbacks(rsp, rdp);
 }
 
 /*
  * Do softirq processing for the current CPU.
  */
-static void rcu_process_callbacks(void)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
@@ -1465,342 +1465,20 @@ static void rcu_process_callbacks(void)
  * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
  * cannot disappear out from under us.
  */
-static void invoke_rcu_cpu_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
-		local_irq_restore(flags);
-		return;
-	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
-	local_irq_restore(flags);
-}
-
-/*
- * Wake up the specified per-rcu_node-structure kthread.
- * Because the per-rcu_node kthreads are immortal, we don't need
- * to do anything to keep them alive.
- */
-static void invoke_rcu_node_kthread(struct rcu_node *rnp)
-{
-	struct task_struct *t;
-
-	t = rnp->node_kthread_task;
-	if (t != NULL)
-		wake_up_process(t);
-}
-
-/*
- * Set the specified CPU's kthread to run RT or not, as specified by
- * the to_rt argument.  The CPU-hotplug locks are held, so the task
- * is not going away.
- */
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
-{
-	int policy;
-	struct sched_param sp;
-	struct task_struct *t;
-
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t == NULL)
-		return;
-	if (to_rt) {
-		policy = SCHED_FIFO;
-		sp.sched_priority = RCU_KTHREAD_PRIO;
-	} else {
-		policy = SCHED_NORMAL;
-		sp.sched_priority = 0;
-	}
-	sched_setscheduler_nocheck(t, policy, &sp);
-}
-
-/*
- * Timer handler to initiate the waking up of per-CPU kthreads that
- * have yielded the CPU due to excess numbers of RCU callbacks.
- * We wake up the per-rcu_node kthread, which in turn will wake up
- * the booster kthread.
- */
-static void rcu_cpu_kthread_timer(unsigned long arg)
-{
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
-	struct rcu_node *rnp = rdp->mynode;
-
-	atomic_or(rdp->grpmask, &rnp->wakemask);
-	invoke_rcu_node_kthread(rnp);
-}
-
-/*
- * Drop to non-real-time priority and yield, but only after posting a
- * timer that will cause us to regain our real-time priority if we
- * remain preempted.  Either way, we restore our real-time priority
- * before returning.
- */
-static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
-{
-	struct sched_param sp;
-	struct timer_list yield_timer;
-
-	setup_timer_on_stack(&yield_timer, f, arg);
-	mod_timer(&yield_timer, jiffies + 2);
-	sp.sched_priority = 0;
-	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
-	set_user_nice(current, 19);
-	schedule();
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-	del_timer(&yield_timer);
-}
-
-/*
- * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
- * This can happen while the corresponding CPU is either coming online
- * or going offline.  We cannot wait until the CPU is fully online
- * before starting the kthread, because the various notifier functions
- * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
- * the corresponding CPU is online.
- *
- * Return 1 if the kthread needs to stop, 0 otherwise.
- *
- * Caller must disable bh.  This function can momentarily enable it.
- */
-static int rcu_cpu_kthread_should_stop(int cpu)
-{
-	while (cpu_is_offline(cpu) ||
-	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
-	       smp_processor_id() != cpu) {
-		if (kthread_should_stop())
-			return 1;
-		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
-		local_bh_enable();
-		schedule_timeout_uninterruptible(1);
-		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
-			set_cpus_allowed_ptr(current, cpumask_of(cpu));
-		local_bh_disable();
-	}
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	return 0;
-}
-
-/*
- * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * earlier RCU softirq.
- */
-static int rcu_cpu_kthread(void *arg)
-{
-	int cpu = (int)(long)arg;
-	unsigned long flags;
-	int spincnt = 0;
-	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
-	char work;
-	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
-
-	for (;;) {
-		*statusp = RCU_KTHREAD_WAITING;
-		rcu_wait(*workp != 0 || kthread_should_stop());
-		local_bh_disable();
-		if (rcu_cpu_kthread_should_stop(cpu)) {
-			local_bh_enable();
-			break;
-		}
-		*statusp = RCU_KTHREAD_RUNNING;
-		per_cpu(rcu_cpu_kthread_loops, cpu)++;
-		local_irq_save(flags);
-		work = *workp;
-		*workp = 0;
-		local_irq_restore(flags);
-		if (work)
-			rcu_process_callbacks();
-		local_bh_enable();
-		if (*workp != 0)
-			spincnt++;
-		else
-			spincnt = 0;
-		if (spincnt > 10) {
-			*statusp = RCU_KTHREAD_YIELDING;
-			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
-			spincnt = 0;
-		}
-	}
-	*statusp = RCU_KTHREAD_STOPPED;
-	return 0;
-}
-
-/*
- * Spawn a per-CPU kthread, setting up affinity and priority.
- * Because the CPU hotplug lock is held, no other CPU will be attempting
- * to manipulate rcu_cpu_kthread_task.  There might be another CPU
- * attempting to access it during boot, but the locking in kthread_bind()
- * will enforce sufficient ordering.
- */
-static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
+static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_kthreads_spawnable ||
-	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
-		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
-	kthread_bind(t, cpu);
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
-	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	return 0;
-}
-
-/*
- * Per-rcu_node kthread, which is in charge of waking up the per-CPU
- * kthreads when needed.  We ignore requests to wake up kthreads
- * for offline CPUs, which is OK because force_quiescent_state()
- * takes care of this case.
- */
-static int rcu_node_kthread(void *arg)
-{
-	int cpu;
-	unsigned long flags;
-	unsigned long mask;
-	struct rcu_node *rnp = (struct rcu_node *)arg;
-	struct sched_param sp;
-	struct task_struct *t;
-
-	for (;;) {
-		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		rcu_wait(atomic_read(&rnp->wakemask) != 0);
-		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		mask = atomic_xchg(&rnp->wakemask, 0);
-		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
-			if ((mask & 0x1) == 0)
-				continue;
-			preempt_disable();
-			t = per_cpu(rcu_cpu_kthread_task, cpu);
-			if (!cpu_online(cpu) || t == NULL) {
-				preempt_enable();
-				continue;
-			}
-			per_cpu(rcu_cpu_has_work, cpu) = 1;
-			sp.sched_priority = RCU_KTHREAD_PRIO;
-			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-			preempt_enable();
-		}
-	}
-	/* NOTREACHED */
-	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
-	return 0;
-}
-
-/*
- * Set the per-rcu_node kthread's affinity to cover all CPUs that are
- * served by the rcu_node in question.  The CPU hotplug lock is still
- * held, so the value of rnp->qsmaskinit will be stable.
- *
- * We don't include outgoingcpu in the affinity set, use -1 if there is
- * no outgoing CPU.  If there are no CPUs left in the affinity set,
- * this function allows the kthread to execute on any CPU.
- */
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
-{
-	cpumask_var_t cm;
-	int cpu;
-	unsigned long mask = rnp->qsmaskinit;
-
-	if (rnp->node_kthread_task == NULL)
-		return;
-	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+	if (likely(!rsp->boost)) {
+		rcu_do_batch(rsp, rdp);
 		return;
-	cpumask_clear(cm);
-	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
-		if ((mask & 0x1) && cpu != outgoingcpu)
-			cpumask_set_cpu(cpu, cm);
-	if (cpumask_weight(cm) == 0) {
-		cpumask_setall(cm);
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
-			cpumask_clear_cpu(cpu, cm);
-		WARN_ON_ONCE(cpumask_weight(cm) == 0);
 	}
-	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
-	rcu_boost_kthread_setaffinity(rnp, cm);
-	free_cpumask_var(cm);
+	invoke_rcu_callbacks_kthread();
 }
 
-/*
- * Spawn a per-rcu_node kthread, setting priority and affinity.
- * Called during boot before online/offline can happen, or, if
- * during runtime, with the main CPU-hotplug locks held.  So only
- * one of these can be executing at a time.
- */
-static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
-						struct rcu_node *rnp)
+static void invoke_rcu_core(void)
 {
-	unsigned long flags;
-	int rnp_index = rnp - &rsp->node[0];
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_kthreads_spawnable ||
-	    rnp->qsmaskinit == 0)
-		return 0;
-	if (rnp->node_kthread_task == NULL) {
-		t = kthread_create(rcu_node_kthread, (void *)rnp,
-				   "rcun%d", rnp_index);
-		if (IS_ERR(t))
-			return PTR_ERR(t);
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rnp->node_kthread_task = t;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		sp.sched_priority = 99;
-		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	}
-	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
+	raise_softirq(RCU_SOFTIRQ);
 }
 
-static void rcu_wake_one_boost_kthread(struct rcu_node *rnp);
-
-/*
- * Spawn all kthreads -- called as soon as the scheduler is running.
- */
-static int __init rcu_spawn_kthreads(void)
-{
-	int cpu;
-	struct rcu_node *rnp;
-	struct task_struct *t;
-
-	rcu_kthreads_spawnable = 1;
-	for_each_possible_cpu(cpu) {
-		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu)) {
-			(void)rcu_spawn_one_cpu_kthread(cpu);
-			t = per_cpu(rcu_cpu_kthread_task, cpu);
-			if (t)
-				wake_up_process(t);
-		}
-	}
-	rnp = rcu_get_root(rcu_state);
-	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	if (rnp->node_kthread_task)
-		wake_up_process(rnp->node_kthread_task);
-	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp) {
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-			t = rnp->node_kthread_task;
-			if (t)
-				wake_up_process(t);
-			rcu_wake_one_boost_kthread(rnp);
-		}
-	}
-	return 0;
-}
-early_initcall(rcu_spawn_kthreads);
-
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -2207,44 +1885,6 @@ static void __cpuinit rcu_prepare_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
-static void __cpuinit rcu_prepare_kthreads(int cpu)
-{
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;
-
-	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
-	if (rcu_kthreads_spawnable) {
-		(void)rcu_spawn_one_cpu_kthread(cpu);
-		if (rnp->node_kthread_task == NULL)
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	}
-}
-
-/*
- * kthread_create() creates threads in TASK_UNINTERRUPTIBLE state,
- * but the RCU threads are woken on demand, and if demand is low this
- * could be a while triggering the hung task watchdog.
- *
- * In order to avoid this, poke all tasks once the CPU is fully
- * up and running.
- */
-static void __cpuinit rcu_online_kthreads(int cpu)
-{
-	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;
-	struct task_struct *t;
-
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t)
-		wake_up_process(t);
-
-	t = rnp->node_kthread_task;
-	if (t)
-		wake_up_process(t);
-
-	rcu_wake_one_boost_kthread(rnp);
-}
-
 /*
  * Handle CPU online/offline notification events.
  */
@@ -2262,7 +1902,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_prepare_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
-		rcu_online_kthreads(cpu);
 	case CPU_DOWN_FAILED:
 		rcu_node_kthread_setaffinity(rnp, -1);
 		rcu_cpu_kthread_setrt(cpu, 1);
@@ -2410,6 +2049,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
+	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7b9a08b..01b2ccd 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -369,6 +369,7 @@ struct rcu_state {
 						/*  period because */
 						/*  force_quiescent_state() */
 						/*  was running. */
+	u8	boost;				/* Subject to priority boost. */
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
 
@@ -426,6 +427,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
+static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
@@ -450,11 +452,19 @@ static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static void invoke_rcu_callbacks_kthread(void);
+#ifdef CONFIG_RCU_BOOST
+static void rcu_preempt_do_callbacks(void);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
-static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index);
+static void invoke_rcu_node_kthread(struct rcu_node *rnp);
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
+static void __cpuinit rcu_prepare_kthreads(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c8bff30..14dc7dd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -602,6 +602,15 @@ static void rcu_preempt_process_callbacks(void)
 				&__get_cpu_var(rcu_preempt_data));
 }
 
+#ifdef CONFIG_RCU_BOOST
+
+static void rcu_preempt_do_callbacks(void)
+{
+	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+}
+
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -1249,6 +1258,23 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
+ * Wake up the per-CPU kthread to invoke RCU callbacks.
+ */
+static void invoke_rcu_callbacks_kthread(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
+		local_irq_restore(flags);
+		return;
+	}
+	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	local_irq_restore(flags);
+}
+
+/*
  * Set the affinity of the boost kthread.  The CPU-hotplug locks are
  * held, so no one should be messing with the existence of the boost
  * kthread.
@@ -1288,6 +1314,7 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 
 	if (&rcu_preempt_state != rsp)
 		return 0;
+	rsp->boost = 1;
 	if (rnp->boost_kthread_task != NULL)
 		return 0;
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
@@ -1299,13 +1326,372 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
 }
 
-static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Stop the RCU's per-CPU kthread when its CPU goes offline,.
+ */
+static void rcu_stop_cpu_kthread(int cpu)
 {
-	if (rnp->boost_kthread_task)
-		wake_up_process(rnp->boost_kthread_task);
+	struct task_struct *t;
+
+	/* Stop the CPU's kthread. */
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t != NULL) {
+		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
+		kthread_stop(t);
+	}
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void rcu_kthread_do_work(void)
+{
+	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_preempt_do_callbacks();
+}
+
+/*
+ * Wake up the specified per-rcu_node-structure kthread.
+ * Because the per-rcu_node kthreads are immortal, we don't need
+ * to do anything to keep them alive.
+ */
+static void invoke_rcu_node_kthread(struct rcu_node *rnp)
+{
+	struct task_struct *t;
+
+	t = rnp->node_kthread_task;
+	if (t != NULL)
+		wake_up_process(t);
+}
+
+/*
+ * Set the specified CPU's kthread to run RT or not, as specified by
+ * the to_rt argument.  The CPU-hotplug locks are held, so the task
+ * is not going away.
+ */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+{
+	int policy;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t == NULL)
+		return;
+	if (to_rt) {
+		policy = SCHED_FIFO;
+		sp.sched_priority = RCU_KTHREAD_PRIO;
+	} else {
+		policy = SCHED_NORMAL;
+		sp.sched_priority = 0;
+	}
+	sched_setscheduler_nocheck(t, policy, &sp);
+}
+
+/*
+ * Timer handler to initiate the waking up of per-CPU kthreads that
+ * have yielded the CPU due to excess numbers of RCU callbacks.
+ * We wake up the per-rcu_node kthread, which in turn will wake up
+ * the booster kthread.
+ */
+static void rcu_cpu_kthread_timer(unsigned long arg)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
+	struct rcu_node *rnp = rdp->mynode;
+
+	atomic_or(rdp->grpmask, &rnp->wakemask);
+	invoke_rcu_node_kthread(rnp);
+}
+
+/*
+ * Drop to non-real-time priority and yield, but only after posting a
+ * timer that will cause us to regain our real-time priority if we
+ * remain preempted.  Either way, we restore our real-time priority
+ * before returning.
+ */
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
+{
+	struct sched_param sp;
+	struct timer_list yield_timer;
+
+	setup_timer_on_stack(&yield_timer, f, arg);
+	mod_timer(&yield_timer, jiffies + 2);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
+	set_user_nice(current, 19);
+	schedule();
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+	del_timer(&yield_timer);
+}
+
+/*
+ * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
+ * This can happen while the corresponding CPU is either coming online
+ * or going offline.  We cannot wait until the CPU is fully online
+ * before starting the kthread, because the various notifier functions
+ * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
+ * the corresponding CPU is online.
+ *
+ * Return 1 if the kthread needs to stop, 0 otherwise.
+ *
+ * Caller must disable bh.  This function can momentarily enable it.
+ */
+static int rcu_cpu_kthread_should_stop(int cpu)
+{
+	while (cpu_is_offline(cpu) ||
+	       !cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)) ||
+	       smp_processor_id() != cpu) {
+		if (kthread_should_stop())
+			return 1;
+		per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+		per_cpu(rcu_cpu_kthread_cpu, cpu) = raw_smp_processor_id();
+		local_bh_enable();
+		schedule_timeout_uninterruptible(1);
+		if (!cpumask_equal(&current->cpus_allowed, cpumask_of(cpu)))
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+		local_bh_disable();
+	}
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
+	return 0;
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * earlier RCU softirq.
+ */
+static int rcu_cpu_kthread(void *arg)
+{
+	int cpu = (int)(long)arg;
+	unsigned long flags;
+	int spincnt = 0;
+	unsigned int *statusp = &per_cpu(rcu_cpu_kthread_status, cpu);
+	char work;
+	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+
+	for (;;) {
+		*statusp = RCU_KTHREAD_WAITING;
+		rcu_wait(*workp != 0 || kthread_should_stop());
+		local_bh_disable();
+		if (rcu_cpu_kthread_should_stop(cpu)) {
+			local_bh_enable();
+			break;
+		}
+		*statusp = RCU_KTHREAD_RUNNING;
+		per_cpu(rcu_cpu_kthread_loops, cpu)++;
+		local_irq_save(flags);
+		work = *workp;
+		*workp = 0;
+		local_irq_restore(flags);
+		if (work)
+			rcu_kthread_do_work();
+		local_bh_enable();
+		if (*workp != 0)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			*statusp = RCU_KTHREAD_YIELDING;
+			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
+			spincnt = 0;
+		}
+	}
+	*statusp = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Spawn a per-CPU kthread, setting up affinity and priority.
+ * Because the CPU hotplug lock is held, no other CPU will be attempting
+ * to manipulate rcu_cpu_kthread_task.  There might be another CPU
+ * attempting to access it during boot, but the locking in kthread_bind()
+ * will enforce sufficient ordering.
+ *
+ * Please note that we cannot simply refuse to wake up the per-CPU
+ * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
+ * which can result in softlockup complaints if the task ends up being
+ * idle for more than a couple of minutes.
+ *
+ * However, please note also that we cannot bind the per-CPU kthread to its
+ * CPU until that CPU is fully online.  We also cannot wait until the
+ * CPU is fully online before we create its per-CPU kthread, as this would
+ * deadlock the system when CPU notifiers tried waiting for grace
+ * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
+ * is online.  If its CPU is not yet fully online, then the code in
+ * rcu_cpu_kthread() will wait until it is fully online, and then do
+ * the binding.
+ */
+static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
+{
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
+		return 0;
+	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	if (cpu_online(cpu))
+		kthread_bind(t, cpu);
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
+	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	per_cpu(rcu_cpu_kthread_task, cpu) = t;
+	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
+	return 0;
+}
+
+/*
+ * Per-rcu_node kthread, which is in charge of waking up the per-CPU
+ * kthreads when needed.  We ignore requests to wake up kthreads
+ * for offline CPUs, which is OK because force_quiescent_state()
+ * takes care of this case.
+ */
+static int rcu_node_kthread(void *arg)
+{
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	for (;;) {
+		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
+		rcu_wait(atomic_read(&rnp->wakemask) != 0);
+		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		mask = atomic_xchg(&rnp->wakemask, 0);
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
+			if ((mask & 0x1) == 0)
+				continue;
+			preempt_disable();
+			t = per_cpu(rcu_cpu_kthread_task, cpu);
+			if (!cpu_online(cpu) || t == NULL) {
+				preempt_enable();
+				continue;
+			}
+			per_cpu(rcu_cpu_has_work, cpu) = 1;
+			sp.sched_priority = RCU_KTHREAD_PRIO;
+			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+			preempt_enable();
+		}
+	}
+	/* NOTREACHED */
+	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
+	return 0;
+}
+
+/*
+ * Set the per-rcu_node kthread's affinity to cover all CPUs that are
+ * served by the rcu_node in question.  The CPU hotplug lock is still
+ * held, so the value of rnp->qsmaskinit will be stable.
+ *
+ * We don't include outgoingcpu in the affinity set, use -1 if there is
+ * no outgoing CPU.  If there are no CPUs left in the affinity set,
+ * this function allows the kthread to execute on any CPU.
+ */
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+{
+	cpumask_var_t cm;
+	int cpu;
+	unsigned long mask = rnp->qsmaskinit;
+
+	if (rnp->node_kthread_task == NULL)
+		return;
+	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+		return;
+	cpumask_clear(cm);
+	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
+		if ((mask & 0x1) && cpu != outgoingcpu)
+			cpumask_set_cpu(cpu, cm);
+	if (cpumask_weight(cm) == 0) {
+		cpumask_setall(cm);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
+			cpumask_clear_cpu(cpu, cm);
+		WARN_ON_ONCE(cpumask_weight(cm) == 0);
+	}
+	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
+	rcu_boost_kthread_setaffinity(rnp, cm);
+	free_cpumask_var(cm);
+}
+
+/*
+ * Spawn a per-rcu_node kthread, setting priority and affinity.
+ * Called during boot before online/offline can happen, or, if
+ * during runtime, with the main CPU-hotplug locks held.  So only
+ * one of these can be executing at a time.
+ */
+static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
+						struct rcu_node *rnp)
+{
+	unsigned long flags;
+	int rnp_index = rnp - &rsp->node[0];
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    rnp->qsmaskinit == 0)
+		return 0;
+	if (rnp->node_kthread_task == NULL) {
+		t = kthread_create(rcu_node_kthread, (void *)rnp,
+				   "rcun%d", rnp_index);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rnp->node_kthread_task = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		sp.sched_priority = 99;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+		wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
+	}
+	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
+}
+
+/*
+ * Spawn all kthreads -- called as soon as the scheduler is running.
+ */
+static int __init rcu_spawn_kthreads(void)
+{
+	int cpu;
+	struct rcu_node *rnp;
+
+	rcu_kthreads_spawnable = 1;
+	for_each_possible_cpu(cpu) {
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+		if (cpu_online(cpu))
+			(void)rcu_spawn_one_cpu_kthread(cpu);
+	}
+	rnp = rcu_get_root(rcu_state);
+	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	if (NUM_RCU_NODES > 1) {
+		rcu_for_each_leaf_node(rcu_state, rnp)
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	}
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
+static void __cpuinit rcu_prepare_kthreads(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+
+	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
+	if (rcu_kthreads_spawnable) {
+		(void)rcu_spawn_one_cpu_kthread(cpu);
+		if (rnp->node_kthread_task == NULL)
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	}
 }
 
 #else /* #ifdef CONFIG_RCU_BOOST */
@@ -1315,23 +1701,32 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
-static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
-					  cpumask_var_t cm)
+static void invoke_rcu_callbacks_kthread(void)
 {
+	WARN_ON_ONCE(1);
 }
 
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
-static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
-						 struct rcu_node *rnp,
-						 int rnp_index)
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void rcu_stop_cpu_kthread(int cpu)
+{
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
+{
+}
+
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
 {
-	return 0;
 }
 
-static void __cpuinit rcu_wake_one_boost_kthread(struct rcu_node *rnp)
+static void __cpuinit rcu_prepare_kthreads(int cpu)
 {
 }
 
@@ -1509,7 +1904,7 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * invoke_rcu_cpu_kthread() to cause rcu_process_callbacks() to be invoked
+ * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
  * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
@@ -1560,7 +1955,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		invoke_rcu_cpu_kthread();
+		invoke_rcu_core();
 	return c;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..4e14487 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,8 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+#ifdef CONFIG_RCU_BOOST
+
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
@@ -58,6 +60,8 @@ static char convert_kthread_status(unsigned int kthread_status)
 	return "SRWOY"[kthread_status];
 }
 
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -76,7 +80,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d ktl=%x b=%ld",
+	seq_printf(m, " ql=%ld qs=%c%c%c%c",
 		   rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -84,13 +88,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 			rdp->nxttail[RCU_NEXT_READY_TAIL]],
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, " kt=%d/%c/%d ktl=%x",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
 		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
-		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff,
-		   rdp->blimit);
+		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_printf(m, " b=%ld", rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -147,18 +154,21 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,\"%c%c%c%c\",%d,\"%c\",%ld", rdp->qlen,
+	seq_printf(m, ",%ld,\"%c%c%c%c\"", rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
 		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
 			rdp->nxttail[RCU_NEXT_READY_TAIL]],
 		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
 			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
+		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, ",%d,\"%c\"",
 		   per_cpu(rcu_cpu_has_work, rdp->cpu),
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
-					  rdp->cpu)),
-		   rdp->blimit);
+					  rdp->cpu)));
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_printf(m, ",%ld", rdp->blimit);
 	seq_printf(m, ",%lu,%lu,%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
@@ -169,7 +179,11 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
+	seq_puts(m, "\"of\",\"ri\",\"ql\",\"qs\"");
+#ifdef CONFIG_RCU_BOOST
+	seq_puts(m, "\"kt\",\"ktl\"");
+#endif /* #ifdef CONFIG_RCU_BOOST */
+	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	seq_puts(m, "\"rcu_preempt:\"\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 1396017..40cf63d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -58,7 +58,7 @@ DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
-	"TASKLET", "SCHED", "HRTIMER"
+	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
 /*
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1e88485..0a7ed5b 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2187,6 +2187,7 @@ static const struct flag flags[] = {
 	{ "TASKLET_SOFTIRQ", 6 },
 	{ "SCHED_SOFTIRQ", 7 },
 	{ "HRTIMER_SOFTIRQ", 8 },
+	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
