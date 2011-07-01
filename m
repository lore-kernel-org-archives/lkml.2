Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1GAFhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:38 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752516Ab1GAFhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:35 -0400
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 01:37:06 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 2/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:09 -0700
Message-Id: <1309497556-7344-3-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
References: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Please see the email 0/9 for a description of this patch.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Peichen Chang <peichen.chang@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/rmi_i2c.c b/drivers/input/touchscreen/rmi_i2c.c
new file mode 100644
index 0000000..c9d248d
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.c
@@ -0,0 +1,528 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2011, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include "rmi_i2c.h"
+#include "rmi_drvr.h"
+#include "rmi_platformdata.h"
+#include "rmi_sensor.h"
+
+#define DRIVER_NAME "rmi4_ts"
+#define DEVICE_NAME "rmi4_ts"
+
+static const struct i2c_device_id rmi_i2c_id_table[] = {
+	{RMI4_I2C_DEVICE_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, rmi_i2c_id_table);
+
+/*
+ * This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various elements
+ * inside.
+ */
+struct instance_data {
+	int instance_no;
+	int irq;
+	struct rmi_phys_driver rmiphysdrvr;
+	struct i2c_client *i2cclient;	/* pointer to client for later use in
+					   read, write, read_multiple, etc. */
+	struct mutex page_mutex;
+	struct lock_class_key page_key;
+	int page;
+};
+
+/*
+ * RMI devices have 16-bit addressing, but some of the physical
+ * implementations (like SMBus) only have 8-bit addressing.  So RMI implements
+ * a page address at 0xff of every page so we can reliable page addresses
+ * every 256 registers.  This function sets the page.
+ *
+ * The page_mutex lock must be held when this function is entered.
+ *
+ * param[in] id - The pointer to the instance_data struct
+ * param[in] page - The new page address.
+ * returns zero on success, non-zero on failure.
+ */
+/* Writing to page select is giving errors in some configurations.  It's
+ * not needed for basic operation [see note], so we've turned it off for the
+ * moment. Once we figure out why this happening (is it a bug in our code? or
+ * in some I2C chips?  or maybe in the driver for some chips?) we'll either
+ * turn this opperation back on, move the choice to platform data, or
+ * determine whether to use it based on I2C driver capability).
+ *
+ * [NOTE: The current driver feature set doesn't require us to access
+ * addresses outside of the first page, so we're OK for the time being.
+ * Obviously this must be remedied before implementing the more advanced
+ * features that are in the pipeline.]
+ */
+#if	defined(USE_PAGESELECT)
+int rmi_set_page(struct instance_data *instancedata, unsigned int page)
+{
+	char txbuf[2];
+	int retval;
+	txbuf[0] = 0xff;
+	txbuf[1] = page;
+	retval = i2c_master_send(instancedata->i2cclient,
+				txbuf, ARRAY_SIZE(txbuf));
+	if (retval != ARRAY_SIZE(txbuf)) {
+		dev_err(&instancedata->i2cclient->dev,
+			"%s: Set page failed: %d.", __func__, retval);
+	} else {
+		retval = 0;
+		instancedata->page = page;
+	}
+	return retval;
+}
+#else
+int rmi_set_page(struct instance_data *instancedata, unsigned int page)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Same as rmi_i2c_read, except that multiple bytes are allowed to be read.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the data read.
+ * param[out] valp - Pointer to the buffer where the data will be stored.  This
+ *     buffer must be at least size bytes long.
+ * param[in] size - The number of bytes to be read.
+ * returns zero upon success (with the byte read in valp), non-zero upon error.
+ *
+ */
+static int
+rmi_i2c_read_multiple(struct rmi_phys_driver *physdrvr, unsigned short address,
+		      char *valp, int size)
+{
+	struct instance_data *instancedata =
+	    container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&instancedata->page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+			__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(instancedata->i2cclient, valp, size);
+
+	if (retval != size) {
+		if (++retry_count == 5) {
+			dev_err(&instancedata->i2cclient->dev,
+				"%s: Read of 0x%04x size %d fail: %d\n",
+				__func__, address, size, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(instancedata, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+	}
+exit:
+
+	mutex_unlock(&instancedata->page_mutex);
+	return retval;
+}
+
+/*
+ * Read a single register through i2c.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the data read.
+ * param[out] valp - Pointer to the buffer where the data will be stored.
+ * returns zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_i2c_read(struct rmi_phys_driver *physdrvr, unsigned short address,
+	     char *valp)
+{
+	return rmi_i2c_read_multiple(physdrvr, address, valp, 1);
+}
+
+/*
+ * Write multiple registers.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the write.
+ * param[in] valp - A pointer to a buffer containing the data to be written.
+ * param[in] size - The number of bytes to write.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write_multiple(struct rmi_phys_driver *physdrvr, unsigned short address,
+		       char *valp, int size)
+{
+	struct instance_data *instancedata =
+	    container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	unsigned char txbuf[size+1];
+	int retval = 0;
+
+	memcpy(txbuf+1, valp, size);
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&instancedata->page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+	txbuf[0] = address & 0xff;	/* put the address in the first byte */
+	retval = i2c_master_send(instancedata->i2cclient,
+				txbuf, ARRAY_SIZE(txbuf));
+
+	/* TODO: Add in retry on writes only in certain error return values */
+	if (retval != ARRAY_SIZE(txbuf)) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+			__func__, retval);
+		goto exit;
+	}
+exit:
+
+	mutex_unlock(&instancedata->page_mutex);
+	return retval;
+}
+
+/*
+ * Write a single register through i2c.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver structnew file (copy)
+ * param[in] address - The address at which to start the write.
+ * param[in] data - The data to be written.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write(struct rmi_phys_driver *physdrvr, unsigned short address,
+	      char data)
+{
+	return rmi_i2c_write_multiple(physdrvr, address, &data, 1);
+}
+
+/*
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ */
+static irqreturn_t i2c_attn_isr(int irq, void *info)
+{
+	struct instance_data *instancedata = info;
+
+	disable_irq_nosync(instancedata->irq);
+
+	if (instancedata->rmiphysdrvr.attention) {
+		instancedata->rmiphysdrvr.attention(&instancedata->rmiphysdrvr,
+						    instancedata->instance_no);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* The Driver probe function - will allocate and initialize the instance
+ * data and request the irq and set the instance data as the clients
+ * platform data then register the physical driver which will do a scan of
+ * the RMI4 Physical Device Table and enumerate any RMI4 functions that
+ * have data sources associated with them.
+ */
+static int
+rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
+{
+	struct instance_data *instancedata;
+	int retval = 0;
+	struct rmi_i2c_platformdata *platformdata;
+	struct rmi_sensordata *sensordata;
+
+	if (client == NULL) {
+		pr_err("%s: Invalid NULL client received.", __func__);
+		return -EINVAL;
+	}
+
+	platformdata = client->dev.platform_data;
+	if (platformdata == NULL) {
+		dev_err(&client->dev, "%s: CONFIGURATION ERROR - "
+		"platform data is NULL.\n", __func__);
+		retval = -EINVAL;
+	}
+	sensordata = platformdata->sensordata;
+
+	dev_dbg(&client->dev, "%s: Probing i2c RMI device, addr: 0x%02x",
+		  __func__, client->addr);
+
+	/* Allocate and initialize the instance data for this client */
+	instancedata = kzalloc(sizeof(*instancedata), GFP_KERNEL);
+	if (!instancedata) {
+		dev_err(&client->dev,
+			"%s: Failed to allocate instance_data.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	__mutex_init(&instancedata->page_mutex, "page_mutex",
+		     &instancedata->page_key);
+	instancedata->rmiphysdrvr.name = RMI4_I2C_DRIVER_NAME;
+	instancedata->rmiphysdrvr.write = rmi_i2c_write;
+	instancedata->rmiphysdrvr.read = rmi_i2c_read;
+	instancedata->rmiphysdrvr.write_multiple = rmi_i2c_write_multiple;
+	instancedata->rmiphysdrvr.read_multiple = rmi_i2c_read_multiple;
+	instancedata->rmiphysdrvr.module = THIS_MODULE;
+
+	/* Set default to polling in case no matching platform data is located
+	   for this device. We'll still work but in polling mode since we didn't
+	   find any irq info */
+	instancedata->rmiphysdrvr.polling_required = true;
+
+	instancedata->page = 0xffff;	/* Force a set page the first time */
+
+	/* Egregiously horrible delay here that seems to prevent I2C disasters
+	 * on certain broken dev systems.  In most cases, you can safely
+	 * leave this as zero.
+	 */
+	if (platformdata->delay_ms > 0)
+		mdelay(platformdata->delay_ms);
+
+	dev_dbg(&client->dev, "%s: sensor addr: 0x%02x irq: 0x%x type: %d\n",
+		 __func__, platformdata->i2c_address, platformdata->irq,
+		 platformdata->irq_type);
+	if (client->addr != platformdata->i2c_address) {
+		dev_err(&client->dev,
+			"%s: CONFIGURATION ERROR - client I2C address 0x%02x "
+			"doesn't match platform data address 0x%02x.\n",
+			__func__, client->addr, platformdata->i2c_address);
+		retval = -EINVAL;
+		goto error_exit;
+	}
+
+	instancedata->instance_no = rmi_next_sensor_id();
+
+	/* set the device name using the instance_no appended to DEVICE_NAME
+	 * to make a unique name */
+	dev_set_name(&client->dev, "%s%d", RMI4_I2C_DEVICE_NAME,
+		     instancedata->instance_no);
+
+	/* Determine if we need to poll (inefficient) or use interrupts.
+	 */
+	if (platformdata->irq) {
+		instancedata->irq = platformdata->irq;
+		switch (platformdata->irq_type) {
+		case IRQF_TRIGGER_NONE:
+			dev_warn(&client->dev, "%s: Touchscreen ATTN IRQ was "
+				"specified as IRQF_TRIGGER_NONE. IRQ trigger "
+				"configuration will be defaulted.", __func__);
+			break;
+		case IRQF_TRIGGER_RISING:
+		case IRQF_TRIGGER_FALLING:
+		case IRQF_TRIGGER_HIGH:
+		case IRQF_TRIGGER_LOW:
+			break;
+		default:
+			dev_warn(&client->dev,
+				 "%s: Invalid IRQ flags in platform data.\n",
+				 __func__);
+			retval = -ENXIO;
+			goto error_exit;
+		}
+
+		instancedata->rmiphysdrvr.polling_required = false;
+		instancedata->rmiphysdrvr.irq = instancedata->irq;
+
+	} else {
+		instancedata->rmiphysdrvr.polling_required = true;
+		dev_info(&client->dev,
+			 "%s: No IRQ info given. Polling required.\n",
+			 __func__);
+	}
+
+	/* Store the instance data in the i2c_client - we need to do this prior
+	 * to calling register_physical_driver since it may use the read, write
+	 * functions. If nothing was found then the id fields will be set to 0
+	 * for the irq and the default  will be set to polling required so we
+	 * will still work but in polling mode. */
+	i2c_set_clientdata(client, instancedata);
+
+	/* Copy i2c_client pointer into instance_data's i2c_client pointer for
+	   later use in rmi4_read, rmi4_write, etc. */
+	instancedata->i2cclient = client;
+
+	/* Call the platform setup routine, to do any setup that is required
+	 * before interacting with the device.  When we refined the bus
+	 * architecture, this will be done elsewhere.
+	 */
+	if (sensordata && sensordata->rmi_sensor_setup) {
+		retval = sensordata->rmi_sensor_setup();
+		if (retval) {
+			dev_err(&client->dev,
+				"%s: sensor setup failed with code %d.",
+			       __func__, retval);
+			goto error_exit;
+		}
+	}
+
+	/* Register sensor drivers - this will call the detect function that
+	 * will then scan the device and determine the supported RMI4 sensors
+	 * and functions.
+	 */
+	retval =
+	    rmi_register_sensor(&instancedata->rmiphysdrvr,
+				platformdata->sensordata);
+	if (retval) {
+		dev_err(&client->dev,
+			"%s: Failed to Register %s sensor drivers\n", __func__,
+			instancedata->rmiphysdrvr.name);
+		goto error_exit;
+	}
+
+	if (instancedata->rmiphysdrvr.polling_required == false) {
+		retval = request_irq(instancedata->irq, i2c_attn_isr,
+				platformdata->irq_type, "rmi_i2c",
+				instancedata);
+		if (retval) {
+			dev_err(&client->dev,
+				"%s: failed to obtain IRQ %d. Result: %d.",
+				__func__, instancedata->irq, retval);
+			dev_info(&client->dev, "%s: Reverting to polling.\n",
+				 __func__);
+			instancedata->rmiphysdrvr.polling_required = true;
+			/* TODO: Need to revert back to polling - create and
+			 * start timer. */
+		} else {
+			dev_dbg(&client->dev, "%s: got irq.\n", __func__);
+		}
+	}
+
+	dev_dbg(&client->dev, "%s: Successfully registered %s sensor driver.\n",
+		__func__, instancedata->rmiphysdrvr.name);
+
+	pr_info("%s: Successfully registered %s sensor driver.\n", __func__,
+		instancedata->rmiphysdrvr.name);
+
+	return retval;
+
+error_exit:
+	kfree(instancedata);
+	/* return error for clean-up*/
+	return retval;
+}
+
+static int rmi_i2c_remove(struct i2c_client *client)
+{
+	struct instance_data *instancedata = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s: Unregistering phys driver %s\n", __func__,
+		instancedata->rmiphysdrvr.name);
+
+	rmi_unregister_sensors(&instancedata->rmiphysdrvr);
+
+	dev_dbg(&client->dev, "%s: Unregistered phys driver %s\n",
+		__func__, instancedata->rmiphysdrvr.name);
+
+	/* only free irq if we have an irq - otherwise the instance_data
+	   will be 0 for that field */
+	if (instancedata->irq)
+		free_irq(instancedata->irq, instancedata);
+
+	kfree(instancedata);
+	dev_dbg(&client->dev, "%s: Remove successful\n", __func__);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int rmi_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	/* Touch sleep mode */
+	return 0;
+}
+
+static int rmi_i2c_resume(struct i2c_client *client)
+{
+	/* Re-initialize upon resume */
+	return 0;
+}
+#else
+#define rmi_i2c_suspend	NULL
+#define rmi_i2c_resume	NULL
+#endif
+
+/*
+ * This structure tells the i2c subsystem about us.
+ *
+ * TODO: we should add .suspend and .resume fns.
+ *
+ */
+static struct i2c_driver rmi_i2c_driver = {
+	.probe = rmi_i2c_probe,
+	.remove = rmi_i2c_remove,
+	.suspend = rmi_i2c_suspend,
+	.resume = rmi_i2c_resume,
+	.driver = {
+		   .name = RMI4_I2C_DRIVER_NAME,
+		   .owner = THIS_MODULE,
+		   },
+	.id_table = rmi_i2c_id_table,
+};
+
+static int __init rmi_phys_i2c_init(void)
+{
+	return i2c_add_driver(&rmi_i2c_driver);
+}
+
+static void __exit rmi_phys_i2c_exit(void)
+{
+	i2c_del_driver(&rmi_i2c_driver);
+}
+
+module_init(rmi_phys_i2c_init);
+module_exit(rmi_phys_i2c_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_i2c.h b/drivers/input/touchscreen/rmi_i2c.h
new file mode 100644
index 0000000..66bc48c
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.h
@@ -0,0 +1,67 @@
+/**
+ *
+ * Synaptics RMI over I2C Physical Layer Driver Header File.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#if !defined(_RMI_I2C_H)
+#define _RMI_I2C_H
+
+#include "rmi_platformdata.h"
+
+/* In the future, we may change the device name.  If so, defining it here
+ * makes life easier.
+ */
+#define RMI4_I2C_DRIVER_NAME "rmi4_ts"
+#define RMI4_I2C_DEVICE_NAME "rmi4_ts"
+
+/* Sensor-specific configuration data, to be included as the platform data
+ * for the relevant i2c_board_info entry.
+ *
+ * This describes a single RMI4 sensor on an I2C bus, including:
+ * its I2C address, IRQ (if any), the type of IRQ (if applicable), and an
+ * optional list of any non-default settings (on a per function basis)
+ * to be applied at start up.
+ */
+struct rmi_i2c_platformdata {
+	/* The seven-bit i2c address of the sensor. */
+	int i2c_address;
+	/* The number of the irq.  Set to zero if polling is required. */
+	int irq;
+	/* The type of the irq.  This should be one of IRQF_TRIGGER_RISING,
+	 * IRQF_TRIGGER_FALLING, IRQF_TRIGGER_HIGH, IRQF_TRIGGER_LOW.
+	 * Recommended value is IRQF_TRIGGER_LOW, but may be different for
+	 * specially configured sensors.
+	 * Only valid if irq != 0 */
+	int irq_type;
+
+	/* If >0, the driver will delay this many milliseconds before attempting
+	 * I2C communications.  This is necessary because some horribly broken
+	 * development systems don't bring their I2C up very fast after system
+	 * power on or reboot.  In most cases, you can safely ignore this.
+	 */
+	int delay_ms;
+
+	/* Use this to specify platformdata that is not I2C specific. */
+	struct rmi_sensordata *sensordata;
+};
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_spi.c b/drivers/input/touchscreen/rmi_spi.c
new file mode 100644
index 0000000..0d2453a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.c
@@ -0,0 +1,711 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) SPI Physical Layer Driver.
+ * Copyright (C) 2008-2011, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
+#include "rmi_spi.h"
+#include "rmi_platformdata.h"
+#include "rmi_drvr.h"
+#include "rmi_sensor.h"
+
+#define COMM_DEBUG  0		/* Set to 1 to dump transfers. */
+
+/* For V1 protocol, the high bit in the address is set to indicate reads. */
+#define SPI_V1_READ_FLAG 0x80
+
+/* For V2 protocol, first byte of transmission indicates what operation is
+ * to be performed.
+ */
+#define SPI_V2_UNIFIED_READ       0xC0
+#define SPI_V2_WRITE              0x40
+#define SPI_V2_PREPARE_SPLIT_READ 0xC8
+#define SPI_V2_EXECUTE_SPLIT_READ 0xCA
+
+/* Once the sensor has prepared a V2 split read, we always send the same
+ * bytes to tell it to execute the read. For convenience, we keep a static
+ * copy of those bytes around.
+ */
+static unsigned char execute_split_read[] = { SPI_V2_EXECUTE_SPLIT_READ, 0x00 };
+
+/* This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various elements
+ * inside.
+ */
+struct spi_device_instance_data {
+	int instance_no;
+	int irq;
+	unsigned int byte_delay_us;
+	unsigned int block_delay_us;
+	unsigned int split_read_byte_delay_us;
+	unsigned int split_read_block_delay_us;
+	unsigned int buffer_size;
+	unsigned char spi_version;
+	int v2_transaction_size;
+	wait_queue_head_t attn_event;
+	bool attn_seen;
+	bool split_read_pending;
+	struct rmi_phys_driver rpd;
+	struct spi_device *spidev;
+	struct rmi_spi_platformdata *platformdata;
+};
+
+static int spi_xfer(struct spi_device_instance_data *instance_data,
+		    const u8 *txbuf, unsigned n_tx, u8 *rxbuf, unsigned n_rx)
+{
+	struct spi_device *spi = instance_data->spidev;
+#if COMM_DEBUG
+	int i;
+#endif
+	int status;
+	struct spi_message message;
+	struct spi_transfer *xfer_list;
+	const int total_bytes = n_tx + n_rx;
+	u8 local_buf[total_bytes];
+	int xfers_in_message = 0;
+	int xfer_index = 0;
+	int block_delay = n_rx > 0 ? instance_data->block_delay_us : 0;
+	int byte_delay = n_tx > 1 ? instance_data->byte_delay_us : 0;
+	if (instance_data->split_read_pending) {
+		block_delay =
+		    n_rx > 0 ? instance_data->split_read_block_delay_us : 0;
+		byte_delay =
+		    n_tx > 1 ? instance_data->split_read_byte_delay_us : 0;
+	}
+
+	if (n_tx)
+		xfers_in_message += 1;
+	if (n_rx) {
+		if (byte_delay)
+			xfers_in_message += n_rx;
+		else
+			xfers_in_message += 1;
+	}
+
+	xfer_list = kcalloc(xfers_in_message,
+			    sizeof(struct spi_transfer), GFP_KERNEL);
+	if (!xfer_list)
+		return -ENOMEM;
+
+	spi_message_init(&message);
+
+	if (n_tx) {
+		memset(&xfer_list[0], 0, sizeof(struct spi_transfer));
+		xfer_list[0].len = n_tx;
+		xfer_list[0].delay_usecs = block_delay;
+		spi_message_add_tail(&xfer_list[0], &message);
+		memcpy(local_buf, txbuf, n_tx);
+		xfer_list[0].tx_buf = local_buf;
+		xfer_index++;
+	}
+	if (n_rx) {
+		if (byte_delay) {
+			int buffer_offset = n_tx;
+			for (; xfer_index < xfers_in_message; xfer_index++) {
+				memset(&xfer_list[xfer_index], 0,
+				       sizeof(struct spi_transfer));
+				xfer_list[xfer_index].len = 1;
+				xfer_list[xfer_index].delay_usecs = byte_delay;
+				xfer_list[xfer_index].rx_buf =
+				    local_buf + buffer_offset;
+				buffer_offset++;
+				spi_message_add_tail(&xfer_list[xfer_index],
+						     &message);
+			}
+		} else {
+			memset(&xfer_list[xfer_index], 0,
+			       sizeof(struct spi_transfer));
+			xfer_list[xfer_index].len = n_rx;
+			xfer_list[xfer_index].rx_buf = local_buf + n_tx;
+			spi_message_add_tail(&xfer_list[xfer_index], &message);
+			xfer_index++;
+		}
+	}
+#if COMM_DEBUG
+	pr_info("%s: SPI transmits %d bytes...", __func__, n_tx);
+	for (i = 0; i < n_tx; i++)
+		pr_info("    0x%02X", local_buf[i]);
+#endif
+
+	/* do the i/o */
+	if (instance_data->platformdata->cs_assert) {
+		status = instance_data->platformdata->cs_assert(
+			instance_data->platformdata->cs_assert_data, true);
+		if (!status) {
+			pr_err("%s: Failed to assert CS.", __func__);
+			goto error_exit;
+		}
+	}
+	status = spi_sync(spi, &message);
+	if (instance_data->platformdata->cs_assert) {
+		status = instance_data->platformdata->cs_assert(
+			instance_data->platformdata->cs_assert_data, false);
+		if (!status) {
+			pr_err("%s: Failed to deassert CS.", __func__);
+			goto error_exit;
+		}
+	}
+	if (status == 0) {
+		memcpy(rxbuf, local_buf + n_tx, n_rx);
+		status = message.status;
+#if COMM_DEBUG
+		if (n_rx) {
+			pr_info("%s: SPI received %d bytes...", __func__, n_rx);
+			for (i = 0; i < n_rx; i++)
+				pr_info("    0x%02X", rxbuf[i]);
+		}
+#endif
+	} else {
+		pr_err("%s: spi_sync failed with error code %d.",
+		       __func__, status);
+	}
+
+error_exit:
+	kfree(xfer_list);
+	return status;
+}
+
+/* Same as rmi_spi_read_v1, except that multiple bytes are allowed to be read.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_multiple_v1(struct rmi_phys_driver *pd, unsigned short address,
+			 char *valp, int size)
+{
+	struct spi_device_instance_data *instance_data =
+	    container_of(pd, struct spi_device_instance_data, rpd);
+	int retval;
+	unsigned char txbuf[2];
+
+	txbuf[1] = address;
+	txbuf[0] = address >> 8;
+	txbuf[0] |= SPI_V1_READ_FLAG;
+
+	retval = spi_xfer(instance_data, txbuf, ARRAY_SIZE(txbuf), valp, size);
+
+	return retval;
+}
+
+/*
+ * Read a single register through SPI, V1 protocol.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_v1(struct rmi_phys_driver *pd, unsigned short address, char *valp)
+{
+	return rmi_spi_read_multiple_v1(pd, address, valp, 1);
+}
+
+/* Write multiple registers using version 1 of the RMI4 SPI interface.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] valp A pointer to a buffer containing the data to be written.
+ * \param[in] size The number of bytes to write.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_multiple_v1(struct rmi_phys_driver *pd, unsigned short address,
+			  char *valp, int size)
+{
+	struct spi_device_instance_data *id =
+	    container_of(pd, struct spi_device_instance_data, rpd);
+	int buffer_size = size + 2;
+	unsigned char txbuf[buffer_size];
+	int retval;
+	int i;
+
+	txbuf[1] = address;
+	txbuf[0] = address >> 8;
+
+	for (i = 0; i < size; i++)
+		txbuf[i + 2] = valp[i];
+
+	retval = spi_xfer(id, txbuf, buffer_size, NULL, 0);
+
+	return retval ? 0 : 1;
+}
+
+/* Write a single register through SPI using version 1 of the interface.
+ * You can write multiple registers at once, but I made the functions for that
+ * seperate for performance reasons.  Writing multiple requires allocation and
+ * freeing.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] data The data to be written.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_v1(struct rmi_phys_driver *pd, unsigned short address, char data)
+{
+	return rmi_spi_write_multiple_v1(pd, address, &data, 1);
+}
+
+/* Read multiple bytes using version 2 of the RMI4 SPI interface.
+ *
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_multiple_v2(struct rmi_phys_driver *pd, unsigned short address,
+			 char *valp, int size)
+{
+	struct spi_device_instance_data *instance_data =
+	    container_of(pd, struct spi_device_instance_data, rpd);
+	int retval;
+	char header_buf[4];
+
+	header_buf[0] = SPI_V2_UNIFIED_READ;
+	header_buf[1] = (address >> 8) & 0x00FF;
+	header_buf[2] = address & 0x00ff;
+	header_buf[3] = size;
+
+	retval = spi_xfer(instance_data, header_buf, ARRAY_SIZE(header_buf),
+			  valp, size);
+
+	return retval;
+}
+
+/* Read a single register (one byte) from the device, using version 2 of the
+ * RMI4 SPI interface.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_v2(struct rmi_phys_driver *pd, unsigned short address, char *valp)
+{
+	return rmi_spi_read_multiple_v2(pd, address, valp, 1);
+}
+
+/* Read multiple bytes using version 2 of the RMI4 SPI interface.
+ *
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_split_read_v2(struct rmi_phys_driver *pd, unsigned short address,
+		      char *valp, int size)
+{
+	struct spi_device_instance_data *instance_data =
+	    container_of(pd, struct spi_device_instance_data, rpd);
+	int retval;
+	char header_buf[4];
+	int read_size = size + 1; /* Add a byte for dummy byte at start. */
+	char read_buf[read_size];
+
+	header_buf[0] = SPI_V2_PREPARE_SPLIT_READ;
+	header_buf[1] = (address >> 8) & 0x00FF;
+	header_buf[2] = address & 0x00ff;
+	header_buf[3] = size;
+
+	instance_data->attn_seen = false;
+	instance_data->split_read_pending = true;
+
+	retval = spi_xfer(instance_data, header_buf, ARRAY_SIZE(header_buf),
+			  NULL, 0);
+	if (retval) {
+		instance_data->split_read_pending = false;
+		return retval;
+	}
+
+	enable_irq(pd->irq);
+	wait_event_interruptible((instance_data->attn_event),
+				 (instance_data->attn_seen == true));
+
+	retval = spi_xfer(instance_data,
+			  execute_split_read, ARRAY_SIZE(execute_split_read),
+			  read_buf, read_size);
+	instance_data->split_read_pending = false;
+	if (retval)
+		return retval;
+	if (read_buf[0] != size)
+		return -EIO;
+	memcpy(valp, &read_buf[1], size);
+
+	return retval;
+}
+
+/* Write multiple registers using version 2 of the RMI4 SPI interface.
+ *
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] valp A pointer to a buffer containing the data to be written.
+ * \param[in] size The number of bytes to write.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_multiple_v2(struct rmi_phys_driver *pd, unsigned short address,
+			  char *valp, int size)
+{
+	struct spi_device_instance_data *id =
+	    container_of(pd, struct spi_device_instance_data, rpd);
+	unsigned char txbuf[size + 4];
+	int retval;
+
+	txbuf[0] = SPI_V2_WRITE;
+	txbuf[1] = (address >> 8) & 0x00FF;
+	txbuf[2] = address & 0x00FF;
+	txbuf[3] = size;
+
+	memcpy(&txbuf[4], valp, size);
+
+	retval = spi_xfer(id, txbuf, size + 4, NULL, 0);
+
+	return retval ? 0 : 1;
+}
+
+/* Write a single byte/register using version 2 of the RMI4 SPI interface.
+ *
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] data The data to be written.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_v2(struct rmi_phys_driver *pd, unsigned short address, char data)
+{
+	return rmi_spi_write_multiple_v2(pd, address, &data, 1);
+}
+
+/* This is the Interrupt Service Routine.  It just notifies the physical device
+ * that attention is required.
+ */
+static irqreturn_t spi_attn_isr(int irq, void *info)
+{
+	struct spi_device_instance_data *instance_data = info;
+	disable_irq_nosync(instance_data->irq);
+	if (instance_data->spi_version == 2 &&
+	    instance_data->split_read_pending) {
+		instance_data->attn_seen = true;
+		wake_up(&instance_data->attn_event);
+		return IRQ_HANDLED;
+	}
+	if (instance_data->rpd.attention)
+		instance_data->rpd.attention(&instance_data->rpd,
+					     instance_data->instance_no);
+	return IRQ_HANDLED;
+}
+
+static int __devinit rmi_spi_probe(struct spi_device *spi)
+{
+	struct spi_device_instance_data *instance_data;
+	int retval;
+	struct rmi_spi_platformdata *platformdata;
+	struct rmi_sensordata *sensordata;
+	char buf[6];
+
+	dev_info(&spi->dev, "%s: Probing RMI4 SPI device", __func__);
+
+	platformdata = spi->dev.platform_data;
+	if (platformdata == NULL) {
+		dev_err(&spi->dev,
+			"%s: CONFIGURATION ERROR - platform data is NULL.",
+		       __func__);
+		return -EINVAL;
+	}
+
+	spi->bits_per_word = 8;
+	/* This should have already been set up in the board file,
+	 * shouldn't it? */
+	spi->mode = SPI_MODE_3;
+
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		dev_err(&spi->dev,
+			"%s: spi_setup failed with %d.", __func__, retval);
+		return retval;
+	}
+
+	instance_data = kzalloc(sizeof(*instance_data), GFP_KERNEL);
+	if (!instance_data) {
+		dev_err(&spi->dev,
+			"%s: Failed to allocate memory for instance data.",
+		       __func__);
+		kfree(platformdata);
+		return -ENOMEM;
+	}
+
+	instance_data->platformdata = platformdata;
+	sensordata = platformdata->sensordata;
+	instance_data->block_delay_us =
+	    platformdata->block_delay_us ? platformdata->
+	    block_delay_us : RMI_DEFAULT_BLOCK_DELAY_US;
+	instance_data->byte_delay_us =
+	    platformdata->byte_delay_us ? platformdata->
+	    byte_delay_us : RMI_DEFAULT_BYTE_DELAY_US;
+	instance_data->split_read_block_delay_us =
+	    platformdata->split_read_block_delay_us;
+	instance_data->split_read_byte_delay_us =
+	    platformdata->split_read_byte_delay_us;
+
+	instance_data->spidev = spi;
+	instance_data->rpd.name = RMI4_SPI_DRIVER_NAME;
+	instance_data->rpd.write = rmi_spi_write_v1;
+	instance_data->rpd.read = rmi_spi_read_v1;
+	instance_data->rpd.write_multiple = rmi_spi_write_multiple_v1;
+	instance_data->rpd.read_multiple = rmi_spi_read_multiple_v1;
+	instance_data->rpd.module = THIS_MODULE;
+		/* default to polling if irq not used */
+	instance_data->rpd.polling_required = true;
+
+	/* Call the platform setup routine, to do any setup that is
+	 * required before interacting with the device.
+	 */
+	if (sensordata && sensordata->rmi_sensor_setup) {
+		retval = sensordata->rmi_sensor_setup();
+		if (retval) {
+			dev_err(&spi->dev,
+				"%s: sensor setup failed with code %d.",
+			       __func__, retval);
+			kfree(instance_data);
+			return retval;
+		}
+	}
+
+	instance_data->instance_no = rmi_next_sensor_id();
+	dev_set_name(&spi->dev, "%s%d", RMI4_SPI_DEVICE_NAME,
+			instance_data->instance_no);
+
+	/* Determine if we need to poll (inefficient) or use interrupts.
+	 */
+	if (platformdata->irq) {
+		instance_data->irq = platformdata->irq;
+		switch (platformdata->irq_type) {
+		case IRQF_TRIGGER_NONE:
+			dev_warn(&spi->dev, "%s: Touchscreen ATTN IRQ was "
+				"specified as IRQF_TRIGGER_NONE. IRQ trigger "
+				"configuration will be defaulted.", __func__);
+			break;
+		case IRQF_TRIGGER_RISING:
+		case IRQF_TRIGGER_FALLING:
+		case IRQF_TRIGGER_HIGH:
+		case IRQF_TRIGGER_LOW:
+			break;
+		default:
+			dev_warn(&spi->dev,
+				"%s: Invalid IRQ flags in platform data.\n",
+				__func__);
+			retval = -ENXIO;
+			goto error_exit;
+		}
+
+		instance_data->rpd.polling_required = false;
+		instance_data->rpd.irq = instance_data->irq;
+	} else {
+		instance_data->rpd.polling_required = true;
+		dev_info(&spi->dev,
+			 "%s: No IRQ info given. Polling required.\n",
+	   __func__);
+	}
+
+	/* Store instance data for later access. */
+	if (instance_data)
+		spi_set_drvdata(spi, instance_data);
+
+#if	defined(CONFIG_MACH_OMAP3_BEAGLE)
+	/* Fixes an issue on Beagleboard - first time read is all 0's,
+	 * brief wait required afterwards. */
+	retval = instance_data->rpd.read_multiple(&(instance_data->rpd),
+					RMI_PDT_START_ADDRESS, (char *)buf,
+					6);
+	msleep(20);
+#endif
+
+	retval = instance_data->rpd.read_multiple(&(instance_data->rpd),
+					RMI_PROTOCOL_VERSION_ADDRESS, buf,
+					2);
+	if (retval < 0) {
+		dev_err(&spi->dev,
+			"%s: Protocol discovery for SPI V2 failed with %d.",
+			__func__, retval);
+		goto error_exit;
+	}
+#if	COMM_DEBUG
+	dev_info(&spi->dev,
+		 "%s: SPI V2 probe got %02X %02X.", __func__, buf[0], buf[1]);
+#endif
+
+	/* buf[0] is equal to SPI proto version - 1. */
+	instance_data->spi_version = buf[0] + 1;
+	switch (instance_data->spi_version) {
+	case 1:
+		break;
+	case 2:
+		instance_data->v2_transaction_size = (unsigned char)buf[1];
+		instance_data->rpd.write = rmi_spi_write_v2;
+		instance_data->rpd.write_multiple = rmi_spi_write_multiple_v2;
+		instance_data->rpd.read = rmi_spi_read_v2;
+		instance_data->rpd.read_multiple = rmi_spi_read_multiple_v2;
+		dev_info(&spi->dev,
+				"%s: Identified SPI V2, transaction size=%d.",
+				__func__, instance_data->v2_transaction_size);
+		break;
+	default:
+		instance_data->spi_version = 1;
+		dev_warn(&spi->dev,
+		    "%s: Unknown SPI version %d encountered. Assuming SPI V1.",
+		     __func__, instance_data->spi_version);
+	}
+
+	/* Register the sensor driver - which will trigger a scan of the PDT. */
+	retval =
+	    rmi_register_sensor(&instance_data->rpd, platformdata->sensordata);
+	if (retval) {
+		dev_err(&spi->dev,
+			"%s: sensor registration failed with code %d.",
+			__func__, retval);
+		goto error_exit;
+	}
+
+	if (instance_data->rpd.polling_required == false) {
+		instance_data->irq = platformdata->irq;
+		retval = request_irq(platformdata->irq, spi_attn_isr,
+				platformdata->irq_type, dev_name(&spi->dev),
+				instance_data);
+		if (retval) {
+			dev_err(&spi->dev,
+				"%s: failed to obtain IRQ %d. Result: %d.",
+				__func__, platformdata->irq, retval);
+			dev_info(&spi->dev, "%s: Reverting to polling.\n",
+				 __func__);
+			instance_data->rpd.polling_required = true;
+			instance_data->irq = 0;
+			/* TODO: Need to revert back to polling -
+			 * create and start timer. */
+		} else {
+			dev_dbg(&spi->dev, "%s: got irq.\n", __func__);
+			instance_data->rpd.irq = instance_data->irq;
+			if (instance_data->spi_version == 2) {
+				init_waitqueue_head(&instance_data->attn_event);
+				instance_data->rpd.read_multiple =
+				    rmi_spi_split_read_v2;
+			}
+		}
+	}
+
+	dev_info(&spi->dev, "%s: Successfully registered %s.", __func__,
+		instance_data->rpd.name);
+
+	return 0;
+
+error_exit:
+	if (sensordata && sensordata->rmi_sensor_teardown)
+		sensordata->rmi_sensor_teardown();
+	if (instance_data->irq)
+		free_irq(instance_data->irq, instance_data);
+	kfree(instance_data);
+	return retval;
+}
+
+static int rmi_spi_suspend(struct spi_device *spi, pm_message_t message)
+{
+	pr_info("%s: Suspending...", __func__);
+	return 0;
+}
+
+static int rmi_spi_resume(struct spi_device *spi)
+{
+	pr_info("%s: Resuming...", __func__);
+	return 0;
+}
+
+static int __devexit rmi_spi_remove(struct spi_device *spi)
+{
+	struct spi_device_instance_data *instance_data = spi_get_drvdata(spi);
+	pr_info("%s: RMI SPI device removed.", __func__);
+
+	rmi_spi_suspend(spi, PMSG_SUSPEND);
+
+	rmi_unregister_sensors(&instance_data->rpd);
+
+	if (instance_data) {
+		if (instance_data->irq)
+			free_irq(instance_data->irq, instance_data);
+		kfree(instance_data);
+	}
+
+	return 0;
+}
+
+static struct spi_driver rmi_spi_driver = {
+	.driver = {
+		.name = RMI4_SPI_DRIVER_NAME,
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+		},
+	.probe = rmi_spi_probe,
+	.remove = __devexit_p(rmi_spi_remove),
+	.suspend = rmi_spi_suspend,
+	.resume = rmi_spi_resume,
+};
+
+static int __init rmi_spi_init(void)
+{
+	int retval;
+	pr_info("%s: RMI SPI physical layer initialization.", __func__);
+	retval = spi_register_driver(&rmi_spi_driver);
+	if (retval < 0) {
+		pr_err("%s: Failed to register spi driver, code = %d.",
+		       __func__, retval);
+		return retval;
+	}
+	pr_debug("%s: SPI initialization complete.", __func__);
+	return retval;
+}
+
+module_init(rmi_spi_init);
+
+static void __exit rmi_spi_exit(void)
+{
+	pr_info("%s: RMI SPI physical layer exits.", __func__);
+	spi_unregister_driver(&rmi_spi_driver);
+}
+
+module_exit(rmi_spi_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver SPI Physical Layer");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_spi.h b/drivers/input/touchscreen/rmi_spi.h
new file mode 100644
index 0000000..f650f0b
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.h
@@ -0,0 +1,114 @@
+/**
+ *
+ * Register Mapped Interface SPI Physical Layer Driver Header File.
+ * Copyright (C) 2008-2011, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#if !defined(_RMI_SPI_H)
+#define _RMI_SPI_H
+
+#include "rmi_platformdata.h"
+
+#define RMI4_SPI_DRIVER_NAME "rmi4_ts"
+#define RMI4_SPI_DEVICE_NAME "rmi4_ts"
+
+/* Some RMI4 SPI devices require a delay between writing the address and
+ * starting the read.  A subset of those required a delay between each
+ * byte transferred during the read.
+ */
+
+/* microseconds between header and start of read operation. */
+#define RMI_DEFAULT_BLOCK_DELAY_US	65
+
+/* microseconds inter-byte delay between bytes during read. */
+#define RMI_DEFAULT_BYTE_DELAY_US	65
+
+/* Use this to specify SPI interface dependent parameters on a per device basis.
+ *
+ * Interface independent data is given in the sensor_data field of this struct.
+ */
+struct rmi_spi_platformdata {
+	/* The number of the irq.  Set to zero if polling is required. */
+	int irq;
+
+	/* The type of the irq.  This should be one of IRQF_TRIGGER_RISING,
+	 * IRQF_TRIGGER_FALLING, IRQF_TRIGGER_HIGH, IRQF_TRIGGER_LOW.
+	 * Recommended value is IRQF_TRIGGER_LOW, but may be different for
+	 * specially configured sensors.
+	 * Only valid if irq != 0 */
+	int irq_type;
+
+	/* RMI4 devices implement two different ways of talking to the
+	 * device over SPI.  These are called SPIv1 and SPIv2.  Due to
+	 * resource constraints on some ASICs, delays may be required when
+	 * reading data from the chip.
+	 *
+	 * The block delay specifies the number of microseconds the
+	 * driver should delay between sending the read request and
+	 * the start of reading data from the ASIC.  If you don't know
+	 * what value to use here, you should specify
+	 * RMI_DEFAULT_BLOCK_DELAY_US.
+	 *
+	 * The byte delay specifies the number of microseconds the driver should
+	 * delay between each byte of a read request.  If don't know what value
+	 * to use here, you should specify RMI_DEFAULT_BLOCK_DELAY_US.
+	 *
+	 * Usually these two values should be the same, but in some cases
+	 * it may be desirable to use different values.
+	 */
+	unsigned int block_delay_us;
+	unsigned int byte_delay_us;
+
+	/* SPIv2 supports a special "split read" operation, which can permit the
+	 * SPI interface to run at full speed (subject to product specific
+	 * limitations) with no delay between blocks and bytes.  In almost all
+	 * cases, it is permissible to default these values to zero.
+	 */
+	unsigned int split_read_block_delay_us;
+	unsigned int split_read_byte_delay_us;
+
+	/* Some SPI hardware and/or drivers do not manage the SSB/CS line in a
+	 * reasonable way.  In particular, the problem is that SSB/CS will be
+	 * deasserted in between every spi_transfer in an spi_message (despite
+	 * whatever you might have set the spi_transfer.cs_change flag to),
+	 * rather than asserting it at the start of the spi_message and leaving
+	 * it asserted until all transfers are completed.  In this case, we
+	 * have to manage the SSB/CS line manually, and you need to provide
+	 * the cs_assert callback here.
+	 *
+	 * If the cs_assert function is non-null, it will be called before
+	 * the driver submits an spi_message in order to assert the line (the
+	 * assert parameter will be TRUE), and afterwards to clear it (the
+	 * assert parameter will be FALSE).  cs_assert should return 0 for
+	 * success, or a negative error code if it fails.
+	 *
+	 * You can provide any needed context data in the cs_assert_data
+	 * variable, which will be passed into all cs_assert calls.
+	 */
+	void *cs_assert_data;
+	int (*cs_assert) (const void *cs_assert_data, const bool assert);
+
+
+	/* Use this to specify platformdata that is not SPI specific. */
+	struct rmi_sensordata *sensordata;
+};
+
+#endif
