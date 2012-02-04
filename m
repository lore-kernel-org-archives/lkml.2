Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2BDOHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:07:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34363 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2BDOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:07:30 -0500
Date: Sat, 4 Feb 2012 22:20:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 3/4] ARM: imx: add irq domain support to tzic
Message-ID: <20120204142001.GB19899@S2101-09.ap.freescale.net>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
 <1328308512-22594-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1328308512-22594-4-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:35:11PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add irq domain support to tzic. This is needed to enable DT.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  arch/arm/plat-mxc/tzic.c |   23 ++++++++++-------------
>  1 files changed, 10 insertions(+), 13 deletions(-)
> 

  CC      arch/arm/plat-mxc/tzic.o
arch/arm/plat-mxc/tzic.c: In function ‘tzic_irq_resume’:
arch/arm/plat-mxc/tzic.c:87:27: warning: unused variable ‘gc’ [-Wunused-variable]
arch/arm/plat-mxc/tzic.c: In function ‘tzic_init_gc’:
arch/arm/plat-mxc/tzic.c:120:2: warning: ‘return’ with a value, in function returning void [enabled by default]

Regards,
Shawn

> diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> index 98308ec..25c10bb 100644
> --- a/arch/arm/plat-mxc/tzic.c
> +++ b/arch/arm/plat-mxc/tzic.c
> @@ -77,7 +77,7 @@ static int tzic_set_irq_fiq(unsigned int irq, unsigned int type)
>  static void tzic_irq_suspend(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	int idx = gc->irq_base >> 5;
> +	int idx = d->hwirq / 32;
>  
>  	__raw_writel(gc->wake_active, tzic_base + TZIC_WAKEUP0(idx));
>  }
> @@ -85,7 +85,7 @@ static void tzic_irq_suspend(struct irq_data *d)
>  static void tzic_irq_resume(struct irq_data *d)
>  {
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	int idx = gc->irq_base >> 5;
> +	int idx = d->hwirq / 32;
>  
>  	__raw_writel(__raw_readl(tzic_base + TZIC_ENSET0(idx)),
>  		     tzic_base + TZIC_WAKEUP0(idx));
> @@ -102,18 +102,13 @@ static struct mxc_extra_irq tzic_extra_irq = {
>  #endif
>  };
>  
> -static __init void tzic_init_gc(unsigned int irq_start)
> +static __init void tzic_init_gc(struct irq_chip_generic *gc)
>  {
> -	struct irq_chip_generic *gc;
> -	struct irq_chip_type *ct;
> -	int idx = irq_start >> 5;
> +	struct irq_chip_type *ct = gc->chip_types;
> +	int idx = gc->hwirq_base / 32;
>  
> -	gc = irq_alloc_generic_chip("tzic", 1, irq_start, tzic_base,
> -				    handle_level_irq);
> -	gc->private = &tzic_extra_irq;
>  	gc->wake_enabled = IRQ_MSK(32);
>  
> -	ct = gc->chip_types;
>  	ct->chip.irq_mask = irq_gc_mask_disable_reg;
>  	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
>  	ct->chip.irq_set_wake = irq_gc_set_wake;
> @@ -122,7 +117,7 @@ static __init void tzic_init_gc(unsigned int irq_start)
>  	ct->regs.disable = TZIC_ENCLEAR0(idx);
>  	ct->regs.enable = TZIC_ENSET0(idx);
>  
> -	irq_setup_generic_chip(gc, IRQ_MSK(32), 0, IRQ_NOREQUEST, 0);
> +	return 0;
>  }
>  
>  asmlinkage void __exception_irq_entry tzic_handle_irq(struct pt_regs *regs)
> @@ -175,8 +170,10 @@ void __init tzic_init_irq(void __iomem *irqbase)
>  
>  	/* all IRQ no FIQ Warning :: No selection */
>  
> -	for (i = 0; i < TZIC_NUM_IRQS; i += 32)
> -		tzic_init_gc(i);
> +	irq_setup_generic_chip_domain("tzic", NULL, 1, 0, tzic_base,
> +				      handle_level_irq, TZIC_NUM_IRQS, 0,
> +				      IRQ_NOREQUEST, 0,
> +				      tzic_init_gc, &tzic_extra_irq);
>  
>  #ifdef CONFIG_FIQ
>  	/* Initialize FIQ */
> -- 
> 1.7.5.4
> 
