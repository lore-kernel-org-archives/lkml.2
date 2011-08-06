Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1HFBYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:24:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1HFBX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:23:56 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=2zumk5v5GeQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=yIInSuBJH12f6DEwNl0A:9 a=oC24eD0SwLC75eGE8rAA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110806012353.891757693@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 21:11:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4 v2] x86: Remove previous_esp from i386 thread_info structure
References: <20110806011102.721109343@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Remove-previous_esp-from-i386-thread_info-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The i386 thread_info contains a previous_esp field that is used
to daisy chain the different stacks for dump_stack()
(ie. irq, softirq, thread stacks).

The goal is to eventual make i386 handling of thread_info the same
as x86_64, which means that the thread_info will not be in the stack
but as a per_cpu variable. We will no longer depend on thread_info
being able to daisy chain different stacks as it will only exist
in one location (the thread stack).

By moving previous_esp out of thread_info, and just placing it
above the thread_info of the current stack, we can still use
the stacks to daisy chain which stack was in use when preempted by
an interrupt.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/thread_info.h |    5 -----
 arch/x86/kernel/dumpstack_32.c     |   10 +++++++++-
 arch/x86/kernel/irq_32.c           |   13 +++++++++----
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 625910f..8f2b249 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -34,11 +34,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
-#ifdef CONFIG_X86_32
-	unsigned long           previous_esp;   /* ESP of the previous stack in
-						   case of nested (IRQ) stacks
-						*/
-#endif
 	int			uaccess_err;
 };
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 3b97a80..8955e25 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -22,6 +22,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
+	u32 *prev_esp;
 
 	if (!task)
 		task = current;
@@ -44,9 +45,16 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
 		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
 
-		stack = (unsigned long *)context->previous_esp;
+		/* Stop if not on irq stack */
+		if (task_stack_page(task) == context)
+			break;
+
+		/* The previous esp is just above the context */
+		prev_esp = (u32 *) ((char *)context + sizeof(struct thread_info));
+		stack = (unsigned long *)*prev_esp;
 		if (!stack)
 			break;
+
 		if (ops->stack(data, "IRQ") < 0)
 			break;
 		touch_nmi_watchdog();
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 7209070..47909a0 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -76,7 +76,7 @@ static inline int
 execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 {
 	union irq_ctx *curctx, *irqctx;
-	u32 *isp, arg1, arg2;
+	u32 *isp, *prev_esp, arg1, arg2;
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = __this_cpu_read(hardirq_ctx);
@@ -93,7 +93,9 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	/* build the stack frame on the IRQ stack */
 	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 	irqctx->tinfo.task = curctx->tinfo.task;
-	irqctx->tinfo.previous_esp = current_stack_pointer;
+	/* Save the next esp after thread_info */
+	prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+	*prev_esp = current_stack_pointer;
 
 	/*
 	 * Copy the softirq bits in preempt_count so that the
@@ -154,7 +156,7 @@ asmlinkage void do_softirq(void)
 	unsigned long flags;
 	struct thread_info *curctx;
 	union irq_ctx *irqctx;
-	u32 *isp;
+	u32 *isp, *prev_esp;
 
 	if (in_interrupt())
 		return;
@@ -165,11 +167,14 @@ asmlinkage void do_softirq(void)
 		curctx = current_thread_info();
 		irqctx = __this_cpu_read(softirq_ctx);
 		irqctx->tinfo.task = curctx->task;
-		irqctx->tinfo.previous_esp = current_stack_pointer;
 
 		/* build the stack frame on the softirq stack */
 		isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 
+		/* Push the previous esp onto the stack */
+		prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+		*prev_esp = current_stack_pointer;
+
 		call_on_stack(__do_softirq, isp);
 		/*
 		 * Shouldn't happen, we returned above if in_interrupt():
-- 
1.7.5.4


