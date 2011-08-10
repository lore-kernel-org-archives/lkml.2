Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1HJQam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:30:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1HJQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:40 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=LJtMZnpSYR4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pR-gvpykjUeEE030QbwA:9 a=bCSGuAAzPLoquYSK3fQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810163037.845656507@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/5][RFC] ftrace: Pass ftrace_ops as third parameter to function trace
References: <20110810162222.017387055@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Pass-ftrace_ops-as-third-parameter-to-functio.patch
 callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the function trace callback receives only the ip and parent_ip
of the function that it traced. It would be more powerful to also return
the ops that registered the function as well. This allows the same function
to act differently depending on what ftrace_ops registered it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h     |    4 ++
 arch/x86/kernel/entry_64.S        |    1 +
 include/linux/ftrace.h            |   16 ++++++++-
 kernel/trace/ftrace.c             |   65 ++++++++++++++++++++++---------------
 kernel/trace/trace_events.c       |    3 +-
 kernel/trace/trace_functions.c    |    9 +++--
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 kernel/trace/trace_selftest.c     |   15 ++++++---
 kernel/trace/trace_stack.c        |    2 +-
 10 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 268c783..b3fcf16 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -32,6 +32,10 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
+#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#define ARCH_SUPPORTS_FTRACE_OPS 1
+#endif
+
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..27adc2b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -77,6 +77,7 @@ ENTRY(ftrace_caller)
 
 	MCOUNT_SAVE_FRAME
 
+	leaq function_trace_op, %rdx
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0c0e8a..e1fe5be 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,15 @@
 
 #include <asm/ftrace.h>
 
+/*
+ * If the arch supports passing the variable contents of
+ * function_trace_op as the third parameter back from the
+ * mcount call, then the arch should define this as 1.
+ */
+#ifndef ARCH_SUPPORTS_FTRACE_OPS
+#define ARCH_SUPPORTS_FTRACE_OPS 0
+#endif
+
 struct ftrace_hash;
 
 #ifdef CONFIG_FUNCTION_TRACER
@@ -29,7 +38,10 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp,
 		     loff_t *ppos);
 
-typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
+struct ftrace_ops;
+
+typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
+			      struct ftrace_ops *op);
 
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
@@ -97,7 +109,7 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
-extern void ftrace_stub(unsigned long a0, unsigned long a1);
+extern void ftrace_stub(unsigned long a0, unsigned long a1, struct ftrace_ops *op);
 
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c3e4575..1d720cb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -59,12 +59,20 @@
 #define FTRACE_HASH_DEFAULT_BITS 10
 #define FTRACE_HASH_MAX_BITS 12
 
+static struct ftrace_ops ftrace_list_end __read_mostly =
+{
+	.func		= ftrace_stub,
+};
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
 /* Quick disabling of function tracer. */
-int function_trace_stop;
+int function_trace_stop __read_mostly;
+
+/* Current function tracing op */
+struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
 
 /* List for set_ftrace_pid's pids. */
 LIST_HEAD(ftrace_pids);
@@ -81,10 +89,6 @@ static int ftrace_disabled __read_mostly;
 
 static DEFINE_MUTEX(ftrace_lock);
 
-static struct ftrace_ops ftrace_list_end __read_mostly = {
-	.func		= ftrace_stub,
-};
-
 static struct ftrace_ops *ftrace_global_list __read_mostly = &ftrace_list_end;
 static struct ftrace_ops *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
@@ -93,8 +97,8 @@ ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 
-static void
-ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
+static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
+				 struct ftrace_ops *op);
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
@@ -105,29 +109,29 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip);
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
-static void ftrace_global_list_func(unsigned long ip,
-				    unsigned long parent_ip)
+static void
+ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
+			struct ftrace_ops *op)
 {
-	struct ftrace_ops *op;
-
 	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
 		return;
 
 	trace_recursion_set(TRACE_GLOBAL_BIT);
 	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
-		op->func(ip, parent_ip);
+		op->func(ip, parent_ip, op);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
-static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip)
+static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
+			    struct ftrace_ops *op)
 {
 	if (!test_tsk_trace_trace(current))
 		return;
 
-	ftrace_pid_function(ip, parent_ip);
+	ftrace_pid_function(ip, parent_ip, op);
 }
 
 static void set_ftrace_pid_function(ftrace_func_t func)
@@ -157,12 +161,13 @@ void clear_ftrace_function(void)
  * For those archs that do not test ftrace_trace_stop in their
  * mcount call site, we need to do it from C.
  */
-static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
+static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip,
+				  struct ftrace_ops *op)
 {
 	if (function_trace_stop)
 		return;
 
-	__ftrace_trace_function(ip, parent_ip);
+	__ftrace_trace_function(ip, parent_ip, op);
 }
 #endif
 
@@ -198,15 +203,24 @@ static void update_ftrace_function(void)
 
 	/*
 	 * If we are at the end of the list and this ops is
-	 * not dynamic, then have the mcount trampoline call
-	 * the function directly
+	 * not dynamic and the arch supports passing ops, then have the
+	 * mcount trampoline call the function directly.
 	 */
 	if (ftrace_ops_list == &ftrace_list_end ||
 	    (ftrace_ops_list->next == &ftrace_list_end &&
-	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC)))
+	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC) &&
+	     ARCH_SUPPORTS_FTRACE_OPS)) {
+		/* Set the ftrace_ops that the arch callback uses */
+		if (ftrace_ops_list == &global_ops)
+			function_trace_op = ftrace_global_list;
+		else
+			function_trace_op = ftrace_ops_list;
 		func = ftrace_ops_list->func;
-	else
+	} else {
+		/* Just use the default ftrace_ops */
+		function_trace_op = &ftrace_list_end;
 		func = ftrace_ops_list_func;
+	}
 
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
@@ -2512,8 +2526,8 @@ static int __init ftrace_mod_cmd_init(void)
 }
 device_initcall(ftrace_mod_cmd_init);
 
-static void
-function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
+static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
+				      struct ftrace_ops *op)
 {
 	struct ftrace_func_probe *entry;
 	struct hlist_head *hhd;
@@ -3560,10 +3574,9 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 static void
-ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
+ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
+		     struct ftrace_ops *op)
 {
-	struct ftrace_ops *op;
-
 	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
 		return;
 
@@ -3576,7 +3589,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
 		if (ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip);
+			op->func(ip, parent_ip, op);
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..d2a6f94 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1673,7 +1673,8 @@ static __init void event_trace_self_tests(void)
 static DEFINE_PER_CPU(atomic_t, ftrace_test_event_disable);
 
 static void
-function_test_events_call(unsigned long ip, unsigned long parent_ip)
+function_test_events_call(unsigned long ip, unsigned long parent_ip,
+			  struct ftrace_ops *op)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c7b0c6a..fceb7a9 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -48,7 +48,8 @@ static void function_trace_start(struct trace_array *tr)
 }
 
 static void
-function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
+function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip,
+				 struct ftrace_ops *op)
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
@@ -75,7 +76,8 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 }
 
 static void
-function_trace_call(unsigned long ip, unsigned long parent_ip)
+function_trace_call(unsigned long ip, unsigned long parent_ip,
+		    struct ftrace_ops *op)
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
@@ -106,7 +108,8 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 }
 
 static void
-function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
+function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
+			  struct ftrace_ops *op)
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..7649609 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -136,7 +136,8 @@ static int func_prolog_dec(struct trace_array *tr,
  * irqsoff uses its own tracer function to keep the overhead down:
  */
 static void
-irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
+irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip,
+		    struct ftrace_ops *op)
 {
 	struct trace_array *tr = irqsoff_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e4a70c0..a311bfd 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -108,7 +108,7 @@ out_enable:
  * wakeup uses its own tracer function to keep the overhead down:
  */
 static void
-wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
+wakeup_tracer_call(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op)
 {
 	struct trace_array *tr = wakeup_trace;
 	struct trace_array_cpu *data;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..9ae40c8 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -103,35 +103,40 @@ static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 
 static int trace_selftest_test_probe1_cnt;
 static void trace_selftest_test_probe1_func(unsigned long ip,
-					    unsigned long pip)
+					    unsigned long pip,
+					    struct ftrace_ops *op)
 {
 	trace_selftest_test_probe1_cnt++;
 }
 
 static int trace_selftest_test_probe2_cnt;
 static void trace_selftest_test_probe2_func(unsigned long ip,
-					    unsigned long pip)
+					    unsigned long pip,
+					    struct ftrace_ops *op)
 {
 	trace_selftest_test_probe2_cnt++;
 }
 
 static int trace_selftest_test_probe3_cnt;
 static void trace_selftest_test_probe3_func(unsigned long ip,
-					    unsigned long pip)
+					    unsigned long pip,
+					    struct ftrace_ops *op)
 {
 	trace_selftest_test_probe3_cnt++;
 }
 
 static int trace_selftest_test_global_cnt;
 static void trace_selftest_test_global_func(unsigned long ip,
-					    unsigned long pip)
+					    unsigned long pip,
+					    struct ftrace_ops *op)
 {
 	trace_selftest_test_global_cnt++;
 }
 
 static int trace_selftest_test_dyn_cnt;
 static void trace_selftest_test_dyn_func(unsigned long ip,
-					 unsigned long pip)
+					 unsigned long pip,
+					 struct ftrace_ops *op)
 {
 	trace_selftest_test_dyn_cnt++;
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 77575b3..456f262 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -108,7 +108,7 @@ static inline void check_stack(void)
 }
 
 static void
-stack_trace_call(unsigned long ip, unsigned long parent_ip)
+stack_trace_call(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op)
 {
 	int cpu;
 
-- 
1.7.5.4


