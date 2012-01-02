Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2ABIyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:54:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2ABIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:54:37 -0500
Date: Mon, 2 Jan 2012 01:54:33 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v2] gpio: pl061: convert to use generic irq chip
Message-ID: <20120102085433.GJ18381@ponder.secretlab.ca>
References: <1323876538-20406-8-git-send-email-robherring2@gmail.com>
 <1324327927-6886-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324327927-6886-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:52:07PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Convert the pl061 irq_chip code to use the generic irq chip code.
> 
> This has the side effect of using 32-bit accesses rather than 8-bit
> accesses to interrupt registers. The h/w TRM and testing seem to indicate
> this is fine.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.ml.walleij@gmail.com>

What does this apply against?  It doesn't apply cleanly.

g.

> ---
> v2:
> - put struct irq_chip_generic pointer into struct pl061_gpio instead of domain
> ptr.
> 
>  drivers/gpio/Kconfig      |    1 +
>  drivers/gpio/gpio-pl061.c |   74 ++++++++++++++++-----------------------------
>  2 files changed, 27 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 8482a23..4d433e2 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -138,6 +138,7 @@ config GPIO_MXS
>  config GPIO_PL061
>  	bool "PrimeCell PL061 GPIO support"
>  	depends on ARM_AMBA
> +	select GENERIC_IRQ_CHIP
>  	help
>  	  Say yes here to support the PrimeCell PL061 GPIO device
>  
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index fe19dec..96ff6b2 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -50,10 +50,10 @@ struct pl061_gpio {
>  	 * the IRQ code simpler.
>  	 */
>  	spinlock_t		lock;		/* GPIO registers */
> -	spinlock_t		irq_lock;	/* IRQ registers */
>  
>  	void __iomem		*base;
>  	int			irq_base;
> +	struct irq_chip_generic	*irq_gc;
>  	struct gpio_chip	gc;
>  };
>  
> @@ -125,40 +125,10 @@ static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
>  	return chip->irq_base + offset;
>  }
>  
> -/*
> - * PL061 GPIO IRQ
> - */
> -static void pl061_irq_disable(struct irq_data *d)
> -{
> -	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
> -	int offset = d->irq - chip->irq_base;
> -	unsigned long flags;
> -	u8 gpioie;
> -
> -	spin_lock_irqsave(&chip->irq_lock, flags);
> -	gpioie = readb(chip->base + GPIOIE);
> -	gpioie &= ~(1 << offset);
> -	writeb(gpioie, chip->base + GPIOIE);
> -	spin_unlock_irqrestore(&chip->irq_lock, flags);
> -}
> -
> -static void pl061_irq_enable(struct irq_data *d)
> -{
> -	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
> -	int offset = d->irq - chip->irq_base;
> -	unsigned long flags;
> -	u8 gpioie;
> -
> -	spin_lock_irqsave(&chip->irq_lock, flags);
> -	gpioie = readb(chip->base + GPIOIE);
> -	gpioie |= 1 << offset;
> -	writeb(gpioie, chip->base + GPIOIE);
> -	spin_unlock_irqrestore(&chip->irq_lock, flags);
> -}
> -
>  static int pl061_irq_type(struct irq_data *d, unsigned trigger)
>  {
> -	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct pl061_gpio *chip = gc->private;
>  	int offset = d->irq - chip->irq_base;
>  	unsigned long flags;
>  	u8 gpiois, gpioibe, gpioiev;
> @@ -166,7 +136,7 @@ static int pl061_irq_type(struct irq_data *d, unsigned trigger)
>  	if (offset < 0 || offset >= PL061_GPIO_NR)
>  		return -EINVAL;
>  
> -	spin_lock_irqsave(&chip->irq_lock, flags);
> +	raw_spin_lock_irqsave(&gc->lock, flags);
>  
>  	gpioiev = readb(chip->base + GPIOIEV);
>  
> @@ -195,18 +165,11 @@ static int pl061_irq_type(struct irq_data *d, unsigned trigger)
>  
>  	writeb(gpioiev, chip->base + GPIOIEV);
>  
> -	spin_unlock_irqrestore(&chip->irq_lock, flags);
> +	raw_spin_unlock_irqrestore(&gc->lock, flags);
>  
>  	return 0;
>  }
>  
> -static struct irq_chip pl061_irqchip = {
> -	.name		= "GPIO",
> -	.irq_enable	= pl061_irq_enable,
> -	.irq_disable	= pl061_irq_disable,
> -	.irq_set_type	= pl061_irq_type,
> -};
> -
>  static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
>  {
>  	struct list_head *chip_list = irq_get_handler_data(irq);
> @@ -232,6 +195,25 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
>  	chained_irq_exit(irqchip, desc);
>  }
>  
> +static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
> +{
> +	struct irq_chip_type *ct;
> +
> +	chip->irq_gc = irq_alloc_generic_chip("gpio-pl061", 1, irq_base,
> +					      chip->base, handle_simple_irq);
> +	chip->irq_gc->private = chip;
> +
> +	ct = chip->irq_gc->chip_types;
> +	ct->chip.irq_mask = irq_gc_mask_clr_bit;
> +	ct->chip.irq_unmask = irq_gc_mask_set_bit;
> +	ct->chip.irq_set_type = pl061_irq_type;
> +	ct->chip.irq_set_wake = irq_gc_set_wake;
> +	ct->regs.mask = GPIOIE;
> +
> +	irq_setup_generic_chip(chip->irq_gc, IRQ_MSK(PL061_GPIO_NR),
> +			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
> +}
> +
>  static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  {
>  	struct pl061_platform_data *pdata;
> @@ -269,7 +251,6 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  	}
>  
>  	spin_lock_init(&chip->lock);
> -	spin_lock_init(&chip->irq_lock);
>  	INIT_LIST_HEAD(&chip->list);
>  
>  	chip->gc.direction_input = pl061_direction_input;
> @@ -293,6 +274,8 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  	if (chip->irq_base <= 0)
>  		return 0;
>  
> +	pl061_init_gc(chip, chip->irq_base);
> +
>  	writeb(0, chip->base + GPIOIE); /* disable irqs */
>  	irq = dev->irq[0];
>  	if (irq < 0) {
> @@ -321,11 +304,6 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  			else
>  				pl061_direction_input(&chip->gc, i);
>  		}
> -
> -		irq_set_chip_and_handler(i + chip->irq_base, &pl061_irqchip,
> -					 handle_simple_irq);
> -		set_irq_flags(i+chip->irq_base, IRQF_VALID);
> -		irq_set_chip_data(i + chip->irq_base, chip);
>  	}
>  
>  	return 0;
> -- 
> 1.7.5.4
> 
