Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1LRJ0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 04:26:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1LRJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 04:26:05 -0500
Date: Sun, 18 Dec 2011 10:24:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [GIT PULL v2] x86: Workaround for NMI iret woes
Message-ID: <20111218092405.GI4144@elte.hu>
References: <1324095039.23971.145.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324095039.23971.145.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

>  DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
>  #endif
> +static inline int is_debug_stack(unsigned long addr) { return 0; }
> +static inline void inc_debug_stack_usage(void) { }
> +static inline void dec_debug_stack_usage(void) { }
> +static inline void zero_debug_stack(void) { }
> +static inline void reset_debug_stack(void) { }

Naming nit: the pattern we use for methods like this is in the 
form of:

	#SUBSYS_#OP_#CONDITION()

For example:

	atomic_inc_not_zero()

To match that pattern the above should be soemthing like:

	debug_stack_usage_inc()
	debug_stack_usage_dec()

You used the proper naming scheme for the variables btw:

> +static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
> +static DEFINE_PER_CPU(int, debug_stack_usage);


[ The same applies to the other methods as well, such as 
  zero_debug_stack(), etc. ]

This:

> +void inc_debug_stack_usage(void)
> +{
> +	__get_cpu_var(debug_stack_usage)++;
> +}
> +
> +void dec_debug_stack_usage(void)
> +{
> +	__get_cpu_var(debug_stack_usage)--;
> +}

... if inlined doesnt it collapse to one or two instructions at 
most? If yes then this might be worth inlining.

> +
> +int is_debug_stack(unsigned long addr)
> +{
> +	return __get_cpu_var(debug_stack_usage) ||
> +		(addr <= __get_cpu_var(debug_stack_addr) &&
> +		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
> +}
> +
> +void zero_debug_stack(void)
> +{
> +	load_idt((const struct desc_ptr *)&nmi_idt_descr);
> +}
> +
> +void reset_debug_stack(void)
> +{
> +	load_idt((const struct desc_ptr *)&idt_descr);
> +}
> +
>  #else	/* CONFIG_X86_64 */
>  
>  DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
> @@ -1208,6 +1240,8 @@ void __cpuinit cpu_init(void)
>  			estacks += exception_stack_sizes[v];
>  			oist->ist[v] = t->x86_tss.ist[v] =
>  					(unsigned long)estacks;
> +			if (v == DEBUG_STACK - 1)

One of the cases where checkpatch is wrong, best for this is:

> +			if (v == DEBUG_STACK-1)


>  ENTRY(nmi)
>  	INTR_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> -	pushq_cfi $-1
> +	/*
> +	 * We allow breakpoints in NMIs. If a breakpoint occurs, then
> +	 * the iretq it performs will take us out of NMI context.
> +	 * This means that we can have nested NMIs where the next
> +	 * NMI is using the top of the stack of the previous NMI. We
> +	 * can't let it execute because the nested NMI will corrupt the
> +	 * stack of the previous NMI. NMI handlers are not re-entrant
> +	 * anyway.
> +	 *
> +	 * To handle this case we do the following:
> +	 *  Check the a special location on the stack that contains
> +	 *  a variable that is set when NMIs are executing.
> +	 *  The interrupted task's stack is also checked to see if it
> +	 *  is an NMI stack.
> +	 *  If the variable is not set and the stack is not the NMI
> +	 *  stack then:
> +	 *    o Set the special variable on the stack
> +	 *    o Copy the interrupt frame into a "saved" location on the stack
> +	 *    o Copy the interrupt frame into a "copy" location on the stack
> +	 *    o Continue processing the NMI
> +	 *  If the variable is set or the previous stack is the NMI stack:
> +	 *    o Modify the "copy" location to jump to the repeate_nmi
> +	 *    o return back to the first NMI
> +	 *
> +	 * Now on exit of the first NMI, we first clear the stack variable
> +	 * The NMI stack will tell any nested NMIs at that point that it is
> +	 * nested. Then we pop the stack normally with iret, and if there was
> +	 * a nested NMI that updated the copy interrupt stack frame, a
> +	 * jump will be made to the repeat_nmi code that will handle the second
> +	 * NMI.
> +	 */
> +
> +	/* Use %rdx as out temp variable throughout */
> +	pushq_cfi %rdx
> +
> +	/*
> +	 * Check the special variable on the stack to see if NMIs are
> +	 * executing.
> +	 */
> +	cmp $1, -8(%rsp)
> +	je nested_nmi
> +
> +	/*
> +	 * Now test if the previous stack was an NMI stack.
> +	 * We need the double check. We check the NMI stack to satisfy the
> +	 * race when the first NMI clears the variable before returning.
> +	 * We check the variable because the first NMI could be in a
> +	 * breakpoint routine using a breakpoint stack.
> +	 */
> +	lea 6*8(%rsp), %rdx
> +	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
> +
> +nested_nmi:
> +	/*
> +	 * Do nothing if we interrupted the fixup in repeat_nmi.
> +	 * It's about to repeat the NMI handler, so we are fine
> +	 * with ignoring this one.
> +	 */
> +	movq $repeat_nmi, %rdx
> +	cmpq 8(%rsp), %rdx
> +	ja 1f
> +	movq $end_repeat_nmi, %rdx
> +	cmpq 8(%rsp), %rdx
> +	ja nested_nmi_out
> +
> +1:
> +	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
> +	leaq -6*8(%rsp), %rdx
> +	movq %rdx, %rsp
> +	pushq $__KERNEL_DS
> +	pushq %rdx
> +	pushfq
> +	pushq $__KERNEL_CS

These probably need CFI annotations.

> +	pushq_cfi $repeat_nmi
> +
> +	/* Put stack back */
> +	addq $(11*8), %rsp
> +
> +nested_nmi_out:
> +	popq_cfi %rdx
> +
> +	/* No need to check faults here */
> +	INTERRUPT_RETURN
> +
> +first_nmi:
> +	/*
> +	 * Because nested NMIs will use the pushed location that we
> +	 * stored rdx, we must keep that space available.

s/stored rdx/stored in rdx

> +restart_nmi:
> +	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
>  	subq $ORIG_RAX-R15, %rsp
>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
> +	/*
> +	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
> +	 * as we should not be calling schedule in NMI context.
> +	 * Even with normal interrupts enabled. An NMI should not be
> +	 * setting NEED_RESCHED or anything that normal interrupts and
> +	 * exceptions might do.
> +	 */

Note that the IRQ return checks are needed because NMI path can 
set the irq-work TIF. Might be worth putting into the comment - 
NMIs are not *entirely* passive entities.

> +	/* copy the saved stack back to copy stack */
> +	.rept 5
> +	pushq 4*8(%rsp)

Probably needs CFI annotation as well.

>  dotraplinkage notrace __kprobes void
>  do_nmi(struct pt_regs *regs, long error_code)
>  {
> +	nmi_preprocess(regs);
> +
>  	nmi_enter();
>  
>  	inc_irq_stat(__nmi_count);
> @@ -416,6 +515,8 @@ do_nmi(struct pt_regs *regs, long error_code)
>  		default_do_nmi(regs);
>  
>  	nmi_exit();
> +
> +	nmi_postprocess();

Small naming nit: would be nice if the nmi_postprocess() naming 
indicated the connection to the preprocess block - in particular 
the retry loop which has the potential for an infinite loop.

Something like nmi_postprocess_retry_preprocess()?

Looks good otherwise.

Thanks,

	Ingo
