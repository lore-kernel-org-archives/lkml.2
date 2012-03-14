Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381Ab2CNCSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:18:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56996 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab2CNCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:18:54 -0400
Message-ID: <1331691525.3782.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: Use tps65912_set_voltage_sel for both DCDCx
 and LDOx
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 14 Mar 2012 10:18:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 42b5ef "regulator: tps65912: Use simple equations to get register address"
uses tps65912_get_sel_register to replace tps65912_get_dcdc_sel_register
and tps65912_get_ldo_sel_register.

Now tps65912_set_voltage_dcdc_sel and tps65912_set_voltage_ldo_sel has exactly
the same implementation. Merge them to tps65912_set_voltage_sel function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index ede688b..988d0ec 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -442,7 +442,7 @@ static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
 	return tps65912_list_voltage_dcdc(dev, vsel);
 }
 
-static int tps65912_set_voltage_dcdc_sel(struct regulator_dev *dev,
+static int tps65912_set_voltage_sel(struct regulator_dev *dev,
 					 unsigned selector)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
@@ -472,19 +472,6 @@ static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
 	return tps65912_vsel_to_uv_ldo(vsel);
 }
 
-static int tps65912_set_voltage_ldo_sel(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
-	struct tps65912 *mfd = pmic->mfd;
-	int id = rdev_get_id(dev), reg, value;
-
-	reg = tps65912_get_sel_register(pmic, id);
-	value = tps65912_reg_read(mfd, reg);
-	value &= 0xC0;
-	return tps65912_reg_write(mfd, reg, selector | value);
-}
-
 static int tps65912_list_voltage_ldo(struct regulator_dev *dev,
 					unsigned selector)
 {
@@ -504,7 +491,7 @@ static struct regulator_ops tps65912_ops_dcdc = {
 	.set_mode = tps65912_set_mode,
 	.get_mode = tps65912_get_mode,
 	.get_voltage = tps65912_get_voltage_dcdc,
-	.set_voltage_sel = tps65912_set_voltage_dcdc_sel,
+	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage_dcdc,
 };
 
@@ -514,7 +501,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.enable = tps65912_reg_enable,
 	.disable = tps65912_reg_disable,
 	.get_voltage = tps65912_get_voltage_ldo,
-	.set_voltage_sel = tps65912_set_voltage_ldo_sel,
+	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage_ldo,
 };
 
-- 
1.7.5.4



