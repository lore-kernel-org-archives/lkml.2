Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0HYTm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:42:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37359 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0HYTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oK0jlaPgXAi9G/PqSkoPC6cvbOepx17yVZzJ1ljJZOx3HSzntUsA9D1zkGYx3V83hX
         glTjQgm6WdyZ0cnBxp2dlqMZ8EB6AL5gFxwq38BlMOv6g3vpMjK5o823/y6vUz7WQM/8
         6oJSEX82+JBZBc0XacAj2a3r9nqKQGBW2RCmc=
Date: Wed, 25 Aug 2010 23:42:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: Add generic driver for simple memory mapped
 controllers
Message-ID: <20100825194249.GA453@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple memory mapped GPIO controllers may be found in various
onboard FPGAs that are used to control board's switches, LEDs,
chip-selects, Ethernet/USB PHY power, etc.

Usually these controllers do not privide any means of pin setup
(in/out/open drain).

The driver provides:
- Support for 8/16/32/64 bits registers;
- Support for GPIO controllers with clear/set registers;
- Support for GPIO controllers with a single "data" register;
- Support for big endian bits/GPIOs ordering (mostly used on PowerPC).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/gpio/Kconfig          |    5 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/simple_mm_gpio.c |  243 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/simple_mm_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f623953..a145063 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -82,6 +82,11 @@ config GPIO_PL061
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
 
+config GPIO_SIMPLE_MM
+	tristate "Simple memory mapped GPIO controllers support"
+	help
+	  Say yes here to support simple memory mapped GPIO controllers.
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a69e060..bfd43bb 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
+obj-$(CONFIG_GPIO_SIMPLE_MM)	+= simple_mm_gpio.o
 obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
diff --git a/drivers/gpio/simple_mm_gpio.c b/drivers/gpio/simple_mm_gpio.c
new file mode 100644
index 0000000..028dce8
--- /dev/null
+++ b/drivers/gpio/simple_mm_gpio.c
@@ -0,0 +1,243 @@
+/*
+ * Simple memory mapped GPIOs
+ *
+ * Copyright 2008 MontaVista Software, Inc.
+ * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/log2.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
+
+struct sgpio_chip {
+	struct gpio_chip gc;
+	void __iomem *reg_dat;
+	void __iomem *reg_set;
+	void __iomem *reg_clr;
+	spinlock_t lock;
+
+	int bits;
+	int big_endian_bits;
+
+	/* shadowed data register to clear/set bits safely */
+	unsigned long data;
+};
+
+static struct sgpio_chip *to_sgpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct sgpio_chip, gc);
+}
+
+static unsigned long sgpio_in(struct sgpio_chip *sgc)
+{
+	switch (sgc->bits) {
+	case 8:
+		return __raw_readb(sgc->reg_dat);
+	case 16:
+		return __raw_readw(sgc->reg_dat);
+	case 32:
+		return __raw_readl(sgc->reg_dat);
+#if BITS_PER_LONG >= 64
+	case 64:
+		return __raw_readq(sgc->reg_dat);
+#endif
+	}
+	BUG();
+}
+
+static void sgpio_out(struct sgpio_chip *sgc, void __iomem *reg,
+		      unsigned long data)
+{
+	switch (sgc->bits) {
+	case 8:
+		__raw_writeb(data, reg);
+		return;
+	case 16:
+		__raw_writew(data, reg);
+		return;
+	case 32:
+		__raw_writel(data, reg);
+		return;
+#if BITS_PER_LONG >= 64
+	case 64:
+		__raw_writeq(data, reg);
+		return;
+#endif
+	}
+	BUG();
+}
+
+static unsigned long sgpio_pin2mask(struct sgpio_chip *sgc, unsigned int pin)
+{
+	if (sgc->big_endian_bits)
+		return 1 << (sgc->bits - 1 - pin);
+	else
+		return 1 << pin;
+}
+
+static int sgpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct sgpio_chip *sgc = to_sgpio_chip(gc);
+
+	return sgpio_in(sgc) & sgpio_pin2mask(sgc, gpio);
+}
+
+static void sgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct sgpio_chip *sgc = to_sgpio_chip(gc);
+	unsigned long mask = sgpio_pin2mask(sgc, gpio);
+	unsigned long flags;
+
+	if (sgc->reg_set) {
+		if (val)
+			sgpio_out(sgc, sgc->reg_set, mask);
+		else
+			sgpio_out(sgc, sgc->reg_clr, mask);
+		return;
+	}
+
+	spin_lock_irqsave(&sgc->lock, flags);
+
+	if (val)
+		sgc->data |= mask;
+	else
+		sgc->data &= ~mask;
+
+	sgpio_out(sgc, sgc->reg_dat, sgc->data);
+
+	spin_unlock_irqrestore(&sgc->lock, flags);
+}
+
+static int sgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int sgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	sgpio_set(gc, gpio, val);
+	return 0;
+}
+
+static int __devinit sgpio_probe(struct platform_device *pdev)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	struct device *dev = &pdev->dev;
+	struct sgpio_chip *sgc;
+	struct resource *res_dat;
+	struct resource *res_set;
+	struct resource *res_clr;
+	resource_size_t dat_sz;
+	int bits;
+
+	res_dat = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_dat)
+		return -EINVAL;
+
+	dat_sz = resource_size(res_dat);
+	if (!is_power_of_2(dat_sz))
+		return -EINVAL;
+
+	bits = dat_sz * 8;
+	if (bits > BITS_PER_LONG)
+		return -EINVAL;
+
+	sgc = devm_kzalloc(dev, sizeof(*sgc), GFP_KERNEL);
+	if (!sgc)
+		return -ENOMEM;
+
+	sgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
+	if (!sgc->reg_dat)
+		return -ENOMEM;
+
+	res_set = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	res_clr = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (res_set && res_clr) {
+		if (resource_size(res_set) != resource_size(res_clr) ||
+				resource_size(res_set) != dat_sz)
+			return -EINVAL;
+
+		sgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
+		sgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
+		if (!sgc->reg_set || !sgc->reg_clr)
+			return -ENOMEM;
+	} else if (res_set || res_clr) {
+		return -EINVAL;
+	}
+
+	spin_lock_init(&sgc->lock);
+
+	sgc->bits = bits;
+	sgc->big_endian_bits = !strcmp(platid->name, "simple-mm-gpio-be");
+	sgc->data = sgpio_in(sgc);
+
+	sgc->gc.ngpio = bits;
+	sgc->gc.direction_input = sgpio_dir_in;
+	sgc->gc.direction_output = sgpio_dir_out;
+	sgc->gc.get = sgpio_get;
+	sgc->gc.set = sgpio_set;
+
+	if (pdev->dev.platform_data)
+		sgc->gc.base = (unsigned long)pdev->dev.platform_data;
+	else
+		sgc->gc.base = -1;
+
+	dev_set_drvdata(dev, sgc);
+
+	return gpiochip_add(&sgc->gc);
+}
+
+static int __devexit sgpio_remove(struct platform_device *pdev)
+{
+	struct sgpio_chip *sgc = dev_get_drvdata(&pdev->dev);
+
+	return gpiochip_remove(&sgc->gc);
+}
+
+static const struct platform_device_id sgpio_id_table[] = {
+	{ "simple-mm-gpio", },
+	{ "simple-mm-gpio-be", },
+	{},
+};
+MODULE_DEVICE_TABLE(platform, sgpio_id_table);
+
+static struct platform_driver sgpio_driver = {
+	.driver = {
+		.name = "simple-mm-gpio",
+	},
+	.id_table = sgpio_id_table,
+	.probe = sgpio_probe,
+	.remove = __devexit_p(sgpio_remove),
+};
+
+static int __init sgpio_init(void)
+{
+	return platform_driver_register(&sgpio_driver);
+}
+module_init(sgpio_init);
+
+static void __exit sgpio_exit(void)
+{
+	platform_driver_unregister(&sgpio_driver);
+}
+module_exit(sgpio_exit);
+
+MODULE_DESCRIPTION("Driver for simple memory mapped GPIO controllers");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.5
