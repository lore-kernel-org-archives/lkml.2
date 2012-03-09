Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2CIDbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:31:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61523 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2CIDbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:31:15 -0500
Message-ID: <1331263868.6239.6.camel@phoenix>
Subject: [PATCH] regulator: Rename s5m8767_convert_voltage to
 s5m8767_convert_voltage_to_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 09 Mar 2012 11:31:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function finds the smallest voltage that falls within the specified range,
and then returns the selector. This rename makes the intention more clear.

Also remove unneeded local variables min_vol and max_vol in s5m8767_set_voltage
and s5m8767_set_voltage_buck.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index e369d9e..d8550fb 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -294,11 +294,11 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 	return val;
 }
 
-static inline int s5m8767_convert_voltage(
+static int s5m8767_convert_voltage_to_sel(
 		const struct s5m_voltage_desc *desc,
 		int min_vol, int max_vol)
 {
-	int out_vol = 0;
+	int selector = 0;
 
 	if (desc == NULL)
 		return -EINVAL;
@@ -306,19 +306,18 @@ static inline int s5m8767_convert_voltage(
 	if (max_vol < desc->min || min_vol > desc->max)
 		return -EINVAL;
 
-	out_vol = (min_vol - desc->min) / desc->step;
+	selector = (min_vol - desc->min) / desc->step;
 
-	if (desc->min + desc->step * out_vol > max_vol)
+	if (desc->min + desc->step * selector > max_vol)
 		return -EINVAL;
 
-	return out_vol;
+	return selector;
 }
 
 static int s5m8767_set_voltage(struct regulator_dev *rdev,
 				int min_uV, int max_uV, unsigned *selector)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int min_vol = min_uV, max_vol = max_uV;
 	const struct s5m_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
 	int reg, mask, ret;
@@ -343,7 +342,7 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 
 	desc = reg_voltage_map[reg_id];
 
-	i = s5m8767_convert_voltage(desc, min_vol, max_vol);
+	i = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
 	if (i < 0)
 		return i;
 
@@ -385,7 +384,6 @@ static int s5m8767_set_voltage_buck(struct regulator_dev *rdev,
 	int reg_id = rdev_get_id(rdev);
 	const struct s5m_voltage_desc *desc;
 	int new_val, old_val, i = 0;
-	int min_vol = min_uV, max_vol = max_uV;
 
 	if (reg_id < S5M8767_BUCK1 || reg_id > S5M8767_BUCK6)
 		return -EINVAL;
@@ -402,7 +400,7 @@ static int s5m8767_set_voltage_buck(struct regulator_dev *rdev,
 	}
 
 	desc = reg_voltage_map[reg_id];
-	new_val = s5m8767_convert_voltage(desc, min_vol, max_vol);
+	new_val = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
 	if (new_val < 0)
 		return new_val;
 
@@ -580,7 +578,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < 8; i++) {
 		if (s5m8767->buck2_gpiodvs) {
 			s5m8767->buck2_vol[i] =
-				s5m8767_convert_voltage(
+				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
 						pdata->buck2_voltage[i],
 						pdata->buck2_voltage[i] +
@@ -589,7 +587,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 
 		if (s5m8767->buck3_gpiodvs) {
 			s5m8767->buck3_vol[i] =
-				s5m8767_convert_voltage(
+				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
 						pdata->buck3_voltage[i],
 						pdata->buck3_voltage[i] +
@@ -598,7 +596,7 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 
 		if (s5m8767->buck4_gpiodvs) {
 			s5m8767->buck4_vol[i] =
-				s5m8767_convert_voltage(
+				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
 						pdata->buck4_voltage[i],
 						pdata->buck4_voltage[i] +
-- 
1.7.5.4



