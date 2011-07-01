Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1GAFhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:33 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754571Ab1GAFha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:30 -0400
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
Subject: [PATCH 7/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:14 -0700
Message-Id: <1309497556-7344-8-git-send-email-cheiny@synaptics.com>
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

diff --git a/drivers/input/touchscreen/rmi_f11.h b/drivers/input/touchscreen/rmi_f11.h
new file mode 100644
index 0000000..7750ed4
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.h
@@ -0,0 +1,80 @@
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
+#if !defined(_RMI_F11_H)
+#define _RMI_F11_H
+
+/* This is the data read from the F11 query registers.
+ */
+struct rmi_F11_device_query {
+	bool has_query_9;
+	unsigned char number_of_sensors;
+};
+
+struct rmi_F11_sensor_query {
+	bool configurable;
+	bool has_sensitivity_adjust;
+	bool has_gestures;
+	bool has_absolute;
+	bool has_relative;
+	unsigned char number_of_fingers;
+	unsigned char number_of_X_electrodes;
+	unsigned char number_of_Y_electrodes;
+	unsigned char maximum_electrodes;
+	bool has_anchored_finger;
+	unsigned char abs_data_size;
+};
+
+struct rmi_F11_control {
+	bool relative_ballistics;
+	bool relative_position_filter;
+	bool absolute_position_filter;
+	unsigned char reporting_mode;
+	bool manually_tracked_finger;
+	bool manually_tracked_finger_enable;
+	unsigned char motion_sensitivity;
+	unsigned char palm_detect_threshold;
+	unsigned char delta_X_pos_threshold;
+	unsigned char delta_Y_pos_threshold;
+	unsigned char velocity;
+	unsigned char acceleration;
+	unsigned short sensor_max_X_pos;
+	unsigned short sensor_max_Y_pos;
+};
+
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs);
+int FN_11_config(struct rmi_function_info *rmifninfo);
+int FN_11_init(struct rmi_function_device *function_device);
+int FN_11_detect(struct rmi_function_info *rmifninfo);
+/* No attention function for Fn $11 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f11.c b/drivers/input/touchscreen/rmi_f11.c
new file mode 100644
index 0000000..0e28cdc
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.c
@@ -0,0 +1,962 @@
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
+#include <linux/sysfs.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f11.h"
+#include "rmi_platformdata.h"
+
+/* By default, we'll support two fingers if we can't figure out how many we
+ * really need to handle.
+ */
+#define DEFAULT_NR_OF_FINGERS 2
+
+struct f11_instance_data {
+	struct rmi_F11_device_query *device_info;
+	struct rmi_F11_sensor_query *sensor_info;
+	struct rmi_F11_control *control_registers;
+	unsigned char finger_data_buffer_size;
+	unsigned char abs_data_offset;
+	unsigned char abs_data_size;
+	unsigned char rel_data_offset;
+	unsigned char gesture_data_offset;
+	unsigned char *finger_data_buffer;
+	/* Last X & Y seen, needed at finger lift.  Was down indicates
+	 * at least one finger was here. TODO: Eventually we'll need to
+	 * track this info on a per finger basis. */
+	bool wasdown;
+	unsigned int old_X;
+	unsigned int old_Y;
+	/* Transformations to be applied to coordinates before reporting. */
+	bool flip_X;
+	bool flip_Y;
+	int offset_X;
+	int offset_Y;
+	int clip_X_low;
+	int clip_X_high;
+	int clip_Y_low;
+	int clip_Y_high;
+	bool swap_axes;
+	bool rel_report_enabled;
+};
+
+enum f11_finger_state {
+	F11_NO_FINGER = 0,
+	F11_PRESENT = 1,
+	F11_INACCURATE = 2,
+	F11_RESERVED = 3
+};
+
+static ssize_t rmi_fn_11_flip_show(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count);
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count);
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				     struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count);
+
+static ssize_t rmi_fn_11_swap_show(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_swap_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count);
+
+static ssize_t rmi_fn_11_relreport_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
+
+static ssize_t rmi_fn_11_relreport_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+
+static ssize_t rmi_fn_11_maxPos_show(struct device *dev,
+				     struct device_attribute *attr, char *buf);
+
+static struct device_attribute attrs[] = {
+	__ATTR(flip, 0664,
+	       rmi_fn_11_flip_show, rmi_fn_11_flip_store),	/* RW attr */
+	__ATTR(clip, 0664,
+	       rmi_fn_11_clip_show, rmi_fn_11_clip_store),	/* RW attr */
+	__ATTR(offset, 0664,
+	       rmi_fn_11_offset_show, rmi_fn_11_offset_store),	/* RW attr */
+	__ATTR(swap, 0664,
+	       rmi_fn_11_swap_show, rmi_fn_11_swap_store),	/* RW attr */
+	__ATTR(relreport, 0664,
+	       rmi_fn_11_relreport_show, rmi_fn_11_relreport_store),	/* RW */
+	__ATTR(maxPos, 0444,
+	       rmi_fn_11_maxPos_show, rmi_store_error)	/* R0 attr */
+};
+
+static void FN_11_relreport(struct rmi_function_info *rmifninfo);
+
+
+/* Reading and parsing the F11 query registers is a big hairy wad.  There's a
+ * lot of stuff that is dependent on the presence or absence of other stuff,
+ * and there's really no tidy way to deal with it.
+ *
+ * TODO: Use more computed and #def'ed offset values.
+ */
+static int read_query_registers(struct rmi_function_info *rmifninfo)
+{
+	int retval = 0;
+	struct f11_instance_data *instance_data = rmifninfo->fndata;
+	unsigned char query_buffer[12];	/* TODO: Compute size correctly. */
+	unsigned char abs_data_size;
+	int has_pinch, has_flick, has_tap;
+	int has_tap_and_hold, has_double_tap;
+	int has_early_tap, has_press;
+	int has_palm_detect, has_rotate;
+	int has_relative;
+	unsigned char f11_egr_0, f11_egr_1;
+	unsigned int all_data_block_size;
+
+	/* need to get number of fingers supported, data size, etc. -
+	 * to be used when getting data since the number of registers to
+	 * read depends on the number of fingers supported and data size. */
+	retval = rmi_read_multiple(rmifninfo->sensor,
+			  rmifninfo->function_descriptor.query_base_addr,
+			  query_buffer, sizeof(query_buffer));
+	if (retval) {
+		pr_err("%s:Could not read F11 query registers 0x%04x\n",
+			__func__,
+			rmifninfo->function_descriptor.query_base_addr);
+		return retval;
+	}
+
+	/* Extract device data. */
+	instance_data->device_info->has_query_9 = (query_buffer[0] & 0x04) != 0;
+	instance_data->device_info->number_of_sensors =
+	(query_buffer[0] & 0x07) + 1;
+	pr_debug("%s: F11 device - %d sensors.  Query 9? %d.", __func__,
+		 instance_data->device_info->number_of_sensors,
+		 instance_data->device_info->has_query_9);
+
+	/* Extract sensor data. */
+	/* 2D data sources have only 3 bits for the number of fingers
+	 * supported - so the encoding is a bit wierd. */
+	instance_data->sensor_info->number_of_fingers = DEFAULT_NR_OF_FINGERS;
+	if ((query_buffer[1] & 0x7) <= 4)
+		/* add 1 since zero based */
+		instance_data->sensor_info->number_of_fingers =
+		(query_buffer[1] & 0x7) + 1;
+	else {
+		/* a value of 5 is up to 10 fingers - 6 and 7 are reserved
+		 (shouldn't get these in a normal 2D source). */
+		if ((query_buffer[1] & 0x7) == 5)
+			instance_data->sensor_info->number_of_fingers = 10;
+	}
+	instance_data->sensor_info->configurable =
+			(query_buffer[1] & 0x80) != 0;
+	instance_data->sensor_info->has_sensitivity_adjust =
+			(query_buffer[1] & 0x40) != 0;
+	instance_data->sensor_info->has_gestures =
+			(query_buffer[1] & 0x20) != 0;
+	instance_data->sensor_info->has_absolute =
+			(query_buffer[1] & 0x10) != 0;
+	instance_data->sensor_info->has_relative =
+			(query_buffer[1] & 0x08) != 0;
+	instance_data->sensor_info->abs_data_size = query_buffer[5] & 0x03;
+	pr_debug("%s: Number of fingers: %d.", __func__,
+		 instance_data->sensor_info->number_of_fingers);
+
+	/* Figure out just how much data we'll need to read. */
+	instance_data->finger_data_buffer_size =
+			(instance_data->sensor_info->number_of_fingers + 3) / 4;
+	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+	abs_data_size = 5;
+	if (instance_data->sensor_info->abs_data_size != 0)
+		pr_warning("%s: Unrecognized abs data size %d ignored.",
+			__func__, instance_data->sensor_info->abs_data_size);
+	if (instance_data->sensor_info->has_absolute) {
+		instance_data->abs_data_size = abs_data_size;
+		instance_data->abs_data_offset =
+			instance_data->finger_data_buffer_size;
+		instance_data->finger_data_buffer_size +=
+			instance_data->sensor_info->number_of_fingers *
+			abs_data_size;
+	}
+	if (instance_data->sensor_info->has_relative) {
+		instance_data->rel_data_offset =
+			((instance_data->sensor_info->number_of_fingers + 3)
+				/ 4) +
+			/* absolute data, per finger times number of fingers */
+			(abs_data_size *
+			instance_data->sensor_info->number_of_fingers);
+		instance_data->finger_data_buffer_size +=
+			instance_data->sensor_info->number_of_fingers * 2;
+	}
+	if (instance_data->sensor_info->has_gestures) {
+		instance_data->gesture_data_offset =
+			instance_data->finger_data_buffer_size;
+		pr_warning("%s: WARNING Need to correctly compute gesture "
+			"data location.", __func__);
+	}
+
+	/* need to determine the size of data to read - this depends on
+	 * conditions such as whether Relative data is reported and if Gesture
+	 * data is reported. */
+	f11_egr_0 = query_buffer[7];
+	f11_egr_1 = query_buffer[8];
+
+	/* Get info about what EGR data is supported, whether it has
+	 * Relative data suppo*rted, etc. */
+	has_pinch = f11_egr_0 & 0x40;
+	has_flick = f11_egr_0 & 0x10;
+	has_tap = f11_egr_0 & 0x01;
+	has_tap_and_hold = f11_egr_0 & 0x02;
+	has_double_tap = f11_egr_0 & 0x04;
+	has_early_tap = f11_egr_0 & 0x08;
+	has_press = f11_egr_0 & 0x20;
+	has_palm_detect = f11_egr_1 & 0x01;
+	has_rotate = f11_egr_1 & 0x02;
+	has_relative = query_buffer[1] & 0x08;
+
+	/* Size of all data including finger status, absolute data for each
+	 * finger, relative data and EGR data */
+	all_data_block_size =
+		/* finger status, four fingers per register */
+		((instance_data->sensor_info->number_of_fingers + 3) / 4) +
+		/* absolute data, per finger times number of fingers */
+		(abs_data_size *
+		instance_data->sensor_info->number_of_fingers) +
+		/* two relative registers (if relative is being reported) */
+		2 * has_relative +
+		/* F11_2D_Data8 is only present if the egr_0
+		 * register is non-zero. */
+		!!(f11_egr_0) +
+		/* F11_2D_Data9 is only present if either egr_0 or
+		 * egr_1 registers are non-zero. */
+		(f11_egr_0 || f11_egr_1) +
+		/* F11_2D_Data10 is only present if EGR_PINCH or EGR_FLICK of
+		 * egr_0 reports as 1. */
+		!!(has_pinch | has_flick) +
+		/* F11_2D_Data11 and F11_2D_Data12 are only present if
+		 * EGR_FLICK of egr_0 reports as 1. */
+		2 * !!(has_flick);
+
+	return 0;
+}
+
+/*
+ * This reads in a sample and reports the function $11 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs)
+{
+	/* number of touch points - fingers down in this case */
+	int finger_down_count;
+	int finger;
+	struct rmi_function_device *function_device;
+	struct f11_instance_data *instance_data = rmifninfo->fndata;
+	int retval;
+
+	finger_down_count = 0;
+	function_device = rmifninfo->function_device;
+
+	/* get 2D sensor finger data */
+	retval =
+	    rmi_read_multiple(rmifninfo->sensor,
+			      rmifninfo->function_descriptor.data_base_addr,
+			      instance_data->finger_data_buffer,
+			      instance_data->finger_data_buffer_size);
+	if (retval) {
+		pr_err("%s: Failed to read finger data registers, code=%d.\n",
+		       __func__, retval);
+		return;
+	}
+
+	/* First we need to count the fingers and generate some events
+	 * related to that. */
+	for (finger = 0; finger < instance_data->sensor_info->number_of_fingers;
+	     finger++) {
+		int reg = finger / 4;	/* Which data byte has finger status */
+		int finger_shift = (finger % 4) * 2;	/* Where in the byte? */
+		int finger_status =
+		    (instance_data->
+		     finger_data_buffer[reg] >> finger_shift) & 0x03;
+
+		if (finger_status == F11_PRESENT
+		    || finger_status == F11_INACCURATE) {
+			finger_down_count++;
+			instance_data->wasdown = true;
+		}
+	}
+	input_report_key(function_device->input, BTN_TOUCH, finger_down_count);
+	for (finger = 0;
+	     finger < (instance_data->sensor_info->number_of_fingers - 1);
+	     finger++)
+		input_report_key(function_device->input, BTN_2 + finger,
+				 finger_down_count >= (finger + 2));
+
+	for (finger = 0; finger < instance_data->sensor_info->number_of_fingers;
+	     finger++) {
+		int reg;
+		int finger_shift;
+		int finger_status;
+		int X = 0, Y = 0, Z = 0, Wy = 0, Wx = 0;
+
+		/* determine which data byte the finger status is in */
+		reg = finger / 4;
+		/* bit shift to get finger's status */
+		finger_shift = (finger % 4) * 2;
+		finger_status =
+		    (instance_data->finger_data_buffer[reg] >> finger_shift)
+		    & 0x03;
+
+		/* if finger status indicates a finger is present then
+		   extract the finger data and report it */
+		if (finger_status == F11_PRESENT
+		    || finger_status == F11_INACCURATE) {
+
+			if (instance_data->sensor_info->has_absolute) {
+				int maxX =
+				    instance_data->control_registers->
+				    sensor_max_X_pos;
+				int maxY =
+				    instance_data->control_registers->
+				    sensor_max_Y_pos;
+				reg =
+				    instance_data->abs_data_offset +
+				    (finger * instance_data->abs_data_size);
+				X = (instance_data->
+				     finger_data_buffer[reg] << 4) & 0x0ff0;
+				X |= (instance_data->
+				      finger_data_buffer[reg + 2] & 0x0f);
+				Y = (instance_data->
+				     finger_data_buffer[reg + 1] << 4) & 0x0ff0;
+				Y |= ((instance_data->
+				       finger_data_buffer[reg +
+							2] & 0xf0) >> 4) & 0x0f;
+				/* First thing to do is swap axes if needed.
+				 */
+				if (instance_data->swap_axes) {
+					int temp = X;
+					X = Y;
+					Y = temp;
+					maxX =
+					    instance_data->control_registers->
+					    sensor_max_Y_pos;
+					maxY =
+					    instance_data->control_registers->
+					    sensor_max_X_pos;
+				}
+				if (instance_data->flip_X)
+					X = max(maxX - X, 0);
+				X = X - instance_data->offset_X;
+				X = min(max(X, instance_data->clip_X_low),
+					instance_data->clip_X_high);
+				if (instance_data->flip_Y)
+					Y = max(maxY - Y, 0);
+				Y = Y - instance_data->offset_Y;
+				Y = min(max(Y, instance_data->clip_Y_low),
+					instance_data->clip_Y_high);
+
+				/* upper 4 bits of W are Wy,
+				   lower 4 of W are Wx */
+				Wy = (instance_data->
+				      finger_data_buffer[reg + 3] >> 4) & 0x0f;
+				Wx = instance_data->finger_data_buffer[reg +
+								     3] & 0x0f;
+				if (instance_data->swap_axes) {
+					int temp = Wx;
+					Wx = Wy;
+					Wy = temp;
+				}
+
+				Z = instance_data->finger_data_buffer[reg + 4];
+
+				/* if this is the first finger report normal
+				 * ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
+				 * non-MT apps. Apps that support Multi-touch
+				 * will ignore these events and use the MT
+				 * events. Apps that don't support Multi-touch
+				 * will still function.
+				 */
+				if (finger_down_count == 1) {
+					instance_data->old_X = X;
+					instance_data->old_Y = Y;
+					input_report_abs(function_device->input,
+							 ABS_X, X);
+					input_report_abs(function_device->input,
+							 ABS_Y, Y);
+					input_report_abs(function_device->input,
+							 ABS_PRESSURE, Z);
+					input_report_abs(function_device->input,
+							 ABS_TOOL_WIDTH,
+							 max(Wx, Wy));
+				} else {
+					/* TODO generate non MT events for
+					 * multifinger situation. */
+				}
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+				/* Report Multi-Touch events for each finger */
+				/* major axis of touch area ellipse */
+				input_report_abs(function_device->input,
+						 ABS_MT_TOUCH_MAJOR, Z);
+				/* minor axis of touch area ellipse */
+				input_report_abs(function_device->input,
+						 ABS_MT_WIDTH_MAJOR, max(Wx,
+									 Wy));
+				/* Currently only 2 supported - 1 or 0 */
+				input_report_abs(function_device->input,
+						 ABS_MT_ORIENTATION,
+						 (Wx > Wy ? 1 : 0));
+				input_report_abs(function_device->input,
+						 ABS_MT_POSITION_X, X);
+				input_report_abs(function_device->input,
+						 ABS_MT_POSITION_Y, Y);
+
+				/* TODO: Tracking ID needs to be reported but
+				 * not used yet. Could be formed by keeping
+				 * an id per position and assiging a new id
+				 * when finger_status changes for that position.
+				 */
+				input_report_abs(function_device->input,
+						 ABS_MT_TRACKING_ID,
+						 finger + 1);
+
+				/* MT sync between fingers */
+				input_mt_sync(function_device->input);
+#endif
+			}
+		}
+	}
+
+	/* if we had a finger down before and now we don't have
+	 * any send a button up. */
+	if ((finger_down_count == 0) && instance_data->wasdown) {
+		instance_data->wasdown = false;
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+		input_report_abs(function_device->input, ABS_MT_TOUCH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_WIDTH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_POSITION_X,
+				 instance_data->old_X);
+		input_report_abs(function_device->input, ABS_MT_POSITION_Y,
+				 instance_data->old_Y);
+		input_report_abs(function_device->input, ABS_MT_TRACKING_ID, 1);
+		input_mt_sync(function_device->input);
+#endif
+
+		input_report_abs(function_device->input, ABS_X,
+				 instance_data->old_X);
+		input_report_abs(function_device->input, ABS_Y,
+				 instance_data->old_Y);
+		instance_data->old_X = instance_data->old_Y = 0;
+		pr_debug("%s: Finger up.", __func__);
+	}
+
+	FN_11_relreport(rmifninfo);
+	input_sync(function_device->input); /* sync after groups of events */
+
+}
+EXPORT_SYMBOL(FN_11_inthandler);
+
+#define F11_MIN_RELATIVE -128
+#define F11_MAX_RELATIVE 127
+
+/* This function reads in relative data for first finger and
+ * sends it to input system */
+static void FN_11_relreport(struct rmi_function_info *rmifninfo)
+{
+	struct f11_instance_data *instance_data = rmifninfo->fndata;
+	struct rmi_function_device *function_device;
+	signed char X, Y;
+	unsigned short fn11DataBaseAddr;
+
+	if (instance_data->sensor_info->has_relative &&
+			instance_data->rel_report_enabled) {
+		int reg = instance_data->rel_data_offset;
+
+		function_device = rmifninfo->function_device;
+
+		fn11DataBaseAddr =
+		    rmifninfo->function_descriptor.data_base_addr;
+		/* Read and report Rel data for primary finger
+		 * one register for X and one for Y */
+		X = instance_data->finger_data_buffer[reg];
+		Y = instance_data->finger_data_buffer[reg + 1];
+		if (instance_data->swap_axes) {
+			signed char temp = X;
+			X = Y;
+			Y = temp;
+		}
+		if (instance_data->flip_X)
+			X = -X;
+		if (instance_data->flip_Y)
+			Y = -Y;
+		X = (signed char)min(F11_MAX_RELATIVE,
+				     max(F11_MIN_RELATIVE, (int)X));
+		Y = (signed char)min(F11_MAX_RELATIVE,
+				     max(F11_MIN_RELATIVE, (int)Y));
+
+		input_report_rel(function_device->input, REL_X, X);
+		input_report_rel(function_device->input, REL_Y, Y);
+	}
+}
+
+/* This is a stub for now, and will be expanded as this implementation
+ * evolves.
+ */
+int FN_11_config(struct rmi_function_info *rmifninfo)
+{
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $11 config\n", __func__);
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_11_config);
+
+/* This operation is done in a number of places, so we have a handy routine
+ * for it.
+ */
+static void f11_set_abs_params(struct rmi_function_device *function_device)
+{
+	struct f11_instance_data *instance_data = function_device->rfi->fndata;
+	/* Use the max X and max Y read from the device, or the clip values,
+	 * whichever is stricter.
+	 */
+	int xMin = instance_data->clip_X_low;
+	int xMax =
+	    min((int)instance_data->control_registers->sensor_max_X_pos,
+		instance_data->clip_X_high);
+	int yMin = instance_data->clip_Y_low;
+	int yMax =
+	    min((int)instance_data->control_registers->sensor_max_Y_pos,
+		instance_data->clip_Y_high);
+	if (instance_data->swap_axes) {
+		int temp = xMin;
+		xMin = yMin;
+		yMin = temp;
+		temp = xMax;
+		xMax = yMax;
+		yMax = temp;
+	}
+	pr_debug("%s: Set ranges X=[%d..%d] Y=[%d..%d].", __func__, xMin, xMax,
+		 yMin, yMax);
+	input_set_abs_params(function_device->input, ABS_X, xMin, xMax, 0, 0);
+	input_set_abs_params(function_device->input, ABS_Y, yMin, yMax, 0, 0);
+	input_set_abs_params(function_device->input, ABS_PRESSURE, 0, 255, 0,
+			     0);
+	input_set_abs_params(function_device->input, ABS_TOOL_WIDTH, 0, 15, 0,
+			     0);
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MAJOR, 0, 15,
+			     0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MINOR, 0, 15,
+			     0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_ORIENTATION, 0, 1,
+			     0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TRACKING_ID, 1, 10,
+			     0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_X, xMin,
+			     xMax, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_Y, yMin,
+			     yMax, 0, 0);
+#endif
+}
+
+/* Initialize any function $11 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_11_init(struct rmi_function_device *function_device)
+{
+	struct f11_instance_data *instance_data = function_device->rfi->fndata;
+	int retval = 0;
+	int attr_count = 0;
+	struct rmi_f11_functiondata *functiondata =
+		rmi_sensor_get_functiondata(function_device->sensor,
+			RMI_F11_INDEX);
+	pr_debug("%s: RMI4 F11 init", __func__);
+
+	/* TODO: Initialize these through some normal kernel mechanism.
+	 */
+	instance_data->flip_X = false;
+	instance_data->flip_Y = false;
+	instance_data->swap_axes = false;
+	instance_data->rel_report_enabled = true;
+	instance_data->offset_X = instance_data->offset_Y = 0;
+	instance_data->clip_X_low = instance_data->clip_Y_low = 0;
+	/* TODO: 65536 should actually be the largest valid RMI4
+	 * position coordinate */
+	instance_data->clip_X_high = instance_data->clip_Y_high = 65536;
+
+	/* Load any overrides that were specified via platform data.
+	 */
+	if (functiondata) {
+		pr_debug("%s: found F11 per function platformdata.", __func__);
+		instance_data->flip_X = functiondata->flip_X;
+		instance_data->flip_Y = functiondata->flip_Y;
+		instance_data->swap_axes = functiondata->swap_axes;
+		if (functiondata->offset) {
+			instance_data->offset_X = functiondata->offset->x;
+			instance_data->offset_Y = functiondata->offset->y;
+		}
+		if (functiondata->clip_X) {
+			if (functiondata->clip_X->min >=
+			    functiondata->clip_X->max) {
+				pr_warning
+				    ("%s: Clip X min (%d) >= X clip max (%d) "
+				     "- ignored.",
+				     __func__, functiondata->clip_X->min,
+				     functiondata->clip_X->max);
+			} else {
+				instance_data->clip_X_low =
+				    functiondata->clip_X->min;
+				instance_data->clip_X_high =
+				    functiondata->clip_X->max;
+			}
+		}
+		if (functiondata->clip_Y) {
+			if (functiondata->clip_Y->min >=
+			    functiondata->clip_Y->max) {
+				pr_warning
+				    ("%s: Clip Y min (%d) >= Y clip max (%d) "
+				     "- ignored.",
+				     __func__, functiondata->clip_Y->min,
+				     functiondata->clip_Y->max);
+			} else {
+				instance_data->clip_Y_low =
+				    functiondata->clip_Y->min;
+				instance_data->clip_Y_high =
+				    functiondata->clip_Y->max;
+			}
+		}
+	}
+
+	/* need to init the input abs params for the 2D */
+	set_bit(EV_ABS, function_device->input->evbit);
+	set_bit(EV_SYN, function_device->input->evbit);
+	set_bit(EV_KEY, function_device->input->evbit);
+
+	f11_set_abs_params(function_device);
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
+EXPORT_SYMBOL(FN_11_init);
+
+int FN_11_detect(struct rmi_function_info *rmifninfo)
+{
+	unsigned char control_buffer[12]; /* TODO: Compute size correctly. */
+	int retval = 0;
+	struct f11_instance_data *instance_data;
+
+	pr_debug("%s: RMI4 F11 detect\n", __func__);
+
+	if (rmifninfo->fndata) {
+		/* detect routine should only ever be called once
+		 * per rmifninfo. */
+		pr_err("%s: WTF?!? F11 instance data is already present!",
+		       __func__);
+		return -EINVAL;
+	}
+	instance_data = kzalloc(sizeof(struct f11_instance_data), GFP_KERNEL);
+	if (!instance_data) {
+		pr_err("%s: Error allocating F11 instance data.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	rmifninfo->fndata = instance_data;
+
+	instance_data->device_info =
+	    kzalloc(sizeof(struct rmi_F11_device_query), GFP_KERNEL);
+	if (!instance_data->device_info) {
+		pr_err("%s: Error allocating F11 device query.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	instance_data->sensor_info =
+	    kzalloc(sizeof(struct rmi_F11_sensor_query), GFP_KERNEL);
+	if (!instance_data->sensor_info) {
+		pr_err("%s: Error allocating F11 sensor query.\n", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	retval = read_query_registers(rmifninfo);
+	if (retval) {
+		pr_err("%s: Failed to read sensor query registers.", __func__);
+		goto error_exit;
+	}
+
+	instance_data->finger_data_buffer =
+	    kcalloc(instance_data->finger_data_buffer_size,
+		    sizeof(unsigned char), GFP_KERNEL);
+	if (!instance_data->finger_data_buffer) {
+		pr_err("%s: Failed to allocate finger data buffer.", __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	/* Grab a copy of the control registers. */
+	instance_data->control_registers =
+	    kzalloc(sizeof(struct rmi_F11_control), GFP_KERNEL);
+	if (!instance_data->control_registers) {
+		pr_err("%s: Error allocating F11 control registers.\n",
+		       __func__);
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+	retval = rmi_read_multiple(rmifninfo->sensor,
+			      rmifninfo->function_descriptor.control_base_addr,
+			      control_buffer, sizeof(control_buffer));
+	if (retval) {
+		pr_err("%s: Failed to read F11 control registers.", __func__);
+		goto error_exit;
+	}
+	instance_data->control_registers->sensor_max_X_pos =
+	    (((int)control_buffer[7] & 0x0F) << 8) + control_buffer[6];
+	instance_data->control_registers->sensor_max_Y_pos =
+	    (((int)control_buffer[9] & 0x0F) << 8) + control_buffer[8];
+	pr_debug("%s: Max X %d Max Y %d", __func__,
+		 instance_data->control_registers->sensor_max_X_pos,
+		 instance_data->control_registers->sensor_max_Y_pos);
+	return 0;
+
+error_exit:
+	if (instance_data) {
+		kfree(instance_data->sensor_info);
+		kfree(instance_data->device_info);
+		kfree(instance_data->control_registers);
+		kfree(instance_data->finger_data_buffer);
+	}
+	kfree(instance_data);
+	rmifninfo->fndata = NULL;
+	return retval;
+}
+EXPORT_SYMBOL(FN_11_detect);
+
+static ssize_t rmi_fn_11_maxPos_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%u %u\n",
+		instance_data->control_registers->sensor_max_X_pos,
+		instance_data->control_registers->sensor_max_Y_pos);
+}
+
+static ssize_t rmi_fn_11_flip_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%u %u\n", instance_data->flip_X,
+			instance_data->flip_Y);
+}
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+	unsigned int new_X, new_Y;
+
+	if (sscanf(buf, "%u %u", &new_X, &new_Y) != 2)
+		return -EINVAL;
+	if (new_X < 0 || new_X > 1 || new_Y < 0 || new_Y > 1)
+		return -EINVAL;
+	instance_data->flip_X = new_X;
+	instance_data->flip_Y = new_Y;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_swap_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", instance_data->swap_axes);
+}
+
+static ssize_t rmi_fn_11_swap_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+	unsigned int newSwap;
+
+	if (sscanf(buf, "%u", &newSwap) != 1)
+		return -EINVAL;
+	if (newSwap < 0 || newSwap > 1)
+		return -EINVAL;
+	instance_data->swap_axes = newSwap;
+
+	f11_set_abs_params(fn);
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_relreport_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE,
+			"%u\n", instance_data->rel_report_enabled);
+}
+
+static ssize_t rmi_fn_11_relreport_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+	unsigned int new_value;
+
+	if (sscanf(buf, "%u", &new_value) != 1)
+		return -EINVAL;
+	if (new_value < 0 || new_value > 1)
+		return -EINVAL;
+	instance_data->rel_report_enabled = new_value;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%d %d\n", instance_data->offset_X,
+		instance_data->offset_Y);
+}
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+	int new_X, new_Y;
+
+	if (sscanf(buf, "%d %d", &new_X, &new_Y) != 2)
+		return -EINVAL;
+	instance_data->offset_X = new_X;
+	instance_data->offset_Y = new_Y;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+
+	return snprintf(buf, PAGE_SIZE, "%u %u %u %u\n",
+		       instance_data->clip_X_low, instance_data->clip_X_high,
+		       instance_data->clip_Y_low, instance_data->clip_Y_high);
+}
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = fn->rfi->fndata;
+	unsigned int new_X_low, new_X_high, new_Y_low, new_Y_high;
+
+	if (sscanf(buf, "%u %u %u %u",
+			&new_X_low, &new_X_high, &new_Y_low, &new_Y_high) != 4)
+		return -EINVAL;
+	if (new_X_low < 0 || new_X_low >= new_X_high || new_Y_low < 0
+			|| new_Y_low >= new_Y_high)
+		return -EINVAL;
+	instance_data->clip_X_low = new_X_low;
+	instance_data->clip_X_high = new_X_high;
+	instance_data->clip_Y_low = new_Y_low;
+	instance_data->clip_Y_high = new_Y_high;
+
+	f11_set_abs_params(fn);
+
+	return count;
+}
