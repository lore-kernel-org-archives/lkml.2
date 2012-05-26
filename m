Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2EZNMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:12:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61402 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2EZNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:12:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 4/6] gpio: introduce lock mechanism for gpiochip_find
To: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, b29396@freescale.com
In-Reply-To: <1337952980-14621-4-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-4-git-send-email-b29396@freescale.com>
Date: Fri, 25 May 2012 18:25:00 -0600
Message-Id: <20120526002500.CA3123E14E9@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 21:36:18 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The module lock will be automatically claimed for gpiochip_find function
> in case the gpio module is removed during the using of gpiochip instance.
> Users are responsible to call gpiochip_put to release the lock after
> the using.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Hey Dong,

Does this actually protect anything?  From what I can see the gpio_lock
is held for the entire time of iterating over gpio_chips when the
match function is called and the gpio number is fully resolved before
gpiochip_find returns when called from of_get_named_gpio_flags().

Also, it doesn't do anything to protect against the gpio_chip being
removed after the gpio number is resolved, which means the gpio number
may no longer be valid, or may no longer point to the same gpio chip.
It looks like the locking protection needs to be wider to be useful.

Or is this patch to fix something in the mach-mx35-3ds.c, which is the
only other use of gpiochip_find().

g.

> ---
>  drivers/gpio/gpiolib-of.c  |    5 ++++-
>  drivers/gpio/gpiolib.c     |   17 +++++++++++++++++
>  include/asm-generic/gpio.h |    2 +-
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index b8010a9..d521452 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -63,6 +63,7 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
>                             int index, enum of_gpio_flags *flags)
>  {
>  	struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
> +	struct gpio_chip *chip;
>  	int ret;
>  
>  	/* .of_xlate might decide to not fill in the flags, so clear it. */
> @@ -76,7 +77,9 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
>  		return -EINVAL;
>  	}
>  
> -	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
> +	chip = gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
> +	if (chip)
> +		gpiochip_put(chip);
>  
>  	of_node_put(gg_data.gpiospec.np);
>  	pr_debug("%s exited with status %d\n", __func__, ret);
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 120b2a0..6453d43 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1144,6 +1144,18 @@ int gpiochip_remove(struct gpio_chip *chip)
>  EXPORT_SYMBOL_GPL(gpiochip_remove);
>  
>  /**
> + * gpiochip_put() - release a gpio_chip
> + * @chip: the chip to release
> + */
> +inline void gpiochip_put(struct gpio_chip *chip)
> +{
> +	BUG_ON(!chip);
> +
> +	module_put(chip->owner);
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_put);
> +
> +/**
>   * gpiochip_find() - iterator for locating a specific gpio_chip
>   * @data: data to pass to match function
>   * @callback: Callback function to check gpio_chip
> @@ -1153,6 +1165,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>   * 0 if the device doesn't match and non-zero if it does.  If the callback is
>   * non-zero, this function will return to the caller and not iterate over any
>   * more gpio_chips.
> + *
> + * Note the gpio_chip is returned with the module locked, users are responsible
> + * to release the lock with gpiochip_put(chip) after using it.
>   */
>  struct gpio_chip *gpiochip_find(void *data,
>  				int (*match)(struct gpio_chip *chip,
> @@ -1169,6 +1184,8 @@ struct gpio_chip *gpiochip_find(void *data,
>  
>  		if (match(gpio_desc[i].chip, data)) {
>  			chip = gpio_desc[i].chip;
> +			if (!try_module_get(chip->owner))
> +				chip = NULL;
>  			break;
>  		}
>  	}
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 365ea09..af372be 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -145,7 +145,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
>  extern struct gpio_chip *gpiochip_find(void *data,
>  					int (*match)(struct gpio_chip *chip,
>  						     void *data));
> -
> +extern void gpiochip_put(struct gpio_chip *chip);
>  
>  /* Always use the library code for GPIO management calls,
>   * or when sleeping may be involved.
> -- 
> 1.7.0.4
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
