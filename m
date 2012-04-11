Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2DKF7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:59:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2DKF7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:59:19 -0400
Message-ID: <1334123954.6776.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: Convert max8998 to set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 13:59:14 +0800
In-Reply-To: <1334123889.6776.1.camel@phoenix>
References: <1334123889.6776.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index c96b87a..4ca22f9 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -359,8 +359,7 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	const struct voltage_map_desc *desc;
 	int buck = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
-	int difference, i, j, previous_sel;
-	u8 val = 0;
+	int i, j, previous_sel;
 	static u8 buck1_last_val;
 
 	if (buck >= ARRAY_SIZE(ldo_voltage_map))
@@ -484,19 +483,40 @@ buck2_exit:
 		break;
 	}
 
+	return ret;
+}
+
+static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
+					     unsigned int old_selector,
+					     unsigned int new_selector)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
+	const struct voltage_map_desc *desc;
+	int buck = rdev_get_id(rdev);
+	u8 val = 0;
+	int difference, ret;
+
+	if (buck < MAX8998_BUCK1 || buck > MAX8998_BUCK4)
+		return -EINVAL;
+
+	desc = ldo_voltage_map[buck];
+
 	/* Voltage stabilization */
-	max8998_read_reg(i2c, MAX8998_REG_ONOFF4, &val);
+	ret = max8998_read_reg(i2c, MAX8998_REG_ONOFF4, &val);
+	if (ret)
+		return ret;
 
 	/* lp3974 hasn't got ENRAMP bit - ramp is assumed as true */
 	/* MAX8998 has ENRAMP bit implemented, so test it*/
 	if (max8998->iodev->type == TYPE_MAX8998 && !(val & MAX8998_ENRAMP))
-		return ret;
+		return 0;
 
-	difference = (i - previous_sel) * desc->step;
+	difference = (new_selector - old_selector) * desc->step;
 	if (difference > 0)
-		udelay(difference / ((val & 0x0f) + 1));
+		return difference / ((val & 0x0f) + 1);
 
-	return ret;
+	return 0;
 }
 
 static struct regulator_ops max8998_ldo_ops = {
@@ -517,6 +537,7 @@ static struct regulator_ops max8998_buck_ops = {
 	.disable		= max8998_ldo_disable,
 	.get_voltage_sel	= max8998_get_voltage_sel,
 	.set_voltage		= max8998_set_voltage_buck,
+	.set_voltage_time_sel	= max8998_set_voltage_buck_time_sel,
 	.set_suspend_enable	= max8998_ldo_enable,
 	.set_suspend_disable	= max8998_ldo_disable,
 };
-- 
1.7.5.4



