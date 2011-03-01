Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1CAA5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:57:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3861 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1CAA4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:56:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 28 Feb 2011 16:56:39 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/4] power: bq20z75: add optional battery detect gpio
Date: Mon, 28 Feb 2011 16:55:28 -0800
Message-Id: <1298940931-17552-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Adding support for an optional gpio for battery detection. This is passed in
through the i2c platform data. It also accepts another field,
battery_detect_present to signify the gpio state which means the battery is
present, either 0 (low) or 1 (high).

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c       |  160 +++++++++++++++++++++++++++++++++--------
 include/linux/power/bq20z75.h |   37 ++++++++++
 2 files changed, 166 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/power/bq20z75.h

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 4141775..a51e98d 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -25,6 +25,10 @@
 #include <linux/power_supply.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <linux/power/bq20z75.h>
 
 enum {
 	REG_MANUFACTURER_DATA,
@@ -141,8 +145,13 @@ static enum power_supply_property bq20z75_properties[] = {
 };
 
 struct bq20z75_info {
-	struct i2c_client	*client;
-	struct power_supply	power_supply;
+	struct i2c_client		*client;
+	struct power_supply		power_supply;
+	struct bq20z75_platform_data	*pdata;
+	bool				is_present;
+	bool				gpio_detect;
+	bool				enable_detection;
+	int				irq;
 };
 
 static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
@@ -179,6 +188,18 @@ static int bq20z75_get_battery_presence_and_health(
 	union power_supply_propval *val)
 {
 	s32 ret;
+	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+
+	if (psp == POWER_SUPPLY_PROP_PRESENT &&
+		bq20z75_device->gpio_detect) {
+		ret = gpio_get_value(
+			bq20z75_device->pdata->battery_detect);
+		if (ret == bq20z75_device->pdata->battery_detect_present)
+			val->intval = 1;
+		else
+			val->intval = 0;
+		return ret;
+	}
 
 	/* Write to ManufacturerAccess with
 	 * ManufacturerAccess command and then
@@ -192,8 +213,11 @@ static int bq20z75_get_battery_presence_and_health(
 
 	ret = bq20z75_read_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr);
-	if (ret < 0)
+	if (ret < 0) {
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			val->intval = 0; /* battery removed */
 		return ret;
+	}
 
 	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
 	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
@@ -397,8 +421,7 @@ static int bq20z75_get_property(struct power_supply *psy,
 	enum power_supply_property psp,
 	union power_supply_propval *val)
 {
-	int ps_index;
-	int ret;
+	int ret = 0;
 	struct bq20z75_info *bq20z75_device = container_of(psy,
 				struct bq20z75_info, power_supply);
 	struct i2c_client *client = bq20z75_device->client;
@@ -407,8 +430,6 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = bq20z75_get_battery_presence_and_health(client, psp, val);
-		if (ret)
-			return ret;
 		break;
 
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
@@ -422,20 +443,15 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ps_index = bq20z75_get_property_index(client, psp);
-		if (ps_index < 0)
-			return ps_index;
-
-		ret = bq20z75_get_battery_capacity(client, ps_index, psp, val);
-		if (ret)
-			return ret;
+		ret = bq20z75_get_property_index(client, psp);
+		if (ret < 0)
+			break;
 
+		ret = bq20z75_get_battery_capacity(client, ret, psp, val);
 		break;
 
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = bq20z75_get_battery_serial_number(client, val);
-		if (ret)
-			return ret;
 		break;
 
 	case POWER_SUPPLY_PROP_STATUS:
@@ -446,14 +462,11 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		ps_index = bq20z75_get_property_index(client, psp);
-		if (ps_index < 0)
-			return ps_index;
-
-		ret = bq20z75_get_battery_property(client, ps_index, psp, val);
-		if (ret)
-			return ret;
+		ret = bq20z75_get_property_index(client, psp);
+		if (ret < 0)
+			break;
 
+		ret = bq20z75_get_battery_property(client, ret, psp, val);
 		break;
 
 	default:
@@ -462,26 +475,51 @@ static int bq20z75_get_property(struct power_supply *psy,
 		return -EINVAL;
 	}
 
-	/* Convert units to match requirements for power supply class */
-	bq20z75_unit_adjustment(client, psp, val);
+	if (!bq20z75_device->enable_detection)
+		goto done;
+
+	if (!bq20z75_device->gpio_detect &&
+		bq20z75_device->is_present != (ret >= 0)) {
+		bq20z75_device->is_present = (ret >= 0);
+		power_supply_changed(&bq20z75_device->power_supply);
+	}
+
+done:
+	if (!ret) {
+		/* Convert units to match requirements for power supply class */
+		bq20z75_unit_adjustment(client, psp, val);
+	}
 
 	dev_dbg(&client->dev,
 		"%s: property = %d, value = %d\n", __func__, psp, val->intval);
 
-	return 0;
+	return ret;
 }
 
-static int bq20z75_probe(struct i2c_client *client,
+static irqreturn_t bq20z75_irq(int irq, void *devid)
+{
+	struct power_supply *battery = devid;
+
+	power_supply_changed(battery);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit bq20z75_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct bq20z75_info *bq20z75_device;
+	struct bq20z75_platform_data *pdata = client->dev.platform_data;
 	int rc;
+	int irq;
 
 	bq20z75_device = kzalloc(sizeof(struct bq20z75_info), GFP_KERNEL);
 	if (!bq20z75_device)
 		return -ENOMEM;
 
 	bq20z75_device->client = client;
+	bq20z75_device->enable_detection = false;
+	bq20z75_device->gpio_detect = false;
 	bq20z75_device->power_supply.name = "battery";
 	bq20z75_device->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
 	bq20z75_device->power_supply.properties = bq20z75_properties;
@@ -489,26 +527,86 @@ static int bq20z75_probe(struct i2c_client *client,
 		ARRAY_SIZE(bq20z75_properties);
 	bq20z75_device->power_supply.get_property = bq20z75_get_property;
 
+	if (pdata) {
+		bq20z75_device->gpio_detect =
+			gpio_is_valid(pdata->battery_detect);
+		bq20z75_device->pdata = pdata;
+	}
+
 	i2c_set_clientdata(client, bq20z75_device);
 
+	if (!bq20z75_device->gpio_detect)
+		goto skip_gpio;
+
+	rc = gpio_request(pdata->battery_detect, dev_name(&client->dev));
+	if (rc) {
+		dev_warn(&client->dev, "Failed to request gpio: %d\n", rc);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = gpio_direction_input(pdata->battery_detect);
+	if (rc) {
+		dev_warn(&client->dev, "Failed to get gpio as input: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	irq = gpio_to_irq(pdata->battery_detect);
+	if (irq <= 0) {
+		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = request_irq(irq, bq20z75_irq,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		dev_name(&client->dev), &bq20z75_device->power_supply);
+	if (rc) {
+		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		bq20z75_device->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	bq20z75_device->irq = irq;
+
+skip_gpio:
+
 	rc = power_supply_register(&client->dev, &bq20z75_device->power_supply);
 	if (rc) {
 		dev_err(&client->dev,
 			"%s: Failed to register power supply\n", __func__);
-		kfree(bq20z75_device);
-		return rc;
+		goto exit_psupply;
 	}
 
 	dev_info(&client->dev,
 		"%s: battery gas gauge device registered\n", client->name);
 
 	return 0;
+
+exit_psupply:
+	if (bq20z75_device->irq)
+		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
+	if (bq20z75_device->gpio_detect)
+		gpio_free(pdata->battery_detect);
+
+	kfree(bq20z75_device);
+
+	return rc;
 }
 
-static int bq20z75_remove(struct i2c_client *client)
+static int __devexit bq20z75_remove(struct i2c_client *client)
 {
 	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
 
+	if (bq20z75_device->irq)
+		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
+	if (bq20z75_device->gpio_detect)
+		gpio_free(bq20z75_device->pdata->battery_detect);
+
 	power_supply_unregister(&bq20z75_device->power_supply);
 	kfree(bq20z75_device);
 	bq20z75_device = NULL;
@@ -544,7 +642,7 @@ static const struct i2c_device_id bq20z75_id[] = {
 
 static struct i2c_driver bq20z75_battery_driver = {
 	.probe		= bq20z75_probe,
-	.remove		= bq20z75_remove,
+	.remove		= __devexit_p(bq20z75_remove),
 	.suspend	= bq20z75_suspend,
 	.resume		= bq20z75_resume,
 	.id_table	= bq20z75_id,
diff --git a/include/linux/power/bq20z75.h b/include/linux/power/bq20z75.h
new file mode 100644
index 0000000..0e1b8a2
--- /dev/null
+++ b/include/linux/power/bq20z75.h
@@ -0,0 +1,37 @@
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
+ * @battery_detect:		GPIO which is used to detect battery presence
+ * @battery_detect_present:	gpio state when battery is present (0 / 1)
+ */
+struct bq20z75_platform_data {
+	int battery_detect;
+	int battery_detect_present;
+};
+
+#endif
-- 
1.7.0.4

