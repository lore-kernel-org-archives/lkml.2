Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2EONnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:43:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab2EONng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:43:36 -0400
Message-ID: <1337089409.6238.4.camel@phoenix>
Subject: [PATCH RFT 3/3] regulator: max8660: Convert to set_voltage_sel and
 regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 21:43:29 +0800
In-Reply-To: <1337089278.6238.1.camel@phoenix>
References: <1337089278.6238.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |   71 +++++++++----------------------------------
 1 files changed, 15 insertions(+), 56 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 93bcfc8..8d53174 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -135,27 +135,13 @@ static int max8660_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 	return selector;
 }
 
-static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
-			    unsigned int *s)
+static int max8660_dcdc_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned int selector)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-	u8 reg, selector, bits;
+	u8 reg, bits;
 	int ret;
 
-	if (min_uV < MAX8660_DCDC_MIN_UV || min_uV > MAX8660_DCDC_MAX_UV)
-		return -EINVAL;
-	if (max_uV < MAX8660_DCDC_MIN_UV || max_uV > MAX8660_DCDC_MAX_UV)
-		return -EINVAL;
-
-	selector = DIV_ROUND_UP(min_uV - MAX8660_DCDC_MIN_UV,
-				MAX8660_DCDC_STEP);
-
-	ret = regulator_list_voltage_linear(rdev, selector);
-	if (ret < 0 || ret > max_uV)
-		return -EINVAL;
-
-	*s = selector;
-
 	reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV2 : MAX8660_SDTV2;
 	ret = max8660_write(max8660, reg, 0, selector);
 	if (ret)
@@ -169,7 +155,8 @@ static int max8660_dcdc_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 static struct regulator_ops max8660_dcdc_ops = {
 	.is_enabled = max8660_dcdc_is_enabled,
 	.list_voltage = regulator_list_voltage_linear,
-	.set_voltage = max8660_dcdc_set,
+	.map_voltage = regulator_map_voltage_linear,
+	.set_voltage_sel = max8660_dcdc_set_voltage_sel,
 	.get_voltage_sel = max8660_dcdc_get_voltage_sel,
 };
 
@@ -186,27 +173,12 @@ static int max8660_ldo5_get_voltage_sel(struct regulator_dev *rdev)
 	return selector;
 }
 
-static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
-			    unsigned int *s)
+static int max8660_ldo5_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned int selector)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-	u8 selector;
 	int ret;
 
-	if (min_uV < MAX8660_LDO5_MIN_UV || min_uV > MAX8660_LDO5_MAX_UV)
-		return -EINVAL;
-	if (max_uV < MAX8660_LDO5_MIN_UV || max_uV > MAX8660_LDO5_MAX_UV)
-		return -EINVAL;
-
-	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO5_MIN_UV,
-				MAX8660_LDO5_STEP);
-
-	ret = regulator_list_voltage_linear(rdev, selector);
-	if (ret < 0 || ret > max_uV)
-		return -EINVAL;
-
-	*s = selector;
-
 	ret = max8660_write(max8660, MAX8660_MDTV2, 0, selector);
 	if (ret)
 		return ret;
@@ -217,7 +189,8 @@ static int max8660_ldo5_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 
 static struct regulator_ops max8660_ldo5_ops = {
 	.list_voltage = regulator_list_voltage_linear,
-	.set_voltage = max8660_ldo5_set,
+	.map_voltage = regulator_map_voltage_linear,
+	.set_voltage_sel = max8660_ldo5_set_voltage_sel,
 	.get_voltage_sel = max8660_ldo5_get_voltage_sel,
 };
 
@@ -257,31 +230,16 @@ static int max8660_ldo67_get_voltage_sel(struct regulator_dev *rdev)
 	return selector;
 }
 
-static int max8660_ldo67_set(struct regulator_dev *rdev, int min_uV,
-			     int max_uV, unsigned int *s)
+static int max8660_ldo67_set_voltage_sel(struct regulator_dev *rdev,
+					 unsigned int selector)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-	u8 selector;
-	int ret;
-
-	if (min_uV < MAX8660_LDO67_MIN_UV || min_uV > MAX8660_LDO67_MAX_UV)
-		return -EINVAL;
-	if (max_uV < MAX8660_LDO67_MIN_UV || max_uV > MAX8660_LDO67_MAX_UV)
-		return -EINVAL;
-
-	selector = DIV_ROUND_UP(min_uV - MAX8660_LDO67_MIN_UV,
-				MAX8660_LDO67_STEP);
-
-	ret = regulator_list_voltage_linear(rdev, selector);
-	if (ret < 0 || ret > max_uV)
-		return -EINVAL;
-
-	*s = selector;
 
 	if (rdev_get_id(rdev) == MAX8660_V6)
 		return max8660_write(max8660, MAX8660_L12VCR, 0xf0, selector);
 	else
-		return max8660_write(max8660, MAX8660_L12VCR, 0x0f, selector << 4);
+		return max8660_write(max8660, MAX8660_L12VCR, 0x0f,
+				     selector << 4);
 }
 
 static struct regulator_ops max8660_ldo67_ops = {
@@ -289,8 +247,9 @@ static struct regulator_ops max8660_ldo67_ops = {
 	.enable = max8660_ldo67_enable,
 	.disable = max8660_ldo67_disable,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = max8660_ldo67_get_voltage_sel,
-	.set_voltage = max8660_ldo67_set,
+	.set_voltage_sel = max8660_ldo67_set_voltage_sel,
 };
 
 static const struct regulator_desc max8660_reg[] = {
-- 
1.7.5.4



