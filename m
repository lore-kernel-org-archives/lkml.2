Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1FXKFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:05:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30339 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1FXKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:05:00 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-db-4e046134914e
Date: Fri, 24 Jun 2011 19:04:19 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH 2/2] regulator: Add a new regulator for charge control of
 MAX8998/LP3974
In-reply-to: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Message-id: <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
X-OriginalArrivalTime: 24 Jun 2011 10:04:53.0088 (UTC)
 FILETIME=[2972FE00:01CC3256]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new regulator, "CHARGER", users can control charging current and
turn on and off the charger.
Note that the charger specification of LP3974 is different from
that of MAX8998.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8998.c |  137 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/max8998.h |    6 ++
 2 files changed, 140 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 41a1495..8ddd299 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -86,6 +86,14 @@ static const struct voltage_map_desc buck3_voltage_map_desc = {
 static const struct voltage_map_desc buck4_voltage_map_desc = {
 	.min = 800,	.step = 100,	.max = 2300,
 };
+static const int charger_current_map_desc_max8998[] = {
+	90, 380, 475, 550, 570, 600, 700, 800
+};
+static const int charger_current_map_desc_lp3974[] = {
+	100, 400, 450, 500, 550, 600, 700, 800
+};
+
+static const int *charger_current_map_desc;
 
 static const struct voltage_map_desc *ldo_voltage_map[] = {
 	NULL,
@@ -110,6 +118,12 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	&buck12_voltage_map_desc,	/* BUCK2 */
 	&buck3_voltage_map_desc,	/* BUCK3 */
 	&buck4_voltage_map_desc,	/* BUCK4 */
+	NULL,				/* EN32KHZ_AP */
+	NULL,				/* EN32KHZ_CP */
+	NULL,				/* ENVICHG */
+	NULL,				/* ESAFEOUT1 */
+	NULL,				/* ESAFEOUT2 */
+	NULL,				/* CHARGER */
 };
 
 static inline int max8998_get_ldo(struct regulator_dev *rdev)
@@ -168,6 +182,10 @@ static int max8998_get_enable_register(struct regulator_dev *rdev,
 		*reg = MAX8998_REG_CHGR2;
 		*shift = 7 - (ldo - MAX8998_ESAFEOUT1);
 		break;
+	case MAX8998_CHARGER:
+		*reg = MAX8998_REG_CHGR2;
+		*shift = 0;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -193,6 +211,14 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
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
@@ -502,6 +528,74 @@ buck2_exit:
 	return ret;
 }
 
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
+	dev_dbg(&rdev->dev, "charger current limit = %dmA (%xh)\n",
+			chosen_current, chosen);
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
@@ -532,6 +626,22 @@ static struct regulator_ops max8998_others_ops = {
 	.set_suspend_disable	= max8998_ldo_disable,
 };
 
+static struct regulator_ops max8998_charger_ops = {
+	.is_enabled		= max8998_ldo_is_enabled_negated,
+	/*
+	 * Enable and disable are intentionally negated as the charger
+	 * control bit is active-negative while others are active-positive.
+	 */
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
@@ -683,7 +793,13 @@ static struct regulator_desc regulators[] = {
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
+	},
 };
 
 static __devinit int max8998_pmic_probe(struct platform_device *pdev)
@@ -836,13 +952,29 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 			goto err_free_mem;
 	}
 
+	switch (pdev->id_entry->driver_data) {
+	case TYPE_MAX8998:
+		charger_current_map_desc =
+			charger_current_map_desc_max8998;
+		break;
+	case TYPE_LP3974:
+		charger_current_map_desc =
+			charger_current_map_desc_lp3974;
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
@@ -856,7 +988,6 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-
 	return 0;
 err:
 	for (i = 0; i < max8998->num_regulators; i++)
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index f4f0dfa..c085935 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -52,6 +52,12 @@ enum {
 	MAX8998_ENVICHG,
 	MAX8998_ESAFEOUT1,
 	MAX8998_ESAFEOUT2,
+	/*
+	 * CHARGER: Controls ON/OFF, current limit of the charger.
+	 * However, note that even if CHARGER is ON, CHARGER_ONLINE
+	 * can be in "disabled" state by MAX8998 internal control.
+	**/
+	MAX8998_CHARGER,
 };
 
 /**
-- 
1.7.4.1

