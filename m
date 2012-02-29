Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778Ab2B2Ep5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 23:45:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965408Ab2B2Epu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 23:45:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.194.193 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330490735.7885.2.camel@phoenix>
Subject: [PATCH RFC] regulator: Fix n_voltage settings for pcf50633 regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 29 Feb 2012 12:45:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has off-by-one n_voltage settings for AUTO/DOWN*/LDO* regulators.

Take ldo1 as example:
n_voltage should be (3.6 - 0.9) / 0.1 + 1 = 28

Table 76. LDO1OUT - LDO1 output voltage select register (address 2Dh) bit description[1]
Bit Symbol Access Description
4:0 ldo1_out R/W VO(prog) = 0.9 + ldo1_out × 0.1 V (max 3.6V); e.g.
00000 : 0.9 V
00001 : 1.0 V
11000 : 3.3 V
11011 : 3.6 V
11111 : 3.6 V

The n_voltage settings for HCLDO and MEMLDO are also wrong.
n_voltage for HCLDO and MEMLDO should be (3.6 - 0.9) / 0.1 + 1 = 28

Table 88. HCLDOOUT - HCLDO output voltage select register (addr. 39h) bit description[1]
Bit Symbol Access Description
4:0 hcldo_out R/W VO(prog) = 0.9 + hcldo_out × 0.1 V (max 3.6 V); e.g.
00000 : 0.9 V
00001 : 1.0 V
11011 : 3.6 V
11111 : 3.6 V

Table 62. MEMLDOOUT - MEMLDO o/p voltage select reg. (address 26h) bit description[1]
Bit Symbol Access Description
4:0 memldo_out R/W VO(prog) = 0.9 + memldo_out × 0.1 V; e.g.
00000: 0.9 V
00001: 1.0 V
11000 : 3.3 V
11011 : 3.6 V
11111 : 3.6 V

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Lars,
I found in your commit a6576cf
"Regulator: Implement list_voltage for pcf50633 regulator driver",
you added index += 0x01 for case PCF50633_REGULATOR_HCLDO in pcf50633_regulator_list_voltage.
And you also set n_voltages for HCLDO to be 26 which is different from other LDOs.
Why HCLDO is special?
And why n_voltage for MEMLDO is 0?

According to the datasheet, the equation to get voltage from the bits should be
the same for HCLDO/MEMLDO/LDOs.

I just check the code with datasheet, I'd appreciate if someone can the this patch.

Thanks,
Axel

 drivers/regulator/pcf50633-regulator.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 1d1c310..6db46c6 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -142,6 +142,7 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 	case PCF50633_REGULATOR_LDO5:
 	case PCF50633_REGULATOR_LDO6:
 	case PCF50633_REGULATOR_HCLDO:
+	case PCF50633_REGULATOR_MEMLDO:
 		volt_bits = ldo_voltage_bits(millivolts);
 		break;
 	default:
@@ -175,6 +176,7 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
 	case PCF50633_REGULATOR_LDO5:
 	case PCF50633_REGULATOR_LDO6:
 	case PCF50633_REGULATOR_HCLDO:
+	case PCF50633_REGULATOR_MEMLDO:
 		millivolts = ldo_voltage_value(bits);
 		break;
 	default:
@@ -217,9 +219,6 @@ static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 	case PCF50633_REGULATOR_AUTO:
 		index += 0x2f;
 		break;
-	case PCF50633_REGULATOR_HCLDO:
-		index += 0x01;
-		break;
 	default:
 		break;
 	}
@@ -288,27 +287,27 @@ static struct regulator_ops pcf50633_regulator_ops = {
 
 static struct regulator_desc regulators[] = {
 	[PCF50633_REGULATOR_AUTO] =
-		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 80),
+		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 81),
 	[PCF50633_REGULATOR_DOWN1] =
-		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1, 95),
+		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1, 96),
 	[PCF50633_REGULATOR_DOWN2] =
-		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2, 95),
+		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2, 96),
 	[PCF50633_REGULATOR_LDO1] =
-		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1, 27),
+		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1, 28),
 	[PCF50633_REGULATOR_LDO2] =
-		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2, 27),
+		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2, 28),
 	[PCF50633_REGULATOR_LDO3] =
-		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3, 27),
+		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3, 28),
 	[PCF50633_REGULATOR_LDO4] =
-		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4, 27),
+		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4, 28),
 	[PCF50633_REGULATOR_LDO5] =
-		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5, 27),
+		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5, 28),
 	[PCF50633_REGULATOR_LDO6] =
-		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6, 27),
+		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6, 28),
 	[PCF50633_REGULATOR_HCLDO] =
-		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO, 26),
+		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO, 28),
 	[PCF50633_REGULATOR_MEMLDO] =
-		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO, 0),
+		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO, 28),
 };
 
 static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
-- 
1.7.5.4



