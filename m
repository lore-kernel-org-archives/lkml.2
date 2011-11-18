Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1KRV7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:59:37 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12593 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1KRV7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:59:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Nov 2011 13:59:34 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Nov 2011 13:59:33 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcymOxqt4N28d+4PQCSbQZfBgOW+fQAAfVAA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
 <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua>
In-Reply-To: <4EC6D1D5.9060808@solonet.org.ua>
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

Denis Kuzmenko wrote at Friday, November 18, 2011 2:45 PM:
> Make s3c24xx LEDS driver use gpiolib. Disable using pull-resistor when not
> using S3C24XX_LEDF_TRISTATE and enble it when in opposite case.
> 
> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>

>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
> +		/*
> +		 * pull is needed here to protect pin from being left
> +		 * floating
> +		 */
> +		ret = s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_UP);
> +		if (ret)
> +			s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_DOWN);

Sorry, could you explain why it's appropriate to configure a pull here
at all, let alone why it's OK to have a random pull on the line?

> +		/* initially turn off led */
> +		ret = gpio_direction_input(pdata->gpio);
>  	} else {
> -		s3c2410_gpio_pullup(pdata->gpio, 0);
> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
> +		/* no point in having a pull-up as we are always driving */
> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
> +		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
> +								pdata->name);
> +		/* initially turn off led */
> +		ret = gpio_direction_output(pdata->gpio,
> +				!!(pdata->flags & S3C24XX_LEDF_ACTLOW));

Wouldn't it be better to pass GPIOF_OUT_INIT_HIGH or GPIOF_OUT_INIT_LOW
to gpio_request_one() based on S3C24XX_LEDF_ACTLOW, and avoid the call to
gpio_direction_output; that will avoid glitching the line for a short time.

I'm fine with the rest of the code.

-- 
nvpublic

