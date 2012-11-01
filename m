Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328Ab2KABEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:04:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25591 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2KABEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:04:35 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EaluEUCYuSkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=U_9UZLlTPtUA:10 a=1XWaLZrsAAAA:8 a=ayC55rCoAAAA:8 a=o1OHuDzbAAAA:8 a=CkexhqMxYUe-tZN3LZ4A:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=ILCZio5HsAgA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351731872.4004.112.camel@gandalf.local.home>
Subject: Re: [PATCH] [PATCH] x86: Don't clobber top of pt_regs in nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Salman Qazi <sqazi@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Date: Wed, 31 Oct 2012 21:04:32 -0400
In-Reply-To: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
References: <20121002002919.27236.14388.stgit@dungbeetle.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 17:29 -0700, Salman Qazi wrote:
> The nested NMI modifies the place (instruction, flags and stack)
> that the first NMI will iret to.  However, the copy of registers
> modified is exactly the one that is the part of pt_regs in
> the first NMI.  This can change the behaviour of the first NMI.
> 
> In particular, Google's arch_trigger_all_cpu_backtrace handler
> also prints regions of memory surrounding addresses appearing in
> registers.  This results in handled exceptions, after which nested NMIs
> start coming in.  These nested NMIs change the value of registers
> in pt_regs.  This can cause the original NMI handler to produce
> incorrect output.
> 
> We solve this problem by interchanging the position of the preserved
> copy of the iret registers ("saved") and the copy subject to being
> trampled by nested NMI ("copied").
> 

I was all ready to push this forward, but on my last final review I
found some nits that prevent me from doing so.

> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  arch/x86/kernel/entry_64.S |   41 +++++++++++++++++++++++++++--------------
>  1 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 44531ac..b5d6e43 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1739,9 +1739,10 @@ nested_nmi:
>  
>  1:
>  	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
> -	leaq -6*8(%rsp), %rdx
> +	leaq -1*8(%rsp), %rdx
>  	movq %rdx, %rsp
> -	CFI_ADJUST_CFA_OFFSET 6*8
> +	CFI_ADJUST_CFA_OFFSET 1*8
> +	leaq -10*8(%rsp), %rdx
>  	pushq_cfi $__KERNEL_DS
>  	pushq_cfi %rdx
>  	pushfq_cfi
> @@ -1749,8 +1750,8 @@ nested_nmi:
>  	pushq_cfi $repeat_nmi
>  
>  	/* Put stack back */
> -	addq $(11*8), %rsp
> -	CFI_ADJUST_CFA_OFFSET -11*8
> +	addq $(6*8), %rsp
> +	CFI_ADJUST_CFA_OFFSET -6*8
>  
>  nested_nmi_out:
>  	popq_cfi %rdx
> @@ -1776,18 +1777,18 @@ first_nmi:
>  	 * +-------------------------+
>  	 * | NMI executing variable  |
>  	 * +-------------------------+
> -	 * | Saved SS                |
> -	 * | Saved Return RSP        |
> -	 * | Saved RFLAGS            |
> -	 * | Saved CS                |
> -	 * | Saved RIP               |
> -	 * +-------------------------+
>  	 * | copied SS               |
>  	 * | copied Return RSP       |
>  	 * | copied RFLAGS           |
>  	 * | copied CS               |
>  	 * | copied RIP              |
>  	 * +-------------------------+
> +	 * | Saved SS                |
> +	 * | Saved Return RSP        |
> +	 * | Saved RFLAGS            |
> +	 * | Saved CS                |
> +	 * | Saved RIP               |
> +	 * +-------------------------+
>  	 * | pt_regs                 |
>  	 * +-------------------------+
>  	 *
> @@ -1803,9 +1804,14 @@ first_nmi:
>  	/* Set the NMI executing variable on the stack. */
>  	pushq_cfi $1
>  
> +	/*
> +	 * Leave room for the "copied" frame
> +	 */
> +	subq $(5*8), %rsp
> +
>  	/* Copy the stack frame to the Saved frame */
>  	.rept 5
> -	pushq_cfi 6*8(%rsp)
> +	pushq_cfi 11*8(%rsp)
>  	.endr
>  	CFI_DEF_CFA_OFFSET SS+8-RIP
>  
> @@ -1826,12 +1832,15 @@ repeat_nmi:
>  	 * is benign for the non-repeat case, where 1 was pushed just above
>  	 * to this very stack slot).
>  	 */
> -	movq $1, 5*8(%rsp)
> +	movq $1, 10*8(%rsp)
>  
>  	/* Make another copy, this one may be modified by nested NMIs */
> +	addq $(10*8), %rsp

This breaks the CFI magic.

>  	.rept 5
> -	pushq_cfi 4*8(%rsp)
> +	pushq_cfi -6*8(%rsp)
>  	.endr
> +	subq $(5*8), %rsp

So does this.

This needs to be annotated correctly before I can push it out. But the
good news is, I stressed tested this change, and it all works out.

Jan, can you help out here?

-- Steve

> +
>  	CFI_DEF_CFA_OFFSET SS+8-RIP
>  end_repeat_nmi:
>  
> @@ -1882,8 +1891,12 @@ nmi_swapgs:
>  	SWAPGS_UNSAFE_STACK
>  nmi_restore:
>  	RESTORE_ALL 8
> +
> +	/* Pop the extra iret frame */
> +	addq $(5*8), %rsp
> +
>  	/* Clear the NMI executing stack variable */
> -	movq $0, 10*8(%rsp)
> +	movq $0, 5*8(%rsp)
>  	jmp irq_return
>  	CFI_ENDPROC
>  END(nmi)


