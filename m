Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1CaCkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:40:41 -0400
Received: from [12.234.97.163] ([12.234.97.163]:6359 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756602Ab1CaCki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:40:38 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 1/3] (corrected) input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Wed, 30 Mar 2011 19:39:27 -0700
Message-Id: <1301539169-9105-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301539169-9105-1-git-send-email-cheiny@synaptics.com>
References: <1301539169-9105-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/rmi_bus.c b/drivers/input/touchscreen/rmi_bus.c
new file mode 100644
index 0000000..fbb8866
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.c
@@ -0,0 +1,391 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Bus Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
+ *
+ * Impliments "rmi" bus per Documentation/driver-model/bus.txt
+ *
+ * This protocol is layered as follows.
+ *
+ *
+ *
+ *  +-------+ +-------+ +-------+ +--------+
+ *  | Fn32  | |   Fn11| |  Fn19 | |  Fn11  |   Devices/Functions
+ *  *---|---+ +--|----+ +----|--+ +----|---*   (2D, cap. btns, etc.)
+ *      |        |           |         |
+ *  +----------------+      +----------------+
+ *  | Sensor0        |      |  Sensor1       | Sensors Dev/Drivers
+ *  +----------------+      +----------------+ (a sensor has one or
+ *          |                      |            more functions)
+ *          |                      |
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |                RMI4 Bus                | RMI Bus Layer
+ *  |                (this file)             |
+ *  *--|-----|------|--------------|---------*
+ *     |     |      |              |
+ *     |     |      |              |
+ *  +-----+-----+-------+--------------------+
+ *  | I2C | SPI | SMBus |         etc.       | Physical Layer
+ *  +-----+-----+-------+--------------------+
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
+static const char busname[] = "rmi";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include "rmi_drvr.h"
+#include "rmi.h"
+#include "rmi_bus.h"
+#include "rmi_platformdata.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+
+/* list of physical drivers - i2c, spi, etc. */
+static LIST_HEAD(phys_drivers);
+static DEFINE_MUTEX(phys_drivers_mutex);
+
+/* list of sensors found on a physical bus (i2c, smi, etc.)*/
+static LIST_HEAD(sensor_drivers);
+static DEFINE_MUTEX(sensor_drivers_mutex);
+static LIST_HEAD(sensor_devices);
+static DEFINE_MUTEX(sensor_devices_mutex);
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x0005
+#define PDT_ENTRY_SIZE 0x0006
+
+/* definitions for rmi bus */
+struct device rmi_bus_device;
+
+struct bus_type rmi_bus_type;
+EXPORT_SYMBOL(rmi_bus_type);
+
+
+/*
+ * This method is called, perhaps multiple times, whenever a new device or driver
+ * is added for this bus. It should return a nonzero value if the given device can be
+ * handled by the given driver. This function must be handled at the bus level,
+ * because that is where the proper logic exists; the core kernel cannot know how
+ * to match devices and drivers for every possible bus type
+ * The match function does a comparison between the hardware ID provided by
+ * the device itself and the IDs supported by the driver.
+ *
+ */
+static int rmi_bus_match(struct device *dev, struct device_driver *driver)
+{
+	printk(KERN_DEBUG "%s: Matching %s for rmi bus.\n", __func__, dev->bus->name);
+	return !strncmp(dev->bus->name, driver->name, strlen(driver->name));
+}
+
+/** Stub for now.
+ */
+static int rmi_bus_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: RMI bus suspending.", __func__);
+	return 0;
+}
+
+/** Stub for now.
+ */
+static int rmi_bus_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: RMI bus resuming.", __func__);
+	return 0;
+}
+
+/*
+ * This method is called, whenever a new device is added for this bus.
+ * It will scan the devices PDT to get the function $01 query, control,
+ * command and data regsiters so that it can create a function $01 (sensor)
+ * device for the new physical device. It also caches the PDT for later use by
+ * other functions that are created for the device. For example, if a function
+ * $11 is found it will need the query, control, command and data register
+ * addresses for that function. The new function could re-scan the PDT but
+ * since it is being done here we can cache it and keep it around.
+ *
+ * TODO: If the device is reset or some action takes place that would invalidate
+ * the PDT - such as a reflash of the firmware - then the device should be re-added
+ * to the bus and the PDT re-scanned and cached.
+ *
+ */
+int rmi_register_sensor(struct rmi_phys_driver *rpd, struct rmi_functiondata_list *perfunctiondata)
+{
+	int i;
+	struct rmi_sensor_device *rmi_sensor_dev;
+	struct rmi_function_info *rfi;
+	struct rmi_function_descriptor rmi_fd;
+	int retval;
+	static int index;
+
+	/* Make sure we have a read, write, read_multiple, write_multiple
+	function pointers from whatever physical layer the sensor is on.
+	*/
+	if (!rpd->name) {
+		printk(KERN_ERR "%s: Physical driver must specify a name",
+			__func__);
+		return -EINVAL;
+	}
+	if (!rpd->write) {
+		printk(KERN_ERR
+			"%s: Physical driver %s must specify a writer.",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read) {
+		printk(KERN_ERR
+			"%s: Physical driver %s must specify a reader.",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->write_multiple) {
+		printk(KERN_ERR "%s: Physical driver %s must specify a "
+			"multiple writer.",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read_multiple) {
+		printk(KERN_ERR "%s: Physical driver %s must specify a "
+			"multiple reader.",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+
+	/* Get some information from the device */
+	printk(KERN_DEBUG "%s: Identifying sensors by presence of F01...", __func__);
+
+	rmi_sensor_dev = NULL;
+
+	/* Scan the page descriptor table until we find F01.  If we find that,
+	 * we assume that we can reliably talk to this sensor.
+	 */
+	for (i = PDT_START_SCAN_LOCATION;	/* Register the rmi sensor driver */
+			i >= PDT_END_SCAN_LOCATION;
+			i -= PDT_ENTRY_SIZE) {
+		retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+				sizeof(rmi_fd));
+		if (!retval) {
+			rfi = NULL;
+
+			if (rmi_fd.functionNum != 0x00 && rmi_fd.functionNum != 0xff) {
+				if ((rmi_fd.functionNum & 0xff) == 0x01) {
+					printk(KERN_DEBUG "%s: F01 Found - RMI Device Control", __func__);
+
+					/* This appears to be a valid device, so create a sensor
+					* device and sensor driver for it. */
+					rmi_sensor_dev = kzalloc(sizeof(*rmi_sensor_dev), GFP_KERNEL);
+					if (!rmi_sensor_dev) {
+						printk(KERN_ERR "%s: Error allocating memory for rmi_sensor_device\n", __func__);
+						return -ENOMEM;
+					}
+					rmi_sensor_dev->dev.bus = &rmi_bus_type;
+
+					retval = rmi_sensor_register_device(rmi_sensor_dev, index++);
+					if (retval < 0) {
+						printk(KERN_ERR "%s: Error %d registering sensor device.", __func__, retval);
+						goto exit_fail;
+					}
+
+					rmi_sensor_dev->driver = kzalloc(sizeof(struct rmi_sensor_driver), GFP_KERNEL);
+					if (!rmi_sensor_dev->driver) {
+						printk(KERN_ERR "%s: Error allocating memory for rmi_sensor_driver.", __func__);
+						return -ENOMEM;
+					}
+					rmi_sensor_dev->driver->sensor_device = rmi_sensor_dev;
+					rmi_sensor_dev->driver->polling_required = rpd->polling_required;
+					rmi_sensor_dev->driver->rpd = rpd;
+					rmi_sensor_dev->driver->perfunctiondata = perfunctiondata;
+					INIT_LIST_HEAD(&rmi_sensor_dev->driver->functions);
+
+					retval = rmi_sensor_register_driver(rmi_sensor_dev->driver);
+					if (retval < 0) {
+						printk(KERN_ERR "%s: Error %d registering sensor driver.", __func__, retval);
+						goto exit_fail;
+					}
+
+					/* link the attention fn in the rpd to the sensor attn fn */
+
+					rpd->sensor = rmi_sensor_dev->driver;
+					rpd->attention = rmi_sensor_dev->driver->attention;
+
+					/* Add it into the list of sensors on the rmi bus */
+					mutex_lock(&sensor_devices_mutex);
+					list_add_tail(&rmi_sensor_dev->sensors, &sensor_devices);
+					mutex_unlock(&sensor_devices_mutex);
+
+					/* All done with this sensor, fall out of PDT scan loop. */
+					break;
+				} else {
+					/* Just print out the function found for now */
+					printk(KERN_DEBUG "%s: Found Function %02x - Ignored.\n", __func__, rmi_fd.functionNum & 0xff);
+				}
+			} else {
+				/* A zero or 0xff in the function number
+				signals the end of the PDT */
+				pr_debug("%s:   Found End of PDT.",
+					__func__);
+				break;
+			}
+		} else {
+			/* failed to read next PDT entry - end PDT
+			scan - this may result in an incomplete set
+			of recognized functions - should probably
+			return an error but the driver may still be
+			viable for diagnostics and debugging so let's
+			let it continue. */
+			printk(KERN_ERR "%s: Read Error %d when reading next PDT entry - "
+				"ending PDT scan.",
+				__func__, retval);
+			break;
+		}
+	}
+
+	/* If we actually found a sensor, keep it around. */
+	if (rmi_sensor_dev) {
+		/* Add physical driver struct to list */
+		mutex_lock(&phys_drivers_mutex);
+		list_add_tail(&rpd->drivers, &phys_drivers);
+		mutex_unlock(&phys_drivers_mutex);
+	}
+
+	printk(KERN_DEBUG "%s: Registered sensor drivers.", __func__);
+
+	return 0;
+
+exit_fail:
+	return retval;
+}
+EXPORT_SYMBOL(rmi_register_sensor);
+
+int rmi_unregister_sensors(struct rmi_phys_driver *rpd)
+{
+	if (rpd->sensor) {
+		printk(KERN_WARNING "%s: WARNING: unregister of %s while %s still attached.",
+			__func__, rpd->name, rpd->sensor->drv.name);
+	}
+
+	pr_debug("%s: Unregistering sensor drivers %s\n", __func__, rpd->name);
+
+	mutex_lock(&sensor_drivers_mutex);
+	list_del(&rpd->sensor->sensor_drivers);
+	mutex_unlock(&sensor_drivers_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(rmi_unregister_sensors);
+
+
+static void rmi_bus_dev_release(struct device *dev)
+{
+	printk(KERN_DEBUG "rmi bus device release\n");
+}
+
+
+int rmi_register_bus_device(struct device *rmibusdev)
+{
+	printk(KERN_DEBUG "%s: Registering RMI4 bus device.\n", __func__);
+
+	/* Here, we simply fill in some of the embedded device structure fields
+	(which individual drivers should not need to know about), and register
+	the device with the driver core. */
+
+	rmibusdev->bus = &rmi_bus_type;
+	rmibusdev->parent = &rmi_bus_device;
+	rmibusdev->release = rmi_bus_dev_release;
+	dev_set_name(rmibusdev, "rmi");
+
+	/* If we wanted to add bus-specific attributes to the device, we could do so here.*/
+
+	return device_register(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_register_bus_device);
+
+void rmi_unregister_bus_device(struct device *rmibusdev)
+{
+	printk(KERN_DEBUG "%s: Unregistering bus device.", __func__);
+
+	device_unregister(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_unregister_bus_device);
+
+static int __init rmi_bus_init(void)
+{
+	int status;
+
+	status = 0;
+
+	printk(KERN_DEBUG "%s: RMI Bus Driver Init", __func__);
+
+	/* Register the rmi bus */
+	rmi_bus_type.name = busname;
+	rmi_bus_type.match = rmi_bus_match;
+	rmi_bus_type.suspend = rmi_bus_suspend;
+	rmi_bus_type.resume = rmi_bus_resume;
+	status = bus_register(&rmi_bus_type);
+	if (status < 0) {
+		printk(KERN_ERR "%s: Error %d registering the rmi bus.", __func__, status);
+		goto err_exit;
+	}
+	printk(KERN_DEBUG "%s: registered bus.", __func__);
+
+#if 0
+	/** This doesn't seem to be required any more.  It worked OK in Froyo,
+	 * but breaks in Gingerbread */
+	/* Register the rmi bus device - "rmi". There is only one rmi bus device. */
+	status = rmi_register_bus_device(&rmi_bus_device);
+	if (status < 0) {
+		printk(KERN_ERR "%s: Error %d registering rmi bus device.", __func__, status);
+		bus_unregister(&rmi_bus_type);
+		goto err_exit;
+	}
+	printk(KERN_DEBUG "%s: Registered bus device.", __func__);
+#endif
+
+	return 0;
+err_exit:
+	return status;
+}
+
+static void __exit rmi_bus_exit(void)
+{
+	printk(KERN_DEBUG "%s: RMI Bus Driver Exit.", __func__);
+
+	/* Unregister the rmi bus device - "rmi". There is only one rmi bus device. */
+	rmi_unregister_bus_device(&rmi_bus_device);
+
+	/* Unregister the rmi bus */
+	bus_unregister(&rmi_bus_type);
+}
+
+
+module_init(rmi_bus_init);
+module_exit(rmi_bus_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_bus.h b/drivers/input/touchscreen/rmi_bus.h
new file mode 100644
index 0000000..70c6b68
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.h
@@ -0,0 +1,33 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) - RMI Bus Module Header.
+ * Copyright (C) 2007 - 2010, Synaptics Incorporated
+ *
+ */
+/*
+ *
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
+#ifndef _RMI_BUS_H
+#define _RMI_BUS_H
+
+
+extern struct bus_type rmi_bus_type;
+
+#endif
+
diff --git a/drivers/input/touchscreen/rmi_i2c.c b/drivers/input/touchscreen/rmi_i2c.c
new file mode 100644
index 0000000..c924694
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.c
@@ -0,0 +1,616 @@
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
+
+
+#define DRIVER_NAME "rmi4_ts"
+
+#define DEVICE_NAME "rmi4_ts"
+
+/* Used to lock access to the page address.*/
+/* TODO: for multiple device support will need a per-device mutex */
+static DEFINE_MUTEX(page_mutex);
+
+
+static const struct i2c_device_id rmi_i2c_id_table[] = {
+	{ DEVICE_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, rmi_i2c_id_table);
+
+
+/* Used to count the number of I2C modules we get.
+ */
+static int device_count;
+
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
+	struct i2c_client *i2cclient; /* pointer to i2c_client for later use in
+					read, write, read_multiple, etc. */
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
+/** Writing to page select is giving errors in some configurations.  It's
+ * not needed for basic operation, so we've turned it off for the moment.
+ */
+#if	defined(USE_PAGESELECT)
+int
+rmi_set_page(struct instance_data *instancedata, unsigned int page)
+{
+	char txbuf[2];
+	int retval;
+	txbuf[0] = 0xff;
+	txbuf[1] = page;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 2);
+	if (retval != 2) {
+		dev_err(&instancedata->i2cclient->dev,
+				"%s: Set page failed: %d.", __func__, retval);
+	} else {
+		retval = 0;
+		instancedata->page = page;
+	}
+	return retval;
+}
+#else
+int
+rmi_set_page(struct instance_data *instancedata, unsigned int page)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Read a single register through i2c.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the data read.
+ * param[out] valp - Pointer to the buffer where the data will be stored.
+ * returns xero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_i2c_read(struct rmi_phys_driver *physdrvr, unsigned short address, char *valp)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
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
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(instancedata->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		if (++retry_count == 5) {
+			dev_err(&instancedata->i2cclient->dev,
+					"%s: Read of 0x%04x fail: %d\n",
+					__func__, address, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(instancedata, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+		*valp = txbuf[0];
+	}
+exit:
+
+	mutex_unlock(&page_mutex);
+	return retval;
+}
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
+	char *valp, int size)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
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
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(instancedata->i2cclient, valp, size);
+
+	if (retval != size) {
+		if (++retry_count == 5) {
+			dev_err(&instancedata->i2cclient->dev,
+					"%s: Read of 0x%04x size %d fail: %d\n",
+					__func__, address, size, retval);
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
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+
+/*
+ * Write a single register through i2c.
+ * You can write multiple registers at once, but I made the functions for that
+ * seperate for performance reasons.  Writing multiple requires allocation and
+ * freeing.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the write.
+ * param[in] data - The data to be written.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write(struct rmi_phys_driver *physdrvr, unsigned short address, char data)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	unsigned char txbuf[2];
+	int retval = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+	txbuf[0] = address & 0xff;
+	txbuf[1] = data;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 2);
+
+	/* TODO: Add in retry on writes only in certian error return values */
+	if (retval != 2) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+			__func__, retval);
+		goto exit; /* Leave this in case we add code below */
+	}
+exit:
+
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+/*
+ * Write multiple registers.
+ *
+ * For fast writes of 16 bytes of less we will re-use a buffer on the stack.
+ * For larger writes (like for RMI reflashing) we will need to allocate a
+ * temp buffer.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the write.
+ * param[in] valp - A pointer to a buffer containing the data to be written.
+ * param[in] size - The number of bytes to write.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write_multiple(struct rmi_phys_driver *physdrvr, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	unsigned char *txbuf;
+	unsigned char txbuf_most[17]; /* Use this buffer for fast writes of 16
+					bytes or less.  The first byte will
+					contain the address at which to start
+					the write. */
+	int retval = 0;
+	int i;
+
+	if (size < sizeof(txbuf_most)) {
+		/* Avoid an allocation if we can help it. */
+		txbuf = txbuf_most;
+	} else {
+		/* over 16 bytes write we'll need to allocate a temp buffer */
+		txbuf = kzalloc(size + 1, GFP_KERNEL);
+		if (!txbuf)
+			return -ENOMEM;
+	}
+
+	/* Yes, it stinks here that we have to copy the buffer */
+	/* We copy from valp to txbuf leaving
+	the first location open for the address */
+	for (i = 0; i < size; i++)
+		txbuf[i + 1] = valp[i];
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+	txbuf[0] = address & 0xff; /* put the address in the first byte */
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, size + 1);
+
+	/* TODO: Add in retyr on writes only in certian error return values */
+	if (retval != 1) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+exit:
+
+	mutex_unlock(&page_mutex);
+	if (txbuf != txbuf_most)
+		kfree(txbuf);
+	return retval;
+}
+
+/*
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ */
+static irqreturn_t
+i2c_attn_isr(int irq, void *info)
+{
+	struct instance_data *instancedata = info;
+
+	disable_irq_nosync(instancedata->irq);
+
+	if (instancedata->rmiphysdrvr.attention) {
+		instancedata->rmiphysdrvr.attention(&instancedata->rmiphysdrvr,
+			instancedata->instance_no);
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
+
+	struct instance_data *instancedata;
+	int retval = 0;
+	int irqtype = 0;
+
+	struct rmi_i2c_platformdata *platformdata;
+
+	if (client == NULL) {
+		printk(KERN_ERR "%s: Invalid NULL client received.", __func__);
+		return -EINVAL;
+	}
+
+	printk(KERN_DEBUG "%s: Probing i2c RMI device, addr: 0x%02x", __func__, client->addr);
+
+	/* Egregiously horrible delay here that seems to prevent I2C disasters on
+	 * certain broken dev systems.  In most cases, you can safely remove this.
+	 * TODO: convert this to a parameter than can be spec'ed at boot time,
+	 * so not everyone needs to suffer.
+	 */
+	mdelay(1000);
+
+	/* Allocate and initialize the instance data for this client */
+	instancedata = kzalloc(sizeof(*instancedata), GFP_KERNEL);
+	if (!instancedata) {
+		dev_err(&client->dev,
+			"%s: Out of memory trying to allocate instance_data.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	instancedata->rmiphysdrvr.name           = DRIVER_NAME;
+	instancedata->rmiphysdrvr.write          = rmi_i2c_write;
+	instancedata->rmiphysdrvr.read           = rmi_i2c_read;
+	instancedata->rmiphysdrvr.write_multiple = rmi_i2c_write_multiple;
+	instancedata->rmiphysdrvr.read_multiple  = rmi_i2c_read_multiple;
+	instancedata->rmiphysdrvr.module         = THIS_MODULE;
+
+	/* Set default to polling in case no matching platform data is located
+	for this device. We'll still work but in polling mode since we didn't
+	find any irq info */
+	instancedata->rmiphysdrvr.polling_required = true;
+
+	instancedata->page = 0xffff; /* Force a set page the first time */
+
+	/* cast to our struct rmi_i2c_platformdata so we know
+	the fields (see rmi_ic2.h) */
+	platformdata = client->dev.platform_data;
+	if (platformdata == NULL) {
+		printk(KERN_ERR "%s: CONFIGURATION ERROR - platform data is NULL.", __func__);
+		return -EINVAL;
+	}
+
+	printk(KERN_DEBUG "%s: sensor addr: 0x%02x irq: 0x%x type: %d",
+		__func__, platformdata->i2c_address, platformdata->irq, platformdata->irq_type);
+	if (client->addr != platformdata->i2c_address) {
+		printk(KERN_ERR "%s: CONFIGURATION ERROR - client I2C address 0x%02x doesn't match platform data address 0x%02x.", __func__, client->addr, platformdata->i2c_address);
+		return -EINVAL;
+	}
+
+	instancedata->instance_no = device_count++;
+
+	/* set the device name using the instance_no appended
+	to DEVICE_NAME to make a unique name */
+	dev_set_name(&client->dev,
+		"rmi4-i2c%d", instancedata->instance_no);
+
+	/* Determine if we need to poll (inefficient) or use interrupts.
+	*/
+	if (platformdata->irq) {
+		instancedata->irq = platformdata->irq;
+		switch (platformdata->irq_type) {
+		case IORESOURCE_IRQ_HIGHEDGE:
+			irqtype = IRQF_TRIGGER_RISING;
+			break;
+		case IORESOURCE_IRQ_LOWEDGE:
+			irqtype = IRQF_TRIGGER_FALLING;
+			break;
+		case IORESOURCE_IRQ_HIGHLEVEL:
+			irqtype = IRQF_TRIGGER_HIGH;
+			break;
+		case IORESOURCE_IRQ_LOWLEVEL:
+			irqtype = IRQF_TRIGGER_LOW;
+			break;
+		default:
+			dev_warn(&client->dev,
+				"%s: Invalid IRQ flags in platform data.\n",
+				__func__);
+			kfree(instancedata);
+			return -ENXIO;
+		}
+
+		instancedata->rmiphysdrvr.polling_required = false;
+		instancedata->rmiphysdrvr.irq = instancedata->irq;
+
+	} else {
+		instancedata->rmiphysdrvr.polling_required = true;
+		dev_info(&client->dev,
+				"%s: No IRQ info given. Polling required.\n",
+				__func__);
+	}
+
+	/* Store the instance data in the i2c_client - we need to do this prior
+	* to calling register_physical_driver since it may use the read, write
+	* functions. If nothing was found then the id fields will be set to 0
+	* for the irq and the default  will be set to polling required so we
+	* will still work but in polling mode. */
+	i2c_set_clientdata(client, instancedata);
+
+	/* Copy i2c_client pointer into instance_data's i2c_client pointer for
+	later use in rmi4_read, rmi4_write, etc. */
+	instancedata->i2cclient = client;
+
+	/* Register sensor drivers - this will call the detect function that
+	* will then scan the device and determine the supported RMI4 sensors
+	* and functions.
+	*/
+	retval = rmi_register_sensor(&instancedata->rmiphysdrvr, platformdata->perfunctiondata);
+	if (retval) {
+		dev_err(&client->dev, "%s: Failed to Register %s sensor drivers\n",
+				__func__, instancedata->rmiphysdrvr.name);
+		i2c_set_clientdata(client, NULL);
+		kfree(instancedata);
+		return retval;
+	}
+
+	if (instancedata->rmiphysdrvr.polling_required == false) {
+		retval = request_irq(instancedata->irq, i2c_attn_isr,
+				irqtype, "rmi_i2c", instancedata);
+		if (retval) {
+			dev_err(&client->dev, "%s: failed to obtain IRQ %d. Result: %d.",
+				__func__, instancedata->irq, retval);
+			dev_info(&client->dev, "%s: Reverting to polling.\n", __func__);
+			instancedata->rmiphysdrvr.polling_required = true;
+			/* TODO: Need to revert back to polling - create and start timer, turn off interrupts for each fn */
+		} else {
+			dev_dbg(&client->dev, "%s: got irq.\n", __func__);
+		}
+	}
+
+	dev_dbg(&client->dev, "%s: Successfully registered %s sensor driver.\n",
+			__func__, instancedata->rmiphysdrvr.name);
+
+	printk(KERN_INFO "%s: Successfully registered %s sensor driver.\n", __func__, instancedata->rmiphysdrvr.name);
+
+	return retval;
+}
+
+/* The Driver remove function.  We tear down the instance data and unregister
+ * the phys driver in this call.
+ */
+static int
+rmi_i2c_remove(struct i2c_client *client)
+{
+	struct instance_data *instancedata =
+		i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s: Unregistering phys driver %s\n", __func__,
+		instancedata->rmiphysdrvr.name);
+
+	rmi_unregister_sensors(&instancedata->rmiphysdrvr);
+
+	dev_dbg(&client->dev, "%s: Unregistered phys driver %s\n",
+			__func__, instancedata->rmiphysdrvr.name);
+
+	/* only free irq if we have an irq - otherwise the instance_data
+	will be 0 for that field */
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
+static int
+rmi_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	/* Touch sleep mode */
+	return 0;
+}
+
+static int
+rmi_i2c_resume(struct i2c_client *client)
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
+	.probe		= rmi_i2c_probe,
+	.remove		= rmi_i2c_remove,
+	.suspend	= rmi_i2c_suspend,
+	.resume		= rmi_i2c_resume,
+	.driver = {
+		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.id_table	= rmi_i2c_id_table,
+};
+
+/*
+ * Register ourselves with i2c Chip Driver.
+ *
+ */
+static int __init rmi_phys_i2c_init(void)
+{
+	return i2c_add_driver(&rmi_i2c_driver);
+}
+
+/*
+ * Un-register ourselves from the i2c Chip Driver.
+ *
+ */
+static void __exit rmi_phys_i2c_exit(void)
+{
+	i2c_del_driver(&rmi_i2c_driver);
+}
+
+
+module_init(rmi_phys_i2c_init);
+module_exit(rmi_phys_i2c_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_i2c.h b/drivers/input/touchscreen/rmi_i2c.h
new file mode 100644
index 0000000..df1290f
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.h
@@ -0,0 +1,50 @@
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
+#ifndef _RMI_I2C_H
+#define _RMI_I2C_H
+
+#include "rmi_platformdata.h"
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
+	/* The type of the irq (e.g., IRQF_TRIGGER_FALLING).
+	Only valid if irq != 0 */
+	int irq_type;
+	/* Use this to specify non-default settings on a per function basis. */
+	struct rmi_functiondata_list *perfunctiondata;
+};
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_spi.c b/drivers/input/touchscreen/rmi_spi.c
new file mode 100644
index 0000000..2e49ea8
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.c
@@ -0,0 +1,474 @@
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
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/semaphore.h>
+#include "rmi_spi.h"
+#include "rmi_drvr.h"
+
+#define DRIVER_NAME "rmi4_ts"
+#define DEVICE_NAME "rmi4_ts"
+
+#define RMI_TDPB	65 /* 65 microseconds inter-byte delay between bytes for RMI chip*/
+#define	SPI_BUFSIZ	32
+
+static u8 *buf;
+
+/** This is a count of how many clients are accessing this driver.
+ */
+static int num_clients;
+static struct rmi_spi_platformdata *platformdata;
+
+
+/**
+ * This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various elements
+ * inside.
+ */
+struct instance_data {
+	int instance_no;
+	int irq;
+	struct rmi_phys_driver rpd;
+	struct spi_device *spidev;
+};
+
+
+static int spi_xfer(struct spi_device *spi,
+		const u8 *txbuf, unsigned n_tx,
+		u8 *rxbuf, unsigned n_rx)
+{
+	static DECLARE_MUTEX(lock);
+
+	int			status;
+	struct spi_message	message;
+	struct spi_transfer	x[2];
+	u8			*local_buf;
+
+
+	if ((n_tx + n_rx) > SPI_BUFSIZ)
+		return -EINVAL;
+
+	spi_message_init(&message);
+	memset(x, 0, sizeof x);
+	if (n_tx) {
+		x[0].len = n_tx;
+		x[0].delay_usecs = RMI_TDPB;
+		spi_message_add_tail(&x[0], &message);
+	}
+	if (n_rx) {
+#ifdef CONFIG_ARCH_OMAP
+		x[1].len = n_rx-1;	/* since OMAP has one dummy byte. */
+#else
+		x[1].len = n_rx;
+#endif
+		x[1].delay_usecs = RMI_TDPB;
+		spi_message_add_tail(&x[1], &message);
+	}
+
+	/* ... unless someone else is using the pre-allocated buffer */
+	if (down_trylock(&lock)) {
+		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+		if (!local_buf)
+			return -ENOMEM;
+	} else
+		local_buf = buf;
+
+	memcpy(local_buf, txbuf, n_tx);
+
+
+	x[0].tx_buf = local_buf;
+	x[1].rx_buf = local_buf + n_tx;
+
+	/* do the i/o */
+	status = spi_sync(spi, &message);
+	if (status == 0) {
+		memcpy(rxbuf, x[1].rx_buf, n_rx);
+		status = message.status;
+	} else {
+		printk(KERN_ERR "spi_sync fials!\n");
+	}
+
+	if (x[0].tx_buf == buf)
+		up(&lock);
+	else
+		kfree(local_buf);
+
+	return status;
+}
+
+/**
+ * Read a single register through spi.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read(struct rmi_phys_driver *pd, unsigned short address, char *valp)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+
+	char rxbuf[2];
+	int retval;
+	unsigned short addr = address;
+
+	addr = ((addr & 0xff00) >> 8);
+	address = ((address & 0x00ff) << 8);
+	addr |= address;
+	addr |= 0x80;		/* High bit set indicates read. */
+
+	retval = spi_xfer(id->spidev, (u8 *)&addr, 2, rxbuf, 1);
+
+	*valp = rxbuf[0];
+
+	return retval;
+}
+
+/**
+ * Same as rmi_spi_read, except that multiple bytes are allowed to be read.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	int retval;
+
+	unsigned short addr = address;
+
+	addr = ((addr & 0xff00) >> 8);
+	address = ((address & 0x00ff) << 8);
+	addr |= address;
+	addr |= 0x80;		/* High bit set indicates read. */
+
+	retval = spi_xfer(id->spidev, (u8 *)&addr, 2, valp, size);
+
+	return retval;
+}
+
+/**
+ * Write a single register through spi.
+ * You can write multiple registers at once, but I made the functions for that
+ * seperate for performance reasons.  Writing multiple requires allocation and
+ * freeing.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] data The data to be written.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write(struct rmi_phys_driver *pd, unsigned short address, char data)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[4];
+	int retval;
+
+	txbuf[2]  = data;
+	txbuf[1]  = address;
+	txbuf[0]  = address>>8;
+
+	retval = spi_xfer(id->spidev, txbuf, 3, NULL, 0);
+	return retval ? 0 : 1;
+}
+
+/**
+ * Write multiple registers.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] valp A pointer to a buffer containing the data to be written.
+ * \param[in] size The number of bytes to write.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[32];
+	int retval;
+	int i;
+
+	txbuf[1]  = address;
+	txbuf[0]  = address>>8;
+
+	for (i = 0; i < size; i++)
+		txbuf[i + 2] = valp[i];
+
+	retval = spi_xfer(id->spidev, txbuf, size+2, NULL, 0);
+
+	return retval ? 0 : 1;
+}
+
+/**
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ */
+static irqreturn_t spi_attn_isr(int irq, void *info)
+{
+	struct instance_data *id = info;
+	disable_irq(id->irq);
+	if (id->rpd.attention)
+		id->rpd.attention(&id->rpd, id->instance_no);
+	return IRQ_HANDLED;
+}
+
+
+static int rmi_spi_probe(struct spi_device *spi)
+{
+	struct instance_data *id;
+	int retval;
+	int i;
+	bool found;
+	struct rmi_spi_data *rmispidata;
+	struct rmi_spi_platformdata *platformdata;
+
+	printk(KERN_DEBUG "Probing RMI4 SPI device\n");
+
+	found = false;
+
+	spi->bits_per_word = 8;
+
+	spi->mode = SPI_MODE_3;
+
+	buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_ERR "%s: Out of memory - can't allocate memory for spi buffer\n", __func__);
+		return -ENOMEM;
+	}
+
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: spi_setup failed.", __func__);
+		return retval;
+	}
+
+	id = kzalloc(sizeof(*id), GFP_KERNEL);
+	if (!id) {
+		printk(KERN_ERR "%s: Out of memory - can't allocate memory for instance data.", __func__);
+		return -ENOMEM;
+	}
+
+	id->spidev             = spi;
+	id->rpd.name           = DRIVER_NAME;
+	id->rpd.write          = rmi_spi_write;
+	id->rpd.read           = rmi_spi_read;
+	id->rpd.write_multiple = rmi_spi_write_multiple;
+	id->rpd.read_multiple  = rmi_spi_read_multiple;
+	id->rpd.module         = THIS_MODULE;
+	id->rpd.polling_required = true; /* default to polling if irq not used */
+
+	/* Loop through the client data and locate the one that was found. */
+
+	rmispidata = spi->dev.platform_data;
+
+	/* Loop through the platform data and locate the one that matches the clients address */
+	for (i = 0; i < rmispidata->num_clients; i++) {
+		platformdata = &(rmispidata->platformdata[i]);
+		if (platformdata->chip == RMI_SUPPORT) {
+			id->instance_no = i;
+			found = true;
+
+			/* set the device name using the instance_no appended to DEVICE_NAME to make a unique name */
+			dev_set_name(&spi->dev, "rmi4-spi%d", id->instance_no);
+			/*
+			* Determine if we need to poll (inefficient) or use interrupts.
+			*/
+			if (platformdata->irq) {
+				int irqtype;
+
+				id->irq = platformdata->irq;
+				switch (platformdata->irq_type) {
+				case IORESOURCE_IRQ_HIGHEDGE:
+					irqtype = IRQF_TRIGGER_RISING;
+					break;
+				case IORESOURCE_IRQ_LOWEDGE:
+					irqtype = IRQF_TRIGGER_FALLING;
+					break;
+				case IORESOURCE_IRQ_HIGHLEVEL:
+					irqtype = IRQF_TRIGGER_HIGH;
+					break;
+				case IORESOURCE_IRQ_LOWLEVEL:
+					irqtype = IRQF_TRIGGER_LOW;
+					break;
+				default:
+					dev_warn(&spi->dev, "%s: Invalid IRQ flags in platform data.", __func__);
+					kfree(id);
+					return -ENXIO;
+				}
+
+				retval = request_irq(id->irq, spi_attn_isr, irqtype, "rmi_spi", id);
+				if (retval) {
+					dev_info(&spi->dev, "%s: Unable to get attn irq %d.  Reverting to polling.", __func__, id->irq);
+					id->rpd.polling_required = true;
+				} else {
+					dev_dbg(&spi->dev, "%s: got irq", __func__);
+					id->rpd.polling_required = false;
+					id->rpd.irq = id->irq;
+				}
+			} else {
+				id->rpd.polling_required = true;
+				dev_info(&spi->dev, "%s: No IRQ info given. Polling required.", __func__);
+			}
+		}
+	}
+
+	/* if went through all the platform data list and didn't find a match
+	 * then notify that we are defaulting to polling */
+	if (!found)
+		dev_info(&spi->dev, "%s: No platform data match found. Defaulting to use polling.", __func__);
+
+	/* Store instance data for later access. */
+	if (id)
+		spi_set_drvdata(spi, id);
+
+	/* Register the sensor driver - which will trigger a scan of the PDT. */
+	retval = rmi_register_sensor(&id->rpd, platformdata->perfunctiondata);
+	if (retval) {
+		printk(KERN_ERR "rmi_register_phys_driver failed with code %d.", retval);
+		if (id->irq)
+			free_irq(id->irq, id);
+		kfree(id);
+		return retval;
+	}
+
+	printk(KERN_DEBUG "%s: Successfully Registered %s.", __func__, id->rpd.name);
+
+	return 0;
+}
+
+static int rmi_spi_suspend(struct spi_device *spi, pm_message_t message)
+{
+	return 0;
+}
+
+static int rmi_spi_resume(struct spi_device *spi)
+{
+	return 0;
+}
+
+static int __devexit rmi_spi_remove(struct spi_device *spi)
+{
+	struct instance_data *id = spi_get_drvdata(spi);
+
+	rmi_spi_suspend(spi, PMSG_SUSPEND);
+
+	rmi_unregister_sensors(&id->rpd);
+
+	if (id) {
+		if (id->irq)
+			free_irq(id->irq, id);
+		kfree(id);
+	}
+
+	return 0;
+}
+
+static struct spi_driver rmi_spi_driver = {
+	.driver = {
+		.name  = "rmi_spi",
+		.bus   = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe    = rmi_spi_probe,
+	.remove   = __devexit_p(rmi_spi_remove),
+	.suspend  = rmi_spi_suspend,
+	.resume   = rmi_spi_resume,
+};
+
+/**
+ * The Platform Driver probe function.  We just tell the spi subsystem about
+ * ourselves in this call.
+ */
+static int
+rmi_spi_plat_probe(struct platform_device *dev)
+{
+	struct rmi_spi_data *mid = dev->dev.platform_data;
+
+	if (!mid) {
+		printk(KERN_ERR "A platform device must contain rmi_spi_data\n");
+		return -ENXIO;
+	}
+
+	num_clients = mid->num_clients;
+	platformdata  = mid->platformdata;
+
+	return spi_register_driver(&rmi_spi_driver);
+}
+
+/**
+ * Tell the spi subsystem that we're done.
+ * \param[in] dev
+ * \return Always returns 0.
+ */
+static int
+rmi_spi_plat_remove(struct platform_device *dev)
+{
+	spi_unregister_driver(&rmi_spi_driver);
+	return 0;
+}
+
+/**
+ * Structure used to tell the Platform Driver subsystem about us.
+ */
+static struct platform_driver rmi_spi_platform_driver = {
+	.driver		= {
+		.name	= "rmi_spi_plat",
+	},
+	.probe		= rmi_spi_plat_probe,
+	.remove		= rmi_spi_plat_remove,
+};
+
+static int __init rmi_spi_init(void)
+{
+	return platform_driver_register(&rmi_spi_platform_driver);
+}
+module_init(rmi_spi_init);
+
+static void __exit rmi_spi_exit(void)
+{
+	kfree(buf);
+	buf = NULL;
+	platform_driver_unregister(&rmi_spi_platform_driver);
+}
+module_exit(rmi_spi_exit);
+
+/** Standard driver module information - the author of the module.
+ */
+MODULE_AUTHOR("Synaptics, Inc.");
+/** Standard driver module information - a summary description of this module.
+ */
+MODULE_DESCRIPTION("RMI4 Driver SPI Physical Layer");
+/** Standard driver module information - the license under which this module
+ * is included in the kernel.
+ */
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/input/touchscreen/rmi_spi.h b/drivers/input/touchscreen/rmi_spi.h
new file mode 100644
index 0000000..0744e8d
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.h
@@ -0,0 +1,55 @@
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
+#if !defined(RMI_SPI_H)
+#define RMI_SPI_H
+
+#include "rmi_platformdata.h"
+
+#define RMI_CHIP_VER_3	0
+#define RMI_CHIP_VER_4	1
+
+#define RMI_SUPPORT (RMI_CHIP_VER_3|RMI_CHIP_VER_4)
+
+/** Platform-specific configuration data.
+ * This structure is used by the platform-specific driver to designate
+ * specific information about the hardware.  A platform client may supply
+ * an array of these to the rmi_phys_spi driver.
+ */
+struct rmi_spi_platformdata {
+	/* struct spi_device spi_dev; */
+	int chip;
+
+	/* The number of the irq.  Set to zero if polling is required. */
+	int irq;
+
+	/* The type of the irq (e.g., IRQF_TRIGGER_FALLING).  Only valid if
+	* irq != 0 */
+	int irq_type;
+
+	/* Use this to specify non-default settings on a per function basis. */
+	struct rmi_functiondata_list *perfunctiondata;
+};
+
+#endif
diff --git a/drivers/input/touchscreen/rmi.h b/drivers/input/touchscreen/rmi.h
new file mode 100644
index 0000000..072d0c3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi.h
@@ -0,0 +1,170 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Header File.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
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
+#ifndef _RMI_H
+#define _RMI_H
+
+/*  RMI4 Protocol Support
+ */
+
+/* For each function present on the RMI device, we need to get the RMI4 Function
+ * Descriptor info from the Page Descriptor Table. This will give us the
+ * addresses for Query, Command, Control, Data and the Source Count (number
+ * of sources for this function) and the function id.
+ */
+struct rmi_function_descriptor {
+	unsigned char queryBaseAddr;
+	unsigned char commandBaseAddr;
+	unsigned char controlBaseAddr;
+	unsigned char dataBaseAddr;
+	unsigned char interruptSrcCnt;
+	unsigned char functionNum;
+};
+
+/*  This encapsulates the information found using the RMI4 Function $01
+ *  query registers. There is only one Function $01 per device.
+ *
+ *  Assuming appropriate endian-ness, you can populate most of this
+ *  structure by reading query registers starting at the query base address
+ *  that was obtained from RMI4 function 0x01 function descriptor info read
+ *  from the Page Descriptor Table.
+ *
+ *  Specific register information is provided in the comments for each field.
+ *  For further reference, please see the "Synaptics RMI 4 Interfacing
+ *  Guide" document : go to http://www.synaptics.com/developers/manuals - and
+ *  select "Synaptics RMI 4 Interfacting Guide".
+ */
+struct rmi_F01_query {
+	/* The Protocol Major Version number.*/
+	unsigned rmi_maj_ver;
+
+	/* The Protocol Minor Version number.*/
+	unsigned rmi_min_ver;
+
+	/* The manufacturer identification byte.*/
+	unsigned char mfgid;
+
+	/* The Product Properties information.*/
+	unsigned char properties;
+
+	/* The product info bytes.*/
+	unsigned char prod_info[2];
+
+	/* Date Code - Year, Month, Day.*/
+	unsigned char date_code[3];
+
+	/* Tester ID (14 bits).*/
+	unsigned short tester_id;
+
+	/* Serial Number (14 bits).*/
+	unsigned short serial_num;
+
+	/* A null-terminated string that identifies this particular product.*/
+	char prod_id[11];
+};
+
+/* This encapsulates the F01 Device Control control registers.
+ * TODO: This isn't right.  The number of interrupt enables needs to be determined
+ * dynamically as the sensor is initialized.  Fix this.
+ */
+struct rmi_F01_control {
+    unsigned char deviceControl;
+    unsigned char interruptEnable[1];
+};
+
+/** This encapsulates the F01 Device Control data registers.
+ * TODO: This isn't right.  The number of irqs needs to be determined
+ * dynamically as the sensor is initialized.  Fix this.
+ */
+struct rmi_F01_data {
+    unsigned char deviceStatus;
+    unsigned char irqs[1];
+};
+
+
+/**********************************************************/
+
+/** This is the data read from the F11 query registers.
+ */
+struct rmi_F11_device_query {
+    bool hasQuery9;
+    unsigned char numberOfSensors;
+};
+
+struct rmi_F11_sensor_query {
+    bool configurable;
+    bool hasSensitivityAdjust;
+    bool hasGestures;
+    bool hasAbs;
+    bool hasRel;
+    unsigned char numberOfFingers;
+    unsigned char numberOfXElectrodes;
+    unsigned char numberOfYElectrodes;
+    unsigned char maximumElectrodes;
+    bool hasAnchoredFinger;
+    unsigned char absDataSize;
+};
+
+struct rmi_F11_control {
+    bool relativeBallistics;
+    bool relativePositionFilter;
+    bool absolutePositionFilter;
+    unsigned char reportingMode;
+    bool manuallyTrackedFinger;
+    bool manuallyTrackedFingerEnable;
+    unsigned char motionSensitivity;
+    unsigned char palmDetectThreshold;
+    unsigned char deltaXPosThreshold;
+    unsigned char deltaYPosThreshold;
+    unsigned char velocity;
+    unsigned char acceleration;
+    unsigned short sensorMaxXPos;
+    unsigned short sensorMaxYPos;
+};
+
+
+/**********************************************************/
+
+/** This is the data read from the F19 query registers.
+ */
+struct rmi_F19_query {
+	bool hasHysteresisThreshold;
+	bool hasSensitivityAdjust;
+	bool configurable;
+	unsigned char buttonCount;
+};
+
+struct rmi_F19_control {
+	unsigned char buttonUsage;
+	unsigned char filterMode;
+	unsigned char *intEnableRegisters;
+	unsigned char *singleButtonControl;
+	unsigned char *sensorMap;
+	unsigned char *singleButtonSensitivity;
+	unsigned char globalSensitivityAdjustment;
+	unsigned char globalHysteresisThreshold;
+};
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_platformdata.h b/drivers/input/touchscreen/rmi_platformdata.h
new file mode 100644
index 0000000..3352381
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_platformdata.h
@@ -0,0 +1,93 @@
+/**
+ *
+ * Synaptics RMI platform data definitions for use in board files.
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
+#if !defined(RMI_PLATFORMDATA_H)
+#define RMI_PLATFORMDATA_H
+
+#define RMI_F01_INDEX 0x01
+#define RMI_F11_INDEX 0x11
+#define RMI_F19_INDEX 0x19
+#define RMI_F34_INDEX 0x34
+
+
+/* A couple of structs that are useful for frequently occuring constructs, such
+ * as coordinate origin offsets or coordinate clipping values.
+ */
+struct rmi_XY_pair {
+	int x;
+	int y;
+};
+
+struct rmi_range {
+	int min;
+	int max;
+};
+
+/* This contains the per-function customization for a given function.  We store
+ * the data this way in order to avoid allocating a large sparse array - typically
+ * only a few functions are present on a sensor, and even fewer will be have
+ * custom settings.  There is a very small penalty paid for doing a linear
+ * search through the list to find a given function's data, but since the list
+ * is typically very short and is searched only at system boot time, this is
+ * considered acceptable.
+ *
+ * When adding new fields to a functiondata struct, please follow these rules:
+ *     - Where possible, use 0 to indicate that the value should be defaulted.
+ *       This works pretty well for bools, ints, and chars.
+ *     - Where this is not practical (for example, in coordinate offsets or
+ *       range clipping), use a pointer.  Set that pointer to null to indicate
+ *       that the value should be defaulted.
+ */
+struct rmi_functiondata {
+	unsigned char	function_index;
+	void		*data;
+};
+
+/* This can be included in the platformdata for SPI or I2C RMI4 devices to
+ * customize the settings of the functions on a given sensor.
+ */
+struct rmi_functiondata_list {
+	unsigned char	count;	/* Number of elements in the array */
+	struct rmi_functiondata *functiondata;
+};
+
+struct rmi_f11_functiondata {
+	bool	swap_axes;
+	bool	flipX;
+	bool	flipY;
+	struct rmi_XY_pair *offset;
+	struct rmi_range *clipX;
+	struct rmi_range *clipY;
+};
+
+struct rmi_button_map {
+	unsigned char nbuttons;
+	unsigned char *map;
+};
+
+struct rmi_f19_functiondata {
+	struct rmi_button_map *button_map;
+};
+
+#endif
\ No newline at end of file
diff --git a/drivers/input/touchscreen/rmi_drvr.h b/drivers/input/touchscreen/rmi_drvr.h
new file mode 100644
index 0000000..460e25a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_drvr.h
@@ -0,0 +1,96 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) RMI Driver Header File.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
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
+#include "rmi.h"
+
+#ifndef _RMI_DRVR_H
+#define _RMI_DRVR_H
+
+#include "rmi_platformdata.h"
+
+/*  RMI4 Protocol Support
+ */
+
+struct rmi_phys_driver {
+	char *name;
+	int (*write)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char data);
+	int (*read)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char *buffer);
+	int (*write_multiple)(struct rmi_phys_driver *physdrvr,
+			unsigned short address, char *buffer, int length);
+	int (*read_multiple)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char *buffer, int length);
+	void (*attention)(struct rmi_phys_driver *physdrvr, int instance);
+	bool polling_required;
+	int irq;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head drivers;
+	struct rmi_sensor_driver *sensor;
+	struct module *module;
+};
+
+int rmi_read(struct rmi_sensor_driver *sensor, unsigned short address, char *dest);
+int rmi_write(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char data);
+int rmi_read_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		char *dest, int length);
+int rmi_write_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char *data, int length);
+int rmi_register_sensor(struct rmi_phys_driver *physdrvr,
+						 struct rmi_functiondata_list *perfunctiondata);
+int rmi_unregister_sensors(struct rmi_phys_driver *physdrvr);
+
+/* Set this to 1 to turn on code used in detecting buffer leaks. */
+#define RMI_ALLOC_STATS 1
+
+#if RMI_ALLOC_STATS
+extern int appallocsrmi;
+extern int rfiallocsrmi;
+extern int fnallocsrmi;
+
+#define INC_ALLOC_STAT(X)   (X##allocsrmi++)
+#define DEC_ALLOC_STAT(X)   \
+	do { \
+		if (X##allocsrmi) X##allocsrmi--; \
+		else printk(KERN_DEBUG "Too many " #X " frees\n"); \
+	} while (0)
+#define CHECK_ALLOC_STAT(X) \
+	do { \
+		if (X##allocsrmi) \
+			printk(KERN_DEBUG "Left over " #X " buffers: %d\n", \
+					X##allocsrmi); \
+	} while (0)
+#else
+#define INC_ALLOC_STAT(X) do { } while (0)
+#define DEC_ALLOC_STAT(X) do { } while (0)
+#define CHECK_ALLOC_STAT(X) do { } while (0)
+#endif
+
+#endif
