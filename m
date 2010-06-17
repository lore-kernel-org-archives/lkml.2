Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab0FQI6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:58:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932804Ab0FQI6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:58:40 -0400
Message-ID: <4C19E3C3.2060900@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 16:58:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing, function graph: Remove the noisy output when use
 function graph filter
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

This patch remove them(very very seldom noise is still left,
It's OK for tracing, doesn't it?).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..9c130b3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 
+#include <asm/irq_regs.h>
+
 #include "trace.h"
 #include "trace_output.h"
 
@@ -213,13 +215,19 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
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
+		if (!depth || current->ret_stack[depth - 1].subtime != cntxt)
+			return 0;
+	}
+	/* We don't use subtime here, reuse it to save context. */
+	current->ret_stack[depth].subtime = cntxt;
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
