Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932Ab2COJSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:18:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53029 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599Ab2COJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:18:40 -0400
Message-ID: <1331803115.13750.1.camel@phoenix>
Subject: [PATCH 2/2] regulator: Use tps65912_get_voltage for both DCDCs and
 LDOs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 17:18:35 +0800
In-Reply-To: <1331803056.13750.0.camel@phoenix>
References: <1331803056.13750.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now tps65912_get_voltage_dcdc and tps65912_get_voltage_ldo has exactly the same
implementation. We can merge them to tps65912_get_voltage function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 46f3c61..05ea096 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -406,7 +406,7 @@ static int tps65912_list_voltage(struct regulator_dev *dev, unsigned selector)
 	return voltage;
 }
 
-static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
+static int tps65912_get_voltage(struct regulator_dev *dev)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
@@ -438,21 +438,6 @@ static int tps65912_set_voltage_sel(struct regulator_dev *dev,
 	return tps65912_reg_write(mfd, reg, selector | value);
 }
 
-static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
-{
-	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
-	struct tps65912 *mfd = pmic->mfd;
-	int id = rdev_get_id(dev);
-	int vsel = 0;
-	u8 reg;
-
-	reg = tps65912_get_sel_register(pmic, id);
-	vsel = tps65912_reg_read(mfd, reg);
-	vsel &= 0x3F;
-
-	return tps65912_vsel_to_uv_ldo(vsel);
-}
-
 /* Operations permitted on DCDCx */
 static struct regulator_ops tps65912_ops_dcdc = {
 	.is_enabled = tps65912_reg_is_enabled,
@@ -460,7 +445,7 @@ static struct regulator_ops tps65912_ops_dcdc = {
 	.disable = tps65912_reg_disable,
 	.set_mode = tps65912_set_mode,
 	.get_mode = tps65912_get_mode,
-	.get_voltage = tps65912_get_voltage_dcdc,
+	.get_voltage = tps65912_get_voltage,
 	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage,
 };
@@ -470,7 +455,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.is_enabled = tps65912_reg_is_enabled,
 	.enable = tps65912_reg_enable,
 	.disable = tps65912_reg_disable,
-	.get_voltage = tps65912_get_voltage_ldo,
+	.get_voltage = tps65912_get_voltage,
 	.set_voltage_sel = tps65912_set_voltage_sel,
 	.list_voltage = tps65912_list_voltage,
 };
-- 
1.7.5.4



