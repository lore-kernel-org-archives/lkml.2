Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab1KJQHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:07:33 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14376 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934881Ab1KJQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:07:31 -0500
From: <oskar.andero@sonyericsson.com>
To: <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jic23@cam.ac.uk>, <aghayal@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [PATCH] input: add driver support for Sharp gp2ap002a00f proximity sensor
Date: Thu, 10 Nov 2011 17:07:53 +0100
Message-ID: <1320941273-21228-1-git-send-email-oskar.andero@sonyericsson.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Courtney Cavin <courtney.cavin@sonyericsson.com>

Signed-off-by: Courtney Cavin <courtney.cavin@sonyericsson.com>
Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
---
 drivers/input/misc/Kconfig        |   11 ++
 drivers/input/misc/Makefile       |    1 +
 drivers/input/misc/gp2ap002a00f.c |  265 +++++++++++++++++++++++++++++++++++++
 include/linux/gp2ap002a00f.h      |   13 ++
 4 files changed, 290 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/gp2ap002a00f.c
 create mode 100644 include/linux/gp2ap002a00f.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 22d875f..dee96a0 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -544,4 +544,15 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
+config INPUT_GP2A
+	tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor driver"
+	depends on I2C
+	default n
+	help
+	  Say Y here if you have a Sharp GP2AP002A00F proximity/als combo-chip
+	  hooked to an I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gp2ap002a00f.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index a244fc6..1681993 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
 obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
+obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
diff --git a/drivers/input/misc/gp2ap002a00f.c b/drivers/input/misc/gp2ap002a00f.c
new file mode 100644
index 0000000..b1af83a
--- /dev/null
+++ b/drivers/input/misc/gp2ap002a00f.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (C) 2009,2010 Sony Ericsson Mobile Communications Inc.
+ *
+ * Author: Courtney Cavin <courtney.cavin@sonyericsson.com>
+ * Prepared for up-stream by: Oskar Andero <oskar.andero@sonyericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/gp2ap002a00f.h>
+
+struct gp2a_data {
+	struct input_dev *device;
+	struct gp2a_platform_data *pdata;
+	struct i2c_client *i2c_client;
+};
+
+enum gp2a_addr {
+	GP2A_ADDR_PROX	= 0x0,
+	GP2A_ADDR_GAIN	= 0x1,
+	GP2A_ADDR_HYS	= 0x2,
+	GP2A_ADDR_CYCLE	= 0x3,
+	GP2A_ADDR_OPMOD	= 0x4,
+	GP2A_ADDR_CON	= 0x6
+};
+
+enum gp2a_controls {
+	GP2A_CTRL_SSD	= 0x01
+};
+
+#define NUM_TRIES 5
+static int gp2a_write_byte(struct gp2a_data *dt, u8 reg, u8 val)
+{
+	int error;
+	int n;
+	struct device *dev = &dt->i2c_client->dev;
+
+	for (n = 0; n < NUM_TRIES; n++) {
+		error = i2c_smbus_write_byte_data(dt->i2c_client, reg, val);
+		if (error < 0)
+			dev_err(dev, "i2c_smbus write failed, %d\n", error);
+		else
+			return 0;
+		msleep(10);
+	}
+	return error;
+}
+
+static int gp2a_initialize(struct gp2a_data *dt)
+{
+	int error;
+
+	error = gp2a_write_byte(dt, GP2A_ADDR_GAIN, 0x08);
+	if (error < 0)
+		return error;
+
+	error = gp2a_write_byte(dt, GP2A_ADDR_HYS, 0xc2);
+	if (error < 0)
+		return error;
+
+	error = gp2a_write_byte(dt, GP2A_ADDR_CYCLE, 0x04);
+	if (error < 0)
+		return error;
+
+	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, 0x00);
+
+	return error;
+}
+
+static int gp2a_report(struct gp2a_data *dt)
+{
+	int vo = gpio_get_value(dt->pdata->gpio);
+
+	input_report_abs(dt->device, ABS_DISTANCE, vo ? 255 : 0);
+	input_sync(dt->device);
+
+	return 0;
+}
+
+static irqreturn_t gp2a_irq(int irq, void *dev_id)
+{
+	struct device *dev = dev_id;
+	struct gp2a_data *dt = dev_get_drvdata(dev);
+
+	gp2a_report(dt);
+
+	return IRQ_HANDLED;
+}
+
+static int gp2a_device_open(struct input_dev *dev)
+{
+	struct gp2a_data *dt = input_get_drvdata(dev);
+	int error;
+
+	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, GP2A_CTRL_SSD);
+	if (error < 0) {
+		dev_err(&dev->dev, "Unable to activate, err %d\n", error);
+		return error;
+	}
+
+	enable_irq(gpio_to_irq(dt->i2c_client->irq));
+
+	if (dt->pdata->wake)
+		enable_irq_wake(gpio_to_irq(dt->i2c_client->irq));
+
+	gp2a_report(dt);
+
+	return 0;
+}
+
+static void gp2a_device_close(struct input_dev *dev)
+{
+	struct gp2a_data *dt = input_get_drvdata(dev);
+	int error;
+
+	if (dt->pdata->wake)
+		disable_irq_wake(gpio_to_irq(dt->i2c_client->irq));
+
+	disable_irq(gpio_to_irq(dt->i2c_client->irq));
+	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, 0);
+	if (error < 0)
+		dev_err(&dev->dev, "Unable to deactivate, err %d\n", error);
+}
+
+static int gp2a_probe(struct i2c_client *client,
+		      const struct i2c_device_id *id);
+static int gp2a_remove(struct i2c_client *client);
+
+static const struct i2c_device_id gp2a_i2c_id[] = {
+	{GP2A_I2C_NAME, 0},
+	{}
+};
+
+static struct i2c_driver gp2a_i2c_driver = {
+	.driver = {
+		.name	= GP2A_I2C_NAME,
+		.owner	= THIS_MODULE
+	},
+	.probe		= gp2a_probe,
+	.remove		= __devexit_p(gp2a_remove),
+	.id_table	= gp2a_i2c_id
+};
+
+static int gp2a_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct gp2a_platform_data *pdata;
+	struct gp2a_data *dt;
+	int error;
+
+	pdata = client->dev.platform_data;
+	if (!pdata)
+		return -EINVAL;
+
+	if (pdata->gpio_setup) {
+		error = pdata->gpio_setup();
+		if (error < 0)
+			return error;
+	}
+
+	error = gpio_direction_input(pdata->gpio);
+	if (error < 0)
+		goto err_gpio_shutdown;
+
+	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
+	if (!dt) {
+		error = -ENOMEM;
+		goto err_gpio_shutdown;
+	}
+
+	client->driver = &gp2a_i2c_driver;
+	dt->pdata = pdata;
+	dt->i2c_client = client;
+	i2c_set_clientdata(client, dt);
+
+	error = gp2a_initialize(dt);
+	if (error < 0)
+		goto err_free_dt;
+
+	dt->device = input_allocate_device();
+	if (!dt->device) {
+		error = -ENOMEM;
+		goto err_free_dt;
+	}
+
+	input_set_drvdata(dt->device, dt);
+
+	dt->device->open = gp2a_device_open;
+	dt->device->close = gp2a_device_close;
+	dt->device->name = GP2A_I2C_NAME;
+	dt->device->id.bustype = BUS_I2C;
+	set_bit(EV_ABS, dt->device->evbit);
+	set_bit(ABS_DISTANCE, dt->device->absbit);
+
+	input_set_abs_params(dt->device, ABS_DISTANCE, 0, 255, 0, 0);
+
+	error = input_register_device(dt->device);
+	if (error) {
+		dev_err(&dt->device->dev, "device registration failed\n");
+		input_free_device(dt->device);
+		goto err_free_dt;
+	}
+
+	error = request_threaded_irq(gpio_to_irq(dt->i2c_client->irq), NULL,
+			gp2a_irq, IRQF_TRIGGER_RISING |
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			GP2A_I2C_NAME, &dt->i2c_client->dev);
+	if (error) {
+		dev_err(&dt->device->dev, "irq request failed\n");
+		goto err_unreg_input;
+	}
+	disable_irq(gpio_to_irq(dt->i2c_client->irq));
+
+	return 0;
+
+err_unreg_input:
+	input_unregister_device(dt->device);
+err_free_dt:
+	kfree(dt);
+err_gpio_shutdown:
+	if (pdata->gpio_shutdown)
+		pdata->gpio_shutdown();
+	return error;
+}
+
+static int gp2a_remove(struct i2c_client *client)
+{
+	struct gp2a_data *dt = i2c_get_clientdata(client);
+
+	device_init_wakeup(&client->dev, 0);
+	if (dt->pdata->gpio_shutdown)
+		dt->pdata->gpio_shutdown();
+	free_irq(gpio_to_irq(dt->i2c_client->irq), &dt->i2c_client->dev);
+	input_unregister_device(dt->device);
+	kfree(dt);
+
+	return 0;
+}
+
+static int __init gp2a_init(void)
+{
+	return i2c_add_driver(&gp2a_i2c_driver);
+}
+
+static void __exit gp2a_exit(void)
+{
+	i2c_del_driver(&gp2a_i2c_driver);
+}
+
+module_init(gp2a_init);
+module_exit(gp2a_exit);
+
+MODULE_AUTHOR("Courtney Cavin <courtney.cavin@sonyericsson.com>");
+MODULE_DESCRIPTION("Sharp GP2AP002A00F I2C Proximity/Opto sensor driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/gp2ap002a00f.h b/include/linux/gp2ap002a00f.h
new file mode 100644
index 0000000..74e2610
--- /dev/null
+++ b/include/linux/gp2ap002a00f.h
@@ -0,0 +1,13 @@
+#ifndef _GP2AP002A00F_H_
+#define _GP2AP002A00F_H_
+
+#define GP2A_I2C_NAME   "gp2ap002a00f"
+
+struct gp2a_platform_data {
+	int gpio;
+	int wake;
+	int (*gpio_setup)(void);
+	int (*gpio_shutdown)(void);
+};
+
+#endif
-- 
1.7.7

