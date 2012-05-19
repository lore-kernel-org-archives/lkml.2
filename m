Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab2ESI4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 04:56:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43287 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2ESI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 04:56:28 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ryan Mallon <rmallon@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>, LW@KARO-electronics.de,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2] gpio/generic: initialize basic_mmio_gpio shadow variables properly
Date: Sat, 19 May 2012 16:55:51 +0800
Message-Id: <1337417751-24848-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
missing initialization of basic_mmio_gpio shadow variables) manged to
fix in gpio-mxc driver, so that other platform specific drivers do not
suffer from the same problem over and over again.

Changes since v1:
* Turn the last parameter "bool big_endian" into "unsigned long flags"
  and give those really quirky hardwares a chance to tell that reg_set
  and reg_dir are unreadable.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-ep93xx.c      |    2 +-
 drivers/gpio/gpio-generic.c     |    9 +++++++--
 drivers/gpio/gpio-mxc.c         |    2 +-
 drivers/gpio/gpio-mxs.c         |    2 +-
 drivers/gpio/gpio-sodaville.c   |    2 +-
 include/linux/basic_mmio_gpio.h |    6 +++++-
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 776b772..9fe5b8fe 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -325,7 +325,7 @@ static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 	void __iomem *dir =  mmio_base + bank->dir;
 	int err;
 
-	err = bgpio_init(bgc, dev, 1, data, NULL, NULL, dir, NULL, false);
+	err = bgpio_init(bgc, dev, 1, data, NULL, NULL, dir, NULL, 0);
 	if (err)
 		return err;
 
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index e38dd0c..51912f7 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -364,7 +364,7 @@ EXPORT_SYMBOL_GPL(bgpio_remove);
 int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 	       unsigned long sz, void __iomem *dat, void __iomem *set,
 	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
-	       bool big_endian)
+	       unsigned long flags)
 {
 	int ret;
 
@@ -385,7 +385,7 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = bgpio_setup_accessors(dev, bgc, big_endian);
+	ret = bgpio_setup_accessors(dev, bgc, flags & BGPIOF_BIG_ENDIAN);
 	if (ret)
 		return ret;
 
@@ -394,6 +394,11 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 		return ret;
 
 	bgc->data = bgc->read_reg(bgc->reg_dat);
+	if (bgc->gc.set == bgpio_set_set &&
+			!(flags & BGPIOF_UNREADABLE_REG_SET))
+		bgc->data = bgc->read_reg(bgc->reg_set);
+	if (bgc->reg_dir && !(flags & BGPIOF_UNREADABLE_REG_DIR))
+		bgc->dir = bgc->read_reg(bgc->reg_dir);
 
 	return ret;
 }
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index e791476..c337143 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -417,7 +417,7 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	err = bgpio_init(&port->bgc, &pdev->dev, 4,
 			 port->base + GPIO_PSR,
 			 port->base + GPIO_DR, NULL,
-			 port->base + GPIO_GDIR, NULL, false);
+			 port->base + GPIO_GDIR, NULL, 0);
 	if (err)
 		goto out_iounmap;
 
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 429228b..39e4956 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -285,7 +285,7 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 	err = bgpio_init(&port->bgc, &pdev->dev, 4,
 			 port->base + PINCTRL_DIN(port),
 			 port->base + PINCTRL_DOUT(port), NULL,
-			 port->base + PINCTRL_DOE(port), NULL, false);
+			 port->base + PINCTRL_DOE(port), NULL, 0);
 	if (err)
 		return err;
 
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
index 031e5d2..38da23d 100644
--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -224,7 +224,7 @@ static int __devinit sdv_gpio_probe(struct pci_dev *pdev,
 
 	ret = bgpio_init(&sd->bgpio, &pdev->dev, 4,
 			sd->gpio_pub_base + GPINR, sd->gpio_pub_base + GPOUTR,
-			NULL, sd->gpio_pub_base + GPOER, NULL, false);
+			NULL, sd->gpio_pub_base + GPOER, NULL, 0);
 	if (ret)
 		goto unmap;
 	sd->bgpio.gc.ngpio = SDV_NUM_PUB_GPIOS;
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index feb91219..1c504ca 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -67,6 +67,10 @@ int bgpio_remove(struct bgpio_chip *bgc);
 int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 	       unsigned long sz, void __iomem *dat, void __iomem *set,
 	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
-	       bool big_endian);
+	       unsigned long flags);
+
+#define BGPIOF_BIG_ENDIAN		BIT(0)
+#define BGPIOF_UNREADABLE_REG_SET	BIT(1) /* reg_set is unreadable */
+#define BGPIOF_UNREADABLE_REG_DIR	BIT(2) /* reg_dir is unreadable */
 
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.5.4

