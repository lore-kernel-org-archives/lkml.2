Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1FVKki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:40:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49450 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FVKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:40:36 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-33-4e01c69d9102
Date: Wed, 22 Jun 2011 19:40:06 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] power_supply: Add charger driver for MAX8997/8966
To: cbouatmailru@gmail.com
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Message-id: <1308739206-7802-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 22 Jun 2011 10:39:46.0656 (UTC)
 FILETIME=[B47C9E00:01CC30C8]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997/8966 chip is a multi-function device which includes
PMIC, RTC, Fuel Gauge, MUIC, Haptic, Flash control, and
Battery charging control.
The driver for it is located at drivers/mfd.

This patch supports battery charging control of MAX8997/8966 chip and
provides power supply class information to userspace.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig           |    7 ++
 drivers/power/Makefile          |    1 +
 drivers/power/max8997_charger.c |  206 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h     |    7 +-
 4 files changed, 220 insertions(+), 1 deletions(-)
 create mode 100644 drivers/power/max8997_charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e57b50b..2d1d0c1 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -235,4 +235,11 @@ config CHARGER_GPIO
 	  This driver can be build as a module. If so, the module will be
 	  called gpio-charger.
 
+config CHARGER_MAX8997
+	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
+	depends on MFD_MAX8997 && REGULATOR_MAX8997
+	help
+	  Say Y to enable support for the battery charger control sysfs and
+	  platform data of MAX8997/LP3974 PMICs.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 009a90f..a98ffaa 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
+obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
new file mode 100644
index 0000000..7106b49
--- /dev/null
+++ b/drivers/power/max8997_charger.c
@@ -0,0 +1,206 @@
+/*
+ * max8997_charger.c - Power supply consumer driver for the Maxim 8997/8966
+ *
+ *  Copyright (C) 2011 Samsung Electronics
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
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+
+struct charger_data {
+	struct device *dev;
+	struct max8997_dev *iodev;
+	struct power_supply battery;
+};
+
+static enum power_supply_property max8997_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS, /* "FULL" or "NOT FULL" only. */
+	POWER_SUPPLY_PROP_PRESENT, /* the presence of battery */
+	POWER_SUPPLY_PROP_ONLINE, /* charger is active or not */
+};
+
+/* Note that the charger control is done by a current regulator "CHARGER" */
+static int max8997_battery_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct charger_data *charger = container_of(psy,
+			struct charger_data, battery);
+	struct i2c_client *i2c = charger->iodev->i2c;
+	int ret;
+	u8 reg;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = 0;
+		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		if (ret)
+			return ret;
+		if ((reg & (1 << 0)) == 0x1)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = 0;
+		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		if (ret)
+			return ret;
+		if ((reg & (1 << 2)) == 0x0)
+			val->intval = 1;
+
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = 0;
+		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		if (ret)
+			return ret;
+		/* DCINOK */
+		if (reg & (1 << 1))
+			val->intval = 1;
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static __devinit int max8997_battery_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct charger_data *charger;
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+
+	if (!pdata)
+		return -EINVAL;
+
+	if (pdata->eoc_mA) {
+		u8 val = (pdata->eoc_mA - 50) / 10;
+		if (val < 0)
+			val = 0;
+		if (val > 0xf)
+			val = 0xf;
+
+		ret = max8997_update_reg(iodev->i2c,
+				MAX8997_REG_MBCCTRL5, val, 0xf);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Cannot use i2c bus.\n");
+			return ret;
+		}
+	}
+
+	switch (pdata->timeout) {
+	case 5:
+		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
+				0x2 << 4, 0x7 << 4);
+		break;
+	case 6:
+		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
+				0x3 << 4, 0x7 << 4);
+		break;
+	case 7:
+		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
+				0x4 << 4, 0x7 << 4);
+		break;
+	case 0:
+		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
+				0x7 << 4, 0x7 << 4);
+		break;
+	default:
+		dev_err(&pdev->dev, "incorrect timeout value (%d)\n",
+				pdata->timeout);
+		return -EINVAL;
+	}
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot use i2c bus.\n");
+		return ret;
+	}
+
+	charger = kzalloc(sizeof(struct charger_data), GFP_KERNEL);
+	if (charger == NULL) {
+		dev_err(&pdev->dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, charger);
+
+	charger->battery.name = "max8997_pmic";
+	charger->battery.type = POWER_SUPPLY_TYPE_BATTERY;
+	charger->battery.get_property = max8997_battery_get_property;
+	charger->battery.properties = max8997_battery_props;
+	charger->battery.num_properties = ARRAY_SIZE(max8997_battery_props);
+
+	charger->dev = &pdev->dev;
+	charger->iodev = iodev;
+
+	ret = power_supply_register(&pdev->dev, &charger->battery);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: power supply register\n");
+		goto err;
+	}
+
+	return 0;
+err:
+	kfree(charger);
+	return ret;
+}
+
+static int __devexit max8997_battery_remove(struct platform_device *pdev)
+{
+	struct charger_data *charger = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&charger->battery);
+	kfree(charger);
+	return 0;
+}
+
+static const struct platform_device_id max8997_battery_id[] = {
+	{ "max8997-battery", 0 },
+};
+
+static struct platform_driver max8997_battery_driver = {
+	.driver = {
+		.name = "max8997-battery",
+		.owner = THIS_MODULE,
+	},
+	.probe = max8997_battery_probe,
+	.remove = __devexit_p(max8997_battery_remove),
+	.id_table = max8997_battery_id,
+};
+
+static int __init max8997_battery_init(void)
+{
+	return platform_driver_register(&max8997_battery_driver);
+}
+subsys_initcall(max8997_battery_init);
+
+static void __exit max8997_battery_cleanup(void)
+{
+	platform_driver_unregister(&max8997_battery_driver);
+}
+module_exit(max8997_battery_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 8997/8966 battery control driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 60931d0..0bbd13d 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -107,11 +107,16 @@ struct max8997_platform_data {
 	unsigned int buck5_voltage[8];
 	bool buck5_gpiodvs;
 
+	/* ---- Charger control ---- */
+	/* eoc stands for 'end of charge' */
+	int eoc_mA; /* 50 ~ 200mA by 10mA step */
+	/* charge Full Timeout */
+	int timeout; /* 0 (no timeout), 5, 6, 7 hours */
+
 	/* MUIC: Not implemented */
 	/* HAPTIC: Not implemented */
 	/* RTC: Not implemented */
 	/* Flash: Not implemented */
-	/* Charger control: Not implemented */
 };
 
 #endif /* __LINUX_MFD_MAX8998_H */
-- 
1.7.4.1

