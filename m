Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1LMSFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:05:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35504 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1LMSFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:05:46 -0500
Date: Tue, 13 Dec 2011 11:05:38 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Feng Tang <feng.tang@intel.com>
Cc: linus.walleij@linaro.org, tomoya-linux@dsn.lapis-semi.com,
        linux-kernel@vger.kernel.org, joel.clark@intel.com,
        ying.huang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2] gpio-ml-ioh: Add the irq_disable/irq_enable hooks
 for ml-ioh irq chip
Message-ID: <20111213180538.GB4871@ponder.secretlab.ca>
References: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
 <1323791630-4125-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323791630-4125-2-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:53:50PM +0800, Feng Tang wrote:
> These hooks will be needed by the general disabl/enable_irq();
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>

Applied, thanks

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 92b6f51..461958f 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -332,6 +332,34 @@ static void ioh_irq_mask(struct irq_data *d)
>  		  &chip->reg->regs[chip->ch].imask);
>  }
>  
> +static void ioh_irq_disable(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct ioh_gpio *chip = gc->private;
> +	unsigned long flags;
> +	u32 ien;
> +
> +	spin_lock_irqsave(&chip->spinlock, flags);
> +	ien = ioread32(&chip->reg->regs[chip->ch].ien);
> +	ien &= ~(1 << (d->irq - chip->irq_base));
> +	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
> +	spin_unlock_irqrestore(&chip->spinlock, flags);
> +}
> +
> +static void ioh_irq_enable(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct ioh_gpio *chip = gc->private;
> +	unsigned long flags;
> +	u32 ien;
> +
> +	spin_lock_irqsave(&chip->spinlock, flags);
> +	ien = ioread32(&chip->reg->regs[chip->ch].ien);
> +	ien |= 1 << (d->irq - chip->irq_base);
> +	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
> +	spin_unlock_irqrestore(&chip->spinlock, flags);
> +}
> +
>  static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
>  {
>  	struct ioh_gpio *chip = dev_id;
> @@ -370,6 +398,8 @@ static __devinit void ioh_gpio_alloc_generic_chip(struct ioh_gpio *chip,
>  	ct->chip.irq_mask = ioh_irq_mask;
>  	ct->chip.irq_unmask = ioh_irq_unmask;
>  	ct->chip.irq_set_type = ioh_irq_type;
> +	ct->chip.irq_disable = ioh_irq_disable;
> +	ct->chip.irq_enable = ioh_irq_enable;
>  
>  	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
>  			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
> -- 
> 1.7.1
> 
