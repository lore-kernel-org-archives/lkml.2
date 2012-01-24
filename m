Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2AXJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:06:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1145 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2AXJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:05:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 01:05:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk,
        sameo@linux.intel.com, gg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] regulator: tps65910: Sleep control through external inputs
Date: Tue, 24 Jan 2012 14:35:19 +0530
Message-Id: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for sleep controls of different rails through
external inputs EN1, EN2 or EN3.
Each rail's output will be active when its external input is high
and turns to OFF/Low power mode when its external input is low.
The configuration parameters for sleep control is provided through
board specific platform data.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |  175 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65910.h           |   14 +++
 2 files changed, 189 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 1d13cf9..0633a0f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -26,6 +26,9 @@
 #include <linux/mfd/tps65910.h>
 
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
+#define EXT_SLEEP_CONTROL (TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1 |  \
+			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2    |  \
+			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3)
 
 /* supported VIO voltages in milivolts */
 static const u16 VIO_VSEL_table[] = {
@@ -252,6 +255,39 @@ static struct tps_info tps65911_regs[] = {
 	},
 };
 
+#define EXT_CONTROL_REG_BITS(id, regs_offs, bits) (((regs_offs) << 8) | (bits))
+static unsigned int tps65910_ext_sleep_control[] = {
+	0,
+	EXT_CONTROL_REG_BITS(VIO,    1, 0),
+	EXT_CONTROL_REG_BITS(VDD1,   1, 1),
+	EXT_CONTROL_REG_BITS(VDD2,   1, 2),
+	EXT_CONTROL_REG_BITS(VDD3,   1, 3),
+	EXT_CONTROL_REG_BITS(VDIG1,  0, 1),
+	EXT_CONTROL_REG_BITS(VDIG2,  0, 2),
+	EXT_CONTROL_REG_BITS(VPLL,   0, 6),
+	EXT_CONTROL_REG_BITS(VDAC,   0, 7),
+	EXT_CONTROL_REG_BITS(VAUX1,  0, 3),
+	EXT_CONTROL_REG_BITS(VAUX2,  0, 4),
+	EXT_CONTROL_REG_BITS(VAUX33, 0, 5),
+	EXT_CONTROL_REG_BITS(VMMC,   0, 0),
+};
+
+static unsigned int tps65911_ext_sleep_control[] = {
+	0,
+	EXT_CONTROL_REG_BITS(VIO,     1, 0),
+	EXT_CONTROL_REG_BITS(VDD1,    1, 1),
+	EXT_CONTROL_REG_BITS(VDD2,    1, 2),
+	EXT_CONTROL_REG_BITS(VDDCTRL, 1, 3),
+	EXT_CONTROL_REG_BITS(LDO1,    0, 1),
+	EXT_CONTROL_REG_BITS(LDO2,    0, 2),
+	EXT_CONTROL_REG_BITS(LDO3,    0, 7),
+	EXT_CONTROL_REG_BITS(LDO4,    0, 6),
+	EXT_CONTROL_REG_BITS(LDO5,    0, 3),
+	EXT_CONTROL_REG_BITS(LDO6,    0, 0),
+	EXT_CONTROL_REG_BITS(LDO7,    0, 5),
+	EXT_CONTROL_REG_BITS(LDO8,    0, 4),
+};
+
 struct tps65910_reg {
 	struct regulator_desc *desc;
 	struct tps65910 *mfd;
@@ -261,6 +297,7 @@ struct tps65910_reg {
 	int num_regulators;
 	int mode;
 	int  (*get_ctrl_reg)(int);
+	unsigned int *ext_sleep_control;
 };
 
 static inline int tps65910_read(struct tps65910_reg *pmic, u8 reg)
@@ -861,6 +898,114 @@ static struct regulator_ops tps65911_ops = {
 	.list_voltage		= tps65911_list_voltage,
 };
 
+static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
+		int rail_id, int ext_sleep_config)
+{
+	struct tps65910 *mfd = pmic->mfd;
+	u8 regoffs = (pmic->ext_sleep_control[rail_id] >> 8) & 0xFF;
+	u8 bit_pos = (1 << pmic->ext_sleep_control[rail_id] & 0xFF);
+	int ret;
+
+	/*
+	 * Rail can not be control from all external input EN1, EN2 and EN3
+	 * together.
+	 */
+	if ((ext_sleep_config & EXT_SLEEP_CONTROL) == EXT_SLEEP_CONTROL) {
+		dev_err(mfd->dev, "External sleep control flag is not "
+					" not proper\n");
+		return -EINVAL;
+	}
+
+	/* External EN1 control */
+	if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1)
+		ret = tps65910_set_bits(mfd,
+				TPS65910_EN1_LDO_ASS + regoffs, bit_pos);
+	else
+		ret = tps65910_clear_bits(mfd,
+				TPS65910_EN1_LDO_ASS + regoffs, bit_pos);
+	if (ret < 0) {
+		dev_err(mfd->dev, "Error in configuring ext EN1 control\n");
+		return ret;
+	}
+
+	/* External EN2 control */
+	if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2)
+		ret = tps65910_set_bits(mfd,
+				TPS65910_EN2_LDO_ASS + regoffs, bit_pos);
+	else
+		ret = tps65910_clear_bits(mfd,
+				TPS65910_EN2_LDO_ASS + regoffs, bit_pos);
+	if (ret < 0) {
+		dev_err(mfd->dev, "Error in configuring ext EN2 control\n");
+		return ret;
+	}
+
+	/* External EN3 control for TPS65910 LDOs only */
+	if ((tps65910_chip_id(mfd) == TPS65911) &&
+			(rail_id >= TPS65910_REG_VDIG1)) {
+		if (ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3)
+			ret = tps65910_set_bits(mfd,
+				TPS65910_EN3_LDO_ASS + regoffs, bit_pos);
+		else
+			ret = tps65910_clear_bits(mfd,
+				TPS65910_EN3_LDO_ASS + regoffs, bit_pos);
+		if (ret < 0) {
+			dev_err(mfd->dev, "Error in configuring ext EN3 "
+					"control\n");
+			return ret;
+		}
+	}
+
+	/* Return if no external control is selected */
+	if (!(ext_sleep_config & EXT_SLEEP_CONTROL))
+		return ret;
+
+	/*
+	 * For regulator that has separate operational and sleep register make
+	 * sure that operational is used and clear sleep register to turn
+	 * regulator off when external control is inactive
+	 */
+	if ((rail_id == TPS65910_REG_VDD1) ||
+		(rail_id == TPS65910_REG_VDD2) ||
+			((rail_id == TPS65911_REG_VDDCTRL) &&
+				(tps65910_chip_id(mfd) == TPS65911))) {
+		int op_reg_add = pmic->get_ctrl_reg(rail_id) + 1;
+		int sr_reg_add = pmic->get_ctrl_reg(rail_id) + 2;
+		int opvsel = tps65910_reg_read(pmic, op_reg_add);
+		int srvsel = tps65910_reg_read(pmic, sr_reg_add);
+		if (opvsel & VDD1_OP_CMD_MASK) {
+			u8 reg_val = srvsel & VDD1_OP_SEL_MASK;
+			ret = tps65910_reg_write(pmic, op_reg_add, reg_val);
+			if (ret < 0) {
+				dev_err(mfd->dev, "Error in configuring op "
+					"register\n");
+				return ret;
+			}
+		}
+		ret = tps65910_reg_write(pmic, sr_reg_add, 0);
+		if (ret < 0) {
+			dev_err(mfd->dev, "Error in settting sr register\n");
+			return ret;
+		}
+	}
+
+	if (ext_sleep_config & TPS65910_SLEEP_CONTROL_REG_LOW_POWER)
+		ret = tps65910_set_bits(mfd,
+			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
+	else {
+		ret = tps65910_clear_bits(mfd,
+			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
+		if (!ret)
+			ret = tps65910_set_bits(mfd,
+				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
+	}
+
+	if (ret < 0)
+		dev_err(mfd->dev, "Error in configuring SLEEP register\n");
+
+	return ret;
+}
+
 static __devinit int tps65910_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
@@ -891,11 +1036,13 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 	case TPS65910:
 		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
 		pmic->num_regulators = ARRAY_SIZE(tps65910_regs);
+		pmic->ext_sleep_control = tps65910_ext_sleep_control;
 		info = tps65910_regs;
 		break;
 	case TPS65911:
 		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
 		pmic->num_regulators = ARRAY_SIZE(tps65911_regs);
+		pmic->ext_sleep_control = tps65911_ext_sleep_control;
 		info = tps65911_regs;
 		break;
 	default:
@@ -958,6 +1105,14 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 				pmic->desc[i].ops = &tps65911_ops;
 		}
 
+		err = tps65910_set_ext_sleep_config(pmic, i,
+				pmic_plat_data->regulator_ext_sleep_control[i]);
+		if (err < 0) {
+			dev_err(tps65910->dev, "Failed to initialise "
+				"ext control configuation\n");
+			goto err_unregister_regulator;
+		}
+
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 
@@ -1004,6 +1159,25 @@ static int __devexit tps65910_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void tps65910_shutdown(struct platform_device *pdev)
+{
+	struct tps65910_reg *pmic = platform_get_drvdata(pdev);
+	int i;
+	int err;
+	dev_err(&pdev->dev, "%s() is called\n", __func__);
+
+	/* Remove all external control before shutting down the device */
+	for (i = 0; i < pmic->num_regulators; i++) {
+		if (!pmic->rdev[i])
+			continue;
+
+		err = tps65910_set_ext_sleep_config(pmic, i, 0);
+		if (err < 0)
+			dev_err(&pdev->dev, "Error in clearing external "
+				"control\n");
+	}
+}
+
 static struct platform_driver tps65910_driver = {
 	.driver = {
 		.name = "tps65910-pmic",
@@ -1011,6 +1185,7 @@ static struct platform_driver tps65910_driver = {
 	},
 	.probe = tps65910_probe,
 	.remove = __devexit_p(tps65910_remove),
+	.shutdown = tps65910_shutdown,
 };
 
 static int __init tps65910_init(void)
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index d0cb12e..7c2f1b7 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -768,6 +768,19 @@
 /* Max number of TPS65910/11 regulators */
 #define TPS65910_NUM_REGS				13
 
+/* External sleep controls through EN1/EN2/EN3 inputs*/
+#define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1		0x1
+#define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2		0x2
+#define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3		0x4
+
+/*
+ * Regulator mode when rail is in sleep state which controlled by external
+ * input. The regultor will be OFF if it is in sleep state by default but
+ * can be set in LOW power mode by ORing following macro with any of
+ * above exterenl input option.
+ */
+#define TPS65910_SLEEP_CONTROL_REG_LOW_POWER		0x10
+
 /**
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
@@ -779,6 +792,7 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
+	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
 };
 
-- 
1.7.1.1

