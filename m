Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2EIVx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:53:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39582 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705Ab2EIVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:53:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8400: Remove custom cache implementation
Date: Wed,  9 May 2012 22:53:48 +0100
Message-Id: <1336600428-13238-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save a useful amount of code by removing the custom cache implementation
for wm8400 and using the regmap cache. Also simplify things by not
separately reseting the CODEC registers, this is a sufficiently infrequent
operation that we can simply invalidate the entire cache when this happens.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8400-core.c          |  251 +++++-------------------------------
 include/linux/mfd/wm8400-private.h |   14 +-
 2 files changed, 42 insertions(+), 223 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 1189a17..9083b77 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -23,136 +23,16 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-static struct {
-	u16  readable;    /* Mask of readable bits */
-	u16  writable;    /* Mask of writable bits */
-	u16  vol;         /* Mask of volatile bits */
-	int  is_codec;    /* Register controlled by codec reset */
-	u16  default_val; /* Value on reset */
-} reg_data[] = {
-	{ 0xFFFF, 0xFFFF, 0x0000, 0, 0x6172 }, /* R0 */
-	{ 0x7000, 0x0000, 0x8000, 0, 0x0000 }, /* R1 */
-	{ 0xFF17, 0xFF17, 0x0000, 0, 0x0000 }, /* R2 */
-	{ 0xEBF3, 0xEBF3, 0x0000, 1, 0x6000 }, /* R3 */
-	{ 0x3CF3, 0x3CF3, 0x0000, 1, 0x0000 }, /* R4  */
-	{ 0xF1F8, 0xF1F8, 0x0000, 1, 0x4050 }, /* R5  */
-	{ 0xFC1F, 0xFC1F, 0x0000, 1, 0x4000 }, /* R6  */
-	{ 0xDFDE, 0xDFDE, 0x0000, 1, 0x01C8 }, /* R7  */
-	{ 0xFCFC, 0xFCFC, 0x0000, 1, 0x0000 }, /* R8  */
-	{ 0xEFFF, 0xEFFF, 0x0000, 1, 0x0040 }, /* R9  */
-	{ 0xEFFF, 0xEFFF, 0x0000, 1, 0x0040 }, /* R10 */
-	{ 0x27F7, 0x27F7, 0x0000, 1, 0x0004 }, /* R11 */
-	{ 0x01FF, 0x01FF, 0x0000, 1, 0x00C0 }, /* R12 */
-	{ 0x01FF, 0x01FF, 0x0000, 1, 0x00C0 }, /* R13 */
-	{ 0x1FEF, 0x1FEF, 0x0000, 1, 0x0000 }, /* R14 */
-	{ 0x0163, 0x0163, 0x0000, 1, 0x0100 }, /* R15 */
-	{ 0x01FF, 0x01FF, 0x0000, 1, 0x00C0 }, /* R16 */
-	{ 0x01FF, 0x01FF, 0x0000, 1, 0x00C0 }, /* R17 */
-	{ 0x1FFF, 0x0FFF, 0x0000, 1, 0x0000 }, /* R18 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 1, 0x1000 }, /* R19 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 1, 0x1010 }, /* R20 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 1, 0x1010 }, /* R21 */
-	{ 0x0FDD, 0x0FDD, 0x0000, 1, 0x8000 }, /* R22 */
-	{ 0x1FFF, 0x1FFF, 0x0000, 1, 0x0800 }, /* R23 */
-	{ 0x0000, 0x01DF, 0x0000, 1, 0x008B }, /* R24 */
-	{ 0x0000, 0x01DF, 0x0000, 1, 0x008B }, /* R25 */
-	{ 0x0000, 0x01DF, 0x0000, 1, 0x008B }, /* R26 */
-	{ 0x0000, 0x01DF, 0x0000, 1, 0x008B }, /* R27 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R28 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R29 */
-	{ 0x0000, 0x0077, 0x0000, 1, 0x0066 }, /* R30 */
-	{ 0x0000, 0x0033, 0x0000, 1, 0x0022 }, /* R31 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0079 }, /* R32 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0079 }, /* R33 */
-	{ 0x0000, 0x0003, 0x0000, 1, 0x0003 }, /* R34 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0003 }, /* R35 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R36 */
-	{ 0x0000, 0x003F, 0x0000, 1, 0x0100 }, /* R37 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R38 */
-	{ 0x0000, 0x000F, 0x0000, 0, 0x0000 }, /* R39 */
-	{ 0x0000, 0x00FF, 0x0000, 1, 0x0000 }, /* R40 */
-	{ 0x0000, 0x01B7, 0x0000, 1, 0x0000 }, /* R41 */
-	{ 0x0000, 0x01B7, 0x0000, 1, 0x0000 }, /* R42 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R43 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R44 */
-	{ 0x0000, 0x00FD, 0x0000, 1, 0x0000 }, /* R45 */
-	{ 0x0000, 0x00FD, 0x0000, 1, 0x0000 }, /* R46 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R47 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R48 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R49 */
-	{ 0x0000, 0x01FF, 0x0000, 1, 0x0000 }, /* R50 */
-	{ 0x0000, 0x01B3, 0x0000, 1, 0x0180 }, /* R51 */
-	{ 0x0000, 0x0077, 0x0000, 1, 0x0000 }, /* R52 */
-	{ 0x0000, 0x0077, 0x0000, 1, 0x0000 }, /* R53 */
-	{ 0x0000, 0x00FF, 0x0000, 1, 0x0000 }, /* R54 */
-	{ 0x0000, 0x0001, 0x0000, 1, 0x0000 }, /* R55 */
-	{ 0x0000, 0x003F, 0x0000, 1, 0x0000 }, /* R56 */
-	{ 0x0000, 0x004F, 0x0000, 1, 0x0000 }, /* R57 */
-	{ 0x0000, 0x00FD, 0x0000, 1, 0x0000 }, /* R58 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R59 */
-	{ 0x1FFF, 0x1FFF, 0x0000, 1, 0x0000 }, /* R60 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 1, 0x0000 }, /* R61 */
-	{ 0x03FF, 0x03FF, 0x0000, 1, 0x0000 }, /* R62 */
-	{ 0x007F, 0x007F, 0x0000, 1, 0x0000 }, /* R63 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R64 */
-	{ 0xDFFF, 0xDFFF, 0x0000, 0, 0x0000 }, /* R65 */
-	{ 0xDFFF, 0xDFFF, 0x0000, 0, 0x0000 }, /* R66 */
-	{ 0xDFFF, 0xDFFF, 0x0000, 0, 0x0000 }, /* R67 */
-	{ 0xDFFF, 0xDFFF, 0x0000, 0, 0x0000 }, /* R68 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R69 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 0, 0x4400 }, /* R70 */
-	{ 0x23FF, 0x23FF, 0x0000, 0, 0x0000 }, /* R71 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 0, 0x4400 }, /* R72 */
-	{ 0x23FF, 0x23FF, 0x0000, 0, 0x0000 }, /* R73 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R74 */
-	{ 0x000E, 0x000E, 0x0000, 0, 0x0008 }, /* R75 */
-	{ 0xE00F, 0xE00F, 0x0000, 0, 0x0000 }, /* R76 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R77 */
-	{ 0x03C0, 0x03C0, 0x0000, 0, 0x02C0 }, /* R78 */
-	{ 0xFFFF, 0x0000, 0xffff, 0, 0x0000 }, /* R79 */
-	{ 0xFFFF, 0xFFFF, 0x0000, 0, 0x0000 }, /* R80 */
-	{ 0xFFFF, 0x0000, 0xffff, 0, 0x0000 }, /* R81 */
-	{ 0x2BFF, 0x0000, 0xffff, 0, 0x0000 }, /* R82 */
-	{ 0x0000, 0x0000, 0x0000, 0, 0x0000 }, /* R83 */
-	{ 0x80FF, 0x80FF, 0x0000, 0, 0x00ff }, /* R84 */
-};
-
-static int wm8400_read(struct wm8400 *wm8400, u8 reg, int num_regs, u16 *dest)
+static bool wm8400_volatile(struct device *dev, unsigned int reg)
 {
-	int i, ret = 0;
-
-	BUG_ON(reg + num_regs > ARRAY_SIZE(wm8400->reg_cache));
-
-	/* If there are any volatile reads then read back the entire block */
-	for (i = reg; i < reg + num_regs; i++)
-		if (reg_data[i].vol) {
-			ret = regmap_bulk_read(wm8400->regmap, reg, dest,
-					       num_regs);
-			return ret;
-		}
-
-	/* Otherwise use the cache */
-	memcpy(dest, &wm8400->reg_cache[reg], num_regs * sizeof(u16));
-
-	return 0;
-}
-
-static int wm8400_write(struct wm8400 *wm8400, u8 reg, int num_regs,
-			u16 *src)
-{
-	int ret, i;
-
-	BUG_ON(reg + num_regs > ARRAY_SIZE(wm8400->reg_cache));
-
-	for (i = 0; i < num_regs; i++) {
-		BUG_ON(!reg_data[reg + i].writable);
-		wm8400->reg_cache[reg + i] = src[i];
-		ret = regmap_write(wm8400->regmap, reg, src[i]);
-		if (ret != 0)
-			return ret;
+	switch (reg) {
+	case WM8400_INTERRUPT_STATUS_1:
+	case WM8400_INTERRUPT_LEVELS:
+	case WM8400_SHUTDOWN_REASON:
+		return true;
+	default:
+		return false;
 	}
-
-	return 0;
 }
 
 /**
@@ -165,13 +45,12 @@ static int wm8400_write(struct wm8400 *wm8400, u8 reg, int num_regs,
  */
 u16 wm8400_reg_read(struct wm8400 *wm8400, u8 reg)
 {
-	u16 val;
-
-	mutex_lock(&wm8400->io_lock);
-
-	wm8400_read(wm8400, reg, 1, &val);
+	unsigned int val;
+	int ret;
 
-	mutex_unlock(&wm8400->io_lock);
+	ret = regmap_read(wm8400->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
 
 	return val;
 }
@@ -179,62 +58,8 @@ EXPORT_SYMBOL_GPL(wm8400_reg_read);
 
 int wm8400_block_read(struct wm8400 *wm8400, u8 reg, int count, u16 *data)
 {
-	int ret;
-
-	mutex_lock(&wm8400->io_lock);
-
-	ret = wm8400_read(wm8400, reg, count, data);
-
-	mutex_unlock(&wm8400->io_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(wm8400_block_read);
-
-/**
- * wm8400_set_bits - Bitmask write
- *
- * @wm8400: Pointer to wm8400 control structure
- * @reg:    Register to access
- * @mask:   Mask of bits to change
- * @val:    Value to set for masked bits
- */
-int wm8400_set_bits(struct wm8400 *wm8400, u8 reg, u16 mask, u16 val)
-{
-	u16 tmp;
-	int ret;
-
-	mutex_lock(&wm8400->io_lock);
-
-	ret = wm8400_read(wm8400, reg, 1, &tmp);
-	tmp = (tmp & ~mask) | val;
-	if (ret == 0)
-		ret = wm8400_write(wm8400, reg, 1, &tmp);
-
-	mutex_unlock(&wm8400->io_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(wm8400_set_bits);
-
-/**
- * wm8400_reset_codec_reg_cache - Reset cached codec registers to
- * their default values.
- */
-void wm8400_reset_codec_reg_cache(struct wm8400 *wm8400)
-{
-	int i;
-
-	mutex_lock(&wm8400->io_lock);
-
-	/* Reset all codec registers to their initial value */
-	for (i = 0; i < ARRAY_SIZE(wm8400->reg_cache); i++)
-		if (reg_data[i].is_codec)
-			wm8400->reg_cache[i] = reg_data[i].default_val;
-
-	mutex_unlock(&wm8400->io_lock);
+	return regmap_bulk_read(wm8400->regmap, reg, data, count);
 }
-EXPORT_SYMBOL_GPL(wm8400_reset_codec_reg_cache);
 
 static int wm8400_register_codec(struct wm8400 *wm8400)
 {
@@ -257,44 +82,24 @@ static int wm8400_register_codec(struct wm8400 *wm8400)
 static int wm8400_init(struct wm8400 *wm8400,
 		       struct wm8400_platform_data *pdata)
 {
-	u16 reg;
-	int ret, i;
-
-	mutex_init(&wm8400->io_lock);
+	unsigned int reg;
+	int ret;
 
 	dev_set_drvdata(wm8400->dev, wm8400);
 
 	/* Check that this is actually a WM8400 */
-	ret = regmap_read(wm8400->regmap, WM8400_RESET_ID, &i);
+	ret = regmap_read(wm8400->regmap, WM8400_RESET_ID, &reg);
 	if (ret != 0) {
 		dev_err(wm8400->dev, "Chip ID register read failed\n");
 		return -EIO;
 	}
-	if (i != reg_data[WM8400_RESET_ID].default_val) {
-		dev_err(wm8400->dev, "Device is not a WM8400, ID is %x\n", i);
+	if (reg != 0x6172) {
+		dev_err(wm8400->dev, "Device is not a WM8400, ID is %x\n",
+			reg);
 		return -ENODEV;
 	}
 
-	/* We don't know what state the hardware is in and since this
-	 * is a PMIC we can't reset it safely so initialise the register
-	 * cache from the hardware.
-	 */
-	ret = regmap_raw_read(wm8400->regmap, 0, wm8400->reg_cache,
-			      ARRAY_SIZE(wm8400->reg_cache));
-	if (ret != 0) {
-		dev_err(wm8400->dev, "Register cache read failed\n");
-		return -EIO;
-	}
-	for (i = 0; i < ARRAY_SIZE(wm8400->reg_cache); i++)
-		wm8400->reg_cache[i] = be16_to_cpu(wm8400->reg_cache[i]);
-
-	/* If the codec is in reset use hard coded values */
-	if (!(wm8400->reg_cache[WM8400_POWER_MANAGEMENT_1] & WM8400_CODEC_ENA))
-		for (i = 0; i < ARRAY_SIZE(wm8400->reg_cache); i++)
-			if (reg_data[i].is_codec)
-				wm8400->reg_cache[i] = reg_data[i].default_val;
-
-	ret = wm8400_read(wm8400, WM8400_ID, 1, &reg);
+	ret = regmap_read(wm8400->regmap, WM8400_ID, &reg);
 	if (ret != 0) {
 		dev_err(wm8400->dev, "ID register read failed: %d\n", ret);
 		return ret;
@@ -334,8 +139,22 @@ static const struct regmap_config wm8400_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 16,
 	.max_register = WM8400_REGISTER_COUNT - 1,
+
+	.volatile_reg = wm8400_volatile,
+
+	.cache_type = REGCACHE_RBTREE,
 };
 
+/**
+ * wm8400_reset_codec_reg_cache - Reset cached codec registers to
+ * their default values.
+ */
+void wm8400_reset_codec_reg_cache(struct wm8400 *wm8400)
+{
+	regmap_reinit_cache(wm8400->regmap, &wm8400_regmap_config);
+}
+EXPORT_SYMBOL_GPL(wm8400_reset_codec_reg_cache);
+
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 static int wm8400_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
diff --git a/include/linux/mfd/wm8400-private.h b/include/linux/mfd/wm8400-private.h
index 0147b69..2de565b 100644
--- a/include/linux/mfd/wm8400-private.h
+++ b/include/linux/mfd/wm8400-private.h
@@ -24,19 +24,14 @@
 #include <linux/mfd/wm8400.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
-
-struct regmap;
+#include <linux/regmap.h>
 
 #define WM8400_REGISTER_COUNT 0x55
 
 struct wm8400 {
 	struct device *dev;
-
-	struct mutex io_lock;
 	struct regmap *regmap;
 
-	u16 reg_cache[WM8400_REGISTER_COUNT];
-
 	struct platform_device regulators[6];
 };
 
@@ -930,6 +925,11 @@ struct wm8400 {
 
 u16 wm8400_reg_read(struct wm8400 *wm8400, u8 reg);
 int wm8400_block_read(struct wm8400 *wm8400, u8 reg, int count, u16 *data);
-int wm8400_set_bits(struct wm8400 *wm8400, u8 reg, u16 mask, u16 val);
+
+static inline int wm8400_set_bits(struct wm8400 *wm8400, u8 reg,
+				  u16 mask, u16 val)
+{
+	return regmap_update_bits(wm8400->regmap, reg, mask, val);
+}
 
 #endif
-- 
1.7.10

