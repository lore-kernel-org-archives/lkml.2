Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2BMSJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:09:11 -0500
Received: from relais.videotron.ca ([24.201.245.36]:59881 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2BMSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:09:09 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_DzOys4NRwkzW64gZRYqoSw)"
Date: Mon, 13 Feb 2012 13:09:08 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Rabin Vincent <rabin@rab.in>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
In-reply-to: <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1202131307430.24536@xanadu.home>
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home>
 <1328234629-32735-1-git-send-email-sboyd@codeaurora.org>
 <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_DzOys4NRwkzW64gZRYqoSw)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Mon, 13 Feb 2012, Rabin Vincent wrote:

> On Fri, Feb 3, 2012 at 07:33, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > armv7's flush_cache_all() flushes caches via set/way. To
> > determine the cache attributes (line size, number of sets,
> > etc.) the assembly first writes the CSSELR register to select a
> > cache level and then reads the CCSIDR register. The CSSELR register
> > is banked per-cpu and is used to determine which cache level CCSIDR
> > reads. If the task is migrated between when the CSSELR is written and
> > the CCSIDR is read the CCSIDR value may be for an unexpected cache
> > level (for example L1 instead of L2) and incorrect cache flushing
> > could occur.
> >
> > Disable interrupts across the write and read so that the correct
> > cache attributes are read and used for the cache flushing
> > routine. We disable interrupts instead of disabling preemption
> > because the critical section is only 3 instructions and we want
> > to call v7_dcache_flush_all from __v7_setup which doesn't have a
> > full kernel stack with a struct thread_info.
> >
> > This fixes a problem we see in scm_call() when flush_cache_all()
> > is called from preemptible context and sometimes the L2 cache is
> > not properly flushed out.
> >
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Nicolas Pitre <nico@fluxnic.net>
> > ---
> > diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> > index 07c4bc8..654a5fc 100644
> > --- a/arch/arm/mm/cache-v7.S
> > +++ b/arch/arm/mm/cache-v7.S
> > @@ -54,9 +54,15 @@ loop1:
> >        and     r1, r1, #7                      @ mask of the bits for current cache only
> >        cmp     r1, #2                          @ see what cache we have at this level
> >        blt     skip                            @ skip if no cache, or just i-cache
> > +#ifdef CONFIG_PREEMPT
> > +       save_and_disable_irqs r9                @ make cssr&csidr read atomic
> > +#endif
> >        mcr     p15, 2, r10, c0, c0, 0          @ select current cache level in cssr
> >        isb                                     @ isb to sych the new cssr&csidr
> >        mrc     p15, 1, r1, c0, c0, 0           @ read the new csidr
> > +#ifdef CONFIG_PREEMPT
> > +       restore_irqs r9
> > +#endif
> >        and     r2, r1, #7                      @ extract the length of the cache lines
> >        add     r2, r2, #4                      @ add 4 (line length offset)
> >        ldr     r4, =0x3ff
> 
> This patch breaks the kernel boot when lockdep is enabled.
> 
> v7_setup (called before the MMU is enabled) calls v7_flush_dcache_all,
> and the save_and_disable_irqs added by this patch ends up calling
> into lockdep C code (trace_hardirqs_off()) when we are in no position
> to execute it (no stack, no MMU).
> 
> The following fixes it.  Perhaps it can be folded in?

Absolutely.  

No tracing what so ever should be involved here.

> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index 62f8095..23371b1 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -137,6 +137,11 @@
>  	disable_irq
>  	.endm
> 
> +	.macro	save_and_disable_irqs_notrace, oldcpsr
> +	mrs	\oldcpsr, cpsr
> +	disable_irq_notrace
> +	.endm
> +
>  /*
>   * Restore interrupt state previously stored in a register.  We don't
>   * guarantee that this will preserve the flags.
> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> index 7a24d396..a655d3d 100644
> --- a/arch/arm/mm/cache-v7.S
> +++ b/arch/arm/mm/cache-v7.S
> @@ -55,7 +55,7 @@ loop1:
>  	cmp	r1, #2				@ see what cache we have at this level
>  	blt	skip				@ skip if no cache, or just i-cache
>  #ifdef CONFIG_PREEMPT
> -	save_and_disable_irqs r9		@ make cssr&csidr read atomic
> +	save_and_disable_irqs_notrace r9	@ make cssr&csidr read atomic
>  #endif
>  	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
>  	isb					@ isb to sych the new cssr&csidr
> 

--Boundary_(ID_DzOys4NRwkzW64gZRYqoSw)--
