Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1GDHlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:41:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33153 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1GDHlL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 4 Jul 2011 03:41:11 -0400
Message-Id: <4E1185F3020000780004BF21@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 04 Jul 2011 08:20:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1309624184-9790-4-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> The save_regs function that saves the regs on low level
> irq entry is complicated because of the fact it changes
> its stack in the middle and also because it manipulates
> data allocated in the caller frame and accesses there
> are directly calculated from callee rsp value with the
> return address in the middle of the way.
> 
> This complicates the static stack offsets calculation and
> require more dynamic ones. It also needs a save/restore
> of the function's return address.
> 
> To simplify and optimize this, turn save_regs() into a
> macro.

So this got pulled out into a function a couple of releases ago,
and now it's being converted back? Wasn't the original patch's
intention to reduce the amount of duplication of generated
code?

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jan Beulich <JBeulich@novell.com>
> ---
>  arch/x86/kernel/entry_64.S |   44 +++++++++++++++++---------------------------
>  1 files changed, 17 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 8a445a0..b6b2e85 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -297,27 +297,22 @@ ENDPROC(native_usergs_sysret64)
>  	.endm
>  
>  /* save partial stack frame */
> -	.pushsection .kprobes.text, "ax"
> -ENTRY(save_args)
> -	XCPT_FRAME
> +	.macro SAVE_ARGS_IRQ
>  	cld
> -	/*
> -	 * start from rbp in pt_regs and jump over
> -	 * return address.
> -	 */
> -	movq_cfi rdi, RDI+8-RBP
> -	movq_cfi rsi, RSI+8-RBP
> -	movq_cfi rdx, RDX+8-RBP
> -	movq_cfi rcx, RCX+8-RBP
> -	movq_cfi rax, RAX+8-RBP
> -	movq_cfi  r8,  R8+8-RBP
> -	movq_cfi  r9,  R9+8-RBP
> -	movq_cfi r10, R10+8-RBP
> -	movq_cfi r11, R11+8-RBP
> -
> -	leaq -RBP+8(%rsp),%rdi	/* arg1 for handler */
> -	movq_cfi rbp, 8		/* push %rbp */
> -	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
> +	/* start from rbp in pt_regs and jump over */
> +	movq_cfi rdi, RDI-RBP
> +	movq_cfi rsi, RSI-RBP
> +	movq_cfi rdx, RDX-RBP
> +	movq_cfi rcx, RCX-RBP
> +	movq_cfi rax, RAX-RBP
> +	movq_cfi  r8,  R8-RBP
> +	movq_cfi  r9,  R9-RBP
> +	movq_cfi r10, R10-RBP
> +	movq_cfi r11, R11-RBP
> +
> +	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
> +	movq_cfi rbp, 0		/* push %rbp */
> +	movq %rsp, %rbp
>  	testl $3, CS(%rdi)
>  	je 1f
>  	SWAPGS
> @@ -329,19 +324,14 @@ ENTRY(save_args)
>  	 */
>  1:	incl PER_CPU_VAR(irq_count)
>  	jne 2f
> -	popq_cfi %rax			/* move return address... */
>  	mov PER_CPU_VAR(irq_stack_ptr),%rsp
>  	EMPTY_FRAME 0
>  	pushq_cfi %rbp			/* backlink for unwinder */
> -	pushq_cfi %rax			/* ... to the new stack */
>  	/*
>  	 * We entered an interrupt context - irqs are off:
>  	 */
>  2:	TRACE_IRQS_OFF
> -	ret
> -	CFI_ENDPROC
> -END(save_args)
> -	.popsection
> +	.endm
>  
>  ENTRY(save_rest)
>  	PARTIAL_FRAME 1 REST_SKIP+8
> @@ -791,7 +781,7 @@ END(interrupt)
>  	/* reserve pt_regs for scratch regs and rbp */
>  	subq $ORIG_RAX-RBP, %rsp
>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
> -	call save_args
> +	SAVE_ARGS_IRQ
>  	PARTIAL_FRAME 0

With the above CFI adjustments all looking correct, this PARTIAL_FRAME
directive now is at best redundant, and hence should be removed.

Jan

>  	call \func
>  	.endm




