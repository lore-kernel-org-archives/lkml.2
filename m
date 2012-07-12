Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227Ab2GLPxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:53:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28196 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab2GLPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:53:48 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=kEgnM1vrZgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=F4dZniw7DhOjSGhZ70YA:9 a=PUjeQqilurYA:10 a=0Z2l2F6ITLjqO5gN:21 a=6O92X066t3RsTv7M:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1342108425.14868.4.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 12 Jul 2012 11:53:45 -0400
In-Reply-To: <4FFEC58E.5070202@hitachi.com>
References: <20120711195048.885039013@goodmis.org>
	 <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm slowly getting this patch set into working order ;-)


On Thu, 2012-07-12 at 21:39 +0900, Masami Hiramatsu wrote:
>  
> > +ENTRY(ftrace_regs_caller)
> > +	pushf	/* push flags before compare (in ss location) */
> > +	cmpl $0, function_trace_stop
> > +	jne ftrace_restore_flags
> > +
> > +	pushl %esp	/* Save stack in sp location */
> > +	subl $4, (%esp) /* Adjust saved stack to skip saved flags */
> > +	pushl 4(%esp)	/* Save flags in correct position */
> > +	movl $__KERNEL_DS, 8(%esp)	/* Save ss */
> > +	pushl $__KERNEL_CS
> > +	pushl 4*4(%esp)	/* Save the ip */
> > +	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
> > +	pushl $0	/* Load 0 into orig_ax */
> 
> Oops, you might forget that the i386's interrupt stack layout is a bit
> different from x86-64.
> 
> On x86-64, regs->sp directly points the top of stack.
> On the other hand (i386), regs->sp IS the top of stack. You can see
> below code in arch/x86/include/asm/ptrace.h
> ---
> /*
>  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
>  * when it traps.  The previous stack will be directly underneath the saved
>  * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
>  *
>  * This is valid only for kernel mode traps.
>  */
> static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> {
> #ifdef CONFIG_X86_32
>         return (unsigned long)(&regs->sp);
> #else
>         return regs->sp;
> #endif


Yuck yuck yuck!

> }
> ---
> 
> This means that you need a trick here.
> 
> 	 sp-> [retaddr]
> 	(*)-> [orig_stack]
> 
> Here is the stack layout when the ftrace_regs_caller is called.
> (*) points the original stack pointer. this means that regs->sp has
> placed at (*). After doing pushf, it changed as below.
> 
> 	                    (what user expects)
> 	 sp-> [flags]      <- regs.cs
> 	      [retaddr]    <- regs.flags
> 	(*)-> [orig_stack] <- regs.sp
> 
> So we have to change this stack layout as the user expected. That is
> what I did it in my previous series;

Yeah, I saw that you did this, but didn't fully understand why. I
completely forgot about that hack in x86_32 :-(

This is why I'm insisting to get your Reviewed-by, as you seem to be
more up-to-date on the subtleties between 32 and 64 than I am.
 
> 
> https://lkml.org/lkml/2012/6/5/119
> 
> In this patch, I clobbered the return address on the stack and
> stores it in the local stack because of that reason.
> 
> +	movl 14*4(%esp), %eax	/* Load return address */
> +	pushl %eax		/* Save return address (+4) */
> +	subl $MCOUNT_INSN_SIZE, %eax
> +	movl %eax, 12*4+4(%esp)	/* Store IP */
> +	movl 13*4+4(%esp), %edx	/* Load flags */
> +	movl %edx, 14*4+4(%esp)	/* Store flags */
> +	movl $__KERNEL_CS, %edx
> +	movl %edx, 13*4+4(%esp)

Well the change log does say that my patch set was influenced by your
code. I started to veer from that. I shouldn't have.
 
> 
> Thank you,
> 

No, thank you!

/me goes to work on v5.

-- Steve


