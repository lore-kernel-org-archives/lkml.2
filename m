Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0DBRCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab0DBRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:01:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv6 3/4] tracing: graph output support for irqsoff tracer
Date: Fri,  2 Apr 2010 19:01:22 +0200
Message-Id: <1270227683-14631-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when I was using irqsoff tracer, I thought it could be any use
to see the disabled IRQs flow output same way as function graph output.

The graph output is enabled by setting new 'display-graph' trace option
of irqsoff tracer.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h               |   15 ++-
 kernel/trace/trace.c                 |   35 +++--
 kernel/trace/trace.h                 |   21 +++
 kernel/trace/trace_functions_graph.c |   15 ++-
 kernel/trace/trace_irqsoff.c         |  259 ++++++++++++++++++++++++++++++++--
 5 files changed, 312 insertions(+), 33 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index cc12b3c..205beae 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -352,6 +352,10 @@ struct ftrace_graph_ret {
 	int depth;
 };
 
+/* Type of the callback handlers for tracing function graph*/
+typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
+typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
@@ -400,10 +404,6 @@ extern char __irqentry_text_end[];
 
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
-/* Type of the callback handlers for tracing function graph*/
-typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
-typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
-
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
 
@@ -441,6 +441,13 @@ static inline void unpause_graph_tracing(void)
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
 
+static inline int register_ftrace_graph(trace_func_graph_ret_t retfunc,
+			  trace_func_graph_ent_t entryfunc)
+{
+	return -1;
+}
+static inline void unregister_ftrace_graph(void) { }
+
 static inline int task_curr_ret_stack(struct task_struct *tsk)
 {
 	return -1;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ec2ee6..5acb3a8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1786,7 +1786,7 @@ static void print_func_help_header(struct seq_file *m)
 }
 
 
-static void
+void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
@@ -1995,7 +1995,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
-static int trace_empty(struct trace_iterator *iter)
+int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
 
@@ -2058,6 +2058,23 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	return print_trace_fmt(iter);
 }
 
+void trace_default_header(struct seq_file *m)
+{
+	struct trace_iterator *iter = m->private;
+
+	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+		/* print nothing if the buffers are empty */
+		if (trace_empty(iter))
+			return;
+		print_trace_header(m, iter);
+		if (!(trace_flags & TRACE_ITER_VERBOSE))
+			print_lat_help_header(m);
+	} else {
+		if (!(trace_flags & TRACE_ITER_VERBOSE))
+			print_func_help_header(m);
+	}
+}
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
@@ -2070,17 +2087,9 @@ static int s_show(struct seq_file *m, void *v)
 		}
 		if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
-		else if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
-			/* print nothing if the buffers are empty */
-			if (trace_empty(iter))
-				return 0;
-			print_trace_header(m, iter);
-			if (!(trace_flags & TRACE_ITER_VERBOSE))
-				print_lat_help_header(m);
-		} else {
-			if (!(trace_flags & TRACE_ITER_VERBOSE))
-				print_func_help_header(m);
-		}
+		else
+			trace_default_header(m);
+
 	} else if (iter->leftover) {
 		/*
 		 * If we filled the seq_file buffer earlier, we
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd4a8f5..9d3baf3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -376,6 +376,9 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_default_header(struct seq_file *m);
+void print_trace_header(struct seq_file *m, struct trace_iterator *iter);
+int trace_empty(struct trace_iterator *iter);
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
@@ -487,11 +490,29 @@ extern int trace_clock_id;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/* Flag options */
+#define TRACE_GRAPH_PRINT_OVERRUN       0x1
+#define TRACE_GRAPH_PRINT_CPU           0x2
+#define TRACE_GRAPH_PRINT_OVERHEAD      0x4
+#define TRACE_GRAPH_PRINT_PROC          0x8
+#define TRACE_GRAPH_PRINT_DURATION      0x10
+#define TRACE_GRAPH_PRINT_ABS_TIME      0x20
+
 extern enum print_line_t
 print_graph_function_flags(struct trace_iterator *iter, u32 flags);
 extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
+extern void graph_trace_open(struct trace_iterator *iter);
+extern void graph_trace_close(struct trace_iterator *iter);
+extern int __trace_graph_entry(struct trace_array *tr,
+			       struct ftrace_graph_ent *trace,
+			       unsigned long flags, int pc);
+extern void __trace_graph_return(struct trace_array *tr,
+				 struct ftrace_graph_ret *trace,
+				 unsigned long flags, int pc);
+
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 1b957af..fa6325b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -178,7 +178,7 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	return ret;
 }
 
-static int __trace_graph_entry(struct trace_array *tr,
+int __trace_graph_entry(struct trace_array *tr,
 				struct ftrace_graph_ent *trace,
 				unsigned long flags,
 				int pc)
@@ -245,7 +245,7 @@ int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 		return trace_graph_entry(trace);
 }
 
-static void __trace_graph_return(struct trace_array *tr,
+void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
@@ -1091,6 +1091,11 @@ print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 		trace_assign_type(field, entry);
 		return print_graph_return(&field->ret, s, entry, iter, flags);
 	}
+	case TRACE_STACK:
+	case TRACE_FN:
+		/* dont trace stack and functions as comments */
+		return TRACE_TYPE_UNHANDLED;
+
 	default:
 		return print_graph_comment(s, entry, iter, flags);
 	}
@@ -1168,12 +1173,12 @@ void print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-static void print_graph_headers(struct seq_file *s)
+void print_graph_headers(struct seq_file *s)
 {
 	print_graph_headers_flags(s, tracer_flags.val);
 }
 
-static void graph_trace_open(struct trace_iterator *iter)
+void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
 	struct fgraph_data *data;
@@ -1208,7 +1213,7 @@ static void graph_trace_open(struct trace_iterator *iter)
 	pr_warning("function graph tracer: not enough memory\n");
 }
 
-static void graph_trace_close(struct trace_iterator *iter)
+void graph_trace_close(struct trace_iterator *iter)
 {
 	struct fgraph_data *data = iter->private;
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..cc20d7c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -34,6 +34,9 @@ static int trace_type __read_mostly;
 
 static int save_lat_flag;
 
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
+static int start_irqsoff_tracer(struct trace_array *tr, int graph);
+
 #ifdef CONFIG_PREEMPT_TRACER
 static inline int
 preempt_trace(void)
@@ -55,6 +58,23 @@ irq_trace(void)
 # define irq_trace() (0)
 #endif
 
+#define TRACE_DISPLAY_GRAPH	1
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
 /*
  * Sequence count - we record it when starting a measurement and
  * skip the latency if the sequence has changed - some other section
@@ -108,6 +128,202 @@ static struct ftrace_ops trace_ops __read_mostly =
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	int cpu;
+
+	if (!(bit & TRACE_DISPLAY_GRAPH))
+		return -EINVAL;
+
+	if (!(is_graph() ^ set))
+		return 0;
+
+	stop_irqsoff_tracer(irqsoff_trace, !set);
+
+	for_each_possible_cpu(cpu)
+		per_cpu(tracing_cpu, cpu) = 0;
+
+	tracing_max_latency = 0;
+	tracing_reset_online_cpus(irqsoff_trace);
+
+	return start_irqsoff_tracer(irqsoff_trace, set);
+}
+
+static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int ret;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return 0;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return 0;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else
+		ret = 0;
+
+	atomic_dec(&data->disabled);
+	return ret;
+}
+
+static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, trace, flags, pc);
+	}
+
+	atomic_dec(&data->disabled);
+}
+
+static void irqsoff_trace_open(struct trace_iterator *iter)
+{
+	if (is_graph())
+		graph_trace_open(iter);
+
+}
+
+static void irqsoff_trace_close(struct trace_iterator *iter)
+{
+	if (iter->private)
+		graph_trace_close(iter);
+}
+
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
+			    TRACE_GRAPH_PRINT_PROC)
+
+static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
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
+static void irqsoff_print_header(struct seq_file *s)
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
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+
+static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
+{
+	return -1;
+}
+
+static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
+{
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void irqsoff_graph_return(struct ftrace_graph_ret *trace) { }
+static void irqsoff_print_header(struct seq_file *s) { }
+static void irqsoff_trace_open(struct trace_iterator *iter) { }
+static void irqsoff_trace_close(struct trace_iterator *iter) { }
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -150,7 +366,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 	/* Skip 5 functions to get to the irq/preempt enable function */
 	__trace_stack(tr, flags, 5, pc);
 
@@ -172,7 +388,7 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
+	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
 static inline void
@@ -204,7 +420,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 
 	local_save_flags(flags);
 
-	trace_function(tr, ip, parent_ip, flags, preempt_count());
+	__trace_function(tr, ip, parent_ip, flags, preempt_count());
 
 	per_cpu(tracing_cpu, cpu) = 1;
 
@@ -238,7 +454,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	atomic_inc(&data->disabled);
 
 	local_save_flags(flags);
-	trace_function(tr, ip, parent_ip, flags, preempt_count());
+	__trace_function(tr, ip, parent_ip, flags, preempt_count());
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
@@ -347,19 +563,32 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-static void start_irqsoff_tracer(struct trace_array *tr)
+static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 {
-	register_ftrace_function(&trace_ops);
-	if (tracing_is_enabled())
+	int ret = 0;
+
+	if (!graph)
+		ret = register_ftrace_function(&trace_ops);
+	else
+		ret = register_ftrace_graph(&irqsoff_graph_return,
+					    &irqsoff_graph_entry);
+
+	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
 	else
 		tracer_enabled = 0;
+
+	return ret;
 }
 
-static void stop_irqsoff_tracer(struct trace_array *tr)
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
+
+	if (!graph)
+		unregister_ftrace_function(&trace_ops);
+	else
+		unregister_ftrace_graph();
 }
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -372,12 +601,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	/* make sure that the tracer is visible */
 	smp_wmb();
 	tracing_reset_online_cpus(tr);
-	start_irqsoff_tracer(tr);
+
+	if (start_irqsoff_tracer(tr, is_graph()))
+		printk(KERN_ERR "failed to start irqsoff tracer\n");
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
-	stop_irqsoff_tracer(tr);
+	stop_irqsoff_tracer(tr, is_graph());
 
 	if (!save_lat_flag)
 		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
@@ -409,9 +640,15 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.print_header   = irqsoff_print_header,
+	.print_line     = irqsoff_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
-- 
1.6.6.1

