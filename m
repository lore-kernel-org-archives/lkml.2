Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab2CPNgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:36:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65062 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2CPNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:36:52 -0400
Message-ID: <1331905005.2891.2.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: Convert pcf50633 to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 16 Mar 2012 21:36:45 +0800
In-Reply-To: <1331904943.2891.1.camel@phoenix>
References: <1331904943.2891.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pcf50633 to get_voltage_sel and then we can remove
pcf50633_regulator_voltage_value function and move its implementation
to pcf50633_regulator_list_voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |   65 ++++++++++++++-----------------
 1 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 3cefc63..5c712e5 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -151,23 +151,43 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 	return pcf50633_reg_write(pcf, regnr, volt_bits);
 }
 
-static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
-						u8 bits)
+static int pcf50633_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
+	struct pcf50633 *pcf;
+	int regulator_id;
+	u8 volt_bits, regnr;
+
+	pcf = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	regnr = pcf50633_regulator_registers[regulator_id];
+
+	volt_bits = pcf50633_reg_read(pcf, regnr);
+
+	return volt_bits;
+}
+
+static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
+						unsigned int index)
+{
+	int regulator_id = rdev_get_id(rdev);
 	int millivolts;
 
-	switch (id) {
+	switch (regulator_id) {
 	case PCF50633_REGULATOR_AUTO:
 		/* AUTOOUT: 00000000 to 00101110 are reserved */
-		if (bits < 0x2f)
+		if (index < 0x2f)
 			return -EINVAL;
-		millivolts = auto_voltage_value(bits);
+		millivolts = auto_voltage_value(index);
 		break;
 	case PCF50633_REGULATOR_DOWN1:
-		millivolts = down_voltage_value(bits);
+		millivolts = down_voltage_value(index);
 		break;
 	case PCF50633_REGULATOR_DOWN2:
-		millivolts = down_voltage_value(bits);
+		millivolts = down_voltage_value(index);
 		break;
 	case PCF50633_REGULATOR_LDO1:
 	case PCF50633_REGULATOR_LDO2:
@@ -177,7 +197,7 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
 	case PCF50633_REGULATOR_LDO6:
 	case PCF50633_REGULATOR_HCLDO:
 	case PCF50633_REGULATOR_MEMLDO:
-		millivolts = ldo_voltage_value(bits);
+		millivolts = ldo_voltage_value(index);
 		break;
 	default:
 		return -EINVAL;
@@ -186,33 +206,6 @@ static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
 	return millivolts * 1000;
 }
 
-static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
-{
-	struct pcf50633 *pcf;
-	int regulator_id;
-	u8 volt_bits, regnr;
-
-	pcf = rdev_get_drvdata(rdev);
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	regnr = pcf50633_regulator_registers[regulator_id];
-
-	volt_bits = pcf50633_reg_read(pcf, regnr);
-
-	return pcf50633_regulator_voltage_value(regulator_id, volt_bits);
-}
-
-static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
-						unsigned int index)
-{
-	int regulator_id = rdev_get_id(rdev);
-
-	return pcf50633_regulator_voltage_value(regulator_id, index);
-}
-
 static int pcf50633_regulator_enable(struct regulator_dev *rdev)
 {
 	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
@@ -265,7 +258,7 @@ static int pcf50633_regulator_is_enabled(struct regulator_dev *rdev)
 
 static struct regulator_ops pcf50633_regulator_ops = {
 	.set_voltage = pcf50633_regulator_set_voltage,
-	.get_voltage = pcf50633_regulator_get_voltage,
+	.get_voltage_sel = pcf50633_regulator_get_voltage_sel,
 	.list_voltage = pcf50633_regulator_list_voltage,
 	.enable = pcf50633_regulator_enable,
 	.disable = pcf50633_regulator_disable,
-- 
1.7.5.4



