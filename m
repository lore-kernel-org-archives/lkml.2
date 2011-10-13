Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1JMAzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:55:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56664 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1JMAzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:55:04 -0400
MIME-Version: 1.0
In-Reply-To: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 13 Oct 2011 09:55:02 +0900
Message-ID: <CAPTzV16bKaHxoyWEv1H8HGyY_CZhY9orXAuWA-wa0yb2NZ5UcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Chanho Park <parkch98@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +Interaction with the GPIO subsystem
> +===================================
> +
> +The GPIO drivers may want to perform operations of various types on the same
> +physical pins that are also registered as GPIO pins.
> +
> +Since the pin controller subsystem have its pinspace local to the pin
> +controller we need a mapping so that the pin control subsystem can figure out
> +which pin controller handles control of a certain GPIO pin. Since a single
> +pin controller may be muxing several GPIO ranges (typically SoCs that have
> +one set of pins but internally several GPIO silicon blocks, each modeled as
> +a struct gpio_chip) any number of GPIO ranges can be added to a pin controller
> +instance like this:
> +
> +struct gpio_chip chip_a;
> +struct gpio_chip chip_b;
> +
> +static struct pinctrl_gpio_range gpio_range_a = {
> +       .name = "chip a",
> +       .id = 0,
> +       .base = 32,
> +       .npins = 16,
> +       .gc = &chip_a;
> +};
> +
> +static struct pinctrl_gpio_range gpio_range_a = {
> +       .name = "chip b",
> +       .id = 0,
> +       .base = 48,
> +       .npins = 8,
> +       .gc = &chip_b;
> +};
> +
> +
> +{
> +       struct pinctrl_dev *pctl;
> +       ...
> +       pinctrl_add_gpio_range(pctl, &gpio_range_a);
> +       pinctrl_add_gpio_range(pctl, &gpio_range_b);
> +}
> +
> +So this complex system has one pin controller handling two different
> +GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped in
> +the global GPIO pin space at:
> +
> +chip a: [32 .. 47]
> +chip b: [48 .. 55]
> +
> +When GPIO-specific functions in the pin control subsystem are called, these
> +ranges will be used to look up the apropriate pin controller by inspecting
> +and matching the pin to the pin ranges across all controllers. When a
> +pin controller handling the matching range is found, GPIO-specific functions
> +will be called on that specific pin controller.
> +
> +For all functionalities dealing with pin biasing, pin muxing etc, the pin
> +controller subsystem will subtract the range's .base offset from the passed
> +in gpio pin number, and pass that on to the pin control driver, so the driver
> +will get an offset into its handled number range. Further it is also passed
> +the range ID value, so that the pin controller knows which range it should
> +deal with.
> +
> +For example: if a user issues pinctrl_gpio_set_foo(50), the pin control
> +subsystem will find that the second range on this pin controller matches,
> +subtract the base 48 and call the
> +pinctrl_driver_gpio_set_foo(pinctrl, range, 2) where the latter function has
> +this signature:
> +
> +int pinctrl_driver_gpio_set_foo(struct pinctrl_dev *pctldev,
> +    struct pinctrl_gpio_range *rangeid,
> +    unsigned offset);
> +
> +Now the driver knows that we want to do some GPIO-specific operation on the
> +second GPIO range handled by "chip b", at offset 2 in that specific range.
> +
> +(If the GPIO subsystem is ever refactored to use a local per-GPIO controller
> +pin space, this mapping will need to be augmented accordingly.)
> +

Hello,
Some gpio-ranges doesn't match with pin numbers.
For example, gpio_range_b starts gpio 48.
However, a pin base number of gpio_range_b is 96. It isn't same with gpio base.
A pinctrl driver must know this pin_space-gpio_range mappings.

static struct pinctrl_gpio_range gpio_range_a = {
       .name = "chip b",
       .id = 0,
       .base = 48,
       .pin_base = 96,
       .npins = 8,
       .gc = &chip_b;
};

To solve this sparse gpio-range issue, you will implement
above pinctrl_driver_gpio_xxx which not yet implemented.
How about below simple patch just added pin_base instead
using pinctrl_driver_gpio_xxx function?

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a0a90a2..7d7f7c0 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -223,7 +223,7 @@ int pinmux_request_gpio(unsigned gpio)
 		return -EINVAL;

 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base;
+	pin = gpio - range->base + range->pin_base;

 	/* Conjure some name stating what chip and pin this is taken by */
 	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
@@ -248,7 +248,7 @@ void pinmux_free_gpio(unsigned gpio)
                return;

        /* Convert to the pin controllers number space */
-       pin = gpio - range->base;
+       pin = gpio - range->base + range->pin_base;

        pin_free(pctldev, pin);
 }
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 1e6f67e..6041fd4 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -53,6 +53,7 @@ struct pinctrl_gpio_range {
 	const char *name;
 	unsigned int id;
 	unsigned int base;
+	unsigned int pin_base;
 	unsigned int npins;
 	struct gpio_chip *gc;
 };


...snip...

+/**
+ * pinctrl_get_device_gpio_range() - find device for GPIO range
+ * @gpio: the pin to locate the pin controller for
+ * @outdev: the pin control device if found
+ * @outrange: the GPIO range if found
+ *
+ * Find the pin controller handling a certain GPIO pin from the pinspace of
+ * the GPIO subsystem, return the device and the matching GPIO range. Returns
+ * negative if the GPIO range could not be found in any device.
+ */
+int pinctrl_get_device_gpio_range(unsigned gpio,
+                               struct pinctrl_dev **outdev,
+                               struct pinctrl_gpio_range **outrange)
+{
+       struct pinctrl_dev *pctldev = NULL;
+
+       /* Loop over the pin controllers */
+       mutex_lock(&pinctrldev_list_mutex);
+       list_for_each_entry(pctldev, &pinctrldev_list, node) {
+               struct pinctrl_gpio_range *range;
+
+               range = pinctrl_match_gpio_range(pctldev, gpio);
+               if (range != NULL) {
+                       *outdev = pctldev;
+                       *outrange = range;

missing mutex_unlock

+                       return 0;
+               }
+       }
+       mutex_unlock(&pinctrldev_list_mutex);
+
+       return -EINVAL;
+}

-- 
Best Regards,
Chanho Park
