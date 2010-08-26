Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0HZR0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:26:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45241 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0HZR0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BbNYvzjKh5aUjASvSqzigS6DoggJXSV4twKqMytyiuJxvVEo0L1ohyiQZdTQRxCc5O
         6xXEcDt2Jz9AnWmofYX10QJmy3KNDxDb+eL/hgPGtJ+ZpW1nTHXA6eOh+gaOyxIw1T1R
         A+L70pwrML8vtB4mgX1LYb5GtrThGiAF9i7dM=
Date: Thu, 26 Aug 2010 21:26:02 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] gpio: Add driver for Anton GPIO controllers
Message-ID: <20100826172602.GA20410@oksana.dev.rtsoft.ru>
References: <20100826051705.GA25521@oksana.dev.rtsoft.ru>
 <290252.99759.qm@web180316.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <290252.99759.qm@web180316.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Anton GPIO controllers are not so complex controllers that may
be found in various on-board FPGAs that are used to control board's
switches, LEDs, chip-selects, Ethernet/USB PHY power, etc.

Usually these controllers do not privide any means of pin setup
(in/out/open drain).

The driver provides:
- Support for 8/16/32/64 bits registers;
- Support for GPIO controllers with clear/set registers;
- Support for GPIO controllers with a single "data" register;
- Support for big endian bits/GPIOs ordering (mostly used on PowerPC).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

In v2:

- Hopefully addressed David's comments regarding driver name;
- Now the driver fills gpio_chip.label.

 drivers/gpio/Kconfig      |    5 +
 drivers/gpio/Makefile     |    1 +
 drivers/gpio/anton_gpio.c |  244 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/anton_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f623953..4658ca6 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,6 +70,11 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_ANTON
+	tristate "Anton GPIO controllers support"
+	help
+	  Say yes here to support Anton GPIO controllers.
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a69e060..a31ddae 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_ANTON)	+= anton_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff --git a/drivers/gpio/anton_gpio.c b/drivers/gpio/anton_gpio.c
new file mode 100644
index 0000000..d044385
--- /dev/null
+++ b/drivers/gpio/anton_gpio.c
@@ -0,0 +1,244 @@
+/*
+ * Anton GPIO driver
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
+struct agpio_chip {
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
+static struct agpio_chip *to_agpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct agpio_chip, gc);
+}
+
+static unsigned long agpio_in(struct agpio_chip *agc)
+{
+	switch (agc->bits) {
+	case 8:
+		return __raw_readb(agc->reg_dat);
+	case 16:
+		return __raw_readw(agc->reg_dat);
+	case 32:
+		return __raw_readl(agc->reg_dat);
+#if BITS_PER_LONG >= 64
+	case 64:
+		return __raw_readq(agc->reg_dat);
+#endif
+	}
+	BUG();
+}
+
+static void agpio_out(struct agpio_chip *agc, void __iomem *reg,
+		      unsigned long data)
+{
+	switch (agc->bits) {
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
+static unsigned long agpio_pin2mask(struct agpio_chip *agc, unsigned int pin)
+{
+	if (agc->big_endian_bits)
+		return 1 << (agc->bits - 1 - pin);
+	else
+		return 1 << pin;
+}
+
+static int agpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct agpio_chip *agc = to_agpio_chip(gc);
+
+	return agpio_in(agc) & agpio_pin2mask(agc, gpio);
+}
+
+static void agpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct agpio_chip *agc = to_agpio_chip(gc);
+	unsigned long mask = agpio_pin2mask(agc, gpio);
+	unsigned long flags;
+
+	if (agc->reg_set) {
+		if (val)
+			agpio_out(agc, agc->reg_set, mask);
+		else
+			agpio_out(agc, agc->reg_clr, mask);
+		return;
+	}
+
+	spin_lock_irqsave(&agc->lock, flags);
+
+	if (val)
+		agc->data |= mask;
+	else
+		agc->data &= ~mask;
+
+	agpio_out(agc, agc->reg_dat, agc->data);
+
+	spin_unlock_irqrestore(&agc->lock, flags);
+}
+
+static int agpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int agpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	agpio_set(gc, gpio, val);
+	return 0;
+}
+
+static int __devinit agpio_probe(struct platform_device *pdev)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	struct device *dev = &pdev->dev;
+	struct agpio_chip *agc;
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
+	agc = devm_kzalloc(dev, sizeof(*agc), GFP_KERNEL);
+	if (!agc)
+		return -ENOMEM;
+
+	agc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
+	if (!agc->reg_dat)
+		return -ENOMEM;
+
+	res_set = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	res_clr = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (res_set && res_clr) {
+		if (resource_size(res_set) != resource_size(res_clr) ||
+				resource_size(res_set) != dat_sz)
+			return -EINVAL;
+
+		agc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
+		agc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
+		if (!agc->reg_set || !agc->reg_clr)
+			return -ENOMEM;
+	} else if (res_set || res_clr) {
+		return -EINVAL;
+	}
+
+	spin_lock_init(&agc->lock);
+
+	agc->bits = bits;
+	agc->big_endian_bits = !strcmp(platid->name, "anton-gpio-be");
+	agc->data = agpio_in(agc);
+
+	agc->gc.ngpio = bits;
+	agc->gc.direction_input = agpio_dir_in;
+	agc->gc.direction_output = agpio_dir_out;
+	agc->gc.get = agpio_get;
+	agc->gc.set = agpio_set;
+	agc->gc.label = dev_name(dev);
+
+	if (dev->platform_data)
+		agc->gc.base = (unsigned long)dev->platform_data;
+	else
+		agc->gc.base = -1;
+
+	dev_set_drvdata(dev, agc);
+
+	return gpiochip_add(&agc->gc);
+}
+
+static int __devexit agpio_remove(struct platform_device *pdev)
+{
+	struct agpio_chip *agc = dev_get_drvdata(&pdev->dev);
+
+	return gpiochip_remove(&agc->gc);
+}
+
+static const struct platform_device_id agpio_id_table[] = {
+	{ "anton-gpio", },
+	{ "anton-gpio-be", },
+	{},
+};
+MODULE_DEVICE_TABLE(platform, agpio_id_table);
+
+static struct platform_driver agpio_driver = {
+	.driver = {
+		.name = "anton-gpio",
+	},
+	.id_table = agpio_id_table,
+	.probe = agpio_probe,
+	.remove = __devexit_p(agpio_remove),
+};
+
+static int __init agpio_init(void)
+{
+	return platform_driver_register(&agpio_driver);
+}
+module_init(agpio_init);
+
+static void __exit agpio_exit(void)
+{
+	platform_driver_unregister(&agpio_driver);
+}
+module_exit(agpio_exit);
+
+MODULE_DESCRIPTION("Driver for Anton GPIO controllers");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.5

