Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1FOVs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:48:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6814 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1FOVs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:48:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 15 Jun 2011 14:48:03 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 15 Jun 2011 14:48:02 -0700
Subject: More pinmux feedback, and GPIO vs. pinmux interaction
Thread-Topic: More pinmux feedback, and GPIO vs. pinmux interaction
Thread-Index: AcwrpVHXnLIbUaScTRSwCCKtpn4eow==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C067D@HQMAIL01.nvidia.com>
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

Linus (W),

Some more thoughts on pinmux:

========== GPIO/pinmux API interactions

I'd like to understand how the gpio and pinmux subsystems are intended
to interact.

Quoting from Documentation/gpio.txt:

  Note that requesting a GPIO does NOT cause it to be configured in any
  way; it just marks that GPIO as in use.  Separate code must handle any
  pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).

Due to this, the current Tegra GPIO driver contains additional non-
standard functions:

void tegra_gpio_enable(int gpio);
void tegra_gpio_disable(int gpio);

In some cases, those functions are called by board files at boot time,
and in other cases by drivers themselves, right before gpio_request().

Is it your intention that such custom functions be replaced by
pinmux_request_gpio(), and the Tegra pinmux driver's gpio_request_enable
op should call tegra_gpio_enable?

That seems like the right idea to me.

========== pinmux calling GPIO or vice-versa?

Having pinmux call gpio appears to conflict with a couple of things from
your recent pinmux patchset:

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> +# pinctrl before gpio - gpio drivers may need it
> +
> +source "drivers/pinctrl/Kconfig"
> +
>  source "drivers/gpio/Kconfig"
>
> diff --git a/drivers/Makefile b/drivers/Makefile
>...
> +# GPIO must come after pinctrl as gpios may need to mux pins etc
> +obj-y				+= pinctrl/

Don't those patches imply that the GPIO controller code is calling into
the pinmux code to perform muxing, not the other way around?

========== When pins get marked as in-used

There seems to be a discrepancy in the way the client APIs work: For
special functions, the client calls pinmux_get, then later pinmux_enable,
whereas for GPIOs, the client just calls pinmux_request_gpio. I'm not
sure of the benefit of having separate pinmux_get and pinmux_enable
calls; I thought the idea was that a client could:

a = pinmux_get(dev, "funca");
b = pinmux_get(dev, "funcb");
pinmux_enable(a);
...
pinmux_disable(a);
pinmux_enable(b);
...
pinmux_disable(b);
pinmux_put(b);
pinmux_put(a);

However, since the pins are marked as reserved/in-use when pinmux_get
is called rather than pinmux_enable, the code above won't work; it'd
need to be:

a = pinmux_get(dev, "funca");
pinmux_enable(a);
...
pinmux_disable(a);
pinmux_put(a);
b = pinmux_get(dev, "funcb");
pinmux_enable(b);
...
pinmux_disable(b);
pinmux_put(b);

Perhaps pin usage marking should be moved into enable/disable?

========== Matched request/free calls for GPIOs

A couple more comments on your recent pinmux patches in light of this:

>From pin_request():

+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio && ops->gpio_request_enable)
+		/* This requests and enables a single GPIO pin */
+		status = ops->gpio_request_enable(pmxdev,
+						  pin - pmxdev->desc->base);
+	else if (ops->request)
+		status = ops->request(pmxdev,
+				      pin - pmxdev->desc->base);
+	else
+		status = 0;

a) I feel the default should be to error out, not succeed; the whole
point of the API is for HW where something must be programmed to enable
each function. As such, if you don't provide that ops->request* function,
that seems like an error.

I think the logic above should be to always call ops->gpio_request_enable
if (gpio):

	if (gpio)
		if (ops->gpio_request_enable)
			/* This requests and enables a single GPIO pin */
			status = ops->gpio_request_enable(pmxdev,
						  pin - pmxdev->desc->base);
	else
		status = ops->request(pmxdev,
				      pin - pmxdev->desc->base);

(ops->gpio_request_enable could be optional if GPIOs aren't supported on
any pinmux pins, whereas ops->request isn't optional, and should be checked
during pinmux_register)

Also, ops->gpio_request_enable should also be passed the GPIO number,
so the driver can validate that it's the correct one. Often, only
one value would be legal, but perhaps some pinmuxs allow 1 of N different
GPIOs to be mapped to some pin, so selection of which GPIO is on par with
selection of which special function to mux out, yet the driver still
doesn't want to expose every GPIO possibility as a pinmux "function" due
to explosion of the number of functions if it did that.

b) When ops->gpio_request_enable is called to request a pin, it'd be nice
if the core could track this, and specifically call a new ops->gpio_disable
to free it, rather than the generic ops->free. There are two cases in HW:

b1) "GPIO" is just another special function in a list, e.g. SPI, I2C, GPIO.
In this case, free for a GPIO needs to either do nothing (the next call to
request will simply set the desired function), or possibly do something to
disable the pin in the same way as any other function. This works fine with
a single free function.

b2) GPIO enable/disable is a separate concept from the pinmuxing; on Tegra
it'll be implemented by calling tegra_gpio_enable/disable. As such, a
single free function would require the pinmux driver to store state
indicating whether ops->free should call tegra_gpio_disable, or whether it
should do cleanup to the pinmux registers. Since the core is managing GPIO
vs. function allocation, I think the storing that state in the core makes
sense.

Thanks for reading. Hopefully this email didn't jump about too much.

-- 
nvpublic

