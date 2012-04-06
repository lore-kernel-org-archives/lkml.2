Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2DFOol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:44:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab2DFOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:40 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 21:48:32 -0700
Message-Id: <20120406044832.7C80D3E0ED5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2012 16:14:49 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Allow drivers to use the modern request and configure idiom together
> with devres.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/devres.c      |   29 +++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |    2 ++
>  include/linux/gpio.h       |    6 ++++++
>  3 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
> index 3dd2939..d21a9ff 100644
> --- a/drivers/gpio/devres.c
> +++ b/drivers/gpio/devres.c
> @@ -71,6 +71,35 @@ int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
>  EXPORT_SYMBOL(devm_gpio_request);
>  
>  /**
> + *	devm_gpio_request_one - request a single GPIO with initial setup
> + *	@dev:   device to request for
> + *	@gpio:	the GPIO number
> + *	@flags:	GPIO configuration as specified by GPIOF_*
> + *	@label:	a literal description string of this GPIO
> + */
> +int devm_gpio_request_one(struct device *dev, unsigned gpio,
> +			  unsigned long flags, const char *label)
> +{
> +	unsigned *dr;
> +	int rc;
> +
> +	dr = devres_alloc(devm_gpio_release, sizeof(unsigned), GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	rc = gpio_request_one(gpio, flags, label);
> +	if (rc) {
> +		devres_free(dr);
> +		return rc;
> +	}
> +
> +	*dr = gpio;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}

Can we make devm_gpio_request a static inline wrapper around
devm_gpio_request_one() with the flags field set to '0'?  I don't liek
the duplication of this function.

Similarily, gpio_request() should actually be a static inline around
gpio_request_one() instead of the other way around as it is currently
written.

> +
> +/**
>   *      devm_gpio_free - free an interrupt
>   *      @dev: device to free gpio for
>   *      @gpio: gpio to free
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 5f52690..4ead123 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -179,6 +179,8 @@ extern void gpio_free_array(const struct gpio *array, size_t num);
>  
>  /* bindings for managed devices that want to request gpios */
>  int devm_gpio_request(struct device *dev, unsigned gpio, const char *label);
> +int devm_gpio_request_one(struct device *dev, unsigned gpio,
> +			  unsigned long flags, const char *label);
>  void devm_gpio_free(struct device *dev, unsigned int gpio);
>  
>  #ifdef CONFIG_GPIO_SYSFS
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index ceb8eef..a8bacb8 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -101,6 +101,12 @@ static inline int gpio_request_one(unsigned gpio,
>  	return -ENOSYS;
>  }
>  
> +static inline int devm_gpio_request_one(struct device *dev, unsigned gpio,
> +					unsigned long flags, const char *label)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_request_array(const struct gpio *array, size_t num)
>  {
>  	return -ENOSYS;
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
