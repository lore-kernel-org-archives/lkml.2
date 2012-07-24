Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2GXNw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:52:58 -0400
Received: from www.xora.org.uk ([80.68.91.202]:38633 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2GXNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:52:56 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 09:52:56 EDT
Message-ID: <500EA751.7010808@xora.org.uk>
Date: Tue, 24 Jul 2012 14:46:57 +0100
From: Graeme Gregory <graeme@xora.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap-irq: support different type of irq register
References: <A874F61F95741C4A9BA573A70FE3998FD9A7@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD9A7@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/12 10:04, Kim, Milo wrote:
> * Interrupt-masked vs Interrupt-enabled
> Commonly the interrupt register is masked when the bit of IRQ register is set.
> But in some device like TI LP8788, the interrupt is enabled when the bit is 1.
> 
> This patch supports the interrupt-enabled type.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/base/regmap/regmap-irq.c |   42 ++++++++++++++++++++++++++++++++++---
>  include/linux/regmap.h           |    9 ++++++++
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
> index ed36ea2..cb44918 100644
> --- a/drivers/base/regmap/regmap-irq.c
> +++ b/drivers/base/regmap/regmap-irq.c
> @@ -94,7 +94,16 @@ static void regmap_irq_enable(struct irq_data *data)
>  	struct regmap *map = d->map;
>  	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
>  
> -	d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
> +	switch (d->chip->irq_type) {
> +	case REGIRQ_MASKED:
> +		d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
> +		break;
> +	case REGIRQ_ENABLED:
> +		d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
> +		break;
> +	default:
> +		break;
> +	}
>  }
>
Rather than have this code every time we change the mask I would have
instead just inverted the value passed to regmap_update_bits on write.
This only affects two sections of code, one in probe and one in sync.

This means internally all the variables always have the same meaning but
on chips that are inverted from the common we just write the correct thing.

This makes it a lot easier to debug as reading positive hex patterns I
find is easier than negative ones.

>  static void regmap_irq_disable(struct irq_data *data)
> @@ -103,7 +112,16 @@ static void regmap_irq_disable(struct irq_data *data)
>  	struct regmap *map = d->map;
>  	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
>  
> -	d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
> +	switch (d->chip->irq_type) {
> +	case REGIRQ_MASKED:
> +		d->val_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
> +		break;
> +	case REGIRQ_ENABLED:
> +		d->val_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
> +		break;
> +	default:
> +		break;
> +	}
>  }
>  
>  static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
> @@ -163,7 +181,18 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
>  			return IRQ_NONE;
>  		}
>  
> -		data->status_buf[i] &= ~data->mask_buf[i];
> +		switch (data->chip->irq_type) {
> +		case REGIRQ_MASKED:
> +			data->status_buf[i] &= ~data->mask_buf[i];
> +			break;
> +		case REGIRQ_ENABLED:
> +			data->status_buf[i] &= data->mask_buf[i];
> +			break;
> +		default:
> +			dev_err(map->dev, "Invalid irq register type: %d\n",
> +					data->chip->irq_type);
> +			return IRQ_NONE;
> +		}
>  
>  		if (data->status_buf[i] && chip->ack_base) {
>  			ret = regmap_write(map, chip->ack_base +
> @@ -238,6 +267,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
>  	struct regmap_irq_chip_data *d;
>  	int i;
>  	int ret = -ENOMEM;
> +	unsigned int val;
>  
>  	for (i = 0; i < chip->num_irqs; i++) {
>  		if (chip->irqs[i].reg_offset % map->reg_stride)
> @@ -302,9 +332,13 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
>  
>  	/* Mask all the interrupts by default */
>  	for (i = 0; i < chip->num_regs; i++) {
> +		val = d->mask_buf[i];
> +		if (chip->irq_type == REGIRQ_ENABLED)
> +			val = ~d->mask_buf[i];
> +
>  		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride
>  				   * d->irq_reg_stride),
> -				   d->mask_buf[i]);
> +				   val);
>  		if (ret != 0) {
>  			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
>  				chip->mask_base + (i * map->reg_stride), ret);
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 7f7e00d..e0094db 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -30,6 +30,12 @@ enum regcache_type {
>  	REGCACHE_COMPRESSED
>  };
>  
> +/* Interrupt register type : masked or enabled */
> +enum regirq_type {
> +	REGIRQ_MASKED,	/* interrupt is masked when the bit is set */
> +	REGIRQ_ENABLED,	/* interrupt is enabled when the bit is set */
> +};
> +
I would have selected MASK_NORMAL, MASK_INVERTED here.

>  /**
>   * Default value for a register.  We use an array of structs rather
>   * than a simple array as many modern devices have very sparse
> @@ -290,6 +296,7 @@ struct regmap_irq {
>   * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
>   *               assigned based on the index in the array of the interrupt.
>   * @num_irqs:    Number of descriptors.
> + * @irq_type:    Interrupt register type. masked or enabled
>   */
>  struct regmap_irq_chip {
>  	const char *name;
> @@ -304,6 +311,8 @@ struct regmap_irq_chip {
>  
>  	const struct regmap_irq *irqs;
>  	int num_irqs;
> +
> +	enum regirq_type irq_type;
>  };
>  
>  struct regmap_irq_chip_data;
> 

