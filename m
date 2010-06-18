Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0FRIPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:15:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59143 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab0FRIPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:15:16 -0400
Message-ID: <4C1B2B0E.1050101@cn.fujitsu.com>
Date: Fri, 18 Jun 2010 16:15:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH V2] tracing, function graph: Remove the noisy output when
 use function graph filter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use function graph filter(echo some_functions >> set_graph_function)
we are only interested in the graph of some_functions.

But if a interrupt occurs when these functions are being traced(or preparing),
the graphs of the handlers of this interrupt are also recorded.
These events that we aren't interested in are totally noisy.

This patch skip the noise when TRACE_GRAPH_FILTER_SKIP_INTR flag is on
(very very seldom noise is still left, It's OK for tracing, doesn't it?).

changed from v1:
Add a TRACE_GRAPH_FILTER_SKIP_INTR flag which is default off
to control it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..d4fa4a4 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 
+#include <asm/irq_regs.h>
+
 #include "trace.h"
 #include "trace_output.h"
 
@@ -41,6 +43,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME	0x20
+#define TRACE_GRAPH_FILTER_SKIP_INTR	0x40
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -55,6 +58,8 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
 	/* Display absolute time of an entry */
 	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
+	/* Skip the graph nested in interrupts when funcgraph filter enabled */
+	{ TRACER_OPT(funcgraph-filter-skip-intr, TRACE_GRAPH_FILTER_SKIP_INTR) },
 	{ } /* Empty entry */
 };
 
@@ -213,13 +218,22 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	int ret;
 	int cpu;
 	int pc;
+	int depth = trace->depth;
+	unsigned long long cntxt = (unsigned long)(void *)get_irq_regs();
 
 	if (!ftrace_trace_task(current))
 		return 0;
 
 	/* trace it when it is-nested-in or is a function enabled. */
-	if (!(trace->depth || ftrace_graph_addr(trace->func)))
-		return 0;
+	if (!ftrace_graph_addr(trace->func)) {
+		if (!depth)
+			return 0;
+		if ((tracer_flags.val & TRACE_GRAPH_FILTER_SKIP_INTR)
+		    && (current->ret_stack[depth - 1].subtime != cntxt))
+			return 0;
+	}
+	/* We don't use subtime here, reuse it to save context. */
+	current->ret_stack[depth].subtime = cntxt;
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();

