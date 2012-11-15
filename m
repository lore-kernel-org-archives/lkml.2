Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768277Ab2KOPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:33:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767939Ab2KOPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:38 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LKbzp2Afl1gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZOIXb3-SFrwA:10 a=20KFwNOVAAAA:8 a=_yoRtwRrdxoPMFm6YYwA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153335.645592960@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/8][RFC] ftrace: Use only the preempt version of function tracing
References: <20121115153036.550942394@goodmis.org>
Content-Disposition: inline; filename=0007-ftrace-Use-only-the-preempt-version-of-function-trac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracer had two different versions of function tracing.

The disabling of irqs version and the preempt disable version.

As function tracing in very intrusive and can cause nasty recursion
issues, it has its own recursion protection. But the old method to
do this was a flat layer. If it detected that a recursion was happening
then it would just return without recording.

This made the preempt version (much faster than the irq disabling one)
not very useful, because if an interrupt were to occur after the
recursion flag was set, the interrupt would not be traced at all,
because every function that was traced would think it recursed on
itself (due to the context it preempted setting the recursive flag).

Now that we have a recursion flag for every context level, we
no longer need to worry about that. We can disable preemption,
set the current context recursion check bit, and go on. If an
interrupt were to come along, it would check its own context bit
and happily continue to trace.

As the preempt version is faster than the irq disable version,
there's no more reason to keep the preempt version around.
And the irq disable version still had an issue with missing
out on tracing NMI code.

Remove the irq disable function tracer version and have the
preempt disable version be the default (and only version).

Before this patch we had from running:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 12.028
Time: 11.945
Time: 11.925
Time: 11.964
Time: 12.002
Time: 11.910
Time: 11.944
Time: 11.929
Time: 11.941
Time: 11.924

(average: 11.9512)

Now we have:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 10.285
Time: 10.407
Time: 10.243
Time: 10.372
Time: 10.380
Time: 10.198
Time: 10.272
Time: 10.354
Time: 10.248
Time: 10.253

(average: 10.3012)

 a 13.8% savings!

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |   61 +++++++++-------------------------------
 1 file changed, 14 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index bb227e3..1621f45 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -47,34 +47,6 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(tr);
 }
 
-static void
-function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op, struct pt_regs *pt_regs)
-{
-	struct trace_array *tr = func_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-	int pc;
-
-	if (unlikely(!ftrace_function_enabled))
-		return;
-
-	pc = preempt_count();
-	preempt_disable_notrace();
-	local_save_flags(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1))
-		trace_function(tr, ip, parent_ip, flags, pc);
-
-	atomic_dec(&data->disabled);
-	preempt_enable_notrace();
-}
-
 /* Our option */
 enum {
 	TRACE_FUNC_OPT_STACK	= 0x1,
@@ -85,34 +57,34 @@ static struct tracer_flags func_flags;
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip,
 		    struct ftrace_ops *op, struct pt_regs *pt_regs)
-
 {
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
+	unsigned int bit;
 	int cpu;
 	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
 		return;
 
-	/*
-	 * Need to use raw, since this must be called before the
-	 * recursive protection is performed.
-	 */
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
+	pc = preempt_count();
+	preempt_disable_notrace();
 
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
+	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	if (bit < 0)
+		goto out;
+
+	cpu = smp_processor_id();
+	data = tr->data[cpu];
+	if (!atomic_read(&data->disabled)) {
+		local_save_flags(flags);
 		trace_function(tr, ip, parent_ip, flags, pc);
 	}
+	trace_clear_recursion(bit);
 
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+ out:
+	preempt_enable_notrace();
 }
 
 static void
@@ -185,11 +157,6 @@ static void tracing_start_function_trace(void)
 {
 	ftrace_function_enabled = 0;
 
-	if (trace_flags & TRACE_ITER_PREEMPTONLY)
-		trace_ops.func = function_trace_call_preempt_only;
-	else
-		trace_ops.func = function_trace_call;
-
 	if (func_flags.val & TRACE_FUNC_OPT_STACK)
 		register_ftrace_function(&trace_stack_ops);
 	else
-- 
1.7.10.4


