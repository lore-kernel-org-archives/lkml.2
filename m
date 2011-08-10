Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1HJQbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:31:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1HJQam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:42 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ARrr5V1Eh4oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0qFbgYdDTOVJC0W_P5wA:9 a=SIm7yxokxPWTDBXDVdkA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810163038.238028499@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/5][RFC] ftrace: Return pt_regs to function trace callback (x86_64 only so
References: <20110810162222.017387055@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Return-pt_regs-to-function-trace-callback-x86.patch
 far)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Return as the 4th paramater to the function tracer callback the pt_regs.

So far this is only supported by x86_64. The ftrace_ops flag
FTRACE_OPS_FL_SAVE_REGS is added to tell the arch to save all regs
to the pt_regs, otherwise a minimum is just passed back (the same
regs that is saved by mcount itself).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h     |   38 ++++++++++++++++++++----------------
 arch/x86/kernel/entry_64.S        |   23 +++++++++++++++++++++-
 include/linux/ftrace.h            |   15 ++++++++++++-
 kernel/trace/ftrace.c             |   29 ++++++++++++++++++---------
 kernel/trace/trace_events.c       |    2 +-
 kernel/trace/trace_functions.c    |    7 +++--
 kernel/trace/trace_irqsoff.c      |    2 +-
 kernel/trace/trace_sched_wakeup.c |    3 +-
 kernel/trace/trace_selftest.c     |   15 +++++++++----
 kernel/trace/trace_stack.c        |    3 +-
 10 files changed, 95 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index b3fcf16..0750c2a 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -4,26 +4,29 @@
 #ifdef __ASSEMBLY__
 
 	.macro MCOUNT_SAVE_FRAME
-	/* taken from glibc */
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
+	 /*
+	  * We add enough stack to save all regs,
+	  * and we what we need in the location of pt_regs.
+	  */
+	subq $ORIG_RAX, %rsp
+	movq %rax, RAX(%rsp)
+	movq %rcx, RCX(%rsp)
+	movq %rdx, RDX(%rsp)
+	movq %rsi, RSI(%rsp)
+	movq %rdi, RDI(%rsp)
+	movq %r8, R8(%rsp)
+	movq %r9, R9(%rsp)
 	.endm
 
 	.macro MCOUNT_RESTORE_FRAME
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
+	movq R9(%rsp), %r9
+	movq R8(%rsp), %r8
+	movq RDI(%rsp), %rdi
+	movq RSI(%rsp), %rsi
+	movq RDX(%rsp), %rdx
+	movq RCX(%rsp), %rcx
+	movq RAX(%rsp), %rax
+	addq $ORIG_RAX, %rsp
 	.endm
 
 #endif
@@ -34,6 +37,7 @@
 
 #if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
 #define ARCH_SUPPORTS_FTRACE_OPS 1
+#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 27adc2b..b77f297 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -78,7 +78,16 @@ ENTRY(ftrace_caller)
 	MCOUNT_SAVE_FRAME
 
 	leaq function_trace_op, %rdx
-	movq 0x38(%rsp), %rdi
+
+	cmpl $0, ftrace_save_regs
+	jne  save_all_regs
+
+call_func:
+
+	/* regs go into 4th parameter */
+	leaq (%rsp), %rcx
+
+	movq ORIG_RAX(%rsp), %rdi
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
 
@@ -96,6 +105,18 @@ GLOBAL(ftrace_stub)
 	retq
 END(ftrace_caller)
 
+save_all_regs:
+	/* Save the rest of pt_regs */
+	movq %r15, R15(%rsp)
+	movq %r14, R14(%rsp)
+	movq %r13, R13(%rsp)
+	movq %r12, R12(%rsp)
+	movq %r10, R10(%rsp)
+	movq %rbp, RBP(%rsp)
+	movq %rbx, RBX(%rsp)
+	jmp call_func
+
+
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 ENTRY(mcount)
 	cmpl $0, function_trace_stop
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e1fe5be..14dcc98 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -11,6 +11,7 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -28,6 +29,14 @@
 #define ARCH_SUPPORTS_FTRACE_OPS 0
 #endif
 
+/*
+ * If the arch supports saving the regs to the ftrace_ops
+ * then it should set this to 1.
+ */
+#ifndef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 0
+#endif
+
 struct ftrace_hash;
 
 #ifdef CONFIG_FUNCTION_TRACER
@@ -41,12 +50,13 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 struct ftrace_ops;
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
-			      struct ftrace_ops *op);
+			      struct ftrace_ops *op, struct pt_regs *pt_regs);
 
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
+	FTRACE_OPS_FL_SAVE_REGS		= 1 << 3,
 };
 
 struct ftrace_ops {
@@ -109,7 +119,8 @@ int register_ftrace_function(struct ftrace_ops *ops);
 int unregister_ftrace_function(struct ftrace_ops *ops);
 void clear_ftrace_function(void);
 
-extern void ftrace_stub(unsigned long a0, unsigned long a1, struct ftrace_ops *op);
+extern void ftrace_stub(unsigned long a0, unsigned long a1,
+			struct ftrace_ops *op, struct pt_regs *pt_regs);
 
 #else /* !CONFIG_FUNCTION_TRACER */
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1d720cb..c92f433 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -74,6 +74,9 @@ int function_trace_stop __read_mostly;
 /* Current function tracing op */
 struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
 
+/* If the arch supports it, return pt_regs to caller */
+int ftrace_save_regs __read_mostly;
+
 /* List for set_ftrace_pid's pids. */
 LIST_HEAD(ftrace_pids);
 struct ftrace_pid {
@@ -98,7 +101,7 @@ ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op);
+				 struct ftrace_ops *op, struct pt_regs *pt_regs);
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
@@ -111,7 +114,7 @@ static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
  */
 static void
 ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
-			struct ftrace_ops *op)
+			struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
 		return;
@@ -119,19 +122,19 @@ ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 	trace_recursion_set(TRACE_GLOBAL_BIT);
 	op = rcu_dereference_raw(ftrace_global_list); /*see above*/
 	while (op != &ftrace_list_end) {
-		op->func(ip, parent_ip, op);
+		op->func(ip, parent_ip, op, pt_regs);
 		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 	trace_recursion_clear(TRACE_GLOBAL_BIT);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
-			    struct ftrace_ops *op)
+			    struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	if (!test_tsk_trace_trace(current))
 		return;
 
-	ftrace_pid_function(ip, parent_ip, op);
+	ftrace_pid_function(ip, parent_ip, op, pt_regs);
 }
 
 static void set_ftrace_pid_function(ftrace_func_t func)
@@ -162,12 +165,12 @@ void clear_ftrace_function(void)
  * mcount call site, we need to do it from C.
  */
 static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip,
-				  struct ftrace_ops *op)
+				  struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	if (function_trace_stop)
 		return;
 
-	__ftrace_trace_function(ip, parent_ip, op);
+	__ftrace_trace_function(ip, parent_ip, op, pt_regs);
 }
 #endif
 
@@ -285,6 +288,9 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	if (!core_kernel_data((unsigned long)ops))
 		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
 
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+		ftrace_save_regs++;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		int first = ftrace_global_list == &ftrace_list_end;
 		add_ftrace_ops(&ftrace_global_list, ops);
@@ -313,6 +319,9 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+		ftrace_save_regs--;
+
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL) {
 		ret = remove_ftrace_ops(&ftrace_global_list, ops);
 		if (!ret && ftrace_global_list == &ftrace_list_end)
@@ -2527,7 +2536,7 @@ static int __init ftrace_mod_cmd_init(void)
 device_initcall(ftrace_mod_cmd_init);
 
 static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
-				      struct ftrace_ops *op)
+				      struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	struct ftrace_func_probe *entry;
 	struct hlist_head *hhd;
@@ -3575,7 +3584,7 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 
 static void
 ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-		     struct ftrace_ops *op)
+		     struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
 		return;
@@ -3589,7 +3598,7 @@ ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	op = rcu_dereference_raw(ftrace_ops_list);
 	while (op != &ftrace_list_end) {
 		if (ftrace_ops_test(op, ip))
-			op->func(ip, parent_ip, op);
+			op->func(ip, parent_ip, op, pt_regs);
 		op = rcu_dereference_raw(op->next);
 	};
 	preempt_enable_notrace();
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d2a6f94..fe2c1ac 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1674,7 +1674,7 @@ static DEFINE_PER_CPU(atomic_t, ftrace_test_event_disable);
 
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
index 7649609..009b3c4 100644
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
index a311bfd..fdafb79 100644
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
index 456f262..d22ba11 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -108,7 +108,8 @@ static inline void check_stack(void)
 }
 
 static void
-stack_trace_call(unsigned long ip, unsigned long parent_ip, struct ftrace_ops *op)
+stack_trace_call(unsigned long ip, unsigned long parent_ip,
+		 struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
 	int cpu;
 
-- 
1.7.5.4


