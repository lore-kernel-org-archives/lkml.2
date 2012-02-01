Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2BATqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:46:07 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55797 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab2BATpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:45:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/41] rcu: Simplify offline processing
Date: Wed,  1 Feb 2012 11:41:30 -0800
Message-Id: <1328125319-5205-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F303CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Move ->qsmaskinit and blkd_tasks[] manipulation to the CPU_DYING
notifier.  This simplifies the code by eliminating a potential
deadlock and by reducing the responsibilities of force_quiescent_state().
Also rename functions to make their connection to the CPU-hotplug
stages explicit.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |  160 ++++++++++++++++++++++-------------------------
 kernel/rcutree.h        |    4 +-
 kernel/rcutree_plugin.h |   25 ++++----
 3 files changed, 90 insertions(+), 99 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 96c1c4a..9040cb6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -943,6 +943,10 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
  * be disabled.
+ *
+ * Note that it is legal for a dying CPU (which is marked as offline) to
+ * invoke this function.  This can happen when the dying CPU reports its
+ * quiescent state.
  */
 static void
 rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
@@ -1245,118 +1249,101 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 
 /*
  * Move a dying CPU's RCU callbacks to online CPU's callback list.
- * Synchronization is not required because this function executes
- * in stop_machine() context.
+ * Also record a quiescent state for this CPU for the current grace period.
+ * Synchronization and interrupt disabling are not required because
+ * this function executes in stop_machine() context.  Therefore, cleanup
+ * operations that might block must be done later from the CPU_DEAD
+ * notifier.
+ *
+ * Note that the outgoing CPU's bit has already been cleared in the
+ * cpu_online_mask.  This allows us to randomly pick a callback
+ * destination from the bits set in that mask.
  */
-static void rcu_send_cbs_to_online(struct rcu_state *rsp)
+static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
+	unsigned long flags;
 	int i;
-	/* current DYING CPU is cleared in the cpu_online_mask */
+	unsigned long mask;
+	int need_report;
 	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
+	struct rcu_node *rnp = rdp->mynode; /* For dying CPU. */
+
+	/* Move callbacks to some other CPU. */
+	if (rdp->nxtlist != NULL) {
+		*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		receive_rdp->nxttail[RCU_NEXT_TAIL] =
+				rdp->nxttail[RCU_NEXT_TAIL];
+		receive_rdp->qlen_lazy += rdp->qlen_lazy;
+		receive_rdp->qlen += rdp->qlen;
+		receive_rdp->n_cbs_adopted += rdp->qlen;
+		rdp->n_cbs_orphaned += rdp->qlen;
+
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+		rdp->qlen_lazy = 0;
+		rdp->qlen = 0;
+	}
 
-	if (rdp->nxtlist == NULL)
-		return;  /* irqs disabled, so comparison is stable. */
-
-	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
-	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	receive_rdp->qlen_lazy += rdp->qlen_lazy;
-	receive_rdp->qlen += rdp->qlen;
-	receive_rdp->n_cbs_adopted += rdp->qlen;
-	rdp->n_cbs_orphaned += rdp->qlen;
-
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
-	rdp->qlen_lazy = 0;
-	rdp->qlen = 0;
-}
-
-/*
- * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
- * and move all callbacks from the outgoing CPU to the current one.
- * There can only be one CPU hotplug operation at a time, so no other
- * CPU can be attempting to update rcu_cpu_kthread_task.
- */
-static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
-{
-	unsigned long flags;
-	unsigned long mask;
-	int need_report = 0;
-	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-	struct rcu_node *rnp;
-
-	rcu_stop_cpu_kthread(cpu);
-
-	/* Exclude any attempts to start a new grace period. */
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-
-	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
+	/* Record a quiescent state for the dying CPU. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	trace_rcu_grace_period(rsp->name,
+			       rnp->gpnum + 1 - !!(rnp->qsmask & mask),
+			       "cpuofl");
+	rcu_report_qs_rdp(smp_processor_id(), rsp, rdp, rsp->gpnum);
+	/* Note that rcu_report_qs_rdp() might call trace_rcu_grace_period(). */
+
+	/*
+	 * Remove the dying CPU from the bitmasks in the rcu_node
+	 * hierarchy.  Because we are in stop_machine() context, we
+	 * automatically exclude ->onofflock critical sections.
+	 */
 	do {
-		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
-			if (rnp != rdp->mynode)
-				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-			else
-				trace_rcu_grace_period(rsp->name,
-						       rnp->gpnum + 1 -
-						       !!(rnp->qsmask & mask),
-						       "cpuofl");
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
 		}
 		if (rnp == rdp->mynode) {
-			trace_rcu_grace_period(rsp->name,
-					       rnp->gpnum + 1 -
-					       !!(rnp->qsmask & mask),
-					       "cpuofl");
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+			if (need_report & RCU_OFL_TASKS_NORM_GP)
+				rcu_report_unblock_qs_rnp(rnp, flags);
+			else
+				raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			if (need_report & RCU_OFL_TASKS_EXP_GP)
+				rcu_report_exp_rnp(rsp, rnp, true);
 		} else
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
 	} while (rnp != NULL);
-
-	/*
-	 * We still hold the leaf rcu_node structure lock here, and
-	 * irqs are still disabled.  The reason for this subterfuge is
-	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
-	 * held leads to deadlock.
-	 */
-	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
-	rnp = rdp->mynode;
-	if (need_report & RCU_OFL_TASKS_NORM_GP)
-		rcu_report_unblock_qs_rnp(rnp, flags);
-	else
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	if (need_report & RCU_OFL_TASKS_EXP_GP)
-		rcu_report_exp_rnp(rsp, rnp, true);
-	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 /*
- * Remove the specified CPU from the RCU hierarchy and move any pending
- * callbacks that it might have to the current CPU.  This code assumes
- * that at least one CPU in the system will remain running at all times.
- * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
+ * The CPU has been completely removed, and some other CPU is reporting
+ * this fact from process context.  Do the remainder of the cleanup.
+ * There can only be one CPU hotplug operation at a time, so no other
+ * CPU can be attempting to update rcu_cpu_kthread_task.
  */
-static void rcu_offline_cpu(int cpu)
+static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
-	__rcu_offline_cpu(cpu, &rcu_sched_state);
-	__rcu_offline_cpu(cpu, &rcu_bh_state);
-	rcu_preempt_offline_cpu(cpu);
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+	struct rcu_node *rnp = rdp->mynode;
+
+	rcu_stop_cpu_kthread(cpu);
+	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_send_cbs_to_online(struct rcu_state *rsp)
+static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 }
 
-static void rcu_offline_cpu(int cpu)
+static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
 }
 
@@ -1725,6 +1712,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * a quiescent state betweentimes.
 	 */
 	local_irq_save(flags);
+	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
@@ -2153,16 +2141,18 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		 * touch any data without introducing corruption. We send the
 		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
 		 */
-		rcu_send_cbs_to_online(&rcu_bh_state);
-		rcu_send_cbs_to_online(&rcu_sched_state);
-		rcu_preempt_send_cbs_to_online();
+		rcu_cleanup_dying_cpu(&rcu_bh_state);
+		rcu_cleanup_dying_cpu(&rcu_sched_state);
+		rcu_preempt_cleanup_dying_cpu();
 		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		rcu_offline_cpu(cpu);
+		rcu_cleanup_dead_cpu(cpu, &rcu_bh_state);
+		rcu_cleanup_dead_cpu(cpu, &rcu_sched_state);
+		rcu_preempt_cleanup_dead_cpu(cpu);
 		break;
 	default:
 		break;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index af2af3c..05e0367 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -439,8 +439,8 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp);
-static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static void rcu_preempt_cleanup_dead_cpu(int cpu);
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
@@ -451,7 +451,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
-static void rcu_preempt_send_cbs_to_online(void);
+static void rcu_preempt_cleanup_dying_cpu(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0a0013c..2b183ab 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -618,16 +618,16 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	return retval;
 }
 
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Do CPU-offline processing for preemptible RCU.
  */
-static void rcu_preempt_offline_cpu(int cpu)
+static void rcu_preempt_cleanup_dead_cpu(int cpu)
 {
-	__rcu_offline_cpu(cpu, &rcu_preempt_state);
+	rcu_cleanup_dead_cpu(cpu, &rcu_preempt_state);
 }
 
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
  * the task is recorded in the corresponding CPU's rcu_node structure,
@@ -911,11 +911,12 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptible RCU's callbacks from dying CPU to other online CPU.
+ * Move preemptible RCU's callbacks from dying CPU to other online CPU
+ * and record a quiescent state.
  */
-static void rcu_preempt_send_cbs_to_online(void)
+static void rcu_preempt_cleanup_dying_cpu(void)
 {
-	rcu_send_cbs_to_online(&rcu_preempt_state);
+	rcu_cleanup_dying_cpu(&rcu_preempt_state);
 }
 
 /*
@@ -1051,16 +1052,16 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	return 0;
 }
 
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Because preemptible RCU does not exist, it never needs CPU-offline
  * processing.
  */
-static void rcu_preempt_offline_cpu(int cpu)
+static void rcu_preempt_cleanup_dead_cpu(int cpu)
 {
 }
 
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
@@ -1152,9 +1153,9 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Because there is no preemptible RCU, there are no callbacks to move.
+ * Because there is no preemptible RCU, there is no cleanup to do.
  */
-static void rcu_preempt_send_cbs_to_online(void)
+static void rcu_preempt_cleanup_dying_cpu(void)
 {
 }
 
-- 
1.7.8

