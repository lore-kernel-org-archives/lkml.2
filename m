Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0ETSGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:06:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288Ab0ETSGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:06:12 -0400
Date: Thu, 20 May 2010 11:06:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: felipe.balbi@nokia.com
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-Id: <20100520110600.be702f58.akpm@linux-foundation.org>
In-Reply-To: <1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
	<1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 13:02:30 +0300
felipe.balbi@nokia.com wrote:

> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> Few architectures, like OMAP, allow you to set
> a debouncing time for the gpio before generating
> the IRQ. Teach gpiolib about that.
> 
> ...
>
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1447,6 +1447,49 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpio_direction_output);
>  
> +/**
> + * gpio_set_debounce - sets @debounce time for a @gpio
> + * @gpio: the gpio to set debounce time
> + * @debounce: debounce time is microseconds
> + */
> +int gpio_set_debounce(unsigned gpio, unsigned debounce)
> +{
> +	unsigned long		flags;
> +	struct gpio_chip	*chip;
> +	struct gpio_desc	*desc = &gpio_desc[gpio];
> +	int			status = -EINVAL;
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	if (!gpio_is_valid(gpio))
> +		goto fail;
> +	chip = desc->chip;
> +	if (!chip || !chip->set || !chip->set_debounce)
> +		goto fail;
> +	gpio -= chip->base;
> +	if (gpio >= chip->ngpio)
> +		goto fail;
> +	status = gpio_ensure_requested(desc, gpio);
> +	if (status < 0)
> +		goto fail;
> +
> +	/* now we know the gpio is valid and chip won't vanish */
> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	might_sleep_if(extra_checks && chip->can_sleep);
> +
> +	return chip->set_debounce(chip, gpio, debounce);
> +
> +fail:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	if (status)
> +		pr_debug("%s: gpio-%d status %d\n",
> +			__func__, gpio, status);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_set_debounce);

nitlet: I suspect this function is taking gpio_lock sooner than it
strictly needs to.  Find-tuning that would decrease contention by an
insignificant amount ;)

