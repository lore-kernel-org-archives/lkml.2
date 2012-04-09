Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2DIUPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:15:37 -0400
Received: from csmtp3.one.com ([91.198.169.23]:58579 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab2DIUPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:15:31 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com,
        christoph.mair@gmail.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv5 3/3] misc: add support for bmp18x chips to the bmp085 driver
Date: Mon,  9 Apr 2012 22:16:17 +0200
Message-Id: <1334002577-7786-4-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
References: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bmp18x chip family comes in an I2C respectively SPI variant.
Hence, the bmp085 driver was split to support both buses.

Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/misc/Kconfig      |   26 ++++++-
 drivers/misc/Makefile     |    2 +
 drivers/misc/bmp085-i2c.c |   91 +++++++++++++++++++++++++
 drivers/misc/bmp085-spi.c |   91 +++++++++++++++++++++++++
 drivers/misc/bmp085.c     |  163 ++++++++++++++++++--------------------------
 drivers/misc/bmp085.h     |   33 +++++++++
 6 files changed, 306 insertions(+), 100 deletions(-)
 create mode 100644 drivers/misc/bmp085-i2c.c
 create mode 100644 drivers/misc/bmp085-spi.c
 create mode 100644 drivers/misc/bmp085.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..9684695 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -452,14 +452,32 @@ config ARM_CHARLCD
 	  still useful.
 
 config BMP085
-	tristate "BMP085 digital pressure sensor"
+	bool
+	depends on SYSFS
+
+config BMP085_I2C
+	tristate "BMP085 digital pressure sensor on I2C"
+	select BMP085
+	select REGMAP_I2C
 	depends on I2C && SYSFS
 	help
-	  If you say yes here you get support for the Bosch Sensortec
-	  BMP085 digital pressure sensor.
+	  Say Y here if you want to support Bosch Sensortec's digital pressure
+	  sensor hooked to an I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bmp085-i2c.
+
+config BMP085_SPI
+	tristate "BMP085 digital pressure sensor on SPI"
+	select BMP085
+	select REGMAP_SPI
+	depends on SPI_MASTER && SYSFS
+	help
+	  Say Y here if you want to support Bosch Sensortec's digital pressure
+	  sensor hooked to an SPI bus.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called bmp085.
+	  module will be called bmp085-spi.
 
 config PCH_PHUB
 	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) PHUB"
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
index 0000000..9943971
--- /dev/null
+++ b/drivers/misc/bmp085-i2c.c
@@ -0,0 +1,91 @@
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
+#include <linux/err.h>
+#include "bmp085.h"
+
+#define BMP085_I2C_ADDRESS	0x77
+
+static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
+							I2C_CLIENT_END };
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
+	int err;
+	struct regmap *regmap = devm_regmap_init_i2c(client,
+						     &bmp085_regmap_config);
+
+	if (IS_ERR(regmap)) {
+		err = PTR_ERR(regmap);
+		dev_err(&client->dev, "Failed to init regmap: %d\n", err);
+		return err;
+	}
+
+	return bmp085_probe(&client->dev, regmap);
+}
+
+static int bmp085_i2c_remove(struct i2c_client *client)
+{
+	return bmp085_remove(&client->dev);
+}
+
+static const struct of_device_id bmp085_of_match[] = {
+	{ .compatible = "bosch,bmp085", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, bmp085_of_match);
+
+static const struct i2c_device_id bmp085_id[] = {
+	{ BMP085_NAME, 0 },
+	{ "bmp180", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
+
+static struct i2c_driver bmp085_i2c_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= BMP085_NAME,
+		.of_match_table = bmp085_of_match
+	},
+	.id_table	= bmp085_id,
+	.probe		= bmp085_i2c_probe,
+	.remove		= __devexit_p(bmp085_i2c_remove),
+
+	.detect		= bmp085_i2c_detect,
+	.address_list	= normal_i2c
+};
+
+module_i2c_driver(bmp085_i2c_driver);
+
+MODULE_AUTHOR("Eric Andersson <eric.andersson@unixphere.com>");
+MODULE_DESCRIPTION("BMP085 I2C bus driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/bmp085-spi.c b/drivers/misc/bmp085-spi.c
new file mode 100644
index 0000000..78aaff9
--- /dev/null
+++ b/drivers/misc/bmp085-spi.c
@@ -0,0 +1,91 @@
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
+#include <linux/err.h>
+#include "bmp085.h"
+
+static int __devinit bmp085_spi_probe(struct spi_device *client)
+{
+	int err;
+	struct regmap *regmap;
+
+	client->bits_per_word = 8;
+	err = spi_setup(client);
+	if (err < 0) {
+		dev_err(&client->dev, "spi_setup failed!\n");
+		return err;
+	}
+
+	regmap = devm_regmap_init_spi(client, &bmp085_regmap_config);
+	if (IS_ERR(regmap)) {
+		err = PTR_ERR(regmap);
+		dev_err(&client->dev, "Failed to init regmap: %d\n", err);
+		return err;
+	}
+
+	return bmp085_probe(&client->dev, regmap);
+}
+
+static int bmp085_spi_remove(struct spi_device *client)
+{
+	return bmp085_remove(&client->dev);
+}
+
+static const struct of_device_id bmp085_of_match[] = {
+	{ .compatible = "bosch,bmp085", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, bmp085_of_match);
+
+static const struct spi_device_id bmp085_id[] = {
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
+		.of_match_table = bmp085_of_match
+	},
+	.id_table	= bmp085_id,
+	.probe		= bmp085_spi_probe,
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
index 6adde9e..62e4182 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -2,10 +2,11 @@
  *  Copyright (c) 2012  Bosch Sensortec GmbH
  *  Copyright (c) 2012  Unixphere AB
  *
- *  This driver supports the bmp085 digital barometric pressure
- *  and temperature sensor from Bosch Sensortec. The datasheet
- *  is available from their website:
+ *  This driver supports the bmp085 and bmp18x digital barometric pressure
+ *  and temperature sensors from Bosch Sensortec. The datasheets
+ *  are available from their website:
  *  http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
+ *  http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP180-DS000-07.pdf
  *
  *  A pressure measurement is issued by reading from pressure0_input.
  *  The return value ranges from 30000 to 110000 pascal with a resulution
@@ -47,15 +48,12 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/init.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/of.h>
+#include "bmp085.h"
 
-#define BMP085_NAME			"bmp085"
-#define BMP085_I2C_ADDRESS		0x77
 #define BMP085_CHIP_ID			0x55
-
 #define BMP085_CALIBRATION_DATA_START	0xAA
 #define BMP085_CALIBRATION_DATA_LENGTH	11	/* 16 bit values */
 #define BMP085_CHIP_ID_REG		0xD0
@@ -67,9 +65,6 @@
 #define BMP085_CONVERSION_REGISTER_XLSB	0xF8
 #define BMP085_TEMP_CONVERSION_TIME	5
 
-static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
-							I2C_CLIENT_END };
-
 struct bmp085_calibration_data {
 	s16 AC1, AC2, AC3;
 	u16 AC4, AC5, AC6;
@@ -78,7 +73,8 @@ struct bmp085_calibration_data {
 };
 
 struct bmp085_data {
-	struct	i2c_client *client;
+	struct	device *dev;
+	struct  regmap *regmap;
 	struct	mutex lock;
 	struct	bmp085_calibration_data calibration;
 	u8	oversampling_setting;
@@ -90,21 +86,16 @@ struct bmp085_data {
 	s32	b6; /* calculated temperature correction coefficient */
 };
 
-static s32 bmp085_read_calibration_data(struct i2c_client *client)
+static s32 bmp085_read_calibration_data(struct bmp085_data *data)
 {
 	u16 tmp[BMP085_CALIBRATION_DATA_LENGTH];
-	struct bmp085_data *data = i2c_get_clientdata(client);
 	struct bmp085_calibration_data *cali = &(data->calibration);
-	s32 status = i2c_smbus_read_i2c_block_data(client,
-				BMP085_CALIBRATION_DATA_START,
-				(BMP085_CALIBRATION_DATA_LENGTH << 1),
-				(u8 *)tmp);
+	s32 status = regmap_bulk_read(data->regmap,
+				BMP085_CALIBRATION_DATA_START, (u8 *)tmp,
+				(BMP085_CALIBRATION_DATA_LENGTH << 1));
 	if (status < 0)
 		return status;
 
-	if (status != (BMP085_CALIBRATION_DATA_LENGTH << 1))
-		return -EIO;
-
 	cali->AC1 =  be16_to_cpu(tmp[0]);
 	cali->AC2 =  be16_to_cpu(tmp[1]);
 	cali->AC3 =  be16_to_cpu(tmp[2]);
@@ -125,23 +116,20 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
-	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
-						BMP085_TEMP_MEASUREMENT);
+	status = regmap_write(data->regmap, BMP085_CTRL_REG,
+			      BMP085_TEMP_MEASUREMENT);
 	if (status < 0) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while requesting temperature measurement.\n");
 		goto exit;
 	}
 	msleep(BMP085_TEMP_CONVERSION_TIME);
 
-	status = i2c_smbus_read_i2c_block_data(data->client,
-		BMP085_CONVERSION_REGISTER_MSB, sizeof(tmp), (u8 *)&tmp);
-	if (status < 0)
-		goto exit;
-	if (status != sizeof(tmp)) {
-		dev_err(&data->client->dev,
+	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
+				 &tmp, sizeof(tmp));
+	if (status < 0) {
+		dev_err(data->dev,
 			"Error while reading temperature measurement result\n");
-		status = -EIO;
 		goto exit;
 	}
 	data->raw_temperature = be16_to_cpu(tmp);
@@ -159,11 +147,11 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	s32 status;
 
 	mutex_lock(&data->lock);
-	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
+	status = regmap_write(data->regmap, BMP085_CTRL_REG,
 			BMP085_PRESSURE_MEASUREMENT +
 			(data->oversampling_setting << 6));
 	if (status < 0) {
-		dev_err(&data->client->dev,
+		dev_err(data->dev,
 			"Error while requesting pressure measurement.\n");
 		goto exit;
 	}
@@ -172,14 +160,11 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	msleep(2+(3 << data->oversampling_setting));
 
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
-	status = i2c_smbus_read_i2c_block_data(data->client,
-			BMP085_CONVERSION_REGISTER_MSB, 3, ((u8 *)&tmp)+1);
-	if (status < 0)
-		goto exit;
-	if (status != 3) {
-		dev_err(&data->client->dev,
+	status = regmap_bulk_read(data->regmap, BMP085_CONVERSION_REGISTER_MSB,
+				 ((u8 *)&tmp)+1, 3);
+	if (status < 0) {
+		dev_err(data->dev,
 			"Error while reading pressure measurement results\n");
-		status = -EIO;
 		goto exit;
 	}
 	data->raw_pressure = be32_to_cpu((tmp));
@@ -304,8 +289,7 @@ static ssize_t set_oversampling(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 	unsigned long oversampling;
 	int err = kstrtoul(buf, 10, &oversampling);
 
@@ -322,8 +306,7 @@ static ssize_t set_oversampling(struct device *dev,
 static ssize_t show_oversampling(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", bmp085_get_oversampling(data));
 }
@@ -336,8 +319,7 @@ static ssize_t show_temperature(struct device *dev,
 {
 	int temperature;
 	int status;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	status = bmp085_get_temperature(data, &temperature);
 	if (status < 0)
@@ -353,8 +335,7 @@ static ssize_t show_pressure(struct device *dev,
 {
 	int pressure;
 	int status;
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
 	status = bmp085_get_pressure(data, &pressure);
 	if (status < 0)
@@ -376,22 +357,27 @@ static const struct attribute_group bmp085_attr_group = {
 	.attrs = bmp085_attributes,
 };
 
-static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
+int bmp085_detect(struct device *dev)
 {
-	if (client->addr != BMP085_I2C_ADDRESS)
-		return -ENODEV;
+	struct bmp085_data *data = dev_get_drvdata(dev);
+	unsigned int id;
+	int ret;
+
+	ret = regmap_read(data->regmap, BMP085_CHIP_ID_REG, &id);
+	if (ret < 0)
+		return ret;
 
-	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != BMP085_CHIP_ID)
+	if (id != data->chip_id)
 		return -ENODEV;
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bmp085_detect);
 
-static void __init bmp085_get_of_properties(struct i2c_client *client,
-					    struct bmp085_data *data)
+static void __init bmp085_get_of_properties(struct bmp085_data *data)
 {
 #ifdef CONFIG_OF
-	struct device_node *np = client->dev.of_node;
+	struct device_node *np = data->dev->of_node;
 	u32 prop;
 
 	if (!np)
@@ -408,30 +394,33 @@ static void __init bmp085_get_of_properties(struct i2c_client *client,
 #endif
 }
 
-static int bmp085_init_client(struct i2c_client *client)
+static int bmp085_init_client(struct bmp085_data *data)
 {
-	struct bmp085_data *data = i2c_get_clientdata(client);
-	int status = bmp085_read_calibration_data(client);
+	int status = bmp085_read_calibration_data(data);
 
 	if (status < 0)
 		return status;
 
 	/* default settings */
-	data->client = client;
 	data->chip_id = BMP085_CHIP_ID;
 	data->last_temp_measurement = 0;
 	data->temp_measurement_period = 1*HZ;
 	data->oversampling_setting = 3;
 
-	bmp085_get_of_properties(client, data);
+	bmp085_get_of_properties(data);
 
 	mutex_init(&data->lock);
 
 	return 0;
 }
 
-static int __devinit bmp085_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+struct regmap_config bmp085_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8
+};
+EXPORT_SYMBOL_GPL(bmp085_regmap_config);
+
+__devinit int bmp085_probe(struct device *dev, struct regmap *regmap)
 {
 	struct bmp085_data *data;
 	int err = 0;
@@ -442,19 +431,27 @@ static int __devinit bmp085_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	i2c_set_clientdata(client, data);
+	dev_set_drvdata(dev, data);
+	data->dev = dev;
+	data->regmap = regmap;
 
 	/* Initialize the BMP085 chip */
-	err = bmp085_init_client(client);
+	err = bmp085_init_client(data);
 	if (err < 0)
 		goto exit_free;
 
+	err = bmp085_detect(dev);
+	if (err < 0) {
+		dev_err(dev, "%s: chip_id failed!\n", BMP085_NAME);
+		goto exit_free;
+	}
+
 	/* Register sysfs hooks */
-	err = sysfs_create_group(&client->dev.kobj, &bmp085_attr_group);
+	err = sysfs_create_group(&dev->kobj, &bmp085_attr_group);
 	if (err)
 		goto exit_free;
 
-	dev_info(&client->dev, "Successfully initialized %s!\n", BMP085_NAME);
+	dev_info(dev, "Successfully initialized %s!\n", BMP085_NAME);
 
 	return 0;
 
@@ -463,44 +460,18 @@ exit_free:
 exit:
 	return err;
 }
+EXPORT_SYMBOL_GPL(bmp085_probe);
 
-static int __devexit bmp085_remove(struct i2c_client *client)
+int bmp085_remove(struct device *dev)
 {
-	struct bmp085_data *data = i2c_get_clientdata(client);
+	struct bmp085_data *data = dev_get_drvdata(dev);
 
-	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
+	sysfs_remove_group(&data->dev->kobj, &bmp085_attr_group);
 	kfree(data);
 
 	return 0;
 }
-
-static const struct of_device_id bmp085_of_match[] = {
-	{ .compatible = "bosch,bmp085", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, bmp085_of_match);
-
-static const struct i2c_device_id bmp085_id[] = {
-	{ BMP085_NAME, 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, bmp085_id);
-
-static struct i2c_driver bmp085_driver = {
-	.driver = {
-		.owner = THIS_MODULE,
-		.name	= BMP085_NAME,
-		.of_match_table = bmp085_of_match
-	},
-	.id_table	= bmp085_id,
-	.probe		= bmp085_probe,
-	.remove		= __devexit_p(bmp085_remove),
-
-	.detect		= bmp085_detect,
-	.address_list	= normal_i2c
-};
-
-module_i2c_driver(bmp085_driver);
+EXPORT_SYMBOL_GPL(bmp085_remove);
 
 MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com>");
 MODULE_DESCRIPTION("BMP085 driver");
diff --git a/drivers/misc/bmp085.h b/drivers/misc/bmp085.h
new file mode 100644
index 0000000..2b8f615
--- /dev/null
+++ b/drivers/misc/bmp085.h
@@ -0,0 +1,33 @@
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
+#include <linux/regmap.h>
+
+#define BMP085_NAME		"bmp085"
+
+extern struct regmap_config bmp085_regmap_config;
+
+int bmp085_probe(struct device *dev, struct regmap *regmap);
+int bmp085_remove(struct device *dev);
+int bmp085_detect(struct device *dev);
+
+#endif
-- 
1.7.3.4

