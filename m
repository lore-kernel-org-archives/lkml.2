Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1BHXRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:17:09 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54497 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790Ab1BHXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:17:05 -0500
Message-ID: <4D51CF3D.9000103@metafoo.de>
Date: Wed, 09 Feb 2011 00:18:21 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>, Dmitry Torokhov <dtor@mail.ru>,
        "Arnd Bergmann (maintainer:GENERIC INCLUDE/A...)" <arnd@arndb.de>,
        "Andrew Morton (commit_signer:4/8=50%)" <akpm@linux-foundation.org>,
        "Mark Brown (commit_signer:1/8=12%)" 
	<broonie@opensource.wolfsonmicro.com>,
        "Anton Vorontsov (commit_signer:1/8=12%)" <cbouatmailru@gmail.com>,
        "Greg Kroah-Hartman (commit_signer:1/8=12%)" <greg@kroah.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] gpio: make newer functionality available outside of GPIOLIB
References: <1297205075-11396-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1297205075-11396-1-git-send-email-w.sang@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 11:44 PM, Wolfram Sang wrote:
> The gpio subsystems offers an API which requires a dependency on GENERIC_GPIO
> when used by drivers. There is also implementation framework of this API, so
> archs can select GPIOLIB if they intend to use it. But they don't have to, they
> can still provide GENERIC_GPIO without GPIOLIB using custom routines.
> 
> Commit 3e45f1d1155894e6f4291f5536b224874d52d8e2 (gpio: introduce
> gpio_request_one() and friends) added some functions, defines and a struct to
> the API, but made them available only for GPIOLIB. So, drivers using these new
> functions will fail in the case of GENERIC_GPIO && !GPIOLIB.
Actually the patch fixes only the case where !GENERIC_GPIO.
In the GENERIC_GPIO && !GPIOLIB case gpio_request_one and friends are likely to
be undefined unless the arch gpio code actually implements them.

Given that these functions are pretty generic and build on top of the generic
gpio interface I think they should be available if GENERIC_GPIO is selected and
not only just through GPIOLIB. Otherwise all the archs not using gpiolib but
providing the gpio api would have to be patched as well.

- Lars

> the include-files.
> 
> Fixes issues like (in linux-next currently):
> 
> drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN' undeclared (first use in this function)
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
> Based on 2.6.38-rc4. Compile tested on x86.
> 
>  include/asm-generic/gpio.h   |   31 +++++--------------------------
>  include/linux/gpio.h         |    2 +-
>  include/linux/gpio_generic.h |   26 ++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+), 27 deletions(-)
>  create mode 100644 include/linux/gpio_generic.h
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..ebc73bc 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -4,6 +4,7 @@
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/gpio_generic.h>
>  
>  #ifdef CONFIG_GPIOLIB
>  
> @@ -158,6 +159,10 @@ extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
>  extern int gpio_get_value_cansleep(unsigned gpio);
>  extern void gpio_set_value_cansleep(unsigned gpio, int value);
>  
> +extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
> +extern int gpio_request_array(struct gpio *array, size_t num);
> +extern void gpio_free_array(struct gpio *array, size_t num);
> +
>  
>  /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
>   * the GPIO is constant and refers to some always-present controller,
> @@ -170,32 +175,6 @@ extern int __gpio_cansleep(unsigned gpio);
>  
>  extern int __gpio_to_irq(unsigned gpio);
>  
> -#define GPIOF_DIR_OUT	(0 << 0)
> -#define GPIOF_DIR_IN	(1 << 0)
> -
> -#define GPIOF_INIT_LOW	(0 << 1)
> -#define GPIOF_INIT_HIGH	(1 << 1)
> -
> -#define GPIOF_IN		(GPIOF_DIR_IN)
> -#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> -#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> -
> -/**
> - * struct gpio - a structure describing a GPIO with configuration
> - * @gpio:	the GPIO number
> - * @flags:	GPIO configuration as specified by GPIOF_*
> - * @label:	a literal description string of this GPIO
> - */
> -struct gpio {
> -	unsigned	gpio;
> -	unsigned long	flags;
> -	const char	*label;
> -};
> -
> -extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
> -extern int gpio_request_array(struct gpio *array, size_t num);
> -extern void gpio_free_array(struct gpio *array, size_t num);
This conflicts with the patch making "array" const.

> -
>  #ifdef CONFIG_GPIO_SYSFS
>  
>  /*
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 32720ba..584ceb6 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -11,9 +11,9 @@
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/gpio_generic.h>
>  
>  struct device;
> -struct gpio;
>  struct gpio_chip;
>  
>  /*
> diff --git a/include/linux/gpio_generic.h b/include/linux/gpio_generic.h
> new file mode 100644
> index 0000000..d662697
> --- /dev/null
> +++ b/include/linux/gpio_generic.h
> @@ -0,0 +1,26 @@
> +#ifndef __LINUX_GPIO_GENERIC_H
> +#define __LINUX_GPIO_GENERIC_H
> +
> +/**
> + * struct gpio - a structure describing a GPIO with configuration
> + * @gpio:	the GPIO number
> + * @flags:	GPIO configuration as specified by GPIOF_*
> + * @label:	a literal description string of this GPIO
> + */
> +struct gpio {
> +	unsigned	gpio;
> +	unsigned long	flags;
> +	const char	*label;
> +};
> +
> +#define GPIOF_DIR_OUT	(0 << 0)
> +#define GPIOF_DIR_IN	(1 << 0)
> +
> +#define GPIOF_INIT_LOW	(0 << 1)
> +#define GPIOF_INIT_HIGH	(1 << 1)
> +
> +#define GPIOF_IN		(GPIOF_DIR_IN)
> +#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> +#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> +
> +#endif /* __LINUX_GPIO_GENERIC_H */

