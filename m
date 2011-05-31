Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1EaPxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:45 -0400
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:41632 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab1EaPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:41 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        Eric Andersson <eric.andersson@unixphere.com>,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: [PATCH] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Tue, 31 May 2011 17:55:14 +0200
Message-Id: <1306857314-655-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Albert Zhang <xu.zhang@bosch-sensortec.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/input/misc/Kconfig  |   10 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/bma150.c |  554 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 565 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/bma150.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 45dc6aa..9da47fd 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -478,4 +478,14 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
+config INPUT_BMA150
+	tristate "BMA150 acceleration sensor support"
+	depends on I2C
+	help
+	  Say Y here if you have Bosch Sensortec's BMA150 acceleration
+	  sensor hooked to an I2C bus.
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
index 0000000..1a176b2
--- /dev/null
+++ b/drivers/input/misc/bma150.c
@@ -0,0 +1,554 @@
+/*
+ * Copyright (c) 2011 Bosch Sensortec GmbH
+ * Copyright (c) 2011 Unixphere
+ *
+ * This driver adds support for Bosch Sensortec's digital acceleration
+ * sensor BMA150.
+ * The datasheet for the chip can be found here:
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
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/pm.h>
+
+#define SENSOR_NAME		"bma150"
+#define ABSMAX_ACC_VAL		0x01FF
+#define ABSMIN_ACC_VAL		-(ABSMAX_ACC_VAL)
+
+#define BMA150_MAX_DELAY	200
+#define BMA150_RANGE_2G		0
+#define BMA150_RANGE_8G		2
+#define BMA150_BW_50HZ		1
+#define BMA150_BW_1500HZ	6
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
+struct bma150acc {
+	s16	x,
+		y,
+		z;
+};
+
+struct bma150_data {
+	struct i2c_client *bma150_client;
+	atomic_t delay;
+	unsigned char mode;
+	struct input_dev *input;
+	struct bma150acc value;
+	struct mutex mutex;
+	struct delayed_work work;
+};
+
+static int bma150_set_mode(struct i2c_client *client, unsigned char mode)
+{
+	int ret;
+	unsigned char data1, data2;
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	if ((mode != BMA150_MODE_NORMAL) &&
+	    (mode != BMA150_MODE_SLEEP) &&
+	    (mode != BMA150_MODE_WAKE_UP))
+		return -EINVAL;
+
+	data1 = i2c_smbus_read_byte_data(client, BMA150_WAKE_UP_REG);
+	if (data1 < 0)
+		return ret;
+
+	data1 = (data1 & ~BMA150_WAKE_UP_MSK) |
+		((mode << BMA150_WAKE_UP_POS) & BMA150_WAKE_UP_MSK);
+
+	data2 = i2c_smbus_read_byte_data(client, BMA150_SLEEP_REG);
+	if (data2 < 0)
+		return ret;
+
+	data2 = (data2 & ~BMA150_SLEEP_MSK) |
+		(((mode>>1) << BMA150_SLEEP_POS) & BMA150_SLEEP_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_WAKE_UP_REG, data1);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_SLEEP_REG, data2);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&bma150->mutex);
+	bma150->mode = (unsigned char) mode;
+	mutex_unlock(&bma150->mutex);
+	return 0;
+}
+
+
+static int bma150_set_range(struct i2c_client *client, unsigned char range)
+{
+	int ret;
+	unsigned char data;
+
+	if (range > BMA150_RANGE_8G)
+		return -EINVAL;
+
+	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
+	if (data < 0)
+		return ret;
+
+	data = (data & ~BMA150_RANGE_MSK) |
+		((range << BMA150_RANGE_POS) & BMA150_RANGE_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_RANGE_REG, data);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int bma150_get_range(struct i2c_client *client, unsigned char *range)
+{
+	int ret;
+	unsigned char data;
+
+	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
+	if (data < 0)
+		return ret;
+
+	*range = (data & BMA150_RANGE_MSK) >> BMA150_RANGE_POS;
+	return 0;
+}
+
+static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)
+{
+	int ret;
+	unsigned char data;
+
+	if (bw > BMA150_BW_1500HZ)
+		return -EINVAL;
+
+	data = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
+	if (data < 0)
+		return ret;
+
+	data = (data & ~BMA150_BANDWIDTH_MSK) |
+		((bw << BMA150_BANDWIDTH_POS) & BMA150_BANDWIDTH_MSK);
+
+	ret = i2c_smbus_write_byte_data(client, BMA150_BANDWIDTH_REG, data);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int bma150_get_bandwidth(struct i2c_client *client, unsigned char *bw)
+{
+	int ret;
+	unsigned char data;
+
+	data = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
+	if (data < 0)
+		return ret;
+
+	*bw = (data & BMA150_BANDWIDTH_MSK) >> BMA150_BANDWIDTH_POS;
+	return 0;
+}
+
+static int bma150_read_accel_xyz(struct i2c_client *client,
+		struct bma150acc *acc)
+{
+	unsigned char data[6];
+	int ret = i2c_smbus_read_i2c_block_data(client,
+			BMA150_ACC_X_LSB_REG, 6, data);
+	if (ret != 6)
+		return -EIO;
+
+	acc->x = ((0xC0 & data[0]) >> 6) | (data[1] << 2);
+	acc->y = ((0xC0 & data[2]) >> 6) | (data[3] << 2);
+	acc->z = ((0xC0 & data[4]) >> 6) | (data[5] << 2);
+
+	/* sign extension */
+	acc->x = (s16) (acc->x << 6) >> 6;
+	acc->y = (s16) (acc->y << 6) >> 6;
+	acc->z = (s16) (acc->z << 6) >> 6;
+
+	return 0;
+}
+
+static void bma150_work_func(struct work_struct *work)
+{
+	int ret;
+	struct bma150_data *bma150 = container_of((struct delayed_work *)work,
+			struct bma150_data, work);
+	struct bma150acc acc;
+	unsigned long delay = msecs_to_jiffies(atomic_read(&bma150->delay));
+
+	ret = bma150_read_accel_xyz(bma150->bma150_client, &acc);
+	if (ret < 0)
+		return;
+
+	input_report_abs(bma150->input, ABS_X, acc.x);
+	input_report_abs(bma150->input, ABS_Y, acc.y);
+	input_report_abs(bma150->input, ABS_Z, acc.z);
+	input_sync(bma150->input);
+
+	mutex_lock(&bma150->mutex);
+	bma150->value = acc;
+	mutex_unlock(&bma150->mutex);
+
+	schedule_delayed_work(&bma150->work, delay);
+}
+
+static ssize_t bma150_mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%d\n", bma150->mode);
+}
+
+static ssize_t bma150_mode_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int error;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	if (bma150_set_mode(bma150->bma150_client, (unsigned char) data) < 0)
+		return -EINVAL;
+
+	return count;
+}
+static ssize_t bma150_range_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned char data;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	if (bma150_get_range(bma150->bma150_client, &data) < 0)
+		return sprintf(buf, "Read error\n");
+
+	return sprintf(buf, "%d\n", data);
+}
+
+static ssize_t bma150_range_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int error;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+	if (bma150_set_range(bma150->bma150_client, (unsigned char) data) < 0)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t bma150_bandwidth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned char data;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	if (bma150_get_bandwidth(bma150->bma150_client, &data) < 0)
+		return sprintf(buf, "Read error\n");
+
+	return sprintf(buf, "%d\n", data);
+
+}
+
+static ssize_t bma150_bandwidth_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int error;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	if (bma150_set_bandwidth(bma150->bma150_client,
+				(unsigned char) data) < 0)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t bma150_value_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct input_dev *input = to_input_dev(dev);
+	struct bma150_data *bma150 = input_get_drvdata(input);
+
+	return sprintf(buf, "%d %d %d\n", bma150->value.x, bma150->value.y,
+			bma150->value.z);
+}
+
+static ssize_t bma150_delay_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%d\n", atomic_read(&bma150->delay));
+
+}
+
+static ssize_t bma150_delay_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int error;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	if (data > BMA150_MAX_DELAY)
+		data = BMA150_MAX_DELAY;
+
+	atomic_set(&bma150->delay, (unsigned int) data);
+
+	return count;
+}
+
+static DEVICE_ATTR(range, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_range_show, bma150_range_store);
+static DEVICE_ATTR(bandwidth, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_bandwidth_show, bma150_bandwidth_store);
+static DEVICE_ATTR(mode, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_mode_show, bma150_mode_store);
+static DEVICE_ATTR(value, S_IRUGO, bma150_value_show, NULL);
+static DEVICE_ATTR(delay, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_delay_show, bma150_delay_store);
+
+static struct attribute *bma150_attributes[] = {
+	&dev_attr_range.attr,
+	&dev_attr_bandwidth.attr,
+	&dev_attr_mode.attr,
+	&dev_attr_value.attr,
+	&dev_attr_delay.attr,
+	NULL
+};
+
+static struct attribute_group bma150_attribute_group = {
+	.attrs = bma150_attributes
+};
+
+static int bma150_open(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+	int ret = bma150_set_mode(dev->bma150_client, BMA150_MODE_NORMAL);
+	if (ret < 0)
+		return ret;
+	schedule_delayed_work(&dev->work,
+		msecs_to_jiffies(atomic_read(&dev->delay)));
+	return 0;
+}
+
+static void bma150_close(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+	cancel_delayed_work_sync(&dev->work);
+	bma150_set_mode(dev->bma150_client, BMA150_MODE_SLEEP);
+}
+
+static int __devinit bma150_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct bma150_data *data;
+	struct input_dev *dev;
+	int tempvalue;
+	int err = 0;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "i2c_check_functionality error\n");
+		return -EIO;
+	}
+
+	data = kzalloc(sizeof(struct bma150_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	tempvalue = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
+	if (tempvalue != BMA150_CHIP_ID) {
+		dev_err(&client->dev, "BMA150 chip id error: %d\n", tempvalue);
+		err = -EINVAL;
+		goto kfree_exit;
+	}
+	i2c_set_clientdata(client, data);
+	data->bma150_client = client;
+
+	bma150_set_bandwidth(client, BMA150_BW_50HZ);
+	bma150_set_range(client, BMA150_RANGE_2G);
+
+	INIT_DELAYED_WORK(&data->work, bma150_work_func);
+	atomic_set(&data->delay, BMA150_MAX_DELAY);
+
+	dev = input_allocate_device();
+	if (!dev) {
+		err = -ENOMEM;
+		goto kfree_exit;
+	}
+
+	dev->name = SENSOR_NAME;
+	dev->id.bustype = BUS_I2C;
+	dev->open = bma150_open;
+	dev->close = bma150_close;
+
+	input_set_capability(dev, EV_ABS, ABS_MISC);
+	input_set_abs_params(dev, ABS_X, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+	input_set_abs_params(dev, ABS_Y, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+	input_set_abs_params(dev, ABS_Z, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
+	input_set_drvdata(dev, data);
+
+	err = input_register_device(dev);
+	if (err < 0) {
+		input_free_device(dev);
+		goto kfree_exit;
+	}
+
+	data->input = dev;
+
+	err = sysfs_create_group(&data->input->dev.kobj,
+			&bma150_attribute_group);
+	if (err < 0)
+		goto error_sysfs;
+
+	mutex_init(&data->mutex);
+
+	schedule_delayed_work(&data->work,
+			msecs_to_jiffies(atomic_read(&data->delay)));
+
+	dev_info(&client->dev, "Registered BMA150 I2C driver\n");
+	return 0;
+
+error_sysfs:
+	input_unregister_device(dev);
+kfree_exit:
+	kfree(data);
+	return err;
+}
+
+#ifdef CONFIG_PM
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
+
+	return bma150_set_mode(client, BMA150_MODE_NORMAL);
+}
+#endif
+
+static int bma150_remove(struct i2c_client *client)
+{
+	struct bma150_data *data = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&data->input->dev.kobj, &bma150_attribute_group);
+	input_unregister_device(data->input);
+	kfree(data);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(bma150_pm, bma150_suspend,
+			 bma150_resume);
+
+static const struct i2c_device_id bma150_id[] = {
+	{ SENSOR_NAME, 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, bma150_id);
+
+static struct i2c_driver bma150_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= SENSOR_NAME,
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

