Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2A3VaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:30:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365Ab2A3V3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:29:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: wm831x: Convert to devm_regmap_init()
Date: Mon, 30 Jan 2012 21:29:45 +0000
Message-Id: <1327958986-16115-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
In-Reply-To: <1327958986-16115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327958986-16115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

OK to take this via regmap, it's another new feature?

 drivers/mfd/wm831x-core.c |   20 +++++++++-----------
 drivers/mfd/wm831x-i2c.c  |    2 +-
 drivers/mfd/wm831x-spi.c  |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index f5e54fa..838056c 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1631,7 +1631,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 	switch (ret) {
 	case 0x6204:
@@ -1640,20 +1640,20 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	default:
 		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
 		ret = -EINVAL;
-		goto err_regmap;
+		goto err;
 	}
 
 	ret = wm831x_reg_read(wm831x, WM831X_REVISION);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read revision: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 	rev = (ret & WM831X_PARENT_REV_MASK) >> WM831X_PARENT_REV_SHIFT;
 
 	ret = wm831x_reg_read(wm831x, WM831X_RESET_ID);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read device ID: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 
 	/* Some engineering samples do not have the ID set, rely on
@@ -1728,7 +1728,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
-		goto err_regmap;
+		goto err;
 	}
 
 	/* This will need revisiting in future but is OK for all
@@ -1742,7 +1742,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	ret = wm831x_reg_read(wm831x, WM831X_SECURITY_KEY);
 	if (ret < 0) {
 		dev_err(wm831x->dev, "Failed to read security key: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 	if (ret != 0) {
 		dev_warn(wm831x->dev, "Security key had non-zero value %x\n",
@@ -1755,7 +1755,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		ret = pdata->pre_init(wm831x);
 		if (ret != 0) {
 			dev_err(wm831x->dev, "pre_init() failed: %d\n", ret);
-			goto err_regmap;
+			goto err;
 		}
 	}
 
@@ -1778,7 +1778,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	ret = wm831x_irq_init(wm831x, irq);
 	if (ret != 0)
-		goto err_regmap;
+		goto err;
 
 	wm831x_auxadc_init(wm831x);
 
@@ -1874,9 +1874,8 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 err_irq:
 	wm831x_irq_exit(wm831x);
-err_regmap:
+err:
 	mfd_remove_devices(wm831x->dev);
-	regmap_exit(wm831x->regmap);
 	return ret;
 }
 
@@ -1887,7 +1886,6 @@ void wm831x_device_exit(struct wm831x *wm831x)
 	if (wm831x->irq_base)
 		free_irq(wm831x->irq_base + WM831X_IRQ_AUXADC_DATA, wm831x);
 	wm831x_irq_exit(wm831x);
-	regmap_exit(wm831x->regmap);
 }
 
 int wm831x_device_suspend(struct wm831x *wm831x)
diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index cb15609..2b29cae 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -37,7 +37,7 @@ static int wm831x_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, wm831x);
 	wm831x->dev = &i2c->dev;
 
-	wm831x->regmap = regmap_init_i2c(i2c, &wm831x_regmap_config);
+	wm831x->regmap = devm_regmap_init_i2c(i2c, &wm831x_regmap_config);
 	if (IS_ERR(wm831x->regmap)) {
 		ret = PTR_ERR(wm831x->regmap);
 		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 62ef325..745c879 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -40,7 +40,7 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, wm831x);
 	wm831x->dev = &spi->dev;
 
-	wm831x->regmap = regmap_init_spi(spi, &wm831x_regmap_config);
+	wm831x->regmap = devm_regmap_init_spi(spi, &wm831x_regmap_config);
 	if (IS_ERR(wm831x->regmap)) {
 		ret = PTR_ERR(wm831x->regmap);
 		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
-- 
1.7.9.rc1

