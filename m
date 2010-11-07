Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0KGCFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:05:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49746 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0KGCFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/12] rcu: priority boosting for TINY_PREEMPT_RCU
Date: Sat,  6 Nov 2010 19:05:23 -0700
Message-Id: <1289095532-5398-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean compile.  FIXME: needs a decent changelog entry.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |    9 ++-
 include/linux/sched.h     |   11 ++-
 init/Kconfig              |   39 +++++++++
 kernel/rcutiny.c          |   66 ++++++---------
 kernel/rcutiny_plugin.h   |  206 +++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 279 insertions(+), 52 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 2fea6c8..69f91aa 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -81,6 +81,12 @@ extern struct group_info init_groups;
  */
 # define CAP_INIT_BSET  CAP_FULL_SET
 
+#ifdef CONFIG_RCU_BOOST
+#define INIT_TASK_RCU_BOOST()						\
+	.rcu_boost_mutex = NULL,
+#else
+#define INIT_TASK_RCU_BOOST()
+#endif
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
@@ -92,7 +98,8 @@ extern struct group_info init_groups;
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()
+	INIT_TASK_RCU_TREE_PREEMPT()					\
+	INIT_TASK_RCU_BOOST()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e18473f..ed1a9bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1210,6 +1210,9 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rcu_boost_mutex;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1745,7 +1748,8 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
@@ -1753,7 +1757,10 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_read_unlock_special = 0;
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
-#endif
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	p->rcu_boost_mutex = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/init/Kconfig b/init/Kconfig
index a619a1a..8187783 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -450,6 +450,45 @@ config TREE_RCU_TRACE
 	  TREE_PREEMPT_RCU implementations, permitting Makefile to
 	  trivially select kernel/rcutree_trace.c.
 
+config RCU_BOOST
+	bool "Enable RCU priority boosting"
+	depends on TINY_PREEMPT_RCU
+	default n
+	help
+	  This option boosts the priority of preempted RCU readers that
+	  block the current preemptible RCU grace period for too long.
+	  This option also prevents heavy loads from blocking RCU
+	  callback invocation for all flavors of RCU.
+
+	  Say Y here if you are working with real-time apps or heavy loads
+	  Say N here if you are unsure.
+
+config RCU_BOOST_PRIO
+	int "Real-time priority to boost RCU readers to"
+	range 1 99
+	depends on RCU_BOOST
+	default 1
+	help
+	  This option specifies the real-time priority to which preempted
+	  RCU readers are to be boosted.  If you are working with CPU-bound
+	  real-time applications, you should specify a priority higher then
+	  the highest-priority CPU-bound application.
+
+	  Specify the real-time priority, or take the default if unsure.
+
+config RCU_BOOST_DELAY
+	int "Milliseconds to delay boosting after RCU grace-period start"
+	range 0 3000
+	depends on RCU_BOOST
+	default 500
+	help
+	  This option specifies the time to wait after the beginning of
+	  a given grace period before priority-boosting preempted RCU
+	  readers blocking that grace period.  Note that any RCU reader
+	  blocking an expedited RCU grace period is boosted immediately.
+
+	  Accept the default if unsure.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 86eef29..93d1665 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -36,38 +36,16 @@
 #include <linux/time.h>
 #include <linux/cpu.h>
 
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
-	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
-	struct rcu_head **curtail;	/* ->next pointer of last CB. */
-};
-
-/* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_sched_ctrlblk = {
-	.donetail	= &rcu_sched_ctrlblk.rcucblist,
-	.curtail	= &rcu_sched_ctrlblk.rcucblist,
-};
-
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
-	.donetail	= &rcu_bh_ctrlblk.rcucblist,
-	.curtail	= &rcu_bh_ctrlblk.rcucblist,
-};
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-int rcu_scheduler_active __read_mostly;
-EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
-/* Controls for rcu_cbs() kthread, replacing RCU_SOFTIRQ used previously. */
-static struct task_struct *rcu_cbs_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_cbs_wq);
-static unsigned long have_rcu_cbs;
-static void invoke_rcu_cbs(void);
+/* Controls for rcu_kthread() kthread, replacing RCU_SOFTIRQ used previously. */
+static struct task_struct *rcu_kthread_task;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static unsigned long have_rcu_kthread_work;
+static void invoke_rcu_kthread(void);
 
 /* Forward declarations for rcutiny_plugin.h. */
+struct rcu_ctrlblk;
 static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
-static int rcu_cbs(void *arg);
+static int rcu_kthread(void *arg);
 static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
@@ -130,7 +108,7 @@ void rcu_sched_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_cbs();
+		invoke_rcu_kthread();
 }
 
 /*
@@ -139,7 +117,7 @@ void rcu_sched_qs(int cpu)
 void rcu_bh_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_cbs();
+		invoke_rcu_kthread();
 }
 
 /*
@@ -201,37 +179,41 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
  * This is a kthread, but it is never stopped, at least not until
  * the system goes down.
  */
-static int rcu_cbs(void *arg)
+static int rcu_kthread(void *arg)
 {
 	unsigned long work;
+	unsigned long morework;
 	unsigned long flags;
 
 	for (;;) {
-		wait_event(rcu_cbs_wq, have_rcu_cbs != 0);
+		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
+		morework = rcu_boost();
 		local_irq_save(flags);
-		work = have_rcu_cbs;
-		have_rcu_cbs = 0;
+		work = have_rcu_kthread_work;
+		have_rcu_kthread_work = morework;
 		local_irq_restore(flags);
 		if (work) {
 			rcu_process_callbacks(&rcu_sched_ctrlblk);
 			rcu_process_callbacks(&rcu_bh_ctrlblk);
 			rcu_preempt_process_callbacks();
 		}
+		schedule_timeout_interruptible(1); /* Leave CPU for others. */
 	}
 
 	return 0;  /* Not reached, but needed to shut gcc up. */
 }
 
 /*
- * Wake up rcu_cbs() to process callbacks now eligible for invocation.
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
  */
-static void invoke_rcu_cbs(void)
+static void invoke_rcu_kthread(void)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	have_rcu_cbs = 1;
-	wake_up(&rcu_cbs_wq);
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
 	local_irq_restore(flags);
 }
 
@@ -327,7 +309,11 @@ EXPORT_SYMBOL_GPL(rcu_barrier_sched);
  */
 static int __init rcu_spawn_kthreads(void)
 {
-	rcu_cbs_task = kthread_run(rcu_cbs, NULL, "rcu_cbs");
+	struct sched_param sp;
+
+	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
+	sp.sched_priority = RCU_BOOST_PRIO;
+	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
 	return 0;
 }
 early_initcall(rcu_spawn_kthreads);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 95f9239..36d203c 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -24,6 +24,29 @@
 
 #include <linux/kthread.h>
 
+/* Global control variables for rcupdate callback mechanism. */
+struct rcu_ctrlblk {
+	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
+	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
+	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+};
+
+/* Definition for rcupdate control block. */
+static struct rcu_ctrlblk rcu_sched_ctrlblk = {
+	.donetail	= &rcu_sched_ctrlblk.rcucblist,
+	.curtail	= &rcu_sched_ctrlblk.rcucblist,
+};
+
+static struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.donetail	= &rcu_bh_ctrlblk.rcucblist,
+	.curtail	= &rcu_bh_ctrlblk.rcucblist,
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -55,10 +78,20 @@ struct rcu_preempt_ctrlblk {
 				/*  if there is no such task.  If there */
 				/*  is no current expedited grace period, */
 				/*  then there cannot be any such task. */
+#ifdef CONFIG_RCU_BOOST
+	struct list_head *boost_tasks;
+				/* Pointer to first task that needs to be */
+				/*  priority-boosted, or NULL if no priority */
+				/*  boosting is needed.  If there is no */
+				/*  current or expedited grace period, there */
+				/*  can be no such task. */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	u8 gpnum;		/* Current grace period. */
 	u8 gpcpu;		/* Last grace period blocked by the CPU. */
 	u8 completed;		/* Last grace period completed. */
 				/*  If all three are equal, RCU is idle. */
+	s8 boosted_this_gp;	/* Has boosting already happened? */
+	unsigned long boost_time; /* When to start boosting (jiffies) */
 };
 
 static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
@@ -124,6 +157,130 @@ static int rcu_preempt_gp_in_progress(void)
 }
 
 /*
+ * Advance a ->blkd_tasks-list pointer to the next entry, instead
+ * returning NULL if at the end of the list.
+ */
+static struct list_head *rcu_next_node_entry(struct task_struct *t)
+{
+	struct list_head *np;
+
+	np = t->rcu_node_entry.next;
+	if (np == &rcu_preempt_ctrlblk.blkd_tasks)
+		np = NULL;
+	return np;
+}
+
+#ifdef CONFIG_RCU_BOOST
+
+#include "rtmutex_common.h"
+
+/*
+ * Carry out RCU priority boosting on the task indicated by ->boost_tasks,
+ * and advance ->boost_tasks to the next task in the ->blkd_tasks list.
+ */
+static int rcu_boost(void)
+{
+	unsigned long flags;
+	struct rt_mutex mtx;
+	struct list_head *np;
+	struct task_struct *t;
+
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL)
+		return 0;  /* Nothing to boost. */
+	raw_local_irq_save(flags);
+	rcu_preempt_ctrlblk.boosted_this_gp++;
+	t = container_of(rcu_preempt_ctrlblk.boost_tasks, struct task_struct,
+			 rcu_node_entry);
+	np = rcu_next_node_entry(t);
+	rt_mutex_init_proxy_locked(&mtx, t);
+	t->rcu_boost_mutex = &mtx;
+	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	raw_local_irq_restore(flags);
+	rt_mutex_lock(&mtx);
+	rt_mutex_unlock(&mtx);
+	return rcu_preempt_ctrlblk.boost_tasks != NULL;
+}
+
+/*
+ * Check to see if it is now time to start boosting RCU readers blocking
+ * the current grace period, and, if so, tell the rcu_kthread_task to
+ * start boosting them.  If there is an expedited boost in progress,
+ * we wait for it to complete.
+ */
+static void rcu_initiate_boost(void)
+{
+	if (rcu_preempt_ctrlblk.gp_tasks != NULL &&
+	    rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.boosted_this_gp == 0 &&
+	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
+		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
+		invoke_rcu_kthread();
+	}
+}
+
+/*
+ * Initiate boosting for an expedited grace period.
+ */
+static void rcu_initiate_expedited_boost(void)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	if (!list_empty(&rcu_preempt_ctrlblk.blkd_tasks)) {
+		rcu_preempt_ctrlblk.boost_tasks =
+			rcu_preempt_ctrlblk.blkd_tasks.next;
+		rcu_preempt_ctrlblk.boosted_this_gp = -1;
+		invoke_rcu_kthread();
+	}
+	raw_local_irq_restore(flags);
+}
+
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000);
+
+/*
+ * Do priority-boost accounting for the start of a new grace period.
+ */
+static void rcu_preempt_boost_start_gp(void)
+{
+	rcu_preempt_ctrlblk.boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
+	if (rcu_preempt_ctrlblk.boosted_this_gp > 0)
+		rcu_preempt_ctrlblk.boosted_this_gp = 0;
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * If there is no RCU priority boosting, we don't boost.
+ */
+static int rcu_boost(void)
+{
+	return 0;
+}
+
+/*
+ * If there is no RCU priority boosting, we don't initiate boosting.
+ */
+static void rcu_initiate_boost(void)
+{
+}
+
+/*
+ * If there is no RCU priority boosting, we don't initiate expedited boosting.
+ */
+static void rcu_initiate_expedited_boost(void)
+{
+}
+
+/*
+ * If there is no RCU priority boosting, nothing to do at grace-period start.
+ */
+static void rcu_preempt_boost_start_gp(void)
+{
+}
+
+#endif /* else #ifdef CONFIG_RCU_BOOST */
+
+/*
  * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * in a quiescent state.  There might be any number of tasks blocked
@@ -150,12 +307,14 @@ static void rcu_preempt_cpu_qs(void)
 	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 
-	/*
-	 * If there is no GP, or if blocked readers are still blocking GP,
-	 * then there is nothing more to do.
-	 */
+	/* If there is no GP then there is nothing more to do.  */
 	if (!rcu_preempt_gp_in_progress() || rcu_preempt_blocked_readers_cgp())
 		return;
+	/* If there are blocked readers, go check up on boosting. */
+	if (rcu_preempt_blocked_readers_cgp()) {
+		rcu_initiate_boost();
+		return;
+	}
 
 	/* Advance callbacks. */
 	rcu_preempt_ctrlblk.completed = rcu_preempt_ctrlblk.gpnum;
@@ -168,7 +327,7 @@ static void rcu_preempt_cpu_qs(void)
 
 	/* If there are done callbacks, cause them to be invoked. */
 	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		invoke_rcu_cbs();
+		invoke_rcu_kthread();
 }
 
 /*
@@ -186,6 +345,9 @@ static void rcu_preempt_start_gp(void)
 			rcu_preempt_ctrlblk.gp_tasks =
 				rcu_preempt_ctrlblk.blkd_tasks.next;
 
+		/* Set up for RCU priority boosting. */
+		rcu_preempt_boost_start_gp();
+
 		/* If there is no running reader, CPU is done with GP. */
 		if (!rcu_preempt_running_reader())
 			rcu_preempt_cpu_qs();
@@ -306,14 +468,16 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		empty = !rcu_preempt_blocked_readers_cgp();
 		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
-		np = t->rcu_node_entry.next;
-		if (np == &rcu_preempt_ctrlblk.blkd_tasks)
-			np = NULL;
+		np = rcu_next_node_entry(t);
 		list_del(&t->rcu_node_entry);
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
 			rcu_preempt_ctrlblk.gp_tasks = np;
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
 			rcu_preempt_ctrlblk.exp_tasks = np;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.boost_tasks)
+			rcu_preempt_ctrlblk.boost_tasks = np;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		INIT_LIST_HEAD(&t->rcu_node_entry);
 
 		/*
@@ -333,6 +497,14 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		if (!empty_exp && rcu_preempt_ctrlblk.exp_tasks == NULL)
 			rcu_report_exp_done();
 	}
+#ifdef CONFIG_RCU_BOOST
+	/* Unboost self if was boosted. */
+	if (special & RCU_READ_UNLOCK_BOOSTED) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
+		rt_mutex_unlock(t->rcu_boost_mutex);
+		t->rcu_boost_mutex = NULL;
+	}
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	local_irq_restore(flags);
 }
 
@@ -376,7 +548,7 @@ static void rcu_preempt_check_callbacks(void)
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
-		invoke_rcu_cbs();
+		invoke_rcu_kthread();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader())
@@ -534,6 +706,7 @@ void synchronize_rcu_expedited(void)
 
 	/* Wait for tail of ->blkd_tasks list to drain. */
 	if (rcu_preempted_readers_exp())
+		rcu_initiate_expedited_boost();
 		wait_event(sync_rcu_preempt_exp_wq,
 			   !rcu_preempted_readers_exp());
 
@@ -575,6 +748,15 @@ void exit_rcu(void)
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 /*
+ * Because preemptible RCU does not exist, it is never necessary to
+ * boost preempted RCU readers.
+ */
+static int rcu_boost(void)
+{
+	return 0;
+}
+
+/*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
@@ -614,3 +796,9 @@ void __init rcu_scheduler_starting(void)
 }
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+#ifdef CONFIG_RCU_BOOST
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+#else /* #ifdef CONFIG_RCU_BOOST */
+#define RCU_BOOST_PRIO 1
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
-- 
1.7.0.6

