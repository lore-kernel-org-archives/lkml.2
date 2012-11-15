Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768269Ab2KOPfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:35:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423673Ab2KOPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:37 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y2s57nzHg2cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aNH6rOs39N8A:10 a=20KFwNOVAAAA:8 a=C_IRinGWAAAA:8 a=7QaoQKzyUE3Xn9JxLJcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=si9q_4b84H0A:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121115153335.186036927@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 15 Nov 2012 10:30:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/8][RFC] ftrace: Add context level recursion bit checking
References: <20121115153036.550942394@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Add-context-level-recursion-bit-checking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently for recursion checking in the function tracer, ftrace
tests a task_struct bit to determine if the function tracer had
recursed or not. If it has, then it will will return without going
further.

But this leads to races. If an interrupt came in after the bit
was set, the functions being traced would see that bit set and
think that the function tracer recursed on itself, and would return.

Instead add a bit for each context (normal, softirq, irq and nmi).

A check of which context the task is in is made before testing the
associated bit. Now if an interrupt preempts the function tracer
after the previous context has been set, the interrupt functions
can still be traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   40 +++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.h  |   12 +++++++++---
 2 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd6cd3c..fbf25e7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -156,14 +156,27 @@ static void
 ftrace_global_list_func(unsigned long ip, unsigned long parent_ip,
 			struct ftrace_ops *op, struct pt_regs *regs)
 {
-	if (unlikely(trace_recursion_test(TRACE_GLOBAL_BIT)))
+	int bit;
+
+	if (in_interrupt()) {
+		if (in_nmi())
+			bit = TRACE_GLOBAL_NMI_BIT;
+
+		else if (in_irq())
+			bit = TRACE_GLOBAL_IRQ_BIT;
+		else
+			bit = TRACE_GLOBAL_SIRQ_BIT;
+	} else
+		bit = TRACE_GLOBAL_BIT;
+
+	if (unlikely(trace_recursion_test(bit)))
 		return;
 
-	trace_recursion_set(TRACE_GLOBAL_BIT);
+	trace_recursion_set(bit);
 	do_for_each_ftrace_op(op, ftrace_global_list) {
 		op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
-	trace_recursion_clear(TRACE_GLOBAL_BIT);
+	trace_recursion_clear(bit);
 }
 
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
@@ -4132,14 +4145,27 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 		       struct ftrace_ops *ignored, struct pt_regs *regs)
 {
 	struct ftrace_ops *op;
+	unsigned int bit;
 
 	if (function_trace_stop)
 		return;
 
-	if (unlikely(trace_recursion_test(TRACE_INTERNAL_BIT)))
-		return;
+	if (in_interrupt()) {
+		if (in_nmi())
+			bit = TRACE_INTERNAL_NMI_BIT;
+
+		else if (in_irq())
+			bit = TRACE_INTERNAL_IRQ_BIT;
+		else
+			bit = TRACE_INTERNAL_SIRQ_BIT;
+	} else
+		bit = TRACE_INTERNAL_BIT;
+
+	if (unlikely(trace_recursion_test(bit)))
+			return;
+
+	trace_recursion_set(bit);
 
-	trace_recursion_set(TRACE_INTERNAL_BIT);
 	/*
 	 * Some of the ops may be dynamically allocated,
 	 * they must be freed after a synchronize_sched().
@@ -4150,7 +4176,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();
-	trace_recursion_clear(TRACE_INTERNAL_BIT);
+	trace_recursion_clear(bit);
 }
 
 /*
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c75d798..fe6ccff 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -299,8 +299,14 @@ struct tracer {
 
 /* for function tracing recursion */
 #define TRACE_INTERNAL_BIT		(1<<11)
-#define TRACE_GLOBAL_BIT		(1<<12)
-#define TRACE_CONTROL_BIT		(1<<13)
+#define TRACE_INTERNAL_NMI_BIT		(1<<12)
+#define TRACE_INTERNAL_IRQ_BIT		(1<<13)
+#define TRACE_INTERNAL_SIRQ_BIT		(1<<14)
+#define TRACE_GLOBAL_BIT		(1<<15)
+#define TRACE_GLOBAL_NMI_BIT		(1<<16)
+#define TRACE_GLOBAL_IRQ_BIT		(1<<17)
+#define TRACE_GLOBAL_SIRQ_BIT		(1<<18)
+#define TRACE_CONTROL_BIT		(1<<19)
 
 /*
  * Abuse of the trace_recursion.
@@ -309,7 +315,7 @@ struct tracer {
  * was called in irq context but we have irq tracing off. Since this
  * can only be modified by current, we can reuse trace_recursion.
  */
-#define TRACE_IRQ_BIT			(1<<13)
+#define TRACE_IRQ_BIT			(1<<20)
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
 #define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
-- 
1.7.10.4


