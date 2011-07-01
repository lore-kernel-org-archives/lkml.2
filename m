Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1GAFjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:39:23 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963Ab1GAFhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:19 -0400
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
Subject: [PATCH 1/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:08 -0700
Message-Id: <1309497556-7344-2-git-send-email-cheiny@synaptics.com>
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

diff --git a/drivers/input/touchscreen/rmi_bus.c b/drivers/input/touchscreen/rmi_bus.c
new file mode 100644
index 0000000..155cb4f
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.c
@@ -0,0 +1,383 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Bus Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
+ *
+ * Implements "rmi" bus per Documentation/driver-model/bus.txt
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
+/*
+ * This method is called, perhaps multiple times, whenever a new device or
+ * driver is added for this bus. It should return a nonzero value if the given
+ * device can be handled by the given driver. This function must be handled at
+ * the bus level, because that is where the proper logic exists; the core
+ * kernel cannot know how to match devices and drivers for every possible bus
+ * type The match function does a comparison between the hardware ID provided
+ * by the device itself and the IDs supported by the driver.
+ *
+ */
+static int rmi_bus_match(struct device *dev, struct device_driver *driver)
+{
+	dev_dbg(dev, "%s: Matching driver %s against bus %s for rmi bus.\n",
+		 __func__, driver->name, dev->bus->name);
+	return !strcmp(dev->bus->name, driver->name);
+}
+
+/* Stub for now.
+ */
+static int rmi_bus_suspend(struct device *dev, pm_message_t state)
+{
+	dev_dbg(dev, "%s: RMI bus suspending.", __func__);
+	return 0;
+}
+
+/* Stub for now.
+ */
+static int rmi_bus_resume(struct device *dev)
+{
+	dev_dbg(dev, "%s: RMI bus resuming.", __func__);
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
+ * the PDT - such as a reflash of the firmware - then the device should be
+ * re-added to the bus and the PDT re-scanned and cached.
+ *
+ */
+int rmi_register_sensor(struct rmi_phys_driver *rpd,
+			struct rmi_sensordata *sensordata)
+{
+	int i;
+	int pdt_entry_count = 0;
+	struct rmi_sensor_device *rmi_sensor_dev = NULL;
+	struct rmi_function_descriptor rmi_fd;
+	int retval;
+	static int index;
+
+	/* Make sure we have a read, write, read_multiple, write_multiple
+	   function pointers from whatever physical layer the sensor is on.
+	 */
+	if (!rpd->name) {
+		pr_err("%s: Physical driver must specify a name", __func__);
+		return -EINVAL;
+	}
+	if (!rpd->write) {
+		pr_err("%s: Physical driver %s must specify a writer.",
+		       __func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read) {
+		pr_err("%s: Physical driver %s must specify a reader.",
+		       __func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->write_multiple) {
+		pr_err("%s: Physical driver %s must specify a "
+		       "multiple writer.", __func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read_multiple) {
+		pr_err("%s: Physical driver %s must specify a "
+		       "multiple reader.", __func__, rpd->name);
+		return -EINVAL;
+	}
+
+	/* Get some information from the device */
+	pr_debug("%s: Identifying sensors by presence of F01...", __func__);
+
+	/* Scan the page descriptor table until we find F01.  If we find that,
+	 * we assume that we can reliably talk to this sensor.
+	 */
+	for (i = PDT_START_SCAN_LOCATION;
+	     i >= PDT_END_SCAN_LOCATION; i -= PDT_ENTRY_SIZE) {
+		retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+					    sizeof(rmi_fd));
+		if (retval) {
+			/* failed to read next PDT entry - end PDT
+			   scan - this may result in an incomplete set
+			   of recognized functions - should probably
+			   return an error but the driver may still be
+			   viable for diagnostics and debugging so let's
+			   let it continue. */
+			pr_err
+			    ("%s: Read Error %d when reading next PDT entry - "
+			     "ending PDT scan.", __func__, retval);
+			break;
+		}
+
+		if (rmi_fd.function_number == 0x00
+		    || rmi_fd.function_number == 0xff) {
+			/* A zero or 0xff in the function number
+			   signals the end of the PDT */
+			pr_debug("%s:   Found End of PDT.", __func__);
+			break;
+		}
+		pdt_entry_count++;
+		if ((rmi_fd.function_number & 0xff) == 0x01) {
+			pr_debug("%s: F01 Found - RMI Device Control",
+				 __func__);
+
+			/* This appears to be a valid device, so create a sensor
+			 * device and sensor driver for it. */
+			rmi_sensor_dev =
+			    kzalloc(sizeof(*rmi_sensor_dev), GFP_KERNEL);
+			if (!rmi_sensor_dev) {
+				pr_err
+				    ("%s: Error allocating memory for "
+				     "rmi_sensor_device",
+				     __func__);
+				retval = -ENOMEM;
+				goto exit_fail;
+			}
+			rmi_sensor_dev->dev.bus = &rmi_bus_type;
+
+			retval =
+			    rmi_sensor_register_device(rmi_sensor_dev, index++);
+			if (retval < 0) {
+				pr_err
+				    ("%s: Error %d registering sensor device.",
+				     __func__, retval);
+				goto exit_fail;
+			}
+
+			rmi_sensor_dev->driver =
+			    rmi_sensor_create_driver(rmi_sensor_dev, rpd,
+						     sensordata);
+			if (!rmi_sensor_dev->driver) {
+				pr_err("%s: Failed to create sensor driver.",
+				       __func__);
+				goto exit_fail;
+			}
+
+			retval =
+			    rmi_sensor_register_driver(rmi_sensor_dev->driver);
+			if (retval < 0) {
+				pr_err
+				    ("%s: Error %d registering sensor driver.",
+				     __func__, retval);
+				goto exit_fail;
+			}
+
+			/* link the attn fn in the rpd to the sensor attn fn */
+			rpd->sensor = rmi_sensor_dev->driver;
+			rpd->attention = rmi_sensor_dev->driver->attention;
+
+			/* All done with this sensor, fall out of scan loop. */
+			break;
+		} else {
+			/* Just print out the function found for now */
+			pr_debug("%s: Found Function %02x - Ignored.\n",
+				 __func__, rmi_fd.function_number & 0xff);
+		}
+	}
+
+	/* If we actually found a sensor, keep it around. */
+	if (rmi_sensor_dev) {
+		pr_debug("%s: Registered sensor drivers.", __func__);
+		retval = 0;
+	} else {
+		pr_err("%s: Failed to find sensor. PDT contained %d entries.",
+		       __func__, pdt_entry_count);
+		retval = -ENODEV;
+		goto exit_fail;
+	}
+
+	return 0;
+
+exit_fail:
+	if (rmi_sensor_dev)
+		rmi_sensor_destroy_driver(rmi_sensor_dev->driver);
+	kfree(rmi_sensor_dev);
+	return retval;
+}
+EXPORT_SYMBOL(rmi_register_sensor);
+
+int rmi_unregister_sensors(struct rmi_phys_driver *rpd)
+{
+	if (rpd->sensor) {
+		pr_warning
+		    ("%s: WARNING: unregister of %s while %s still attached.",
+		     __func__, rpd->name, rpd->sensor->drv.name);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(rmi_unregister_sensors);
+
+static void rmi_bus_dev_release(struct device *dev)
+{
+	pr_debug("rmi bus device release\n");
+}
+
+int rmi_register_bus_device(struct device *rmibusdev)
+{
+	pr_debug("%s: Registering RMI4 bus device.\n", __func__);
+
+	/* Here, we simply fill in some of the embedded device structure
+	 * fields (which individual drivers should not need to know about),
+	 * and register the device with the driver core. */
+
+	rmibusdev->bus = &rmi_bus_type;
+	rmibusdev->parent = &rmi_bus_device;
+	rmibusdev->release = rmi_bus_dev_release;
+	dev_set_name(rmibusdev, "rmi");
+
+	/* If we wanted to add bus-specific attributes to the device,
+	 * we could do so here. */
+
+	return device_register(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_register_bus_device);
+
+void rmi_unregister_bus_device(struct device *rmibusdev)
+{
+	dev_dbg(rmibusdev, "%s: Unregistering bus device.", __func__);
+
+	device_unregister(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_unregister_bus_device);
+
+static int __init rmi_bus_init(void)
+{
+	int status = 0;
+
+	pr_info("%s: RMI Bus Driver Init", __func__);
+
+	/* Register the rmi bus */
+	rmi_bus_type.name = busname;
+	rmi_bus_type.match = rmi_bus_match;
+	rmi_bus_type.suspend = rmi_bus_suspend;
+	rmi_bus_type.resume = rmi_bus_resume;
+	status = bus_register(&rmi_bus_type);
+	if (status < 0) {
+		pr_err("%s: Error %d registering the rmi bus.", __func__,
+		       status);
+		goto err_exit;
+	}
+	pr_debug("%s: successfully registered bus.", __func__);
+
+	return 0;
+err_exit:
+	return status;
+}
+
+static void __exit rmi_bus_exit(void)
+{
+	pr_debug("%s: RMI Bus Driver Exit.", __func__);
+
+	rmi_unregister_bus_device(&rmi_bus_device);
+	bus_unregister(&rmi_bus_type);
+}
+
+/* Utility routine to handle writes to read-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's store function).
+ */
+ssize_t rmi_store_error(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	dev_warn(dev,
+		"RMI4 WARNING: Attempt to write %d characters to read-only "
+		"attribute %s.", count, attr->attr.name);
+	return -EPERM;
+}
+
+/* Utility routine to handle reads of write-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's show function).
+ */
+ssize_t rmi_show_error(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf)
+{
+	dev_warn(dev,
+		 "RMI4 WARNING: Attempt to read from write-only attribute %s.",
+		 attr->attr.name);
+	return -EPERM;
+}
+
+/* Register a sensor driver on the bus.
+ */
+int rmi_bus_register_sensor_driver(struct rmi_sensor_driver *sensor_driver)
+{
+	int retval = 0;
+
+	sensor_driver->drv.bus = &rmi_bus_type;
+	retval = driver_register(&sensor_driver->drv);
+	return retval;
+}
+EXPORT_SYMBOL(rmi_bus_register_sensor_driver);
+
+/* Remove a sensor driver from the bus.
+ */
+void rmi_bus_unregister_sensor_driver(struct rmi_sensor_driver *sensor_driver)
+{
+	driver_unregister(&sensor_driver->drv);
+}
+EXPORT_SYMBOL(rmi_bus_unregister_sensor_driver);
+
+module_init(rmi_bus_init);
+module_exit(rmi_bus_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_bus.h b/drivers/input/touchscreen/rmi_bus.h
new file mode 100644
index 0000000..66666ae
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.h
@@ -0,0 +1,34 @@
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
+#if !defined(_RMI_BUS_H)
+#define _RMI_BUS_H
+
+#include "rmi_sensor.h"
+
+int rmi_bus_register_sensor_driver(struct rmi_sensor_driver *sensor_driver);
+void rmi_bus_unregister_sensor_driver(struct rmi_sensor_driver *sensor_driver);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi.h b/drivers/input/touchscreen/rmi.h
new file mode 100644
index 0000000..7357819
--- /dev/null
+++ b/drivers/input/touchscreen/rmi.h
@@ -0,0 +1,72 @@
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
+#if !defined(_RMI_H)
+#define _RMI_H
+
+/*  RMI4 Protocol Support
+ */
+
+
+/* Every function on an RMI device is identified by a one byte function number.
+ * The hexadecimal representation of this byte is used in the function name.
+ * For example, the function identified by the byte 0x11 is referred to as
+ * F11 (or sometimes FN11).  In the extremely improbable event that F11 is no
+ * longer identified by 0x11, though, we provide these handy #defines.
+ */
+#define RMI_F01_INDEX 0x01
+#define RMI_F05_INDEX 0x05
+#define RMI_F11_INDEX 0x11
+#define RMI_F19_INDEX 0x19
+#define RMI_F34_INDEX 0x34
+#define RMI_F54_INDEX 0x54
+
+/* This byte has information about the communications protocol.  See the RMI4
+ * specification for details of what exactly is there.
+ */
+#define RMI_PROTOCOL_VERSION_ADDRESS 0xA0FD
+
+/* For each function present on the RMI device, we need to get the RMI4 Function
+ * Descriptor info from the Page Descriptor Table. This will give us the
+ * addresses for Query, Command, Control, Data and the Source Count (number
+ * of sources for this function) and the function id.
+ */
+struct rmi_function_descriptor {
+	unsigned char query_base_addr;
+	unsigned char command_base_addr;
+	unsigned char control_base_addr;
+	unsigned char data_base_addr;
+	unsigned char interrupt_source_count;
+	unsigned char function_number;
+};
+
+/* The product descriptor table starts here, and continues till we get
+ * a function ID of 0x00 or 0xFF.
+ */
+#define RMI_PDT_START_ADDRESS 0x00E9
+
+#define RMI_IS_VALID_FUNCTION_ID(id) (id != 0x00 && id != 0xFF)
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_platformdata.h b/drivers/input/touchscreen/rmi_platformdata.h
new file mode 100644
index 0000000..6dcbbaf
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_platformdata.h
@@ -0,0 +1,135 @@
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
+#if !defined(_RMI_PLATFORMDATA_H)
+#define _RMI_PLATFORMDATA_H
+
+#include "rmi.h"
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
+struct rmi_sensor_suspend_custom_ops {
+	/* This will be called when suspend or early_suspend is issued.
+	 * Use this for any initial setting related to IRQ (for Attention
+	 * signal) or anything else to lower power consumption. This will
+	 * be called before any internal process related to suspend mode. */
+	void (*rmi_sensor_custom_suspend) (void);
+	/* This will be called when resume or late_resume is issued. Use
+	 * this for any setting related to IRQ (for Attention signal) or
+	 * anything else to restore from low power mode. This will be called
+	 * after all internal process related to resume mode*/
+	void (*rmi_sensor_custom_resume) (void);
+	/* custom delay in millisecond waiting for stability of hardware
+	 * from low power mode */
+	int delay_resume;
+
+};
+/* This contains sensor specific data that is not specialized to I2C or SPI.
+ */
+struct rmi_sensordata {
+	/* This will be called from rmi_register_sensor().  You can use
+	 * it to set up gpios, IRQs, and other platform specific
+	 * infrastructure. */
+	int (*rmi_sensor_setup) (void);
+
+	/* This will be called when the sensor is unloaded.  Use this to release
+	 * gpios, IRQs, and other platform specific infrastructure. */
+	void (*rmi_sensor_teardown) (void);
+
+	/* Use this to customize non-default setting regarding suspend/resume */
+	struct rmi_sensor_suspend_custom_ops *custom_suspend_ops;
+	/* Use this to specify non-default settings on a per function basis. */
+	struct rmi_functiondata_list *perfunctiondata;
+};
+
+/* This contains the per-function customization for a given function.  We store
+ * the data this way in order to avoid allocating a large sparse array -
+ * typically only a few functions are present on a sensor, and even fewer
+ * will be have custom settings.  There is a very small penalty paid for
+ * doing a linear search through the list to find a given function's data,
+ * but since the list is typically very short and is searched only at system
+ * boot time, this is considered acceptable.
+ *
+ * When adding new fields to a functiondata struct, please follow these rules:
+ *     - Where possible, use 0 to indicate that the value should be defaulted.
+ *       This works pretty well for bools, ints, and chars.
+ *     - Where this is not practical (for example, in coordinate offsets or
+ *       range clipping), use a pointer.  Set that pointer to null to indicate
+ *       that the value should be defaulted.
+ */
+struct rmi_functiondata {
+	unsigned char function_index;
+	void *data;
+};
+
+/* This can be included in the platformdata for SPI or I2C RMI4 devices to
+ * customize the settings of the functions on a given sensor.
+ */
+struct rmi_functiondata_list {
+	unsigned char count;	/* Number of elements in the array */
+	struct rmi_functiondata *functiondata;
+};
+
+struct rmi_f01_functiondata {
+	/* What this does is product specific.  For most, but not all, RMI4
+	 * devices, you can set this to true in order to request the device
+	 * report data at half the usual rate.  This can be useful on slow
+	 * CPUs that don't have the resources to process data at the usual
+	 * rate.  However, the meaning of this field is product specific, and
+	 * you should consult the product spec for your sensor to find out
+	 * what this will do.
+	 */
+	bool nonstandard_report_rate;
+};
+
+struct rmi_f11_functiondata {
+	bool swap_axes;
+	bool flip_X;
+	bool flip_Y;
+	struct rmi_XY_pair *offset;
+	struct rmi_range *clip_X;
+	struct rmi_range *clip_Y;
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
diff --git a/drivers/input/touchscreen/rmi_drvr.h b/drivers/input/touchscreen/rmi_drvr.h
new file mode 100644
index 0000000..a306c01
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_drvr.h
@@ -0,0 +1,97 @@
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
+#if !defined(_RMI_DRVR_H)
+#define _RMI_DRVR_H
+
+#include "rmi.h"
+#include "rmi_platformdata.h"
+
+/*  RMI4 Protocol Support
+ */
+
+struct rmi_phys_driver {
+	char *name;
+	int (*write) (struct rmi_phys_driver *physdrvr, unsigned short address,
+		      char data);
+	int (*read) (struct rmi_phys_driver *physdrvr, unsigned short address,
+		     char *buffer);
+	int (*write_multiple) (struct rmi_phys_driver *physdrvr,
+			       unsigned short address, char *buffer,
+			       int length);
+	int (*read_multiple) (struct rmi_phys_driver *physdrvr,
+			      unsigned short address, char *buffer, int length);
+	void (*attention) (struct rmi_phys_driver *physdrvr, int instance);
+	bool polling_required;
+	int irq;
+
+	/* Standard kernel linked list implementation.
+	 *  Documentation on how to use it can be found at
+	 *  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	 */
+	struct list_head drivers;
+	struct rmi_sensor_driver *sensor;
+	struct module *module;
+};
+
+int rmi_read(struct rmi_sensor_driver *sensor, unsigned short address,
+	     char *dest);
+int rmi_write(struct rmi_sensor_driver *sensor, unsigned short address,
+	      unsigned char data);
+int rmi_read_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		      char *dest, int length);
+int rmi_write_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		       unsigned char *data, int length);
+int rmi_register_sensor(struct rmi_phys_driver *physdrvr,
+			struct rmi_sensordata *sensordata);
+int rmi_unregister_sensors(struct rmi_phys_driver *physdrvr);
+
+/* Utility routine to set bits in a register. */
+int rmi_set_bits(struct rmi_sensor_driver *sensor, unsigned short address,
+		 unsigned char bits);
+/* Utility routine to clear bits in a register. */
+int rmi_clear_bits(struct rmi_sensor_driver *sensor, unsigned short address,
+		   unsigned char bits);
+/* Utility routine to set the value of a bit field in a register. */
+int rmi_set_bit_field(struct rmi_sensor_driver *sensor, unsigned short address,
+		      unsigned char field_mask, unsigned char bits);
+
+/* Utility routine to handle writes to read-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we
+ * don't want to accept it quietly.
+ */
+ssize_t rmi_store_error(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count);
+
+/* Utility routine to handle reads to write-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we
+ * don't want to accept it quietly.
+ */
+ssize_t rmi_show_error(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf);
+
+#endif
