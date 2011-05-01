Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab1EANXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:23:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48605 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 27/86] rcu: Converge TINY_RCU expedited and normal boosting
Date: Sun,  1 May 2011 06:21:07 -0700
Message-Id: <1304256126-26015-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This applies a trick from TREE_RCU boosting to TINY_RCU, eliminating
code and adding comments.  The key point is that it is possible for
the booster thread itself to work out whether there is a normal or
expedited boost required based solely on local information.  There
is therefore no need for boost initiation to know or care what type
of boosting is required.  In addition, when boosting is complete for
a given grace period, then by definition there cannot be any more
boosting for that grace period.  This allows eliminating yet more
state and statistics.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |  163 +++++++++++++++++++++++++---------------------
 1 files changed, 89 insertions(+), 74 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 2b8d529..f259c67 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -106,15 +106,22 @@ struct rcu_preempt_ctrlblk {
 	unsigned long n_grace_periods;
 #ifdef CONFIG_RCU_BOOST
 	unsigned long n_tasks_boosted;
+				/* Total number of tasks boosted. */
 	unsigned long n_exp_boosts;
+				/* Number of tasks boosted for expedited GP. */
 	unsigned long n_normal_boosts;
-	unsigned long n_normal_balk_blkd_tasks;
-	unsigned long n_normal_balk_gp_tasks;
-	unsigned long n_normal_balk_boost_tasks;
-	unsigned long n_normal_balk_notyet;
-	unsigned long n_normal_balk_nos;
-	unsigned long n_exp_balk_blkd_tasks;
-	unsigned long n_exp_balk_nos;
+				/* Number of tasks boosted for normal GP. */
+	unsigned long n_balk_blkd_tasks;
+				/* Refused to boost: no blocked tasks. */
+	unsigned long n_balk_exp_gp_tasks;
+				/* Refused to boost: nothing blocking GP. */
+	unsigned long n_balk_boost_tasks;
+				/* Refused to boost: already boosting. */
+	unsigned long n_balk_notyet;
+				/* Refused to boost: not yet time. */
+	unsigned long n_balk_nos;
+				/* Refused to boost: not sure why, though. */
+				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 #endif /* #ifdef CONFIG_RCU_TRACE */
 };
@@ -199,7 +206,6 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 static void rcu_initiate_boost_trace(void);
-static void rcu_initiate_exp_boost_trace(void);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 /*
@@ -225,16 +231,13 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 		   rcu_preempt_ctrlblk.n_normal_boosts,
 		   (int)(jiffies & 0xffff),
 		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
-	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu ny=%lu nos=%lu\n",
-		   "normal balk",
-		   rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_gp_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_boost_tasks,
-		   rcu_preempt_ctrlblk.n_normal_balk_notyet,
-		   rcu_preempt_ctrlblk.n_normal_balk_nos);
-	seq_printf(m, "             exp balk: bt=%lu nos=%lu\n",
-		   rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks,
-		   rcu_preempt_ctrlblk.n_exp_balk_nos);
+	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu ny=%lu nos=%lu\n",
+		   "             balk",
+		   rcu_preempt_ctrlblk.n_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_balk_exp_gp_tasks,
+		   rcu_preempt_ctrlblk.n_balk_boost_tasks,
+		   rcu_preempt_ctrlblk.n_balk_notyet,
+		   rcu_preempt_ctrlblk.n_balk_nos);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 }
 
@@ -252,23 +255,59 @@ static int rcu_boost(void)
 {
 	unsigned long flags;
 	struct rt_mutex mtx;
-	struct list_head *np;
 	struct task_struct *t;
+	struct list_head *tb;
 
-	if (rcu_preempt_ctrlblk.boost_tasks == NULL)
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL)
 		return 0;  /* Nothing to boost. */
+
 	raw_local_irq_save(flags);
-	t = container_of(rcu_preempt_ctrlblk.boost_tasks, struct task_struct,
-			 rcu_node_entry);
-	np = rcu_next_node_entry(t);
+
+	/*
+	 * Recheck with irqs disabled: all tasks in need of boosting
+	 * might exit their RCU read-side critical sections on their own
+	 * if we are preempted just before disabling irqs.
+	 */
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
+		raw_local_irq_restore(flags);
+		return 0;
+	}
+
+	/*
+	 * Preferentially boost tasks blocking expedited grace periods.
+	 * This cannot starve the normal grace periods because a second
+	 * expedited grace period must boost all blocked tasks, including
+	 * those blocking the pre-existing normal grace period.
+	 */
+	if (rcu_preempt_ctrlblk.exp_tasks != NULL) {
+		tb = rcu_preempt_ctrlblk.exp_tasks;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
+	} else {
+		tb = rcu_preempt_ctrlblk.boost_tasks;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
+	}
+	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
+
+	/*
+	 * We boost task t by manufacturing an rt_mutex that appears to
+	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * task t can find it, and task t will release the mutex when it
+	 * exits its outermost RCU read-side critical section.  Then
+	 * simply acquiring this artificial rt_mutex will boost task
+	 * t's priority.  (Thanks to tglx for suggesting this approach!)
+	 */
+	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
-	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
-	rt_mutex_unlock(&mtx);
-	return rcu_preempt_ctrlblk.boost_tasks != NULL;
+	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	return rcu_preempt_ctrlblk.boost_tasks != NULL ||
+	       rcu_preempt_ctrlblk.exp_tasks != NULL;
 }
 
 /*
@@ -283,39 +322,24 @@ static int rcu_boost(void)
  */
 static int rcu_initiate_boost(void)
 {
-	if (!rcu_preempt_blocked_readers_cgp()) {
-		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks++);
+	if (!rcu_preempt_blocked_readers_cgp() &&
+	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
+		RCU_TRACE(rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++);
 		return 0;
 	}
-	if (rcu_preempt_ctrlblk.gp_tasks != NULL &&
-	    rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
-		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
+	if (rcu_preempt_ctrlblk.exp_tasks != NULL ||
+	    (rcu_preempt_ctrlblk.gp_tasks != NULL &&
+	     rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	     ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))) {
+		if (rcu_preempt_ctrlblk.exp_tasks == NULL)
+			rcu_preempt_ctrlblk.boost_tasks =
+				rcu_preempt_ctrlblk.gp_tasks;
 		invoke_rcu_kthread();
-		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
 	} else
 		RCU_TRACE(rcu_initiate_boost_trace());
 	return 1;
 }
 
-/*
- * Initiate boosting for an expedited grace period.
- */
-static void rcu_initiate_expedited_boost(void)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	if (!list_empty(&rcu_preempt_ctrlblk.blkd_tasks)) {
-		rcu_preempt_ctrlblk.boost_tasks =
-			rcu_preempt_ctrlblk.blkd_tasks.next;
-		invoke_rcu_kthread();
-		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
-	} else
-		RCU_TRACE(rcu_initiate_exp_boost_trace());
-	raw_local_irq_restore(flags);
-}
-
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
 
 /*
@@ -347,13 +371,6 @@ static int rcu_initiate_boost(void)
 }
 
 /*
- * If there is no RCU priority boosting, we don't initiate expedited boosting.
- */
-static void rcu_initiate_expedited_boost(void)
-{
-}
-
-/*
  * If there is no RCU priority boosting, nothing to do at grace-period start.
  */
 static void rcu_preempt_boost_start_gp(void)
@@ -786,13 +803,16 @@ void synchronize_rcu_expedited(void)
 	rpcp->exp_tasks = rpcp->blkd_tasks.next;
 	if (rpcp->exp_tasks == &rpcp->blkd_tasks)
 		rpcp->exp_tasks = NULL;
-	local_irq_restore(flags);
 
 	/* Wait for tail of ->blkd_tasks list to drain. */
-	if (rcu_preempted_readers_exp())
-		rcu_initiate_expedited_boost();
+	if (!rcu_preempted_readers_exp())
+		local_irq_restore(flags);
+	else {
+		rcu_initiate_boost();
+		local_irq_restore(flags);
 		wait_event(sync_rcu_preempt_exp_wq,
 			   !rcu_preempted_readers_exp());
+	}
 
 	/* Clean up and exit. */
 	barrier(); /* ensure expedited GP seen before counter increment. */
@@ -905,22 +925,17 @@ void __init rcu_scheduler_starting(void)
 
 static void rcu_initiate_boost_trace(void)
 {
-	if (rcu_preempt_ctrlblk.gp_tasks == NULL)
-		rcu_preempt_ctrlblk.n_normal_balk_gp_tasks++;
+	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
+		rcu_preempt_ctrlblk.n_balk_blkd_tasks++;
+	else if (rcu_preempt_ctrlblk.gp_tasks == NULL &&
+		 rcu_preempt_ctrlblk.exp_tasks == NULL)
+		rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++;
 	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
-		rcu_preempt_ctrlblk.n_normal_balk_boost_tasks++;
+		rcu_preempt_ctrlblk.n_balk_boost_tasks++;
 	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
-		rcu_preempt_ctrlblk.n_normal_balk_notyet++;
-	else
-		rcu_preempt_ctrlblk.n_normal_balk_nos++;
-}
-
-static void rcu_initiate_exp_boost_trace(void)
-{
-	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
-		rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks++;
+		rcu_preempt_ctrlblk.n_balk_notyet++;
 	else
-		rcu_preempt_ctrlblk.n_exp_balk_nos++;
+		rcu_preempt_ctrlblk.n_balk_nos++;
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
-- 
1.7.3.2

