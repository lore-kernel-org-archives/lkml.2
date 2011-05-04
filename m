Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1EDOiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:38:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47778 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1EDOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:38:02 -0400
Date: Wed, 4 May 2011 15:37:57 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504143757.GB15967@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
 <20110504110939.GB13514@pulham.picochip.com>
 <20110504113131.GA639@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <20110504113131.GA639@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 04, 2011 at 03:31:31PM +0400, Anton Vorontsov wrote:
> On Wed, May 04, 2011 at 12:09:39PM +0100, Jamie Iles wrote:
> > On Wed, May 04, 2011 at 02:34:15AM +0400, Anton Vorontsov wrote:
> > > On Tue, May 03, 2011 at 11:04:08PM +0100, Jamie Iles wrote:
> > > [...]
> > > > The advantage that Grant's proposal has though is that the user can 
> > > > override the gpio_chip callbacks.  When I tried porting over some 
> > > > existing ARM platforms, one of the blocking issues was that lots of 
> > > > platforms had some annoying small detail that was slightly different 
> > > > (such as doing muxing in the _get() callback or needing a to_irq 
> > > > callback).
> > > > 
> > > > If we make bgpio_chip public and return that from bgpio_probe 
> > > > unregistered then the calling code can override some of the methods then 
> > > > register the gpio_chip.
> > > 
> > > Oh, that makes sense, right.
> > 
> > I've just given this a try and it largely works, but it's probably 
> > better if we allow bgpio_chip to be embedded in other structures.  For 
> > example, the langwell driver has a gpio_to_irq callback that we would 
> > need to get the IRQ base for the bank.  We could add a void *priv member 
> > to bgpio_chip but that doesn't feel quite right.
> > 
> > So,
> > 	int bgpio_init(struct bgpio_chip *bgc, struct device *dev, 
> > 		       unsigned long sz, void __iomem *dat, ...)
> > 
> > rather than a probe() that returns the bgpio_chip?
> 
> Sounds good to me.

OK, so here's what I've got so far (patches attached).  I've updated the 
basic_mmio_gpio library with your initial lkml patch and updated it to 
allow bgpio_chip to be embedded in another structure.  I've also 
attempted to convert over the bt8xx and langwell drivers but they're a 
little rough around the edges in places (and untested as I don't have 
the hardware).

Jamie

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-basic_mmio_gpio-split-into-a-gpio-library-and-platfo.patch"

>From 21f25152816acfb145daebbaeb75f33d70c7ec53 Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Wed, 4 May 2011 14:27:58 +0100
Subject: [PATCH 1/3] basic_mmio_gpio: split into a gpio library and platform
 device

Allow GPIO_BASIC_MMIO_CORE to be used to provide an accessor library
for implementing GPIO drivers whilst abstracting the register access
detail.  Based on a patch from Anton Vorontsov[1] and adapted to allow
bgpio_chip to be embedded in another structure.

1. https://lkml.org/lkml/2011/4/19/401
---
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/basic_mmio_gpio.c  |  317 +++++++++++++++++++++------------------
 include/linux/basic_mmio_gpio.h |   55 +++++++
 4 files changed, 231 insertions(+), 148 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b7fac15..ca16a30 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,8 +70,14 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO drivers:"
 
+config GPIO_BASIC_MMIO_CORE
+	tristate
+	help
+	  Provides core functionality for basic memory-mapped GPIO controllers.
+
 config GPIO_BASIC_MMIO
 	tristate "Basic memory-mapped GPIO controllers support"
+	select GPIO_BASIC_MMIO_CORE
 	help
 	  Say yes here to support basic memory-mapped GPIO controllers.
 
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index cfbdef1..91a295d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index b2ec45f..6b1c6e5 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -45,6 +45,7 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
  */
 
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -61,44 +62,6 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
 #include <linux/mod_devicetable.h>
 #include <linux/basic_mmio_gpio.h>
 
-struct bgpio_chip {
-	struct gpio_chip gc;
-
-	unsigned long (*read_reg)(void __iomem *reg);
-	void (*write_reg)(void __iomem *reg, unsigned long data);
-
-	void __iomem *reg_dat;
-	void __iomem *reg_set;
-	void __iomem *reg_clr;
-	void __iomem *reg_dir;
-
-	/* Number of bits (GPIOs): <register width> * 8. */
-	int bits;
-
-	/*
-	 * Some GPIO controllers work with the big-endian bits notation,
-	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
-	 */
-	unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
-
-	/*
-	 * Used to lock bgpio_chip->data. Also, this is needed to keep
-	 * shadowed and real data registers writes together.
-	 */
-	spinlock_t lock;
-
-	/* Shadowed data register to clear/set bits safely. */
-	unsigned long data;
-
-	/* Shadowed direction registers to clear/set direction safely. */
-	unsigned long dir;
-};
-
-static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
-{
-	return container_of(gc, struct bgpio_chip, gc);
-}
-
 static void bgpio_write8(void __iomem *reg, unsigned long data)
 {
 	writeb(data, reg);
@@ -284,20 +247,10 @@ static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static void __iomem *bgpio_request_and_map(struct device *dev,
-					   struct resource *res)
-{
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				     res->name ?: "mmio_gpio"))
-		return NULL;
-
-	return devm_ioremap(dev, res->start, resource_size(res));
-}
-
-static int bgpio_setup_accessors(struct platform_device *pdev,
-				 struct bgpio_chip *bgc)
+static int bgpio_setup_accessors(struct device *dev,
+				 struct bgpio_chip *bgc,
+				 bool be)
 {
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
 
 	switch (bgc->bits) {
 	case 8:
@@ -319,13 +272,11 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
 		break;
 #endif /* BITS_PER_LONG >= 64 */
 	default:
-		dev_err(&pdev->dev, "unsupported data width %u bits\n",
-			bgc->bits);
+		dev_err(dev, "unsupported data width %u bits\n", bgc->bits);
 		return -EINVAL;
 	}
 
-	bgc->pin2mask = strcmp(platid->name, "basic-mmio-gpio-be") ?
-		bgpio_pin2mask : bgpio_pin2mask_be;
+	bgc->pin2mask = be ? bgpio_pin2mask_be : bgpio_pin2mask;
 
 	return 0;
 }
@@ -352,51 +303,22 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
  *	- an input direction register (named "dirin") where a 1 bit indicates
  *	the GPIO is an input.
  */
-static int bgpio_setup_io(struct platform_device *pdev,
-			  struct bgpio_chip *bgc)
+static int bgpio_setup_io(struct bgpio_chip *bgc,
+			  void __iomem *dat,
+			  void __iomem *set,
+			  void __iomem *clr)
 {
-	struct resource *res_set;
-	struct resource *res_clr;
-	struct resource *res_dat;
-	resource_size_t dat_sz;
 
-	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
-	if (!res_dat)
-		return -EINVAL;
-
-	dat_sz = resource_size(res_dat);
-	if (!is_power_of_2(dat_sz))
-		return -EINVAL;
-
-	bgc->bits = dat_sz * 8;
-	if (bgc->bits > BITS_PER_LONG)
-		return -EINVAL;
-
-	bgc->reg_dat = bgpio_request_and_map(&pdev->dev, res_dat);
+	bgc->reg_dat = dat;
 	if (!bgc->reg_dat)
-		return -ENOMEM;
-
-	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
-	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
-	if (res_set && res_clr) {
-		if (resource_size(res_set) != resource_size(res_clr) ||
-		    resource_size(res_set) != resource_size(res_dat))
-			return -EINVAL;
-
-		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
-		bgc->reg_clr = bgpio_request_and_map(&pdev->dev, res_clr);
-		if (!bgc->reg_set || !bgc->reg_clr)
-			return -ENOMEM;
+		return -EINVAL;
 
+	if (set && clr) {
+		bgc->reg_set = set;
+		bgc->reg_clr = clr;
 		bgc->gc.set = bgpio_set_with_clear;
-	} else if (res_set && !res_clr) {
-		if (resource_size(res_set) != resource_size(res_dat))
-			return -EINVAL;
-
-		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
-		if (!bgc->reg_set)
-			return -ENOMEM;
-
+	} else if (set && !clr) {
+		bgc->reg_set = set;
 		bgc->gc.set = bgpio_set_set;
 	} else {
 		bgc->gc.set = bgpio_set;
@@ -407,27 +329,18 @@ static int bgpio_setup_io(struct platform_device *pdev,
 	return 0;
 }
 
-static int bgpio_setup_direction(struct platform_device *pdev,
-				 struct bgpio_chip *bgc)
+static int bgpio_setup_direction(struct bgpio_chip *bgc,
+				 void __iomem *dirout,
+				 void __iomem *dirin)
 {
-	struct resource *res_dirout;
-	struct resource *res_dirin;
-
-	res_dirout = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						  "dirout");
-	res_dirin = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirin");
-	if (res_dirout && res_dirin) {
+	if (dirout && dirin) {
 		return -EINVAL;
-	} else if (res_dirout) {
-		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirout);
-		if (!bgc->reg_dir)
-			return -ENOMEM;
+	} else if (dirout) {
+		bgc->reg_dir = dirout;
 		bgc->gc.direction_output = bgpio_dir_out;
 		bgc->gc.direction_input = bgpio_dir_in;
-	} else if (res_dirin) {
-		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirin);
-		if (!bgc->reg_dir)
-			return -ENOMEM;
+	} else if (dirin) {
+		bgc->reg_dir = dirin;
 		bgc->gc.direction_output = bgpio_dir_out_inv;
 		bgc->gc.direction_input = bgpio_dir_in_inv;
 	} else {
@@ -438,60 +351,166 @@ static int bgpio_setup_direction(struct platform_device *pdev,
 	return 0;
 }
 
-static int __devinit bgpio_probe(struct platform_device *pdev)
+int __devexit bgpio_remove(struct bgpio_chip *bgc)
+{
+	int err = gpiochip_remove(&bgc->gc);
+
+	kfree(bgc);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(bgpio_remove);
+
+int __devinit bgpio_init(struct bgpio_chip *bgc,
+			 struct device *dev,
+			 unsigned long sz,
+			 void __iomem *dat,
+			 void __iomem *set,
+			 void __iomem *clr,
+			 void __iomem *dirout,
+			 void __iomem *dirin,
+			 bool big_endian)
 {
-	struct device *dev = &pdev->dev;
-	struct bgpio_pdata *pdata = dev_get_platdata(dev);
-	struct bgpio_chip *bgc;
 	int ret;
-	int ngpio;
 
-	bgc = devm_kzalloc(dev, sizeof(*bgc), GFP_KERNEL);
-	if (!bgc)
-		return -ENOMEM;
+	if (!is_power_of_2(sz))
+		return -EINVAL;
 
-	ret = bgpio_setup_io(pdev, bgc);
+	bgc->bits = sz * 8;
+	if (bgc->bits > BITS_PER_LONG)
+		return -EINVAL;
+
+	spin_lock_init(&bgc->lock);
+	bgc->gc.dev = dev;
+	bgc->gc.label = dev_name(dev);
+	bgc->gc.base = -1;
+	bgc->gc.ngpio = bgc->bits;
+
+	ret = bgpio_setup_io(bgc, dat, set, clr);
 	if (ret)
 		return ret;
 
-	ngpio = bgc->bits;
-	if (pdata) {
-		bgc->gc.base = pdata->base;
-		if (pdata->ngpio > 0)
-			ngpio = pdata->ngpio;
-	} else {
-		bgc->gc.base = -1;
-	}
-
-	ret = bgpio_setup_accessors(pdev, bgc);
+	ret = bgpio_setup_accessors(dev, bgc, big_endian);
 	if (ret)
 		return ret;
 
-	spin_lock_init(&bgc->lock);
-	ret = bgpio_setup_direction(pdev, bgc);
+	ret = bgpio_setup_direction(bgc, dirout, dirin);
 	if (ret)
 		return ret;
 
 	bgc->data = bgc->read_reg(bgc->reg_dat);
 
-	bgc->gc.ngpio = ngpio;
-	bgc->gc.dev = dev;
-	bgc->gc.label = dev_name(dev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bgpio_init);
 
-	platform_set_drvdata(pdev, bgc);
+#ifdef CONFIG_GPIO_BASIC_MMIO
 
-	ret = gpiochip_add(&bgc->gc);
-	if (ret)
-		dev_err(dev, "gpiochip_add() failed: %d\n", ret);
+static void __iomem *bgpio_map(struct platform_device *pdev,
+			       const char *name,
+			       resource_size_t sane_sz,
+			       int *err)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *r;
+	resource_size_t start;
+	resource_size_t sz;
+	void __iomem *ret;
+
+	*err = 0;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+	if (!r)
+		return NULL;
+
+	sz = resource_size(r);
+	if (sz != sane_sz) {
+		*err = -EINVAL;
+		return NULL;
+	}
+
+	start = r->start;
+	if (!devm_request_mem_region(dev, start, sz, r->name)) {
+		*err = -EBUSY;
+		return NULL;
+	}
+
+	ret = devm_ioremap(dev, start, sz);
+	if (!ret) {
+		*err = -ENOMEM;
+		return NULL;
+	}
 
 	return ret;
 }
 
-static int __devexit bgpio_remove(struct platform_device *pdev)
+static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *r;
+	void __iomem *dat;
+	void __iomem *set;
+	void __iomem *clr;
+	void __iomem *dirout;
+	void __iomem *dirin;
+	unsigned long sz;
+	bool be;
+	int err;
+	struct bgpio_chip *bgc;
+	struct bgpio_pdata *pdata = dev_get_platdata(dev);
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
+	if (!r)
+		return -EINVAL;
+
+	sz = resource_size(r);
+
+	dat = bgpio_map(pdev, "dat", sz, &err);
+	if (!dat)
+		return err ? err : -EINVAL;
+
+	set = bgpio_map(pdev, "set", sz, &err);
+	if (err)
+		return err;
+
+	clr = bgpio_map(pdev, "clr", sz, &err);
+	if (err)
+		return err;
+
+	dirout = bgpio_map(pdev, "dirout", sz, &err);
+	if (err)
+		return err;
+
+	dirin = bgpio_map(pdev, "dirin", sz, &err);
+	if (err)
+		return err;
+
+	be = !strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be");
+
+	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
+	if (!bgc)
+		return -ENOMEM;
+
+	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
+	if (err)
+		return err;
+
+	if (pdata) {
+		bgc->gc.base = pdata->base;
+		if (pdata->ngpio > 0)
+			bgc->gc.ngpio = pdata->ngpio;
+	}
+
+	platform_set_drvdata(pdev, bgc);
+
+	return 0;
+}
+
+static int __devexit bgpio_pdev_remove(struct platform_device *pdev)
 {
 	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
 
-	return gpiochip_remove(&bgc->gc);
+	return bgpio_remove(bgc);
 }
 
 static const struct platform_device_id bgpio_id_table[] = {
@@ -506,21 +525,23 @@ static struct platform_driver bgpio_driver = {
 		.name = "basic-mmio-gpio",
 	},
 	.id_table = bgpio_id_table,
-	.probe = bgpio_probe,
-	.remove = __devexit_p(bgpio_remove),
+	.probe = bgpio_pdev_probe,
+	.remove = __devexit_p(bgpio_pdev_remove),
 };
 
-static int __init bgpio_init(void)
+static int __init bgpio_platform_init(void)
 {
 	return platform_driver_register(&bgpio_driver);
 }
-module_init(bgpio_init);
+module_init(bgpio_platform_init);
 
-static void __exit bgpio_exit(void)
+static void __exit bgpio_platform_exit(void)
 {
 	platform_driver_unregister(&bgpio_driver);
 }
-module_exit(bgpio_exit);
+module_exit(bgpio_platform_exit);
+
+#endif /* CONFIG_GPIO_BASIC_MMIO */
 
 MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index f23ec73..1ae1271 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -13,9 +13,64 @@
 #ifndef __BASIC_MMIO_GPIO_H
 #define __BASIC_MMIO_GPIO_H
 
+#include <linux/gpio.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+
 struct bgpio_pdata {
 	int base;
 	int ngpio;
 };
 
+struct device;
+
+struct bgpio_chip {
+	struct gpio_chip gc;
+
+	unsigned long (*read_reg)(void __iomem *reg);
+	void (*write_reg)(void __iomem *reg, unsigned long data);
+
+	void __iomem *reg_dat;
+	void __iomem *reg_set;
+	void __iomem *reg_clr;
+	void __iomem *reg_dir;
+
+	/* Number of bits (GPIOs): <register width> * 8. */
+	int bits;
+
+	/*
+	 * Some GPIO controllers work with the big-endian bits notation,
+	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
+	 */
+	unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
+
+	/*
+	 * Used to lock bgpio_chip->data. Also, this is needed to keep
+	 * shadowed and real data registers writes together.
+	 */
+	spinlock_t lock;
+
+	/* Shadowed data register to clear/set bits safely. */
+	unsigned long data;
+
+	/* Shadowed direction registers to clear/set direction safely. */
+	unsigned long dir;
+};
+
+static inline struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct bgpio_chip, gc);
+}
+
+int __devexit bgpio_remove(struct bgpio_chip *bgc);
+int __devinit bgpio_init(struct bgpio_chip *bgc,
+			 struct device *dev,
+			 unsigned long sz,
+			 void __iomem *dat,
+			 void __iomem *set,
+			 void __iomem *clr,
+			 void __iomem *dirout,
+			 void __iomem *dirin,
+			 bool big_endian);
+
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.4.4


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-gpio-bt8xxgpio-convert-to-use-basic_mmio_gpio-librar.patch"

>From 34a2b274369fb136d2111a0d5747f42daeb3a9b9 Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Wed, 4 May 2011 14:29:40 +0100
Subject: [PATCH 2/3] gpio/bt8xxgpio: convert to use basic_mmio_gpio library

Use the basic_mmio_gpio library for the register accesses.  The driver
itself is now only concerned with PCI and hardware initialisation.
---
 drivers/gpio/Kconfig     |    1 +
 drivers/gpio/bt8xxgpio.c |  119 ++++++++++------------------------------------
 2 files changed, 26 insertions(+), 94 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ca16a30..898cdb2 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -332,6 +332,7 @@ config GPIO_CS5535
 config GPIO_BT8XX
 	tristate "BT8XX GPIO abuser"
 	depends on PCI && VIDEO_BT848=n
+	select GPIO_BASIC_MMIO_CORE
 	help
 	  The BT8xx frame grabber chip has 24 GPIO pins than can be abused
 	  as a cheap PCI GPIO card.
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index aa4f09a..63ed0cb 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -43,11 +43,13 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 /* Steal the hardware definitions from the bttv driver. */
 #include "../media/video/bt8xx/bt848.h"
@@ -61,7 +63,7 @@ struct bt8xxgpio {
 
 	void __iomem *mmio;
 	struct pci_dev *pdev;
-	struct gpio_chip gpio;
+	struct bgpio_chip bgc;
 
 #ifdef CONFIG_PM
 	u32 saved_outen;
@@ -77,101 +79,23 @@ static int modparam_gpiobase = -1/* dynamic */;
 module_param_named(gpiobase, modparam_gpiobase, int, 0444);
 MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, which is the default.");
 
-
-static int bt8xxgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+static int bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
 {
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 outen, data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	data = bgread(BT848_GPIO_DATA);
-	data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
-
-	outen = bgread(BT848_GPIO_OUT_EN);
-	outen &= ~(1 << nr);
-	bgwrite(outen, BT848_GPIO_OUT_EN);
-
-	spin_unlock_irqrestore(&bg->lock, flags);
-
-	return 0;
-}
-
-static int bt8xxgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&bg->lock, flags);
-	val = bgread(BT848_GPIO_DATA);
-	spin_unlock_irqrestore(&bg->lock, flags);
-
-	return !!(val & (1 << nr));
-}
-
-static int bt8xxgpio_gpio_direction_output(struct gpio_chip *gpio,
-					unsigned nr, int val)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 outen, data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	outen = bgread(BT848_GPIO_OUT_EN);
-	outen |= (1 << nr);
-	bgwrite(outen, BT848_GPIO_OUT_EN);
+	void __iomem *dir_out = bg->mmio + BT848_GPIO_OUT_EN;
+	void __iomem *dat = bg->mmio + BT848_GPIO_DATA;
+	int err;
 
-	data = bgread(BT848_GPIO_DATA);
-	if (val)
-		data |= (1 << nr);
-	else
-		data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
+	err = bgpio_init(&bg->bgc, &bg->pdev->dev, 4, dat, NULL, NULL,
+			 dir_out, NULL, 0);
+	if (err)
+		return err;
 
-	spin_unlock_irqrestore(&bg->lock, flags);
+	bg->bgc.gc.base = modparam_gpiobase;
+	bg->bgc.gc.ngpio = BT8XXGPIO_NR_GPIOS;
 
 	return 0;
 }
 
-static void bt8xxgpio_gpio_set(struct gpio_chip *gpio,
-			    unsigned nr, int val)
-{
-	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
-	unsigned long flags;
-	u32 data;
-
-	spin_lock_irqsave(&bg->lock, flags);
-
-	data = bgread(BT848_GPIO_DATA);
-	if (val)
-		data |= (1 << nr);
-	else
-		data &= ~(1 << nr);
-	bgwrite(data, BT848_GPIO_DATA);
-
-	spin_unlock_irqrestore(&bg->lock, flags);
-}
-
-static void bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
-{
-	struct gpio_chip *c = &bg->gpio;
-
-	c->label = dev_name(&bg->pdev->dev);
-	c->owner = THIS_MODULE;
-	c->direction_input = bt8xxgpio_gpio_direction_input;
-	c->get = bt8xxgpio_gpio_get;
-	c->direction_output = bt8xxgpio_gpio_direction_output;
-	c->set = bt8xxgpio_gpio_set;
-	c->dbg_show = NULL;
-	c->base = modparam_gpiobase;
-	c->ngpio = BT8XXGPIO_NR_GPIOS;
-	c->can_sleep = 0;
-}
-
 static int bt8xxgpio_probe(struct pci_dev *dev,
 			const struct pci_device_id *pci_id)
 {
@@ -216,18 +140,25 @@ static int bt8xxgpio_probe(struct pci_dev *dev,
 	bgwrite(0, BT848_GPIO_REG_INP);
 	bgwrite(0, BT848_GPIO_OUT_EN);
 
-	bt8xxgpio_gpio_setup(bg);
-	err = gpiochip_add(&bg->gpio);
+	err = bt8xxgpio_gpio_setup(bg);
 	if (err) {
-		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
+		printk(KERN_ERR "bt8xxgpio: Failed to init GPIOs\n");
 		goto err_release_mem;
 	}
 
+	err = gpiochip_add(&bg->bgc.gc);
+	if (err) {
+		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
+		goto err_release_bgc;
+	}
+
 	printk(KERN_INFO "bt8xxgpio: Abusing BT8xx card for GPIOs %d to %d\n",
-	       bg->gpio.base, bg->gpio.base + BT8XXGPIO_NR_GPIOS - 1);
+	       bg->bgc.gc.base, bg->bgc.gc.base + BT8XXGPIO_NR_GPIOS - 1);
 
 	return 0;
 
+err_release_bgc:
+	bgpio_remove(&bg->bgc);
 err_release_mem:
 	release_mem_region(pci_resource_start(dev, 0),
 			   pci_resource_len(dev, 0));
@@ -244,7 +175,7 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
 {
 	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
 
-	gpiochip_remove(&bg->gpio);
+	bgpio_remove(&bg->bgc);
 
 	bgwrite(0, BT848_INT_MASK);
 	bgwrite(~0x0, BT848_INT_STAT);
-- 
1.7.4.4


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-gpio-langwell-convert-to-use-basic_mmio_gpio-library.patch"

>From 2426c6da6d14c3ec95b03dbc570f4fc0baa14948 Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Wed, 4 May 2011 14:30:59 +0100
Subject: [PATCH 3/3] gpio/langwell: convert to use basic_mmio_gpio library

Use the basic_mmio_gpio library for register accessors.  The driver is
now only concerned with hardware initialisation and interrupts.
---
 drivers/gpio/Kconfig         |    1 +
 drivers/gpio/langwell_gpio.c |  253 ++++++++++++++++++++---------------------
 2 files changed, 124 insertions(+), 130 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 898cdb2..a0e3370 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -349,6 +349,7 @@ config GPIO_BT8XX
 config GPIO_LANGWELL
 	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI && X86
+	select GPIO_BASIC_MMIO_CORE
 	help
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 1b06f67..a2898cd 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
@@ -58,106 +59,53 @@ enum GPIO_REG {
 	GEDR,		/* edge detect result */
 };
 
-struct lnw_gpio {
-	struct gpio_chip		chip;
-	void				*reg_base;
-	spinlock_t			lock;
+struct lnw_bank {
+	struct bgpio_chip		bgc;
+	void __iomem			*grer, *gfer, *gedr;
 	unsigned			irq_base;
 };
 
-static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
-			enum GPIO_REG reg_type)
-{
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	unsigned nreg = chip->ngpio / 32;
-	u8 reg = offset / 32;
-	void __iomem *ptr;
-
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
-	return ptr;
-}
-
-static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
-
-	return readl(gplr) & BIT(offset % 32);
-}
-
-static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	void __iomem *gpsr, *gpcr;
-
-	if (value) {
-		gpsr = gpio_reg(chip, offset, GPSR);
-		writel(BIT(offset % 32), gpsr);
-	} else {
-		gpcr = gpio_reg(chip, offset, GPCR);
-		writel(BIT(offset % 32), gpcr);
-	}
-}
-
-static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static inline struct lnw_bank *to_lnw_bank(struct bgpio_chip *bgc)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
-	u32 value;
-	unsigned long flags;
-
-	spin_lock_irqsave(&lnw->lock, flags);
-	value = readl(gpdr);
-	value &= ~BIT(offset % 32);
-	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
-	return 0;
+	return container_of(bgc, struct lnw_bank, bgc);
 }
 
-static int lnw_gpio_direction_output(struct gpio_chip *chip,
-			unsigned offset, int value)
-{
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
-	unsigned long flags;
-
-	lnw_gpio_set(chip, offset, value);
-	spin_lock_irqsave(&lnw->lock, flags);
-	value = readl(gpdr);
-	value |= BIT(offset % 32);
-	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
-	return 0;
-}
+struct lnw_gpio {
+	struct lnw_bank			banks[3];
+	int				nr_banks;
+	void __iomem			*reg_base;
+};
 
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	return lnw->irq_base + offset;
+	struct bgpio_chip *bgc = to_bgpio_chip(chip);
+	struct lnw_bank *bank = to_lnw_bank(bgc);
+
+	return bank->irq_base + offset;
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
-	u32 gpio = d->irq - lnw->irq_base;
+	struct lnw_bank *bank = irq_data_get_irq_chip_data(d);
+	u32 gpio = d->irq - bank->irq_base;
 	unsigned long flags;
 	u32 value;
-	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
-	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
 
-	if (gpio >= lnw->chip.ngpio)
+	if (gpio >= bank->bgc.gc.ngpio)
 		return -EINVAL;
-	spin_lock_irqsave(&lnw->lock, flags);
+	spin_lock_irqsave(&bank->bgc.lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
-		value = readl(grer) | BIT(gpio % 32);
+		value = readl(bank->grer) | BIT(gpio % 32);
 	else
-		value = readl(grer) & (~BIT(gpio % 32));
-	writel(value, grer);
+		value = readl(bank->grer) & (~BIT(gpio % 32));
+	writel(value, bank->grer);
 
 	if (type & IRQ_TYPE_EDGE_FALLING)
-		value = readl(gfer) | BIT(gpio % 32);
+		value = readl(bank->gfer) | BIT(gpio % 32);
 	else
-		value = readl(gfer) & (~BIT(gpio % 32));
-	writel(value, gfer);
-	spin_unlock_irqrestore(&lnw->lock, flags);
+		value = readl(bank->gfer) & (~BIT(gpio % 32));
+	writel(value, bank->gfer);
+	spin_unlock_irqrestore(&bank->bgc.lock, flags);
 
 	return 0;
 }
@@ -192,30 +140,101 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, gpio, mask;
 	unsigned long pending;
-	void __iomem *gedr;
+	int i;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
-	for (base = 0; base < lnw->chip.ngpio; base += 32) {
-		gedr = gpio_reg(&lnw->chip, base, GEDR);
-		pending = readl(gedr);
+	for (base = 0, i = 0; i < lnw->nr_banks; base += 32, i++) {
+		struct lnw_bank *bank = &lnw->banks[i];
+
+		pending = readl(bank->gedr);
 		while (pending) {
 			gpio = __ffs(pending) - 1;
 			mask = BIT(gpio);
 			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */
-			writel(mask, gedr);
-			generic_handle_irq(lnw->irq_base + base + gpio);
+			writel(mask, bank->gedr);
+			generic_handle_irq(bank->irq_base + gpio);
 		}
 	}
 
 	chip->irq_eoi(data);
 }
 
+static int bank_init(struct lnw_bank *bank, struct device *dev,
+		     void __iomem *reg_base, int bank_nr, int ngpio)
+{
+	unsigned nreg = ngpio / 32;
+	void __iomem *dat = reg_base + GPLR * nreg * 4 + bank_nr * 4;
+	void __iomem *dirout = reg_base + GPDR * nreg * 4 + bank_nr * 4;
+	void __iomem *set = reg_base + GPSR * nreg * 4 + bank_nr * 4;
+	void __iomem *clr = reg_base + GPCR * nreg * 4 + bank_nr * 4;
+
+	bank->grer = reg_base + GRER * nreg * 4 + bank_nr * 4;
+	bank->gfer = reg_base + GFER * nreg * 4 + bank_nr * 4;
+	bank->gedr = reg_base + GEDR * nreg * 4 + bank_nr * 4;
+
+	return bgpio_init(&bank->bgc, dev, 4, dat, set, clr, dirout, NULL, 0);
+}
+
+static int lnw_init_banks(struct lnw_gpio *lnw, int nr_banks,
+			  struct device *dev, int irq_base, int gpio_base)
+{
+	int retval, i;
+	lnw->nr_banks = nr_banks;
+
+	for (i = 0; i < lnw->nr_banks; i++) {
+		struct lnw_bank *bank = &lnw->banks[i];
+		int j;
+
+		retval = bank_init(bank, dev, lnw->reg_base, i, nr_banks * 32);
+		if (retval) {
+			dev_err(dev, "langwell failed to init bank %d (%d)\n",
+				i, retval);
+			goto out_remove;
+		}
+		bank->bgc.gc.ngpio = 32;
+		bank->bgc.gc.base = gpio_base + i * 32;
+
+		if (irq_base > 0) {
+			bank->irq_base = irq_base + i * 32;
+			bank->bgc.gc.to_irq = lnw_gpio_to_irq;
+			for (j = 0; j < 32; j++) {
+				irq_set_chip_and_handler_name(
+					j + bank->irq_base, &lnw_irqchip,
+					handle_simple_irq, "demux");
+				irq_set_chip_data(j + bank->irq_base, bank);
+			}
+		}
+
+		retval = gpiochip_add(&bank->bgc.gc);
+		if (retval) {
+			dev_err(dev, "langwell gpiochip_add error %d\n",
+				retval);
+			goto out_remove;
+		}
+	}
+
+	return 0;
+
+out_remove:
+	while (--i >= 0) {
+		int j;
+		struct lnw_bank *bank = &lnw->banks[i];
+		bgpio_remove(&bank->bgc);
+		if (irq_base > 0) {
+			for (j = 0; j < 32; ++j)
+				irq_set_chip_and_handler(j + bank->irq_base,
+							 NULL, NULL);
+		}
+	}
+
+	return retval;
+}
+
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
-			const struct pci_device_id *id)
+				    const struct pci_device_id *id)
 {
 	void *base;
-	int i;
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
 	u32 irq_base;
@@ -259,32 +278,17 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		retval = -ENOMEM;
 		goto err4;
 	}
+
 	lnw->reg_base = base;
-	lnw->irq_base = irq_base;
-	lnw->chip.label = dev_name(&pdev->dev);
-	lnw->chip.direction_input = lnw_gpio_direction_input;
-	lnw->chip.direction_output = lnw_gpio_direction_output;
-	lnw->chip.get = lnw_gpio_get;
-	lnw->chip.set = lnw_gpio_set;
-	lnw->chip.to_irq = lnw_gpio_to_irq;
-	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = id->driver_data;
-	lnw->chip.can_sleep = 0;
-	pci_set_drvdata(pdev, lnw);
-	retval = gpiochip_add(&lnw->chip);
-	if (retval) {
-		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
+	retval = lnw_init_banks(lnw, id->driver_data / 32, &pdev->dev,
+				irq_base, gpio_base);
+	if (retval)
 		goto err5;
-	}
+
+	pci_set_drvdata(pdev, lnw);
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
-	for (i = 0; i < lnw->chip.ngpio; i++) {
-		irq_set_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
-					      handle_simple_irq, "demux");
-		irq_set_chip_data(i + lnw->irq_base, lnw);
-	}
 
-	spin_lock_init(&lnw->lock);
 	goto done;
 err5:
 	kfree(lnw);
@@ -304,11 +308,9 @@ static struct pci_driver lnw_gpio_driver = {
 	.probe		= lnw_gpio_probe,
 };
 
-
 static int __devinit wp_gpio_probe(struct platform_device *pdev)
 {
 	struct lnw_gpio *lnw;
-	struct gpio_chip *gc;
 	struct resource *rc;
 	int retval = 0;
 
@@ -327,24 +329,10 @@ static int __devinit wp_gpio_probe(struct platform_device *pdev)
 		retval = -EINVAL;
 		goto err_kmalloc;
 	}
-	spin_lock_init(&lnw->lock);
-	gc = &lnw->chip;
-	gc->label = dev_name(&pdev->dev);
-	gc->owner = THIS_MODULE;
-	gc->direction_input = lnw_gpio_direction_input;
-	gc->direction_output = lnw_gpio_direction_output;
-	gc->get = lnw_gpio_get;
-	gc->set = lnw_gpio_set;
-	gc->to_irq = NULL;
-	gc->base = 0;
-	gc->ngpio = 64;
-	gc->can_sleep = 0;
-	retval = gpiochip_add(gc);
-	if (retval) {
-		dev_err(&pdev->dev, "whitneypoint gpiochip_add error %d\n",
-								retval);
+
+	retval = lnw_init_banks(lnw, 2, &pdev->dev, -1, 0);
+	if (retval)
 		goto err_ioremap;
-	}
 	platform_set_drvdata(pdev, lnw);
 	return 0;
 err_ioremap:
@@ -357,10 +345,15 @@ err_kmalloc:
 static int __devexit wp_gpio_remove(struct platform_device *pdev)
 {
 	struct lnw_gpio *lnw = platform_get_drvdata(pdev);
-	int err;
-	err = gpiochip_remove(&lnw->chip);
-	if (err)
-		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	int i, err;
+
+	for (i = 0; i < lnw->nr_banks; ++i) {
+		struct lnw_bank *bank = &lnw->banks[i];
+
+		err = bgpio_remove(&bank->bgc);
+		if (err)
+			dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
+	}
 	iounmap(lnw->reg_base);
 	kfree(lnw);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.4.4


--WhfpMioaduB5tiZL--
