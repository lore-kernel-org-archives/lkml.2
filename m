Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2FKGoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:44:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40683 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2FKGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:44:06 -0400
Message-ID: <1339397037.18866.1.camel@phoenix>
Subject: [PATCH RFT] regulator: pcf50633: Convert to
 regulator_set_voltage_sel_regmap and map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 14:43:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 3c9d14c..092e5cb 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -100,13 +100,12 @@ static unsigned int ldo_voltage_value(u8 bits)
 	return 900 + (bits * 100);
 }
 
-static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
-					  int min_uV, int max_uV,
-					  unsigned *selector)
+static int pcf50633_regulator_map_voltage(struct regulator_dev *rdev,
+					  int min_uV, int max_uV)
 {
 	struct pcf50633 *pcf;
 	int regulator_id, millivolts;
-	u8 volt_bits, regnr;
+	u8 volt_bits;
 
 	pcf = rdev_get_drvdata(rdev);
 
@@ -116,15 +115,11 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 
 	millivolts = min_uV / 1000;
 
-	regnr = rdev->desc->vsel_reg;
-
 	switch (regulator_id) {
 	case PCF50633_REGULATOR_AUTO:
 		volt_bits = auto_voltage_bits(millivolts);
 		break;
 	case PCF50633_REGULATOR_DOWN1:
-		volt_bits = down_voltage_bits(millivolts);
-		break;
 	case PCF50633_REGULATOR_DOWN2:
 		volt_bits = down_voltage_bits(millivolts);
 		break;
@@ -142,9 +137,7 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	*selector = volt_bits;
-
-	return pcf50633_reg_write(pcf, regnr, volt_bits);
+	return volt_bits;
 }
 
 static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
@@ -159,8 +152,6 @@ static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 		millivolts = auto_voltage_value(index);
 		break;
 	case PCF50633_REGULATOR_DOWN1:
-		millivolts = down_voltage_value(index);
-		break;
 	case PCF50633_REGULATOR_DOWN2:
 		millivolts = down_voltage_value(index);
 		break;
@@ -182,9 +173,10 @@ static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops pcf50633_regulator_ops = {
-	.set_voltage = pcf50633_regulator_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = pcf50633_regulator_list_voltage,
+	.map_voltage = pcf50633_regulator_map_voltage,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
-- 
1.7.9.5



