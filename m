Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2K0XXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:23:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2K0XXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:23:06 -0500
Message-ID: <1354058574.6138.1.camel@phoenix>
Subject: [PATCH RESEND] regulator: tps51632: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Nov 2012 07:22:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps51632-regulator.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 3460364..dce5eb3 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -106,29 +106,23 @@ static int tps51632_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 	}
 
 	vsel = data & TPS51632_VOUT_MASK;
-
-	if (vsel < TPS51632_MIN_VSEL)
-		return 0;
-	else
-		return vsel - TPS51632_MIN_VSEL;
+	return vsel;
 }
 
 static int tps51632_dcdc_set_voltage_sel(struct regulator_dev *rdev,
 		unsigned selector)
 {
 	struct tps51632_chip *tps = rdev_get_drvdata(rdev);
-	int vsel;
 	int ret;
 	unsigned int reg = TPS51632_VOLTAGE_SELECT_REG;
 
 	if (tps->enable_pwm_dvfs)
 		reg = TPS51632_VOLTAGE_BASE_REG;
 
-	vsel = selector + TPS51632_MIN_VSEL;
-	if (vsel > TPS51632_MAX_VSEL)
+	if (selector > TPS51632_MAX_VSEL)
 		return -EINVAL;
 
-	ret = regmap_write(tps->regmap, TPS51632_VOLTAGE_SELECT_REG, vsel);
+	ret = regmap_write(tps->regmap, TPS51632_VOLTAGE_SELECT_REG, selector);
 	if (ret < 0)
 		dev_err(tps->dev, "reg write failed, err %d\n", ret);
 	return ret;
@@ -254,7 +248,8 @@ static int __devinit tps51632_probe(struct i2c_client *client,
 	tps->desc.ramp_delay = TPS51632_DEFAULT_RAMP_DELAY;
 	tps->desc.min_uV = TPS51632_MIN_VOLATGE;
 	tps->desc.uV_step = TPS51632_VOLATGE_STEP_10mV;
-	tps->desc.n_voltages = (TPS51632_MAX_VSEL - TPS51632_MIN_VSEL) + 1;
+	tps->desc.linear_min_sel = TPS51632_MIN_VSEL;
+	tps->desc.n_voltages = TPS51632_MAX_VSEL + 1;
 	tps->desc.ops = &tps51632_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
-- 
1.7.9.5



