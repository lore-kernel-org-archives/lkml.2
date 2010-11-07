Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0KGCGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:18 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49264 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0KGCFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 09/12] rcu,cleanup: simplify the code when cpu is dying
Date: Sat,  6 Nov 2010 19:05:29 -0700
Message-Id: <1289095532-5398-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

When we handle the CPU_DYING notifier, the whole system is stopped except
for the current CPU.  We therefore need no synchronization with the other
CPUs.  This allows us to move any orphaned RCU callbacks directly to the
list of any online CPU without needing to run them through the global
orphan lists.  These global orphan lists can therefore be dispensed with.
This commit makes thes changes, though currently victimizes CPU 0 @@@.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   81 ++++++++++++----------------------------------
 kernel/rcutree.h        |   16 ++-------
 kernel/rcutree_plugin.h |    8 ++--
 kernel/rcutree_trace.c  |    4 +-
 4 files changed, 31 insertions(+), 78 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ccdc04c..669d7fe 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -67,9 +67,6 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
-	.orphan_cbs_list = NULL, \
-	.orphan_cbs_tail = &structname.orphan_cbs_list, \
-	.orphan_qlen = 0, \
 	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
@@ -984,53 +981,31 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
- * specified flavor of RCU.  The callbacks will be adopted by the next
- * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
- * comes first.  Because this is invoked from the CPU_DYING notifier,
- * irqs are already disabled.
+ * Move a dying CPU's RCU callbacks to online CPU's callback list.
+ * Synchronization is not required because this function executes
+ * in stop_machine() context.
  */
-static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
+static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 {
 	int i;
+	/* current DYING CPU is cleared in the cpu_online_mask */
+	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
-	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
-	*rsp->orphan_cbs_tail = rdp->nxtlist;
-	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
+
+	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	receive_rdp->qlen += rdp->qlen;
+	receive_rdp->n_cbs_adopted += rdp->qlen;
+	rdp->n_cbs_orphaned += rdp->qlen;
+
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
-	rsp->orphan_qlen += rdp->qlen;
-	rdp->n_cbs_orphaned += rdp->qlen;
 	rdp->qlen = 0;
-	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
-}
-
-/*
- * Adopt previously orphaned RCU callbacks.
- */
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
-{
-	unsigned long flags;
-	struct rcu_data *rdp;
-
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rdp = this_cpu_ptr(rsp->rda);
-	if (rsp->orphan_cbs_list == NULL) {
-		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
-		return;
-	}
-	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
-	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
-	rdp->qlen += rsp->orphan_qlen;
-	rdp->n_cbs_adopted += rsp->orphan_qlen;
-	rsp->orphan_cbs_list = NULL;
-	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
-	rsp->orphan_qlen = 0;
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -1081,8 +1056,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
-
-	rcu_adopt_orphan_cbs(rsp);
 }
 
 /*
@@ -1100,11 +1073,7 @@ static void rcu_offline_cpu(int cpu)
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
-{
-}
-
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 {
 }
 
@@ -1702,10 +1671,7 @@ static void _rcu_barrier(struct rcu_state *rsp,
 	 * early.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
-	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
-	rcu_adopt_orphan_cbs(rsp);
 	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
-	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
@@ -1831,18 +1797,13 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/*
-		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
-		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
-		 * returns, all online cpus have queued rcu_barrier_func().
-		 * The dying CPU clears its cpu_online_mask bit and
-		 * moves all of its RCU callbacks to ->orphan_cbs_list
-		 * in the context of stop_machine(), so subsequent calls
-		 * to _rcu_barrier() will adopt these callbacks and only
-		 * then queue rcu_barrier_func() on all remaining CPUs.
+		 * The whole machine is "stopped" except this cpu, so we can
+		 * touch any data without introducing corruption. And we send
+		 * the callbacks to an attribute chosen online cpu.
 		 */
-		rcu_send_cbs_to_orphanage(&rcu_bh_state);
-		rcu_send_cbs_to_orphanage(&rcu_sched_state);
-		rcu_preempt_send_cbs_to_orphanage();
+		rcu_send_cbs_to_online(&rcu_bh_state);
+		rcu_send_cbs_to_online(&rcu_sched_state);
+		rcu_preempt_send_cbs_to_online();
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 91d4170..1a54be2 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -203,8 +203,8 @@ struct rcu_data {
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
-	unsigned long	n_cbs_orphaned;	/* RCU cbs sent to orphanage. */
-	unsigned long	n_cbs_adopted;	/* RCU cbs adopted from orphanage. */
+	unsigned long   n_cbs_orphaned; /* RCU cbs orphaned by dying CPU */
+	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
@@ -309,15 +309,7 @@ struct rcu_state {
 	/* End of fields guarded by root rcu_node's lock. */
 
 	raw_spinlock_t onofflock;		/* exclude on/offline and */
-						/*  starting new GP.  Also */
-						/*  protects the following */
-						/*  orphan_cbs fields. */
-	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
-						/*  orphaned by all CPUs in */
-						/*  a given leaf rcu_node */
-						/*  going offline. */
-	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
-	long orphan_qlen;			/* Number of orphaned cbs. */
+						/*  starting new GP. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
@@ -390,7 +382,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
-static void rcu_preempt_send_cbs_to_orphanage(void);
+static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 21df7f3..0de359b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -774,11 +774,11 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable RCU's callbacks to ->orphan_cbs_list.
+ * Move preemptable DYING RCU's callbacks to other online CPU.
  */
-static void rcu_preempt_send_cbs_to_orphanage(void)
+static void rcu_preempt_send_cbs_to_online(void)
 {
-	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
+	rcu_send_cbs_to_online(&rcu_preempt_state);
 }
 
 /*
@@ -1002,7 +1002,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 /*
  * Because there is no preemptable RCU, there are no callbacks to move.
  */
-static void rcu_preempt_send_cbs_to_orphanage(void)
+static void rcu_preempt_send_cbs_to_online(void)
 {
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 78ad3c3..c8e9785 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -166,13 +166,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
-		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
 		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh, rsp->orphan_qlen);
+		   rsp->n_force_qs_lh);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
-- 
1.7.0.6

