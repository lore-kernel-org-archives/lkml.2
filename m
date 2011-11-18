Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1KRRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:08:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15727 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1KRRIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:08:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Nov 2011 09:08:41 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>
CC: Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Nov 2011 09:08:39 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcylafKd4WjNCkQcSaqWprplgEduMwAqR+hg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
In-Reply-To: <4EC572E1.1020209@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Thursday, November 17, 2011 1:47 PM:
> Make s3c24xx LEDS driver use gpiolib.

Structurally this looks fine to me, but I made some slightly nit-picky
comments below.

> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c

>  static void s3c24xx_led_set(struct led_classdev *led_cdev,
> -			    enum led_brightness value)
> +				enum led_brightness value)

Seems unnecessary, but is probably fine.

>  {
>  	struct s3c24xx_gpio_led *led = to_gpio(led_cdev);
>  	struct s3c24xx_led_platdata *pd = led->pdata;
> 
> -	/* there will be a short delay between setting the output and
> -	 * going from output to input when using tristate. */
> -
> -	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
> -			    (pd->flags & S3C24XX_LEDF_ACTLOW));
> -
> -	if (pd->flags & S3C24XX_LEDF_TRISTATE)
> -		s3c2410_gpio_cfgpin(pd->gpio,
> -			value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);
> +	/*
> +	 * ensure value is 0 or 1 to use it with bitwise XOR (^)
> +	 * (only 100% brightness is supported)
> +	 */
> +	value = value ? 1 : 0;
> +
> +	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
> +		if (value) {
> +			/* invert value if S3C24XX_LEDF_ACTLOW is set */
> +			value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
> +			gpio_direction_output(pd->gpio, value);
> +		} else {
> +			gpio_direction_input(pd->gpio);
> +		}
> +	} else {
> +		/* invert value if S3C24XX_LEDF_ACTLOW is set */
> +		value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
> +		gpio_set_value(pd->gpio, value);
> +	}

I'd be tempted to simplify the new code a little:

	/* invert value if S3C24XX_LEDF_ACTLOW is set */
	value = !!(pd->flags & S3C24XX_LEDF_ACTLOW) ^ !!value;

	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
		if (value)
			gpio_direction_output(pd->gpio, value);
		else
			gpio_direction_input(pd->gpio);
	} else {
		gpio_set_value(pd->gpio, value);
	}

> @@ -76,7 +88,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
>  	led = kzalloc(sizeof(struct s3c24xx_gpio_led), GFP_KERNEL);
>  	if (led == NULL) {
>  		dev_err(&dev->dev, "No memory for device\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_kzalloc;
>  	}

That works fine, but isn't strictly necessary; no previous allocations
have been made here that need to be undone.

> @@ -91,12 +104,15 @@ static int s3c24xx_led_probe(struct platform_device
> *dev)
>  	/* no point in having a pull-up if we are always driving */
> 
>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
> +		ret = gpio_request_one(pdata->gpio, GPIOF_IN, pdata->name);
>  	} else {
> -		s3c2410_gpio_pullup(pdata->gpio, 0);
> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
> +		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
> +												pdata->name);
> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
> +	}

I always prefer not to duplicate function calls, but rather to calculate
the differing data (either directly in the call, or into a temporary
variable first), so:

	ret = gpio_request_one(pdata->gpio, 
				(pdata->flags & S3C24XX_LEDF_TRISTATE) ?
				GPIOF_IN : GPIOF_OUT_INIT_LOW,
				pdata->name);

	if (!(pdata->flags & S3C24XX_LEDF_TRISTATE))
		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);


> +	if (ret < 0) {
> +		dev_err(&dev->dev, "gpio_request failed\n");
> +		goto err_gpio_request;
>  	}

You should probably move that error check right after calling
gpio_request_one()

-- 
nvpublic

