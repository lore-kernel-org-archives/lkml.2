Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1IGGXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:23:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38389 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab1IGGWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/55] rcu: Add RCU type to callback-invocation tracing
Date: Tue,  6 Sep 2011 11:00:11 -0700
Message-Id: <1315332049-2604-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Add a string the the rcu_batch_start() and rcu_batch_end() trace
messages that indicates the RCU type ("rcu_sched", "rcu_bh", or
"rcu_preempt").  The trace messages for the actual invocations
themselves are not marked, as it should be clear from the
rcu_batch_start() and rcu_batch_end() events before and after.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   28 ++++++++++++++++++----------
 kernel/rcutiny.c           |    8 ++++----
 kernel/rcutree.c           |    8 ++++----
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index ab458eb..508824e5 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -33,27 +33,31 @@ TRACE_EVENT(rcu_utilization,
 
 /*
  * Tracepoint for marking the beginning rcu_do_batch, performed to start
- * RCU callback invocation.  The first argument is the total number of
- * callbacks (including those that are not yet ready to be invoked),
- * and the second argument is the current RCU-callback batch limit.
+ * RCU callback invocation.  The first argument is the RCU flavor,
+ * the second is the total number of callbacks (including those that
+ * are not yet ready to be invoked), and the third argument is the
+ * current RCU-callback batch limit.
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(long qlen, int blimit),
+	TP_PROTO(char *rcuname, long qlen, int blimit),
 
-	TP_ARGS(qlen, blimit),
+	TP_ARGS(rcuname, qlen, blimit),
 
 	TP_STRUCT__entry(
+		__field(char *, rcuname)
 		__field(long, qlen)
 		__field(int, blimit)
 	),
 
 	TP_fast_assign(
+		__entry->rcuname = rcuname;
 		__entry->qlen = qlen;
 		__entry->blimit = blimit;
 	),
 
-	TP_printk("CBs=%ld bl=%d", __entry->qlen, __entry->blimit)
+	TP_printk("%s CBs=%ld bl=%d",
+		  __entry->rcuname, __entry->qlen, __entry->blimit)
 );
 
 /*
@@ -106,23 +110,27 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 
 /*
  * Tracepoint for exiting rcu_do_batch after RCU callbacks have been
- * invoked.  The first argument is the number of callbacks actually invoked.
+ * invoked.  The first argument is the name of the RCU flavor and
+ * the second argument is number of callbacks actually invoked.
  */
 TRACE_EVENT(rcu_batch_end,
 
-	TP_PROTO(int callbacks_invoked),
+	TP_PROTO(char *rcuname, int callbacks_invoked),
 
-	TP_ARGS(callbacks_invoked),
+	TP_ARGS(rcuname, callbacks_invoked),
 
 	TP_STRUCT__entry(
+		__field(char *, rcuname)
 		__field(int, callbacks_invoked)
 	),
 
 	TP_fast_assign(
+		__entry->rcuname = rcuname;
 		__entry->callbacks_invoked = callbacks_invoked;
 	),
 
-	TP_printk("CBs-invoked=%d", __entry->callbacks_invoked)
+	TP_printk("%s CBs-invoked=%d",
+		  __entry->rcuname, __entry->callbacks_invoked)
 );
 
 #endif /* _TRACE_RCU_H */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0d28974..1c37bdd 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -168,14 +168,14 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail) {
-		RCU_TRACE(trace_rcu_batch_start(0, -1));
-		RCU_TRACE(trace_rcu_batch_end(0));
+		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
+		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0));
 		return;
 	}
 
 	/* Move the ready-to-invoke callbacks to a local list. */
 	local_irq_save(flags);
-	RCU_TRACE(trace_rcu_batch_start(0, -1));
+	RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
 	list = rcp->rcucblist;
 	rcp->rcucblist = *rcp->donetail;
 	*rcp->donetail = NULL;
@@ -197,7 +197,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
-	RCU_TRACE(trace_rcu_batch_end(cb_count));
+	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count));
 }
 
 /*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b953e2c..eb6e731 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1199,8 +1199,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
-		trace_rcu_batch_start(0, 0);
-		trace_rcu_batch_end(0);
+		trace_rcu_batch_start(rsp->name, 0, 0);
+		trace_rcu_batch_end(rsp->name, 0);
 		return;
 	}
 
@@ -1210,7 +1210,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	 */
 	local_irq_save(flags);
 	bl = rdp->blimit;
-	trace_rcu_batch_start(rdp->qlen, bl);
+	trace_rcu_batch_start(rsp->name, rdp->qlen, bl);
 	list = rdp->nxtlist;
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
@@ -1233,7 +1233,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	local_irq_save(flags);
-	trace_rcu_batch_end(count);
+	trace_rcu_batch_end(rsp->name, count);
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
-- 
1.7.3.2

