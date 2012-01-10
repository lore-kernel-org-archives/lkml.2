Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2AJBag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:30:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40068 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab2AJBae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:30:34 -0500
From: Ameya Palande <ameya.palande@ti.com>
To: <greg@kroah.com>
CC: <arnd@arndb.de>, <ameya.palande@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Texas Instruments DRV2665 Piezo Haptics Driver
Date: Mon, 9 Jan 2012 17:30:27 -0800
Message-ID: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Texas Instruments's DRV2665 is a piezo haptic driver which is capable of
driving both high-voltage and low-voltage piezo haptic actuators.

Signed-off-by: Ameya Palande <ameya.palande@ti.com>
---
 MAINTAINERS               |    5 +
 drivers/misc/Kconfig      |    7 +
 drivers/misc/Makefile     |    1 +
 drivers/misc/ti_drv2665.c |  448 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 461 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ti_drv2665.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e7d904..19acfaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2343,6 +2343,11 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+DRV2665 PIEZO HAPTICS DRIVER
+M:	Ameya Palande <ameya.palande@ti.com>
+S:	Maintained
+F:	drivers/misc/ti_drv2665.c
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 5664696..e3ba6c2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -500,6 +500,13 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config TI_DRV2665
+	tristate "Texas Instruments DRV2665 Piezo Haptic Driver"
+	depends on I2C && SYSFS
+	help
+	  If you say yes here you get support for the Texas Instruments
+	  DRV2665 Piezo Haptic Driver.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index b26495a..d1f1645 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -48,3 +48,4 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_TI_DRV2665)	+= ti_drv2665.o
diff --git a/drivers/misc/ti_drv2665.c b/drivers/misc/ti_drv2665.c
new file mode 100644
index 0000000..ac31825
--- /dev/null
+++ b/drivers/misc/ti_drv2665.c
@@ -0,0 +1,448 @@
+/*
+ *  ti_drv2665.c - Texas Instruments DRV2665 piezo haptic driver
+ *
+ *  Copyright (C) 2011 Texas Instruments
+ *
+ *  Contact: Ameya Palande <ameya.palande@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#define DRV2665_DRV_NAME			"ti_drv2665"
+#define DRV2665_I2C_ADDRESS			0x59
+#define DRV2665_CHIP_ID				0x05
+#define DRV2665_AUTOSUSPEND_DELAY		5000
+#define DRV2665_FIFO_DEPTH			100
+
+#define DRV2665_STATUS_REG			0x00
+#define		DRV2665_STATUS_MASK		0x03
+#define DRV2665_CONTROL_REG			0x01
+#define		DRV2665_ID_MASK			0x78
+#define		DRV2665_ID_SHIFT		0x03
+#define		DRV2665_CONTROL_WRITE_MASK	0x07
+#define DRV2665_CONTROL2_REG			0x02
+#define		DRV2665_DEV_RST_SHIFT		0x07
+#define		DRV2665_DEV_RST			(1 << DRV2665_DEV_RST_SHIFT)
+#define		DRV2665_STANDBY_SHIFT		0x06
+#define		DRV2665_STANDBY			(1 << DRV2665_STANDBY_SHIFT)
+#define		DRV2665_TIMEOUT_SHIFT		0x02
+#define		DRV2665_05MS_TIMEOUT		0x00
+#define		DRV2665_10MS_TIMEOUT		0x01
+#define		DRV2665_15MS_TIMEOUT		0x02
+#define		DRV2665_20MS_TIMEOUT		0x03
+#define DRV2665_FIFO_REG			0x0B
+
+struct drv2665_data {
+	struct mutex lock;
+	/* DRV2665 cached registers */
+	u8 control;
+	u8 control2;
+	/* DRV2665_FIFO_DEPTH + additional 1 byte for fifo command register */
+	u8 fifo_buff[DRV2665_FIFO_DEPTH + 1];
+};
+
+static int drv2665_read_byte(struct device *dev, u8 reg, const char *reg_name)
+{
+	int val;
+
+	val = i2c_smbus_read_byte_data(to_i2c_client(dev), reg);
+	if (val < 0)
+		dev_err(dev, "error reading %s register\n", reg_name);
+
+	return val;
+}
+
+static int drv2665_write_byte(struct device *dev, u8 reg, u8 data,
+		const char *reg_name)
+{
+	int status;
+
+	status = i2c_smbus_write_byte_data(to_i2c_client(dev), reg, data);
+	if (status < 0)
+		dev_err(dev, "error writing %s register\n", reg_name);
+
+	return status;
+}
+
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	int val;
+
+	val = drv2665_read_byte(dev, DRV2665_STATUS_REG, "status");
+	if (val < 0)
+		return val;
+
+	return sprintf(buf, "%x\n", val & DRV2665_STATUS_MASK);
+}
+static DEVICE_ATTR(status, S_IRUGO, status_show, NULL);
+
+static ssize_t fifo_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int status;
+	struct i2c_client *client;
+	struct drv2665_data *data;
+
+	/*
+	 * make sure that count is between 1 and DRV2665_FIFO_DEPTH both
+	 * inclusive
+	 */
+	if (count < 1)
+		return -EINVAL;
+	if (count > DRV2665_FIFO_DEPTH)
+		return -ENOSPC;
+
+	client = to_i2c_client(dev);
+	data = i2c_get_clientdata(client);
+
+	pm_runtime_get_sync(dev);
+	mutex_lock(&data->lock);
+
+	/* DRV2665 FIFO Register Address */
+	data->fifo_buff[0] = DRV2665_FIFO_REG;
+
+	/* fill remaining fifo_buff with data from user space */
+	memcpy(data->fifo_buff + 1, buf, count);
+
+	status = i2c_master_send(client, data->fifo_buff, count + 1);
+
+	mutex_unlock(&data->lock);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	if (status < 0) {
+		/* i2c_master_send() error condition */
+		return status;
+	}
+
+	/*
+	 * subtract DRV2665_FIFO_REG byte from successfully
+	 * transferred bytes
+	 */
+	return status - 1;
+}
+static DEVICE_ATTR(fifo, S_IWUSR, NULL, fifo_store);
+
+static ssize_t control_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int val;
+
+	val = drv2665_read_byte(dev, DRV2665_CONTROL_REG, "control");
+	if (val < 0)
+		return val;
+
+	return sprintf(buf, "%x\n", val);
+}
+
+static ssize_t control_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	u8 val;
+	int status;
+	struct drv2665_data *data;
+	ssize_t ret_value;
+
+	data = dev_get_drvdata(dev);
+
+	status = kstrtou8(buf, 16, &val);
+	if (status)
+		return status;
+
+	mutex_lock(&data->lock);
+
+	status = drv2665_write_byte(dev, DRV2665_CONTROL_REG,
+			val & DRV2665_CONTROL_WRITE_MASK, "control");
+	if (status < 0) {
+		ret_value = status;
+	} else {
+		/* cache DRV2665_CONTROL_REG value */
+		data->control = val & DRV2665_CONTROL_WRITE_MASK;
+		ret_value = 1;
+	}
+
+	mutex_unlock(&data->lock);
+
+	return ret_value;
+}
+static DEVICE_ATTR(control, S_IRUGO | S_IWUSR, control_show, control_store);
+
+static ssize_t control2_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int val;
+
+	val = drv2665_read_byte(dev, DRV2665_CONTROL2_REG, "control2");
+	if (val < 0)
+		return val;
+
+	return sprintf(buf, "%x\n", val);
+}
+
+static ssize_t control2_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	u8 val;
+	int status;
+	struct drv2665_data *data;
+	ssize_t ret_value;
+
+	data = dev_get_drvdata(dev);
+
+	status = kstrtou8(buf, 16, &val);
+	if (status)
+		return status;
+
+	mutex_lock(&data->lock);
+
+	status = drv2665_write_byte(dev, DRV2665_CONTROL2_REG, val, "control2");
+	if (status < 0) {
+		ret_value = status;
+	} else {
+		/* cache DRV2665_CONTROL2_REG value */
+		data->control2 = val;
+		ret_value = 1;
+	}
+
+	mutex_unlock(&data->lock);
+
+	return ret_value;
+}
+static DEVICE_ATTR(control2, S_IRUGO | S_IWUSR, control2_show, control2_store);
+
+static ssize_t reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	u8 val;
+	int status;
+	struct drv2665_data *data;
+
+	data = dev_get_drvdata(dev);
+
+	status = kstrtou8(buf, 16, &val);
+	if (status)
+		return status;
+
+	if (val != 1)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+	status = drv2665_write_byte(dev, DRV2665_CONTROL2_REG,
+			DRV2665_DEV_RST, "control2");
+	mutex_unlock(&data->lock);
+
+	if (status < 0)
+		return status;
+
+	return 1;
+}
+static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
+
+
+static struct attribute *drv2665_attributes[] = {
+	&dev_attr_reset.attr,
+	&dev_attr_control2.attr,
+	&dev_attr_control.attr,
+	&dev_attr_status.attr,
+	&dev_attr_fifo.attr,
+	NULL
+};
+
+static const struct attribute_group drv2665_attr_group = {
+	.attrs = drv2665_attributes,
+};
+
+#ifdef CONFIG_PM
+static int drv2665_suspend(struct device *dev)
+{
+	struct drv2665_data *data;
+	int status;
+
+	data = dev_get_drvdata(dev);
+	mutex_lock(&data->lock);
+	status = drv2665_write_byte(dev, DRV2665_CONTROL2_REG,
+			DRV2665_STANDBY, "control2");
+	mutex_unlock(&data->lock);
+
+	return status;
+}
+
+static int drv2665_resume(struct device *dev)
+{
+	struct drv2665_data *data;
+	int status;
+
+	data = dev_get_drvdata(dev);
+
+	mutex_lock(&data->lock);
+	/* restore cached control2 register */
+	status = drv2665_write_byte(dev, DRV2665_CONTROL2_REG,
+			data->control2, "control2");
+	if (status < 0)
+		goto exit;
+
+	/* if needed restore cached control register */
+	if (data->control)
+		status = drv2665_write_byte(dev, DRV2665_CONTROL2_REG,
+				data->control, "control");
+
+exit:
+	mutex_unlock(&data->lock);
+
+	return status;
+}
+#endif
+
+static int __devinit drv2665_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	int status;
+	struct drv2665_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		status = -ENOMEM;
+		dev_err(&client->dev, "%s: kzalloc failed\n", __func__);
+		goto exit;
+	}
+
+	/* register sysfs hooks */
+	status = sysfs_create_group(&client->dev.kobj, &drv2665_attr_group);
+	if (status) {
+		dev_err(&client->dev, "sysfs_create_group failed\n");
+		goto exit_free;
+	}
+
+	/*
+	 * turn on the chip with max timeout of 20ms
+	 * save this configuration in dev->control2
+	 */
+	data->control2 = DRV2665_20MS_TIMEOUT << DRV2665_TIMEOUT_SHIFT;
+	status = drv2665_write_byte(&client->dev, DRV2665_CONTROL2_REG,
+			data->control2, "control2");
+	if (status < 0)
+		goto exit_sysfs;
+
+
+	mutex_init(&data->lock);
+	i2c_set_clientdata(client, data);
+	dev_info(&client->dev, "initialized successfully\n");
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev,
+			DRV2665_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&client->dev);
+	pm_runtime_enable(&client->dev);
+
+	return 0;
+
+exit_sysfs:
+	sysfs_remove_group(&client->dev.kobj, &drv2665_attr_group);
+exit_free:
+	kfree(data);
+exit:
+	return status;
+}
+
+static int __devexit drv2665_remove(struct i2c_client *client)
+{
+	struct drv2665_data *data;
+
+	data = i2c_get_clientdata(client);
+
+	/* unregister sysfs hooks */
+	sysfs_remove_group(&client->dev.kobj, &drv2665_attr_group);
+
+	pm_runtime_get_sync(&client->dev);
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
+	mutex_destroy(&data->lock);
+	kfree(data);
+	return 0;
+}
+
+static int drv2665_detect(struct i2c_client *client,
+		struct i2c_board_info *info)
+{
+	int val;
+
+	if (!i2c_check_functionality(client->adapter,
+				I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	val = drv2665_read_byte(&client->dev, DRV2665_CONTROL_REG, "control");
+	if (val < 0)
+		return -ENODEV;
+
+	val = (val & DRV2665_ID_MASK) >> DRV2665_ID_SHIFT;
+
+	if (val != DRV2665_CHIP_ID)
+		return -ENODEV;
+	else
+		strlcpy(info->type, DRV2665_DRV_NAME, I2C_NAME_SIZE);
+
+	return 0;
+}
+
+static UNIVERSAL_DEV_PM_OPS(drv2665_pm_ops, drv2665_suspend, drv2665_resume,
+		NULL);
+
+static const struct i2c_device_id drv2665_id[] = {
+	{ DRV2665_DRV_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, drv2665_id);
+
+static const unsigned short normal_i2c[] = { DRV2665_I2C_ADDRESS,
+						I2C_CLIENT_END };
+
+static struct i2c_driver drv2665_driver = {
+	.driver = {
+		.name	= DRV2665_DRV_NAME,
+		.pm	= &drv2665_pm_ops,
+	},
+	.id_table	= drv2665_id,
+	.class		= I2C_CLASS_HWMON,
+	.probe		= drv2665_probe,
+	.detect		= drv2665_detect,
+	.address_list	= normal_i2c,
+	.remove		= __devexit_p(drv2665_remove),
+};
+
+static int __init drv2665_init(void)
+{
+	return i2c_add_driver(&drv2665_driver);
+}
+
+static void __exit drv2665_exit(void)
+{
+	i2c_del_driver(&drv2665_driver);
+}
+
+module_init(drv2665_init);
+module_exit(drv2665_exit);
+
+MODULE_AUTHOR("Ameya Palande <ameya.palande@ti.com>");
+MODULE_DESCRIPTION("DRV2665 Piezo Haptic Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4.1

