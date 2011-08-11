Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1HKM7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:59:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1HKM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:59:29 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=b6fuAeHeA_gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0qP6rABCJcbxiX0xsfQA:9 a=bjEpOOFvFauIpFoBwDUA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=DkQY7Sc9M4Rmtq9s:21 a=frBzWovhMQ_AismM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/5][RFC] ftrace: Return pt_regs to function trace
 callback (x86_64 only so
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E436EDC.2080101@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <20110810163038.238028499@goodmis.org>  <4E436EDC.2080101@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Aug 2011 08:59:26 -0400
Message-ID: <1313067566.18583.288.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 14:55 +0900, Masami Hiramatsu wrote:
> (2011/08/11 1:22), Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Return as the 4th paramater to the function tracer callback the pt_regs.
> >
> > So far this is only supported by x86_64. The ftrace_ops flag
> > FTRACE_OPS_FL_SAVE_REGS is added to tell the arch to save all regs
> > to the pt_regs, otherwise a minimum is just passed back (the same
> > regs that is saved by mcount itself).
> 
> I guess it will be a bit hard to port this on x86-32, because
> on x86-32, the top of stack address in pt_regs is the address
> of sp member (e.g. &(pt_regs->sp)). I mean that when mcount-entry
> calls ftrace_caller, it pushes an address of the next instruction
> of mcount-entry on the top of stack.
> In that case, &(pt_regs->sp) points the entry which stores the
> address, instead of the return address of probed function.

I'm a little confused here. What is needed by kprobes handlers?

It should be no problem saving the sp member onto pt_regs of the time
mcount was called, and simulate the probe as if it was put on the nop.

> 
> e.g. with kprobes (on x86-32):
> 
> [  <bx>  ] <- pt_regs
> [  ...   ]
> [  <cs>  ]
> [<flags> ]
> [ret-addr] <- &(pt_regs.sp)
> [  arg1  ]
> [  arg2  ]
> 
> with this method:
> 
> [  <bx>  ] <- pt_regs
> [  ...   ]
> [  <cs>  ]
> [<flags> ]
> [mcount-ret] <- &(pt_regs.sp)
> [ret-addr]
> [  arg1  ]
> [  arg2  ]
> 
> I think this is hard to solve without a tricky hack.

Is this for handling kretprobes? With mcount, we shouldn't be doing that
because mcount is not the place that kretprobes should be doing this.
When we add __fentry__, the arch code will be different to handle that
and it shouldn't be too hard to make that work with kretprobes.

> 
> For example, on x86-32, MCOUNT_FRAME_SAVE saves
> flags on the entry which will be <cs> and it saves
> mcount-ret to local stack and moves flags to next entry.
> 
> <save-frame>
> pushf			# save flags on CS(%esp)
> subl $12, %esp		# skip ip, orig_ax and gs
> pushl %fs
> pushl %es
> ...
> pushl %ebx
> movl 56(%esp), %ebx	# load mcount-ret address
> movl 52(%esp), %ebp	# load flags
> movl %ebp, 56(%esp)	# store flags

Nope we don't do anything like this. I've already got x86_32 working
(but maybe it needs more for pt_regs->sp) but why is pushf needed?

-- Steve

> 
> call function (ebx is callee save)
> 
> <restore-frame>
> movl 56(%esp), %ebp	# load flags
> movl %ebp, 52(%esp)	# store flags
> movl %ebx, 56(%esp)	# load mcount-ret address
> ...
> popf
> ret
> 
> Hmm?
> 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  arch/x86/include/asm/ftrace.h     |   38 ++++++++++++++++++++----------------
> >  arch/x86/kernel/entry_64.S        |   23 +++++++++++++++++++++-
> >  include/linux/ftrace.h            |   15 ++++++++++++-
> >  kernel/trace/ftrace.c             |   29 ++++++++++++++++++---------
> >  kernel/trace/trace_events.c       |    2 +-
> >  kernel/trace/trace_functions.c    |    7 +++--
> >  kernel/trace/trace_irqsoff.c      |    2 +-
> >  kernel/trace/trace_sched_wakeup.c |    3 +-
> >  kernel/trace/trace_selftest.c     |   15 +++++++++----
> >  kernel/trace/trace_stack.c        |    3 +-
> >  10 files changed, 95 insertions(+), 42 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index b3fcf16..0750c2a 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -4,26 +4,29 @@
> >  #ifdef __ASSEMBLY__
> >
> >  	.macro MCOUNT_SAVE_FRAME
> > -	/* taken from glibc */
> > -	subq $0x38, %rsp
> > -	movq %rax, (%rsp)
> > -	movq %rcx, 8(%rsp)
> > -	movq %rdx, 16(%rsp)
> > -	movq %rsi, 24(%rsp)
> > -	movq %rdi, 32(%rsp)
> > -	movq %r8, 40(%rsp)
> > -	movq %r9, 48(%rsp)
> > +	 /*
> > +	  * We add enough stack to save all regs,
> > +	  * and we what we need in the location of pt_regs.
> > +	  */
> > +	subq $ORIG_RAX, %rsp
> > +	movq %rax, RAX(%rsp)
> > +	movq %rcx, RCX(%rsp)
> > +	movq %rdx, RDX(%rsp)
> > +	movq %rsi, RSI(%rsp)
> > +	movq %rdi, RDI(%rsp)
> > +	movq %r8, R8(%rsp)
> > +	movq %r9, R9(%rsp)
> >  	.endm
> >
> >  	.macro MCOUNT_RESTORE_FRAME
> > -	movq 48(%rsp), %r9
> > -	movq 40(%rsp), %r8
> > -	movq 32(%rsp), %rdi
> > -	movq 24(%rsp), %rsi
> > -	movq 16(%rsp), %rdx
> > -	movq 8(%rsp), %rcx
> > -	movq (%rsp), %rax
> > -	addq $0x38, %rsp
> > +	movq R9(%rsp), %r9
> > +	movq R8(%rsp), %r8
> > +	movq RDI(%rsp), %rdi
> > +	movq RSI(%rsp), %rsi
> > +	movq RDX(%rsp), %rdx
> > +	movq RCX(%rsp), %rcx
> > +	movq RAX(%rsp), %rax
> > +	addq $ORIG_RAX, %rsp
> >  	.endm
> >
> >  #endif
> > @@ -34,6 +37,7 @@
> >
> >  #if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
> >  #define ARCH_SUPPORTS_FTRACE_OPS 1
> > +#define ARCH_SUPPORTS_FTRACE_SAVE_REGS 1
> >  #endif
> >
> >  #ifndef __ASSEMBLY__
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 27adc2b..b77f297 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -78,7 +78,16 @@ ENTRY(ftrace_caller)
> 
> I can see below code before save frame.
> 
> 	cmpl $0, function_trace_stop
> 	jne  ftrace_stub
> 
> Please pushf before comparing it. :)
> Sometimes, the value of eflags is worth to watch.
> I know that SF/ZF will be never used between
> function call, so it is OK if the eflags is saved
> in MCOUNT_SAVE_FRAME.
> 
> >  	MCOUNT_SAVE_FRAME
> >
> >  	leaq function_trace_op, %rdx
> > -	movq 0x38(%rsp), %rdi
> > +
> > +	cmpl $0, ftrace_save_regs
> > +	jne  save_all_regs
> > +
> > +call_func:
> > +
> > +	/* regs go into 4th parameter */
> > +	leaq (%rsp), %rcx
> > +
> > +	movq ORIG_RAX(%rsp), %rdi
> >  	movq 8(%rbp), %rsi
> >  	subq $MCOUNT_INSN_SIZE, %rdi
> >
> > @@ -96,6 +105,18 @@ GLOBAL(ftrace_stub)
> >  	retq
> >  END(ftrace_caller)
> >
> > +save_all_regs:
> > +	/* Save the rest of pt_regs */
> > +	movq %r15, R15(%rsp)
> > +	movq %r14, R14(%rsp)
> > +	movq %r13, R13(%rsp)
> > +	movq %r12, R12(%rsp)
> > +	movq %r10, R10(%rsp)
> > +	movq %rbp, RBP(%rsp)
> > +	movq %rbx, RBX(%rsp)
> > +	jmp call_func
> 
> At least, pt_regs.sp must be saved for accessing
> vars on stack.
> 
> > +
> > +
> >  #else /* ! CONFIG_DYNAMIC_FTRACE */
> >  ENTRY(mcount)
> >  	cmpl $0, function_trace_stop
> 
> You also need to restore the rest of pt_regs if
> ftrace_save_regs is true.
> 
> Thank you,
> 


