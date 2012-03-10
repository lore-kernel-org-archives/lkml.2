Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab2CJBCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 20:02:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34695 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2CJBCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 20:02:07 -0500
Date: Fri, 9 Mar 2012 17:01:32 -0800
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-c94082656dac74257f63e91f78d5d458ac781fa5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        keescook@chromium.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de
In-Reply-To: <20120310000710.GA32667@www.outflux.net>
References: <20120310000710.GA32667@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86:
  Use enum instead of literals for trap values
Git-Commit-ID: c94082656dac74257f63e91f78d5d458ac781fa5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 17:01:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c94082656dac74257f63e91f78d5d458ac781fa5
Gitweb:     http://git.kernel.org/tip/c94082656dac74257f63e91f78d5d458ac781fa5
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 9 Mar 2012 16:07:10 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 Mar 2012 16:47:54 -0800

x86: Use enum instead of literals for trap values

The traps are referred to by their numbers and it can be difficult to
understand them while reading the code without context. This patch adds
enumeration of the trap numbers and replaces the numbers with the correct
enum for x86.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20120310000710.GA32667@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/traps.h |   25 +++++++++
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  123 ++++++++++++++++++++++--------------------
 3 files changed, 91 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0012d09..88eae2a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+/* Interrupts/Exceptions */
+enum {
+	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
+	X86_TRAP_DB,		/*  1, Debug */
+	X86_TRAP_NMI,		/*  2, Non-maskable Interrupt */
+	X86_TRAP_BP,		/*  3, Breakpoint */
+	X86_TRAP_OF,		/*  4, Overflow */
+	X86_TRAP_BR,		/*  5, Bound Range Exceeded */
+	X86_TRAP_UD,		/*  6, Invalid Opcode */
+	X86_TRAP_NM,		/*  7, Device Not Available */
+	X86_TRAP_DF,		/*  8, Double Fault */
+	X86_TRAP_OLD_MF,	/*  9, Coprocessor Segment Overrun */
+	X86_TRAP_TS,		/* 10, Invalid TSS */
+	X86_TRAP_NP,		/* 11, Segment Not Present */
+	X86_TRAP_SS,		/* 12, Stack Segment Fault */
+	X86_TRAP_GP,		/* 13, General Protection Fault */
+	X86_TRAP_PF,		/* 14, Page Fault */
+	X86_TRAP_SPURIOUS,	/* 15, Spurious Interrupt */
+	X86_TRAP_MF,		/* 16, x87 Floating-Point Exception */
+	X86_TRAP_AC,		/* 17, Alignment Check */
+	X86_TRAP_MC,		/* 18, Machine Check */
+	X86_TRAP_XF,		/* 19, SIMD Floating-Point Exception */
+	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
+};
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 313fb5c..7b77062 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -61,7 +61,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error(get_irq_regs(), 0, 16);
+	math_error(get_irq_regs(), 0, X86_TRAP_MF);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..037fc2b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -119,7 +119,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < 6)
+		if (trapnr < X86_TRAP_UD)
 			goto vm86_trap;
 		goto trap_signal;
 	}
@@ -203,27 +203,31 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
+		regs->ip)
+DO_ERROR(X86_TRAP_OF, SIGSEGV, "overflow", overflow)
+DO_ERROR(X86_TRAP_BR, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(X86_TRAP_UD, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN,
+		regs->ip)
+DO_ERROR(X86_TRAP_OLD_MF, SIGFPE, "coprocessor segment overrun",
+		coprocessor_segment_overrun)
+DO_ERROR(X86_TRAP_TS, SIGSEGV, "invalid TSS", invalid_TSS)
+DO_ERROR(X86_TRAP_NP, SIGBUS, "segment not present", segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+DO_ERROR(X86_TRAP_SS, SIGBUS, "stack segment", stack_segment)
 #endif
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
+		BUS_ADRALN, 0)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
+			X86_TRAP_SS, SIGBUS) == NOTIFY_STOP)
 		return;
 	preempt_conditional_sti(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 }
 
@@ -233,10 +237,10 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk = current;
 
 	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
+	tsk->thread.trap_no = X86_TRAP_DF;
 
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
@@ -264,7 +268,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		goto gp_in_kernel;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
+	tsk->thread.trap_no = X86_TRAP_GP;
 
 	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 			printk_ratelimit()) {
@@ -291,9 +295,9 @@ gp_in_kernel:
 		return;
 
 	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
+	tsk->thread.trap_no = X86_TRAP_GP;
+	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
+			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
 		return;
 	die("general protection fault", regs, error_code);
 }
@@ -302,13 +306,13 @@ gp_in_kernel:
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
-	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+				SIGTRAP) == NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
+	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+			SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/*
@@ -317,7 +321,7 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	 */
 	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 }
@@ -422,8 +426,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	preempt_conditional_sti(regs);
 
 	if (regs->flags & X86_VM_MASK) {
-		handle_vm86_trap((struct kernel_vm86_regs *) regs,
-				error_code, 1);
+		handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code,
+					X86_TRAP_DB);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
 		return;
@@ -460,7 +464,8 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	struct task_struct *task = current;
 	siginfo_t info;
 	unsigned short err;
-	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+	char *str = (trapnr == X86_TRAP_MF) ? "fpu exception" :
+						"simd exception";
 
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
 		return;
@@ -485,7 +490,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
 	info.si_addr = (void __user *)regs->ip;
-	if (trapnr == 16) {
+	if (trapnr == X86_TRAP_MF) {
 		unsigned short cwd, swd;
 		/*
 		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
@@ -529,10 +534,11 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 		info.si_code = FPE_FLTRES;
 	} else {
 		/*
-		 * If we're using IRQ 13, or supposedly even some trap 16
-		 * implementations, it's possible we get a spurious trap...
+		 * If we're using IRQ 13, or supposedly even some trap
+		 * X86_TRAP_MF implementations, it's possible
+		 * we get a spurious trap, which is not an error.
 		 */
-		return;		/* Spurious trap, no error */
+		return;
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
@@ -543,13 +549,13 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 	ignore_fpu_irq = 1;
 #endif
 
-	math_error(regs, error_code, 16);
+	math_error(regs, error_code, X86_TRAP_MF);
 }
 
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	math_error(regs, error_code, 19);
+	math_error(regs, error_code, X86_TRAP_XF);
 }
 
 dotraplinkage void
@@ -643,20 +649,21 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
 	info.si_addr = NULL;
-	if (notify_die(DIE_TRAP, "iret exception",
-			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+	if (notify_die(DIE_TRAP, "iret exception", regs, error_code,
+			X86_TRAP_IRET, SIGILL) == NOTIFY_STOP)
 		return;
-	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+	do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
+		&info);
 }
 #endif
 
 /* Set of traps needed for early debugging. */
 void __init early_trap_init(void)
 {
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(X86_TRAP_DB, &debug, DEBUG_STACK);
 	/* int3 can be called from all */
-	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
-	set_intr_gate(14, &page_fault);
+	set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
+	set_intr_gate(X86_TRAP_PF, &page_fault);
 	load_idt(&idt_descr);
 }
 
@@ -672,30 +679,30 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	set_intr_gate(X86_TRAP_DE, &divide_error);
+	set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
-	set_system_intr_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
+	set_system_intr_gate(X86_TRAP_OF, &overflow);
+	set_intr_gate(X86_TRAP_BR, &bounds);
+	set_intr_gate(X86_TRAP_UD, &invalid_op);
+	set_intr_gate(X86_TRAP_NM, &device_not_available);
 #ifdef CONFIG_X86_32
-	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+	set_task_gate(X86_TRAP_DF, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate_ist(X86_TRAP_DF, &double_fault, DOUBLEFAULT_STACK);
 #endif
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
+	set_intr_gate(X86_TRAP_OLD_MF, &coprocessor_segment_overrun);
+	set_intr_gate(X86_TRAP_TS, &invalid_TSS);
+	set_intr_gate(X86_TRAP_NP, &segment_not_present);
+	set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(X86_TRAP_GP, &general_protection);
+	set_intr_gate(X86_TRAP_SPURIOUS, &spurious_interrupt_bug);
+	set_intr_gate(X86_TRAP_MF, &coprocessor_error);
+	set_intr_gate(X86_TRAP_AC, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
+	set_intr_gate_ist(X86_TRAP_MC, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(19, &simd_coprocessor_error);
+	set_intr_gate(X86_TRAP_XF, &simd_coprocessor_error);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
@@ -720,7 +727,7 @@ void __init trap_init(void)
 
 #ifdef CONFIG_X86_64
 	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
-	set_nmi_gate(1, &debug);
-	set_nmi_gate(3, &int3);
+	set_nmi_gate(X86_TRAP_DB, &debug);
+	set_nmi_gate(X86_TRAP_BP, &int3);
 #endif
 }
