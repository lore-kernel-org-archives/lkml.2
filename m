Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1CaUsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:48:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47945 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1CaUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:48:37 -0400
Date: Thu, 31 Mar 2011 14:48:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: gpio: pca953x: prevent freeing IRQ 0 on probe error
Message-ID: <20110331204833.GA32522@ponder.secretlab.ca>
References: <201103251502.54348.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103251502.54348.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 03:02:54PM -0700, H Hartley Sweeten wrote:
> If CONFIG_GPIO_PCA953X_IRQ is enabled and an error occurs in the probe
> before pca953x_irq_setup() is called chip->client->irq will be 0 due to
> the kmalloc.  pca953x_irq_teardown() will then try to free_irq(0, chip)
> which will produce a:
> 
> 	WARN(1, "Trying to free already-free IRQ %d\n", irq);
> 
> Add an error path to prevent this.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Thanks for catching this Hartley.

Ben also submitted a patch for this and I ended up looking at his patch first, so that is what's applied.  :-)

g.

> 
> ---
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 2fc25de..e1ff4d5 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -523,7 +523,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  	if (pdata == NULL) {
>  		dev_dbg(&client->dev, "no platform data\n");
>  		ret = -EINVAL;
> -		goto out_failed;
> +		goto out_free;
>  	}
>  
>  	chip->client = client;
> @@ -541,20 +541,20 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  
>  	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
>  	if (ret)
> -		goto out_failed;
> +		goto out_free;
>  
>  	ret = pca953x_read_reg(chip, PCA953X_DIRECTION, &chip->reg_direction);
>  	if (ret)
> -		goto out_failed;
> +		goto out_free;
>  
>  	/* set platform specific polarity inversion */
>  	ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
>  	if (ret)
> -		goto out_failed;
> +		goto out_free;
>  
>  	ret = pca953x_irq_setup(chip, id);
>  	if (ret)
> -		goto out_failed;
> +		goto out_free;
>  
>  	ret = gpiochip_add(&chip->gpio_chip);
>  	if (ret)
> @@ -572,6 +572,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  
>  out_failed:
>  	pca953x_irq_teardown(chip);
> +out_free:
>  	kfree(chip->dyn_pdata);
>  	kfree(chip);
>  	return ret;
