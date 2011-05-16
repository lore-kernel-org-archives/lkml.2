Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1EPSu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:50:27 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48941 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1EPSu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:50:26 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 2/5] regulator: tps65911: Add new chip version
Date: Mon, 16 May 2011 13:50:12 -0500
Message-Id: <114BE19F-EA93-40FA-99D7-16621C23B6CF@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65911 chip introduces new features, including changes in
the regulator module.

- VDD1 and VDD2 remain unchanged.
- VDD3 is now named VDDCTRL and has a wider voltage range.
- LDOs are now named LDO1...8 and voltage ranges are sequential,
  making LDOs easier to handle.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/regulator/tps65910-regulator.c |  357 +++++++++++++++++++++++++++++---
 include/linux/mfd/tps65910.h           |   10 +-
 2 files changed, 332 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index d461fa7..f17895b 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -39,8 +39,17 @@
 #define TPS65910_REG_VAUX33		11
 #define TPS65910_REG_VMMC		12
 
-#define TPS65910_NUM_REGULATOR		13
+#define TPS65911_REG_VDDCTRL		4
+#define TPS65911_REG_LDO1		5
+#define TPS65911_REG_LDO2		6
+#define TPS65911_REG_LDO3		7
+#define TPS65911_REG_LDO4		8
+#define TPS65911_REG_LDO5		9
+#define TPS65911_REG_LDO6		10
+#define TPS65911_REG_LDO7		11
+#define TPS65911_REG_LDO8		12
 
+#define TPS65910_NUM_REGULATOR		13
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 
 /* supported VIO voltages in milivolts */
@@ -48,7 +57,9 @@ static const u16 VIO_VSEL_table[] = {
 	1500, 1800, 2500, 3300,
 };
 
-/* supported VIO voltages in milivolts */
+/* VSEL tables for TPS65910 specific LDOs and dcdc's */
+
+/* supported VDD3 voltages in milivolts */
 static const u16 VDD3_VSEL_table[] = {
 	5000,
 };
@@ -187,6 +198,71 @@ static struct tps_info tps65910_regs[] = {
 	},
 };
 
+static struct tps_info tps65911_regs[] = {
+	{
+		.name = "VIO",
+		.min_uV = 1500000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VIO_VSEL_table),
+		.table = VIO_VSEL_table,
+	},
+	{
+		.name = "VDD1",
+		.min_uV = 600000,
+		.max_uV = 4500000,
+	},
+	{
+		.name = "VDD2",
+		.min_uV = 600000,
+		.max_uV = 4500000,
+	},
+	{
+		.name = "VDDCTRL",
+		.min_uV = 600000,
+		.max_uV = 1400000,
+	},
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO3",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO4",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO5",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO6",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO7",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+	{
+		.name = "LDO8",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+	},
+};
+
 struct tps65910_reg {
 	struct regulator_desc desc[TPS65910_NUM_REGULATOR];
 	struct tps65910 *mfd;
@@ -194,6 +270,7 @@ struct tps65910_reg {
 	struct tps_info *info[TPS65910_NUM_REGULATOR];
 	struct mutex mutex;
 	int mode;
+	int  (*get_ctrl_reg)(int);
 };
 
 static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
@@ -300,12 +377,46 @@ static int tps65910_get_ctrl_register(int id)
 	}
 }
 
+static int tps65911_get_ctrl_register(int id)
+{
+	switch (id) {
+	case TPS65910_REG_VRTC:
+		return TPS65910_VRTC;
+	case TPS65910_REG_VIO:
+		return TPS65910_VIO;
+	case TPS65910_REG_VDD1:
+		return TPS65910_VDD1;
+	case TPS65910_REG_VDD2:
+		return TPS65910_VDD2;
+	case TPS65911_REG_VDDCTRL:
+		return TPS65911_VDDCTRL;
+	case TPS65911_REG_LDO1:
+		return TPS65911_LDO1;
+	case TPS65911_REG_LDO2:
+		return TPS65911_LDO2;
+	case TPS65911_REG_LDO3:
+		return TPS65911_LDO3;
+	case TPS65911_REG_LDO4:
+		return TPS65911_LDO4;
+	case TPS65911_REG_LDO5:
+		return TPS65911_LDO5;
+	case TPS65911_REG_LDO6:
+		return TPS65911_LDO6;
+	case TPS65911_REG_LDO7:
+		return TPS65911_LDO7;
+	case TPS65911_REG_LDO8:
+		return TPS65911_LDO8;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int tps65910_is_enabled(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, value, id = rdev_get_id(dev);
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -322,7 +433,7 @@ static int tps65910_enable(struct regulator_dev *dev)
 	struct tps65910 *mfd = pmic->mfd;
 	int reg, id = rdev_get_id(dev);
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -335,7 +446,7 @@ static int tps65910_disable(struct regulator_dev *dev)
 	struct tps65910 *mfd = pmic->mfd;
 	int reg, id = rdev_get_id(dev);
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -348,7 +459,8 @@ static int tps65910_set_mode(struct regulator_dev *dev, unsigned int mode)
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65910 *mfd = pmic->mfd;
 	int reg, value, id = rdev_get_id(dev);
-	reg = tps65910_get_ctrl_register(id);
+
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -371,7 +483,7 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, value, id = rdev_get_id(dev);
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -391,7 +503,7 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int id = rdev_get_id(dev), voltage = 0;
-	int opvsel = 0, srvsel = 0, mult = 0, sr = 0;
+	int opvsel = 0, srvsel = 0, vselmax = 0, mult = 0, sr = 0;
 
 	switch (id) {
 	case TPS65910_REG_VDD1:
@@ -402,6 +514,7 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 		sr = opvsel & VDD1_OP_CMD_MASK;
 		opvsel &= VDD1_OP_SEL_MASK;
 		srvsel &= VDD1_SR_SEL_MASK;
+		vselmax = 75;
 		break;
 	case TPS65910_REG_VDD2:
 		opvsel = tps65910_reg_read(pmic, TPS65910_VDD2_OP);
@@ -411,6 +524,15 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 		sr = opvsel & VDD2_OP_CMD_MASK;
 		opvsel &= VDD2_OP_SEL_MASK;
 		srvsel &= VDD2_SR_SEL_MASK;
+		vselmax = 75;
+		break;
+	case TPS65911_REG_VDDCTRL:
+		opvsel = tps65910_reg_read(pmic, TPS65911_VDDCTRL_OP);
+		srvsel = tps65910_reg_read(pmic, TPS65911_VDDCTRL_SR);
+		sr = opvsel & VDDCTRL_OP_CMD_MASK;
+		opvsel &= VDDCTRL_OP_SEL_MASK;
+		srvsel &= VDDCTRL_SR_SEL_MASK;
+		vselmax = 64;
 		break;
 	}
 
@@ -419,17 +541,21 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 		mult=1;
 
 	if (sr) {
-		/* Valid range is 3-75 so normalise */
-		if (srvsel < 3) srvsel = 3;
-		if (srvsel > 75) srvsel = 75;
+		/* normalise to valid range */
+		if (srvsel < 3)
+			srvsel = 3;
+		if (srvsel > vselmax)
+			srvsel = vselmax;
 		srvsel -= 3;
 
 		voltage = (srvsel * VDD1_2_OFFSET + VDD1_2_MIN_VOLT) * 100;
 	} else {
 
-		/* Valid range is 3-75 so normalise */
-		if (opvsel < 3) opvsel = 3;
-		if (opvsel > 75) opvsel = 75;
+		/* normalise to valid range*/
+		if (opvsel < 3)
+			opvsel = 3;
+		if (opvsel > vselmax)
+			opvsel = vselmax;
 		opvsel -= 3;
 
 		voltage = (opvsel * VDD1_2_OFFSET + VDD1_2_MIN_VOLT) * 100;
@@ -445,7 +571,7 @@ static int tps65910_get_voltage(struct regulator_dev *dev)
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, value, id = rdev_get_id(dev), voltage = 0;
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -480,29 +606,88 @@ static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
 	return 5 * 1000 * 1000;
 }
 
+static int tps65911_get_voltage(struct regulator_dev *dev)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int step_mv, id = rdev_get_id(dev);
+	u8 value, reg;
+	
+	reg = pmic->get_ctrl_reg(id);
+
+	value = tps65910_reg_read(pmic, reg);
+
+	switch (id) {
+	case TPS65911_REG_LDO1:
+	case TPS65911_REG_LDO2:
+	case TPS65911_REG_LDO4:
+		value &= LDO1_SEL_MASK;
+		value >>= LDO_SEL_SHIFT;
+		/* The first 5 values of the selector correspond to 1V */
+		if (value < 5)
+			value = 0;
+		else
+			value -= 4;
+
+		step_mv = 50;
+		break;
+	case TPS65911_REG_LDO3:
+	case TPS65911_REG_LDO5:
+	case TPS65911_REG_LDO6:
+	case TPS65911_REG_LDO7:
+	case TPS65911_REG_LDO8:
+		value &= LDO3_SEL_MASK;
+		value >>= LDO_SEL_SHIFT;
+		/* The first 3 values of the selector correspond to 1V */
+		if (value < 3)
+			value = 0;
+		else
+			value -= 2;
+
+		step_mv = 100;
+		break;
+	case TPS65910_REG_VIO:
+		return pmic->info[id]->table[value] * 1000;
+		break; 
+	default:
+		return -EINVAL;
+	}
+
+	return (LDO_MIN_VOLT + value * step_mv) * 1000;
+}
+
 static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 				unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int id = rdev_get_id(dev), vsel;
-	int dcdc_mult;
+	int dcdc_mult = 0;
 
-	/* Split vsel into appropriate registers */
-	dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
-	if (dcdc_mult == 1) dcdc_mult--;
-
-	vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
+	switch (id) {
+	case TPS65910_REG_VDD1:
+		dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		if (dcdc_mult == 1)
+			dcdc_mult--;
+		vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
 
-	if (id == TPS65910_REG_VDD1) {
 		tps65910_modify_bits(pmic, TPS65910_VDD1,
 				(dcdc_mult << VDD1_VGAIN_SEL_SHIFT),
 						VDD1_VGAIN_SEL_MASK);
 		tps65910_reg_write(pmic, TPS65910_VDD1_OP, vsel);
-	} else {
+		break;
+	case TPS65910_REG_VDD2:
+		dcdc_mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		if (dcdc_mult == 1)
+			dcdc_mult--;
+		vsel = (selector % VDD1_2_NUM_VOLTS) + 3;
+
 		tps65910_modify_bits(pmic, TPS65910_VDD2,
 				(dcdc_mult << VDD2_VGAIN_SEL_SHIFT),
 						VDD1_VGAIN_SEL_MASK);
 		tps65910_reg_write(pmic, TPS65910_VDD2_OP, vsel);
+		break;
+	case TPS65911_REG_VDDCTRL:
+		vsel = selector;
+		tps65910_reg_write(pmic, TPS65911_VDDCTRL_OP, vsel);
 	}
 
 	return 0;
@@ -513,7 +698,7 @@ static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, id = rdev_get_id(dev);
 
-	reg = tps65910_get_ctrl_register(id);
+	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
 		return reg;
 
@@ -534,14 +719,49 @@ static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
 	return -EINVAL;
 }
 
+static int tps65911_set_voltage(struct regulator_dev *dev, unsigned selector)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int reg, id = rdev_get_id(dev);
+
+	reg = pmic->get_ctrl_reg(id);
+	if (reg < 0)
+		return reg;
+
+	switch (id) {
+	case TPS65911_REG_LDO1:
+	case TPS65911_REG_LDO2:
+	case TPS65911_REG_LDO4:
+		return tps65910_modify_bits(pmic, reg,
+				(selector << LDO_SEL_SHIFT), LDO1_SEL_MASK);
+	case TPS65911_REG_LDO3:
+	case TPS65911_REG_LDO5:
+	case TPS65911_REG_LDO6:
+	case TPS65911_REG_LDO7:
+	case TPS65911_REG_LDO8:
+	case TPS65910_REG_VIO:
+		return tps65910_modify_bits(pmic, reg,
+				(selector << LDO_SEL_SHIFT), LDO3_SEL_MASK);
+	}
+
+	return -EINVAL;
+}
+
+
 static int tps65910_list_voltage_dcdc(struct regulator_dev *dev,
 					unsigned selector)
 {
-	int mult, volt;
-
-	mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+	int volt, mult = 1, id = rdev_get_id(dev);
 
-	volt = VDD1_2_MIN_VOLT + (selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+	switch (id) {
+	case TPS65910_REG_VDD1:
+	case TPS65910_REG_VDD2:
+		mult = (selector / VDD1_2_NUM_VOLTS) + 1;
+		volt = VDD1_2_MIN_VOLT +
+				(selector % VDD1_2_NUM_VOLTS) * VDD1_2_OFFSET;
+	case TPS65911_REG_VDDCTRL:
+		volt = VDDCTRL_MIN_VOLT + (selector * VDDCTRL_OFFSET);
+	}
 
 	return  volt * 100 * mult;
 }
@@ -563,6 +783,45 @@ static int tps65910_list_voltage(struct regulator_dev *dev,
 	return voltage;
 }
 
+static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
+{
+	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
+	int step_mv = 0, id = rdev_get_id(dev);
+
+	switch(id) {
+	case TPS65911_REG_LDO1:
+	case TPS65911_REG_LDO2:
+	case TPS65911_REG_LDO4:
+		/* The first 5 values of the selector correspond to 1V */
+		if (selector < 5)
+			selector = 0;
+		else
+			selector -= 4;
+
+		step_mv = 50;
+		break;
+	case TPS65911_REG_LDO3:
+	case TPS65911_REG_LDO5:
+	case TPS65911_REG_LDO6:
+	case TPS65911_REG_LDO7:
+	case TPS65911_REG_LDO8:
+		/* The first 3 values of the selector correspond to 1V */
+		if (selector < 3)
+			selector = 0;
+		else
+			selector -= 2;
+
+		step_mv = 100;
+		break;
+	case TPS65910_REG_VIO:
+		return pmic->info[id]->table[selector] * 1000;
+	default:
+		return -EINVAL;
+	}
+
+	return (LDO_MIN_VOLT + selector * step_mv) * 1000;
+}
+
 /* Regulator ops (except VRTC) */
 static struct regulator_ops tps65910_ops_dcdc = {
 	.is_enabled		= tps65910_is_enabled,
@@ -596,10 +855,21 @@ static struct regulator_ops tps65910_ops = {
 	.list_voltage		= tps65910_list_voltage,
 };
 
+static struct regulator_ops tps65911_ops = {
+	.is_enabled		= tps65910_is_enabled,
+	.enable			= tps65910_enable,
+	.disable		= tps65910_disable,
+	.set_mode		= tps65910_set_mode,
+	.get_mode		= tps65910_get_mode,
+	.get_voltage		= tps65911_get_voltage,
+	.set_voltage_sel	= tps65911_set_voltage,
+	.list_voltage		= tps65911_list_voltage,
+};
+
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
-	struct tps_info *info = tps65910_regs;
+	struct tps_info *info;
 	struct regulator_init_data *reg_data;
 	struct regulator_dev *rdev;
 	struct tps65910_reg *pmic;
@@ -625,6 +895,18 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	tps65910_set_bits(pmic->mfd, TPS65910_DEVCTRL,
 				DEVCTRL_SR_CTL_I2C_SEL_MASK);
 
+	switch(tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
+		info = tps65910_regs;
+	case TPS65911:
+		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
+		info = tps65911_regs;
+	default:
+		pr_err("Invalid tps chip version\n");
+		return -ENODEV;
+	}
+
 	for (i = 0; i < TPS65910_NUM_REGULATOR; i++, info++, reg_data++) {
 		/* Register the regulators */
 		pmic->info[i] = info;
@@ -633,12 +915,19 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].id = desc_id++;
 		pmic->desc[i].n_voltages = info->table_len;
 
-		if ((i == TPS65910_REG_VDD1) || (i == TPS65910_REG_VDD2))
+		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
 			pmic->desc[i].ops = &tps65910_ops_dcdc;
-		else if (i == TPS65910_REG_VDD3)
-			pmic->desc[i].ops = &tps65910_ops_vdd3;
-		else
-			pmic->desc[i].ops = &tps65910_ops;
+		} else if (i == TPS65910_REG_VDD3) {
+			if (tps65910_chip_id(tps65910) == TPS65910)
+				pmic->desc[i].ops = &tps65910_ops_vdd3;
+			else
+				pmic->desc[i].ops = &tps65910_ops_dcdc;
+		} else {
+			if (tps65910_chip_id(tps65910) == TPS65910)
+				pmic->desc[i].ops = &tps65910_ops;
+			else
+				pmic->desc[i].ops = &tps65911_ops;
+		}
 
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 6ceea0d..20359e6 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -232,7 +232,6 @@
 #define VDD2_OP_SEL_MASK				0x7F
 #define VDD2_OP_SEL_SHIFT				0
 
-
 /*Register VDD2_SR  (0x80) register.RegisterDescription */
 #define VDD2_SR_SEL_MASK				0x7F
 #define VDD2_SR_SEL_SHIFT				0
@@ -249,6 +248,8 @@
 #define VDD3_CKINEN_SHIFT				2
 #define VDD3_ST_MASK					0x03
 #define VDD3_ST_SHIFT					0
+#define VDDCTRL_MIN_VOLT				6000
+#define VDDCTRL_OFFSET					125
 
 /*Registers VDIG (0x80) to VDAC register.RegisterDescription */
 #define LDO_SEL_MASK					0x0C
@@ -259,6 +260,13 @@
 #define LDO_ST_MODE_BIT					0x02	
 
 
+/* Registers LDO1 to LDO8 in tps65910 */
+#define LDO1_SEL_MASK					0xFC
+#define LDO3_SEL_MASK					0x7C
+#define LDO_MIN_VOLT					1000
+#define LDO_MAX_VOLT					3300;
+
+
 /*Register VDIG1  (0x80) register.RegisterDescription */
 #define VDIG1_SEL_MASK					0x0C
 #define VDIG1_SEL_SHIFT					2
-- 
1.7.1

