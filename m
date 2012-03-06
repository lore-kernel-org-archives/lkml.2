Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031295Ab2CFVGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:06:51 -0500
Received: from csmtp2.one.com ([91.198.169.22]:13986 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031076Ab2CFVGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:06:49 -0500
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv2 1/3] misc: clean up bmp085 driver
Date: Tue,  6 Mar 2012 22:08:02 +0100
Message-Id: <1331068084-17911-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes various cleaning of the bmp085 driver including:
- Addition of platform_data and header file
- Implement pm functions
- Whitespaces and alignment fixes
- Minor typos
- Consistency fixes

Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/misc/bmp085.c      |  178 ++++++++++++++++++++++++++++----------------
 include/linux/i2c/bmp085.h |   43 +++++++++++
 2 files changed, 158 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/i2c/bmp085.h

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index b29a2be..5978094 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -1,4 +1,6 @@
 /*  Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
+    Copyright (c) 2012  Bosch Sensortec GmbH
+    Copyright (c) 2012  Unixphere AB
 
     This driver supports the bmp085 digital barometric pressure
     and temperature sensor from Bosch Sensortec. The datasheet
@@ -42,13 +44,13 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-
 #include <linux/module.h>
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-
+#include <linux/i2c/bmp085.h>
 
 #define BMP085_I2C_ADDRESS		0x77
 #define BMP085_CHIP_ID			0x55
@@ -56,7 +58,6 @@
 #define BMP085_CALIBRATION_DATA_START	0xAA
 #define BMP085_CALIBRATION_DATA_LENGTH	11	/* 16 bit values */
 #define BMP085_CHIP_ID_REG		0xD0
-#define BMP085_VERSION_REG		0xD1
 #define BMP085_CTRL_REG			0xF4
 #define BMP085_TEMP_MEASUREMENT		0x2E
 #define BMP085_PRESSURE_MEASUREMENT	0x34
@@ -65,9 +66,6 @@
 #define BMP085_CONVERSION_REGISTER_XLSB	0xF8
 #define BMP085_TEMP_CONVERSION_TIME	5
 
-#define BMP085_CLIENT_NAME		"bmp085"
-
-
 static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
 							I2C_CLIENT_END };
 
@@ -78,20 +76,18 @@ struct bmp085_calibration_data {
 	s16 MB, MC, MD;
 };
 
-
-/* Each client has this additional data */
 struct bmp085_data {
-	struct i2c_client *client;
-	struct mutex lock;
-	struct bmp085_calibration_data calibration;
-	u32 raw_temperature;
-	u32 raw_pressure;
-	unsigned char oversampling_setting;
-	u32 last_temp_measurement;
-	s32 b6; /* calculated temperature correction coefficient */
+	struct	i2c_client *client;
+	struct	mutex lock;
+	struct	bmp085_calibration_data calibration;
+	u8	oversampling_setting;
+	u32	raw_temperature;
+	u32	raw_pressure;
+	u32	temp_measurement_period;
+	u32	last_temp_measurement;
+	s32	b6; /* calculated temperature correction coefficient */
 };
 
-
 static s32 bmp085_read_calibration_data(struct i2c_client *client)
 {
 	u16 tmp[BMP085_CALIBRATION_DATA_LENGTH];
@@ -99,12 +95,12 @@ static s32 bmp085_read_calibration_data(struct i2c_client *client)
 	struct bmp085_calibration_data *cali = &(data->calibration);
 	s32 status = i2c_smbus_read_i2c_block_data(client,
 				BMP085_CALIBRATION_DATA_START,
-				BMP085_CALIBRATION_DATA_LENGTH*sizeof(u16),
+				(BMP085_CALIBRATION_DATA_LENGTH << 1),
 				(u8 *)tmp);
 	if (status < 0)
 		return status;
 
-	if (status != BMP085_CALIBRATION_DATA_LENGTH*sizeof(u16))
+	if (status != (BMP085_CALIBRATION_DATA_LENGTH << 1))
 		return -EIO;
 
 	cali->AC1 =  be16_to_cpu(tmp[0]);
@@ -121,7 +117,6 @@ static s32 bmp085_read_calibration_data(struct i2c_client *client)
 	return 0;
 }
 
-
 static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 {
 	u16 tmp;
@@ -129,8 +124,8 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 
 	mutex_lock(&data->lock);
 	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
-						BMP085_TEMP_MEASUREMENT);
-	if (status != 0) {
+				   BMP085_TEMP_MEASUREMENT);
+	if (status < 0) {
 		dev_err(&data->client->dev,
 			"Error while requesting temperature measurement.\n");
 		goto exit;
@@ -163,8 +158,9 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 
 	mutex_lock(&data->lock);
 	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
-		BMP085_PRESSURE_MEASUREMENT + (data->oversampling_setting<<6));
-	if (status != 0) {
+			BMP085_PRESSURE_MEASUREMENT +
+			(data->oversampling_setting << 6));
+	if (status < 0) {
 		dev_err(&data->client->dev,
 			"Error while requesting pressure measurement.\n");
 		goto exit;
@@ -193,7 +189,6 @@ exit:
 	return status;
 }
 
-
 /*
  * This function starts the temperature measurement and returns the value
  * in tenth of a degree celsius.
@@ -205,7 +200,7 @@ static s32 bmp085_get_temperature(struct bmp085_data *data, int *temperature)
 	int status;
 
 	status = bmp085_update_raw_temperature(data);
-	if (status != 0)
+	if (status < 0)
 		goto exit;
 
 	x1 = ((data->raw_temperature - cali->AC6) * cali->AC5) >> 15;
@@ -222,8 +217,10 @@ exit:
 /*
  * This function starts the pressure measurement and returns the value
  * in millibar. Since the pressure depends on the ambient temperature,
- * a temperature measurement is executed if the last known value is older
- * than one second.
+ * a temperature measurement is executed according to the given temperature
+ * measurememt period (default is 1 sec boundary). This period could vary
+ * and needs to be adjusted according to the sensor environment, i.e. if big
+ * temperature variations then the temperature needs to be read out often.
  */
 static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 {
@@ -233,16 +230,17 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 	s32 p;
 	int status;
 
-	/* alt least every second force an update of the ambient temperature */
-	if (data->last_temp_measurement + 1*HZ < jiffies) {
+	/* update the ambient temperature according to the given meas. period */
+	if (data->last_temp_measurement +
+			data->temp_measurement_period < jiffies) {
 		status = bmp085_get_temperature(data, NULL);
-		if (status != 0)
-			goto exit;
+		if (status < 0)
+			return status;
 	}
 
 	status = bmp085_update_raw_pressure(data);
-	if (status != 0)
-		goto exit;
+	if (status < 0)
+		return status;
 
 	x1 = (data->b6 * data->b6) >> 12;
 	x1 *= cali->B2;
@@ -273,15 +271,14 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 
 	*pressure = p;
 
-exit:
-	return status;
+	return 0;
 }
 
 /*
  * This function sets the chip-internal oversampling. Valid values are 0..3.
  * The chip will use 2^oversampling samples for internal averaging.
  * This influences the measurement time and the accuracy; larger values
- * increase both. The datasheet gives on overview on how measurement time,
+ * increase both. The datasheet gives an overview on how measurement time,
  * accuracy and noise correlate.
  */
 static void bmp085_set_oversampling(struct bmp085_data *data,
@@ -308,12 +305,16 @@ static ssize_t set_oversampling(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
 	unsigned long oversampling;
-	int success = strict_strtoul(buf, 10, &oversampling);
-	if (success == 0) {
+	int err = kstrtoul(buf, 10, &oversampling);
+
+	if (err == 0) {
+		mutex_lock(&data->lock);
 		bmp085_set_oversampling(data, oversampling);
+		mutex_unlock(&data->lock);
 		return count;
 	}
-	return success;
+
+	return err;
 }
 
 static ssize_t show_oversampling(struct device *dev,
@@ -321,6 +322,7 @@ static ssize_t show_oversampling(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
+
 	return sprintf(buf, "%u\n", bmp085_get_oversampling(data));
 }
 static DEVICE_ATTR(oversampling, S_IWUSR | S_IRUGO,
@@ -336,7 +338,7 @@ static ssize_t show_temperature(struct device *dev,
 	struct bmp085_data *data = i2c_get_clientdata(client);
 
 	status = bmp085_get_temperature(data, &temperature);
-	if (status != 0)
+	if (status < 0)
 		return status;
 	else
 		return sprintf(buf, "%d\n", temperature);
@@ -353,7 +355,7 @@ static ssize_t show_pressure(struct device *dev,
 	struct bmp085_data *data = i2c_get_clientdata(client);
 
 	status = bmp085_get_pressure(data, &pressure);
-	if (status != 0)
+	if (status < 0)
 		return status;
 	else
 		return sprintf(buf, "%d\n", pressure);
@@ -385,43 +387,58 @@ static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
 
 static int bmp085_init_client(struct i2c_client *client)
 {
-	unsigned char version;
-	int status;
 	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_platform_data *pdata = client->dev.platform_data;
+	int status = bmp085_read_calibration_data(client);
+
+	if (status < 0)
+		return status;
+
 	data->client = client;
-	status = bmp085_read_calibration_data(client);
-	if (status != 0)
-		goto exit;
-	version = i2c_smbus_read_byte_data(client, BMP085_VERSION_REG);
 	data->last_temp_measurement = 0;
-	data->oversampling_setting = 3;
+	data->temp_measurement_period =
+		pdata ? (pdata->temp_measurement_period/1000)*HZ : 1*HZ;
+	data->oversampling_setting = pdata ? pdata->default_oversampling : 3;
 	mutex_init(&data->lock);
-	dev_info(&data->client->dev, "BMP085 ver. %d.%d found.\n",
-			(version & 0x0F), (version & 0xF0) >> 4);
-exit:
-	return status;
+
+	return 0;
 }
 
 static int __devinit bmp085_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
 	struct bmp085_data *data;
+	struct bmp085_platform_data *pdata = client->dev.platform_data;
+	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id :
+						 BMP085_CHIP_ID;
 	int err = 0;
 
+	if (pdata && pdata->init_hw) {
+		err = pdata->init_hw(&client->dev);
+		if (err) {
+			dev_err(&client->dev, "%s: init_hw failed!\n",
+				BMP085_NAME);
+			return err;
+		}
+	}
+
 	data = kzalloc(sizeof(struct bmp085_data), GFP_KERNEL);
 	if (!data) {
 		err = -ENOMEM;
 		goto exit;
 	}
 
-	/* default settings after POR */
-	data->oversampling_setting = 0x00;
-
 	i2c_set_clientdata(client, data);
 
+	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != chip_id) {
+		dev_err(&client->dev, "%s: chip_id failed!\n", BMP085_NAME);
+		err = -ENODEV;
+		goto exit_free;
+	}
+
 	/* Initialize the BMP085 chip */
 	err = bmp085_init_client(client);
-	if (err != 0)
+	if (err < 0)
 		goto exit_free;
 
 	/* Register sysfs hooks */
@@ -429,22 +446,57 @@ static int __devinit bmp085_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	dev_info(&data->client->dev, "Successfully initialized bmp085!\n");
-	goto exit;
+	dev_info(&client->dev, "Succesfully initialized bmp085!\n");
+	return 0;
 
 exit_free:
 	kfree(data);
 exit:
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw(&client->dev);
 	return err;
 }
 
 static int __devexit bmp085_remove(struct i2c_client *client)
 {
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_platform_data *pdata = client->dev.platform_data;
+
 	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
-	kfree(i2c_get_clientdata(client));
+
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw(&client->dev);
+
+	kfree(data);
+
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int bmp085_suspend(struct device *dev)
+{
+	struct bmp085_platform_data *pdata = dev->platform_data;
+
+	if (pdata && pdata->deinit_hw)
+		pdata->deinit_hw(dev);
+
+	return 0;
+}
+
+static int bmp085_resume(struct device *dev)
+{
+	struct bmp085_platform_data *pdata = dev->platform_data;
+
+	if (pdata && pdata->init_hw)
+		return pdata->init_hw(dev);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(bmp085_pm_ops, bmp085_suspend,
+			 bmp085_resume);
+
 static const struct i2c_device_id bmp085_id[] = {
 	{ "bmp085", 0 },
 	{ }
@@ -454,7 +506,8 @@ MODULE_DEVICE_TABLE(i2c, bmp085_id);
 static struct i2c_driver bmp085_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
-		.name	= "bmp085"
+		.name	= "bmp085",
+		.pm	= &bmp085_pm_ops,
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_probe,
@@ -474,7 +527,6 @@ static void __exit bmp085_exit(void)
 	i2c_del_driver(&bmp085_driver);
 }
 
-
 MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com");
 MODULE_DESCRIPTION("BMP085 driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
new file mode 100644
index 0000000..e6fc752
--- /dev/null
+++ b/include/linux/i2c/bmp085.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2012  Bosch Sensortec GmbH
+ * Copyright (c) 2012  Unixphere AB
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _BMP085_H
+#define _BMP085_H
+
+#define BMP085_NAME "bmp085"
+
+/**
+ * struct bmp085_platform_data - represents platform data for the bmp085 driver
+ * @chip_id: Configurable chip id for non-default chip revisions
+ * @default_oversampling: Default oversampling value to be used at startup,
+ * value range is 0-3 with rising sensitivity.
+ * @temp_measurement_period: Temperature measurement period (milliseconds), set
+ * to zero if unsure.
+ * @init_hw: Callback for hw specific startup
+ * @deinit_hw: Callback for hw specific shutdown
+ */
+struct bmp085_platform_data {
+	u8	chip_id;
+	u8	default_oversampling;
+	u32	temp_measurement_period;
+	int	(*init_hw)(struct device *dev);
+	void	(*deinit_hw)(struct device *dev);
+};
+
+#endif
-- 
1.7.3.4

