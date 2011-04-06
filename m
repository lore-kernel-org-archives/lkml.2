Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1DFLpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:45:33 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:1551 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab1DFLpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:45:32 -0400
X-SpamScore: -20
X-BigFish: VS-20(zzbb2dK9371O1432N98dK4015Lc8kzz1202hzz8275bhz2dh2a8h637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4D9C524F.5050907@freescale.com>
Date: Wed, 6 Apr 2011 08:45:19 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kernel@pengutronix.de>
Subject: Re: [PATCH v2] leds: provide helper to register "leds-gpio" devices
References: <20110405163338.GA11832@n2100.arm.linux.org.uk> <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1302035048-25819-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On 4/5/2011 5:24 PM, Uwe Kleine-König wrote:
> This function makes a deep copy of the platform data to allow it to live
> in init memory.
> The definition cannot go into leds-gpio.c because it needs to be builtin
> to be usable by platforms.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks,

Fabio Estevam

> ---
> changes since v1:
>  - don't add __init to the declaration of gpio_led_register_device
> 
>  drivers/leds/led-core.c |   27 ++++++++++++++++++++++++++-
>  include/linux/leds.h    |   12 ++++++++++++
>  2 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 016d19f..a9a762e 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -2,8 +2,10 @@
>   * LED Class Core
>   *
>   * Copyright 2005-2006 Openedhand Ltd.
> + * Richard Purdie <rpurdie@openedhand.com>
>   *
> - * Author: Richard Purdie <rpurdie@openedhand.com>
> + * Copyright (C) 2009-2010 Pengutronix
> + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -16,6 +18,9 @@
>  #include <linux/module.h>
>  #include <linux/rwsem.h>
>  #include <linux/leds.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
>  #include "leds.h"
>  
>  DECLARE_RWSEM(leds_list_lock);
> @@ -23,3 +28,23 @@ EXPORT_SYMBOL_GPL(leds_list_lock);
>  
>  LIST_HEAD(leds_list);
>  EXPORT_SYMBOL_GPL(leds_list);
> +
> +struct platform_device *__init gpio_led_register_device(
> +                const struct gpio_led_platform_data *pdata)
> +{
> +	struct platform_device *ret = ERR_PTR(-ENOMEM);
> +	struct gpio_led_platform_data _pdata = *pdata;
> +	_pdata.leds = kmemdup(pdata->leds,
> +			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
> +
> +	if (!_pdata.leds)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = platform_device_register_resndata(NULL, "leds-gpio", -1,
> +			NULL, 0, &_pdata, sizeof(_pdata));
> +
> +	if (IS_ERR(ret))
> +		kfree(_pdata.leds);
> +
> +	return ret;
> +}
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 61e0340..1c82006 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -207,5 +207,17 @@ struct gpio_led_platform_data {
>  					unsigned long *delay_off);
>  };
>  
> +/**
> + * gpio_led_register_device - register a gpio-led device
> + * @pdata: the platform data used for the new device
> + *
> + * Use this function instead of platform_device_add()ing a static struct
> + * platform_device.
> + *
> + * Note: as pdata and pdata->leds is copied these usually can and should be
> + * __initdata.
> + */
> +struct platform_device *gpio_led_register_device(
> +		const struct gpio_led_platform_data *pdata);
>  
>  #endif		/* __LINUX_LEDS_H_INCLUDED */



