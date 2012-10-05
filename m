Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2JEUhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:37:08 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:50455 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:37:00 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 1/2 v2] gpio: Add a block GPIO API to gpiolib
Date: Fri,  5 Oct 2012 22:36:26 +0200
Message-Id: <1349469387-20580-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recurring task of providing simultaneous access to GPIO lines (especially
for bit banging protocols) needs an appropriate API.

This patch adds a kernel internal "Block GPIO" API that enables simultaneous
access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
Once requested, it provides access to a group of GPIOs which can range over
multiple GPIO chips.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
NOTE: This is only useful if individual drivers implement the .get_block() and
.set_block() functions. I'm providing an example implementation for max730x
(see next patch), and can provide further driver patches after API review.

Thanks in advance!

 Documentation/gpio.txt     |   39 +++++++++++
 drivers/gpio/gpiolib.c     |  148 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   10 +++
 include/linux/gpio.h       |   67 ++++++++++++++++++++
 4 files changed, 264 insertions(+)

--- linux-2.6.orig/Documentation/gpio.txt
+++ linux-2.6/Documentation/gpio.txt
@@ -439,6 +439,45 @@ slower clock delays the rising edge of S
 signaling rate accordingly.
 
 
+Block GPIO
+----------
+
+The above described interface concentrates on handling single GPIOs.  However,
+in applications where it is critical to set several GPIOs at once, this
+interface doesn't work well, e.g. bit-banging protocols via GPIO lines.
+Consider a GPIO controller that is connected via a slow I2C line. When
+switching two or more GPIOs one after another, there can be considerable time
+between those events. This is solved by an interface called Block GPIO:
+
+struct gpio_block *gpio_block_request(unsigned int *gpios, size_t size);
+
+This creates a new block of GPIOs as a list of GPIO numbers with the specified
+size which are accessible via the returned struct gpio_block and the accessor
+functions described below. Please note that you need to request the GPIOs
+separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
+specified, even ranging over several gpio_chips. Actual handling of I/O
+operations will be done on a best effort base, i.e. simultaneous I/O only where
+possible by hardware and implemented in the respective GPIO driver. The number
+of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
+system.
+
+unsigned gpio_block_get(struct gpio_block *block);
+void gpio_block_set(struct gpio_block *block, unsigned value);
+
+With those accessor functions, setting and getting the GPIO values is possible,
+analogous to gpio_get_value() and gpio_set_value(). Each bit in the return
+value of gpio_block_get() and in the value argument of gpio_block_set()
+corresponds to a bit specified on gpio_block_request(). Block operations in
+hardware are only possible where the respective GPIO driver implements it,
+falling back to using single GPIO operations where the driver only implements
+single GPIO access.
+
+void gpio_block_free(struct gpio_block *block);
+
+After the GPIO block isn't used anymore, it should be free'd via
+gpio_block_free().
+
+
 What do these conventions omit?
 ===============================
 One of the biggest things these conventions omit is pin multiplexing, since
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -1676,6 +1676,154 @@ void __gpio_set_value(unsigned gpio, int
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+static inline
+int gpio_block_chip_index(struct gpio_block *block, struct gpio_chip *gc)
+{
+	int i;
+
+	for (i = 0; i < block->nchip; i++) {
+		if (block->gbc[i].gc == gc)
+			return i;
+	}
+	return -1;
+}
+
+struct gpio_block *__gpio_block_request(unsigned *gpios, size_t size)
+{
+	struct gpio_block *block;
+	struct gpio_block_chip *gbc;
+	struct gpio_remap *remap;
+	int i;
+
+	if (size < 1 || size > sizeof(unsigned) * 8)
+		return NULL;
+
+	block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
+
+	for (i = 0; i < size; i++) {
+		struct gpio_chip *gc = gpio_to_chip(gpios[i]);
+		int bit = gpios[i] - gc->base;
+		int index = gpio_block_chip_index(block, gc);
+
+		if (index < 0) {
+			block->nchip++;
+			block->gbc = krealloc(block->gbc,
+					      sizeof(struct gpio_block_chip) *
+					      block->nchip, GFP_KERNEL);
+			gbc = &block->gbc[block->nchip - 1];
+			gbc->gc = gc;
+			gbc->remap = NULL;
+			gbc->nremap = 0;
+			gbc->mask = 0;
+		} else {
+			gbc = &block->gbc[index];
+		}
+		/* represents the mask necessary on calls to the driver's
+		 * .get_block() and .set_block()
+		 */
+		gbc->mask |= BIT(bit);
+
+		/* collect gpios that are specified together, represented by
+		 * neighboring bits
+		 */
+		remap = &gbc->remap[gbc->nremap - 1];
+		if (!gbc->nremap || !(remap->mask & BIT(i - 1))) {
+			gbc->nremap++;
+			gbc->remap = krealloc(gbc->remap,
+					      sizeof(struct gpio_remap) *
+					      gbc->nremap, GFP_KERNEL);
+			remap = &gbc->remap[gbc->nremap - 1];
+			remap->offset = bit - i;
+			remap->mask = 0;
+		}
+
+		/* represents the mask necessary for bit reordering between
+		 * gpio_block (i.e. as specified on gpio_block_get() and
+		 * gpio_block_set()) and gpio_chip domain (i.e. as specified on
+		 * the driver's .set_block() and .get_block())
+		 */
+		remap->mask |= BIT(i);
+	}
+
+	return block;
+}
+EXPORT_SYMBOL_GPL(__gpio_block_request);
+
+void __gpio_block_free(struct gpio_block *block)
+{
+	int i;
+
+	for (i = 0; i < block->nchip; i++)
+		kfree(block->gbc[i].remap);
+	kfree(block->gbc);
+	kfree(block);
+}
+EXPORT_SYMBOL_GPL(__gpio_block_free);
+
+unsigned __gpio_block_get(struct gpio_block *block)
+{
+	struct gpio_block_chip *gbc;
+	int i, j;
+	unsigned values = 0;
+
+	for (i = 0; i < block->nchip; i++) {
+		unsigned remapped = 0;
+
+		gbc = &block->gbc[i];
+
+		if (gbc->gc->get_block) {
+			remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
+		} else { /* emulate */
+			unsigned bit = 1;
+
+			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
+				if (gbc->mask & bit)
+					remapped |= gbc->gc->get(gbc->gc,
+							gbc->gc->base + j) << j;
+			}
+		}
+
+		for (j = 0; j < gbc->nremap; j++) {
+			struct gpio_remap *gr = &gbc->remap[j];
+
+			values |= (remapped >> gr->offset) & gr->mask;
+		}
+	}
+
+	return values;
+}
+EXPORT_SYMBOL_GPL(__gpio_block_get);
+
+void __gpio_block_set(struct gpio_block *block, unsigned values)
+{
+	struct gpio_block_chip *gbc;
+	int i, j;
+
+	for (i = 0; i < block->nchip; i++) {
+		unsigned remapped = 0;
+
+		gbc = &block->gbc[i];
+
+		for (j = 0; j < gbc->nremap; j++) {
+			struct gpio_remap *gr = &gbc->remap[j];
+
+			remapped |= (values & gr->mask) << gr->offset;
+		}
+		if (gbc->gc->set_block) {
+			gbc->gc->set_block(gbc->gc, gbc->mask, remapped);
+		} else { /* emulate */
+			unsigned bit = 1;
+
+			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
+				if (gbc->mask & bit)
+					gbc->gc->set(gbc->gc, gbc->gc->base + j,
+						     (remapped >> j) & 1);
+			}
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(__gpio_block_set);
+
 /**
  * __gpio_cansleep() - report whether gpio value access will sleep
  * @gpio: gpio in question
--- linux-2.6.orig/include/asm-generic/gpio.h
+++ linux-2.6/include/asm-generic/gpio.h
@@ -43,6 +43,7 @@ static inline bool gpio_is_valid(int num
 
 struct device;
 struct gpio;
+struct gpio_block;
 struct seq_file;
 struct module;
 struct device_node;
@@ -105,6 +106,8 @@ struct gpio_chip {
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
 						unsigned offset);
+	unsigned		(*get_block)(struct gpio_chip *chip,
+					     unsigned mask);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
 	int			(*set_debounce)(struct gpio_chip *chip,
@@ -112,6 +115,8 @@ struct gpio_chip {
 
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	void			(*set_block)(struct gpio_chip *chip,
+					     unsigned mask, unsigned values);
 
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
@@ -171,6 +176,11 @@ extern void gpio_set_value_cansleep(unsi
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
 
+extern struct gpio_block *__gpio_block_request(unsigned *gpio, size_t size);
+extern void __gpio_block_free(struct gpio_block *block);
+extern unsigned __gpio_block_get(struct gpio_block *block);
+extern void __gpio_block_set(struct gpio_block *block, unsigned values);
+
 extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -2,6 +2,7 @@
 #define __LINUX_GPIO_H
 
 #include <linux/errno.h>
+#include <linux/types.h>
 
 /* see Documentation/gpio.txt */
 
@@ -39,6 +40,27 @@ struct gpio {
 	const char	*label;
 };
 
+struct gpio_remap {
+	int	mask;
+	int	offset;
+};
+
+struct gpio_block_chip {
+	struct gpio_chip	*gc;
+	struct gpio_remap	*remap;
+	int			nremap;
+	unsigned		mask;
+};
+
+/**
+ * struct gpio_block - a structure describing a list of GPIOs for simultaneous
+ *                     operations
+ */
+struct gpio_block {
+	struct gpio_block_chip	*gbc;
+	size_t			nchip;
+};
+
 #ifdef CONFIG_GENERIC_GPIO
 
 #ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
@@ -57,6 +79,28 @@ static inline void gpio_set_value(unsign
 	__gpio_set_value(gpio, value);
 }
 
+static inline
+struct gpio_block *gpio_block_request(unsigned int *gpios, size_t size)
+{
+	return __gpio_block_request(gpios, size);
+}
+
+static inline void gpio_block_free(struct gpio_block *block)
+{
+	__gpio_block_free(block);
+}
+
+static inline unsigned gpio_block_get(struct gpio_block *block)
+{
+	return __gpio_block_get(block, value);
+}
+
+static inline
+void gpio_block_set(struct gpio_block *block, unsigned value)
+{
+	__gpio_block_set(block, value);
+}
+
 static inline int gpio_cansleep(unsigned int gpio)
 {
 	return __gpio_cansleep(gpio);
@@ -169,6 +213,29 @@ static inline void gpio_set_value(unsign
 	WARN_ON(1);
 }
 
+static inline
+struct gpio_block *gpio_block_request(unsigned int *gpios, size_t size)
+{
+	WARN_ON(1);
+	return NULL;
+}
+
+static inline void gpio_block_free(struct gpio_block *block)
+{
+	WARN_ON(1);
+}
+
+static inline unsigned gpio_block_get(struct gpio_block *block)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_block_set(struct gpio_block *block, unsigned value)
+{
+	WARN_ON(1);
+}
+
 static inline int gpio_cansleep(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
