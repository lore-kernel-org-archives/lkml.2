Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab2DKO4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:56:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44539 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2DKO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:56:21 -0400
Message-ID: <1334156171.2469.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: Convert max8997 to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 22:56:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also rename get_current_limit and set_current_limit callbacks
to max8997_get_current_limit and max8997_set_current_limit for
better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   53 ++++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index db09244..56402e8 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -382,7 +382,7 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 	return 0;
 }
 
-static int max8997_get_voltage(struct regulator_dev *rdev)
+static int max8997_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
@@ -400,15 +400,7 @@ static int max8997_get_voltage(struct regulator_dev *rdev)
 	val >>= shift;
 	val &= mask;
 
-	if (rdev->desc && rdev->desc->ops && rdev->desc->ops->list_voltage)
-		return rdev->desc->ops->list_voltage(rdev, val);
-
-	/*
-	 * max8997_list_voltage returns value for any rdev with voltage_map,
-	 * which works for "CHARGER" and "CHARGER TOPOFF" that do not have
-	 * list_voltage ops (they are current regulators).
-	 */
-	return max8997_list_voltage(rdev, val);
+	return val;
 }
 
 static inline int max8997_get_voltage_proper_val(
@@ -786,7 +778,7 @@ static struct regulator_ops max8997_ldo_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
-	.get_voltage		= max8997_get_voltage,
+	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_ldobuck,
 	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
@@ -797,7 +789,7 @@ static struct regulator_ops max8997_buck_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
-	.get_voltage		= max8997_get_voltage,
+	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_buck,
 	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
@@ -817,7 +809,7 @@ static struct regulator_ops max8997_safeout_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
-	.get_voltage		= max8997_get_voltage,
+	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_safeout,
 	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
@@ -825,31 +817,50 @@ static struct regulator_ops max8997_safeout_ops = {
 
 static struct regulator_ops max8997_fixedstate_ops = {
 	.list_voltage		= max8997_list_voltage_charger_cv,
-	.get_voltage		= max8997_get_voltage,
+	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_charger_cv,
 };
 
-static int max8997_set_voltage_ldobuck_wrap(struct regulator_dev *rdev,
-		int min_uV, int max_uV)
+static int max8997_set_current_limit(struct regulator_dev *rdev,
+				     int min_uA, int max_uA)
 {
 	unsigned dummy;
+	int rid = rdev_get_id(rdev);
+
+	if (rid != MAX8997_CHARGER && rid != MAX8997_CHARGER_TOPOFF)
+		return -EINVAL;
 
-	return max8997_set_voltage_ldobuck(rdev, min_uV, max_uV, &dummy);
+	/* Reuse max8997_set_voltage_ldobuck to set current_limit. */
+	return max8997_set_voltage_ldobuck(rdev, min_uA, max_uA, &dummy);
 }
 
+static int max8997_get_current_limit(struct regulator_dev *rdev)
+{
+	int sel, rid = rdev_get_id(rdev);
+
+	if (rid != MAX8997_CHARGER && rid != MAX8997_CHARGER_TOPOFF)
+		return -EINVAL;
+
+	sel = max8997_get_voltage_sel(rdev);
+	if (sel < 0)
+		return sel;
+
+	/* Reuse max8997_list_voltage to get current_limit. */
+	return max8997_list_voltage(rdev, sel);
+}
 
 static struct regulator_ops max8997_charger_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
-	.get_current_limit	= max8997_get_voltage,
-	.set_current_limit	= max8997_set_voltage_ldobuck_wrap,
+	.get_current_limit	= max8997_get_current_limit,
+	.set_current_limit	= max8997_set_current_limit,
 };
 
 static struct regulator_ops max8997_charger_fixedstate_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
-	.get_current_limit	= max8997_get_voltage,
-	.set_current_limit	= max8997_set_voltage_ldobuck_wrap,
+	.get_current_limit	= max8997_get_current_limit,
+	.set_current_limit	= max8997_set_current_limit,
 };
 
 #define MAX8997_VOLTAGE_REGULATOR(_name, _ops) {\
-- 
1.7.5.4



