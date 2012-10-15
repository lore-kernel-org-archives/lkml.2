Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2JOXcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:32:08 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:48207 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611Ab2JOXcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:32:05 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, gregkh@linuxfoundation.org, rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 01/11 v4] gpio: Add a block GPIO API to gpiolib
Date: Tue, 16 Oct 2012 01:31:17 +0200
Message-Id: <1350343887-7344-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350343887-7344-1-git-send-email-stigge@antcom.de>
References: <1350343887-7344-1-git-send-email-stigge@antcom.de>
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

 Documentation/gpio.txt     |   45 +++++++++
 drivers/gpio/gpiolib.c     |  217 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   15 +++
 include/linux/gpio.h       |   74 +++++++++++++++
 4 files changed, 351 insertions(+)

--- linux-2.6.orig/Documentation/gpio.txt
+++ linux-2.6/Documentation/gpio.txt
@@ -439,6 +439,51 @@ slower clock delays the rising edge of S
 signaling rate accordingly.
 
 
+Block GPIO
+----------
+
+The above described interface concentrates on handling single GPIOs.  However,
+in applications where it is critical to set several GPIOs at once, this
+interface doesn't work well, e.g. bit-banging protocols via grouped GPIO lines.
+Consider a GPIO controller that is connected via a slow I2C line. When
+switching two or more GPIOs one after another, there can be considerable time
+between those events. This is solved by an interface called Block GPIO:
+
+struct gpio_block *gpio_block_create(unsigned int *gpios, size_t size);
+
+This creates a new block of GPIOs as a list of GPIO numbers with the specified
+size which are accessible via the returned struct gpio_block and the accessor
+functions described below. Please note that you need to request the GPIOs
+separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
+specified, even ranging over several gpio_chips. Actual handling of I/O
+operations will be done on a best effort base, i.e. simultaneous I/O only where
+possible by hardware and implemented in the respective GPIO driver. The number
+of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
+system. However, several blocks can be defined at once.
+
+unsigned gpio_block_get(struct gpio_block *block);
+void gpio_block_set(struct gpio_block *block, unsigned value);
+
+With those accessor functions, setting and getting the GPIO values is possible,
+analogous to gpio_get_value() and gpio_set_value(). Each bit in the return
+value of gpio_block_get() and in the value argument of gpio_block_set()
+corresponds to a bit specified on gpio_block_create(). Block operations in
+hardware are only possible where the respective GPIO driver implements it,
+falling back to using single GPIO operations where the driver only implements
+single GPIO access.
+
+void gpio_block_free(struct gpio_block *block);
+
+After the GPIO block isn't used anymore, it should be free'd via
+gpio_block_free().
+
+int gpio_block_register(struct gpio_block *block);
+void gpio_block_unregister(struct gpio_block *block);
+
+These functions can be used to register a GPIO block. Blocks registered this
+way will be available via sysfs.
+
+
 What do these conventions omit?
 ===============================
 One of the biggest things these conventions omit is pin multiplexing, since
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -83,6 +83,8 @@ static inline void desc_set_label(struct
 #endif
 }
 
+static LIST_HEAD(gpio_block_list);
+
 /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
  * when setting direction, and otherwise illegal.  Until board setup code
  * and drivers use explicit requests everywhere (which won't happen when
@@ -1676,6 +1678,221 @@ void __gpio_set_value(unsigned gpio, int
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+static int gpio_block_chip_index(struct gpio_block *block, struct gpio_chip *gc)
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
+struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
+				     const char *name)
+{
+	struct gpio_block *block;
+	struct gpio_block_chip *gbc;
+	struct gpio_remap *remap;
+	void *tmp;
+	int i;
+
+	if (size < 1 || size > sizeof(unsigned long) * 8)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < size; i++)
+		if (!gpio_is_valid(gpios[i]))
+			return ERR_PTR(-EINVAL);
+
+	block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
+	if (!block)
+		return ERR_PTR(-ENOMEM);
+
+	block->name = name;
+	block->ngpio = size;
+	block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
+	if (!block->gpio)
+		goto err1;
+
+	memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
+
+	for (i = 0; i < size; i++) {
+		struct gpio_chip *gc = gpio_to_chip(gpios[i]);
+		int bit = gpios[i] - gc->base;
+		int index = gpio_block_chip_index(block, gc);
+
+		if (index < 0) {
+			block->nchip++;
+			tmp = krealloc(block->gbc,
+				       sizeof(struct gpio_block_chip) *
+				       block->nchip, GFP_KERNEL);
+			if (!tmp) {
+				kfree(block->gbc);
+				goto err2;
+			}
+			block->gbc = tmp;
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
+		 *
+		 * Note that even though in setting remap is given a negative
+		 * index, the next lines guard that the potential out-of-bounds
+		 * pointer is not dereferenced when out of bounds.
+		 */
+		remap = &gbc->remap[gbc->nremap - 1];
+		if (!gbc->nremap || (bit - i != remap->offset)) {
+			gbc->nremap++;
+			tmp = krealloc(gbc->remap,
+					      sizeof(struct gpio_remap) *
+					      gbc->nremap, GFP_KERNEL);
+			if (!tmp) {
+				kfree(gbc->remap);
+				goto err3;
+			}
+			gbc->remap = tmp;
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
+err3:
+	for (i = 0; i < block->nchip - 1; i++)
+		kfree(block->gbc[i].remap);
+	kfree(block->gbc);
+err2:
+	kfree(block->gpio);
+err1:
+	kfree(block);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(gpio_block_create);
+
+void gpio_block_free(struct gpio_block *block)
+{
+	int i;
+
+	for (i = 0; i < block->nchip; i++)
+		kfree(block->gbc[i].remap);
+	kfree(block->gpio);
+	kfree(block->gbc);
+	kfree(block);
+}
+EXPORT_SYMBOL_GPL(gpio_block_free);
+
+unsigned long gpio_block_get(const struct gpio_block *block)
+{
+	struct gpio_block_chip *gbc;
+	int i, j;
+	unsigned long values = 0;
+
+	for (i = 0; i < block->nchip; i++) {
+		unsigned long remapped = 0;
+
+		gbc = &block->gbc[i];
+
+		if (gbc->gc->get_block) {
+			remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
+		} else {
+			/* emulate */
+			for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
+				remapped |= gbc->gc->get(gbc->gc,
+						gbc->gc->base + j) << j;
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
+EXPORT_SYMBOL_GPL(gpio_block_get);
+
+void gpio_block_set(struct gpio_block *block, unsigned long values)
+{
+	struct gpio_block_chip *gbc;
+	int i, j;
+
+	for (i = 0; i < block->nchip; i++) {
+		unsigned long remapped = 0;
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
+		} else {
+			/* emulate */
+			for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
+				gbc->gc->set(gbc->gc, gbc->gc->base + j,
+					     (remapped >> j) & 1);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(gpio_block_set);
+
+struct gpio_block *gpio_block_find_by_name(const char *name)
+{
+	struct gpio_block *i;
+
+	list_for_each_entry(i, &gpio_block_list, list)
+		if (!strcmp(i->name, name))
+			return i;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(gpio_block_find_by_name);
+
+int gpio_block_register(struct gpio_block *block)
+{
+	if (gpio_block_find_by_name(block->name))
+		return -EBUSY;
+
+	list_add(&block->list, &gpio_block_list);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpio_block_register);
+
+void gpio_block_unregister(struct gpio_block *block)
+{
+	struct gpio_block *i;
+
+	list_for_each_entry(i, &gpio_block_list, list)
+		if (i == block) {
+			list_del(&i->list);
+			break;
+		}
+}
+EXPORT_SYMBOL_GPL(gpio_block_unregister);
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
+	unsigned long		(*get_block)(struct gpio_chip *chip,
+					     unsigned long mask);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
 	int			(*set_debounce)(struct gpio_chip *chip,
@@ -112,6 +115,9 @@ struct gpio_chip {
 
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	void			(*set_block)(struct gpio_chip *chip,
+					     unsigned long mask,
+					     unsigned long values);
 
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
@@ -171,6 +177,15 @@ extern void gpio_set_value_cansleep(unsi
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
 
+extern struct gpio_block *gpio_block_create(unsigned *gpio, size_t size,
+					    const char *name);
+extern void gpio_block_free(struct gpio_block *block);
+extern unsigned long gpio_block_get(const struct gpio_block *block);
+extern void gpio_block_set(struct gpio_block *block, unsigned long values);
+extern struct gpio_block *gpio_block_find_by_name(const char *name);
+extern int gpio_block_register(struct gpio_block *block);
+extern void gpio_block_unregister(struct gpio_block *block);
+
 extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -2,6 +2,8 @@
 #define __LINUX_GPIO_H
 
 #include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/list.h>
 
 /* see Documentation/gpio.txt */
 
@@ -39,6 +41,43 @@ struct gpio {
 	const char	*label;
 };
 
+/*
+ * struct gpio_remap - a structure for describing a bit mapping
+ * @mask:	a bit mask
+ * @offset:	how many bits to shift to the left (negative: to the right)
+ *
+ * When we are mapping bit values from one word to another (here: from GPIO
+ * block domain to GPIO driver domain) we first mask them out with mask and
+ * shift them as specified with offset. More complicated mappings are done by
+ * grouping several of those structs and adding the results together.
+ */
+struct gpio_remap {
+	unsigned long		mask;
+	int			offset;
+};
+
+struct gpio_block_chip {
+	struct gpio_chip	*gc;
+	struct gpio_remap	*remap;
+	int			nremap;
+	unsigned long		mask;
+};
+
+/**
+ * struct gpio_block - a structure describing a list of GPIOs for simultaneous
+ *                     operations
+ */
+struct gpio_block {
+	struct gpio_block_chip	*gbc;
+	size_t			nchip;
+	const char		*name;
+
+	int			ngpio;
+	unsigned		*gpio;
+
+	struct list_head	list;
+};
+
 #ifdef CONFIG_GENERIC_GPIO
 
 #ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
@@ -169,6 +208,41 @@ static inline void gpio_set_value(unsign
 	WARN_ON(1);
 }
 
+static inline
+struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
+				     const char *name)
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
+static inline unsigned long gpio_block_get(const struct gpio_block *block)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_block_set(struct gpio_block *block, unsigned long value)
+{
+	WARN_ON(1);
+}
+
+static inline int gpio_block_register(struct gpio_block *block)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_block_unregister(struct gpio_block *block)
+{
+	WARN_ON(1);
+}
+
 static inline int gpio_cansleep(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
