Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1ANFqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:46:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1ANFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:46:14 -0500
Date: Fri, 14 Jan 2011 14:46:11 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] Add MAX17042 Fuel Gauge Driver - Initial Release
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grazvydas Ignotas <notasas@gmail.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1294983971-17140-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 14 Jan 2011 05:46:11.0782 (UTC)
 FILETIME=[5985E660:01CBB3AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX17042 is a fuel gauge with an I2C interface for lithium-ion
betteries. Unlike its predecessor MAX17040, MAX17042 uses 16bit
registers. Besides, MAX17042 has much more features than MAX17040; e.g.,
a thermistor, current and current accumulation measurement, battery
internal resistance estimate, average values of measurement, and others.

This patch implements a driver for MAX17042.
In this initial release, we have implemented the most basic features of
a fuel gauge: measure the battery capacity and voltage.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig                  |   10 ++
 drivers/power/Makefile                 |    1 +
 drivers/power/max17042_battery.c       |  238 ++++++++++++++++++++++++++++++++
 include/linux/power/max17042_battery.h |   30 ++++
 4 files changed, 279 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/max17042_battery.c
 create mode 100644 include/linux/power/max17042_battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 06b720c..fdbc62b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -136,6 +136,16 @@ config BATTERY_MAX17040
 	  in handheld and portable equipment. The MAX17040 is configured
 	  to operate with a single lithium cell
 
+config BATTERY_MAX17042
+	tristate "Maxim MAX17042/8997/8966 Fuel Gauge"
+	depends on I2C
+	help
+	  MAX17042 is fuel-gauge systems for lithium-ion (Li+) batteries
+	  in handheld and portable equipment. The MAX17042 is configured
+	  to operate with a single lithium cell. MAX8997 and MAX8966 are
+	  multi-function devices that include fuel gauages that are compatible
+	  with MAX17042.
+
 config BATTERY_Z2
 	tristate "Z2 battery driver"
 	depends on I2C && MACH_ZIPIT2
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 4e66b91..9f070cf 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_BATTERY_BQ20Z75)	+= bq20z75.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
+obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
new file mode 100644
index 0000000..6e6eeab
--- /dev/null
+++ b/drivers/power/max17042_battery.c
@@ -0,0 +1,238 @@
+/*
+ * max17042_battery.c - Fuel gauge driver for Maxim 17042 / 8966 / 8997
+ *  Note that Maxim 8966 and 8997 are mfd and this is its subdevice.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
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
+ *
+ * This driver is based on max17040_battery.c
+ */
+
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/power_supply.h>
+#include <linux/power/max17042_battery.h>
+
+enum max17042_register {
+	MAX17042_STATUS		= 0x00,
+	MAX17042_VALRT_Th	= 0x01,
+	MAX17042_TALRT_Th	= 0x02,
+	MAX17042_SALRT_Th	= 0x03,
+	MAX17042_AtRate		= 0x04,
+	MAX17042_RepCap		= 0x05,
+	MAX17042_RepSOC		= 0x06,
+	MAX17042_Age		= 0x07,
+	MAX17042_TEMP		= 0x08,
+	MAX17042_VCELL		= 0x09,
+	MAX17042_Current	= 0x0A,
+	MAX17042_AvgCurrent	= 0x0B,
+	MAX17042_Qresidual	= 0x0C,
+	MAX17042_SOC		= 0x0D,
+	MAX17042_AvSOC		= 0x0E,
+	MAX17042_RemCap		= 0x0F,
+	MAX17402_FullCAP	= 0x10,
+	MAX17042_TTE		= 0x11,
+	MAX17042_V_empty	= 0x12,
+
+	MAX17042_RSLOW		= 0x14,
+
+	MAX17042_AvgTA		= 0x16,
+	MAX17042_Cycles		= 0x17,
+	MAX17042_DesignCap	= 0x18,
+	MAX17042_AvgVCELL	= 0x19,
+	MAX17042_MinMaxTemp	= 0x1A,
+	MAX17042_MinMaxVolt	= 0x1B,
+	MAX17042_MinMaxCurr	= 0x1C,
+	MAX17042_CONFIG		= 0x1D,
+	MAX17042_ICHGTerm	= 0x1E,
+	MAX17042_AvCap		= 0x1F,
+	MAX17042_ManName	= 0x20,
+	MAX17042_DevName	= 0x21,
+	MAX17042_DevChem	= 0x22,
+
+	MAX17042_TempNom	= 0x24,
+	MAX17042_TempCold	= 0x25,
+	MAX17042_TempHot	= 0x26,
+	MAX17042_AIN		= 0x27,
+	MAX17042_LearnCFG	= 0x28,
+	MAX17042_SHFTCFG	= 0x29,
+	MAX17042_RelaxCFG	= 0x2A,
+	MAX17042_MiscCFG	= 0x2B,
+	MAX17042_TGAIN		= 0x2C,
+	MAx17042_TOFF		= 0x2D,
+	MAX17042_CGAIN		= 0x2E,
+	MAX17042_COFF		= 0x2F,
+
+	MAX17042_Q_empty	= 0x33,
+	MAX17042_T_empty	= 0x34,
+
+	MAX17042_RCOMP0		= 0x38,
+	MAX17042_TempCo		= 0x39,
+	MAX17042_Rx		= 0x3A,
+	MAX17042_T_empty0	= 0x3B,
+	MAX17042_TaskPeriod	= 0x3C,
+	MAX17042_FSTAT		= 0x3D,
+
+	MAX17042_SHDNTIMER	= 0x3F,
+
+	MAX17042_VFRemCap	= 0x4A,
+
+	MAX17042_QH		= 0x4D,
+	MAX17042_QL		= 0x4E,
+};
+
+struct max17042_chip {
+	struct i2c_client *client;
+	struct power_supply battery;
+	struct max17042_platform_data *pdata;
+};
+
+static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
+{
+	int ret = i2c_smbus_write_word_data(client, reg, value);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int max17042_read_reg(struct i2c_client *client, u8 reg)
+{
+	int ret = i2c_smbus_read_word_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static enum power_supply_property max17042_battery_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+};
+
+static int max17042_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	struct max17042_chip *chip = container_of(psy,
+				struct max17042_chip, battery);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_AvgVCELL) * 83;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = max17042_read_reg(chip->client,
+				MAX17042_SOC) / 256;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int __devinit max17042_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct max17042_chip *chip;
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -EIO;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+	chip->pdata = client->dev.platform_data;
+
+	i2c_set_clientdata(client, chip);
+
+	chip->battery.name		= "max17042_battery";
+	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
+	chip->battery.get_property	= max17042_get_property;
+	chip->battery.properties	= max17042_battery_props;
+	chip->battery.num_properties	= ARRAY_SIZE(max17042_battery_props);
+
+	ret = power_supply_register(&client->dev, &chip->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed: power supply register\n");
+		i2c_set_clientdata(client, NULL);
+		kfree(chip);
+		return ret;
+	}
+
+	if (!chip->pdata->enable_current_sense) {
+		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
+		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
+		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
+	}
+
+	return 0;
+}
+
+static int __devexit max17042_remove(struct i2c_client *client)
+{
+	struct max17042_chip *chip = i2c_get_clientdata(client);
+
+	power_supply_unregister(&chip->battery);
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+	return 0;
+}
+
+static const struct i2c_device_id max17042_id[] = {
+	{ "max17042", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max17040_id);
+
+
+static struct i2c_driver max17042_i2c_driver = {
+	.driver	= {
+		.name	= "max17042",
+	},
+	.probe		= max17042_probe,
+	.remove		= __devexit_p(max17042_remove),
+	.id_table	= max17042_id,
+};
+
+static int __init max17042_init(void)
+{
+	return i2c_add_driver(&max17042_i2c_driver);
+}
+module_init(max17042_init);
+
+static void __exit max17042_exit(void)
+{
+	i2c_del_driver(&max17042_i2c_driver);
+}
+module_exit(max17042_exit);
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("MAX17042 Fuel Gauge");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
new file mode 100644
index 0000000..4cc533f
--- /dev/null
+++ b/include/linux/power/max17042_battery.h
@@ -0,0 +1,30 @@
+/*
+ * max17042_battery.h - Fuel gauge driver for Maxim 17042 / 8966 / 8997
+ *  Note that Maxim 8966 and 8997 are mfd and this is its subdevice.
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
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
+#ifndef __MAX17042_BATTERY_H_
+#define __MAX17042_BATTERY_H_
+
+struct max17042_platform_data {
+	bool enable_current_sense;
+};
+
+#endif /* __MAX17042_BATTERY_H_ */
-- 
1.7.1

