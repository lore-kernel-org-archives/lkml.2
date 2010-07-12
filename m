Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0GLQVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0GLQVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:21:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] trace: funcgraph tracer - adding funcgraph-irq option
Date: Mon, 12 Jul 2010 18:21:10 +0200
Message-Id: <1278951670-8133-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding funcgraph-irq option for function graph tracer.

It's handy to be able to disable the irq related output
and not to have to jump over each irq related code, when
you have no interrest in it.

The option is by default enabled, so there's no change to
current behaviour. It affects only the final output, so all
the irq related data stays in the ring buffer.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   96 +++++++++++++++++++++++++++++++++-
 1 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6bff236..f28476e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -19,6 +19,7 @@ struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
 	int		ignore;
+	unsigned long	irq_entry_addr;
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
+	{ TRACER_OPT(funcgraph-irqs, TRACE_GRAPH_PRINT_IRQS ) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
 	/* Don't display overruns and proc by default */
 	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
-	       TRACE_GRAPH_PRINT_DURATION,
+	       TRACE_GRAPH_PRINT_DURATION | TRACE_GRAPH_PRINT_IRQS,
 	.opts = trace_opts
 };
 
@@ -847,6 +851,88 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
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
+check_irq_entry(struct trace_iterator *iter, u32 flags, unsigned long addr)
+{
+	struct fgraph_data *data = iter->private;
+	int cpu = iter->cpu;
+	unsigned long *irq_entry_addr;
+
+	if (flags & TRACE_GRAPH_PRINT_IRQS)
+		return 0;
+
+	/*
+	 * We are inside the irq code
+	 */
+	irq_entry_addr = &(per_cpu_ptr(data->cpu_data, cpu)->irq_entry_addr);
+	if (*irq_entry_addr)
+		return 1;
+
+	if ((addr < (unsigned long)__irqentry_text_start) ||
+	    (addr >= (unsigned long)__irqentry_text_end))
+		return 0;
+
+	/*
+	 * We are entering irq code.
+	 */
+	*irq_entry_addr = addr;
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
+check_irq_return(struct trace_iterator *iter, u32 flags, unsigned long addr)
+{
+	struct fgraph_data *data = iter->private;
+	int cpu = iter->cpu;
+	unsigned long *irq_entry_addr;
+
+	if (flags & TRACE_GRAPH_PRINT_IRQS)
+		return 0;
+
+	/*
+	 * We are not inside the irq code.
+	 */
+	irq_entry_addr = &(per_cpu_ptr(data->cpu_data, cpu)->irq_entry_addr);
+	if (!(*irq_entry_addr))
+		return 0;
+
+	/*
+	 * We are inside the irq code, and this is not the entry.
+	 */
+	if (*irq_entry_addr != addr)
+		return 1;
+
+	/*
+	 * We are inside the irq code, and this is returning entry.
+	 * Let's not trace it and clear the entry address, since
+	 * we are out of irq code.
+	 */
+	*irq_entry_addr = 0;
+	return 1;
+}
+
 static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			struct trace_iterator *iter, u32 flags)
@@ -857,6 +943,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	static enum print_line_t ret;
 	int cpu = iter->cpu;
 
+	if (check_irq_entry(iter, flags, call->func))
+		return TRACE_TYPE_HANDLED;
+
 	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -894,6 +983,9 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int ret;
 	int i;
 
+	if (check_irq_return(iter, flags, trace->func))
+		return TRACE_TYPE_HANDLED;
+
 	if (data) {
 		struct fgraph_cpu_data *cpu_data;
 		int cpu = iter->cpu;
@@ -1202,9 +1294,11 @@ void graph_trace_open(struct trace_iterator *iter)
 		pid_t *pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 		int *ignore = &(per_cpu_ptr(data->cpu_data, cpu)->ignore);
+		unsigned long *irq_entry_addr = &(per_cpu_ptr(data->cpu_data, cpu)->irq_entry_addr);
 		*pid = -1;
 		*depth = 0;
 		*ignore = 0;
+		*irq_entry_addr = 0;
 	}
 
 	iter->private = data;
