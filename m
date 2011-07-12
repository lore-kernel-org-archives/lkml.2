Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1GLTDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:03:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1GLTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:03:05 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=dTjUkDRXnZ8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=aJeQ05OULc81He9rttUA:9 a=uQ-QjhGS_syut11vnRcA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=p08TfjfVVcO7dk25:21 a=gdxurOysVP9Qh-he:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110712190302.475833802@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 12 Jul 2011 14:51:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 2/3] ftrace: Add extend-notrace to not trace sub funcs of notrace funcs
References: <20110712185131.698851699@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Add-extend-notrace-to-not-trace-sub-funcs-of-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When debugging the kernel with the function tracer, the trace can trace
lots of "noise" functions. That is functions that you do not care about
tracing but end up filling the ring buffer and perhaps even causing you
to lose what you wanted to trace. The set_ftrace_notrace as well as
denoting specific functions in the kernel with 'notrace' is useful to
keep these functions down. But sometimes they call functions that you
do not want to trace when a notrace function calls them. For this the
trace option 'extend-notrace' has been added.

Because the function tracer only records the entering of the function
and function graph tracing may be too slow to trace what is needed,
being able to recognise notrace functions is a complex problem as there's
no good way to know when a function has returned. But to do a "best effort"
in this the following is done.

The extend-notrace option uses the function_graph ret_stack to record a
call chain to each function. As the function tracer callbacks receive the
instruction pointer of both the traced function and the parent that called
that function, we can use the parent to help figure out if the function was
called by a notrace function or not. If the parent function is in the ret_stack
then we know that this function can be traced. If it is not, then it is a
candidate to not be traced.

When the parent is not in the ret_stack, care must be taken to know if the
current function should be ignored or not. Along with the call chain, the
irq context is also recorded. If the last traced function was not in irq
context and the current traced function is, then we trace this function.

If nothing is in the ret_stack than we just trace that as well. But because
we never know when this top function has exited, we have to have other tricks
to find out when we are at the top again.

One is to check the current stack (by referencing the address of a local
variable). If it is less than the current top function's stack, then we declare
this function as the new top pointer.

Or, if it is greater than 64 words of the kernel stack, then it is assumed
to be a sys_call and we start tracing that as the top function as well.

Known issues: Things that are called from assembly are also not traced.
That is because assembly is just like a "notrace" statement. This includes
do_page_fault() as that is called from a trap, as well as preempt_schedule()
which may be called from returning from an interrupt.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h         |   21 +++++-
 include/linux/sched.h          |    6 ++
 kernel/fork.c                  |    1 -
 kernel/trace/ftrace.c          |    3 +
 kernel/trace/trace.c           |    4 +
 kernel/trace/trace.h           |    4 +
 kernel/trace/trace_functions.c |  152 +++++++++++++++++++++++++++++++++++++++-
 7 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 60e38c0..9539e7a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -406,8 +406,25 @@ typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
 struct ftrace_ret_stack {
 	unsigned long ret;
 	unsigned long func;
-	unsigned long long calltime;
-	unsigned long long subtime;
+	/*
+	 * Function graph and function extend notrace
+	 * share this structure. The ret and func above are
+	 * sensitive to function graph and modifying them could
+	 * cause a kernel panic. The calltime and subtime are
+	 * just used for reporting. When function extend notrace
+	 * is active, function graph can not be active, so these
+	 * numbers are ignored anyway. If not, the worse that can
+	 * happen is that we get funny numbers in the output trace, but
+	 * this should never happen.
+	 */
+	union {
+		unsigned long long calltime;
+		unsigned long start_ip;
+	};
+	union {
+		unsigned long long subtime;
+		unsigned long end_ip;
+	};
 	unsigned long fp;
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c61b5bd..7dd914e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1543,6 +1543,12 @@ struct task_struct {
 #ifdef CONFIG_FUNCTION_TRACER
 	/* Index of current stored address in ret_stack */
 	int curr_ret_stack;
+	/*
+	 * Index of current stored address in ret_stack.
+	 * Must be separate from function graph curr_ret_stack.
+	 */
+	int curr_trace_stack;
+	unsigned long trace_start_stack;
 	/* Stack of return addresses for return function tracing */
 	struct ftrace_ret_stack	*ret_stack;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 8516893e..6d60ac3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1199,7 +1199,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->curr_chain_key = 0;
 	p->lockdep_recursion = 0;
 #endif
-
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 20bdbd6..2cbba7c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3919,6 +3919,7 @@ trace_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 void ftrace_init_idle_task(struct task_struct *t, int cpu)
 {
 	t->curr_ret_stack = -1;
+	t->trace_start_stack = 0;
 	/*
 	 * The idle task has no parent, it either has its own
 	 * stack or no stack at all.
@@ -3954,6 +3955,7 @@ void ftrace_init_task(struct task_struct *t)
 	/* Make sure we do not use the parent ret_stack */
 	t->ret_stack = NULL;
 	t->curr_ret_stack = -1;
+	t->trace_start_stack = 0;
 
 	if (ret_stack_active) {
 		struct ftrace_ret_stack *ret_stack;
@@ -4008,6 +4010,7 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 
 		if (t->ret_stack == NULL) {
 			t->curr_ret_stack = -1;
+			t->trace_start_stack = 0;
 			trace_init_task(t, ret_stack_list[start++]);
 		}
 	} while_each_thread(g, t);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee9c921..dc8b945 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -424,6 +424,7 @@ static const char *trace_options[] = {
 	"graph-time",
 	"record-cmd",
 	"overwrite",
+	"extend-notrace",
 	NULL
 };
 
@@ -2540,6 +2541,9 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_OVERWRITE)
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+
+	if (mask == TRACE_ITER_EXTEND_NOTRACE)
+		trace_extend_notrace(enabled);
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fa439f0..bbef5a5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -540,6 +540,7 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 int trace_ret_stack_enable(void);
 void trace_ret_stack_disable(void);
+void trace_extend_notrace(int enabled);
 
 #else
 static inline int ftrace_trace_task(struct task_struct *task)
@@ -548,6 +549,7 @@ static inline int ftrace_trace_task(struct task_struct *task)
 }
 static inline int trace_ret_stack_enable(void) { return -ENODEV; }
 static inline void trace_ret_stack_disable(void) { }
+static inline void trace_extend_notrace(int enabled) { }
 #endif
 
 /*
@@ -615,6 +617,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
+	TRACE_ITER_EXTEND_NOTRACE	= 0x400000,
 };
 
 /*
@@ -800,6 +803,7 @@ extern const char *__stop___trace_bprintk_fmt[];
 /* for function tracing recursion */
 #define TRACE_INTERNAL_BIT		(1<<11)
 #define TRACE_GLOBAL_BIT		(1<<12)
+#define TRACE_IN_IRQ			(1<<13)
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
 #define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 8d0e1cc..73cf336 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -47,6 +47,148 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(tr);
 }
 
+static int notrace_extended;
+
+void trace_extend_notrace(int enable)
+{
+	int ret = 0;
+
+	if (!ftrace_function_enabled)
+		return;
+
+	if (!!enable == notrace_extended)
+		return;
+
+	if (enable)
+		ret = trace_ret_stack_enable();
+	else
+		trace_ret_stack_disable();
+	if (!ret)
+		notrace_extended = !!enable;
+}
+
+/* 64 words depth to reset stack */
+#define STACK_OFFSET	(THREAD_SIZE - (64 * BITS_PER_LONG/8))
+
+static inline int skip_notrace(unsigned long ip, unsigned long parent_ip)
+{
+	unsigned long offset;
+	unsigned long size;
+	int irq_stack;
+	int last_stack;
+	int curr_ret;
+	int i;
+
+	/* Optimize for this case to be off */
+	if (likely(!(trace_flags & TRACE_ITER_EXTEND_NOTRACE)))
+		return 0;
+
+	/*
+	 * We always trace NMIs, and do not update anything.
+	 * This code requires interrupts disabled.
+	 */
+	if (in_nmi())
+		return 0;
+
+	if (!current->ret_stack)
+		return 0;
+
+	/*
+	 * We must make sure the ret_stack is tested before we read
+	 * anything else.
+	 */
+	smp_rmb();
+
+	curr_ret = current->curr_trace_stack;
+
+	/* Test the stack if we are in irq or not. */
+	last_stack = !!trace_recursion_test(TRACE_IN_IRQ);
+	irq_stack = !!(!object_is_on_stack(&irq_stack) || in_irq());
+
+	/* Always update the irq info if it changes */
+	if (irq_stack != last_stack) {
+		if (irq_stack)
+			trace_recursion_set(TRACE_IN_IRQ);
+		else
+			trace_recursion_clear(TRACE_IN_IRQ);
+	}
+
+	/* If we just transitioned from normal to irq context then print */
+	if (!last_stack && irq_stack)
+		goto out_trace;
+
+	/* If the ret_stack is empty this is our first function, trace it */
+	if (curr_ret == -1)
+		goto out_trace;
+
+	/* If we just transitioned from irq to normal, find last normal stack */
+	if (last_stack && !irq_stack) {
+		for (i = curr_ret; i >= 0; i--) {
+			if (!(current->ret_stack[i].start_ip & 1))
+				break;
+		}
+		curr_ret = i;
+		if (curr_ret < 0)
+			goto out_trace;
+	}
+
+	/* Check if the parent function is in our saved stack */
+	for (i = curr_ret; i >= 0; i--) {
+		if (parent_ip >= current->ret_stack[i].start_ip &&
+		    parent_ip <= current->ret_stack[i].end_ip)
+			break;
+	}
+	/* If found then reset curr_trace_stack to our parent and trace */
+	if (i >= 0) {
+		curr_ret = i;
+		goto out_trace;
+	}
+
+	/* If stack is full, just print everything */
+	if (curr_ret == FTRACE_RETFUNC_DEPTH - 1)
+		return 0;
+
+	/* If this stack is higher than the top stack, trace it */
+	if (object_is_on_stack(&irq_stack) &&
+	    ((unsigned long)&irq_stack > current->trace_start_stack ||
+	     (void *)&irq_stack > task_stack_page(current) + STACK_OFFSET)) {
+		/* Force recording of new start_stack */
+		curr_ret = -1;
+		goto out_trace;
+	}
+
+	/*
+	 * Seems that this function was called by something that was
+	 * marked, notrace. We don't want to trace this function either.
+	 */
+	current->curr_trace_stack = curr_ret;
+	return 1;
+
+ out_trace:
+	/* If stack is full, just print everything */
+	if (curr_ret == FTRACE_RETFUNC_DEPTH - 1)
+		return 0;
+
+	i = ++curr_ret;
+	current->curr_trace_stack = curr_ret;
+	if (!irq_stack && (!i || !current->trace_start_stack))
+		current->trace_start_stack = (unsigned long)&irq_stack;
+
+	/* Find the actual function pointer */
+	kallsyms_lookup_size_offset(ip, &size, &offset);
+
+	/* Make offset point to the actual function */
+	offset = ip - offset;
+
+	/* We use the LSB of start_ip to denote irq stack or not */
+	offset = (~1UL & offset) | !!irq_stack;
+
+	current->ret_stack[i].start_ip = offset;
+	current->ret_stack[i].end_ip = offset + size;
+
+	return 0;
+}
+
 static void
 function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 {
@@ -96,7 +238,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1)) {
+	if (likely(disabled == 1) && !skip_notrace(ip, parent_ip)) {
 		pc = preempt_count();
 		trace_function(tr, ip, parent_ip, flags, pc);
 	}
@@ -127,7 +269,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1)) {
+	if (likely(disabled == 1) && !skip_notrace(ip, parent_ip)) {
 		pc = preempt_count();
 		trace_function(tr, ip, parent_ip, flags, pc);
 		/*
@@ -189,6 +331,9 @@ static void tracing_start_function_trace(void)
 	else
 		register_ftrace_function(&trace_ops);
 
+	if (trace_flags & TRACE_ITER_EXTEND_NOTRACE)
+		trace_extend_notrace(1);
+
 	ftrace_function_enabled = 1;
 }
 
@@ -196,6 +341,9 @@ static void tracing_stop_function_trace(void)
 {
 	ftrace_function_enabled = 0;
 
+	if (trace_flags & TRACE_ITER_EXTEND_NOTRACE)
+		trace_extend_notrace(0);
+
 	if (func_flags.val & TRACE_FUNC_OPT_STACK)
 		unregister_ftrace_function(&trace_stack_ops);
 	else
-- 
1.7.5.4


