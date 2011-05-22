Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1EVUVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:21:24 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:44443 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1EVUVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:21:13 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, lrg@slimlogic.co.uk, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux@slimlogic.co.uk,
        balajitk@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH v4 1/2] REGULATOR: TWL6025: add support to twl-regulator
Date: Sun, 22 May 2011 21:21:23 +0100
Message-Id: <1306095684-7732-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the twl6025. Major difference in the twl6025 is the
group functionality has been removed from the chip so this affects how
regulators are enabled and disabled.

The names of the regulators also changed.

The DCDCs of the 6025 are software controllable as well.

Since V1

Use the features variable passed via platform data instead of calling
global function.

Change the very switch like if statements to be a more readable
switch statement.

Since V2

twl6025 doesn't use remap so remove it from the macros.

Since V3

enable/disable functions for 4030/6030 were seperated upstream so rebase
on top of this. Change DCDC reference to SMPS as this is used in TRM.
Change list_voltage slightly to have less code.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/twl-regulator.c |  329 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 321 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 4702b8a..87fe0f7 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -51,8 +51,13 @@ struct twlreg_info {
 	u16			min_mV;
 	u16			max_mV;
 
+	u8			flags;
+
 	/* used by regulator core */
 	struct regulator_desc	desc;
+
+	/* chip specific features */
+	unsigned long 		features;
 };
 
 
@@ -70,6 +75,7 @@ struct twlreg_info {
 #define VREG_TRANS		1
 #define VREG_STATE		2
 #define VREG_VOLTAGE		3
+#define VREG_VOLTAGE_SMPS	4
 /* TWL6030 Misc register offsets */
 #define VREG_BC_ALL		1
 #define VREG_BC_REF		2
@@ -87,6 +93,17 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
 
+/* Flags for SMPS Voltage reading */
+#define SMPS_OFFSET_EN		BIT(0)
+#define SMPS_EXTENDED_EN	BIT(1)
+
+/* twl6025 SMPS EPROM values */
+#define TWL6030_SMPS_OFFSET		0xB0
+#define TWL6030_SMPS_MULT		0xB3
+#define SMPS_MULTOFFSET_SMPS4	BIT(0)
+#define SMPS_MULTOFFSET_VIO	BIT(1)
+#define SMPS_MULTOFFSET_SMPS3	BIT(6)
+
 static inline int
 twlreg_read(struct twlreg_info *info, unsigned slave_subgp, unsigned offset)
 {
@@ -142,13 +159,17 @@ static int twl4030reg_is_enabled(struct regulator_dev *rdev)
 static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			grp, val;
+	int			grp = 0, val;
 
-	grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
-	grp &= P1_GRP_6030;
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+		grp &= P1_GRP_6030;
+	else
+		grp = 1;
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 	val = TWL6030_CFG_STATE_APP(val);
@@ -178,10 +199,11 @@ static int twl4030reg_enable(struct regulator_dev *rdev)
 static int twl6030reg_enable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			grp;
+	int			grp = 0;
 	int			ret;
 
-	grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
@@ -217,7 +239,8 @@ static int twl6030reg_disable(struct regulator_dev *rdev)
 	int			grp = 0;
 	int			ret;
 
-	grp = P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030;
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+		grp = P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030;
 
 	/* For 6030, set the off state for all grps enabled */
 	ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
@@ -307,10 +330,11 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int grp;
+	int grp = 0;
 	int val;
 
-	grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
 
 	if (grp < 0)
 		return grp;
@@ -602,6 +626,209 @@ static struct regulator_ops twl6030_fixed_resource = {
 	.get_status	= twl6030reg_get_status,
 };
 
+/*
+ * SMPS status and control
+ */
+
+static int twl6030smps_list_voltage(struct regulator_dev *rdev, unsigned index)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+
+	int voltage = 0;
+
+	switch (info->flags) {
+	case SMPS_OFFSET_EN:
+		voltage = 100000;
+		/* fall through */
+	case 0:
+		switch (index) {
+		case 0:
+			voltage = 0;
+			break;
+		case 58:
+			voltage = 1350 * 1000;
+			break;
+		case 59:
+			voltage = 1500 * 1000;
+			break;
+		case 60:
+			voltage = 1800 * 1000;
+			break;
+		case 61:
+			voltage = 1900 * 1000;
+			break;
+		case 62:
+			voltage = 2100 * 1000;
+			break;
+		default:
+			voltage += (600000 + (12500 * (index - 1)));
+		}
+		break;
+	case SMPS_EXTENDED_EN:
+		switch (index) {
+		case 0:
+			voltage = 0;
+			break;
+		case 58:
+			voltage = 2084 * 1000;
+			break;
+		case 59:
+			voltage = 2315 * 1000;
+			break;
+		case 60:
+			voltage = 2778 * 1000;
+			break;
+		case 61:
+			voltage = 2932 * 1000;
+			break;
+		case 62:
+			voltage = 3241 * 1000;
+			break;
+		default:
+			voltage = (1852000 + (38600 * (index - 1)));
+		}
+		break;
+	case SMPS_OFFSET_EN | SMPS_EXTENDED_EN:
+		switch (index) {
+		case 0:
+			voltage = 0;
+			break;
+		case 58:
+			voltage = 4167 * 1000;
+			break;
+		case 59:
+			voltage = 2315 * 1000;
+			break;
+		case 60:
+			voltage = 2778 * 1000;
+			break;
+		case 61:
+			voltage = 2932 * 1000;
+			break;
+		case 62:
+			voltage = 3241 * 1000;
+			break;
+		default:
+			voltage = (2161000 + (38600 * (index - 1)));
+		}
+		break;
+	}
+
+	return voltage;
+}
+
+static int
+twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
+			unsigned int *selector)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int	vsel = 0;
+
+	switch (info->flags) {
+	case 0:
+		if (min_uV == 0)
+			vsel = 0;
+		else if ((min_uV >= 600000) && (max_uV <= 1300000)) {
+			vsel = (min_uV - 600000) / 125;
+			if (vsel % 100)
+				vsel += 100;
+			vsel /= 100;
+			vsel++;
+		}
+		/* Values 1..57 for vsel are linear and can be calculated
+		 * values 58..62 are non linear.
+		 */
+		else if ((min_uV > 1900000) && (max_uV >= 2100000))
+			vsel = 62;
+		else if ((min_uV > 1800000) && (max_uV >= 1900000))
+			vsel = 61;
+		else if ((min_uV > 1500000) && (max_uV >= 1800000))
+			vsel = 60;
+		else if ((min_uV > 1350000) && (max_uV >= 1500000))
+			vsel = 59;
+		else if ((min_uV > 1300000) && (max_uV >= 1350000))
+			vsel = 58;
+		else
+			return -EINVAL;
+		break;
+	case SMPS_OFFSET_EN:
+		if (min_uV == 0)
+			vsel = 0;
+		else if ((min_uV >= 700000) && (max_uV <= 1420000)) {
+			vsel = (min_uV - 700000) / 125;
+			if (vsel % 100)
+				vsel += 100;
+			vsel /= 100;
+			vsel++;
+		}
+		/* Values 1..57 for vsel are linear and can be calculated
+		 * values 58..62 are non linear.
+		 */
+		else if ((min_uV > 1900000) && (max_uV >= 2100000))
+			vsel = 62;
+		else if ((min_uV > 1800000) && (max_uV >= 1900000))
+			vsel = 61;
+		else if ((min_uV > 1350000) && (max_uV >= 1800000))
+			vsel = 60;
+		else if ((min_uV > 1350000) && (max_uV >= 1500000))
+			vsel = 59;
+		else if ((min_uV > 1300000) && (max_uV >= 1350000))
+			vsel = 58;
+		else
+			return -EINVAL;
+		break;
+	case SMPS_EXTENDED_EN:
+		if (min_uV == 0)
+			vsel = 0;
+		else if ((min_uV >= 1852000) && (max_uV <= 4013600)) {
+			vsel = (min_uV - 1852000) / 386;
+			if (vsel % 100)
+				vsel += 100;
+			vsel /= 100;
+			vsel++;
+		}
+		break;
+	case SMPS_OFFSET_EN|SMPS_EXTENDED_EN:
+		if (min_uV == 0)
+			vsel = 0;
+		else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
+			vsel = (min_uV - 1852000) / 386;
+			if (vsel % 100)
+				vsel += 100;
+			vsel /= 100;
+			vsel++;
+		}
+		break;
+	}
+
+	*selector = vsel;
+
+	return twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE_SMPS,
+							vsel);
+}
+
+static int twl6030smps_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+
+	return twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_VOLTAGE_SMPS);
+}
+
+static struct regulator_ops twlsmps_ops = {
+	.list_voltage		= twl6030smps_list_voltage,
+
+	.set_voltage		= twl6030smps_set_voltage,
+	.get_voltage_sel	= twl6030smps_get_voltage_sel,
+
+	.enable			= twl6030reg_enable,
+	.disable		= twl6030reg_disable,
+	.is_enabled		= twl6030reg_is_enabled,
+
+	.set_mode		= twl6030reg_set_mode,
+
+	.get_status		= twl6030reg_get_status,
+};
+
 /*----------------------------------------------------------------------*/
 
 #define TWL4030_FIXED_LDO(label, offset, mVolts, num, turnon_delay, \
@@ -644,6 +871,20 @@ static struct regulator_ops twl6030_fixed_resource = {
 		}, \
 	}
 
+#define TWL6025_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts, num) { \
+	.base = offset, \
+	.id = num, \
+	.min_mV = min_mVolts, \
+	.max_mV = max_mVolts, \
+	.desc = { \
+		.name = #label, \
+		.id = TWL6025_REG_##label, \
+		.n_voltages = ((max_mVolts - min_mVolts)/100) + 1, \
+		.ops = &twl6030ldo_ops, \
+		.type = REGULATOR_VOLTAGE, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
 
 #define TWL_FIXED_LDO(label, offset, mVolts, num, turnon_delay, remap_conf, \
 		family, operations) { \
@@ -675,6 +916,21 @@ static struct regulator_ops twl6030_fixed_resource = {
 		}, \
 	}
 
+#define TWL6025_ADJUSTABLE_SMPS(label, offset, num) { \
+	.base = offset, \
+	.id = num, \
+	.min_mV = 600, \
+	.max_mV = 2100, \
+	.desc = { \
+		.name = #label, \
+		.id = TWL6025_REG_##label, \
+		.n_voltages = 63, \
+		.ops = &twlsmps_ops, \
+		.type = REGULATOR_VOLTAGE, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
+
 /*
  * We list regulators here if systems need some level of
  * software control over them after boot.
@@ -716,8 +972,41 @@ static struct twlreg_info twl_regs[] = {
 	TWL6030_FIXED_LDO(VDAC, 0x64, 1800, 17, 0),
 	TWL6030_FIXED_LDO(VUSB, 0x70, 3300, 18, 0),
 	TWL6030_FIXED_RESOURCE(CLK32KG, 0x8C, 48, 0),
+
+	/* 6025 are renamed compared to 6030 versions */
+	TWL6025_ADJUSTABLE_LDO(LDO2, 0x54, 1000, 3300, 1),
+	TWL6025_ADJUSTABLE_LDO(LDO4, 0x58, 1000, 3300, 2),
+	TWL6025_ADJUSTABLE_LDO(LDO3, 0x5c, 1000, 3300, 3),
+	TWL6025_ADJUSTABLE_LDO(LDO5, 0x68, 1000, 3300, 4),
+	TWL6025_ADJUSTABLE_LDO(LDO1, 0x6c, 1000, 3300, 5),
+	TWL6025_ADJUSTABLE_LDO(LDO7, 0x74, 1000, 3300, 7),
+	TWL6025_ADJUSTABLE_LDO(LDO6, 0x60, 1000, 3300, 16),
+	TWL6025_ADJUSTABLE_LDO(LDOLN, 0x64, 1000, 3300, 17),
+	TWL6025_ADJUSTABLE_LDO(LDOUSB, 0x70, 1000, 3300, 18),
+
+	TWL6025_ADJUSTABLE_SMPS(SMPS3, 0x34, 1),
+	TWL6025_ADJUSTABLE_SMPS(SMPS4, 0x10, 2),
+	TWL6025_ADJUSTABLE_SMPS(VIO, 0x16, 3),
 };
 
+static u8 twl_get_smps_offset(void)
+{
+	u8 value;
+
+	twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER, &value,
+			TWL6030_SMPS_OFFSET);
+	return value;
+}
+
+static u8 twl_get_smps_mult(void)
+{
+	u8 value;
+
+	twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER, &value,
+			TWL6030_SMPS_MULT);
+	return value;
+}
+
 static int __devinit twlreg_probe(struct platform_device *pdev)
 {
 	int				i;
@@ -739,6 +1028,9 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 	if (!initdata)
 		return -EINVAL;
 
+	/* copy the features into regulator data */
+	info->features = (unsigned long)initdata->driver_data;
+
 	/* Constrain board-specific capabilities according to what
 	 * this driver and the chip itself can actually do.
 	 */
@@ -761,6 +1053,27 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 		break;
 	}
 
+	switch (pdev->id) {
+	case TWL6025_REG_SMPS3:
+		if (twl_get_smps_mult() & SMPS_MULTOFFSET_SMPS3)
+			info->flags |= SMPS_EXTENDED_EN;
+		if (twl_get_smps_offset() & SMPS_MULTOFFSET_SMPS3)
+			info->flags |= SMPS_OFFSET_EN;
+		break;
+	case TWL6025_REG_SMPS4:
+		if (twl_get_smps_mult() & SMPS_MULTOFFSET_SMPS4)
+			info->flags |= SMPS_EXTENDED_EN;
+		if (twl_get_smps_offset() & SMPS_MULTOFFSET_SMPS4)
+			info->flags |= SMPS_OFFSET_EN;
+		break;
+	case TWL6025_REG_VIO:
+		if (twl_get_smps_mult() & SMPS_MULTOFFSET_VIO)
+			info->flags |= SMPS_EXTENDED_EN;
+		if (twl_get_smps_offset() & SMPS_MULTOFFSET_VIO)
+			info->flags |= SMPS_OFFSET_EN;
+		break;
+	}
+
 	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
-- 
1.7.4.1

