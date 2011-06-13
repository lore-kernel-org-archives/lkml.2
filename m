Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1FMXaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:30:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1FMXaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QFbolf1xi7ud4OPUuzYwkEGhmc9olxNZ4Bxcb8YcuB1QjDr6AbKVGB5eXwG7nR4881
         N3hDWj0pLTH3GSBX99dA==
MIME-Version: 1.0
In-Reply-To: <1304462995-1825-1-git-send-email-vnagarnaik@google.com>
References: <1304462995-1825-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 13 Jun 2011 16:29:28 -0700
Message-ID: <BANLkTimNs-iJPK67fkWdeq_Hmd2WvPSFpo9-ZL4hHOobkXaZNg@mail.gmail.com>
Subject: Re: [PATCH] x86: Change trap definitions to enumerated values
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Aditya Kali <adityakali@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 3:49 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
> From: Aditya Kali <adityakali@google.com>
>
> The traps are referred to by their numbers and it can be difficult to
> understand them while reading the code without context. This patch adds
> enumeration of the trap numbers and replaced the numbers to the correct
> enum for x86.
>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  arch/x86/include/asm/traps.h |   24 +++++++++
>  arch/x86/kernel/traps.c      |  116 ++++++++++++++++++++++-------------------
>  2 files changed, 86 insertions(+), 54 deletions(-)
>
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 0310da6..c561caf 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -87,4 +87,28 @@ asmlinkage void smp_thermal_interrupt(void);
>  asmlinkage void mce_threshold_interrupt(void);
>  #endif
>
> +/* Interrupts/Exceptions */
> +enum {
> +       INTR_DIV_BY_ZERO = 0,   /*  0 */
> +       INTR_DEBUG,             /*  1 */
> +       INTR_NMI,               /*  2 */
> +       INTR_BREAKPOINT,        /*  3 */
> +       INTR_OVERFLOW,          /*  4 */
> +       INTR_BOUNDS_CHECK,      /*  5 */
> +       INTR_INVALID_OP,        /*  6 */
> +       INTR_NO_DEV,            /*  7 */
> +       INTR_DBL_FAULT,         /*  8 */
> +       INTR_SEG_OVERRUN,       /*  9 */
> +       INTR_INVALID_TSS,       /* 10 */
> +       INTR_NO_SEG,            /* 11 */
> +       INTR_STACK_FAULT,       /* 12 */
> +       INTR_GPF,               /* 13 */
> +       INTR_PAGE_FAULT,        /* 14 */
> +       INTR_SPURIOUS,          /* 15 */
> +       INTR_COPROCESSOR,       /* 16 */
> +       INTR_ALIGNMENT,         /* 17 */
> +       INTR_MCE,               /* 18 */
> +       INTR_SIMD_COPROCESSOR   /* 19 */
> +};
> +
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index fbfc162..b3efe9f 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -129,7 +129,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
>                 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
>                 * On nmi (interrupt 2), do_trap should not be called.
>                 */
> -               if (trapnr < 6)
> +               if (trapnr < INTR_INVALID_OP)
>                        goto vm86_trap;
>                goto trap_signal;
>        }
> @@ -213,27 +213,29 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)       \
>        do_trap(trapnr, signr, str, regs, error_code, &info);           \
>  }
>
> -DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
> -DO_ERROR(4, SIGSEGV, "overflow", overflow)
> -DO_ERROR(5, SIGSEGV, "bounds", bounds)
> -DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
> -DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
> -DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
> -DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
> +DO_ERROR_INFO(INTR_DIV_BY_ZERO, SIGFPE, "divide error",    divide_error,    FPE_INTDIV, regs->ip)
> +DO_ERROR_INFO(INTR_ALIGNMENT,   SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
> +DO_ERROR_INFO(INTR_INVALID_OP,  SIGILL, "invalid opcode",  invalid_op,      ILL_ILLOPN, regs->ip)
> +
> +DO_ERROR(INTR_OVERFLOW,     SIGSEGV, "overflow",                    overflow)
> +DO_ERROR(INTR_BOUNDS_CHECK, SIGSEGV, "bounds",                      bounds)
> +DO_ERROR(INTR_SEG_OVERRUN,  SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)
> +DO_ERROR(INTR_INVALID_TSS,  SIGSEGV, "invalid TSS",                 invalid_TSS)
> +DO_ERROR(INTR_NO_SEG,       SIGBUS,  "segment not present",         segment_not_present)
>  #ifdef CONFIG_X86_32
> -DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
> +DO_ERROR(INTR_STACK_FAULT,  SIGBUS,  "stack segment",               stack_segment)
>  #endif
> -DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
>
>  #ifdef CONFIG_X86_64
>  /* Runs on IST stack */
>  dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
>  {
>        if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
> -                       12, SIGBUS) == NOTIFY_STOP)
> +                       INTR_STACK_FAULT, SIGBUS) == NOTIFY_STOP)
>                return;
>        preempt_conditional_sti(regs);
> -       do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
> +       do_trap(INTR_STACK_FAULT, SIGBUS, "stack segment", regs, error_code,
> +                       NULL);
>        preempt_conditional_cli(regs);
>  }
>
> @@ -243,10 +245,10 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
>        struct task_struct *tsk = current;
>
>        /* Return not checked because double check cannot be ignored */
> -       notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
> +       notify_die(DIE_TRAP, str, regs, error_code, INTR_DBL_FAULT, SIGSEGV);
>
>        tsk->thread.error_code = error_code;
> -       tsk->thread.trap_no = 8;
> +       tsk->thread.trap_no = INTR_DBL_FAULT;
>
>        /*
>         * This is always a kernel trap and never fixable (and thus must
> @@ -274,7 +276,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
>                goto gp_in_kernel;
>
>        tsk->thread.error_code = error_code;
> -       tsk->thread.trap_no = 13;
> +       tsk->thread.trap_no = INTR_GPF;
>
>        if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
>                        printk_ratelimit()) {
> @@ -301,9 +303,9 @@ gp_in_kernel:
>                return;
>
>        tsk->thread.error_code = error_code;
> -       tsk->thread.trap_no = 13;
> +       tsk->thread.trap_no = INTR_GPF;
>        if (notify_die(DIE_GPF, "general protection fault", regs,
> -                               error_code, 13, SIGSEGV) == NOTIFY_STOP)
> +                               error_code, INTR_GPF, SIGSEGV) == NOTIFY_STOP)
>                return;
>        die("general protection fault", regs, error_code);
>  }
> @@ -372,7 +374,8 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
>  static notrace __kprobes void
>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  {
> -       if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
> +       if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, INTR_NMI,
> +                               SIGINT) ==
>                        NOTIFY_STOP)
>                return;
>  #ifdef CONFIG_MCA
> @@ -404,7 +407,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>         * NMI, otherwise we may lose it, because the CPU-specific
>         * NMI can not be detected/processed on other CPUs.
>         */
> -       if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> +       if (notify_die(DIE_NMI, "nmi", regs, 0, INTR_NMI, SIGINT) ==
> +                       NOTIFY_STOP)
>                return;
>
>        /* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> @@ -460,22 +464,24 @@ void restart_nmi(void)
>  dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  {
>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
> -       if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
> -                       == NOTIFY_STOP)
> +       if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, INTR_BREAKPOINT,
> +                       SIGTRAP) == NOTIFY_STOP)
>                return;
>  #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
>  #ifdef CONFIG_KPROBES
> -       if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
> +       if (notify_die(DIE_INT3, "int3", regs, error_code, INTR_BREAKPOINT,
> +                               SIGTRAP)
>                        == NOTIFY_STOP)
>                return;
>  #else
> -       if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
> +       if (notify_die(DIE_TRAP, "int3", regs, error_code, INTR_BREAKPOINT,
> +                               SIGTRAP)
>                        == NOTIFY_STOP)
>                return;
>  #endif
>
>        preempt_conditional_sti(regs);
> -       do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> +       do_trap(INTR_BREAKPOINT, SIGTRAP, "int3", regs, error_code, NULL);
>        preempt_conditional_cli(regs);
>  }
>
> @@ -574,7 +580,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>
>        if (regs->flags & X86_VM_MASK) {
>                handle_vm86_trap((struct kernel_vm86_regs *) regs,
> -                               error_code, 1);
> +                               error_code, INTR_DEBUG);
>                preempt_conditional_cli(regs);
>                return;
>        }
> @@ -602,14 +608,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  /*
>  * Note that we play around with the 'TS' bit in an attempt to get
>  * the correct behaviour even in the presence of the asynchronous
> - * IRQ13 behaviour
> + * INTR_GPF behaviour
>  */
>  void math_error(struct pt_regs *regs, int error_code, int trapnr)
>  {
>        struct task_struct *task = current;
>        siginfo_t info;
>        unsigned short err;
> -       char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
> +       char *str = (trapnr == INTR_COPROCESSOR) ? "fpu exception" :
> +                                               "simd exception";
>
>        if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
>                return;
> @@ -634,7 +641,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
>        info.si_signo = SIGFPE;
>        info.si_errno = 0;
>        info.si_addr = (void __user *)regs->ip;
> -       if (trapnr == 16) {
> +       if (trapnr == INTR_COPROCESSOR) {
>                unsigned short cwd, swd;
>                /*
>                 * (~cwd & swd) will mask out exceptions that are not set to unmasked
> @@ -678,8 +685,9 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
>                info.si_code = FPE_FLTRES;
>        } else {
>                /*
> -                * If we're using IRQ 13, or supposedly even some trap 16
> -                * implementations, it's possible we get a spurious trap...
> +                * If we're using INTR_GPF, or supposedly even some trap
> +                * INTR_COPROCESSOR implementations, it's possible we get a
> +                * spurious trap...
>                 */
>                return;         /* Spurious trap, no error */
>        }
> @@ -692,13 +700,13 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
>        ignore_fpu_irq = 1;
>  #endif
>
> -       math_error(regs, error_code, 16);
> +       math_error(regs, error_code, INTR_COPROCESSOR);
>  }
>
>  dotraplinkage void
>  do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
>  {
> -       math_error(regs, error_code, 19);
> +       math_error(regs, error_code, INTR_SIMD_COPROCESSOR);
>  }
>
>  dotraplinkage void
> @@ -745,7 +753,7 @@ void __math_state_restore(void)
>  * 'math_state_restore()' saves the current math information in the
>  * old math state array, and gets the new ones from the current task
>  *
> - * Careful.. There are problems with IBM-designed IRQ13 behaviour.
> + * Careful.. There are problems with IBM-designed INTR_GPF behaviour.
>  * Don't touch unless you *really* know how it works.
>  *
>  * Must be called with kernel preemption disabled (in this case,
> @@ -817,10 +825,10 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>  /* Set of traps needed for early debugging. */
>  void __init early_trap_init(void)
>  {
> -       set_intr_gate_ist(1, &debug, DEBUG_STACK);
> +       set_intr_gate_ist(INTR_DEBUG, &debug, DEBUG_STACK);
>        /* int3 can be called from all */
> -       set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
> -       set_intr_gate(14, &page_fault);
> +       set_system_intr_gate_ist(INTR_BREAKPOINT, &int3, DEBUG_STACK);
> +       set_intr_gate(INTR_PAGE_FAULT, &page_fault);
>        load_idt(&idt_descr);
>  }
>
> @@ -836,30 +844,30 @@ void __init trap_init(void)
>        early_iounmap(p, 4);
>  #endif
>
> -       set_intr_gate(0, &divide_error);
> -       set_intr_gate_ist(2, &nmi, NMI_STACK);
> +       set_intr_gate(INTR_DIV_BY_ZERO,     &divide_error);
> +       set_intr_gate_ist(INTR_NMI,         &nmi, NMI_STACK);
>        /* int4 can be called from all */
> -       set_system_intr_gate(4, &overflow);
> -       set_intr_gate(5, &bounds);
> -       set_intr_gate(6, &invalid_op);
> -       set_intr_gate(7, &device_not_available);
> +       set_system_intr_gate(INTR_OVERFLOW, &overflow);
> +       set_intr_gate(INTR_BOUNDS_CHECK,    &bounds);
> +       set_intr_gate(INTR_INVALID_OP,      &invalid_op);
> +       set_intr_gate(INTR_NO_DEV,          &device_not_available);
>  #ifdef CONFIG_X86_32
> -       set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
> +       set_task_gate(INTR_DBL_FAULT,       GDT_ENTRY_DOUBLEFAULT_TSS);
>  #else
> -       set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
> +       set_intr_gate_ist(INTR_DBL_FAULT,   &double_fault, DOUBLEFAULT_STACK);
>  #endif
> -       set_intr_gate(9, &coprocessor_segment_overrun);
> -       set_intr_gate(10, &invalid_TSS);
> -       set_intr_gate(11, &segment_not_present);
> -       set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
> -       set_intr_gate(13, &general_protection);
> -       set_intr_gate(15, &spurious_interrupt_bug);
> -       set_intr_gate(16, &coprocessor_error);
> -       set_intr_gate(17, &alignment_check);
> +       set_intr_gate(INTR_SEG_OVERRUN,     &coprocessor_segment_overrun);
> +       set_intr_gate(INTR_INVALID_TSS,     &invalid_TSS);
> +       set_intr_gate(INTR_NO_SEG,          &segment_not_present);
> +       set_intr_gate_ist(INTR_STACK_FAULT, &stack_segment, STACKFAULT_STACK);
> +       set_intr_gate(INTR_GPF,             &general_protection);
> +       set_intr_gate(INTR_SPURIOUS,        &spurious_interrupt_bug);
> +       set_intr_gate(INTR_COPROCESSOR,     &coprocessor_error);
> +       set_intr_gate(INTR_ALIGNMENT,       &alignment_check);
>  #ifdef CONFIG_X86_MCE
> -       set_intr_gate_ist(18, &machine_check, MCE_STACK);
> +       set_intr_gate_ist(INTR_MCE,         &machine_check, MCE_STACK);
>  #endif
> -       set_intr_gate(19, &simd_coprocessor_error);
> +       set_intr_gate(INTR_SIMD_COPROCESSOR, &simd_coprocessor_error);
>
>        /* Reserve all the builtin and the syscall vector: */
>        for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
> --
> 1.7.3.1
>
>

All

Can you please go through this patch?


Thanks
Vaibhav Nagarnaik
