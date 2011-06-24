Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1FXKFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:05:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30339 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1FXKE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:04:59 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-d9-4e046134f7b5
Date: Fri, 24 Jun 2011 19:04:18 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH 1/2] power_supply: Add charger driver for MAX8998/LP3974
In-reply-to: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Message-id: <1308909859-3674-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
X-OriginalArrivalTime: 24 Jun 2011 10:04:53.0072 (UTC)
 FILETIME=[29708D00:01CC3256]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports power supply APIs for MAX8998/LP3974.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998.c           |    2 +
 drivers/power/Kconfig           |    7 ++
 drivers/power/Makefile          |    1 +
 drivers/power/max8998_charger.c |  218 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998.h     |   12 ++
 5 files changed, 240 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/max8998_charger.c

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 9ec7570..de4096a 100644
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
 
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e57b50b..3a6427d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -235,4 +235,11 @@ config CHARGER_GPIO
 	  This driver can be build as a module. If so, the module will be
 	  called gpio-charger.
 
+config CHARGER_MAX8998
+	tristate "Maxim MAX8998/LP3974 PMIC battery charger driver"
+	depends on MFD_MAX8998 && REGULATOR_MAX8998
+	help
+	  Say Y to enable support for the battery charger control sysfs and
+	  platform data of MAX8998/LP3974 PMICs.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 009a90f..d0a62c7 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
+obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
new file mode 100644
index 0000000..cc21fa2
--- /dev/null
+++ b/drivers/power/max8998_charger.c
@@ -0,0 +1,218 @@
+/*
+ * max8998_charger.c - Power supply consumer driver for the Maxim 8998/LP3974
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
+	struct power_supply battery;
+};
+
+static enum power_supply_property max8998_battery_props[] = {
+	POWER_SUPPLY_PROP_PRESENT, /* the presence of battery */
+	POWER_SUPPLY_PROP_ONLINE, /* charger is active or not */
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
+	max8998->dev = &pdev->dev;
+	max8998->iodev = iodev;
+	platform_set_drvdata(pdev, max8998);
+	i2c = max8998->iodev->i2c;
+
+	/* Setup "End of Charge" */
+	/* If EOC value equals 0,
+	 * remain value set from bootloader or default value */
+	if (pdata->eoc >= 10 && pdata->eoc <= 45) {
+		max8998_update_reg(i2c, MAX8998_REG_CHGR1,
+				(pdata->eoc / 5 - 2) << 5, 0x7 << 5);
+	} else if (pdata->eoc == 0) {
+		dev_dbg(max8998->dev,
+			"EOC value not set: leave it unchanged.\n");
+	} else {
+		dev_err(max8998->dev, "Invalid EOC value\n");
+		ret = -EINVAL;
+		goto err;
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
+	case 0:
+		dev_dbg(max8998->dev,
+			"Restart Level not set: leave it unchanged.\n");
+		break;
+	default:
+		dev_err(max8998->dev, "Invalid Restart Level\n");
+		ret = -EINVAL;
+		goto err;
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
+	case 0:
+		dev_dbg(max8998->dev,
+			"Full Timeout not set: leave it unchanged.\n");
+	default:
+		dev_err(max8998->dev, "Invalid Full Timeout value\n");
+		ret = -EINVAL;
+		goto err;
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
+		goto err;
+	}
+
+	return 0;
+err:
+	kfree(max8998);
+	return ret;
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
+MODULE_ALIAS("platform:max8998-battery");
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 61daa16..f4f0dfa 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -87,6 +87,15 @@ struct max8998_regulator_data {
  * @wakeup: Allow to wake up from suspend
  * @rtc_delay: LP3974 RTC chip bug that requires delay after a register
  * write before reading it.
+ * @eoc: End of Charge Level in percent: 10% ~ 45% by 5% step
+ *   If it equals 0, leave it unchanged.
+ *   Otherwise, it is a invalid value.
+ * @restart: Restart Level in mV: 100, 150, 200, and -1 for disable.
+ *   If it equals 0, leave it unchanged.
+ *   Otherwise, it is a invalid value.
+ * @timeout: Full Timeout in hours: 5, 6, 7, and -1 for disable.
+ *   If it equals 0, leave it unchanged.
+ *   Otherwise, leave it unchanged.
  */
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
@@ -107,6 +116,9 @@ struct max8998_platform_data {
 	int				buck2_default_idx;
 	bool				wakeup;
 	bool				rtc_delay;
+	int				eoc;
+	int				restart;
+	int				timeout;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.4.1

