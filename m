Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0IODEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:04:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0IODEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:04:04 -0400
X-Authority-Analysis: v=1.1 cv=8l6A00wGdfxWf8DimOOtudg6dZOi9rXZmlWhmOLJpog= c=1 sm=0 a=FykpPtqSPTsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=wh7I_t_pnjIJhw1iQA0A:9 a=EMPhtwczfhJotSV4eXllQK2cdRYA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100915030401.828275095@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 23:01:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] tracing: Add funcgraph-irq option for function graph tracer.
References: <20100915030139.444219083@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-funcgraph-irq-option-for-function-graph-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

It's handy to be able to disable the irq related output
and not to have to jump over each irq related code, when
you have no interrest in it.

The option is by default enabled, so there's no change to
current behaviour. It affects only the final output, so all
the irq related data stay in the ring buffer.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20100907145344.GC1912@jolsa.brq.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |  101 +++++++++++++++++++++++++++++++++-
 1 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index c93bcb2..8674750 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -18,6 +18,7 @@
 struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
+	int		depth_irq;
 	int		ignore;
 	unsigned long	enter_funcs[FTRACE_RETFUNC_DEPTH];
 };
@@ -41,6 +42,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME	0x20
+#define TRACE_GRAPH_PRINT_IRQS		0x40
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -55,13 +57,15 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
 	/* Display absolute time of an entry */
 	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
+	/* Display interrupts */
+	{ TRACER_OPT(funcgraph-irqs, TRACE_GRAPH_PRINT_IRQS) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
 	/* Don't display overruns and proc by default */
 	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
-	       TRACE_GRAPH_PRINT_DURATION,
+	       TRACE_GRAPH_PRINT_DURATION | TRACE_GRAPH_PRINT_IRQS,
 	.opts = trace_opts
 };
 
@@ -855,6 +859,92 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 	return 0;
 }
 
+/*
+ * Entry check for irq code
+ *
+ * returns 1 if
+ *  - we are inside irq code
+ *  - we just extered irq code
+ *
+ * retunns 0 if
+ *  - funcgraph-interrupts option is set
+ *  - we are not inside irq code
+ */
+static int
+check_irq_entry(struct trace_iterator *iter, u32 flags,
+		unsigned long addr, int depth)
+{
+	int cpu = iter->cpu;
+	struct fgraph_data *data = iter->private;
+	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
+	if (flags & TRACE_GRAPH_PRINT_IRQS)
+		return 0;
+
+	/*
+	 * We are inside the irq code
+	 */
+	if (*depth_irq >= 0)
+		return 1;
+
+	if ((addr < (unsigned long)__irqentry_text_start) ||
+	    (addr >= (unsigned long)__irqentry_text_end))
+		return 0;
+
+	/*
+	 * We are entering irq code.
+	 */
+	*depth_irq = depth;
+	return 1;
+}
+
+/*
+ * Return check for irq code
+ *
+ * returns 1 if
+ *  - we are inside irq code
+ *  - we just left irq code
+ *
+ * returns 0 if
+ *  - funcgraph-interrupts option is set
+ *  - we are not inside irq code
+ */
+static int
+check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
+{
+	int cpu = iter->cpu;
+	struct fgraph_data *data = iter->private;
+	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
+	if (flags & TRACE_GRAPH_PRINT_IRQS)
+		return 0;
+
+	/*
+	 * We are not inside the irq code.
+	 */
+	if (*depth_irq == -1)
+		return 0;
+
+	/*
+	 * We are inside the irq code, and this is returning entry.
+	 * Let's not trace it and clear the entry depth, since
+	 * we are out of irq code.
+	 *
+	 * This condition ensures that we 'leave the irq code' once
+	 * we are out of the entry depth. Thus protecting us from
+	 * the RETURN entry loss.
+	 */
+	if (*depth_irq >= depth) {
+		*depth_irq = -1;
+		return 1;
+	}
+
+	/*
+	 * We are inside the irq code, and this is not the entry.
+	 */
+	return 1;
+}
+
 static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			struct trace_iterator *iter, u32 flags)
@@ -865,6 +955,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	static enum print_line_t ret;
 	int cpu = iter->cpu;
 
+	if (check_irq_entry(iter, flags, call->func, call->depth))
+		return TRACE_TYPE_HANDLED;
+
 	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -902,6 +995,9 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int ret;
 	int i;
 
+	if (check_irq_return(iter, flags, trace->depth))
+		return TRACE_TYPE_HANDLED;
+
 	if (data) {
 		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
@@ -1210,9 +1306,12 @@ void graph_trace_open(struct trace_iterator *iter)
 		pid_t *pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 		int *ignore = &(per_cpu_ptr(data->cpu_data, cpu)->ignore);
+		int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
 		*pid = -1;
 		*depth = 0;
 		*ignore = 0;
+		*depth_irq = -1;
 	}
 
 	iter->private = data;
-- 
1.7.1


