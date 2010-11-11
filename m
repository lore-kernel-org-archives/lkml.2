Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0KKL6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:58:09 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:40340 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593Ab0KKL6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:58:06 -0500
From: mems applications <mems.applications@st.com>
To: dmitry.torokhov@gmail.com
Cc: carmine.iascone@st.com, matteo.dameno@st.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] input: misc: add lis331dlh driver
Date: Thu, 11 Nov 2010 12:58:01 +0100
Message-Id: <1289476681-15983-1-git-send-email-carmine.iascone@st.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add STMicroelectronics LIS331DLH digital accelerometer device driver

Signed-off-by: Carmine Iascone <carmine.iascone@st.com>
---
 drivers/input/misc/Kconfig     |    7 +
 drivers/input/misc/Makefile    |    2 +-
 drivers/input/misc/lis331dlh.c |  836 ++++++++++++++++++++++++++++++++++++++++
 drivers/input/misc/lis331dlh.h |   83 ++++
 4 files changed, 927 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/lis331dlh.c
 create mode 100644 drivers/input/misc/lis331dlh.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b99b8cb..eb58bd3 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -448,4 +448,11 @@ config INPUT_ADXL34X_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called adxl34x-spi.
 
+config INPUT_LIS331DLH
+	tristate "STMicroelectronics LIS331DLH Accelerometer"
+	depends on I2C
+	---help---
+	 If you say yes here you get support for the STMicroelectronics
+	 LIS331DLH accelerometer sensor
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 1fe1f6c..819e1a3 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
+obj-$(CONFIG_INPUT_LIS331DLH)		+= lis331dlh.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
 obj-$(CONFIG_INPUT_MAX8925_ONKEY)	+= max8925_onkey.o
 obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
@@ -42,4 +43,3 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
-
diff --git a/drivers/input/misc/lis331dlh.c b/drivers/input/misc/lis331dlh.c
new file mode 100644
index 0000000..2b72c12
--- /dev/null
+++ b/drivers/input/misc/lis331dlh.c
@@ -0,0 +1,836 @@
+/******************** (C) COPYRIGHT 2010 STMicroelectronics ********************
+*
+* File Name          : lis331dlh.c
+* Authors            : MSH - Motion Mems BU - Application Team
+*		     : Carmine Iascone (carmine.iascone@st.com)
+*		     : Matteo Dameno (matteo.dameno@st.com)
+* Version            : V 1.0.0
+* Date               : 08/11/2010
+* Description        : LIS331DLH sensor API
+*
+********************************************************************************
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
+* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
+* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
+* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
+* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
+* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
+*
+* THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH ST PARTS.
+*
+******************************************************************************/
+#include "lis331dlh.h"
+
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/input-polldev.h>
+#include <linux/slab.h>
+
+
+#define LIS331DLH_DEV_NAME	"lis331dlh"
+
+/** Maximum polled-device-reported g value */
+#define G_MAX			8000
+
+#define SHIFT_ADJ_2G		4
+#define SHIFT_ADJ_4G		3
+#define SHIFT_ADJ_8G		2
+
+#define AXISDATA_REG		0x28
+
+/* ctrl 1: pm2 pm1 pm0 dr1 dr0 zenable yenable zenable */
+#define CTRL_REG1		0x20	/* power control reg */
+#define CTRL_REG2		0x21	/* power control reg */
+#define CTRL_REG3		0x22	/* power control reg */
+#define CTRL_REG4		0x23	/* interrupt control reg */
+
+#define FUZZ			0
+#define FLAT			0
+#define I2C_RETRY_DELAY		5
+#define I2C_RETRIES		5
+#define AUTO_INCREMENT		0x80
+
+static struct {
+	unsigned int cutoff;
+	unsigned int mask;
+} odr_table[] = {
+	{
+	3,	LIS331DLH_PM_NORMAL | LIS331DLH_ODR1000}, {
+	10,	LIS331DLH_PM_NORMAL | LIS331DLH_ODR400}, {
+	20,	LIS331DLH_PM_NORMAL | LIS331DLH_ODR100}, {
+	100,	LIS331DLH_PM_NORMAL | LIS331DLH_ODR50}, {
+	200,	LIS331DLH_ODR1000 | LIS331DLH_ODR10}, {
+	500,	LIS331DLH_ODR1000 | LIS331DLH_ODR5}, {
+	1000,	LIS331DLH_ODR1000 | LIS331DLH_ODR2}, {
+	2000,	LIS331DLH_ODR1000 | LIS331DLH_ODR1}, {
+	0,	LIS331DLH_ODR1000 | LIS331DLH_ODRHALF},};
+
+struct lis331dlh_data {
+	struct i2c_client *client;
+	struct lis331dlh_platform_data *pdata;
+
+	struct mutex lock;
+
+	struct input_polled_dev *input_poll_dev;
+
+	int hw_initialized;
+	atomic_t enabled;
+	int on_before_suspend;
+
+	u8 reg_addr;
+
+	u8 shift_adj;
+	u8 resume_state[5];
+};
+
+/*
+ * Because misc devices can not carry a pointer from driver register to
+ * open, we keep this global.  This limits the driver to a single instance.
+ */
+struct lis331dlh_data *lis331dlh_misc_data;
+
+static int lis331dlh_i2c_read(struct lis331dlh_data *acc,
+				  u8 *buf, int len)
+{
+	int err;
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = acc->client->addr,
+		 .flags = acc->client->flags & I2C_M_TEN,
+		 .len = 1,
+		 .buf = buf,
+		 },
+		{
+		 .addr = acc->client->addr,
+		 .flags = (acc->client->flags & I2C_M_TEN) | I2C_M_RD,
+		 .len = len,
+		 .buf = buf,
+		 },
+	};
+
+	err = i2c_transfer(acc->client->adapter, msgs, 2);
+
+	if (err != 2) {
+		dev_err(&acc->client->dev, "read transfer error\n");
+		err = -EIO;
+	} else {
+		err = 0;
+	}
+
+	return err;
+}
+
+static int lis331dlh_i2c_write(struct lis331dlh_data *acc,
+				   u8 *buf, int len)
+{
+	int err;
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = acc->client->addr,
+		 .flags = acc->client->flags & I2C_M_TEN,
+		 .len = len + 1,
+		 .buf = buf,
+		 },
+	};
+
+	err = i2c_transfer(acc->client->adapter, msgs, 1);
+
+	if (err != 1) {
+		dev_err(&acc->client->dev, "write transfer error\n");
+		err = -EIO;
+	} else {
+		err = 0;
+	}
+
+	return err;
+}
+
+static int lis331dlh_hw_init(struct lis331dlh_data *acc)
+{
+	int err = -1;
+	u8 buf[6];
+
+	buf[0] = (AUTO_INCREMENT | CTRL_REG1);
+	buf[1] = acc->resume_state[0];
+	buf[2] = acc->resume_state[1];
+	buf[3] = acc->resume_state[2];
+	buf[4] = acc->resume_state[3];
+	buf[5] = acc->resume_state[4];
+	err = lis331dlh_i2c_write(acc, buf, 5);
+	if (err < 0)
+		return err;
+
+	acc->hw_initialized = 1;
+
+	return 0;
+}
+
+static void lis331dlh_device_power_off(struct lis331dlh_data *acc)
+{
+	int err;
+	u8 buf[2] = { CTRL_REG1,
+		      LIS331DLH_PM_OFF | LIS331DLH_ENABLE_ALL_AXES };
+
+	err = lis331dlh_i2c_write(acc, buf, 1);
+	if (err < 0)
+		dev_err(&acc->client->dev, "soft power off failed\n");
+
+	if (acc->pdata->power_off)
+		acc->pdata->power_off();
+
+	acc->hw_initialized = 0;
+
+}
+
+static int lis331dlh_device_power_on(struct lis331dlh_data *acc)
+{
+	int err;
+
+	if (acc->pdata->power_on) {
+		err = acc->pdata->power_on();
+		if (err < 0)
+			return err;
+	}
+
+	if (!acc->hw_initialized) {
+		err = lis331dlh_hw_init(acc);
+		if (err < 0) {
+			lis331dlh_device_power_off(acc);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int lis331dlh_update_g_range(struct lis331dlh_data *acc, u8 new_g_range)
+{
+	int err;
+	u8 shift;
+	u8 buf[2];
+	switch (new_g_range) {
+	case LIS331DLH_G_2G:
+		shift = SHIFT_ADJ_2G;
+		break;
+	case LIS331DLH_G_4G:
+		shift = SHIFT_ADJ_4G;
+		break;
+	case LIS331DLH_G_8G:
+		shift = SHIFT_ADJ_8G;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (atomic_read(&acc->enabled)) {
+		/* Set configuration register 4, which contains g range setting
+		 *  NOTE: this is a straight overwrite because this driver does
+		 *  not use any of the other configuration bits in this
+		 *  register.  Should this become untrue, we will have to read
+		 *  out the value and only change the relevant bits --XX----
+		 *  (marked by X) */
+		buf[0] = CTRL_REG4;
+		buf[1] = new_g_range;
+		err = lis331dlh_i2c_write(acc, buf, 1);
+		if (err < 0)
+			return err;
+	}
+
+	acc->resume_state[3] = new_g_range;
+	acc->shift_adj = shift;
+
+	return 0;
+}
+
+int lis331dlh_update_odr(struct lis331dlh_data *acc, int poll_interval)
+{
+	int err = -1;
+	int i;
+	u8 config[2];
+
+	/* Convert the poll interval into an output data rate configuration
+	 *  that is as low as possible.  The ordering of these checks must be
+	 *  maintained due to the cascading cut off values - poll intervals are
+	 *  checked from shortest to longest.  At each check, if the next lower
+	 *  ODR cannot support the current poll interval, we stop searching */
+	for (i = 0; i < ARRAY_SIZE(odr_table); i++) {
+		config[1] = odr_table[i].mask;
+		if (poll_interval < odr_table[i].cutoff)
+			break;
+	}
+
+	config[1] |= LIS331DLH_ENABLE_ALL_AXES;
+
+	/* If device is currently enabled, we need to write new
+	 *  configuration out to it */
+	if (atomic_read(&acc->enabled)) {
+		config[0] = CTRL_REG1;
+		err = lis331dlh_i2c_write(acc, config, 1);
+		if (err < 0)
+			return err;
+	}
+
+	acc->resume_state[0] = config[1];
+
+	return 0;
+}
+
+static int decode(u8 *p, int adj)
+{
+	s16 v = p[0] | (p[1] << 8);
+	return (int) v >> adj;
+}
+
+static int lis331dlh_get_data(struct lis331dlh_data *acc,
+					       int *xyz)
+{
+	int err = -1;
+	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
+	u8 acc_data[6];
+	/* x,y,z hardware data */
+	int hw_d[3] = { 0 };
+
+	acc_data[0] = (AUTO_INCREMENT | AXISDATA_REG);
+	err = lis331dlh_i2c_read(acc, acc_data, 6);
+	if (err < 0)
+		return err;
+
+	hw_d[0] = decode(acc_data, acc->shift_adj);
+	hw_d[1] = decode(acc_data + 2, acc->shift_adj);
+	hw_d[2] = decode(acc_data + 4, acc->shift_adj);
+
+	xyz[0] = ((acc->pdata->negate_x) ? (-hw_d[acc->pdata->axis_map_x])
+		  : (hw_d[acc->pdata->axis_map_x]));
+	xyz[1] = ((acc->pdata->negate_y) ? (-hw_d[acc->pdata->axis_map_y])
+		  : (hw_d[acc->pdata->axis_map_y]));
+	xyz[2] = ((acc->pdata->negate_z) ? (-hw_d[acc->pdata->axis_map_z])
+		  : (hw_d[acc->pdata->axis_map_z]));
+
+	return err;
+}
+
+static void lis331dlh_report_values(struct lis331dlh_data *acc,
+					int *xyz)
+{
+	struct input_dev *input = acc->input_poll_dev->input;
+	input_report_abs(input, ABS_X, xyz[0]);
+	input_report_abs(input, ABS_Y, xyz[1]);
+	input_report_abs(input, ABS_Z, xyz[2]);
+	input_sync(input);
+}
+
+static int lis331dlh_enable(struct lis331dlh_data *acc)
+{
+	int err;
+
+	if (!atomic_cmpxchg(&acc->enabled, 0, 1)) {
+
+		err = lis331dlh_device_power_on(acc);
+		if (err < 0) {
+			atomic_set(&acc->enabled, 0);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int lis331dlh_disable(struct lis331dlh_data *acc)
+{
+	if (atomic_cmpxchg(&acc->enabled, 1, 0))
+		lis331dlh_device_power_off(acc);
+
+	return 0;
+}
+
+static ssize_t attr_get_polling_rate(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	int val;
+	mutex_lock(&acc->lock);
+	val = acc->pdata->poll_interval;
+	mutex_unlock(&acc->lock);
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t attr_set_polling_rate(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t size)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	unsigned long interval_ms;
+
+	if (strict_strtoul(buf, 10, &interval_ms))
+		return -EINVAL;
+	if (!interval_ms)
+		return -EINVAL;
+	mutex_lock(&acc->lock);
+	acc->pdata->poll_interval = interval_ms;
+	lis331dlh_update_odr(acc, interval_ms);
+	mutex_unlock(&acc->lock);
+	return size;
+}
+
+static ssize_t attr_get_range(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	char range;
+	char val;
+	mutex_lock(&acc->lock);
+	val = acc->pdata->g_range ;
+	switch (val) {
+	case LIS331DLH_G_2G:
+		range = 2;
+		break;
+	case LIS331DLH_G_4G:
+		range = 4;
+		break;
+	case LIS331DLH_G_8G:
+		range = 8;
+		break;
+	default:
+		range = 2;
+		break;
+	}
+	mutex_unlock(&acc->lock);
+	return sprintf(buf, "%d\n", range);
+}
+
+static ssize_t attr_set_range(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	unsigned long val;
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+	mutex_lock(&acc->lock);
+	acc->pdata->g_range = val;
+	lis331dlh_update_g_range(acc, val);
+	mutex_unlock(&acc->lock);
+	return size;
+}
+
+static ssize_t attr_get_enable(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	int val = atomic_read(&acc->enabled);
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t attr_set_enable(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	if (val)
+		lis331dlh_enable(acc);
+	else
+		lis331dlh_disable(acc);
+
+	return size;
+}
+
+static ssize_t attr_reg_set(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	int rc;
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	u8 x[2];
+	unsigned long val;
+
+	if (strict_strtoul(buf, 16, &val))
+		return -EINVAL;
+	mutex_lock(&acc->lock);
+	x[0] = acc->reg_addr;
+	mutex_unlock(&acc->lock);
+	x[1] = val;
+	rc = lis331dlh_i2c_write(acc, x, 1);
+	return size;
+}
+
+static ssize_t attr_reg_get(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	ssize_t ret;
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	int rc;
+	u8 data;
+
+	mutex_lock(&acc->lock);
+	data = acc->reg_addr;
+	mutex_unlock(&acc->lock);
+	rc = lis331dlh_i2c_read(acc, &data, 1);
+	ret = sprintf(buf, "0x%02x\n", data);
+	return ret;
+}
+
+static ssize_t attr_addr_set(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	struct lis331dlh_data *acc = dev_get_drvdata(dev);
+	unsigned long val;
+	if (strict_strtoul(buf, 16, &val))
+		return -EINVAL;
+	mutex_lock(&acc->lock);
+	acc->reg_addr = val;
+	mutex_unlock(&acc->lock);
+	return size;
+}
+
+static struct device_attribute attributes[] = {
+	__ATTR(pollrate_ms, 0666, attr_get_polling_rate, attr_set_polling_rate),
+	__ATTR(range, 0666, attr_get_range, attr_set_range),
+	__ATTR(enable, 0666, attr_get_enable, attr_set_enable),
+	__ATTR(reg_value, 0600, attr_reg_get, attr_reg_set),
+	__ATTR(reg_addr, 0200, NULL, attr_addr_set),
+};
+
+static int create_sysfs_interfaces(struct device *dev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(attributes); i++)
+		if (device_create_file(dev, attributes + i))
+			goto error;
+	return 0;
+
+error:
+	for ( ; i >= 0; i--)
+		device_remove_file(dev, attributes + i);
+	dev_err(dev, "%s:Unable to create interface\n", __func__);
+	return -1;
+}
+
+static int remove_sysfs_interfaces(struct device *dev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(attributes); i++)
+		device_remove_file(dev, attributes + i);
+	return 0;
+}
+
+
+static void lis331dlh_input_poll_func(struct input_polled_dev *dev)
+{
+	struct lis331dlh_data *acc = dev->private;
+
+	int xyz[3] = { 0 };
+	int err;
+
+	/* acc = container_of((struct delayed_work *)work,
+			    struct lis331dlh_data, input_work); */
+
+	mutex_lock(&acc->lock);
+	err = lis331dlh_get_data(acc, xyz);
+	if (err < 0)
+		dev_err(&acc->client->dev, "get_acceleration_data failed\n");
+	else
+		lis331dlh_report_values(acc, xyz);
+
+	mutex_unlock(&acc->lock);
+}
+
+int lis331dlh_input_open(struct input_dev *input)
+{
+	struct lis331dlh_data *acc = input_get_drvdata(input);
+
+	return lis331dlh_enable(acc);
+}
+
+void lis331dlh_input_close(struct input_dev *dev)
+{
+	struct lis331dlh_data *acc = input_get_drvdata(dev);
+
+	lis331dlh_disable(acc);
+}
+
+static int lis331dlh_validate_pdata(struct lis331dlh_data *acc)
+{
+	acc->pdata->poll_interval = max(acc->pdata->poll_interval,
+					acc->pdata->min_interval);
+
+	if (acc->pdata->axis_map_x > 2 ||
+	    acc->pdata->axis_map_y > 2 || acc->pdata->axis_map_z > 2) {
+		dev_err(&acc->client->dev,
+			"invalid axis_map value x:%u y:%u z%u\n",
+			acc->pdata->axis_map_x, acc->pdata->axis_map_y,
+			acc->pdata->axis_map_z);
+		return -EINVAL;
+	}
+
+	/* Only allow 0 and 1 for negation boolean flag */
+	if (acc->pdata->negate_x > 1 || acc->pdata->negate_y > 1 ||
+	    acc->pdata->negate_z > 1) {
+		dev_err(&acc->client->dev,
+			"invalid negate value x:%u y:%u z:%u\n",
+			acc->pdata->negate_x, acc->pdata->negate_y,
+			acc->pdata->negate_z);
+		return -EINVAL;
+	}
+
+	/* Enforce minimum polling interval */
+	if (acc->pdata->poll_interval < acc->pdata->min_interval) {
+		dev_err(&acc->client->dev, "minimum poll interval violated\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int lis331dlh_input_init(struct lis331dlh_data *acc)
+{
+	int err;
+	struct input_dev *input;
+
+	acc->input_poll_dev = input_allocate_polled_device();
+	if (!acc->input_poll_dev) {
+		err = -ENOMEM;
+		dev_err(&acc->client->dev, "input device allocate failed\n");
+		goto err0;
+	}
+
+	/* set input-polldev handlers */
+	acc->input_poll_dev->private = acc;
+	acc->input_poll_dev->poll = lis331dlh_input_poll_func;
+	acc->input_poll_dev->poll_interval = acc->pdata->poll_interval;
+
+	input = acc->input_poll_dev->input;
+
+	input->open = lis331dlh_input_open;
+	input->close = lis331dlh_input_close;
+	input->name = LIS331DLH_DEV_NAME;
+	input->id.bustype = BUS_I2C;
+	input->dev.parent = &acc->client->dev;
+
+	input_set_drvdata(acc->input_poll_dev->input, acc);
+
+	set_bit(EV_ABS, input->evbit);
+
+	input_set_abs_params(input, ABS_X, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(input, ABS_Y, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(input, ABS_Z, -G_MAX, G_MAX, FUZZ, FLAT);
+
+	input->name = "accelerometer";
+
+	err = input_register_polled_device(acc->input_poll_dev);
+	if (err) {
+		dev_err(&acc->client->dev,
+			"unable to register input polled device %s\n",
+			acc->input_poll_dev->input->name);
+		goto err1;
+	}
+
+	return 0;
+
+err1:
+	input_free_polled_device(acc->input_poll_dev);
+err0:
+	return err;
+}
+
+static void lis331dlh_input_cleanup(struct lis331dlh_data *acc)
+{
+	input_unregister_polled_device(acc->input_poll_dev);
+	input_free_polled_device(acc->input_poll_dev);
+}
+
+static int lis331dlh_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct lis331dlh_data *acc;
+	int err = -1;
+
+	if (client->dev.platform_data == NULL) {
+		dev_err(&client->dev, "platform data is NULL. exiting.\n");
+		err = -ENODEV;
+		goto err0;
+	}
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "client not i2c capable\n");
+		err = -ENODEV;
+		goto err0;
+	}
+
+	acc = kzalloc(sizeof(*acc), GFP_KERNEL);
+	if (acc == NULL) {
+		dev_err(&client->dev,
+			"failed to allocate memory for module data\n");
+		err = -ENOMEM;
+		goto err0;
+	}
+
+	mutex_init(&acc->lock);
+	mutex_lock(&acc->lock);
+	acc->client = client;
+
+	acc->pdata = kmalloc(sizeof(*acc->pdata), GFP_KERNEL);
+	if (acc->pdata == NULL)
+		goto err1;
+
+	memcpy(acc->pdata, client->dev.platform_data, sizeof(*acc->pdata));
+
+	err = lis331dlh_validate_pdata(acc);
+	if (err < 0) {
+		dev_err(&client->dev, "failed to validate platform data\n");
+		goto err1_1;
+	}
+
+	i2c_set_clientdata(client, acc);
+
+	if (acc->pdata->init) {
+		err = acc->pdata->init();
+		if (err < 0)
+			goto err1_1;
+	}
+
+	memset(acc->resume_state, 0, ARRAY_SIZE(acc->resume_state));
+
+	acc->resume_state[0] = 0x27;
+	acc->resume_state[1] = 0x00;
+	acc->resume_state[2] = 0x00;
+	acc->resume_state[3] = 0x00;
+	acc->resume_state[4] = 0x00;
+
+	err = lis331dlh_device_power_on(acc);
+	if (err < 0)
+		goto err2;
+
+	atomic_set(&acc->enabled, 1);
+
+	err = lis331dlh_update_g_range(acc, acc->pdata->g_range);
+	if (err < 0) {
+		dev_err(&client->dev, "update_g_range failed\n");
+		goto err2;
+	}
+
+	err = lis331dlh_update_odr(acc, acc->pdata->poll_interval);
+	if (err < 0) {
+		dev_err(&client->dev, "update_odr failed\n");
+		goto err2;
+	}
+
+	err = lis331dlh_input_init(acc);
+	if (err < 0)
+		goto err3;
+
+	err = create_sysfs_interfaces(&client->dev);
+	if (err < 0) {
+		dev_err(&client->dev, "lsm_acc_device register failed\n");
+		goto err4;
+	}
+
+	lis331dlh_device_power_off(acc);
+
+	/* As default, do not report information */
+	atomic_set(&acc->enabled, 0);
+
+	mutex_unlock(&acc->lock);
+
+	dev_info(&client->dev, "lis331dlh probed\n");
+
+	return 0;
+
+err4:
+	lis331dlh_input_cleanup(acc);
+err3:
+	lis331dlh_device_power_off(acc);
+err2:
+	if (acc->pdata->exit)
+		acc->pdata->exit();
+err1_1:
+	mutex_unlock(&acc->lock);
+	kfree(acc->pdata);
+err1:
+	kfree(acc);
+err0:
+	return err;
+}
+
+static int __devexit lis331dlh_remove(struct i2c_client *client)
+{
+	/* TODO: revisit ordering here once _probe order is finalized */
+	struct lis331dlh_data *acc = i2c_get_clientdata(client);
+	lis331dlh_input_cleanup(acc);
+	lis331dlh_device_power_off(acc);
+	remove_sysfs_interfaces(&client->dev);
+	if (acc->pdata->exit)
+		acc->pdata->exit();
+	kfree(acc->pdata);
+	kfree(acc);
+
+	return 0;
+}
+
+static int lis331dlh_resume(struct i2c_client *client)
+{
+	struct lis331dlh_data *acc = i2c_get_clientdata(client);
+
+	if (acc->on_before_suspend)
+		return lis331dlh_enable(acc);
+	return 0;
+}
+
+static int lis331dlh_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct lis331dlh_data *acc = i2c_get_clientdata(client);
+
+	acc->on_before_suspend = atomic_read(&acc->enabled);
+	return lis331dlh_disable(acc);
+}
+
+static const struct i2c_device_id lis331dlh_id[] = {
+	{LIS331DLH_DEV_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, lis331dlh_id);
+
+static struct i2c_driver lis331dlh_driver = {
+	.driver = {
+		.name = LIS331DLH_DEV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = lis331dlh_probe,
+	.remove = __devexit_p(lis331dlh_remove),
+	.resume = lis331dlh_resume,
+	.suspend = lis331dlh_suspend,
+	.id_table = lis331dlh_id,
+};
+
+static int __init lis331dlh_init(void)
+{
+	pr_debug("LIS331DLH driver for the accelerometer part\n");
+	return i2c_add_driver(&lis331dlh_driver);
+}
+
+static void __exit lis331dlh_exit(void)
+{
+	i2c_del_driver(&lis331dlh_driver);
+	return;
+}
+
+module_init(lis331dlh_init);
+module_exit(lis331dlh_exit);
+
+MODULE_DESCRIPTION("lis331dlh accelerometer driver");
+MODULE_AUTHOR("STMicroelectronics");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/input/misc/lis331dlh.h b/drivers/input/misc/lis331dlh.h
new file mode 100644
index 0000000..4ea008a
--- /dev/null
+++ b/drivers/input/misc/lis331dlh.h
@@ -0,0 +1,83 @@
+/******************** (C) COPYRIGHT 2010 STMicroelectronics ********************
+*
+* File Name          : lis331dlh.h
+* Authors            : MSH - Motion Mems BU - Application Team
+*		     : Carmine Iascone (carmine.iascone@st.com)
+*		     : Matteo Dameno (matteo.dameno@st.com)
+* Version            : V 1.0.0
+* Date               : 08/11/2010
+* Description        : LIS331DLH sensor API
+*
+********************************************************************************
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
+* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
+* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
+* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
+* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
+* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
+* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
+*
+* THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH ST PARTS.
+*
+*******************************************************************************/
+
+#ifndef __LIS331DLH_H__
+#define __LIS331DLH_H__
+
+#include <linux/types.h>
+
+/************************************************/
+/*	Accelerometer section defines		*/
+/************************************************/
+
+/* Accelerometer Sensor Full Scale */
+#define LIS331DLH_G_2G			0x00
+#define LIS331DLH_G_4G			0x10
+#define LIS331DLH_G_8G			0x30
+
+/* Accelerometer Sensor Operating Mode */
+#define LIS331DLH_PM_OFF		0x00
+#define LIS331DLH_PM_NORMAL		0x20
+#define LIS331DLH_ENABLE_ALL_AXES	0x07
+
+/* Accelerometer output data rate  */
+#define LIS331DLH_ODRHALF		0x40	/* 0.5Hz output data rate */
+#define LIS331DLH_ODR1			0x60	/* 1Hz output data rate */
+#define LIS331DLH_ODR2			0x80	/* 2Hz output data rate */
+#define LIS331DLH_ODR5			0xA0	/* 5Hz output data rate */
+#define LIS331DLH_ODR10			0xC0	/* 10Hz output data rate */
+#define LIS331DLH_ODR50			0x00	/* 50Hz output data rate */
+#define LIS331DLH_ODR100		0x08	/* 100Hz output data rate */
+#define LIS331DLH_ODR400		0x10	/* 400Hz output data rate */
+#define LIS331DLH_ODR1000		0x18	/* 1000Hz output data rate */
+
+#ifdef __KERNEL__
+struct lis331dlh_platform_data {
+
+	int poll_interval;
+	int min_interval;
+
+	u8 g_range;
+
+	u8 axis_map_x;
+	u8 axis_map_y;
+	u8 axis_map_z;
+
+	u8 negate_x;
+	u8 negate_y;
+	u8 negate_z;
+
+	int (*init)(void);
+	void (*exit)(void);
+	int (*power_on)(void);
+	int (*power_off)(void);
+
+};
+#endif /* __KERNEL__ */
+
+#endif  /* __LIS331DLH_H__ */
-- 
1.5.4.3

