Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1JXN0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:26:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37046 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab1JXN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:26:45 -0400
From: jhbird.choi@gmail.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH v2] regulator: max8649 Convert max8649 to use regmap api
Date: Mon, 24 Oct 2011 22:26:26 +0900
Message-Id: <1319462786-2602-1-git-send-email-jhbird.choi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@gmail.com>

Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>
---
 drivers/regulator/Kconfig   |    1 +
 drivers/regulator/max8649.c |  155 +++++++++++++++----------------------------
 2 files changed, 56 insertions(+), 100 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c7fd2c0..c4f9e1c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -83,6 +83,7 @@ config REGULATOR_MAX1586
 config REGULATOR_MAX8649
 	tristate "Maxim 8649 voltage regulator"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  This driver controls a Maxim 8649 voltage output regulator via
 	  I2C bus.
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 30eb9e5..1143bb4 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -16,6 +16,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/slab.h>
 #include <linux/regulator/max8649.h>
+#include <linux/regmap.h>
 
 #define MAX8649_DCDC_VMIN	750000		/* uV */
 #define MAX8649_DCDC_VMAX	1380000		/* uV */
@@ -49,9 +50,8 @@
 
 struct max8649_regulator_info {
 	struct regulator_dev	*regulator;
-	struct i2c_client	*i2c;
 	struct device		*dev;
-	struct mutex		io_lock;
+	struct regmap		*regmap;
 
 	int		vol_reg;
 	unsigned	mode:2;	/* bit[1:0] = VID1, VID0 */
@@ -63,71 +63,6 @@ struct max8649_regulator_info {
 
 /* I2C operations */
 
-static inline int max8649_read_device(struct i2c_client *i2c,
-				      int reg, int bytes, void *dest)
-{
-	unsigned char data;
-	int ret;
-
-	data = (unsigned char)reg;
-	ret = i2c_master_send(i2c, &data, 1);
-	if (ret < 0)
-		return ret;
-	ret = i2c_master_recv(i2c, dest, bytes);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
-
-static inline int max8649_write_device(struct i2c_client *i2c,
-				       int reg, int bytes, void *src)
-{
-	unsigned char buf[bytes + 1];
-	int ret;
-
-	buf[0] = (unsigned char)reg;
-	memcpy(&buf[1], src, bytes);
-
-	ret = i2c_master_send(i2c, buf, bytes + 1);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
-
-static int max8649_reg_read(struct i2c_client *i2c, int reg)
-{
-	struct max8649_regulator_info *info = i2c_get_clientdata(i2c);
-	unsigned char data;
-	int ret;
-
-	mutex_lock(&info->io_lock);
-	ret = max8649_read_device(i2c, reg, 1, &data);
-	mutex_unlock(&info->io_lock);
-
-	if (ret < 0)
-		return ret;
-	return (int)data;
-}
-
-static int max8649_set_bits(struct i2c_client *i2c, int reg,
-			    unsigned char mask, unsigned char data)
-{
-	struct max8649_regulator_info *info = i2c_get_clientdata(i2c);
-	unsigned char value;
-	int ret;
-
-	mutex_lock(&info->io_lock);
-	ret = max8649_read_device(i2c, reg, 1, &value);
-	if (ret < 0)
-		goto out;
-	value &= ~mask;
-	value |= data;
-	ret = max8649_write_device(i2c, reg, 1, &value);
-out:
-	mutex_unlock(&info->io_lock);
-	return ret;
-}
-
 static inline int check_range(int min_uV, int max_uV)
 {
 	if ((min_uV < MAX8649_DCDC_VMIN) || (max_uV > MAX8649_DCDC_VMAX)
@@ -144,13 +79,14 @@ static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
 static int max8649_get_voltage(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
+	unsigned int val;
 	unsigned char data;
 	int ret;
 
-	ret = max8649_reg_read(info->i2c, info->vol_reg);
-	if (ret < 0)
+	ret = regmap_read(info->regmap, info->vol_reg, &val);
+	if (ret != 0)
 		return ret;
-	data = (unsigned char)ret & MAX8649_VOL_MASK;
+	data = (unsigned char)val & MAX8649_VOL_MASK;
 	return max8649_list_voltage(rdev, data);
 }
 
@@ -170,14 +106,14 @@ static int max8649_set_voltage(struct regulator_dev *rdev,
 	mask = MAX8649_VOL_MASK;
 	*selector = data & mask;
 
-	return max8649_set_bits(info->i2c, info->vol_reg, mask, data);
+	return regmap_update_bits(info->regmap, info->vol_reg, mask, data);
 }
 
 /* EN_PD means pulldown on EN input */
 static int max8649_enable(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	return max8649_set_bits(info->i2c, MAX8649_CONTROL, MAX8649_EN_PD, 0);
+	return regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_EN_PD, 0);
 }
 
 /*
@@ -187,38 +123,40 @@ static int max8649_enable(struct regulator_dev *rdev)
 static int max8649_disable(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	return max8649_set_bits(info->i2c, MAX8649_CONTROL, MAX8649_EN_PD,
+	return regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_EN_PD,
 				MAX8649_EN_PD);
 }
 
 static int max8649_is_enabled(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
+	unsigned int val;
 	int ret;
 
-	ret = max8649_reg_read(info->i2c, MAX8649_CONTROL);
-	if (ret < 0)
+	ret = regmap_read(info->regmap, MAX8649_CONTROL, &val);
+	if (ret != 0)
 		return ret;
-	return !((unsigned char)ret & MAX8649_EN_PD);
+	return !((unsigned char)val & MAX8649_EN_PD);
 }
 
 static int max8649_enable_time(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
 	int voltage, rate, ret;
+	unsigned int val;
 
 	/* get voltage */
-	ret = max8649_reg_read(info->i2c, info->vol_reg);
-	if (ret < 0)
+	ret = regmap_read(info->regmap, info->vol_reg, &val);
+	if (ret != 0)
 		return ret;
-	ret &= MAX8649_VOL_MASK;
+	val &= MAX8649_VOL_MASK;
 	voltage = max8649_list_voltage(rdev, (unsigned char)ret); /* uV */
 
 	/* get rate */
-	ret = max8649_reg_read(info->i2c, MAX8649_RAMP);
-	if (ret < 0)
+	ret = regmap_read(info->regmap, MAX8649_RAMP, &val);
+	if (ret != 0)
 		return ret;
-	ret = (ret & MAX8649_RAMP_MASK) >> 5;
+	ret = (val & MAX8649_RAMP_MASK) >> 5;
 	rate = (32 * 1000) >> ret;	/* uV/uS */
 
 	return (voltage / rate);
@@ -230,12 +168,12 @@ static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)
 
 	switch (mode) {
 	case REGULATOR_MODE_FAST:
-		max8649_set_bits(info->i2c, info->vol_reg, MAX8649_FORCE_PWM,
-				 MAX8649_FORCE_PWM);
+		regmap_update_bits(info->regmap, info->vol_reg, MAX8649_FORCE_PWM,
+				   MAX8649_FORCE_PWM);
 		break;
 	case REGULATOR_MODE_NORMAL:
-		max8649_set_bits(info->i2c, info->vol_reg,
-				 MAX8649_FORCE_PWM, 0);
+		regmap_update_bits(info->regmap, info->vol_reg,
+				   MAX8649_FORCE_PWM, 0);
 		break;
 	default:
 		return -EINVAL;
@@ -246,10 +184,13 @@ static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 {
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
+	unsigned int val;
 	int ret;
 
-	ret = max8649_reg_read(info->i2c, info->vol_reg);
-	if (ret & MAX8649_FORCE_PWM)
+	ret = regmap_read(info->regmap, info->vol_reg, &val);
+	if (ret != 0)
+		return ret;
+	if (val & MAX8649_FORCE_PWM)
 		return REGULATOR_MODE_FAST;
 	return REGULATOR_MODE_NORMAL;
 }
@@ -275,11 +216,17 @@ static struct regulator_desc dcdc_desc = {
 	.owner		= THIS_MODULE,
 };
 
+static struct regmap_config max8649_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 static int __devinit max8649_regulator_probe(struct i2c_client *client,
 					     const struct i2c_device_id *id)
 {
 	struct max8649_platform_data *pdata = client->dev.platform_data;
 	struct max8649_regulator_info *info = NULL;
+	unsigned int val;
 	unsigned char data;
 	int ret;
 
@@ -289,9 +236,14 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	info->i2c = client;
+	info->regmap = regmap_init_i2c(client, &max8649_regmap_config);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n", ret);
+		goto fail;
+	}
+
 	info->dev = &client->dev;
-	mutex_init(&info->io_lock);
 	i2c_set_clientdata(client, info);
 
 	info->mode = pdata->mode;
@@ -312,8 +264,8 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 		break;
 	}
 
-	ret = max8649_reg_read(info->i2c, MAX8649_CHIP_ID1);
-	if (ret < 0) {
+	ret = regmap_read(info->regmap, MAX8649_CHIP_ID1, &val);
+	if (ret != 0) {
 		dev_err(info->dev, "Failed to detect ID of MAX8649:%d\n",
 			ret);
 		goto out;
@@ -321,29 +273,29 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
 
 	/* enable VID0 & VID1 */
-	max8649_set_bits(info->i2c, MAX8649_CONTROL, MAX8649_VID_MASK, 0);
+	regmap_update_bits(info->regmap, MAX8649_CONTROL, MAX8649_VID_MASK, 0);
 
 	/* enable/disable external clock synchronization */
 	info->extclk = pdata->extclk;
 	data = (info->extclk) ? MAX8649_SYNC_EXTCLK : 0;
-	max8649_set_bits(info->i2c, info->vol_reg, MAX8649_SYNC_EXTCLK, data);
+	regmap_update_bits(info->regmap, info->vol_reg, MAX8649_SYNC_EXTCLK, data);
 	if (info->extclk) {
 		/* set external clock frequency */
 		info->extclk_freq = pdata->extclk_freq;
-		max8649_set_bits(info->i2c, MAX8649_SYNC, MAX8649_EXT_MASK,
-				 info->extclk_freq << 6);
+		regmap_update_bits(info->regmap, MAX8649_SYNC, MAX8649_EXT_MASK,
+				   info->extclk_freq << 6);
 	}
 
 	if (pdata->ramp_timing) {
 		info->ramp_timing = pdata->ramp_timing;
-		max8649_set_bits(info->i2c, MAX8649_RAMP, MAX8649_RAMP_MASK,
-				 info->ramp_timing << 5);
+		regmap_update_bits(info->regmap, MAX8649_RAMP, MAX8649_RAMP_MASK,
+				   info->ramp_timing << 5);
 	}
 
 	info->ramp_down = pdata->ramp_down;
 	if (info->ramp_down) {
-		max8649_set_bits(info->i2c, MAX8649_RAMP, MAX8649_RAMP_DOWN,
-				 MAX8649_RAMP_DOWN);
+		regmap_update_bits(info->regmap, MAX8649_RAMP, MAX8649_RAMP_DOWN,
+				   MAX8649_RAMP_DOWN);
 	}
 
 	info->regulator = regulator_register(&dcdc_desc, &client->dev,
@@ -358,6 +310,8 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	dev_info(info->dev, "Max8649 regulator device is detected.\n");
 	return 0;
 out:
+	regmap_exit(info->regmap);
+fail:
 	kfree(info);
 	return ret;
 }
@@ -369,6 +323,7 @@ static int __devexit max8649_regulator_remove(struct i2c_client *client)
 	if (info) {
 		if (info->regulator)
 			regulator_unregister(info->regulator);
+		regmap_exit(info->regmap);
 		kfree(info);
 	}
 
-- 
1.7.1

