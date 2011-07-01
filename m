Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1GAFha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:30 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752801Ab1GAFhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:17 -0400
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
Subject: [PATCH 8/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:15 -0700
Message-Id: <1309497556-7344-9-git-send-email-cheiny@synaptics.com>
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

diff --git a/drivers/input/touchscreen/rmi_f19.h b/drivers/input/touchscreen/rmi_f19.h
new file mode 100644
index 0000000..b5964fe
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f19.h
@@ -0,0 +1,63 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 header.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors,
+ * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
+ * file and add these functions to perform the config(), init(), report()
+ * and detect() functionality. The function pointers are then srored under
+ * the RMI function info and these functions will automatically be called by
+ * the global config(), init(), report() and detect() functions that will
+ * loop through all data sources and call the data sources functions using
+ * these functions pointed to by the function ptrs.
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
+#if !defined(_RMI_F19_H)
+#define _RMI_F19_H
+
+/* This is the data read from the F19 query registers.
+ */
+struct rmi_F19_query {
+	bool has_hysteresis_threshold;
+	bool has_sensitivity_adjust;
+	bool configurable;
+	unsigned char button_count;
+};
+
+struct rmi_F19_control {
+	unsigned char button_usage;
+	unsigned char filter_mode;
+	unsigned char *interrupt_enable_registers;
+	unsigned char *single_button_control;
+	unsigned char *sensor_map;
+	unsigned char *single_button_sensitivity;
+	unsigned char global_sensitivity_adjustment;
+	unsigned char global_hysteresis_threshold;
+};
+
+
+void FN_19_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs);
+int FN_19_config(struct rmi_function_info *rmifninfo);
+int FN_19_init(struct rmi_function_device *function_device);
+int FN_19_detect(struct rmi_function_info *rmifninfo);
+/* No attention function for Fn $19 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f19.c b/drivers/input/touchscreen/rmi_f19.c
new file mode 100644
index 0000000..c8646aa
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f19.c
@@ -0,0 +1,629 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
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
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f19.h"
+#include "rmi_platformdata.h"
+
+struct f19_instance_data {
+	struct rmi_F19_query *device_info;
+	struct rmi_F19_control *control_registers;
+	bool *button_down;
+	unsigned char button_data_buffer_size;
+	unsigned char *button_data_buffer;
+	unsigned char *button_map;
+	int control_register_size;
+	int register_count_for_bit_per_button;
+	int usage_and_filter_mode_offset;
+	int interrupt_enable_offset;
+	int interrupt_enable_length;
+	int single_button_control_length;
+	int single_button_control_offset;
+	int sensor_map_control_offset;
+	int sensor_map_control_length;
+	int single_button_sensor_offset;
+	int single_button_sensor_length;
+	int global_sensor_offset;
+	int global_hysteresis_threshold_offset;
+};
+
+static ssize_t rmi_f19_button_count_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+
+static ssize_t rmi_f19_buttonMap_show(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f19_buttonMap_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count);
+
+static struct device_attribute attrs[] = {
+	__ATTR(button_count, 0444,
+	       rmi_f19_button_count_show, rmi_store_error),	/* RO attr */
+	__ATTR(buttonMap, 0664,
+	       rmi_f19_buttonMap_show, rmi_f19_buttonMap_store)	/* RW attr */
+};
+
+/*
+ * There is no attention function for F19 - it is left NULL
+ * in the function table so it is not called.
+ *
+ */
+
+/*
+ * This reads in a sample and reports the F19 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+void FN_19_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs)
+{
+	struct f19_instance_data *instance_data = rmifninfo->fndata;
+	struct rmi_function_device *function_device =
+	    rmifninfo->function_device;
+	int button;
+
+	/* Read the button data. */
+
+	if (rmi_read_multiple(rmifninfo->sensor,
+			rmifninfo->function_descriptor.data_base_addr,
+			instance_data->button_data_buffer,
+			instance_data->button_data_buffer_size)) {
+		pr_err("%s: Failed to read button data registers.\n", __func__);
+		return;
+	}
+
+	/* Generate events for buttons that change state. */
+	for (button = 0; button < instance_data->device_info->button_count;
+	     button++) {
+		int button_reg;
+		int button_shift;
+		bool button_status;
+
+		/* determine which data byte the button status is in */
+		button_reg = button / 4;
+		/* bit shift to get button's status */
+		button_shift = button % 8;
+		button_status =
+		    ((instance_data->
+		      button_data_buffer[button_reg] >> button_shift) & 0x01) !=
+		    0;
+
+		/* if the button state changed from the last time report it
+		 * and store the new state */
+		if (button_status != instance_data->button_down[button]) {
+			pr_debug("%s: Button %d (code %d) -> %d.", __func__,
+				 button, instance_data->button_map[button],
+				 button_status);
+			/* Generate an event here. */
+			input_report_key(function_device->input,
+					 instance_data->button_map[button],
+					 button_status);
+			instance_data->button_down[button] = button_status;
+		}
+	}
+
+	input_sync(function_device->input); /* sync after groups of events */
+}
+EXPORT_SYMBOL(FN_19_inthandler);
+
+/* This is a stub for now.  It will be filled in as the driver implementation
+ * evolves.
+ */
+int FN_19_config(struct rmi_function_info *rmifninfo)
+{
+	int retval = 0;
+
+	pr_debug("%s: RMI4 F19 config\n", __func__);
+
+	/* TODO: Perform configuration.  In particular, write any cached control
+	 * register values to the device. */
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_19_config);
+
+/* Initialize any F19 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_19_init(struct rmi_function_device *function_device)
+{
+	int i, retval = 0;
+	int attr_count = 0;
+	struct f19_instance_data *instance_data = function_device->rfi->fndata;
+	struct rmi_f19_functiondata *functiondata =
+	    rmi_sensor_get_functiondata(function_device->sensor, RMI_F19_INDEX);
+
+	pr_debug("%s: RMI4 F19 init\n", __func__);
+
+	if (functiondata && functiondata->button_map) {
+		if (functiondata->button_map->nbuttons !=
+		    instance_data->device_info->button_count) {
+			pr_warning
+			    ("%s: Platformdata button map size (%d) != number "
+			     "of buttons on device (%d) - ignored.",
+			     __func__, functiondata->button_map->nbuttons,
+			     instance_data->device_info->button_count);
+		} else if (!functiondata->button_map->map) {
+			pr_warning("%s: Platformdata button map is missing!",
+				   __func__);
+		} else {
+			for (i = 0; i < functiondata->button_map->nbuttons; i++)
+				instance_data->button_map[i] =
+				    functiondata->button_map->map[i];
+		}
+	}
+
+	/* Set up any input events. */
+	set_bit(EV_SYN, function_device->input->evbit);
+	set_bit(EV_KEY, function_device->input->evbit);
+	/* set bits for each button... */
+	for (i = 0; i < instance_data->device_info->button_count; i++)
+		set_bit(instance_data->button_map[i],
+			function_device->input->keybit);
+
+	pr_debug("%s: Creating sysfs files.", __func__);
+	/* Set up sysfs device attributes. */
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		if (sysfs_create_file
+		    (&function_device->dev.kobj, &attrs[attr_count].attr) < 0) {
+			pr_err
+			    ("%s: Failed to create sysfs file for %s.",
+			     __func__, attrs[attr_count].attr.name);
+			retval = -ENODEV;
+			goto error_exit;
+		}
+	}
+
+	return 0;
+
+error_exit:
+	for (attr_count--; attr_count >= 0; attr_count--)
+		sysfs_remove_file(&function_device->dev.kobj,
+				  &attrs[attr_count].attr);
+	/* If you alloc anything, free it here. */
+	return retval;
+}
+EXPORT_SYMBOL(FN_19_init);
+
+static int init_control_registers(struct rmi_function_info *rmifninfo)
+{
+	struct f19_instance_data *instance_data = rmifninfo->fndata;
+	unsigned char *control_registers = NULL;
+	int retval = 0;
+
+	if (instance_data->control_registers) {
+		pr_err
+		    ("%s: WTF? F19 control regsiters are already initialized.",
+		     __func__);
+		return -EINVAL;
+	}
+
+	/* Allocate memory for the control registers. */
+	instance_data->control_registers =
+	    kzalloc(sizeof(struct rmi_F19_control), GFP_KERNEL);
+	if (!instance_data->control_registers) {
+		pr_err("%s: Error allocating F19 control registers.\n",
+		       __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	instance_data->register_count_for_bit_per_button =
+	    (instance_data->device_info->button_count + 7) / 8;
+
+	/* Need to compute the amount of data to read since it varies with the
+	 * number of buttons */
+		/* 1 for filter mode and button usage bits */
+	instance_data->control_register_size = 1
+		/* interrupt enable bits and single button participation bits */
+	    + 2 * instance_data->register_count_for_bit_per_button
+		/* sensormap registers + single button sensitivity registers */
+	    + 2 * instance_data->device_info->button_count
+		/* 1 for global sensitivity adjust and
+		 * 1 for global hysteresis threshold */
+	    + 2;
+
+	/* Allocate a temp memory buffer to read the control registers into */
+	control_registers =
+	    kzalloc(instance_data->control_register_size, GFP_KERNEL);
+	if (!control_registers) {
+		pr_err
+		    ("%s: Error allocating temp storage to read "
+		     "fn19 control info.\n",
+		     __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	/* Grab a copy of the control registers. */
+	retval = rmi_read_multiple(rmifninfo->sensor,
+			      rmifninfo->function_descriptor.control_base_addr,
+			      control_registers,
+			      instance_data->control_register_size);
+	if (retval) {
+		pr_err("%s: Failed to read F19 control registers.", __func__);
+		goto error_exit;
+	}
+
+	/* Copy over control registers data to the instance data */
+	instance_data->usage_and_filter_mode_offset = 0;
+	instance_data->control_registers->button_usage =
+	    control_registers[instance_data->
+			      usage_and_filter_mode_offset] & 0x3;
+	instance_data->control_registers->filter_mode =
+	    control_registers[instance_data->
+			      usage_and_filter_mode_offset] & 0xc;
+
+	/* Fill in interrupt enable registers */
+	instance_data->interrupt_enable_offset = 1;
+	instance_data->interrupt_enable_length =
+	    instance_data->register_count_for_bit_per_button;
+	instance_data->control_registers->interrupt_enable_registers =
+	    kzalloc(instance_data->interrupt_enable_length, GFP_KERNEL);
+	if (!instance_data->control_registers->interrupt_enable_registers) {
+		pr_err("%s: Error allocating storage for interrupt "
+		     "enable control info.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	memcpy(instance_data->control_registers->interrupt_enable_registers,
+	       &control_registers[instance_data->interrupt_enable_offset],
+	       instance_data->interrupt_enable_length);
+
+	/* Fill in single button control registers */
+	instance_data->single_button_control_offset =
+	    instance_data->interrupt_enable_offset +
+	    instance_data->interrupt_enable_length;
+	instance_data->single_button_control_length =
+	    instance_data->register_count_for_bit_per_button;
+	instance_data->control_registers->single_button_control =
+	    kzalloc(instance_data->single_button_control_length, GFP_KERNEL);
+	if (!instance_data->control_registers->single_button_control) {
+		pr_err("%s: Error allocating storage for single button "
+		     "participation control info.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	memcpy(instance_data->control_registers->single_button_control,
+	       &control_registers[instance_data->single_button_control_offset],
+	       instance_data->single_button_control_length);
+
+	/* Fill in sensor map registers */
+	instance_data->sensor_map_control_offset =
+	    instance_data->single_button_control_offset +
+	    instance_data->single_button_control_length;
+	instance_data->sensor_map_control_length =
+	    instance_data->device_info->button_count;
+	instance_data->control_registers->sensor_map =
+	    kzalloc(instance_data->sensor_map_control_length, GFP_KERNEL);
+	if (!instance_data->control_registers->sensor_map) {
+		pr_err("%s: Error allocating storage for sensor map "
+		     "control info.", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	memcpy(instance_data->control_registers->sensor_map,
+	       &control_registers[instance_data->sensor_map_control_offset],
+	       instance_data->sensor_map_control_length);
+
+	/* Fill in single button sensitivity registers */
+	instance_data->single_button_sensor_offset =
+	    instance_data->sensor_map_control_offset +
+	    instance_data->sensor_map_control_length;
+	instance_data->single_button_sensor_length =
+	    instance_data->device_info->button_count;
+	instance_data->control_registers->single_button_sensitivity =
+	    kzalloc(instance_data->single_button_sensor_length, GFP_KERNEL);
+	if (!instance_data->control_registers->single_button_sensitivity) {
+		pr_err
+		    ("%s: Error allocating storage for single button "
+		     "sensitivity control info.",
+		     __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	memcpy(instance_data->control_registers->single_button_sensitivity,
+	       &control_registers[instance_data->single_button_sensor_offset],
+	       instance_data->single_button_sensor_length);
+
+	/* Fill in global sensitivity adjustment and global
+	 * hysteresis threshold values */
+	instance_data->global_sensor_offset =
+	    instance_data->single_button_sensor_offset +
+	    instance_data->single_button_sensor_length;
+	instance_data->global_hysteresis_threshold_offset =
+	    instance_data->global_sensor_offset + 1;
+	instance_data->control_registers->global_sensitivity_adjustment =
+	    control_registers[instance_data->global_sensor_offset] & 0x1f;
+	instance_data->control_registers->global_hysteresis_threshold =
+	    control_registers[instance_data->
+			      global_hysteresis_threshold_offset] & 0x0f;
+
+	/* Free up temp storage that held copy of control registers */
+	kfree(control_registers);
+
+	return 0;
+
+error_exit:
+	if (instance_data->control_registers) {
+		kfree(
+		  instance_data->control_registers->single_button_sensitivity);
+		kfree(
+		  instance_data->control_registers->interrupt_enable_registers);
+		kfree(instance_data->control_registers->sensor_map);
+		kfree(instance_data->control_registers->single_button_control);
+	}
+	kfree(instance_data->control_registers);
+	kfree(control_registers);
+	return retval;
+}
+
+int FN_19_detect(struct rmi_function_info *rmifninfo)
+{
+	unsigned char query_buffer[2];
+	int retval = 0;
+	int i;
+	struct f19_instance_data *instance_data;
+
+	pr_debug("%s: RMI4 F19 detect\n", __func__);
+
+	if (rmifninfo->fndata) {
+		/* detect routine should only ever be called once
+		 * per rmifninfo. */
+		pr_err("%s: WTF?!? F19 instance data is already present!",
+		       __func__);
+		return -EINVAL;
+	}
+	instance_data = kzalloc(sizeof(struct f19_instance_data), GFP_KERNEL);
+	if (!instance_data) {
+		pr_err("%s: Error allocating F19 instance data.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	instance_data->device_info =
+	    kzalloc(sizeof(struct rmi_F19_query), GFP_KERNEL);
+	if (!instance_data->device_info) {
+		pr_err("%s: Error allocating F19 device query.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	rmifninfo->fndata = instance_data;
+
+	/* need to get number of fingers supported, data size, etc. -
+	   to be used when getting data since the number of registers to
+	   read depends on the number of fingers supported and data size. */
+	retval =
+	    rmi_read_multiple(rmifninfo->sensor,
+			      rmifninfo->function_descriptor.query_base_addr,
+			      query_buffer, sizeof(query_buffer));
+	if (retval) {
+		pr_err("%s: RMI4 F19 detect: "
+		       "Could not read function query registers 0x%x\n",
+		       __func__,
+		       rmifninfo->function_descriptor.query_base_addr);
+		goto error_exit;
+	}
+
+	/* Extract device data. */
+	instance_data->device_info->configurable = query_buffer[0] & 0x01;
+	instance_data->device_info->has_sensitivity_adjust =
+	    query_buffer[0] & 0x02;
+	instance_data->device_info->has_hysteresis_threshold =
+	    query_buffer[0] & 0x04;
+	instance_data->device_info->button_count = query_buffer[1] & 0x01F;
+	pr_debug("%s: F19 device - %d buttons...", __func__,
+		 instance_data->device_info->button_count);
+
+	/* Figure out just how much data we'll need to read. */
+	instance_data->button_down =
+	    kcalloc(instance_data->device_info->button_count, sizeof(bool),
+		    GFP_KERNEL);
+	if (!instance_data->button_down) {
+		pr_err("%s: Error allocating F19 button state buffer.\n",
+		       __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	instance_data->button_data_buffer_size =
+	    (instance_data->device_info->button_count + 7) / 8;
+	instance_data->button_data_buffer =
+	    kcalloc(instance_data->button_data_buffer_size,
+		    sizeof(unsigned char), GFP_KERNEL);
+	if (!instance_data->button_data_buffer) {
+		pr_err("%s: Failed to allocate button data buffer.", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	instance_data->button_map =
+	    kcalloc(instance_data->device_info->button_count,
+		    sizeof(unsigned char), GFP_KERNEL);
+	if (!instance_data->button_map) {
+		pr_err("%s: Error allocating F19 button map.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	for (i = 0; i < instance_data->device_info->button_count; i++)
+		instance_data->button_map[i] = BTN_0 + i; /* default values */
+
+	/* Grab the control register info. */
+	retval = init_control_registers(rmifninfo);
+	if (retval) {
+		pr_err("%s: Error %d getting fn19 control register info.\n",
+		       __func__, retval);
+		goto error_exit;
+	}
+
+	return 0;
+
+error_exit:
+	if (instance_data) {
+		kfree(instance_data->button_map);
+		kfree(instance_data->button_data_buffer);
+		kfree(instance_data->button_down);
+		kfree(instance_data->device_info);
+	}
+	kfree(instance_data);
+	return retval;
+}
+EXPORT_SYMBOL(FN_19_detect);
+
+static ssize_t rmi_f19_button_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			instance_data->device_info->button_count);
+}
+
+static ssize_t rmi_f19_buttonMap_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = fn->rfi->fndata;
+	int i, len, total_len = 0;
+	char *current_buf = buf;
+
+	/* loop through each button map value and copy its
+	 * string representation into buf */
+	for (i = 0; i < instance_data->device_info->button_count; i++) {
+		/* get next button mapping value and write it to buf */
+		len = snprintf(current_buf, PAGE_SIZE - total_len,
+			"%u ", instance_data->button_map[i]);
+		/* bump up ptr to next location in buf if the
+		 * snprintf was valid.  Otherwise issue an error
+		 * and return. */
+		if (len > 0) {
+			current_buf += len;
+			total_len += len;
+		} else {
+			dev_err(dev, "%s: Failed to build button map buffer, "
+				"code = %d.\n", __func__, len);
+			return snprintf(buf, PAGE_SIZE, "unknown\n");
+		}
+	}
+	snprintf(current_buf, PAGE_SIZE - total_len, "\n");
+
+	return total_len;
+}
+
+static ssize_t rmi_f19_buttonMap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = fn->rfi->fndata;
+	unsigned int button;
+	int i;
+	int retval = count;
+	int button_count = 0;
+	unsigned char *temp_button_map;
+
+	/* Do validation on the button map data passed in.  Store button
+	 * mappings into a temp buffer and then verify button count and
+	 * data prior to clearing out old button mappings and storing the
+	 * new ones. */
+	temp_button_map =
+	    kzalloc(instance_data->device_info->button_count, GFP_KERNEL);
+	if (!temp_button_map) {
+		dev_err(dev, "%s: Error allocating temp button map.\n",
+			__func__);
+		retval = -ENOMEM;
+		goto err_ret;
+	}
+
+	for (i = 0; i < instance_data->device_info->button_count && *buf != 0;
+	     i++) {
+		/* get next button mapping value and store and bump up to
+		 * point to next item in buf */
+		sscanf(buf, "%u", &button);
+
+		/* Make sure the key is a valid key */
+		if (button > KEY_MAX) {
+			dev_err(dev,
+				"%s: Error - button map for button %d is not a "
+				"valid value 0x%x.\n",
+				__func__, i, button);
+			retval = -EINVAL;
+			goto err_ret;
+		}
+
+		temp_button_map[i] = button;
+		button_count++;
+
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf - 1) == ' ')
+				break;
+		}
+	}
+
+	/* Make sure the button count matches */
+	if (button_count != instance_data->device_info->button_count) {
+		dev_err(dev,
+		    "%s: Error - button map count of %d doesn't match device "
+		     "button count of %d.\n", __func__, button_count,
+		     instance_data->device_info->button_count);
+		retval = -EINVAL;
+		goto err_ret;
+	}
+
+	/* Switch to the new map. */
+	kfree(instance_data->button_map);
+	instance_data->button_map = temp_button_map;
+	temp_button_map = NULL;
+
+	/* Loop through the temp buffer and copy the button event and
+	 * set the key bit for the new mapping. */
+	for (i = 0; i < button_count; i++)
+		set_bit(instance_data->button_map[i], fn->input->keybit);
+
+err_ret:
+	kfree(temp_button_map);
+
+	return retval;
+}
