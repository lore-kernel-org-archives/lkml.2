Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1BWBl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:56 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37304 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1BWBjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq to kthread
Date: Tue, 22 Feb 2011 17:39:40 -0800
Message-Id: <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

If RCU priority boosting is to be meaningful, callback invocation must
be boosted in addition to preempted RCU readers.  Otherwise, in presence
of CPU real-time threads, the grace period ends, but the callbacks don't
get invoked.  If the callbacks don't get invoked, the associated memory
doesn't get freed, so the system is still subject to OOM.

But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
moves the callback invocations to a kthread, which can be boosted easily.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/interrupt.h           |    1 -
 include/trace/events/irq.h          |    3 +-
 kernel/rcutree.c                    |  324 ++++++++++++++++++++++++++++++++++-
 kernel/rcutree.h                    |    8 +
 kernel/rcutree_plugin.h             |    4 +-
 tools/perf/util/trace-event-parse.c |    1 -
 6 files changed, 331 insertions(+), 10 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 79d0c4f..ed47deb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -385,7 +385,6 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
-	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1c09820..ae045ca 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -20,8 +20,7 @@ struct softirq_action;
 			 softirq_name(BLOCK_IOPOLL),	\
 			 softirq_name(TASKLET),		\
 			 softirq_name(SCHED),		\
-			 softirq_name(HRTIMER),		\
-			 softirq_name(RCU))
+			 softirq_name(HRTIMER))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0ac1cc0..2241f28 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -47,6 +47,8 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 #include <linux/kernel_stat.h>
+#include <linux/wait.h>
+#include <linux/kthread.h>
 
 #include "rcutree.h"
 
@@ -82,6 +84,18 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+/* Control variables for per-CPU and per-rcu_node kthreads. */
+
+static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
+static DEFINE_PER_CPU(char, rcu_cpu_has_work);
+static char rcu_kthreads_spawnable;
+
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp);
+static void invoke_rcu_kthread(void);
+
+#define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
+
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -1018,6 +1032,12 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
 
+	/* Stop the CPU's kthread. */
+	if (per_cpu(rcu_cpu_kthread_task, cpu) != NULL) {
+		kthread_stop(per_cpu(rcu_cpu_kthread_task, cpu));
+		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
+	}
+
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
@@ -1054,6 +1074,18 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
+
+	/*
+	 * If there are no more online CPUs for this rcu_node structure,
+	 * kill the rcu_node structure's kthread.  Otherwise, adjust its
+	 * affinity.
+	 */
+	if (rnp->node_kthread_task != NULL &&
+	    rnp->qsmaskinit == 0) {
+		kthread_stop(rnp->node_kthread_task);
+		rnp->node_kthread_task = NULL;
+	} else
+		rcu_node_kthread_setaffinity(rnp);
 }
 
 /*
@@ -1151,7 +1183,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 }
 
 /*
@@ -1197,7 +1229,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 }
 
 #ifdef CONFIG_SMP
@@ -1361,7 +1393,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Do softirq processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
@@ -1372,6 +1404,272 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	rcu_needs_cpu_flush();
 }
 
+/*
+ * Wake up the current CPU's kthread.  This replaces raise_softirq()
+ * in earlier versions of RCU.
+ */
+static void invoke_rcu_kthread(void)
+{
+	unsigned long flags;
+	wait_queue_head_t *q;
+	int cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
+		local_irq_restore(flags);
+		return;
+	}
+	per_cpu(rcu_cpu_has_work, cpu) = 1;
+	q = &per_cpu(rcu_cpu_wq, cpu);
+	wake_up(q);
+	local_irq_restore(flags);
+}
+
+/*
+ * Timer handler to initiate the waking up of per-CPU kthreads that
+ * have yielded the CPU due to excess numbers of RCU callbacks.
+ */
+static void rcu_cpu_kthread_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct rcu_data *rdp = (struct rcu_data *)arg;
+	struct rcu_node *rnp = rdp->mynode;
+	struct task_struct *t;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->wakemask |= rdp->grpmask;
+	t = rnp->node_kthread_task;
+	if (t == NULL) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	wake_up_process(t);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Drop to non-real-time priority and yield, but only after posting a
+ * timer that will cause us to regain our real-time priority if we
+ * remain preempted.  Either way, we restore our real-time priority
+ * before returning.
+ */
+static void rcu_yield(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
+	struct sched_param sp;
+	struct timer_list yield_timer;
+
+	setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);
+	mod_timer(&yield_timer, jiffies + 2);
+	sp.sched_priority = 0;
+	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
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
+	while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
+		if (kthread_should_stop())
+			return 1;
+		local_bh_enable();
+		schedule_timeout_uninterruptible(1);
+		if (smp_processor_id() != cpu)
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+		local_bh_disable();
+	}
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
+	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
+	char work;
+	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
+
+	for (;;) {
+		wait_event_interruptible(*wqp,
+					 *workp != 0 || kthread_should_stop());
+		local_bh_disable();
+		if (rcu_cpu_kthread_should_stop(cpu)) {
+			local_bh_enable();
+			break;
+		}
+		local_irq_save(flags);
+		work = *workp;
+		*workp = 0;
+		local_irq_restore(flags);
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp != 0)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			rcu_yield(cpu);
+			spincnt = 0;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Spawn a per-CPU kthread, setting up affinity and priority.
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
+	kthread_bind(t, cpu);
+	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
+	per_cpu(rcu_cpu_kthread_task, cpu) = t;
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+/*
+ * Per-rcu_node kthread, which is in charge of waking up the per-CPU
+ * kthreads when needed.
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
+		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
+						       kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		mask = rnp->wakemask;
+		rnp->wakemask = 0;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
+			if ((mask & 0x1) == 0)
+				continue;
+			preempt_disable();
+			per_cpu(rcu_cpu_has_work, cpu) = 1;
+			t = per_cpu(rcu_cpu_kthread_task, cpu);
+			if (t == NULL) {
+				preempt_enable();
+				continue;
+			}
+			sp.sched_priority = RCU_KTHREAD_PRIO;
+			sched_setscheduler_nocheck(t, cpu, &sp);
+			wake_up_process(t);
+			preempt_enable();
+		}
+	}
+	return 0;
+}
+
+/*
+ * Set the per-rcu_node kthread's affinity to cover all CPUs that are
+ * served by the rcu_node in question.
+ */
+static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
+{
+	cpumask_var_t cm;
+	int cpu;
+	unsigned long mask = rnp->qsmaskinit;
+
+	if (rnp->node_kthread_task == NULL ||
+	    rnp->qsmaskinit == 0)
+		return;
+	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
+		return;
+	cpumask_clear(cm);
+	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1)
+		if (mask & 01)
+			cpumask_set_cpu(cpu, cm);
+	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
+	free_cpumask_var(cm);
+}
+
+/*
+ * Spawn a per-rcu_node kthread, setting priority and affinity.
+ */
+static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
+						struct rcu_node *rnp)
+{
+	int rnp_index = rnp - &rsp->node[0];
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (!rcu_kthreads_spawnable ||
+	    rnp->qsmaskinit == 0 ||
+	    rnp->node_kthread_task != NULL)
+		return 0;
+	t = kthread_create(rcu_node_kthread, (void *)rnp, "rcun%d", rnp_index);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	rnp->node_kthread_task = t;
+	wake_up_process(t);
+	sp.sched_priority = 99;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
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
+		init_waitqueue_head(&per_cpu(rcu_cpu_wq, cpu));
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+		if (cpu_online(cpu))
+			(void)rcu_spawn_one_cpu_kthread(cpu);
+	}
+	rcu_for_each_leaf_node(&rcu_sched_state, rnp) {
+		init_waitqueue_head(&rnp->node_wq);
+		(void)rcu_spawn_one_node_kthread(&rcu_sched_state, rnp);
+	}
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -1771,6 +2069,19 @@ static void __cpuinit rcu_online_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
+static void __cpuinit rcu_online_kthreads(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+
+	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
+	if (rcu_kthreads_spawnable) {
+		(void)rcu_spawn_one_cpu_kthread(cpu);
+		if (rnp->node_kthread_task == NULL)
+			(void)rcu_spawn_one_node_kthread(&rcu_sched_state, rnp);
+	}
+}
+
 /*
  * Handle CPU online/offline notification events.
  */
@@ -1778,11 +2089,17 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
+		rcu_online_kthreads(cpu);
+		break;
+	case CPU_ONLINE:
+		rcu_node_kthread_setaffinity(rnp);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
@@ -1923,7 +2240,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5a439c1..c021380 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -111,6 +111,7 @@ struct rcu_node {
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
+	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
@@ -134,6 +135,13 @@ struct rcu_node {
 				/*  if there is no such task.  If there */
 				/*  is no current expedited grace period, */
 				/*  then there can cannot be any such task. */
+	struct task_struct *node_kthread_task;
+				/* kthread that takes care of this rcu_node */
+				/*  structure, for example, awakening the */
+				/*  per-CPU kthreads as needed. */
+	wait_queue_head_t node_wq;
+				/* Wait queue on which to park the per-node */
+				/*  kthread. */
 } ____cacheline_internodealigned_in_smp;
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 774f010..b9bd69a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1206,7 +1206,7 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * raise_softirq() to cause rcu_process_callbacks() to be invoked later.
+ * invoke_rcu_kthread() to cause rcu_process_callbacks() to be invoked later.
  * The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
@@ -1257,7 +1257,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 	return c;
 }
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..043c085 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2187,7 +2187,6 @@ static const struct flag flags[] = {
 	{ "TASKLET_SOFTIRQ", 6 },
 	{ "SCHED_SOFTIRQ", 7 },
 	{ "HRTIMER_SOFTIRQ", 8 },
-	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
-- 
1.7.3.2

