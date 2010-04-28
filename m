Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0D1BiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:38:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0D1BiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:10 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=V81aUR3VNOUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=zCALLqyuWmiC37I1UCcA:9 a=VnaRMnjtHMdMXsprscoA:7 a=2wYNGMs5HQC5AjNXbuTdKHtMYXsA:4 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013805.846332780@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/8] tracing: Have graph flags passed in to ouput functions
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Have-graph-flags-passed-in-to-ouput-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Let the function graph tracer have custom flags passed to its
output functions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1270227683-14631-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |    6 +-
 kernel/trace/trace_functions_graph.c |  123 +++++++++++++++++++---------------
 2 files changed, 73 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2825ef2..970004c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -491,7 +491,9 @@ extern int trace_clock_id;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+extern enum print_line_t
+print_graph_function_flags(struct trace_iterator *iter, u32 flags);
+extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 
@@ -524,7 +526,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #else /* CONFIG_FUNCTION_GRAPH_TRACER */
 static inline enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	return TRACE_TYPE_UNHANDLED;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index db9e06b..de5f651 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -527,17 +527,18 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 /* Signal a overhead of time execution to the output */
 static int
-print_graph_overhead(unsigned long long duration, struct trace_seq *s)
+print_graph_overhead(unsigned long long duration, struct trace_seq *s,
+		     u32 flags)
 {
 	/* If duration disappear, we don't need anything */
-	if (!(tracer_flags.val & TRACE_GRAPH_PRINT_DURATION))
+	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
 		return 1;
 
 	/* Non nested entry or return */
 	if (duration == -1)
 		return trace_seq_printf(s, "  ");
 
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
 		/* Duration exceeded 100 msecs */
 		if (duration > 100000ULL)
 			return trace_seq_printf(s, "! ");
@@ -563,7 +564,7 @@ static int print_graph_abs_time(u64 t, struct trace_seq *s)
 
 static enum print_line_t
 print_graph_irq(struct trace_iterator *iter, unsigned long addr,
-		enum trace_type type, int cpu, pid_t pid)
+		enum trace_type type, int cpu, pid_t pid, u32 flags)
 {
 	int ret;
 	struct trace_seq *s = &iter->seq;
@@ -573,21 +574,21 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return TRACE_TYPE_UNHANDLED;
 
 	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+	if (flags & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+	if (flags & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, pid);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -597,7 +598,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -610,7 +611,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Don't close the duration column if haven't one */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		trace_seq_printf(s, " |");
 	ret = trace_seq_printf(s, "\n");
 
@@ -680,7 +681,8 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 static enum print_line_t
 print_graph_entry_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *entry,
-		struct ftrace_graph_ret_entry *ret_entry, struct trace_seq *s)
+		struct ftrace_graph_ret_entry *ret_entry,
+		struct trace_seq *s, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ret *graph_ret;
@@ -712,12 +714,12 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	}
 
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	ret = print_graph_overhead(duration, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = print_graph_duration(duration, s);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -740,7 +742,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 static enum print_line_t
 print_graph_entry_nested(struct trace_iterator *iter,
 			 struct ftrace_graph_ent_entry *entry,
-			 struct trace_seq *s, int cpu)
+			 struct trace_seq *s, int cpu, u32 flags)
 {
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 	struct fgraph_data *data = iter->private;
@@ -760,12 +762,12 @@ print_graph_entry_nested(struct trace_iterator *iter,
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -791,7 +793,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 
 static enum print_line_t
 print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
-		     int type, unsigned long addr)
+		     int type, unsigned long addr, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct trace_entry *ent = iter->ent;
@@ -804,27 +806,27 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 
 	if (type) {
 		/* Interrupt */
-		ret = print_graph_irq(iter, addr, type, cpu, ent->pid);
+		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+	if (flags & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
 	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+	if (flags & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, ent->pid);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -846,7 +848,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 
 static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
-			struct trace_iterator *iter)
+			struct trace_iterator *iter, u32 flags)
 {
 	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ent *call = &field->graph_ent;
@@ -854,14 +856,14 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	static enum print_line_t ret;
 	int cpu = iter->cpu;
 
-	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
+	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
-		ret = print_graph_entry_leaf(iter, field, leaf_ret, s);
+		ret = print_graph_entry_leaf(iter, field, leaf_ret, s, flags);
 	else
-		ret = print_graph_entry_nested(iter, field, s, cpu);
+		ret = print_graph_entry_nested(iter, field, s, cpu, flags);
 
 	if (data) {
 		/*
@@ -880,7 +882,8 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 
 static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
-		   struct trace_entry *ent, struct trace_iterator *iter)
+		   struct trace_entry *ent, struct trace_iterator *iter,
+		   u32 flags)
 {
 	unsigned long long duration = trace->rettime - trace->calltime;
 	struct fgraph_data *data = iter->private;
@@ -910,16 +913,16 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		}
 	}
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	ret = print_graph_overhead(duration, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = print_graph_duration(duration, s);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -949,14 +952,15 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	}
 
 	/* Overrun */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
+	if (flags & TRACE_GRAPH_PRINT_OVERRUN) {
 		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
 					trace->overrun);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET, cpu, pid);
+	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET,
+			      cpu, pid, flags);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -964,8 +968,8 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 }
 
 static enum print_line_t
-print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
-		    struct trace_iterator *iter)
+print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
+		    struct trace_iterator *iter, u32 flags)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct fgraph_data *data = iter->private;
@@ -977,16 +981,16 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	if (data)
 		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s);
+	ret = print_graph_overhead(-1, s, flags);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+	if (flags & TRACE_GRAPH_PRINT_DURATION) {
 		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
@@ -1041,7 +1045,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 
 
 enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1062,7 +1066,7 @@ print_graph_function(struct trace_iterator *iter)
 	if (data && data->failed) {
 		field = &data->ent;
 		iter->cpu = data->cpu;
-		ret = print_graph_entry(field, s, iter);
+		ret = print_graph_entry(field, s, iter, flags);
 		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
 			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;
 			ret = TRACE_TYPE_NO_CONSUME;
@@ -1082,38 +1086,44 @@ print_graph_function(struct trace_iterator *iter)
 		struct ftrace_graph_ent_entry saved;
 		trace_assign_type(field, entry);
 		saved = *field;
-		return print_graph_entry(&saved, s, iter);
+		return print_graph_entry(&saved, s, iter, flags);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
 		trace_assign_type(field, entry);
-		return print_graph_return(&field->ret, s, entry, iter);
+		return print_graph_return(&field->ret, s, entry, iter, flags);
 	}
 	default:
-		return print_graph_comment(s, entry, iter);
+		return print_graph_comment(s, entry, iter, flags);
 	}
 
 	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
+print_graph_function(struct trace_iterator *iter)
+{
+	return print_graph_function_flags(iter, tracer_flags.val);
+}
+
+static enum print_line_t
 print_graph_function_event(struct trace_iterator *iter, int flags)
 {
 	return print_graph_function(iter);
 }
 
-static void print_lat_header(struct seq_file *s)
+static void print_lat_header(struct seq_file *s, u32 flags)
 {
 	static const char spaces[] = "                "	/* 16 spaces */
 		"    "					/* 4 spaces */
 		"                 ";			/* 17 spaces */
 	int size = 0;
 
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		size += 16;
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		size += 4;
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		size += 17;
 
 	seq_printf(s, "#%.*s  _-----=> irqs-off        \n", size, spaces);
@@ -1124,42 +1134,47 @@ static void print_lat_header(struct seq_file *s)
 	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
-static void print_graph_headers(struct seq_file *s)
+void print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
 	if (lat)
-		print_lat_header(s);
+		print_lat_header(s, flags);
 
 	/* 1st line */
 	seq_printf(s, "#");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "     TIME       ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		seq_printf(s, " CPU");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
 		seq_printf(s, "|||||");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
 	seq_printf(s, "#");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "      |         ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+	if (flags & TRACE_GRAPH_PRINT_CPU)
 		seq_printf(s, " |  ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
 		seq_printf(s, "|||||");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
 }
 
+static void print_graph_headers(struct seq_file *s)
+{
+	print_graph_headers_flags(s, tracer_flags.val);
+}
+
 static void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
-- 
1.7.0


