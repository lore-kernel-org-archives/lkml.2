Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab1LICnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:43:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1LICnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:43:40 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=kPMIJa2Y4FBXagioLX4A:9 a=kP2SlmD6ykdw1Q81Ot0A:7 a=QEXdDO2ut3YA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1323373012.30977.123.camel@frodo>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 21:43:36 -0500
Message-ID: <1323398616.30977.167.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 14:36 -0500, Steven Rostedt wrote:

> I'm not sure how to handle this case. We could do something similar in
> the break point code to handle the same thing. But this just seems
> really ugly.
> 
> Anyone with any better ideas?

On IRC, Peter Zijlstra mentioned changing the IDT in NMI. I'm not sure
if he was joking or not. But I decided to try it out. It seems to
work :)


What's nice is that this change is in the C code, which makes things
much easier.

I check on nmi entry, if the nmi preempted code running with the debug
stack. If it has, then I load a special "nmi_idt_table" that has a zero
IST for the debug stack, which will make the debug interrupt in the NMI
not change the stack pointer. Then on exit, it returns it to the old IDT
table.

Just to see how bad this was, I made it make the change on every NMI. I
didn't notice any difference, but I wasn't doing any real benchmark,
except doing a perf top -c 1000.

But in practice, it should seldom hit, if ever. It only updates the IDT
if it interrupted debug processing.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
index aa003b1..11a86d5 100644
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
+		addr > (__get_cpu_var(debug_stack_addr) - 4096);
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
+			if (v == DEBUG_STACK)
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
index b9c8628..d35f554 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -407,13 +407,29 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	int update_debug_stack = 0;
+
 	nmi_enter();
 
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
+	
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	if (unlikely(update_debug_stack))
+		reset_debug_stack();
+
 	nmi_exit();
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..906a02a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -723,4 +723,9 @@ void __init trap_init(void)
 	cpu_init();
 
 	x86_init.irqs.trap_init();
+
+#ifdef CONFIG_X86_64
+	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	set_nmi_gate(1, &debug);
+#endif
 }


