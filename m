Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2FOVH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:07:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60922 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab2FOVGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:06:49 -0400
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
Subject: [PATCH tip/core/rcu 10/15] rcu: Add tracing for _rcu_barrier()
Date: Fri, 15 Jun 2012 14:06:05 -0700
Message-Id: <1339794370-28119-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-7606-0000-0000-00000129588E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit adds event tracing for _rcu_barrier() execution.  This
is defined only if RCU_TRACE=y.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   45 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree.c           |   29 +++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 1480900..cd63f79 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -540,6 +540,50 @@ TRACE_EVENT(rcu_torture_read,
 		  __entry->rcutorturename, __entry->rhp)
 );
 
+/*
+ * Tracepoint for _rcu_barrier() execution.  The string "s" describes
+ * the _rcu_barrier phase:
+ *	"Begin": rcu_barrier_callback() started.
+ *	"Check": rcu_barrier_callback() checking for piggybacking.
+ *	"EarlyExit": rcu_barrier_callback() piggybacked, thus early exit.
+ *	"Inc1": rcu_barrier_callback() piggyback check counter incremented.
+ *	"Offline": rcu_barrier_callback() found offline CPU
+ *	"OnlineQ": rcu_barrier_callback() found online CPU with callbacks.
+ *	"OnlineNQ": rcu_barrier_callback() found online CPU, no callbacks.
+ *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
+ *	"CB": An rcu_barrier_callback() invoked a callback, not the last.
+ *	"LastCB": An rcu_barrier_callback() invoked the last callback.
+ *	"Inc2": rcu_barrier_callback() piggyback check counter incremented.
+ * The "cpu" argument is the CPU or -1 if meaningless, the "cnt" argument
+ * is the count of remaining callbacks, and "done" is the piggybacking count.
+ */
+TRACE_EVENT(rcu_barrier,
+
+	TP_PROTO(char *rcuname, char *s, int cpu, int cnt, unsigned long done),
+
+	TP_ARGS(rcuname, s, cpu, cnt, done),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(char *, s)
+		__field(int, cpu)
+		__field(int, cnt)
+		__field(unsigned long, done)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->s = s;
+		__entry->cpu = cpu;
+		__entry->cnt = cnt;
+		__entry->done = done;
+	),
+
+	TP_printk("%s %s cpu %d remaining %d # %lu",
+		  __entry->rcuname, __entry->s, __entry->cpu, __entry->cnt,
+		  __entry->done)
+);
+
 #else /* #ifdef CONFIG_RCU_TRACE */
 
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
@@ -563,6 +607,7 @@ TRACE_EVENT(rcu_torture_read,
 #define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
 	do { } while (0)
 #define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define trace_rcu_barrier(name, s, cpu, cnt, done) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7c299d3..ebd5223 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2257,6 +2257,17 @@ static int rcu_cpu_has_callbacks(int cpu)
 }
 
 /*
+ * Helper function for _rcu_barrier() tracing.  If tracing is disabled,
+ * the compiler is expected to optimize this away.
+ */
+static void _rcu_barrier_trace(struct rcu_state *rsp, char *s,
+			       int cpu, unsigned long done)
+{
+	trace_rcu_barrier(rsp->name, s, cpu,
+			  atomic_read(&rsp->barrier_cpu_count), done);
+}
+
+/*
  * RCU callback function for _rcu_barrier().  If we are last, wake
  * up the task executing _rcu_barrier().
  */
@@ -2265,8 +2276,12 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
 	struct rcu_data *rdp = container_of(rhp, struct rcu_data, barrier_head);
 	struct rcu_state *rsp = rdp->rsp;
 
-	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
+	if (atomic_dec_and_test(&rsp->barrier_cpu_count)) {
+		_rcu_barrier_trace(rsp, "LastCB", -1, rsp->n_barrier_done);
 		complete(&rsp->barrier_completion);
+	} else {
+		_rcu_barrier_trace(rsp, "CB", -1, rsp->n_barrier_done);
+	}
 }
 
 /*
@@ -2277,6 +2292,7 @@ static void rcu_barrier_func(void *type)
 	struct rcu_state *rsp = type;
 	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
 
+	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
 	rsp->call(&rdp->barrier_head, rcu_barrier_callback);
 }
@@ -2295,6 +2311,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	unsigned long snap_done;
 
 	init_rcu_head_on_stack(&rd.barrier_head);
+	_rcu_barrier_trace(rsp, "Begin", -1, snap);
 
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
 	mutex_lock(&rsp->barrier_mutex);
@@ -2307,7 +2324,9 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	/* Recheck ->n_barrier_done to see if others did our work for us. */
 	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
+	_rcu_barrier_trace(rsp, "Check", -1, snap_done);
 	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
+		_rcu_barrier_trace(rsp, "EarlyExit", -1, snap_done);
 		smp_mb();
 		mutex_unlock(&rsp->barrier_mutex);
 		return;
@@ -2316,6 +2335,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	/* Increment ->n_barrier_done to avoid duplicate work. */
 	ACCESS_ONCE(rsp->n_barrier_done)++;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 1);
+	_rcu_barrier_trace(rsp, "Inc1", -1, rsp->n_barrier_done);
 	smp_mb(); /* Order ->n_barrier_done increment with below mechanism. */
 
 	/*
@@ -2352,13 +2372,19 @@ static void _rcu_barrier(struct rcu_state *rsp)
 		preempt_disable();
 		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (cpu_is_offline(cpu)) {
+			_rcu_barrier_trace(rsp, "Offline", cpu,
+					   rsp->n_barrier_done);
 			preempt_enable();
 			while (cpu_is_offline(cpu) && ACCESS_ONCE(rdp->qlen))
 				schedule_timeout_interruptible(1);
 		} else if (ACCESS_ONCE(rdp->qlen)) {
+			_rcu_barrier_trace(rsp, "OnlineQ", cpu,
+					   rsp->n_barrier_done);
 			smp_call_function_single(cpu, rcu_barrier_func, rsp, 1);
 			preempt_enable();
 		} else {
+			_rcu_barrier_trace(rsp, "OnlineNQ", cpu,
+					   rsp->n_barrier_done);
 			preempt_enable();
 		}
 	}
@@ -2391,6 +2417,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	smp_mb(); /* Keep increment after above mechanism. */
 	ACCESS_ONCE(rsp->n_barrier_done)++;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 0);
+	_rcu_barrier_trace(rsp, "Inc2", -1, rsp->n_barrier_done);
 	smp_mb(); /* Keep increment before caller's subsequent code. */
 
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
-- 
1.7.8

