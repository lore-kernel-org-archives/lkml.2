Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1HIOfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36541 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751239Ab1HIOfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert WM8400 to regmap API
Date: Tue,  9 Aug 2011 16:34:29 +0900
Message-Id: <1312875269-26565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This one also depends on regmap stuff in -next.

 drivers/mfd/wm8400-core.c          |  106 ++++++++++--------------------------
 include/linux/mfd/wm8400-private.h |    7 +--
 2 files changed, 32 insertions(+), 81 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index b49b91e..36de271 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -13,11 +13,13 @@
  */
 
 #include <linux/bug.h>
+#include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/wm8400-private.h>
 #include <linux/mfd/wm8400-audio.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 
@@ -124,14 +126,9 @@ static int wm8400_read(struct wm8400 *wm8400, u8 reg, int num_regs, u16 *dest)
 	/* If there are any volatile reads then read back the entire block */
 	for (i = reg; i < reg + num_regs; i++)
 		if (reg_data[i].vol) {
-			ret = wm8400->read_dev(wm8400->io_data, reg,
-					       num_regs, dest);
-			if (ret != 0)
-				return ret;
-			for (i = 0; i < num_regs; i++)
-				dest[i] = be16_to_cpu(dest[i]);
-
-			return 0;
+			ret = regmap_bulk_read(wm8400->regmap, reg, dest,
+					       num_regs);
+			return ret;
 		}
 
 	/* Otherwise use the cache */
@@ -150,14 +147,11 @@ static int wm8400_write(struct wm8400 *wm8400, u8 reg, int num_regs,
 	for (i = 0; i < num_regs; i++) {
 		BUG_ON(!reg_data[reg + i].writable);
 		wm8400->reg_cache[reg + i] = src[i];
-		src[i] = cpu_to_be16(src[i]);
+		ret = regmap_write(wm8400->regmap, reg, src[i]);
+		if (ret != 0)
+			return ret;
 	}
 
-	/* Do the actual I/O */
-	ret = wm8400->write_dev(wm8400->io_data, reg, num_regs, src);
-	if (ret != 0)
-		return -EIO;
-
 	return 0;
 }
 
@@ -271,14 +265,14 @@ static int wm8400_init(struct wm8400 *wm8400,
 	dev_set_drvdata(wm8400->dev, wm8400);
 
 	/* Check that this is actually a WM8400 */
-	ret = wm8400->read_dev(wm8400->io_data, WM8400_RESET_ID, 1, &reg);
+	ret = regmap_read(wm8400->regmap, WM8400_RESET_ID, &i);
 	if (ret != 0) {
 		dev_err(wm8400->dev, "Chip ID register read failed\n");
 		return -EIO;
 	}
-	if (be16_to_cpu(reg) != reg_data[WM8400_RESET_ID].default_val) {
+	if (i != reg_data[WM8400_RESET_ID].default_val) {
 		dev_err(wm8400->dev, "Device is not a WM8400, ID is %x\n",
-			be16_to_cpu(reg));
+			reg);
 		return -ENODEV;
 	}
 
@@ -286,9 +280,8 @@ static int wm8400_init(struct wm8400 *wm8400,
 	 * is a PMIC we can't reset it safely so initialise the register
 	 * cache from the hardware.
 	 */
-	ret = wm8400->read_dev(wm8400->io_data, 0,
-			       ARRAY_SIZE(wm8400->reg_cache),
-			       wm8400->reg_cache);
+	ret = regmap_raw_read(wm8400->regmap, 0, wm8400->reg_cache,
+			      ARRAY_SIZE(wm8400->reg_cache));
 	if (ret != 0) {
 		dev_err(wm8400->dev, "Register cache read failed\n");
 		return -EIO;
@@ -338,60 +331,13 @@ static void wm8400_release(struct wm8400 *wm8400)
 	mfd_remove_devices(wm8400->dev);
 }
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-static int wm8400_i2c_read(void *io_data, char reg, int count, u16 *dest)
-{
-	struct i2c_client *i2c = io_data;
-	struct i2c_msg xfer[2];
-	int ret;
-
-	/* Write register */
-	xfer[0].addr = i2c->addr;
-	xfer[0].flags = 0;
-	xfer[0].len = 1;
-	xfer[0].buf = &reg;
-
-	/* Read data */
-	xfer[1].addr = i2c->addr;
-	xfer[1].flags = I2C_M_RD;
-	xfer[1].len = count * sizeof(u16);
-	xfer[1].buf = (u8 *)dest;
-
-	ret = i2c_transfer(i2c->adapter, xfer, 2);
-	if (ret == 2)
-		ret = 0;
-	else if (ret >= 0)
-		ret = -EIO;
-
-	return ret;
-}
-
-static int wm8400_i2c_write(void *io_data, char reg, int count, const u16 *src)
-{
-	struct i2c_client *i2c = io_data;
-	u8 *msg;
-	int ret;
-
-	/* We add 1 byte for device register - ideally I2C would gather. */
-	msg = kmalloc((count * sizeof(u16)) + 1, GFP_KERNEL);
-	if (msg == NULL)
-		return -ENOMEM;
-
-	msg[0] = reg;
-	memcpy(&msg[1], src, count * sizeof(u16));
-
-	ret = i2c_master_send(i2c, msg, (count * sizeof(u16)) + 1);
-
-	if (ret == (count * 2) + 1)
-		ret = 0;
-	else if (ret >= 0)
-		ret = -EIO;
-
-	kfree(msg);
-
-	return ret;
-}
+static const struct regmap_config wm8400_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 16,
+	.max_register = WM8400_REGISTER_COUNT - 1,
+};
 
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 static int wm8400_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -404,18 +350,23 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 		goto err;
 	}
 
-	wm8400->io_data = i2c;
-	wm8400->read_dev = wm8400_i2c_read;
-	wm8400->write_dev = wm8400_i2c_write;
+	wm8400->regmap = regmap_init_i2c(i2c, &wm8400_regmap_config);
+	if (IS_ERR(wm8400->regmap)) {
+		ret = PTR_ERR(wm8400->regmap);
+		goto struct_err;
+	}
+
 	wm8400->dev = &i2c->dev;
 	i2c_set_clientdata(i2c, wm8400);
 
 	ret = wm8400_init(wm8400, i2c->dev.platform_data);
 	if (ret != 0)
-		goto struct_err;
+		goto map_err;
 
 	return 0;
 
+map_err:
+	regmap_exit(wm8400->regmap);
 struct_err:
 	kfree(wm8400);
 err:
@@ -427,6 +378,7 @@ static int wm8400_i2c_remove(struct i2c_client *i2c)
 	struct wm8400 *wm8400 = i2c_get_clientdata(i2c);
 
 	wm8400_release(wm8400);
+	regmap_exit(wm8400->regmap);
 	kfree(wm8400);
 
 	return 0;
diff --git a/include/linux/mfd/wm8400-private.h b/include/linux/mfd/wm8400-private.h
index 2aab4e9..0147b69 100644
--- a/include/linux/mfd/wm8400-private.h
+++ b/include/linux/mfd/wm8400-private.h
@@ -25,16 +25,15 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 
+struct regmap;
+
 #define WM8400_REGISTER_COUNT 0x55
 
 struct wm8400 {
 	struct device *dev;
 
-	int (*read_dev)(void *data, char reg, int count, u16 *dst);
-	int (*write_dev)(void *data, char reg, int count, const u16 *src);
-
 	struct mutex io_lock;
-	void *io_data;
+	struct regmap *regmap;
 
 	u16 reg_cache[WM8400_REGISTER_COUNT];
 
-- 
1.7.5.4

