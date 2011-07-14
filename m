Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1GNVw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:52:57 -0400
Received: from csmtp2.one.com ([91.198.169.22]:21427 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1GNVwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:52:55 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: [PATCH v3 1/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 14 Jul 2011 23:56:12 +0200
Message-Id: <1310680572-27410-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310680572-27410-1-git-send-email-eric.andersson@unixphere.com>
References: <1310680572-27410-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Albert Zhang <xu.zhang@bosch-sensortec.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 Documentation/ABI/testing/sysfs-i2c-bma150 |   22 +
 drivers/input/misc/Kconfig                 |   11 +
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/bma150.c                |  577 ++++++++++++++++++++++++++++
 4 files changed, 611 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bma150
 create mode 100644 drivers/input/misc/bma150.c

diff --git a/Documentation/ABI/testing/sysfs-i2c-bma150 b/Documentation/ABI/testing/sysfs-i2c-bma150
new file mode 100644
index 0000000..842cb03
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-i2c-bma150
@@ -0,0 +1,22 @@
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/range
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to select the full scale acceleration range. The
+		values represent the range given as +/- G.
+		Possible values are: 2, 4, 8.
+
+		Reading: returns the current acceleration range.
+
+		Writing: sets a new acceleration range.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/bandwidth
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to setup the digital filtering on ADC output data.
+		The values represent the bandwidth given in Hz.
+		Possible values are: 25, 50, 100, 190, 375, 750, 1500
+
+		Reading: returns the current bandwidth.
+
+		Writing: sets a new bandwidth.
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 45dc6aa..e6681d2 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -478,4 +478,15 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
+config INPUT_BMA150
+	tristate "BMA150/SMB380 acceleration sensor support"
+	depends on I2C
+	select INPUT_POLLDEV
+	help
+	  Say Y here if you have Bosch Sensortec's BMA150 or SMB380
+	  acceleration sensor hooked to an I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bma150.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 38efb2c..9b13e0e 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -45,4 +45,5 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
+obj-$(CONFIG_INPUT_BMA150)		+= bma150.o
 
diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
new file mode 100644
index 0000000..fb789a3
--- /dev/null
+++ b/drivers/input/misc/bma150.c
@@ -0,0 +1,577 @@
+/*
+ * Copyright (c) 2011 Bosch Sensortec GmbH
+ * Copyright (c) 2011 Unixphere
+ *
+ * This driver adds support for Bosch Sensortec's digital acceleration
+ * sensors BMA150 and SMB380.
+ * The SMB380 is fully compatible with BMA150 and only differs in packaging.
+ *
+ * The datasheet for the BMA150 chip can be found here:
+ * http://www.bosch-sensortec.com/content/language1/downloads/BST-BMA150-DS000-07.pdf
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input-polldev.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#define DRIVER_NAME		"bma150"
+#define ABSMAX_ACC_VAL		0x01FF
+#define ABSMIN_ACC_VAL		-(ABSMAX_ACC_VAL)
+/* Input poll interval in milliseconds */
+#define BMA150_POLL_INTERVAL	10
+#define BMA150_POLL_MAX		200
+#define BMA150_POLL_MIN		0
+
+#define BMA150_BW_25HZ		0
+#define BMA150_BW_50HZ		1
+#define BMA150_BW_100HZ		2
+#define BMA150_BW_190HZ		3
+#define BMA150_BW_375HZ		4
+#define BMA150_BW_750HZ		5
+#define BMA150_BW_1500HZ	6
+
+#define BMA150_RANGE_2G		0
+#define BMA150_RANGE_4G		1
+#define BMA150_RANGE_8G		2
+
+#define BMA150_MODE_NORMAL	0
+#define BMA150_MODE_SLEEP	2
+#define BMA150_MODE_WAKE_UP	3
+
+#define BMA150_CHIP_ID		2
+#define BMA150_CHIP_ID_REG	0x00
+
+#define BMA150_ACC_X_LSB_REG	0x02
+
+#define BMA150_SLEEP_POS	0
+#define BMA150_SLEEP_MSK	0x01
+#define BMA150_SLEEP_REG	0x0a
+
+#define BMA150_BANDWIDTH_POS	0
+#define BMA150_BANDWIDTH_MSK	0x07
+#define BMA150_BANDWIDTH_REG	0x14
+
+#define BMA150_RANGE_POS	3
+#define BMA150_RANGE_MSK	0x18
+#define BMA150_RANGE_REG	0x14
+
+#define BMA150_WAKE_UP_POS	0
+#define BMA150_WAKE_UP_MSK	0x01
+#define BMA150_WAKE_UP_REG	0x15
+
+#define BMA150_SW_RES_POS	1
+#define BMA150_SW_RES_REG	BMA150_SLEEP_REG
+
+struct bma150_data {
+	struct i2c_client *client;
+	struct input_polled_dev *input_polled;
+	struct input_dev *input;
+	struct mutex mutex;
+};
+
+static const struct {
+	int value;
+	int reg;
+} bw_val[] = {
+	{ 25,	BMA150_BW_25HZ },
+	{ 50,	BMA150_BW_50HZ },
+	{ 100,	BMA150_BW_100HZ },
+	{ 190,	BMA150_BW_190HZ },
+	{ 375,	BMA150_BW_375HZ },
+	{ 750,	BMA150_BW_750HZ },
+	{ 1500,	BMA150_BW_1500HZ }
+};
+
+static const struct {
+	int value;
+	int reg;
+} range_val[] = {
+	{ 2,	BMA150_RANGE_2G },
+	{ 4,	BMA150_RANGE_4G },
+	{ 8,	BMA150_RANGE_8G }
+};
+
+static int bma150_soft_reset(struct i2c_client *client)
+{
+	s32 ret;
+	u8 data;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_SW_RES_REG);
+	if (ret < 0)
+		goto error;
+
+	data = ret | (1 << BMA150_SW_RES_POS);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_SW_RES_REG, data);
+	msleep(2);
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_set_mode(struct i2c_client *client, u8 mode)
+{
+	s32 ret;
+	u8 data1, data2;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_WAKE_UP_REG);
+	if (ret < 0)
+		goto error;
+
+	data1 = (ret & ~BMA150_WAKE_UP_MSK) |
+		((mode << BMA150_WAKE_UP_POS) & BMA150_WAKE_UP_MSK);
+
+	ret = i2c_smbus_read_byte_data(client, BMA150_SLEEP_REG);
+	if (ret < 0)
+		goto error;
+
+	data2 = (ret & ~BMA150_SLEEP_MSK) |
+		(((mode>>1) << BMA150_SLEEP_POS) & BMA150_SLEEP_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_WAKE_UP_REG, data1);
+	if (ret < 0)
+		goto error;
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_SLEEP_REG, data2);
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_set_range(struct i2c_client *client, u8 range)
+{
+	s32 ret;
+	u8 data;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
+	if (ret < 0)
+		goto error;
+
+	data = (ret & ~BMA150_RANGE_MSK) |
+		((range << BMA150_RANGE_POS) & BMA150_RANGE_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_RANGE_REG, data);
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_get_range(struct i2c_client *client)
+{
+	s32 ret;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
+	if (ret < 0)
+		goto error;
+
+	ret = (ret & BMA150_RANGE_MSK) >> BMA150_RANGE_POS;
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_set_bandwidth(struct i2c_client *client, u8 bw)
+{
+	s32 ret;
+	u8 data;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
+	if (ret < 0)
+		goto error;
+
+	data = (ret & ~BMA150_BANDWIDTH_MSK) |
+		((bw << BMA150_BANDWIDTH_POS) & BMA150_BANDWIDTH_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_BANDWIDTH_REG, data);
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_get_bandwidth(struct i2c_client *client)
+{
+	s32 ret;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	mutex_lock(&bma150->mutex);
+	ret = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
+	if (ret < 0)
+		goto error;
+
+	ret = (ret & BMA150_BANDWIDTH_MSK) >> BMA150_BANDWIDTH_POS;
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_initialize(struct i2c_client *client)
+{
+	s32 ret;
+
+	ret = bma150_soft_reset(client);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
+	if (ret != BMA150_CHIP_ID) {
+		dev_err(&client->dev, "BMA150 chip id error: %d\n", ret);
+		return -EINVAL;
+	}
+
+	ret = bma150_set_bandwidth(client, BMA150_BW_50HZ);
+	if (ret < 0)
+		return ret;
+
+	ret = bma150_set_range(client, BMA150_RANGE_2G);
+	if (ret < 0)
+		return ret;
+
+	ret = bma150_set_mode(client, BMA150_MODE_SLEEP);
+	return ret;
+}
+
+static ssize_t bma150_range_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	int i;
+	int range;
+	struct input_polled_dev *ipoll_dev = dev_get_drvdata(dev);
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	pm_runtime_get_sync(bma150_dev);
+	range = bma150_get_range(bma150->client);
+	pm_runtime_put(bma150_dev);
+
+	if (range < 0)
+		return sprintf(buf, "Read error\n");
+
+	for (i = 0, ret = 0; i < ARRAY_SIZE(range_val); i++)
+		ret += sprintf(buf + ret,
+			(range_val[i].reg == range) ? "[%d] " : "%d ",
+			range_val[i].value);
+
+	ret += sprintf(buf + ret, "\n");
+	return ret;
+}
+
+static ssize_t bma150_range_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int ret;
+	int i;
+	struct input_polled_dev *ipoll_dev = dev_get_drvdata(dev);
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	ret = strict_strtoul(buf, 10, &data);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(range_val); i++)
+		if (range_val[i].value == data) {
+			pm_runtime_get_sync(bma150_dev);
+			ret = bma150_set_range(bma150->client,
+					       range_val[i].reg);
+			pm_runtime_put(bma150_dev);
+			if (ret < 0)
+				return ret;
+			return count;
+		}
+
+	return -EINVAL;
+}
+
+static ssize_t bma150_bandwidth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	int i;
+	int bw;
+	struct input_polled_dev *ipoll_dev = dev_get_drvdata(dev);
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	pm_runtime_get_sync(bma150_dev);
+	bw = bma150_get_bandwidth(bma150->client);
+	pm_runtime_put(bma150_dev);
+
+	if (bw < 0)
+		return sprintf(buf, "Read error\n");
+
+	for (i = 0, ret = 0; i < ARRAY_SIZE(bw_val); i++)
+		ret += sprintf(buf + ret,
+			(bw_val[i].reg == bw) ? "[%d] " : "%d ",
+			bw_val[i].value);
+
+	ret += sprintf(buf + ret, "\n");
+	return ret;
+}
+
+static ssize_t bma150_bandwidth_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int ret;
+	int i;
+	struct input_polled_dev *ipoll_dev = dev_get_drvdata(dev);
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	ret = strict_strtoul(buf, 10, &data);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(bw_val); i++)
+		if (bw_val[i].value == data) {
+			pm_runtime_get_sync(bma150_dev);
+			ret = bma150_set_bandwidth(bma150->client,
+						     bw_val[i].reg);
+			pm_runtime_put(bma150_dev);
+			if (ret < 0)
+				return ret;
+			return count;
+		}
+
+	return -EINVAL;
+}
+
+static DEVICE_ATTR(range, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_range_show, bma150_range_store);
+static DEVICE_ATTR(bandwidth, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_bandwidth_show, bma150_bandwidth_store);
+
+static struct attribute *bma150_attributes[] = {
+	&dev_attr_range.attr,
+	&dev_attr_bandwidth.attr,
+	NULL
+};
+
+static struct attribute_group bma150_attribute_group = {
+	.attrs = bma150_attributes
+};
+
+static void bma150_open(struct input_polled_dev *ipoll_dev)
+{
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	pm_runtime_get(bma150_dev);
+}
+
+static void bma150_close(struct input_polled_dev *ipoll_dev)
+{
+	struct bma150_data *bma150 = ipoll_dev->private;
+	struct device *bma150_dev = &bma150->client->dev;
+
+	pm_runtime_put(bma150_dev);
+}
+
+static void bma150_poll(struct input_polled_dev *dev)
+{
+	struct bma150_data *bma150 = dev->private;
+	u8 data[6];
+	s16 x, y, z;
+	s32 ret = i2c_smbus_read_i2c_block_data(bma150->client,
+			BMA150_ACC_X_LSB_REG, 6, data);
+	if (ret != 6)
+		return;
+
+	x = ((0xc0 & data[0]) >> 6) | (data[1] << 2);
+	y = ((0xc0 & data[2]) >> 6) | (data[3] << 2);
+	z = ((0xc0 & data[4]) >> 6) | (data[5] << 2);
+
+	/* sign extension */
+	x = (s16) (x << 6) >> 6;
+	y = (s16) (y << 6) >> 6;
+	z = (s16) (z << 6) >> 6;
+
+	input_report_abs(bma150->input, ABS_X, x);
+	input_report_abs(bma150->input, ABS_Y, y);
+	input_report_abs(bma150->input, ABS_Z, z);
+	input_sync(bma150->input);
+}
+
+static int __devinit bma150_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct bma150_data *bma150;
+	struct input_polled_dev *ipoll_dev;
+	struct input_dev *idev;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "i2c_check_functionality error\n");
+		return -EIO;
+	}
+
+	bma150 = kzalloc(sizeof(struct bma150_data), GFP_KERNEL);
+	if (!bma150)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, bma150);
+	bma150->client = client;
+	mutex_init(&bma150->mutex);
+	ret = bma150_initialize(client);
+	if (ret < 0)
+		goto kfree_exit;
+
+	pm_runtime_set_active(&client->dev);
+
+	ipoll_dev = input_allocate_polled_device();
+	if (!ipoll_dev) {
+		ret = -ENOMEM;
+		goto kfree_exit;
+	}
+	ipoll_dev->private = bma150;
+	ipoll_dev->open = bma150_open;
+	ipoll_dev->close = bma150_close;
+	ipoll_dev->poll = bma150_poll;
+	ipoll_dev->poll_interval = BMA150_POLL_INTERVAL;
+	ipoll_dev->poll_interval_min = BMA150_POLL_MIN;
+	ipoll_dev->poll_interval_max = BMA150_POLL_MAX;
+
+	idev = ipoll_dev->input;
+	idev->name = DRIVER_NAME;
+	idev->phys = DRIVER_NAME "/input0";
+	idev->id.bustype = BUS_I2C;
+	idev->dev.parent = &client->dev;
+
+	input_set_capability(idev, EV_ABS, ABS_MISC);
+	input_set_abs_params(idev, ABS_X, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+	input_set_abs_params(idev, ABS_Y, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+	input_set_abs_params(idev, ABS_Z, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+
+	ret = input_register_polled_device(ipoll_dev);
+	if (ret < 0) {
+		input_free_polled_device(ipoll_dev);
+		goto kfree_exit;
+	}
+
+	bma150->input_polled = ipoll_dev;
+	bma150->input = idev;
+
+	ret = sysfs_create_group(&bma150->input->dev.kobj,
+			&bma150_attribute_group);
+	if (ret < 0)
+		goto error_sysfs;
+
+	pm_runtime_enable(&client->dev);
+
+	dev_info(&client->dev, "Registered BMA150 I2C driver\n");
+	return 0;
+
+error_sysfs:
+	input_unregister_polled_device(ipoll_dev);
+kfree_exit:
+	kfree(bma150);
+	return ret;
+}
+
+#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
+static int bma150_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return bma150_set_mode(client, BMA150_MODE_SLEEP);
+}
+
+static int bma150_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret = bma150_set_mode(client, BMA150_MODE_NORMAL);
+
+	msleep(2);
+	return ret;
+}
+#endif
+
+static int bma150_remove(struct i2c_client *client)
+{
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	sysfs_remove_group(&bma150->input->dev.kobj, &bma150_attribute_group);
+	input_unregister_polled_device(bma150->input_polled);
+	kfree(bma150);
+
+	return 0;
+}
+
+static const struct dev_pm_ops bma150_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(bma150_suspend, bma150_resume)
+	SET_RUNTIME_PM_OPS(bma150_suspend, bma150_resume, NULL)
+};
+
+static const struct i2c_device_id bma150_id[] = {
+	{ "bma150", 0 },
+	{ "smb380", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, bma150_id);
+
+static struct i2c_driver bma150_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+		.pm	= &bma150_pm,
+	},
+	.class          = I2C_CLASS_HWMON,
+	.id_table	= bma150_id,
+	.probe		= bma150_probe,
+	.remove		= __devexit_p(bma150_remove),
+};
+
+static int __init BMA150_init(void)
+{
+	return i2c_add_driver(&bma150_driver);
+}
+
+static void __exit BMA150_exit(void)
+{
+	i2c_del_driver(&bma150_driver);
+}
+
+MODULE_AUTHOR("Albert Zhang <xu.zhang@bosch-sensortec.com>");
+MODULE_DESCRIPTION("BMA150 driver");
+MODULE_LICENSE("GPL");
+
+module_init(BMA150_init);
+module_exit(BMA150_exit);
+
-- 
1.7.3.4

