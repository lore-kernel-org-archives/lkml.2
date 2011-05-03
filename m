Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1ECTlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:41:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46180 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1ECTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:41:40 -0400
Date: Tue, 3 May 2011 13:41:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        cbouatmailru@gmail.com, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 3/7] basic_mmio_gpio: allow overriding number of gpio
Message-ID: <20110503194136.GC9401@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-4-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302520914-22816-4-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:50PM +0100, Jamie Iles wrote:
> Some platforms may have a number of GPIO that is less than the register
> width of the peripheral.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks.

g.

> ---
>  drivers/gpio/basic_mmio_gpio.c  |   18 ++++++++++++------
>  include/linux/basic_mmio_gpio.h |    1 +
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index 5db5de4..2b2d384 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -239,6 +239,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	resource_size_t dat_sz;
>  	int bits;
>  	int ret;
> +	int ngpio;
>  
>  	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
>  	if (!res_dat)
> @@ -249,6 +250,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  
>  	bits = dat_sz * 8;
> +	ngpio = bits;
>  	if (bits > BITS_PER_LONG)
>  		return -EINVAL;
>  
> @@ -277,13 +279,22 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  
>  	spin_lock_init(&bgc->lock);
>  
> +	if (pdata) {
> +		bgc->gc.base = pdata->base;
> +		if (pdata->ngpio > 0)
> +			ngpio = pdata->ngpio;
> +	} else {
> +		bgc->gc.base = -1;
> +	}
> +
>  	bgc->bits = bits;
>  	ret = bgpio_setup_accessors(pdev, bgc);
>  	if (ret)
>  		return ret;
>  
>  	bgc->data = bgc->read_reg(bgc->reg_dat);
> -	bgc->gc.ngpio = bits;
> +
> +	bgc->gc.ngpio = ngpio;
>  	bgc->gc.direction_input = bgpio_dir_in;
>  	bgc->gc.direction_output = bgpio_dir_out;
>  	bgc->gc.get = bgpio_get;
> @@ -291,11 +302,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	bgc->gc.dev = dev;
>  	bgc->gc.label = dev_name(dev);
>  
> -	if (pdata)
> -		bgc->gc.base = pdata->base;
> -	else
> -		bgc->gc.base = -1;
> -
>  	platform_set_drvdata(pdev, bgc);
>  
>  	ret = gpiochip_add(&bgc->gc);
> diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
> index 198087a..f23ec73 100644
> --- a/include/linux/basic_mmio_gpio.h
> +++ b/include/linux/basic_mmio_gpio.h
> @@ -15,6 +15,7 @@
>  
>  struct bgpio_pdata {
>  	int base;
> +	int ngpio;
>  };
>  
>  #endif /* __BASIC_MMIO_GPIO_H */
> -- 
> 1.7.4.2
> 
