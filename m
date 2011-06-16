Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1FPTwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:52:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60406 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab1FPTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:52:45 -0400
Date: Thu, 16 Jun 2011 13:45:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/5] GPIO: pca953x.c: Deprecate meaningless
 device-tree bindings
Message-ID: <20110616194532.GD3697@ponder.secretlab.ca>
References: <1308042058-20107-1-git-send-email-david@protonic.nl>
 <1308042058-20107-4-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308042058-20107-4-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 11:00:56AM +0200, David Jander wrote:
> The property 'polarity' is handled by the GPIO core, and the 'gpio-base'
> should be assigned automatically. It is meaningless in the device-tree,
> since GPIO's are identified by the "chip-name"/offset pair.
> This way, the whole pca953x_get_alt_pdata() can hopefully soon go away.
> We still need to check whether we really want GPIO-interrupt functionality
> by simply looking if the I2C node has an interrupts property defined, since
> this property is not used for anything else.
> 
> Signed-off-by: David Jander <david@protonic.nl>

Merged, thanks.

g.

> ---
>  drivers/gpio/pca953x.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index db69d9e..c28fc98 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -21,7 +21,6 @@
>  #include <linux/slab.h>
>  #ifdef CONFIG_OF_GPIO
>  #include <linux/of_platform.h>
> -#include <linux/of_gpio.h>
>  #endif
>  
>  #define PCA953X_INPUT		0
> @@ -546,6 +545,7 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
>  #ifdef CONFIG_OF_GPIO
>  /*
>   * Translate OpenFirmware node properties into platform_data
> + * WARNING: This is DEPRECATED and will be removed eventually!
>   */
>  void
>  pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
> @@ -560,6 +560,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
>  
>  	*gpio_base = -1;
>  	val = of_get_property(node, "linux,gpio-base", &size);
> +	WARN(val, "%s: device-tree property 'linux,gpio-base' is deprecated!", __func__);
>  	if (val) {
>  		if (size != sizeof(*val))
>  			dev_warn(&client->dev, "%s: wrong linux,gpio-base\n",
> @@ -569,6 +570,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
>  	}
>  
>  	val = of_get_property(node, "polarity", NULL);
> +	WARN(val, "%s: device-tree property 'polarity' is deprecated!", __func__);
>  	if (val)
>  		*invert = *val;
>  }
> @@ -637,7 +639,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  {
>  	struct pca953x_platform_data *pdata;
>  	struct pca953x_chip *chip;
> -	int irq_base=-1, invert=0;
> +	int irq_base=0, invert=0;
>  	int ret = 0;
>  
>  	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
> @@ -652,6 +654,11 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  		chip->names = pdata->names;
>  	} else {
>  		pca953x_get_alt_pdata(client, &chip->gpio_start, &invert);
> +#ifdef CONFIG_OF_GPIO
> +		/* If I2C node has no interrupts property, disable GPIO interrupts */
> +		if (of_find_property(client->dev.of_node, "interrupts", NULL) == NULL)
> +			irq_base = -1;
> +#endif
>  	}
>  
>  	chip->client = client;
> -- 
> 1.7.4.1
> 
