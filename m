Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2BXOLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2BXOLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:11:54 -0500
Subject: Re: [PATCH] x86-64: fix CFI annotations for NMI nesting code
From: Steven Rostedt <srostedt@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4F478B630200007800074A31@nat28.tlf.novell.com>
References: <4F478B630200007800074A31@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 24 Feb 2012 09:11:30 -0500
Message-ID: <1330092690.3306.18.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 12:06 +0000, Jan Beulich wrote:
> The saving and restoring of %rdx wasn't annotated at all, and the
> jumping over sections where state gets partly restored wasn't handled
> either.
> 
> Further, by folding the pushing of the previous frame in repeat_nmi
> into that which so far was immediately preceding restart_nmi (after
> moving the restore of %rdx ahead of that, since it doesn't get used
> anymore when pushing prior frames), annotations of the replicated
> frame creations can be made consistent too.
> 
> Finally, the END()/CFI_ENDPROC marker of nmi should be at the very
> end, rather than giving repeat_nmi its own frame (as this isn't a
> separate function).

Thanks I really don't understand the CFI notations and I made a best
effort in doing so. But there's a bug in your approach to the update in
the repeat NMI changes.


> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> 
> ---
>  arch/x86/kernel/entry_64.S |   27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> --- 3.3-rc4/arch/x86/kernel/entry_64.S
> +++ 3.3-rc4-x86_64-nmi-cfi/arch/x86/kernel/entry_64.S
> @@ -1530,6 +1530,7 @@ ENTRY(nmi)
>  
>  	/* Use %rdx as out temp variable throughout */
>  	pushq_cfi %rdx
> +	CFI_REL_OFFSET rdx, 0
>  
>  	/*
>  	 * Check the special variable on the stack to see if NMIs are
> @@ -1547,6 +1548,7 @@ ENTRY(nmi)
>  	 */
>  	lea 6*8(%rsp), %rdx
>  	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
> +	CFI_REMEMBER_STATE
>  
>  nested_nmi:
>  	/*
> @@ -1578,10 +1580,12 @@ nested_nmi:
>  
>  nested_nmi_out:
>  	popq_cfi %rdx
> +	CFI_RESTORE rdx
>  
>  	/* No need to check faults here */
>  	INTERRUPT_RETURN
>  
> +	CFI_RESTORE_STATE
>  first_nmi:
>  	/*
>  	 * Because nested NMIs will use the pushed location that we
> @@ -1617,6 +1621,10 @@ first_nmi:
>  	 * NMI may zero out. The original stack frame and the temp storage
>  	 * is also used by nested NMIs and can not be trusted on exit.
>  	 */
> +	/* Do not pop rdx, nested NMIs will corrupt it */
> +	movq (%rsp), %rdx
> +	CFI_RESTORE rdx
> +
>  	/* Set the NMI executing variable on the stack. */
>  	pushq_cfi $1
>  
> @@ -1624,14 +1632,14 @@ first_nmi:
>  	.rept 5
>  	pushq_cfi 6*8(%rsp)
>  	.endr
> +	CFI_DEF_CFA_OFFSET SS+8-RIP
>  
> +restart_nmi:

So we jump back to here after from a repeat_nmi because we had a nested
NMI. But NMIs are still enabled and the special variable is set. That
means we can take another nested NMI.

>  	/* Make another copy, this one may be modified by nested NMIs */
>  	.rept 5
>  	pushq_cfi 4*8(%rsp)

Half way through this copy (the rept is not atomic) we get an NMI, it
sees that we are nested so it updates this copy of the interrupt frame
and returns. Now the rest of the copy finishes so we end up with a half
and half stack frame (half to go back to restart_nmi and half to go back
to the original location of the stack). The result is a system crash.

But! There is a fix to this. We can move the setting of the special
variable to here and make this the "repeart_nmi" instead. The nested NMI
checks that we are not in the repeat nmi before updating the stack. If
it interrupted in the repeat nmi it will just return knowing a repeat is
about to take place anyway.


So instead of adding restart_nmi here, add:

repeat_nmi:
	/* Update the stack variable to say we are in NMI */
	movq $1, 5*8(%rsp)
	
	/* Make another copy, this one may be modified by nested NMIs */
	.rept 5
	pushq_cfi 4*8(%rsp)
end_repeat_nmi:


And just continue. We only need to protect against updating the stack
and the nested NMI will not touch it if it interrupted RIP is between
repeat_nmi and end_repeat_nmi. But there's no reason that we can't just
set the iret jump to go back into the middle of the NMI handler.

Would that work for you?

Also we need to add a comment about this. Just above the repeat_nmi:

	/*
	 * If there was a nested NMI, the first NMI's iret will return
	 * here. But NMIs are still enabled and we can take another
	 * nested NMI. The nested NMI checks the interrupted RIP to see
	 * if it is between repeat_nmi and end_repeat_nmi, and if so
	 * it will just return, as we are about to repeat an NMI anyway.
	 * This makes it safe to copy to the stack frame that a nested
	 * NMI will update.
	 */


-- Steve

>  	.endr
> -
> -	/* Do not pop rdx, nested NMIs will corrupt it */
> -	movq 11*8(%rsp), %rdx
> +	CFI_DEF_CFA_OFFSET SS+8-RIP
>  
>  	/*
>  	 * Everything below this point can be preempted by a nested
> @@ -1639,7 +1647,6 @@ first_nmi:
>  	 * caused by an exception and nested NMI will start here, and
>  	 * can still be preempted by another NMI.
>  	 */
> -restart_nmi:
>  	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
>  	subq $ORIG_RAX-R15, %rsp
>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
> @@ -1665,8 +1672,6 @@ nmi_restore:
>  	/* Clear the NMI executing stack variable */
>  	movq $0, 10*8(%rsp)
>  	jmp irq_return
> -	CFI_ENDPROC
> -END(nmi)
>  
>  	/*
>  	 * If an NMI hit an iret because of an exception or breakpoint,
> @@ -1675,18 +1680,12 @@ END(nmi)
>  	 * stack to jump to here when it does the final iret.
>  	 */
>  repeat_nmi:
> -	INTR_FRAME
>  	/* Update the stack variable to say we are still in NMI */
>  	movq $1, 5*8(%rsp)
> -
> -	/* copy the saved stack back to copy stack */
> -	.rept 5
> -	pushq_cfi 4*8(%rsp)
> -	.endr
> -
>  	jmp restart_nmi
> -	CFI_ENDPROC
>  end_repeat_nmi:
> +	CFI_ENDPROC
> +END(nmi)
>  
>  ENTRY(ignore_sysret)
>  	CFI_STARTPROC
> 
> 
> 


