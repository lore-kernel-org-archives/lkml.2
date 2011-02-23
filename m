Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1BWBl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37417 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab1BWBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/11] rcu: Remove conditional compilation for RCU CPU stall warnings
Date: Tue, 22 Feb 2011 17:39:36 -0800
Message-Id: <1298425183-21265-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU CPU stall warnings can now be controlled using the
rcu_cpu_stall_suppress boot-time parameter or via the same parameter
from sysfs.  There is therefore no longer any reason to have
kernel config parameters for this feature.  This commit therefore
removes the RCU_CPU_STALL_DETECTOR and RCU_CPU_STALL_DETECTOR_RUNNABLE
kernel config parameters.  The RCU_CPU_STALL_TIMEOUT parameter remains
to allow the timeout to be tuned and the RCU_CPU_STALL_VERBOSE parameter
remains to allow task-stall information to be suppressed if desired.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/00-INDEX      |    2 +-
 Documentation/RCU/stallwarn.txt |   23 +++++++++++++----------
 kernel/rcutree.c                |   26 +-------------------------
 kernel/rcutree.h                |   12 ------------
 kernel/rcutree_plugin.h         |   12 ------------
 lib/Kconfig.debug               |   30 ++----------------------------
 6 files changed, 17 insertions(+), 88 deletions(-)

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 71b6f50..1d7a885 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -21,7 +21,7 @@ rcu.txt
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 stallwarn.txt
-	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
+	- RCU CPU stall warnings (module parameter rcu_cpu_stall_suppress)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 862c08e..4e95920 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -1,22 +1,25 @@
 Using RCU's CPU Stall Detector
 
-The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
-RCU's CPU stall detector, which detects conditions that unduly delay
-RCU grace periods.  The stall detector's idea of what constitutes
-"unduly delayed" is controlled by a set of C preprocessor macros:
+The rcu_cpu_stall_suppress module parameter enables RCU's CPU stall
+detector, which detects conditions that unduly delay RCU grace periods.
+This module parameter enables CPU stall detection by default, but
+may be overridden via boot-time parameter or at runtime via sysfs.
+The stall detector's idea of what constitutes "unduly delayed" is
+controlled by a set of kernel configuration variables and cpp macros:
 
-RCU_SECONDS_TILL_STALL_CHECK
+CONFIG_RCU_CPU_STALL_TIMEOUT
 
-	This macro defines the period of time that RCU will wait from
-	the beginning of a grace period until it issues an RCU CPU
-	stall warning.	This time period is normally ten seconds.
+	This kernel configuration parameter defines the period of time
+	that RCU will wait from the beginning of a grace period until it
+	issues an RCU CPU stall warning.  This time period is normally
+	ten seconds.
 
 RCU_SECONDS_TILL_STALL_RECHECK
 
 	This macro defines the period of time that RCU will wait after
 	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to thirty
-	seconds.
+	for the same stall.  This time period is normally set to three
+	times the check interval plus thirty seconds.
 
 RCU_STALL_RAT_DELAY
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d0ddfea..5513129 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -140,10 +140,8 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
+int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -450,8 +448,6 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -587,26 +583,6 @@ static void __init check_cpu_stall_init(void)
 	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
 }
 
-#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-static void record_gp_stall_check_time(struct rcu_state *rsp)
-{
-}
-
-static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-}
-
-void rcu_cpu_stall_reset(void)
-{
-}
-
-static void __init check_cpu_stall_init(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e8f057e..e1a6663 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -254,7 +254,6 @@ struct rcu_data {
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA	       (5 * HZ)
@@ -272,13 +271,6 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
-#define RCU_CPU_STALL_SUPPRESS_INIT 0
-#else
-#define RCU_CPU_STALL_SUPPRESS_INIT 1
-#endif
-
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
@@ -325,12 +317,10 @@ struct rcu_state {
 						/*  due to lock unavailable. */
 	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
 						/*  due to no GP active. */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	char *name;				/* Name of structure. */
 };
 
@@ -366,11 +356,9 @@ static int rcu_preempted_readers(struct rcu_node *rnp);
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 static void rcu_preempt_stall_reset(void);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a363871..38426ef 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -54,10 +54,6 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
-#ifndef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO
-	       "\tRCU-based detection of stalled CPUs is disabled.\n");
-#endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
@@ -356,8 +352,6 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
@@ -430,8 +424,6 @@ static void rcu_preempt_stall_reset(void)
 	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Check that the list of blocked tasks for the newly completed grace
  * period is in fact empty.  It is a serious bug to complete a grace
@@ -862,8 +854,6 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
 /*
  * Because preemptable RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
@@ -888,8 +878,6 @@ static void rcu_preempt_stall_reset(void)
 {
 }
 
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
 /*
  * Because there is no preemptable RCU, there can be no readers blocked,
  * so there is no need to check for blocked tasks.  So check only for
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28b42b9..9296cc7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -862,22 +862,9 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default y
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say N if you want to disable such checks.
-
-	  Say Y if you are unsure.
-
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on RCU_CPU_STALL_DETECTOR
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	range 3 300
 	default 60
 	help
@@ -886,22 +873,9 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
-config RCU_CPU_STALL_DETECTOR_RUNNABLE
-	bool "RCU CPU stall checking starts automatically at boot"
-	depends on RCU_CPU_STALL_DETECTOR
-	default y
-	help
-	  If set, start checking for RCU CPU stalls immediately on
-	  boot.  Otherwise, RCU CPU stall checking must be manually
-	  enabled.
-
-	  Say Y if you are unsure.
-
-	  Say N if you wish to suppress RCU CPU stall checking during boot.
-
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
+	depends on TREE_PREEMPT_RCU
 	default y
 	help
 	  This option causes RCU to printk detailed per-task information
-- 
1.7.3.2

