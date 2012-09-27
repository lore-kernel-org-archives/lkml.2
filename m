Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2I0VWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:22:42 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:42673 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755343Ab2I0VWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:22:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Date: Thu, 27 Sep 2012 23:22:02 +0200
Message-Id: <1348780923-27428-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recurring task of providing simultaneous access to GPIO lines (especially
for bit banging protocols) needs an appropriate API.

This patch adds a kernel internal "Block GPIO" API that enables simultaneous
access to several GPIOs in the same gpio_chip (bit mapped). Further, it adds a
sysfs interface (/sys/class/gpio/gpiochipXX/block).

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
NOTE: This is only useful if individual drivers implement the .get_block() and
.set_block() functions. I'm providing an example implementation for max730x
(see next patch), and can provide further driver patches after API review.

Thanks in advance!

 Documentation/gpio.txt     |   52 +++++++++++++++++++
 drivers/gpio/gpiolib.c     |  121 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    7 ++
 include/linux/gpio.h       |   24 ++++++++
 4 files changed, 204 insertions(+)

--- linux-2.6.orig/Documentation/gpio.txt
+++ linux-2.6/Documentation/gpio.txt
@@ -439,6 +439,51 @@ slower clock delays the rising edge of S
 signaling rate accordingly.
 
 
+Block GPIO (optional)
+---------------------
+
+The above described interface concentrates on handling single GPIOs.  However,
+in applications where it is critical to set several GPIOs at once, this
+interface doesn't work well, e.g. bit-banging protocols via GPIO lines.
+Consider a GPIO controller that is connected via a slow I2C line. When
+switching two or more GPIOs one after another, there can be considerable time
+between those events. This is solved by an interface called Block GPIO:
+
+void gpio_get_block(unsigned int gpio, u8* values, size_t size);
+void gpio_set_block(unsigned int gpio, u8* set, u8* clr, size_t size);
+
+The function gpio_get_block() detects the current state of several GPIOs at
+once, practically by doing only one query at the hardware level (e.g. memory
+mapped or via bus transfers like I2C). There are some limits to this interface:
+A certain gpio_chip (see below) must be specified via the gpio parameter as the
+first GPIO in the gpio_chip group. The Block GPIO interface only supports
+simultaneous handling of GPIOs in the same gpio_chip group since different
+gpio_chips typically map to different GPIO hardware blocks.
+
+The values and size (in bytes) arguments specify a bit field of consecutive
+values for the GPIOs in this gpio_chip group, relative to the specified GPIO.
+E.g., when the gpio_chip group contains 16 GPIOs (80-95), size is 2 and values
+points to an array of two bytes, the first of which contains the input values
+of GPIOs 80-87 and the second one the values of GPIOs 88-95.
+
+Setting and clearing can be done via gpio_set_block(). Similar to the values
+argument of gpio_get_block(), the arrays pointed to by set and clr contain bit
+mapped lists of GPIOs to set and clear. This way, it is possible to
+simultaneously set e.g. GPIOs 10 and 12 and clear GPIO 3, leaving the others in
+the current state. The size argument refers to both set and clr which must be
+sized equally.
+
+Another limit of this interface is that although gpio_get_block() and
+gpio_set_block() are valid for all gpio_chips, they only work as expected where
+the actual hardware really supports setting and clearing simultaneously. Some
+GPIO hardware can only set simultaneously or clear simultaneously, but not set
+and clear simultaneously.  Further, the respective GPIO driver must implement
+the .get_block() and .set_block() functions in their struct gpio_chip
+efficiently. If they default to NULL, gpiolib uses .get() and .set() functions
+as backup, which effectively leads to non-simultaneous GPIO handling. Please
+check the actual GPIO driver you are using.
+
+
 What do these conventions omit?
 ===============================
 One of the biggest things these conventions omit is pin multiplexing, since
@@ -686,6 +731,13 @@ read-only attributes:
 
     	"ngpio" ... how many GPIOs this manges (N to N + ngpio - 1)
 
+    	"block" ... get/set Block GPIO:
+		    * reads: space separated list of GPIO inputs of this chip that
+		      are set to 1, e.g. "83 85 87 99"
+		    * write: space separated list of GPIO outputs of this chip
+		      that are to be set or cleared, e.g. "80 -83 -85" (prefix
+		      "-" clears)
+
 Board documentation should in most cases cover what GPIOs are used for
 what purposes.  However, those numbers are not always stable; GPIOs on
 a daughtercard might be different depending on the base board being used,
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -589,10 +589,114 @@ static ssize_t chip_ngpio_show(struct de
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
+
+static ssize_t chip_block_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct gpio_chip *chip = dev_get_drvdata(dev);
+	size_t size = (chip->ngpio + 7) / 8;
+	u8 *bits;
+	int ret = 0;
+	int i, chars;
+
+	bits = kzalloc(size, GFP_KERNEL);
+
+	if (chip->get_block) {
+		chip->get_block(chip, bits, size);
+	} else { /* emulate as fallback */
+		u8 byte = 0;
+
+		for (i = 0; i < chip->ngpio; i++) {
+			byte |= gpio_get_value_cansleep(chip->base + i) <<
+				(i & 7);
+			if ((i & 7) == 7 || i == chip->ngpio - 1) {
+				bits[i >> 3] = byte;
+				byte = 0;
+			}
+		}
+	}
+
+	for (i = 0; i < chip->ngpio; i++) {
+		if (bits[i >> 3] & BIT(i & 7)) {
+			chars = sprintf(buf, "%s%d", ret ? " " : "",
+					chip->base + i);
+			buf += chars;
+			ret += chars;
+		}
+	}
+
+	kfree(bits);
+
+	ret += sprintf(buf, "\n");
+
+	return ret;
+}
+
+static ssize_t chip_block_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t size)
+{
+	struct gpio_chip *chip = dev_get_drvdata(dev);
+	u8 *set_bits;
+	u8 *clr_bits;
+	size_t bits_size = (chip->ngpio + 7) / 8;
+	int count = size;
+	int gpio;
+
+	mutex_lock(&sysfs_lock);
+
+	set_bits = kzalloc(bits_size, GFP_KERNEL);
+	clr_bits = kzalloc(bits_size, GFP_KERNEL);
+
+	while (count >= 0) {
+		bool clear = buf[0] == '-' ? true : false;
+		if (sscanf(buf, "%d", &gpio) == 1) {
+			if (clear)
+				gpio = -gpio;
+			gpio -= chip->base;
+			if (gpio >= 0 && gpio < chip->ngpio) {
+				if (clear)
+					clr_bits[gpio >> 3] |= BIT(gpio & 7);
+				else
+					set_bits[gpio >> 3] |= BIT(gpio & 7);
+			}
+		}
+
+		/* Find next token */
+		while (count >= 0 && *buf != ' ') {
+			buf++;
+			count--;
+		}
+		buf++;
+		count--;
+	}
+
+	if (chip->set_block) {
+		chip->set_block(chip, set_bits, clr_bits, bits_size);
+	} else if (chip->set) { /* emulate as fall back */
+		int i;
+
+		for (i = 0; i < chip->ngpio; i++) {
+			if (set_bits[i >> 3] & BIT(i & 7))
+				chip->set(chip, i, 1);
+			if (clr_bits[i >> 3] & BIT(i & 7))
+				chip->set(chip, i, 0);
+		}
+	}
+	kfree(set_bits);
+	kfree(clr_bits);
+	mutex_unlock(&sysfs_lock);
+
+	return size;
+}
+
+static DEVICE_ATTR(block, 0644, chip_block_show, chip_block_store);
+
 static const struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
+	&dev_attr_block.attr,
 	NULL,
 };
 
@@ -1599,6 +1703,14 @@ int __gpio_get_value(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
 
+void __gpio_get_block(unsigned gpio, u8 *values, size_t size)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	return chip->get_block ? chip->get_block(chip, values, size) : 0;
+}
+EXPORT_SYMBOL_GPL(__gpio_get_block);
+
 /*
  *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
  * @gpio: Gpio whose state need to be set.
@@ -1676,6 +1788,15 @@ void __gpio_set_value(unsigned gpio, int
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+void __gpio_set_block(unsigned gpio, u8 *set, u8 *clr, size_t size)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	if (chip->set_block)
+		chip->set_block(chip, set, clr, size);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_block);
+
 /**
  * __gpio_cansleep() - report whether gpio value access will sleep
  * @gpio: gpio in question
--- linux-2.6.orig/include/asm-generic/gpio.h
+++ linux-2.6/include/asm-generic/gpio.h
@@ -105,6 +105,8 @@ struct gpio_chip {
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
 						unsigned offset);
+	void			(*get_block)(struct gpio_chip *chip,
+					     u8 *values, size_t size);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
 	int			(*set_debounce)(struct gpio_chip *chip,
@@ -112,6 +114,8 @@ struct gpio_chip {
 
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	void			(*set_block)(struct gpio_chip *chip, u8 *set,
+					     u8 *clr, size_t size);
 
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
@@ -171,6 +175,9 @@ extern void gpio_set_value_cansleep(unsi
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
 
+extern void __gpio_get_block(unsigned gpio, u8 *values, size_t size);
+extern void __gpio_set_block(unsigned gpio, u8 *set, u8 *clr, size_t size);
+
 extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -57,6 +57,17 @@ static inline void gpio_set_value(unsign
 	__gpio_set_value(gpio, value);
 }
 
+static inline void gpio_get_block(unsigned int gpio, u8 *values, size_t size)
+{
+	return __gpio_get_block(gpio, values, size);
+}
+
+static inline
+void gpio_set_block(unsigned int gpio, u8 *set, u8 *clr, size_t size)
+{
+	__gpio_set_block(gpio, set, clr, size);
+}
+
 static inline int gpio_cansleep(unsigned int gpio)
 {
 	return __gpio_cansleep(gpio);
@@ -167,6 +178,19 @@ static inline void gpio_set_value(unsign
 {
 	/* GPIO can never have been requested or set as output */
 	WARN_ON(1);
+}
+
+static inline void gpio_get_block(unsigned gpio, u8 *values, size_t size)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_block(unsigned gpio, u8 *set, u8 *clr, size_t size)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
 }
 
 static inline int gpio_cansleep(unsigned gpio)
