Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596Ab2ELAU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:20:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761407Ab2ELAUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:20:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: pch9: Use proper flow type handlers
To: Thomas Gleixner <tglx@linutronix.de>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        alexander.stein@systec-electronic.com, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya.rohm@gmail.com
In-Reply-To: <alpine.LFD.2.02.1204281012420.6271@ionos>
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1311207599-2553-6-git-send-email-tomoya-linux@dsn.okisemi.com> <3D60A4A2-3538-4B24-B65B-219D6ED7B219@gmail.com> <CA46BB56-61AD-45E9-8D03-906B71C21C71@gmail.com> <alpine.LFD.2.02.1204252332070.2542@ionos> <D0A540D9-CFCD-456D-A1DB-C04ED063DF18@gmail.com> <alpine.LFD.2.02.1204281012420.6271@ionos>
Date: Fri, 11 May 2012 18:20:10 -0600
Message-Id: <20120512002010.ECE643E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2012 10:13:45 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> Jean-Francois Dagenais reported:
> 
>  Configuring a gpio pin with the gpio-pch driver with
>  "IRQF_TRIGGER_LOW | IRQF_ONESHOT" generates an interrupt storm for
>  threaded ISR until the ISR thread actually gets to physically clear
>  the interrupt on the triggering chip!! The immediate observable
>  symptom is the high CPU usage for my ISR thread task and the
>  interrupt count in /proc/interrupts incrementing radically.
> 
> The driver is wrong in several ways:
> 
> 1) Using handle_simple_irq() does not provide proper flow control
>    handling. In the case of oneshot threaded handlers for the
>    demultiplexed interrupts this results in an interrupt storm because
>    the simple handler does not deal with masking/unmasking.  Even
>    without threaded oneshot handlers an interrupt storm for level type
>    interrupts can easily be triggered when the interrupt is disabled
>    and the interrupt line is activated from the device.
> 
> 2) Acknowlegding the demultiplexed interrupt before calling the
>    handler is wrong for level type interrupts.
> 
> 3) The set_type function unconditionally enables the interrupt. It's
>    supposed to set the type and nothing else. The unmasking is done by
>    the core code.
> 
> Move the acknowledge code into a separate function and add it to the
> demux irqchip callbacks.
> 
> Remove the unconditional enabling from the set_type() callback and set
> the proper flow handlers depending on the selected type (level/edge).
> 
> Reported-and-tested-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: alexander.stein@systec-electronic.com
> Cc: qi.wang@intel.com
> Cc: yong.y.wang@intel.com
> Cc: joel.clark@intel.com
> Cc: kok.howg.ewe@intel.com
> Cc: toshiharu-linux@dsn.okisemi.com
> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204252332070.2542@ionos

Applied, thanks.  I'll push to Linus right away.

g.

> ---
>  drivers/gpio/gpio-pch.c |   57 +++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 29 deletions(-)
> 
> Index: linux-2.6/drivers/gpio/gpio-pch.c
> ===================================================================
> --- linux-2.6.orig/drivers/gpio/gpio-pch.c
> +++ linux-2.6/drivers/gpio/gpio-pch.c
> @@ -230,16 +230,12 @@ static void pch_gpio_setup(struct pch_gp
>  
>  static int pch_irq_type(struct irq_data *d, unsigned int type)
>  {
> -	u32 im;
> -	u32 __iomem *im_reg;
> -	u32 ien;
> -	u32 im_pos;
> -	int ch;
> -	unsigned long flags;
> -	u32 val;
> -	int irq = d->irq;
>  	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>  	struct pch_gpio *chip = gc->private;
> +	u32 im, im_pos, val;
> +	u32 __iomem *im_reg;
> +	unsigned long flags;
> +	int ch, irq = d->irq;
>  
>  	ch = irq - chip->irq_base;
>  	if (irq <= chip->irq_base + 7) {
> @@ -270,30 +266,22 @@ static int pch_irq_type(struct irq_data 
>  	case IRQ_TYPE_LEVEL_LOW:
>  		val = PCH_LEVEL_L;
>  		break;
> -	case IRQ_TYPE_PROBE:
> -		goto end;
>  	default:
> -		dev_warn(chip->dev, "%s: unknown type(%dd)",
> -			__func__, type);
> -		goto end;
> +		goto unlock;
>  	}
>  
>  	/* Set interrupt mode */
>  	im = ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));
>  	iowrite32(im | (val << (im_pos * 4)), im_reg);
>  
> -	/* iclr */
> -	iowrite32(BIT(ch), &chip->reg->iclr);
> +	/* And the handler */
> +	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
> +		__irq_set_handler_locked(d->irq, handle_level_irq);
> +	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
> +		__irq_set_handler_locked(d->irq, handle_edge_irq);
>  
> -	/* IMASKCLR */
> -	iowrite32(BIT(ch), &chip->reg->imaskclr);
> -
> -	/* Enable interrupt */
> -	ien = ioread32(&chip->reg->ien);
> -	iowrite32(ien | BIT(ch), &chip->reg->ien);
> -end:
> +unlock:
>  	spin_unlock_irqrestore(&chip->spinlock, flags);
> -
>  	return 0;
>  }
>  
> @@ -313,18 +301,24 @@ static void pch_irq_mask(struct irq_data
>  	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->imask);
>  }
>  
> +static void pch_irq_ack(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct pch_gpio *chip = gc->private;
> +
> +	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->iclr);
> +}
> +
>  static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
>  {
>  	struct pch_gpio *chip = dev_id;
>  	u32 reg_val = ioread32(&chip->reg->istatus);
> -	int i;
> -	int ret = IRQ_NONE;
> +	int i, ret = IRQ_NONE;
>  
>  	for (i = 0; i < gpio_pins[chip->ioh]; i++) {
>  		if (reg_val & BIT(i)) {
>  			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
>  				__func__, i, irq, reg_val);
> -			iowrite32(BIT(i), &chip->reg->iclr);
>  			generic_handle_irq(chip->irq_base + i);
>  			ret = IRQ_HANDLED;
>  		}
> @@ -343,6 +337,7 @@ static __devinit void pch_gpio_alloc_gen
>  	gc->private = chip;
>  	ct = gc->chip_types;
>  
> +	ct->chip.irq_ack = pch_irq_ack;
>  	ct->chip.irq_mask = pch_irq_mask;
>  	ct->chip.irq_unmask = pch_irq_unmask;
>  	ct->chip.irq_set_type = pch_irq_type;
> @@ -357,6 +352,7 @@ static int __devinit pch_gpio_probe(stru
>  	s32 ret;
>  	struct pch_gpio *chip;
>  	int irq_base;
> +	u32 msk;
>  
>  	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>  	if (chip == NULL)
> @@ -408,8 +404,13 @@ static int __devinit pch_gpio_probe(stru
>  	}
>  	chip->irq_base = irq_base;
>  
> +	/* Mask all interrupts, but enable them */
> +	msk = (1 << gpio_pins[chip->ioh]) - 1;
> +	iowrite32(msk, &chip->reg->imask);
> +	iowrite32(msk, &chip->reg->ien);
> +
>  	ret = request_irq(pdev->irq, pch_gpio_handler,
> -			     IRQF_SHARED, KBUILD_MODNAME, chip);
> +			  IRQF_SHARED, KBUILD_MODNAME, chip);
>  	if (ret != 0) {
>  		dev_err(&pdev->dev,
>  			"%s request_irq failed\n", __func__);
> @@ -418,8 +419,6 @@ static int __devinit pch_gpio_probe(stru
>  
>  	pch_gpio_alloc_generic_chip(chip, irq_base, gpio_pins[chip->ioh]);
>  
> -	/* Initialize interrupt ien register */
> -	iowrite32(0, &chip->reg->ien);
>  end:
>  	return 0;
>  

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
