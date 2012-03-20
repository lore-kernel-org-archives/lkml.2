Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2CTBvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:51:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39804 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2CTBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:51:17 -0400
Message-ID: <1332208268.10843.1.camel@phoenix>
Subject: [PATCH RFT] regulator: Convert ab8500 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 20 Mar 2012 09:51:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ab8500 to set_voltage_sel and then we can remove
ab8500_get_best_voltage_index function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |   35 ++++-------------------------------
 1 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c7ee4c1..0d095b6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -234,25 +234,8 @@ static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 		return val;
 }
 
-static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
-		int min_uV, int max_uV)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	int i;
-
-	/* check the supported voltage */
-	for (i = 0; i < info->voltages_len; i++) {
-		if ((info->voltages[i] >= min_uV) &&
-		    (info->voltages[i] <= max_uV))
-			return i;
-	}
-
-	return -EINVAL;
-}
-
-static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
-					int min_uV, int max_uV,
-					unsigned *selector)
+static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					    unsigned selector)
 {
 	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -263,18 +246,8 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	/* get the appropriate voltages within the range */
-	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
-	if (ret < 0) {
-		dev_err(rdev_get_dev(rdev),
-				"couldn't get best voltage for regulator\n");
-		return ret;
-	}
-
-	*selector = ret;
-
 	/* set the registers for the request */
-	regval = (u8)ret;
+	regval = (u8)selector;
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 			info->voltage_bank, info->voltage_reg,
 			info->voltage_mask, regval);
@@ -319,7 +292,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
-	.set_voltage	= ab8500_regulator_set_voltage,
+	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
 	.list_voltage	= ab8500_list_voltage,
 	.enable_time	= ab8500_regulator_enable_time,
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
-- 
1.7.5.4



