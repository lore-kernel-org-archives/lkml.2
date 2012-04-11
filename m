Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537Ab2DKO6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:58:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61655 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484Ab2DKO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:58:09 -0400
Message-ID: <1334156283.2469.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: Convert max8997 to set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 22:58:03 +0800
In-Reply-To: <1334156171.2469.1.camel@phoenix>
References: <1334156171.2469.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   55 ++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 56402e8..ec99bd3 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -489,9 +489,7 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
 	int rid = rdev_get_id(rdev);
-	int reg, shift = 0, mask, ret;
-	int i;
-	u8 org;
+	int i, reg, shift, mask, ret;
 
 	switch (rid) {
 	case MAX8997_LDO1 ... MAX8997_LDO21:
@@ -520,21 +518,50 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	max8997_read_reg(i2c, reg, &org);
-	org = (org & mask) >> shift;
-
 	ret = max8997_update_reg(i2c, reg, i << shift, mask << shift);
 	*selector = i;
 
-	if (rid == MAX8997_BUCK1 || rid == MAX8997_BUCK2 ||
-			rid == MAX8997_BUCK4 || rid == MAX8997_BUCK5) {
-		/* If the voltage is increasing */
-		if (org < i)
-			udelay(DIV_ROUND_UP(desc->step * (i - org),
-						max8997->ramp_delay));
+	return ret;
+}
+
+static int max8997_set_voltage_ldobuck_time_sel(struct regulator_dev *rdev,
+						unsigned int old_selector,
+						unsigned int new_selector)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	int rid = rdev_get_id(rdev);
+	const struct voltage_map_desc *desc = reg_voltage_map[rid];
+
+	/* Delay is required only if the voltage is increasing */
+	if (old_selector >= new_selector)
+		return 0;
+
+	/* No need to delay if gpio_dvs_mode */
+	switch (rid) {
+	case MAX8997_BUCK1:
+		if (max8997->buck1_gpiodvs)
+			return 0;
+		break;
+	case MAX8997_BUCK2:
+		if (max8997->buck2_gpiodvs)
+			return 0;
+		break;
+	case MAX8997_BUCK5:
+		if (max8997->buck5_gpiodvs)
+			return 0;
+		break;
+	}
+
+	switch (rid) {
+	case MAX8997_BUCK1:
+	case MAX8997_BUCK2:
+	case MAX8997_BUCK4:
+	case MAX8997_BUCK5:
+		return DIV_ROUND_UP(desc->step * (new_selector - old_selector),
+				    max8997->ramp_delay);
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -780,6 +807,7 @@ static struct regulator_ops max8997_ldo_ops = {
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_ldobuck,
+	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
 	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
@@ -791,6 +819,7 @@ static struct regulator_ops max8997_buck_ops = {
 	.disable		= max8997_reg_disable,
 	.get_voltage_sel	= max8997_get_voltage_sel,
 	.set_voltage		= max8997_set_voltage_buck,
+	.set_voltage_time_sel	= max8997_set_voltage_ldobuck_time_sel,
 	.set_suspend_enable	= max8997_reg_enable_suspend,
 	.set_suspend_disable	= max8997_reg_disable_suspend,
 };
-- 
1.7.5.4



