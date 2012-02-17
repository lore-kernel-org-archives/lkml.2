Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2BQO6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:58:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19127 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2BQO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:58:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 17 Feb 2012 06:58:50 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2 2/3] gpio: gpiolib: Support for open drain/collector gpios
Date: Fri, 17 Feb 2012 20:26:21 +0530
Message-Id: <1329490582-22107-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
References: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the open drain gpio on which client
can specify the open drain property through GPIO flag
GPIOF_OPEN_DRAIN at the time of gpio request.
The open drain pins are normally pulled high and it
cannot be driven to output with value of 1 and so
when client request for setting the pin to HIGH, the
gpio will be set to input direction to make pin in tristate
and hence PULL-UP on pins will make the state to HIGH.
The open drain pin can be driven to LOW by setting output
with value of 0.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpiolib.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/gpio.h   |    3 +++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 17fdf4b..9940777 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -58,6 +58,7 @@ struct gpio_desc {
 #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
+#define FLAG_OPEN_DRAIN	8	/* Gpio is open drain type */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
@@ -1261,6 +1262,7 @@ void gpio_free(unsigned gpio)
 		module_put(desc->chip->owner);
 		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
+		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
 
@@ -1282,6 +1284,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	if (err)
 		return err;
 
+	if (flags & GPIOF_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &gpio_desc[gpio].flags);
+
 	if (flags & GPIOF_DIR_IN)
 		err = gpio_direction_input(gpio);
 	else
@@ -1431,6 +1436,10 @@ int gpio_direction_output(unsigned gpio, int value)
 	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
 
+	/* Open drain pin should not be driven to 1 */
+	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
+		return gpio_direction_input(gpio);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (!gpio_is_valid(gpio))
@@ -1567,6 +1576,31 @@ int __gpio_get_value(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
 
+/*
+ *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
+ * @gpio: Gpio whose state need to be set.
+ * @chip: Gpio chip.
+ * @value: Non-zero for setting it HIGH otherise it will set to LOW.
+ */
+static void _gpio_set_open_drain_value(unsigned gpio,
+			struct gpio_chip *chip, int value)
+{
+	int err = 0;
+	if (value) {
+		err = chip->direction_input(chip, gpio - chip->base);
+		if (!err)
+			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	} else {
+		err = chip->direction_output(chip, gpio - chip->base, 0);
+		if (!err)
+			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	}
+	trace_gpio_direction(gpio, value, err);
+	if (err < 0)
+		pr_err("%s: Error in set_value for open drain gpio%d err %d\n",
+					__func__, gpio, err);
+}
+
 /**
  * __gpio_set_value() - assign a gpio's value
  * @gpio: gpio whose value will be assigned
@@ -1583,7 +1617,10 @@ void __gpio_set_value(unsigned gpio, int value)
 	chip = gpio_to_chip(gpio);
 	WARN_ON(chip->can_sleep);
 	trace_gpio_value(gpio, 0, value);
-	chip->set(chip, gpio - chip->base, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
+		_gpio_set_open_drain_value(gpio, chip, value);
+	else
+		chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
@@ -1650,7 +1687,10 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 	might_sleep_if(extra_checks);
 	chip = gpio_to_chip(gpio);
 	trace_gpio_value(gpio, 0, value);
-	chip->set(chip, gpio - chip->base, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
+		_gpio_set_open_drain_value(gpio, chip, value);
+	else
+		chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..66a5b2e 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -14,6 +14,9 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+/* Gpio pin is open drain */
+#define GPIOF_OPEN_DRAIN	(1 << 2)
+
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
-- 
1.7.1.1

