Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1JVVaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 17:30:20 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:36259 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab1JVVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 17:30:19 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Paul Schilling <paul.s.schilling@gmail.com>
Subject: Re: [PATCH 05/14] ARM : SAMSUNG : Add GPIO_EXTRA for S3C2416.
Date: Sat, 22 Oct 2011 23:30:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <GPIO_extra> <1319256492-4975-1-git-send-email-paul.s.schilling@gmail.com>
In-Reply-To: <1319256492-4975-1-git-send-email-paul.s.schilling@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110222330.09918.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 22 Oktober 2011, 06:08:12 schrieb Paul Schilling:
> The S3C2416 has more GPIO than other S3C24XX processors.
> 
> Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
> ---
>  arch/arm/mach-s3c2410/include/mach/gpio.h |   15 ++++++++++-----
>  arch/arm/plat-s3c24xx/gpiolib.c           |   10 ++++++++--
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2410/include/mach/gpio.h
> b/arch/arm/mach-s3c2410/include/mach/gpio.h index f7f6b07..65a0bce 100644
> --- a/arch/arm/mach-s3c2410/include/mach/gpio.h
> +++ b/arch/arm/mach-s3c2410/include/mach/gpio.h
> @@ -20,22 +20,27 @@
>   * devices that need GPIO.
>   */
> 
> +#if defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
> +#define ARCH_NR_GPIOS	(32 * 12 + CONFIG_S3C24XX_GPIO_EXTRA)
> +#else
>  #ifdef CONFIG_CPU_S3C244X
>  #define ARCH_NR_GPIOS	(32 * 9 + CONFIG_S3C24XX_GPIO_EXTRA)
> -#elif defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
> -#define ARCH_NR_GPIOS	(32 * 12 + CONFIG_S3C24XX_GPIO_EXTRA)
>  #else
>  #define ARCH_NR_GPIOS	(256 + CONFIG_S3C24XX_GPIO_EXTRA)
>  #endif
> +#endif
why are you moving these around? I don't see a functional change.

 
>  #include <asm-generic/gpio.h>
>  #include <mach/gpio-nrs.h>
>  #include <mach/gpio-fns.h>
> 
> -#ifdef CONFIG_CPU_S3C244X
> -#define S3C_GPIO_END	(S3C2410_GPJ(0) + 32)
> -#elif defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
> +
> +#if defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
>  #define S3C_GPIO_END	(S3C2410_GPM(0) + 32)
>  #else
> +#ifdef CONFIG_CPU_S3C244X
> +#define S3C_GPIO_END	(S3C2410_GPJ(0) + 32)
> +else
>  #define S3C_GPIO_END	(S3C2410_GPH(0) + 32)
>  #endif
> +#endif
same as above

> diff --git a/arch/arm/plat-s3c24xx/gpiolib.c
> b/arch/arm/plat-s3c24xx/gpiolib.c index 243b641..93d4734 100644
> --- a/arch/arm/plat-s3c24xx/gpiolib.c
> +++ b/arch/arm/plat-s3c24xx/gpiolib.c
> @@ -34,6 +34,11 @@ static int s3c24xx_gpiolib_banka_input(struct gpio_chip
> *chip, unsigned offset) return -EINVAL;
>  }
> 
> +static int s3c24xx_gpiolib_bankm_output(struct gpio_chip *chip, unsigned
> offset, int value) +{
> +	return -EINVAL;
> +}
> +
>  static int s3c24xx_gpiolib_banka_output(struct gpio_chip *chip,
>  					unsigned offset, int value)
>  {
> @@ -93,7 +98,7 @@ struct s3c_gpio_chip s3c24xx_gpios[] = {
>  			.base			= S3C2410_GPA(0),
>  			.owner			= THIS_MODULE,
>  			.label			= "GPIOA",
> -			.ngpio			= 24,
> +			.ngpio			= 27,
>  			.direction_input	= s3c24xx_gpiolib_banka_input,
>  			.direction_output	= s3c24xx_gpiolib_banka_output,
>  		},
> @@ -167,7 +172,7 @@ struct s3c_gpio_chip s3c24xx_gpios[] = {
>  			.base			= S3C2410_GPH(0),
>  			.owner			= THIS_MODULE,
>  			.label			= "GPIOH",
> -			.ngpio			= 11,
> +			.ngpio			= 15,
>  		},
>  	},
>  		/* GPIOS for the S3C2443 and later devices. */
> @@ -206,6 +211,7 @@ struct s3c_gpio_chip s3c24xx_gpios[] = {
>  			.owner			= THIS_MODULE,
>  			.label			= "GPIOM",
>  			.ngpio			= 2,
> +			.direction_output	= s3c24xx_gpiolib_bankm_output,
>  		},
>  	},
>  };
looks ok, but you will probably have to coordinate with Kgene as the Samsung 
gpio support gets consolidated for 3.2 (i.e. in linux-next it currently sits 
in drivers/gpio/gpio-samsung.c)

Heiko
