Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031326Ab2CFVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:06:55 -0500
Received: from csmtp2.one.com ([91.198.169.22]:14002 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031076Ab2CFVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:06:52 -0500
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv2 2/3] misc: add support for bmp18x chips to the bmp085 driver
Date: Tue,  6 Mar 2012 22:08:03 +0100
Message-Id: <1331068084-17911-3-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bmp18x chip family comes in an I2C respectively SPI variant.
Hence, the bmp085 driver was split to support both buses.

Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/misc/Kconfig       |   26 ++++++-
 drivers/misc/Makefile      |    2 +
 drivers/misc/bmp085-i2c.c  |  132 ++++++++++++++++++++++++++++++++++
 drivers/misc/bmp085-spi.c  |  140 +++++++++++++++++++++++++++++++++++++
 drivers/misc/bmp085.c      |  167 +++++++++++++++++++-------------------------
 include/linux/i2c/bmp085.h |   22 ++++++-
 6 files changed, 391 insertions(+), 98 deletions(-)
 create mode 100644 drivers/misc/bmp085-i2c.c
 create mode 100644 drivers/misc/bmp085-spi.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..9bf65c3 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -453,14 +453,34 @@ config ARM_CHARLCD
 
 config BMP085
 	tristate "BMP085 digital pressure sensor"
-	depends on I2C && SYSFS
+	depends on (I2C || SPI_MASTER) && SYSFS
 	help
-	  If you say yes here you get support for the Bosch Sensortec
-	  BMP085 digital pressure sensor.
+	  Say Y here if you want support for Bosch Sensortec's digital
+	  pressure sensors BMP085 and BMP18x.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config BMP085_I2C
+	tristate "support I2C bus connection"
+	depends on BMP085 && I2C
+	help
+	  Say Y here if you want to support Bosch Sensortec's digital pressure
+	  sensor hooked to an I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bmp085-i2c.
+
+config BMP085_SPI
+	tristate "support SPI bus connection"
+	depends on BMP085 && SPI_MASTER
+	help
+	  Say Y here if you want to support Bosch Sensortec's digital pressure
+	  sensor hooked to an SPI bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bmp085-spi.
+
 config PCH_PHUB
 	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) PHUB"
 	depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3e1d801..509d056 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_BMP085)		+= bmp085.o
+obj-$(CONFIG_BMP085_I2C)	+= bmp085-i2c.o
+obj-$(CONFIG_BMP085_SPI)	+= bmp085-spi.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff --git a/drivers/misc/bmp085-i2c.c b/drivers/misc/bmp085-i2c.c
new file mode 100644
index 0000000..1e8eabf
--- /dev/null
+++ b/drivers/misc/bmp085-i2c.c
@@ -0,0 +1,132 @@
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
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/i2c/bmp085.h>
+
+static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
+							I2C_CLIENT_END };
+
+static int bmp085_i2c_read_block(void *client, u8 reg, int len, char *buf)
+{
+	return i2c_smbus_read_i2c_block_data(client, reg, len, buf);
+}
+
+static int bmp085_i2c_read_byte(void *client, u8 reg)
+{
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int bmp085_i2c_write_byte(void *client, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static const struct bmp085_bus_ops bmp085_i2c_bus_ops = {
+	.read_block	= bmp085_i2c_read_block,
+	.read_byte	= bmp085_i2c_read_byte,
+	.write_byte	= bmp085_i2c_write_byte
+};
+
+static int bmp085_i2c_detect(struct i2c_client *client,
+			     struct i2c_board_info *info)
+{
+	if (client->addr != BMP085_I2C_ADDRESS)
+		return -ENODEV;
+
+	return bmp085_detect(&client->dev);
+}
+
+static int __devinit bmp085_i2c_probe(struct i2c_client *client,
+				      const struct i2c_device_id *id)
+{
+	struct bmp085_data_bus data_bus = {
+		.bops = &bmp085_i2c_bus_ops,
+		.client = client
+	};
+
+	return bmp085_probe(&client->dev, &data_bus);
+}
+
+static void bmp085_i2c_shutdown(struct i2c_client *client)
+{
+	bmp085_disable(&client->dev);
+}
+
+static int bmp085_i2c_remove(struct i2c_client *client)
+{
+	return bmp085_remove(&client->dev);
+}
+
+#ifdef CONFIG_PM
+static int bmp085_i2c_suspend(struct device *dev)
+{
+	return bmp085_disable(dev);
+}
+
+static int bmp085_i2c_resume(struct device *dev)
+{
+	return bmp085_enable(dev);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(bmp085_i2c_pm_ops, bmp085_i2c_suspend,
+			 bmp085_i2c_resume);
+
+static const struct i2c_device_id bmp085_id[] = {
+	{ BMP085_NAME, 0 },
+	{ "bmp085", 0 },
+	{ "bmp180", 0 },
+	{ "bmp181", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
+
+static struct i2c_driver bmp085_i2c_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= BMP085_NAME,
+		.pm	= &bmp085_i2c_pm_ops,
+	},
+	.id_table	= bmp085_id,
+	.probe		= bmp085_i2c_probe,
+	.shutdown	= bmp085_i2c_shutdown,
+	.remove		= __devexit_p(bmp085_i2c_remove),
+
+	.detect		= bmp085_i2c_detect,
+	.address_list	= normal_i2c
+};
+
+static int __init bmp085_i2c_init(void)
+{
+	return i2c_add_driver(&bmp085_i2c_driver);
+}
+
+static void __exit bmp085_i2c_exit(void)
+{
+	i2c_del_driver(&bmp085_i2c_driver);
+}
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP085 I2C bus driver");
+MODULE_LICENSE("GPL");
+
+module_init(bmp085_i2c_init);
+module_exit(bmp085_i2c_exit);
diff --git a/drivers/misc/bmp085-spi.c b/drivers/misc/bmp085-spi.c
new file mode 100644
index 0000000..a4772ac
--- /dev/null
+++ b/drivers/misc/bmp085-spi.c
@@ -0,0 +1,140 @@
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
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c/bmp085.h>
+
+static int bmp085_spi_write_byte(void *client, u8 reg, u8 value)
+{
+	u8 data[2] = { reg, value };
+	return spi_write(client, data, 2);
+}
+
+static int bmp085_spi_read_block(void *client, u8 reg, int len, char *buf)
+{
+	int err = bmp085_spi_write_byte(client, reg, 0);
+
+	if (err < 0)
+		return err;
+
+	return spi_read(client, buf, len);
+}
+
+static int bmp085_spi_read_byte(void *client, u8 reg)
+{
+	u8 data;
+	int err = bmp085_spi_write_byte(client, reg, 0);
+
+	if (err < 0)
+		return err;
+
+	err = spi_read(client, &data, 1);
+	if (err < 0)
+		return err;
+
+	return data;
+}
+
+static const struct bmp085_bus_ops bmp085_spi_bus_ops = {
+	.read_block	= bmp085_spi_read_block,
+	.read_byte	= bmp085_spi_read_byte,
+	.write_byte	= bmp085_spi_write_byte
+};
+
+static int __devinit bmp085_spi_probe(struct spi_device *client)
+{
+	int err;
+	struct bmp085_data_bus data_bus = {
+		.bops = &bmp085_spi_bus_ops,
+		.client = client
+	};
+
+	client->bits_per_word = 8;
+	err = spi_setup(client);
+	if (err < 0) {
+		dev_err(&client->dev, "spi_setup failed!\n");
+		return err;
+	}
+
+	return bmp085_probe(&client->dev, &data_bus);
+}
+
+static void bmp085_spi_shutdown(struct spi_device *client)
+{
+	bmp085_disable(&client->dev);
+}
+
+static int bmp085_spi_remove(struct spi_device *client)
+{
+	return bmp085_remove(&client->dev);
+}
+
+#ifdef CONFIG_PM
+static int bmp085_spi_suspend(struct device *dev)
+{
+	return bmp085_disable(dev);
+}
+
+static int bmp085_spi_resume(struct device *dev)
+{
+	return bmp085_enable(dev);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(bmp085_spi_pm_ops, bmp085_spi_suspend,
+					    bmp085_spi_resume);
+
+static const struct spi_device_id bmp085_id[] = {
+	{ BMP085_NAME, 0 },
+	{ "bmp085", 0 },
+	{ "bmp180", 0 },
+	{ "bmp181", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, bmp085_id);
+
+static struct spi_driver bmp085_spi_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= BMP085_NAME,
+		.pm	= &bmp085_spi_pm_ops,
+	},
+	.id_table	= bmp085_id,
+	.probe		= bmp085_spi_probe,
+	.shutdown	= bmp085_spi_shutdown,
+	.remove		= __devexit_p(bmp085_spi_remove)
+};
+
+static int __init bmp085_spi_init(void)
+{
+	return spi_register_driver(&bmp085_spi_driver);
+}
+
+static void __exit bmp085_spi_exit(void)
+{
+	spi_unregister_driver(&bmp085_spi_driver);
+}
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP085 SPI bus driver");
+MODULE_LICENSE("GPL");
+
+module_init(bmp085_spi_init);
+module_exit(bmp085_spi_exit);
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 5978094..78406d7 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -3,9 +3,10 @@
     Copyright (c) 2012  Unixphere AB
 
     This driver supports the bmp085 digital barometric pressure
-    and temperature sensor from Bosch Sensortec. The datasheet
-    is available from their website:
+    and temperature sensor from Bosch Sensortec. The datasheets
+    are available from their website:
     http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
+    http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP180-DS000-07.pdf
 
     A pressure measurement is issued by reading from pressure0_input.
     The return value ranges from 30000 to 110000 pascal with a resulution
@@ -47,12 +48,10 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/init.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c/bmp085.h>
 
-#define BMP085_I2C_ADDRESS		0x77
 #define BMP085_CHIP_ID			0x55
 
 #define BMP085_CALIBRATION_DATA_START	0xAA
@@ -66,9 +65,6 @@
 #define BMP085_CONVERSION_REGISTER_XLSB	0xF8
 #define BMP085_TEMP_CONVERSION_TIME	5
 
-static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
-							I2C_CLIENT_END };
-
 struct bmp085_calibration_data {
 	s16 AC1, AC2, AC3;
 	u16 AC4, AC5, AC6;
@@ -77,7 +73,8 @@ struct bmp085_calibration_data {
 };
 
 struct bmp085_data {
-	struct	i2c_client *client;
+	struct	bmp085_data_bus data_bus;
+	struct	device *dev;
 	struct	mutex lock;
 	struct	bmp085_calibration_data calibration;
 	u8	oversampling_setting;
@@ -88,13 +85,29 @@ struct bmp085_data {
 	s32	b6; /* calculated temperature correction coefficient */
 };
 
-static s32 bmp085_read_calibration_data(struct i2c_client *client)
+static inline int bmp085_read_block(struct bmp085_data *data, u8 reg, int len,
+				    char *buf)
+{
+	return data->data_bus.bops->read_block(data->data_bus.client, reg,
+					       len, buf);
+}
+
+static inline int bmp085_read_byte(struct bmp085_data *data, u8 reg)
+{
+	return data->data_bus.bops->read_byte(data->data_bus.client, reg);
+}
+
+static inline int bmp085_write_byte(struct bmp085_data *data, u8 reg, u8 value)
+{
+	return data->data_bus.bops->write_byte(data->data_bus.client, reg,
+					       value);
+}
+
+static s32 bmp085_read_calibration_data(struct bmp085_data *data)
 {
 	u16 tmp[BMP085_CALIBRATION_DATA_LENGTH];
-	struct bmp085_data *data = i2c_get_clientdata(client);
 	struct bmp085_calibration_data *cali = &(data->calibration);
-	s32 status = i2c_smbus_read_i2c_block_data(client,
-				BMP085_CALIBRATION_DATA_START,
+	s32 status = bmp085_read_block(data, BMP085_CALIBRATION_DATA_START,
 				(BMP085_CALIBRATION_DATA_LENGTH << 1),
 				(u8 *)tmp);
 	if (status < 0)
@@ -123,21 +136,21 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
-	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
+	status = bmp085_write_byte(data, BMP085_CTRL_REG,
 				   BMP085_TEMP_MEASUREMENT);
 	if (status < 0) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while requesting temperature measurement.\n");
 		goto exit;
 	}
 	msleep(BMP085_TEMP_CONVERSION_TIME);
 
-	status = i2c_smbus_read_i2c_block_data(data->client,
-		BMP085_CONVERSION_REGISTER_MSB, sizeof(tmp), (u8 *)&tmp);
+	status = bmp085_read_block(data, BMP085_CONVERSION_REGISTER_MSB,
+				   sizeof(tmp), (u8 *)&tmp);
 	if (status < 0)
 		goto exit;
 	if (status != sizeof(tmp)) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while reading temperature measurement result\n");
 		status = -EIO;
 		goto exit;
@@ -157,11 +170,11 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
-	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
+	status = bmp085_write_byte(data, BMP085_CTRL_REG,
 			BMP085_PRESSURE_MEASUREMENT +
 			(data->oversampling_setting << 6));
 	if (status < 0) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while requesting pressure measurement.\n");
 		goto exit;
 	}
@@ -170,12 +183,12 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	msleep(2+(3 << data->oversampling_setting));
 
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
-	status = i2c_smbus_read_i2c_block_data(data->client,
-			BMP085_CONVERSION_REGISTER_MSB, 3, ((u8 *)&tmp)+1);
+	status = bmp085_read_block(data, BMP085_CONVERSION_REGISTER_MSB, 3,
+				   ((u8 *)&tmp)+1);
 	if (status < 0)
 		goto exit;
 	if (status != 3) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while reading pressure measurement results\n");
 		status = -EIO;
 		goto exit;
@@ -302,8 +315,7 @@ static ssize_t set_oversampling(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 	unsigned long oversampling;
 	int err = kstrtoul(buf, 10, &oversampling);
 
@@ -320,8 +332,7 @@ static ssize_t set_oversampling(struct device *dev,
 static ssize_t show_oversampling(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", bmp085_get_oversampling(data));
 }
@@ -334,8 +345,7 @@ static ssize_t show_temperature(struct device *dev,
 {
 	int temperature;
 	int status;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	status = bmp085_get_temperature(data, &temperature);
 	if (status < 0)
@@ -351,8 +361,7 @@ static ssize_t show_pressure(struct device *dev,
 {
 	int pressure;
 	int status;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	status = bmp085_get_pressure(data, &pressure);
 	if (status < 0)
@@ -374,27 +383,28 @@ static const struct attribute_group bmp085_attr_group = {
 	.attrs = bmp085_attributes,
 };
 
-static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
+int bmp085_detect(struct device *dev)
 {
-	if (client->addr != BMP085_I2C_ADDRESS)
-		return -ENODEV;
+	struct bmp085_data *data = dev_get_drvdata(dev);
+	struct bmp085_platform_data *pdata = dev->platform_data;
+	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id :
+						 BMP085_CHIP_ID;
 
-	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != BMP085_CHIP_ID)
+	if (bmp085_read_byte(data, BMP085_CHIP_ID_REG) != chip_id)
 		return -ENODEV;
 
 	return 0;
 }
+EXPORT_SYMBOL(bmp085_detect);
 
-static int bmp085_init_client(struct i2c_client *client)
+static int bmp085_init_client(struct bmp085_data *data,
+			      struct bmp085_platform_data *pdata)
 {
-	struct bmp085_data *data = i2c_get_clientdata(client);
-	struct bmp085_platform_data *pdata = client->dev.platform_data;
-	int status = bmp085_read_calibration_data(client);
+	int status = bmp085_read_calibration_data(data);
 
 	if (status < 0)
 		return status;
 
-	data->client = client;
 	data->last_temp_measurement = 0;
 	data->temp_measurement_period =
 		pdata ? (pdata->temp_measurement_period/1000)*HZ : 1*HZ;
@@ -404,19 +414,18 @@ static int bmp085_init_client(struct i2c_client *client)
 	return 0;
 }
 
-static int __devinit bmp085_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+__devinit int bmp085_probe(struct device *dev, struct bmp085_data_bus *data_bus)
 {
 	struct bmp085_data *data;
-	struct bmp085_platform_data *pdata = client->dev.platform_data;
+	struct bmp085_platform_data *pdata = dev->platform_data;
 	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id :
 						 BMP085_CHIP_ID;
 	int err = 0;
 
 	if (pdata && pdata->init_hw) {
-		err = pdata->init_hw(&client->dev);
+		err = pdata->init_hw(dev);
 		if (err) {
-			dev_err(&client->dev, "%s: init_hw failed!\n",
+			dev_err(dev, "%s: init_hw failed!\n",
 				BMP085_NAME);
 			return err;
 		}
@@ -428,52 +437,56 @@ static int __devinit bmp085_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	i2c_set_clientdata(client, data);
+	dev_set_drvdata(dev, data);
+	data->data_bus = *data_bus;
+	data->dev = dev;
 
-	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != chip_id) {
-		dev_err(&client->dev, "%s: chip_id failed!\n", BMP085_NAME);
+	if (bmp085_read_byte(data, BMP085_CHIP_ID_REG) != chip_id) {
+		dev_err(dev, "%s: chip_id failed!\n", BMP085_NAME);
 		err = -ENODEV;
 		goto exit_free;
 	}
 
 	/* Initialize the BMP085 chip */
-	err = bmp085_init_client(client);
+	err = bmp085_init_client(data, pdata);
 	if (err < 0)
 		goto exit_free;
 
 	/* Register sysfs hooks */
-	err = sysfs_create_group(&client->dev.kobj, &bmp085_attr_group);
+	err = sysfs_create_group(&dev->kobj, &bmp085_attr_group);
 	if (err)
 		goto exit_free;
 
-	dev_info(&client->dev, "Succesfully initialized bmp085!\n");
+	dev_info(dev, "Succesfully initialized bmp085!\n");
 	return 0;
 
 exit_free:
 	kfree(data);
 exit:
 	if (pdata && pdata->deinit_hw)
-		pdata->deinit_hw(&client->dev);
+		pdata->deinit_hw(dev);
 	return err;
 }
+EXPORT_SYMBOL(bmp085_probe);
 
-static int __devexit bmp085_remove(struct i2c_client *client)
+int bmp085_remove(struct device *dev)
 {
-	struct bmp085_data *data = i2c_get_clientdata(client);
-	struct bmp085_platform_data *pdata = client->dev.platform_data;
+	struct bmp085_data *data = dev_get_drvdata(dev);
+	struct bmp085_platform_data *pdata = dev->platform_data;
 
-	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
+	sysfs_remove_group(&dev->kobj, &bmp085_attr_group);
 
 	if (pdata && pdata->deinit_hw)
-		pdata->deinit_hw(&client->dev);
+		pdata->deinit_hw(dev);
 
 	kfree(data);
 
 	return 0;
 }
+EXPORT_SYMBOL(bmp085_remove);
 
 #ifdef CONFIG_PM
-static int bmp085_suspend(struct device *dev)
+int bmp085_disable(struct device *dev)
 {
 	struct bmp085_platform_data *pdata = dev->platform_data;
 
@@ -482,8 +495,9 @@ static int bmp085_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(bmp085_disable);
 
-static int bmp085_resume(struct device *dev)
+int bmp085_enable(struct device *dev)
 {
 	struct bmp085_platform_data *pdata = dev->platform_data;
 
@@ -492,44 +506,9 @@ static int bmp085_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(bmp085_enable);
 #endif
 
-static SIMPLE_DEV_PM_OPS(bmp085_pm_ops, bmp085_suspend,
-			 bmp085_resume);
-
-static const struct i2c_device_id bmp085_id[] = {
-	{ "bmp085", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, bmp085_id);
-
-static struct i2c_driver bmp085_driver = {
-	.driver = {
-		.owner = THIS_MODULE,
-		.name	= "bmp085",
-		.pm	= &bmp085_pm_ops,
-	},
-	.id_table	= bmp085_id,
-	.probe		= bmp085_probe,
-	.remove		= __devexit_p(bmp085_remove),
-
-	.detect		= bmp085_detect,
-	.address_list	= normal_i2c
-};
-
-static int __init bmp085_init(void)
-{
-	return i2c_add_driver(&bmp085_driver);
-}
-
-static void __exit bmp085_exit(void)
-{
-	i2c_del_driver(&bmp085_driver);
-}
-
 MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com");
 MODULE_DESCRIPTION("BMP085 driver");
 MODULE_LICENSE("GPL");
-
-module_init(bmp085_init);
-module_exit(bmp085_exit);
diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
index e6fc752..ee6e398 100644
--- a/include/linux/i2c/bmp085.h
+++ b/include/linux/i2c/bmp085.h
@@ -20,7 +20,8 @@
 #ifndef _BMP085_H
 #define _BMP085_H
 
-#define BMP085_NAME "bmp085"
+#define BMP085_NAME		"bmp085"
+#define BMP085_I2C_ADDRESS	0x77
 
 /**
  * struct bmp085_platform_data - represents platform data for the bmp085 driver
@@ -40,4 +41,23 @@ struct bmp085_platform_data {
 	void	(*deinit_hw)(struct device *dev);
 };
 
+struct bmp085_bus_ops {
+	int	(*read_block)(void *client, u8 reg, int len, char *buf);
+	int	(*read_byte)(void *client, u8 reg);
+	int	(*write_byte)(void *client, u8 reg, u8 value);
+};
+
+struct bmp085_data_bus {
+	const struct bmp085_bus_ops	*bops;
+	void	*client;
+};
+
+int bmp085_probe(struct device *dev, struct bmp085_data_bus *data_bus);
+int bmp085_remove(struct device *dev);
+int bmp085_detect(struct device *dev);
+#ifdef CONFIG_PM
+int bmp085_enable(struct device *dev);
+int bmp085_disable(struct device *dev);
+#endif
+
 #endif
-- 
1.7.3.4

