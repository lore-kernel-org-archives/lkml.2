Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1IIIYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:24:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48798 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab1IIIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:24:10 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-ac-4e69cd283a22
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de,
        jic23@cam.ac.kr, kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH v2] misc: Add driver for GP2AP002 proximity/ambient light sensor
Date: Fri, 09 Sep 2011 17:22:26 +0900
Message-id: <1315556546-7445-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 09 Sep 2011 08:24:42.0403 (UTC)
 FILETIME=[EC9BFF30:01CC6EC9]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SHARP GP2AP002 is proximity and ambient light sensor.
This patch supports it.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes for v2
  - changed to expose lux
  - changed request_irq to request_threaded_irq function
  - added sysfs_notify function call
  - cleaned up code

 Documentation/misc-devices/gp2ap002    |   44 +++
 drivers/misc/Kconfig                   |   10 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/gp2ap002.c                |  488 ++++++++++++++++++++++++++++++++
 include/linux/platform_data/gp2ap002.h |   69 +++++
 5 files changed, 612 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/gp2ap002
 create mode 100644 drivers/misc/gp2ap002.c
 create mode 100644 include/linux/platform_data/gp2ap002.h

diff --git a/Documentation/misc-devices/gp2ap002 b/Documentation/misc-devices/gp2ap002
new file mode 100644
index 0000000..3187740
--- /dev/null
+++ b/Documentation/misc-devices/gp2ap002
@@ -0,0 +1,44 @@
+Kernel driver gp2ap002
+=================
+
+Supported chips:
+* SHARP GP2AP002A00F proximity and ambient light sensor
+  Datasheet: Not publicly available
+
+Authors: Donggeun Kim <dg77.kim@samsung.com>
+	 Minkyu Kang <mk7.kang@samsung.com>
+
+Description
+-----------
+GP2AP002A00F is a proximity and ambient light sensor.
+The proximity sensor operates in a normal or interrupt mode.
+1. Normal mode: read the register regarding proximity register
+2. Interrupt mode: the chip generates interrupts
+	whenever object is detected or not detected
+The proximity state can be obtained from VO field of PROX register
+	1 = object is detected (value of VO field)
+	0 = object is not detected (value of VO field)
+
+This chip only exports current as the result of ambient light sensor.
+To get illuminance, CPU measures the current exported
+from the sensor through ADC.
+The relationship between current and illuminance is as follows:
+	illuminance = 10^(current/10)  - (1)
+This driver exposes illuminance
+by looking up the current-illuminance mapping table.
+
+Sysfs Interface
+---------------
+prox0_input	proximity sensor result
+		0: object is not detected
+		1: object is detected
+		RO
+
+lux0_input	ambient light sensor result
+		unit: lux
+		RO
+
+power_state	enable/disable the sensor
+		1: enable
+		0: disable
+		RW
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2d6423c..576e386 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,16 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config GP2AP002
+	tristate "SHARP GP2AP002 proximity/ambient light sensor"
+	depends on I2C
+	help
+	 Say Y here if you want to support Sharp GP2AP002
+	 proximity/ambient light sensor.
+
+	 To compile this driver as a module, choose M here: the
+	 module will be called GP2AP002.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 8f3efb6..7929c26 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -47,3 +47,4 @@ obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
+obj-$(CONFIG_GP2AP002)		+= gp2ap002.o
diff --git a/drivers/misc/gp2ap002.c b/drivers/misc/gp2ap002.c
new file mode 100644
index 0000000..7ce5b37
--- /dev/null
+++ b/drivers/misc/gp2ap002.c
@@ -0,0 +1,488 @@
+/*
+ *  gp2ap002.c - SHARP GP2AP002 proximity/ambient light sensor
+ *
+ *  Copyright (C) 2010 Samsung Electronics
+ *  Minkyu Kang <mk7.kang@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+
+#include <linux/platform_data/gp2ap002.h>
+
+#define GP2AP002_PROX		0x00
+#define GP2AP002_GAIN		0x01
+#define GP2AP002_HYS		0x02
+#define GP2AP002_CYCLE		0x03
+#define GP2AP002_OPMOD		0x04
+#define GP2AP002_CON		0x06
+
+#define PROX_VO_NO_DETECT	(0 << 0)
+#define PROX_VO_DETECT		(1 << 0)
+
+#define GAIN_LED_SHIFT		(3)
+#define GAIN_LED_MASK		(0x1 << GAIN_LED_SHIFT)
+
+#define HYS_HYSD_SHIFT		(7)
+#define HYS_HYSD_MASK		(0x1 << HYS_HYSD_SHIFT)
+#define HYS_HYSC_SHIFT		(5)
+#define HYS_HYSC_MASK		(0x3 << HYS_HYSC_SHIFT)
+#define HYS_HYSF_SHIFT		(0)
+#define HYS_HYSF_MASK		(0xf << HYS_HYSF_SHIFT)
+
+#define CYCLE_CYCL_SHIFT	(3)
+#define CYCLE_CYCL_MASK		(0x7 << CYCLE_CYCL_SHIFT)
+#define CYCLE_OSC_SHIFT		(2)
+#define CYCLE_OSC_MASK		(0x1 << CYCLE_OSC_SHIFT)
+
+#define OPMOD_ASD_SHIFT		(4)
+#define OPMOD_ASD_MASK		(0x1 << OPMOD_ASD_SHIFT)
+#define OPMOD_SSD_SHUTDOWN	(0)
+#define OPMOD_SSD_OPERATING	(1)
+#define OPMOD_VCON_SHIFT	(1)
+#define OPMOD_VCON_MASK		(0x1 << OPMOD_VCON_SHIFT)
+#define OPMOD_VCON_NORMAL	(0 << 1)
+#define OPMOD_VCON_IRQ		(1 << 1)
+
+#define CON_OCON_SHIFT		(3)
+#define CON_OCON_MASK		(0x3 << CON_OCON_SHIFT)
+
+struct illuminance {
+	unsigned int	curr;
+	unsigned int	lux;
+};
+
+/*
+ * This array maps current and lux.
+ * Ambient light sensing range is 3 to 55000.
+ * This mapping is based on the following formula.
+ * illuminance = 10 ^ (current / 10)
+ */
+const struct illuminance illuminance_table[] = {
+	{ .curr		= 5, .lux	= 3 },
+	{ .curr		= 6, .lux	= 4 },
+	{ .curr		= 7, .lux	= 5 },
+	{ .curr		= 8, .lux	= 6 },
+	{ .curr		= 9, .lux	= 8 },
+	{ .curr		= 10, .lux	= 10 },
+	{ .curr		= 11, .lux	= 12 },
+	{ .curr		= 12, .lux	= 16 },
+	{ .curr		= 13, .lux	= 20 },
+	{ .curr		= 14, .lux	= 25 },
+	{ .curr		= 15, .lux	= 32 },
+	{ .curr		= 16, .lux	= 40 },
+	{ .curr		= 17, .lux	= 50 },
+	{ .curr		= 18, .lux	= 63 },
+	{ .curr		= 19, .lux	= 79 },
+	{ .curr		= 20, .lux	= 100 },
+	{ .curr		= 21, .lux	= 126 },
+	{ .curr		= 22, .lux	= 158 },
+	{ .curr		= 23, .lux	= 200 },
+	{ .curr		= 24, .lux	= 251 },
+	{ .curr		= 25, .lux	= 316 },
+	{ .curr		= 26, .lux	= 398 },
+	{ .curr		= 27, .lux	= 501 },
+	{ .curr		= 28, .lux	= 631 },
+	{ .curr		= 29, .lux	= 794 },
+	{ .curr		= 30, .lux	= 1000 },
+	{ .curr		= 31, .lux	= 1259 },
+	{ .curr		= 32, .lux	= 1585 },
+	{ .curr		= 33, .lux	= 1995 },
+	{ .curr		= 34, .lux	= 2512 },
+	{ .curr		= 35, .lux	= 3162 },
+	{ .curr		= 36, .lux	= 3981 },
+	{ .curr		= 37, .lux	= 5012 },
+	{ .curr		= 38, .lux	= 6310 },
+	{ .curr		= 39, .lux	= 7943 },
+	{ .curr		= 40, .lux	= 10000 },
+	{ .curr		= 41, .lux	= 12589 },
+	{ .curr		= 42, .lux	= 15849 },
+	{ .curr		= 43, .lux	= 19953 },
+	{ .curr		= 44, .lux	= 25119 },
+	{ .curr		= 45, .lux	= 31623 },
+	{ .curr		= 46, .lux	= 39811 },
+	{ .curr		= 47, .lux	= 50119 },
+};
+
+struct gp2ap002_chip {
+	struct i2c_client	*client;
+	struct work_struct	work;
+	struct mutex		lock;
+
+	struct gp2ap002_platform_data *pdata;
+
+	bool enabled;
+
+	/* Proximity */
+	int proximity;
+
+	/* Ambient Light */
+	int adc;
+	int lux;
+};
+
+static void gp2ap002_get_proximity(struct gp2ap002_chip *chip)
+{
+	/* Determine whether the object is detected
+	   by reading GP2AP002_PROX register */
+	chip->proximity = i2c_smbus_read_byte_data(chip->client,
+				GP2AP002_PROX) & PROX_VO_DETECT;
+}
+
+static int gp2ap002_chip_enable(struct gp2ap002_chip *chip, bool enable)
+{
+	struct gp2ap002_platform_data *pdata = chip->pdata;
+	int ret;
+	u8 value;
+
+	if (enable == chip->enabled)
+		return 0;
+
+	value = (pdata->analog_sleep << OPMOD_ASD_SHIFT) |
+		(pdata->prox_mode << OPMOD_VCON_SHIFT);
+	/* software shutdown mode */
+	if (enable)
+		value |= OPMOD_SSD_OPERATING;
+	else /* operating mode */
+		value |= OPMOD_SSD_SHUTDOWN;
+
+	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_OPMOD, value);
+	if (ret < 0)
+		goto out;
+
+	chip->enabled = enable;
+out:
+	return ret;
+}
+
+static void gp2ap002_work(struct work_struct *work)
+{
+	struct gp2ap002_chip *chip = container_of(work,
+			struct gp2ap002_chip, work);
+
+	mutex_lock(&chip->lock);
+	gp2ap002_get_proximity(chip);
+
+	kobject_uevent(&chip->client->dev.kobj, KOBJ_CHANGE);
+	sysfs_notify(&chip->client->dev.kobj, NULL, "prox0_input");
+	mutex_unlock(&chip->lock);
+
+	enable_irq(chip->client->irq);
+}
+
+static irqreturn_t gp2ap002_irq(int irq, void *data)
+{
+	struct gp2ap002_chip *chip = data;
+
+	disable_irq_nosync(irq);
+	schedule_work(&chip->work);
+
+	return IRQ_HANDLED;
+}
+
+static int lookup_lux(int curr)
+{
+	int start, end, mid = -1;
+	int table_size = ARRAY_SIZE(illuminance_table);
+
+	/* Do a binary search on illuminance table */
+	start = 0;
+	end = table_size;
+
+	while (end > start) {
+		mid = start + (end - start) / 2;
+		if (illuminance_table[mid].curr < curr)
+			end = mid;
+		else if (illuminance_table[mid].curr > curr)
+			start = mid + 1;
+		else
+			return mid;
+	}
+
+	return -ENODATA;
+}
+
+static ssize_t gp2ap002_show_proximity(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct gp2ap002_chip *chip = dev_get_drvdata(dev);
+
+	mutex_lock(&chip->lock);
+	gp2ap002_get_proximity(chip);
+	mutex_unlock(&chip->lock);
+
+	if (chip->proximity < 0)
+		return chip->proximity;
+	return sprintf(buf, "%d\n", chip->proximity);
+}
+static DEVICE_ATTR(prox0_input, S_IRUGO, gp2ap002_show_proximity, NULL);
+
+static ssize_t gp2ap002_show_lux(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct gp2ap002_chip *chip = dev_get_drvdata(dev);
+	struct gp2ap002_platform_data *pdata = chip->pdata;
+	int ret;
+
+	if (pdata->get_adc) {
+		mutex_lock(&chip->lock);
+		chip->adc = pdata->get_adc();
+		ret = lookup_lux(chip->adc);
+		if (ret < 0) {
+			mutex_unlock(&chip->lock);
+			return ret;
+		}
+		chip->lux = illuminance_table[ret].lux;
+		mutex_unlock(&chip->lock);
+	}
+	return sprintf(buf, "%d\n", chip->lux);
+}
+static DEVICE_ATTR(lux0_input, S_IRUGO, gp2ap002_show_lux, NULL);
+
+static ssize_t gp2ap002_store_enable(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct gp2ap002_chip *chip = dev_get_drvdata(dev);
+	unsigned long value;
+	int ret;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	ret = gp2ap002_chip_enable(chip, !!value);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+static ssize_t gp2ap002_show_enable(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gp2ap002_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", chip->enabled);
+}
+static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
+		gp2ap002_show_enable, gp2ap002_store_enable);
+
+static struct attribute *gp2ap002_attributes[] = {
+	&dev_attr_prox0_input.attr,
+	&dev_attr_lux0_input.attr,
+	&dev_attr_power_state.attr,
+	NULL
+};
+
+static const struct attribute_group gp2ap002_attribute_group = {
+	.attrs = gp2ap002_attributes,
+};
+
+static int gp2ap002_initialize(struct gp2ap002_chip *chip)
+{
+	struct gp2ap002_platform_data *pdata = chip->pdata;
+	int ret;
+	u8 value;
+
+	/* GAIN register */
+	value = (pdata->led_mode << GAIN_LED_SHIFT) & GAIN_LED_MASK;
+	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_GAIN, value);
+	if (ret < 0)
+		goto out;
+
+	/* HYS register */
+	value = (pdata->hysd << HYS_HYSD_SHIFT) & HYS_HYSD_MASK;
+	value |= (pdata->hysc << HYS_HYSC_SHIFT) & HYS_HYSC_MASK;
+	value |= (pdata->hysf << HYS_HYSF_SHIFT) & HYS_HYSF_MASK;
+	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_HYS, value);
+	if (ret < 0)
+		goto out;
+
+	/* CYCLE register */
+	value = (pdata->cycle << CYCLE_CYCL_SHIFT) & CYCLE_CYCL_MASK;
+	value |= (pdata->oscillator << CYCLE_OSC_SHIFT) & CYCLE_OSC_MASK;
+	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_CYCLE, value);
+	if (ret < 0)
+		goto out;
+
+	/* CON register */
+	value = (pdata->vout_control << CON_OCON_SHIFT) & CON_OCON_MASK;
+	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_CYCLE, value);
+out:
+	return ret;
+}
+
+static int __devinit gp2ap002_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	struct gp2ap002_chip *chip;
+	struct gp2ap002_platform_data *pdata;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev, "No platform init data supplied\n");
+		return -ENODEV;
+	}
+
+	chip = kzalloc(sizeof(struct gp2ap002_chip), GFP_KERNEL);
+	if (!chip) {
+		dev_err(&client->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
+
+	if (client->irq > 0) {
+		ret = request_threaded_irq(client->irq, NULL, gp2ap002_irq,
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			"GP2AP002 sensor", chip);
+		if (ret) {
+			dev_err(&client->dev, "Failed to request irq: %d\n",
+				client->irq);
+			goto error_irq;
+		}
+	}
+
+	chip->client = client;
+	i2c_set_clientdata(client, chip);
+	INIT_WORK(&chip->work, gp2ap002_work);
+	mutex_init(&chip->lock);
+	chip->pdata = pdata;
+
+	ret = sysfs_create_group(&client->dev.kobj, &gp2ap002_attribute_group);
+	if (ret) {
+		dev_err(&client->dev,
+			"Failed to create attribute group\n");
+		goto error_sysfs_group;
+	}
+
+	if (pdata->power_enable)
+		pdata->power_enable(true);
+
+	ret = gp2ap002_initialize(chip);
+	if (ret) {
+		dev_err(&client->dev, "Failed to initialize chip\n");
+		goto error_chip_initialize;
+	}
+
+	ret = gp2ap002_chip_enable(chip, pdata->chip_enable);
+	if (ret) {
+		dev_err(&client->dev, "Failed to enable chip\n");
+		goto error_chip_enable;
+	}
+
+	dev_info(&client->dev, "%s registered\n", id->name);
+	return 0;
+
+error_chip_enable:
+error_chip_initialize:
+	sysfs_remove_group(&client->dev.kobj, &gp2ap002_attribute_group);
+error_sysfs_group:
+	if (client->irq > 0)
+		free_irq(client->irq, chip);
+error_irq:
+	kfree(chip);
+	return ret;
+}
+
+static int __devexit gp2ap002_remove(struct i2c_client *client)
+{
+	struct gp2ap002_chip *chip = i2c_get_clientdata(client);
+
+	disable_irq_nosync(client->irq);
+	cancel_work_sync(&chip->work);
+
+	if (client->irq > 0)
+		free_irq(client->irq, chip);
+
+	sysfs_remove_group(&client->dev.kobj, &gp2ap002_attribute_group);
+
+	gp2ap002_chip_enable(chip, false);
+
+	if (chip->pdata->power_enable)
+		chip->pdata->power_enable(false);
+
+	kfree(chip);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int gp2ap002_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct gp2ap002_chip *chip = i2c_get_clientdata(client);
+
+	cancel_work_sync(&chip->work);
+	gp2ap002_chip_enable(chip, false);
+
+	if (chip->pdata->power_enable)
+		chip->pdata->power_enable(false);
+
+	return 0;
+}
+
+static int gp2ap002_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct gp2ap002_chip *chip = i2c_get_clientdata(client);
+
+	if (chip->pdata->power_enable)
+		chip->pdata->power_enable(true);
+
+	gp2ap002_chip_enable(chip, true);
+
+	return 0;
+}
+#else
+#define gp2ap002_suspend NULL
+#define gp2ap002_resume NULL
+#endif
+
+static const struct i2c_device_id gp2ap002_id[] = {
+	{ "GP2AP002", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, gp2ap002_id);
+
+static const struct dev_pm_ops gp2ap002_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(gp2ap002_suspend, gp2ap002_resume)
+};
+
+static struct i2c_driver gp2ap002_i2c_driver = {
+	.driver = {
+		.name	= "GP2AP002",
+		.owner	= THIS_MODULE,
+		.pm	= &gp2ap002_pm_ops,
+	},
+	.probe		= gp2ap002_probe,
+	.remove		= __devexit_p(gp2ap002_remove),
+	.id_table	= gp2ap002_id,
+};
+
+static int __init gp2ap002_init(void)
+{
+	return i2c_add_driver(&gp2ap002_i2c_driver);
+}
+module_init(gp2ap002_init);
+
+static void __exit gp2ap002_exit(void)
+{
+	i2c_del_driver(&gp2ap002_i2c_driver);
+}
+module_exit(gp2ap002_exit);
+
+MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
+MODULE_DESCRIPTION("GP2AP002 Proximity/Ambient Light Sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/gp2ap002.h b/include/linux/platform_data/gp2ap002.h
new file mode 100644
index 0000000..39e6a1b
--- /dev/null
+++ b/include/linux/platform_data/gp2ap002.h
@@ -0,0 +1,69 @@
+/*
+ *  Copyright (C) 2010 Samsung Electronics
+ *  Minkyu Kang <mk7.kang@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __GP2AP002_H_
+#define __GP2AP002_H_
+
+/**
+ * struct gp2ap002_platform_data
+ * @get_adc: call back function to get adc value for ambient light sensor
+ * @power_enable: call back function to control voltage supply for chip
+ * @led_mode: select switch for LED's resistance
+ *	0: 2x higher setting,
+ *	1: normal setting
+ * @hysd, hysc, hysf: a set of these bits adjusts the sensitivity,
+ *	determining characteristics of the detection distance and
+ *	its hysteresis
+ *	0 <= hysd <= 1
+ *	0 <= hysc <= 3
+ *	0 <= hysf <= 15
+ * @cycle: determine the detection cycle
+ *	0: 8ms (response time)
+ *	1: 16ms (response time)
+ *	2: 32ms (response time)
+ *	3: 64ms (response time)
+ *	4: 128ms (response time)
+ *	5: 256ms (response time)
+ *	6: 512ms (response time)
+ *	7: 1024ms (response time)
+ * @oscillator: select switch for internal clock frequency hopping
+ *	0: effective,
+ *	1: ineffective
+ * @analog_sleep: select switch for analog sleep function
+ *	0: ineffective
+ *	1: effective
+ * @prox_mode: determine output method control for Vout pin
+ *	0: normal mode
+ *	1: interrupt_mode
+ * @vout_control: select switch for enabling/disabling Vout pin
+ *	0: enable
+ *	2: force to go Low
+ *	3: force to go High
+ * @chip_enable: determine enabling/disabling software shutdown function
+ *	0: shutdown mode
+ *	1: operating mode
+ */
+struct gp2ap002_platform_data {
+	int (*get_adc)(void);
+	void (*power_enable)(bool);
+
+	u8 led_mode;
+	u8 hysd;
+	u8 hysc;
+	u8 hysf;
+	u8 cycle;
+	u8 oscillator;
+	u8 analog_sleep;
+	u8 prox_mode;
+	u8 vout_control;
+
+	bool chip_enable;
+};
+
+#endif
-- 
1.7.4.1

