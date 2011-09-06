Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1IGGVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37859 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1IGGVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/55] rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
Date: Tue,  6 Sep 2011 11:00:15 -0700
Message-Id: <1315332049-2604-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711881
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This patch #ifdefs TINY_RCU kthreads out of the kernel unless RCU_BOOST=y,
thus eliminating context-switch overhead if RCU priority boosting has
not been configured.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |    4 ++
 kernel/rcutiny.c        |   74 ++++---------------------------
 kernel/rcutiny_plugin.h |  110 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 97 insertions(+), 91 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 4eab233..00b7a5e 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,9 +27,13 @@
 
 #include <linux/cache.h>
 
+#ifdef CONFIG_RCU_BOOST
 static inline void rcu_init(void)
 {
 }
+#else /* #ifdef CONFIG_RCU_BOOST */
+void rcu_init(void);
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 static inline void rcu_barrier_bh(void)
 {
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 1c37bdd..c9321d8 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -43,16 +43,11 @@
 
 #include "rcu.h"
 
-/* Controls for rcu_kthread() kthread, replacing RCU_SOFTIRQ used previously. */
-static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
-static unsigned long have_rcu_kthread_work;
-
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
-static void invoke_rcu_kthread(void);
-static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
-static int rcu_kthread(void *arg);
+static void invoke_rcu_callbacks(void);
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static void rcu_process_callbacks(struct softirq_action *unused);
 static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
@@ -102,16 +97,6 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 }
 
 /*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_kthread(void)
-{
-	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
-}
-
-/*
  * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
@@ -123,7 +108,7 @@ void rcu_sched_qs(int cpu)
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	local_irq_restore(flags);
 }
 
@@ -136,7 +121,7 @@ void rcu_bh_qs(int cpu)
 
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	local_irq_restore(flags);
 }
 
@@ -160,7 +145,7 @@ void rcu_check_callbacks(int cpu, int user)
  * Invoke the RCU callbacks on the specified rcu_ctrlkblk structure
  * whose grace period has elapsed.
  */
-static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
 	struct rcu_head *next, *list;
 	unsigned long flags;
@@ -200,36 +185,11 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count));
 }
 
-/*
- * This kthread invokes RCU callbacks whose grace periods have
- * elapsed.  It is awakened as needed, and takes the place of the
- * RCU_SOFTIRQ that was used previously for this purpose.
- * This is a kthread, but it is never stopped, at least not until
- * the system goes down.
- */
-static int rcu_kthread(void *arg)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
-	unsigned long work;
-	unsigned long morework;
-	unsigned long flags;
-
-	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
-		morework = rcu_boost();
-		local_irq_save(flags);
-		work = have_rcu_kthread_work;
-		have_rcu_kthread_work = morework;
-		local_irq_restore(flags);
-		if (work) {
-			rcu_process_callbacks(&rcu_sched_ctrlblk);
-			rcu_process_callbacks(&rcu_bh_ctrlblk);
-			rcu_preempt_process_callbacks();
-		}
-		schedule_timeout_interruptible(1); /* Leave CPU for others. */
-	}
-
-	return 0;  /* Not reached, but needed to shut gcc up. */
+	__rcu_process_callbacks(&rcu_sched_ctrlblk);
+	__rcu_process_callbacks(&rcu_bh_ctrlblk);
+	rcu_preempt_process_callbacks();
 }
 
 /*
@@ -291,17 +251,3 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
-
-/*
- * Spawn the kthread that invokes RCU callbacks.
- */
-static int __init rcu_spawn_kthreads(void)
-{
-	struct sched_param sp;
-
-	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
-	sp.sched_priority = RCU_BOOST_PRIO;
-	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
-	return 0;
-}
-early_initcall(rcu_spawn_kthreads);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 791ddf7..02aa713 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -245,6 +245,13 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 
 #include "rtmutex_common.h"
 
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+
+/* Controls for rcu_kthread() kthread. */
+static struct task_struct *rcu_kthread_task;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static unsigned long have_rcu_kthread_work;
+
 /*
  * Carry out RCU priority boosting on the task indicated by ->boost_tasks,
  * and advance ->boost_tasks to the next task in the ->blkd_tasks list.
@@ -332,7 +339,7 @@ static int rcu_initiate_boost(void)
 		if (rcu_preempt_ctrlblk.exp_tasks == NULL)
 			rcu_preempt_ctrlblk.boost_tasks =
 				rcu_preempt_ctrlblk.gp_tasks;
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	} else
 		RCU_TRACE(rcu_initiate_boost_trace());
 	return 1;
@@ -351,14 +358,6 @@ static void rcu_preempt_boost_start_gp(void)
 #else /* #ifdef CONFIG_RCU_BOOST */
 
 /*
- * If there is no RCU priority boosting, we don't boost.
- */
-static int rcu_boost(void)
-{
-	return 0;
-}
-
-/*
  * If there is no RCU priority boosting, we don't initiate boosting,
  * but we do indicate whether there are blocked readers blocking the
  * current grace period.
@@ -425,7 +424,7 @@ static void rcu_preempt_cpu_qs(void)
 
 	/* If there are done callbacks, cause them to be invoked. */
 	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 }
 
 /*
@@ -646,7 +645,7 @@ static void rcu_preempt_check_callbacks(void)
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
-		invoke_rcu_kthread();
+		invoke_rcu_callbacks();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader())
@@ -672,7 +671,7 @@ static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_preempt_process_callbacks(void)
 {
-	rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
+	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
 }
 
 /*
@@ -848,15 +847,6 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
 /*
- * Because preemptible RCU does not exist, it is never necessary to
- * boost preempted RCU readers.
- */
-static int rcu_boost(void)
-{
-	return 0;
-}
-
-/*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
@@ -882,6 +872,78 @@ static void rcu_preempt_process_callbacks(void)
 
 #endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_BOOST
+
+/*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_callbacks(void)
+{
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+}
+
+/*
+ * This kthread invokes RCU callbacks whose grace periods have
+ * elapsed.  It is awakened as needed, and takes the place of the
+ * RCU_SOFTIRQ that is used for this purpose when boosting is disabled.
+ * This is a kthread, but it is never stopped, at least not until
+ * the system goes down.
+ */
+static int rcu_kthread(void *arg)
+{
+	unsigned long work;
+	unsigned long morework;
+	unsigned long flags;
+
+	for (;;) {
+		wait_event_interruptible(rcu_kthread_wq,
+					 have_rcu_kthread_work != 0);
+		morework = rcu_boost();
+		local_irq_save(flags);
+		work = have_rcu_kthread_work;
+		have_rcu_kthread_work = morework;
+		local_irq_restore(flags);
+		if (work)
+			rcu_process_callbacks(NULL);
+		schedule_timeout_interruptible(1); /* Leave CPU for others. */
+	}
+
+	return 0;  /* Not reached, but needed to shut gcc up. */
+}
+
+/*
+ * Spawn the kthread that invokes RCU callbacks.
+ */
+static int __init rcu_spawn_kthreads(void)
+{
+	struct sched_param sp;
+
+	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
+	sp.sched_priority = RCU_BOOST_PRIO;
+	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
+	return 0;
+}
+early_initcall(rcu_spawn_kthreads);
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * Start up softirq processing of callbacks.
+ */
+void invoke_rcu_callbacks(void)
+{
+	raise_softirq(RCU_SOFTIRQ);
+}
+
+void rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #include <linux/kernel_stat.h>
 
@@ -897,12 +959,6 @@ void __init rcu_scheduler_starting(void)
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-#ifdef CONFIG_RCU_BOOST
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-#else /* #ifdef CONFIG_RCU_BOOST */
-#define RCU_BOOST_PRIO 1
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
-
 #ifdef CONFIG_RCU_TRACE
 
 #ifdef CONFIG_RCU_BOOST
-- 
1.7.3.2

