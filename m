Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2IXN17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:27:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2IXN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:27:58 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=2m2QGXyeEZIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=EYgjXvPEHzMA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=awpZ77zks73WD0BlYj4A:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Date: Mon, 24 Sep 2012 09:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Salman Qazi <sqazi@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Don't clobber top of pt_regs in nested NMI
Message-ID: <20120924132753.GB21402@home.goodmis.org>
References: <20120919012935.23551.12099.stgit@dungbeetle.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919012935.23551.12099.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 06:29:35PM -0700, Salman Qazi wrote:
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

Hmm, interesting problem.

> 
> We solve this problem by introducing an extra copy of the iret
> registers that are exclusively a part of pt_regs and are not modified
> elsewhere.

Yuck, 4 copies of the stack frame?

> The downside is that the do_nmi function can no longer
> change the control flow, as any values it writes to these five
> registers will be discarded.

I consider this a feature.

> 
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  arch/x86/kernel/entry_64.S |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 69babd8..40ddb6d 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1724,6 +1724,18 @@ repeat_nmi:
>  end_repeat_nmi:
>  
>  	/*
> +	 * We went a running NMI handling routine to have a consistent
> +	 * picture of register state.  This should hold true even if
> +	 * there is a nested NMI.  Therefore, we let the nested NMI
> +	 * play with the previous copy of these registers and leave this
> +	 * new copy unmodified for do_nmi()
> +	 */
> +	.rept 5
> +	pushq_cfi 4*8(%rsp)
> +	.endr
> +	CFI_DEF_CFA_OFFSET SS+8-RIP

Hmm, another solution that can be done without an extra copy, is to swap
the return stack frame with the copy stack frame. This way, the copy is
seen by the pt_regs and will always be correct. The end would basically
be the same as you have below, just skip the copy and return.

Now this breaks the idea that anything below the sp pointer is not safe
to use. But this is the NMI stack in the controlled part of the NMI
Handler (no breakpoints allowed here). The NMI stack is special, which
is why we have all this crap in the first place.

It would be safe to save the copy stack below the stack pointer because
the only thing that could possible interrupt us here is another NMI,
which would just reset the stack pointer to the top again, and notice
that this is a nested NMI and return after modifying the return stack.
Which is OK.

At least this way, we avoid copying the stack frame a third time (two
was enough).

-- Steve


> +
> +	/*
>  	 * Everything below this point can be preempted by a nested
>  	 * NMI if the first NMI took an exception and reset our iret stack
>  	 * so that we repeat another NMI.
> @@ -1771,7 +1783,13 @@ nmi_swapgs:
>  nmi_restore:
>  	RESTORE_ALL 8
>  	/* Clear the NMI executing stack variable */
> -	movq $0, 10*8(%rsp)
> +	movq $0, 15*8(%rsp)
> +
> +	/* Pop the extra copy of iret context that was saved above
> +	 * just for do_nmi()
> +	 */
> +	addq $5*8, %rsp
> +
>  	jmp irq_return
>  	CFI_ENDPROC
>  END(nmi)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
