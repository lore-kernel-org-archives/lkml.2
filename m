Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab1D0NNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:13:40 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:51472 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab1D0NNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:13:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/10] gpio: add a custom configuration mechanism to gpiolib
Date: Wed, 27 Apr 2011 15:13:10 +0200
Message-ID: <1303909990-3300-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds an opaque pin config call to gpiolib to configure
individual pins. We provide standardized configurarion definitions
for bias and drive mode settings for individual pins, and provide
the mechanism to hook in custom mode settings per-driver if need
be.

Since we have no previous hacked-up arch-specific drivers for this
we can avoid any __override_functions and we just allow this to be
properly implemented using gpiolib. Further the function is made
non-mandatory, calling it without a backing implementation will
result in -ENOTSUPP being returned.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c     |   28 ++++++++++++++++++++
 include/asm-generic/gpio.h |    8 ++++-
 include/linux/gpio.h       |   61 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 36a2974..b62db38 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1635,6 +1635,34 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 }
 EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
+/**
+ * gpio_config() - configure a GPIO
+ * @gpio: gpio to configure
+ * @param: the custom parameter to set/get, typically an enum (only the
+ *	specific driver will know about these parameter)
+ * @data: optional data pointer: if you're getting a config, you can
+ *	pass data back using this pointer, either by dereferencing it
+ *	to a struct or using it to contain an enumerator.
+ * Context: process
+ *
+ * This is used to directly or indirectly to implement gpio_config().
+ * It invokes the associated gpio_chip.config() method. It can be
+ * used for setting things like drive modes, biasing, sleep modes etc.
+ * It returns a negative error code on error or 0 for successful
+ * operations. This is designed to work a bit like an ioctl() so you
+ * can use it to get/set specific parameters.
+ */
+int gpio_config(unsigned gpio, u16 param, unsigned long *data)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	/* Implementing this is not mandatory */
+	if (chip->config)
+		return chip->config(chip, gpio - chip->base, param, data);
+	return -ENOTSUPP;
+}
+EXPORT_SYMBOL_GPL(gpio_config);
 
 #ifdef CONFIG_DEBUG_FS
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..ce16e70 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -61,6 +61,7 @@ struct device_node;
  * @set: assigns output value for signal "offset"
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
+ * @config: set/get a certain custom parameter for the GPIO
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
@@ -105,12 +106,14 @@ struct gpio_chip {
 						unsigned offset, int value);
 	int			(*set_debounce)(struct gpio_chip *chip,
 						unsigned offset, unsigned debounce);
-
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
-
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
+	int			(*config)(struct gpio_chip *chip,
+						unsigned offset,
+						u16 param,
+						unsigned long *data);
 
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
@@ -158,6 +161,7 @@ extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
+extern int gpio_config(unsigned gpio, u16 param, unsigned long *data);
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 32720ba..fa92e50 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -3,6 +3,60 @@
 
 /* see Documentation/gpio.txt */
 
+/*
+ * Bias modes for GPIOs - if you have more biases, add them here or provide
+ * custom enumerators for your driver if you find they are not generally
+ * useful.
+ *
+ * GPIO_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
+ * GPIO_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
+ *	is not controlled by software
+ * GPIO_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
+ *	impedance to VDD)
+ * GPIO_CONFIG_BIAS_PULL_DOWN: the GPIO will be pulled down (usually with high
+ *	impedance to GROUND)
+ * GPIO_BIAS_HIGH: the GPIO will be wired high, connected to VDD
+ * GPIO_BIAS_GROUND: the GPIO will be grounded, connected to GROUND
+ */
+#define GPIO_CONFIG_BIAS_UNKNOWN	0x1000
+#define GPIO_CONFIG_BIAS_FLOAT		0x1001
+#define GPIO_CONFIG_BIAS_PULL_UP	0x1002
+#define GPIO_CONFIG_BIAS_PULL_DOWN	0x1003
+#define GPIO_CONFIG_BIAS_HIGH		0x1004
+#define GPIO_CONFIG_BIAS_GROUND		0x1005
+
+/*
+ * Drive modes for GPIOs (output) - if you have more custom modes either
+ * add them here or keep them to your driver if you think they are not
+ * generally useful.
+ *
+ * GPIO_CONFIG_DRIVE_UNKNOWN: we don't know the drive mode of this GPIO, for
+ *	example since it is controlled by hardware or the information is not
+ *	accessible but we need a meaningful enumerator in e.g. initialization
+ *	code
+ * GPIO_CONFIG_DRIVE_PUSH_PULL: the GPIO will be driven actively high and
+ *	low, this is the most typical case and is typically achieved with two
+ *	active transistors on the output
+ * GPIO_CONFIG_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain (open
+ *	collector) which means it is usually wired with other output ports
+ *	which are then pulled up with an external resistor
+ * GPIO_CONFIG_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
+ *	(open emitter) which is the same as open drain mutatis mutandis but
+ *	pulled to ground
+ * GPIO_CONFIG_DRIVE_OFF: the GPIO pin is set to inactive mode, off
+ */
+#define GPIO_CONFIG_DRIVE_UNKNOWN	0x2010
+#define GPIO_CONFIG_DRIVE_PUSH_PULL	0x2011
+#define GPIO_CONFIG_DRIVE_OPEN_DRAIN	0x2012
+#define GPIO_CONFIG_DRIVE_OPEN_SOURCE	0x2013
+#define GPIO_CONFIG_DRIVE_OFF		0x2014
+
+/*
+ * From this value on, the configuration commands are custom and shall be
+ * defined in the header file for your specific GPIO driver.
+ */
+#define GPIO_CONFIG_CUSTOM_BASE		0x8000
+
 #ifdef CONFIG_GENERIC_GPIO
 #include <asm/gpio.h>
 
@@ -152,6 +206,13 @@ static inline int irq_to_gpio(unsigned irq)
 	return -EINVAL;
 }
 
+static inline int gpio_config(unsigned gpio, u16 param, unsigned long *data)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
 #endif
 
 #endif /* __LINUX_GPIO_H */
-- 
1.7.3.2

