Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1GACTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:19:38 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49498 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754727Ab1GACTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:36 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Date: Thu, 30 Jun 2011 19:18:27 -0700
Message-Id: <1309486707-1658-11-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/inv_mpu/Kconfig           |    1 +
 drivers/misc/inv_mpu/Makefile          |    1 +
 drivers/misc/inv_mpu/pressure/Kconfig  |   20 ++
 drivers/misc/inv_mpu/pressure/Makefile |    8 +
 drivers/misc/inv_mpu/pressure/bma085.c |  367 ++++++++++++++++++++++++++++++++
 5 files changed, 397 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/pressure/Kconfig
 create mode 100644 drivers/misc/inv_mpu/pressure/Makefile
 create mode 100644 drivers/misc/inv_mpu/pressure/bma085.c

diff --git a/drivers/misc/inv_mpu/Kconfig b/drivers/misc/inv_mpu/Kconfig
index 7d9f2c3..ea7d754 100644
--- a/drivers/misc/inv_mpu/Kconfig
+++ b/drivers/misc/inv_mpu/Kconfig
@@ -57,5 +57,6 @@ endchoice
 
 source "drivers/misc/inv_mpu/accel/Kconfig"
 source "drivers/misc/inv_mpu/compass/Kconfig"
+source "drivers/misc/inv_mpu/pressure/Kconfig"
 
 endif #INV_SENSORS
diff --git a/drivers/misc/inv_mpu/Makefile b/drivers/misc/inv_mpu/Makefile
index dc77a1b..506b8f5 100644
--- a/drivers/misc/inv_mpu/Makefile
+++ b/drivers/misc/inv_mpu/Makefile
@@ -18,3 +18,4 @@ EXTRA_CFLAGS += -Idrivers/misc/inv_mpu
 
 obj-y			+= accel/
 obj-y			+= compass/
+obj-y			+= pressure/
diff --git a/drivers/misc/inv_mpu/pressure/Kconfig b/drivers/misc/inv_mpu/pressure/Kconfig
new file mode 100644
index 0000000..f1c021e
--- /dev/null
+++ b/drivers/misc/inv_mpu/pressure/Kconfig
@@ -0,0 +1,20 @@
+menuconfig: INV_SENSORS_PRESSURE
+	bool "Pressure Sensor Slaves"
+	depends on INV_SENSORS
+	default y
+	help
+	  Select y to see a list of supported pressure sensors that can be
+	  integrated with the MPUxxxx set of motion processors.
+
+if INV_SENSORS_PRESSURE
+
+config MPU_SENSORS_BMA085
+	tristate "Bosch BMA085"
+	help
+	  This enables support for the Bosch bma085 pressure sensor
+	  This support is for integration with the MPU3050 or MPU6050 gyroscope
+          device driver.  Only one accelerometer can be registered at a time.
+	  Specifying more that one accelerometer in the board file will result
+	  in runtime errors.
+
+endif
diff --git a/drivers/misc/inv_mpu/pressure/Makefile b/drivers/misc/inv_mpu/pressure/Makefile
new file mode 100644
index 0000000..595923d
--- /dev/null
+++ b/drivers/misc/inv_mpu/pressure/Makefile
@@ -0,0 +1,8 @@
+#
+# Pressure Slaves to MPUxxxx
+#
+obj-$(CONFIG_MPU_SENSORS_BMA085) += inv_mpu_bma085.o
+inv_mpu_bma085-objs +=	bma085.o
+
+EXTRA_CFLAGS += -Idrivers/misc/inv_mpu
+EXTRA_CFLAGS += -D__C99_DESIGNATED_INITIALIZER
diff --git a/drivers/misc/inv_mpu/pressure/bma085.c b/drivers/misc/inv_mpu/pressure/bma085.c
new file mode 100644
index 0000000..696d2b6
--- /dev/null
+++ b/drivers/misc/inv_mpu/pressure/bma085.c
@@ -0,0 +1,367 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+/**
+ *  @defgroup   ACCELDL (Motion Library - Pressure Driver Layer)
+ *  @brief      Provides the interface to setup and handle a pressure
+ *              connected to the secondary I2C interface of the gyroscope.
+ *
+ *  @{
+ *      @file   bma085.c
+ *      @brief  Pressure setup and handling methods.
+ */
+
+/* ------------------ */
+/* - Include Files. - */
+/* ------------------ */
+
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include "mpu-dev.h"
+
+#include <linux/mpu.h>
+#include "mlsl.h"
+#include "log.h"
+
+/*
+ * this structure holds all device specific calibration parameters
+ */
+struct bmp085_calibration_param_t {
+	short ac1;
+	short ac2;
+	short ac3;
+	unsigned short ac4;
+	unsigned short ac5;
+	unsigned short ac6;
+	short b1;
+	short b2;
+	short mb;
+	short mc;
+	short md;
+	long param_b5;
+};
+
+struct bmp085_calibration_param_t cal_param;
+
+#define PRESSURE_BMA085_PARAM_MG      3038        /* calibration parameter */
+#define PRESSURE_BMA085_PARAM_MH     -7357        /* calibration parameter */
+#define PRESSURE_BMA085_PARAM_MI      3791        /* calibration parameter */
+
+/*********************************************
+ *    Pressure Initialization Functions
+ *********************************************/
+
+static int bma085_suspend(void *mlsl_handle,
+			  struct ext_slave_descr *slave,
+			  struct ext_slave_platform_data *pdata)
+{
+	int result = INV_SUCCESS;
+	return result;
+}
+
+#define PRESSURE_BMA085_PROM_START_ADDR  (0xAA)
+#define PRESSURE_BMA085_PROM_DATA_LEN    (22)
+#define PRESSURE_BMP085_CTRL_MEAS_REG    (0xF4)
+/* temperature measurent */
+#define PRESSURE_BMP085_T_MEAS           (0x2E)
+/* pressure measurement; oversampling_setting */
+#define PRESSURE_BMP085_P_MEAS_OSS_0     (0x34)
+#define PRESSURE_BMP085_P_MEAS_OSS_1     (0x74)
+#define PRESSURE_BMP085_P_MEAS_OSS_2     (0xB4)
+#define PRESSURE_BMP085_P_MEAS_OSS_3     (0xF4)
+#define PRESSURE_BMP085_ADC_OUT_MSB_REG  (0xF6)
+#define PRESSURE_BMP085_ADC_OUT_LSB_REG  (0xF7)
+
+static int bma085_resume(void *mlsl_handle,
+			 struct ext_slave_descr *slave,
+			 struct ext_slave_platform_data *pdata)
+{
+	int result;
+	unsigned char data[PRESSURE_BMA085_PROM_DATA_LEN];
+
+	result =
+	    inv_serial_read(mlsl_handle, pdata->address,
+			   PRESSURE_BMA085_PROM_START_ADDR,
+			   PRESSURE_BMA085_PROM_DATA_LEN, data);
+	if (result) {
+		LOG_RESULT_LOCATION(result);
+		return result;
+	}
+
+	/* parameters AC1-AC6 */
+	cal_param.ac1 = (data[0] << 8) | data[1];
+	cal_param.ac2 = (data[2] << 8) | data[3];
+	cal_param.ac3 = (data[4] << 8) | data[5];
+	cal_param.ac4 = (data[6] << 8) | data[7];
+	cal_param.ac5 = (data[8] << 8) | data[9];
+	cal_param.ac6 = (data[10] << 8) | data[11];
+
+	/* parameters B1,B2 */
+	cal_param.b1 = (data[12] << 8) | data[13];
+	cal_param.b2 = (data[14] << 8) | data[15];
+
+	/* parameters MB,MC,MD */
+	cal_param.mb = (data[16] << 8) | data[17];
+	cal_param.mc = (data[18] << 8) | data[19];
+	cal_param.md = (data[20] << 8) | data[21];
+
+	return result;
+}
+
+static int bma085_read(void *mlsl_handle,
+		       struct ext_slave_descr *slave,
+		       struct ext_slave_platform_data *pdata,
+		       unsigned char *data)
+{
+	int result;
+	long pressure, x1, x2, x3, b3, b6;
+	unsigned long b4, b7;
+	unsigned long up;
+	unsigned short ut;
+	short oversampling_setting = 0;
+	short temperature;
+	long divisor;
+
+	/* get temprature */
+	result = inv_serial_single_write(mlsl_handle, pdata->address,
+				       PRESSURE_BMP085_CTRL_MEAS_REG,
+				       PRESSURE_BMP085_T_MEAS);
+	msleep(5);
+	result =
+	    inv_serial_read(mlsl_handle, pdata->address,
+			   PRESSURE_BMP085_ADC_OUT_MSB_REG, 2,
+			   (unsigned char *)data);
+	if (result) {
+		LOG_RESULT_LOCATION(result);
+		return result;
+	}
+	ut = (data[0] << 8) | data[1];
+
+	x1 = (((long) ut - (long)cal_param.ac6) * (long)cal_param.ac5) >> 15;
+	divisor = x1 + cal_param.md;
+	if (!divisor)
+		return INV_ERROR_DIVIDE_BY_ZERO;
+
+	x2 = ((long)cal_param.mc << 11) / (x1 + cal_param.md);
+	cal_param.param_b5 = x1 + x2;
+	/* temperature in 0.1 degree C */
+	temperature = (short)((cal_param.param_b5 + 8) >> 4);
+
+	/* get pressure */
+	result = inv_serial_single_write(mlsl_handle, pdata->address,
+				       PRESSURE_BMP085_CTRL_MEAS_REG,
+				       PRESSURE_BMP085_P_MEAS_OSS_0);
+	msleep(5);
+	result =
+	    inv_serial_read(mlsl_handle, pdata->address,
+			   PRESSURE_BMP085_ADC_OUT_MSB_REG, 2,
+			   (unsigned char *)data);
+	if (result) {
+		LOG_RESULT_LOCATION(result);
+		return result;
+	}
+	up = (((unsigned long) data[0] << 8) | ((unsigned long) data[1]));
+
+	b6 = cal_param.param_b5 - 4000;
+	/* calculate B3 */
+	x1 = (b6*b6) >> 12;
+	x1 *= cal_param.b2;
+	x1 >>= 11;
+
+	x2 = (cal_param.ac2*b6);
+	x2 >>= 11;
+
+	x3 = x1 + x2;
+
+	b3 = (((((long)cal_param.ac1) * 4 + x3)
+	    << oversampling_setting) + 2) >> 2;
+
+	/* calculate B4 */
+	x1 = (cal_param.ac3 * b6) >> 13;
+	x2 = (cal_param.b1 * ((b6*b6) >> 12)) >> 16;
+	x3 = ((x1 + x2) + 2) >> 2;
+	b4 = (cal_param.ac4 * (unsigned long) (x3 + 32768)) >> 15;
+	if (!b4)
+		return INV_ERROR;
+
+	b7 = ((unsigned long)(up - b3) * (50000>>oversampling_setting));
+	if (b7 < 0x80000000)
+		pressure = (b7 << 1) / b4;
+	else
+		pressure = (b7 / b4) << 1;
+
+	x1 = pressure >> 8;
+	x1 *= x1;
+	x1 = (x1 * PRESSURE_BMA085_PARAM_MG) >> 16;
+	x2 = (pressure * PRESSURE_BMA085_PARAM_MH) >> 16;
+	/* pressure in Pa */
+	pressure += (x1 + x2 + PRESSURE_BMA085_PARAM_MI) >> 4;
+
+	data[0] = (unsigned char)(pressure >> 16);
+	data[1] = (unsigned char)(pressure >> 8);
+	data[2] = (unsigned char)(pressure & 0xFF);
+
+	return result;
+}
+
+static struct ext_slave_descr bma085_descr = {
+	.init             = NULL,
+	.exit             = NULL,
+	.suspend          = bma085_suspend,
+	.resume           = bma085_resume,
+	.read             = bma085_read,
+	.config           = NULL,
+	.get_config       = NULL,
+	.name             = "bma085",
+	.type             = EXT_SLAVE_TYPE_PRESSURE,
+	.id               = PRESSURE_ID_BMA085,
+	.read_reg         = 0xF6,
+	.read_len         = 3,
+	.endian           = EXT_SLAVE_BIG_ENDIAN,
+	.range            = {0, 0},
+};
+
+static
+struct ext_slave_descr *bma085_get_slave_descr(void)
+{
+	return &bma085_descr;
+}
+
+/* Platform data for the MPU */
+struct bma085_mod_private_data {
+	struct i2c_client *client;
+	struct ext_slave_platform_data *pdata;
+};
+
+static unsigned short normal_i2c[] = { I2C_CLIENT_END };
+
+static int bma085_mod_probe(struct i2c_client *client,
+			   const struct i2c_device_id *devid)
+{
+	struct ext_slave_platform_data *pdata;
+	struct bma085_mod_private_data *private_data;
+	int result = 0;
+
+	dev_info(&client->adapter->dev, "%s: %s\n", __func__, devid->name);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		result = -ENODEV;
+		goto out_no_free;
+	}
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->adapter->dev,
+			"Missing platform data for slave %s\n", devid->name);
+		result = -EFAULT;
+		goto out_no_free;
+	}
+
+	private_data = kzalloc(sizeof(*private_data), GFP_KERNEL);
+	if (!private_data) {
+		result = -ENOMEM;
+		goto out_no_free;
+	}
+
+	i2c_set_clientdata(client, private_data);
+	private_data->client = client;
+	private_data->pdata = pdata;
+
+	result = inv_mpu_register_slave(THIS_MODULE, client, pdata,
+					bma085_get_slave_descr);
+	if (result) {
+		dev_err(&client->adapter->dev,
+			"Slave registration failed: %s, %d\n",
+			devid->name, result);
+		goto out_free_memory;
+	}
+
+	return result;
+
+out_free_memory:
+	kfree(private_data);
+out_no_free:
+	dev_err(&client->adapter->dev, "%s failed %d\n", __func__, result);
+	return result;
+
+}
+
+static int bma085_mod_remove(struct i2c_client *client)
+{
+	struct bma085_mod_private_data *private_data =
+		i2c_get_clientdata(client);
+
+	dev_dbg(&client->adapter->dev, "%s\n", __func__);
+
+	inv_mpu_unregister_slave(client, private_data->pdata,
+				bma085_get_slave_descr);
+
+	kfree(private_data);
+	return 0;
+}
+
+static const struct i2c_device_id bma085_mod_id[] = {
+	{ "bma085", PRESSURE_ID_BMA085 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, bma085_mod_id);
+
+static struct i2c_driver bma085_mod_driver = {
+	.class = I2C_CLASS_HWMON,
+	.probe = bma085_mod_probe,
+	.remove = bma085_mod_remove,
+	.id_table = bma085_mod_id,
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = "bma085_mod",
+		   },
+	.address_list = normal_i2c,
+};
+
+static int __init bma085_mod_init(void)
+{
+	int res = i2c_add_driver(&bma085_mod_driver);
+	pr_info("%s: Probe name %s\n", __func__, "bma085_mod");
+	if (res)
+		pr_err("%s failed\n", __func__);
+	return res;
+}
+
+static void __exit bma085_mod_exit(void)
+{
+	pr_info("%s\n", __func__);
+	i2c_del_driver(&bma085_mod_driver);
+}
+
+module_init(bma085_mod_init);
+module_exit(bma085_mod_exit);
+
+MODULE_AUTHOR("Invensense Corporation");
+MODULE_DESCRIPTION("Driver to integrate BMA085 sensor with the MPU");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("bma085_mod");
+/**
+ *  @}
+**/
-- 
1.7.4.1

