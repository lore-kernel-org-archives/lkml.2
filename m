Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2L2BjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 20:39:03 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:40333 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2L2BjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 20:39:01 -0500
Message-ID: <1356745130.8271.1.camel@phoenix>
Subject: [PATCH] regulator: s5m8767: Remove max_vol parameter from
 s5m8767_convert_voltage_to_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sat, 29 Dec 2012 09:38:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks pointless to pass max_vol to s5m8767_convert_voltage_to_sel().
Compare selected voltage to desc->max is enough to ensure selected voltage
is in supported range.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index eeadf58..aa0ccef 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -297,16 +297,15 @@ static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
 	return reg;
 }
 
-static int s5m8767_convert_voltage_to_sel(
-		const struct sec_voltage_desc *desc,
-		int min_vol, int max_vol)
+static int s5m8767_convert_voltage_to_sel(const struct sec_voltage_desc *desc,
+					  int min_vol)
 {
 	int selector = 0;
 
 	if (desc == NULL)
 		return -EINVAL;
 
-	if (max_vol < desc->min || min_vol > desc->max)
+	if (min_vol > desc->max)
 		return -EINVAL;
 
 	if (min_vol < desc->min)
@@ -314,7 +313,7 @@ static int s5m8767_convert_voltage_to_sel(
 
 	selector = DIV_ROUND_UP(min_vol - desc->min, desc->step);
 
-	if (desc->min + desc->step * selector > max_vol)
+	if (desc->min + desc->step * selector > desc->max)
 		return -EINVAL;
 
 	return selector;
@@ -544,23 +543,17 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	s5m8767->opmode = pdata->opmode;
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
-						pdata->buck2_init,
-						pdata->buck2_init +
-						buck_voltage_val2.step);
+						   pdata->buck2_init);
 
 	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
-						pdata->buck3_init,
-						pdata->buck3_init +
-						buck_voltage_val2.step);
+						   pdata->buck3_init);
 
 	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
 
 	buck_init = s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
-						pdata->buck4_init,
-						pdata->buck4_init +
-						buck_voltage_val2.step);
+						   pdata->buck4_init);
 
 	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
 
@@ -569,27 +562,21 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 			s5m8767->buck2_vol[i] =
 				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
-						pdata->buck2_voltage[i],
-						pdata->buck2_voltage[i] +
-						buck_voltage_val2.step);
+						pdata->buck2_voltage[i]);
 		}
 
 		if (s5m8767->buck3_gpiodvs) {
 			s5m8767->buck3_vol[i] =
 				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
-						pdata->buck3_voltage[i],
-						pdata->buck3_voltage[i] +
-						buck_voltage_val2.step);
+						pdata->buck3_voltage[i]);
 		}
 
 		if (s5m8767->buck4_gpiodvs) {
 			s5m8767->buck4_vol[i] =
 				s5m8767_convert_voltage_to_sel(
 						&buck_voltage_val2,
-						pdata->buck4_voltage[i],
-						pdata->buck4_voltage[i] +
-						buck_voltage_val2.step);
+						pdata->buck4_voltage[i]);
 		}
 	}
 
-- 
1.7.9.5



