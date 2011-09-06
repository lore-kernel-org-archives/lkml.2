Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1IGGaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:30:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48809 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1IGGUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/55] rcu: Event-trace markers for computing RCU CPU utilization
Date: Tue,  6 Sep 2011 11:00:09 -0700
Message-Id: <1315332049-2604-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit adds the trace_rcu_utilization() marker that is to be
used to allow postprocessing scripts compute RCU's CPU utilization,
give or take event-trace overhead.  Note that we do not include RCU's
dyntick-idle interface because event tracing requires RCU protection,
which is not available in dyntick-idle mode.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   73 ++++++++++++++++++++++++++++++++------------
 kernel/rcutree.c           |   16 +++++++++-
 2 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index db3f6e9..ab458eb 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -7,29 +7,58 @@
 #include <linux/tracepoint.h>
 
 /*
- * Tracepoint for calling rcu_do_batch, performed to start callback invocation:
+ * Tracepoint for start/end markers used for utilization calculations.
+ * By convention, the string is of the following forms:
+ *
+ * "Start <activity>" -- Mark the start of the specified activity,
+ *			 such as "context switch".  Nesting is permitted.
+ * "End <activity>" -- Mark the end of the specified activity.
+ */
+TRACE_EVENT(rcu_utilization,
+
+	TP_PROTO(char *s),
+
+	TP_ARGS(s),
+
+	TP_STRUCT__entry(
+		__field(char *,	s)
+	),
+
+	TP_fast_assign(
+		__entry->s = s;
+	),
+
+	TP_printk("%s", __entry->s)
+);
+
+/*
+ * Tracepoint for marking the beginning rcu_do_batch, performed to start
+ * RCU callback invocation.  The first argument is the total number of
+ * callbacks (including those that are not yet ready to be invoked),
+ * and the second argument is the current RCU-callback batch limit.
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(long callbacks_ready, int blimit),
+	TP_PROTO(long qlen, int blimit),
 
-	TP_ARGS(callbacks_ready, blimit),
+	TP_ARGS(qlen, blimit),
 
 	TP_STRUCT__entry(
-		__field(	long,	callbacks_ready		)
-		__field(	int,	blimit			)
+		__field(long, qlen)
+		__field(int, blimit)
 	),
 
 	TP_fast_assign(
-		__entry->callbacks_ready	= callbacks_ready;
-		__entry->blimit			= blimit;
+		__entry->qlen = qlen;
+		__entry->blimit = blimit;
 	),
 
-	TP_printk("CBs=%ld bl=%d", __entry->callbacks_ready, __entry->blimit)
+	TP_printk("CBs=%ld bl=%d", __entry->qlen, __entry->blimit)
 );
 
 /*
- * Tracepoint for the invocation of a single RCU callback
+ * Tracepoint for the invocation of a single RCU callback function.
+ * The argument is a pointer to the RCU callback itself.
  */
 TRACE_EVENT(rcu_invoke_callback,
 
@@ -38,20 +67,23 @@ TRACE_EVENT(rcu_invoke_callback,
 	TP_ARGS(rhp),
 
 	TP_STRUCT__entry(
-		__field(	void *,	rhp	)
-		__field(	void *,	func	)
+		__field(void *,	rhp)
+		__field(void *,	func)
 	),
 
 	TP_fast_assign(
-		__entry->rhp	= rhp;
-		__entry->func	= rhp->func;
+		__entry->rhp = rhp;
+		__entry->func = rhp->func;
 	),
 
 	TP_printk("rhp=%p func=%pf", __entry->rhp, __entry->func)
 );
 
 /*
- * Tracepoint for the invocation of a single RCU kfree callback
+ * Tracepoint for the invocation of a single RCU callback of the special
+ * kfree() form.  The first argument is a pointer to the RCU callback
+ * and the second argument is the offset of the callback within the
+ * enclosing RCU-protected data structure.
  */
 TRACE_EVENT(rcu_invoke_kfree_callback,
 
@@ -60,12 +92,12 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 	TP_ARGS(rhp, offset),
 
 	TP_STRUCT__entry(
-		__field(void *,	rhp	)
-		__field(unsigned long,	offset	)
+		__field(void *,	rhp)
+		__field(unsigned long, offset)
 	),
 
 	TP_fast_assign(
-		__entry->rhp	= rhp;
+		__entry->rhp = rhp;
 		__entry->offset	= offset;
 	),
 
@@ -73,7 +105,8 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 );
 
 /*
- * Tracepoint for leaving rcu_do_batch, performed after callback invocation:
+ * Tracepoint for exiting rcu_do_batch after RCU callbacks have been
+ * invoked.  The first argument is the number of callbacks actually invoked.
  */
 TRACE_EVENT(rcu_batch_end,
 
@@ -82,11 +115,11 @@ TRACE_EVENT(rcu_batch_end,
 	TP_ARGS(callbacks_invoked),
 
 	TP_STRUCT__entry(
-		__field(	int,	callbacks_invoked		)
+		__field(int, callbacks_invoked)
 	),
 
 	TP_fast_assign(
-		__entry->callbacks_invoked	= callbacks_invoked;
+		__entry->callbacks_invoked = callbacks_invoked;
 	),
 
 	TP_printk("CBs-invoked=%d", __entry->callbacks_invoked)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 45dcc20..2a9643b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -184,8 +184,10 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_note_context_switch(int cpu)
 {
+	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
+	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
@@ -1275,6 +1277,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	trace_rcu_utilization("Start scheduler-tick");
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1308,6 +1311,7 @@ void rcu_check_callbacks(int cpu, int user)
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
 		invoke_rcu_core();
+	trace_rcu_utilization("End scheduler-tick");
 }
 
 #ifdef CONFIG_SMP
@@ -1369,10 +1373,14 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!rcu_gp_in_progress(rsp))
+	trace_rcu_utilization("Start fqs");
+	if (!rcu_gp_in_progress(rsp)) {
+		trace_rcu_utilization("End fqs");
 		return;  /* No grace period in progress, nothing to force. */
+	}
 	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
+		trace_rcu_utilization("End fqs");
 		return;	/* Someone else is already on the job. */
 	}
 	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
@@ -1421,11 +1429,13 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
 		rsp->fqs_need_gp = 0;
 		rcu_start_gp(rsp, flags); /* releases rnp->lock */
+		trace_rcu_utilization("End fqs");
 		return;
 	}
 	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
 	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
+	trace_rcu_utilization("End fqs");
 }
 
 #else /* #ifdef CONFIG_SMP */
@@ -1481,6 +1491,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
+	trace_rcu_utilization("Start RCU core");
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
@@ -1488,6 +1499,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();
+	trace_rcu_utilization("End RCU core");
 }
 
 /*
@@ -1910,6 +1922,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 
+	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -1945,6 +1958,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	default:
 		break;
 	}
+	trace_rcu_utilization("End CPU hotplug");
 	return NOTIFY_OK;
 }
 
-- 
1.7.3.2

