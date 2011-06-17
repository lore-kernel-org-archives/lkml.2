Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1FQABl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:01:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41634 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1FQABi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:01:38 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/2] rcu: Move RCU_BOOST #ifdefs to header file
Date: Thu, 16 Jun 2011 17:00:50 -0700
Message-Id: <1308268850-16210-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110617000019.GA15881@linux.vnet.ibm.com>
References: <20110617000019.GA15881@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The commit "use softirq instead of kthreads except when RCU_BOOST=y"
just applied #ifdef in place.  This commit is a cleanup that moves
the newly #ifdef'ed code to the header file kernel/rcutree_plugin.h.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |  383 +----------------------------------------------
 kernel/rcutree.h        |    5 +
 kernel/rcutree_plugin.h |  384 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+), 382 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 429d494..7e59ffb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1093,16 +1093,8 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
-#ifdef CONFIG_RCU_BOOST
-	struct task_struct *t;
 
-	/* Stop the CPU's kthread. */
-	t = per_cpu(rcu_cpu_kthread_task, cpu);
-	if (t != NULL) {
-		per_cpu(rcu_cpu_kthread_task, cpu) = NULL;
-		kthread_stop(t);
-	}
-#endif /* #ifdef CONFIG_RCU_BOOST */
+	rcu_stop_cpu_kthread(cpu);
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -1453,17 +1445,6 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 		invoke_rcu_callbacks(rsp, rdp);
 }
 
-#ifdef CONFIG_RCU_BOOST
-
-static void rcu_kthread_do_work(void)
-{
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
-	rcu_preempt_do_callbacks();
-}
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 /*
  * Do softirq processing for the current CPU.
  */
@@ -1498,345 +1479,6 @@ static void invoke_rcu_core(void)
 	raise_softirq(RCU_SOFTIRQ);
 }
 
-#ifdef CONFIG_RCU_BOOST
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
-			rcu_kthread_do_work();
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
- *
- * Please note that we cannot simply refuse to wake up the per-CPU
- * kthread because kthreads are created in TASK_UNINTERRUPTIBLE state,
- * which can result in softlockup complaints if the task ends up being
- * idle for more than a couple of minutes.
- *
- * However, please note also that we cannot bind the per-CPU kthread to its
- * CPU until that CPU is fully online.  We also cannot wait until the
- * CPU is fully online before we create its per-CPU kthread, as this would
- * deadlock the system when CPU notifiers tried waiting for grace
- * periods.  So we bind the per-CPU kthread to its CPU only if the CPU
- * is online.  If its CPU is not yet fully online, then the code in
- * rcu_cpu_kthread() will wait until it is fully online, and then do
- * the binding.
- */
-static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
-{
-	struct sched_param sp;
-	struct task_struct *t;
-
-	if (!rcu_kthreads_spawnable ||
-	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
-		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
-	if (IS_ERR(t))
-		return PTR_ERR(t);
-	if (cpu_online(cpu))
-		kthread_bind(t, cpu);
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
-	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-	per_cpu(rcu_cpu_kthread_task, cpu) = t;
-	wake_up_process(t); /* Get to TASK_INTERRUPTIBLE quickly. */
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
-		return;
-	cpumask_clear(cm);
-	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
-		if ((mask & 0x1) && cpu != outgoingcpu)
-			cpumask_set_cpu(cpu, cm);
-	if (cpumask_weight(cm) == 0) {
-		cpumask_setall(cm);
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
-			cpumask_clear_cpu(cpu, cm);
-		WARN_ON_ONCE(cpumask_weight(cm) == 0);
-	}
-	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
-	rcu_boost_kthread_setaffinity(rnp, cm);
-	free_cpumask_var(cm);
-}
-
-/*
- * Spawn a per-rcu_node kthread, setting priority and affinity.
- * Called during boot before online/offline can happen, or, if
- * during runtime, with the main CPU-hotplug locks held.  So only
- * one of these can be executing at a time.
- */
-static int __cpuinit rcu_spawn_one_node_kthread(struct rcu_state *rsp,
-						struct rcu_node *rnp)
-{
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
-		wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
-	}
-	return rcu_spawn_one_boost_kthread(rsp, rnp, rnp_index);
-}
-
-/*
- * Spawn all kthreads -- called as soon as the scheduler is running.
- */
-static int __init rcu_spawn_kthreads(void)
-{
-	int cpu;
-	struct rcu_node *rnp;
-
-	rcu_kthreads_spawnable = 1;
-	for_each_possible_cpu(cpu) {
-		per_cpu(rcu_cpu_has_work, cpu) = 0;
-		if (cpu_online(cpu))
-			(void)rcu_spawn_one_cpu_kthread(cpu);
-	}
-	rnp = rcu_get_root(rcu_state);
-	(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	if (NUM_RCU_NODES > 1) {
-		rcu_for_each_leaf_node(rcu_state, rnp)
-			(void)rcu_spawn_one_node_kthread(rcu_state, rnp);
-	}
-	return 0;
-}
-early_initcall(rcu_spawn_kthreads);
-
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
-{
-}
-
-static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
-
 static void
 __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	   struct rcu_state *rsp)
@@ -2243,29 +1885,6 @@ static void __cpuinit rcu_prepare_cpu(int cpu)
 	rcu_preempt_init_percpu_data(cpu);
 }
 
-#ifdef CONFIG_RCU_BOOST
-
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
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-static void __cpuinit rcu_prepare_kthreads(int cpu)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
-
 /*
  * Handle CPU online/offline notification events.
  */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 434288c..01b2ccd 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -427,6 +427,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
+static void rcu_stop_cpu_kthread(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
@@ -460,6 +461,10 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index);
+static void invoke_rcu_node_kthread(struct rcu_node *rnp);
+static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 #endif /* #ifdef CONFIG_RCU_BOOST */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
+static void __cpuinit rcu_prepare_kthreads(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2772386..14dc7dd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1330,6 +1330,370 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Stop the RCU's per-CPU kthread when its CPU goes offline,.
+ */
+static void rcu_stop_cpu_kthread(int cpu)
+{
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
+}
+
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
@@ -1346,6 +1710,26 @@ static void rcu_preempt_boost_start_gp(struct rcu_node *rnp)
 {
 }
 
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
+{
+}
+
+static void __cpuinit rcu_prepare_kthreads(int cpu)
+{
+}
+
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifndef CONFIG_SMP
-- 
1.7.3.2

