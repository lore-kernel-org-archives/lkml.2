Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2DWQRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49060 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2DWQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 3/4] rcu: Make RCU_FAST_NO_HZ account for pauses out of idle
Date: Mon, 23 Apr 2012 09:16:00 -0700
Message-Id: <1335197761-6577-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-3352-0000-0000-000004367026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Both Steven Rostedt's new idle-capable trace macros and the RCU_NONIDLE()
macro can cause RCU to momentarily pause out of idle without the rest
of the system being involved.  This can cause rcu_prepare_for_idle()
to run through its state machine too quickly, which can in turn result
in needless scheduling-clock interrupts.

This commit therefore adds code to enable rcu_prepare_for_idle() to
distinguish between an initial entry to idle on the one hand (which needs
to advance the rcu_prepare_for_idle() state machine) and an idle reentry
due to idle-capable trace macros and RCU_NONIDLE() on the other hand
(which should avoid advancing the rcu_prepare_for_idle() state machine).
Additional state is maintained to allow the timer to be correctly reposted
when returning after a momentary pause out of idle, and even more state
is maintained to detect when new non-lazy callbacks have been enqueued
(which may require re-evaluation of the approach to idleness).

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 +
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   57 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..403306b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1829,6 +1829,8 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->qlen++;
 	if (lazy)
 		rdp->qlen_lazy++;
+	else
+		rcu_idle_count_callbacks_posted();
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..36ca28e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -471,6 +471,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0f007b3..50c1797 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1938,6 +1938,14 @@ static void rcu_prepare_for_idle(int cpu)
 {
 }
 
+/*
+ * Don't bother keeping a running count of the number of RCU callbacks
+ * posted because CONFIG_RCU_FAST_NO_HZ=n.
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+}
+
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 /*
@@ -1981,6 +1989,10 @@ static void rcu_prepare_for_idle(int cpu)
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
+static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
+static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -1993,6 +2005,8 @@ static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
  */
 int rcu_needs_cpu(int cpu)
 {
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 	/* If no callbacks, RCU doesn't need the CPU. */
 	if (!rcu_cpu_has_callbacks(cpu))
 		return 0;
@@ -2096,6 +2110,26 @@ static void rcu_cleanup_after_idle(int cpu)
 static void rcu_prepare_for_idle(int cpu)
 {
 	/*
+	 * If this is an idle re-entry, for example, due to use of
+	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
+	 * loop, then don't take any state-machine actions, unless the
+	 * momentary exit from idle queued additional non-lazy callbacks.
+	 * Instead, repost the rcu_idle_gp_timer if this CPU has callbacks
+	 * pending.
+	 */
+	if (!per_cpu(rcu_idle_first_pass, cpu) &&
+	    (per_cpu(rcu_nonlazy_posted, cpu) ==
+	     per_cpu(rcu_nonlazy_posted_snap, cpu))) {
+		if (rcu_cpu_has_callbacks(cpu))
+			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+				  per_cpu(rcu_idle_gp_timer_expires, cpu));
+		return;
+	}
+	per_cpu(rcu_idle_first_pass, cpu) = 0;
+	per_cpu(rcu_nonlazy_posted_snap, cpu) =
+		per_cpu(rcu_nonlazy_posted, cpu) - 1;
+
+	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
 	 */
@@ -2127,11 +2161,15 @@ static void rcu_prepare_for_idle(int cpu)
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
-			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-					   jiffies + RCU_IDLE_GP_DELAY);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_GP_DELAY;
 		else
-			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-					   jiffies + RCU_IDLE_LAZY_GP_DELAY);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
+		mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+			  per_cpu(rcu_idle_gp_timer_expires, cpu));
+		per_cpu(rcu_nonlazy_posted_snap, cpu) =
+			per_cpu(rcu_nonlazy_posted, cpu);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
@@ -2171,6 +2209,17 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Callbacks drained");
 }
 
+/*
+ * Keep a running count of callbacks posted so that rcu_prepare_for_idle()
+ * can detect when something out of the idle loop posts a callback.
+ * Of course, it had better do so either from a trace event designed to
+ * be called from idle or from within RCU_NONIDLE().
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+	__this_cpu_add(rcu_nonlazy_posted, 1);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
-- 
1.7.8

