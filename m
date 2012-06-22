Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762538Ab2FVPc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:32:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33564 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762327Ab2FVPc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:32:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/22] rcu: Move RCU grace-period initialization into a kthread
Date: Fri, 22 Jun 2012 08:17:17 -0700
Message-Id: <1340378241-6458-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5930-0000-0000-0000092521EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

As the first step towards allowing grace-period initialization to be
preemptible, this commit moves the RCU grace-period initialization
into its own kthread.  This is needed to keep large-system scheduling
latency at reasonable levels.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |  191 ++++++++++++++++++++++++++++++++++++------------------
 kernel/rcutree.h |    3 +
 2 files changed, 130 insertions(+), 64 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1b0e441..faf4860 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1030,6 +1030,103 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 }
 
 /*
+ * Body of kthread that handles grace periods.
+ */
+static int rcu_gp_kthread(void *arg)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp = arg;
+
+	for (;;) {
+
+		/* Handle grace-period start. */
+		rnp = rcu_get_root(rsp);
+		for (;;) {
+			wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
+			if (rsp->gp_flags)
+				break;
+			flush_signals(current);
+		}
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rsp->gp_flags = 0;
+		rdp = this_cpu_ptr(rsp->rda);
+
+		if (rcu_gp_in_progress(rsp)) {
+			/*
+			 * A grace period is already in progress, so
+			 * don't start another one.
+			 */
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			continue;
+		}
+
+		if (rsp->fqs_active) {
+			/*
+			 * We need a grace period, but force_quiescent_state()
+			 * is running.  Tell it to start one on our behalf.
+			 */
+			rsp->fqs_need_gp = 1;
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			continue;
+		}
+
+		/* Advance to a new grace period and initialize state. */
+		rsp->gpnum++;
+		trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
+		WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
+		rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
+		rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+		record_gp_stall_check_time(rsp);
+		raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+
+		/* Exclude any concurrent CPU-hotplug operations. */
+		raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+
+		/*
+		 * Set the quiescent-state-needed bits in all the rcu_node
+		 * structures for all currently online CPUs in breadth-first
+		 * order, starting from the root rcu_node structure.
+		 * This operation relies on the layout of the hierarchy
+		 * within the rsp->node[] array.  Note that other CPUs will
+		 * access only the leaves of the hierarchy, which still
+		 * indicate that no grace period is in progress, at least
+		 * until the corresponding leaf node has been initialized.
+		 * In addition, we have excluded CPU-hotplug operations.
+		 *
+		 * Note that the grace period cannot complete until
+		 * we finish the initialization process, as there will
+		 * be at least one qsmask bit set in the root node until
+		 * that time, namely the one corresponding to this CPU,
+		 * due to the fact that we have irqs disabled.
+		 */
+		rcu_for_each_node_breadth_first(rsp, rnp) {
+			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			rcu_preempt_check_blocked_tasks(rnp);
+			rnp->qsmask = rnp->qsmaskinit;
+			rnp->gpnum = rsp->gpnum;
+			rnp->completed = rsp->completed;
+			if (rnp == rdp->mynode)
+				rcu_start_gp_per_cpu(rsp, rnp, rdp);
+			rcu_preempt_boost_start_gp(rnp);
+			trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
+						    rnp->level, rnp->grplo,
+						    rnp->grphi, rnp->qsmask);
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		}
+
+		rnp = rcu_get_root(rsp);
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		/* force_quiescent_state() now OK. */
+		rsp->fqs_state = RCU_SIGNAL_INIT;
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	}
+	return 0;
+}
+
+/*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
@@ -1046,77 +1143,20 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!rcu_scheduler_fully_active ||
+	if (!rsp->gp_kthread ||
 	    !cpu_needs_another_gp(rsp, rdp)) {
 		/*
-		 * Either the scheduler hasn't yet spawned the first
-		 * non-idle task or this CPU does not need another
-		 * grace period.  Either way, don't start a new grace
-		 * period.
-		 */
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
-	}
-
-	if (rsp->fqs_active) {
-		/*
-		 * This CPU needs a grace period, but force_quiescent_state()
-		 * is running.  Tell it to start one on this CPU's behalf.
+		 * Either we have not yet spawned the grace-period
+		 * task or this CPU does not need another grace period.
+		 * Either way, don't start a new grace period.
 		 */
-		rsp->fqs_need_gp = 1;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
-	/* Advance to a new grace period and initialize state. */
-	rsp->gpnum++;
-	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
-	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
-	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
-	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	record_gp_stall_check_time(rsp);
-	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
-
-	/* Exclude any concurrent CPU-hotplug operations. */
-	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
-
-	/*
-	 * Set the quiescent-state-needed bits in all the rcu_node
-	 * structures for all currently online CPUs in breadth-first
-	 * order, starting from the root rcu_node structure.  This
-	 * operation relies on the layout of the hierarchy within the
-	 * rsp->node[] array.  Note that other CPUs will access only
-	 * the leaves of the hierarchy, which still indicate that no
-	 * grace period is in progress, at least until the corresponding
-	 * leaf node has been initialized.  In addition, we have excluded
-	 * CPU-hotplug operations.
-	 *
-	 * Note that the grace period cannot complete until we finish
-	 * the initialization process, as there will be at least one
-	 * qsmask bit set in the root node until that time, namely the
-	 * one corresponding to this CPU, due to the fact that we have
-	 * irqs disabled.
-	 */
-	rcu_for_each_node_breadth_first(rsp, rnp) {
-		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
-		rcu_preempt_check_blocked_tasks(rnp);
-		rnp->qsmask = rnp->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
-		rnp->completed = rsp->completed;
-		if (rnp == rdp->mynode)
-			rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		rcu_preempt_boost_start_gp(rnp);
-		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
-					    rnp->level, rnp->grplo,
-					    rnp->grphi, rnp->qsmask);
-		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
-	}
-
-	rnp = rcu_get_root(rsp);
-	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
-	rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
-	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	rsp->gp_flags = 1;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up(&rsp->gp_wq);
 }
 
 /*
@@ -2615,6 +2655,28 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 }
 
 /*
+ * Spawn the kthread that handles this RCU flavor's grace periods.
+ */
+static int __init rcu_spawn_gp_kthread(void)
+{
+	unsigned long flags;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
+	struct task_struct *t;
+
+	for_each_rcu_flavor(rsp) {
+		t = kthread_run(rcu_gp_kthread, rsp, rsp->name);
+		BUG_ON(IS_ERR(t));
+		rnp = rcu_get_root(rsp);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rsp->gp_kthread = t;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+	return 0;
+}
+early_initcall(rcu_spawn_gp_kthread);
+
+/*
  * This function is invoked towards the end of the scheduler's initialization
  * process.  Before this is called, the idle task might contain
  * RCU read-side critical sections (during which time, this idle
@@ -2715,6 +2777,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 	}
 
 	rsp->rda = rda;
+	init_waitqueue_head(&rsp->gp_wq);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 138fb33..c7c31c2 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -370,6 +370,9 @@ struct rcu_state {
 	u8	boost;				/* Subject to priority boost. */
 	unsigned long gpnum;			/* Current gp number. */
 	unsigned long completed;		/* # of last completed gp. */
+	struct task_struct *gp_kthread;		/* Task for grace periods. */
+	wait_queue_head_t gp_wq;		/* Where GP task waits. */
+	int gp_flags;				/* Commands for GP task. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-- 
1.7.8

