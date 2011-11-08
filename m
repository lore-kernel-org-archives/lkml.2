Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1KHNYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:24:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43146 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab1KHNYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:24:17 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH RESEND v2 2/2] regulator: TPS65910: VDD1/2 voltage selector count
Date: Tue, 8 Nov 2011 18:54:10 +0530
Message-ID: <1320758650-29180-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Count of selector voltage is required for regulator_set_voltage
to work via set_voltage_sel. VDD1/2 currently have it as zero,
so regulator_set_voltage won't work for VDD1/2.
Update count (n_voltages) for VDD1/2.

Output Voltage = (step value * 12.5 mV + 562.5 mV) * gain

With above expr, number of voltages that can be selected is
step value count * gain count

constant for gain count will be called VDD1_2_NUM_VOLT_COARSE

existing constant for step value count is VDD1_2_NUM_VOLTS,
use VDD1_2_NUM_VOLT_FINE instead to make clear that step value
is not the only component in deciding selectable voltage count

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
v2: Use macros unambigously to specify count of selectable voltage 

 drivers/regulator/tps65910-regulator.c |   14 ++++++++------
 include/linux/mfd/tps65910.h           |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index a620e25..bb2a08d 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -640,10 +640,10 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 
 	switch (id) {
 	case TPS65910_REG_VDD1:
-		dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		dcdc_mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
 		if (dcdc_mult == 1)
 			dcdc_mult--;
-		vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
+		vsel = (selector % VDD1_2_NUM_VOLT_FINE) + 3;
 
 		tps65910_modify_bits(pmic, TPS65910_VDD1,
 				(dcdc_mult << VDD1_VGAIN_SEL_SHIFT),
@@ -651,10 +651,10 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 		tps65910_reg_write(pmic, TPS65910_VDD1_OP, vsel);
 		break;
 	case TPS65910_REG_VDD2:
-		dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		dcdc_mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
 		if (dcdc_mult == 1)
 			dcdc_mult--;
-		vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
+		vsel = (selector % VDD1_2_NUM_VOLT_FINE) + 3;
 
 		tps65910_modify_bits(pmic, TPS65910_VDD2,
 				(dcdc_mult << VDD2_VGAIN_SEL_SHIFT),
@@ -732,9 +732,9 @@ static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 	switch (id) {
 	case TPS65910_REG_VDD1:
 	case TPS65910_REG_VDD2:
-		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		mult = (selector / VDD1_2_NUM_VOLT_FINE) + 1;
 		volt = VDD1_2_MIN_VOLT +
-				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+				(selector % VDD1_2_NUM_VOLT_FINE) * VDD1_2_OFFSET;
 		break;
 	case TPS65911_REG_VDDCTRL:
 		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
@@ -930,6 +930,8 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 
 		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
+			pmic->desc[i].n_voltages = VDD1_2_NUM_VOLT_FINE *
+							VDD1_2_NUM_VOLT_COARSE;
 		} else if (i == TPS65910_REG_VDD3) {
 			if (tps65910_chip_id(tps65910) == TPS65910)
 				pmic->desc[i].ops = &tps65910_ops_vdd3;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 207b8b2..cfc1f76 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -250,7 +250,8 @@
 
 
 /*Registers VDD1, VDD2 voltage values definitions */
-#define VDD1_2_NUM_VOLTS				73
+#define VDD1_2_NUM_VOLT_FINE				73
+#define VDD1_2_NUM_VOLT_COARSE				3
 #define VDD1_2_MIN_VOLT					6000
 #define VDD1_2_OFFSET					125
 
-- 
1.7.0.4

