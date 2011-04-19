Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1DSQkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:40:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39075 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1DSQky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FO015gTfCP4oCiczY5gdMKNTaS6kbw1vduJqW2jodNHAvqz5urGTi+TDGGbb2i5poO
         yoxDnPn7lyTeSgk+CeE2nPPf5ApvEsJ58fiHCyPyHkp8pVr5kHRMYCfsiXhYEvmtkkti
         p8CM98ZzLTIDe6ZHvn+xM3lmOktgRTanRPoAE=
Date: Tue, 19 Apr 2011 20:40:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, arnd@arndb.de
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419164048.GA30346@oksana.dev.rtsoft.ru>
References: <20110419145303.111aead7@endymion.delvare>
 <BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
 <20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
 <BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
 <20110419165746.2857c56f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110419165746.2857c56f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 04:57:46PM +0100, Alan Cox wrote:
> > Doing a platform device is one solution that is pretty simple to
> > implement and I don't think adding child devices is at all a problem.
> > However, I'm not mandating that approach, and if you or Jean prefer to
> > abstract out the gpio accessors from basic_mmio_gpio(), then that is
> > fine by me.  The key issue it to avoid merging yet another, probably
> > subtly broken, set of GPIO accessor functions if it can at all be
> > avoided.
> 
> As is adding a set of subtly broken attempts to create device stacks that
> then get into funny sysfs and power management tangles. As well as being
> about 12K larger due to the need to suck in an extra module.
> 
> I can see the point of splitting out the accessors but if thats a module
> of its own then thats another 8K we don't need to waste on a few hundred
> bytes of utterly trivial code.

How about exporting some bus/device-type neutral probe function, like
we do in drivers/ata/pata_platform.c ?

That way bus-specific probe functions may call the generic routines.

And if you still want to save 8K, you could place the PCI bindings
inside the basic_mmio_gpio.

The patch below is against Linus tree + the following patches from
Jamie Iles:

      basic_mmio_gpio: remove runtime width/endianness evaluation
      basic_mmio_gpio: convert to platform_{get,set}_drvdata()
      basic_mmio_gpio: allow overriding number of gpio
      basic_mmio_gpio: request register regions
      basic_mmio_gpio: detect output method at probe time
      basic_mmio_gpio: support different input/output registers
      basic_mmio_gpio: support direction registers
      basic_mmio_gpio: convert to non-__raw* accessors

Not-yet-signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

and only compile tested so far, just an idea:

---
 drivers/gpio/Kconfig            |    6 ++
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/basic_mmio_gpio.c  |   98 ++++++++++++++++++++++----------------
 include/linux/basic_mmio_gpio.h |   14 ++++++
 4 files changed, 78 insertions(+), 41 deletions(-)

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
index b2ec45f..3deb1d7 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -294,10 +294,10 @@ static void __iomem *bgpio_request_and_map(struct device *dev,
 	return devm_ioremap(dev, res->start, resource_size(res));
 }
 
-static int bgpio_setup_accessors(struct platform_device *pdev,
-				 struct bgpio_chip *bgc)
+static int bgpio_setup_accessors(struct device *dev,
+				 struct bgpio_chip *bgc,
+				 bool be)
 {
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
 
 	switch (bgc->bits) {
 	case 8:
@@ -319,13 +319,11 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
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
@@ -352,18 +350,14 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
  *	- an input direction register (named "dirin") where a 1 bit indicates
  *	the GPIO is an input.
  */
-static int bgpio_setup_io(struct platform_device *pdev,
-			  struct bgpio_chip *bgc)
+static int bgpio_setup_io(struct device *dev,
+			  struct bgpio_chip *bgc,
+			  struct resource *res_dat,
+			  struct resource *res_set,
+			  struct resource *res_clr)
 {
-	struct resource *res_set;
-	struct resource *res_clr;
-	struct resource *res_dat;
 	resource_size_t dat_sz;
 
-	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
-	if (!res_dat)
-		return -EINVAL;
-
 	dat_sz = resource_size(res_dat);
 	if (!is_power_of_2(dat_sz))
 		return -EINVAL;
@@ -372,19 +366,17 @@ static int bgpio_setup_io(struct platform_device *pdev,
 	if (bgc->bits > BITS_PER_LONG)
 		return -EINVAL;
 
-	bgc->reg_dat = bgpio_request_and_map(&pdev->dev, res_dat);
+	bgc->reg_dat = bgpio_request_and_map(dev, res_dat);
 	if (!bgc->reg_dat)
 		return -ENOMEM;
 
-	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
-	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
 	if (res_set && res_clr) {
 		if (resource_size(res_set) != resource_size(res_clr) ||
 		    resource_size(res_set) != resource_size(res_dat))
 			return -EINVAL;
 
-		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
-		bgc->reg_clr = bgpio_request_and_map(&pdev->dev, res_clr);
+		bgc->reg_set = bgpio_request_and_map(dev, res_set);
+		bgc->reg_clr = bgpio_request_and_map(dev, res_clr);
 		if (!bgc->reg_set || !bgc->reg_clr)
 			return -ENOMEM;
 
@@ -393,7 +385,7 @@ static int bgpio_setup_io(struct platform_device *pdev,
 		if (resource_size(res_set) != resource_size(res_dat))
 			return -EINVAL;
 
-		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
+		bgc->reg_set = bgpio_request_and_map(dev, res_set);
 		if (!bgc->reg_set)
 			return -ENOMEM;
 
@@ -407,25 +399,21 @@ static int bgpio_setup_io(struct platform_device *pdev,
 	return 0;
 }
 
-static int bgpio_setup_direction(struct platform_device *pdev,
-				 struct bgpio_chip *bgc)
+static int bgpio_setup_direction(struct device *dev,
+				 struct bgpio_chip *bgc,
+				 struct resource *res_dirout,
+				 struct resource *res_dirin)
 {
-	struct resource *res_dirout;
-	struct resource *res_dirin;
-
-	res_dirout = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						  "dirout");
-	res_dirin = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirin");
 	if (res_dirout && res_dirin) {
 		return -EINVAL;
 	} else if (res_dirout) {
-		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirout);
+		bgc->reg_dir = bgpio_request_and_map(dev, res_dirout);
 		if (!bgc->reg_dir)
 			return -ENOMEM;
 		bgc->gc.direction_output = bgpio_dir_out;
 		bgc->gc.direction_input = bgpio_dir_in;
 	} else if (res_dirin) {
-		bgc->reg_dir = bgpio_request_and_map(&pdev->dev, res_dirin);
+		bgc->reg_dir = bgpio_request_and_map(dev, res_dirin);
 		if (!bgc->reg_dir)
 			return -ENOMEM;
 		bgc->gc.direction_output = bgpio_dir_out_inv;
@@ -438,9 +426,22 @@ static int bgpio_setup_direction(struct platform_device *pdev,
 	return 0;
 }
 
-static int __devinit bgpio_probe(struct platform_device *pdev)
+int __devexit __bgpio_remove(struct device *dev)
+{
+	struct bgpio_chip *bgc = dev_get_drvdata(dev);
+
+	return gpiochip_remove(&bgc->gc);
+}
+EXPORT_SYMBOL_GPL(__bgpio_remove);
+
+int __devinit __bgpio_probe(struct device *dev,
+			    struct resource *res_dat,
+			    struct resource *res_set,
+			    struct resource *res_clr,
+			    struct resource *res_dirout,
+			    struct resource *res_dirin,
+			    bool be)
 {
-	struct device *dev = &pdev->dev;
 	struct bgpio_pdata *pdata = dev_get_platdata(dev);
 	struct bgpio_chip *bgc;
 	int ret;
@@ -450,7 +451,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc)
 		return -ENOMEM;
 
-	ret = bgpio_setup_io(pdev, bgc);
+	ret = bgpio_setup_io(dev, bgc, res_dat, res_set, res_clr);
 	if (ret)
 		return ret;
 
@@ -463,12 +464,12 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 		bgc->gc.base = -1;
 	}
 
-	ret = bgpio_setup_accessors(pdev, bgc);
+	ret = bgpio_setup_accessors(dev, bgc, be);
 	if (ret)
 		return ret;
 
 	spin_lock_init(&bgc->lock);
-	ret = bgpio_setup_direction(pdev, bgc);
+	ret = bgpio_setup_direction(dev, bgc, res_dirout, res_dirin);
 	if (ret)
 		return ret;
 
@@ -478,7 +479,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-	platform_set_drvdata(pdev, bgc);
+	dev_set_drvdata(dev, bgc);
 
 	ret = gpiochip_add(&bgc->gc);
 	if (ret)
@@ -486,12 +487,25 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__bgpio_probe);
 
-static int __devexit bgpio_remove(struct platform_device *pdev)
+#ifdef CONFIG_GPIO_BASIC_MMIO
+
+static int __devinit bgpio_probe(struct platform_device *pdev)
 {
-	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
+	return __bgpio_probe(&pdev->dev,
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat"),
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "set"),
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr"),
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirout"),
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirin"),
+		!strcmp(platform_get_device_id(pdev)->name,
+			"basic-mmio-gpio-be"));
+}
 
-	return gpiochip_remove(&bgc->gc);
+static int __devexit bgpio_remove(struct platform_device *pdev)
+{
+	return __bgpio_remove(&pdev->dev);
 }
 
 static const struct platform_device_id bgpio_id_table[] = {
@@ -522,6 +536,8 @@ static void __exit bgpio_exit(void)
 }
 module_exit(bgpio_exit);
 
+#endif /* CONFIG_GPIO_BASIC_MMIO */
+
 MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index f23ec73..9277e59 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -13,9 +13,23 @@
 #ifndef __BASIC_MMIO_GPIO_H
 #define __BASIC_MMIO_GPIO_H
 
+#include <linux/types.h>
+
 struct bgpio_pdata {
 	int base;
 	int ngpio;
 };
 
+struct device;
+struct resource;
+
+int __devexit __bgpio_remove(struct device *dev);
+int __devinit __bgpio_probe(struct device *dev,
+			    struct resource *res_dat,
+			    struct resource *res_set,
+			    struct resource *res_clr,
+			    struct resource *res_dirout,
+			    struct resource *res_dirin,
+			    bool be);
+
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.4.1

