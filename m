Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab2FCPCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 11:02:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34615 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2FCPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 11:02:41 -0400
Message-ID: <1338735754.21662.5.camel@phoenix>
Subject: [PATCH RFT] regulator: anatop: Convert to set_voltage_sel and
 regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 03 Jun 2012 23:02:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/anatop-regulator.c |   29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 479d9ad..e9c2085 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -43,33 +43,15 @@ struct anatop_regulator {
 	struct regulator_init_data *initdata;
 };
 
-static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
-				  int max_uV, unsigned *selector)
+static int anatop_set_voltage_sel(struct regulator_dev *reg, unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	u32 val, sel, mask;
-	int uv;
-
-	uv = min_uV;
-	dev_dbg(&reg->dev, "%s: uv %d, min %d, max %d\n", __func__,
-		uv, anatop_reg->min_voltage,
-		anatop_reg->max_voltage);
-
-	if (uv < anatop_reg->min_voltage) {
-		if (max_uV > anatop_reg->min_voltage)
-			uv = anatop_reg->min_voltage;
-		else
-			return -EINVAL;
-	}
+	u32 val, mask;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	sel = DIV_ROUND_UP(uv - anatop_reg->min_voltage, 25000);
-	if (sel * 25000 + anatop_reg->min_voltage > anatop_reg->max_voltage)
-		return -EINVAL;
-	val = anatop_reg->min_bit_val + sel;
-	*selector = sel;
+	val = anatop_reg->min_bit_val + selector;
 	dev_dbg(&reg->dev, "%s: calculated val %d\n", __func__, val);
 	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
@@ -95,9 +77,10 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
 }
 
 static struct regulator_ops anatop_rops = {
-	.set_voltage     = anatop_set_voltage,
+	.set_voltage_sel = anatop_set_voltage_sel,
 	.get_voltage_sel = anatop_get_voltage_sel,
-	.list_voltage    = regulator_list_voltage_linear,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 };
 
 static int __devinit anatop_regulator_probe(struct platform_device *pdev)
-- 
1.7.9.5



