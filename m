Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2HUPGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:06:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2HUPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:06:30 -0400
Date: Tue, 21 Aug 2012 08:00:10 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-a1e2e31d175a1349274eba3465d17616c6725f8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120702201821.019966811@goodmis.org>
References: <20120702201821.019966811@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Return pt_regs to function trace callback
Git-Commit-ID: a1e2e31d175a1349274eba3465d17616c6725f8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:00:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1e2e31d175a1349274eba3465d17616c6725f8c
Gitweb:     http://git.kernel.org/tip/a1e2e31d175a1349274eba3465d17616c6725f8c
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 9 Aug 2011 12:50:46 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 19 Jul 2012 13:18:49 -0400

ftrace: Return pt_regs to function trace callback

Return as the 4th paramater to the function tracer callback the pt_regs.

Later patches that implement regs passing for the architectures will require
having the ftrace_ops set the SAVE_REGS flag, which will tell the arch
to take the time to pass a full set of pt_regs to the ftrace_ops callback
function. If the arch does not support it then it should pass NULL.

If an arch can pass full regs, then it should define:
 ARCH_SUPPORTS_FTRACE_SAVE_REGS to 1

Link: http://lkml.kernel.org/r/20120702201821.019966811@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h            |    6 ++++--
 kernel/trace/ftrace.c             |   37 ++++++++++++++++++++++---------------
 kernel/trace/trace_event_perf.c   |    2 +-
 kernel/trace/trace_events.c       |    2 +-
 kernel/trace/trace_functions.c    |    7 ++++---
 kernel/trace/trace_irqsoff.c      |    2 +-
 kernel/trace/trace_sched_wakeup.c |    3 ++-
 kernel/trace/trace_selftest.c     |   15 ++++++++++-----
 kernel/trace/trace_stack.c        |    3 ++-
 9 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 3651fdc..e420288 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -10,6 +10,7 @@
 #include <linux/kallsyms.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
+#include <linux/ptrace.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -54,7 +55,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 struct ftrace_ops;
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
-			      struct ftrace_ops *op);
+			      struct ftrace_ops *op, struct pt_regs *regs);
 
 /*
  * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
@@ -188,7 +189,8 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
 	return *this_cpu_ptr(ops->disabled);
 }
 
-extern void ftrace_stub(unsigned long a0, unsigned long a1, struct ftrace_ops *op);
+extern void ftrace_stub(unsigned long a0, unsigned long a1,
+			struct ftrace_ops *op, struct pt_regs *regs);
 
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4cbca2e..6ff07ad 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -103,7 +103,7 @@ static struct ftrace_ops control_ops;
 
 #if ARCH_SUPPORTS_FTRACE_OPS
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op);
+				 struct ftrace_ops *op, struct pt_regs *regs);
 #else
 /* See comment below, where ftrace_ops_list_func is defined */
 static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
@@ -121,7 +121,7 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
  */
 static void
 ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
-			struct ftrace_ops *op)
+			struct ftrace_ops *op, struct pt_regs *regs)
 {
 	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
 		return;
@@ -129,19 +129,19 @@ ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 	trace_recursion_set(TRACE_GLOBAL_BIT);
 	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
-		op->func(ip, parent_ip, op);
+		op->func(ip, parent_ip, op, regs);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
-			    struct ftrace_ops *op)
+			    struct ftrace_ops *op, struct pt_regs *regs)
 {
 	if (!test_tsk_trace_trace(current))
 		return;
 
-	ftrace_pid_function(ip, parent_ip, op);
+	ftrace_pid_function(ip, parent_ip, op, regs);
 }
 
 static void set_ftrace_pid_function(ftrace_func_t func)
@@ -763,7 +763,7 @@ ftrace_profile_alloc(struct ftrace_profile_stat *stat, unsigned long ip)
 
 static void
 function_profile_call(unsigned long ip, unsigned long parent_ip,
-		      struct ftrace_ops *ops)
+		      struct ftrace_ops *ops, struct pt_regs *regs)
 {
 	struct ftrace_profile_stat *stat;
 	struct ftrace_profile *rec;
@@ -793,7 +793,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static int profile_graph_entry(struct ftrace_graph_ent *trace)
 {
-	function_profile_call(trace->func, 0, NULL);
+	function_profile_call(trace->func, 0, NULL, NULL);
 	return 1;
 }
 
@@ -2771,7 +2771,7 @@ static int __init ftrace_mod_cmd_init(void)
 device_initcall(ftrace_mod_cmd_init);
 
 static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
-				      struct ftrace_ops *op)
+				      struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct ftrace_func_probe *entry;
 	struct hlist_head *hhd;
@@ -3923,7 +3923,7 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 
 static void
 ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
-			struct ftrace_ops *op)
+			struct ftrace_ops *op, struct pt_regs *regs)
 {
 	if (unlikely(trace_recursion_test(TRACE_CONTROL_BIT)))
 		return;
@@ -3938,7 +3938,7 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 	while (op != &ftrace_list_end) {
 		if (!ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip, op);
+			op->func(ip, parent_ip, op, regs);
 
 		op = rcu_dereference_raw(op->next);
 	};
@@ -3952,7 +3952,7 @@ static struct ftrace_ops control_ops = {
 
 static inline void
 __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-		       struct ftrace_ops *ignored)
+		       struct ftrace_ops *ignored, struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
 
@@ -3971,7 +3971,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
 		if (ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip, op);
+			op->func(ip, parent_ip, op, regs);
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
@@ -3983,17 +3983,24 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
  * the list function ignores the op parameter, we do not want any
  * C side effects, where a function is called without the caller
  * sending a third parameter.
+ * Archs are to support both the regs and ftrace_ops at the same time.
+ * If they support ftrace_ops, it is assumed they support regs.
+ * If call backs want to use regs, they must either check for regs
+ * being NULL, or ARCH_SUPPORTS_FTRACE_SAVE_REGS.
+ * Note, ARCH_SUPPORT_SAVE_REGS expects a full regs to be saved.
+ * An architecture can pass partial regs with ftrace_ops and still
+ * set the ARCH_SUPPORT_FTARCE_OPS.
  */
 #if ARCH_SUPPORTS_FTRACE_OPS
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op)
+				 struct ftrace_ops *op, struct pt_regs *regs)
 {
-	__ftrace_ops_list_func(ip, parent_ip, NULL);
+	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
 }
 #else
 static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
 {
-	__ftrace_ops_list_func(ip, parent_ip, NULL);
+	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
 }
 #endif
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index a872a9a..9824419 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -259,7 +259,7 @@ EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
 #ifdef CONFIG_FUNCTION_TRACER
 static void
 perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
-			  struct ftrace_ops *ops)
+			  struct ftrace_ops *ops, struct pt_regs *pt_regs)
 {
 	struct ftrace_entry *entry;
 	struct hlist_head *head;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 88daa51..8c66968 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1682,7 +1682,7 @@ static DEFINE_PER_CPU(atomic_t, ftrace_test_event_disable);
 
 static void
 function_test_events_call(unsigned long ip, unsigned long parent_ip,
-			  struct ftrace_ops *op)
+			  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index fceb7a9..5675ebd 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -49,7 +49,7 @@ static void function_trace_start(struct trace_array *tr)
 
 static void
 function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op)
+				 struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
@@ -77,7 +77,8 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip,
 
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip,
-		    struct ftrace_ops *op)
+		    struct ftrace_ops *op, struct pt_regs *pt_regs)
+
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
@@ -109,7 +110,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 
 static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
-			  struct ftrace_ops *op)
+			  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2862c77..c7a9ba9 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -137,7 +137,7 @@ static int func_prolog_dec(struct trace_array *tr,
  */
 static void
 irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip,
-		    struct ftrace_ops *op)
+		    struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct trace_array *tr = irqsoff_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0caf4f5..7547e36 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -108,7 +108,8 @@ out_enable:
  * wakeup uses its own tracer function to keep the overhead down:
  */
 static void
-wakeup_tracer_call(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op)
+wakeup_tracer_call(unsigned long ip, unsigned long parent_ip,
+		   struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct trace_array *tr = wakeup_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 9ae40c8..add37e0 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -104,7 +104,8 @@ static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 static int trace_selftest_test_probe1_cnt;
 static void trace_selftest_test_probe1_func(unsigned long ip,
 					    unsigned long pip,
-					    struct ftrace_ops *op)
+					    struct ftrace_ops *op,
+					    struct pt_regs *pt_regs)
 {
 	trace_selftest_test_probe1_cnt++;
 }
@@ -112,7 +113,8 @@ static void trace_selftest_test_probe1_func(unsigned long ip,
 static int trace_selftest_test_probe2_cnt;
 static void trace_selftest_test_probe2_func(unsigned long ip,
 					    unsigned long pip,
-					    struct ftrace_ops *op)
+					    struct ftrace_ops *op,
+					    struct pt_regs *pt_regs)
 {
 	trace_selftest_test_probe2_cnt++;
 }
@@ -120,7 +122,8 @@ static void trace_selftest_test_probe2_func(unsigned long ip,
 static int trace_selftest_test_probe3_cnt;
 static void trace_selftest_test_probe3_func(unsigned long ip,
 					    unsigned long pip,
-					    struct ftrace_ops *op)
+					    struct ftrace_ops *op,
+					    struct pt_regs *pt_regs)
 {
 	trace_selftest_test_probe3_cnt++;
 }
@@ -128,7 +131,8 @@ static void trace_selftest_test_probe3_func(unsigned long ip,
 static int trace_selftest_test_global_cnt;
 static void trace_selftest_test_global_func(unsigned long ip,
 					    unsigned long pip,
-					    struct ftrace_ops *op)
+					    struct ftrace_ops *op,
+					    struct pt_regs *pt_regs)
 {
 	trace_selftest_test_global_cnt++;
 }
@@ -136,7 +140,8 @@ static void trace_selftest_test_global_func(unsigned long ip,
 static int trace_selftest_test_dyn_cnt;
 static void trace_selftest_test_dyn_func(unsigned long ip,
 					 unsigned long pip,
-					 struct ftrace_ops *op)
+					 struct ftrace_ops *op,
+					 struct pt_regs *pt_regs)
 {
 	trace_selftest_test_dyn_cnt++;
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e20006d..2fa5328 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -111,7 +111,8 @@ static inline void check_stack(void)
 }
 
 static void
-stack_trace_call(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op)
+stack_trace_call(unsigned long ip, unsigned long parent_ip,
+		 struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	int cpu;
 
