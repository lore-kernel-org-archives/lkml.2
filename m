Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784Ab1EANiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:38:50 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38312 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1EANWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/86] rcu: Add boosting to TREE_PREEMPT_RCU tracing
Date: Sun,  1 May 2011 06:20:51 -0700
Message-Id: <1304256126-26015-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Includes total number of tasks boosted, number boosted on behalf of each
of normal and expedited grace periods, and statistics on attempts to
initiate boosting that failed for various reasons.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h        |   19 +++++++++++++
 kernel/rcutree_plugin.h |   42 ++++++++++++++++++++++++++---
 kernel/rcutree_trace.c  |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8db0cdc..d49046c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -152,6 +152,25 @@ struct rcu_node {
 	wait_queue_head_t boost_wq;
 				/* Wait queue on which to park the boost */
 				/*  kthread. */
+	unsigned long n_tasks_boosted;
+				/* Total number of tasks boosted. */
+	unsigned long n_exp_boosts;
+				/* Number of tasks boosted for expedited GP. */
+	unsigned long n_normal_boosts;
+				/* Number of tasks boosted for normal GP. */
+	unsigned long n_balk_blkd_tasks;
+				/* Refused to boost: no blocked tasks. */
+	unsigned long n_balk_exp_gp_tasks;
+				/* Refused to boost: nothing blocking GP. */
+	unsigned long n_balk_boost_tasks;
+				/* Refused to boost: already boosting. */
+	unsigned long n_balk_notblocked;
+				/* Refused to boost: RCU RS CS still running. */
+	unsigned long n_balk_notyet;
+				/* Refused to boost: not yet time. */
+	unsigned long n_balk_nos;
+				/* Refused to boost: not sure why, though. */
+				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct task_struct *node_kthread_task;
 				/* kthread that takes care of this rcu_node */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4e48625..07d3464 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1073,6 +1073,33 @@ static void __init __rcu_init_preempt(void)
 
 #include "rtmutex_common.h"
 
+#ifdef CONFIG_RCU_TRACE
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+	if (list_empty(&rnp->blkd_tasks))
+		rnp->n_balk_blkd_tasks++;
+	else if (rnp->exp_tasks == NULL && rnp->gp_tasks == NULL)
+		rnp->n_balk_exp_gp_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->boost_tasks != NULL)
+		rnp->n_balk_boost_tasks++;
+	else if (rnp->gp_tasks != NULL && rnp->qsmask != 0)
+		rnp->n_balk_notblocked++;
+	else if (rnp->gp_tasks != NULL &&
+		 ULONG_CMP_GE(jiffies, rnp->boost_time))
+		rnp->n_balk_notyet++;
+	else
+		rnp->n_balk_nos++;
+}
+
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+static void rcu_initiate_boost_trace(struct rcu_node *rnp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1108,10 +1135,14 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * expedited grace period must boost all blocked tasks, including
 	 * those blocking the pre-existing normal grace period.
 	 */
-	if (rnp->exp_tasks != NULL)
+	if (rnp->exp_tasks != NULL) {
 		tb = rnp->exp_tasks;
-	else
+		rnp->n_exp_boosts++;
+	} else {
 		tb = rnp->boost_tasks;
+		rnp->n_normal_boosts++;
+	}
+	rnp->n_tasks_boosted++;
 
 	/*
 	 * We boost task t by manufacturing an rt_mutex that appears to
@@ -1197,8 +1228,10 @@ static void rcu_initiate_boost(struct rcu_node *rnp)
 {
 	struct task_struct *t;
 
-	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL)
+	if (!rcu_preempt_blocked_readers_cgp(rnp) && rnp->exp_tasks == NULL) {
+		rnp->n_balk_exp_gp_tasks++;
 		return;
+	}
 	if (rnp->exp_tasks != NULL ||
 	    (rnp->gp_tasks != NULL &&
 	     rnp->boost_tasks == NULL &&
@@ -1209,7 +1242,8 @@ static void rcu_initiate_boost(struct rcu_node *rnp)
 		t = rnp->boost_kthread_task;
 		if (t != NULL)
 			wake_up_process(t);
-	}
+	} else
+		rcu_initiate_boost_trace(rnp);
 }
 
 /*
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 1cedf94..ead5736 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -157,6 +157,71 @@ static const struct file_operations rcudata_csv_fops = {
 	.release = single_release,
 };
 
+#ifdef CONFIG_RCU_BOOST
+
+static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
+{
+	seq_printf(m,  "%d:%d tasks=%c%c%c%c ntb=%lu neb=%lu nnb=%lu "
+		   "j=%04x bt=%04x\n",
+		   rnp->grplo, rnp->grphi,
+		   "T."[list_empty(&rnp->blkd_tasks)],
+		   "N."[!rnp->gp_tasks],
+		   "E."[!rnp->exp_tasks],
+		   "B."[!rnp->boost_tasks],
+		   rnp->n_tasks_boosted, rnp->n_exp_boosts,
+		   rnp->n_normal_boosts,
+		   (int)(jiffies & 0xffff),
+		   (int)(rnp->boost_time & 0xffff));
+	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu nb=%lu ny=%lu nos=%lu\n",
+		   "     balk",
+		   rnp->n_balk_blkd_tasks,
+		   rnp->n_balk_exp_gp_tasks,
+		   rnp->n_balk_boost_tasks,
+		   rnp->n_balk_notblocked,
+		   rnp->n_balk_notyet,
+		   rnp->n_balk_nos);
+}
+
+static int show_rcu_node_boost(struct seq_file *m, void *unused)
+{
+	struct rcu_node *rnp;
+
+	rcu_for_each_leaf_node(&rcu_preempt_state, rnp)
+		print_one_rcu_node_boost(m, rnp);
+	return 0;
+}
+
+static int rcu_node_boost_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcu_node_boost, NULL);
+}
+
+static const struct file_operations rcu_node_boost_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_node_boost_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/*
+ * Create the rcuboost debugfs entry.  Standard error return.
+ */
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return !debugfs_create_file("rcuboost", 0444, rcudir, NULL,
+				    &rcu_node_boost_fops);
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return 0;  /* There cannot be an error if we didn't create it! */
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
 	unsigned long gpnum;
@@ -315,6 +380,9 @@ static int __init rcutree_trace_init(void)
 	if (!retval)
 		goto free_out;
 
+	if (rcu_boost_trace_create_file(rcudir))
+		goto free_out;
+
 	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
 	if (!retval)
 		goto free_out;
-- 
1.7.3.2

