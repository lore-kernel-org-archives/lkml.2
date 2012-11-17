Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2KQKCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:02:23 -0500
Received: from antcom.de ([188.40.178.216]:34421 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2KQKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:00:58 -0500
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/6 v7] gpio: Add a block GPIO API to gpiolib
Date: Sat, 17 Nov 2012 10:59:48 +0100
Message-Id: <1353146393-19312-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353146393-19312-1-git-send-email-stigge@antcom.de>
References: <1353146393-19312-1-git-send-email-stigge@antcom.de>
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

 Documentation/gpio.txt     |   57 +++++++++++
 drivers/gpio/gpiolib.c     |  217 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   17 +++
 include/linux/gpio.h       |   97 ++++++++++++++++++++
 4 files changed, 388 insertions(+)

--- linux-2.6.orig/Documentation/gpio.txt
+++ linux-2.6/Documentation/gpio.txt
@@ -439,6 +439,63 @@ slower clock delays the rising edge of S
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
+separately via gpio_request(). Similarly, the direction of the used GPIOs need
+to be set by the user before using the block. An arbitrary list of globally
+valid GPIOs can be specified, even ranging over several gpio_chips. Actual
+handling of I/O operations will be done on a best effort base, i.e.
+simultaneous I/O only where possible by hardware and implemented in the
+respective GPIO driver. The number of GPIOs in one block is limited to the
+number of bits in an unsigned long, or BITS_PER_LONG, of the respective
+platform, i.e. typically at least 32 on a 32 bit system, and at least 64 on a
+64 bit system. However, several blocks can be defined at once.
+
+unsigned long gpio_block_get(struct gpio_block *block, unsigned long mask);
+void gpio_block_set(struct gpio_block *block, unsigned long mask,
+		    unsigned long values);
+
+With those accessor functions, setting and getting the GPIO values is possible,
+analogous to gpio_get_value() and gpio_set_value(). Each bit in the return
+value of gpio_block_get() and in the value argument of gpio_block_set()
+corresponds to a bit specified on gpio_block_create(). The mask parameters
+specify which bits in the block are acted upon. This is useful to let some bits
+untouched when doing a set operation on the block.
+
+Block operations in hardware are only possible where the respective GPIO driver
+implements it, falling back to using single GPIO operations where the driver
+only implements single GPIO access.
+
+If a GPIO block includes GPIOs from several chips, the chips are handled one
+after another in the order of first specification in the list of GPIOs defined
+in the GPIO block, starting with bit 0. Note that in this case, you typically
+can't assume simultaneous access.
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
+way will be available via userspace API.
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
@@ -1680,6 +1682,221 @@ void __gpio_set_value(unsigned gpio, int
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+static struct gpio_block_chip *gpio_block_chip_get(struct gpio_block *block,
+						   struct gpio_chip *gc)
+{
+	struct gpio_block_chip *i;
+
+	list_for_each_entry(i, &block->gbc_list, list)
+		if (i->gc == gc)
+			return i;
+	return NULL;
+}
+
+struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
+				     const char *name)
+{
+	struct gpio_block *block;
+	struct gpio_block_chip *gbc;
+	struct gpio_remap *remap;
+	int i;
+
+	if (size < 1 || size > BITS_PER_LONG)
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
+	INIT_LIST_HEAD(&block->gbc_list);
+	block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
+	if (!block->gpio)
+		goto err;
+
+	memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
+
+	for (i = 0; i < size; i++) {
+		struct gpio_chip *gc = gpio_to_chip(gpios[i]);
+		int bit = gpios[i] - gc->base;
+		gbc = gpio_block_chip_get(block, gc);
+
+		if (!gbc) {
+			gbc = kzalloc(sizeof(struct gpio_block_chip),
+				      GFP_KERNEL);
+			if (!gbc)
+				goto err;
+			list_add_tail(&gbc->list, &block->gbc_list);
+			gbc->gc = gc;
+			INIT_LIST_HEAD(&gbc->remap_list);
+		}
+
+		/*
+		 * represents the mask necessary on calls to the driver's
+		 * .get_block() and .set_block()
+		 */
+		gbc->mask |= BIT(bit);
+
+		/*
+		 * collect gpios that are specified together, represented by
+		 * neighboring bits
+		 *
+		 * get last element and create new element if list empty or
+		 * new element necessary
+		 */
+		remap = list_entry(gbc->remap_list.prev, struct gpio_remap,
+				   list);
+		if (list_empty(&gbc->remap_list) ||
+		    (bit - i != remap->offset)) {
+			remap = kzalloc(sizeof(struct gpio_remap), GFP_KERNEL);
+			if (!remap)
+				goto err;
+			list_add_tail(&remap->list, &gbc->remap_list);
+			remap->offset = bit - i;
+		}
+
+		/*
+		 * represents the mask necessary for bit reordering between
+		 * gpio_block (i.e. as specified on gpio_block_get() and
+		 * gpio_block_set()) and gpio_chip domain (i.e. as specified on
+		 * the driver's .set_block() and .get_block())
+		 */
+		remap->mask |= BIT(i);
+	}
+
+	return block;
+err:
+	gpio_block_free(block);
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(gpio_block_create);
+
+void gpio_block_free(struct gpio_block *block)
+{
+	struct list_head *i, *itmp, *j, *jtmp;
+	struct gpio_block_chip *gbc;
+	struct gpio_remap *remap;
+
+	list_for_each_safe(i, itmp, &block->gbc_list) {
+		gbc = list_entry(i, struct gpio_block_chip, list);
+		list_del(i);
+		list_for_each_safe(j, jtmp, &gbc->remap_list) {
+		       remap = list_entry(j, struct gpio_remap, list);
+		       list_del(j);
+		       kfree(remap);
+		}
+		kfree(gbc);
+	}
+
+	kfree(block->gpio);
+	kfree(block);
+}
+EXPORT_SYMBOL_GPL(gpio_block_free);
+
+unsigned long gpio_block_get(const struct gpio_block *block, unsigned long mask)
+{
+	struct gpio_block_chip *gbc;
+	unsigned long values = 0;
+
+	list_for_each_entry(gbc, &block->gbc_list, list) {
+		struct gpio_remap *remap;
+		int i;
+		unsigned long remapped = 0;
+		unsigned long remapped_mask = 0;
+
+		list_for_each_entry(remap, &gbc->remap_list, list)
+			remapped_mask |= (mask & remap->mask) << remap->offset;
+		remapped_mask &= gbc->mask;
+
+		if (!remapped_mask)
+			continue;
+
+		if (gbc->gc->get_block)
+			remapped = gbc->gc->get_block(gbc->gc, remapped_mask);
+		else
+			/* emulate */
+			for_each_set_bit(i, &remapped_mask, BITS_PER_LONG)
+				remapped |= gbc->gc->get(gbc->gc,
+						gbc->gc->base + i) << i;
+
+		list_for_each_entry(remap, &gbc->remap_list, list)
+			values |= (remapped >> remap->offset) & remap->mask;
+	}
+
+	return values;
+}
+EXPORT_SYMBOL_GPL(gpio_block_get);
+
+void gpio_block_set(struct gpio_block *block, unsigned long mask,
+		    unsigned long values)
+{
+	struct gpio_block_chip *gbc;
+
+	list_for_each_entry(gbc, &block->gbc_list, list) {
+		struct gpio_remap *remap;
+		int i;
+		unsigned long remapped = 0;
+		unsigned long remapped_mask = 0;
+
+		list_for_each_entry(remap, &gbc->remap_list, list) {
+			remapped |= (values & remap->mask) << remap->offset;
+			remapped_mask |= (mask & remap->mask) << remap->offset;
+		}
+		remapped_mask &= gbc->mask;
+
+		if (!remapped_mask)
+			continue;
+
+		if (gbc->gc->set_block)
+			gbc->gc->set_block(gbc->gc, remapped_mask, remapped);
+		else
+			/* emulate */
+			for_each_set_bit(i, &remapped_mask, BITS_PER_LONG)
+				gbc->gc->set(gbc->gc, gbc->gc->base + i,
+					     (remapped >> i) & 1);
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
@@ -171,6 +177,17 @@ extern void gpio_set_value_cansleep(unsi
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
 
+extern struct gpio_block *gpio_block_create(unsigned *gpio, size_t size,
+					    const char *name);
+extern void gpio_block_free(struct gpio_block *block);
+extern unsigned long gpio_block_get(const struct gpio_block *block,
+				    unsigned long mask);
+extern void gpio_block_set(struct gpio_block *block, unsigned long mask,
+			   unsigned long values);
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
 
@@ -39,6 +41,64 @@ struct gpio {
 	const char	*label;
 };
 
+/**
+ * struct gpio_remap - a structure for describing a bit mapping
+ * @mask:	a bit mask, relevant for a (partial) mapping
+ * @offset:	how many bits to shift to the left (negative: to the right)
+ * @list:	several remappings are internally collected in a list
+ *
+ * When we are mapping bit values from one word to another (here: from GPIO
+ * block domain to GPIO driver domain) we first mask them out with mask and
+ * shift them as specified with offset. More complicated mappings are done by
+ * grouping several of those structs and adding the results together.
+ */
+struct gpio_remap {
+	unsigned long		mask;
+	int			offset;
+
+	struct list_head	list;
+};
+
+/**
+ * struct gpio_block_chip - a structure representing chip specific data in a
+ *                          gpio block
+ * @gc:          the chip
+ * @remap_list:  list of remappings, there are several necessary if the bits
+ *               are not consecutive
+ * @mask:        chip specific mask, used for propagating to the driver's
+ *               get_block() and set_block() functions
+ * @list:        list collecting potentially multiple chips in one block
+ *
+ * This structure holds information about remapping and masking of gpios within
+ * one chip. There can be several of those in one block.
+ */
+struct gpio_block_chip {
+	struct gpio_chip	*gc;
+	struct list_head	remap_list;
+	unsigned long		mask;
+
+	struct list_head	list;
+};
+
+/**
+ * struct gpio_block - a structure describing a list of GPIOs for simultaneous
+ *                     operations
+ * @gbc_list:   list of chips in this block, typically just one
+ * @name:       the name of this block
+ * @ngpio:      number of gpios in this block
+ * @gpio:       list of gpios in this block
+ * @list:       global list of blocks, maintained by gpiolib
+ */
+struct gpio_block {
+	struct list_head	gbc_list;
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
@@ -169,6 +229,43 @@ static inline void gpio_set_value(unsign
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
+static inline unsigned long gpio_block_get(const struct gpio_block *block,
+					   unsigned long mask)
+{
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_block_set(struct gpio_block *block, unsigned long mask,
+				  unsigned long values)
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
