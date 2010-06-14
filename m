Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0FNOTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:19:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab0FNOTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:19:05 -0400
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Jun 2010 19:49:00 +0530
Subject: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
Thread-Topic: [RFC] [PATCH] Adding support for BMP085 pressure sensor.
Thread-Index: AcsLx9ajrMUfmYL5Rf6bj45lmUHl3QAABVVg
Message-ID: <0680EC522D0CC943BC586913CF3768C003B34A6178@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding support for BMP085 pressure sensor.
The interface of the device is I2C.
The driver is based on a version initially written by Christoph
Mair.


Signed-off-by: Shubhrajyoti Datta <shubhrajyoti@ti.com>
---
 drivers/misc/bmp085.c |  342 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 342 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/bmp085.c

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
new file mode 100644
index 0000000..73edf1b
--- /dev/null
+++ b/drivers/misc/bmp085.c
@@ -0,0 +1,342 @@
+/*  Copyright (c) 2009  Christoph Mair <christoph.mair@gmail.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+
+#define BMP085_I2C_ADDRESS		0x77
+#define BMP085_CALIBRATION_DATA_START	0xAA
+#define BMP085_CALIBRATION_DATA_LENGTH	22
+#define BMP085_CHIP_ID_REG		0xD0
+#define BMP085_VERSION_REG		0xD1
+#define BMP085_CHIP_ID			0x55
+#define BMP085_CTRL_REG			0xF4
+#define BMP085_TEMP_REG			0x2E
+#define BMP085_PRESSURE_OSRS0		0x34
+#define BMP085_MSB 			0xF6
+#define BMP085_LSB 			0xF7
+#define BMP085_XLSB 			0xF8
+#define BMP085_TEMP_CONV_TIME		5
+
+struct bmp085_calibration_data {
+	s16 AC1, AC2, AC3;
+	u16 AC4, AC5, AC6;
+	s16 B1, B2;
+	s16 MB, MC, MD;
+};
+
+/* Each client has this additional data */
+struct bmp085_data {
+	struct i2c_client *client;
+	struct mutex lock;
+	struct bmp085_calibration_data calibration;
+	unsigned char oversampling_setting;
+	s32 b6; /* calculated temperature correction coefficient */
+};
+
+static void bmp085_init_client(struct i2c_client *client);
+
+static s32 bmp085_get_calibration_data(struct i2c_client *client)
+{
+	u8 tmp[BMP085_CALIBRATION_DATA_LENGTH];
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_calibration_data *cali = &(data->calibration);
+	s32 status = i2c_smbus_read_i2c_block_data(client,
+				BMP085_CALIBRATION_DATA_START,
+				BMP085_CALIBRATION_DATA_LENGTH, tmp);
+
+	cali->AC1 =  (tmp[0] << 8) | tmp[1];
+	cali->AC2 =  (tmp[2] << 8) | tmp[3];
+	cali->AC3 =  (tmp[4] << 8) | tmp[5];
+	cali->AC4 =  (tmp[6] << 8) | tmp[7];
+	cali->AC5 =  (tmp[8] << 8) | tmp[9];
+	cali->AC6 = (tmp[10] << 8) | tmp[11];
+
+	/*parameters B1,B2*/
+	cali->B1 =  (tmp[12] << 8) | tmp[13];
+	cali->B2 =  (tmp[14] << 8) | tmp[15];
+
+	/*parameters MB,MC,MD*/
+	cali->MB =  (tmp[16] << 8) | tmp[17];
+	cali->MC =  (tmp[18] << 8) | tmp[19];
+	cali->MD =  (tmp[20] << 8) | tmp[21];
+	return status;
+}
+
+static s32 bmp085_get_temperature(struct i2c_client *client)
+{
+	u16 temperature = 0x00;
+	u8 tmp[2];
+	s32 status = i2c_smbus_write_byte_data(client, BMP085_CTRL_REG,
+						BMP085_TEMP_REG);
+	if (status != 0) {
+		dev_err(&client->dev, "bmp085: Error requesting\
+				temperature measurement.\n");
+		return status;
+	}
+	msleep(BMP085_TEMP_CONV_TIME);
+
+	i2c_smbus_read_i2c_block_data(client, BMP085_MSB, 2, tmp);
+	/* next temperature measurement is needed in one second */
+	temperature = (tmp[0] << 8) + tmp[1];
+	pr_info("temperature: %u\n", temperature);
+	return temperature;
+}
+
+static s32 bmp085_read_pressure(struct i2c_client *client, u32 *pressure)
+{
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	u8 tmp[3];
+	s32 status;
+
+	status = i2c_smbus_write_byte_data(client, BMP085_CTRL_REG,
+		BMP085_PRESSURE_OSRS0 + (data->oversampling_setting<<6));
+	if (status != 0)
+		return status;
+
+	/* wait for the end of conversion */
+	msleep(2+(3 << data->oversampling_setting));
+
+	status = i2c_smbus_read_i2c_block_data(client, BMP085_MSB, 0x03, tmp);
+	/* swap positions to correct the MSB/LSB positions*/
+	*pressure = (tmp[0] << 16) | (tmp[1] << 8) | tmp[2];
+	*pressure = *pressure >> (8-data->oversampling_setting);
+	return status;
+}
+
+/* sysfs callbacks */
+/*
+* From the Datasheet
+* Oversampling  (osrs)
+* Measurement		| Control register	| conversion time[ms]
+* Pressure (osrs 0 ) 	|0x34			|4.5
+* Pressure (osrs 0 ) 	|0x74			|7.5
+* Pressure (osrs 0 ) 	|0xB4			|13.5
+* Pressure (osrs 0 ) 	|0xF4			|25.5
+*/
+static ssize_t set_oversampling(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	data->oversampling_setting = simple_strtoul(buf, NULL, 10);
+	if (data->oversampling_setting > 3)
+		data->oversampling_setting = 3;
+	return count;
+}
+
+static ssize_t show_oversampling(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	return sprintf(buf, "%u\n", data->oversampling_setting);
+}
+static DEVICE_ATTR(oversampling, S_IWUSR | S_IRUGO,
+	show_oversampling, set_oversampling);
+
+static void bmp085_read_temperature(struct i2c_client *client,  s32 *buf)
+{
+	s32 raw_temp, x1 , x2;
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_calibration_data *cali = &data->calibration;
+
+	raw_temp = bmp085_get_temperature(client);
+	x1 = ((raw_temp - cali->AC6) * cali->AC5) >> 15;
+	x2 = (cali->MC << 11) / (x1 + cali->MD);
+	data->b6 = x1 + x2 - 4000;
+	*buf = ((x1+x2+8) >> 4) ;
+}
+
+static int bmp085_read_sensor(struct bmp085_data *bmp085,
+					s32 *pressure,
+					s32 *temp)
+{
+
+	struct i2c_client *client = bmp085->client;
+	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_calibration_data *cali = &data->calibration;
+	s32 x1, x2, x3, b3;
+	u32 b4, b7;
+	s32 p;
+	unsigned int raw_pressure = 0;
+	s32 raw_temp;
+
+	bmp085_read_temperature(client,  &raw_temp);
+	*temp = raw_temp ;
+	bmp085_read_pressure(client, &raw_pressure);
+
+	x1 = (data->b6 * data->b6) >> 12;
+	x1 *= cali->B2;
+	x1 >>= 11;
+
+	x2 = cali->AC2 * data->b6;
+	x2 >>= 11;
+
+	x3 = x1 + x2;
+
+	b3 = (((((s32)cali->AC1) * 4 + x3) <<
+				data->oversampling_setting) + 2) >> 2;
+
+	x1 = (cali->AC3 * data->b6) >> 13;
+	x2 = (cali->B1 * ((data->b6 * data->b6) >> 12)) >> 16;
+	x3 = (x1 + x2 + 2) >> 2;
+	b4 = (cali->AC4 * (u32)(x3 + 32768)) >> 15;
+
+	b7 = ((u32)raw_pressure - b3) *
+				(50000 >> data->oversampling_setting);
+	p = ((b7 < 0x80000000) ? ((b7 << 1) / b4) : ((b7 / b4) * 2));
+
+	x1 = p >> 8;
+	x1 *= x1;
+	x1 = (x1 * 3038) >> 16;
+	x2 = (-7357 * p) >> 16;
+	p += (x1 + x2 + 3791) >> 4;
+	*pressure = p;
+	return 0;
+}
+static ssize_t show_temperature(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	return sprintf(buf, "%d\n", bmp085_get_temperature(client));
+}
+static DEVICE_ATTR(temp0_input, S_IRUGO, show_temperature, NULL);
+
+static ssize_t show_pressure(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bmp085_data *bmp085 = i2c_get_clientdata(client);
+	s32 pressure_read, temperature;
+
+	bmp085_read_sensor(bmp085, &pressure_read, &temperature);
+
+	return sprintf(buf, "%d\n", pressure_read);
+}
+static DEVICE_ATTR(pressure0_input, S_IRUGO, show_pressure, NULL);
+
+static struct attribute *bmp085_attributes[] = {
+	&dev_attr_oversampling.attr,
+	&dev_attr_pressure0_input.attr,
+	&dev_attr_temp0_input.attr,
+	NULL
+};
+
+static const struct attribute_group bmp085_attr_group = {
+	.attrs = bmp085_attributes,
+};
+
+static int bmp085_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct bmp085_data *bmp085_data;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_dbg(&client->dev, "adapter doesn't support I2C\n");
+		return -ENODEV;
+	}
+
+	bmp085_data = kzalloc(sizeof(struct bmp085_data), GFP_KERNEL);
+	if (!bmp085_data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	bmp085_data->client = client;
+
+	/* default settings after POR */
+	bmp085_data->oversampling_setting = 0x00;
+
+	i2c_set_clientdata(client, bmp085_data);
+
+	/* Initialize the BMP085 chip */
+	bmp085_init_client(client);
+
+	/* Register sysfs hooks */
+	err = sysfs_create_group(&client->dev.kobj, &bmp085_attr_group);
+	if (err)
+		dev_err(&client->dev,
+			"failed to create sysfs entries\n");
+
+	return 0;
+
+exit:
+	return err;
+}
+
+static int bmp085_remove(struct i2c_client *client)
+{
+	struct bmp085_data *bmp085 = i2c_get_clientdata(client);
+
+	pr_info("bmp085 remove\n");
+	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
+	kfree(bmp085);
+	return 0;
+}
+
+static void bmp085_init_client(struct i2c_client *client)
+{
+	u8 version;
+	struct bmp085_data *data = i2c_get_clientdata(client);
+
+	bmp085_get_calibration_data(client);
+	version = i2c_smbus_read_byte_data(client, BMP085_VERSION_REG);
+	data->oversampling_setting = 3;
+	mutex_init(&data->lock);
+	pr_info("BMP085 ver. %d.%d initialized\n",
+			(version & 0x0F), (version & 0xF0) >> 4);
+}
+
+static const struct i2c_device_id bmp085_id[] = {
+	{ "bmp085", 0 },
+	{ }
+};
+
+static struct i2c_driver bmp085_driver = {
+	.driver = {
+		.name	= "bmp085",
+		.owner = THIS_MODULE,
+	},
+	.probe		= bmp085_probe,
+	.remove		= bmp085_remove,
+	.id_table	= bmp085_id,
+};
+
+static int __init bmp085_init(void)
+{
+	return i2c_add_driver(&bmp085_driver);
+}
+
+static void __exit bmp085_exit(void)
+{
+	i2c_del_driver(&bmp085_driver);
+}
+
+MODULE_AUTHOR("Christoph Mair, Shubhrajyoti");
+MODULE_DESCRIPTION("BMP085 driver");
+MODULE_LICENSE("GPL");
+
+module_init(bmp085_init);
+module_exit(bmp085_exit);
+
+
-- 
1.5.4.7

