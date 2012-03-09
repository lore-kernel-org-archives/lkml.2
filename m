Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2CIH7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:59:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46684 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2CIH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:59:09 -0500
Date: Thu, 8 Mar 2012 23:42:02 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120309074202.GA28609@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The traps are referred to by their numbers and it can be difficult to
understand them while reading the code without context. This patch adds
enumeration of the trap numbers and replaces the numbers with the correct
enum for x86.

Signed-off-by: Kees Cook <keescook@chromium.org>

---
I've updated Aditya Kali's earlier patch:
https://lkml.org/lkml/2011/4/22/328
---
 arch/x86/include/asm/traps.h |   25 +++++++++
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  117 ++++++++++++++++++++++--------------------
 3 files changed, 88 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0012d09..768afb2 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+/* Interrupts/Exceptions */
+enum {
+	INTR_DIV_BY_ZERO = 0,	/*  0 */
+	INTR_DEBUG,		/*  1 */
+	INTR_NMI,		/*  2 */
+	INTR_BREAKPOINT,	/*  3 */
+	INTR_OVERFLOW,		/*  4 */
+	INTR_BOUNDS_CHECK,	/*  5 */
+	INTR_INVALID_OP,	/*  6 */
+	INTR_NO_DEV,		/*  7 */
+	INTR_DBL_FAULT,		/*  8 */
+	INTR_SEG_OVERRUN,	/*  9 */
+	INTR_INVALID_TSS,	/* 10 */
+	INTR_NO_SEG,		/* 11 */
+	INTR_STACK_FAULT,	/* 12 */
+	INTR_GPF,		/* 13 */
+	INTR_PAGE_FAULT,	/* 14 */
+	INTR_SPURIOUS,		/* 15 */
+	INTR_COPROCESSOR,	/* 16 */
+	INTR_ALIGNMENT,		/* 17 */
+	INTR_MCE,		/* 18 */
+	INTR_SIMD_COPROCESSOR,	/* 19 */
+	INTR_IRET = 32,		/* 32 */
+};
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 313fb5c..67471bf 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -61,7 +61,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error(get_irq_regs(), 0, 16);
+	math_error(get_irq_regs(), 0, INTR_COPROCESSOR);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..9f8d6a6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -119,7 +119,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < 6)
+		if (trapnr < INTR_INVALID_OP)
 			goto vm86_trap;
 		goto trap_signal;
 	}
@@ -203,27 +203,32 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR_INFO(INTR_DIV_BY_ZERO, SIGFPE, "divide error", divide_error,
+		FPE_INTDIV, regs->ip)
+DO_ERROR(INTR_OVERFLOW, SIGSEGV, "overflow", overflow)
+DO_ERROR(INTR_BOUNDS_CHECK, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(INTR_INVALID_OP, SIGILL, "invalid opcode", invalid_op,
+		ILL_ILLOPN, regs->ip)
+DO_ERROR(INTR_SEG_OVERRUN, SIGFPE, "coprocessor segment overrun",
+		coprocessor_segment_overrun)
+DO_ERROR(INTR_INVALID_TSS, SIGSEGV, "invalid TSS", invalid_TSS)
+DO_ERROR(INTR_NO_SEG, SIGBUS, "segment not present", segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+DO_ERROR(INTR_STACK_FAULT, SIGBUS, "stack segment", stack_segment)
 #endif
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+DO_ERROR_INFO(INTR_ALIGNMENT, SIGBUS, "alignment check", alignment_check,
+		BUS_ADRALN, 0)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
+			INTR_STACK_FAULT, SIGBUS) == NOTIFY_STOP)
 		return;
 	preempt_conditional_sti(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	do_trap(INTR_STACK_FAULT, SIGBUS, "stack segment", regs, error_code,
+			NULL);
 	preempt_conditional_cli(regs);
 }
 
@@ -233,10 +238,10 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk = current;
 
 	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+	notify_die(DIE_TRAP, str, regs, error_code, INTR_DBL_FAULT, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
+	tsk->thread.trap_no = INTR_DBL_FAULT;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -264,7 +269,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_no = INTR_GPF;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -291,9 +296,9 @@ gp_in_kernel:
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_no = INTR_GPF;
 	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
+				error_code, INTR_GPF, SIGSEGV) == NOTIFY_STOP)
 		return;
 	die("general protection fault", regs, error_code);
 }
@@ -302,13 +307,13 @@ gp_in_kernel:
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
-	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, INTR_BREAKPOINT,
+				SIGTRAP) == NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (notify_die(DIE_INT3, "int3", regs, error_code, INTR_BREAKPOINT,
+				SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/*
@@ -317,7 +322,7 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	 */
 	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	do_trap(INTR_BREAKPOINT, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 }
@@ -423,7 +428,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
-				error_code, 1);
+				error_code, INTR_DEBUG);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
 		return;
@@ -453,14 +458,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
- * IRQ13 behaviour
+ * INTR_GPF behaviour
  */
 void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
 	struct task_struct *task = current;
 	siginfo_t info;
 	unsigned short err;
-	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+	char *str = (trapnr == INTR_COPROCESSOR) ? "fpu exception" :
+						"simd exception";
 
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
 		return;
@@ -485,7 +491,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_addr = (void __user *)regs->ip;
-	if (trapnr == 16) {
+	if (trapnr == INTR_COPROCESSOR) {
 		unsigned short cwd, swd;
 		/*
 		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
@@ -529,8 +535,9 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 		info.si_code = FPE_FLTRES;
 	} else {
 		/*
-		 * If we're using IRQ 13, or supposedly even some trap 16
-		 * implementations, it's possible we get a spurious trap...
+		 * If we're using INTR_GPF, or supposedly even some trap
+		 * INTR_COPROCESSOR implementations, it's possible we get a
+		 * spurious trap...
 		 */
 		return;		/* Spurious trap, no error */
 	}
@@ -543,13 +550,13 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 	ignore_fpu_irq = 1;
 #endif
 
-	math_error(regs, error_code, 16);
+	math_error(regs, error_code, INTR_COPROCESSOR);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	math_error(regs, error_code, 19);
+	math_error(regs, error_code, INTR_SIMD_COPROCESSOR);
 }
 
 dotraplinkage void
@@ -574,7 +581,7 @@ asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
  * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
- * Careful.. There are problems with IBM-designed IRQ13 behaviour.
+ * Careful.. There are problems with IBM-designed INTR_GPF behaviour.
  * Don't touch unless you *really* know how it works.
  *
  * Must be called with kernel preemption disabled (eg with local
@@ -646,17 +653,17 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_TRAP, "iret exception",
 			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
 		return;
-	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+	do_trap(INTR_IRET, SIGILL, "iret exception", regs, error_code, &info);
 }
 #endif
 
 /* Set of traps needed for early debugging. */
 void __init early_trap_init(void)
 {
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(INTR_DEBUG, &debug, DEBUG_STACK);
 	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
-	set_intr_gate(14, &page_fault);
+	set_system_intr_gate_ist(INTR_BREAKPOINT, &int3, DEBUG_STACK);
+	set_intr_gate(INTR_PAGE_FAULT, &page_fault);
 	load_idt(&idt_descr);
 }
 
@@ -672,30 +679,30 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	set_intr_gate(INTR_DIV_BY_ZERO, &divide_error);
+	set_intr_gate_ist(INTR_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
-	set_system_intr_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
+	set_system_intr_gate(INTR_OVERFLOW, &overflow);
+	set_intr_gate(INTR_BOUNDS_CHECK, &bounds);
+	set_intr_gate(INTR_INVALID_OP, &invalid_op);
+	set_intr_gate(INTR_NO_DEV, &device_not_available);
 #ifdef CONFIG_X86_32
-	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+	set_task_gate(INTR_DBL_FAULT, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate_ist(INTR_DBL_FAULT, &double_fault, DOUBLEFAULT_STACK);
 #endif
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
+	set_intr_gate(INTR_SEG_OVERRUN, &coprocessor_segment_overrun);
+	set_intr_gate(INTR_INVALID_TSS, &invalid_TSS);
+	set_intr_gate(INTR_NO_SEG, &segment_not_present);
+	set_intr_gate_ist(INTR_STACK_FAULT, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(INTR_GPF, &general_protection);
+	set_intr_gate(INTR_SPURIOUS, &spurious_interrupt_bug);
+	set_intr_gate(INTR_COPROCESSOR, &coprocessor_error);
+	set_intr_gate(INTR_ALIGNMENT, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
+	set_intr_gate_ist(INTR_MCE, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(19, &simd_coprocessor_error);
+	set_intr_gate(INTR_SIMD_COPROCESSOR, &simd_coprocessor_error);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
@@ -720,7 +727,7 @@ void __init trap_init(void)
 
 #ifdef CONFIG_X86_64
 	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
-	set_nmi_gate(1, &debug);
-	set_nmi_gate(3, &int3);
+	set_nmi_gate(INTR_DEBUG, &debug);
+	set_nmi_gate(INTR_BREAKPOINT, &int3);
 #endif
 }
-- 
1.7.0.4

-- 
Kees Cook
ChromeOS Security
