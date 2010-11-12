Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KLI0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:26:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35170 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0KLIZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:25:59 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "kmpark@infradead.org" <kmpark@infradead.org>,
        "konkers@android.com" <konkers@android.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        "avorontsov@mvista.com" <avorontsov@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srinidhikasagar@gmail.com" <srinidhikasagar@gmail.com>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 12 Nov 2010 13:55:25 +0530
Subject: RE: [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
Thread-Topic: [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
Thread-Index: AcuCQk6ASopku0I4TtS0ea8Ir4zYjwAAHcAw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB030D58AE84@dbde02.ent.ti.com>
References: <20101112082059.27221.52879.sendpatchset@t400s>
 <20101112082211.27221.47096.sendpatchset@t400s>
In-Reply-To: <20101112082211.27221.47096.sendpatchset@t400s>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Magnus Damm [mailto:magnus.damm@gmail.com]
> Sent: Friday, November 12, 2010 1:52 PM
> To: linux@arm.linux.org.uk
> Cc: kgene.kim@samsung.com; kmpark@infradead.org; konkers@android.com;
> tony@atomide.com; adharmap@codeaurora.org; avorontsov@mvista.com; linux-
> kernel@vger.kernel.org; srinidhikasagar@gmail.com; dwalker@codeaurora.org;
> Shilimkar, Santosh; ccross@android.com; olof@lixom.net; Magnus Damm;
> linux-arm-kernel@lists.infradead.org
> Subject: [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
> 
> From: Magnus Damm <damm@opensource.se>
> 
> Common GIC entry macro for omap
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> 
>  arch/arm/mach-omap2/include/mach/entry-macro.S |   92 ++++++++-----------
> -----
>  1 file changed, 31 insertions(+), 61 deletions(-)
> 
> --- 0001/arch/arm/mach-omap2/include/mach/entry-macro.S
> +++ work/arch/arm/mach-omap2/include/mach/entry-macro.S	2010-11-12
> 16:10:51.000000000 +0900
> @@ -105,6 +105,35 @@ omap_irq_base:	.word	0
>  9999:
>  		.endm
> 
> +#ifdef CONFIG_SMP
> +		/* We assume that irqstat (the raw value of the IRQ
> acknowledge
> +		 * register) is preserved from the macro above.
> +		 * If there is an IPI, we immediately signal end of interrupt
> +		 * on the controller, since this requires the original irqstat
> +		 * value which we won't easily be able to recreate later.
> +		 */
> +
> +		.macro test_for_ipi, irqnr, irqstat, base, tmp
> +		bic	\irqnr, \irqstat, #0x1c00
> +		cmp	\irqnr, #16
> +		it	cc
> +		strcc	\irqstat, [\base, #GIC_CPU_EOI]
> +		it	cs
> +		cmpcs	\irqnr, \irqnr
> +		.endm
> +
> +		/* As above, this assumes that irqstat and base are preserved
> */
> +
> +		.macro test_for_ltirq, irqnr, irqstat, base, tmp
> +		bic	\irqnr, \irqstat, #0x1c00
> +		mov 	\tmp, #0
> +		cmp	\irqnr, #29
> +		itt	eq
> +		moveq	\tmp, #1
> +		streq	\irqstat, [\base, #GIC_CPU_EOI]
> +		cmp	\tmp, #0
> +		.endm
> +#endif	/* CONFIG_SMP */
> 
>  #else	/* MULTI_OMAP2 */
> 
> @@ -141,74 +170,15 @@ omap_irq_base:	.word	0
> 
> 
>  #ifdef CONFIG_ARCH_OMAP4
> +#include <asm/hardware/entry-macro-gic.S>
> 
>  		.macro  get_irqnr_preamble, base, tmp
>  		ldr     \base, =OMAP4_IRQ_BASE
>  		.endm
> 
> -		/*
> -		 * The interrupt numbering scheme is defined in the
> -		 * interrupt controller spec.  To wit:
> -		 *
> -		 * Interrupts 0-15 are IPI
> -		 * 16-28 are reserved
> -		 * 29-31 are local.  We allow 30 to be used for the watchdog.
> -		 * 32-1020 are global
> -		 * 1021-1022 are reserved
> -		 * 1023 is "spurious" (no interrupt)
> -		 *
> -		 * For now, we ignore all local interrupts so only return an
> -		 * interrupt if it's between 30 and 1020.  The test_for_ipi
> -		 * routine below will pick up on IPIs.
> -		 * A simple read from the controller will tell us the number
> -		 * of the highest priority enabled interrupt.
> -		 * We then just need to check whether it is in the
> -		 * valid range for an IRQ (30-1020 inclusive).
> -		 */
> -		.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
> -		ldr     \irqstat, [\base, #GIC_CPU_INTACK]
> -
> -		ldr     \tmp, =1021
> -
> -		bic     \irqnr, \irqstat, #0x1c00
> -
> -		cmp     \irqnr, #29
> -		cmpcc   \irqnr, \irqnr
> -		cmpne   \irqnr, \tmp
> -		cmpcs   \irqnr, \irqnr
> -		.endm
>  #endif
> -#endif	/* MULTI_OMAP2 */
> -
> -#ifdef CONFIG_SMP
> -		/* We assume that irqstat (the raw value of the IRQ
> acknowledge
> -		 * register) is preserved from the macro above.
> -		 * If there is an IPI, we immediately signal end of interrupt
> -		 * on the controller, since this requires the original irqstat
> -		 * value which we won't easily be able to recreate later.
> -		 */
> -
> -		.macro test_for_ipi, irqnr, irqstat, base, tmp
> -		bic	\irqnr, \irqstat, #0x1c00
> -		cmp	\irqnr, #16
> -		it	cc
> -		strcc	\irqstat, [\base, #GIC_CPU_EOI]
> -		it	cs
> -		cmpcs	\irqnr, \irqnr
> -		.endm
> -
> -		/* As above, this assumes that irqstat and base are preserved
> */
> 
> -		.macro test_for_ltirq, irqnr, irqstat, base, tmp
> -		bic	\irqnr, \irqstat, #0x1c00
> -		mov 	\tmp, #0
> -		cmp	\irqnr, #29
> -		itt	eq
> -		moveq	\tmp, #1
> -		streq	\irqstat, [\base, #GIC_CPU_EOI]
> -		cmp	\tmp, #0
> -		.endm
> -#endif	/* CONFIG_SMP */
> +#endif	/* MULTI_OMAP2 */
> 
>  		.macro	irq_prio_table
>  		.endm
