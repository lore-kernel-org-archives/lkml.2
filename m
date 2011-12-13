Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1LMAmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:44 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41132 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1LMAml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:41 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/6] rcu: Augment rcu_batch_end tracing for idle and callback state
Date: Mon, 12 Dec 2011 16:42:20 -0800
Message-Id: <1323736944-32575-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
 <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 11121300-7282-0000-0000-000004DC6D8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The current rcu_batch_end event trace records only the name of the RCU
flavor and the total number of callbacks that remain queued on the
current CPU.  This is insufficient for testing and tuning the new
dyntick-idle RCU_FAST_NO_HZ code, so this commit adds idle state along
with whether or not any of the callbacks that were ready to invoke
at the beginning of rcu_do_batch() are still queued.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   38 +++++++++++++++++++++++++++++---------
 kernel/rcutiny.c           |   10 ++++++++--
 kernel/rcutiny_plugin.h    |   25 +++++++++++++++++++++++++
 kernel/rcutree.c           |    8 ++++++--
 4 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index c75418c..d2d88be 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -461,27 +461,46 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 
 /*
  * Tracepoint for exiting rcu_do_batch after RCU callbacks have been
- * invoked.  The first argument is the name of the RCU flavor and
- * the second argument is number of callbacks actually invoked.
+ * invoked.  The first argument is the name of the RCU flavor,
+ * the second argument is number of callbacks actually invoked,
+ * the third argument (cb) is whether or not any of the callbacks that
+ * were ready to invoke at the beginning of this batch are still
+ * queued, the fourth argument (nr) is the return value of need_resched(),
+ * the fifth argument (iit) is 1 if the current task is the idle task,
+ * and the sixth argument (risk) is the return value from
+ * rcu_is_callbacks_kthread().
  */
 TRACE_EVENT(rcu_batch_end,
 
-	TP_PROTO(char *rcuname, int callbacks_invoked),
+	TP_PROTO(char *rcuname, int callbacks_invoked,
+		 bool cb, bool nr, bool iit, bool risk),
 
-	TP_ARGS(rcuname, callbacks_invoked),
+	TP_ARGS(rcuname, callbacks_invoked, cb, nr, iit, risk),
 
 	TP_STRUCT__entry(
 		__field(char *, rcuname)
 		__field(int, callbacks_invoked)
+		__field(bool, cb)
+		__field(bool, nr)
+		__field(bool, iit)
+		__field(bool, risk)
 	),
 
 	TP_fast_assign(
 		__entry->rcuname = rcuname;
 		__entry->callbacks_invoked = callbacks_invoked;
-	),
-
-	TP_printk("%s CBs-invoked=%d",
-		  __entry->rcuname, __entry->callbacks_invoked)
+		__entry->cb = cb;
+		__entry->nr = nr;
+		__entry->iit = iit;
+		__entry->risk = risk;
+	),
+
+	TP_printk("%s CBs-invoked=%d idle=%c%c%c%c",
+		  __entry->rcuname, __entry->callbacks_invoked,
+		  __entry->cb ? 'C' : '.',
+		  __entry->nr ? 'S' : '.',
+		  __entry->iit ? 'I' : '.',
+		  __entry->risk ? 'R' : '.')
 );
 
 /*
@@ -524,7 +543,8 @@ TRACE_EVENT(rcu_torture_read,
 #define trace_rcu_batch_start(rcuname, qlen, blimit) do { } while (0)
 #define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
-#define trace_rcu_batch_end(rcuname, callbacks_invoked) do { } while (0)
+#define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
+	do { } while (0)
 #define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e5bd949..977296d 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -259,7 +259,11 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail) {
 		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, -1));
-		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0));
+		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
+					      ACCESS_ONCE(rcp->rcucblist),
+					      need_resched(),
+					      is_idle_task(current),
+					      rcu_is_callbacks_kthread()));
 		return;
 	}
 
@@ -288,7 +292,9 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
-	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count));
+	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
+				      is_idle_task(current),
+				      rcu_is_callbacks_kthread()));
 }
 
 static void rcu_process_callbacks(struct softirq_action *unused)
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 2b0484a..dfa97cb 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -885,6 +885,19 @@ static void invoke_rcu_callbacks(void)
 	wake_up(&rcu_kthread_wq);
 }
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * Is the current CPU running the RCU-callbacks kthread?
+ * Caller must have preemption disabled.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return rcu_kthread_task == current;
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 /*
  * This kthread invokes RCU callbacks whose grace periods have
  * elapsed.  It is awakened as needed, and takes the place of the
@@ -938,6 +951,18 @@ void invoke_rcu_callbacks(void)
 	raise_softirq(RCU_SOFTIRQ);
 }
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * There is no callback kthread, so this thread is never it.
+ */
+static bool rcu_is_callbacks_kthread(void)
+{
+	return false;
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
 void rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2b2e1a9..6c4a672 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1373,7 +1373,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
 		trace_rcu_batch_start(rsp->name, 0, 0);
-		trace_rcu_batch_end(rsp->name, 0);
+		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
+				    need_resched(), is_idle_task(current),
+				    rcu_is_callbacks_kthread());
 		return;
 	}
 
@@ -1409,7 +1411,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	local_irq_save(flags);
-	trace_rcu_batch_end(rsp->name, count);
+	trace_rcu_batch_end(rsp->name, count, !!list, need_resched(),
+			    is_idle_task(current),
+			    rcu_is_callbacks_kthread());
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
-- 
1.7.8

