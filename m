Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1DMLwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:52:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7449 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1DMLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:52:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 13 Apr 2011 04:52:11 -0700
From: wni@nvidia.com
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, achew@nvidia.com, Wei Ni <wni@nvidia.com>
Subject: [PATCH] [hwmon] lm90: Support NCT1008 sensor
Date: Wed, 13 Apr 2011 19:51:48 +0800
Message-Id: <1302695508-2002-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Ni <wni@nvidia.com>

NCT1008 is the register-compatible with the ADM1032 and ADT7461,
so support it in this lm90 driver.
And add alarm function, suspend/resume callback.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c    |  164 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/nct1008.h |   39 +++++++++++
 2 files changed, 202 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/nct1008.h

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index c43b4e9..72d6a05 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -83,6 +83,8 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/interrupt.h>
+#include <linux/nct1008.h>
 
 /*
  * Addresses to scan
@@ -101,7 +103,7 @@ static const unsigned short normal_i2c[] = {
 	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
-	max6646, w83l771, max6696 };
+	max6646, w83l771, max6696, nct1008 };
 
 /*
  * The LM90 registers
@@ -174,6 +176,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 static const struct i2c_device_id lm90_id[] = {
 	{ "adm1032", adm1032 },
 	{ "adt7461", adt7461 },
+	{ "nct1008", nct1008 },
 	{ "lm90", lm90 },
 	{ "lm86", lm86 },
 	{ "lm89", lm86 },
@@ -216,6 +219,12 @@ static const struct lm90_params lm90_params[] = {
 		.alert_alarms = 0x7c,
 		.max_convrate = 10,
 	},
+	[nct1008] = {
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_BROKEN_ALERT,
+		.alert_alarms = 0x7c,
+		.max_convrate = 10,
+	},
 	[lm86] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
 		.alert_alarms = 0x7b,
@@ -271,6 +280,8 @@ static const struct lm90_params lm90_params[] = {
 struct lm90_data {
 	struct device *hwmon_dev;
 	struct mutex update_lock;
+	struct work_struct work;
+	struct i2c_client *client;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 	int kind;
@@ -304,6 +315,7 @@ struct lm90_data {
 			   7: remote 2 high limit (ma6695/96 only) */
 	u8 temp_hyst;
 	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
+	void (*alarm_fn)(int irq);
 };
 
 /*
@@ -1082,6 +1094,46 @@ static DEVICE_ATTR(pec, S_IWUSR | S_IRUGO, show_pec, set_pec);
  * Real code
  */
 
+static void lm90_enable(struct i2c_client *client)
+{
+	u8 value;
+
+	lm90_read_reg(client, LM90_REG_R_CONFIG1, &value);
+	value &= ~0x40;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, value);
+}
+
+static void lm90_disable(struct i2c_client *client)
+{
+	u8 value;
+
+	lm90_read_reg(client, LM90_REG_R_CONFIG1, &value);
+	value |= 0x40;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, value);
+}
+
+
+static void lm90_work_func(struct work_struct *work)
+{
+	struct lm90_data *data = container_of(work, struct lm90_data, work);
+	int irq = data->client->irq;
+
+	mutex_lock(&data->update_lock);
+
+	if (data->alarm_fn)
+		data->alarm_fn(irq);
+
+	mutex_unlock(&data->update_lock);
+}
+
+static irqreturn_t lm90_irq(int irq, void *dev_id)
+{
+	struct lm90_data *data = dev_id;
+	schedule_work(&data->work);
+
+	return IRQ_HANDLED;
+}
+
 /* Return 0 if detection is successful, -ENODEV otherwise */
 static int lm90_detect(struct i2c_client *new_client,
 		       struct i2c_board_info *info)
@@ -1153,6 +1205,11 @@ static int lm90_detect(struct i2c_client *new_client,
 		 && (reg_config1 & 0x1B) == 0x00
 		 && reg_convrate <= 0x0A) {
 			name = "adt7461";
+		} else
+		if ((chip_id == 0x57 || chip_id == 0x54) /* NCT1008 */
+		 && (reg_config1 & 0x1B) == 0x00
+		 && reg_convrate <= 0x0A) {
+			name = "nct1008";
 		}
 	} else
 	if (man_id == 0x4D) { /* Maxim */
@@ -1332,6 +1389,74 @@ static void lm90_init_client(struct i2c_client *client)
 		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
 }
 
+static void nct1008_configure_client(struct i2c_client *client)
+{
+	struct lm90_data *data = i2c_get_clientdata(client);
+	struct nct1008_platform_data *pdata = client->dev.platform_data;
+	u8 value;
+	u16 value16;
+
+	/*
+	 * Initial Configuration - device is placed in standby and
+	 * ALERT/THERM2 pin is configured as THERM2
+	 */
+	lm90_read_reg(client, LM90_REG_R_CONFIG1, &value);
+	if (pdata->ext_range)
+		value |= 0x24;
+	else
+		value |= 0x20;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, value);
+
+	/* Check Temperature Range Select */
+	if (value & 0x04)
+		data->flags |= LM90_FLAG_ADT7461_EXT;
+
+	/* Temperature conversion rate */
+	value = pdata->conv_rate;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_CONVRATE, value);
+
+	/* External temperature h/w shutdown limit */
+	value = temp_to_u8_adt7461(data, pdata->shutdown_ext_limit);
+	i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_CRIT, value);
+
+	/* Local temperature h/w shutdown limit */
+	value = temp_to_u8_adt7461(data, pdata->shutdown_local_limit);
+	i2c_smbus_write_byte_data(client, LM90_REG_W_LOCAL_CRIT, value);
+
+	/* External Temperature Throttling limit */
+	value16 = temp_to_u16_adt7461(data, pdata->throttling_ext_limit);
+	i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_HIGHH,
+				  value16 >> 8);
+	if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
+		i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_HIGHL,
+					  value16 & 0xff);
+
+	/* Local Temperature Throttling limit */
+	value = pdata->ext_range ? 191 : 127;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_LOCAL_HIGH, value);
+
+	/* Remote channel offset */
+	value = pdata->offset;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_REMOTE_OFFSH, value);
+
+	/* THERM hysteresis */
+	value = pdata->hysteresis;
+	i2c_smbus_write_byte_data(client, LM90_REG_W_TCRIT_HYST, value);
+
+	data->alarm_fn = pdata->alarm_fn;
+}
+
+static int lm90_configure_irq(struct lm90_data *data)
+{
+	if (data->alarm_fn || data->client->irq) {
+		INIT_WORK(&data->work, lm90_work_func);
+		return request_irq(data->client->irq, lm90_irq,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"lm90", data);
+	} else
+		return 0;
+}
+
 static int lm90_probe(struct i2c_client *new_client,
 		      const struct i2c_device_id *id)
 {
@@ -1344,6 +1469,7 @@ static int lm90_probe(struct i2c_client *new_client,
 		err = -ENOMEM;
 		goto exit;
 	}
+	data->client = new_client;
 	i2c_set_clientdata(new_client, data);
 	mutex_init(&data->update_lock);
 
@@ -1367,6 +1493,14 @@ static int lm90_probe(struct i2c_client *new_client,
 	/* Initialize the LM90 chip */
 	lm90_init_client(new_client);
 
+	/* Configure the NCT1008 chip from platform_data */
+	if (new_client->dev.platform_data)
+		nct1008_configure_client(new_client);
+
+	err = lm90_configure_irq(data);
+	if (err)
+		goto exit_free;
+
 	/* Register sysfs hooks */
 	err = sysfs_create_group(&new_client->dev.kobj, &lm90_group);
 	if (err)
@@ -1474,6 +1608,30 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
 	}
 }
 
+#ifdef CONFIG_PM
+static int lm90_suspend(struct i2c_client *client, pm_message_t state)
+{
+	if (client->irq)
+		disable_irq(client->irq);
+	lm90_disable(client);
+
+	return 0;
+}
+
+static int lm90_resume(struct i2c_client *client)
+{
+	struct lm90_data *data = i2c_get_clientdata(client);
+
+	lm90_enable(client);
+	if (client->irq)
+		enable_irq(client->irq);
+	if (data->alarm_fn || data->client->irq)
+		schedule_work(&data->work);
+
+	return 0;
+}
+#endif
+
 static struct i2c_driver lm90_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
@@ -1485,6 +1643,10 @@ static struct i2c_driver lm90_driver = {
 	.id_table	= lm90_id,
 	.detect		= lm90_detect,
 	.address_list	= normal_i2c,
+#ifdef CONFIG_PM
+	.suspend	= lm90_suspend,
+	.resume		= lm90_resume,
+#endif
 };
 
 static int __init sensors_lm90_init(void)
diff --git a/include/linux/nct1008.h b/include/linux/nct1008.h
new file mode 100644
index 0000000..f9a9626
--- /dev/null
+++ b/include/linux/nct1008.h
@@ -0,0 +1,39 @@
+/*
+ * include/linux/nct1008.h
+ *
+ * NCT1008, temperature monitoring device from ON Semiconductors
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
+#ifndef _LINUX_NCT1008_H
+#define _LINUX_NCT1008_H
+
+#include <linux/types.h>
+
+struct nct1008_platform_data {
+	bool ext_range;
+	u8 conv_rate;
+	u8 offset;
+	u8 hysteresis;
+	long shutdown_ext_limit;
+	long shutdown_local_limit;
+	long throttling_ext_limit;
+	void (*alarm_fn)(int irq);
+};
+
+#endif /* _LINUX_NCT1008_H */
-- 
1.7.0

