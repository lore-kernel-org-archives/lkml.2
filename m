Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1LMWUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:20:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1LMWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:20:51 -0500
Date: Tue, 13 Dec 2011 14:20:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, rpurdie@rpsys.net
Subject: Re: [PATCH RESEND] add led driver for Bachmann's ot200
Message-Id: <20111213142050.de6c1fbc.akpm@linux-foundation.org>
In-Reply-To: <CAH9NwWfMXKQ5DUeHfXaMzEKK_Zn6TS6E44AdqhcOj-jMuAeGQw@mail.gmail.com>
References: <CAH9NwWfMXKQ5DUeHfXaMzEKK_Zn6TS6E44AdqhcOj-jMuAeGQw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 10:57:30 +0100
Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> >From a7fecf3426ef98fdd19e9d2610665b9d1ce358a0 Mon Sep 17 00:00:00 2001
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date: Fri, 18 Nov 2011 10:21:48 +0100
> Subject: [PATCH] add led driver for Bachmann's ot200
> 
> This patch adds support for leds on Bachmann's ot200 visualisation device.
> The device has three leds on the back panel (led_err, led_init and led_run)
> and can handle up to seven leds on the front panel.
> 
> The driver was written by Linutronix on behalf of
> Bachmann electronic GmbH.

The code uses no tabs and indents with seven-spaces.  Please convert it
to use hard tabs in the conventional fashion?  In the Makefile and
Kconfig, too.

> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ff203a4..6cf0dd6 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -387,6 +387,14 @@ config LEDS_RENESAS_TPU
>          pin function. The latter to support brightness control.
>          Brightness control is supported but hardware blinking is not.
> 
> +config LEDS_OT200
> +       tristate "LED support for Bachmann OT200"
> +       depends on LEDS_CLASS
> +       help
> +         This option enables support for the LEDs on the Bachmann OT200. The
> +         LEDs are controlled through LPC bus.
> +         Say Y to enable LEDs on the Bachmann OT200.
> +
>  config LEDS_TRIGGERS
>        bool "LED Trigger support"
>        depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index e4f6bf5..0814d42 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -43,6 +43,7 @@ obj-$(CONFIG_LEDS_NS2)                        += leds-ns2.o
>  obj-$(CONFIG_LEDS_NETXBIG)             += leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)               += leds-asic3.o
>  obj-$(CONFIG_LEDS_RENESAS_TPU)         += leds-renesas-tpu.o
> +obj-$(CONFIG_LEDS_OT200)               += leds-ot200.o
> 
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
> new file mode 100644
> index 0000000..60f118b
> --- /dev/null
> +++ b/drivers/leds/leds-ot200.c
> @@ -0,0 +1,204 @@
> +/*
> + * Bachmann ot200 leds driver.
> + *
> + * Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> + * License: GPL as published by the FSF.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/leds.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +
> +struct ot200_led {
> +       struct led_classdev cdev;
> +       char name[8];
> +       unsigned int num;
> +};
> +
> +static u8 old_val;
> +static u8 old_val_back;

What's going on here?  The driver is using eight bits to store the
current control setting, but the changelog says the driver can handle
ten LEDs.

<looks>

OK, so we're using seven bits in old_val and three in old_val_back.

> +DEFINE_SPINLOCK(value_lock);

Should be static.

> +static void ot200_led_set(struct led_classdev *led_cdev,
> +                       enum led_brightness value)
> +{
> +       struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
> +       u8 val;
> +       u8 mask;
> +       unsigned long flags;
> +
> +       mask = 1 << led->num;
> +
> +       spin_lock_irqsave(&value_lock, flags);
> +       val = old_val;
> +
> +       if (value == LED_OFF)
> +               val &= ~mask;
> +       else
> +               val |= mask;
> +
> +       old_val = val;
> +       spin_unlock_irqrestore(&value_lock, flags);
> +       outb(val, 0x49);
> +}

It's a bit worrisome doing the outb() outside the locked section, but
all the races I can think of result from userspace doing things which
were unavoidably indeterminate anyway.

> +static void ot200_led_back_set(struct led_classdev *led_cdev,
> +                       enum led_brightness value)
> +{
> +       struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
> +       u8 val;
> +       u8 mask;
> +       unsigned long flags;
> +
> +       mask = 1 << led->num;
> +
> +       spin_lock_irqsave(&value_lock, flags);
> +       val = old_val_back;
> +
> +       if (value == LED_OFF)
> +               val &= ~mask;
> +       else
> +               val |= mask;
> +
> +       old_val_back = val;
> +       spin_unlock_irqrestore(&value_lock, flags);
> +       outb(val, 0x5a);
> +}
> +
> +static int __devinit create_ot200_led(struct platform_device *pdev, int num,
> +               struct ot200_led *led)
> +{
> +       int ret;
> +
> +       num += 1;
> +       snprintf(led->name, sizeof(led->name), "led%d", num);
> +       led->num = 7 - num;
> +       led->cdev.name = led->name;
> +       led->cdev.default_trigger = NULL;
> +       led->cdev.blink_set = NULL;
> +       led->cdev.brightness_set = ot200_led_set;
> +
> +       ret = led_classdev_register(&pdev->dev, &led->cdev);
> +       if (ret < 0)
> +               goto out;
> +
> +       dev_set_drvdata(led->cdev.dev, led);
> +       return 0;
> +
> +       led_classdev_unregister(&led->cdev);
> +out:
> +       return ret;
> +}
> +
> +static int __devinit create_ot200_led_back(struct platform_device *pdev,
> +               int num, struct ot200_led *led)
> +{
> +       char *led_name;
> +       int ret;
> +
> +       switch (num) {
> +       case 0:
> +               led_name = "run";
> +               break;
> +       case 1:
> +               led_name = "init";
> +               break;
> +       case 2:
> +               led_name = "err";
> +               break;
> +       default:
> +               BUG();
> +       };
> +
> +       snprintf(led->name, sizeof(led->name), "led_%s", led_name);
> +       led->num = num;
> +       led->cdev.name = led->name;
> +       led->cdev.blink_set = NULL;
> +       led->cdev.brightness_set = ot200_led_back_set;
> +
> +       ret = led_classdev_register(&pdev->dev, &led->cdev);
> +       if (ret < 0)
> +               goto out;
> +
> +       dev_set_drvdata(led->cdev.dev, led);
> +       return 0;
> +
> +       led_classdev_unregister(&led->cdev);
> +out:
> +       return ret;
> +
> +}

This is implementing a userspace API (led_run, led_init, led_err) but
that API isn't documented anywhere.  Can we add a few words of
Documentation so our users know how to use this driver?

>
> ...
>
