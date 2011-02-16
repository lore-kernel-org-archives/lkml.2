Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1BPCsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:48:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1BPCs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:48:29 -0500
Date: Tue, 15 Feb 2011 19:48:26 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Bean <gbean@codeaurora.org>, Jean Delvare <khali@linux-fr.org>,
        Lennert Buytenhek <buytenh@secretlab.ca>
Subject: Re: [patch] drivers: gpio: sx150x: Do not access I2C from
 mask/unmask functions
Message-ID: <20110216024826.GL28005@angua.secretlab.ca>
References: <20110214164634.510293676@linutronix.de>
 <alpine.LFD.2.00.1102141807000.26192@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102141807000.26192@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 06:08:51PM +0100, Thomas Gleixner wrote:
> On Mon, 14 Feb 2011, Thomas Gleixner wrote:
> 
> Ooops. quilt refresh should be mandatory for quilt mail. One day I'll fix that.
> 
> ------->
> Subject: drivers: gpio: sx150x: Do not access I2C from mask/unmask functions
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Mon, 14 Feb 2011 16:58:11 +0100
> 
> irq_chip->irq_mask/unmask are called with interrupts disabled and
> irq_desc->lock held. So we cannot access i2c from this context. That's
> what irq_bus_sync_unlock() is for.
>  
> Store the masked information in the chip data structure and update the
> i2c bus from the irq_bus_sync_unlock() callback.
> 
> This does not need a while(pending) loop because the update to this is
> always serialized via the bus lock, so we never have more than one pin
> update pending.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Gregory Bean <gbean@codeaurora.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Lennert Buytenhek <buytenh@secretlab.ca>

Applied, thanks.

g.

> ---
>  drivers/gpio/sx150x.c |   54 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 37 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6-tip/drivers/gpio/sx150x.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/gpio/sx150x.c
> +++ linux-2.6-tip/drivers/gpio/sx150x.c
> @@ -25,6 +25,8 @@
>  #include <linux/workqueue.h>
>  #include <linux/i2c/sx150x.h>
>  
> +#define NO_UPDATE_PENDING	-1
> +
>  struct sx150x_device_data {
>  	u8 reg_pullup;
>  	u8 reg_pulldn;
> @@ -47,8 +49,11 @@ struct sx150x_chip {
>  	const struct sx150x_device_data *dev_cfg;
>  	int                              irq_summary;
>  	int                              irq_base;
> +	int				 irq_update;
>  	u32                              irq_sense;
> -	unsigned long                    irq_set_type_pending;
> +	u32				 irq_masked;
> +	u32				 dev_sense;
> +	u32				 dev_masked;
>  	struct irq_chip                  irq_chip;
>  	struct mutex                     lock;
>  };
> @@ -312,9 +317,8 @@ static void sx150x_irq_mask(struct irq_d
>  
>  	chip = container_of(ic, struct sx150x_chip, irq_chip);
>  	n = d->irq - chip->irq_base;
> -
> -	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
> -	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
> +	chip->irq_masked |= (1 << n);
> +	chip->irq_update = n;
>  }
>  
>  static void sx150x_irq_unmask(struct irq_data *d)
> @@ -326,9 +330,8 @@ static void sx150x_irq_unmask(struct irq
>  	chip = container_of(ic, struct sx150x_chip, irq_chip);
>  	n = d->irq - chip->irq_base;
>  
> -	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
> -	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
> -			 chip->irq_sense >> (n * 2));
> +	chip->irq_masked &= ~(1 << n);
> +	chip->irq_update = n;
>  }
>  
>  static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
> @@ -350,7 +353,7 @@ static int sx150x_irq_set_type(struct ir
>  
>  	chip->irq_sense &= ~(3UL << (n * 2));
>  	chip->irq_sense |= val << (n * 2);
> -	chip->irq_set_type_pending |= BIT(n);
> +	chip->irq_update = n;
>  	return 0;
>  }
>  
> @@ -404,15 +407,29 @@ static void sx150x_irq_bus_sync_unlock(s
>  
>  	chip = container_of(ic, struct sx150x_chip, irq_chip);
>  
> -	while (chip->irq_set_type_pending) {
> -		n = __ffs(chip->irq_set_type_pending);
> -		chip->irq_set_type_pending &= ~BIT(n);
> -		if (!(irq_to_desc(n + chip->irq_base)->status & IRQ_MASKED))
> -			sx150x_write_cfg(chip, n, 2,
> -					chip->dev_cfg->reg_sense,
> -					chip->irq_sense >> (n * 2));
> -	}
> +	if (chip->irq_update == NO_UPDATE_PENDING)
> +		goto out;
>  
> +	n = chip->irq_update;
> +	chip->irq_update = NO_UPDATE_PENDING;
> +
> +	/* Avoid updates if nothing changed */
> +	if (chip->dev_sense == chip->irq_sense &&
> +	    chip->dev_sense == chip->irq_masked)
> +		goto out;
> +
> +	chip->dev_sense = chip->irq_sense;
> +	chip->dev_masked = chip->irq_masked;
> +
> +	if (chip->irq_masked & (1 << n)) {
> +		sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
> +		sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
> +	} else {
> +		sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
> +		sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
> +				 chip->irq_sense >> (n * 2));
> +	}
> +out:
>  	mutex_unlock(&chip->lock);
>  }
>  
> @@ -445,8 +462,11 @@ static void sx150x_init_chip(struct sx15
>  	chip->irq_chip.irq_bus_sync_unlock = sx150x_irq_bus_sync_unlock;
>  	chip->irq_summary                  = -1;
>  	chip->irq_base                     = -1;
> +	chip->irq_masked                   = ~0;
>  	chip->irq_sense                    = 0;
> -	chip->irq_set_type_pending         = 0;
> +	chip->dev_masked                   = ~0;
> +	chip->dev_sense                    = 0;
> +	chip->irq_update		   = NO_UPDATE_PENDING;
>  }
>  
>  static int sx150x_init_io(struct sx150x_chip *chip, u8 base, u16 cfg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
