Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0ICBas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:30:48 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41169 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0ICBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:30:47 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: lrg@slimlogic.co.uk, Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] regulators: add support max8952 regulator
Date: Fri,  3 Sep 2010 10:15:24 +0900
Message-Id: <1283476524-12820-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changhwan Youn <chaos.youn@samsung.com>

The operation of max8952 is almost similar to max8649 except
the output voltage range. This patch adds support the max8952
regulator using current max8649 implementation.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/regulator/Kconfig   |    4 ++--
 drivers/regulator/max8649.c |   43 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 172951b..fab9a90 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -81,10 +81,10 @@ config REGULATOR_MAX1586
 	  for PXA27x chips to control VCC_CORE and VCC_USIM voltages.
 
 config REGULATOR_MAX8649
-	tristate "Maxim 8649 voltage regulator"
+	tristate "Maxim 8649/8952 voltage regulator"
 	depends on I2C
 	help
-	  This driver controls a Maxim 8649 voltage output regulator via
+	  This driver controls a Maxim 8649/8952 voltage output regulator via
 	  I2C bus.
 
 config REGULATOR_MAX8660
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 4520ace..f5d034c 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -22,6 +22,9 @@
 #define MAX8649_DCDC_STEP	10000		/* uV */
 #define MAX8649_VOL_MASK	0x3f
 
+/* difference between voltages of max8649 and max8952 */
+#define DIFF_MAX8952_DCDC_VOL	20000		/* uV */
+
 /* Registers */
 #define MAX8649_MODE0		0x00
 #define MAX8649_MODE1		0x01
@@ -47,6 +50,11 @@
 #define MAX8649_RAMP_MASK	(7 << 5)
 #define MAX8649_RAMP_DOWN	(1 << 1)
 
+enum chips {
+	MAX8649,
+	MAX8952
+};
+
 struct max8649_regulator_info {
 	struct regulator_dev	*regulator;
 	struct i2c_client	*i2c;
@@ -54,6 +62,7 @@ struct max8649_regulator_info {
 	struct mutex		io_lock;
 
 	int		vol_reg;
+	int		type;
 	unsigned	mode:2;	/* bit[1:0] = VID1, VID0 */
 	unsigned	extclk_freq:2;
 	unsigned	extclk:1;
@@ -138,7 +147,12 @@ static inline int check_range(int min_uV, int max_uV)
 
 static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
-	return (MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP);
+	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret = MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP;
+
+	if (info->type == MAX8952)
+		ret += DIFF_MAX8952_DCDC_VOL;
+	return ret;
 }
 
 static int max8649_get_voltage(struct regulator_dev *rdev)
@@ -160,6 +174,11 @@ static int max8649_set_voltage(struct regulator_dev *rdev,
 	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
 	unsigned char data, mask;
 
+	if (info->type == MAX8952) {
+		min_uV -= DIFF_MAX8952_DCDC_VOL;
+		max_uV -= DIFF_MAX8952_DCDC_VOL;
+	}
+
 	if (check_range(min_uV, max_uV)) {
 		dev_err(info->dev, "invalid voltage range (%d, %d) uV\n",
 			min_uV, max_uV);
@@ -263,7 +282,6 @@ static struct regulator_ops max8649_dcdc_ops = {
 	.enable_time	= max8649_enable_time,
 	.set_mode	= max8649_set_mode,
 	.get_mode	= max8649_get_mode,
-
 };
 
 static struct regulator_desc dcdc_desc = {
@@ -281,6 +299,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	struct max8649_regulator_info *info = NULL;
 	unsigned char data;
 	int ret;
+	int ret2;
 
 	info = kzalloc(sizeof(struct max8649_regulator_info), GFP_KERNEL);
 	if (!info) {
@@ -313,11 +332,20 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 
 	ret = max8649_reg_read(info->i2c, MAX8649_CHIP_ID1);
 	if (ret < 0) {
-		dev_err(info->dev, "Failed to detect ID of MAX8649:%d\n",
-			ret);
+		dev_err(info->dev, "Failed to detect ID of %s:%d\n",
+			id->name, ret);
+		goto out;
+	}
+
+	ret2 = max8649_reg_read(info->i2c, MAX8649_CHIP_ID2);
+	if (ret2 < 0) {
+		dev_err(info->dev, "Failed to detect ID of %s:%d\n",
+			id->name, ret2);
 		goto out;
 	}
-	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
+	dev_info(info->dev, "Detected %s (ID:%x %x)\n", id->name, ret, ret2);
+
+	info->type = id->driver_data;
 
 	/* enable VID0 & VID1 */
 	max8649_set_bits(info->i2c, MAX8649_CONTROL, MAX8649_VID_MASK, 0);
@@ -354,7 +382,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 		goto out;
 	}
 
-	dev_info(info->dev, "Max8649 regulator device is detected.\n");
+	dev_info(info->dev, "%s regulator device is detected.\n", id->name);
 	return 0;
 out:
 	kfree(info);
@@ -375,7 +403,8 @@ static int __devexit max8649_regulator_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id max8649_id[] = {
-	{ "max8649", 0 },
+	{ "max8649", MAX8649 },
+	{ "max8952", MAX8952 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8649_id);
-- 
1.6.2.5

