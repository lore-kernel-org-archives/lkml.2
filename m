Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0LJKKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:10:32 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45062 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158Ab0LJKK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:10:28 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 5/9] regulators: Updated ab8500 variable names, macro names and comments
Date: Fri, 10 Dec 2010 11:08:44 +0100
Message-ID: <1291975728-12525-6-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator enumeration is used for putting the regulator data
in correct place in the info array. This should be matched in the
board configuration.

Variable names are updated to be more consistent, comments are
corrected and macros have been edited to be consistent.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c |  161 ++++++++++++++++++++++---------------------
 1 files changed, 82 insertions(+), 79 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 9a3dc79..ccb0bfd 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3,18 +3,13 @@
  *
  * License Terms: GNU General Public License v2
  *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
  *
  * AB8500 peripheral regulators
  *
- * AB8500 supports the following regulators,
- * LDOs - VAUDIO, VANAMIC2/2, VDIGMIC, VINTCORE12, VTVOUT,
- *        VAUX1/2/3, VANA
- *
- * for DB8500 cut 1.0 and previous versions of the silicon, all accesses
- * to registers are through the DB8500 SPI. In cut 1.1 onwards, these
- * accesses are through the DB8500 PRCMU I2C
- *
+ * AB8500 supports the following regulators:
+ *   VAUX1/2/3, VINTCORE, VTVOUT, VAUDIO, VAMIC1/2, VDMIC, VANA
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -28,6 +23,7 @@
 
 /**
  * struct ab8500_regulator_info - ab8500 regulator information
+ * @dev: device pointer
  * @desc: regulator description
  * @regulator_dev: regulator device
  * @max_uV: maximum voltage (for variable voltage supplies)
@@ -35,12 +31,12 @@
  * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
- * @mask: mask to enable/disable regulator
- * @enable: bits to enable the regulator in normal(high power) mode
+ * @update_mask: mask to enable/disable regulator
+ * @update_val_enable: bits to enable the regulator in normal (high power) mode
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @supported_voltages: supported voltage table
+ * @voltages: supported voltage table
  * @voltages_len: number of supported voltages for the regulator
  */
 struct ab8500_regulator_info {
@@ -52,12 +48,12 @@ struct ab8500_regulator_info {
 	int fixed_uV;
 	u8 update_bank;
 	u8 update_reg;
-	u8 mask;
-	u8 enable;
+	u8 update_mask;
+	u8 update_val_enable;
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
-	int const *supported_voltages;
+	int const *voltages;
 	int voltages_len;
 };
 
@@ -112,7 +108,8 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 		return -EINVAL;
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, info->mask, info->enable);
+		info->update_bank, info->update_reg,
+		info->update_mask, info->update_val_enable);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
@@ -129,7 +126,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		return -EINVAL;
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, info->mask, 0x0);
+		info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
@@ -154,7 +152,7 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		return ret;
 	}
 
-	if (value & info->mask)
+	if (value & info->update_mask)
 		return true;
 	else
 		return false;
@@ -176,7 +174,7 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 	if (selector >= info->voltages_len)
 		return -EINVAL;
 
-	return info->supported_voltages[selector];
+	return info->voltages[selector];
 }
 
 static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
@@ -200,9 +198,9 @@ static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 	/* vintcore has a different layout */
 	value &= info->voltage_mask;
 	if (regulator_id == AB8500_LDO_INTCORE)
-		ret = info->supported_voltages[value >> 0x3];
+		ret = info->voltages[value >> 0x3];
 	else
-		ret = info->supported_voltages[value];
+		ret = info->voltages[value];
 
 	return ret;
 }
@@ -215,8 +213,8 @@ static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
 
 	/* check the supported voltage */
 	for (i = 0; i < info->voltages_len; i++) {
-		if ((info->supported_voltages[i] >= min_uV) &&
-		    (info->supported_voltages[i] <= max_uV))
+		if ((info->voltages[i] >= min_uV) &&
+		    (info->voltages[i] <= max_uV))
 			return i;
 	}
 
@@ -284,74 +282,79 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	.list_voltage	= ab8500_list_voltage,
 };
 
-#define AB8500_LDO(_id, min, max, bank, reg, reg_mask,		\
-		reg_enable, volt_bank, volt_reg, volt_mask,	\
-		voltages, len_volts)				\
-{								\
+#define AB8500_LDO(_id, _min_mV, _max_mV,			\
+	_u_bank, _u_reg, _u_mask, _u_val_enable,		\
+	_v_bank, _v_reg, _v_mask, _v_table, _v_table_len)	\
+[AB8500_LDO_##_id] = {						\
 	.desc	= {						\
-		.name	= "LDO-" #_id,				\
-		.ops	= &ab8500_regulator_ops,		\
-		.type	= REGULATOR_VOLTAGE,			\
-		.id	= AB8500_LDO_##_id,			\
-		.owner	= THIS_MODULE,				\
+		.name		= "LDO-" #_id,			\
+		.ops		= &ab8500_regulator_ops,	\
+		.type		= REGULATOR_VOLTAGE,		\
+		.id		= AB8500_LDO_##_id,		\
+		.owner		= THIS_MODULE,			\
 	},							\
-	.min_uV		= (min) * 1000,				\
-	.max_uV		= (max) * 1000,				\
-	.update_bank	= bank,					\
-	.update_reg	= reg,					\
-	.mask		= reg_mask,				\
-	.enable		= reg_enable,				\
-	.voltage_bank	= volt_bank,				\
-	.voltage_reg	= volt_reg,				\
-	.voltage_mask	= volt_mask,				\
-	.supported_voltages = voltages,				\
-	.voltages_len	= len_volts,				\
-	.fixed_uV	= 0,					\
+	.min_uV			= (_min_mV) * 1000,		\
+	.max_uV			= (_max_mV) * 1000,		\
+	.update_bank		= _u_bank,			\
+	.update_reg		= _u_reg,			\
+	.update_mask		= _u_mask,			\
+	.update_val_enable	= _u_val_enable,		\
+	.voltage_bank		= _v_bank,			\
+	.voltage_reg		= _v_reg,			\
+	.voltage_mask		= _v_mask,			\
+	.voltages		= _v_table,			\
+	.voltages_len		= _v_table_len,			\
+	.fixed_uV		= 0,				\
 }
 
-#define AB8500_FIXED_LDO(_id, fixed, bank, reg,		\
-			reg_mask, reg_enable)		\
-{							\
-	.desc	= {					\
-		.name	= "LDO-" #_id,			\
-		.ops	= &ab8500_ldo_fixed_ops,	\
-		.type	= REGULATOR_VOLTAGE,		\
-		.id	= AB8500_LDO_##_id,		\
-		.owner	= THIS_MODULE,			\
-	},						\
-	.fixed_uV	= fixed * 1000,			\
-	.update_bank	= bank,				\
-	.update_reg	= reg,				\
-	.mask		= reg_mask,			\
-	.enable		= reg_enable,			\
+#define AB8500_FIXED_LDO(_id, _fixed_mV,			\
+	_u_bank, _u_reg, _u_mask, _u_val_enable)		\
+[AB8500_LDO_##_id] = {						\
+	.desc	= {						\
+		.name		= "LDO-" #_id,			\
+		.ops		= &ab8500_ldo_fixed_ops,	\
+		.type		= REGULATOR_VOLTAGE,		\
+		.id		= AB8500_LDO_##_id,		\
+		.owner		= THIS_MODULE,			\
+	},							\
+	.fixed_uV		= (_fixed_mV) * 1000,		\
+	.update_bank		= _u_bank,			\
+	.update_reg		= _u_reg,			\
+	.update_mask		= _u_mask,			\
+	.update_val_enable	= _u_val_enable,		\
 }
 
 static struct ab8500_regulator_info ab8500_regulator_info[] = {
 	/*
-	 * Variable Voltage LDOs
-	 * name, min uV, max uV, ctrl bank, ctrl reg, reg mask, enable mask,
-	 *      volt ctrl bank, volt ctrl reg, volt ctrl mask, volt table,
-	 *      num supported volts
+	 * Variable Voltage Regulators
+	 *   name, min mV, max mV,
+	 *   update bank, reg, mask, enable val
+	 *   volt bank, reg, mask, table, table length
 	 */
-	AB8500_LDO(AUX1, 1100, 3300, 0x04, 0x09, 0x3, 0x1, 0x04, 0x1f, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX2, 1100, 3300, 0x04, 0x09, 0xc, 0x4, 0x04, 0x20, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0x7,
-			ldo_vaux3_voltages, ARRAY_SIZE(ldo_vaux3_voltages)),
-	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x44, 0x4, 0x03, 0x80, 0x38,
+	AB8500_LDO(AUX1, 1100, 3300,
+		0x04, 0x09, 0x03, 0x01, 0x04, 0x1f, 0x0f,
+		ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(AUX2, 1100, 3300,
+		0x04, 0x09, 0x0c, 0x04, 0x04, 0x20, 0x0f,
+		ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(AUX3, 1100, 3300,
+		0x04, 0x0a, 0x03, 0x01, 0x04, 0x21, 0x07,
+		ldo_vaux3_voltages, ARRAY_SIZE(ldo_vaux3_voltages)),
+	AB8500_LDO(INTCORE, 1100, 3300,
+		0x03, 0x80, 0x44, 0x04, 0x03, 0x80, 0x38,
 		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
 
 	/*
-	 * Fixed Voltage LDOs
-	 *		 name,	o/p uV, ctrl bank, ctrl reg, enable, disable
+	 * Fixed Voltage Regulators
+	 *   name, fixed mV,
+	 *   update bank, reg, mask, enable val
 	 */
-	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03,      0x80,     0x82,    0x2),
-	AB8500_FIXED_LDO(AUDIO,   2000, 0x03,      0x83,     0x2,    0x2),
-	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03,      0x83,     0x08,    0x08),
-	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03,      0x83,     0x10,    0x10),
-	AB8500_FIXED_LDO(DMIC,    1800, 0x03,      0x83,     0x04,   0x04),
-	AB8500_FIXED_LDO(ANA,     1200, 0x04,      0x06,     0xc,    0x4),
+	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03, 0x80, 0x82, 0x02),
+	AB8500_FIXED_LDO(AUDIO,   2000, 0x03, 0x83, 0x02, 0x02),
+	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03, 0x83, 0x08, 0x08),
+	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03, 0x83, 0x10, 0x10),
+	AB8500_FIXED_LDO(DMIC,    1800, 0x03, 0x83, 0x04, 0x04),
+	AB8500_FIXED_LDO(ANA,     1200, 0x04, 0x06, 0x0c, 0x04),
 };
 
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
@@ -385,7 +388,7 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 			if (info->desc.id == AB8500_LDO_AUX3) {
 				info->desc.n_voltages =
 					ARRAY_SIZE(ldo_vauxn_voltages);
-				info->supported_voltages = ldo_vauxn_voltages;
+				info->voltages = ldo_vauxn_voltages;
 				info->voltages_len =
 					ARRAY_SIZE(ldo_vauxn_voltages);
 				info->voltage_mask = 0xf;
-- 
1.7.2.2

