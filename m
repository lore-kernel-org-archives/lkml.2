Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab1FWOh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:37:56 -0400
Received: from csmtp2.one.com ([91.198.169.22]:44865 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1FWOhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:37:54 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk,
        Eric Andersson <eric.andersson@unixphere.com>,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: [PATCH v2 1/1] input: add driver for Bosch Sensortec's BMA150 accelerometer
Date: Thu, 23 Jun 2011 16:40:27 +0200
Message-Id: <1308840027-10724-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
References: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Albert Zhang <xu.zhang@bosch-sensortec.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 Documentation/ABI/testing/sysfs-i2c-bma150 |   71 +++
 drivers/input/misc/Kconfig                 |   10 +
 drivers/input/misc/Makefile                |    1 +
 drivers/input/misc/bma150.c                |  684 ++++++++++++++++++++++++++++
 4 files changed, 766 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bma150
 create mode 100644 drivers/input/misc/bma150.c

diff --git a/Documentation/ABI/testing/sysfs-i2c-bma150 b/Documentation/ABI/testing/sysfs-i2c-bma150
new file mode 100644
index 0000000..16ed552
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-i2c-bma150
@@ -0,0 +1,71 @@
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
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/mode
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to set the operational mode of the chip. Possible
+		values are:
+			normal - Sets the sensor in full running mode.
+			sleep  - Sets the sensor in deep sleep.
+			wakeup - Sets the sensor to low-power mode using
+				 sequential sleep period.
+
+		Reading: returns the current operational mode.
+
+		Writing: sets a new operational mode.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/value
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to get the current acceleration values for each
+		axis. The values are represented as (x,y,z), where each axis can
+		hold a value between -512 and 511.
+
+		Reading: returns the current acceleration values.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/delay
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to select the polling rate of the driver. The
+		value is represented in ms and can be between 0 and 200. Any
+		value higher than the maximum will result in the maximum.
+
+		Reading: returns the current poll rate.
+
+		Writing: sets a new poll rate.
+
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/enable
+Date:		May 2011
+Contact:	Eric Andersson <eric.andersson@unixphere.com>
+Description:	This is used to enable and disable the chip. The chip will only
+		be disabled if there are no input device users.
+
+		Reading: returns 1 if chip is enabled and 0 if not.
+
+		Writing: write 1 to enable and 0 to disable the chip.
+
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
index 0000000..596861b
--- /dev/null
+++ b/drivers/input/misc/bma150.c
@@ -0,0 +1,684 @@
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
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/pm.h>
+
+#define SENSOR_NAME		"bma150"
+#define ABSMAX_ACC_VAL		0x01FF
+#define ABSMIN_ACC_VAL		-(ABSMAX_ACC_VAL)
+#define BMA150_MAX_DELAY	200
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
+struct bma150_data {
+	struct i2c_client *bma150_client;
+	unsigned int delay;
+	unsigned int sysfs_enable;
+	unsigned char mode;
+	struct input_dev *input;
+	struct mutex mutex;
+	struct delayed_work work;
+
+	s16 x, y, z;
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
+	{ 1500,	BMA150_BW_1500HZ },
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
+static const struct {
+	char *value;
+	int reg;
+} mode_val[] = {
+	{ "normal",	BMA150_MODE_NORMAL },
+	{ "sleep",	BMA150_MODE_SLEEP },
+	{ "wakeup",	BMA150_MODE_WAKE_UP }
+};
+
+static int bma150_start_polling(struct input_dev *inputdev);
+static void bma150_stop_polling(struct input_dev *inputdev);
+
+static int bma150_set_mode(struct i2c_client *client, unsigned char mode)
+{
+	s32 ret;
+	unsigned char data1, data2;
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
+	if (ret < 0)
+		goto error;
+
+	bma150->mode = (unsigned char) mode;
+error:
+	mutex_unlock(&bma150->mutex);
+	return ret;
+}
+
+static int bma150_set_range(struct i2c_client *client, unsigned char range)
+{
+	s32 ret;
+	unsigned char data;
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
+static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)
+{
+	s32 ret;
+	unsigned char data;
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
+static void bma150_work_func(struct work_struct *work)
+{
+	unsigned char data[6];
+	s16 x, y, z;
+	s32 ret;
+	struct bma150_data *bma150 = container_of((struct delayed_work *)work,
+			struct bma150_data, work);
+	unsigned long delay = msecs_to_jiffies(bma150->delay);
+
+	ret = i2c_smbus_read_i2c_block_data(bma150->bma150_client,
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
+
+	mutex_lock(&bma150->mutex);
+	bma150->x = x;
+	bma150->y = y;
+	bma150->z = z;
+	mutex_unlock(&bma150->mutex);
+
+	schedule_delayed_work(&bma150->work, delay);
+}
+
+static ssize_t bma150_mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int len;
+	int i;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	for (i = 0, len = 0; i < ARRAY_SIZE(mode_val); i++)
+		len += sprintf(buf + len,
+			(bma150->mode == mode_val[i].reg) ? "[%s] " : "%s ",
+			mode_val[i].value);
+
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+
+static ssize_t bma150_mode_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int i;
+	int ret;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	for (i = 0; i < ARRAY_SIZE(mode_val); i++)
+		if (strncmp(mode_val[i].value, buf,
+			    strlen(mode_val[i].value)) == 0) {
+			ret = bma150_set_mode(bma150->bma150_client,
+					      mode_val[i].reg);
+			if (ret < 0)
+				return ret;
+			return count;
+		}
+
+	return -EINVAL;
+}
+static ssize_t bma150_range_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	int i;
+	int range;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	range = bma150_get_range(bma150->bma150_client);
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
+	int error;
+	int i;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	for (i = 0; i < ARRAY_SIZE(range_val); i++)
+		if (range_val[i].value == data) {
+			error = bma150_set_range(bma150->bma150_client,
+						 range_val[i].reg);
+			if (error < 0)
+				return error;
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
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	bw = bma150_get_bandwidth(bma150->bma150_client);
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
+	int error;
+	int i;
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	for (i = 0; i < ARRAY_SIZE(bw_val); i++)
+		if (bw_val[i].value == data) {
+			error = bma150_set_bandwidth(bma150->bma150_client,
+						     bw_val[i].reg);
+			if (error < 0)
+				return error;
+			return count;
+		}
+
+	return -EINVAL;
+}
+
+static ssize_t bma150_value_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct input_dev *input = to_input_dev(dev);
+	struct bma150_data *bma150 = input_get_drvdata(input);
+
+	return sprintf(buf, "(%d,%d,%d)\n", bma150->x, bma150->y,
+			bma150->z);
+}
+
+static ssize_t bma150_delay_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%d\n", bma150->delay);
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
+	mutex_lock(&bma150->mutex);
+	bma150->delay = data;
+	mutex_unlock(&bma150->mutex);
+
+	return count;
+}
+
+static ssize_t bma150_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct input_dev *input = to_input_dev(dev);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%d\n",
+		      !!(bma150->sysfs_enable || input->users));
+}
+
+static ssize_t bma150_enable_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	unsigned long data;
+	int error;
+	struct input_dev *input = to_input_dev(dev);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct bma150_data *bma150 = i2c_get_clientdata(client);
+
+	error = strict_strtoul(buf, 10, &data);
+	if (error)
+		return error;
+
+	if (input->users)
+		goto exit;
+
+	if (data)
+		bma150_start_polling(input);
+	else
+		bma150_stop_polling(input);
+
+exit:
+	mutex_lock(&bma150->mutex);
+	bma150->sysfs_enable = !!data;
+	mutex_unlock(&bma150->mutex);
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
+static DEVICE_ATTR(enable, S_IRUGO|S_IWUSR|S_IWGRP,
+		bma150_enable_show, bma150_enable_store);
+
+static struct attribute *bma150_attributes[] = {
+	&dev_attr_range.attr,
+	&dev_attr_bandwidth.attr,
+	&dev_attr_mode.attr,
+	&dev_attr_value.attr,
+	&dev_attr_delay.attr,
+	&dev_attr_enable.attr,
+	NULL
+};
+
+static struct attribute_group bma150_attribute_group = {
+	.attrs = bma150_attributes
+};
+
+static int bma150_start_polling(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+	int ret = bma150_set_mode(dev->bma150_client, BMA150_MODE_NORMAL);
+	if (ret < 0)
+		return ret;
+
+	schedule_delayed_work(&dev->work, msecs_to_jiffies(dev->delay));
+	return 0;
+}
+
+static void bma150_stop_polling(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+	cancel_delayed_work_sync(&dev->work);
+	bma150_set_mode(dev->bma150_client, BMA150_MODE_SLEEP);
+}
+
+static int bma150_open(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+
+	if (!dev->sysfs_enable)
+		return bma150_start_polling(inputdev);
+
+	return 0;
+}
+
+static void bma150_close(struct input_dev *inputdev)
+{
+	struct bma150_data *dev = input_get_drvdata(inputdev);
+
+	if (!dev->sysfs_enable)
+		bma150_stop_polling(inputdev);
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
+	mutex_init(&data->mutex);
+
+	bma150_set_bandwidth(client, BMA150_BW_50HZ);
+	bma150_set_range(client, BMA150_RANGE_2G);
+
+	INIT_DELAYED_WORK(&data->work, bma150_work_func);
+	data->delay = BMA150_MAX_DELAY;
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

