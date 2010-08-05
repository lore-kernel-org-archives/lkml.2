Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab0HEO5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758923Ab0HEO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:57:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] trace: add graph output support for wakeup tracer
Date: Thu,  5 Aug 2010 16:57:27 +0200
Message-Id: <1281020247-5756-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding function graph output to irqsoff tracer.
The graph output is enabled by setting new 'display-graph' trace option.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |  274 +++++++++++++++++++++++++++++++++++--
 1 files changed, 264 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 4086eae..b576141 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -31,13 +31,33 @@ static int			wakeup_rt;
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+static void wakeup_reset(struct trace_array *tr);
 static void __wakeup_reset(struct trace_array *tr);
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
+static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
 static int save_lat_flag;
 
+#define TRACE_DISPLAY_GRAPH     1
+
+static struct tracer_opt trace_opts[] = {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* display latency trace as call graph */
+	{ TRACER_OPT(display-graph, TRACE_DISPLAY_GRAPH) },
+#endif
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val  = 0,
+	.opts = trace_opts,
+};
+
+#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
+
 #ifdef CONFIG_FUNCTION_TRACER
 /*
- * irqsoff uses its own tracer function to keep the overhead down:
+ * wakeup uses its own tracer function to keep the overhead down:
  */
 static void
 wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
@@ -80,8 +100,234 @@ static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
 };
+
+static int start_func_tracer(int graph)
+{
+	int ret;
+
+	if (!graph)
+		ret = register_ftrace_function(&trace_ops);
+	else
+		ret = register_ftrace_graph(&wakeup_graph_return,
+					    &wakeup_graph_entry);
+
+	if (!ret && tracing_is_enabled())
+		tracer_enabled = 1;
+	else
+		tracer_enabled = 0;
+
+	return ret;
+}
+
+static void stop_func_tracer(int graph)
+{
+	tracer_enabled = 0;
+
+	if (!graph)
+		unregister_ftrace_function(&trace_ops);
+	else
+		unregister_ftrace_graph();
+}
+
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+{
+
+	if (!(bit & TRACE_DISPLAY_GRAPH))
+		return -EINVAL;
+
+	if (!(is_graph() ^ set))
+		return 0;
+
+	stop_func_tracer(!set);
+	wakeup_reset(wakeup_trace);
+
+	return start_func_tracer(set);
+}
+
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu, pc, ret = 0;
+
+	if (likely(!wakeup_task))
+		return 0;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	local_irq_save(flags);
+	ret = __trace_graph_entry(tr, trace, flags, pc);
+	local_irq_restore(flags);
+
+ out:
+	atomic_dec(&data->disabled);
+
+ out_enable:
+	preempt_enable_notrace();
+	return ret;
+}
+
+static void wakeup_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu, pc;
+
+	if (likely(!wakeup_task))
+		return;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	local_irq_save(flags);
+	__trace_graph_return(tr, trace, flags, pc);
+	local_irq_restore(flags);
+
+ out:
+	atomic_dec(&data->disabled);
+
+ out_enable:
+	preempt_enable_notrace();
+	return;
+}
+
+static void wakeup_trace_open(struct trace_iterator *iter)
+{
+	if (is_graph())
+		graph_trace_open(iter);
+}
+
+static void wakeup_trace_close(struct trace_iterator *iter)
+{
+	if (iter->private)
+		graph_trace_close(iter);
+}
+
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC)
+
+static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
+{
+	u32 flags = GRAPH_TRACER_FLAGS;
+
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		flags |= TRACE_GRAPH_PRINT_DURATION;
+	else
+		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+	/*
+	 * In graph mode call the graph tracer output function,
+	 * otherwise go with the TRACE_FN event handler
+	 */
+	if (is_graph())
+		return print_graph_function_flags(iter, flags);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void wakeup_print_header(struct seq_file *s)
+{
+	if (is_graph()) {
+		struct trace_iterator *iter = s->private;
+		u32 flags = GRAPH_TRACER_FLAGS;
+
+		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+			/* print nothing if the buffers are empty */
+			if (trace_empty(iter))
+				return;
+
+			print_trace_header(s, iter);
+			flags |= TRACE_GRAPH_PRINT_DURATION;
+		} else
+			flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+		print_graph_headers_flags(s, flags);
+	} else
+		trace_default_header(s);
+}
+
+static void
+trace_graph_function(struct trace_array *tr,
+		 unsigned long ip, unsigned long flags, int pc)
+{
+	u64 time = trace_clock_local();
+	struct ftrace_graph_ent ent = {
+		.func  = ip,
+		.depth = 0,
+	};
+	struct ftrace_graph_ret ret = {
+		.func     = ip,
+		.depth    = 0,
+		.calltime = time,
+		.rettime  = time,
+	};
+
+	__trace_graph_entry(tr, &ent, flags, pc);
+	__trace_graph_return(tr, &ret, flags, pc);
+}
+
+static void
+__trace_function(struct trace_array *tr,
+		 unsigned long ip, unsigned long parent_ip,
+		 unsigned long flags, int pc)
+{
+	if (!is_graph())
+		trace_function(tr, ip, parent_ip, flags, pc);
+	else {
+		trace_graph_function(tr, parent_ip, flags, pc);
+		trace_graph_function(tr, ip, flags, pc);
+	}
+}
+
+#else
+#define __trace_function trace_function
+
+static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
+{
+	return -1;
+}
+
+static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
+{
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void wakeup_graph_return(struct ftrace_graph_ret *trace) { }
+static void wakeup_print_header(struct seq_file *s) { }
+static void wakeup_trace_open(struct trace_iterator *iter) { }
+static void wakeup_trace_close(struct trace_iterator *iter) { }
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -152,7 +398,7 @@ probe_wakeup_sched_switch(void *ignore,
 	/* The task we are waiting for is waking up */
 	data = wakeup_trace->data[wakeup_cpu];
 
-	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
+	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
 	T0 = data->preempt_timestamp;
@@ -252,7 +498,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	 * is not called by an assembly function  (where as schedule is)
 	 * it should be safe to use it here.
 	 */
-	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	__trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
 	arch_spin_unlock(&wakeup_lock);
@@ -303,12 +549,8 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	 */
 	smp_wmb();
 
-	register_ftrace_function(&trace_ops);
-
-	if (tracing_is_enabled())
-		tracer_enabled = 1;
-	else
-		tracer_enabled = 0;
+	if (start_func_tracer(is_graph()))
+		printk(KERN_ERR "failed to start wakeup tracer\n");
 
 	return;
 fail_deprobe_wake_new:
@@ -320,7 +562,7 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
+	stop_func_tracer(is_graph());
 	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 	unregister_trace_sched_wakeup(probe_wakeup, NULL);
@@ -379,9 +621,15 @@ static struct tracer wakeup_tracer __read_mostly =
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
 	.print_max	= 1,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
 	.use_max_tr	= 1,
 };
 
@@ -394,9 +642,15 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.stop		= wakeup_tracer_stop,
 	.wait_pipe	= poll_wait_pipe,
 	.print_max	= 1,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
 	.use_max_tr	= 1,
 };
 
-- 
1.7.2

