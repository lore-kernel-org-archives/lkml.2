Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2ASXEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:04:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50015 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2ASXEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:04:47 -0500
Message-ID: <4F18A18C.9090302@gmail.com>
Date: Thu, 19 Jan 2012 17:04:44 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>
CC: grant.likely@secretlab.ca, tglx@linutronix.de,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: irq: Allow for specification of no preallocated
 irqs
References: <1327013024-22530-1-git-send-email-mbohan@codeaurora.org>
In-Reply-To: <1327013024-22530-1-git-send-email-mbohan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 04:43 PM, Michael Bohan wrote:
> For cases with SPARSE_IRQ enabled, irqs preallocated with
> arch_probe_nr_irqs() are already marked as allocated in the
> allocated_irqs bitmap. As a consequence, irq chip drivers that
> allocate irqs will feel one of two behaviors:
> 
> 1. An allocation will succeed with the starting irq_base one
> more than the preallocated irqs. This will thus waste the
> preceeding interrupt resources that were preallocated, unless a
> legacy chip driver happens to assume ownership of these by some
> platform definition. The GIC driver is a typical primary chip
> driver, and abides to the allocation APIs. So this can be a
> problem in many trivial usecases.
> 
> 2. An allocation will fail with < 0. This can also happen in the
> GIC driver, which interprets this value as meaning the irq_descs
> are already preallocated. But in Device Tree configurations, the
> fallback irq_base is -1. This results in an invalid irq_base
> value.
> 
> Looking forward, we are moving towards a world where preallocation
> of irqs is no longer necessary. irq_domain is scoped to handle all
> irq_desc allocations in the future. Thus, we should support
> configurations where the platform wants to preallocate no irqs.
> 
> One easy way to achieve this is to allow for
> machine_desc->nr_irqs < 0, which indicates not to preallocate any
> interrupts.
> 
> Signed-off-by: Michael Bohan <mbohan@codeaurora.org>

I don't know if you saw my recent series on NR_IRQS clean-up (Make
mach/irqs.h optional).

No doubt that arch_probe_nr_irqs is doing the wrong thing on ARM, but no
pre-allocation is not what we want either. We ultimately want
arch_probe_nr_irqs to return NR_IRQS_LEGACY (16) to reserve IRQ0 (aka
NO_IRQ) and legacy ISA IRQs. With my series, NR_IRQS is set to
NR_IRQS_LEGACY for SPARSE_IRQ. You can accomplish the same thing without
that series by setting .nr_irqs to NR_IRQS for non-DT and to
NR_IRQS_LEGACY for DT. For platforms to work in single kernel builds,
they will need to select SPARSE_IRQ.

Rob

> ---
>  arch/arm/include/asm/mach/arch.h |    2 +-
>  arch/arm/kernel/irq.c            |   14 ++++++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index d7692ca..cc6506a 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -22,7 +22,7 @@ struct machine_desc {
>  	const char *const 	*dt_compat;	/* array of device tree
>  						 * 'compatible' strings	*/
>  
> -	unsigned int		nr_irqs;	/* number of IRQs */
> +	int			nr_irqs;	/* number of IRQs */
>  
>  #ifdef CONFIG_ZONE_DMA
>  	unsigned long		dma_zone_size;	/* size of DMA-able area */
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 3efd82c..f74b173 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -129,8 +129,18 @@ void __init init_IRQ(void)
>  #ifdef CONFIG_SPARSE_IRQ
>  int __init arch_probe_nr_irqs(void)
>  {
> -	nr_irqs = machine_desc->nr_irqs ? machine_desc->nr_irqs : NR_IRQS;
> -	return nr_irqs;
> +	/*
> +	 * machine_desc->nr_irqs < 0 is a special case that
> +	 * specifies not to preallocate any irq_descs.
> +	 */
> +	if (machine_desc->nr_irqs < 0) {
> +		nr_irqs = 0;
> +		return nr_irqs;
> +	} else {
> +		nr_irqs = machine_desc->nr_irqs ?
> +			  machine_desc->nr_irqs : NR_IRQS;
> +		return nr_irqs;
> +	}
>  }
>  #endif
>  

