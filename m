Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab1EANjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:39:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53799 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1EANWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/86] rcu: priority boosting for TREE_PREEMPT_RCU
Date: Sun,  1 May 2011 06:20:46 -0700
Message-Id: <1304256126-26015-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Add priority boosting for TREE_PREEMPT_RCU, similar to that for
TINY_PREEMPT_RCU.  This is enabled by the default-off RCU_BOOST
kernel parameter.  The priority to which to boost preempted
RCU readers is controlled by the RCU_BOOST_PRIO kernel parameter
(defaulting to real-time priority 1) and the time to wait before
boosting the readers who are blocking a given grace period is
controlled by the RCU_BOOST_DELAY kernel parameter (defaulting to
500 milliseconds).

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |    2 +-
 kernel/rcutree.c        |  115 ++++++++++++------
 kernel/rcutree.h        |   31 +++++-
 kernel/rcutree_plugin.h |  314 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 411 insertions(+), 51 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..8fc00ef 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -485,7 +485,7 @@ config TREE_RCU_TRACE
 
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
-	depends on RT_MUTEXES && TINY_PREEMPT_RCU
+	depends on RT_MUTEXES && PREEMPT_RCU
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97420b6..1ce51b8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -81,6 +81,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+static struct rcu_state *rcu_state;
+
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
@@ -94,7 +96,7 @@ static DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
 
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp);
-static void invoke_rcu_kthread(void);
+static void invoke_rcu_cpu_kthread(void);
 
 #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
 
@@ -791,6 +793,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -826,6 +829,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
+		rcu_preempt_boost_start_gp(rnp);
 		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -882,7 +886,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
-		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+		if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 
 			/* Other bits still set at this level, so done. */
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1089,8 +1093,11 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	t = rnp->node_kthread_task;
 	if (t != NULL &&
 	    rnp->qsmaskinit == 0) {
-		kthread_stop(t);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->node_kthread_task = NULL;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		kthread_stop(t);
+		rcu_stop_boost_kthread(rnp);
 	} else
 		rcu_node_kthread_setaffinity(rnp);
 }
@@ -1190,7 +1197,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
 	if (cpu_has_callbacks_ready_to_invoke(rdp))
-		invoke_rcu_kthread();
+		invoke_rcu_cpu_kthread();
 }
 
 /*
@@ -1236,7 +1243,7 @@ void rcu_check_callbacks(int cpu, int user)
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
-		invoke_rcu_kthread();
+		invoke_rcu_cpu_kthread();
 }
 
 #ifdef CONFIG_SMP
@@ -1244,6 +1251,8 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
+ * Also initiate boosting for any threads blocked on the root rcu_node.
+ *
  * The caller must have suppressed start of new grace periods.
  */
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
@@ -1262,6 +1271,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			return;
 		}
 		if (rnp->qsmask == 0) {
+			rcu_initiate_boost(rnp);
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
@@ -1280,6 +1290,11 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
+	rnp = rcu_get_root(rsp);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (rnp->qsmask == 0)
+		rcu_initiate_boost(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1417,7 +1432,7 @@ static void rcu_process_callbacks(void)
  * the current CPU with interrupts disabled, the rcu_cpu_kthread_task
  * cannot disappear out from under us.
  */
-static void invoke_rcu_kthread(void)
+static void invoke_rcu_cpu_kthread(void)
 {
 	unsigned long flags;
 	wait_queue_head_t *q;
@@ -1436,24 +1451,33 @@ static void invoke_rcu_kthread(void)
 }
 
 /*
+ * Wake up the specified per-rcu_node-structure kthread.
+ * The caller must hold ->lock.
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
  * Timer handler to initiate the waking up of per-CPU kthreads that
  * have yielded the CPU due to excess numbers of RCU callbacks.
+ * We wake up the per-rcu_node kthread, which in turn will wake up
+ * the booster kthread.
  */
 static void rcu_cpu_kthread_timer(unsigned long arg)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = (struct rcu_data *)arg;
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
 	struct rcu_node *rnp = rdp->mynode;
-	struct task_struct *t;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->wakemask |= rdp->grpmask;
-	t = rnp->node_kthread_task;
-	if (t == NULL) {
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
-	}
-	wake_up_process(t);
+	invoke_rcu_node_kthread(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -1463,13 +1487,12 @@ static void rcu_cpu_kthread_timer(unsigned long arg)
  * remain preempted.  Either way, we restore our real-time priority
  * before returning.
  */
-static void rcu_yield(int cpu)
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 {
-	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
 	struct sched_param sp;
 	struct timer_list yield_timer;
 
-	setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);
+	setup_timer(&yield_timer, f, arg);
 	mod_timer(&yield_timer, jiffies + 2);
 	sp.sched_priority = 0;
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
@@ -1540,7 +1563,7 @@ static int rcu_cpu_kthread(void *arg)
 		else
 			spincnt = 0;
 		if (spincnt > 10) {
-			rcu_yield(cpu);
+			rcu_yield(rcu_cpu_kthread_timer, (unsigned long)cpu);
 			spincnt = 0;
 		}
 	}
@@ -1597,6 +1620,7 @@ static int rcu_node_kthread(void *arg)
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = rnp->wakemask;
 		rnp->wakemask = 0;
+		rcu_initiate_boost(rnp);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
@@ -1618,7 +1642,8 @@ static int rcu_node_kthread(void *arg)
 
 /*
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
- * served by the rcu_node in question.
+ * served by the rcu_node in question.  The CPU hotplug lock is still
+ * held, so the value of rnp->qsmaskinit will be stable.
  */
 static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
 {
@@ -1626,8 +1651,7 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
 	int cpu;
 	unsigned long mask = rnp->qsmaskinit;
 
-	if (rnp->node_kthread_task == NULL ||
-	    rnp->qsmaskinit == 0)
+	if (rnp->node_kthread_task == NULL || mask == 0)
 		return;
 	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
 		return;
@@ -1636,31 +1660,40 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
 		if (mask & 0x1)
 			cpumask_set_cpu(cpu, cm);
 	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
+	rcu_boost_kthread_setaffinity(rnp, cm);
 	free_cpumask_var(cm);
 }
 
 /*
  * Spawn a per-rcu_node kthread, setting priority and affinity.
+ * Called during boot before online/offline can happen, or, if
+ * during runtime, with the main CPU-hotplug locks held.  So only
+ * one of these can be executing at a time.
  */
 static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
 						struct rcu_node *rnp)
 {
+	unsigned long flags;
 	int rnp_index = rnp - &rsp->node[0];
 	struct sched_param sp;
 	struct task_struct *t;
 
 	if (!rcu_kthreads_spawnable ||
-	    rnp->qsmaskinit == 0 ||
-	    rnp->node_kthread_task != NULL)
+	    rnp->qsmaskinit == 0)
 		return 0;
-	t = kthread_create(rcu_node_kthread, (void *)rnp, "rcun%d", rnp_index);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
-	rnp->node_kthread_task = t;
-	wake_up_process(t);
-	sp.sched_priority = 99;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	return 0;
+	if (rnp->node_kthread_task == NULL) {
+		t = kthread_create(rcu_node_kthread, (void *)rnp,
+				   "rcun%d", rnp_index);
+		if (IS_ERR(t))
+			return PTR_ERR(t);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rnp->node_kthread_task = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		wake_up_process(t);
+		sp.sched_priority = 99;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	}
+	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
 }
 
 /*
@@ -1678,10 +1711,16 @@ static int __init rcu_spawn_kthreads(void)
 		if (cpu_online(cpu))
 			(void)rcu_spawn_one_cpu_kthread(cpu);
 	}
-	rcu_for_each_leaf_node(&rcu_sched_state, rnp) {
-		init_waitqueue_head(&rnp->node_wq);
-		(void)rcu_spawn_one_node_kthread(&rcu_sched_state, rnp);
-	}
+	rnp = rcu_get_root(rcu_state);
+	init_waitqueue_head(&rnp->node_wq);
+	rcu_init_boost_waitqueue(rnp);
+	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+	if (NUM_RCU_NODES > 1)
+		rcu_for_each_leaf_node(rcu_state, rnp) {
+			init_waitqueue_head(&rnp->node_wq);
+			rcu_init_boost_waitqueue(rnp);
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
+		}
 	return 0;
 }
 early_initcall(rcu_spawn_kthreads);
@@ -2087,14 +2126,14 @@ static void __cpuinit rcu_online_cpu(int cpu)
 
 static void __cpuinit rcu_online_kthreads(int cpu)
 {
-	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
 	/* Fire up the incoming CPU's kthread and leaf rcu_node kthread. */
 	if (rcu_kthreads_spawnable) {
 		(void)rcu_spawn_one_cpu_kthread(cpu);
 		if (rnp->node_kthread_task == NULL)
-			(void)rcu_spawn_one_node_kthread(&rcu_sched_state, rnp);
+			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
 	}
 }
 
@@ -2105,7 +2144,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
-	struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
 	switch (action) {
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c021380..8db0cdc 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -135,6 +135,24 @@ struct rcu_node {
 				/*  if there is no such task.  If there */
 				/*  is no current expedited grace period, */
 				/*  then there can cannot be any such task. */
+#ifdef CONFIG_RCU_BOOST
+	struct list_head *boost_tasks;
+				/* Pointer to first task that needs to be */
+				/*  priority boosted, or NULL if no priority */
+				/*  boosting is needed for this rcu_node */
+				/*  structure.  If there are no tasks */
+				/*  queued on this rcu_node structure that */
+				/*  are blocking the current grace period, */
+				/*  there can be no such task. */
+	unsigned long boost_time;
+				/* When to start boosting (jiffies). */
+	struct task_struct *boost_kthread_task;
+				/* kthread that takes care of priority */
+				/*  boosting for this rcu_node structure. */
+	wait_queue_head_t boost_wq;
+				/* Wait queue on which to park the boost */
+				/*  kthread. */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	struct task_struct *node_kthread_task;
 				/* kthread that takes care of this rcu_node */
 				/*  structure, for example, awakening the */
@@ -365,7 +383,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
-static int rcu_preempted_readers(struct rcu_node *rnp);
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
@@ -392,5 +410,16 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
+static void rcu_initiate_boost(struct rcu_node *rnp);
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index);
+#ifdef CONFIG_HOTPLUG_CPU
+static void rcu_stop_boost_kthread(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b9bd69a..5964f82 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -66,6 +66,7 @@ static void __init rcu_bootup_announce_oddness(void)
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+static struct rcu_state *rcu_state = &rcu_preempt_state;
 
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
@@ -179,6 +180,10 @@ static void rcu_preempt_note_context_switch(int cpu)
 		if ((rnp->qsmask & rdp->grpmask) && rnp->gp_tasks != NULL) {
 			list_add(&t->rcu_node_entry, rnp->gp_tasks->prev);
 			rnp->gp_tasks = &t->rcu_node_entry;
+#ifdef CONFIG_RCU_BOOST
+			if (rnp->boost_tasks != NULL)
+				rnp->boost_tasks = rnp->gp_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		} else {
 			list_add(&t->rcu_node_entry, &rnp->blkd_tasks);
 			if (rnp->qsmask & rdp->grpmask)
@@ -218,7 +223,7 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
 	return rnp->gp_tasks != NULL;
 }
@@ -236,7 +241,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	unsigned long mask;
 	struct rcu_node *rnp_p;
 
-	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;  /* Still need more quiescent states! */
 	}
@@ -325,7 +330,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
-		empty = !rcu_preempted_readers(rnp);
+		empty = !rcu_preempt_blocked_readers_cgp(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		np = rcu_next_node_entry(t, rnp);
@@ -334,6 +339,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			rnp->gp_tasks = np;
 		if (&t->rcu_node_entry == rnp->exp_tasks)
 			rnp->exp_tasks = np;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp->boost_tasks = np;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
 		/*
@@ -346,6 +355,15 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
 
+#ifdef CONFIG_RCU_BOOST
+		/* Unboost if we were boosted. */
+		if (special & RCU_READ_UNLOCK_BOOSTED) {
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
+			rt_mutex_unlock(t->rcu_boost_mutex);
+			t->rcu_boost_mutex = NULL;
+		}
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 		/*
 		 * If this was the last task on the expedited lists,
 		 * then we need to report up the rcu_node hierarchy.
@@ -391,7 +409,7 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 	unsigned long flags;
 	struct task_struct *t;
 
-	if (!rcu_preempted_readers(rnp))
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	t = list_entry(rnp->gp_tasks,
@@ -430,7 +448,7 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 	struct task_struct *t;
 
-	if (!rcu_preempted_readers(rnp))
+	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return;
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
@@ -460,7 +478,7 @@ static void rcu_preempt_stall_reset(void)
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
-	WARN_ON_ONCE(rcu_preempted_readers(rnp));
+	WARN_ON_ONCE(rcu_preempt_blocked_readers_cgp(rnp));
 	if (!list_empty(&rnp->blkd_tasks))
 		rnp->gp_tasks = rnp->blkd_tasks.next;
 	WARN_ON_ONCE(rnp->qsmask);
@@ -509,7 +527,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * absolutely necessary, but this is a good performance/complexity
 	 * tradeoff.
 	 */
-	if (rcu_preempted_readers(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp))
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
@@ -525,8 +543,22 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 			rnp_root->gp_tasks = rnp->gp_tasks;
 		if (&t->rcu_node_entry == rnp->exp_tasks)
 			rnp_root->exp_tasks = rnp->exp_tasks;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rnp->boost_tasks)
+			rnp_root->boost_tasks = rnp->boost_tasks;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
+
+#ifdef CONFIG_RCU_BOOST
+	/* In case root is being boosted and leaf is not. */
+	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+	if (rnp_root->boost_tasks != NULL &&
+	    rnp_root->boost_tasks != rnp_root->gp_tasks)
+		rnp_root->boost_tasks = rnp_root->gp_tasks;
+	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 	rnp->gp_tasks = NULL;
 	rnp->exp_tasks = NULL;
 	return retval;
@@ -684,6 +716,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 	raw_spin_lock(&rnp->lock); /* irqs already disabled */
 	if (!list_empty(&rnp->blkd_tasks)) {
 		rnp->exp_tasks = rnp->blkd_tasks.next;
+		rcu_initiate_boost(rnp);
 		must_wait = 1;
 	}
 	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
@@ -830,6 +863,8 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+static struct rcu_state *rcu_state = &rcu_sched_state;
+
 /*
  * Tell them what RCU they are running.
  */
@@ -870,7 +905,7 @@ static void rcu_preempt_note_context_switch(int cpu)
  * Because preemptable RCU does not exist, there are never any preempted
  * RCU readers.
  */
-static int rcu_preempted_readers(struct rcu_node *rnp)
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
 	return 0;
 }
@@ -1034,6 +1069,263 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+
+#include "rtmutex_common.h"
+
+/*
+ * Carry out RCU priority boosting on the task indicated by ->exp_tasks
+ * or ->boost_tasks, advancing the pointer to the next task in the
+ * ->blkd_tasks list.
+ *
+ * Note that irqs must be enabled: boosting the task can block.
+ * Returns 1 if there are more tasks needing to be boosted.
+ */
+static int rcu_boost(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct rt_mutex mtx;
+	struct task_struct *t;
+	struct list_head *tb;
+
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
+		return 0;  /* Nothing left to boost. */
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+
+	/*
+	 * Recheck under the lock: all tasks in need of boosting
+	 * might exit their RCU read-side critical sections on their own.
+	 */
+	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return 0;
+	}
+
+	/*
+	 * Preferentially boost tasks blocking expedited grace periods.
+	 * This cannot starve the normal grace periods because a second
+	 * expedited grace period must boost all blocked tasks, including
+	 * those blocking the pre-existing normal grace period.
+	 */
+	if (rnp->exp_tasks != NULL)
+		tb = rnp->exp_tasks;
+	else
+		tb = rnp->boost_tasks;
+
+	/*
+	 * We boost task t by manufacturing an rt_mutex that appears to
+	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * task t can find it, and task t will release the mutex when it
+	 * exits its outermost RCU read-side critical section.  Then
+	 * simply acquiring this artificial rt_mutex will boost task
+	 * t's priority.  (Thanks to tglx for suggesting this approach!)
+	 *
+	 * Note that task t must acquire rnp->lock to remove itself from
+	 * the ->blkd_tasks list, which it will do from exit() if from
+	 * nowhere else.  We therefore are guaranteed that task t will
+	 * stay around at least until we drop rnp->lock.  Note that
+	 * rnp->lock also resolves races between our priority boosting
+	 * and task t's exiting its outermost RCU read-side critical
+	 * section.
+	 */
+	t = container_of(tb, struct task_struct, rcu_node_entry);
+	rt_mutex_init_proxy_locked(&mtx, t);
+	t->rcu_boost_mutex = &mtx;
+	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
+	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
+}
+
+/*
+ * Timer handler to initiate waking up of boost kthreads that
+ * have yielded the CPU due to excessive numbers of tasks to
+ * boost.  We wake up the per-rcu_node kthread, which in turn
+ * will wake up the booster kthread.
+ */
+static void rcu_boost_kthread_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	invoke_rcu_node_kthread(rnp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Priority-boosting kthread.  One per leaf rcu_node and one for the
+ * root rcu_node.
+ */
+static int rcu_boost_kthread(void *arg)
+{
+	struct rcu_node *rnp = (struct rcu_node *)arg;
+	int spincnt = 0;
+	int more2boost;
+
+	for (;;) {
+		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
+							rnp->exp_tasks ||
+							kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+		more2boost = rcu_boost(rnp);
+		if (more2boost)
+			spincnt++;
+		else
+			spincnt = 0;
+		if (spincnt > 10) {
+			rcu_yield(rcu_boost_kthread_timer, (unsigned long)rnp);
+			spincnt = 0;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Check to see if it is time to start boosting RCU readers that are
+ * blocking the current grace period, and, if so, tell the per-rcu_node
+ * kthread to start boosting them.  If there is an expedited grace
+ * period in progress, it is always time to boost.
+ *
+ * The caller must hold rnp->lock.
+ */
+static void rcu_initiate_boost(struct rcu_node *rnp)
+{
+	struct task_struct *t;
+
+	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL)
+		return;
+	if (rnp->exp_tasks != NULL ||
+	    (rnp->gp_tasks != NULL &&
+	     rnp->boost_tasks == NULL &&
+	     rnp->qsmask == 0 &&
+	     ULONG_CMP_GE(jiffies, rnp->boost_time))) {
+		if (rnp->exp_tasks == NULL)
+			rnp->boost_tasks = rnp->gp_tasks;
+		t = rnp->boost_kthread_task;
+		if (t != NULL)
+			wake_up_process(t);
+	}
+}
+
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+	unsigned long flags;
+	struct task_struct *t;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = rnp->boost_kthread_task;
+	if (t != NULL)
+		set_cpus_allowed_ptr(rnp->boost_kthread_task, cm);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
+
+/*
+ * Do priority-boost accounting for the start of a new grace period.
+ */
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+	rnp->boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
+}
+
+/*
+ * Initialize the RCU-boost waitqueue.
+ */
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+	init_waitqueue_head(&rnp->boost_wq);
+}
+
+/*
+ * Create an RCU-boost kthread for the specified node if one does not
+ * already exist.  We only create this kthread for preemptible RCU.
+ * Returns zero if all is well, a negated errno otherwise.
+ */
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	unsigned long flags;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	if (&rcu_preempt_state != rsp)
+		return 0;
+	if (rnp->boost_kthread_task != NULL)
+		return 0;
+	t = kthread_create(rcu_boost_kthread, (void *)rnp,
+			   "rcub%d", rnp_index);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	rnp->boost_kthread_task = t;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up_process(t);
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void rcu_stop_boost_kthread(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct task_struct *t;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = rnp->boost_kthread_task;
+	rnp->boost_kthread_task = NULL;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (t != NULL)
+		kthread_stop(t);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_initiate_boost(struct rcu_node *rnp)
+{
+}
+
+static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
+					  cpumask_var_t cm)
+{
+}
+
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
+{
+}
+
+static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp)
+{
+}
+
+static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
+						 struct rcu_node *rnp,
+						 int rnp_index)
+{
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void rcu_stop_boost_kthread(struct rcu_node *rnp)
+{
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 #ifndef CONFIG_SMP
 
 void synchronize_sched_expedited(void)
@@ -1206,8 +1498,8 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
  *
  * Because it is not legal to invoke rcu_process_callbacks() with irqs
  * disabled, we do one pass of force_quiescent_state(), then do a
- * invoke_rcu_kthread() to cause rcu_process_callbacks() to be invoked later.
- * The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ * invoke_rcu_cpu_kthread() to cause rcu_process_callbacks() to be invoked
+ * later.  The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
 {
@@ -1257,7 +1549,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
 	if (c)
-		invoke_rcu_kthread();
+		invoke_rcu_cpu_kthread();
 	return c;
 }
 
-- 
1.7.3.2

