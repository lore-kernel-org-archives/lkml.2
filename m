Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1EANgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:36:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53867 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab1EANW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/86] rcu: make rcutorture version numbers available through debugfs
Date: Sun,  1 May 2011 06:20:56 -0700
Message-Id: <1304256126-26015-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

It is not possible to accurately correlate rcutorture output with that
of debugfs.  This patch therefore adds a debugfs file that prints out
the rcutorture version number, permitting easy correlation.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   13 ++++++++++++-
 include/linux/rcutree.h  |    3 +++
 kernel/rcutorture.c      |    8 +++++---
 kernel/rcutree.c         |   37 +++++++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c   |   28 ++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ff422d2..9e169c2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,18 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+extern void rcutorture_record_test_transition(void);
+extern void rcutorture_record_progress(unsigned long vernum);
+#else
+static inline void rcutorture_record_test_transition(void)
+{
+}
+static inline void rcutorture_record_progress(unsigned long vernum)
+{
+}
+#endif
+
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
@@ -68,7 +80,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
-extern int sched_expedited_torture_stats(char *page);
 
 static inline void __rcu_read_lock_bh(void)
 {
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3a93348..284dad1 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -58,9 +58,12 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void rcu_barrier(void);
 
+extern unsigned long rcutorture_testseq;
+extern unsigned long rcutorture_vernum;
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
+
 extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 62ec8ee6..735d172 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -131,7 +131,7 @@ struct rcu_torture {
 
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture __rcu *rcu_torture_current;
-static long rcu_torture_current_version;
+static unsigned long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
@@ -886,7 +886,7 @@ rcu_torture_writer(void *arg)
 			old_rp->rtort_pipe_count++;
 			cur_ops->deferred_free(old_rp);
 		}
-		rcu_torture_current_version++;
+		rcutorture_record_progress(++rcu_torture_current_version);
 		oldbatch = cur_ops->completed();
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
@@ -1066,7 +1066,7 @@ rcu_torture_printk(char *page)
 	}
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
-		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
+		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
 		       "rtmbe: %d rtbke: %ld rtbre: %ld "
 		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
@@ -1329,6 +1329,7 @@ rcu_torture_cleanup(void)
 	int i;
 
 	mutex_lock(&fullstop_mutex);
+	rcutorture_record_test_transition();
 	if (fullstop == FULLSTOP_SHUTDOWN) {
 		printk(KERN_WARNING /* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
@@ -1622,6 +1623,7 @@ rcu_torture_init(void)
 		}
 	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
+	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a591694..c1f5434 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -102,6 +102,18 @@ static void invoke_rcu_cpu_kthread(void);
 #define RCU_KTHREAD_PRIO 1	/* RT priority for per-CPU kthreads. */
 
 /*
+ * Track the rcutorture test sequence number and the update version
+ * number within a given test.  The rcutorture_testseq is incremented
+ * on every rcutorture module load and unload, so has an odd value
+ * when a test is running.  The rcutorture_vernum is set to zero
+ * when rcutorture starts and is incremented on each rcutorture update.
+ * These variables enable correlating rcutorture output with the
+ * RCU tracing information.
+ */
+unsigned long rcutorture_testseq;
+unsigned long rcutorture_vernum;
+
+/*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
  * structure's ->lock, but of course results can be subject to change.
@@ -193,6 +205,31 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
+ * Record the number of times rcutorture tests have been initiated and
+ * terminated.  This information allows the debugfs tracing stats to be
+ * correlated to the rcutorture messages, even when the rcutorture module
+ * is being repeatedly loaded and unloaded.  In other words, we cannot
+ * store this state in rcutorture itself.
+ */
+void rcutorture_record_test_transition(void)
+{
+	rcutorture_testseq++;
+	rcutorture_vernum = 0;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
+
+/*
+ * Record the number of writer passes through the current rcutorture test.
+ * This is also used to correlate debugfs tracing stats with the rcutorture
+ * messages.
+ */
+void rcutorture_record_progress(unsigned long vernum)
+{
+	rcutorture_vernum++;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_progress);
+
+/*
  * Force a quiescent state for RCU-sched.
  */
 void rcu_sched_force_quiescent_state(void)
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index fc40e89..3baa235 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -394,6 +394,29 @@ static const struct file_operations rcu_pending_fops = {
 	.release = single_release,
 };
 
+static int show_rcutorture(struct seq_file *m, void *unused)
+{
+	seq_printf(m, "rcutorture test sequence: %lu %s\n",
+		   rcutorture_testseq >> 1,
+		   (rcutorture_testseq & 0x1) ? "(test in progress)" : "");
+	seq_printf(m, "rcutorture update version number: %lu\n",
+		   rcutorture_vernum);
+	return 0;
+}
+
+static int rcutorture_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcutorture, NULL);
+}
+
+static const struct file_operations rcutorture_fops = {
+	.owner = THIS_MODULE,
+	.open = rcutorture_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
@@ -430,6 +453,11 @@ static int __init rcutree_trace_init(void)
 						NULL, &rcu_pending_fops);
 	if (!retval)
 		goto free_out;
+
+	retval = debugfs_create_file("rcutorture", 0444, rcudir,
+						NULL, &rcutorture_fops);
+	if (!retval)
+		goto free_out;
 	return 0;
 free_out:
 	debugfs_remove_recursive(rcudir);
-- 
1.7.3.2

