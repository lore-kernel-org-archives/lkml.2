Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0DVHgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:36:41 -0400
Received: from compulab.co.il ([67.18.134.219]:49947 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0DVHgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:36:39 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] ds2782_battery: add support for ds2786 battery gas gauge
Date: Thu, 22 Apr 2010 10:35:23 +0300
Message-Id: <1271921723-18289-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.6.2
In-Reply-To: <20100422071437.GA32489@oksana.dev.rtsoft.ru>
References: <20100422071437.GA32489@oksana.dev.rtsoft.ru>
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yulia Vilensky <vilensky@compulab.co.il>

Signed-off-by: Yulia Vilensky <vilensky@compulab.co.il>
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/power/Kconfig          |    4 +-
 drivers/power/ds2782_battery.c |  217 +++++++++++++++++++++++++++++++--------
 include/linux/ds2782_battery.h |    8 ++
 3 files changed, 182 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/ds2782_battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index faaa9b4..d8b8a19 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -65,10 +65,10 @@ config BATTERY_DS2760
 	  Say Y here to enable support for batteries with ds2760 chip.
 
 config BATTERY_DS2782
-	tristate "DS2782 standalone gas-gauge"
+	tristate "DS2782/DS2786 standalone gas-gauge"
 	depends on I2C
 	help
-	  Say Y here to enable support for the DS2782 standalone battery
+	  Say Y here to enable support for the DS2782/DS2786 standalone battery
 	  gas-gauge.
 
 config BATTERY_PMU
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 99c8997..0df49b4 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -5,6 +5,8 @@
  *
  * Author: Ryan Mallon <ryan@bluewatersys.com>
  *
+ * DS278 added by Yulia Vilensky <vilensky@compulab.co.il>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -20,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/power_supply.h>
 #include <linux/slab.h>
+#include <linux/ds2782_battery.h>
 
 #define DS2782_REG_RARC		0x06	/* Remaining active relative capacity */
 
@@ -33,18 +36,39 @@
 /* Current unit measurement in uA for a 1 milli-ohm sense resistor */
 #define DS2782_CURRENT_UNITS	1563
 
-#define to_ds2782_info(x) container_of(x, struct ds2782_info, battery)
+#define DS2786_REG_RARC		0x02	/* Remaining active relative capacity */
+
+#define DS2786_REG_VOLT_MSB	0x0c
+#define DS2786_REG_TEMP_MSB	0x0a
+#define DS2786_REG_CURRENT_MSB	0x0e
+
+#define DS2786_CURRENT_UNITS	25
+
+#define DS278X_SIGN_BIT_MASK16  0x8000
+
+struct ds278x_info;
 
-struct ds2782_info {
+struct ds278x_battery_ops {
+	int	(*get_temp)(struct ds278x_info *info, int *temp);
+	int	(*get_current)(struct ds278x_info *info, int *current_uA);
+	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
+	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
+};
+
+#define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
+
+struct ds278x_info {
 	struct i2c_client	*client;
 	struct power_supply	battery;
+	struct ds278x_battery_ops  *ops;
 	int			id;
+	int                     rsns;
 };
 
 static DEFINE_IDR(battery_id);
 static DEFINE_MUTEX(battery_lock);
 
-static inline int ds2782_read_reg(struct ds2782_info *info, int reg, u8 *val)
+static inline int ds278x_read_reg(struct ds278x_info *info, int reg, u8 *val)
 {
 	int ret;
 
@@ -58,7 +82,7 @@ static inline int ds2782_read_reg(struct ds2782_info *info, int reg, u8 *val)
 	return 0;
 }
 
-static inline int ds2782_read_reg16(struct ds2782_info *info, int reg_msb,
+static inline int ds278x_read_reg16(struct ds278x_info *info, int reg_msb,
 				    s16 *val)
 {
 	int ret;
@@ -73,7 +97,7 @@ static inline int ds2782_read_reg16(struct ds2782_info *info, int reg_msb,
 	return 0;
 }
 
-static int ds2782_get_temp(struct ds2782_info *info, int *temp)
+static int ds2782_get_temp(struct ds278x_info *info, int *temp)
 {
 	s16 raw;
 	int err;
@@ -84,14 +108,14 @@ static int ds2782_get_temp(struct ds2782_info *info, int *temp)
 	 * celsius. The temperature value is stored as a 10 bit number, plus
 	 * sign in the upper bits of a 16 bit register.
 	 */
-	err = ds2782_read_reg16(info, DS2782_REG_TEMP_MSB, &raw);
+	err = ds278x_read_reg16(info, DS2782_REG_TEMP_MSB, &raw);
 	if (err)
 		return err;
 	*temp = ((raw / 32) * 125) / 100;
 	return 0;
 }
 
-static int ds2782_get_current(struct ds2782_info *info, int *current_uA)
+static int ds2782_get_current(struct ds278x_info *info, int *current_uA)
 {
 	int sense_res;
 	int err;
@@ -102,7 +126,7 @@ static int ds2782_get_current(struct ds2782_info *info, int *current_uA)
 	 * The units of measurement for current are dependent on the value of
 	 * the sense resistor.
 	 */
-	err = ds2782_read_reg(info, DS2782_REG_RSNSP, &sense_res_raw);
+	err = ds278x_read_reg(info, DS2782_REG_RSNSP, &sense_res_raw);
 	if (err)
 		return err;
 	if (sense_res_raw == 0) {
@@ -113,14 +137,14 @@ static int ds2782_get_current(struct ds2782_info *info, int *current_uA)
 
 	dev_dbg(&info->client->dev, "sense resistor = %d milli-ohms\n",
 		sense_res);
-	err = ds2782_read_reg16(info, DS2782_REG_CURRENT_MSB, &raw);
+	err = ds278x_read_reg16(info, DS2782_REG_CURRENT_MSB, &raw);
 	if (err)
 		return err;
 	*current_uA = raw * (DS2782_CURRENT_UNITS / sense_res);
 	return 0;
 }
 
-static int ds2782_get_voltage(struct ds2782_info *info, int *voltage_uA)
+static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uA)
 {
 	s16 raw;
 	int err;
@@ -129,36 +153,110 @@ static int ds2782_get_voltage(struct ds2782_info *info, int *voltage_uA)
 	 * Voltage is measured in units of 4.88mV. The voltage is stored as
 	 * a 10-bit number plus sign, in the upper bits of a 16-bit register
 	 */
-	err = ds2782_read_reg16(info, DS2782_REG_VOLT_MSB, &raw);
+	err = ds278x_read_reg16(info, DS2782_REG_VOLT_MSB, &raw);
 	if (err)
 		return err;
 	*voltage_uA = (raw / 32) * 4800;
 	return 0;
 }
 
-static int ds2782_get_capacity(struct ds2782_info *info, int *capacity)
+static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
 {
 	int err;
 	u8 raw;
 
-	err = ds2782_read_reg(info, DS2782_REG_RARC, &raw);
+	err = ds278x_read_reg(info, DS2782_REG_RARC, &raw);
 	if (err)
 		return err;
 	*capacity = raw;
 	return raw;
 }
 
-static int ds2782_get_status(struct ds2782_info *info, int *status)
+static int ds2786_get_temp(struct ds278x_info *info, int *temp)
+{
+	s16 raw;
+	int err;
+
+	/*
+	 * Temperature is measured in units of 0.125 degrees celcius, the
+	 * power_supply class measures temperature in tenths of degrees
+	 * celsius. The temperature value is stored as a 10 bit number, plus
+	 * sign in the upper bits of a 16 bit register.
+	 */
+	err = ds278x_read_reg16(info, DS2786_REG_TEMP_MSB, &raw);
+	if (err)
+		return err;
+
+	if (raw &  DS278X_SIGN_BIT_MASK16)
+		*temp = -(((~raw >> 5)+1) * 125)/100;
+	else
+		*temp = ((raw >> 5) * 125)/100;
+
+	return 0;
+}
+
+static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
+{
+	int err;
+	s16 raw;
+
+	err = ds278x_read_reg16(info, DS2786_REG_CURRENT_MSB, &raw);
+	if (err)
+		return err;
+
+	if (raw &  DS278X_SIGN_BIT_MASK16)
+		*current_uA = -(((~raw >> 4)+1) *
+			       (DS2786_CURRENT_UNITS / info->rsns));
+	else
+		*current_uA = (raw >> 4) *
+			      (DS2786_CURRENT_UNITS / info->rsns);
+	return 0;
+}
+
+static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
+{
+	s16 raw;
+	int err;
+
+	/*
+	 * Voltage is measured in units of 1.22mV. The voltage is stored as
+	 * a 10-bit number plus sign, in the upper bits of a 16-bit register
+	 */
+	err = ds278x_read_reg16(info, DS2786_REG_VOLT_MSB, &raw);
+	if (err)
+		return err;
+
+	if (raw &  DS278X_SIGN_BIT_MASK16)
+		*voltage_uA = -(((~raw >> 3)+1) * 1220);
+	else
+		*voltage_uA = (raw >> 3) * 1220;
+	return 0;
+}
+
+static int ds2786_get_capacity(struct ds278x_info *info, int *capacity)
+{
+	int err;
+	u8 raw;
+
+	err = ds278x_read_reg(info, DS2786_REG_RARC, &raw);
+	if (err)
+		return err;
+	/* Relative capacity is displayed with resolution 0.5 % */
+	*capacity = raw/2 ;
+	return 0;
+}
+
+static int ds278x_get_status(struct ds278x_info *info, int *status)
 {
 	int err;
 	int current_uA;
 	int capacity;
 
-	err = ds2782_get_current(info, &current_uA);
+	err = info->ops->get_current(info, &current_uA);
 	if (err)
 		return err;
 
-	err = ds2782_get_capacity(info, &capacity);
+	err = info->ops->get_capacity(info, &capacity);
 	if (err)
 		return err;
 
@@ -174,32 +272,32 @@ static int ds2782_get_status(struct ds2782_info *info, int *status)
 	return 0;
 }
 
-static int ds2782_battery_get_property(struct power_supply *psy,
+static int ds278x_battery_get_property(struct power_supply *psy,
 				       enum power_supply_property prop,
 				       union power_supply_propval *val)
 {
-	struct ds2782_info *info = to_ds2782_info(psy);
+	struct ds278x_info *info = to_ds278x_info(psy);
 	int ret;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_STATUS:
-		ret = ds2782_get_status(info, &val->intval);
+		ret = ds278x_get_status(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = ds2782_get_capacity(info, &val->intval);
+		ret = info->ops->get_capacity(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = ds2782_get_voltage(info, &val->intval);
+		ret = info->ops->get_voltage(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		ret = ds2782_get_current(info, &val->intval);
+		ret = info->ops->get_current(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
-		ret = ds2782_get_temp(info, &val->intval);
+		ret = info->ops->get_temp(info, &val->intval);
 		break;
 
 	default:
@@ -209,7 +307,7 @@ static int ds2782_battery_get_property(struct power_supply *psy,
 	return ret;
 }
 
-static enum power_supply_property ds2782_battery_props[] = {
+static enum power_supply_property ds278x_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
@@ -217,18 +315,18 @@ static enum power_supply_property ds2782_battery_props[] = {
 	POWER_SUPPLY_PROP_TEMP,
 };
 
-static void ds2782_power_supply_init(struct power_supply *battery)
+static void ds278x_power_supply_init(struct power_supply *battery)
 {
 	battery->type			= POWER_SUPPLY_TYPE_BATTERY;
-	battery->properties		= ds2782_battery_props;
-	battery->num_properties		= ARRAY_SIZE(ds2782_battery_props);
-	battery->get_property		= ds2782_battery_get_property;
+	battery->properties		= ds278x_battery_props;
+	battery->num_properties		= ARRAY_SIZE(ds278x_battery_props);
+	battery->get_property		= ds278x_battery_get_property;
 	battery->external_power_changed	= NULL;
 }
 
-static int ds2782_battery_remove(struct i2c_client *client)
+static int ds278x_battery_remove(struct i2c_client *client)
 {
-	struct ds2782_info *info = i2c_get_clientdata(client);
+	struct ds278x_info *info = i2c_get_clientdata(client);
 
 	power_supply_unregister(&info->battery);
 	kfree(info->battery.name);
@@ -243,13 +341,38 @@ static int ds2782_battery_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int ds2782_battery_probe(struct i2c_client *client,
+static struct ds278x_battery_ops ds278x_ops[] = {
+	[0] = {
+		.get_temp     = ds2782_get_temp,
+		.get_current  = ds2782_get_current,
+		.get_voltage  = ds2782_get_voltage,
+		.get_capacity = ds2782_get_capacity,
+	},
+	[1] = {
+		.get_temp     = ds2786_get_temp,
+		.get_current  = ds2786_get_current,
+		.get_voltage  = ds2786_get_voltage,
+		.get_capacity = ds2786_get_capacity,
+	}
+};
+
+static int ds278x_battery_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	struct ds2782_info *info;
+	struct ds278x_platform_data *pdata = client->dev.platform_data;
+	struct ds278x_info *info;
 	int ret;
 	int num;
 
+	/*
+	 * ds2786 should have the sense resistor value set
+	 * in the platform data .
+	 */
+	if (id->driver_data == 1 && pdata == 0) {
+		dev_err(&client->dev, "missing platform data for ds2786\n");
+		return -EINVAL;
+	}
+
 	/* Get an ID for this battery */
 	ret = idr_pre_get(&battery_id, GFP_KERNEL);
 	if (ret == 0) {
@@ -269,7 +392,7 @@ static int ds2782_battery_probe(struct i2c_client *client,
 		goto fail_info;
 	}
 
-	info->battery.name = kasprintf(GFP_KERNEL, "ds2782-%d", num);
+	info->battery.name = kasprintf(GFP_KERNEL, "%s-%d", client->name, num);
 	if (!info->battery.name) {
 		ret = -ENOMEM;
 		goto fail_name;
@@ -277,7 +400,10 @@ static int ds2782_battery_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, info);
 	info->client = client;
-	ds2782_power_supply_init(&info->battery);
+	info->id = num;
+	info->ops  = &ds278x_ops[id->driver_data];
+	info->rsns = pdata->rsns;
+	ds278x_power_supply_init(&info->battery);
 
 	ret = power_supply_register(&client->dev, &info->battery);
 	if (ret) {
@@ -300,31 +426,32 @@ fail_id:
 	return ret;
 }
 
-static const struct i2c_device_id ds2782_id[] = {
+static const struct i2c_device_id ds278x_id[] = {
 	{"ds2782", 0},
+	{"ds2786", 1},
 	{},
 };
 
-static struct i2c_driver ds2782_battery_driver = {
+static struct i2c_driver ds278x_battery_driver = {
 	.driver 	= {
 		.name	= "ds2782-battery",
 	},
-	.probe		= ds2782_battery_probe,
-	.remove		= ds2782_battery_remove,
-	.id_table	= ds2782_id,
+	.probe		= ds278x_battery_probe,
+	.remove		= ds278x_battery_remove,
+	.id_table	= ds278x_id,
 };
 
-static int __init ds2782_init(void)
+static int __init ds278x_init(void)
 {
-	return i2c_add_driver(&ds2782_battery_driver);
+	return i2c_add_driver(&ds278x_battery_driver);
 }
-module_init(ds2782_init);
+module_init(ds278x_init);
 
-static void __exit ds2782_exit(void)
+static void __exit ds278x_exit(void)
 {
-	i2c_del_driver(&ds2782_battery_driver);
+	i2c_del_driver(&ds278x_battery_driver);
 }
-module_exit(ds2782_exit);
+module_exit(ds278x_exit);
 
 MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
diff --git a/include/linux/ds2782_battery.h b/include/linux/ds2782_battery.h
new file mode 100644
index 0000000..b4e281f
--- /dev/null
+++ b/include/linux/ds2782_battery.h
@@ -0,0 +1,8 @@
+#ifndef __LINUX_DS2782_BATTERY_H
+#define __LINUX_DS2782_BATTERY_H
+
+struct ds278x_platform_data {
+	int rsns;
+};
+
+#endif
-- 
1.6.6.2

