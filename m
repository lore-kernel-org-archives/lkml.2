Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2AIMuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:50:21 -0500
Received: from smtp-out-233.synserver.de ([212.40.185.233]:1029 "EHLO
	smtp-out-233.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2AIMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:50:20 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20731
Message-ID: <4F0AE2BF.6080605@metafoo.de>
Date: Mon, 09 Jan 2012 13:51:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: christian.gmeiner@gmail.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        bigeasy@linutronix.de, rpurdie@rpsys.net
Subject: Re: [PATCH v2] add led driver for Bachmann's ot200
References: <4F0AC06C.3000502@gmail.com>
In-Reply-To: <4F0AC06C.3000502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 11:24 AM, Christian Gmeiner wrote:
> From a7fecf3426ef98fdd19e9d2610665b9d1ce358a0 Mon Sep 17 00:00:00 2001
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de
> <mailto:bigeasy@linutronix.de>>
> Date: Mon, 9 Jan 2012 10:09:50 +0100
> Subject: [PATCH v2] add led driver for Bachmann's ot200
> 
> This patch adds support for leds on Bachmann's ot200 visualisation device.
> The device has three leds on the back panel (led_err, led_init and led_run)
> and can handle up to seven leds on the front panel.
> 
> The driver was written by Linutronix on behalf of
> Bachmann electronic GmbH.
> 
> Changes in v2:
> - *incorporated* feedback from Andrew Morton and Lars-Peter Clausen
> 

looks good to me except some minor style issues and the <mailto:...> tags.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de
> <mailto:bigeasy@linutronix.de>>
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com
> <mailto:christian.gmeiner@gmail.com>>
> ---
> [...]
> diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
> new file mode 100644
> index 0000000..4d000ac
> --- /dev/null
> +++ b/drivers/leds/leds-ot200.c
> @@ -0,0 +1,177 @@
> [...]
> +
> +static int __devinit ot200_led_probe(struct platform_device *pdev)
> +{
> +    int i;
> +    int ret;
> +
> +    for (i = 0; i < ARRAY_SIZE(leds); i++) {
> +
> +        leds[i].cdev.name = leds[i].name;
> +        leds[i].cdev.default_trigger = NULL;
> +        leds[i].cdev.blink_set = NULL;

No need to initialize to NULL.

> +        leds[i].cdev.brightness_set = ot200_led_brightness_set;
> +
> +        ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
> +        if (ret < 0)
> +            goto err;
> +
> +        dev_set_drvdata(leds[i].cdev.dev, &leds[i]);

Neither this ...

> +    }
> +
> +    platform_set_drvdata(pdev, leds);

nor this is ever used.

> +
> +    outb(0x0, 0x49);    /* turn off all front leds */
> +    outb(0x2, 0x5a);    /* turn on init led */
> +    leds_front = 0;
> +    leds_back = BIT(1);

Maybe initialize leds_front and leds_back first and pass it to outb.

> +
> +    return 0;
> +
> +err:
> +    for (i = i - 1; i >= 0; i--)
> +        led_classdev_unregister(&leds[i].cdev);
> +
> +    return ret;
> +}
> +
