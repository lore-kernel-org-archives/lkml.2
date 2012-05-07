Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2EGJEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:04:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60734 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974Ab2EGJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/7] mfd: wm8350: Convert physical I/O to regmap API
Date: Mon,  7 May 2012 10:03:21 +0100
Message-Id: <1336381403-7840-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver still uses a custom cache implementation but the underlying
physical I/O is now done using the regmap API, saving some code and
avoiding allocating enormous scratch arrays on the stack.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   31 ++++++++---------------
 drivers/mfd/wm8350-i2c.c        |   53 +++++++++++----------------------------
 include/linux/mfd/wm8350/core.h |    9 ++-----
 3 files changed, 27 insertions(+), 66 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index dd1caaa..8a9b11c 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/regmap.h>
 #include <linux/workqueue.h>
 
 #include <linux/mfd/wm8350/core.h>
@@ -74,7 +75,7 @@ static int wm8350_phys_read(struct wm8350 *wm8350, u8 reg, int num_regs,
 	int bytes = num_regs * 2;
 
 	dev_dbg(wm8350->dev, "volatile read\n");
-	ret = wm8350->read_dev(wm8350, reg, bytes, (char *)dest);
+	ret = regmap_raw_read(wm8350->regmap, reg, dest, bytes);
 
 	for (i = reg; i < reg + num_regs; i++) {
 		/* Cache is CPU endian */
@@ -96,9 +97,6 @@ static int wm8350_read(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *dest)
 	int ret = 0;
 	int bytes = num_regs * 2;
 
-	if (wm8350->read_dev == NULL)
-		return -ENODEV;
-
 	if ((reg + num_regs - 1) > WM8350_MAX_REGISTER) {
 		dev_err(wm8350->dev, "invalid reg %x\n",
 			reg + num_regs - 1);
@@ -149,9 +147,6 @@ static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
 	int end = reg + num_regs;
 	int bytes = num_regs * 2;
 
-	if (wm8350->write_dev == NULL)
-		return -ENODEV;
-
 	if ((reg + num_regs - 1) > WM8350_MAX_REGISTER) {
 		dev_err(wm8350->dev, "invalid reg %x\n",
 			reg + num_regs - 1);
@@ -182,7 +177,7 @@ static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
 	}
 
 	/* Actually write it out */
-	return wm8350->write_dev(wm8350, reg, bytes, (char *)src);
+	return regmap_raw_write(wm8350->regmap, reg, src, bytes);
 }
 
 /*
@@ -515,9 +510,8 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 	 * a PMIC so the device many not be in a virgin state and we
 	 * can't rely on the silicon values.
 	 */
-	ret = wm8350->read_dev(wm8350, 0,
-			       sizeof(u16) * (WM8350_MAX_REGISTER + 1),
-			       wm8350->reg_cache);
+	ret = regmap_raw_read(wm8350->regmap, 0, wm8350->reg_cache,
+			      sizeof(u16) * (WM8350_MAX_REGISTER + 1));
 	if (ret < 0) {
 		dev_err(wm8350->dev,
 			"failed to read initial cache values\n");
@@ -570,35 +564,30 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
 	int ret;
-	u16 id1, id2, mask_rev;
-	u16 cust_id, mode, chip_rev;
+	unsigned int id1, id2, mask_rev;
+	unsigned int cust_id, mode, chip_rev;
 
 	dev_set_drvdata(wm8350->dev, wm8350);
 
 	/* get WM8350 revision and config mode */
-	ret = wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
+	ret = regmap_read(wm8350->regmap, WM8350_RESET_ID, &id1);
 	if (ret != 0) {
 		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
 		goto err;
 	}
 
-	ret = wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
+	ret = regmap_read(wm8350->regmap, WM8350_ID, &id2);
 	if (ret != 0) {
 		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
 		goto err;
 	}
 
-	ret = wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev),
-			       &mask_rev);
+	ret = regmap_read(wm8350->regmap, WM8350_REVISION, &mask_rev);
 	if (ret != 0) {
 		dev_err(wm8350->dev, "Failed to read revision: %d\n", ret);
 		goto err;
 	}
 
-	id1 = be16_to_cpu(id1);
-	id2 = be16_to_cpu(id2);
-	mask_rev = be16_to_cpu(mask_rev);
-
 	if (id1 != 0x6143) {
 		dev_err(wm8350->dev,
 			"Device with ID %x is not a WM8350\n", id1);
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index d955faa..271589f 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -15,47 +15,18 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/wm8350/core.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 
-static int wm8350_i2c_read_device(struct wm8350 *wm8350, char reg,
-				  int bytes, void *dest)
-{
-	int ret;
-
-	ret = i2c_master_send(wm8350->i2c_client, &reg, 1);
-	if (ret < 0)
-		return ret;
-	ret = i2c_master_recv(wm8350->i2c_client, dest, bytes);
-	if (ret < 0)
-		return ret;
-	if (ret != bytes)
-		return -EIO;
-	return 0;
-}
-
-static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
-				   int bytes, void *src)
-{
-	/* we add 1 byte for device register */
-	u8 msg[(WM8350_MAX_REGISTER << 1) + 1];
-	int ret;
-
-	if (bytes > ((WM8350_MAX_REGISTER << 1) + 1))
-		return -EINVAL;
-
-	msg[0] = reg;
-	memcpy(&msg[1], src, bytes);
-	ret = i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
-	if (ret < 0)
-		return ret;
-	if (ret != bytes + 1)
-		return -EIO;
-	return 0;
-}
+static const struct regmap_config wm8350_regmap = {
+	.reg_bits = 8,
+	.val_bits = 16,
+};
 
 static int wm8350_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
@@ -67,11 +38,16 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	if (wm8350 == NULL)
 		return -ENOMEM;
 
+	wm8350->regmap = devm_regmap_init_i2c(i2c, &wm8350_regmap);
+	if (IS_ERR(wm8350->regmap)) {
+		ret = PTR_ERR(wm8350->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
 	i2c_set_clientdata(i2c, wm8350);
 	wm8350->dev = &i2c->dev;
-	wm8350->i2c_client = i2c;
-	wm8350->read_dev = wm8350_i2c_read_device;
-	wm8350->write_dev = wm8350_i2c_write_device;
 
 	ret = wm8350_device_init(wm8350, i2c->irq, i2c->dev.platform_data);
 	if (ret < 0)
@@ -80,6 +56,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err:
+	regmap_exit(wm8350->regmap);
 	return ret;
 }
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 98fcc97..9192b64 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -602,6 +602,7 @@ extern const u16 wm8352_mode2_defaults[];
 extern const u16 wm8352_mode3_defaults[];
 
 struct wm8350;
+struct regmap;
 
 struct wm8350_hwmon {
 	struct platform_device *pdev;
@@ -612,13 +613,7 @@ struct wm8350 {
 	struct device *dev;
 
 	/* device IO */
-	union {
-		struct i2c_client *i2c_client;
-		struct spi_device *spi_device;
-	};
-	int (*read_dev)(struct wm8350 *wm8350, char reg, int size, void *dest);
-	int (*write_dev)(struct wm8350 *wm8350, char reg, int size,
-			 void *src);
+	struct regmap *regmap;
 	u16 *reg_cache;
 
 	struct mutex auxadc_mutex;
-- 
1.7.10

