Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2DKF6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:58:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55364 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2DKF6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:58:22 -0400
Message-ID: <1334123889.6776.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Convert max8998 to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 13:58:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 7e831a9..c96b87a 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -277,7 +277,7 @@ static int max8998_get_voltage_register(struct regulator_dev *rdev,
 	return 0;
 }
 
-static int max8998_get_voltage(struct regulator_dev *rdev)
+static int max8998_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8998->iodev->i2c;
@@ -295,7 +295,7 @@ static int max8998_get_voltage(struct regulator_dev *rdev)
 	val >>= shift;
 	val &= mask;
 
-	return max8998_list_voltage(rdev, val);
+	return val;
 }
 
 static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
@@ -359,7 +359,7 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	const struct voltage_map_desc *desc;
 	int buck = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
-	int difference = 0, i, j = 0, previous_vol = 0;
+	int difference, i, j, previous_sel;
 	u8 val = 0;
 	static u8 buck1_last_val;
 
@@ -388,13 +388,14 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	previous_vol = max8998_get_voltage(rdev);
+	previous_sel = max8998_get_voltage_sel(rdev);
 
 	/* Check if voltage needs to be changed */
 	/* if previous_voltage equal new voltage, return */
-	if (previous_vol == max8998_list_voltage(rdev, i)) {
+	if (previous_sel == i) {
 		dev_dbg(max8998->dev, "No voltage change, old:%d, new:%d\n",
-			previous_vol, max8998_list_voltage(rdev, i));
+			max8998_list_voltage(rdev, previous_sel),
+			max8998_list_voltage(rdev, i));
 		return ret;
 	}
 
@@ -491,7 +492,7 @@ buck2_exit:
 	if (max8998->iodev->type == TYPE_MAX8998 && !(val & MAX8998_ENRAMP))
 		return ret;
 
-	difference = desc->min + desc->step*i - previous_vol/1000;
+	difference = (i - previous_sel) * desc->step;
 	if (difference > 0)
 		udelay(difference / ((val & 0x0f) + 1));
 
@@ -503,7 +504,7 @@ static struct regulator_ops max8998_ldo_ops = {
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
-	.get_voltage		= max8998_get_voltage,
+	.get_voltage_sel	= max8998_get_voltage_sel,
 	.set_voltage		= max8998_set_voltage_ldo,
 	.set_suspend_enable	= max8998_ldo_enable,
 	.set_suspend_disable	= max8998_ldo_disable,
@@ -514,7 +515,7 @@ static struct regulator_ops max8998_buck_ops = {
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
-	.get_voltage		= max8998_get_voltage,
+	.get_voltage_sel	= max8998_get_voltage_sel,
 	.set_voltage		= max8998_set_voltage_buck,
 	.set_suspend_enable	= max8998_ldo_enable,
 	.set_suspend_disable	= max8998_ldo_disable,
-- 
1.7.5.4



