Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1LCSfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:35:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57178 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab1LCSez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:34:55 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 4/7] rcu: Adaptive dyntick-idle preparation
Date: Sat,  3 Dec 2011 10:34:39 -0800
Message-Id: <1322937282-19846-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-9360-0000-0000-000001361775
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

If there are other CPUs active at a given point in time, then there is a
limit to what a given CPU can do to advance the current RCU grace period.
Beyond this limit, attempting to force the RCU grace period forward will
do nothing but consume energy burning CPU cycles.

Therefore, this commit takes an adaptive approach to RCU_FAST_NO_HZ
preparations for idle.  It pushes the RCU core state machine for
two cycles unconditionally, and then it will push from zero to three
additional cycles, but only as long as the RCU core has work for this
CPU to do immediately.  The rcu_pending() function is used to check
whether the RCU core has such work.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   54 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index adb6e66..8cd9efe 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1994,8 +1994,40 @@ static void rcu_prepare_for_idle(int cpu)
 
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
-#define RCU_NEEDS_CPU_FLUSHES 5		/* Allow for callback self-repost. */
+/*
+ * This code is invoked when a CPU goes idle, at which point we want
+ * to have the CPU do everything required for RCU so that it can enter
+ * the energy-efficient dyntick-idle mode.  This is handled by a
+ * state machine implemented by rcu_prepare_for_idle() below.
+ *
+ * The following three proprocessor symbols control this state machine:
+ *
+ * RCU_IDLE_FLUSHES gives the maximum number of times that we will attempt
+ *	to satisfy RCU.  Beyond this point, it is better to incur a periodic
+ *	scheduling-clock interrupt than to loop through the state machine
+ *	at full power.
+ * RCU_IDLE_OPT_FLUSHES gives the number of RCU_IDLE_FLUSHES that are
+ *	optional if RCU does not need anything immediately from this
+ *	CPU, even if this CPU still has RCU callbacks queued.  The first
+ *	times through the state machine are mandatory: we need to give
+ *	the state machine a chance to communicate a quiescent state
+ *	to the RCU core.
+ * RCU_IDLE_GP_DELAY gives the number of jiffies that a CPU is permitted
+ *	to sleep in dyntick-idle mode with RCU callbacks pending.  This
+ *	is sized to be roughly one RCU grace period.  Those energy-efficiency
+ *	benchmarkers who might otherwise be tempted to set this to a large
+ *	number, be warned: Setting RCU_IDLE_GP_DELAY too high can hang your
+ *	system.  And if you are -that- concerned about energy efficiency,
+ *	just power the system down and be done with it!
+ *
+ * The values below work well in practice.  If future workloads require
+ * adjustment, they can be converted into kernel config parameters, though
+ * making the state machine smarter might be a better option.
+ */
+#define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
+#define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
+
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
@@ -2110,17 +2142,17 @@ static void rcu_prepare_for_idle(int cpu)
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* First time through, initialize the counter. */
-		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
-	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		per_cpu(rcu_dyntick_drain, cpu) = RCU_IDLE_FLUSHES;
+	} else if (per_cpu(rcu_dyntick_drain, cpu) <= RCU_IDLE_OPT_FLUSHES &&
+		   !rcu_pending(cpu)) {
 		/* Can we go dyntick-idle despite still having callbacks? */
-		if (!rcu_pending(cpu)) {
-			trace_rcu_prep_idle("Dyntick with callbacks");
-			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
-			return; /* Nothing more to do immediately. */
-		}
-
+		trace_rcu_prep_idle("Dyntick with callbacks");
+		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+			      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		return; /* Nothing more to do immediately. */
+	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		local_irq_restore(flags);
-- 
1.7.3.2

