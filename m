Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1LSRCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:02:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1LSRCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:02:36 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=evd7ePTNNZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GTgS5FHV2EeI7j56ksYA:9 a=-yomiNJ0a3AOyyfR95oA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324314151.5916.15.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] [GIT PULL v2] x86: Workaround for NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Date: Mon, 19 Dec 2011 12:02:31 -0500
In-Reply-To: <20111218092405.GI4144@elte.hu>
References: <1324095039.23971.145.camel@gandalf.stny.rr.com>
	 <20111218092405.GI4144@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-18 at 10:24 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >  DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
> >  #endif
> > +static inline int is_debug_stack(unsigned long addr) { return 0; }
> > +static inline void inc_debug_stack_usage(void) { }
> > +static inline void dec_debug_stack_usage(void) { }
> > +static inline void zero_debug_stack(void) { }
> > +static inline void reset_debug_stack(void) { }
> 
> Naming nit: the pattern we use for methods like this is in the 
> form of:
> 
> 	#SUBSYS_#OP_#CONDITION()
> 
> For example:
> 
> 	atomic_inc_not_zero()
> 
> To match that pattern the above should be soemthing like:
> 
> 	debug_stack_usage_inc()
> 	debug_stack_usage_dec()

OK, will change.

> 
> You used the proper naming scheme for the variables btw:
> 
> > +static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
> > +static DEFINE_PER_CPU(int, debug_stack_usage);
> 
> 
> [ The same applies to the other methods as well, such as 
>   zero_debug_stack(), etc. ]

OK.

> 
> This:
> 
> > +void inc_debug_stack_usage(void)
> > +{
> > +	__get_cpu_var(debug_stack_usage)++;
> > +}
> > +
> > +void dec_debug_stack_usage(void)
> > +{
> > +	__get_cpu_var(debug_stack_usage)--;
> > +}
> 
> ... if inlined doesnt it collapse to one or two instructions at 
> most? If yes then this might be worth inlining.

OK, will change.

> 
> > +
> > +int is_debug_stack(unsigned long addr)
> > +{
> > +	return __get_cpu_var(debug_stack_usage) ||
> > +		(addr <= __get_cpu_var(debug_stack_addr) &&
> > +		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
> > +}
> > +
> > +void zero_debug_stack(void)
> > +{
> > +	load_idt((const struct desc_ptr *)&nmi_idt_descr);
> > +}
> > +
> > +void reset_debug_stack(void)
> > +{
> > +	load_idt((const struct desc_ptr *)&idt_descr);
> > +}
> > +
> >  #else	/* CONFIG_X86_64 */
> >  
> >  DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
> > @@ -1208,6 +1240,8 @@ void __cpuinit cpu_init(void)
> >  			estacks += exception_stack_sizes[v];
> >  			oist->ist[v] = t->x86_tss.ist[v] =
> >  					(unsigned long)estacks;
> > +			if (v == DEBUG_STACK - 1)
> 
> One of the cases where checkpatch is wrong, best for this is:
> 
> > +			if (v == DEBUG_STACK-1)

Hehe, OK. I didn't realize that. Thanks, will fix.

> 
> 
> >  ENTRY(nmi)
> >  	INTR_FRAME
> >  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> > -	pushq_cfi $-1
> > +	/*
> > +	 * We allow breakpoints in NMIs. If a breakpoint occurs, then
> > +	 * the iretq it performs will take us out of NMI context.
> > +	 * This means that we can have nested NMIs where the next
> > +	 * NMI is using the top of the stack of the previous NMI. We
> > +	 * can't let it execute because the nested NMI will corrupt the
> > +	 * stack of the previous NMI. NMI handlers are not re-entrant
> > +	 * anyway.
> > +	 *
> > +	 * To handle this case we do the following:
> > +	 *  Check the a special location on the stack that contains
> > +	 *  a variable that is set when NMIs are executing.
> > +	 *  The interrupted task's stack is also checked to see if it
> > +	 *  is an NMI stack.
> > +	 *  If the variable is not set and the stack is not the NMI
> > +	 *  stack then:
> > +	 *    o Set the special variable on the stack
> > +	 *    o Copy the interrupt frame into a "saved" location on the stack
> > +	 *    o Copy the interrupt frame into a "copy" location on the stack
> > +	 *    o Continue processing the NMI
> > +	 *  If the variable is set or the previous stack is the NMI stack:
> > +	 *    o Modify the "copy" location to jump to the repeate_nmi
> > +	 *    o return back to the first NMI
> > +	 *
> > +	 * Now on exit of the first NMI, we first clear the stack variable
> > +	 * The NMI stack will tell any nested NMIs at that point that it is
> > +	 * nested. Then we pop the stack normally with iret, and if there was
> > +	 * a nested NMI that updated the copy interrupt stack frame, a
> > +	 * jump will be made to the repeat_nmi code that will handle the second
> > +	 * NMI.
> > +	 */
> > +
> > +	/* Use %rdx as out temp variable throughout */
> > +	pushq_cfi %rdx
> > +
> > +	/*
> > +	 * Check the special variable on the stack to see if NMIs are
> > +	 * executing.
> > +	 */
> > +	cmp $1, -8(%rsp)
> > +	je nested_nmi
> > +
> > +	/*
> > +	 * Now test if the previous stack was an NMI stack.
> > +	 * We need the double check. We check the NMI stack to satisfy the
> > +	 * race when the first NMI clears the variable before returning.
> > +	 * We check the variable because the first NMI could be in a
> > +	 * breakpoint routine using a breakpoint stack.
> > +	 */
> > +	lea 6*8(%rsp), %rdx
> > +	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
> > +
> > +nested_nmi:
> > +	/*
> > +	 * Do nothing if we interrupted the fixup in repeat_nmi.
> > +	 * It's about to repeat the NMI handler, so we are fine
> > +	 * with ignoring this one.
> > +	 */
> > +	movq $repeat_nmi, %rdx
> > +	cmpq 8(%rsp), %rdx
> > +	ja 1f
> > +	movq $end_repeat_nmi, %rdx
> > +	cmpq 8(%rsp), %rdx
> > +	ja nested_nmi_out
> > +
> > +1:
> > +	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
> > +	leaq -6*8(%rsp), %rdx
> > +	movq %rdx, %rsp
> > +	pushq $__KERNEL_DS
> > +	pushq %rdx
> > +	pushfq
> > +	pushq $__KERNEL_CS
> 
> These probably need CFI annotations.

I'm not sure we want CFI here. As this is updating the copy of the
interrupted NMI, not for the current NMI itself.  That is, it
temporarily moved the current stack pointer to the return stack frame of
the preempted NMI, and overwrote it so that the interrupted NMI will
jump to repeat_nmi. Then it puts the current stack back. IOW, this is
not really the current stack. I would have just copied the data without
moving the stack pointer but it was easier to do it this way for the
pushfq.


> 
> > +	pushq_cfi $repeat_nmi
> > +
> > +	/* Put stack back */
> > +	addq $(11*8), %rsp

This is where we put the stack back to the original position. Is CFI
notation really necessary here?


> > +
> > +nested_nmi_out:
> > +	popq_cfi %rdx
> > +
> > +	/* No need to check faults here */
> > +	INTERRUPT_RETURN
> > +
> > +first_nmi:
> > +	/*
> > +	 * Because nested NMIs will use the pushed location that we
> > +	 * stored rdx, we must keep that space available.
> 
> s/stored rdx/stored in rdx

Thanks, will fix.

> 
> > +restart_nmi:
> > +	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
> >  	subq $ORIG_RAX-R15, %rsp
> >  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
> > +	/*
> > +	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
> > +	 * as we should not be calling schedule in NMI context.
> > +	 * Even with normal interrupts enabled. An NMI should not be
> > +	 * setting NEED_RESCHED or anything that normal interrupts and
> > +	 * exceptions might do.
> > +	 */
> 
> Note that the IRQ return checks are needed because NMI path can 
> set the irq-work TIF. Might be worth putting into the comment - 
> NMIs are not *entirely* passive entities.

The NMI path can set the TIF flags? Then where should they be processed.
There was an assumption that NMIs shouldn't do that. I could have been
wrong with that. What work needs to be done and when? This is the change
that Linus made. If that's the case, we need to work something else out.

I can still do most the work without issue, as I didn't implement
Linus's idea about catching a fault on return. The return will do most
of the work anyway.

But NMIs still can't do the full paranoid exit due to the schedule. We
could call back into kernel routines, but scheduling shouldn't be
allowed as we still have NMI context. Unless we do some tricks to call
an iret to take us out. I've done this to test a lot of this code.


> 
> > +	/* copy the saved stack back to copy stack */
> > +	.rept 5
> > +	pushq 4*8(%rsp)
> 
> Probably needs CFI annotation as well.

Hmm, this probably does, but it probably needs more tricks due to the
crazy jumping around.

> 
> >  dotraplinkage notrace __kprobes void
> >  do_nmi(struct pt_regs *regs, long error_code)
> >  {
> > +	nmi_preprocess(regs);
> > +
> >  	nmi_enter();
> >  
> >  	inc_irq_stat(__nmi_count);
> > @@ -416,6 +515,8 @@ do_nmi(struct pt_regs *regs, long error_code)
> >  		default_do_nmi(regs);
> >  
> >  	nmi_exit();
> > +
> > +	nmi_postprocess();
> 
> Small naming nit: would be nice if the nmi_postprocess() naming 
> indicated the connection to the preprocess block - in particular 
> the retry loop which has the potential for an infinite loop.

That's for i386 only, for x86_64 the retry happens in assembly with the
return.

> 
> Something like nmi_postprocess_retry_preprocess()?

Not sure what would be good, as i386 does the retry, x86_64 just
switches the idt. The two archs do two different things. The above name
would be confusing as it doesn't match what x86_64 does.

> 
> Looks good otherwise.


Thanks!

-- Steve


