Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1ECTl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:41:59 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:61572 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1ECTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:41:57 -0400
Date: Tue, 3 May 2011 13:41:52 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        cbouatmailru@gmail.com, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 4/7] basic_mmio_gpio: request register regions
Message-ID: <20110503194152.GD9401@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-5-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302520914-22816-5-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:51PM +0100, Jamie Iles wrote:
> Make sure that we get the register regions with request_mem_region()
> before ioremap() to make sure we have exclusive access.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks.

g.

> ---
>  drivers/gpio/basic_mmio_gpio.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index 2b2d384..90f7f89 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -192,6 +192,16 @@ static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
>  	return 0;
>  }
>  
> +static void __iomem *bgpio_request_and_map(struct device *dev,
> +					   struct resource *res)
> +{
> +	if (!devm_request_mem_region(dev, res->start, resource_size(res),
> +				     res->name ?: "mmio_gpio"))
> +		return NULL;
> +
> +	return devm_ioremap(dev, res->start, resource_size(res));
> +}
> +
>  static int bgpio_setup_accessors(struct platform_device *pdev,
>  				 struct bgpio_chip *bgc)
>  {
> @@ -258,7 +268,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	if (!bgc)
>  		return -ENOMEM;
>  
> -	bgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
> +	bgc->reg_dat = bgpio_request_and_map(dev, res_dat);
>  	if (!bgc->reg_dat)
>  		return -ENOMEM;
>  
> @@ -269,8 +279,8 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  				resource_size(res_set) != dat_sz)
>  			return -EINVAL;
>  
> -		bgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
> -		bgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
> +		bgc->reg_set = bgpio_request_and_map(dev, res_set);
> +		bgc->reg_clr = bgpio_request_and_map(dev, res_clr);
>  		if (!bgc->reg_set || !bgc->reg_clr)
>  			return -ENOMEM;
>  	} else if (res_set || res_clr) {
> -- 
> 1.7.4.2
> 
