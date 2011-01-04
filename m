Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1ADFYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:24:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1ADFYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:24:33 -0500
Date: Tue, 04 Jan 2011 14:17:41 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v4 3/3] MFD MAX8998/LP3974: Support Charger
In-reply-to: <20101224113805.GI27832@sortiz-mobl>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1294118261-18906-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101224113805.GI27832@sortiz-mobl>
X-OriginalArrivalTime: 04 Jan 2011 05:17:41.0859 (UTC)
 FILETIME=[B632DB30:01CBABCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new regulator, "CHARGER", users can control charging
current and turn on and off the charger. Note that the charger
specification of LP3974 is different from that of MAX8998.

driver/power/max8998.c supports power supply APIs for

1. "ONLINE" monitors the charger status, which can be
different from the status "CHARGER"; e.g., users allowed the charger
to charge, but the MAX8998 chip decided not to do so.

2. "PRESENT" monitors the battery status (the existence of the
battery).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998.c               |    4 +
 drivers/power/Kconfig               |    7 +
 drivers/power/Makefile              |    1 +
 drivers/power/max8998.c             |  265 +++++++++++++++++++++++++++++++++++
 drivers/regulator/max8998.c         |  129 +++++++++++++++++-
 include/linux/mfd/max8998-private.h |   12 ++-
 include/linux/mfd/max8998.h         |   15 ++
 7 files changed, 429 insertions(+), 4 deletions(-)
 create mode 100644 drivers/power/max8998.c

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index bbfe867..4716003 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -39,6 +39,8 @@ static struct mfd_cell max8998_devs[] = {
 		.name = "max8998-pmic",
 	}, {
 		.name = "max8998-rtc",
+	}, {
+		.name = "max8998-battery",
 	},
 };
 
@@ -47,6 +49,8 @@ static struct mfd_cell lp3974_devs[] = {
 		.name = "lp3974-pmic",
 	}, {
 		.name = "lp3974-rtc",
+	}, {
+		.name = "lp3974-battery",
 	},
 };
 
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 60d83d9..06b720c 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -185,4 +185,11 @@ config CHARGER_TWL4030
 	help
 	  Say Y here to enable support for TWL4030 Battery Charge Interface.
 
+config CHARGERCTRL_MAX8998
+	tristate "Battery charger driver for MAX8998/LP3974 PMIC"
+	depends on MFD_MAX8998 && REGULATOR_MAX8998
+	help
+	  Say Y to enable support for the battery charger control sysfs and
+	  platform data of MAX8998/LP3974 PMICs.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index c75772e..4e66b91 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
+obj-$(CONFIG_CHARGERCTRL_MAX8998)	+= max8998.o
diff --git a/drivers/power/max8998.c b/drivers/power/max8998.c
new file mode 100644
index 0000000..6e73b42
--- /dev/null
+++ b/drivers/power/max8998.c
@@ -0,0 +1,265 @@
+/*
+ * max8998.c - Power supply consumer driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electronics
+ *  MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/max8998.h>
+#include <linux/mfd/max8998-private.h>
+
+struct max8998_battery_data {
+	struct device *dev;
+	struct max8998_dev *iodev;
+	unsigned int eoc_in_mA;
+	struct power_supply battery;
+	enum max8998_type device_id;
+};
+
+static enum power_supply_property max8998_battery_props[] = {
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_PRESENT, /* the presence of battery */
+	POWER_SUPPLY_PROP_ONLINE, /* charger is active or not */
+};
+
+static const char * const manufacturers[] = {
+	[TYPE_MAX8998] = "Maxim",
+	[TYPE_LP3974] = "National Semiconductor",
+	[TYPE_UNKNOWN] = "Unknown",
+};
+
+/* Note that the charger control is done by a current regulator "CHARGER" */
+static int max8998_battery_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct max8998_battery_data *max8998 = container_of(psy,
+			struct max8998_battery_data, battery);
+	struct i2c_client *i2c = max8998->iodev->i2c;
+	int ret;
+	u8 reg;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		if (max8998->device_id == TYPE_MAX8998)
+			val->strval = manufacturers[TYPE_MAX8998];
+		else if (max8998->device_id == TYPE_LP3974)
+			val->strval = manufacturers[TYPE_LP3974];
+		else
+			val->strval = manufacturers[TYPE_UNKNOWN];
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		ret = max8998_read_reg(i2c, MAX8998_REG_STATUS2, &reg);
+		if (ret)
+			return ret;
+		if (reg & (1 << 4))
+			val->intval = 0;
+		else
+			val->intval = 1;
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = max8998_read_reg(i2c, MAX8998_REG_STATUS2, &reg);
+		if (ret)
+			return ret;
+		if (reg & (1 << 3))
+			val->intval = 0;
+		else
+			val->intval = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void _max8998_update_eoc(struct platform_device *pdev)
+{
+	struct max8998_battery_data *max8998 = platform_get_drvdata(pdev);
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
+/*
+ * max89998_update_eoc() sets EOC ratio. It uses
+ * the greatest EOC ratio that results in equal to or lower than the
+ * specified "eoc_in_mA" value. If no such value exists, it's 10%.
+**/
+void max8998_update_eoc(struct max8998_dev *mdev)
+{
+	_max8998_update_eoc(mdev->battery);
+}
+
+static __devinit int max8998_battery_probe(struct platform_device *pdev)
+{
+	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8998_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct max8998_battery_data *max8998;
+	struct i2c_client *i2c;
+	int ret = 0;
+
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "No platform init data supplied\n");
+		return -ENODEV;
+	}
+
+	max8998 = kzalloc(sizeof(struct max8998_battery_data), GFP_KERNEL);
+	if (!max8998)
+		return -ENOMEM;
+
+	max8998->eoc_in_mA = 0;
+	max8998->dev = &pdev->dev;
+	max8998->iodev = iodev;
+	iodev->battery = pdev;
+	platform_set_drvdata(pdev, max8998);
+	i2c = max8998->iodev->i2c;
+
+	/* Setup "End of Charge" */
+	if (pdata->eoc >= 10 && pdata->eoc <= 45) {
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1,
+				(pdata->eoc / 5 - 2) << 5, 0x7 << 5);
+	} else if (pdata->eoc >= 50) {
+		max8998->eoc_in_mA = pdata->eoc;
+		_max8998_update_eoc(pdev);
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
+
+	max8998->battery.name = "max8998_pmic";
+	max8998->battery.type = POWER_SUPPLY_TYPE_BATTERY;
+	max8998->battery.get_property = max8998_battery_get_property;
+	max8998->battery.properties = max8998_battery_props;
+	max8998->battery.num_properties = ARRAY_SIZE(max8998_battery_props);
+
+	ret = power_supply_register(max8998->dev, &max8998->battery);
+	if (ret) {
+		dev_err(max8998->dev, "failed: power supply register\n");
+		kfree(max8998);
+		return ret;
+	}
+
+	max8998->device_id = pdev->id_entry->driver_data;
+
+	return 0;
+}
+
+static int __devexit max8998_battery_remove(struct platform_device *pdev)
+{
+	struct max8998_battery_data *max8998 = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&max8998->battery);
+	kfree(max8998);
+
+	return 0;
+}
+
+static const struct platform_device_id max8998_battery_id[] = {
+	{ "max8998-battery", TYPE_MAX8998 },
+	{ "lp3974-battery", TYPE_LP3974 },
+};
+
+static struct platform_driver max8998_battery_driver = {
+	.driver = {
+		.name = "max8998-battery",
+		.owner = THIS_MODULE,
+	},
+	.probe = max8998_battery_probe,
+	.remove = __devexit_p(max8998_battery_remove),
+	.id_table = max8998_battery_id,
+};
+
+static int __init max8998_battery_init(void)
+{
+	return platform_driver_register(&max8998_battery_driver);
+}
+module_init(max8998_battery_init);
+
+static void __exit max8998_battery_cleanup(void)
+{
+	platform_driver_unregister(&max8998_battery_driver);
+}
+module_exit(max8998_battery_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 8998 battery control driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 9946488..0d38e64 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -86,6 +86,13 @@ static const struct voltage_map_desc buck3_voltage_map_desc = {
 static const struct voltage_map_desc buck4_voltage_map_desc = {
 	.min = 800,	.step = 100,	.max = 2300,
 };
+static const int charger_current_map_desc_max8998[] = {
+	90, 380, 475, 550, 570, 600, 700, 800
+};
+static const int charger_current_map_desc_lp3974[] = {
+	100, 400, 450, 500, 550, 600, 700, 800
+};
+const int *charger_current_map_desc;
 
 static const struct voltage_map_desc *ldo_voltage_map[] = {
 	NULL,
@@ -115,6 +122,7 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	NULL,				/* ENVICHG */
 	NULL,				/* ESAFEOUT1 */
 	NULL,				/* ESAFEOUT2 */
+	NULL,				/* CHARGER */
 };
 
 static inline int max8998_get_ldo(struct regulator_dev *rdev)
@@ -173,6 +181,10 @@ static int max8998_get_enable_register(struct regulator_dev *rdev,
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
@@ -198,6 +210,14 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
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
@@ -503,6 +523,76 @@ buck2_exit:
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
+	dev_info(&rdev->dev, "charger current limit = %dmA (%xh)\n",
+			chosen_current, chosen);
+
+	max8998_update_eoc(max8998->iodev);
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
@@ -533,6 +623,20 @@ static struct regulator_ops max8998_others_ops = {
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
@@ -684,7 +788,13 @@ static struct regulator_desc regulators[] = {
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
@@ -834,13 +944,27 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
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
@@ -854,7 +978,6 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		}
 	}
 
-
 	return 0;
 err:
 	for (i = 0; i < max8998->num_regulators; i++)
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index effa5d3..bfa558f 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -102,10 +102,11 @@ enum {
 };
 
 /* MAX8998 various variants */
-enum {
+enum max8998_type {
 	TYPE_MAX8998 = 0, /* Default */
 	TYPE_LP3974,	/* National version of MAX8998 */
 	TYPE_LP3979,	/* Added AVS */
+	TYPE_UNKNOWN,
 };
 
 #define MAX8998_IRQ_DCINF_MASK		(1 << 2)
@@ -145,6 +146,7 @@ enum {
  * @irq_masks_cur: currently active value
  * @irq_masks_cache: cached hardware value
  * @type: indicate which max8998 "variant" is used
+ * @battery: the max8998 battery control device
  */
 struct max8998_dev {
 	struct device *dev;
@@ -160,6 +162,7 @@ struct max8998_dev {
 	u8 irq_masks_cache[MAX8998_NUM_IRQ_REGS];
 	int type;
 	bool wakeup;
+	struct platform_device *battery;
 };
 
 int max8998_irq_init(struct max8998_dev *max8998);
@@ -174,4 +177,11 @@ extern int max8998_bulk_write(struct i2c_client *i2c, u8 reg, int count,
 		u8 *buf);
 extern int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
 
+#ifdef CONFIG_CHARGERCTRL_MAX8998
+extern void max8998_update_eoc(struct max8998_dev *mdev);
+extern const int *charger_current_map_desc;
+#else
+static void __maybe_unused max8998_update_eoc(struct max8998_dev *mdev) { }
+#endif
+
 #endif /*  __LINUX_MFD_MAX8998_PRIV_H */
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 61daa16..341654c 100644
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
@@ -87,6 +93,12 @@ struct max8998_regulator_data {
  * @wakeup: Allow to wake up from suspend
  * @rtc_delay: LP3974 RTC chip bug that requires delay after a register
  * write before reading it.
+ * @eoc: End of Charge Level: 10 ~ 45% or if it's over 45, in mA.
+ *   If it's under 10, leave it unchanged.
+ * @restart: Restart Level in mV: 100, 150, 200, and -1 for disable.
+ *   Otherwise, leave it unchanged.
+ * @timeout: Full Timeout in hours: 5, 6, 7, and -1 for disable.
+ *  Otherwise, leave it unchanged.
  */
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
@@ -107,6 +119,9 @@ struct max8998_platform_data {
 	int				buck2_default_idx;
 	bool				wakeup;
 	bool				rtc_delay;
+	int				eoc;
+	int				restart;
+	int				timeout;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1

