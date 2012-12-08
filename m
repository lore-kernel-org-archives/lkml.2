Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab2LHChR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:37:17 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:33603 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab2LHChP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:37:15 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Subject: [PATCH v2] gpio: add TS-5500 DIO blocks support
Date: Fri,  7 Dec 2012 21:36:34 -0500
Message-Id: <1354934194-28213-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technologic Systems TS-5500 provides digital I/O lines exposed through
pin blocks. On this platform, there are three of them, named DIO1, DIO2
and LCD port, that may be used as a DIO block.

The TS-5500 pin blocks are described in the product's wiki:
http://wiki.embeddedarm.com/wiki/TS-5500#Digital_I.2FO

This driver is not limited to the TS-5500 blocks. It can be extended to
support similar boards pin blocks, such as on the TS-5600.

This patch is the V2 of the previous https://lkml.org/lkml/2012/9/25/671
with corrections suggested by Linus Walleij.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
---
 drivers/gpio/Kconfig                      |   8 +
 drivers/gpio/Makefile                     |   1 +
 drivers/gpio/gpio-ts5500.c                | 466 ++++++++++++++++++++++++++++++
 include/linux/platform_data/gpio-ts5500.h |  27 ++
 4 files changed, 502 insertions(+)
 create mode 100644 drivers/gpio/gpio-ts5500.c
 create mode 100644 include/linux/platform_data/gpio-ts5500.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 47150f5..d1e6474 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -189,6 +189,14 @@ config GPIO_STA2X11
 	  Say yes here to support the STA2x11/ConneXt GPIO device.
 	  The GPIO module has 128 GPIO pins with alternate functions.
 
+config GPIO_TS5500
+	tristate "TS-5500 DIO blocks and compatibles"
+	help
+	  This driver supports Digital I/O exposed by pin blocks found on some
+	  Technologic Systems platforms. It includes, but is not limited to, 3
+	  blocks of the TS-5500: DIO1, DIO2 and the LCD port, and the TS-5600
+	  LCD port.
+
 config GPIO_VT8500
 	bool "VIA/Wondermedia SoC GPIO Support"
 	depends on ARCH_VT8500
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9aeed67..e33f344 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
 obj-$(CONFIG_GPIO_TPS6586X)	+= gpio-tps6586x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
+obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
diff --git a/drivers/gpio/gpio-ts5500.c b/drivers/gpio/gpio-ts5500.c
new file mode 100644
index 0000000..0634cee
--- /dev/null
+++ b/drivers/gpio/gpio-ts5500.c
@@ -0,0 +1,466 @@
+/*
+ * Digital I/O driver for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * Technologic Systems platforms have pin blocks, exposing several Digital
+ * Input/Output lines (DIO). This driver aims to support single pin blocks.
+ * In that sense, the support is not limited to the TS-5500 blocks.
+ * Actually, the following platforms have DIO support:
+ *
+ * TS-5500:
+ *   Documentation: http://wiki.embeddedarm.com/wiki/TS-5500
+ *   Blocks: DIO1, DIO2 and LCD port.
+ *
+ * TS-5600:
+ *   Documentation: http://wiki.embeddedarm.com/wiki/TS-5600
+ *   Blocks: LCD port (identical to TS-5500 LCD).
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-ts5500.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* List of supported Technologic Systems platforms DIO blocks */
+enum ts5500_blocks { TS5500_DIO1, TS5500_DIO2, TS5500_LCD, TS5600_LCD };
+
+struct ts5500_priv {
+	const struct ts5500_dio *pinout;
+	struct gpio_chip gpio_chip;
+	spinlock_t lock;
+	bool strap;
+	u8 hwirq;
+};
+
+/*
+ * Hex 7D is used to control several blocks (e.g. DIO2 and LCD port).
+ * This flag ensures that the region has been requested by this driver.
+ */
+static bool hex7d_reserved;
+
+/*
+ * This structure is used to describe capabilities of DIO lines,
+ * such as available directions and connected interrupt (if any).
+ */
+struct ts5500_dio {
+	const u8 value_addr;
+	const u8 value_mask;
+	const u8 control_addr;
+	const u8 control_mask;
+	const bool no_input;
+	const bool no_output;
+	const u8 irq;
+};
+
+#define TS5500_DIO_IN_OUT(vaddr, vbit, caddr, cbit)	\
+	{						\
+		.value_addr = vaddr,			\
+		.value_mask = BIT(vbit),		\
+		.control_addr = caddr,			\
+		.control_mask = BIT(cbit),		\
+	}
+
+#define TS5500_DIO_IN(addr, bit)		\
+	{					\
+		.value_addr = addr,		\
+		.value_mask = BIT(bit),		\
+		.no_output = true,		\
+	}
+
+#define TS5500_DIO_IN_IRQ(addr, bit, _irq)	\
+	{					\
+		.value_addr = addr,		\
+		.value_mask = BIT(bit),		\
+		.no_output = true,		\
+		.irq = _irq,			\
+	}
+
+#define TS5500_DIO_OUT(addr, bit)		\
+	{					\
+		.value_addr = addr,		\
+		.value_mask = BIT(bit),		\
+		.no_input = true,		\
+	}
+
+/*
+ * Input/Output DIO lines are programmed in groups of 4. Their values are
+ * available through 4 consecutive bits in a value port, whereas the direction
+ * of these 4 lines is driven by only 1 bit in a control port.
+ */
+#define TS5500_DIO_GROUP(vaddr, vbitfrom, caddr, cbit)		\
+	TS5500_DIO_IN_OUT(vaddr, vbitfrom + 0, caddr, cbit),	\
+	TS5500_DIO_IN_OUT(vaddr, vbitfrom + 1, caddr, cbit),	\
+	TS5500_DIO_IN_OUT(vaddr, vbitfrom + 2, caddr, cbit),	\
+	TS5500_DIO_IN_OUT(vaddr, vbitfrom + 3, caddr, cbit)
+
+/*
+ * TS-5500 DIO1 block
+ *
+ *  value    control  dir    hw
+ *  addr bit addr bit in out irq name     pin offset
+ *
+ *  0x7b  0  0x7a  0  x   x      DIO1_0   1   0
+ *  0x7b  1  0x7a  0  x   x      DIO1_1   3   1
+ *  0x7b  2  0x7a  0  x   x      DIO1_2   5   2
+ *  0x7b  3  0x7a  0  x   x      DIO1_3   7   3
+ *  0x7b  4  0x7a  1  x   x      DIO1_4   9   4
+ *  0x7b  5  0x7a  1  x   x      DIO1_5   11  5
+ *  0x7b  6  0x7a  1  x   x      DIO1_6   13  6
+ *  0x7b  7  0x7a  1  x   x      DIO1_7   15  7
+ *  0x7c  0  0x7a  5  x   x      DIO1_8   4   8
+ *  0x7c  1  0x7a  5  x   x      DIO1_9   6   9
+ *  0x7c  2  0x7a  5  x   x      DIO1_10  8   10
+ *  0x7c  3  0x7a  5  x   x      DIO1_11  10  11
+ *  0x7c  4           x          DIO1_12  12  12
+ *  0x7c  5           x      7   DIO1_13  14  13
+ */
+static const struct ts5500_dio ts5500_dio1[] = {
+	TS5500_DIO_GROUP(0x7b, 0, 0x7a, 0),
+	TS5500_DIO_GROUP(0x7b, 4, 0x7a, 1),
+	TS5500_DIO_GROUP(0x7c, 0, 0x7a, 5),
+	TS5500_DIO_IN(0x7c, 4),
+	TS5500_DIO_IN_IRQ(0x7c, 5, 7),
+};
+
+/*
+ * TS-5500 DIO2 block
+ *
+ *  value    control  dir    hw
+ *  addr bit addr bit in out irq name     pin offset
+ *
+ *  0x7e  0  0x7d  0  x   x      DIO2_0   1   0
+ *  0x7e  1  0x7d  0  x   x      DIO2_1   3   1
+ *  0x7e  2  0x7d  0  x   x      DIO2_2   5   2
+ *  0x7e  3  0x7d  0  x   x      DIO2_3   7   3
+ *  0x7e  4  0x7d  1  x   x      DIO2_4   9   4
+ *  0x7e  5  0x7d  1  x   x      DIO2_5   11  5
+ *  0x7e  6  0x7d  1  x   x      DIO2_6   13  6
+ *  0x7e  7  0x7d  1  x   x      DIO2_7   15  7
+ *  0x7f  0  0x7d  5  x   x      DIO2_8   4   8
+ *  0x7f  1  0x7d  5  x   x      DIO2_9   6   9
+ *  0x7f  2  0x7d  5  x   x      DIO2_10  8   10
+ *  0x7f  3  0x7d  5  x   x      DIO2_11  10  11
+ *  0x7f  4           x      6   DIO2_13  14  12
+ */
+static const struct ts5500_dio ts5500_dio2[] = {
+	TS5500_DIO_GROUP(0x7e, 0, 0x7d, 0),
+	TS5500_DIO_GROUP(0x7e, 4, 0x7d, 1),
+	TS5500_DIO_GROUP(0x7f, 0, 0x7d, 5),
+	TS5500_DIO_IN_IRQ(0x7f, 4, 6),
+};
+
+/*
+ * TS-5500 LCD port used as DIO block
+ * TS-5600 LCD port is identical
+ *
+ *  value    control  dir    hw
+ *  addr bit addr bit in out irq name    pin offset
+ *
+ *  0x72  0  0x7d  2  x   x      LCD_0   8   0
+ *  0x72  1  0x7d  2  x   x      LCD_1   7   1
+ *  0x72  2  0x7d  2  x   x      LCD_2   10  2
+ *  0x72  3  0x7d  2  x   x      LCD_3   9   3
+ *  0x72  4  0x7d  3  x   x      LCD_4   12  4
+ *  0x72  5  0x7d  3  x   x      LCD_5   11  5
+ *  0x72  6  0x7d  3  x   x      LCD_6   14  6
+ *  0x72  7  0x7d  3  x   x      LCD_7   13  7
+ *  0x73  0               x      LCD_EN  5   8
+ *  0x73  6           x          LCD_WR  6   9
+ *  0x73  7           x      1   LCD_RS  3   10
+ */
+static const struct ts5500_dio ts5500_lcd[] = {
+	TS5500_DIO_GROUP(0x72, 0, 0x7d, 2),
+	TS5500_DIO_GROUP(0x72, 4, 0x7d, 3),
+	TS5500_DIO_OUT(0x73, 0),
+	TS5500_DIO_IN(0x73, 6),
+	TS5500_DIO_IN_IRQ(0x73, 7, 1),
+};
+
+static inline struct ts5500_priv *ts5500_gc_to_priv(struct gpio_chip *chip)
+{
+	return container_of(chip, struct ts5500_priv, gpio_chip);
+}
+
+static inline void ts5500_set_mask(u8 mask, u8 addr)
+{
+	u8 val = inb(addr);
+	val |= mask;
+	outb(val, addr);
+}
+
+static inline void ts5500_clear_mask(u8 mask, u8 addr)
+{
+	u8 val = inb(addr);
+	val &= ~mask;
+	outb(val, addr);
+}
+
+static int ts5500_gpio_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_priv *priv = ts5500_gc_to_priv(chip);
+	const struct ts5500_dio line = priv->pinout[offset];
+	unsigned long flags;
+
+	if (line.no_input)
+		return -ENXIO;
+
+	if (line.no_output)
+		return 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ts5500_clear_mask(line.control_mask, line.control_addr);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static int ts5500_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_priv *priv = ts5500_gc_to_priv(chip);
+	const struct ts5500_dio line = priv->pinout[offset];
+
+	return !!(inb(line.value_addr) & line.value_mask);
+}
+
+static int ts5500_gpio_output(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct ts5500_priv *priv = ts5500_gc_to_priv(chip);
+	const struct ts5500_dio line = priv->pinout[offset];
+	unsigned long flags;
+
+	if (line.no_output)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (!line.no_input)
+		ts5500_set_mask(line.control_mask, line.control_addr);
+
+	if (val)
+		ts5500_set_mask(line.value_mask, line.value_addr);
+	else
+		ts5500_clear_mask(line.value_mask, line.value_addr);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static void ts5500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	struct ts5500_priv *priv = ts5500_gc_to_priv(chip);
+	const struct ts5500_dio line = priv->pinout[offset];
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (val)
+		ts5500_set_mask(line.value_mask, line.value_addr);
+	else
+		ts5500_clear_mask(line.value_mask, line.value_addr);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct ts5500_priv *priv = ts5500_gc_to_priv(chip);
+	const struct ts5500_dio *block = priv->pinout;
+	const struct ts5500_dio line = block[offset];
+
+	/* Only one pin is connected to an interrupt */
+	if (line.irq)
+		return line.irq;
+
+	/* As this pin is input-only, we may strap it to another in/out pin */
+	if (priv->strap)
+		return priv->hwirq;
+
+	return -ENXIO;
+}
+
+static int ts5500_enable_irq(struct ts5500_priv *priv)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->hwirq == 7)
+		ts5500_set_mask(BIT(7), 0x7a); /* DIO1_13 on IRQ7 */
+	else if (priv->hwirq == 6)
+		ts5500_set_mask(BIT(7), 0x7d); /* DIO2_13 on IRQ6 */
+	else if (priv->hwirq == 1)
+		ts5500_set_mask(BIT(6), 0x7d); /* LCD_RS on IRQ1 */
+	else
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return ret;
+}
+
+static void ts5500_disable_irq(struct ts5500_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->hwirq == 7)
+		ts5500_clear_mask(BIT(7), 0x7a); /* DIO1_13 on IRQ7 */
+	else if (priv->hwirq == 6)
+		ts5500_clear_mask(BIT(7), 0x7d); /* DIO2_13 on IRQ6 */
+	else if (priv->hwirq == 1)
+		ts5500_clear_mask(BIT(6), 0x7d); /* LCD_RS on IRQ1 */
+	else
+		dev_err(priv->gpio_chip.dev, "invalid hwirq %d\n", priv->hwirq);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static int __devinit ts5500_dio_probe(struct platform_device *pdev)
+{
+	enum ts5500_blocks block = platform_get_device_id(pdev)->driver_data;
+	struct ts5500_dio_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	const char *name = dev_name(dev);
+	struct ts5500_priv *priv;
+	struct resource *res;
+	unsigned long flags;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "missing IRQ resource\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(dev, sizeof(struct ts5500_priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, priv);
+	priv->hwirq = res->start;
+	spin_lock_init(&priv->lock);
+
+	priv->gpio_chip.owner = THIS_MODULE;
+	priv->gpio_chip.label = name;
+	priv->gpio_chip.dev = dev;
+	priv->gpio_chip.direction_input = ts5500_gpio_input;
+	priv->gpio_chip.direction_output = ts5500_gpio_output;
+	priv->gpio_chip.get = ts5500_gpio_get;
+	priv->gpio_chip.set = ts5500_gpio_set;
+	priv->gpio_chip.to_irq = ts5500_gpio_to_irq;
+	priv->gpio_chip.base = -1;
+	if (pdata) {
+		priv->gpio_chip.base = pdata->base;
+		priv->strap = pdata->strap;
+	}
+
+	switch (block) {
+	case TS5500_DIO1:
+		priv->pinout = ts5500_dio1;
+		priv->gpio_chip.ngpio = ARRAY_SIZE(ts5500_dio1);
+
+		if (!devm_request_region(dev, 0x7a, 3, name)) {
+			dev_err(dev, "failed to request %s ports\n", name);
+			return -EBUSY;
+		}
+		break;
+	case TS5500_DIO2:
+		priv->pinout = ts5500_dio2;
+		priv->gpio_chip.ngpio = ARRAY_SIZE(ts5500_dio2);
+
+		if (!devm_request_region(dev, 0x7e, 2, name)) {
+			dev_err(dev, "failed to request %s ports\n", name);
+			return -EBUSY;
+		}
+
+		if (hex7d_reserved)
+			break;
+
+		if (!devm_request_region(dev, 0x7d, 1, name)) {
+			dev_err(dev, "failed to request %s 7D\n", name);
+			return -EBUSY;
+		}
+
+		hex7d_reserved = true;
+		break;
+	case TS5500_LCD:
+	case TS5600_LCD:
+		priv->pinout = ts5500_lcd;
+		priv->gpio_chip.ngpio = ARRAY_SIZE(ts5500_lcd);
+
+		if (!devm_request_region(dev, 0x72, 2, name)) {
+			dev_err(dev, "failed to request %s ports\n", name);
+			return -EBUSY;
+		}
+
+		if (!hex7d_reserved) {
+			if (!devm_request_region(dev, 0x7d, 1, name)) {
+				dev_err(dev, "failed to request %s 7D\n", name);
+				return -EBUSY;
+			}
+
+			hex7d_reserved = true;
+		}
+
+		/* Ensure usage of LCD port as DIO */
+		spin_lock_irqsave(&priv->lock, flags);
+		ts5500_clear_mask(BIT(4), 0x7d);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		break;
+	}
+
+	ret = gpiochip_add(&priv->gpio_chip);
+	if (ret) {
+		dev_err(dev, "failed to register the gpio chip\n");
+		return ret;
+	}
+
+	ret = ts5500_enable_irq(priv);
+	if (ret) {
+		dev_err(dev, "invalid interrupt %d\n", priv->hwirq);
+		goto cleanup;
+	}
+
+	return 0;
+cleanup:
+	if (gpiochip_remove(&priv->gpio_chip))
+		dev_err(dev, "failed to remove gpio chip\n");
+	return ret;
+}
+
+static int __devexit ts5500_dio_remove(struct platform_device *pdev)
+{
+	struct ts5500_priv *priv = platform_get_drvdata(pdev);
+
+	ts5500_disable_irq(priv);
+	return gpiochip_remove(&priv->gpio_chip);
+}
+
+static struct platform_device_id ts5500_dio_ids[] = {
+	{ "ts5500-dio1", TS5500_DIO1 },
+	{ "ts5500-dio2", TS5500_DIO2 },
+	{ "ts5500-dio-lcd", TS5500_LCD },
+	{ "ts5600-dio-lcd", TS5600_LCD },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, ts5500_dio_ids);
+
+static struct platform_driver ts5500_dio_driver = {
+	.driver = {
+		.name = "ts5500-dio",
+		.owner = THIS_MODULE,
+	},
+	.probe = ts5500_dio_probe,
+	.remove = __devexit_p(ts5500_dio_remove),
+	.id_table = ts5500_dio_ids,
+};
+
+module_platform_driver(ts5500_dio_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500 Digital I/O driver");
diff --git a/include/linux/platform_data/gpio-ts5500.h b/include/linux/platform_data/gpio-ts5500.h
new file mode 100644
index 0000000..b10d11c
--- /dev/null
+++ b/include/linux/platform_data/gpio-ts5500.h
@@ -0,0 +1,27 @@
+/*
+ * GPIO (DIO) header for Technologic Systems TS-5500
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PDATA_GPIO_TS5500_H
+#define _PDATA_GPIO_TS5500_H
+
+/**
+ * struct ts5500_dio_platform_data - TS-5500 pin block configuration
+ * @base:	The GPIO base number to use.
+ * @strap:	The only pin connected to an interrupt in a block is input-only.
+ *		If you need a bidirectional line which can trigger an IRQ, you
+ *		may strap it with an in/out pin. This flag indicates this case.
+ */
+struct ts5500_dio_platform_data {
+	int base;
+	bool strap;
+};
+
+#endif /* _PDATA_GPIO_TS5500_H */
-- 
1.7.11.7

