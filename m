Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1ECTmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:42:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59753 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1ECTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:42:20 -0400
Date: Tue, 3 May 2011 13:42:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        cbouatmailru@gmail.com, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110503194215.GF9401@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-7-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302520914-22816-7-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:53PM +0100, Jamie Iles wrote:
> Some controllers have separate input and output registers.  For these
> controllers, use "set" for the output and "dat" for the input.
> 
> Changes since v2: reuse "set" for output and "dat" for input rather than
> adding a new "in" register.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks.

g.

> ---
>  drivers/gpio/basic_mmio_gpio.c |   38 +++++++++++++++++++++++++++++++++-----
>  1 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index 728bc67..6b99489 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -185,6 +185,24 @@ static void bgpio_set_with_clear(struct gpio_chip *gc, unsigned int gpio,
>  		bgc->write_reg(bgc->reg_clr, mask);
>  }
>  
> +static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	unsigned long mask = bgc->pin2mask(bgc, gpio);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +
> +	if (val)
> +		bgc->data |= mask;
> +	else
> +		bgc->data &= ~mask;
> +
> +	bgc->write_reg(bgc->reg_set, bgc->data);
> +
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
>  static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  {
>  	return 0;
> @@ -245,10 +263,12 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
>  
>  /*
>   * Create the device and allocate the resources.  For setting GPIO's there are
> - * two supported configurations:
> + * three supported configurations:
>   *
> - *	- single output register resource (named "dat").
> + *	- single input/output register resource (named "dat").
>   *	- set/clear pair (named "set" and "clr").
> + *	- single output register resource and single input resource ("set" and
> + *	dat").
>   *
>   * For the single output register, this drives a 1 by setting a bit and a zero
>   * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
> @@ -292,12 +312,21 @@ static int bgpio_setup_io(struct platform_device *pdev,
>  			return -ENOMEM;
>  
>  		bgc->gc.set = bgpio_set_with_clear;
> -	} else if (res_set || res_clr) {
> -		return -EINVAL;
> +	} else if (res_set && !res_clr) {
> +		if (resource_size(res_set) != resource_size(res_dat))
> +			return -EINVAL;
> +
> +		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
> +		if (!bgc->reg_set)
> +			return -ENOMEM;
> +
> +		bgc->gc.set = bgpio_set_set;
>  	} else {
>  		bgc->gc.set = bgpio_set;
>  	}
>  
> +	bgc->gc.get = bgpio_get;
> +
>  	return 0;
>  }
>  
> @@ -336,7 +365,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	bgc->gc.ngpio = ngpio;
>  	bgc->gc.direction_input = bgpio_dir_in;
>  	bgc->gc.direction_output = bgpio_dir_out;
> -	bgc->gc.get = bgpio_get;
>  	bgc->gc.dev = dev;
>  	bgc->gc.label = dev_name(dev);
>  
> -- 
> 1.7.4.2
> 
