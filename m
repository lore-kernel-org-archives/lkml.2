Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1LNCxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:53:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab1LNCwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:52:55 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Ncku1LITv_IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=nVI_mnzzUJ0xBcMVdE8A:9 a=2R4oPsScBZbIOtX69w8A:7 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111214025252.684160446@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 21:52:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 4/5 v2] x86: Keep current stack in NMI breakpoints
References: <20111214025237.457632996@goodmis.org>
Content-Disposition: inline; filename=0004-x86-Keep-current-stack-in-NMI-breakpoints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

We want to allow NMI handlers to have breakpoints to be able to
remove stop_machine from ftrace, kprobes and jump_labels. But if
an NMI interrupts a current breakpoint, and then it triggers a
breakpoint itself, it will switch to the breakpoint stack and
corrupt the data on it for the breakpoint processing that it
interrupted.

Instead, have the NMI check if it interrupted breakpoint processing
by checking if the stack that is currently used is a breakpoint
stack. If it is, then load a special IDT that changes the IST
for the debug exception to keep the same stack in kernel context.
When the NMI is done, it puts it back.

This way, if the NMI does trigger a breakpoint, it will keep
using the same stack and not stomp on the breakpoint data for
the breakpoint it interrupted.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/desc.h      |   12 ++++++++++++
 arch/x86/include/asm/processor.h |    6 ++++++
 arch/x86/kernel/cpu/common.c     |   22 ++++++++++++++++++++++
 arch/x86/kernel/head_64.S        |    4 ++++
 arch/x86/kernel/nmi.c            |   15 +++++++++++++++
 arch/x86/kernel/traps.c          |    6 ++++++
 6 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 41935fa..e95822d 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -35,6 +35,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
+extern struct desc_ptr nmi_idt_descr;
+extern gate_desc nmi_idt_table[];
 
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -307,6 +309,16 @@ static inline void set_desc_limit(struct desc_struct *desc, unsigned long limit)
 	desc->limit = (limit >> 16) & 0xf;
 }
 
+#ifdef CONFIG_X86_64
+static inline void set_nmi_gate(int gate, void *addr)
+{
+	gate_desc s;
+
+	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
+	write_idt_entry(nmi_idt_table, gate, &s);
+}
+#endif
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b650435..d748d1f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,6 +402,9 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+int is_debug_stack(unsigned long addr);
+void zero_debug_stack(void);
+void reset_debug_stack(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -416,6 +419,9 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
+static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void zero_debug_stack(void) { }
+static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
 
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..98faeff 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,6 +1026,8 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
+struct desc_ptr nmi_idt_descr = { NR_VECTORS * 16 - 1,
+				    (unsigned long) nmi_idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
@@ -1090,6 +1092,24 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
+static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+
+int is_debug_stack(unsigned long addr)
+{
+	return addr <= __get_cpu_var(debug_stack_addr) &&
+		addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ);
+}
+
+void zero_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&nmi_idt_descr);
+}
+
+void reset_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&idt_descr);
+}
+
 #else	/* CONFIG_X86_64 */
 
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
@@ -1208,6 +1228,8 @@ void __cpuinit cpu_init(void)
 			estacks += exception_stack_sizes[v];
 			oist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
+			if (v == DEBUG_STACK - 1)
+				per_cpu(debug_stack_addr, cpu) = (unsigned long)estacks;
 		}
 	}
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e11e394..40f4eb3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -417,6 +417,10 @@ ENTRY(phys_base)
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
+	.align L1_CACHE_BYTES
+ENTRY(nmi_idt_table)
+	.skip IDT_ENTRIES * 16
+
 	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index b9c8628..fb86773 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -407,6 +407,18 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	int update_debug_stack = 0;
+
+	/*
+	 * If we interrupted a breakpoint, it is possible that
+	 * the nmi handler will have breakpoints too. We need to
+	 * change the IDT such that breakpoints that happen here
+	 * continue to use the NMI stack.
+	 */
+	if (unlikely(is_debug_stack(regs->sp))) {
+		zero_debug_stack();
+		update_debug_stack = 1;
+	}
 	nmi_enter();
 
 	inc_irq_stat(__nmi_count);
@@ -415,6 +427,9 @@ do_nmi(struct pt_regs *regs, long error_code)
 		default_do_nmi(regs);
 
 	nmi_exit();
+
+	if (unlikely(update_debug_stack))
+		reset_debug_stack();
 }
 
 void stop_nmi(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..a93c5ca 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -723,4 +723,10 @@ void __init trap_init(void)
 	cpu_init();
 
 	x86_init.irqs.trap_init();
+
+#ifdef CONFIG_X86_64
+	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	set_nmi_gate(1, &debug);
+	set_nmi_gate(3, &int3);
+#endif
 }
-- 
1.7.7.3


