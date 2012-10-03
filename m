Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2JCDdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:33:40 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:42807 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2JCDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:33:38 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Steve Hardy <shardy@redhat.com>
Subject: [PATCH v4 1/2] hwmon: (ads7828) driver cleanup
Date: Tue,  2 Oct 2012 23:33:26 -0400
Message-Id: <1349235207-7517-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove module parameters, add a ads7828_platform_data;
* Move driver declaration to avoid adding function prototypes;
* Remove unused macros;
* Coding Style fixes.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/hwmon/ads7828           |  31 +++--
 drivers/hwmon/ads7828.c               | 206 ++++++++++++++++------------------
 include/linux/platform_data/ads7828.h |  29 +++++
 3 files changed, 147 insertions(+), 119 deletions(-)
 create mode 100644 include/linux/platform_data/ads7828.h

diff --git a/Documentation/hwmon/ads7828 b/Documentation/hwmon/ads7828
index 2bbebe6..b35668c 100644
--- a/Documentation/hwmon/ads7828
+++ b/Documentation/hwmon/ads7828
@@ -5,21 +5,32 @@ Supported chips:
   * Texas Instruments/Burr-Brown ADS7828
     Prefix: 'ads7828'
     Addresses scanned: I2C 0x48, 0x49, 0x4a, 0x4b
-    Datasheet: Publicly available at the Texas Instruments website :
+    Datasheet: Publicly available at the Texas Instruments website:
                http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
 Authors:
         Steve Hardy <shardy@redhat.com>
 
-Module Parameters
------------------
-
-* se_input: bool (default Y)
-  Single ended operation - set to N for differential mode
-* int_vref: bool (default Y)
-  Operate with the internal 2.5V reference - set to N for external reference
-* vref_mv: int (default 2500)
-  If using an external reference, set this to the reference voltage in mV
+Platform data
+-------------
+
+The ads7828 driver accepts an optional ads7828_platform_data structure (defined
+in include/linux/platform_data/ads7828.h). If no structure is provided, the
+configuration defaults to single ended operation and internal vref (2.5V).
+
+The structure fields are:
+
+* diff_input: bool
+  Differential operation - set to true for differential mode,
+  false for default single ended mode.
+* ext_vref: bool
+  External reference - set to true if it operates with an external reference,
+  false for default internal reference.
+* vref_mv: int
+  Voltage reference - if using an external reference, set this to the reference
+  voltage in mV, otherwise, it will default to the internal value (2500mV).
+  This value will be bounded with limits accepted by the chip, described in the
+  datasheet.
 
 Description
 -----------
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index 1f9e8af..756bd1b 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -6,7 +6,7 @@
  *
  * Written by Steve Hardy <shardy@redhat.com>
  *
- * Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads7828.pdf
+ * For further information, see the Documentation/hwmon/ads7828 file.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -23,63 +23,48 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/jiffies.h>
-#include <linux/i2c.h>
+#include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/platform_data/ads7828.h>
+#include <linux/slab.h>
 
 /* The ADS7828 registers */
-#define ADS7828_NCH 8 /* 8 channels of 12-bit A-D supported */
-#define ADS7828_CMD_SD_SE 0x80 /* Single ended inputs */
-#define ADS7828_CMD_SD_DIFF 0x00 /* Differential inputs */
-#define ADS7828_CMD_PD0 0x0 /* Power Down between A-D conversions */
-#define ADS7828_CMD_PD1 0x04 /* Internal ref OFF && A-D ON */
-#define ADS7828_CMD_PD2 0x08 /* Internal ref ON && A-D OFF */
-#define ADS7828_CMD_PD3 0x0C /* Internal ref ON && A-D ON */
-#define ADS7828_INT_VREF_MV 2500 /* Internal vref is 2.5V, 2500mV */
+#define ADS7828_NCH		8	/* 8 channels supported */
+#define ADS7828_CMD_SD_SE	0x80	/* Single ended inputs */
+#define ADS7828_CMD_PD1		0x04	/* Internal vref OFF && A/D ON */
+#define ADS7828_CMD_PD3		0x0C	/* Internal vref ON && A/D ON */
+#define ADS7828_INT_VREF_MV	2500	/* Internal vref is 2.5V, 2500mV */
+#define ADS7828_EXT_VREF_MV_MIN	50	/* External vref min value 0.05V */
+#define ADS7828_EXT_VREF_MV_MAX	5250	/* External vref max value 5.25V */
 
 /* Addresses to scan */
-static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
+static const unsigned short ads7828_normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
 	I2C_CLIENT_END };
 
-/* Module parameters */
-static bool se_input = 1; /* Default is SE, 0 == diff */
-static bool int_vref = 1; /* Default is internal ref ON */
-static int vref_mv = ADS7828_INT_VREF_MV; /* set if vref != 2.5V */
-module_param(se_input, bool, S_IRUGO);
-module_param(int_vref, bool, S_IRUGO);
-module_param(vref_mv, int, S_IRUGO);
-
-/* Global Variables */
-static u8 ads7828_cmd_byte; /* cmd byte without channel bits */
-static unsigned int ads7828_lsb_resol; /* resolution of the ADC sample lsb */
-
-/* Each client has this additional data */
+/* Client specific data */
 struct ads7828_data {
 	struct device *hwmon_dev;
-	struct mutex update_lock; /* mutex protect updates */
-	char valid; /* !=0 if following fields are valid */
-	unsigned long last_updated; /* In jiffies */
-	u16 adc_input[ADS7828_NCH]; /* ADS7828_NCH 12-bit samples */
+	struct mutex update_lock;	/* Mutex protecting updates */
+	unsigned long last_updated;	/* Last updated time (in jiffies) */
+	u16 adc_input[ADS7828_NCH];	/* ADS7828_NCH samples */
+	bool valid;			/* Validity flag */
+	bool diff_input;		/* Differential input */
+	bool ext_vref;			/* External voltage reference */
+	unsigned int vref_mv;		/* voltage reference value */
+	u8 cmd_byte;			/* Command byte without channel bits */
+	unsigned int lsb_resol;		/* Resolution of the ADC sample LSB */
 };
 
-/* Function declaration - necessary due to function dependencies */
-static int ads7828_detect(struct i2c_client *client,
-			  struct i2c_board_info *info);
-static int ads7828_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id);
-
-static inline u8 channel_cmd_byte(int ch)
+/* Command byte C2,C1,C0 - see datasheet */
+static inline u8 ads7828_cmd_byte(u8 cmd, int ch)
 {
-	/* cmd byte C2,C1,C0 - see datasheet */
-	u8 cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
-	cmd |= ads7828_cmd_byte;
-	return cmd;
+	return cmd | (((ch >> 1) | (ch & 0x01) << 2) << 4);
 }
 
 /* Update data for the device (all 8 channels) */
@@ -96,12 +81,12 @@ static struct ads7828_data *ads7828_update_device(struct device *dev)
 		dev_dbg(&client->dev, "Starting ads7828 update\n");
 
 		for (ch = 0; ch < ADS7828_NCH; ch++) {
-			u8 cmd = channel_cmd_byte(ch);
+			u8 cmd = ads7828_cmd_byte(data->cmd_byte, ch);
 			data->adc_input[ch] =
 				i2c_smbus_read_word_swapped(client, cmd);
 		}
 		data->last_updated = jiffies;
-		data->valid = 1;
+		data->valid = true;
 	}
 
 	mutex_unlock(&data->update_lock);
@@ -110,28 +95,25 @@ static struct ads7828_data *ads7828_update_device(struct device *dev)
 }
 
 /* sysfs callback function */
-static ssize_t show_in(struct device *dev, struct device_attribute *da,
-	char *buf)
+static ssize_t ads7828_show_in(struct device *dev, struct device_attribute *da,
+			       char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	struct ads7828_data *data = ads7828_update_device(dev);
-	/* Print value (in mV as specified in sysfs-interface documentation) */
-	return sprintf(buf, "%d\n", (data->adc_input[attr->index] *
-		ads7828_lsb_resol)/1000);
-}
+	unsigned int value = DIV_ROUND_CLOSEST(data->adc_input[attr->index] *
+					       data->lsb_resol, 1000);
 
-#define in_reg(offset)\
-static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
-	NULL, offset)
+	return sprintf(buf, "%d\n", value);
+}
 
-in_reg(0);
-in_reg(1);
-in_reg(2);
-in_reg(3);
-in_reg(4);
-in_reg(5);
-in_reg(6);
-in_reg(7);
+static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ads7828_show_in, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, ads7828_show_in, NULL, 1);
+static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, ads7828_show_in, NULL, 2);
+static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, ads7828_show_in, NULL, 3);
+static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, ads7828_show_in, NULL, 4);
+static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, ads7828_show_in, NULL, 5);
+static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, ads7828_show_in, NULL, 6);
+static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, ads7828_show_in, NULL, 7);
 
 static struct attribute *ads7828_attributes[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
@@ -152,35 +134,19 @@ static const struct attribute_group ads7828_group = {
 static int ads7828_remove(struct i2c_client *client)
 {
 	struct ads7828_data *data = i2c_get_clientdata(client);
+
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ads7828_group);
+
 	return 0;
 }
 
-static const struct i2c_device_id ads7828_id[] = {
-	{ "ads7828", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, ads7828_id);
-
-/* This is the driver that will be inserted */
-static struct i2c_driver ads7828_driver = {
-	.class = I2C_CLASS_HWMON,
-	.driver = {
-		.name = "ads7828",
-	},
-	.probe = ads7828_probe,
-	.remove = ads7828_remove,
-	.id_table = ads7828_id,
-	.detect = ads7828_detect,
-	.address_list = normal_i2c,
-};
-
 /* Return 0 if detection is successful, -ENODEV otherwise */
 static int ads7828_detect(struct i2c_client *client,
 			  struct i2c_board_info *info)
 {
 	struct i2c_adapter *adapter = client->adapter;
+	u8 default_cmd_byte = ADS7828_CMD_SD_SE | ADS7828_CMD_PD3;
 	int ch;
 
 	/* Check we have a valid client */
@@ -195,9 +161,12 @@ static int ads7828_detect(struct i2c_client *client,
 	 * - Check the top 4 bits of each result are not set (12 data bits)
 	 */
 	for (ch = 0; ch < ADS7828_NCH; ch++) {
-		u16 in_data;
-		u8 cmd = channel_cmd_byte(ch);
-		in_data = i2c_smbus_read_word_swapped(client, cmd);
+		u8 cmd = ads7828_cmd_byte(default_cmd_byte, ch);
+		u16 in_data = i2c_smbus_read_word_swapped(client, cmd);
+
+		if (in_data < 0)
+			return -ENODEV;
+
 		if (in_data & 0xF000) {
 			pr_debug("%s : Doesn't look like an ads7828 device\n",
 				 __func__);
@@ -213,6 +182,7 @@ static int ads7828_detect(struct i2c_client *client,
 static int ads7828_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
+	struct ads7828_platform_data *pdata = client->dev.platform_data;
 	struct ads7828_data *data;
 	int err;
 
@@ -221,10 +191,30 @@ static int ads7828_probe(struct i2c_client *client,
 	if (!data)
 		return -ENOMEM;
 
+	if (pdata) {
+		data->diff_input = pdata->diff_input;
+		data->ext_vref = pdata->ext_vref;
+		if (data->ext_vref)
+			data->vref_mv = pdata->vref_mv;
+	}
+
+	/* Bound Vref with min/max values if it was provided */
+	if (data->vref_mv)
+		data->vref_mv = SENSORS_LIMIT(data->vref_mv,
+					      ADS7828_EXT_VREF_MV_MIN,
+					      ADS7828_EXT_VREF_MV_MAX);
+	else
+		data->vref_mv = ADS7828_INT_VREF_MV;
+
+	data->lsb_resol = DIV_ROUND_CLOSEST(data->vref_mv * 1000, 4096);
+
+	data->cmd_byte = data->ext_vref ? ADS7828_CMD_PD1 : ADS7828_CMD_PD3;
+	if (!data->diff_input)
+		data->cmd_byte |= ADS7828_CMD_SD_SE;
+
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
-	/* Register sysfs hooks */
 	err = sysfs_create_group(&client->dev.kobj, &ads7828_group);
 	if (err)
 		return err;
@@ -232,38 +222,36 @@ static int ads7828_probe(struct i2c_client *client,
 	data->hwmon_dev = hwmon_device_register(&client->dev);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove;
+		goto error;
 	}
 
 	return 0;
 
-exit_remove:
+error:
 	sysfs_remove_group(&client->dev.kobj, &ads7828_group);
 	return err;
 }
 
-static int __init sensors_ads7828_init(void)
-{
-	/* Initialize the command byte according to module parameters */
-	ads7828_cmd_byte = se_input ?
-		ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
-	ads7828_cmd_byte |= int_vref ?
-		ADS7828_CMD_PD3 : ADS7828_CMD_PD1;
-
-	/* Calculate the LSB resolution */
-	ads7828_lsb_resol = (vref_mv*1000)/4096;
+static const struct i2c_device_id ads7828_device_ids[] = {
+	{ "ads7828", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ads7828_device_ids);
 
-	return i2c_add_driver(&ads7828_driver);
-}
+static struct i2c_driver ads7828_driver = {
+	.class = I2C_CLASS_HWMON,
+	.driver = {
+		.name = "ads7828",
+	},
+	.address_list = ads7828_normal_i2c,
+	.detect = ads7828_detect,
+	.probe = ads7828_probe,
+	.remove = ads7828_remove,
+	.id_table = ads7828_device_ids,
+};
 
-static void __exit sensors_ads7828_exit(void)
-{
-	i2c_del_driver(&ads7828_driver);
-}
+module_i2c_driver(ads7828_driver);
 
-MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
-MODULE_DESCRIPTION("ADS7828 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_ads7828_init);
-module_exit(sensors_ads7828_exit);
+MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
+MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter");
diff --git a/include/linux/platform_data/ads7828.h b/include/linux/platform_data/ads7828.h
new file mode 100644
index 0000000..3245f45
--- /dev/null
+++ b/include/linux/platform_data/ads7828.h
@@ -0,0 +1,29 @@
+/*
+ * TI ADS7828 A/D Converter platform data definition
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * For further information, see the Documentation/hwmon/ads7828 file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PDATA_ADS7828_H
+#define _PDATA_ADS7828_H
+
+/**
+ * struct ads7828_platform_data - optional ADS7828 connectivity info
+ * @diff_input:		Differential input mode.
+ * @ext_vref:		Use an external voltage reference.
+ * @vref_mv:		Voltage reference value, if external.
+ */
+struct ads7828_platform_data {
+	bool diff_input;
+	bool ext_vref;
+	unsigned int vref_mv;
+};
+
+#endif /* _PDATA_ADS7828_H */
-- 
1.7.11.4

