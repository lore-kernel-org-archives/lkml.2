Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1C1AjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 20:39:19 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:61659 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1C1AjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 20:39:18 -0400
Message-ID: <4D8FD892.3040200@snapgear.com>
Date: Mon, 28 Mar 2011 10:38:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: m68knommu: Convert to new irq function names
References: <alpine.LFD.2.00.1103251443180.31464@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103251443180.31464@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 25/03/11 23:44, Thomas Gleixner wrote:
> Scripted conversion with coccinelle.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>

Looks good, and works fine after reworking for the m68k/m68knommu
merge. Do you want me to carry it for 2.6.40?

Regards
Greg


> ---
>   arch/m68knommu/kernel/irq.c                  |    2 +-
>   arch/m68knommu/platform/5249/intc2.c         |    4 ++--
>   arch/m68knommu/platform/5272/intc.c          |   12 ++++++------
>   arch/m68knommu/platform/68328/ints.c         |    4 ++--
>   arch/m68knommu/platform/68360/ints.c         |    4 ++--
>   arch/m68knommu/platform/coldfire/intc-2.c    |   10 +++++-----
>   arch/m68knommu/platform/coldfire/intc-simr.c |   10 +++++-----
>   arch/m68knommu/platform/coldfire/intc.c      |    6 +++---
>   8 files changed, 26 insertions(+), 26 deletions(-)
>
> Index: linux-2.6-tip/arch/m68knommu/kernel/irq.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/kernel/irq.c
> +++ linux-2.6-tip/arch/m68knommu/kernel/irq.c
> @@ -44,7 +44,7 @@ int show_interrupts(struct seq_file *p,
>   		if (ap) {
>   			seq_printf(p, "%3d: ", irq);
>   			seq_printf(p, "%10u ", kstat_irqs(irq));
> -			seq_printf(p, "%14s  ", get_irq_desc_chip(desc)->name);
> +			seq_printf(p, "%14s  ", irq_desc_get_chip(desc)->name);
>
>   			seq_printf(p, "%s", ap->name);
>   			for (ap = ap->next; ap; ap = ap->next)
> Index: linux-2.6-tip/arch/m68knommu/platform/5249/intc2.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/5249/intc2.c
> +++ linux-2.6-tip/arch/m68knommu/platform/5249/intc2.c
> @@ -51,8 +51,8 @@ static int __init mcf_intc2_init(void)
>
>   	/* GPIO interrupt sources */
>   	for (irq = MCFINTC2_GPIOIRQ0; (irq<= MCFINTC2_GPIOIRQ7); irq++) {
> -		set_irq_chip(irq,&intc2_irq_gpio_chip);
> -		set_irq_handler(irq, handle_edge_irq);
> +		irq_set_chip(irq,&intc2_irq_gpio_chip);
> +		irq_set_handler(irq, handle_edge_irq);
>   	}
>
>   	return 0;
> Index: linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/5272/intc.c
> +++ linux-2.6-tip/arch/m68knommu/platform/5272/intc.c
> @@ -145,7 +145,7 @@ static int intc_irq_set_type(struct irq_
>    */
>   static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
>   {
> -	get_irq_desc_chip(desc)->irq_ack(&desc->irq_data);
> +	irq_desc_get_chip(desc)->irq_ack(&desc->irq_data);
>   	handle_simple_irq(irq, desc);
>   }
>
> @@ -171,16 +171,16 @@ void __init init_IRQ(void)
>   	writel(0x88888888, MCF_MBAR + MCFSIM_ICR4);
>
>   	for (irq = 0; (irq<  NR_IRQS); irq++) {
> -		set_irq_chip(irq,&intc_irq_chip);
> +		irq_set_chip(irq,&intc_irq_chip);
>   		edge = 0;
>   		if ((irq>= MCFINT_VECBASE)&&  (irq<= MCFINT_VECMAX))
>   			edge = intc_irqmap[irq - MCFINT_VECBASE].ack;
>   		if (edge) {
> -			set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> -			set_irq_handler(irq, intc_external_irq);
> +			irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +			irq_set_handler(irq, intc_external_irq);
>   		} else {
> -			set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> -			set_irq_handler(irq, handle_level_irq);
> +			irq_set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> +			irq_set_handler(irq, handle_level_irq);
>   		}
>   	}
>   }
> Index: linux-2.6-tip/arch/m68knommu/platform/68328/ints.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/68328/ints.c
> +++ linux-2.6-tip/arch/m68knommu/platform/68328/ints.c
> @@ -179,8 +179,8 @@ void __init init_IRQ(void)
>   	IMR = ~0;
>
>   	for (i = 0; (i<  NR_IRQS); i++) {
> -		set_irq_chip(i,&intc_irq_chip);
> -		set_irq_handler(i, handle_level_irq);
> +		irq_set_chip(i,&intc_irq_chip);
> +		irq_set_handler(i, handle_level_irq);
>   	}
>   }
>
> Index: linux-2.6-tip/arch/m68knommu/platform/68360/ints.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/68360/ints.c
> +++ linux-2.6-tip/arch/m68knommu/platform/68360/ints.c
> @@ -132,8 +132,8 @@ void init_IRQ(void)
>   	pquicc->intr_cimr = 0x00000000;
>
>   	for (i = 0; (i<  NR_IRQS); i++) {
> -		set_irq_chip(i,&intc_irq_chip);
> -		set_irq_handler(i, handle_level_irq);
> +		irq_set_chip(i,&intc_irq_chip);
> +		irq_set_handler(i, handle_level_irq);
>   	}
>   }
>
> Index: linux-2.6-tip/arch/m68knommu/platform/coldfire/intc-2.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/coldfire/intc-2.c
> +++ linux-2.6-tip/arch/m68knommu/platform/coldfire/intc-2.c
> @@ -164,7 +164,7 @@ static int intc_irq_set_type(struct irq_
>   	}
>
>   	if (tb)
> -		set_irq_handler(irq, handle_edge_irq);
> +		irq_set_handler(irq, handle_edge_irq);
>
>   	irq -= EINT0;
>   	pa = __raw_readw(MCFEPORT_EPPAR);
> @@ -204,11 +204,11 @@ void __init init_IRQ(void)
>
>   	for (irq = MCFINT_VECBASE; (irq<  MCFINT_VECBASE + NR_VECS); irq++) {
>   		if ((irq>= EINT1)&&  (irq<=EINT7))
> -			set_irq_chip(irq,&intc_irq_chip_edge_port);
> +			irq_set_chip(irq,&intc_irq_chip_edge_port);
>   		else
> -			set_irq_chip(irq,&intc_irq_chip);
> -		set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> -		set_irq_handler(irq, handle_level_irq);
> +			irq_set_chip(irq,&intc_irq_chip);
> +		irq_set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> +		irq_set_handler(irq, handle_level_irq);
>   	}
>   }
>
> Index: linux-2.6-tip/arch/m68knommu/platform/coldfire/intc-simr.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/coldfire/intc-simr.c
> +++ linux-2.6-tip/arch/m68knommu/platform/coldfire/intc-simr.c
> @@ -141,7 +141,7 @@ static int intc_irq_set_type(struct irq_
>   	}
>
>   	if (tb)
> -		set_irq_handler(irq, handle_edge_irq);
> +		irq_set_handler(irq, handle_edge_irq);
>
>   	ebit = irq2ebit(irq) * 2;
>   	pa = __raw_readw(MCFEPORT_EPPAR);
> @@ -181,11 +181,11 @@ void __init init_IRQ(void)
>   	eirq = MCFINT_VECBASE + 64 + (MCFINTC1_ICR0 ? 64 : 0);
>   	for (irq = MCFINT_VECBASE; (irq<  eirq); irq++) {
>   		if ((irq>= EINT1)&&  (irq<= EINT7))
> -			set_irq_chip(irq,&intc_irq_chip_edge_port);
> +			irq_set_chip(irq,&intc_irq_chip_edge_port);
>   		else
> -			set_irq_chip(irq,&intc_irq_chip);
> -		set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> -		set_irq_handler(irq, handle_level_irq);
> +			irq_set_chip(irq,&intc_irq_chip);
> +		irq_set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> +		irq_set_handler(irq, handle_level_irq);
>   	}
>   }
>
> Index: linux-2.6-tip/arch/m68knommu/platform/coldfire/intc.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68knommu/platform/coldfire/intc.c
> +++ linux-2.6-tip/arch/m68knommu/platform/coldfire/intc.c
> @@ -143,9 +143,9 @@ void __init init_IRQ(void)
>   	mcf_maskimr(0xffffffff);
>
>   	for (irq = 0; (irq<  NR_IRQS); irq++) {
> -		set_irq_chip(irq,&intc_irq_chip);
> -		set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> -		set_irq_handler(irq, handle_level_irq);
> +		irq_set_chip(irq,&intc_irq_chip);
> +		irq_set_irq_type(irq, IRQ_TYPE_LEVEL_HIGH);
> +		irq_set_handler(irq, handle_level_irq);
>   	}
>   }
>
>
>
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
