Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1GPLW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:22:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1GPLWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:53 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=YhTgZTORN4oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=DAz7-d-wjv9Io5UqZgwA:9 a=poTzZO6F3hRWVEBxnmgA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112251.423929607@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 01/20] tracing: Still trace filtered irq functions when irq trace is
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Still-trace-filtered-irq-functions-when-irq-.patch
 disabled
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a function is set to be traced by the set_graph_function, but the
option funcgraph-irqs is zero, and the traced function happens to be
called from a interrupt, it will not be traced.

The point of funcgraph-irqs is to not trace interrupts when we are
preempted by an irq, not to not trace functions we want to trace that
happen to be *in* a irq.

Luckily the current->trace_recursion element is perfect to add a flag
to help us be able to trace functions within an interrupt even when
we are not tracing interrupts that preempt the trace.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |   50 +++++++++++++++++++++++-----------
 kernel/trace/trace_functions_graph.c |    2 +-
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a3e2db7..651f35b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -278,6 +278,29 @@ struct tracer {
 };
 
 
+/* Only current can touch trace_recursion */
+#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
+#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
+
+/* Ring buffer has the 10 LSB bits to count */
+#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
+
+/* for function tracing recursion */
+#define TRACE_INTERNAL_BIT		(1<<11)
+#define TRACE_GLOBAL_BIT		(1<<12)
+/*
+ * Abuse of the trace_recursion.
+ * As we need a way to maintain state if we are tracing the function
+ * graph in irq because we want to trace a particular function that
+ * was called in irq context but we have irq tracing off. Since this
+ * can only be modified by current, we can reuse trace_recursion.
+ */
+#define TRACE_IRQ_BIT			(1<<13)
+
+#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
+#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+
 #define TRACE_PIPE_ALL_CPU	-1
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
@@ -516,8 +539,18 @@ static inline int ftrace_graph_addr(unsigned long addr)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
-		if (addr == ftrace_graph_funcs[i])
+		if (addr == ftrace_graph_funcs[i]) {
+			/*
+			 * If no irqs are to be traced, but a set_graph_function
+			 * is set, and called by an interrupt handler, we still
+			 * want to trace it.
+			 */
+			if (in_irq())
+				trace_recursion_set(TRACE_IRQ_BIT);
+			else
+				trace_recursion_clear(TRACE_IRQ_BIT);
 			return 1;
+		}
 	}
 
 	return 0;
@@ -794,19 +827,4 @@ extern const char *__stop___trace_bprintk_fmt[];
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
 #include "trace_entries.h"
 
-/* Only current can touch trace_recursion */
-#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
-#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
-
-/* Ring buffer has the 10 LSB bits to count */
-#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
-
-/* for function tracing recursion */
-#define TRACE_INTERNAL_BIT		(1<<11)
-#define TRACE_GLOBAL_BIT		(1<<12)
-
-#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
-#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
-#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
-
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e8d6bb5..a7d2a4c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -227,7 +227,7 @@ int __trace_graph_entry(struct trace_array *tr,
 
 static inline int ftrace_graph_ignore_irqs(void)
 {
-	if (!ftrace_graph_skip_irqs)
+	if (!ftrace_graph_skip_irqs || trace_recursion_test(TRACE_IRQ_BIT))
 		return 0;
 
 	return in_irq();
-- 
1.7.5.4


