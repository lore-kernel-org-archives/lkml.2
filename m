Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0IODEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:04:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0IODEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:04:04 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=t-HZLlH-gkcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=A8rld-07AqTd04APrigA:9 a=0kIoqo3Rh7jOZDaCjgL10AL2ifkA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100915030402.101080952@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Sep 2010 23:01:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] tracing: Do not trace in irq when funcgraph-irq option is zero
References: <20100915030139.444219083@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Do-not-trace-in-irq-when-funcgraph-irq-optio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the function graph tracer funcgraph-irq option is zero, disable
tracing in IRQs. This makes the option have two effects.

1) When reading the trace file, do not display the functions that
   happen in interrupt context (when detected)

2) [*new*] When recording a trace, skip those that are detected
   to be in interrupt by the 'in_irq()' function

Note, in_irq() is updated at irq_enter() and irq_exit(). There are
still functions that are recorded by the function graph tracer that
is in interrupt context but outside the irq_enter/exit() routines.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8674750..02c708a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -15,6 +15,9 @@
 #include "trace.h"
 #include "trace_output.h"
 
+/* When set, irq functions will be ignored */
+static int ftrace_graph_skip_irqs;
+
 struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
@@ -208,6 +211,14 @@ int __trace_graph_entry(struct trace_array *tr,
 	return 1;
 }
 
+static inline int ftrace_graph_ignore_irqs(void)
+{
+	if (!ftrace_graph_skip_irqs)
+		return 0;
+
+	return in_irq();
+}
+
 int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = graph_array;
@@ -222,7 +233,8 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 		return 0;
 
 	/* trace it when it is-nested-in or is a function enabled. */
-	if (!(trace->depth || ftrace_graph_addr(trace->func)))
+	if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
+	      ftrace_graph_ignore_irqs())
 		return 0;
 
 	local_irq_save(flags);
@@ -1334,6 +1346,14 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static int func_graph_set_flag(u32 old_flags, u32 bit, int set)
+{
+	if (bit == TRACE_GRAPH_PRINT_IRQS)
+		ftrace_graph_skip_irqs = !set;
+
+	return 0;
+}
+
 static struct trace_event_functions graph_functions = {
 	.trace		= print_graph_function_event,
 };
@@ -1360,6 +1380,7 @@ static struct tracer graph_trace __read_mostly = {
 	.print_line	= print_graph_function,
 	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
+	.set_flag	= func_graph_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_function_graph,
 #endif
-- 
1.7.1


