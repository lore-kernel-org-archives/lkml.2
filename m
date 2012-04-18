Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DRCwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:52:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50325 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2DRCwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:52:04 -0400
Message-ID: <1334717519.12560.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: pcf50633: Use
 regulator_get_voltage_sel_regmap()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 10:51:59 +0800
In-Reply-To: <1334717437.12560.1.camel@phoenix>
References: <1334717437.12560.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |   37 +++----------------------------
 1 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 5887505..3c9d14c 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -32,24 +32,12 @@
 		.n_voltages = _n,				\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
+		.vsel_reg = PCF50633_REG_##_id##OUT,		\
+		.vsel_mask = 0xff,				\
 		.enable_reg = PCF50633_REG_##_id##OUT + 1,	\
 		.enable_mask = PCF50633_REGULATOR_ON,		\
 	}
 
-static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
-	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
-	[PCF50633_REGULATOR_DOWN1]	= PCF50633_REG_DOWN1OUT,
-	[PCF50633_REGULATOR_DOWN2]	= PCF50633_REG_DOWN2OUT,
-	[PCF50633_REGULATOR_MEMLDO]	= PCF50633_REG_MEMLDOOUT,
-	[PCF50633_REGULATOR_LDO1]	= PCF50633_REG_LDO1OUT,
-	[PCF50633_REGULATOR_LDO2]	= PCF50633_REG_LDO2OUT,
-	[PCF50633_REGULATOR_LDO3]	= PCF50633_REG_LDO3OUT,
-	[PCF50633_REGULATOR_LDO4]	= PCF50633_REG_LDO4OUT,
-	[PCF50633_REGULATOR_LDO5]	= PCF50633_REG_LDO5OUT,
-	[PCF50633_REGULATOR_LDO6]	= PCF50633_REG_LDO6OUT,
-	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
-};
-
 /* Bits from voltage value */
 static u8 auto_voltage_bits(unsigned int millivolts)
 {
@@ -128,7 +116,7 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 
 	millivolts = min_uV / 1000;
 
-	regnr = pcf50633_regulator_registers[regulator_id];
+	regnr = rdev->desc->vsel_reg;
 
 	switch (regulator_id) {
 	case PCF50633_REGULATOR_AUTO:
@@ -159,23 +147,6 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 	return pcf50633_reg_write(pcf, regnr, volt_bits);
 }
 
-static int pcf50633_regulator_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct pcf50633 *pcf;
-	int regulator_id;
-	u8 regnr;
-
-	pcf = rdev_get_drvdata(rdev);
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	regnr = pcf50633_regulator_registers[regulator_id];
-
-	return pcf50633_reg_read(pcf, regnr);
-}
-
 static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 						unsigned int index)
 {
@@ -212,7 +183,7 @@ static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 
 static struct regulator_ops pcf50633_regulator_ops = {
 	.set_voltage = pcf50633_regulator_set_voltage,
-	.get_voltage_sel = pcf50633_regulator_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = pcf50633_regulator_list_voltage,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-- 
1.7.5.4



