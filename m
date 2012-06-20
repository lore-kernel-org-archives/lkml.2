Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2FTOkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:40:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2FTOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:40:17 -0400
Message-ID: <1340203210.8003.6.camel@phoenix>
Subject: [PATCH] regulator: tps65910: Convert to
 regulator_set_voltage_time_sel()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 20 Jun 2012 22:40:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   34 ++++++--------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index e1b01ec..373c529 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -824,31 +824,6 @@ static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 	return (LDO_MIN_VOLT + selector * step_mv) * 1000;
 }
 
-static int tps65910_set_voltage_dcdc_time_sel(struct regulator_dev *dev,
-		unsigned int old_selector, unsigned int new_selector)
-{
-	int id = rdev_get_id(dev);
-	int old_volt, new_volt;
-
-	old_volt = tps65910_list_voltage_dcdc(dev, old_selector);
-	if (old_volt < 0)
-		return old_volt;
-
-	new_volt = tps65910_list_voltage_dcdc(dev, new_selector);
-	if (new_volt < 0)
-		return new_volt;
-
-	/* VDD1 and VDD2 are 12.5mV/us, VDDCTRL is 100mV/20us */
-	switch (id) {
-	case TPS65910_REG_VDD1:
-	case TPS65910_REG_VDD2:
-		return DIV_ROUND_UP(abs(old_volt - new_volt), 12500);
-	case TPS65911_REG_VDDCTRL:
-		return DIV_ROUND_UP(abs(old_volt - new_volt), 5000);
-	}
-	return -EINVAL;
-}
-
 /* Regulator ops (except VRTC) */
 static struct regulator_ops tps65910_ops_dcdc = {
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -859,7 +834,7 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.get_mode		= tps65910_get_mode,
 	.get_voltage_sel	= tps65910_get_voltage_dcdc_sel,
 	.set_voltage_sel	= tps65910_set_voltage_dcdc_sel,
-	.set_voltage_time_sel	= tps65910_set_voltage_dcdc_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.list_voltage		= tps65910_list_voltage_dcdc,
 };
 
@@ -1236,11 +1211,14 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
 			pmic->desc[i].n_voltages = VDD1_2_NUM_VOLT_FINE *
 							VDD1_2_NUM_VOLT_COARSE;
+			pmic->desc[i].ramp_delay = 12500;
 		} else if (i == TPS65910_REG_VDD3) {
-			if (tps65910_chip_id(tps65910) == TPS65910)
+			if (tps65910_chip_id(tps65910) == TPS65910) {
 				pmic->desc[i].ops = &tps65910_ops_vdd3;
-			else
+			} else {
 				pmic->desc[i].ops = &tps65910_ops_dcdc;
+				pmic->desc[i].ramp_delay = 5000;
+			}
 		} else {
 			if (tps65910_chip_id(tps65910) == TPS65910)
 				pmic->desc[i].ops = &tps65910_ops;
-- 
1.7.9.5



