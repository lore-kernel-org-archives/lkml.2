Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2CHXFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:05:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46129 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2CHXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:05:53 -0500
Message-ID: <1331247941.3570.1.camel@phoenix>
Subject: [PATCH] regulator: Use array to store dcdc_range settings for
 tps65912
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 09 Mar 2012 07:05:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can use the regulator id as array index to access the array.
This change makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |   70 +++++++++-----------------------
 1 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index b685757..a654602 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -114,10 +114,7 @@ struct tps65912_reg {
 	struct mutex io_lock;
 	int mode;
 	int (*get_ctrl_reg)(int);
-	int dcdc1_range;
-	int dcdc2_range;
-	int dcdc3_range;
-	int dcdc4_range;
+	int dcdc_range[TPS65912_NUM_DCDC];
 	int pwm_mode_reg;
 	int eco_reg;
 };
@@ -125,46 +122,31 @@ struct tps65912_reg {
 static int tps65912_get_range(struct tps65912_reg *pmic, int id)
 {
 	struct tps65912 *mfd = pmic->mfd;
-
-	if (id > TPS65912_REG_DCDC4)
-		return 0;
+	int range;
 
 	switch (id) {
 	case TPS65912_REG_DCDC1:
-		pmic->dcdc1_range = tps65912_reg_read(mfd,
-							TPS65912_DCDC1_LIMIT);
-		if (pmic->dcdc1_range < 0)
-			return pmic->dcdc1_range;
-		pmic->dcdc1_range = (pmic->dcdc1_range &
-			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
-		return pmic->dcdc1_range;
+		range = tps65912_reg_read(mfd, TPS65912_DCDC1_LIMIT);
+		break;
 	case TPS65912_REG_DCDC2:
-		pmic->dcdc2_range = tps65912_reg_read(mfd,
-							TPS65912_DCDC2_LIMIT);
-		if (pmic->dcdc2_range < 0)
-			return pmic->dcdc2_range;
-		pmic->dcdc2_range = (pmic->dcdc2_range &
-			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
-		return pmic->dcdc2_range;
+		range = tps65912_reg_read(mfd, TPS65912_DCDC2_LIMIT);
+		break;
 	case TPS65912_REG_DCDC3:
-		pmic->dcdc3_range = tps65912_reg_read(mfd,
-							TPS65912_DCDC3_LIMIT);
-		if (pmic->dcdc3_range < 0)
-			return pmic->dcdc3_range;
-		pmic->dcdc3_range = (pmic->dcdc3_range &
-			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
-		return pmic->dcdc3_range;
+		range = tps65912_reg_read(mfd, TPS65912_DCDC3_LIMIT);
+		break;
 	case TPS65912_REG_DCDC4:
-		pmic->dcdc4_range = tps65912_reg_read(mfd,
-							TPS65912_DCDC4_LIMIT);
-		if (pmic->dcdc4_range < 0)
-			return pmic->dcdc4_range;
-		pmic->dcdc4_range = (pmic->dcdc4_range &
-			DCDC_LIMIT_RANGE_MASK) >> DCDC_LIMIT_RANGE_SHIFT;
-		return pmic->dcdc4_range;
+		range = tps65912_reg_read(mfd, TPS65912_DCDC4_LIMIT);
+		break;
 	default:
 		return 0;
 	}
+
+	if (range >= 0)
+		range = (range & DCDC_LIMIT_RANGE_MASK)
+			>> DCDC_LIMIT_RANGE_SHIFT;
+
+	pmic->dcdc_range[id] = range;
+	return range;
 }
 
 static unsigned long tps65912_vsel_to_uv_range0(u8 vsel)
@@ -512,22 +494,10 @@ static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	int range, voltage = 0, id = rdev_get_id(dev);
 
-	switch (id) {
-	case TPS65912_REG_DCDC1:
-		range = pmic->dcdc1_range;
-		break;
-	case TPS65912_REG_DCDC2:
-		range = pmic->dcdc2_range;
-		break;
-	case TPS65912_REG_DCDC3:
-		range = pmic->dcdc3_range;
-		break;
-	case TPS65912_REG_DCDC4:
-		range = pmic->dcdc4_range;
-		break;
-	default:
+	if (id > TPS65912_REG_DCDC4)
 		return -EINVAL;
-	}
+
+	range = pmic->dcdc_range[id];
 
 	switch (range) {
 	case 0:
-- 
1.7.5.4



