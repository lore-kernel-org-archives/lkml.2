Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1EHNeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:34:25 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36088 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab1EHNeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:34:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: permit rcu_read_unlock() to be called while holding runqueue locks
Date: Sun,  8 May 2011 06:34:10 -0700
Message-Id: <1304861650-18475-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110508133343.GA18287@linux.vnet.ibm.com>
References: <20110508133343.GA18287@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Avoid calling into the scheduler while holding core RCU locks.  This
allows rcu_read_unlock() to be called while holding the runqueue locks,
but only as long as there was no chance of the RCU read-side critical
section having been preempted.  (Otherwise, if RCU priority boosting
is enabled, rcu_read_unlock() might call into the scheduler in order to
unboost itself, which might allows self-deadlock on the runqueue locks
within the scheduler.)

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   44 +++++++++----------------------
 kernel/rcutree.h        |    5 +---
 kernel/rcutree_plugin.h |   64 ++++++++++++++--------------------------------
 3 files changed, 34 insertions(+), 79 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 54ff7eb..5616b17 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1133,22 +1133,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
-
-	/*
-	 * If there are no more online CPUs for this rcu_node structure,
-	 * kill the rcu_node structure's kthread.  Otherwise, adjust its
-	 * affinity.
-	 */
-	t = rnp->node_kthread_task;
-	if (t != NULL &&
-	    rnp->qsmaskinit == 0) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rnp->node_kthread_task = NULL;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		kthread_stop(t);
-		rcu_stop_boost_kthread(rnp);
-	} else
-		rcu_node_kthread_setaffinity(rnp, -1);
+	rcu_node_kthread_setaffinity(rnp, -1);
 }
 
 /*
@@ -1320,8 +1305,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 			return;
 		}
 		if (rnp->qsmask == 0) {
-			rcu_initiate_boost(rnp);
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
 			continue;
 		}
 		cpu = rnp->grplo;
@@ -1340,10 +1324,10 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	rnp = rcu_get_root(rsp);
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (rnp->qsmask == 0)
-		rcu_initiate_boost(rnp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (rnp->qsmask == 0) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+	}
 }
 
 /*
@@ -1497,7 +1481,8 @@ static void invoke_rcu_cpu_kthread(void)
 
 /*
  * Wake up the specified per-rcu_node-structure kthread.
- * The caller must hold ->lock.
+ * Because the per-rcu_node kthreads are immortal, we don't need
+ * to do anything to keep them alive.
  */
 static void invoke_rcu_node_kthread(struct rcu_node *rnp)
 {
@@ -1546,8 +1531,8 @@ static void rcu_cpu_kthread_timer(unsigned long arg)
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rnp->wakemask |= rdp->grpmask;
-	invoke_rcu_node_kthread(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	invoke_rcu_node_kthread(rnp);
 }
 
 /*
@@ -1694,16 +1679,12 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
-						       kthread_should_stop());
-		if (kthread_should_stop())
-			break;
+		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = rnp->wakemask;
 		rnp->wakemask = 0;
-		rcu_initiate_boost(rnp);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
 				continue;
@@ -1719,6 +1700,7 @@ static int rcu_node_kthread(void *arg)
 			preempt_enable();
 		}
 	}
+	/* NOTREACHED */
 	rnp->node_kthread_status = RCU_KTHREAD_STOPPED;
 	return 0;
 }
@@ -1738,7 +1720,7 @@ static void rcu_node_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	int cpu;
 	unsigned long mask = rnp->qsmaskinit;
 
-	if (rnp->node_kthread_task == NULL || mask == 0)
+	if (rnp->node_kthread_task == NULL)
 		return;
 	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
 		return;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a6a9717..93d4a1c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -444,15 +444,12 @@ static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
 static void __init rcu_init_boost_waitqueue(struct rcu_node *rnp);
-static void rcu_initiate_boost(struct rcu_node *rnp);
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
 					  cpumask_var_t cm);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp,
 						 int rnp_index);
-#ifdef CONFIG_HOTPLUG_CPU
-static void rcu_stop_boost_kthread(struct rcu_node *rnp);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f629479..ed339702 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -711,15 +711,17 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 {
+	unsigned long flags;
 	int must_wait = 0;
 
-	raw_spin_lock(&rnp->lock); /* irqs already disabled */
-	if (!list_empty(&rnp->blkd_tasks)) {
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (list_empty(&rnp->blkd_tasks))
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	else {
 		rnp->exp_tasks = rnp->blkd_tasks.next;
-		rcu_initiate_boost(rnp);
+		rcu_initiate_boost(rnp, flags);  /* releases rnp->lock */
 		must_wait = 1;
 	}
-	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
 }
@@ -1179,12 +1181,7 @@ static int rcu_boost(struct rcu_node *rnp)
  */
 static void rcu_boost_kthread_timer(unsigned long arg)
 {
-	unsigned long flags;
-	struct rcu_node *rnp = (struct rcu_node *)arg;
-
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	invoke_rcu_node_kthread(rnp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	invoke_rcu_node_kthread((struct rcu_node *)arg);
 }
 
 /*
@@ -1200,10 +1197,7 @@ static int rcu_boost_kthread(void *arg)
 	for (;;) {
 		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
 		wait_event_interruptible(rnp->boost_wq, rnp->boost_tasks ||
-							rnp->exp_tasks ||
-							kthread_should_stop());
-		if (kthread_should_stop())
-			break;
+							rnp->exp_tasks);
 		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
 		more2boost = rcu_boost(rnp);
 		if (more2boost)
@@ -1215,7 +1209,7 @@ static int rcu_boost_kthread(void *arg)
 			spincnt = 0;
 		}
 	}
-	rnp->boost_kthread_status = RCU_KTHREAD_STOPPED;
+	/* NOTREACHED */
 	return 0;
 }
 
@@ -1225,14 +1219,17 @@ static int rcu_boost_kthread(void *arg)
  * kthread to start boosting them.  If there is an expedited grace
  * period in progress, it is always time to boost.
  *
- * The caller must hold rnp->lock.
+ * The caller must hold rnp->lock, which this function releases,
+ * but irqs remain disabled.  The ->boost_kthread_task is immortal,
+ * so we don't need to worry about it going away.
  */
-static void rcu_initiate_boost(struct rcu_node *rnp)
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 {
 	struct task_struct *t;
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL) {
 		rnp->n_balk_exp_gp_tasks++;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	if (rnp->exp_tasks != NULL ||
@@ -1242,11 +1239,14 @@ static void rcu_initiate_boost(struct rcu_node *rnp)
 	     ULONG_CMP_GE(jiffies, rnp->boost_time))) {
 		if (rnp->exp_tasks == NULL)
 			rnp->boost_tasks = rnp->gp_tasks;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		t = rnp->boost_kthread_task;
 		if (t != NULL)
 			wake_up_process(t);
-	} else
+	} else {
 		rcu_initiate_boost_trace(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
 }
 
 /*
@@ -1312,27 +1312,11 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void rcu_stop_boost_kthread(struct rcu_node *rnp)
-{
-	unsigned long flags;
-	struct task_struct *t;
-
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	t = rnp->boost_kthread_task;
-	rnp->boost_kthread_task = NULL;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	if (t != NULL)
-		kthread_stop(t);
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 #else /* #ifdef CONFIG_RCU_BOOST */
 
-static void rcu_initiate_boost(struct rcu_node *rnp)
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 {
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp,
@@ -1355,14 +1339,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void rcu_stop_boost_kthread(struct rcu_node *rnp)
-{
-}
-
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifndef CONFIG_SMP
-- 
1.7.3.2

