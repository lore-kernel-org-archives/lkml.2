Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1K1Xds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:48 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53644 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1K1Xdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:43 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 05/13] rcu: Add tracing for RCU_FAST_NO_HZ
Date: Mon, 28 Nov 2011 15:32:57 -0800
Message-Id: <1322523185-456-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-5806-0000-0000-00000E8602B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit adds trace_rcu_prep_idle(), which is invoked from
rcu_prepare_for_idle() and rcu_wake_cpu() to trace attempts on
the part of RCU to force CPUs into dyntick-idle mode.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   37 +++++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h    |   18 +++++++++++++++---
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 7f6877a..debe453 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -275,6 +275,42 @@ TRACE_EVENT(rcu_dyntick,
 );
 
 /*
+ * Tracepoint for RCU preparation for idle, the goal being to get RCU
+ * processing done so that the current CPU can shut off its scheduling
+ * clock and enter dyntick-idle mode.  One way to accomplish this is
+ * to drain all RCU callbacks from this CPU, and the other is to have
+ * done everything RCU requires for the current grace period.  In this
+ * latter case, the CPU will be awakened at the end of the current grace
+ * period in order to process the remainder of its callbacks.
+ *
+ * These tracepoints take a string as argument:
+ *
+ *	"No callbacks": Nothing to do, no callbacks on this CPU.
+ *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
+ *	"Dyntick with callbacks": Callbacks remain, but RCU doesn't need CPU.
+ *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
+ *	"More callbacks": Still more callbacks, try again to clear them out.
+ *	"Callbacks drained": All callbacks processed, off to dyntick idle!
+ *	"CPU awakened at GP end":
+ */
+TRACE_EVENT(rcu_prep_idle,
+
+	TP_PROTO(char *reason),
+
+	TP_ARGS(reason),
+
+	TP_STRUCT__entry(
+		__field(char *, reason)
+	),
+
+	TP_fast_assign(
+		__entry->reason = reason;
+	),
+
+	TP_printk("%s", __entry->reason)
+);
+
+/*
  * Tracepoint for the registration of a single RCU callback function.
  * The first argument is the type of RCU, the second argument is
  * a pointer to the RCU callback itself, and the third element is the
@@ -482,6 +518,7 @@ TRACE_EVENT(rcu_torture_read,
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, grplo, grphi, gp_tasks) do { } while (0)
 #define trace_rcu_fqs(rcuname, gpnum, cpu, qsevent) do { } while (0)
 #define trace_rcu_dyntick(polarity, oldnesting, newnesting) do { } while (0)
+#define trace_rcu_prep_idle(reason) do { } while (0)
 #define trace_rcu_callback(rcuname, rhp, qlen) do { } while (0)
 #define trace_rcu_kfree_callback(rcuname, rhp, offset, qlen) do { } while (0)
 #define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b70ca8c..6467f56 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2031,10 +2031,13 @@ static void rcu_prepare_for_idle(int cpu)
 	/* If no callbacks or in the holdoff period, enter dyntick-idle. */
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
-	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies)
+	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
+		trace_rcu_prep_idle("In holdoff");
 		return;
+	}
 
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
@@ -2044,9 +2047,11 @@ static void rcu_prepare_for_idle(int cpu)
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (!rcu_pending(cpu)) {
+			trace_rcu_prep_idle("Dyntick with callbacks");
 			per_cpu(rcu_awake_at_gp_end, cpu) = 1;
 			return;  /* Nothing to do immediately. */
 		}
+		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
 	}
@@ -2073,9 +2078,15 @@ static void rcu_prepare_for_idle(int cpu)
 		c = c || per_cpu(rcu_bh_data, cpu).nxtlist;
 	}
 
-	/* If RCU callbacks are still pending, RCU still needs this CPU. */
-	if (c)
+	/*
+	 * If RCU callbacks are still pending, RCU still needs this CPU.
+	 * So try forcing the callbacks through the grace period.
+	 */
+	if (c) {
+		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
+	} else
+		trace_rcu_prep_idle("Callbacks drained");
 }
 
 /*
@@ -2085,6 +2096,7 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_wake_cpu(void *unused)
 {
+	trace_rcu_prep_idle("CPU awakened at GP end");
 	invoke_rcu_core();
 }
 
-- 
1.7.3.2

