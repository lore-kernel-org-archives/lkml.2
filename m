Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1BWBj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:39:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41435 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab1BWBjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:54 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 14/14] rcu: Add boosting to TREE_PREEMPT_RCU tracing
Date: Tue, 22 Feb 2011 17:39:43 -0800
Message-Id: <1298425183-21265-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
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
 kernel/rcutree.h        |   19 +++++++++++
 kernel/rcutree_plugin.h |   37 ++++++++++++++++++++-
 kernel/rcutree_trace.c  |   82 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4c820a8..292fed7 100644
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
index 1242949..381f117 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1071,6 +1071,33 @@ static void __init __rcu_init_preempt(void)
 
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
@@ -1106,10 +1133,14 @@ static int rcu_boost(struct rcu_node *rnp)
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
@@ -1209,6 +1240,8 @@ static void rcu_initiate_boost(struct rcu_node *rnp)
 		t = rnp->boost_kthread_task;
 		if (t != NULL)
 			wake_up_process(t);
+	} else {
+		rcu_initiate_boost_trace(rnp);
 	}
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 1cedf94..5a1554c 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -157,6 +157,72 @@ static const struct file_operations rcudata_csv_fops = {
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
+	rcu_for_each_leaf_node(rcu_preempt_state, rnp)
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
+ * Create the rcuboost debugfs entry.  Note that the return value
+ * is the standard zero for success, non-zero for failure.
+ */
+static int rcu_boost_trace_create_file(struct dentry *rcudir)
+{
+	return IS_ERR_VALUE(debugfs_create_file("rcuboost", 0444, rcudir, NULL,
+						&rcu_node_boost_fops));
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
@@ -302,31 +368,35 @@ static int __init rcutree_trace_init(void)
 	struct dentry *retval;
 
 	rcudir = debugfs_create_dir("rcu", NULL);
-	if (!rcudir)
+	if (IS_ERR_VALUE(rcudir))
 		goto free_out;
 
 	retval = debugfs_create_file("rcudata", 0444, rcudir,
 						NULL, &rcudata_fops);
-	if (!retval)
+	if (IS_ERR_VALUE(retval))
 		goto free_out;
 
 	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
 						NULL, &rcudata_csv_fops);
-	if (!retval)
+	if (IS_ERR_VALUE(retval))
+		goto free_out;
+
+	retval = rcu_boost_trace_create_file(rcudir);
+	if (retval)
 		goto free_out;
 
 	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!retval)
+	if (IS_ERR_VALUE(retval))
 		goto free_out;
 
 	retval = debugfs_create_file("rcuhier", 0444, rcudir,
 						NULL, &rcuhier_fops);
-	if (!retval)
+	if (IS_ERR_VALUE(retval))
 		goto free_out;
 
 	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
 						NULL, &rcu_pending_fops);
-	if (!retval)
+	if (IS_ERR_VALUE(retval))
 		goto free_out;
 	return 0;
 free_out:
-- 
1.7.3.2

