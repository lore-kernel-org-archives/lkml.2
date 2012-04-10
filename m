Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2DJQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:56:25 -0400
Received: from trent.utfs.org ([94.185.90.103]:44352 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2DJQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:56:23 -0400
Date: Tue, 10 Apr 2012 09:56:07 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.0-rc1: No init found
In-Reply-To: <1334042632.3040.54.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1204100953400.3375@trent.utfs.org>
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org>  <1333440522.3040.9.camel@pasglop>  <alpine.DEB.2.01.1204030953320.4930@trent.utfs.org>  <4F7C4058.6090405@in.ibm.com>  <alpine.DEB.2.01.1204040944210.4930@trent.utfs.org>
 <1334042632.3040.54.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 at 17:23, Benjamin Herrenschmidt wrote:
> can you test the patch below ?

When applied to 3.4-rc2, Linux boots again, yay! :-)

   Tested-by: Christian Kujau <lists@nerdbynature.de>

Thanks!
Christian.

> From 08f1ec8a594c60bf3856e3c45b6d15fd691d90bb Mon Sep 17 00:00:00 2001
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 10 Apr 2012 17:21:35 +1000
> Subject: [PATCH] powerpc: Fix page fault with lockdep regression
> 
> commit a546498f3bf9aac311c66f965186373aee2ca0b0
> introduced a regression on 32-bit when irq tracing
> is enabled by exposing an old bug in our irq tracing
> code for exception entry.
> 
> The code would save and restore some GPRs around the
> calls to the C lockdep code, however, it tries to be
> too smart for its own good and restores some of the
> GPRs from the exception frame (as saved there on
> exception entry).
> 
> However, for page faults, we do replace those GPRs with
> arguments to do_page_fault before we call transfer_to_handler
> and so restoring from the exception frame is plain wrong in
> this case.
> 
> This was fine as long as we didn't touch the interrupt state
> when taking page fault, but when I started doing it, it would
> trigger the lockdep calls and the bug.
> 
> This fixes it by cleaning up that code a bit. It did create
> a small stack frame for the sake of backtraces, so let's
> make it a bit bigger and use it to save and restore the
> stuff we care about.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/kernel/entry_32.S |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
> index 3e57a00..ba3aeb4 100644
> --- a/arch/powerpc/kernel/entry_32.S
> +++ b/arch/powerpc/kernel/entry_32.S
> @@ -206,40 +206,43 @@ reenable_mmu:				/* re-enable mmu so we can */
>  	andi.	r10,r10,MSR_EE		/* Did EE change? */
>  	beq	1f
>  
> -	/* Save handler and return address into the 2 unused words
> -	 * of the STACK_FRAME_OVERHEAD (sneak sneak sneak). Everything
> -	 * else can be recovered from the pt_regs except r3 which for
> -	 * normal interrupts has been set to pt_regs and for syscalls
> -	 * is an argument, so we temporarily use ORIG_GPR3 to save it
> -	 */
> -	stw	r9,8(r1)
> -	stw	r11,12(r1)
> -	stw	r3,ORIG_GPR3(r1)
>  	/*
>  	 * The trace_hardirqs_off will use CALLER_ADDR0 and CALLER_ADDR1.
>  	 * If from user mode there is only one stack frame on the stack, and
>  	 * accessing CALLER_ADDR1 will cause oops. So we need create a dummy
>  	 * stack frame to make trace_hardirqs_off happy.
> +	 *
> +	 * This is handy because we also need to save a bunch of GPRs,
> +	 * r3 can be different from GPR3(r1) at this point, r9 and r11
> +	 * contains the old MSR and handler address respectively,
> +	 * r4 & r5 can contain page fault arguments that need to be passed
> +	 * along as well. r12, CCR, CTR, XER etc... are left clobbered as
> +	 * they aren't useful past this point (aren't syscall arguments),
> +	 * the rest is restored from the exception frame.
>  	 */
> +	stwu	r1,-32(r1)
> +	stw	r9,8(r1)
> +	stw	r11,12(r1)
> +	stw	r3,16(r1)
> +	stw	r4,20(r1)
> +	stw	r5,24(r1)
>  	andi.	r12,r12,MSR_PR
> -	beq	11f
> -	stwu	r1,-16(r1)
> +	b	11f
>  	bl	trace_hardirqs_off
> -	addi	r1,r1,16
>  	b	12f
> -
>  11:
>  	bl	trace_hardirqs_off
>  12:
> +	lwz	r5,24(r1)
> +	lwz	r4,20(r1)
> +	lwz	r3,16(r1)
> +	lwz	r11,12(r1)
> +	lwz	r9,8(r1)
> +	addi	r1,r1,32
>  	lwz	r0,GPR0(r1)
> -	lwz	r3,ORIG_GPR3(r1)
> -	lwz	r4,GPR4(r1)
> -	lwz	r5,GPR5(r1)
>  	lwz	r6,GPR6(r1)
>  	lwz	r7,GPR7(r1)
>  	lwz	r8,GPR8(r1)
> -	lwz	r9,8(r1)
> -	lwz	r11,12(r1)
>  1:	mtctr	r11
>  	mtlr	r9
>  	bctr				/* jump to handler */
> -- 
> 1.7.9.5
> 
-- 
BOFH excuse #292:

We ran out of dial tone and we're and waiting for the phone company to deliver another bottle.
