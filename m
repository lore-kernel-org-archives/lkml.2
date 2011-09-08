Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab1IHLBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 07:01:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab1IHLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 07:01:41 -0400
X-AuditID: cbfee61b-b7b7fae000005864-fb-4e68a093cb20
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de,
        jic23@cam.ac.uk, kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH] misc: Add driver for GP2AP002 proximity/ambient light sensor
Date: Thu, 08 Sep 2011 20:00:54 +0900
Message-id: <1315479654-19836-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 08 Sep 2011 11:02:13.0118 (UTC)
 FILETIME=[C342E9E0:01CC6E16]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SHARP GP2AP002 is proximity and ambient light sensor.
This patch supports it.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/misc-devices/gp2ap002    |   47 ++++
 drivers/misc/Kconfig                   |   10 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/gp2ap002.c                |  419 ++++++++++++++++++++++++++++++++
 include/linux/platform_data/gp2ap002.h |   71 ++++++
 5 files changed, 548 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/gp2ap002
 create mode 100644 drivers/misc/gp2ap002.c
 create mode 100644 include/linux/platform_data/gp2ap002.h

diff --git a/Documentation/misc-devices/gp2ap002 b/Documentation/misc-devices/gp2ap002
new file mode 100644
index 0000000..c227d19
--- /dev/null
+++ b/Documentation/misc-devices/gp2ap002
@@ -0,0 +1,47 @@
+Kernel driver gp2ap002
+=================
+
+Supported chips:
+* Sharp GP2AP002A00F proximity and ambient light sensor
+  Datasheet: Not publicly available
+
+Authors: Donggeun Kim <dg77.kim@samsung.com>
+	 Minkyu Kang <mk7.kang@samsung.com>
+
+Description
+-----------
+GP2AP002A00F is a proximity and ambient light sensor.
+The proximity value can be obtained one of the following modes.
+1. Normal mode: get the value of Vout gpio pin
+	High = object is not detected
+	Low  = object is detected
+2. Interrupt mode: the chip generates interrupts
+	whenever object is detected or not detected
+	The proximity state can be obtained
+	from VO field of PROX register
+	1 = object is detected (value of VO field)
+	0 = object is not detected (value of VO field)
+
+This chip only exports current as the result of ambient light sensor.
+To get illuminance, CPU measures the current exported
+from the sensor through ADC.
+The relationship between current and illuminance is as follows:
+	illuminance = 10^(current/10)  - (1)
+This driver only exposes the measured current.
+Illuminance should be calculated at the user space by (1) formula.
+
+Sysfs Interface
+---------------
+prox0_input	proximity sensor result
+		0: object is not detected
+		1: object is detected
+		RO
+
+adc0_input	ADC result for ambient light sensor
+		current [unit: uA]
+		RO
+
+enable		enable/disable the sensor
+		1: enable
+		0: disable
+		RW
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2d6423c..493373f 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,16 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config GP2AP002
+	tristate "Sharp GP2AP002 proximity/ambient light sensor"
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
index 0000000..924f9d7
--- /dev/null
+++ b/drivers/misc/gp2ap002.c
@@ -0,0 +1,419 @@
+/*
+ *  gp2ap002.c - Sharp GP2AP002 proximity/ambient light sensor
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
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/kobject.h>
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
+	int mode;
+	int proximity;
+
+	/* Ambient Light */
+	int adc;
+};
+
+static void gp2ap002_get_proximity(struct gp2ap002_chip *chip)
+{
+	struct gp2ap002_platform_data *pdata = chip->pdata;
+	int prox_mode;
+
+	prox_mode = pdata->prox_mode << OPMOD_VCON_SHIFT;
+	/* interrupt output mode */
+	if ((prox_mode & OPMOD_VCON_MASK) == OPMOD_VCON_IRQ) {
+		/* Determine whether the object is detected
+		   by reading proximity output register */
+		chip->proximity = i2c_smbus_read_byte_data(chip->client,
+					GP2AP002_PROX) & PROX_VO_DETECT;
+	} else { /* normal output mode */
+		/* vo_gpio is changed from high to low
+		   when the object is detected */
+		chip->proximity = !gpio_get_value(pdata->vout_gpio);
+	}
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
+static ssize_t gp2ap002_show_light_adc(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct gp2ap002_chip *chip = dev_get_drvdata(dev);
+	struct gp2ap002_platform_data *pdata = chip->pdata;
+
+	if (pdata->get_adc) {
+		mutex_lock(&chip->lock);
+		chip->adc = pdata->get_adc();
+		mutex_unlock(&chip->lock);
+	}
+	if (chip->adc < 0)
+		return chip->adc;
+	return sprintf(buf, "%d\n", chip->adc);
+}
+static DEVICE_ATTR(adc0_input, S_IRUGO, gp2ap002_show_light_adc, NULL);
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
+	return sprintf(buf, "%d\n", chip->enabled);
+}
+static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR,
+		gp2ap002_show_enable, gp2ap002_store_enable);
+
+static struct attribute *gp2ap002_attributes[] = {
+	&dev_attr_prox0_input.attr,
+	&dev_attr_adc0_input.attr,
+	&dev_attr_enable.attr,
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
+		unsigned long irq_flag = IRQF_DISABLED;
+
+		if (chip->mode == OPMOD_VCON_IRQ)
+			irq_flag |= IRQF_TRIGGER_FALLING;
+		else
+			irq_flag |= IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING;
+
+		ret = request_irq(client->irq, gp2ap002_irq, irq_flag,
+				"GP2AP002 sensor", chip);
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
index 0000000..134e7ef
--- /dev/null
+++ b/include/linux/platform_data/gp2ap002.h
@@ -0,0 +1,71 @@
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
+ * @vout_gpio: gpio number for Vout pin
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
+	int vout_gpio;
+
+	int led_mode;
+	int hysd;
+	int hysc;
+	int hysf;
+	int cycle;
+	int oscillator;
+	int analog_sleep;
+	int prox_mode;
+	int vout_control;
+
+	bool chip_enable;
+};
+
+#endif
-- 
1.7.4.1

