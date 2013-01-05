Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3AEREx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:04:53 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47565 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab3AEREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:04:50 -0500
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
Subject: [PATCH tip/core/rcu 2/3] rcu: Reduce rcutorture tracing
Date: Sat,  5 Jan 2013 09:04:18 -0800
Message-Id: <1357405459-13675-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405459-13675-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105170356.GA13534@linux.vnet.ibm.com>
 <1357405459-13675-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-2398-0000-0000-00000FBC5AAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, rcutorture traces every read-side access.  This can be
problematic because even a two-minute rcutorture run on a two-CPU system
can generate 28,853,363 reads.  Normally, only a failing read is of
interest, so this commit traces adjusts rcutorture's tracing to only
trace failing reads.  The resulting event tracing records the time
and the ->completed value captured at the beginning of the RCU read-side
critical section, allowing correlation with other event-tracing messages.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h   |   13 ++++++++++---
 include/trace/events/rcu.h |   19 ++++++++++++++-----
 kernel/rcupdate.c          |    9 ++++++---
 kernel/rcutorture.c        |   31 ++++++++++++++++++++++++-------
 4 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 275aa3f..7f89cea 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -53,7 +53,10 @@ extern int rcutorture_runnable; /* for sysctl */
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
 extern void do_trace_rcu_torture_read(char *rcutorturename,
-				      struct rcu_head *rhp);
+				      struct rcu_head *rhp,
+				      unsigned long secs,
+				      unsigned long c_old,
+				      unsigned long c);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -63,9 +66,13 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 }
 #ifdef CONFIG_RCU_TRACE
 extern void do_trace_rcu_torture_read(char *rcutorturename,
-				      struct rcu_head *rhp);
+				      struct rcu_head *rhp,
+				      unsigned long secs,
+				      unsigned long c_old,
+				      unsigned long c);
 #else
-#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #endif
 #endif
 
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d4f559b..09af021 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -523,22 +523,30 @@ TRACE_EVENT(rcu_batch_end,
  */
 TRACE_EVENT(rcu_torture_read,
 
-	TP_PROTO(char *rcutorturename, struct rcu_head *rhp),
+	TP_PROTO(char *rcutorturename, struct rcu_head *rhp,
+		 unsigned long secs, unsigned long c_old, unsigned long c),
 
-	TP_ARGS(rcutorturename, rhp),
+	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
 		__field(char *, rcutorturename)
 		__field(struct rcu_head *, rhp)
+		__field(unsigned long, secs)
+		__field(unsigned long, c_old)
+		__field(unsigned long, c)
 	),
 
 	TP_fast_assign(
 		__entry->rcutorturename = rcutorturename;
 		__entry->rhp = rhp;
+		__entry->secs = secs;
+		__entry->c_old = c_old;
+		__entry->c = c;
 	),
 
-	TP_printk("%s torture read %p",
-		  __entry->rcutorturename, __entry->rhp)
+	TP_printk("%s torture read %p %luus c: %lu %lu",
+		  __entry->rcutorturename, __entry->rhp,
+		  __entry->secs, __entry->c_old, __entry->c)
 );
 
 /*
@@ -608,7 +616,8 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
 #define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
 	do { } while (0)
-#define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #define trace_rcu_barrier(name, s, cpu, cnt, done) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a2cf761..303359d 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -404,11 +404,14 @@ EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
-void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp)
+void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp,
+			       unsigned long secs,
+			       unsigned long c_old, unsigned long c)
 {
-	trace_rcu_torture_read(rcutorturename, rhp);
+	trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c);
 }
 EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #else
-#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #endif
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 31dea01..a583f1c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -46,6 +46,7 @@
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/trace_clock.h>
 #include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
@@ -1028,7 +1029,6 @@ void rcutorture_trace_dump(void)
 		return;
 	if (atomic_xchg(&beenhere, 1) != 0)
 		return;
-	do_trace_rcu_torture_read(cur_ops->name, (struct rcu_head *)~0UL);
 	ftrace_dump(DUMP_ALL);
 }
 
@@ -1042,13 +1042,16 @@ static void rcu_torture_timer(unsigned long unused)
 {
 	int idx;
 	int completed;
+	int completed_end;
 	static DEFINE_RCU_RANDOM(rand);
 	static DEFINE_SPINLOCK(rand_lock);
 	struct rcu_torture *p;
 	int pipe_count;
+	unsigned long long ts;
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
+	ts = trace_clock_local();
 	p = rcu_dereference_check(rcu_torture_current,
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
@@ -1058,7 +1061,6 @@ static void rcu_torture_timer(unsigned long unused)
 		cur_ops->readunlock(idx);
 		return;
 	}
-	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
@@ -1071,10 +1073,16 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
-	if (pipe_count > 1)
+	completed_end = cur_ops->completed();
+	if (pipe_count > 1) {
+		unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
+
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu, ts,
+					  completed, completed_end);
 		rcutorture_trace_dump();
+	}
 	__this_cpu_inc(rcu_torture_count[pipe_count]);
-	completed = cur_ops->completed() - completed;
+	completed = completed_end - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
 		/* Should not happen, but... */
 		completed = RCU_TORTURE_PIPE_LEN;
@@ -1094,11 +1102,13 @@ static int
 rcu_torture_reader(void *arg)
 {
 	int completed;
+	int completed_end;
 	int idx;
 	DEFINE_RCU_RANDOM(rand);
 	struct rcu_torture *p;
 	int pipe_count;
 	struct timer_list t;
+	unsigned long long ts;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
@@ -1112,6 +1122,7 @@ rcu_torture_reader(void *arg)
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
+		ts = trace_clock_local();
 		p = rcu_dereference_check(rcu_torture_current,
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
@@ -1122,7 +1133,6 @@ rcu_torture_reader(void *arg)
 			schedule_timeout_interruptible(HZ);
 			continue;
 		}
-		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
 		cur_ops->read_delay(&rand);
@@ -1132,10 +1142,17 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
-		if (pipe_count > 1)
+		completed_end = cur_ops->completed();
+		if (pipe_count > 1) {
+			unsigned long __maybe_unused ts_rem =
+					do_div(ts, NSEC_PER_USEC);
+
+			do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu,
+						  ts, completed, completed_end);
 			rcutorture_trace_dump();
+		}
 		__this_cpu_inc(rcu_torture_count[pipe_count]);
-		completed = cur_ops->completed() - completed;
+		completed = completed_end - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
 			/* Should not happen, but... */
 			completed = RCU_TORTURE_PIPE_LEN;
-- 
1.7.8

