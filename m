Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab2LIAHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 19:07:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2LIAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 19:07:51 -0500
Message-ID: <1355011663.3283.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: anatop: Use
 regulator_[get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 09 Dec 2012 08:07:43 +0800
In-Reply-To: <1355011545.3283.1.camel@phoenix>
References: <1355011545.3283.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call regulator_[get|set]_voltage_sel_regmap instead of open code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/anatop-regulator.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 645a42d..0199eee 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -48,34 +48,21 @@ static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
 					unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	u32 mask;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
-		anatop_reg->vol_bit_shift;
-	selector <<= anatop_reg->vol_bit_shift;
-	regmap_update_bits(anatop_reg->anatop, anatop_reg->control_reg,
-				mask, selector);
-
-	return 0;
+	return regulator_set_voltage_sel_regmap(reg, selector);
 }
 
 static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	u32 val, mask;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
-	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
-		anatop_reg->vol_bit_shift;
-	val = (val & mask) >> anatop_reg->vol_bit_shift;
-
-	return val;
+	return regulator_get_voltage_sel_regmap(reg);
 }
 
 static struct regulator_ops anatop_rops = {
@@ -161,11 +148,15 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	rdesc->min_uV = sreg->min_voltage;
 	rdesc->uV_step = 25000;
 	rdesc->linear_min_sel = sreg->min_bit_val;
+	rdesc->vsel_reg = sreg->control_reg;
+	rdesc->vsel_mask = ((1 << sreg->vol_bit_width) - 1) <<
+			   sreg->vol_bit_shift;
 
 	config.dev = &pdev->dev;
 	config.init_data = initdata;
 	config.driver_data = sreg;
 	config.of_node = pdev->dev.of_node;
+	config.regmap = sreg->anatop;
 
 	/* register regulator */
 	rdev = regulator_register(rdesc, &config);
-- 
1.7.9.5



