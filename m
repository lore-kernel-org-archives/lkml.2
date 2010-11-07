Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0KGCHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:07:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38297 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0KGCFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 02/12] rcu: move TINY_RCU from softirq to kthread
Date: Sat,  6 Nov 2010 19:05:22 -0700
Message-Id: <1289095532-5398-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If RCU priority boosting is to be meaningful, callback invocation must
be boosted in addition to preempted RCU readers.  Otherwise, in presence
of CPU real-time threads, the grace period ends, but the callbacks don't
get invoked.  If the callbacks don't get invoked, the associated memory
doesn't get freed, so the system is still subject to OOM.

But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
moves the callback invocations to a kthread, which can be boosted easily.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 -
 include/linux/rcutiny.h  |    8 ++---
 include/linux/rcutree.h  |    1 +
 kernel/rcutiny.c         |   71 +++++++++++++++++++++++++++++++++++++--------
 kernel/rcutiny_plugin.h  |   15 +++++----
 5 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 03cda7b..7142ee3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -118,7 +118,6 @@ static inline int rcu_preempt_depth(void)
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
-extern void rcu_init(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 13877cb..ea025a6 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,7 +27,9 @@
 
 #include <linux/cache.h>
 
-#define rcu_init_sched()	do { } while (0)
+static inline void rcu_init(void)
+{
+}
 
 #ifdef CONFIG_TINY_RCU
 
@@ -125,16 +127,12 @@ static inline void rcu_cpu_stall_reset(void)
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-
 extern int rcu_scheduler_active __read_mostly;
 extern void rcu_scheduler_starting(void);
-
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
 static inline void rcu_scheduler_starting(void)
 {
 }
-
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 95518e6..c0e9683 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,6 +30,7 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
+extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index d806735..86eef29 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -59,8 +59,15 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/* Controls for rcu_cbs() kthread, replacing RCU_SOFTIRQ used previously. */
+static struct task_struct *rcu_cbs_task;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_cbs_wq);
+static unsigned long have_rcu_cbs;
+static void invoke_rcu_cbs(void);
+
 /* Forward declarations for rcutiny_plugin.h. */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static int rcu_cbs(void *arg);
 static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
@@ -123,7 +130,7 @@ void rcu_sched_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cbs();
 }
 
 /*
@@ -132,7 +139,7 @@ void rcu_sched_qs(int cpu)
 void rcu_bh_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cbs();
 }
 
 /*
@@ -152,10 +159,10 @@ void rcu_check_callbacks(int cpu, int user)
 }
 
 /*
- * Helper function for rcu_process_callbacks() that operates on the
- * specified rcu_ctrlkblk structure.
+ * Invoke the RCU callbacks on the specified rcu_ctrlkblk structure
+ * whose grace period has elapsed.
  */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
 	struct rcu_head *next, *list;
 	unsigned long flags;
@@ -180,19 +187,52 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
+		local_bh_disable();
 		list->func(list);
+		local_bh_enable();
 		list = next;
 	}
 }
 
 /*
- * Invoke any callbacks whose grace period has completed.
+ * This kthread invokes RCU callbacks whose grace periods have
+ * elapsed.  It is awakened as needed, and takes the place of the
+ * RCU_SOFTIRQ that was used previously for this purpose.
+ * This is a kthread, but it is never stopped, at least not until
+ * the system goes down.
+ */
+static int rcu_cbs(void *arg)
+{
+	unsigned long work;
+	unsigned long flags;
+
+	for (;;) {
+		wait_event(rcu_cbs_wq, have_rcu_cbs != 0);
+		local_irq_save(flags);
+		work = have_rcu_cbs;
+		have_rcu_cbs = 0;
+		local_irq_restore(flags);
+		if (work) {
+			rcu_process_callbacks(&rcu_sched_ctrlblk);
+			rcu_process_callbacks(&rcu_bh_ctrlblk);
+			rcu_preempt_process_callbacks();
+		}
+	}
+
+	return 0;  /* Not reached, but needed to shut gcc up. */
+}
+
+/*
+ * Wake up rcu_cbs() to process callbacks now eligible for invocation.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void invoke_rcu_cbs(void)
 {
-	__rcu_process_callbacks(&rcu_sched_ctrlblk);
-	__rcu_process_callbacks(&rcu_bh_ctrlblk);
-	rcu_preempt_process_callbacks();
+	unsigned long flags;
+
+	local_irq_save(flags);
+	have_rcu_cbs = 1;
+	wake_up(&rcu_cbs_wq);
+	local_irq_restore(flags);
 }
 
 /*
@@ -282,7 +322,12 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
-void __init rcu_init(void)
+/*
+ * Spawn the kthread that invokes RCU callbacks.
+ */
+static int __init rcu_spawn_kthreads(void)
 {
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	rcu_cbs_task = kthread_run(rcu_cbs, NULL, "rcu_cbs");
+	return 0;
 }
+early_initcall(rcu_spawn_kthreads);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 6ceca4f..95f9239 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -22,6 +22,8 @@
  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
+#include <linux/kthread.h>
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -164,9 +166,9 @@ static void rcu_preempt_cpu_qs(void)
 	if (!rcu_preempt_blocked_readers_any())
 		rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.nexttail;
 
-	/* If there are done callbacks, make RCU_SOFTIRQ process them. */
+	/* If there are done callbacks, cause them to be invoked. */
 	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cbs();
 }
 
 /*
@@ -374,7 +376,7 @@ static void rcu_preempt_check_callbacks(void)
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_cbs();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader())
@@ -383,7 +385,7 @@ static void rcu_preempt_check_callbacks(void)
 
 /*
  * TINY_PREEMPT_RCU has an extra callback-list tail pointer to
- * update, so this is invoked from __rcu_process_callbacks() to
+ * update, so this is invoked from rcu_process_callbacks() to
  * handle that case.  Of course, it is invoked for all flavors of
  * RCU, but RCU callbacks can appear only on one of the lists, and
  * neither ->nexttail nor ->donetail can possibly be NULL, so there
@@ -400,7 +402,7 @@ static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_preempt_process_callbacks(void)
 {
-	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
+	rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
 }
 
 /*
@@ -599,14 +601,13 @@ static void rcu_preempt_process_callbacks(void)
 #endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-
 #include <linux/kernel_stat.h>
 
 /*
  * During boot, we forgive RCU lockdep issues.  After this function is
  * invoked, we start taking RCU lockdep issues seriously.
  */
-void rcu_scheduler_starting(void)
+void __init rcu_scheduler_starting(void)
 {
 	WARN_ON(nr_context_switches() > 0);
 	rcu_scheduler_active = 1;
-- 
1.7.0.6

