Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab0CZMcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0CZMcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:32:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv3 1/2] tracing: graph output support for irqsoff tracer
Date: Fri, 26 Mar 2010 13:32:02 +0100
Message-Id: <1269606723-12439-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
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
 kernel/trace/trace.c                 |   31 ++++--
 kernel/trace/trace.h                 |   10 ++
 kernel/trace/trace_functions_graph.c |   15 ++-
 kernel/trace/trace_irqsoff.c         |  184 ++++++++++++++++++++++++++++++++--
 4 files changed, 217 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ec2ee6..2229f5a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
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
index 2825ef2..42ad603 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -378,6 +378,7 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_default_header(struct seq_file *m);
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
@@ -492,8 +493,17 @@ extern int trace_clock_id;
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+extern void print_graph_headers(struct seq_file *s);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
+extern void graph_trace_open(struct trace_iterator *iter);
+extern void graph_trace_close(struct trace_iterator *iter);
+extern int __trace_graph_entry(struct trace_array *tr,
+			struct ftrace_graph_ent *trace,
+			unsigned long flags, int pc);
+extern void __trace_graph_return(struct trace_array *tr,
+			struct ftrace_graph_ret *trace,
+			unsigned long flags, int pc);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e6989d9..d1b5d38 100644
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
@@ -1087,6 +1087,11 @@ print_graph_function(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 		return print_graph_return(&field->ret, s, entry, iter);
 	}
+	case TRACE_STACK:
+	case TRACE_FN:
+		/* dont trace stack and functions as comments */
+		return TRACE_TYPE_UNHANDLED;
+
 	default:
 		return print_graph_comment(s, entry, iter);
 	}
@@ -1116,7 +1121,7 @@ static void print_lat_header(struct seq_file *s)
 	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
-static void print_graph_headers(struct seq_file *s)
+void print_graph_headers(struct seq_file *s)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
@@ -1152,7 +1157,7 @@ static void print_graph_headers(struct seq_file *s)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-static void graph_trace_open(struct trace_iterator *iter)
+void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
 	struct fgraph_data *data;
@@ -1187,7 +1192,7 @@ static void graph_trace_open(struct trace_iterator *iter)
 	pr_warning("function graph tracer: not enough memory\n");
 }
 
-static void graph_trace_close(struct trace_iterator *iter)
+void graph_trace_close(struct trace_iterator *iter)
 {
 	struct fgraph_data *data = iter->private;
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..2b67e35 100644
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
+	.val = 0,
+	.opts = trace_opts,
+};
+
+#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
+
 /*
  * Sequence count - we record it when starting a measurement and
  * skip the latency if the sequence has changed - some other section
@@ -108,6 +128,129 @@ static struct ftrace_ops trace_ops __read_mostly =
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
+static enum print_line_t
+irqsoff_print_line(struct trace_iterator *iter)
+{
+	/*
+	 * In graph mode call the graph tracer output function,
+	 * otherwise go with the TRACE_FN event handler
+	 */
+	if (is_graph())
+		return print_graph_function(iter);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+void irqsoff_print_header(struct seq_file *s)
+{
+	if (is_graph())
+		print_graph_headers(s);
+	else
+		trace_default_header(s);
+}
+#else
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -347,19 +490,36 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
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
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	else
+		ret = register_ftrace_graph(&irqsoff_graph_return,
+					    &irqsoff_graph_entry);
+#endif
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
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	else
+		unregister_ftrace_graph();
+#endif
 }
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -372,12 +532,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
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
@@ -409,9 +571,17 @@ static struct tracer irqsoff_tracer __read_mostly =
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
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
+#endif
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
-- 
1.6.6.1

