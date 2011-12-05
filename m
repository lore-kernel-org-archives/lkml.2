Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1LELpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:45:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37653 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab1LELpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:45:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Initialise WM8994 register cache after reading chip ID registers
Date: Mon,  5 Dec 2011 11:45:00 +0000
Message-Id: <1323085500-27462-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323085500-27462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1323085500-27462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different devices handled by the WM8994 can be distinguished using
their ID registers so we don't need to rely on the user having registered
the device correctly. Instead do the initial regmap setup with a minimal
configuration only supporting physical I/O and then configure the cache
once we have identified the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This depends on all the other 8994 regmap stuff - I'll add it to the
relevant branches.

 drivers/mfd/wm8994-core.c   |   41 ++++++++++++++++++++++++-----------------
 drivers/mfd/wm8994-regmap.c |    5 +++++
 drivers/mfd/wm8994.h        |    1 +
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 4549999..d1c73f8 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -349,6 +349,7 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 {
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	struct regmap_config *regmap_config;
 	const char *devname;
 	int ret, i;
 	int pulls = 0;
@@ -487,6 +488,28 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	dev_info(wm8994->dev, "%s revision %c\n", devname,
 		 'A' + wm8994->revision);
 
+	switch (wm8994->type) {
+	case WM1811:
+		regmap_config = &wm1811_regmap_config;
+		break;
+	case WM8994:
+		regmap_config = &wm8994_regmap_config;
+		break;
+	case WM8958:
+		regmap_config = &wm8958_regmap_config;
+		break;
+	default:
+		dev_err(wm8994->dev, "Unknown device type %d\n", wm8994->type);
+		return -EINVAL;
+	}
+
+	ret = regmap_reinit_cache(wm8994->regmap, regmap_config);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to reinit register cache: %d\n",
+			ret);
+		return ret;
+	}
+
 	if (pdata) {
 		wm8994->irq_base = pdata->irq_base;
 		wm8994->gpio_base = pdata->gpio_base;
@@ -578,7 +601,6 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8994 *wm8994;
-	struct regmap_config *regmap_config;
 	int ret;
 
 	wm8994 = devm_kzalloc(&i2c->dev, sizeof(struct wm8994), GFP_KERNEL);
@@ -590,22 +612,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	wm8994->irq = i2c->irq;
 	wm8994->type = id->driver_data;
 
-	switch (wm8994->type) {
-	case WM1811:
-		regmap_config = &wm1811_regmap_config;
-		break;
-	case WM8994:
-		regmap_config = &wm8994_regmap_config;
-		break;
-	case WM8958:
-		regmap_config = &wm8958_regmap_config;
-		break;
-	default:
-		dev_err(wm8994->dev, "Unknown device type %d\n", wm8994->type);
-		return -EINVAL;
-	}
-
-	wm8994->regmap = regmap_init_i2c(i2c, regmap_config);
+	wm8994->regmap = regmap_init_i2c(i2c, &wm8994_base_regmap_config);
 	if (IS_ERR(wm8994->regmap)) {
 		ret = PTR_ERR(wm8994->regmap);
 		dev_err(wm8994->dev, "Failed to allocate register map: %d\n",
diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 2fdefa124..c598ae6 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1231,3 +1231,8 @@ struct regmap_config wm8958_regmap_config = {
 	.volatile_reg = wm8958_volatile_register,
 	.readable_reg = wm8958_readable_register,
 };
+
+struct regmap_config wm8994_base_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+};
diff --git a/drivers/mfd/wm8994.h b/drivers/mfd/wm8994.h
index bf2bdc1..6f39a84 100644
--- a/drivers/mfd/wm8994.h
+++ b/drivers/mfd/wm8994.h
@@ -20,5 +20,6 @@
 extern struct regmap_config wm1811_regmap_config;
 extern struct regmap_config wm8994_regmap_config;
 extern struct regmap_config wm8958_regmap_config;
+extern struct regmap_config wm8994_base_regmap_config;
 
 #endif
-- 
1.7.7.3

