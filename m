Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2BIJLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:11:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49337 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2BIJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:11:32 -0500
Date: Thu, 9 Feb 2012 09:11:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Kleine-Budde <mkl@blackshift.org>
Cc: linux-kernel@vger.kernel.org, Imre Kaloz <kaloz@openwrt.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Message-ID: <20120209091124.GR889@n2100.arm.linux.org.uk>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org> <1328729069-21308-2-git-send-email-mkl@blackshift.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328729069-21308-2-git-send-email-mkl@blackshift.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:24:28PM +0100, Marc Kleine-Budde wrote:
> diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
> index 3841ab4..963f752 100644
> --- a/arch/arm/mach-ixp4xx/common.c
> +++ b/arch/arm/mach-ixp4xx/common.c
> @@ -36,6 +36,7 @@
>  #include <asm/page.h>
>  #include <asm/irq.h>
>  #include <asm/sched_clock.h>
> +#include <asm/gpio.h>

linux/gpio.h

> diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> index 83d6b4e..093dfad 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> @@ -27,49 +27,31 @@
>  
>  #include <linux/kernel.h>
>  #include <mach/hardware.h>
> +#include <asm-generic/gpio.h>			/* cansleep wrappers */
>  
>  #define __ARM_GPIOLIB_COMPLEX
>  
> -static inline int gpio_request(unsigned gpio, const char *label)
> -{
> -	return 0;
> -}
> -
> -static inline void gpio_free(unsigned gpio)
> -{
> -	might_sleep();
> -
> -	return;
> -}
> -
> -static inline int gpio_direction_input(unsigned gpio)
> -{
> -	gpio_line_config(gpio, IXP4XX_GPIO_IN);
> -	return 0;
> -}
> -
> -static inline int gpio_direction_output(unsigned gpio, int level)
> -{
> -	gpio_line_set(gpio, level);
> -	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
> -	return 0;
> -}
> +#define NR_BUILTIN_GPIO 16
>  
>  static inline int gpio_get_value(unsigned gpio)
>  {
> -	int value;
> -
> -	gpio_line_get(gpio, &value);
> -
> -	return value;
> +	if (gpio < NR_BUILTIN_GPIO) {
> +		int value;
> +		gpio_line_get(gpio, &value);
> +		return value;
> +	} else
> +		return __gpio_get_value(gpio);
>  }
>  
>  static inline void gpio_set_value(unsigned gpio, int value)
>  {
> -	gpio_line_set(gpio, value);
> +	if (gpio < NR_BUILTIN_GPIO)
> +		gpio_line_set(gpio, value);
> +	else
> +		__gpio_set_value(gpio, value);
>  }
>  
> -#include <asm-generic/gpio.h>			/* cansleep wrappers */
> +#define gpio_cansleep __gpio_cansleep
>  
>  extern int gpio_to_irq(int gpio);
>  #define gpio_to_irq gpio_to_irq

Does anything on ixp4xx require fast access to on-chip GPIOs?  If not,
it would be much better to get rid of this and just use the standard
wrapping, which can be done by changing this entire file to be just a
single line:

/* empty */
