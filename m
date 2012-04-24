Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2DXBwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:52:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45557 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2DXBwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:52:41 -0400
Message-ID: <1335232352.6470.1.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: 88pm8607: Use
 regulator_get_voltage_sel_regmap()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Tue, 24 Apr 2012 09:52:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |   36 +++++++++---------------------------
 1 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index f5de1c5..c3482b9 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -27,8 +27,6 @@ struct pm8607_regulator_info {
 	unsigned int	*vol_table;
 	unsigned int	*vol_suspend;
 
-	int	vol_reg;
-	int	vol_shift;
 	int	update_reg;
 	int	update_bit;
 	int	slope_double;
@@ -224,13 +222,13 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
 static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-	uint8_t val, mask;
+	uint8_t val;
 	int ret;
 
-	val = (uint8_t)(selector << info->vol_shift);
-	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
+	val = (uint8_t)(selector << (ffs(rdev->desc->vsel_mask) - 1));
 
-	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, val);
+	ret = pm860x_set_bits(info->i2c, rdev->desc->vsel_reg,
+			      rdev->desc->vsel_mask, val);
 	if (ret)
 		return ret;
 	switch (info->desc.id) {
@@ -244,26 +242,10 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	return ret;
 }
 
-static int pm8607_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-	uint8_t val, mask;
-	int ret;
-
-	ret = pm860x_reg_read(info->i2c, info->vol_reg);
-	if (ret < 0)
-		return ret;
-
-	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
-	val = ((unsigned char)ret & mask) >> info->vol_shift;
-
-	return val;
-}
-
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
 	.set_voltage_sel = pm8607_set_voltage_sel,
-	.get_voltage_sel = pm8607_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
@@ -278,11 +260,11 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.id	= PM8607_ID_##vreg,				\
 		.owner	= THIS_MODULE,					\
 		.n_voltages = ARRAY_SIZE(vreg##_table),			\
+		.vsel_reg = PM8607_##vreg,				\
+		.vsel_mask = ARRAY_SIZE(vreg##_table) - 1,		\
 		.enable_reg = PM8607_##ereg,				\
 		.enable_mask = 1 << (ebit),				\
 	},								\
-	.vol_reg	= PM8607_##vreg,				\
-	.vol_shift	= (0),						\
 	.update_reg	= PM8607_##ureg,				\
 	.update_bit	= (ubit),					\
 	.slope_double	= (0),						\
@@ -299,11 +281,11 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.id	= PM8607_ID_LDO##_id,				\
 		.owner	= THIS_MODULE,					\
 		.n_voltages = ARRAY_SIZE(LDO##_id##_table),		\
+		.vsel_reg = PM8607_##vreg,				\
+		.vsel_mask = (ARRAY_SIZE(LDO##_id##_table) - 1) << (shift), \
 		.enable_reg = PM8607_##ereg,				\
 		.enable_mask = 1 << (ebit),				\
 	},								\
-	.vol_reg	= PM8607_##vreg,				\
-	.vol_shift	= (shift),					\
 	.slope_double	= (0),						\
 	.vol_table	= (unsigned int *)&LDO##_id##_table,		\
 	.vol_suspend	= (unsigned int *)&LDO##_id##_suspend_table,	\
-- 
1.7.5.4



