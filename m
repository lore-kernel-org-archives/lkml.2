Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2CIJ3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:29:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2CIJ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:29:17 -0500
Date: Fri, 9 Mar 2012 10:28:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120309092845.GA10281@elte.hu>
References: <20120309074202.GA28609@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309074202.GA28609@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> The traps are referred to by their numbers and it can be difficult to
> understand them while reading the code without context. This patch adds
> enumeration of the trap numbers and replaces the numbers with the correct
> enum for x86.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> ---
> I've updated Aditya Kali's earlier patch:
> https://lkml.org/lkml/2011/4/22/328
> ---
>  arch/x86/include/asm/traps.h |   25 +++++++++
>  arch/x86/kernel/irqinit.c    |    2 +-
>  arch/x86/kernel/traps.c      |  117 ++++++++++++++++++++++--------------------
>  3 files changed, 88 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 0012d09..768afb2 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
>  asmlinkage void mce_threshold_interrupt(void);
>  #endif
>  
> +/* Interrupts/Exceptions */
> +enum {
> +	INTR_DIV_BY_ZERO = 0,	/*  0 */
> +	INTR_DEBUG,		/*  1 */
> +	INTR_NMI,		/*  2 */
> +	INTR_BREAKPOINT,	/*  3 */
> +	INTR_OVERFLOW,		/*  4 */
> +	INTR_BOUNDS_CHECK,	/*  5 */
> +	INTR_INVALID_OP,	/*  6 */
> +	INTR_NO_DEV,		/*  7 */
> +	INTR_DBL_FAULT,		/*  8 */
> +	INTR_SEG_OVERRUN,	/*  9 */
> +	INTR_INVALID_TSS,	/* 10 */
> +	INTR_NO_SEG,		/* 11 */
> +	INTR_STACK_FAULT,	/* 12 */
> +	INTR_GPF,		/* 13 */
> +	INTR_PAGE_FAULT,	/* 14 */
> +	INTR_SPURIOUS,		/* 15 */
> +	INTR_COPROCESSOR,	/* 16 */
> +	INTR_ALIGNMENT,		/* 17 */
> +	INTR_MCE,		/* 18 */
> +	INTR_SIMD_COPROCESSOR,	/* 19 */
> +	INTR_IRET = 32,		/* 32 */
> +};

> @@ -453,14 +458,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  /*
>   * Note that we play around with the 'TS' bit in an attempt to get
>   * the correct behaviour even in the presence of the asynchronous
> - * IRQ13 behaviour
> + * INTR_GPF behaviour
>   */

> @@ -529,8 +535,9 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
>  		info.si_code = FPE_FLTRES;
>  	} else {
>  		/*
> -		 * If we're using IRQ 13, or supposedly even some trap 16
> -		 * implementations, it's possible we get a spurious trap...
> +		 * If we're using INTR_GPF, or supposedly even some trap
> +		 * INTR_COPROCESSOR implementations, it's possible we get a
> +		 * spurious trap...

There's confusion in this patch between legacy IRQ #13 [vector 
0x20 + 13 ] and #GPF general protection fault [vector 13] - they 
are not the same.

Furthermore, the INTR_ naming is not ideal either for (most of) 
these entries: for example we don't think of a page fault as an 
asynchronous interrupt entity - we think of it as a more or less 
synchronous fault/exception.

Thus a X86_*_FAULT_VEC naming pattern might be better:

	X86_PAGE_FAULT_VEC
	X86_DOUBLE_FAULT_VEC

(With X86_*_EXCEPTION_VEC applied where appropriate.)

I don't disagree with the general principle of the cleanup 
otherwise, the numeric literals are often ambiguous and 
confusing - as the trap 13 - irq 13 mixup above shows.

Thanks,

	Ingo
