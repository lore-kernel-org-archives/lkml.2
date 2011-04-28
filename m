Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1D1Xkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:40:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1D1Xkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:40:40 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=HyJjte3XNWIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=ZLqj0RqdLVjB4d_1mQgA:9 a=NTNx5uBN8zreXELVIXoA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] x86: Change trap definitions to enumerated values
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Aditya Kali <adityakali@google.com>
In-Reply-To: <1303513438-26519-2-git-send-email-vnagarnaik@google.com>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
	 <1303513438-26519-2-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 19:40:37 -0400
Message-ID: <1304034037.18763.217.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 16:03 -0700, Vaibhav Nagarnaik wrote:
> From: Aditya Kali <adityakali@google.com>
> 
> The traps are referred to by their numbers and it can be difficult to
> understand them while reading the code without context. This patch adds
> enumeration of the trap numbers and replaced the numbers to the correct
> enum for x86.

I actually like this patch, as I find floating numbers in code annoying.

> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---


> -DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
> -DO_ERROR(4, SIGSEGV, "overflow", overflow)
> -DO_ERROR(5, SIGSEGV, "bounds", bounds)
> -DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
> -DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
> -DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
> -DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
> +DO_ERROR_INFO(INTR_DIV_BY_ZERO, SIGFPE, "divide error", divide_error,
> +		FPE_INTDIV, regs->ip)
> +DO_ERROR(INTR_OVERFLOW, SIGSEGV, "overflow", overflow)
> +DO_ERROR(INTR_BOUNDS_CHECK, SIGSEGV, "bounds", bounds)
> +DO_ERROR_INFO(INTR_INVALID_OP, SIGILL, "invalid opcode", invalid_op,
> +		ILL_ILLOPN, regs->ip)
> +DO_ERROR(INTR_SEG_OVERRUN, SIGFPE, "coprocessor segment overrun",
> +		coprocessor_segment_overrun)
> +DO_ERROR(INTR_INVALID_TSS, SIGSEGV, "invalid TSS", invalid_TSS)
> +DO_ERROR(INTR_NO_SEG, SIGBUS, "segment not present", segment_not_present)
>  #ifdef CONFIG_X86_32
> -DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
> +DO_ERROR(INTR_STACK_FAULT, SIGBUS, "stack segment", stack_segment)
>  #endif
> -DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
> +DO_ERROR_INFO(INTR_ALIGNMENT, SIGBUS, "alignment check", alignment_check,
> +		BUS_ADRALN, 0)

Could you format the above to make it look more tabular and easier to
read.

>  #ifdef CONFIG_X86_32
> @@ -833,10 +844,10 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>  /* Set of traps needed for early debugging. */
>  void __init early_trap_init(void)
>  {
> -	set_intr_gate_ist(1, &debug, DEBUG_STACK);
> +	set_intr_gate_ist(INTR_DEBUG, &debug, DEBUG_STACK);
>  	/* int3 can be called from all */
> -	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
> -	set_intr_gate(14, &page_fault);
> +	set_system_intr_gate_ist(INTR_BREAKPOINT, &int3, DEBUG_STACK);
> +	set_intr_gate(INTR_PAGE_FAULT, &page_fault);
>  	load_idt(&idt_descr);
>  }
>  
> @@ -852,30 +863,30 @@ void __init trap_init(void)
>  	early_iounmap(p, 4);
>  #endif
>  
> -	set_intr_gate(0, &divide_error);
> -	set_intr_gate_ist(2, &nmi, NMI_STACK);
> +	set_intr_gate(INTR_DIV_BY_ZERO, &divide_error);
> +	set_intr_gate_ist(INTR_NMI, &nmi, NMI_STACK);
>  	/* int4 can be called from all */
> -	set_system_intr_gate(4, &overflow);
> -	set_intr_gate(5, &bounds);
> -	set_intr_gate(6, &invalid_op);
> -	set_intr_gate(7, &device_not_available);
> +	set_system_intr_gate(INTR_OVERFLOW, &overflow);
> +	set_intr_gate(INTR_BOUNDS_CHECK, &bounds);
> +	set_intr_gate(INTR_INVALID_OP, &invalid_op);
> +	set_intr_gate(INTR_NO_DEV, &device_not_available);
>  #ifdef CONFIG_X86_32
> -	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
> +	set_task_gate(INTR_DBL_FAULT, GDT_ENTRY_DOUBLEFAULT_TSS);
>  #else
> -	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
> +	set_intr_gate_ist(INTR_DBL_FAULT, &double_fault, DOUBLEFAULT_STACK);
>  #endif
> -	set_intr_gate(9, &coprocessor_segment_overrun);
> -	set_intr_gate(10, &invalid_TSS);
> -	set_intr_gate(11, &segment_not_present);
> -	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
> -	set_intr_gate(13, &general_protection);
> -	set_intr_gate(15, &spurious_interrupt_bug);
> -	set_intr_gate(16, &coprocessor_error);
> -	set_intr_gate(17, &alignment_check);
> +	set_intr_gate(INTR_SEG_OVERRUN, &coprocessor_segment_overrun);
> +	set_intr_gate(INTR_INVALID_TSS, &invalid_TSS);
> +	set_intr_gate(INTR_NO_SEG, &segment_not_present);
> +	set_intr_gate_ist(INTR_STACK_FAULT, &stack_segment, STACKFAULT_STACK);
> +	set_intr_gate(INTR_GPF, &general_protection);
> +	set_intr_gate(INTR_SPURIOUS, &spurious_interrupt_bug);
> +	set_intr_gate(INTR_COPROCESSOR, &coprocessor_error);
> +	set_intr_gate(INTR_ALIGNMENT, &alignment_check);
>  #ifdef CONFIG_X86_MCE
> -	set_intr_gate_ist(18, &machine_check, MCE_STACK);
> +	set_intr_gate_ist(INTR_MCE, &machine_check, MCE_STACK);
>  #endif
> -	set_intr_gate(19, &simd_coprocessor_error);
> +	set_intr_gate(INTR_SIMD_COPROCESSOR, &simd_coprocessor_error);

Could you format these too, maybe even ignore the 80 char limit if it
makes it look better.

The numbers were all one or two characters in length and kept the second
argument easy to read. Now with the larger delta in the difference of
characters, it puts a strain on ones eyes.

-- Steve

>  
>  	/* Reserve all the builtin and the syscall vector: */
>  	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)


