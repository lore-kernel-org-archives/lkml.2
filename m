Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1DSUal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:30:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43869 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1DSUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uCDs97ETQXIEstigECJSNrM8mep56XIQQcLGy3dOtaqXC7fJC/I1c48vd9l5HocW8f
         HEqX3paLU0DSy2aGcpv+NDk7hdCVF1i4ON2AZbKteY0HkCGmneMA0qgA/ZNdu5JY9oOU
         hPqRC+ZECNqNtXW8EAw0DEImfHKFnp65H8zPQ=
Date: Wed, 20 Apr 2011 00:30:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, arnd@arndb.de
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419203031.GA6494@oksana.dev.rtsoft.ru>
References: <20110419145303.111aead7@endymion.delvare>
 <BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
 <20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
 <BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
 <20110419165746.2857c56f@lxorguk.ukuu.org.uk>
 <20110419164048.GA30346@oksana.dev.rtsoft.ru>
 <20110419180829.56daccd0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110419180829.56daccd0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 06:08:29PM +0100, Alan Cox wrote:
> > How about exporting some bus/device-type neutral probe function, like
> > we do in drivers/ata/pata_platform.c ?
> 
> Not sure you want to be using resources as the basic currency, nor do you
> want your generic code doing the request_region stuff. That was a nasty
> mistake we made in the IDE code.
> 
> Maybe the platform code should do that bit, but the generic stuff not - in
> the PCI case the caller will have done pci_request_* itself and chances
> are several of the resources are the same pci device resource and
> different offsets so doing request_resource on them will blow up.

Oh, right. How about this:

int __devinit bgpio_probe(struct device *dev,
                          unsigned long sz,
                          void __iomem *dat,
                          void __iomem *set,
                          void __iomem *clr,
                          void __iomem *dirout,
                          void __iomem *dirin,
                          bool big_endian);

I.e. PCI driver can now map the whole area with a single ioremap(),
and then call bgpio_probe(), which will provide accessors and
common MMIO GPIO registration stuff.

Not-yet-signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/basic_mmio_gpio.c  |  241 ++++++++++++++++++++++++---------------
 include/linux/basic_mmio_gpio.h |   15 +++
 4 files changed, 171 insertions(+), 92 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..88dd650 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,8 +70,14 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO expanders:"
 
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
index 3351cf8..1abf916 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index b2ec45f..947734a 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -284,20 +284,10 @@ static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static void __iomem *bgpio_request_and_map(struct device *dev,
-					   struct resource *res)
+static int bgpio_setup_accessors(struct device *dev,
+				 struct bgpio_chip *bgc,
+				 bool be)
 {
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				     res->name ?: "mmio_gpio"))
-		return NULL;
-
-	return devm_ioremap(dev, res->start, resource_size(res));
-}
-
-static int bgpio_setup_accessors(struct platform_device *pdev,
-				 struct bgpio_chip *bgc)
-{
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
 
 	switch (bgc->bits) {
 	case 8:
@@ -319,13 +309,11 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
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
@@ -352,51 +340,22 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
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
-
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
@@ -407,27 +366,18 @@ static int bgpio_setup_io(struct platform_device *pdev,
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
@@ -438,9 +388,23 @@ static int bgpio_setup_direction(struct platform_device *pdev,
 	return 0;
 }
 
-static int __devinit bgpio_probe(struct platform_device *pdev)
+int __devexit bgpio_remove(struct device *dev)
+{
+	struct bgpio_chip *bgc = dev_get_drvdata(dev);
+
+	return gpiochip_remove(&bgc->gc);
+}
+EXPORT_SYMBOL_GPL(bgpio_remove);
+
+int __devinit bgpio_probe(struct device *dev,
+			  unsigned long sz,
+			  void __iomem *dat,
+			  void __iomem *set,
+			  void __iomem *clr,
+			  void __iomem *dirout,
+			  void __iomem *dirin,
+			  bool big_endian)
 {
-	struct device *dev = &pdev->dev;
 	struct bgpio_pdata *pdata = dev_get_platdata(dev);
 	struct bgpio_chip *bgc;
 	int ret;
@@ -450,9 +414,16 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc)
 		return -ENOMEM;
 
-	ret = bgpio_setup_io(pdev, bgc);
-	if (ret)
-		return ret;
+	if (!is_power_of_2(sz))
+		return -EINVAL;
+
+	bgc->bits = sz * 8;
+	if (bgc->bits > BITS_PER_LONG)
+		return -EINVAL;
+
+	spin_lock_init(&bgc->lock);
+	bgc->gc.dev = dev;
+	bgc->gc.label = dev_name(dev);
 
 	ngpio = bgc->bits;
 	if (pdata) {
@@ -463,22 +434,23 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 		bgc->gc.base = -1;
 	}
 
-	ret = bgpio_setup_accessors(pdev, bgc);
+	bgc->gc.ngpio = ngpio;
+
+	ret = bgpio_setup_io(bgc, dat, set, clr);
 	if (ret)
 		return ret;
 
-	spin_lock_init(&bgc->lock);
-	ret = bgpio_setup_direction(pdev, bgc);
+	ret = bgpio_setup_accessors(dev, bgc, big_endian);
 	if (ret)
 		return ret;
 
-	bgc->data = bgc->read_reg(bgc->reg_dat);
+	ret = bgpio_setup_direction(bgc, dirout, dirin);
+	if (ret)
+		return ret;
 
-	bgc->gc.ngpio = ngpio;
-	bgc->gc.dev = dev;
-	bgc->gc.label = dev_name(dev);
+	bgc->data = bgc->read_reg(bgc->reg_dat);
 
-	platform_set_drvdata(pdev, bgc);
+	dev_set_drvdata(dev, bgc);
 
 	ret = gpiochip_add(&bgc->gc);
 	if (ret)
@@ -486,12 +458,95 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(bgpio_probe);
 
-static int __devexit bgpio_remove(struct platform_device *pdev)
+#ifdef CONFIG_GPIO_BASIC_MMIO
+
+static void __iomem *bgpio_map(struct platform_device *pdev,
+			       const char *name,
+			       resource_size_t sane_sz,
+			       int *err)
 {
-	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct resource *r;
+	resource_size_t start;
+	resource_size_t sz;
+	void __iomem *ret;
 
-	return gpiochip_remove(&bgc->gc);
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
+
+	return ret;
+}
+
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
+	return bgpio_probe(dev, sz, dat, set, clr, dirout, dirin, be);
+}
+
+static int __devexit bgpio_pdev_remove(struct platform_device *pdev)
+{
+	return bgpio_remove(&pdev->dev);
 }
 
 static const struct platform_device_id bgpio_id_table[] = {
@@ -506,8 +561,8 @@ static struct platform_driver bgpio_driver = {
 		.name = "basic-mmio-gpio",
 	},
 	.id_table = bgpio_id_table,
-	.probe = bgpio_probe,
-	.remove = __devexit_p(bgpio_remove),
+	.probe = bgpio_pdev_probe,
+	.remove = __devexit_p(bgpio_pdev_remove),
 };
 
 static int __init bgpio_init(void)
@@ -522,6 +577,8 @@ static void __exit bgpio_exit(void)
 }
 module_exit(bgpio_exit);
 
+#endif /* CONFIG_GPIO_BASIC_MMIO */
+
 MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index f23ec73..f3a27e4 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -13,9 +13,24 @@
 #ifndef __BASIC_MMIO_GPIO_H
 #define __BASIC_MMIO_GPIO_H
 
+#include <linux/types.h>
+#include <linux/compiler.h>
+
 struct bgpio_pdata {
 	int base;
 	int ngpio;
 };
 
+struct device;
+
+int __devexit bgpio_remove(struct device *dev);
+int __devinit bgpio_probe(struct device *dev,
+			  unsigned long sz,
+			  void __iomem *dat,
+			  void __iomem *set,
+			  void __iomem *clr,
+			  void __iomem *dirout,
+			  void __iomem *dirin,
+			  bool big_endian);
+
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.4.1

