Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1G2Bmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:42:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1G2Bmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:42:52 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Iul_llewWiMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=DCZZivdHKvpnAhJn2GoA:9 a=kvnfC0mMpJ_CQvjRA30A:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110729014249.004019468@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Jul 2011 21:42:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/5] x86: Clean up dumpstack_64.c code
References: <20110729014215.328710900@goodmis.org>
Content-Disposition: inline; filename=0005-x86-Clean-up-dumpstack_64.c-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The dump_trace() function in dumpstack_64.c is hard to follow.
The test for exception stack is processed differently than the
test for irq stack, and the normal stack is outside completely.

By restructuring this code to have all the stacks determined by
a single function that returns an enum of the following:

 STACK_IS_NORMAL
 STACK_IS_EXCEPTION
 STACK_IS_IRQ
 STACK_IS_UNKNOWN

and has the logic of each within a switch statement.
This should make the code much easier to read and understand.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/dumpstack_64.c |  121 ++++++++++++++++++++++++++++------------
 1 files changed, 85 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index e71c98d..d0b2ace 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -132,6 +132,45 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
 	return bp;
 }
 
+static const unsigned long irq_stack_size =
+	(IRQ_STACK_SIZE - 64) / sizeof(unsigned long);
+
+enum stack_type {
+	STACK_IS_UNKNOWN,
+	STACK_IS_NORMAL,
+	STACK_IS_EXCEPTION,
+	STACK_IS_IRQ,
+};
+
+static enum stack_type
+analyze_stack(int cpu, struct task_struct *task,
+	      unsigned long *stack, unsigned long **stack_end, char **id)
+{
+	unsigned long *irq_stack;
+	unsigned long addr;
+	unsigned used = 0;
+
+	addr = ((unsigned long)stack & (~(THREAD_SIZE - 1)));
+	if ((unsigned long)task_stack_page(task) == addr)
+		return STACK_IS_NORMAL;
+
+	*stack_end = in_exception_stack(cpu, (unsigned long)stack,
+					 &used, id);
+	if (*stack_end)
+		return STACK_IS_EXCEPTION;
+
+	*stack_end = (unsigned long *)per_cpu(irq_stack_ptr, cpu);
+	if (!*stack_end)
+		return STACK_IS_UNKNOWN;
+
+	irq_stack = *stack_end - irq_stack_size;
+
+	if (in_irq_stack(stack, irq_stack, *stack_end))
+		return STACK_IS_IRQ;
+
+	return STACK_IS_UNKNOWN;
+}
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -144,12 +183,11 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irq_stack_end =
-		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
-	unsigned used = 0;
 	struct thread_info *tinfo;
-	int graph = 0;
+	unsigned long *irq_stack;
 	unsigned long dummy;
+	int graph = 0;
+	int done = 0;
 
 	if (!task)
 		task = current;
@@ -168,51 +206,62 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * exceptions
 	 */
 	tinfo = task_thread_info(task);
-	for (;;) {
+	while (!done) {
+		unsigned long *stack_end;
+		enum stack_type stype;
 		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
 
-		if (estack_end) {
+		stype = analyze_stack(cpu, task, stack, &stack_end, &id);
+
+		/* Default finish unless specified to continue */
+		done = 1;
+
+		switch (stype) {
+
+		/* Break out early if we are on the thread stack */
+		case STACK_IS_NORMAL:
+			break;
+
+		case STACK_IS_EXCEPTION:
+
 			if (ops->stack(data, id) < 0)
 				break;
 
 			bp = ops->walk_stack(tinfo, stack, bp, ops,
-					     data, estack_end, &graph);
+					     data, stack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
 			 * second-to-last pointer (index -2 to end) in the
 			 * exception stack:
 			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
-		if (irq_stack_end) {
-			unsigned long *irq_stack;
-			irq_stack = irq_stack_end -
-				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
-
-			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
-				if (ops->stack(data, "IRQ") < 0)
-					break;
-				bp = ops->walk_stack(tinfo, stack, bp,
-					ops, data, irq_stack_end, &graph);
-				/*
-				 * We link to the next stack (which would be
-				 * the process stack normally) the last
-				 * pointer (index -1 to end) in the IRQ stack:
-				 */
-				stack = (unsigned long *) (irq_stack_end[-1]);
-				bp = fixup_bp_irq_link(bp, stack, irq_stack,
-						       irq_stack_end);
-				irq_stack_end = NULL;
-				ops->stack(data, "EOI");
-				continue;
-			}
+			stack = (unsigned long *) stack_end[-2];
+			done = 0;
+			break;
+
+		case STACK_IS_IRQ:
+
+			if (ops->stack(data, "IRQ") < 0)
+				break;
+			bp = ops->walk_stack(tinfo, stack, bp,
+				     ops, data, stack_end, &graph);
+			/*
+			 * We link to the next stack (which would be
+			 * the process stack normally) the last
+			 * pointer (index -1 to end) in the IRQ stack:
+			 */
+			stack = (unsigned long *) (stack_end[-1]);
+			irq_stack = stack_end - irq_stack_size;
+			bp = fixup_bp_irq_link(bp, stack, irq_stack,
+					       stack_end);
+			ops->stack(data, "EOI");
+			done = 0;
+			break;
+
+		case STACK_IS_UNKNOWN:
+			ops->stack(data, "UNK");
+			break;
 		}
-		break;
 	}
 
 	/*
-- 
1.7.5.4


