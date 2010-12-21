Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab0LUCWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 21:22:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29075 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484Ab0LUCWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 21:22:17 -0500
Date: Tue, 21 Dec 2010 11:22:08 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] MFD MAX8998/LP3974: Add Features: hibernation, charger,
 and other misc.
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292898128-32647-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 21 Dec 2010 02:22:08.0369 (UTC)
 FILETIME=[DDF75610:01CBA0B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Hibernation support
	With runtime-pm, this patch allows to save and restore register
values for hibernation.

2. Charger support
	With the new regulator, "CHARGER", users can control charging
current and turn on and off the charger. Note that charger specification
of LP3974 is different from that of MAX8998.
	"CHARGER_ONLINE" monitors the charger status, which can be
different from the status "CHARGER"; e.g., users allowed the charger
to charge, but the MAX8998 chip decided not to do so.
	"BATTERY_ONLINE" monitors the battery status.

	In the platform data, users can provide charger-related
information: "End of Charge Level", "Charge Restart Level", and "Charger
Full Timeout".

3. Support LP3974 RTC.
	The first releases of LP3974 have a large delay in RTC registers,
which requires a huge delay (msleep) after writing to a rtc register
before reading it. If the device name is "lp3974-regerr", the rtc driver
assumes that such delays are required. If the device name is "lp3974",
the rtc driver does not; although we have not seen LP3974s without
requiring such delays, we assume that such LP3974s will be released
soon (or they have done so already).

4. Support wider ranges for DVS-GPIO
	The previous release of this driver did not use GPIOs provided
for DVS support fully. This patch allows the driver to use all DVS
GPIOs.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998-irq.c           |    7 +
 drivers/mfd/max8998.c               |  149 +++++++++++++++-
 drivers/regulator/max8998.c         |  334 ++++++++++++++++++++++++++++++++---
 drivers/rtc/rtc-max8998.c           |   56 ++++++-
 include/linux/mfd/max8998-private.h |    3 +
 include/linux/mfd/max8998.h         |   36 ++++-
 6 files changed, 553 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index 45bfe77..93c621d 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -181,6 +181,13 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+int max8998_irq_resume(struct max8998_dev *max8998)
+{
+	if (max8998->irq && max8998->irq_base)
+		max8998_irq_thread(max8998->irq_base, max8998);
+	return 0;
+}
+
 int max8998_irq_init(struct max8998_dev *max8998)
 {
 	int i;
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index bb9977b..8b9eed1 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -25,6 +25,8 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8998.h>
@@ -40,6 +42,22 @@ static struct mfd_cell max8998_devs[] = {
 	},
 };
 
+static struct mfd_cell lp3974_devs[] = {
+	{
+		.name = "lp3974-pmic",
+	}, {
+		.name = "lp3974-rtc",
+	},
+};
+
+static struct mfd_cell lp3974_regerr_devs[] = {
+	{
+		.name = "lp3974-pmic",
+	}, {
+		.name = "lp3974-rtc-regerr",
+	},
+};
+
 int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 {
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
@@ -135,6 +153,7 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	if (pdata) {
 		max8998->ono = pdata->ono;
 		max8998->irq_base = pdata->irq_base;
+		max8998->wakeup = pdata->wakeup;
 	}
 	mutex_init(&max8998->iolock);
 
@@ -143,9 +162,29 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 	max8998_irq_init(max8998);
 
-	ret = mfd_add_devices(max8998->dev, -1,
-			      max8998_devs, ARRAY_SIZE(max8998_devs),
-			      NULL, 0);
+	pm_runtime_set_active(max8998->dev);
+
+	switch (id->driver_data) {
+	case TYPE_LP3974_REGERR:
+		ret = mfd_add_devices(max8998->dev, -1,
+				lp3974_regerr_devs,
+				ARRAY_SIZE(lp3974_regerr_devs),
+				NULL, 0);
+		break;
+	case TYPE_LP3974:
+		ret = mfd_add_devices(max8998->dev, -1,
+				lp3974_devs, ARRAY_SIZE(lp3974_devs),
+				NULL, 0);
+		break;
+	case TYPE_MAX8998:
+		ret = mfd_add_devices(max8998->dev, -1,
+				max8998_devs, ARRAY_SIZE(max8998_devs),
+				NULL, 0);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
 	if (ret < 0)
 		goto err;
 
@@ -174,14 +213,118 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 static const struct i2c_device_id max8998_i2c_id[] = {
 	{ "max8998", TYPE_MAX8998 },
 	{ "lp3974", TYPE_LP3974},
+	{ "lp3974-regerr", TYPE_LP3974_REGERR },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
 
+static int max8998_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+
+	if (max8998->wakeup)
+		set_irq_wake(max8998->irq, 1);
+	return 0;
+}
+
+static int max8998_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+
+	if (max8998->wakeup)
+		set_irq_wake(max8998->irq, 0);
+	/*
+	 * In LP3974, if IRQ registers are not "read & clear"
+	 * when it's set during sleep, the interrupt becomes
+	 * disabled.
+	 */
+	return max8998_irq_resume(i2c_get_clientdata(i2c));
+}
+
+struct max8998_reg_dump {
+	u8	addr;
+	u8	val;
+};
+#define SAVE_ITEM(x)	{ .addr = (x), .val = 0x0, }
+struct max8998_reg_dump max8998_dump[] = {
+	SAVE_ITEM(MAX8998_REG_IRQM1),
+	SAVE_ITEM(MAX8998_REG_IRQM2),
+	SAVE_ITEM(MAX8998_REG_IRQM3),
+	SAVE_ITEM(MAX8998_REG_IRQM4),
+	SAVE_ITEM(MAX8998_REG_STATUSM1),
+	SAVE_ITEM(MAX8998_REG_STATUSM2),
+	SAVE_ITEM(MAX8998_REG_CHGR1),
+	SAVE_ITEM(MAX8998_REG_CHGR2),
+	SAVE_ITEM(MAX8998_REG_LDO_ACTIVE_DISCHARGE1),
+	SAVE_ITEM(MAX8998_REG_LDO_ACTIVE_DISCHARGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK_ACTIVE_DISCHARGE3),
+	SAVE_ITEM(MAX8998_REG_ONOFF1),
+	SAVE_ITEM(MAX8998_REG_ONOFF2),
+	SAVE_ITEM(MAX8998_REG_ONOFF3),
+	SAVE_ITEM(MAX8998_REG_ONOFF4),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE2),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE3),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE4),
+	SAVE_ITEM(MAX8998_REG_BUCK2_VOLTAGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK2_VOLTAGE2),
+	SAVE_ITEM(MAX8998_REG_LDO2_LDO3),
+	SAVE_ITEM(MAX8998_REG_LDO4),
+	SAVE_ITEM(MAX8998_REG_LDO5),
+	SAVE_ITEM(MAX8998_REG_LDO6),
+	SAVE_ITEM(MAX8998_REG_LDO7),
+	SAVE_ITEM(MAX8998_REG_LDO8_LDO9),
+	SAVE_ITEM(MAX8998_REG_LDO10_LDO11),
+	SAVE_ITEM(MAX8998_REG_LDO12),
+	SAVE_ITEM(MAX8998_REG_LDO13),
+	SAVE_ITEM(MAX8998_REG_LDO14),
+	SAVE_ITEM(MAX8998_REG_LDO15),
+	SAVE_ITEM(MAX8998_REG_LDO16),
+	SAVE_ITEM(MAX8998_REG_LDO17),
+	SAVE_ITEM(MAX8998_REG_BKCHR),
+	SAVE_ITEM(MAX8998_REG_LBCNFG1),
+	SAVE_ITEM(MAX8998_REG_LBCNFG2),
+};
+/* Save registers before hibernation */
+static int max8998_freeze(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8998_dump); i++)
+		max8998_read_reg(i2c, max8998_dump[i].addr,
+				&max8998_dump[i].val);
+
+	return 0;
+}
+
+/* Restore registers after hibernation */
+static int max8998_restore(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8998_dump); i++)
+		max8998_write_reg(i2c, max8998_dump[i].addr,
+				max8998_dump[i].val);
+
+	return 0;
+}
+
+const struct dev_pm_ops max8998_pm = {
+	.suspend = max8998_suspend,
+	.resume = max8998_resume,
+	.freeze = max8998_freeze,
+	.restore = max8998_restore,
+};
+
 static struct i2c_driver max8998_i2c_driver = {
 	.driver = {
 		   .name = "max8998",
 		   .owner = THIS_MODULE,
+		   .pm = &max8998_pm,
 	},
 	.probe = max8998_i2c_probe,
 	.remove = max8998_i2c_remove,
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5c20756..58426f9 100644
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
@@ -110,6 +118,14 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	&buck12_voltage_map_desc,	/* BUCK2 */
 	&buck3_voltage_map_desc,	/* BUCK3 */
 	&buck4_voltage_map_desc,	/* BUCK4 */
+	NULL,				/* EN32KHZ_AP */
+	NULL,				/* EN32KHZ_CP */
+	NULL,				/* ENVICHG */
+	NULL,				/* ESAFEOUT1 */
+	NULL,				/* ESAFEOUT2 */
+	NULL,				/* CHARGER */
+	NULL,				/* CHARGER_ONLINE */
+	NULL,				/* BATTERY_ONLINE */
 };
 
 static inline int max8998_get_ldo(struct regulator_dev *rdev)
@@ -168,6 +184,18 @@ static int max8998_get_enable_register(struct regulator_dev *rdev,
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
@@ -193,6 +221,14 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
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
@@ -420,6 +456,9 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 				}
 			}
 
+			if (pdata->buck_max_voltage_lock)
+				return -EINVAL;
+
 			/* no predefine regulator found */
 			max8998->buck1_idx = (buck1_last_val % 2) + 2;
 			dev_dbg(max8998->dev, "max8998->buck1_idx:%d\n",
@@ -447,18 +486,26 @@ buck1_exit:
 			"BUCK2, i:%d buck2_vol1:%d, buck2_vol2:%d\n"
 			, i, max8998->buck2_vol[0], max8998->buck2_vol[1]);
 		if (gpio_is_valid(pdata->buck2_set3)) {
-			if (max8998->buck2_vol[0] == i) {
-				max8998->buck1_idx = 0;
-				buck2_gpio_set(pdata->buck2_set3, 0);
-			} else {
-				max8998->buck1_idx = 1;
-				ret = max8998_get_voltage_register(rdev, &reg,
-								   &shift,
-								   &mask);
-				ret = max8998_write_reg(i2c, reg, i);
-				max8998->buck2_vol[1] = i;
-				buck2_gpio_set(pdata->buck2_set3, 1);
+
+			/* check if requested voltage */
+			/* value is already defined */
+			for (j = 0; j < ARRAY_SIZE(max8998->buck2_vol); j++) {
+				if (max8998->buck2_vol[j] == i) {
+					max8998->buck2_idx = j;
+					buck2_gpio_set(pdata->buck2_set3, j);
+					goto buck2_exit;
+				}
 			}
+
+			if (pdata->buck_max_voltage_lock)
+				return -EINVAL;
+
+			max8998_get_voltage_register(rdev,
+					&reg, &shift, &mask);
+			ret = max8998_write_reg(i2c, reg, i);
+			max8998->buck2_vol[max8998->buck2_idx] = i;
+			buck2_gpio_set(pdata->buck2_set3, max8998->buck2_idx);
+buck2_exit:
 			dev_dbg(max8998->dev, "%s: SET3:%d\n", i2c->name,
 				gpio_get_value(pdata->buck2_set3));
 		} else {
@@ -487,6 +534,113 @@ buck1_exit:
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
@@ -517,6 +671,20 @@ static struct regulator_ops max8998_others_ops = {
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
@@ -668,7 +836,25 @@ static struct regulator_desc regulators[] = {
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
@@ -703,6 +889,9 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, max8998);
 	i2c = max8998->iodev->i2c;
 
+	max8998->buck1_idx = pdata->buck1_default_idx;
+	max8998->buck2_idx = pdata->buck2_default_idx;
+
 	/* NOTE: */
 	/* For unused GPIO NOT marked as -1 (thereof equal to 0)  WARN_ON */
 	/* will be displayed */
@@ -735,9 +924,9 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck1_max_voltage1 / 1000))
+		       < (pdata->buck1_max_voltage1 / 1000))
 			i++;
-		printk(KERN_ERR "i:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
+		printk(KERN_ERR "i1:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
 
@@ -745,13 +934,35 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck1_max_voltage2 / 1000))
+		       < (pdata->buck1_max_voltage2 / 1000))
 			i++;
 
 		max8998->buck1_vol[1] = i;
-		printk(KERN_ERR "i:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i)
-			+ ret;
+		printk(KERN_ERR "i2:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
+		ret += max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i);
+
+		/* Set predefined value for BUCK1 register 3 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck1_max_voltage3 / 1000))
+			i++;
+
+		max8998->buck1_vol[2] = i;
+		printk(KERN_ERR "i3:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
+		ret += max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE3, i);
+
+		/* Set predefined value for BUCK1 register 4 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck1_max_voltage4 / 1000))
+			i++;
+
+		max8998->buck1_vol[3] = i;
+		printk(KERN_ERR "i4:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
+		ret += max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE4, i);
+
 		if (ret)
 			return ret;
 
@@ -768,27 +979,52 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		gpio_direction_output(pdata->buck2_set3,
 				      max8998->buck2_idx & 0x1);
 
-		/* BUCK2 - set preset default voltage value to buck2_vol[0] */
+		/* BUCK2 register 1 */
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck2_max_voltage / 1000))
+		       < (pdata->buck2_max_voltage1 / 1000))
 			i++;
-		printk(KERN_ERR "i:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
+		printk(KERN_ERR "i1:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
+
+		/* BUCK2 register 2 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck2_max_voltage2 / 1000))
+			i++;
+		printk(KERN_ERR "i2:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
+		max8998->buck2_vol[1] = i;
+		ret += max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
+
 		if (ret)
 			return ret;
 
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
@@ -802,6 +1038,53 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
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
@@ -831,6 +1114,12 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max8998_pmic_id[] = {
+	{ "max8998-pmic", TYPE_MAX8998 },
+	{ "lp3974-pmic", TYPE_LP3974 },
+	{ }
+};
+
 static struct platform_driver max8998_pmic_driver = {
 	.driver = {
 		.name = "max8998-pmic",
@@ -838,6 +1127,7 @@ static struct platform_driver max8998_pmic_driver = {
 	},
 	.probe = max8998_pmic_probe,
 	.remove = __devexit_p(max8998_pmic_remove),
+	.id_table = max8998_pmic_id,
 };
 
 static int __init max8998_pmic_init(void)
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index f22dee3..d9012bb 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -20,6 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/max8998.h>
 #include <linux/mfd/max8998-private.h>
+#include <linux/delay.h>
+
 
 #define MAX8998_RTC_SEC			0x00
 #define MAX8998_RTC_MIN			0x01
@@ -73,6 +75,7 @@ struct max8998_rtc_info {
 	struct i2c_client	*rtc;
 	struct rtc_device	*rtc_dev;
 	int irq;
+	bool lp3974_bug_workaround;
 };
 
 static void max8998_data_to_tm(u8 *data, struct rtc_time *tm)
@@ -124,10 +127,16 @@ static int max8998_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct max8998_rtc_info *info = dev_get_drvdata(dev);
 	u8 data[8];
+	int ret;
 
 	max8998_tm_to_data(tm, data);
 
-	return max8998_bulk_write(info->rtc, MAX8998_RTC_SEC, 8, data);
+	ret = max8998_bulk_write(info->rtc, MAX8998_RTC_SEC, 8, data);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -163,12 +172,29 @@ static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int max8998_rtc_stop_alarm(struct max8998_rtc_info *info)
 {
-	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
+	int ret = max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_start_alarm(struct max8998_rtc_info *info)
 {
-	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0x77);
+	int ret;
+	u8 alarm0_conf = 0x77;
+
+	/* LP3974 Prelim Chips has rtc alarm bugs with "MONTH" field */
+	if (info->lp3974_bug_workaround)
+		alarm0_conf = 0x57;
+
+	ret = max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, alarm0_conf);
+
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
+	return ret;
 }
 
 static int max8998_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -187,10 +213,13 @@ static int max8998_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		return ret;
 
+	if (info->lp3974_bug_workaround)
+		msleep(2000);
+
 	if (alrm->enabled)
-		return max8998_rtc_start_alarm(info);
+		ret = max8998_rtc_start_alarm(info);
 
-	return 0;
+	return ret;
 }
 
 static int max8998_rtc_alarm_irq_enable(struct device *dev,
@@ -249,10 +278,18 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
+
 	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
 
+	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
+	if (pdev->id_entry->driver_data == TYPE_LP3974_REGERR) {
+		info->lp3974_bug_workaround = true;
+		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
+				" RTC updates will be extremely slow.\n");
+	}
+
 	return 0;
 
 out_rtc:
@@ -273,6 +310,14 @@ static int __devexit max8998_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max8998_rtc_id[] = {
+	{ "max8998-rtc", TYPE_MAX8998 },
+	{ "lp3974-rtc", TYPE_LP3974 },
+	/* REGERR: requires 1 ~ 2 s of delay after writing to RTC registers */
+	{ "lp3974-rtc-regerr", TYPE_LP3974_REGERR },
+	{ }
+};
+
 static struct platform_driver max8998_rtc_driver = {
 	.driver		= {
 		.name	= "max8998-rtc",
@@ -280,6 +325,7 @@ static struct platform_driver max8998_rtc_driver = {
 	},
 	.probe		= max8998_rtc_probe,
 	.remove		= __devexit_p(max8998_rtc_remove),
+	.id_table	= max8998_rtc_id,
 };
 
 static int __init max8998_rtc_init(void)
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index 7363dea..f107f42 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -105,6 +105,7 @@ enum {
 enum {
 	TYPE_MAX8998 = 0, /* Default */
 	TYPE_LP3974,	/* National version of MAX8998 */
+	TYPE_LP3974_REGERR, /* National version of MAX8998 with RTC REG BUG */
 	TYPE_LP3979,	/* Added AVS */
 };
 
@@ -159,10 +160,12 @@ struct max8998_dev {
 	u8 irq_masks_cur[MAX8998_NUM_IRQ_REGS];
 	u8 irq_masks_cache[MAX8998_NUM_IRQ_REGS];
 	int type;
+	bool wakeup;
 };
 
 int max8998_irq_init(struct max8998_dev *max8998);
 void max8998_irq_exit(struct max8998_dev *max8998);
+int max8998_irq_resume(struct max8998_dev *max8998);
 
 extern int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
 extern int max8998_bulk_read(struct i2c_client *i2c, u8 reg, int count,
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index f8c9f88..5e21238 100644
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
@@ -70,24 +78,48 @@ struct max8998_regulator_data {
  * @num_regulators: number of regultors used
  * @irq_base: base IRQ number for max8998, required for IRQs
  * @ono: power onoff IRQ number for max8998
+ * @buck_max_voltage_lock: Do NOT change the values of the following six
+ *   registers set by buck?_max_voltage?. The voltage of BUCK1/2 cannot
+ *   be other than the preset values.
  * @buck1_max_voltage1: BUCK1 maximum alowed voltage register 1
  * @buck1_max_voltage2: BUCK1 maximum alowed voltage register 2
- * @buck2_max_voltage: BUCK2 maximum alowed voltage
+ * @buck1_max_voltage3: BUCK1 maximum alowed voltage register 3
+ * @buck1_max_voltage4: BUCK1 maximum alowed voltage register 4
+ * @buck2_max_voltage1: BUCK2 maximum alowed voltage register 1
+ * @buck2_max_voltage2: BUCK2 maximum alowed voltage register 2
  * @buck1_set1: BUCK1 gpio pin 1 to set output voltage
  * @buck1_set2: BUCK1 gpio pin 2 to set output voltage
+ * @buck1_default_idx: Default for BUCK1 gpio pin 1, 2
  * @buck2_set3: BUCK2 gpio pin to set output voltage
+ * @buck2_default_idx: Default for BUCK2 gpio pin.
+ * @eoc: End of Charge Level: 10 ~ 45% or if it's over 45, in mA.
+ *   If it's under 10, leave it unchanged.
+ * @restart: Restart Level in mV: 100, 150, 200, and -1 for disable.
+ *   Otherwise, leave it unchanged.
+ * @timeout: Full Timeout in hours: 5, 6, 7, and -1 for disable.
+ *  Otherwise, leave it unchanged.
  */
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
 	int				num_regulators;
 	int				irq_base;
 	int				ono;
+	bool				buck_max_voltage_lock;
 	int                             buck1_max_voltage1;
 	int                             buck1_max_voltage2;
-	int                             buck2_max_voltage;
+	int                             buck1_max_voltage3;
+	int                             buck1_max_voltage4;
+	int                             buck2_max_voltage1;
+	int                             buck2_max_voltage2;
 	int				buck1_set1;
 	int				buck1_set2;
+	int				buck1_default_idx;
 	int				buck2_set3;
+	int				buck2_default_idx;
+	bool				wakeup;
+	int				eoc;
+	int				restart;
+	int				timeout;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1

