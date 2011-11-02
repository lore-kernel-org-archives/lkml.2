Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1KBUb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32854 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1KBUbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 08/28] rcu: Add failure tracing to rcutorture
Date: Wed,  2 Nov 2011 13:30:29 -0700
Message-Id: <1320265849-5744-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-7182-0000-0000-0000001E33B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Trace the rcutorture RCU accesses and dump the trace buffer when the
first failure is detected.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h   |    8 ++++++++
 include/trace/events/rcu.h |   26 ++++++++++++++++++++++++++
 kernel/rcupdate.c          |   10 ++++++++++
 kernel/rcutorture.c        |   18 ++++++++++++++++++
 4 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index cd1ad4b..8d315b0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -51,6 +51,8 @@ extern int rcutorture_runnable; /* for sysctl */
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
+extern void do_trace_rcu_torture_read(char *rcutorturename,
+				      struct rcu_head *rhp);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -58,6 +60,12 @@ static inline void rcutorture_record_test_transition(void)
 static inline void rcutorture_record_progress(unsigned long vernum)
 {
 }
+#ifdef CONFIG_RCU_TRACE
+extern void do_trace_rcu_torture_read(char *rcutorturename,
+				      struct rcu_head *rhp);
+#else
+#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#endif
 #endif
 
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index e577180..172620a 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -437,6 +437,31 @@ TRACE_EVENT(rcu_batch_end,
 		  __entry->rcuname, __entry->callbacks_invoked)
 );
 
+/*
+ * Tracepoint for rcutorture readers.  The first argument is the name
+ * of the RCU flavor from rcutorture's viewpoint and the second argument
+ * is the callback address.
+ */
+TRACE_EVENT(rcu_torture_read,
+
+	TP_PROTO(char *rcutorturename, struct rcu_head *rhp),
+
+	TP_ARGS(rcutorturename, rhp),
+
+	TP_STRUCT__entry(
+		__field(char *, rcutorturename)
+		__field(struct rcu_head *, rhp)
+	),
+
+	TP_fast_assign(
+		__entry->rcutorturename = rcutorturename;
+		__entry->rhp = rhp;
+	),
+
+	TP_printk("%s torture read %p",
+		  __entry->rcutorturename, __entry->rhp)
+);
+
 #else /* #ifdef CONFIG_RCU_TRACE */
 
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
@@ -452,6 +477,7 @@ TRACE_EVENT(rcu_batch_end,
 #define trace_rcu_invoke_callback(rcuname, rhp) do { } while (0)
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
 #define trace_rcu_batch_end(rcuname, callbacks_invoked) do { } while (0)
+#define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ca0d23b..34a02da 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -316,3 +316,13 @@ struct debug_obj_descr rcuhead_debug_descr = {
 };
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
+void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp)
+{
+	trace_rcu_torture_read(rcutorturename, rhp);
+}
+EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
+#else
+#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#endif
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 764825c..df35228 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -913,6 +913,18 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
+void rcutorture_trace_dump(void)
+{
+	static atomic_t beenhere = ATOMIC_INIT(0);
+
+	if (atomic_read(&beenhere))
+		return;
+	if (atomic_xchg(&beenhere, 1) != 0)
+		return;
+	do_trace_rcu_torture_read(cur_ops->name, (struct rcu_head *)~0UL);
+	ftrace_dump(DUMP_ALL);
+}
+
 /*
  * RCU torture reader from timer handler.  Dereferences rcu_torture_current,
  * incrementing the corresponding element of the pipeline array.  The
@@ -934,6 +946,7 @@ static void rcu_torture_timer(unsigned long unused)
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
 				  srcu_read_lock_held(&srcu_ctl));
+	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
@@ -951,6 +964,8 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
+	if (pipe_count > 1)
+		rcutorture_trace_dump();
 	__this_cpu_inc(rcu_torture_count[pipe_count]);
 	completed = cur_ops->completed() - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
@@ -994,6 +1009,7 @@ rcu_torture_reader(void *arg)
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
 					  srcu_read_lock_held(&srcu_ctl));
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
@@ -1009,6 +1025,8 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
+		if (pipe_count > 1)
+			rcutorture_trace_dump();
 		__this_cpu_inc(rcu_torture_count[pipe_count]);
 		completed = cur_ops->completed() - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
-- 
1.7.3.2

