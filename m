Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab1BLKo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:44:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36752 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1BLKoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 05:44:21 -0500
Date: Sat, 12 Feb 2011 10:44:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/19] ARM: LPAE: Add context switching support
Message-ID: <20110212104400.GF15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-13-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-13-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:54PM +0000, Catalin Marinas wrote:
> +#ifdef CONFIG_ARM_LPAE
> +#define cpu_set_asid(asid) {						\
> +	unsigned long ttbl, ttbh;					\
> +	asm("	mrrc	p15, 0, %0, %1, c2		@ read TTBR0\n"	\
> +	    "	mov	%1, %1, lsl #(48 - 32)		@ set ASID\n"	\
> +	    "	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"	\
> +	    : "=r" (ttbl), "=r" (ttbh)					\
> +	    : "r" (asid & ~ASID_MASK));					\

This is wrong:
1. It does nothing with %2 (the new asid)
2. it shifts the high address bits of TTBR0 left 16 places each time its
   called.

> +}
> +#else
> +#define cpu_set_asid(asid) \
> +	asm("	mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (asid))
> +#endif
> +
>  /*
>   * We fork()ed a process, and we need a new context for the child
>   * to run in.  We reserve version 0 for initial tasks so we will
> @@ -37,7 +51,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  static void flush_context(void)
>  {
>  	/* set the reserved ASID before flushing the TLB */
> -	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (0));
> +	cpu_set_asid(0);
>  	isb();
>  	local_flush_tlb_all();
>  	if (icache_is_vivt_asid_tagged()) {
> @@ -99,7 +113,7 @@ static void reset_context(void *info)
>  	set_mm_context(mm, asid);
>  
>  	/* set the new ASID */
> -	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (mm->context.id));
> +	cpu_set_asid(mm->context.id);
>  	isb();
>  }
>  
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index a22b89f..ed4f3cb 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -117,6 +117,11 @@ ENTRY(cpu_v7_switch_mm)
>  #ifdef CONFIG_MMU
>  	mov	r2, #0
>  	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id

How about swapping the order here to avoid r1 being referenced in the very
next instruction?

> +#ifdef CONFIG_ARM_LPAE
> +	and	r3, r1, #0xff
> +	mov	r3, r3, lsl #(48 - 32)		@ ASID
> +	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
> +#else	/* !CONFIG_ARM_LPAE */
>  	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
>  	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
>  #ifdef CONFIG_ARM_ERRATA_430973
> @@ -124,9 +129,10 @@ ENTRY(cpu_v7_switch_mm)
>  #endif
>  	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
>  	isb
> -1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
> +	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
>  	isb
>  	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
> +#endif	/* CONFIG_ARM_LPAE */
>  	isb
>  #endif
>  	mov	pc, lr
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
