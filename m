Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab0KJFJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:09:54 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36226 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0KJFJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:09:50 -0500
Date: Tue, 9 Nov 2010 22:09:47 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Maciej Szmigiero <mhej@o2.pl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: Re: [GPIO]implement sleeping GPIO chip removal
Message-ID: <20101110050947.GC4110@angua.secretlab.ca>
References: <4CD6F049.10102@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD6F049.10102@o2.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 07:30:33PM +0100, Maciej Szmigiero wrote:
> [GPIO]implement sleeping GPIO chip removal
> 
> Existing GPIO chip removal code is only of "non-blocking" type: if the chip is currently
> requested it just returns -EBUSY.
> This is bad for devices which disappear and reappear, like those on hot pluggable buses,
> because it forces the driver to call gpiochip_remove() in loop until it returns 0.
> 
> This patch implements a new function which sleeps until device is free instead of
> returning -EBUSY like gpiochip_remove().
> 
> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

This patch makes me uncomfortable, but I'm not entirely sure why.  Is
there a reason that the process is manipulated directly instead of
using a completion?  Perhaps I'm bother by the joint use of
->dead + ->removing_task that is bothering me.  I need to mull on this
one some more.

Also, comments below...

> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 21da9c1..a41f614 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -11,7 +11,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/idr.h>
>  #include <linux/slab.h>
> -
> +#include <linux/sched.h>
>  
>  /* Optional implementation infrastructure for GPIO interfaces.
>   *
> @@ -95,6 +95,10 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
>  	const struct gpio_chip *chip = desc->chip;
>  	const int gpio = chip->base + offset;
>  
> +	/* no new requests if chip is being deregistered */
> +	if ((chip->dead) && (test_bit(FLAG_REQUESTED, &desc->flags) == 0))
> +		return -ENODEV;
> +

Not holding spin lock.  Race condition.

>  	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
>  			"autorequest GPIO-%d\n", gpio)) {
>  		if (!try_module_get(chip->owner)) {
> @@ -1041,6 +1045,11 @@ int gpiochip_add(struct gpio_chip *chip)
>  		goto fail;
>  	}
>  
> +	/* make sure is not registered as already dead */
> +	chip->dead = 0;
> +
> +	chip->removing_task = NULL;
> +
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
>  	if (base < 0) {
> @@ -1134,6 +1143,75 @@ int gpiochip_remove(struct gpio_chip *chip)
>  EXPORT_SYMBOL_GPL(gpiochip_remove);
>  
>  /**
> + * gpiochip_remove_sleeping() - unregister a gpio_chip sleeping when needed
> + * @chip: the chip to unregister
> + * @interruptible: should the sleep be interruptible?
> + *
> + * If any of GPIOs are still requested this function will wait for them
> + * to be freed.
> + */
> +int gpiochip_remove_sleeping(struct gpio_chip *chip, int interruptible)
> +{
> +	unsigned	id;
> +	unsigned long	flags;
> +
> +	/* prevent new requests */
> +	chip->dead = 1;

race, grab spinlock first.

> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	while (1) {
> +		int busy = 0;
> +
> +		for (id = chip->base; id < chip->base + chip->ngpio; id++) {
> +			if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
> +				/* printk("ID %u is still requested\n", id); */

Drop the commented out printk

> +				busy = 1;
> +				break;
> +			}
> +		}

There has to be a better way to determine if a chip is still used
without resorting to a loop each and every time through.  At the very
least, this is a duplicate code block from gpiochip_remove which
should be generalized instead of duplicated.

In fact, gpiochip_remove could be called directly here (with some
spin_lock refactoring) and exit the loop if it doesn't return -EBUSY.

> +
> +		if (!busy)
> +			break;
> +
> +		set_current_state(interruptible ?
> +				TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
> +		chip->removing_task = current;
> +
> +		spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +		schedule();
> +
> +		/* printk("GPIO remove woken up\n"); */

remove

> +
> +		spin_lock_irqsave(&gpio_lock, flags);
> +
> +		if (interruptible && (signal_pending(current))) {
> +			/* printk("GPIO remove signal pending\n"); */

remove

> +			/* mark chip alive again */
> +			chip->dead = 0;
> +			chip->removing_task = NULL;
> +
> +			spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +			return -EINTR;
> +		}
> +	}
> +
> +	of_gpiochip_remove(chip);
> +
> +	for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +		gpio_desc[id].chip = NULL;

Don't open code this.  Generalize the code in gpiochip_remove() instead.

> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	gpiochip_unexport(chip);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_remove_sleeping);
> +
> +/**
>   * gpiochip_find() - iterator for locating a specific gpio_chip
>   * @data: data to pass to match function
>   * @callback: Callback function to check gpio_chip
> @@ -1186,6 +1264,12 @@ int gpio_request(unsigned gpio, const char *label)
>  	if (chip == NULL)
>  		goto done;
>  
> +	/* chip is being deregistered, prohibit new requests */
> +	if (chip->dead) {
> +		status = -ENODEV;
> +		goto done;
> +	}
> +
>  	if (!try_module_get(chip->owner))
>  		goto done;
>  
> @@ -1254,6 +1338,9 @@ void gpio_free(unsigned gpio)
>  		module_put(desc->chip->owner);
>  		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
>  		clear_bit(FLAG_REQUESTED, &desc->flags);
> +
> +		if (chip->removing_task != NULL)
> +			wake_up_process(chip->removing_task);
>  	} else
>  		WARN_ON(extra_checks);
>  
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..8576732 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -119,6 +119,9 @@ struct gpio_chip {
>  	const char		*const *names;
>  	unsigned		can_sleep:1;
>  	unsigned		exported:1;
> +	unsigned		dead:1;
> +
> +	struct task_struct	*removing_task;
>  
>  #if defined(CONFIG_OF_GPIO)
>  	/*
> @@ -139,6 +142,7 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
>  /* add/remove chips */
>  extern int gpiochip_add(struct gpio_chip *chip);
>  extern int __must_check gpiochip_remove(struct gpio_chip *chip);
> +extern int gpiochip_remove_sleeping(struct gpio_chip *chip, int interruptible);
>  extern struct gpio_chip *gpiochip_find(void *data,
>  					int (*match)(struct gpio_chip *chip,
>  						     void *data));
> 
> 
