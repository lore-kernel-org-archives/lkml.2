Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1BNT1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:27:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3253 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1BNT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:27:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 14 Feb 2011 11:14:51 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] power: bq20z75: change to platform driver
Date: Mon, 14 Feb 2011 11:25:42 -0800
Message-Id: <1297711542-10180-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

This change switches the bq20z75 i2c driver into a platform driver
and adds support for an optional battery detect gpio. Now the driver also
signals when the battery is inserted or removed.

I also added a retry mechanism so that for boards where there may be
intermittent i2c issues, retries can be used to avoid spurious failures.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c       |  282 ++++++++++++++++++++++++++++++++---------
 include/linux/power/bq20z75.h |   39 ++++++
 2 files changed, 258 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/power/bq20z75.h

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 4141775..9b9269e 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -25,6 +25,11 @@
 #include <linux/power_supply.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <linux/power/bq20z75.h>
 
 enum {
 	REG_MANUFACTURER_DATA,
@@ -141,17 +146,30 @@ static enum power_supply_property bq20z75_properties[] = {
 };
 
 struct bq20z75_info {
-	struct i2c_client	*client;
-	struct power_supply	power_supply;
+	struct i2c_client		*client;
+	struct i2c_adapter		*adapter;
+	struct power_supply		power_supply;
+	bool				is_present;
+	struct bq20z75_platform_data	*pdata;
+	struct platform_device		*pdev;
+	bool				gpio_detect;
+	int				irq;
+	bool				enable_detection;
 };
 
 static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
 {
-	s32 ret;
+	s32 ret = 0;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	int retries = max(bq20z75_device->pdata->i2c_retry_count+1, 1);
 
-	ret = i2c_smbus_read_word_data(client, address);
+	while (retries > 0) {
+		ret = i2c_smbus_read_word_data(client, address);
+		if (ret >= 0)
+			break;
+	}
 	if (ret < 0) {
-		dev_err(&client->dev,
+		dev_warn(&bq20z75_device->pdev->dev,
 			"%s: i2c read at address 0x%x failed\n",
 			__func__, address);
 		return ret;
@@ -162,15 +180,24 @@ static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
 static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
 	u16 value)
 {
-	s32 ret;
-
-	ret = i2c_smbus_write_word_data(client, address, le16_to_cpu(value));
+	s32 ret = 0;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	int retries = max(bq20z75_device->pdata->i2c_retry_count+1, 1);
+
+	while (retries > 0) {
+		ret = i2c_smbus_write_word_data(client, address,
+			le16_to_cpu(value));
+		if (ret >= 0)
+			break;
+		retries--;
+	}
 	if (ret < 0) {
-		dev_err(&client->dev,
+		dev_warn(&bq20z75_device->pdev->dev,
 			"%s: i2c write to address 0x%x failed\n",
 			__func__, address);
 		return ret;
 	}
+
 	return 0;
 }
 
@@ -179,7 +206,15 @@ static int bq20z75_get_battery_presence_and_health(
 	union power_supply_propval *val)
 {
 	s32 ret;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
 
+	if (psp == POWER_SUPPLY_PROP_PRESENT &&
+		bq20z75_device->gpio_detect) {
+		ret = gpio_get_value(
+			bq20z75_device->pdata->battery_detect);
+		val->intval = (ret == 0 ? 1 : 0);
+		return ret;
+	}
 	/* Write to ManufacturerAccess with
 	 * ManufacturerAccess command and then
 	 * read the status */
@@ -189,12 +224,15 @@ static int bq20z75_get_battery_presence_and_health(
 	if (ret < 0)
 		return ret;
 
-
 	ret = bq20z75_read_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr);
-	if (ret < 0)
+	if (ret < 0) {
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			val->intval = 0; /* battery removed */
 		return ret;
 
+	}
+
 	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
 	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
 		val->intval = 0;
@@ -271,6 +309,8 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 #define BATTERY_MODE_CAP_MULT_WATT	(10 * BASE_UNIT_CONVERSION)
 #define TIME_UNIT_CONVERSION		600
 #define TEMP_KELVIN_TO_CELCIUS		2731
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
@@ -300,7 +340,7 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 		break;
 
 	default:
-		dev_dbg(&client->dev,
+		dev_dbg(&bq20z75_device->pdev->dev,
 			"%s: no need for unit conversion %d\n", __func__, psp);
 	}
 }
@@ -348,11 +388,11 @@ static int bq20z75_get_battery_capacity(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	if (psp == POWER_SUPPLY_PROP_CAPACITY) {
-		/* bq20z75 spec says that this can be >100 %
-		* even if max value is 100 % */
+	/* bq20z75 spec says that this can be >100 %
+	 * even if max value is 100 % */
+	if (psp == POWER_SUPPLY_PROP_CAPACITY)
 		val->intval = min(ret, 100);
-	} else
+	else
 		val->intval = ret;
 
 	ret = bq20z75_set_battery_mode(client, mode);
@@ -383,11 +423,13 @@ static int bq20z75_get_property_index(struct i2c_client *client,
 	enum power_supply_property psp)
 {
 	int count;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+
 	for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++)
 		if (psp == bq20z75_data[count].psp)
 			return count;
 
-	dev_warn(&client->dev,
+	dev_warn(&bq20z75_device->pdev->dev,
 		"%s: Invalid Property - %d\n", __func__, psp);
 
 	return -EINVAL;
@@ -398,7 +440,7 @@ static int bq20z75_get_property(struct power_supply *psy,
 	union power_supply_propval *val)
 {
 	int ps_index;
-	int ret;
+	int ret = 0;
 	struct bq20z75_info *bq20z75_device = container_of(psy,
 				struct bq20z75_info, power_supply);
 	struct i2c_client *client = bq20z75_device->client;
@@ -407,8 +449,6 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = bq20z75_get_battery_presence_and_health(client, psp, val);
-		if (ret)
-			return ret;
 		break;
 
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
@@ -423,19 +463,16 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ps_index = bq20z75_get_property_index(client, psp);
-		if (ps_index < 0)
-			return ps_index;
+		if (ps_index < 0) {
+			ret = ps_index;
+			break;
+		}
 
 		ret = bq20z75_get_battery_capacity(client, ps_index, psp, val);
-		if (ret)
-			return ret;
-
 		break;
 
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = bq20z75_get_battery_serial_number(client, val);
-		if (ret)
-			return ret;
 		break;
 
 	case POWER_SUPPLY_PROP_STATUS:
@@ -447,41 +484,76 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
 		ps_index = bq20z75_get_property_index(client, psp);
-		if (ps_index < 0)
-			return ps_index;
+		if (ps_index < 0) {
+			ret = ps_index;
+			break;
+		}
 
 		ret = bq20z75_get_battery_property(client, ps_index, psp, val);
-		if (ret)
-			return ret;
-
 		break;
 
 	default:
-		dev_err(&client->dev,
+		dev_err(&bq20z75_device->pdev->dev,
 			"%s: INVALID property\n", __func__);
 		return -EINVAL;
 	}
 
-	/* Convert units to match requirements for power supply class */
-	bq20z75_unit_adjustment(client, psp, val);
+	if (!bq20z75_device->enable_detection)
+		goto done;
+
+	if (!bq20z75_device->gpio_detect &&
+			bq20z75_device->is_present != (ret >= 0)) {
+		bq20z75_device->is_present = (ret >= 0);
+		power_supply_changed(&bq20z75_device->power_supply);
+	}
 
-	dev_dbg(&client->dev,
+done:
+	if (!ret) {
+		/* Convert units to match requirements for power supply class */
+		bq20z75_unit_adjustment(client, psp, val);
+	}
+
+	dev_dbg(&bq20z75_device->pdev->dev,
 		"%s: property = %d, value = %d\n", __func__, psp, val->intval);
 
-	return 0;
+	return ret;
 }
 
-static int bq20z75_probe(struct i2c_client *client,
-	const struct i2c_device_id *id)
+static irqreturn_t bq20z75_irq(int irq, void *devid)
+{
+	struct power_supply *battery = devid;
+
+	power_supply_changed(battery);
+
+	return IRQ_HANDLED;
+}
+
+static struct i2c_board_info __initdata bq20z75_i2c_device = {
+	I2C_BOARD_INFO("bq20z75", 0x0b),
+};
+
+static int __devinit bq20z75_probe(struct platform_device *pdev)
 {
 	struct bq20z75_info *bq20z75_device;
 	int rc;
+	struct bq20z75_platform_data *pdata = pdev->dev.platform_data;
+	int irq;
+	struct i2c_adapter *adapter;
+	struct i2c_client *client;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
 
 	bq20z75_device = kzalloc(sizeof(struct bq20z75_info), GFP_KERNEL);
 	if (!bq20z75_device)
 		return -ENOMEM;
 
-	bq20z75_device->client = client;
+	bq20z75_device->gpio_detect = gpio_is_valid(pdata->battery_detect);
+	bq20z75_device->pdata = pdata;
+	bq20z75_device->enable_detection = false;
+	bq20z75_device->pdev = pdev;
 	bq20z75_device->power_supply.name = "battery";
 	bq20z75_device->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
 	bq20z75_device->power_supply.properties = bq20z75_properties;
@@ -489,27 +561,116 @@ static int bq20z75_probe(struct i2c_client *client,
 		ARRAY_SIZE(bq20z75_properties);
 	bq20z75_device->power_supply.get_property = bq20z75_get_property;
 
+	platform_set_drvdata(pdev, &bq20z75_device);
+
+	if (!bq20z75_device->gpio_detect)
+		goto skip_gpio;
+
+	rc = gpio_request(pdata->battery_detect, dev_name(&pdev->dev));
+	if (rc) {
+		dev_warn(&pdev->dev, "Failed to request gpio: %d\n", rc);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = gpio_direction_input(pdata->battery_detect);
+	if (rc) {
+		dev_warn(&pdev->dev, "Failed to get gpio as input: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	irq = gpio_to_irq(pdata->battery_detect);
+	if (irq <= 0) {
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = request_irq(irq, bq20z75_irq,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		dev_name(&pdev->dev), &bq20z75_device->power_supply);
+	if (rc) {
+		dev_warn(&pdev->dev, "Failed to request irq: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+	}
+
+	bq20z75_device->irq = irq;
+
+skip_gpio:
+	adapter = i2c_get_adapter(pdata->bus);
+	if (!adapter) {
+		dev_err(&pdev->dev, "Failed to get I2C adapter\n");
+		rc = -EINVAL;
+		goto exit_adapter;
+	}
+
+	client = i2c_new_device(adapter, &bq20z75_i2c_device);
+	if (!client) {
+		dev_err(&pdev->dev, "Failed to create I2C device\n");
+		rc = -EINVAL;
+		goto exit_device;
+	}
+
+	bq20z75_device->adapter = adapter;
+	bq20z75_device->client = client;
 	i2c_set_clientdata(client, bq20z75_device);
 
-	rc = power_supply_register(&client->dev, &bq20z75_device->power_supply);
+	rc = power_supply_register(&pdev->dev, &bq20z75_device->power_supply);
 	if (rc) {
-		dev_err(&client->dev,
+		dev_err(&pdev->dev,
 			"%s: Failed to register power supply\n", __func__);
-		kfree(bq20z75_device);
-		return rc;
+		goto exit_psupply;
 	}
 
-	dev_info(&client->dev,
+	/* NOW check if initially present */
+	if (bq20z75_device->gpio_detect) {
+		int present = gpio_get_value(pdata->battery_detect);
+		bq20z75_device->is_present = (present == 0);
+	} else {
+		union power_supply_propval val;
+		bq20z75_get_battery_presence_and_health(client,
+			POWER_SUPPLY_PROP_PRESENT, &val);
+		bq20z75_device->is_present = (val.intval != 0);
+	}
+	bq20z75_device->enable_detection = true;
+
+	dev_info(&pdev->dev,
 		"%s: battery gas gauge device registered\n", client->name);
 
 	return 0;
+exit_psupply:
+	i2c_unregister_device(client);
+exit_device:
+	i2c_put_adapter(adapter);
+exit_adapter:
+	if (bq20z75_device->irq)
+		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
+	if (bq20z75_device->gpio_detect)
+		gpio_free(pdata->battery_detect);
+
+	kfree(bq20z75_device);
+	return rc;
 }
 
-static int bq20z75_remove(struct i2c_client *client)
+static int __devexit bq20z75_remove(struct platform_device *pdev)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct bq20z75_info *bq20z75_device = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&bq20z75_device->power_supply);
+
+	if (bq20z75_device->irq)
+		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
+
+	if (bq20z75_device->gpio_detect)
+		gpio_free(bq20z75_device->pdata->battery_detect);
+
+	i2c_unregister_device(bq20z75_device->client);
+	i2c_put_adapter(bq20z75_device->adapter);
+
+	platform_set_drvdata(pdev, NULL);
 	kfree(bq20z75_device);
 	bq20z75_device = NULL;
 
@@ -517,13 +678,14 @@ static int bq20z75_remove(struct i2c_client *client)
 }
 
 #if defined CONFIG_PM
-static int bq20z75_suspend(struct i2c_client *client,
+static int bq20z75_suspend(struct platform_device *pdev,
 	pm_message_t state)
 {
+	struct bq20z75_info *bq20z75_device = platform_get_drvdata(pdev);
 	s32 ret;
 
 	/* write to manufacturer access with sleep command */
-	ret = bq20z75_write_word_data(client,
+	ret = bq20z75_write_word_data(bq20z75_device->client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_SLEEP);
 	if (ret < 0)
@@ -537,33 +699,27 @@ static int bq20z75_suspend(struct i2c_client *client,
 /* any smbus transaction will wake up bq20z75 */
 #define bq20z75_resume		NULL
 
-static const struct i2c_device_id bq20z75_id[] = {
-	{ "bq20z75", 0 },
-	{}
-};
-
-static struct i2c_driver bq20z75_battery_driver = {
+static struct platform_driver bq20z75_driver = {
 	.probe		= bq20z75_probe,
-	.remove		= bq20z75_remove,
+	.remove		= __devexit_p(bq20z75_remove),
 	.suspend	= bq20z75_suspend,
 	.resume		= bq20z75_resume,
-	.id_table	= bq20z75_id,
 	.driver = {
 		.name	= "bq20z75-battery",
 	},
 };
 
-static int __init bq20z75_battery_init(void)
+static int __init bq20z75_init(void)
 {
-	return i2c_add_driver(&bq20z75_battery_driver);
+	return platform_driver_register(&bq20z75_driver);
 }
-module_init(bq20z75_battery_init);
+module_init(bq20z75_init);
 
-static void __exit bq20z75_battery_exit(void)
+static void __exit bq20z75_exit(void)
 {
-	i2c_del_driver(&bq20z75_battery_driver);
+	platform_driver_unregister(&bq20z75_driver);
 }
-module_exit(bq20z75_battery_exit);
+module_exit(bq20z75_exit);
 
 MODULE_DESCRIPTION("BQ20z75 battery monitor driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/power/bq20z75.h b/include/linux/power/bq20z75.h
new file mode 100644
index 0000000..53529f0
--- /dev/null
+++ b/include/linux/power/bq20z75.h
@@ -0,0 +1,39 @@
+/*
+ * Gas Gauge driver for TI's BQ20Z75
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __LINUX_POWER_BQ20Z75_H_
+#define __LINUX_POWER_BQ20Z75_H_
+
+#include <linux/power_supply.h>
+#include <linux/types.h>
+
+/**
+ * struct bq20z75_platform_data - platform data for bq20z75 devices
+ * @battery_detect:	GPIO which is used to detect battery presence
+ * @i2c_retry_count:	# of times to retry on i2c io failure
+ * @bus:		i2c bus number
+ */
+struct bq20z75_platform_data {
+	int battery_detect;
+	int i2c_retry_count;
+	int bus;
+};
+
+#endif
-- 
1.7.0.4

