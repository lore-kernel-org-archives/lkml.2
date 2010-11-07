Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0KGCHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:07:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49754 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0KGCFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/12] rcu: add tracing for TINY_RCU and TINY_PREEMPT_RCU
Date: Sat,  6 Nov 2010 19:05:24 -0700
Message-Id: <1289095532-5398-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracing for the tiny RCU implementations, including statistics on
boosting in the case of TINY_PREEMPT_RCU and RCU_BOOST.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |    1 -
 kernel/rcutiny.c        |    4 +
 kernel/rcutiny_plugin.h |  208 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8187783..046f963 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -384,7 +384,6 @@ config PREEMPT_RCU
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 93d1665..0344937 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -144,6 +144,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
 	struct rcu_head *next, *list;
 	unsigned long flags;
+	RCU_TRACE(int cb_count = 0);
 
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail)
@@ -169,7 +170,9 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		list->func(list);
 		local_bh_enable();
 		list = next;
+		RCU_TRACE(cb_count++);
 	}
+	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
 }
 
 /*
@@ -252,6 +255,7 @@ static void __call_rcu(struct rcu_head *head,
 	local_irq_save(flags);
 	*rcp->curtail = head;
 	rcp->curtail = &head->next;
+	RCU_TRACE(rcp->qlen++);
 	local_irq_restore(flags);
 }
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 36d203c..419b796 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -23,12 +23,21 @@
  */
 
 #include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#ifdef CONFIG_RCU_TRACE
+#define RCU_TRACE(stmt)	stmt
+#else /* #ifdef CONFIG_RCU_TRACE */
+#define RCU_TRACE(stmt)
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
 	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+	RCU_TRACE(long qlen);		/* Number of pending CBs. */
 };
 
 /* Definition for rcupdate control block. */
@@ -90,8 +99,26 @@ struct rcu_preempt_ctrlblk {
 	u8 gpcpu;		/* Last grace period blocked by the CPU. */
 	u8 completed;		/* Last grace period completed. */
 				/*  If all three are equal, RCU is idle. */
+#ifdef CONFIG_RCU_BOOST
 	s8 boosted_this_gp;	/* Has boosting already happened? */
 	unsigned long boost_time; /* When to start boosting (jiffies) */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_RCU_TRACE
+	unsigned long n_grace_periods;
+#ifdef CONFIG_RCU_BOOST
+	unsigned long n_tasks_boosted;
+	unsigned long n_exp_boosts;
+	unsigned long n_normal_boosts;
+	unsigned long n_normal_balk_blkd_tasks;
+	unsigned long n_normal_balk_gp_tasks;
+	unsigned long n_normal_balk_boost_tasks;
+	unsigned long n_normal_balk_boosted;
+	unsigned long n_normal_balk_notyet;
+	unsigned long n_normal_balk_nos;
+	unsigned long n_exp_balk_blkd_tasks;
+	unsigned long n_exp_balk_nos;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_RCU_TRACE */
 };
 
 static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
@@ -170,6 +197,65 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t)
 	return np;
 }
 
+#ifdef CONFIG_RCU_TRACE
+
+#ifdef CONFIG_RCU_BOOST
+static void rcu_initiate_boost_trace(void);
+static void rcu_initiate_exp_boost_trace(void);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * Dump additional statistice for TINY_PREEMPT_RCU.
+ */
+static void show_tiny_preempt_stats(struct seq_file *m)
+{
+	seq_printf(m, "rcu_preempt: qlen=%ld gp=%lu g%u/p%u/c%u tasks=%c%c%c\n",
+		   rcu_preempt_ctrlblk.rcb.qlen,
+		   rcu_preempt_ctrlblk.n_grace_periods,
+		   rcu_preempt_ctrlblk.gpnum,
+		   rcu_preempt_ctrlblk.gpcpu,
+		   rcu_preempt_ctrlblk.completed,
+		   "T."[list_empty(&rcu_preempt_ctrlblk.blkd_tasks)],
+		   "N."[!rcu_preempt_ctrlblk.gp_tasks],
+		   "E."[!rcu_preempt_ctrlblk.exp_tasks]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, "             ttb=%c btg=",
+		   "B."[!rcu_preempt_ctrlblk.boost_tasks]);
+	switch (rcu_preempt_ctrlblk.boosted_this_gp) {
+	case -1:
+		seq_puts(m, "exp");
+		break;
+	case 0:
+		seq_puts(m, "no");
+		break;
+	case 1:
+		seq_puts(m, "done");
+		break;
+	default:
+		seq_printf(m, "?%d?", rcu_preempt_ctrlblk.boosted_this_gp);
+	}
+	seq_printf(m, " ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+		   rcu_preempt_ctrlblk.n_tasks_boosted,
+		   rcu_preempt_ctrlblk.n_exp_boosts,
+		   rcu_preempt_ctrlblk.n_normal_boosts,
+		   (int)(jiffies & 0xffff),
+		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
+	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu b=%lu ny=%lu nos=%lu\n",
+		   "normal balk",
+		   rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_gp_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_boost_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_boosted,
+		   rcu_preempt_ctrlblk.n_normal_balk_notyet,
+		   rcu_preempt_ctrlblk.n_normal_balk_nos);
+	seq_printf(m, "             exp balk: bt=%lu nos=%lu\n",
+		   rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_exp_balk_nos);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 #ifdef CONFIG_RCU_BOOST
 
 #include "rtmutex_common.h"
@@ -197,6 +283,7 @@ static int rcu_boost(void)
 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
+	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
 	rt_mutex_unlock(&mtx);
 	return rcu_preempt_ctrlblk.boost_tasks != NULL;
 }
@@ -215,7 +302,9 @@ static void rcu_initiate_boost(void)
 	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
 		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
 		invoke_rcu_kthread();
-	}
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
+	} else
+		RCU_TRACE(rcu_initiate_boost_trace());
 }
 
 /*
@@ -231,7 +320,9 @@ static void rcu_initiate_expedited_boost(void)
 			rcu_preempt_ctrlblk.blkd_tasks.next;
 		rcu_preempt_ctrlblk.boosted_this_gp = -1;
 		invoke_rcu_kthread();
-	}
+		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
+	} else
+		RCU_TRACE(rcu_initiate_exp_boost_trace());
 	raw_local_irq_restore(flags);
 }
 
@@ -308,13 +399,14 @@ static void rcu_preempt_cpu_qs(void)
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 
 	/* If there is no GP then there is nothing more to do.  */
-	if (!rcu_preempt_gp_in_progress() || rcu_preempt_blocked_readers_cgp())
+	if (!rcu_preempt_gp_in_progress())
 		return;
 	/* If there are blocked readers, go check up on boosting. */
 	if (rcu_preempt_blocked_readers_cgp()) {
 		rcu_initiate_boost();
 		return;
-	}
+	} else
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks++);
 
 	/* Advance callbacks. */
 	rcu_preempt_ctrlblk.completed = rcu_preempt_ctrlblk.gpnum;
@@ -339,6 +431,7 @@ static void rcu_preempt_start_gp(void)
 
 		/* Official start of GP. */
 		rcu_preempt_ctrlblk.gpnum++;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
 
 		/* Any blocked RCU readers block new GP. */
 		if (rcu_preempt_blocked_readers_any())
@@ -591,6 +684,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	local_irq_save(flags);
 	*rcu_preempt_ctrlblk.nexttail = head;
 	rcu_preempt_ctrlblk.nexttail = &head->next;
+	RCU_TRACE(rcu_preempt_ctrlblk.rcb.qlen++);
 	rcu_preempt_start_gp();  /* checks to see if GP needed. */
 	local_irq_restore(flags);
 }
@@ -747,6 +841,18 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * Because preemptible RCU does not exist, it is not necessary to
+ * dump out its statistics.
+ */
+static void show_tiny_preempt_stats(struct seq_file *m)
+{
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 /*
  * Because preemptible RCU does not exist, it is never necessary to
  * boost preempted RCU readers.
@@ -802,3 +908,97 @@ void __init rcu_scheduler_starting(void)
 #else /* #ifdef CONFIG_RCU_BOOST */
 #define RCU_BOOST_PRIO 1
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
+
+#ifdef CONFIG_RCU_TRACE
+
+#ifdef CONFIG_RCU_BOOST
+
+static void rcu_initiate_boost_trace(void)
+{
+	if (rcu_preempt_ctrlblk.gp_tasks == NULL)
+		rcu_preempt_ctrlblk.n_normal_balk_gp_tasks++;
+	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
+		rcu_preempt_ctrlblk.n_normal_balk_boost_tasks++;
+	else if (rcu_preempt_ctrlblk.boosted_this_gp != 0)
+		rcu_preempt_ctrlblk.n_normal_balk_boosted++;
+	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
+		rcu_preempt_ctrlblk.n_normal_balk_notyet++;
+	else
+		rcu_preempt_ctrlblk.n_normal_balk_nos++;
+}
+
+static void rcu_initiate_exp_boost_trace(void)
+{
+	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
+		rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks++;
+	else
+		rcu_preempt_ctrlblk.n_exp_balk_nos++;
+}
+
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	rcp->qlen -= n;
+	raw_local_irq_restore(flags);
+}
+
+/*
+ * Dump statistics for TINY_RCU, such as they are.
+ */
+static int show_tiny_stats(struct seq_file *m, void *unused)
+{
+	show_tiny_preempt_stats(m);
+	seq_printf(m, "rcu_sched: qlen: %ld\n", rcu_sched_ctrlblk.qlen);
+	seq_printf(m, "rcu_bh: qlen: %ld\n", rcu_bh_ctrlblk.qlen);
+	return 0;
+}
+
+static int show_tiny_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_tiny_stats, NULL);
+}
+
+static const struct file_operations show_tiny_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = show_tiny_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir;
+
+static int __init rcutiny_trace_init(void)
+{
+	struct dentry *retval;
+
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto free_out;
+	retval = debugfs_create_file("rcudata", 0444, rcudir,
+				     NULL, &show_tiny_stats_fops);
+	if (!retval)
+		goto free_out;
+	return 0;
+free_out:
+	debugfs_remove_recursive(rcudir);
+	return 1;
+}
+
+static void __exit rcutiny_trace_cleanup(void)
+{
+	debugfs_remove_recursive(rcudir);
+}
+
+module_init(rcutiny_trace_init);
+module_exit(rcutiny_trace_cleanup);
+
+MODULE_AUTHOR("Paul E. McKenney");
+MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
+MODULE_LICENSE("GPL");
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
-- 
1.7.0.6

