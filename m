Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0LVGYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:24:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0LVGYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:24:15 -0500
Date: Wed, 22 Dec 2010 15:23:10 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 5/6] MFD MAX8998/LP3974: Charger Support
In-reply-to: <20101221155004.GA21871@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292998991-26968-6-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 22 Dec 2010 06:23:11.0827 (UTC)
 FILETIME=[B545A230:01CBA1A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new regulator, "CHARGER", users can control charging
current and turn on and off the charger. Note that the charger
specification of LP3974 is different from that of MAX8998.

"CHARGER_ONLINE" monitors the charger status, which can be
different from the status "CHARGER"; e.g., users allowed the charger
to charge, but the MAX8998 chip decided not to do so.

"BATTERY_ONLINE" monitors the battery status (the existence of the
battery).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8998.c |  235 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/max8998.h |   17 +++
 2 files changed, 250 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index d183756..1c0bbd0 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -44,6 +44,7 @@ struct max8998_data {
 	unsigned int		buck1_idx; /* index to last changed voltage */
 					   /* value in a set */
 	unsigned int		buck2_idx;
+	unsigned int		eoc_in_mA;
 };
 
 struct voltage_map_desc {
@@ -86,6 +87,13 @@ static const struct voltage_map_desc buck3_voltage_map_desc = {
 static const struct voltage_map_desc buck4_voltage_map_desc = {
 	.min = 800,	.step = 100,	.max = 2300,
 };
+static const int charger_current_map_desc_max8998[] = {
+	90, 380, 475, 550, 570, 600, 700, 800
+};
+static const int charger_current_map_desc_lp3974[] = {
+	100, 400, 450, 500, 550, 600, 700, 800
+};
+static const int *charger_current_map_desc;
 
 static const struct voltage_map_desc *ldo_voltage_map[] = {
 	NULL,
@@ -115,6 +123,9 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	NULL,				/* ENVICHG */
 	NULL,				/* ESAFEOUT1 */
 	NULL,				/* ESAFEOUT2 */
+	NULL,				/* CHARGER */
+	NULL,				/* CHARGER_ONLINE */
+	NULL,				/* BATTERY_ONLINE */
 };
 
 static inline int max8998_get_ldo(struct regulator_dev *rdev)
@@ -173,6 +184,18 @@ static int max8998_get_enable_register(struct regulator_dev *rdev,
 		*reg = MAX8998_REG_CHGR2;
 		*shift = 7 - (ldo - MAX8998_ESAFEOUT1);
 		break;
+	case MAX8998_CHARGER:
+		*reg = MAX8998_REG_CHGR2;
+		*shift = 0;
+		break;
+	case MAX8998_CHARGER_ONLINE:
+		*reg = MAX8998_REG_STATUS2;
+		*shift = 3;
+		break;
+	case MAX8998_BATTERY_ONLINE:
+		*reg = MAX8998_REG_STATUS2;
+		*shift = 4;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -198,6 +221,14 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
 	return val & (1 << shift);
 }
 
+static int max8998_ldo_is_enabled_negated(struct regulator_dev *rdev)
+{
+	int ret = max8998_ldo_is_enabled(rdev);
+	if (ret >= 0)
+		ret = !ret;
+	return ret;
+}
+
 static int max8998_ldo_enable(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
@@ -492,6 +523,113 @@ buck1_exit:
 	return ret;
 }
 
+/*
+ * max89998_update_eoc() sets EOC ratio. It uses
+ * the greatest EOC ratio that results in equal to or lower than the
+ * specified "eoc_in_mA" value. If no such value exists, it's 10%.
+**/
+static void max8998_update_eoc(struct max8998_data *max8998)
+{
+	struct i2c_client *i2c = max8998->iodev->i2c;
+	int charge_current = 0;
+	int target_eoc_ratio;
+	u8 val;
+
+	/* Nothing to do. User set EOC with % */
+	if (max8998->eoc_in_mA == 0)
+		return;
+
+	/* Not initialized. */
+	if (!charger_current_map_desc)
+		return;
+
+	if (max8998_read_reg(i2c, MAX8998_REG_CHGR1, &val))
+		return;
+
+	charge_current = charger_current_map_desc[val & 0x07];
+
+	target_eoc_ratio = max8998->eoc_in_mA / charge_current * 100;
+
+	if (target_eoc_ratio < 10)
+		target_eoc_ratio = 10;
+	if (target_eoc_ratio > 45)
+		target_eoc_ratio = 45;
+
+	max8998_update_reg(i2c, MAX8998_REG_CHGR1,
+			(target_eoc_ratio / 5 - 2) << 5,
+			0x7 << 5);
+}
+
+static int max8998_charger_current_set(struct regulator_dev *rdev,
+					int min_uA, int max_uA)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
+	int reg = MAX8998_REG_CHGR1;
+	int shift = 0;
+	int mask = 0x7;
+	int ret;
+	u8 val;
+	int chosen = -1, chosen_current = -1;
+	int i;
+
+	if (!charger_current_map_desc)
+		return -ENXIO;
+
+	for (i = 0; i < (mask + 1); i++) {
+		int temp = charger_current_map_desc[i];
+		if (temp >= (min_uA / 1000) && temp <= (max_uA / 1000) &&
+				temp > chosen_current) {
+			chosen = i;
+			chosen_current = temp;
+		}
+	}
+
+	if (chosen < 0)
+		return -EINVAL;
+
+	ret = max8998_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	val &= ~(mask << shift);
+	val |= (chosen & mask) << shift;
+
+	ret = max8998_write_reg(i2c, reg, val);
+	if (ret)
+		return ret;
+
+	dev_info(&rdev->dev, "charger current limit = %dmA (%xh)\n",
+			chosen_current, chosen);
+
+	max8998_update_eoc(max8998);
+
+	return 0;
+}
+
+static int max8998_charger_current_get(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
+	int reg = MAX8998_REG_CHGR1;
+	int shift = 0;
+	int mask = 0x7;
+	int ret;
+	u8 val;
+
+	ret = max8998_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= shift;
+	val &= mask;
+
+	if (!charger_current_map_desc)
+		return -ENXIO;
+
+	return charger_current_map_desc[val] * 1000;
+}
+
 static struct regulator_ops max8998_ldo_ops = {
 	.list_voltage		= max8998_list_voltage,
 	.is_enabled		= max8998_ldo_is_enabled,
@@ -522,6 +660,20 @@ static struct regulator_ops max8998_others_ops = {
 	.set_suspend_disable	= max8998_ldo_disable,
 };
 
+/* The enable bit is negated */
+static struct regulator_ops max8998_charger_ops = {
+	.is_enabled		= max8998_ldo_is_enabled_negated,
+	/* enable and disable are intentionally negated */
+	.enable			= max8998_ldo_disable,
+	.disable		= max8998_ldo_enable,
+	.set_current_limit	= max8998_charger_current_set,
+	.get_current_limit	= max8998_charger_current_get,
+};
+
+static struct regulator_ops max8998_neg_online_ops = {
+	.is_enabled		= max8998_ldo_is_enabled_negated,
+};
+
 static struct regulator_desc regulators[] = {
 	{
 		.name		= "LDO2",
@@ -673,7 +825,25 @@ static struct regulator_desc regulators[] = {
 		.ops		= &max8998_others_ops,
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
-	}
+	}, {
+		.name		= "CHARGER",
+		.id		= MAX8998_CHARGER,
+		.ops		= &max8998_charger_ops,
+		.type		= REGULATOR_CURRENT,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "CHARGER_ONLINE",
+		.id		= MAX8998_CHARGER_ONLINE,
+		.ops		= &max8998_neg_online_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BATTERY_ONLINE",
+		.id		= MAX8998_BATTERY_ONLINE,
+		.ops		= &max8998_neg_online_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	},
 };
 
 static __devinit int max8998_pmic_probe(struct platform_device *pdev)
@@ -787,13 +957,27 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 
 	}
 
+	switch (pdev->id_entry->driver_data) {
+	case TYPE_MAX8998:
+		charger_current_map_desc = charger_current_map_desc_max8998;
+		break;
+	case TYPE_LP3974:
+		charger_current_map_desc = charger_current_map_desc_lp3974;
+		break;
+	default:
+		ret = -ENODEV;
+		goto err;
+	}
+
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct voltage_map_desc *desc;
 		int id = pdata->regulators[i].id;
 		int index = id - MAX8998_LDO2;
 
 		desc = ldo_voltage_map[id];
-		if (desc && regulators[index].ops != &max8998_others_ops) {
+		if (desc && regulators[index].ops != &max8998_others_ops &&
+		    regulators[index].ops != &max8998_charger_ops &&
+		    regulators[index].ops != &max8998_neg_online_ops) {
 			int count = (desc->max - desc->min) / desc->step + 1;
 			regulators[index].n_voltages = count;
 		}
@@ -807,6 +991,53 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
+	max8998->eoc_in_mA = 0;
+	/* Setup "End of Charge" */
+	if (pdata->eoc >= 10 && pdata->eoc <= 45) {
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1,
+				(pdata->eoc / 5 - 2) << 5, 0x7 << 5);
+	} else if (pdata->eoc >= 50) {
+		max8998->eoc_in_mA = pdata->eoc;
+		max8998_update_eoc(max8998);
+	} else {
+		dev_info(max8998->dev, "EOC value not set: leave it unchanged.\n");
+	}
+
+	/* Setup Charge Restart Level */
+	switch (pdata->restart) {
+	case 100:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1, 0x1 << 3, 0x3 << 3);
+		break;
+	case 150:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1, 0x0 << 3, 0x3 << 3);
+		break;
+	case 200:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1, 0x2 << 3, 0x3 << 3);
+		break;
+	case -1:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1, 0x3 << 3, 0x3 << 3);
+		break;
+	default:
+		dev_info(max8998->dev, "Restart Level not set: leave it unchanged.\n");
+	}
+
+	/* Setup Charge Full Timeout */
+	switch (pdata->timeout) {
+	case 5:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR2, 0x0 << 4, 0x3 << 4);
+		break;
+	case 6:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR2, 0x1 << 4, 0x3 << 4);
+		break;
+	case 7:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR2, 0x2 << 4, 0x3 << 4);
+		break;
+	case -1:
+		max8998_update_reg(i2c, MAX8998_REG_CHGR2, 0x3 << 4, 0x3 << 4);
+		break;
+	default:
+		dev_info(max8998->dev, "Full Timeout not set: leave it unchanged.\n");
+	}
 
 	return 0;
 err:
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 686a744..9c56839 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -52,6 +52,14 @@ enum {
 	MAX8998_ENVICHG,
 	MAX8998_ESAFEOUT1,
 	MAX8998_ESAFEOUT2,
+	/*
+	 * CHARGER: Controls ON/OFF, current limit of the charger.
+	 * However, note that even if CHARGER is ON, CHARGER_ONLINE
+	 * can be in "disabled" state by MAX8998 internal control.
+	**/
+	MAX8998_CHARGER,
+	MAX8998_CHARGER_ONLINE, /* "is_enabled" is the only permitted op. */
+	MAX8998_BATTERY_ONLINE, /* "is_enabled" is the only permitted op. */
 };
 
 /**
@@ -76,6 +84,12 @@ struct max8998_regulator_data {
  * @buck1_set1: BUCK1 gpio pin 1 to set output voltage
  * @buck1_set2: BUCK1 gpio pin 2 to set output voltage
  * @buck2_set3: BUCK2 gpio pin to set output voltage
+ * @eoc: End of Charge Level: 10 ~ 45% or if it's over 45, in mA.
+ *   If it's under 10, leave it unchanged.
+ * @restart: Restart Level in mV: 100, 150, 200, and -1 for disable.
+ *   Otherwise, leave it unchanged.
+ * @timeout: Full Timeout in hours: 5, 6, 7, and -1 for disable.
+ *  Otherwise, leave it unchanged.
  */
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
@@ -89,6 +103,9 @@ struct max8998_platform_data {
 	int				buck1_set2;
 	int				buck2_set3;
 	bool				wakeup;
+	int				eoc;
+	int				restart;
+	int				timeout;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1

