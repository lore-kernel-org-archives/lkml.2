Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1FMN47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:56:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47469 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1FMN4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:56:54 -0400
Date: Mon, 13 Jun 2011 14:56:49 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Frank Hofmann <frank.hofmann@tomtom.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v5] ARM hibernation / suspend-to-disk (fwd)
Message-ID: <20110613135649.GB8498@arm.com>
References: <alpine.DEB.2.00.1106131303290.25153@localhost6.localdomain6>
 <20110613122601.GC12325@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106131400090.25153@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106131400090.25153@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 02:20:12PM +0100, Frank Hofmann wrote:
> 
> 
> On Mon, 13 Jun 2011, Russell King - ARM Linux wrote:
> 
> >On Mon, Jun 13, 2011 at 01:04:02PM +0100, Frank Hofmann wrote:
> >>  To make it clear: IF AND ONLY IF your suspend(-to-ram) func looks like:
> >>
> >>	ENTRY(acmeSoC_cpu_suspend)
> >>		stmfd	sp!, {r4-r12,lr}
> >>		ldr	r3, resume_mmu_done
> >>		bl	cpu_suspend
> >>	resume_mmu_done:
> >>		ldmfd	sp!, {r3-r12,pc}
> >>	ENDPROC(acmeSoC_cpu_suspend)
> >
> >Nothing has that - because you can't execute that ldmfd after the call
> >to cpu_suspend returns.  I don't think you've understood what I said on
> >that subject in the previous thread.
> >
> 
> Ok, to illustrate a bit more, what is ok and what not.
> 
> 
> From the current code ...
> 
> a) a case where the hibernation patch as I posted it is ok for core state:
> 
> arch/arm/mach-exynos4/sleep.S has:
> 
> ENTRY(s3c_cpu_save)
> 
>         stmfd   sp!, { r3 - r12, lr }
>         ldr     r3, =resume_with_mmu
>         bl      cpu_suspend
> 
>         ldr     r0, =pm_cpu_sleep
>         ldr     r0, [ r0 ]
>         mov     pc, r0
> 
> resume_with_mmu:
>         ldmfd   sp!, { r3 - r12, pc }
> 
> ENTRY(s3c_cpu_resume)
>         b       cpu_resume
> 
> 
> I.e. it does nothing before but set up the arguments for
> cpu_suspend, and does nothing afterwards but redirect to a function
> that enters low power (and switches the CPU off).
> Likewise, all it does for resume is redirect to cpu_resume which
> will ultimately end up jumping to resume_with_mmu: as requested.
> 
> 
> b) a case where the hibernation patch is insufficient even though the
>    code in the soc suspend func uses cpu_suspend:
> 
> arch/arm/mach-pxa/sleep.S has:
> 
> /*
>  * pxa27x_cpu_suspend()
>  *
>  * Forces CPU into sleep state.
>  *
>  * r0 = value for PWRMODE M field for desired sleep state
>  * r1 = v:p offset
>  */
> ENTRY(pxa27x_cpu_suspend)
> 
> #ifndef CONFIG_IWMMXT
>         mra     r2, r3, acc0
> #endif
>         stmfd   sp!, {r2 - r12, lr}             @ save registers on stack
>         mov     r4, r0                          @ save sleep mode
>         ldr     r3, =pxa_cpu_resume             @ resume function
>         bl      cpu_suspend
> [ ... some stuff ... ]
>         ldr     r6, =CCCR
>         ldr     r8, [r6]                @ keep original value for resume
> 
>         ldr     r7, =CCCR_SLEEP         @ prepare CCCR sleep value
>         mov     r0, #0x2                @ prepare value for CLKCFG
> 
>         @ align execution to a cache line
>         b       pxa_cpu_do_suspend
> #endif
> [ ... ]
> pxa_cpu_do_suspend:
> 
>         @ All needed values are now in registers.
>         @ These last instructions should be in cache
> 
>         @ initiate the frequency change...
>         str     r7, [r6]
>         mcr     p14, 0, r0, c6, c0, 0
> 
>         @ restore the original cpu speed value for resume
>         str     r8, [r6]
> [ ... ]
> /*
>  * pxa_cpu_resume()
>  *
>  * entry point from bootloader into kernel during resume
>  */
>         .align 5
> pxa_cpu_resume:
>         ldmfd   sp!, {r2, r3}
> #ifndef CONFIG_IWMMXT
>         mar     acc0, r2, r3
> #endif
>         ldmfd   sp!, {r4 - r12, pc}             @ return to caller
> 
> 
> 
> In this case, there's _MORE_ state saved (the CCCR / CCCR_SLEEP
> accesses) after the call to cpu_suspend things that aren't dealt
> with by the way the hibernation support patch currently operates.
> 
> There also is _more_ restored at resume than what the generic part
> does for you.
> 
> Whether these things (for example) are relevant wrt. to a
> hibernation resume is something I simply do not know.
> 
> 
> A third example of a soc suspend func, even more complex, with more
> constraints, would be as already mentioned, OMAP. On that as well
> the caveat applies, "what works empirically might not be correct in
> all cases".

Santosh, Frank: to what extent do you think the OMAP suspend code could
be abstracted using something like Colin's CPU pm notifier framework?

I'd hope that at least some stuff can be abstracted out, but I don't
understand the OMAP code intimately enough to be certain of that...

We shouldn't expect to remove absolutely all the SoC specifics from
suspend code, but the more we can hook into a generic framework, the
better for everyone.

Cheers
---Dave
