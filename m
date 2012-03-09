Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2CIQ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:28:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47667 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2CIQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:28:14 -0500
Date: Fri, 9 Mar 2012 08:13:27 -0800
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
Subject: [PATCH v2] x86: use enum instead of literals for trap values
Message-ID: <20120309161327.GA6913@www.outflux.net>
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
v2:
 - drop IRQ 13 confusions, change enum naming (Ingo Molnar).
v1:
 - updated Aditya Kali's earlier patch: https://lkml.org/lkml/2011/4/22/328
---
 arch/x86/include/asm/traps.h |   25 +++++++++
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  123 +++++++++++++++++++++++-------------------
 3 files changed, 94 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0012d09..9fbecc0 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+/* Processor Fault Vectors */
+enum {
+	X86_DIV_BY_ZERO_FAULT_VEC = 0,	/*  0 */
+	X86_DEBUG_FAULT_VEC,		/*  1 */
+	X86_NMI_FAULT_VEC,		/*  2 */
+	X86_BREAKPOINT_FAULT_VEC,	/*  3 */
+	X86_OVERFLOW_FAULT_VEC,		/*  4 */
+	X86_BOUNDS_CHECK_FAULT_VEC,	/*  5 */
+	X86_INVALID_OP_FAULT_VEC,	/*  6 */
+	X86_NO_DEV_FAULT_VEC,		/*  7 */
+	X86_DOUBLE_FAULT_VEC,		/*  8 */
+	X86_SEG_OVERRUN_FAULT_VEC,	/*  9 */
+	X86_INVALID_TSS_FAULT_VEC,	/* 10 */
+	X86_NO_SEG_FAULT_VEC,		/* 11 */
+	X86_STACK_FAULT_VEC,		/* 12 */
+	X86_GPF_FAULT_VEC,		/* 13 */
+	X86_PAGE_FAULT_VEC,		/* 14 */
+	X86_SPURIOUS_FAULT_VEC,		/* 15 */
+	X86_COPROCESSOR_FAULT_VEC,	/* 16 */
+	X86_ALIGNMENT_FAULT_VEC,	/* 17 */
+	X86_MCE_FAULT_VEC,		/* 18 */
+	X86_SIMD_COPROCESSOR_FAULT_VEC,	/* 19 */
+	X86_IRET_FAULT_VEC = 32,	/* 32 */
+};
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 313fb5c..b7d9525 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -61,7 +61,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error(get_irq_regs(), 0, 16);
+	math_error(get_irq_regs(), 0, X86_COPROCESSOR_FAULT_VEC);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..4ffce6a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -119,7 +119,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < 6)
+		if (trapnr < X86_INVALID_OP_FAULT_VEC)
 			goto vm86_trap;
 		goto trap_signal;
 	}
@@ -203,27 +203,33 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR_INFO(X86_DIV_BY_ZERO_FAULT_VEC, SIGFPE, "divide error", divide_error,
+		FPE_INTDIV, regs->ip)
+DO_ERROR(X86_OVERFLOW_FAULT_VEC, SIGSEGV, "overflow", overflow)
+DO_ERROR(X86_BOUNDS_CHECK_FAULT_VEC, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(X86_INVALID_OP_FAULT_VEC, SIGILL, "invalid opcode", invalid_op,
+		ILL_ILLOPN, regs->ip)
+DO_ERROR(X86_SEG_OVERRUN_FAULT_VEC, SIGFPE, "coprocessor segment overrun",
+		coprocessor_segment_overrun)
+DO_ERROR(X86_INVALID_TSS_FAULT_VEC, SIGSEGV, "invalid TSS", invalid_TSS)
+DO_ERROR(X86_NO_SEG_FAULT_VEC, SIGBUS, "segment not present",
+		segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+DO_ERROR(X86_STACK_FAULT_VEC, SIGBUS, "stack segment", stack_segment)
 #endif
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+DO_ERROR_INFO(X86_ALIGNMENT_FAULT_VEC, SIGBUS, "alignment check",
+		alignment_check, BUS_ADRALN, 0)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
+			X86_STACK_FAULT_VEC, SIGBUS) == NOTIFY_STOP)
 		return;
 	preempt_conditional_sti(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	do_trap(X86_STACK_FAULT_VEC, SIGBUS, "stack segment", regs,
+			error_code, NULL);
 	preempt_conditional_cli(regs);
 }
 
@@ -233,10 +239,11 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk = current;
 
 	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+	notify_die(DIE_TRAP, str, regs, error_code, X86_DOUBLE_FAULT_VEC,
+			SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
+	tsk->thread.trap_no = X86_DOUBLE_FAULT_VEC;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -264,7 +271,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_no = X86_GPF_FAULT_VEC;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -291,9 +298,9 @@ gp_in_kernel:
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
+	tsk->thread.trap_no = X86_GPF_FAULT_VEC;
+	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
+			X86_GPF_FAULT_VEC, SIGSEGV) == NOTIFY_STOP)
 		return;
 	die("general protection fault", regs, error_code);
 }
@@ -302,13 +309,13 @@ gp_in_kernel:
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
-	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code,
+			 X86_BREAKPOINT_FAULT_VEC, SIGTRAP) == NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (notify_die(DIE_INT3, "int3", regs, error_code,
+		       X86_BREAKPOINT_FAULT_VEC, SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/*
@@ -317,7 +324,8 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	 */
 	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	do_trap(X86_BREAKPOINT_FAULT_VEC, SIGTRAP, "int3", regs, error_code,
+			NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 }
@@ -423,7 +431,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
-				error_code, 1);
+				error_code, X86_DEBUG_FAULT_VEC);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
 		return;
@@ -460,7 +468,8 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	struct task_struct *task = current;
 	siginfo_t info;
 	unsigned short err;
-	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+	char *str = (trapnr == X86_COPROCESSOR_FAULT_VEC) ? "fpu exception" :
+						"simd exception";
 
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
 		return;
@@ -485,7 +494,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_addr = (void __user *)regs->ip;
-	if (trapnr == 16) {
+	if (trapnr == X86_COPROCESSOR_FAULT_VEC) {
 		unsigned short cwd, swd;
 		/*
 		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
@@ -529,10 +538,11 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 		info.si_code = FPE_FLTRES;
 	} else {
 		/*
-		 * If we're using IRQ 13, or supposedly even some trap 16
-		 * implementations, it's possible we get a spurious trap...
+		 * If we're using IRQ 13, or supposedly even some trap
+		 * X86_COPROCESSOR_FAULT_VEC implementations, it's possible
+		 * we get a spurious trap, which is not an error.
 		 */
-		return;		/* Spurious trap, no error */
+		return;
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
@@ -543,13 +553,13 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 	ignore_fpu_irq = 1;
 #endif
 
-	math_error(regs, error_code, 16);
+	math_error(regs, error_code, X86_COPROCESSOR_FAULT_VEC);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	math_error(regs, error_code, 19);
+	math_error(regs, error_code, X86_SIMD_COPROCESSOR_FAULT_VEC);
 }
 
 dotraplinkage void
@@ -646,17 +656,18 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_TRAP, "iret exception",
 			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
 		return;
-	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+	do_trap(X86_IRET_FAULT_VEC, SIGILL, "iret exception", regs,
+		error_code, &info);
 }
 #endif
 
 /* Set of traps needed for early debugging. */
 void __init early_trap_init(void)
 {
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(X86_DEBUG_FAULT_VEC, &debug, DEBUG_STACK);
 	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
-	set_intr_gate(14, &page_fault);
+	set_system_intr_gate_ist(X86_BREAKPOINT_FAULT_VEC, &int3, DEBUG_STACK);
+	set_intr_gate(X86_PAGE_FAULT_VEC, &page_fault);
 	load_idt(&idt_descr);
 }
 
@@ -672,30 +683,32 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	set_intr_gate(X86_DIV_BY_ZERO_FAULT_VEC, &divide_error);
+	set_intr_gate_ist(X86_NMI_FAULT_VEC, &nmi, NMI_STACK);
 	/* int4 can be called from all */
-	set_system_intr_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
+	set_system_intr_gate(X86_OVERFLOW_FAULT_VEC, &overflow);
+	set_intr_gate(X86_BOUNDS_CHECK_FAULT_VEC, &bounds);
+	set_intr_gate(X86_INVALID_OP_FAULT_VEC, &invalid_op);
+	set_intr_gate(X86_NO_DEV_FAULT_VEC, &device_not_available);
 #ifdef CONFIG_X86_32
-	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+	set_task_gate(X86_DOUBLE_FAULT_VEC, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate_ist(X86_DOUBLE_FAULT_VEC, &double_fault,
+				DOUBLEFAULT_STACK);
 #endif
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
+	set_intr_gate(X86_SEG_OVERRUN_FAULT_VEC, &coprocessor_segment_overrun);
+	set_intr_gate(X86_INVALID_TSS_FAULT_VEC, &invalid_TSS);
+	set_intr_gate(X86_NO_SEG_FAULT_VEC, &segment_not_present);
+	set_intr_gate_ist(X86_STACK_FAULT_VEC, &stack_segment,
+				STACKFAULT_STACK);
+	set_intr_gate(X86_GPF_FAULT_VEC, &general_protection);
+	set_intr_gate(X86_SPURIOUS_FAULT_VEC, &spurious_interrupt_bug);
+	set_intr_gate(X86_COPROCESSOR_FAULT_VEC, &coprocessor_error);
+	set_intr_gate(X86_ALIGNMENT_FAULT_VEC, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
+	set_intr_gate_ist(X86_MCE_FAULT_VEC, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(19, &simd_coprocessor_error);
+	set_intr_gate(X86_SIMD_COPROCESSOR_FAULT_VEC, &simd_coprocessor_error);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
@@ -720,7 +733,7 @@ void __init trap_init(void)
 
 #ifdef CONFIG_X86_64
 	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
-	set_nmi_gate(1, &debug);
-	set_nmi_gate(3, &int3);
+	set_nmi_gate(X86_DEBUG_FAULT_VEC, &debug);
+	set_nmi_gate(X86_BREAKPOINT_FAULT_VEC, &int3);
 #endif
 }
-- 
1.7.0.4

-- 
Kees Cook
ChromeOS Security
