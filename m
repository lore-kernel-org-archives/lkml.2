Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1G2BoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:44:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1G2Bmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:42:51 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=XuuYMVbNEwQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=6aAxk7X2Wy-M-NEywecA:9 a=WI-pCOByDRdEK7GO1m4A:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=_08l64Je9isDmirY:21 a=g_mu2mGJLcAcaR_E:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110729014248.673567571@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Jul 2011 21:42:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/5] x86: Keep thread_info on thread stack in x86_32
References: <20110729014215.328710900@goodmis.org>
Content-Disposition: inline; filename=0004-x86-Keep-thread_info-on-thread-stack-in-x86_32.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

x86_64 uses a per_cpu variable kernel_stack to always point to
the thread stack of current. This is where the thread_info is stored
and is accessed from this location even when the irq or exception stack
is in use. This removes the complexity of having to maintain the
thread info on the stack when interrupts are running and having to
copy the preempt_count and other fields to the interrupt stack.

x86_32 uses the old method of copying the thread_info from the thread
stack to the exception stack just before executing the exception.

Having the two different requires #ifdefs and also the x86_32 way
is a bit of a pain to maintain. By converting x86_32 to the same
method of x86_64, we can remove #ifdefs, clean up the x86_32 code
a little, and remove the overhead of the copy.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/processor.h   |    9 ++++
 arch/x86/include/asm/thread_info.h |   50 ++++------------------
 arch/x86/kernel/cpu/common.c       |    8 ++--
 arch/x86/kernel/dumpstack_32.c     |   40 +++++++++++++++---
 arch/x86/kernel/irq_32.c           |   81 ++++++++++++++----------------------
 arch/x86/kernel/process_32.c       |    4 ++
 arch/x86/kernel/smpboot.c          |    2 +-
 7 files changed, 93 insertions(+), 101 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2193715..1d01248 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -414,6 +414,15 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
+/*
+ * per-CPU IRQ handling stacks
+ */
+struct irq_stack {
+	u32                     stack[THREAD_SIZE/sizeof(u32)];
+} __attribute__((aligned(THREAD_SIZE)));
+
+DECLARE_PER_CPU(struct irq_stack *, hardirq_stack);
+DECLARE_PER_CPU(struct irq_stack *, softirq_stack);
 #endif	/* X86_64 */
 
 extern unsigned int xstate_size;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8f2b249..2424077 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -164,9 +164,11 @@ struct thread_info {
 	ret;								\
 })
 
-#ifdef CONFIG_X86_32
+#include <asm/percpu.h>
+
+#define STACK_WARN		(THREAD_SIZE/8)
+#define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
 
-#define STACK_WARN	(THREAD_SIZE/8)
 /*
  * macros/functions for gaining access to the thread information structure
  *
@@ -174,40 +176,6 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-
-/* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __used;
-
-/* how to get the thread information struct from C */
-static inline struct thread_info *current_thread_info(void)
-{
-	return (struct thread_info *)
-		(current_stack_pointer & ~(THREAD_SIZE - 1));
-}
-
-#else /* !__ASSEMBLY__ */
-
-/* how to get the thread information struct from ASM */
-#define GET_THREAD_INFO(reg)	 \
-	movl $-THREAD_SIZE, reg; \
-	andl %esp, reg
-
-/* use this one if reg already contains %esp */
-#define GET_THREAD_INFO_WITH_ESP(reg) \
-	andl $-THREAD_SIZE, reg
-
-#endif
-
-#else /* X86_32 */
-
-#include <asm/percpu.h>
-#define KERNEL_STACK_OFFSET (5*8)
-
-/*
- * macros/functions for gaining access to the thread information structure
- * preempt_count needs to be 1 initially, until the scheduler is functional.
- */
-#ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned long, kernel_stack);
 
 static inline struct thread_info *current_thread_info(void)
@@ -222,12 +190,14 @@ static inline struct thread_info *current_thread_info(void)
 
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
-	movq PER_CPU_VAR(kernel_stack),reg ; \
-	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
+	_ASM_MOV PER_CPU_VAR(kernel_stack),reg ; \
+	_ASM_SUB $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg ;
 
-#endif
+/* use this one if reg already contains %esp (x86_32 only) */
+#define GET_THREAD_INFO_WITH_ESP(reg) \
+	GET_THREAD_INFO(reg)
 
-#endif /* !X86_32 */
+#endif
 
 /*
  * Thread-synchronous status.
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..b0304fb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1019,6 +1019,10 @@ static __init int setup_disablecpuid(char *arg)
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
+DEFINE_PER_CPU(unsigned long, kernel_stack) =
+	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+EXPORT_PER_CPU_SYMBOL(kernel_stack);
+
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
 
@@ -1033,10 +1037,6 @@ DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
 	&init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(unsigned long, kernel_stack) =
-	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
-EXPORT_PER_CPU_SYMBOL(kernel_stack);
-
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 8955e25..6341cdc 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -16,11 +16,33 @@
 
 #include <asm/stacktrace.h>
 
+static void *is_irq_stack(void *p, void *irq)
+{
+	if (p < irq || p >= (irq + THREAD_SIZE))
+		return NULL;
+	return irq + THREAD_SIZE;
+}
+
+
+static void *is_hardirq_stack(unsigned long *stack, int cpu)
+{
+	void *irq = per_cpu(hardirq_stack, cpu);
+
+	return is_irq_stack(stack, irq);
+}
+
+static void *is_softirq_stack(unsigned long *stack, int cpu)
+{
+	void *irq = per_cpu(softirq_stack, cpu);
+
+	return is_irq_stack(stack, irq);
+}
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
+	const unsigned cpu = get_cpu();
 	int graph = 0;
 	u32 *prev_esp;
 
@@ -40,17 +62,22 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	for (;;) {
 		struct thread_info *context;
+		void *end_stack = NULL;
+
+		end_stack = is_hardirq_stack(stack, cpu);
+		if (!end_stack)
+			end_stack = is_softirq_stack(stack, cpu);
 
-		context = (struct thread_info *)
-			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
+		context = task_thread_info(task);
+		bp = ops->walk_stack(context, stack, bp, ops, data,
+				     end_stack, &graph);
 
 		/* Stop if not on irq stack */
-		if (task_stack_page(task) == context)
+		if (!end_stack)
 			break;
 
-		/* The previous esp is just above the context */
-		prev_esp = (u32 *) ((char *)context + sizeof(struct thread_info));
+		/* The previous esp is saved on the bottom of the stack */
+		prev_esp = (u32 *)(end_stack - THREAD_SIZE);
 		stack = (unsigned long *)*prev_esp;
 		if (!stack)
 			break;
@@ -59,6 +86,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			break;
 		touch_nmi_watchdog();
 	}
+	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
 
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 47909a0..205c4f8 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -50,16 +50,8 @@ static inline int check_stack_overflow(void) { return 0; }
 static inline void print_stack_overflow(void) { }
 #endif
 
-/*
- * per-CPU IRQ handling contexts (thread information and stack)
- */
-union irq_ctx {
-	struct thread_info      tinfo;
-	u32                     stack[THREAD_SIZE/sizeof(u32)];
-} __attribute__((aligned(THREAD_SIZE)));
-
-static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
-static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
+DEFINE_PER_CPU(struct irq_stack *, hardirq_stack);
+DEFINE_PER_CPU(struct irq_stack *, softirq_stack);
 
 static void call_on_stack(void *func, void *stack)
 {
@@ -72,14 +64,22 @@ static void call_on_stack(void *func, void *stack)
 		     : "memory", "cc", "edx", "ecx", "eax");
 }
 
+/* how to get the current stack pointer from C */
+register unsigned long current_stack_pointer asm("esp") __used;
+
+static inline void *current_stack(void)
+{
+	return (void *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+}
+
 static inline int
 execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 {
-	union irq_ctx *curctx, *irqctx;
+	struct irq_stack *curstk, *irqstk;
 	u32 *isp, *prev_esp, arg1, arg2;
 
-	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = __this_cpu_read(hardirq_ctx);
+	curstk = (struct irq_stack *) current_stack();
+	irqstk = __this_cpu_read(hardirq_stack);
 
 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -87,23 +87,14 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	 * handler) we can't do that and just have to keep using the
 	 * current stack (which is the irq stack already after all)
 	 */
-	if (unlikely(curctx == irqctx))
+	if (unlikely(curstk == irqstk))
 		return 0;
 
-	/* build the stack frame on the IRQ stack */
-	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
-	irqctx->tinfo.task = curctx->tinfo.task;
-	/* Save the next esp after thread_info */
-	prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
-	*prev_esp = current_stack_pointer;
+	isp = (u32 *) ((char *)irqstk + sizeof(*irqstk));
 
-	/*
-	 * Copy the softirq bits in preempt_count so that the
-	 * softirq checks work in the hardirq context.
-	 */
-	irqctx->tinfo.preempt_count =
-		(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
-		(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
+	/* Save the next esp at the bottom of the stack */
+	prev_esp = (u32 *)irqstk;
+	*prev_esp = current_stack_pointer;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -123,39 +114,30 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
  */
 void __cpuinit irq_ctx_init(int cpu)
 {
-	union irq_ctx *irqctx;
+	struct irq_stack *irqstk;
 
-	if (per_cpu(hardirq_ctx, cpu))
+	if (per_cpu(hardirq_stack, cpu))
 		return;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+	irqstk = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
-	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
-	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
-
-	per_cpu(hardirq_ctx, cpu) = irqctx;
+	per_cpu(hardirq_stack, cpu) = irqstk;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+	irqstk = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREAD_FLAGS,
 					       THREAD_ORDER));
-	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
-	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
-
-	per_cpu(softirq_ctx, cpu) = irqctx;
+	per_cpu(softirq_stack, cpu) = irqstk;
 
 	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",
-	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
+	       cpu, per_cpu(hardirq_stack, cpu),  per_cpu(softirq_stack, cpu));
 }
 
 asmlinkage void do_softirq(void)
 {
 	unsigned long flags;
-	struct thread_info *curctx;
-	union irq_ctx *irqctx;
+	struct thread_info *curstk;
+	struct irq_stack *irqstk;
 	u32 *isp, *prev_esp;
 
 	if (in_interrupt())
@@ -164,15 +146,14 @@ asmlinkage void do_softirq(void)
 	local_irq_save(flags);
 
 	if (local_softirq_pending()) {
-		curctx = current_thread_info();
-		irqctx = __this_cpu_read(softirq_ctx);
-		irqctx->tinfo.task = curctx->task;
+		curstk = current_stack();
+		irqstk = __this_cpu_read(softirq_stack);
 
 		/* build the stack frame on the softirq stack */
-		isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
+		isp = (u32 *) ((char *)irqstk + sizeof(*irqstk));
 
 		/* Push the previous esp onto the stack */
-		prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info));
+		prev_esp = (u32 *)irqstk;
 		*prev_esp = current_stack_pointer;
 
 		call_on_stack(__do_softirq, isp);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a3d0dc5..19e1468 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -341,6 +341,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
 		set_iopl_mask(next->iopl);
 
+	percpu_write(kernel_stack,
+		  (unsigned long)task_stack_page(next_p) +
+		  THREAD_SIZE - KERNEL_STACK_OFFSET);
+
 	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9fd3137..d6518a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -715,10 +715,10 @@ do_rest:
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
+#endif
 	per_cpu(kernel_stack, cpu) =
 		(unsigned long)task_stack_page(c_idle.idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
-#endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = c_idle.idle->thread.sp;
-- 
1.7.5.4


