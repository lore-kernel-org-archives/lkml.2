Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2BQO67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:58:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6306 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2BQO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:58:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 Feb 2012 06:58:54 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2 3/3] gpio: gpiolib: Support for open source/emitter gpios
Date: Fri, 17 Feb 2012 20:26:22 +0530
Message-Id: <1329490582-22107-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
References: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the open source gpio on which client
can specify the open source property through GPIO flag
GPIOF_OPEN_SOURCE at the time of gpio request.
The open source pins are normally pulled low and it
cannot be driven to output with value of 0 and so
when client request for setting the pin to LOW, the
gpio will be set to input direction to make pin in tristate
and hence PULL-DOWN on pins will make the state to LOW.
The open source pin can be driven to HIGH by setting output
with value of 1.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpiolib.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/gpio.h   |    3 +++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9940777..3b089ef 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -59,6 +59,7 @@ struct gpio_desc {
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
 #define FLAG_OPEN_DRAIN	8	/* Gpio is open drain type */
+#define FLAG_OPEN_SOURCE 9	/* Gpio is open source type */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
@@ -1263,6 +1264,7 @@ void gpio_free(unsigned gpio)
 		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
 		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
+		clear_bit(FLAG_OPEN_SOURCE, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
 
@@ -1287,6 +1289,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	if (flags & GPIOF_OPEN_DRAIN)
 		set_bit(FLAG_OPEN_DRAIN, &gpio_desc[gpio].flags);
 
+	if (flags & GPIOF_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &gpio_desc[gpio].flags);
+
 	if (flags & GPIOF_DIR_IN)
 		err = gpio_direction_input(gpio);
 	else
@@ -1440,6 +1445,10 @@ int gpio_direction_output(unsigned gpio, int value)
 	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
 		return gpio_direction_input(gpio);
 
+	/* Open source pin should not be driven to 0 */
+	if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
+		return gpio_direction_input(gpio);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (!gpio_is_valid(gpio))
@@ -1601,6 +1610,32 @@ static void _gpio_set_open_drain_value(unsigned gpio,
 					__func__, gpio, err);
 }
 
+/*
+ *  _gpio_set_open_source() - Set the open source gpio's value.
+ * @gpio: Gpio whose state need to be set.
+ * @chip: Gpio chip.
+ * @value: Non-zero for setting it HIGH otherise it will set to LOW.
+ */
+static void _gpio_set_open_source_value(unsigned gpio,
+			struct gpio_chip *chip, int value)
+{
+	int err = 0;
+	if (value) {
+		err = chip->direction_output(chip, gpio - chip->base, 1);
+		if (!err)
+			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	} else {
+		err = chip->direction_input(chip, gpio - chip->base);
+		if (!err)
+			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	}
+	trace_gpio_direction(gpio, !value, err);
+	if (err < 0)
+		pr_err("%s: Error in set_value for open source gpio%d err %d\n",
+					__func__, gpio, err);
+}
+
+
 /**
  * __gpio_set_value() - assign a gpio's value
  * @gpio: gpio whose value will be assigned
@@ -1619,6 +1654,8 @@ void __gpio_set_value(unsigned gpio, int value)
 	trace_gpio_value(gpio, 0, value);
 	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
 		_gpio_set_open_drain_value(gpio, chip, value);
+	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
+		_gpio_set_open_source_value(gpio, chip, value);
 	else
 		chip->set(chip, gpio - chip->base, value);
 }
@@ -1689,6 +1726,8 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 	trace_gpio_value(gpio, 0, value);
 	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
 		_gpio_set_open_drain_value(gpio, chip, value);
+	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
+		_gpio_set_open_source_value(gpio, chip, value);
 	else
 		chip->set(chip, gpio - chip->base, value);
 }
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 66a5b2e..67851bb 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -17,6 +17,9 @@
 /* Gpio pin is open drain */
 #define GPIOF_OPEN_DRAIN	(1 << 2)
 
+/* Gpio pin is open source */
+#define GPIOF_OPEN_SOURCE	(1 << 3)
+
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
-- 
1.7.1.1

