Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2GSHKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:10:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48215 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2GSHKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:10:42 -0400
Message-ID: <1342681831.13385.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: mc13892: Simplify implementation of
 mc13892_sw_regulator_set_voltage_sel()
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 15:10:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mc13xxx_reg_rmw rather than a mc13xxx_reg_read and a mc13xxx_reg_write calls.

This logic to set MC13892_SWITCHERS0_SWxHI bit is pretty simple:

if (volt > 1375000)
        set MC13892_SWITCHERS0_SWxHI bit
else if (volt < 1100000)
        clear MC13892_SWITCHERS0_SWxHI bit
else
        leave MC13892_SWITCHERS0_SWxHI bit untouched

We already know the selector, so we don't need to calculate the selector again.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |   42 ++++++++++++---------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index b388b74..60195b3 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -432,37 +432,25 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 						unsigned selector)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int hi, value, mask, id = rdev_get_id(rdev);
-	u32 valread;
+	int volt, mask, id = rdev_get_id(rdev);
+	u32 reg_value;
 	int ret;
 
-	value = rdev->desc->volt_table[selector];
+	volt = rdev->desc->volt_table[selector];
+	mask = mc13892_regulators[id].vsel_mask;
+	reg_value = selector << mc13892_regulators[id].vsel_shift;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_read(priv->mc13xxx,
-		mc13892_regulators[id].vsel_reg, &valread);
-	if (ret)
-		goto err;
+	if (volt > 1375000) {
+		mask |= MC13892_SWITCHERS0_SWxHI;
+		reg_value |= MC13892_SWITCHERS0_SWxHI;
+	} else if (volt < 1100000) {
+		mask |= MC13892_SWITCHERS0_SWxHI;
+		reg_value &= ~MC13892_SWITCHERS0_SWxHI;
+	}
 
-	if (value > 1375000)
-		hi = 1;
-	else if (value < 1100000)
-		hi = 0;
-	else
-		hi = valread & MC13892_SWITCHERS0_SWxHI;
-
-	if (hi) {
-		value = (value - 1100000) / 25000;
-		value |= MC13892_SWITCHERS0_SWxHI;
-	} else
-		value = (value - 600000) / 25000;
-
-	mask = mc13892_regulators[id].vsel_mask | MC13892_SWITCHERS0_SWxHI;
-	valread = (valread & ~mask) |
-			(value << mc13892_regulators[id].vsel_shift);
-	ret = mc13xxx_reg_write(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
-			valread);
-err:
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].reg, mask,
+			      reg_value);
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
-- 
1.7.9.5



