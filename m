Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab2CMD3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:29:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921Ab2CMD3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:29:53 -0400
Message-ID: <1331608961.11322.5.camel@phoenix>
Subject: [PATCH] regulator: Make max8997_get_voltage_register always return
 correct register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Mar 2012 11:22:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check max8997->buck[1|2|5]_gpiodvs status in max8997_get_voltage_register
and return correct register accordingly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 9657929..35e7332 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -320,6 +320,7 @@ static int max8997_reg_disable(struct regulator_dev *rdev)
 static int max8997_get_voltage_register(struct regulator_dev *rdev,
 		int *_reg, int *_shift, int *_mask)
 {
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask = 0x3f;
 
@@ -329,9 +330,13 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 		break;
 	case MAX8997_BUCK1:
 		reg = MAX8997_REG_BUCK1DVS1;
+		if (max8997->buck1_gpiodvs)
+			reg += max8997->buck125_gpioindex;
 		break;
 	case MAX8997_BUCK2:
 		reg = MAX8997_REG_BUCK2DVS1;
+		if (max8997->buck2_gpiodvs)
+			reg += max8997->buck125_gpioindex;
 		break;
 	case MAX8997_BUCK3:
 		reg = MAX8997_REG_BUCK3DVS;
@@ -341,6 +346,8 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 		break;
 	case MAX8997_BUCK5:
 		reg = MAX8997_REG_BUCK5DVS1;
+		if (max8997->buck5_gpiodvs)
+			reg += max8997->buck125_gpioindex;
 		break;
 	case MAX8997_BUCK7:
 		reg = MAX8997_REG_BUCK7DVS;
@@ -381,18 +388,12 @@ static int max8997_get_voltage(struct regulator_dev *rdev)
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int reg, shift, mask, ret;
-	int rid = rdev_get_id(rdev);
 	u8 val;
 
 	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
 
-	if ((rid == MAX8997_BUCK1 && max8997->buck1_gpiodvs) ||
-			(rid == MAX8997_BUCK2 && max8997->buck2_gpiodvs) ||
-			(rid == MAX8997_BUCK5 && max8997->buck5_gpiodvs))
-		reg += max8997->buck125_gpioindex;
-
 	ret = max8997_read_reg(i2c, reg, &val);
 	if (ret)
 		return ret;
-- 
1.7.5.4



