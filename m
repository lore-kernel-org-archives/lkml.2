Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1KXW0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:26:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47147 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1KXWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:25:59 -0500
Date: Thu, 24 Nov 2011 22:26:01 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: at91/aic: add device tree support for AIC
Message-ID: <20111124222601.GA28582@gallagher>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Thu, Nov 24, 2011 at 10:56:27PM +0100, Nicolas Ferre wrote:
> Ioremap registers from DT specification and adding
> of a simple irq domain for AIC interrupts.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---

Apologies if I've missed it somewhere but I think this needs to be 
documented in Documentation/devicetree.

[...]
> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
> index be6b639..80783b0 100644
> --- a/arch/arm/mach-at91/irq.c
> +++ b/arch/arm/mach-at91/irq.c
> @@ -24,6 +24,8 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/types.h>
> +#include <linux/of_address.h>
> +#include <linux/irqdomain.h>
>  
>  #include <mach/hardware.h>
>  #include <asm/irq.h>
> @@ -34,6 +36,7 @@
>  #include <asm/mach/map.h>
>  
>  void __iomem *at91_aic_base;
> +static struct irq_domain at91_aic_domain;
>  
>  static void at91_aic_mask_irq(struct irq_data *d)
>  {
> @@ -127,14 +130,44 @@ static struct irq_chip at91_aic_chip = {
>  	.irq_set_wake	= at91_aic_set_wake,
>  };
>  
> +#if defined(CONFIG_OF)
> +static struct of_device_id aic_ids[]  = {
> +	{ .compatible = "atmel,at91rm9200-aic" },
> +	{ /*sentinel*/ }
> +};
> +
> +static int __init at91_aic_of_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_matching_node(NULL, aic_ids);
> +	if (np == NULL)
> +		return -ENODEV;
> +
> +	at91_aic_base = of_iomap(np, 0);
> +	at91_aic_domain.of_node = np;

I think this needs to be:

	at91_aic_domain.of_node = of_node_get(np);

to keep the reference count.

> +	/* Keep refcount of the node */
> +
> +	return 0;
> +}
> +#else
> +static int __init at91_aic_of_init(void)
> +{
> +	return -ENOSYS;
> +}
> +#endif

I think it's preferred if you use of_irq_init() here as it can handle 
the ordering of IRQ controllers.  There are GIC and VIC bindings in 
-next that use this and provide a way for non-DT platforms to still use 
the drivers.

>  /*
>   * Initialize the AIC interrupt controller.
>   */
>  void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
>  {
>  	unsigned int i;
> +	int ret;
>  
> -	at91_aic_base = ioremap(AT91_AIC, 512);
> +	ret = at91_aic_of_init();
> +	if (ret < 0)
> +		at91_aic_base = ioremap(AT91_AIC, 512);
>  
>  	if (!at91_aic_base)
>  		panic("Impossible to ioremap AT91_AIC\n");
> @@ -169,4 +202,10 @@ void __init at91_aic_init(unsigned int priority[NR_AIC_IRQS])
>  	/* Disable and clear all interrupts initially */
>  	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
>  	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
> +
> +	/* Add irq domain for AIC */
> +	at91_aic_domain.irq_base = at91_aic_domain.hwirq_base = 0;
> +	at91_aic_domain.nr_irq = NR_AIC_IRQS;
> +	at91_aic_domain.ops = &irq_domain_simple_ops;

irq_domain_simple_ops is only exported when CONFIG_OF_IRQ=y, so this 
probably won't work for !CONFIG_USE_OF.

> +	irq_domain_add(&at91_aic_domain);
>  }
> -- 
> 1.7.5.4
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
