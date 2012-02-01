Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2BATv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:51:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33597 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2BATnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:11 -0500
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
Subject: [PATCH RFC tip/core/rcu 38/41] rcu: Rework detection of use of RCU by offline CPUs
Date: Wed,  1 Feb 2012 11:41:56 -0800
Message-Id: <1328125319-5205-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-6148-0000-0000-000003144F54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Because newly offlined CPUs continue executing after completing the
CPU_DYING notifiers, they legitimately enter the scheduler and use
RCU while appearing to be offline.  This calls for a more sophisticated
approach as follows:

1.	RCU marks the CPU online during the CPU_UP_PREPARE phase.

2.	RCU marks the CPU offline during the CPU_DEAD phase.

3.	Diagnostics regarding use of read-side RCU by offline CPUs use
	RCU's accounting rather than the cpu_online_map.  (Note that
	__call_rcu() still uses cpu_online_map to detect illegal
	invocations within CPU_DYING notifiers.)

4.	Offline CPUs are prevented from hanging the system by
	force_quiescent_state(), which pays attention to cpu_online_map.
	Some additional work (in a later commit) will be needed to
	guarantee that force_quiescent_state() waits a full jiffy before
	assuming that a CPU is offline, for example, when called from
	idle entry.

This approach avoids the false positives encountered when attempting to
use more exact classification of CPU online/offline state.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   92 ++++++++++++++++++++++++++++++----------------
 kernel/rcutree_plugin.h |    2 +-
 2 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 632b1c3..ce39431 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -604,19 +604,33 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  * this task being preempted, its old CPU being taken offline, resuming
  * on some other CPU, then determining that its old CPU is now offline.
  * It is OK to use RCU on an offline processor during initial boot, hence
- * the check for rcu_scheduler_fully_active.
+ * the check for rcu_scheduler_fully_active.  Note also that it is OK
+ * for a CPU coming online to use RCU for one jiffy prior to marking itself
+ * online in the cpu_online_mask.  Similarly, it is OK for a CPU going
+ * offline to continue to use RCU for one jiffy after marking itself
+ * offline in the cpu_online_mask.  This leniency is necessary given the
+ * non-atomic nature of the online and offline processing, for example,
+ * the fact that a CPU enters the scheduler after completing the CPU_DYING
+ * notifiers.
+ *
+ * This is also why RCU internally marks CPUs online during the
+ * CPU_UP_PREPARE phase and offline during the CPU_DEAD phase.
  *
  * Disable checking if in an NMI handler because we cannot safely report
  * errors from NMI handlers anyway.
  */
 bool rcu_lockdep_current_cpu_online(void)
 {
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
 	bool ret;
 
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	ret = cpu_online(smp_processor_id()) ||
+	rdp = &__get_cpu_var(rcu_sched_data);
+	rnp = rdp->mynode;
+	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
 	preempt_enable();
 	return ret;
@@ -1311,14 +1325,12 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
-	unsigned long flags;
 	int i;
 	unsigned long mask;
-	int need_report;
 	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
-	struct rcu_node *rnp = rdp->mynode; /* For dying CPU. */
+	RCU_TRACE(struct rcu_node *rnp = rdp->mynode); /* For dying CPU. */
 
 	/* First, adjust the counts. */
 	if (rdp->nxtlist != NULL) {
@@ -1384,32 +1396,6 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 			       "cpuofl");
 	rcu_report_qs_rdp(smp_processor_id(), rsp, rdp, rsp->gpnum);
 	/* Note that rcu_report_qs_rdp() might call trace_rcu_grace_period(). */
-
-	/*
-	 * Remove the dying CPU from the bitmasks in the rcu_node
-	 * hierarchy.  Because we are in stop_machine() context, we
-	 * automatically exclude ->onofflock critical sections.
-	 */
-	do {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rnp->qsmaskinit &= ~mask;
-		if (rnp->qsmaskinit != 0) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			break;
-		}
-		if (rnp == rdp->mynode) {
-			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
-			if (need_report & RCU_OFL_TASKS_NORM_GP)
-				rcu_report_unblock_qs_rnp(rnp, flags);
-			else
-				raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			if (need_report & RCU_OFL_TASKS_EXP_GP)
-				rcu_report_exp_rnp(rsp, rnp, true);
-		} else
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		mask = rnp->grpmask;
-		rnp = rnp->parent;
-	} while (rnp != NULL);
 }
 
 /*
@@ -1420,11 +1406,53 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
  */
 static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 {
+	unsigned long flags;
+	unsigned long mask;
+	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;
+	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rnp. */
 
+	/* Adjust any no-longer-needed kthreads. */
 	rcu_stop_cpu_kthread(cpu);
 	rcu_node_kthread_setaffinity(rnp, -1);
+
+	/* Remove the dying CPU from the bitmasks in the rcu_node hierarchy. */
+
+	/* Exclude any attempts to start a new grace period. */
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	do {
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit != 0) {
+			if (rnp != rdp->mynode)
+				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			break;
+		}
+		if (rnp == rdp->mynode)
+			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+		else
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		mask = rnp->grpmask;
+		rnp = rnp->parent;
+	} while (rnp != NULL);
+
+	/*
+	 * We still hold the leaf rcu_node structure lock here, and
+	 * irqs are still disabled.  The reason for this subterfuge is
+	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * held leads to deadlock.
+	 */
+	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	rnp = rdp->mynode;
+	if (need_report & RCU_OFL_TASKS_NORM_GP)
+		rcu_report_unblock_qs_rnp(rnp, flags);
+	else
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (need_report & RCU_OFL_TASKS_EXP_GP)
+		rcu_report_exp_rnp(rsp, rnp, true);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3dc58cc..56a63bc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -610,7 +610,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * absolutely necessary, but this is a good performance/complexity
 	 * tradeoff.
 	 */
-	if (rcu_preempt_blocked_readers_cgp(rnp))
+	if (rcu_preempt_blocked_readers_cgp(rnp) && rnp->qsmask == 0)
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
-- 
1.7.8

