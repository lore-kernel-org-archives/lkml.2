Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2J3Qr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:47:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43597 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2J3Qr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:47:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: Provide RCU CPU stall warnings for tiny RCU
Date: Tue, 30 Oct 2012 09:46:49 -0700
Message-Id: <1351615609-25316-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030164622.GA25108@linux.vnet.ibm.com>
 <1351615609-25316-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5518-0000-0000-000008D6DF6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Tiny RCU has historically omitted RCU CPU stall warnings in order to
reduce memory requirements, however, lack of these warnings caused
Thomas Gleixner some debugging pain recently.  Therefore, this commit
adds RCU CPU stall warnings to tiny RCU if RCU_TRACE=y.  This keeps
the memory footprint small, while still enabling CPU stall warnings
in kernels built to enable them.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu.h            |    7 ++++++
 kernel/rcupdate.c       |   52 +++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c        |    6 +++-
 kernel/rcutiny_plugin.h |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree.c        |   46 ++------------------------------------
 kernel/rcutree.h        |    5 ----
 lib/Kconfig.debug       |    2 +-
 7 files changed, 123 insertions(+), 51 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 8ba99cd..a88fa9f 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -109,4 +109,11 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 	}
 }
 
+#if defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE)
+
+extern int rcu_cpu_stall_suppress;
+int rcu_jiffies_till_stall_check(void);
+
+#endif /* defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) */
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 29ca1c6..0b69443 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,6 +46,7 @@
 #include <linux/export.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
+#include <linux/moduleparam.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
@@ -409,3 +410,54 @@ EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #else
 #define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
 #endif
+
+#if defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE)
+
+#ifdef CONFIG_PROVE_RCU
+#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
+#else
+#define RCU_STALL_DELAY_DELTA	       0
+#endif
+
+int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
+int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+
+module_param(rcu_cpu_stall_suppress, int, 0644);
+module_param(rcu_cpu_stall_timeout, int, 0644);
+
+int rcu_jiffies_till_stall_check(void)
+{
+	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
+
+	/*
+	 * Limit check must be consistent with the Kconfig limits
+	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
+	 */
+	if (till_stall_check < 3) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
+		till_stall_check = 3;
+	} else if (till_stall_check > 300) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
+		till_stall_check = 300;
+	}
+	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
+}
+
+static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	rcu_cpu_stall_suppress = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rcu_panic_block = {
+	.notifier_call = rcu_panic,
+};
+
+static int __init check_cpu_stall_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+	return 0;
+}
+early_initcall(check_cpu_stall_init);
+
+#endif /* defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e4c6a59..386e776 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -51,10 +51,10 @@ static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
 
-#include "rcutiny_plugin.h"
-
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
+#include "rcutiny_plugin.h"
+
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
@@ -205,6 +205,7 @@ int rcu_is_cpu_rrupt_from_idle(void)
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
+	reset_cpu_stall_ticks(rcp);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
@@ -251,6 +252,7 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	check_cpu_stalls();
 	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3d01902..0ee65f8 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -33,6 +33,9 @@ struct rcu_ctrlblk {
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
 	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+	RCU_TRACE(unsigned long gp_start); /* Start time for stalls. */
+	RCU_TRACE(unsigned long ticks_this_gp); /* Statistic for stalls. */
+	RCU_TRACE(unsigned long jiffies_stall); /* Jiffies at next stall. */
 	RCU_TRACE(char *name);		/* Name of RCU type. */
 };
 
@@ -54,6 +57,51 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#ifdef CONFIG_RCU_TRACE
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long j;
+	unsigned long js;
+
+	if (rcu_cpu_stall_suppress)
+		return;
+	rcp->ticks_this_gp++;
+	j = jiffies;
+	js = rcp->jiffies_stall;
+	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+		printk(KERN_ERR "INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
+		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
+		       jiffies - rcp->gp_start, rcp->qlen);
+		dump_stack();
+	}
+	if (*rcp->curtail && ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies +
+			3 * rcu_jiffies_till_stall_check() + 3;
+	else if (ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
+static void check_cpu_stall_preempt(void);
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
+static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
+{
+#ifdef CONFIG_RCU_TRACE
+	rcp->ticks_this_gp = 0;
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+#endif /* #ifdef CONFIG_RCU_TRACE */
+}
+
+static void check_cpu_stalls(void)
+{
+	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
+	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
+	RCU_TRACE(check_cpu_stall_preempt());
+}
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -448,6 +496,7 @@ static void rcu_preempt_start_gp(void)
 		/* Official start of GP. */
 		rcu_preempt_ctrlblk.gpnum++;
 		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
+		reset_cpu_stall_ticks(&rcu_preempt_ctrlblk.rcb);
 
 		/* Any blocked RCU readers block new GP. */
 		if (rcu_preempt_blocked_readers_any())
@@ -1051,4 +1100,11 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
+static void check_cpu_stall_preempt(void)
+{
+#ifdef CONFIG_TINY_PREEMPT_RCU
+	check_cpu_stall(&rcu_preempt_ctrlblk.rcb);
+#endif /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+}
+
 #endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 24b21cb..8ef8152 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -220,12 +220,6 @@ module_param(blimit, int, 0444);
 module_param(qhimark, int, 0444);
 module_param(qlowmark, int, 0444);
 
-int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
-int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
-
-module_param(rcu_cpu_stall_suppress, int, 0644);
-module_param(rcu_cpu_stall_timeout, int, 0644);
-
 static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 
@@ -849,28 +843,10 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return 0;
 }
 
-static int jiffies_till_stall_check(void)
-{
-	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
-
-	/*
-	 * Limit check must be consistent with the Kconfig limits
-	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
-	 */
-	if (till_stall_check < 3) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
-		till_stall_check = 3;
-	} else if (till_stall_check > 300) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
-		till_stall_check = 300;
-	}
-	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
-}
-
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
+	rsp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
 }
 
 /*
@@ -913,7 +889,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
+	rsp->jiffies_stall = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -991,7 +967,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall = jiffies +
-				     3 * jiffies_till_stall_check() + 3;
+				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
@@ -1022,12 +998,6 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 }
 
-static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
-{
-	rcu_cpu_stall_suppress = 1;
-	return NOTIFY_DONE;
-}
-
 /**
  * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
  *
@@ -1045,15 +1015,6 @@ void rcu_cpu_stall_reset(void)
 		rsp->jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-static struct notifier_block rcu_panic_block = {
-	.notifier_call = rcu_panic,
-};
-
-static void __init check_cpu_stall_init(void)
-{
-	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
-}
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
@@ -3009,7 +2970,6 @@ void __init rcu_init(void)
 	cpu_notifier(rcu_cpu_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-	check_cpu_stall_init();
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a240f03..0a318db 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -330,11 +330,6 @@ struct rcu_data {
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
-#ifdef CONFIG_PROVE_RCU
-#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
-#else
-#define RCU_STALL_DELAY_DELTA	       0
-#endif
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28e9d6c9..6a4b500 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -970,7 +970,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE
 	range 3 300
 	default 60
 	help
-- 
1.7.8

