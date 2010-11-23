Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0KWS3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:29:06 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:56172 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab0KWS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:29:03 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 2/3] regulators: Update of ab8500 driver
Date: Tue, 23 Nov 2010 19:25:53 +0100
Message-ID: <1290536754-21775-3-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the driver with some bug fixes, support
for v2 hardware, support for regulator_count_voltages,
changes for reading the board config, added indexing of
the regulator array and added debug prints.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500.c       |  446 +++++++++++++++++++++++++++-----------
 include/linux/regulator/ab8500.h |   27 ++-
 2 files changed, 330 insertions(+), 143 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 2f4ec0f..9d8f632 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3,19 +3,15 @@
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
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
@@ -28,38 +24,37 @@
 
 /**
  * struct ab8500_regulator_info - ab8500 regulator information
+ * @dev: device pointer
  * @desc: regulator description
- * @ab8500: ab8500 parent
  * @regulator_dev: regulator device
  * @max_uV: maximum voltage (for variable voltage supplies)
  * @min_uV: minimum voltage (for variable voltage supplies)
  * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
- * @mask: mask to enable/disable regulator
- * @enable: bits to enable the regulator in normal(high power) mode
+ * @update_mask: mask to enable/disable regulator
+ * @update_enable: bits to enable the regulator in normal (high power) mode
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @supported_voltages: supported voltage table
+ * @voltages: supported voltage table
  * @voltages_len: number of supported voltages for the regulator
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
 	struct regulator_desc	desc;
-	struct ab8500		*ab8500;
 	struct regulator_dev	*regulator;
 	int max_uV;
 	int min_uV;
 	int fixed_uV;
 	u8 update_bank;
 	u8 update_reg;
-	u8 mask;
-	u8 enable;
+	u8 update_mask;
+	u8 update_enable;
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
-	int const *supported_voltages;
+	int const *voltages;
 	int voltages_len;
 };
 
@@ -83,6 +78,17 @@ static const int ldo_vauxn_voltages[] = {
 	3300000,
 };
 
+static const int ldo_vaux3_voltages[] = {
+	1200000,
+	1500000,
+	1800000,
+	2100000,
+	2500000,
+	2750000,
+	2790000,
+	2910000,
+};
+
 static const int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
@@ -95,57 +101,81 @@ static const int ldo_vintcore_voltages[] = {
 
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, info->mask, info->enable);
+		info->update_bank, info->update_reg,
+		info->update_mask, info->update_enable);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, info->update_enable);
+
 	return ret;
 }
 
 static int ab8500_regulator_disable(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, info->mask, 0x0);
+		info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, 0x0);
+
 	return ret;
 }
 
 static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	u8 value;
+	u8 regval;
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	ret = abx500_get_register_interruptible(info->dev,
-		info->update_bank, info->update_reg, &value);
+			info->update_bank, info->update_reg, &regval);
+
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't read 0x%x register\n", info->update_reg);
 		return ret;
 	}
 
-	if (value & info->mask)
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-is_enabled (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->update_bank, info->update_reg,
+		info->update_mask, regval);
+
+	if (regval & info->update_mask)
 		return true;
 	else
 		return false;
@@ -153,12 +183,12 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 
 static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 {
-	int regulator_id;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	/* return the uV for the fixed regulators */
 	if (info->fixed_uV)
@@ -167,33 +197,40 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 	if (selector >= info->voltages_len)
 		return -EINVAL;
 
-	return info->supported_voltages[selector];
+	return info->voltages[selector];
 }
 
 static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 {
-	int regulator_id, ret;
+	int ret, val;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	u8 value;
+	u8 regval;
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
-	ret = abx500_get_register_interruptible(info->dev, info->voltage_bank,
-		info->voltage_reg, &value);
+	ret = abx500_get_register_interruptible(info->dev,
+			info->voltage_bank, info->voltage_reg, &regval);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't read voltage reg for regulator\n");
 		return ret;
 	}
 
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-get_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->voltage_bank, info->voltage_reg,
+		info->voltage_mask, regval);
+
 	/* vintcore has a different layout */
-	value &= info->voltage_mask;
-	if (regulator_id == AB8500_LDO_INTCORE)
-		ret = info->supported_voltages[value >> 0x3];
+	val = regval & info->voltage_mask;
+	if (info->desc.id == AB8500_REGULATOR_INTCORE)
+		ret = info->voltages[val >> 0x3];
 	else
-		ret = info->supported_voltages[value];
+		ret = info->voltages[val];
 
 	return ret;
 }
@@ -204,10 +241,15 @@ static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 	int i;
 
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
 	/* check the supported voltage */
 	for (i = 0; i < info->voltages_len; i++) {
-		if ((info->supported_voltages[i] >= min_uV) &&
-		    (info->supported_voltages[i] <= max_uV))
+		if ((info->voltages[i] >= min_uV) &&
+		    (info->voltages[i] <= max_uV))
 			return i;
 	}
 
@@ -218,12 +260,14 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 					int min_uV, int max_uV,
 					unsigned *selector)
 {
-	int regulator_id, ret;
+	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	/* get the appropriate voltages within the range */
 	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
@@ -236,13 +280,20 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 	*selector = ret;
 
 	/* set the registers for the request */
+	regval = (u8)ret;
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->voltage_bank, info->voltage_reg,
-		info->voltage_mask, (u8)ret);
+		info->voltage_mask, regval);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 		"couldn't set voltage reg for regulator\n");
 
+	dev_vdbg(rdev_get_dev(rdev),
+		"%s-set_voltage (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
+		" 0x%x\n",
+		info->desc.name, info->voltage_bank, info->voltage_reg,
+		info->voltage_mask, regval);
+
 	return ret;
 }
 
@@ -257,17 +308,17 @@ static struct regulator_ops ab8500_regulator_ops = {
 
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
 {
-	int regulator_id;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= AB8500_NUM_REGULATORS)
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
 		return -EINVAL;
+	}
 
 	return info->fixed_uV;
 }
 
-static struct regulator_ops ab8500_ldo_fixed_ops = {
+static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
@@ -275,112 +326,238 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	.list_voltage	= ab8500_list_voltage,
 };
 
-#define AB8500_LDO(_id, min, max, bank, reg, reg_mask,		\
-		reg_enable, volt_bank, volt_reg, volt_mask,	\
-		voltages, len_volts)				\
-{								\
-	.desc	= {						\
-		.name	= "LDO-" #_id,				\
-		.ops	= &ab8500_regulator_ops,		\
-		.type	= REGULATOR_VOLTAGE,			\
-		.id	= AB8500_LDO_##_id,			\
-		.owner	= THIS_MODULE,				\
-	},							\
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
-}
-
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
-}
-
-static struct ab8500_regulator_info ab8500_regulator_info[] = {
+static struct ab8500_regulator_info
+		ab8500_regulator_info[AB8500_NUM_REGULATOR] = {
 	/*
 	 * Variable Voltage LDOs
-	 * name, min uV, max uV, ctrl bank, ctrl reg, reg mask, enable mask,
-	 *      volt ctrl bank, volt ctrl reg, volt ctrl mask, volt table,
-	 *      num supported volts
 	 */
-	AB8500_LDO(AUX1, 1100, 3300, 0x04, 0x09, 0x3, 0x1, 0x04, 0x1f, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX2, 1100, 3300, 0x04, 0x09, 0xc, 0x4, 0x04, 0x20, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0xf,
-			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x4, 0x4, 0x03, 0x80, 0x38,
-		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
+	[AB8500_REGULATOR_AUX1] = {
+		.desc = {
+			.name		= "aux1",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AUX1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV		= 1100000,
+		.max_uV		= 3300000,
+		.update_bank	= 0x04,
+		.update_reg	= 0x09,
+		.update_mask	= 0x03,
+		.update_enable	= 0x01,
+		.voltage_bank	= 0x04,
+		.voltage_reg	= 0x1f,
+		.voltage_mask	= 0x0f,
+		.voltages	= ldo_vauxn_voltages,
+		.voltages_len	= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8500_REGULATOR_AUX2] = {
+		.desc = {
+			.name		= "aux2",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AUX2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV		= 1100000,
+		.max_uV		= 3300000,
+		.update_bank	= 0x04,
+		.update_reg	= 0x09,
+		.update_mask	= 0x0c,
+		.update_enable	= 0x04,
+		.voltage_bank	= 0x04,
+		.voltage_reg	= 0x20,
+		.voltage_mask	= 0x0f,
+		.voltages	= ldo_vauxn_voltages,
+		.voltages_len	= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB8500_REGULATOR_AUX3] = {
+		.desc = {
+			.name		= "aux3",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AUX3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+		},
+		.min_uV		= 1100000,
+		.max_uV		= 3300000,
+		.update_bank	= 0x04,
+		.update_reg	= 0x0a,
+		.update_mask	= 0x03,
+		.update_enable	= 0x01,
+		.voltage_bank	= 0x04,
+		.voltage_reg	= 0x21,
+		.voltage_mask	= 0x07,
+		.voltages	= ldo_vaux3_voltages,
+		.voltages_len	= ARRAY_SIZE(ldo_vaux3_voltages),
+	},
+	[AB8500_REGULATOR_INTCORE] = {
+		.desc = {
+			.name		= "intcore",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_INTCORE,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+		},
+		.min_uV		= 1100000,
+		.max_uV		= 3300000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x80,
+		.update_mask	= 0x44,
+		.update_enable	= 0x04,
+		.voltage_bank	= 0x03,
+		.voltage_reg	= 0x80,
+		.voltage_mask	= 0x38,
+		.voltages	= ldo_vintcore_voltages,
+		.voltages_len	= ARRAY_SIZE(ldo_vintcore_voltages),
+	},
 
 	/*
 	 * Fixed Voltage LDOs
-	 *		 name,	o/p uV, ctrl bank, ctrl reg, enable, disable
 	 */
-	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03,      0x80,     0x2,    0x2),
-	AB8500_FIXED_LDO(AUDIO,   2000, 0x03,      0x83,     0x2,    0x2),
-	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03,      0x83,     0x4,    0x4),
-	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03,      0x83,     0x8,    0x8),
-	AB8500_FIXED_LDO(DMIC,    1800, 0x03,      0x83,     0x10,   0x10),
-	AB8500_FIXED_LDO(ANA,     1200, 0x03,      0x83,     0xc,    0x4),
-};
+	[AB8500_REGULATOR_TVOUT] = {
+		.desc = {
+			.name		= "tvout",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_TVOUT,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 2000000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x80,
+		.update_mask	= 0x82,
+		.update_enable	= 0x02,
+	},
+	[AB8500_REGULATOR_AUDIO] = {
+		.desc = {
+			.name		= "audio",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AUDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 2000000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x83,
+		.update_mask	= 0x02,
+		.update_enable	= 0x02,
+	},
+	[AB8500_REGULATOR_AMIC1] = {
+		.desc = {
+			.name		= "amic1",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AMIC1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 2050000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x83,
+		.update_mask	= 0x08,
+		.update_enable	= 0x08,
+	},
+	[AB8500_REGULATOR_AMIC2] = {
+		.desc = {
+			.name		= "amic2",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_AMIC2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 2050000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x83,
+		.update_mask	= 0x10,
+		.update_enable	= 0x10,
+	},
+	[AB8500_REGULATOR_DMIC] = {
+		.desc = {
+			.name		= "dmic",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_DMIC,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 1800000,
+		.update_bank	= 0x03,
+		.update_reg	= 0x83,
+		.update_mask	= 0x04,
+		.update_enable	= 0x04,
+	},
+	[AB8500_REGULATOR_ANA] = {
+		.desc = {
+			.name		= "ana",
+			.ops		= &ab8500_regulator_fixed_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_REGULATOR_ANA,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV	= 1200000,
+		.update_bank	= 0x04,
+		.update_reg	= 0x06,
+		.update_mask	= 0x0c,
+		.update_enable	= 0x04,
+	},
 
-static inline struct ab8500_regulator_info *find_regulator_info(int id)
-{
-	struct ab8500_regulator_info *info;
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
-		info = &ab8500_regulator_info[i];
-		if (info->desc.id == id)
-			return info;
-	}
-	return NULL;
-}
+};
 
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *pdata;
+	struct regulator_init_data *ab8500_regulator_data;
 	int i, err;
 
 	if (!ab8500) {
 		dev_err(&pdev->dev, "null mfd parent\n");
 		return -EINVAL;
 	}
+
 	pdata = dev_get_platdata(ab8500->dev);
+	if (!pdata) {
+		dev_err(&pdev->dev, "null pdata\n");
+		return -EINVAL;
+	}
+
+	ab8500_regulator_data = pdata->regulator_data;
 
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
-		struct ab8500_regulator_info *info = NULL;
+		struct ab8500_regulator_info *info;
+		struct regulator_init_data *init_data;
 
 		/* assign per-regulator data */
 		info = &ab8500_regulator_info[i];
+		init_data = &ab8500_regulator_data[i];
 		info->dev = &pdev->dev;
-		info->ab8500 = ab8500;
 
+		/* fix for hardware before ab8500v2.0 */
+		if (abx500_get_chip_id(info->dev) < 0x20) {
+			if (info->desc.id == AB8500_REGULATOR_AUX3) {
+				info->desc.n_voltages =
+					ARRAY_SIZE(ldo_vauxn_voltages);
+				info->voltages = ldo_vauxn_voltages;
+				info->voltages_len =
+					ARRAY_SIZE(ldo_vauxn_voltages);
+				info->voltage_mask = 0xf;
+			}
+		}
+
+		/* register regulator with framework */
 		info->regulator = regulator_register(&info->desc, &pdev->dev,
-				pdata->regulator[i], info);
+				init_data, info);
 		if (IS_ERR(info->regulator)) {
 			err = PTR_ERR(info->regulator);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
@@ -392,6 +569,9 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 			}
 			return err;
 		}
+
+		dev_vdbg(rdev_get_dev(info->regulator),
+			"%s-probed\n", info->desc.name);
 	}
 
 	return 0;
@@ -404,6 +584,10 @@ static __devexit int ab8500_regulator_remove(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
 		struct ab8500_regulator_info *info = NULL;
 		info = &ab8500_regulator_info[i];
+
+		dev_vdbg(rdev_get_dev(info->regulator),
+			"%s-remove\n", info->desc.name);
+
 		regulator_unregister(info->regulator);
 	}
 
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index f509877..4d84d3b 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -3,23 +3,26 @@
  *
  * License Terms: GNU General Public License v2
  *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
- *
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
  */
 
 #ifndef __LINUX_MFD_AB8500_REGULATOR_H
 #define __LINUX_MFD_AB8500_REGULATOR_H
 
 /* AB8500 regulators */
-#define AB8500_LDO_AUX1         0
-#define AB8500_LDO_AUX2         1
-#define AB8500_LDO_AUX3         2
-#define AB8500_LDO_INTCORE      3
-#define AB8500_LDO_TVOUT        4
-#define AB8500_LDO_AUDIO	5
-#define AB8500_LDO_ANAMIC1      6
-#define AB8500_LDO_ANAMIC2      7
-#define AB8500_LDO_DMIC         8
-#define AB8500_LDO_ANA          9
+enum ab8500_regulator_id {
+	AB8500_REGULATOR_AUX1,
+	AB8500_REGULATOR_AUX2,
+	AB8500_REGULATOR_AUX3,
+	AB8500_REGULATOR_INTCORE,
+	AB8500_REGULATOR_TVOUT,
+	AB8500_REGULATOR_AUDIO,
+	AB8500_REGULATOR_AMIC1,
+	AB8500_REGULATOR_AMIC2,
+	AB8500_REGULATOR_DMIC,
+	AB8500_REGULATOR_ANA,
+	AB8500_NUM_REGULATOR
+};
 
 #endif
-- 
1.7.2.2

