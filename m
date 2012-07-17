Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2GQGrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:47:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2GQGrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:47:36 -0400
Message-ID: <1342507641.18110.1.camel@phoenix>
Subject: [PATCH RFT] regulator: s2mps11: Fix ramp_delay settings for
 s2mps11_buck_ops
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jul 2012 14:47:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramp_delay settings were missing while converting to
regulator_set_voltage_time_sel(). Fix it.

There is no ramp_delay setting for s2mps11_ldo_ops, thus remove
setting set_voltage_sel callback for s2mps11_ldo_ops.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s2mps11.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 4669dc9..b0f7ac1 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -62,7 +62,6 @@ static struct regulator_ops s2mps11_ldo_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops s2mps11_buck_ops = {
@@ -291,6 +290,32 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
+		struct regulator_desc *desc = &regulators[i];
+
+		switch (i) {
+		case S2MPS11_BUCK1:
+		case S2MPS11_BUCK6:
+			desc->ramp_delay = pdata->buck16_ramp_delay * 1000;
+			break;
+		case S2MPS11_BUCK2:
+			desc->ramp_delay = pdata->buck2_ramp_delay * 1000;
+			break;
+		case S2MPS11_BUCK3:
+		case S2MPS11_BUCK4:
+			desc->ramp_delay = pdata->buck34_ramp_delay * 1000;
+			break;
+		case S2MPS11_BUCK5:
+			desc->ramp_delay = pdata->buck5_ramp_delay * 1000;
+			break;
+		case S2MPS11_BUCK7:
+		case S2MPS11_BUCK8:
+		case S2MPS11_BUCK10:
+			desc->ramp_delay = pdata->buck7810_ramp_delay * 1000;
+			break;
+		case S2MPS11_BUCK9:
+			desc->ramp_delay = pdata->buck9_ramp_delay * 1000;
+			break;
+		}
 
 		config.dev = &pdev->dev;
 		config.regmap = iodev->regmap;
-- 
1.7.9.5



