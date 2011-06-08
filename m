Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1FHRJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:09:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55520 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1FHRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:08:59 -0400
Date: Wed, 8 Jun 2011 11:08:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] GPIO: pca953x.c: Remove meaningless device-tree
 bindings
Message-ID: <20110608170857.GI8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
 <1307537314-4345-4-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307537314-4345-4-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:48:31PM +0200, David Jander wrote:
> The property 'polarity' is handled by the GPIO core, and the 'gpio-base'
> should be assigned automatically. It is meaningless in the device-tree,
> since GPIO's are identified by the "chip-name"/offset pair.
> This way, the whole pca953x_get_alt_pdata() can go away.
> We still need to check whether we really want GPIO-interrupt functionality
> by simply looking if the I2C node has an interrupts property defined, since
> this property is not used for anything else.
> 
> Signed-off-by: David Jander <david@protonic.nl>
> ---
>  drivers/gpio/pca953x.c |   62 ++++++++---------------------------------------
>  1 files changed, 11 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 2dff562..ae9fe61 100644
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
> @@ -539,55 +538,6 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
>  }
>  #endif
>  
> -/*
> - * Handlers for alternative sources of platform_data
> - */
> -#ifdef CONFIG_OF_GPIO
> -/*
> - * Translate OpenFirmware node properties into platform_data
> - */
> -static struct pca953x_platform_data *
> -pca953x_get_alt_pdata(struct i2c_client *client)
> -{
> -	struct pca953x_platform_data *pdata;
> -	struct device_node *node;
> -	const __be32 *val;
> -	int size;
> -
> -	node = client->dev.of_node;
> -	if (node == NULL)
> -		return NULL;
> -
> -	pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
> -	if (pdata == NULL) {
> -		dev_err(&client->dev, "Unable to allocate platform_data\n");
> -		return NULL;
> -	}
> -
> -	pdata->gpio_base = -1;
> -	val = of_get_property(node, "linux,gpio-base", &size);
> -	if (val) {
> -		if (size != sizeof(*val))
> -			dev_warn(&client->dev, "%s: wrong linux,gpio-base\n",
> -				 node->full_name);
> -		else
> -			pdata->gpio_base = be32_to_cpup(val);
> -	}
> -
> -	val = of_get_property(node, "polarity", NULL);
> -	if (val)
> -		pdata->invert = *val;
> -
> -	return pdata;
> -}
> -#else
> -static struct pca953x_platform_data *
> -pca953x_get_alt_pdata(struct i2c_client *client)
> -{
> -	return NULL;
> -}
> -#endif
> -

Ah, hmm.  I missed that you were adding documentation for properties
that were already implemented.  I try really hard not to break things
that others are already relying on, so I don't think this code can be
removed.  However, bonus points if you make it deprecated and spit
out a scary warning when these properties are used.

>  static int __devinit device_pca953x_init(struct pca953x_chip *chip, int invert)
>  {
>  	int ret;
> @@ -654,7 +604,17 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  
>  	pdata = client->dev.platform_data;
>  	if (pdata == NULL) {
> -		pdata = pca953x_get_alt_pdata(client);
> +		pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
> +		if (pdata == NULL) {
> +			dev_err(&client->dev, "Unable to allocate platform_data\n");
> +			goto out_failed;
> +		}
> +		pdata->gpio_base = -1;
> +#ifdef CONFIG_OF_GPIO
> +		/* If I2C node has no interrupts property, disable GPIO interrupts */
> +		if (of_find_property(client->dev.of_node, "interrupts", NULL) == NULL)
> +			pdata->irq_base = -1;
> +#endif

Interesting fact: pdata is only used during setup of this driver.  All
the goofing around to kzalloc a pdata for the dt use case is really
kind of pointless, and the driver could be simpler if it were removed.
It would be nice if somebody could investigate this.

g.

