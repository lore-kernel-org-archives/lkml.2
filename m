Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1GEFLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:11:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1GEFLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:11:22 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Kevin Hilman <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [RFC/RFT 1/2] gpio/basic_mmio: add support for enable register
Date: Tue, 5 Jul 2011 10:40:59 +0530
Message-ID: <83915224c24e43224272b1bf570cddb9545279a6.1309840042.git.nsekhar@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <cover.1309840042.git.nsekhar@ti.com>
References: <cover.1309840042.git.nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some GPIO controllers have an enable register
which needs to be written to before a GPIO
can be used.

Add support for enabling the GPIO. At this
time inverted logic for enabling the GPIO
is not supported. This can be done by adding
a disable register as and when a controller
with this comes along.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/gpio/gpio-ep93xx.c      |    2 +-
 drivers/gpio/gpio-generic.c     |   45 ++++++++++++++++++++++++++++++++++++++-
 drivers/gpio/gpio-mxc.c         |    2 +-
 drivers/gpio/gpio-mxs.c         |    2 +-
 include/linux/basic_mmio_gpio.h |    5 ++++
 5 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 3bfd341..8ed498a 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -314,7 +314,7 @@ static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 	void __iomem *dir =  mmio_base + bank->dir;
 	int err;
 
-	err = bgpio_init(bgc, dev, 1, data, NULL, NULL, dir, NULL, false);
+	err = bgpio_init(bgc, dev, 1, data, NULL, NULL, dir, NULL, NULL, false);
 	if (err)
 		return err;
 
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 231714d..cf7d596 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -247,6 +247,34 @@ static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
+static int bgpio_request(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->en |= bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_en, bgc->en);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
+static void bgpio_free(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	bgc->en &= ~bgc->pin2mask(bgc, gpio);
+	bgc->write_reg(bgc->reg_en, bgc->en);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
 static int bgpio_setup_accessors(struct device *dev,
 				 struct bgpio_chip *bgc,
 				 bool be)
@@ -302,6 +330,10 @@ static int bgpio_setup_accessors(struct device *dev,
  *	indicates the GPIO is an output.
  *	- an input direction register (named "dirin") where a 1 bit indicates
  *	the GPIO is an input.
+ *
+ * To enable and disable a GPIO at the time of requesting it there is a
+ * a simple enable register supported where a 1 bit indicates that the GPIO
+ * is enabled.
  */
 static int bgpio_setup_io(struct bgpio_chip *bgc,
 			  void __iomem *dat,
@@ -369,6 +401,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 			 void __iomem *clr,
 			 void __iomem *dirout,
 			 void __iomem *dirin,
+			 void __iomem *en,
 			 bool big_endian)
 {
 	int ret;
@@ -398,6 +431,11 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 	if (ret)
 		return ret;
 
+	if (en) {
+		bgc->gc.request = bgpio_request;
+		bgc->gc.free = bgpio_free;
+	}
+
 	bgc->data = bgc->read_reg(bgc->reg_dat);
 
 	return ret;
@@ -453,6 +491,7 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
 	void __iomem *clr;
 	void __iomem *dirout;
 	void __iomem *dirin;
+	void __iomem *en;
 	unsigned long sz;
 	bool be;
 	int err;
@@ -485,13 +524,17 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	en = bgpio_map(pdev, "en", sz, &err);
+	if (err)
+		return err;
+
 	be = !strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be");
 
 	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
 	if (!bgc)
 		return -ENOMEM;
 
-	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
+	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, en, be);
 	if (err)
 		return err;
 
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 2f6a81b..5ce98c6 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -300,7 +300,7 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	err = bgpio_init(&port->bgc, &pdev->dev, 4,
 			 port->base + GPIO_PSR,
 			 port->base + GPIO_DR, NULL,
-			 port->base + GPIO_GDIR, NULL, false);
+			 port->base + GPIO_GDIR, NULL, NULL, false);
 	if (err)
 		goto out_iounmap;
 
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index d8cafba..f3b78bf 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -241,7 +241,7 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 	err = bgpio_init(&port->bgc, &pdev->dev, 4,
 			 port->base + PINCTRL_DIN(port->id),
 			 port->base + PINCTRL_DOUT(port->id), NULL,
-			 port->base + PINCTRL_DOE(port->id), NULL, false);
+			 port->base + PINCTRL_DOE(port->id), NULL, NULL, false);
 	if (err)
 		goto out_iounmap;
 
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index 98999cf..fc2e1cc 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -35,6 +35,7 @@ struct bgpio_chip {
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
 	void __iomem *reg_dir;
+	void __iomem *reg_en;
 
 	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
@@ -56,6 +57,9 @@ struct bgpio_chip {
 
 	/* Shadowed direction registers to clear/set direction safely. */
 	unsigned long dir;
+
+	/* Shadowed enable register to enable/disable safely. */
+	unsigned long en;
 };
 
 static inline struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
@@ -72,6 +76,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 			 void __iomem *clr,
 			 void __iomem *dirout,
 			 void __iomem *dirin,
+			 void __iomem *en,
 			 bool big_endian);
 
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.3.2

