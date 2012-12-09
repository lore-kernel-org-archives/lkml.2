Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2LIAF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 19:05:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37010 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2LIAF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 19:05:57 -0500
Message-ID: <1355011545.3283.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: anatop: Use linear_min_sel with linear
 mapping
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 09 Dec 2012 08:05:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting linear_min_sel to anatop_reg->min_bit_val, we can avoid
adjust the anatop_reg->min_bit_val offset in [set|get]_voltage_sel.

With this chance we can refactor this driver to use
regulator_[get|set]_voltage_sel_regmap.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/anatop-regulator.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 1aa5246..645a42d 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -48,18 +48,16 @@ static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
 					unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
-	u32 val, mask;
+	u32 mask;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	val = anatop_reg->min_bit_val + selector;
-	dev_dbg(&reg->dev, "%s: calculated val %d\n", __func__, val);
 	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
 		anatop_reg->vol_bit_shift;
-	val <<= anatop_reg->vol_bit_shift;
+	selector <<= anatop_reg->vol_bit_shift;
 	regmap_update_bits(anatop_reg->anatop, anatop_reg->control_reg,
-				mask, val);
+				mask, selector);
 
 	return 0;
 }
@@ -77,7 +75,7 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 		anatop_reg->vol_bit_shift;
 	val = (val & mask) >> anatop_reg->vol_bit_shift;
 
-	return val - anatop_reg->min_bit_val;
+	return val;
 }
 
 static struct regulator_ops anatop_rops = {
@@ -158,10 +156,11 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 		goto anatop_probe_end;
 	}
 
-	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage)
-		/ 25000 + 1;
+	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage) / 25000 + 1
+			    + sreg->min_bit_val;
 	rdesc->min_uV = sreg->min_voltage;
 	rdesc->uV_step = 25000;
+	rdesc->linear_min_sel = sreg->min_bit_val;
 
 	config.dev = &pdev->dev;
 	config.init_data = initdata;
-- 
1.7.9.5



