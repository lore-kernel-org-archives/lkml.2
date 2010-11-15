Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0KODy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:54:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30245 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KODy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:54:56 -0500
Date: Mon, 15 Nov 2010 12:55:17 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 2/2] h1940-leds: Fix compile issue introduced by
 latch-related changes
In-reply-to: <1289248308-21272-2-git-send-email-anarsoul@gmail.com>
To: rpurdie@rpsys.net, arnaud.patard@rtp-net.org
Cc: "'Vasily Khoruzhick'" <anarsoul@gmail.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <004201cb8478$ed3dbfa0$c7b93ee0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Act/hCMC5lGpZQH2ThGLgxJzqNpIqgE6GORA
References: <1289248308-21272-1-git-send-email-anarsoul@gmail.com>
 <1289248308-21272-2-git-send-email-anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Monday 08 November 2010 09:15:55 Kukjin Kim wrote:
> Now, happens following build error due to commit
> 14477095abc661a9f195ca4733bb739c54794b32 'ARM: h1940: Use gpiolib for
latch
> access' with s3c2410_defconfig.
> 
> drivers/leds/leds-h1940.c: In function 'h1940_greenled_set':
> drivers/leds/leds-h1940.c:33: error: implicit declaration of function
> 'h1940_latch_control'
> 
> The h1940_greenled_set(), h1940_redled_set(), and h1940_blueled_set() in
> drivers/leds/leds-h1940.c call h1940_latch_control()...

Please check below Vasily's patch about above error.

And as a note, latest Linus' tree has following error with
s3c2410_defconfig.

drivers/built-in.o: In function `led_trigger_set':
drivers/leds/led-triggers.c:116: undefined reference to `led_brightness_set'
make: *** [.tmp_vmlinux1] Error 1

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

Vasily Khoruzhick wrote:
> 
> Latch API was converted to gpiolib API as result we got this compile
> error:
> 
> drivers/leds/leds-h1940.c: In function 'h1940_greenled_set':
> drivers/leds/leds-h1940.c:33: error: implicit declaration of function
> 'h1940_latch_control
> 
> Adapt h1940-leds driver to new changes and fix compile issue.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  drivers/leds/leds-h1940.c |   67
++++++++++++++++++++++++++++++++-----------
> --
>  1 files changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
> index 173d104..d9c2729 100644
> --- a/drivers/leds/leds-h1940.c
> +++ b/drivers/leds/leds-h1940.c
> @@ -30,18 +30,18 @@ static void h1940_greenled_set(struct led_classdev
> *led_dev,
>  {
>  	switch (value) {
>  	case LED_HALF:
> -		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
> -		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
> +		gpio_set_value(S3C2410_GPA(7), 1);
>  		break;
>  	case LED_FULL:
> -		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
> -		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
> +		gpio_set_value(H1940_LATCH_LED_GREEN, 1);
> +		gpio_set_value(S3C2410_GPA(7), 1);
>  		break;
>  	default:
>  	case LED_OFF:
> -		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
> -		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
> -		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
> +		gpio_set_value(H1940_LATCH_LED_GREEN, 0);
> +		gpio_set_value(S3C2410_GPA(7), 0);
>  		break;
>  	}
>  }
> @@ -60,18 +60,18 @@ static void h1940_redled_set(struct led_classdev
*led_dev,
>  {
>  	switch (value) {
>  	case LED_HALF:
> -		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
> -		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
> +		gpio_set_value(S3C2410_GPA(1), 1);
>  		break;
>  	case LED_FULL:
> -		h1940_latch_control(0, H1940_LATCH_LED_RED);
> -		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
> +		gpio_set_value(H1940_LATCH_LED_RED, 1);
> +		gpio_set_value(S3C2410_GPA(1), 1);
>  		break;
>  	default:
>  	case LED_OFF:
> -		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
> -		h1940_latch_control(H1940_LATCH_LED_RED, 0);
> -		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
> +		gpio_set_value(H1940_LATCH_LED_RED, 0);
> +		gpio_set_value(S3C2410_GPA(1), 0);
>  		break;
>  	}
>  }
> @@ -91,11 +91,11 @@ static void h1940_blueled_set(struct led_classdev
> *led_dev,
>  {
>  	if (value) {
>  		/* flashing Blue */
> -		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
> -		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
> +		gpio_set_value(S3C2410_GPA(3), 1);
>  	} else {
> -		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
> -		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
> +		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
> +		gpio_set_value(S3C2410_GPA(3), 0);
>  	}
> 
>  }
> @@ -108,7 +108,24 @@ static struct led_classdev h1940_blueled = {
> 
>  static int __devinit h1940leds_probe(struct platform_device *pdev)
>  {
> -	int ret;
> +	int ret, gpioidx = 0;
> +	int led_gpios[] = {
> +		H1940_LATCH_LED_GREEN,
> +		H1940_LATCH_LED_RED,
> +		H1940_LATCH_LED_FLASH,
> +		S3C2410_GPA(1),
> +		S3C2410_GPA(3),
> +		S3C2410_GPA(7),
> +	};
> +
> +	for (gpioidx = 0; gpioidx < ARRAY_SIZE(led_gpios); gpioidx++) {
> +		ret = gpio_request(led_gpios[gpioidx], "h1940 leds");
> +		if (ret < 0)
> +			goto err_gpio;
> +		ret = gpio_direction_output(led_gpios[gpioidx], 0);
> +		if (ret < 0)
> +			goto err_gpio;
> +	}
> 
>  	ret = led_classdev_register(&pdev->dev, &h1940_greenled);
>  	if (ret)
> @@ -129,6 +146,10 @@ err_blue:
>  err_red:
>  	led_classdev_unregister(&h1940_greenled);
>  err_green:
> +err_gpio:
> +	while (--gpioidx >= 0)
> +		gpio_free(led_gpios[gpioidx]);
> +
>  	return ret;
>  }
> 
> @@ -137,6 +158,14 @@ static int h1940leds_remove(struct platform_device
*pdev)
>  	led_classdev_unregister(&h1940_greenled);
>  	led_classdev_unregister(&h1940_redled);
>  	led_classdev_unregister(&h1940_blueled);
> +
> +	gpio_free(H1940_LATCH_LED_GREEN);
> +	gpio_free(H1940_LATCH_LED_RED);
> +	gpio_free(H1940_LATCH_LED_FLASH);
> +	gpio_free(S3C2410_GPA(1));
> +	gpio_free(S3C2410_GPA(3));
> +	gpio_free(S3C2410_GPA(7));
> +
>  	return 0;
>  }
> 
> --
> 1.7.3.2

