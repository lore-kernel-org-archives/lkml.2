Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab0JRUdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:33:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab0JRUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:32:53 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=G3gMwwb3HCUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=yWAYrdlXemoUrjiyPAoA:9 a=U1-_up0tvmmwJjq2ybMA:7 a=ryzZMSMp_l4gDRvsHw4qb3MJ4SkA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101018203248.558785656@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 18 Oct 2010 16:29:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/7] tracing: Use one prologue for the wakeup tracer function tracers
References: <20101018202939.828061748@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Use-one-prologue-for-the-wakeup-tracer-funct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The wakeup tracer has three types of function tracers. Normal
function tracer, function graph entry, and function graph return.
Each of these use a complex dance to prevent recursion and whether
to trace the data or not (depending on the wake_task variable).

This patch moves the duplicate code into a single routine, to
prevent future mistakes with modifying duplicate complex code.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_wakeup.c |  102 ++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 033510d..31689d2 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -56,43 +56,73 @@ static struct tracer_flags tracer_flags = {
 #define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
 
 #ifdef CONFIG_FUNCTION_TRACER
+
 /*
- * wakeup uses its own tracer function to keep the overhead down:
+ * Prologue for the wakeup function tracers.
+ *
+ * Returns 1 if it is OK to continue, and preemption
+ *            is disabled and data->disabled is incremented.
+ *         0 if the trace is to be ignored, and preemption
+ *            is not disabled and data->disabled is
+ *            kept the same.
+ *
+ * Note, this function is also used outside this ifdef but
+ *  inside the #ifdef of the function graph tracer below.
+ *  This is OK, since the function graph tracer is
+ *  dependent on the function tracer.
  */
-static void
-wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
+static int
+func_prolog_preempt_disable(struct trace_array *tr,
+			    struct trace_array_cpu **data,
+			    int *pc)
 {
-	struct trace_array *tr = wakeup_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
 	long disabled;
 	int cpu;
-	int pc;
 
 	if (likely(!wakeup_task))
-		return;
+		return 0;
 
-	pc = preempt_count();
+	*pc = preempt_count();
 	preempt_disable_notrace();
 
 	cpu = raw_smp_processor_id();
 	if (cpu != wakeup_current_cpu)
 		goto out_enable;
 
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
+	*data = tr->data[cpu];
+	disabled = atomic_inc_return(&(*data)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
-	local_irq_save(flags);
+	return 1;
 
-	trace_function(tr, ip, parent_ip, flags, pc);
+out:
+	atomic_dec(&(*data)->disabled);
+
+out_enable:
+	preempt_enable_notrace();
+	return 0;
+}
+
+/*
+ * wakeup uses its own tracer function to keep the overhead down:
+ */
+static void
+wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	int pc;
+
+	if (!func_prolog_preempt_disable(tr, &data, &pc))
+		return;
 
+	local_irq_save(flags);
+	trace_function(tr, ip, parent_ip, flags, pc);
 	local_irq_restore(flags);
 
- out:
 	atomic_dec(&data->disabled);
- out_enable:
 	preempt_enable_notrace();
 }
 
@@ -154,32 +184,16 @@ static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
 	struct trace_array *tr = wakeup_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu, pc, ret = 0;
+	int pc, ret = 0;
 
-	if (likely(!wakeup_task))
+	if (!func_prolog_preempt_disable(tr, &data, &pc))
 		return 0;
 
-	pc = preempt_count();
-	preempt_disable_notrace();
-
-	cpu = raw_smp_processor_id();
-	if (cpu != wakeup_current_cpu)
-		goto out_enable;
-
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (unlikely(disabled != 1))
-		goto out;
-
 	local_save_flags(flags);
 	ret = __trace_graph_entry(tr, trace, flags, pc);
-
-out:
 	atomic_dec(&data->disabled);
-
-out_enable:
 	preempt_enable_notrace();
+
 	return ret;
 }
 
@@ -188,31 +202,15 @@ static void wakeup_graph_return(struct ftrace_graph_ret *trace)
 	struct trace_array *tr = wakeup_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu, pc;
+	int pc;
 
-	if (likely(!wakeup_task))
+	if (!func_prolog_preempt_disable(tr, &data, &pc))
 		return;
 
-	pc = preempt_count();
-	preempt_disable_notrace();
-
-	cpu = raw_smp_processor_id();
-	if (cpu != wakeup_current_cpu)
-		goto out_enable;
-
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (unlikely(disabled != 1))
-		goto out;
-
 	local_save_flags(flags);
 	__trace_graph_return(tr, trace, flags, pc);
-
-out:
 	atomic_dec(&data->disabled);
 
-out_enable:
 	preempt_enable_notrace();
 	return;
 }
-- 
1.7.1


