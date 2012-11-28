Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab2K1CTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:19:16 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34941 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2K1CTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:19:15 -0500
Message-ID: <1354069143.12957.3.camel@phoenix>
Subject: [PATCH RFT] regulator: pcf50633: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Balaji Rao <balajirrao@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 28 Nov 2012 10:19:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be converted to use linear_min_sel and
regulator_[map|list]_voltage_linear.

Below shows the equations from datasheet:

For AUTOOUT:
        VO(prog) = 0.625 + auto_out × 0.025 V; e.g.
        (00000000 to 00101110: reserved)
        00101111: 1.8 V (min)
        01010011: 2.7 V
        01101010: 3.275 V
        01101011: 3.300 V
        01101100: 3.325 V
        01111111 : 3.800 V (max)

        The linear mapping start from 0x2f selector.

        Thus convert this equation to:
        VO(prog) = 1.8 + (selector - linear_min_sel) × 0.025 V,
        (min_uV = 1800000, uV_step = 25000, linear_min_sel = 0x2f)

For DOWNxOUT:
        VO(prog) = 0.625 + downx_out × 0.025 V; e.g.
        00000000 : 0.625 V (min)
        00010111 : 1.200 V
        00101111 : 1.800 V
        01011111 : 3.000 V (max)

For xLDOOUT:
        VO(prog) = 0.9 + xldo_out × 0.1 V; e.g.
        00000: 0.9 V
        00001: 1.0 V
        11000 : 3.3 V
        11011 : 3.6 V

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pcf50633-regulator.c |  176 +++++---------------------------
 1 file changed, 28 insertions(+), 148 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index d776f51..534075e 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -24,12 +24,15 @@
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/pmic.h>
 
-#define PCF50633_REGULATOR(_name, _id, _n)			\
+#define PCF50633_REGULATOR(_name, _id, _min_uV, _uV_step, _min_sel, _n) \
 	{							\
 		.name = _name,					\
 		.id = PCF50633_REGULATOR_##_id,			\
 		.ops = &pcf50633_regulator_ops,			\
 		.n_voltages = _n,				\
+		.min_uV = _min_uV,				\
+		.uV_step = _uV_step,				\
+		.linear_min_sel = _min_sel,			\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
 		.vsel_reg = PCF50633_REG_##_id##OUT,		\
@@ -38,162 +41,39 @@
 		.enable_mask = PCF50633_REGULATOR_ON,		\
 	}
 
-/* Bits from voltage value */
-static u8 auto_voltage_bits(unsigned int millivolts)
-{
-	if (millivolts < 1800)
-		return 0x2f;
-	if (millivolts > 3800)
-		return 0xff;
-
-	millivolts -= 625;
-
-	return millivolts / 25;
-}
-
-static u8 down_voltage_bits(unsigned int millivolts)
-{
-	if (millivolts < 625)
-		return 0;
-	else if (millivolts > 3000)
-		return 0xff;
-
-	millivolts -= 625;
-
-	return millivolts / 25;
-}
-
-static u8 ldo_voltage_bits(unsigned int millivolts)
-{
-	if (millivolts < 900)
-		return 0;
-	else if (millivolts > 3600)
-		return 0x1f;
-
-	millivolts -= 900;
-	return millivolts / 100;
-}
-
-/* Obtain voltage value from bits */
-static unsigned int auto_voltage_value(u8 bits)
-{
-	/* AUTOOUT: 00000000 to 00101110 are reserved.
-	 * Return 0 for bits in reserved range, which means this selector code
-	 * can't be used on this system */
-	if (bits < 0x2f)
-		return 0;
-
-	return 625 + (bits * 25);
-}
-
-
-static unsigned int down_voltage_value(u8 bits)
-{
-	return 625 + (bits * 25);
-}
-
-
-static unsigned int ldo_voltage_value(u8 bits)
-{
-	bits &= 0x1f;
-
-	return 900 + (bits * 100);
-}
-
-static int pcf50633_regulator_map_voltage(struct regulator_dev *rdev,
-					  int min_uV, int max_uV)
-{
-	struct pcf50633 *pcf;
-	int regulator_id, millivolts;
-	u8 volt_bits;
-
-	pcf = rdev_get_drvdata(rdev);
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	millivolts = min_uV / 1000;
-
-	switch (regulator_id) {
-	case PCF50633_REGULATOR_AUTO:
-		volt_bits = auto_voltage_bits(millivolts);
-		break;
-	case PCF50633_REGULATOR_DOWN1:
-	case PCF50633_REGULATOR_DOWN2:
-		volt_bits = down_voltage_bits(millivolts);
-		break;
-	case PCF50633_REGULATOR_LDO1:
-	case PCF50633_REGULATOR_LDO2:
-	case PCF50633_REGULATOR_LDO3:
-	case PCF50633_REGULATOR_LDO4:
-	case PCF50633_REGULATOR_LDO5:
-	case PCF50633_REGULATOR_LDO6:
-	case PCF50633_REGULATOR_HCLDO:
-	case PCF50633_REGULATOR_MEMLDO:
-		volt_bits = ldo_voltage_bits(millivolts);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return volt_bits;
-}
-
-static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
-						unsigned int index)
-{
-	int regulator_id = rdev_get_id(rdev);
-
-	int millivolts;
-
-	switch (regulator_id) {
-	case PCF50633_REGULATOR_AUTO:
-		millivolts = auto_voltage_value(index);
-		break;
-	case PCF50633_REGULATOR_DOWN1:
-	case PCF50633_REGULATOR_DOWN2:
-		millivolts = down_voltage_value(index);
-		break;
-	case PCF50633_REGULATOR_LDO1:
-	case PCF50633_REGULATOR_LDO2:
-	case PCF50633_REGULATOR_LDO3:
-	case PCF50633_REGULATOR_LDO4:
-	case PCF50633_REGULATOR_LDO5:
-	case PCF50633_REGULATOR_LDO6:
-	case PCF50633_REGULATOR_HCLDO:
-	case PCF50633_REGULATOR_MEMLDO:
-		millivolts = ldo_voltage_value(index);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return millivolts * 1000;
-}
-
 static struct regulator_ops pcf50633_regulator_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.list_voltage = pcf50633_regulator_list_voltage,
-	.map_voltage = pcf50633_regulator_map_voltage,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static const struct regulator_desc regulators[] = {
-	[PCF50633_REGULATOR_AUTO] = PCF50633_REGULATOR("auto", AUTO, 128),
-	[PCF50633_REGULATOR_DOWN1] = PCF50633_REGULATOR("down1", DOWN1, 96),
-	[PCF50633_REGULATOR_DOWN2] = PCF50633_REGULATOR("down2", DOWN2, 96),
-	[PCF50633_REGULATOR_LDO1] = PCF50633_REGULATOR("ldo1", LDO1, 28),
-	[PCF50633_REGULATOR_LDO2] = PCF50633_REGULATOR("ldo2", LDO2, 28),
-	[PCF50633_REGULATOR_LDO3] = PCF50633_REGULATOR("ldo3", LDO3, 28),
-	[PCF50633_REGULATOR_LDO4] = PCF50633_REGULATOR("ldo4", LDO4, 28),
-	[PCF50633_REGULATOR_LDO5] = PCF50633_REGULATOR("ldo5", LDO5, 28),
-	[PCF50633_REGULATOR_LDO6] = PCF50633_REGULATOR("ldo6", LDO6, 28),
-	[PCF50633_REGULATOR_HCLDO] = PCF50633_REGULATOR("hcldo", HCLDO, 28),
-	[PCF50633_REGULATOR_MEMLDO] = PCF50633_REGULATOR("memldo", MEMLDO, 28),
+	[PCF50633_REGULATOR_AUTO] =
+		PCF50633_REGULATOR("auto", AUTO, 1800000, 25000, 0x2f, 128),
+	[PCF50633_REGULATOR_DOWN1] =
+		PCF50633_REGULATOR("down1", DOWN1, 625000, 25000, 0, 96),
+	[PCF50633_REGULATOR_DOWN2] =
+		PCF50633_REGULATOR("down2", DOWN2, 625000, 25000, 0, 96),
+	[PCF50633_REGULATOR_LDO1] =
+		PCF50633_REGULATOR("ldo1", LDO1, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_LDO2] =
+		PCF50633_REGULATOR("ldo2", LDO2, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_LDO3] =
+		PCF50633_REGULATOR("ldo3", LDO3, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_LDO4] =
+		PCF50633_REGULATOR("ldo4", LDO4, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_LDO5] =
+		PCF50633_REGULATOR("ldo5", LDO5, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_LDO6] =
+		PCF50633_REGULATOR("ldo6", LDO6, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_HCLDO] =
+		PCF50633_REGULATOR("hcldo", HCLDO, 900000, 100000, 0, 28),
+	[PCF50633_REGULATOR_MEMLDO] =
+		PCF50633_REGULATOR("memldo", MEMLDO, 900000, 100000, 0, 28),
 };
 
 static int pcf50633_regulator_probe(struct platform_device *pdev)
-- 
1.7.9.5



