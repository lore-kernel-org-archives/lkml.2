Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0JRUcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:32:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab0JRUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:32:51 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=F64z7ntu6zgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=E1fLRRr-8lSgszxbwL4A:9 a=Ntzz73yqo5asG-h2dFkA:7 a=cLF3sbcMkWqe400Z8tF_sGwIUF4A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101018203248.883779817@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 18 Oct 2010 16:29:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/7] tracing: Use one prologue for the preempt irqs off tracer function tracers
References: <20101018202939.828061748@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Use-one-prologue-for-the-preempt-irqs-off-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The preempt and irqsoff tracers have three types of function tracers.
Normal function tracer, function graph entry, and function graph return.
Each of these use a complex dance to prevent recursion and whether
to trace the data or not (depending if interrupts are enabled or not).

This patch moves the duplicate code into a single routine, to
prevent future mistakes with modifying duplicate complex code.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c |   96 +++++++++++++++++++++---------------------
 1 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 4047e98..5cf8c60 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -87,14 +87,22 @@ static __cacheline_aligned_in_smp	unsigned long max_sequence;
 
 #ifdef CONFIG_FUNCTION_TRACER
 /*
- * irqsoff uses its own tracer function to keep the overhead down:
+ * Prologue for the preempt and irqs off function tracers.
+ *
+ * Returns 1 if it is OK to continue, and data->disabled is
+ *            incremented.
+ *         0 if the trace is to be ignored, and data->disabled
+ *            is kept the same.
+ *
+ * Note, this function is also used outside this ifdef but
+ *  inside the #ifdef of the function graph tracer below.
+ *  This is OK, since the function graph tracer is
+ *  dependent on the function tracer.
  */
-static void
-irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
+static int func_prolog_dec(struct trace_array *tr,
+			   struct trace_array_cpu **data,
+			   unsigned long *flags)
 {
-	struct trace_array *tr = irqsoff_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
 	long disabled;
 	int cpu;
 
@@ -106,18 +114,38 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 	 */
 	cpu = raw_smp_processor_id();
 	if (likely(!per_cpu(tracing_cpu, cpu)))
-		return;
+		return 0;
 
-	local_save_flags(flags);
+	local_save_flags(*flags);
 	/* slight chance to get a false positive on tracing_cpu */
-	if (!irqs_disabled_flags(flags))
-		return;
+	if (!irqs_disabled_flags(*flags))
+		return 0;
 
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
+	*data = tr->data[cpu];
+	disabled = atomic_inc_return(&(*data)->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, ip, parent_ip, flags, preempt_count());
+		return 1;
+
+	atomic_dec(&(*data)->disabled);
+
+	return 0;
+}
+
+/*
+ * irqsoff uses its own tracer function to keep the overhead down:
+ */
+static void
+irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+
+	if (!func_prolog_dec(tr, &data, &flags))
+		return;
+
+	trace_function(tr, ip, parent_ip, flags, preempt_count());
 
 	atomic_dec(&data->disabled);
 }
@@ -155,30 +183,16 @@ static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
 	struct trace_array *tr = irqsoff_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
 	int ret;
-	int cpu;
 	int pc;
 
-	cpu = raw_smp_processor_id();
-	if (likely(!per_cpu(tracing_cpu, cpu)))
-		return 0;
-
-	local_save_flags(flags);
-	/* slight chance to get a false positive on tracing_cpu */
-	if (!irqs_disabled_flags(flags))
+	if (!func_prolog_dec(tr, &data, &flags))
 		return 0;
 
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		ret = __trace_graph_entry(tr, trace, flags, pc);
-	} else
-		ret = 0;
-
+	pc = preempt_count();
+	ret = __trace_graph_entry(tr, trace, flags, pc);
 	atomic_dec(&data->disabled);
+
 	return ret;
 }
 
@@ -187,27 +201,13 @@ static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
 	struct trace_array *tr = irqsoff_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu;
 	int pc;
 
-	cpu = raw_smp_processor_id();
-	if (likely(!per_cpu(tracing_cpu, cpu)))
-		return;
-
-	local_save_flags(flags);
-	/* slight chance to get a false positive on tracing_cpu */
-	if (!irqs_disabled_flags(flags))
+	if (!func_prolog_dec(tr, &data, &flags))
 		return;
 
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		__trace_graph_return(tr, trace, flags, pc);
-	}
-
+	pc = preempt_count();
+	__trace_graph_return(tr, trace, flags, pc);
 	atomic_dec(&data->disabled);
 }
 
-- 
1.7.1


