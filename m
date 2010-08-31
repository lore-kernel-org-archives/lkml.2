Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0HaR7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:59:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54711 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0HaR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JXf3YgFwqRkDEu8P6svQX3vaDOwKIyX4Y5SxgrmcOmkY1k/E07TSm9yzYStHGvgawS
         KF38ES3Q7FEtKJ3Tlie3lC2TXKpmr1fjmKqLVDZFIFhPUGnrpD5pw71SGh6Ze8JsOO5H
         tGTyV5gmbafqRveh07NldB73EUkzVuhHeRJbY=
Date: Tue, 31 Aug 2010 21:58:39 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v5] gpio: Add driver for basic memory-mapped GPIO
 controllers
Message-ID: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
References: <20100829212857.GA25592@oksana.dev.rtsoft.ru>
 <373151.77032.qm@web180311.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <373151.77032.qm@web180311.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic GPIO controllers may be found in various on-board FPGA
and ASIC solutions that are used to control board's switches, LEDs,
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

On Mon, Aug 30, 2010 at 01:23:18PM -0700, David Brownell wrote:
> --- On Sun, 8/29/10, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > > But  do it without BUG()... 
> > Yeah, good idea. Let's turn these BUG() into
> > WARN_ON_ONCE()?
> 
> I'm not a big fan of redundant -- and
>  noisy! error reports like
> that:  recall that errors were already reported
> (and ignored) on those paths, indicating invalid
> GPIOs (requested, or direction set, etc).

OK, here's another version. Looks good?

Thanks,

 drivers/gpio/Kconfig           |    5 +
 drivers/gpio/Makefile          |    1 +
 drivers/gpio/basic_mmio_gpio.c |  278 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 284 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/basic_mmio_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f623953..d1d1c24 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,6 +70,11 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_BASIC_MMIO
+	tristate "Basic memory-mapped GPIO controllers support"
+	help
+	  Say yes here to support basic memory-mapped GPIO controllers.
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index a69e060..dfb571b 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
new file mode 100644
index 0000000..ff5bc06
--- /dev/null
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -0,0 +1,278 @@
+/*
+ * Driver for basic memory-mapped GPIO controllers.
+ *
+ * Copyright 2008 MontaVista Software, Inc.
+ * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * ....``.```~~~~````.`.`.`.`.```````'',,,.........`````......`.......
+ * ...``                                                         ```````..
+ * ..The simplest form of a GPIO controller that the driver supports is``
+ *  `.just a single "data" register, where GPIO state can be read and/or `
+ *    `,..written. ,,..``~~~~ .....``.`.`.~~.```.`.........``````.```````
+ *        `````````
+                                    ___
+_/~~|___/~|   . ```~~~~~~       ___/___\___     ,~.`.`.`.`````.~~...,,,,...
+__________|~$@~~~        %~    /o*o*o*o*o*o\   .. Implementing such a GPIO .
+o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
+                                                 `....trivial..'~`.```.```
+ *                                                    ```````
+ *  .```````~~~~`..`.``.``.
+ * .  The driver supports  `...       ,..```.`~~~```````````````....````.``,,
+ * .   big-endian notation, just`.  .. A bit more sophisticated controllers ,
+ *  . register the device with -be`. .with a pair of set/clear-bit registers ,
+ *   `.. suffix.  ```~~`````....`.`   . affecting the data register and the .`
+ *     ``.`.``...```                  ```.. output pins are also supported.`
+ *                        ^^             `````.`````````.,``~``~``~~``````
+ *                                                   .                  ^^
+ *   ,..`.`.`...````````````......`.`.`.`.`.`..`.`.`..
+ * .. The expectation is that in at least some cases .    ,-~~~-,
+ *  .this will be used with roll-your-own ASIC/FPGA .`     \   /
+ *  .logic in Verilog or VHDL. ~~~`````````..`````~~`       \ /
+ *  ..````````......```````````                             \o_
+ *                                                           |
+ *                              ^^                          / \
+ *
+ *           ...`````~~`.....``.`..........``````.`.``.```........``.
+ *            `  8, 16, 32 and 64 bits registers are supported, and``.
+ *            . the number of GPIOs is determined by the width of   ~
+ *             .. the registers. ,............```.`.`..`.`.~~~.`.`.`~
+ *               `.......````.```
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
+struct bgpio_chip {
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
+static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct bgpio_chip, gc);
+}
+
+static unsigned long bgpio_in(struct bgpio_chip *bgc)
+{
+	switch (bgc->bits) {
+	case 8:
+		return __raw_readb(bgc->reg_dat);
+	case 16:
+		return __raw_readw(bgc->reg_dat);
+	case 32:
+		return __raw_readl(bgc->reg_dat);
+#if BITS_PER_LONG >= 64
+	case 64:
+		return __raw_readq(bgc->reg_dat);
+#endif
+	}
+	return 0;
+}
+
+static void bgpio_out(struct bgpio_chip *bgc, void __iomem *reg,
+		      unsigned long data)
+{
+	switch (bgc->bits) {
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
+}
+
+static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
+{
+	if (bgc->big_endian_bits)
+		return 1 << (bgc->bits - 1 - pin);
+	else
+		return 1 << pin;
+}
+
+static int bgpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+
+	return bgpio_in(bgc) & bgpio_pin2mask(bgc, gpio);
+}
+
+static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long mask = bgpio_pin2mask(bgc, gpio);
+	unsigned long flags;
+
+	if (bgc->reg_set) {
+		if (val)
+			bgpio_out(bgc, bgc->reg_set, mask);
+		else
+			bgpio_out(bgc, bgc->reg_clr, mask);
+		return;
+	}
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		bgc->data |= mask;
+	else
+		bgc->data &= ~mask;
+
+	bgpio_out(bgc, bgc->reg_dat, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	return 0;
+}
+
+static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	bgpio_set(gc, gpio, val);
+	return 0;
+}
+
+static int __devinit bgpio_probe(struct platform_device *pdev)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	struct device *dev = &pdev->dev;
+	struct bgpio_chip *bgc;
+	struct resource *res_dat;
+	struct resource *res_set;
+	struct resource *res_clr;
+	resource_size_t dat_sz;
+	int bits;
+
+	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
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
+	bgc = devm_kzalloc(dev, sizeof(*bgc), GFP_KERNEL);
+	if (!bgc)
+		return -ENOMEM;
+
+	bgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
+	if (!bgc->reg_dat)
+		return -ENOMEM;
+
+	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
+	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
+	if (res_set && res_clr) {
+		if (resource_size(res_set) != resource_size(res_clr) ||
+				resource_size(res_set) != dat_sz)
+			return -EINVAL;
+
+		bgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
+		bgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
+		if (!bgc->reg_set || !bgc->reg_clr)
+			return -ENOMEM;
+	} else if (res_set || res_clr) {
+		return -EINVAL;
+	}
+
+	spin_lock_init(&bgc->lock);
+
+	bgc->bits = bits;
+	bgc->big_endian_bits = !strcmp(platid->name, "basic-mmio-gpio-be");
+	bgc->data = bgpio_in(bgc);
+
+	bgc->gc.ngpio = bits;
+	bgc->gc.direction_input = bgpio_dir_in;
+	bgc->gc.direction_output = bgpio_dir_out;
+	bgc->gc.get = bgpio_get;
+	bgc->gc.set = bgpio_set;
+	bgc->gc.dev = dev;
+	bgc->gc.label = dev_name(dev);
+
+	if (dev->platform_data)
+		bgc->gc.base = (unsigned long)dev->platform_data;
+	else
+		bgc->gc.base = -1;
+
+	dev_set_drvdata(dev, bgc);
+
+	return gpiochip_add(&bgc->gc);
+}
+
+static int __devexit bgpio_remove(struct platform_device *pdev)
+{
+	struct bgpio_chip *bgc = dev_get_drvdata(&pdev->dev);
+
+	return gpiochip_remove(&bgc->gc);
+}
+
+static const struct platform_device_id bgpio_id_table[] = {
+	{ "basic-mmio-gpio", },
+	{ "basic-mmio-gpio-be", },
+	{},
+};
+MODULE_DEVICE_TABLE(platform, bgpio_id_table);
+
+static struct platform_driver bgpio_driver = {
+	.driver = {
+		.name = "basic-mmio-gpio",
+	},
+	.id_table = bgpio_id_table,
+	.probe = bgpio_probe,
+	.remove = __devexit_p(bgpio_remove),
+};
+
+static int __init bgpio_init(void)
+{
+	return platform_driver_register(&bgpio_driver);
+}
+module_init(bgpio_init);
+
+static void __exit bgpio_exit(void)
+{
+	platform_driver_unregister(&bgpio_driver);
+}
+module_exit(bgpio_exit);
+
+MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.5

