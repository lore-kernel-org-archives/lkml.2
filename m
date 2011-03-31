Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1CaCk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:40:57 -0400
Received: from [12.234.97.163] ([12.234.97.163]:6289 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756801Ab1CaCk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:40:28 -0400
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
Subject: [PATCH 2/3] (corrected) input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Wed, 30 Mar 2011 19:39:28 -0700
Message-Id: <1301539169-9105-3-git-send-email-cheiny@synaptics.com>
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

diff --git a/drivers/input/touchscreen/rmi_f01.c b/drivers/input/touchscreen/rmi_f01.c
new file mode 100644
index 0000000..ddf6cd3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f01.c
@@ -0,0 +1,245 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $01 support for sensor
+ * control and configuration.
+ *
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
+#include <linux/param.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f01.h"
+
+
+#define RMI_REPORT_RATE_80 0
+#define RMI_REPORT_RATE_40 (1 << 6)
+
+/** Context data for each F01 we find.
+ */
+struct f01_instance_data {
+	struct rmi_F01_control *controlRegisters;
+	struct rmi_F01_data *dataRegisters;
+	struct rmi_F01_query *queryRegisters;
+};
+
+/*.
+ * The interrupt handler for Fn $01 doesn't do anything (for now).
+ */
+void FN_01_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	struct f01_instance_data *instanceData = (struct f01_instance_data *) rmifninfo->fndata;
+
+	printk(KERN_DEBUG "%s: Read device status.", __func__);
+
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr,
+		&instanceData->dataRegisters->deviceStatus, 1)) {
+		printk(KERN_ERR "%s : Could not read F01 device status.\n",
+			__func__);
+	}
+
+	/* TODO: Check for reset and handle appropriately.
+	*/
+}
+EXPORT_SYMBOL(FN_01_inthandler);
+
+/*
+ * This reads in the function $01 source data.
+ *
+ */
+void FN_01_attention(struct rmi_function_info *rmifninfo)
+{
+	struct f01_instance_data *instanceData = (struct f01_instance_data *) rmifninfo->fndata;
+
+	/* TODO: Compute size to read and number of IRQ registers to processors
+	* dynamically.  See comments in rmi.h. */
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr+1,
+		instanceData->dataRegisters->irqs, 1)) {
+		printk(KERN_ERR "%s : Could not read interrupt status registers at 0x%02x\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr);
+	}
+
+	if (instanceData->dataRegisters->irqs[0] & instanceData->controlRegisters->interruptEnable[0]) {
+		/* call down to the sensors irq dispatcher to dispatch all enabled IRQs */
+		rmifninfo->sensor->dispatchIRQs(rmifninfo->sensor,
+			instanceData->dataRegisters->irqs[0]);
+	}
+
+}
+EXPORT_SYMBOL(FN_01_attention);
+
+int FN_01_config(struct rmi_function_info *rmifninfo)
+{
+	/* print info and do any source specific configuration. */
+	int retval = 0;
+
+	printk(KERN_DEBUG "%s: RMI4 function $01 config\n", __func__);
+
+	/* On slow processors, we need to throttle back the rate at which
+	* data updates become ready. */
+#if 0
+	/* TODO: This code gets invoked pointlessly on some systems, and causes
+	 * the Synaptics device to stop working in those cases.  We need to figure
+	 * out what's going on there.
+	 */
+	if (HZ < 500) {
+		/* The default packet rate of 80 packets per
+		* second is too fast (the Linux time slice for
+		* sub-GHz processors is only 100 times per second).
+		* So re-program it to 40 packets per second.
+		*/
+		/* TODO: We need to OR this in, rather than stomping on the other
+		 * contents of the register.  It's OK for now, because this is
+		 * early in the initializaton process and nobody else has had
+		 * a chance to change this register, which defaults to 0.
+		 */
+		rmi_write(rmifninfo->sensor, rmifninfo->funcDescriptor.controlBaseAddr, RMI_REPORT_RATE_40);
+		printk(KERN_INFO "%s: Throttled back reporting for slow CPU (%d HZ).", __func__, HZ);
+	}
+#endif
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_01_config);
+
+/* Initialize any function $01 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_01_init(struct rmi_function_device *function_device)
+{
+	pr_debug("%s: RMI4 function $01 init\n", __func__);
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_01_init);
+
+int FN_01_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	int i;
+	int InterruptOffset;
+	int retval = 0;
+	struct f01_instance_data *instanceData;
+	struct rmi_F01_control *controlRegisters;
+	struct rmi_F01_data *dataRegisters;
+	struct rmi_F01_query *queryRegisters;
+
+	pr_debug("%s: RMI4 function $01 detect\n", __func__);
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* Set up context data. */
+	instanceData = kzalloc(sizeof(*instanceData), GFP_KERNEL);
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 context data.\n", __func__);
+		return -ENOMEM;
+	}
+	queryRegisters = kzalloc(sizeof(*queryRegisters), GFP_KERNEL);
+	if (!queryRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 query registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->queryRegisters = queryRegisters;
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr,
+		(char *)instanceData->queryRegisters, sizeof(struct rmi_F01_query));
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read F01 control registers at 0x%02x. Error %d.\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr, retval);
+	}
+	printk(KERN_DEBUG "%s: RMI Protocol: %d.%d",
+		__func__, queryRegisters->rmi_maj_ver, queryRegisters->rmi_min_ver);
+	printk(KERN_DEBUG "%s: Manufacturer: %d %s", __func__,
+		queryRegisters->mfgid, queryRegisters->mfgid == 1 ? "(Synaptics)" : "");
+	printk(KERN_DEBUG "%s: Properties: 0x%x",
+		__func__, queryRegisters->properties);
+	printk(KERN_DEBUG "%s: Product Info: 0x%x 0x%x",
+		__func__, queryRegisters->prod_info[0], queryRegisters->prod_info[1]);
+	printk(KERN_DEBUG "%s: Date Code: Year : %d Month: %d Day: %d",
+		__func__, queryRegisters->date_code[0], queryRegisters->date_code[1],
+		queryRegisters->date_code[2]);
+	printk(KERN_DEBUG "%s: Tester ID: %d", __func__, queryRegisters->tester_id);
+	printk(KERN_DEBUG "%s: Serial Number: 0x%x",
+		__func__, queryRegisters->serial_num);
+	printk(KERN_DEBUG "%s: Product ID: %s", __func__, queryRegisters->prod_id);
+
+	/* TODO: size of control registers needs to be computed dynamically.  See comment
+	* in rmi.h. */
+	controlRegisters = kzalloc(sizeof(*controlRegisters), GFP_KERNEL);
+	if (!controlRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 control registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->controlRegisters = controlRegisters;
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.controlBaseAddr,
+		(char *)instanceData->controlRegisters, sizeof(struct rmi_F01_control));
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read F01 control registers at 0x%02x. Error %d.\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr, retval);
+	}
+
+	/* TODO: size of data registers needs to be computed dynamically.  See comment
+	* in rmi.h. */
+	dataRegisters = kzalloc(sizeof(*dataRegisters), GFP_KERNEL);
+	if (!dataRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 data registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->dataRegisters = dataRegisters;
+	rmifninfo->fndata = instanceData;
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source and or in a bit
+	to the interrupt mask for each. */
+	InterruptOffset = interruptCount % 8;
+
+	for (i = InterruptOffset;
+		i < ((fndescr->interruptSrcCnt & 0x7) + InterruptOffset);
+		i++) {
+			rmifninfo->interruptMask |= 1 << i;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_01_detect);
diff --git a/drivers/input/touchscreen/rmi_f01.h b/drivers/input/touchscreen/rmi_f01.h
new file mode 100644
index 0000000..976e062
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f01.h
@@ -0,0 +1,40 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $01 header.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ * There is only one function $01 for each RMI4 sensor. This will be
+ * the function that is used to set sensor control and configurations
+ * and check the interrupts to find the source function that is interrupting.
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
+#ifndef _RMI_FUNCTION_01_H
+#define _RMI_FUNCTION_01_H
+
+void FN_01_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_01_config(struct rmi_function_info *rmifninfo);
+int FN_01_init(struct rmi_function_device *function_device);
+int FN_01_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+void FN_01_attention(struct rmi_function_info *rmifninfo);
+#endif
diff --git a/drivers/input/touchscreen/rmi_f11.c b/drivers/input/touchscreen/rmi_f11.c
new file mode 100644
index 0000000..18c44e1
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.c
@@ -0,0 +1,896 @@
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
+
+static int sensorMaxX;
+static int sensorMaxY;
+
+struct f11_instance_data {
+	struct rmi_F11_device_query *deviceInfo;
+	struct rmi_F11_sensor_query *sensorInfo;
+	struct rmi_F11_control *controlRegisters;
+	unsigned char fingerDataBufferSize;
+	unsigned char absDataOffset;
+	unsigned char absDataSize;
+	unsigned char relDataOffset;
+	unsigned char gestureDataOffset;
+	unsigned char *fingerDataBuffer;
+		/* Last X & Y seen, needed at finger lift.  Was down indicates at least one finger was here. */
+		/* TODO: Eventually we'll need to track this info on a per finger basis. */
+	bool wasdown;
+	unsigned int oldX;
+	unsigned int oldY;
+		/* Transformations to be applied to coordinates before reporting. */
+	bool flipX;
+	bool flipY;
+	int offsetX;
+	int offsetY;
+	int clipXLow;
+	int clipXHigh;
+	int clipYLow;
+	int clipYHigh;
+	bool swap_axes;
+	bool relReport;
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
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(flip, 0664, rmi_fn_11_flip_show, rmi_fn_11_flip_store);     /* RW attr */
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(clip, 0664, rmi_fn_11_clip_show, rmi_fn_11_clip_store);     /* RW attr */
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(offset, 0664, rmi_fn_11_offset_show, rmi_fn_11_offset_store);     /* RW attr */
+
+static ssize_t rmi_fn_11_swap_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_swap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(swap, 0664, rmi_fn_11_swap_show, rmi_fn_11_swap_store);     /* RW attr */
+
+static void FN_11_relreport(struct rmi_function_info *rmifninfo);
+
+/*
+ * There is no attention function for Fn $11 - it is left NULL
+ * in the function table so it is not called.
+ *
+ */
+
+
+/*
+ * This reads in a sample and reports the function $11 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	/* number of touch points - fingers down in this case */
+	int fingerDownCount;
+	int finger;
+	struct rmi_function_device *function_device;
+	struct f11_instance_data *instanceData;
+
+	instanceData = (struct f11_instance_data *) rmifninfo->fndata;
+
+	fingerDownCount = 0;
+	function_device = rmifninfo->function_device;
+
+	/* get 2D sensor finger data */
+
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr,
+		instanceData->fingerDataBuffer, instanceData->fingerDataBufferSize)) {
+		printk(KERN_ERR "%s: Failed to read finger data registers.\n", __func__);
+		return;
+	}
+
+		/* First we need to count the fingers and generate some events related to that. */
+	for (finger = 0; finger < instanceData->sensorInfo->numberOfFingers; finger++) {
+		int reg;
+		int fingerShift;
+		int fingerStatus;
+
+		/* determine which data byte the finger status is in */
+		reg = finger/4;
+		/* bit shift to get finger's status */
+		fingerShift = (finger % 4) * 2;
+		fingerStatus = (instanceData->fingerDataBuffer[reg] >> fingerShift) & 3;
+
+		if (fingerStatus == F11_PRESENT || fingerStatus == F11_INACCURATE) {
+			fingerDownCount++;
+			instanceData->wasdown = true;
+		}
+	}
+	input_report_key(function_device->input,
+			BTN_TOUCH, fingerDownCount);
+	for (finger = 0; finger < (instanceData->sensorInfo->numberOfFingers - 1); finger++) {
+		input_report_key(function_device->input,
+			BTN_2 + finger, fingerDownCount >= (finger + 2));
+	}
+
+	for (finger = 0; finger < instanceData->sensorInfo->numberOfFingers; finger++) {
+		int reg;
+		int fingerShift;
+		int fingerStatus;
+		int X = 0, Y = 0, Z = 0, Wy = 0, Wx = 0;
+
+		/* determine which data byte the finger status is in */
+		reg = finger/4;
+		/* bit shift to get finger's status */
+		fingerShift = (finger % 4) * 2;
+		fingerStatus = (instanceData->fingerDataBuffer[reg] >> fingerShift) & 3;
+
+		/* if finger status indicates a finger is present then
+		read the finger data and report it */
+		if (fingerStatus == F11_PRESENT || fingerStatus == F11_INACCURATE) {
+
+			if (instanceData->sensorInfo->hasAbs) {
+				int maxX = instanceData->controlRegisters->sensorMaxXPos;
+				int maxY = instanceData->controlRegisters->sensorMaxYPos;
+				reg = instanceData->absDataOffset + (finger * instanceData->absDataSize);
+				X = (instanceData->fingerDataBuffer[reg] << 4) & 0x0ff0;
+				X |= (instanceData->fingerDataBuffer[reg+2] & 0x0f);
+				Y = (instanceData->fingerDataBuffer[reg+1] << 4) & 0x0ff0;
+				Y |= ((instanceData->fingerDataBuffer[reg+2] & 0xf0) >> 4) & 0x0f;
+				/* First thing to do is swap axes if needed.
+				 */
+				if (instanceData->swap_axes) {
+					int temp = X;
+					X = Y;
+					Y = temp;
+					maxX = instanceData->controlRegisters->sensorMaxYPos;
+					maxY = instanceData->controlRegisters->sensorMaxXPos;
+				}
+				if (instanceData->flipX)
+					X = max(maxX-X, 0);
+				X = X - instanceData->offsetX;
+				X = min(max(X, instanceData->clipXLow), instanceData->clipXHigh);
+				if (instanceData->flipY)
+					Y = max(maxY-Y, 0);
+				Y = Y - instanceData->offsetY;
+				Y = min(max(Y, instanceData->clipYLow), instanceData->clipYHigh);
+
+				/* upper 4 bits of W are Wy,
+				lower 4 of W are Wx */
+				Wy =  (instanceData->fingerDataBuffer[reg+3] >> 4) & 0x0f;
+				Wx = instanceData->fingerDataBuffer[reg+3] & 0x0f;
+				if (instanceData->swap_axes) {
+					int temp = Wx;
+					Wx = Wy;
+					Wy = temp;
+				}
+
+				Z = instanceData->fingerDataBuffer[reg+4];
+
+				/* if this is the first finger report normal
+				ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
+				non-MT apps. Apps that support Multi-touch
+				will ignore these events and use the MT events.
+				Apps that don't support Multi-touch will still
+				function.
+				*/
+				if (fingerDownCount == 1) {
+					instanceData->oldX = X;
+					instanceData->oldY = Y;
+					input_report_abs(function_device->input, ABS_X, X);
+					input_report_abs(function_device->input, ABS_Y, Y);
+					input_report_abs(function_device->input, ABS_PRESSURE, Z);
+					input_report_abs(function_device->input, ABS_TOOL_WIDTH,
+							max(Wx, Wy));
+				} else {
+					/* TODO generate non MT events for multifinger situation. */
+				}
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+				/* Report Multi-Touch events for each finger */
+				/* major axis of touch area ellipse */
+				input_report_abs(function_device->input, ABS_MT_TOUCH_MAJOR, Z);
+				/* minor axis of touch area ellipse */
+				input_report_abs(function_device->input, ABS_MT_WIDTH_MAJOR,
+						max(Wx, Wy));
+				/* Currently only 2 supported - 1 or 0 */
+				input_report_abs(function_device->input, ABS_MT_ORIENTATION,
+					(Wx > Wy ? 1 : 0));
+				input_report_abs(function_device->input, ABS_MT_POSITION_X, X);
+				input_report_abs(function_device->input, ABS_MT_POSITION_Y, Y);
+
+				/* TODO: Tracking ID needs to be reported but not used yet. */
+				/* Could be formed by keeping an id per position and assiging */
+				/* a new id when fingerStatus changes for that position.*/
+				input_report_abs(function_device->input, ABS_MT_TRACKING_ID,
+						finger+1);
+
+				/* MT sync between fingers */
+				input_mt_sync(function_device->input);
+#endif
+			}
+		}
+	}
+
+	/* if we had a finger down before and now we don't have any send a button up. */
+	if ((fingerDownCount == 0) && instanceData->wasdown) {
+		instanceData->wasdown = false;
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+		input_report_abs(function_device->input, ABS_MT_TOUCH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_WIDTH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_POSITION_X, instanceData->oldX);
+		input_report_abs(function_device->input, ABS_MT_POSITION_Y, instanceData->oldY);
+		input_report_abs(function_device->input, ABS_MT_TRACKING_ID, 1);
+		input_mt_sync(function_device->input);
+#endif
+
+		input_report_abs(function_device->input, ABS_X, instanceData->oldX);
+		input_report_abs(function_device->input, ABS_Y, instanceData->oldY);
+		instanceData->oldX = instanceData->oldY = 0;
+		printk(KERN_DEBUG "%s: Finger up.", __func__);
+	}
+
+	FN_11_relreport(rmifninfo);
+	input_sync(function_device->input); /* sync after groups of events */
+
+}
+EXPORT_SYMBOL(FN_11_inthandler);
+
+/* This function reads in relative data for first finger and send to input system */
+static void FN_11_relreport(struct rmi_function_info *rmifninfo)
+{
+	struct f11_instance_data *instanceData;
+	struct rmi_function_device *function_device;
+	signed char X, Y;
+	unsigned short fn11DataBaseAddr;
+	
+	instanceData = (struct f11_instance_data *) rmifninfo->fndata;
+
+	if (instanceData->sensorInfo->hasRel && instanceData->relReport) {
+		function_device = rmifninfo->function_device;
+
+		fn11DataBaseAddr = rmifninfo->funcDescriptor.dataBaseAddr;
+		/* Read and report Rel data for primary finger one register for X and one for Y*/
+		int reg = instanceData->relDataOffset;
+		X = instanceData->fingerDataBuffer[reg];
+		Y = instanceData->fingerDataBuffer[reg+1];
+		if (instanceData->swap_axes) {
+			signed char temp = X;
+			X = Y;
+			Y = temp;
+		}
+		if (instanceData->flipX) {
+			X = -X;
+		}
+		if (instanceData->flipY) {
+			Y = -Y;
+		}
+		X = min(127, max(-128, X));
+		Y = min(127, max(-128, Y));
+
+		input_report_rel(function_device->input, REL_X, X);
+		input_report_rel(function_device->input, REL_Y, Y);
+	}
+}
+
+int FN_11_config(struct rmi_function_info *rmifninfo)
+{
+	/* For the data source - print info and do any
+	source specific configuration. */
+	unsigned char data[14];
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $11 config\n", __func__);
+
+	/* Get and print some info about the data source... */
+
+	/* To Query 2D devices we need to read from the address obtained
+	* from the function descriptor stored in the RMI function info.
+	*/
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr,
+		data, 9);
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 config:"
+			"Could not read function query registers 0x%x\n",
+			__func__, rmifninfo->funcDescriptor.queryBaseAddr);
+	} else {
+		pr_debug("%s:  Number of Fingers:   %d\n",
+				__func__, data[1] & 7);
+		pr_debug("%s:  Is Configurable:     %d\n",
+				__func__, data[1] & (1 << 7) ? 1 : 0);
+		pr_debug("%s:  Has Gestures:        %d\n",
+				__func__, data[1] & (1 << 5) ? 1 : 0);
+		pr_debug("%s:  Has Absolute:        %d\n",
+				__func__, data[1] & (1 << 4) ? 1 : 0);
+		pr_debug("%s:  Has Relative:        %d\n",
+				__func__, data[1] & (1 << 3) ? 1 : 0);
+
+		pr_debug("%s:  Number X Electrodes: %d\n",
+				__func__, data[2] & 0x1f);
+		pr_debug("%s:  Number Y Electrodes: %d\n",
+				__func__, data[3] & 0x1f);
+		pr_debug("%s:  Maximum Electrodes:  %d\n",
+				__func__, data[4] & 0x1f);
+
+		pr_debug("%s:  Absolute Data Size:  %d\n",
+				__func__, data[5] & 3);
+
+		pr_debug("%s:  Has XY Dist:         %d\n",
+				__func__, data[7] & (1 << 7) ? 1 : 0);
+		pr_debug("%s:  Has Pinch:           %d\n",
+				__func__, data[7] & (1 << 6) ? 1 : 0);
+		pr_debug("%s:  Has Press:           %d\n",
+				__func__, data[7] & (1 << 5) ? 1 : 0);
+		pr_debug("%s:  Has Flick:           %d\n",
+				__func__, data[7] & (1 << 4) ? 1 : 0);
+		pr_debug("%s:  Has Early Tap:       %d\n",
+				__func__, data[7] & (1 << 3) ? 1 : 0);
+		pr_debug("%s:  Has Double Tap:      %d\n",
+				__func__, data[7] & (1 << 2) ? 1 : 0);
+		pr_debug("%s:  Has Tap and Hold:    %d\n",
+				__func__, data[7] & (1 << 1) ? 1 : 0);
+		pr_debug("%s:  Has Tap:             %d\n",
+				__func__, data[7] & 1 ? 1 : 0);
+		pr_debug("%s:  Has Palm Detect:     %d\n",
+				__func__, data[8] & 1 ? 1 : 0);
+		pr_debug("%s:  Has Rotate:          %d\n",
+				__func__, data[8] & (1 << 1) ? 1 : 0);
+
+		retval = rmi_read_multiple(rmifninfo->sensor,
+				rmifninfo->funcDescriptor.controlBaseAddr, data, 14);
+		if (retval) {
+			printk(KERN_ERR "%s: RMI4 function $11 config:"
+				"Could not read control registers 0x%x\n",
+				__func__, rmifninfo->funcDescriptor.controlBaseAddr);
+			return retval;
+		}
+
+		/* Store these for use later...*/
+		sensorMaxX = ((data[6] & 0x1f) << 8) | ((data[7] & 0xff) << 0);
+		sensorMaxY = ((data[8] & 0x1f) << 8) | ((data[9] & 0xff) << 0);
+
+		pr_debug("%s:  Sensor Max X:  %d\n", __func__, sensorMaxX);
+		pr_debug("%s:  Sensor Max Y:  %d\n", __func__, sensorMaxY);
+	}
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
+	int xMin = instance_data->clipXLow;
+	int xMax = min((int) instance_data->controlRegisters->sensorMaxXPos, instance_data->clipXHigh);
+	int yMin = instance_data->clipYLow;
+	int yMax = min((int) instance_data->controlRegisters->sensorMaxYPos, instance_data->clipYHigh);
+	if (instance_data->swap_axes) {
+		int temp = xMin;
+		xMin = yMin;
+		yMin = temp;
+		temp = xMax;
+		xMax = yMax;
+		yMax = temp;
+	}
+	printk(KERN_DEBUG "%s: Set ranges X=[%d..%d] Y=[%d..%d].", __func__, xMin, xMax, yMin, yMax);
+	input_set_abs_params(function_device->input, ABS_X, xMin, xMax,
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_Y, yMin, yMax,
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_PRESSURE, 0, 255, 0, 0);
+	input_set_abs_params(function_device->input, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MAJOR, 0, 15, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MINOR, 0, 15, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TRACKING_ID, 1, 10, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_X, xMin, xMax,
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_Y, yMin, yMax,
+		0, 0);
+#endif
+}
+
+/* Initialize any function $11 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_11_init(struct rmi_function_device *function_device)
+{
+	struct f11_instance_data *instanceData = function_device->rfi->fndata;
+	int retval = 0;
+	struct rmi_f11_functiondata *functiondata = rmi_sensor_get_functiondata(function_device->sensor, RMI_F11_INDEX);
+	printk(KERN_DEBUG "%s: RMI4 F11 init", __func__);
+
+	/* TODO: Initialize these through some normal kernel mechanism.
+	 */
+	instanceData->flipX = false;
+	instanceData->flipY = false;
+	instanceData->swap_axes = false;
+	instanceData->relReport = true;
+	instanceData->offsetX = instanceData->offsetY = 0;
+	instanceData->clipXLow = instanceData->clipYLow = 0;
+	/* TODO: 65536 should actually be the largest valid RMI4 position coordinate */
+	instanceData->clipXHigh = instanceData->clipYHigh = 65536;
+
+	/* Load any overrides that were specified via platform data.
+	 */
+	if (functiondata) {
+		printk(KERN_DEBUG "%s: found F11 per function platformdata.", __func__);
+		instanceData->flipX = functiondata->flipX;
+		instanceData->flipY = functiondata->flipY;
+		instanceData->swap_axes = functiondata->swap_axes;
+		if (functiondata->offset) {
+			instanceData->offsetX = functiondata->offset->x;
+			instanceData->offsetY = functiondata->offset->y;
+		}
+		if (functiondata->clipX) {
+			if (functiondata->clipX->min >= functiondata->clipX->max) {
+				printk(KERN_WARNING "%s: Clip X min (%d) >= X clip max (%d) - ignored.",
+					   __func__, functiondata->clipX->min, functiondata->clipX->max);
+			} else {
+				instanceData->clipXLow = functiondata->clipX->min;
+				instanceData->clipXHigh = functiondata->clipX->max;
+			}
+		}
+		if (functiondata->clipY) {
+			if (functiondata->clipY->min >= functiondata->clipY->max) {
+				printk(KERN_WARNING "%s: Clip Y min (%d) >= Y clip max (%d) - ignored.",
+					   __func__, functiondata->clipY->min, functiondata->clipY->max);
+			} else {
+				instanceData->clipYLow = functiondata->clipY->min;
+				instanceData->clipYHigh = functiondata->clipY->max;
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
+	printk(KERN_DEBUG "%s: Creating sysfs files.", __func__);
+	retval = device_create_file(&function_device->dev, &dev_attr_flip);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create flip.", __func__);
+		return retval;
+	}
+	retval = device_create_file(&function_device->dev, &dev_attr_clip);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create clip.", __func__);
+		return retval;
+	}
+	retval = device_create_file(&function_device->dev, &dev_attr_offset);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create offset.", __func__);
+		return retval;
+	}
+	retval = device_create_file(&function_device->dev, &dev_attr_swap);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create swap.", __func__);
+		return retval;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_11_init);
+
+int FN_11_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	unsigned char fn11Queries[12];   /* TODO: Compute size correctly. */
+	unsigned char fn11Control[12];   /* TODO: Compute size correctly. */
+	int i;
+	unsigned short fn11InterruptOffset;
+	unsigned char fn11AbsDataBlockSize;
+	int fn11HasPinch, fn11HasFlick, fn11HasTap;
+	int fn11HasTapAndHold, fn11HasDoubleTap;
+	int fn11HasEarlyTap, fn11HasPress;
+	int fn11HasPalmDetect, fn11HasRotate;
+	int fn11HasRel;
+	unsigned char f11_egr_0, f11_egr_1;
+	unsigned int fn11AllDataBlockSize;
+	int retval = 0;
+	struct f11_instance_data *instanceData;
+
+	printk(KERN_DEBUG "%s: RMI4 F11 detect\n", __func__);
+
+	instanceData = kzalloc(sizeof(struct f11_instance_data), GFP_KERNEL);
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error allocating F11 instance data.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->deviceInfo = kzalloc(sizeof(struct rmi_F11_device_query), GFP_KERNEL);
+	if (!instanceData->deviceInfo) {
+		printk(KERN_ERR "%s: Error allocating F11 device query.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->sensorInfo = kzalloc(sizeof(struct rmi_F11_sensor_query), GFP_KERNEL);
+	if (!instanceData->sensorInfo) {
+		printk(KERN_ERR "%s: Error allocating F11 sensor query.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = instanceData;
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* need to get number of fingers supported, data size, etc. -
+	to be used when getting data since the number of registers to
+	read depends on the number of fingers supported and data size. */
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->queryBaseAddr, fn11Queries,
+			sizeof(fn11Queries));
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 detect: "
+			"Could not read function query registers 0x%x\n",
+			__func__,  rmifninfo->funcDescriptor.queryBaseAddr);
+		return retval;
+	}
+
+	/* Extract device data. */
+	instanceData->deviceInfo->hasQuery9 = (fn11Queries[0] & 0x04) != 0;
+	instanceData->deviceInfo->numberOfSensors = (fn11Queries[0] & 0x07) + 1;
+	printk(KERN_DEBUG "%s: F11 device - %d sensors.  Query 9? %d.", __func__, instanceData->deviceInfo->numberOfSensors, instanceData->deviceInfo->hasQuery9);
+
+	/* Extract sensor data. */
+	/* 2D data sources have only 3 bits for the number of fingers
+	supported - so the encoding is a bit wierd. */
+	instanceData->sensorInfo->numberOfFingers = 2; /* default number of fingers supported */
+	if ((fn11Queries[1] & 0x7) <= 4)
+		/* add 1 since zero based */
+		instanceData->sensorInfo->numberOfFingers = (fn11Queries[1] & 0x7) + 1;
+	else {
+		/* a value of 5 is up to 10 fingers - 6 and 7 are reserved
+		(shouldn't get these i int retval;n a normal 2D source). */
+		if ((fn11Queries[1] & 0x7) == 5)
+			instanceData->sensorInfo->numberOfFingers = 10;
+	}
+	instanceData->sensorInfo->configurable = (fn11Queries[1] & 0x80) != 0;
+	instanceData->sensorInfo->hasSensitivityAdjust = (fn11Queries[1] & 0x40) != 0;
+	instanceData->sensorInfo->hasGestures = (fn11Queries[1] & 0x20) != 0;
+	instanceData->sensorInfo->hasAbs = (fn11Queries[1] & 0x10) != 0;
+	instanceData->sensorInfo->hasRel = (fn11Queries[1] & 0x08) != 0;
+	instanceData->sensorInfo->absDataSize = fn11Queries[5] & 0x03;
+	printk(KERN_DEBUG "%s: Number of fingers: %d.", __func__, instanceData->sensorInfo->numberOfFingers);
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source in fn $11 and or in a bit
+	to the interrupt mask for each. */
+	fn11InterruptOffset = interruptCount % 8;
+
+	for (i = fn11InterruptOffset;
+			i < ((fndescr->interruptSrcCnt & 0x7) + fn11InterruptOffset);
+			i++)
+		rmifninfo->interruptMask |= 1 << i;
+
+	/* Figure out just how much data we'll need to read. */
+	instanceData->fingerDataBufferSize = (instanceData->sensorInfo->numberOfFingers + 3) / 4;
+	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+	fn11AbsDataBlockSize = 5;
+	if (instanceData->sensorInfo->absDataSize != 0)
+		printk(KERN_WARNING "%s: Unrecognized abs data size %d ignored.", __func__, instanceData->sensorInfo->absDataSize);
+	if (instanceData->sensorInfo->hasAbs) {
+		instanceData->absDataSize = fn11AbsDataBlockSize;
+		instanceData->absDataOffset = instanceData->fingerDataBufferSize;
+		instanceData->fingerDataBufferSize += instanceData->sensorInfo->numberOfFingers * fn11AbsDataBlockSize;
+	}
+	if (instanceData->sensorInfo->hasRel) {
+		instanceData->relDataOffset = ((instanceData->sensorInfo->numberOfFingers + 3) / 4) +
+			/* absolute data, per finger times number of fingers */
+			(fn11AbsDataBlockSize * instanceData->sensorInfo->numberOfFingers);
+		instanceData->fingerDataBufferSize += instanceData->sensorInfo->numberOfFingers * 2;
+	}
+	if (instanceData->sensorInfo->hasGestures) {
+		instanceData->gestureDataOffset = instanceData->fingerDataBufferSize;
+		printk(KERN_WARNING "%s: WARNING Need to correctly compute gesture data location.", __func__);
+	}
+
+	/* need to determine the size of data to read - this depends on
+	conditions such as whether Relative data is reported and if Gesture
+	data is reported. */
+	f11_egr_0 = fn11Queries[7];
+	f11_egr_1 = fn11Queries[8];
+
+	/* Get info about what EGR data is supported, whether it has
+	Relative data supported, etc. */
+	fn11HasPinch = f11_egr_0 & 0x40;
+	fn11HasFlick = f11_egr_0 & 0x10;
+	fn11HasTap = f11_egr_0 & 0x01;
+	fn11HasTapAndHold = f11_egr_0 & 0x02;
+	fn11HasDoubleTap = f11_egr_0 & 0x04;
+	fn11HasEarlyTap = f11_egr_0 & 0x08;
+	fn11HasPress = f11_egr_0 & 0x20;
+	fn11HasPalmDetect = f11_egr_1 & 0x01;
+	fn11HasRotate = f11_egr_1 & 0x02;
+	fn11HasRel = fn11Queries[1] & 0x08;
+
+	/* Size of all data including finger status, absolute data for each
+	finger, relative data and EGR data */
+	fn11AllDataBlockSize =
+		/* finger status, four fingers per register */
+		((instanceData->sensorInfo->numberOfFingers + 3) / 4) +
+		/* absolute data, per finger times number of fingers */
+		(fn11AbsDataBlockSize * instanceData->sensorInfo->numberOfFingers) +
+		/* two relative registers (if relative is being reported) */
+		2 * fn11HasRel +
+		/* F11_2D_Data8 is only present if the egr_0
+		register is non-zero. */
+		!!(f11_egr_0) +
+		/* F11_2D_Data9 is only present if either egr_0 or
+		egr_1 registers are non-zero. */
+		(f11_egr_0 || f11_egr_1) +
+		/* F11_2D_Data10 is only present if EGR_PINCH or EGR_FLICK of
+		egr_0 reports as 1. */
+		!!(fn11HasPinch | fn11HasFlick) +
+		/* F11_2D_Data11 and F11_2D_Data12 are only present if
+		EGR_FLICK of egr_0 reports as 1. */
+		2 * !!(fn11HasFlick);
+	instanceData->fingerDataBuffer = kcalloc(instanceData->fingerDataBufferSize, sizeof(unsigned char), GFP_KERNEL);
+	if (!instanceData->fingerDataBuffer) {
+		printk(KERN_ERR "%s: Failed to allocate finger data buffer.", __func__);
+		return -ENOMEM;
+	}
+
+	/* Grab a copy of the control registers. */
+	instanceData->controlRegisters = kzalloc(sizeof(struct rmi_F11_control), GFP_KERNEL);
+	if (!instanceData->controlRegisters) {
+		printk(KERN_ERR "%s: Error allocating F11 control registers.\n", __func__);
+		return -ENOMEM;
+	}
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->controlBaseAddr,
+		fn11Control, sizeof(fn11Control));
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to read F11 control registers.", __func__);
+		return retval;
+	}
+	instanceData->controlRegisters->sensorMaxXPos = (((int) fn11Control[7] & 0x0F) << 8) + fn11Control[6];
+	instanceData->controlRegisters->sensorMaxYPos = (((int) fn11Control[9] & 0x0F) << 8) + fn11Control[8];
+	printk(KERN_DEBUG "%s: Max X %d Max Y %d", __func__, instanceData->controlRegisters->sensorMaxXPos, instanceData->controlRegisters->sensorMaxYPos);
+	return 0;
+}
+EXPORT_SYMBOL(FN_11_detect);
+
+static ssize_t rmi_fn_11_maxPos_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u %u\n", instance_data->controlRegisters->sensorMaxXPos, instance_data->controlRegisters->sensorMaxYPos);
+}
+
+static ssize_t rmi_fn_11_maxPos_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	return -EPERM;
+}
+
+static ssize_t rmi_fn_11_flip_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u %u\n", instance_data->flipX, instance_data->flipY);
+}
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int newX, newY;
+
+	printk(KERN_DEBUG "%s: Flip set to %s", __func__, buf);
+
+	if (sscanf(buf, "%u %u", &newX, &newY) != 2)
+		return -EINVAL;
+	if (newX < 0 || newX > 1 || newY < 0 || newY > 1)
+		return -EINVAL;
+	instance_data->flipX = newX;
+	instance_data->flipY = newY;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_swap_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", instance_data->swap_axes);
+}
+
+static ssize_t rmi_fn_11_swap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int newSwap;
+
+	printk(KERN_DEBUG "%s: Swap set to %s", __func__, buf);
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
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u \n", instance_data->relReport);
+}
+
+static ssize_t rmi_fn_11_relreport_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int relRep;
+
+	printk(KERN_DEBUG "%s: relReport set to %s", __func__, buf);
+	if (sscanf(buf, "%u", &relRep) != 1)
+		return -EINVAL;
+	if (relRep < 0 || relRep > 1)
+		return -EINVAL;
+	instance_data->relReport = relRep;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%d %d\n", instance_data->offsetX, instance_data->offsetY);
+}
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	int newX, newY;
+
+	printk(KERN_DEBUG "%s: Offset set to %s", __func__, buf);
+
+	if (sscanf(buf, "%d %d", &newX, &newY) != 2)
+		return -EINVAL;
+	instance_data->offsetX = newX;
+	instance_data->offsetY = newY;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u %u %u %u\n",
+				   instance_data->clipXLow, instance_data->clipXHigh,
+				   instance_data->clipYLow, instance_data->clipYHigh);
+}
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int newXLow, newXHigh, newYLow, newYHigh;
+
+	printk(KERN_DEBUG "%s: Clip set to %s", __func__, buf);
+
+	if (sscanf(buf, "%u %u %u %u", &newXLow, &newXHigh, &newYLow, &newYHigh) != 4)
+		return -EINVAL;
+	if (newXLow < 0 || newXLow >= newXHigh || newYLow < 0 || newYLow >= newYHigh)
+		return -EINVAL;
+	instance_data->clipXLow = newXLow;
+	instance_data->clipXHigh = newXHigh;
+	instance_data->clipYLow = newYLow;
+	instance_data->clipYHigh = newYHigh;
+
+	f11_set_abs_params(fn);
+
+	return count;
+}
diff --git a/drivers/input/touchscreen/rmi_f11.h b/drivers/input/touchscreen/rmi_f11.h
new file mode 100644
index 0000000..0bf386a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.h
@@ -0,0 +1,43 @@
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
+#ifndef _RMI_FUNCTION_11_H
+#define _RMI_FUNCTION_11_H
+
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_11_config(struct rmi_function_info *rmifninfo);
+int FN_11_init(struct rmi_function_device *function_device);
+int FN_11_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+/* No attention function for Fn $11 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f19.c b/drivers/input/touchscreen/rmi_f19.c
new file mode 100644
index 0000000..145f958
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f19.c
@@ -0,0 +1,516 @@
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
+
+struct f19_instance_data {
+	struct rmi_F19_query *deviceInfo;
+	struct rmi_F19_control *controlRegisters;
+	bool *buttonDown;
+	unsigned char buttonDataBufferSize;
+	unsigned char *buttonDataBuffer;
+	unsigned char *buttonMap;
+	int fn19ControlRegisterSize;
+	int fn19regCountForBitPerButton;
+	int fn19btnUsageandfilterModeOffset;
+	int fn19intEnableOffset;
+	int fn19intEnableLen;
+	int fn19singleBtnCtrlLen;
+	int fn19singleBtnCtrlOffset;
+	int fn19sensorMapCtrlOffset;
+	int fn19sensorMapCtrlLen;
+	int fn19singleBtnSensOffset;
+	int fn19singleBtnSensLen;
+	int fn19globalSensOffset;
+	int fn19globalHystThreshOffset;
+};
+
+static ssize_t rmi_f19_buttonCount_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f19_buttonCount_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(buttonCount, 0444, rmi_f19_buttonCount_show, rmi_f19_buttonCount_store);	/* RO attr */
+
+static ssize_t rmi_f19_buttonMap_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f19_buttonMap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(buttonMap, 0664, rmi_f19_buttonMap_show, rmi_f19_buttonMap_store);	/* RW attr */
+
+
+/*
+ * There is no attention function for F19 - it is left NULL
+ * in the function table so it is not called.
+ *
+ */
+
+
+/*
+ * This reads in a sample and reports the F19 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+void FN_19_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	struct rmi_function_device *function_device;
+	struct f19_instance_data *instanceData;
+	int button;
+
+	instanceData = (struct f19_instance_data *) rmifninfo->fndata;
+
+	function_device = rmifninfo->function_device;
+
+	/* Read the button data. */
+
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr,
+		instanceData->buttonDataBuffer, instanceData->buttonDataBufferSize)) {
+		printk(KERN_ERR "%s: Failed to read button data registers.\n", __func__);
+		return;
+	}
+
+	/* Generate events for buttons that change state. */
+	for (button = 0; button < instanceData->deviceInfo->buttonCount; button++) {
+		int buttonReg;
+		int buttonShift;
+		bool buttonStatus;
+
+		/* determine which data byte the button status is in */
+		buttonReg = button/4;
+		/* bit shift to get button's status */
+		buttonShift = button % 8;
+		buttonStatus = ((instanceData->buttonDataBuffer[buttonReg] >> buttonShift) & 0x01) != 0;
+
+		/* if the button state changed from the last time report it and store the new state */
+		if (buttonStatus != instanceData->buttonDown[button]) {
+			printk(KERN_DEBUG "%s: Button %d (code %d) -> %d.", __func__, button, instanceData->buttonMap[button], buttonStatus);
+			/* Generate an event here. */
+			input_report_key(function_device->input,
+				instanceData->buttonMap[button], buttonStatus);
+			instanceData->buttonDown[button] = buttonStatus;
+		}
+	}
+
+	input_sync(function_device->input); /* sync after groups of events */
+}
+EXPORT_SYMBOL(FN_19_inthandler);
+
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
+	struct f19_instance_data *instance_data = function_device->rfi->fndata;
+	struct rmi_f19_functiondata *functiondata = rmi_sensor_get_functiondata(function_device->sensor, RMI_F19_INDEX);
+
+	printk(KERN_DEBUG "%s: RMI4 F19 init\n", __func__);
+
+	if (functiondata) {
+		if (functiondata->button_map) {
+			if (functiondata->button_map->nbuttons != instance_data->deviceInfo->buttonCount) {
+				printk(KERN_WARNING "%s: Platformdata button map size (%d) != number of buttons on device (%d) - ignored.", __func__, functiondata->button_map->nbuttons, instance_data->deviceInfo->buttonCount);
+			} else if (!functiondata->button_map->map) {
+				printk(KERN_WARNING "%s: Platformdata button map is missing!", __func__);
+			} else {
+				for (i = 0; i < functiondata->button_map->nbuttons; i++)
+					instance_data->buttonMap[i] = functiondata->button_map->map[i];
+			}
+		}
+	}
+
+	/* Set up any input events. */
+	set_bit(EV_SYN, function_device->input->evbit);
+	set_bit(EV_KEY, function_device->input->evbit);
+	/* set bits for each button...*/
+	for (i = 0; i < instance_data->deviceInfo->buttonCount; i++) {
+		set_bit(instance_data->buttonMap[i], function_device->input->keybit);
+	}
+
+	printk(KERN_DEBUG "%s: Creating sysfs files.", __func__);
+	retval = device_create_file(&function_device->dev, &dev_attr_buttonCount);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create button count.", __func__);
+		return retval;
+	}
+
+	retval = device_create_file(&function_device->dev, &dev_attr_buttonMap);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create button map.", __func__);
+		return retval;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_19_init);
+
+int getControlRegisters(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr)
+{
+	struct f19_instance_data *instanceData;
+	unsigned char *fn19Control = NULL;
+	int retval = 0;
+
+	/* Get the instance data - it should have been allocated and stored in detect.*/
+	instanceData = rmifninfo->fndata;
+
+	/* Check to make sure instanceData is really there before using.*/
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error - instance data not initialized yet when getting  fn19 control registers.\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Allocate memory for the control registers. */
+	instanceData->controlRegisters = kzalloc(sizeof(struct rmi_F19_control), GFP_KERNEL);
+	if (!instanceData->controlRegisters) {
+		printk(KERN_ERR "%s: Error allocating F19 control registers.\n", __func__);
+		return -ENOMEM;
+	}
+
+	instanceData->fn19regCountForBitPerButton = (instanceData->deviceInfo->buttonCount + 7)/8;
+
+	/* Need to compute the amount of data to read since it varies with the
+	 * number of buttons */
+	instanceData->fn19ControlRegisterSize = 1  /* 1 for filter mode and button usage bits */
+		+ 2*instanceData->fn19regCountForBitPerButton  /* interrupt enable bits and single button participation bits */
+		+ 2*instanceData->deviceInfo->buttonCount  /* sensormap registers + single button sensitivity registers */
+		+ 2; /* 1 for global sensitivity adjust + 1 for global hysteresis threshold */
+
+	/* Allocate a temp memory buffer to read the control registers into */
+	fn19Control = kzalloc(instanceData->fn19ControlRegisterSize, GFP_KERNEL);
+	if (!fn19Control) {
+		printk(KERN_ERR "%s: Error allocating temp storage to read fn19 control info.\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* Grab a copy of the control registers. */
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->controlBaseAddr,
+		fn19Control, instanceData->fn19ControlRegisterSize);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to read F19 control registers.", __func__);
+		return retval;
+	}
+
+	/* Copy over control registers data to the instance data */
+	instanceData->fn19btnUsageandfilterModeOffset = 0;
+	instanceData->controlRegisters->buttonUsage = fn19Control[instanceData->fn19btnUsageandfilterModeOffset] & 0x3;
+	instanceData->controlRegisters->filterMode = fn19Control[instanceData->fn19btnUsageandfilterModeOffset] & 0xc;
+
+	/* Fill in interrupt enable registers */
+	instanceData->fn19intEnableOffset = 1;
+	instanceData->fn19intEnableLen = instanceData->fn19regCountForBitPerButton;
+	instanceData->controlRegisters->intEnableRegisters = kzalloc(instanceData->fn19intEnableLen, GFP_KERNEL);
+	if (!instanceData->controlRegisters->intEnableRegisters) {
+		printk(KERN_ERR "%s: Error allocating storage for interrupt enable control info.\n", __func__);
+		return -ENOMEM;
+	}
+	memcpy(instanceData->controlRegisters->intEnableRegisters, &fn19Control[instanceData->fn19intEnableOffset],
+		instanceData->fn19intEnableLen);
+
+	/* Fill in single button control registers */
+	instanceData->fn19singleBtnCtrlOffset = instanceData->fn19intEnableOffset + instanceData->fn19intEnableLen;
+	instanceData->fn19singleBtnCtrlLen = instanceData->fn19regCountForBitPerButton;
+	instanceData->controlRegisters->singleButtonControl = kzalloc(instanceData->fn19singleBtnCtrlLen, GFP_KERNEL);
+	if (!instanceData->controlRegisters->singleButtonControl) {
+		printk(KERN_ERR "%s: Error allocating storage for single button participation control info.\n", __func__);
+		return -ENOMEM;
+	}
+	memcpy(instanceData->controlRegisters->singleButtonControl, &fn19Control[instanceData->fn19singleBtnCtrlOffset],
+		instanceData->fn19singleBtnCtrlLen);
+
+	/* Fill in sensor map registers */
+	instanceData->fn19sensorMapCtrlOffset = instanceData->fn19singleBtnCtrlOffset + instanceData->fn19singleBtnCtrlLen;
+	instanceData->fn19sensorMapCtrlLen = instanceData->deviceInfo->buttonCount;
+	instanceData->controlRegisters->sensorMap = kzalloc(instanceData->fn19sensorMapCtrlLen, GFP_KERNEL);
+	if (!instanceData->controlRegisters->sensorMap) {
+		printk(KERN_ERR "%s: Error allocating storage for sensor map control info.\n", __func__);
+		return -ENOMEM;
+	}
+	memcpy(instanceData->controlRegisters->sensorMap, &fn19Control[instanceData->fn19sensorMapCtrlOffset],
+		instanceData->fn19sensorMapCtrlLen);
+
+	/* Fill in single button sensitivity registers */
+	instanceData->fn19singleBtnSensOffset = instanceData->fn19sensorMapCtrlOffset + instanceData->fn19sensorMapCtrlLen;
+	instanceData->fn19singleBtnSensLen = instanceData->deviceInfo->buttonCount;
+	instanceData->controlRegisters->singleButtonSensitivity = kzalloc(instanceData->fn19singleBtnSensLen, GFP_KERNEL);
+	if (!instanceData->controlRegisters->intEnableRegisters) {
+		printk(KERN_ERR "%s: Error allocating storage for single button sensitivity control info.\n", __func__);
+		return -ENOMEM;
+	}
+	memcpy(instanceData->controlRegisters->singleButtonSensitivity, &fn19Control[instanceData->fn19singleBtnSensOffset],
+		instanceData->fn19singleBtnSensLen);
+
+	/* Fill in global sensitivity adjustment and global hysteresis threshold values */
+	instanceData->fn19globalSensOffset = instanceData->fn19singleBtnSensOffset + instanceData->fn19singleBtnSensLen;
+	instanceData->fn19globalHystThreshOffset = instanceData->fn19globalSensOffset + 1;
+	instanceData->controlRegisters->globalSensitivityAdjustment = fn19Control[instanceData->fn19globalSensOffset] & 0x1f;
+	instanceData->controlRegisters->globalHysteresisThreshold = fn19Control[instanceData->fn19globalHystThreshOffset] & 0x0f;
+
+	/* Free up temp storage that held copy of control registers */
+	kfree(fn19Control);
+
+	return 0;
+}
+
+int FN_19_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	unsigned char fn19queries[2];
+	int fn19ControlRegisterSize;
+	unsigned char *fn19Control = NULL;
+	int retval = 0;
+	int i;
+	struct f19_instance_data *instanceData;
+	int fn19InterruptOffset;
+
+	printk(KERN_DEBUG "%s: RMI4 F19 detect\n", __func__);
+
+	instanceData = kzalloc(sizeof(struct f19_instance_data), GFP_KERNEL);
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error allocating F19 instance data.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->deviceInfo = kzalloc(sizeof(struct rmi_F19_query), GFP_KERNEL);
+	if (!instanceData->deviceInfo) {
+		printk(KERN_ERR "%s: Error allocating F19 device query.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = instanceData;
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* need to get number of fingers supported, data size, etc. -
+	to be used when getting data since the number of registers to
+	read depends on the number of fingers supported and data size. */
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->queryBaseAddr, fn19queries,
+			sizeof(fn19queries));
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 F19 detect: "
+			"Could not read function query registers 0x%x\n",
+			__func__,  rmifninfo->funcDescriptor.queryBaseAddr);
+		return retval;
+	}
+
+	/* Extract device data. */
+	instanceData->deviceInfo->configurable = fn19queries[0] & 0x01;
+	instanceData->deviceInfo->hasSensitivityAdjust = fn19queries[0] & 0x02;
+	instanceData->deviceInfo->hasHysteresisThreshold = fn19queries[0] & 0x04;
+	instanceData->deviceInfo->buttonCount = fn19queries[1] & 0x01F;
+	printk(KERN_DEBUG "%s: F19 device - %d buttons...", __func__, instanceData->deviceInfo->buttonCount);
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source in fn $11 and or in a bit
+	to the interrupt mask for each. */
+	fn19InterruptOffset = interruptCount % 8;
+
+	for (i = fn19InterruptOffset;
+			i < ((fndescr->interruptSrcCnt & 0x7) + fn19InterruptOffset);
+			i++)
+		rmifninfo->interruptMask |= 1 << i;
+
+	/* Figure out just how much data we'll need to read. */
+	instanceData->buttonDown = kcalloc(instanceData->deviceInfo->buttonCount, sizeof(bool), GFP_KERNEL);
+	if (!instanceData->buttonDown) {
+		printk(KERN_ERR "%s: Error allocating F19 button state buffer.\n", __func__);
+		return -ENOMEM;
+	}
+
+	instanceData->buttonDataBufferSize = (instanceData->deviceInfo->buttonCount + 7) / 8;
+	instanceData->buttonDataBuffer = kcalloc(instanceData->buttonDataBufferSize, sizeof(unsigned char), GFP_KERNEL);
+	if (!instanceData->buttonDataBuffer) {
+		printk(KERN_ERR "%s: Failed to allocate button data buffer.", __func__);
+		return -ENOMEM;
+	}
+
+	instanceData->buttonMap = kcalloc(instanceData->deviceInfo->buttonCount, sizeof(unsigned char),  GFP_KERNEL);
+	if (!instanceData->buttonMap) {
+		printk(KERN_ERR "%s: Error allocating F19 button map.\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < instanceData->deviceInfo->buttonCount; i++)
+		instanceData->buttonMap[i] = BTN_0 + i; /* default values */
+
+	/* Grab the control register info. */
+	retval = getControlRegisters(rmifninfo, fndescr);
+	if (retval) {
+		printk(KERN_ERR "%s: Error %d getting fn19 control register info.\n", __func__, retval);
+		return retval;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_19_detect);
+
+static ssize_t rmi_f19_buttonCount_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = (struct f19_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", instance_data->deviceInfo->buttonCount);
+}
+
+static ssize_t rmi_f19_buttonCount_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	/* Not allowed. */
+	return -EPERM;
+}
+
+static ssize_t rmi_f19_buttonMap_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = (struct f19_instance_data *)fn->rfi->fndata;
+	int i, len, totalLen = 0;
+
+	/* loop through each button map value and copy it's string representation into buf */
+	for (i = 0; i < instance_data->deviceInfo->buttonCount; i++) {
+		/* get next button mapping value and write it to buf */
+		len = sprintf(buf, "%u ", instance_data->buttonMap[i]);
+		/* bump up ptr to next location in buf if the sprintf was valid */
+		if (len > 0) {
+			buf += len;
+			totalLen += len;
+		}
+	}
+
+	return totalLen;
+}
+
+static ssize_t rmi_f19_buttonMap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f19_instance_data *instance_data = (struct f19_instance_data *)fn->rfi->fndata;
+	unsigned int button;
+	int i;
+	int retval = count;
+	int buttonCount = 0;
+	unsigned char *tmpButtonMap;
+
+	/* Do validation on the button map data passed in. */
+	/* Store button mappings into a temp buffer and then verify button count
+	and data prior to clearing out old button mappings and storing the new ones. */
+	tmpButtonMap = kzalloc(instance_data->deviceInfo->buttonCount, GFP_KERNEL);
+	if (!tmpButtonMap) {
+		printk(KERN_ERR "%s: Error allocating temp button map.\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < instance_data->deviceInfo->buttonCount && *buf != 0; i++) {
+		/* get next button mapping value and store and bump up to point to next item in buf */
+		sscanf(buf, "%u", &button);
+
+		/* Make sure the key is a valid key */
+		if (button > KEY_MAX) {
+			printk(KERN_ERR "%s: Error - button map for button %d is not a valid value 0x%x.\n",
+				__func__, i, button);
+			retval = -EINVAL;
+			goto err_ret;
+		}
+
+		tmpButtonMap[i] = button;
+		buttonCount++;
+
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf-1) == ' ')
+				break;
+		}
+	}
+
+	/* Make sure the button count matches */
+	if (buttonCount != instance_data->deviceInfo->buttonCount) {
+		printk(KERN_ERR "%s: Error - button map count of %d doesn't match device button count of %d.\n"
+			 , __func__, buttonCount, instance_data->deviceInfo->buttonCount);
+		retval = -EINVAL;
+		goto err_ret;
+	}
+
+	/* Clear out old buttonMap data */
+	memset(instance_data->buttonMap, 0, buttonCount);
+
+	/* Loop through the temp buffer and copy the button event and set the key bit for the new mapping. */
+	for (i = 0; i < buttonCount; i++) {
+		instance_data->buttonMap[i] = tmpButtonMap[1];
+		set_bit(instance_data->buttonMap[i], fn->input->keybit);
+	}
+
+err_ret:
+	kfree(tmpButtonMap);
+
+	return retval;
+}
diff --git a/drivers/input/touchscreen/rmi_f19.h b/drivers/input/touchscreen/rmi_f19.h
new file mode 100644
index 0000000..41f3e4d
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f19.h
@@ -0,0 +1,43 @@
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
+#ifndef _RMI_FUNCTION_19_H
+#define _RMI_FUNCTION_19_H
+
+void FN_19_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_19_config(struct rmi_function_info *rmifninfo);
+int FN_19_init(struct rmi_function_device *function_device);
+int FN_19_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+/* No attention function for Fn $19 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f34.c b/drivers/input/touchscreen/rmi_f34.c
new file mode 100644
index 0000000..47ae5eb
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f34.c
@@ -0,0 +1,552 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $34 support for sensor
+ * firmware reflashing.
+ *
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
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/sysfs.h>
+#include <linux/math64.h>
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f34.h"
+
+/* data specific to fn $34 that needs to be kept around */
+struct rmi_fn_34_data {
+	unsigned char   status;
+	unsigned char   cmd;
+	unsigned short  bootloaderid;
+	unsigned short  blocksize;
+};
+
+
+static ssize_t rmi_fn_34_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+
+static ssize_t rmi_fn_34_cmd_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_cmd_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+static ssize_t rmi_fn_34_data_read(struct kobject *kobj,
+				struct bin_attribute *attributes,
+				char *buf, loff_t pos, size_t count);
+
+static ssize_t rmi_fn_34_data_write(struct kobject *kobj,
+				struct bin_attribute *attributes,
+				char *buf, loff_t pos, size_t count);
+
+static ssize_t rmi_fn_34_bootloaderid_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_bootloaderid_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+static ssize_t rmi_fn_34_blocksize_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_blocksize_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+/* define the device attributes using DEVICE_ATTR macros */
+DEVICE_ATTR(status, 0444, rmi_fn_34_status_show, rmi_fn_34_status_store);  /* RO attr */
+DEVICE_ATTR(cmd, 0664, rmi_fn_34_cmd_show, rmi_fn_34_cmd_store);     /* RW attr */
+DEVICE_ATTR(bootloaderid, 0644, rmi_fn_34_bootloaderid_show, rmi_fn_34_bootloaderid_store); /* RW attr */
+DEVICE_ATTR(blocksize, 0444, rmi_fn_34_blocksize_show, rmi_fn_34_blocksize_store);    /* RO attr */
+
+
+struct bin_attribute dev_attr_data = {
+	.attr = {
+		.name = "data",
+		.mode = 0644
+	},
+	.size = 0,
+	.read = rmi_fn_34_data_read,
+	.write = rmi_fn_34_data_write,
+};
+
+/* Helper fn to convert from processor specific data to our firmware specific endianness.
+ * TODO: Should we use ntohs or something like that?
+ */
+void copyEndianAgnostic(unsigned char *dest, unsigned short src)
+{
+	dest[0] = src%0x100;
+	dest[1] = src/0x100;
+}
+
+/*.
+ * The interrupt handler for Fn $34.
+ */
+void FN_34_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	unsigned int status;
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)rmifninfo->fndata;
+
+	/* Read the Fn $34 status register to see whether the previous command executed OK */
+	/* inform user space - through a sysfs param. */
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr+3,
+		(unsigned char *)&status, 1)) {
+		printk(KERN_ERR "%s : Could not read status from 0x%x\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr+3);
+		status = 0xff; /* failure */
+	}
+
+	/* set a sysfs value that the user mode can read - only upper 4 bits are the status */
+	fn34data->status = status & 0xf0; /* successful is $80, anything else is failure */
+}
+EXPORT_SYMBOL(FN_34_inthandler);
+
+void FN_34_attention(struct rmi_function_info *rmifninfo)
+{
+
+}
+EXPORT_SYMBOL(FN_34_attention);
+
+int FN_34_config(struct rmi_function_info *rmifninfo)
+{
+	pr_debug("%s: RMI4 function $34 config\n", __func__);
+	return 0;
+}
+EXPORT_SYMBOL(FN_34_config);
+
+
+int FN_34_init(struct rmi_function_device *function_device)
+{
+	int retval = 0;
+	unsigned char uData[2];
+	struct rmi_function_info *rmifninfo = function_device->rfi;
+	struct rmi_fn_34_data *fn34data;
+
+	pr_debug("%s: RMI4 function $34 init\n", __func__);
+
+	/* Here we will need to set up sysfs files for Bootloader ID and Block size */
+	fn34data = kzalloc(sizeof(struct rmi_fn_34_data), GFP_KERNEL);
+	if (!fn34data) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_fn_34_data.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = (void *)fn34data;
+
+	/* set up sysfs file for Bootloader ID. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_bootloaderid.attr) < 0) {
+		printk(KERN_ERR "%s: Failed to create sysfs file for fn 34 bootloaderid.\n", __func__);
+		return -ENODEV;
+	}
+
+	/* set up sysfs file for Block Size. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_blocksize.attr) < 0) {
+		printk(KERN_ERR "%s: Failed to create sysfs file for fn 34 blocksize.\n", __func__);
+		return -ENODEV;
+	}
+
+	/* get the Bootloader ID and Block Size and store in the sysfs attributes. */
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr,
+		uData, 2);
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read bootloaderid from 0x%x\n",
+			__func__, function_device->function->functionQueryBaseAddr);
+		return retval;
+	}
+	/* need to convert from our firmware storage to processore specific data */
+	fn34data->bootloaderid = (unsigned int)uData[0] + (unsigned int)uData[1]*0x100;
+
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr+3,
+		uData, 2);
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read block size from 0x%x\n",
+			__func__, rmifninfo->funcDescriptor.queryBaseAddr+3);
+		return retval;
+	}
+	/* need to convert from our firmware storage to processor specific data */
+	fn34data->blocksize = (unsigned int)uData[0] + (unsigned int)uData[1]*0x100;
+
+	/* set up sysfs file for status. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_status.attr) < 0) {
+		printk(KERN_ERR "%s: Failed to create sysfs file for fn 34 status.\n", __func__);
+		return -ENODEV;
+	}
+
+	/* Also, sysfs will need to have a file set up to distinguish between commands - like
+	Config write/read, Image write/verify.*/
+	/* set up sysfs file for command code. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_cmd.attr) < 0) {
+		printk(KERN_ERR "%s: Failed to create sysfs file for fn 34 cmd.\n", __func__);
+		return -ENODEV;
+	}
+
+	/* We will also need a sysfs file for the image/config block to write or read.*/
+	/* set up sysfs bin file for binary data block. Since the image is already in our format
+	there is no need to convert the data for endianess. */
+	if (sysfs_create_bin_file(&function_device->dev.kobj, &dev_attr_data) < 0) {
+		printk(KERN_ERR "%s: Failed to create sysfs file for fn 34 data.\n", __func__);
+		return -ENODEV;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_34_init);
+
+int FN_34_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	int i;
+	int InterruptOffset;
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $34 detect\n", __func__);
+	if (rmifninfo->sensor == NULL) {
+		printk(KERN_ERR "%s: NULL sensor passed in!", __func__);
+		return -EINVAL;
+	}
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source and or in a bit
+	to the interrupt mask for each. */
+	InterruptOffset = interruptCount % 8;
+
+	for (i = InterruptOffset;
+		i < ((fndescr->interruptSrcCnt & 0x7) + InterruptOffset);
+		i++) {
+			rmifninfo->interruptMask |= 1 << i;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_34_detect);
+
+static ssize_t rmi_fn_34_bootloaderid_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->bootloaderid);
+}
+
+static ssize_t rmi_fn_34_bootloaderid_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int error;
+	unsigned long val;
+	unsigned char uData[2];
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	/* need to convert the string data to an actual value */
+	error = strict_strtoul(buf, 10, &val);
+
+	if (error)
+		return error;
+
+	fn34data->bootloaderid = val;
+
+	/* Write the Bootloader ID key data back to the first two Block Data registers
+	(F34_Flash_Data2.0 and F34_Flash_Data2.1).*/
+	copyEndianAgnostic(uData, (unsigned short)val);
+	error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr,
+		uData, 2);
+	if (error) {
+		printk(KERN_ERR "%s : Could not write bootloader id to 0x%x\n",
+			__func__, fn->function->functionDataBaseAddr);
+		return error;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_blocksize_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->blocksize);
+}
+
+static ssize_t rmi_fn_34_blocksize_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	/* Block Size is RO so we shouldn't do anything if the
+	user space writes to the sysfs file. */
+
+	return -EPERM;
+}
+
+static ssize_t rmi_fn_34_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->status);
+}
+
+static ssize_t rmi_fn_34_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	/* Status is RO so we shouldn't do anything if the user
+	app writes to the sysfs file. */
+	return -EPERM;
+}
+
+static ssize_t rmi_fn_34_cmd_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->cmd);
+}
+
+static ssize_t rmi_fn_34_cmd_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+	unsigned long val;
+	unsigned char cmd;
+	int error;
+
+	/* need to convert the string data to an actual value */
+	error = strict_strtoul(buf, 10, &val);
+
+	if (error)
+		return error;
+
+	fn34data->cmd = val;
+
+	/* determine the proper command to issue.
+	*/
+	switch (val) {
+	case ENABLE_FLASH_PROG:
+		/* Issue a Flash Program Enable ($0F) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x0F;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Flash Program Enable cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case ERASE_ALL:
+		/* Issue a Erase All ($03) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x03;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Erase All cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case ERASE_CONFIG:
+		/* Issue a Erase Configuration ($07) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x07;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Erase Configuration cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case WRITE_FW_BLOCK:
+		/* Issue a Write Firmware Block ($02) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x02;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Write Firmware Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+		return error;
+		}
+		break;
+
+	case WRITE_CONFIG_BLOCK:
+		/* Issue a Write Config Block ($06) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x06;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Write Config Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case READ_CONFIG_BLOCK:
+		/* Issue a Read Config Block ($05) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x05;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Read Config Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case DISABLE_FLASH_PROG:
+		/* Issue a reset command ($01) - this will reboot the sensor and ATTN will now go to
+		the Fn $01 instead of the Fn $34 since the sensor will no longer be in Flash mode. */
+		cmd = 0x01;
+		/*if ((error = rmi_write_multiple(fn->sensor, fn->sensor->sensorCommandBaseAddr,
+			(unsigned char *)&cmd, 1))) {
+			printk(KERN_ERR "%s : Could not write Reset cmd to 0x%x\n",
+				__func__, fn->sensor->sensorCommandBaseAddr);
+		return error;
+		}*/
+		break;
+
+	default:
+		pr_debug("%s: RMI4 function $34 - unknown command.\n", __func__);
+		break;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_data_read(struct kobject *kobj,
+				struct bin_attribute *attributes,
+				char *buf, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	int error;
+
+	/* TODO: add check for count to verify it's the correct blocksize */
+
+	/* read the data from flash into buf. */
+	/* the app layer will be blocked at reading from the sysfs file. */
+	/* when we return the count (or error if we fail) the app will resume. */
+	error = rmi_read_multiple(fn->sensor, fn->function->functionDataBaseAddr+pos,
+		(unsigned char *)buf, count);
+	if (error) {
+		printk(KERN_ERR "%s : Could not read data from 0x%llx\n",
+			__func__, fn->function->functionDataBaseAddr+pos);
+		return error;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_data_write(struct kobject *kobj,
+				struct bin_attribute *attributes,
+				char *buf, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+	unsigned int blocknum;
+	int error;
+
+	/* write the data from buf to flash. */
+	/* the app layer will be blocked at writing to the sysfs file. */
+	/* when we return the count (or error if we fail) the app will resume. */
+
+	/* TODO: Add check on count - if non-zero veriy it's the correct blocksize */
+
+	/* Verify that the byte offset is always aligned on a block boundary and if not
+	return an error.  We can't just use the mod operator % and do a (pos % fn34data->blocksize) because of a gcc
+	bug that results in undefined symbols.  So we have to compute it the hard
+	way.  Grumble. */
+	unsigned int remainder;
+	div_u64_rem(pos, fn34data->blocksize, &remainder);
+	if (remainder) {
+		printk(KERN_ERR "%s : Invalid byte offset of %llx leads to invalid block number.\n",
+			__func__, pos);
+		return -EINVAL;
+	}
+
+	/* Compute the block number using the byte offset (pos) and the block size.
+	once again, we can't just do a divide due to a gcc bug. */
+	blocknum = div_u64(pos, fn34data->blocksize);
+
+	/* Write the block number first */
+	error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr,
+		(unsigned char *)&blocknum, 2);
+	if (error) {
+		printk(KERN_ERR "%s : Could not write block number to 0x%x\n",
+			__func__, fn->function->functionDataBaseAddr);
+		return error;
+	}
+
+	/* Write the data block - only if the count is non-zero  */
+	if (count) {
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+2,
+			(unsigned char *)buf, count);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write block data to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+2);
+			return error;
+		}
+	}
+
+	return count;
+}
diff --git a/drivers/input/touchscreen/rmi_f34.h b/drivers/input/touchscreen/rmi_f34.h
new file mode 100644
index 0000000..48293e3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f34.h
@@ -0,0 +1,50 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $34 header.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ * There is only one function $34 for each RMI4 sensor. This will be
+ * the function that is used to reflash the firmware and get the
+ * boot loader address and the boot image block size.
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
+#ifndef _RMI_FUNCTION_34_H
+#define _RMI_FUNCTION_34_H
+
+/* define fn $34 commands */
+#define WRITE_FW_BLOCK            2
+#define ERASE_ALL                 3
+#define READ_CONFIG_BLOCK         5
+#define WRITE_CONFIG_BLOCK        6
+#define ERASE_CONFIG              7
+#define ENABLE_FLASH_PROG         15
+#define DISABLE_FLASH_PROG        16
+
+void FN_34_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_34_config(struct rmi_function_info *rmifninfo);
+int FN_34_init(struct rmi_function_device *function_device);
+int FN_34_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+void FN_34_attention(struct rmi_function_info *rmifninfo);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_function.c b/drivers/input/touchscreen/rmi_function.c
new file mode 100644
index 0000000..f9b9833
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function.c
@@ -0,0 +1,320 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Function Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+static const char functionname[10] = "fn";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+#include "rmi_drvr.h"
+#include "rmi_function.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_f01.h"
+#include "rmi_f11.h"
+#include "rmi_f19.h"
+#include "rmi_f34.h"
+
+/* Each time a new RMI4 function support is added the developer needs to
+bump the number of supported functions and add the info for
+that RMI4 function to the array along with pointers to the report,
+config, init and detect functions that they coded in rmi_fxx.c
+and rmi_fxx.h - where xx is the RMI4 function number in hex for the new
+RMI4 data source function. The information for the RMI4 functions is
+obtained from the RMI4 specification document.
+ */
+#define rmi4_num_supported_data_src_fns 4
+
+/* supported RMI4 functions list - controls what we
+ * will provide support for - if it's not in the list then
+ * the developer needs to add support functions for it.*/
+static LIST_HEAD(fns_list);
+static DEFINE_MUTEX(fns_mutex);
+
+/* NOTE: Developer - add in any new RMI4 fn data info - function number
+ * and ptrs to report, config, init and detect functions.  This data is
+ * used to point to the functions that need to be called to config, init,
+ * detect and report data for the new RMI4 function. Refer to the RMI4
+ * specification for information on RMI4 functions.
+ */
+/* TODO: This will eventually go away, and each function will be an independent
+ * module. */
+static struct rmi_functions_data
+	rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] = {
+	/* Fn $11 - 2D sensing */
+	{.functionNumber = 0x11, .inthandlerFn = FN_11_inthandler, .configFn = FN_11_config, .initFn = FN_11_init, .detectFn = FN_11_detect, .attnFn = NULL},
+	/* Fn $01 - device control */
+	{.functionNumber = 0x01, .inthandlerFn = FN_01_inthandler, .configFn = FN_01_config, .initFn = FN_01_init, .detectFn = FN_01_detect, .attnFn = FN_01_attention},
+	/* Fn $19 - buttons */
+	{.functionNumber = 0x19, .inthandlerFn = FN_19_inthandler, .configFn = FN_19_config, .initFn = FN_19_init, .detectFn = FN_19_detect, .attnFn = NULL},
+	/* Fn $34 - firmware reflash */
+	{.functionNumber = 0x34, .inthandlerFn = FN_34_inthandler, .configFn = FN_34_config, .initFn = FN_34_init, .detectFn = FN_34_detect, .attnFn = FN_34_attention},
+};
+
+
+/* This function is here to provide a way for external modules to access the
+ * functions list.  It will try to find a matching function base on the passed
+ * in RMI4 function number and return  the pointer to the struct rmi_functions
+ * if a match is found or NULL if not found.
+ */
+struct rmi_functions *rmi_find_function(int functionNum)
+{
+	struct rmi_functions *fn;
+	bool found = false;
+
+	list_for_each_entry(fn, &fns_list, link) {
+		if (functionNum == fn->functionNum) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return NULL;
+	else
+		return fn;
+}
+EXPORT_SYMBOL(rmi_find_function);
+
+
+static void rmi_function_config(struct rmi_function_device *function)
+{
+	printk(KERN_DEBUG "%s: rmi_function_config", __func__);
+
+}
+
+/**
+ * This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 function.
+ */
+static int rmi_function_probe(struct rmi_function_driver *function)
+{
+	struct rmi_phys_driver *rpd;
+
+	rpd = function->rpd;
+
+	if (!rpd) {
+		printk(KERN_ERR "%s: Invalid rmi physical driver - null ptr.", __func__);
+		return 0;
+	}
+
+	return 1;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_function_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: function suspend called.", __func__);
+	return 0;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_function_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: function resume called.", __func__);
+	return 0;
+}
+
+int rmi_function_register_driver(struct rmi_function_driver *drv, int fnNumber)
+{
+	int retval;
+	char *drvrname;
+
+	printk(KERN_INFO "%s: Registering function driver for F%02x.\n", __func__, fnNumber);
+
+	retval = 0;
+
+	/* Create a function device and function driver for this Fn */
+	drvrname = kzalloc(sizeof(functionname) + 4, GFP_KERNEL);
+	if (!drvrname) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_function_driver name.\n", __func__);
+		return -ENOMEM;
+	}
+	sprintf(drvrname, "fn%02x", fnNumber);
+
+	drv->drv.name = drvrname;
+	drv->module = drv->drv.owner;
+
+	drv->drv.suspend = rmi_function_suspend;
+	drv->drv.resume = rmi_function_resume;
+
+	/* register the sensor driver */
+	retval = driver_register(&drv->drv);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed driver_register %d\n",
+			__func__, retval);
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(rmi_function_register_driver);
+
+void rmi_function_unregister_driver(struct rmi_function_driver *drv)
+{
+	printk(KERN_INFO "%s: Unregistering function driver.\n", __func__);
+
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL(rmi_function_unregister_driver);
+
+int rmi_function_register_device(struct rmi_function_device *function_device, int fnNumber)
+{
+	struct input_dev *input;
+	int retval;
+
+	printk(KERN_INFO "%s: Registering function device for F%02x.\n", __func__, fnNumber);
+
+	retval = 0;
+
+	/* make name - fn11, fn19, etc. */
+	dev_set_name(&function_device->dev, "%sfn%02x", function_device->sensor->drv.name, fnNumber);
+	dev_set_drvdata(&function_device->dev, function_device);
+	retval = device_register(&function_device->dev);
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed device_register for function device.\n",
+			__func__);
+		return retval;
+	}
+
+	input = input_allocate_device();
+	if (input == NULL) {
+		printk(KERN_ERR "%s:  Failed to allocate memory for a "
+			"new input device.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	input->name = dev_name(&function_device->dev);
+	input->phys = "rmi_function";
+	function_device->input = input;
+
+
+	/* init any input specific params for this function */
+	function_device->rmi_funcs->init(function_device);
+
+	retval = input_register_device(input);
+
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed input_register_device.\n",
+			__func__);
+		return retval;
+	}
+
+
+	rmi_function_config(function_device);
+
+	return retval;
+}
+EXPORT_SYMBOL(rmi_function_register_device);
+
+void rmi_function_unregister_device(struct rmi_function_device *dev)
+{
+	printk(KERN_INFO "%s: Unregistering function device.n", __func__);
+
+	input_unregister_device(dev->input);
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL(rmi_function_unregister_device);
+
+static int __init rmi_function_init(void)
+{
+	struct rmi_functions_data *rmi4_fn;
+	int i;
+
+	printk(KERN_DEBUG "%s: RMI Function Init\n", __func__);
+
+	/* Initialize global list of RMI4 Functions.
+	We need to add the supported RMI4 funcions so that we will have
+	pointers to the associated functions for init, config, report and
+	detect. See rmi.h for more details. The developer will add a new
+	RMI4 function number in the array in rmi_drvr.h, then add a new file to
+	the build (called rmi_fXX.c where XX is the hex number for
+	the added RMI4 function). The rest should be automatic.
+	*/
+
+	/* for each function number defined in rmi.h creat a new rmi_function
+	struct and initialize the pointers to the servicing functions and then
+	add it into the global list for function support.
+	*/
+	for (i = 0; i < rmi4_num_supported_data_src_fns; i++) {
+		/* Add new rmi4 function struct to list */
+		struct rmi_functions *fn = kzalloc(sizeof(*fn), GFP_KERNEL);
+		if (!fn) {
+			printk(KERN_ERR "%s: could not allocate memory "
+				"for rmi_function struct for function 0x%x\n",
+				__func__,
+				rmi4_supported_data_src_functions[i].functionNumber);
+			return -ENOMEM;
+		} else {
+
+			rmi4_fn = &rmi4_supported_data_src_functions[i];
+			fn->functionNum = rmi4_fn->functionNumber;
+			/* Fill in ptrs to functions. The functions are
+			linked in from a file called rmi_fxx.c
+			where xx is the hex number of the RMI4 function
+			from the RMI4 spec. Also, the function prototypes
+			need to be added to rmi_fxx.h - also where
+			xx is the hex number of the RMI4 function.  So
+			that you don't get compile errors and that new
+			header needs to be included in the rmi_function.h
+			*/
+			fn->inthandler = rmi4_fn->inthandlerFn;
+			fn->config = rmi4_fn->configFn;
+			fn->init =   rmi4_fn->initFn;
+			fn->detect = rmi4_fn->detectFn;
+			fn->attention = rmi4_fn->attnFn;
+
+			/* Add the new fn to the global list */
+			mutex_lock(&fns_mutex);
+			list_add_tail(&fn->link, &fns_list);
+			mutex_unlock(&fns_mutex);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit rmi_function_exit(void)
+{
+	printk(KERN_DEBUG "%s: RMI Function Exit\n", __func__);
+}
+
+
+module_init(rmi_function_init);
+module_exit(rmi_function_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Function Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_function.h b/drivers/input/touchscreen/rmi_function.h
new file mode 100644
index 0000000..801609b
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function.h
@@ -0,0 +1,213 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function Device Header File.
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
+#ifndef _RMI_FUNCTION_H
+#define _RMI_FUNCTION_H
+
+#include <linux/input.h>
+#include <linux/device.h>
+
+
+/* For each function present on the RMI device, there will be a corresponding
+ * entry in the functions list of the rmi_sensor_driver structure.  This entry
+ * gives information about the number of data sources and the number of data
+ * registers associated with the function.
+ */
+struct rmi_function_info {
+	/* The sensor this function belongs to.
+	*/
+	struct rmi_sensor_driver *sensor;
+
+	/* A device associated with this function.
+	*/
+	struct rmi_function_device *function_device;
+
+	unsigned char functionNum;
+
+	/* This is the number of data sources associated with the function.*/
+	unsigned char numSources;
+
+	/* This is the number of data registers to read.*/
+	unsigned char dataRegBlockSize;
+
+	/* This is the interrupt register and mask - needed for enabling the
+	*  interrupts and for checking what source had caused the attention line
+	* interrupt.
+	*/
+	unsigned char interruptRegister;
+	unsigned char interruptMask;
+
+	/* This is the RMI function descriptor associated with this function.
+	*  It contains the Base addresses for the functions query, command,
+	*  control, and data registers.
+	*/
+	struct rmi_function_descriptor funcDescriptor;
+
+	/* pointer to data specific to a functions implementation. */
+	void *fndata;
+
+	/* A list of the function information.
+	*  This list uses the standard kernel linked list implementation.
+	*  Documentation on on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head link;
+};
+
+
+/* This struct is for creating a list of RMI4 functions that have data sources
+associated with them. This is to facilitate adding new support for other
+data sources besides 2D sensors.
+To add a new data source support, the developer will create a new file
+and add these 4 functions below with FN$## in front of the names - where
+## is the hex number for the function taken from the RMI4 specification.
+
+The function number will be associated with this and later will be used to
+match the RMI4 function to the 4 functions for that RMI4 function number.
+The user will also have to add code that adds the new rmi_functions item
+to the global list of RMI4 functions and stores the pointers to the 4
+functions in the function pointers.
+ */
+struct rmi_functions {
+	unsigned char functionNum;
+
+	/* Pointers to function specific functions for interruptHandler, config, init
+	, detect and attention. */
+	/* These ptrs. need to be filled in for every RMI4 function that has
+	data source(s) associated with it - like fn $11 (2D sensors),
+	fn $19 (buttons), etc. Each RMI4 function that has data sources
+	will be added into a list that is used to match the function
+	number against the number stored here.
+	*/
+	/* The sensor implementation will call this whenever and IRQ is
+	* dispatched that this function is interested in.
+	*/
+	void (*inthandler)(struct rmi_function_info *rfi, unsigned int assertedIRQs);
+
+	int (*config)(struct rmi_function_info *rmifninfo);
+	int (*init)(struct rmi_function_device *function_device);
+	int (*detect)(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+	/** If this is non-null, the sensor implemenation will call this
+	* whenever the ATTN line is asserted.
+	*/
+	void (*attention)(struct rmi_function_info *rmifninfo);
+
+
+	/* Standard kernel linked list implementation.
+	* Documentation on how to use it can be found at
+	* http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head link;
+};
+
+
+typedef void(*inthandlerFuncPtr)(struct rmi_function_info *rfi, unsigned int assertedIRQs);
+typedef int(*configFuncPtr)(struct rmi_function_info *rmifninfo);
+typedef int(*initFuncPtr)(struct rmi_function_device *function_device);
+typedef int(*detectFuncPtr)(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+typedef	void (*attnFuncPtr)(struct rmi_function_info *rmifninfo);
+
+struct rmi_functions_data {
+	int functionNumber;
+	inthandlerFuncPtr inthandlerFn;
+	configFuncPtr configFn;
+	initFuncPtr initFn;
+	detectFuncPtr detectFn;
+	attnFuncPtr attnFn;
+};
+
+
+struct rmi_functions *rmi_find_function(int functionNum);
+int rmi_functions_init(struct input_dev *inputdev);
+
+struct rmi_function_driver {
+	struct module *module;
+	struct device_driver drv;
+
+	/* Probe Function
+	*  This function is called to give the function driver layer an
+	*  opportunity to claim an RMI function.
+	*/
+	int (*probe)(struct rmi_function_driver *function);
+	/* Config Function
+	*  This function is called after a successful probe.  It gives the
+	*  function driver an opportunity to query and/or configure an RMI
+	*  function before data starts flowing.
+	*/
+	void (*config)(struct rmi_function_driver *function);
+
+	unsigned short functionQueryBaseAddr; /* RMI4 function control */
+	unsigned short functionControlBaseAddr;
+	unsigned short functionCommandBaseAddr;
+	unsigned short functionDataBaseAddr;
+	unsigned int interruptRegisterOffset; /* offset from start of interrupt registers */
+	unsigned int interruptMask;
+
+	/* pointer to the corresponding phys driver info for this sensor */
+	/* The phys driver has the pointers to read, write, etc. */
+	/* Probably don't need it here - used down in bus driver and sensor driver */
+	struct rmi_phys_driver *rpd;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head function_drivers; /* link function drivers into list */
+};
+
+struct rmi_function_device {
+	struct rmi_function_driver *function;
+	struct device dev;
+	struct input_dev *input;
+	struct rmi_sensor_driver *sensor; /* need this to be bound to phys driver layer */
+
+	/* the function ptrs to the config, init, detect and
+	report fns for this rmi function device. */
+	struct rmi_functions *rmi_funcs;
+	struct rmi_function_info *rfi;
+
+	/** An RMI sensor might actually have several IRQ registers -
+	* this tells us which IRQ register this function is interested in.
+	*/
+	unsigned int irqRegisterSet;
+
+	/** This is a mask of the IRQs the function is interested in.
+	*/
+	unsigned int irqMask;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head functions; /* link functions into list */
+};
+
+int rmi_function_register_device(struct rmi_function_device *dev, int fnNumber);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_sensor.c b/drivers/input/touchscreen/rmi_sensor.c
new file mode 100644
index 0000000..e834c6c
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_sensor.c
@@ -0,0 +1,587 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Sensor Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+static const char sensorname[] = "sensor";
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_function.h"
+#include "rmi_sensor.h"
+
+long polltime = 25000000;   /* Shared with rmi_function.c. */
+EXPORT_SYMBOL(polltime);
+module_param(polltime, long, 0644);
+MODULE_PARM_DESC(polltime, "How long to wait between polls (in nano seconds).");
+
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x0005
+#define PDT_ENTRY_SIZE 0x0006
+
+static DEFINE_MUTEX(rfi_mutex);
+
+struct rmi_functions *rmi_find_function(int functionNum);
+
+int rmi_read(struct rmi_sensor_driver *sensor, unsigned short address, char *dest)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->read(rpd, address, dest);
+}
+EXPORT_SYMBOL(rmi_read);
+
+int rmi_write(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char data)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->write(rpd, address, data);
+}
+EXPORT_SYMBOL(rmi_write);
+
+int rmi_read_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		char *dest, int length)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->read_multiple(rpd, address, dest, length);
+}
+EXPORT_SYMBOL(rmi_read_multiple);
+
+int rmi_write_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char *data, int length)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->write_multiple(rpd, address, data, length);
+}
+EXPORT_SYMBOL(rmi_write_multiple);
+
+bool rmi_polling_required(struct rmi_sensor_driver *sensor)
+{
+	return sensor->polling_required;
+}
+EXPORT_SYMBOL(rmi_polling_required);
+
+/** Functions can call this in order to dispatch IRQs. */
+void dispatchIRQs(struct rmi_sensor_driver *sensor, unsigned int irqStatus)
+{
+	struct rmi_function_info *functionInfo;
+
+
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		if ((functionInfo->interruptMask & irqStatus)) {
+			if (functionInfo->function_device->rmi_funcs->inthandler) {
+				/* Call the functions interrupt handler function. */
+				functionInfo->function_device->rmi_funcs->inthandler(functionInfo, (functionInfo->interruptMask & irqStatus));
+			}
+		}
+	}
+}
+
+/**
+ * This is the function we pass to the RMI4 subsystem so we can be notified
+ * when attention is required.  It may be called in interrupt context.
+ */
+static void attention(struct rmi_phys_driver *physdrvr, int instance)
+{
+	/* All we have to do is schedule work. */
+
+	/* TODO: It's possible that workIsReady is not really needed anymore.
+	 * Investigate this to see if the race condition between setting up
+	 * the work and enabling the interrupt still exists. */
+	if (physdrvr->sensor->workIsReady) {
+		schedule_work(&(physdrvr->sensor->work));
+	} else {
+		/* Got an interrupt but we're not ready so enable the irq so it doesn't get hung up */
+		printk(KERN_DEBUG "%s: Work not initialized yet - enabling irqs.\n", __func__);
+		enable_irq(physdrvr->irq);
+	}
+}
+
+/**
+ * This notifies any interested functions that there
+ * is an Attention interrupt.  The interested functions should take appropriate
+ * actions (such as reading the interrupt status register and dispatching any
+ * appropriate RMI4 interreupts).
+ */
+void attn_notify(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_function_info *functionInfo;
+
+	/* check each function that has data sources and if the interrupt for
+	* that triggered then call that RMI4 functions report() function to
+	* gather data and report it to the input subsystem */
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		if (functionInfo->function_device->rmi_funcs->attention)
+			functionInfo->function_device->rmi_funcs->attention(functionInfo);
+	}
+}
+
+/* This is the worker function - for now it simply has to call attn_notify. This work
+ * should be scheduled whenever an ATTN interrupt is asserted by the touch sensor.
+ * We then call attn_notify to dispatch notification of the ATTN interrupt to all
+ * interested functions. After all the attention handling functions
+ * have returned, it is presumed safe to re-enable the Attention interrupt.
+ */
+static void sensor_work_func(struct work_struct *work)
+{
+	struct rmi_sensor_driver *sensor = container_of(work,
+			struct rmi_sensor_driver, work);
+
+	attn_notify(sensor);
+
+	/* we only need to enable the irq if doing interrupts */
+	if (!rmi_polling_required(sensor))
+		enable_irq(sensor->rpd->irq);
+}
+
+/* This is the timer function for polling - it simply has to schedule work
+ * and restart the timer. */
+static enum hrtimer_restart sensor_poll_timer_func(struct hrtimer *timer)
+{
+	struct rmi_sensor_driver *sensor = container_of(timer,
+			struct rmi_sensor_driver, timer);
+
+	schedule_work(&sensor->work);
+	hrtimer_start(&sensor->timer, ktime_set(0, polltime), HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+/* This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 device.  In this case, we're looking for
+ * Synaptics devices that have data sources - such as touch screens, buttons,
+ * etc.
+ *
+ * TODO: Well, it used to do this.  I'm not sure it's required any more.
+ */
+static int probe(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_phys_driver *rpd;
+
+	rpd = sensor->rpd;
+
+	if (!rpd) {
+		printk(KERN_ERR "%s: Invalid rmi physical driver - null ptr: %p\n", __func__, rpd);
+		return 0;
+	}
+
+	return 1;
+}
+
+static void config(struct rmi_sensor_driver *sensor)
+{
+	/* For each data source we had detected print info and set up interrupts
+	or polling. */
+	struct rmi_function_info *functionInfo;
+	struct rmi_phys_driver *rpd;
+
+	rpd = sensor->rpd; /* get ptr to rmi_physical_driver from app */
+
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		/* Get and print some info about the data sources... */
+		struct rmi_functions *fn;
+		bool found = false;
+		/* check if function number matches - if so call that
+		config function */
+		fn = rmi_find_function(functionInfo->functionNum);
+		if (fn) {
+			found = true;
+
+			if (fn->config) {
+				fn->config(functionInfo);
+			} else {
+				/* the developer did not add in the
+				pointer to the config function into
+				rmi4_supported_data_src_functions */
+				printk(KERN_ERR
+					"%s: no config function for "
+					"function 0x%x\n",
+					__func__, functionInfo->functionNum);
+				break;
+			}
+		}
+
+		if (!found) {
+			/* if no support found for this RMI4 function
+			it means the developer did not add the
+			appropriate function pointer list into the
+			rmi4_supported_data_src_functions array and/or
+			did not bump up the number of supported RMI4
+			functions in rmi.h as required */
+			printk(KERN_ERR "%s: could not find support "
+				"for function 0x%x\n",
+				__func__, functionInfo->functionNum);
+		}
+	}
+
+	/* This will handle interrupts on the ATTN line (interrupt driven)
+	* or will be called every poll interval (when we're not interrupt
+	* driven).
+	*/
+	INIT_WORK(&sensor->work, sensor_work_func);
+	sensor->workIsReady = true;
+
+	if (rmi_polling_required(sensor)) {
+		/* We're polling driven, so set up the polling timer
+		and timer function. */
+		hrtimer_init(&sensor->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		sensor->timer.function = sensor_poll_timer_func;
+		hrtimer_start(&sensor->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+	}
+}
+
+/** Just a stub for now.
+ */
+static int rmi_sensor_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: sensor suspend called.", __func__);
+	return 0;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_sensor_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: sensor resume called.", __func__);
+	return 0;
+}
+
+/*
+ * This method is called, whenever a new sensor device is added for the rmi
+ * bus.
+ *
+ * It will scan the devices PDT to determine the supported functions
+ * and create a new function device for each of these. It will read
+ * the query, control, command and data regsiters for the function
+ * to be used for each newly created function device.
+ *
+ * The sensor device is then bound to every function it supports.
+ *
+ */
+int rmi_sensor_register_functions(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_function_device *function;
+	unsigned int interruptRegisterCount;
+	struct rmi_phys_driver *rpd;
+	int i;
+	unsigned char interruptCount;
+	struct rmi_function_info *functionInfo;
+	struct rmi_function_descriptor rmi_fd;
+	struct rmi_functions *fn;
+	bool found;
+	int retval;
+
+	pr_debug("%s: Registering sensor functions\n", __func__);
+
+	retval = 0;
+
+	/* Scan device for functions that may be supported */
+	{
+		pr_debug("%s: Scanning sensor for Functions:\n", __func__);
+
+		interruptCount = 0;
+		rpd = sensor->rpd;
+
+		/* Read the Page Descriptor Table to determine what functions
+		are present */
+		printk(KERN_DEBUG "%s: Scanning page descriptors.", __func__);
+		for (i = PDT_START_SCAN_LOCATION;
+				i >= PDT_END_SCAN_LOCATION;
+				i -= PDT_ENTRY_SIZE) {
+			printk(KERN_DEBUG "%s: Reading page descriptor 0x%02x", __func__, i);
+			retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+					sizeof(rmi_fd));
+			if (!retval) {
+				functionInfo = NULL;
+
+				if (rmi_fd.functionNum != 0x00 && rmi_fd.functionNum != 0xff) {
+					printk(KERN_DEBUG "%s: F%02x - queries %02x commands %02x control %02x data %02x ints %02x", __func__, rmi_fd.functionNum, rmi_fd.queryBaseAddr, rmi_fd.commandBaseAddr, rmi_fd.controlBaseAddr, rmi_fd.dataBaseAddr, rmi_fd.interruptSrcCnt);
+
+					/* Print a helpful message for debugging. */
+					if ((rmi_fd.functionNum & 0xff) == 0x01)
+						printk(KERN_DEBUG "%s:   Fn $01 Found - RMI Device Control\n", __func__);
+
+					/* determine if the function is supported and if so
+					then bind this function device to the sensor */
+					if (rmi_fd.interruptSrcCnt) {
+						functionInfo = kzalloc(sizeof(*functionInfo), GFP_KERNEL);
+						if (!functionInfo) {
+							printk(KERN_ERR "%s: could not allocate memory for function 0x%x\n",
+								__func__, rmi_fd.functionNum);
+							retval = -ENOMEM;
+							goto exit_fail;
+						}
+						functionInfo->sensor = sensor;
+						functionInfo->functionNum = (rmi_fd.functionNum & 0xff);
+						INIT_LIST_HEAD(&functionInfo->link);
+						/* Get the ptr to the detect function based on
+						the function number */
+						found = false;
+						printk(KERN_DEBUG "%s: Checking for RMI function F%02x.", __func__, rmi_fd.functionNum);
+						fn = rmi_find_function(rmi_fd.functionNum);
+						if (fn) {
+							found = true;
+							retval = fn->detect(functionInfo, &rmi_fd,
+								interruptCount);
+							if (retval)
+								printk(KERN_ERR "%s: Function detect for F%02x failed with %d.",
+									   __func__, rmi_fd.functionNum, retval);
+
+							/* Create a function device and function driver for this Fn */
+							function = kzalloc(sizeof(*function), GFP_KERNEL);
+							if (!function) {
+								printk(KERN_ERR "%s: Error allocating memeory for rmi_function_device\n", __func__);
+								return -ENOMEM;
+							}
+
+							function->dev.parent = &sensor->sensor_device->dev;
+							function->dev.bus = sensor->sensor_device->dev.bus;
+							function->rmi_funcs = fn;
+							function->sensor = sensor;
+							function->rfi = functionInfo;
+							functionInfo->function_device = function;
+
+							/* Check if we have an interrupt mask of 0 and a non-NULL interrupt
+							handler function and print a debug message since we should never
+							have this.
+							*/
+							if (functionInfo->interruptMask == 0 && fn->inthandler != NULL) {
+								printk(KERN_DEBUG "%s: Can't have a zero interrupt mask for function F%02x (which requires an interrupt handler).\n",
+									__func__, rmi_fd.functionNum);
+							}
+
+
+							/* Check if we have a non-zero interrupt mask and a NULL interrupt
+							handler function and print a debug message since we should never
+							have this.
+							*/
+							if (functionInfo->interruptMask != 0 && fn->inthandler == NULL) {
+								printk(KERN_DEBUG "%s: Can't have a non-zero interrupt mask %d for function F%02x with a NULL inthandler fn.\n",
+									__func__, functionInfo->interruptMask, rmi_fd.functionNum);
+							}
+
+							/* Register the rmi function device */
+							retval = rmi_function_register_device(function, rmi_fd.functionNum);
+							if (retval) {
+								printk(KERN_ERR "%s:  Failed rmi_function_register_device.\n",
+									__func__);
+								return retval;
+							}
+						}
+
+						if (!found) {
+							printk(KERN_ERR "%s: could not find support for function 0x%x\n",
+								__func__, rmi_fd.functionNum);
+						}
+					} else {
+						printk(KERN_DEBUG "%s: Found function F%02x - Ignored.\n", __func__, rmi_fd.functionNum & 0xff);
+					}
+
+					/* bump interrupt count for next iteration */
+					/* NOTE: The value 7 is reserved - for now, only bump up one for an interrupt count of 7 */
+					if ((rmi_fd.interruptSrcCnt & 0x7) == 0x7) {
+						interruptCount += 1;
+					} else {
+						interruptCount +=
+							(rmi_fd.interruptSrcCnt & 0x7);
+					}
+
+					/* link this function info to the RMI module infos list
+					of functions */
+					if (functionInfo == NULL) {
+						printk(KERN_DEBUG "%s: WTF? functionInfo is null here.", __func__);
+					} else {
+						printk(KERN_DEBUG "%s: Adding function F%02x with %d sources.\n",
+							__func__, functionInfo->functionNum, functionInfo->numSources);
+
+						mutex_lock(&rfi_mutex);
+						list_add_tail(&functionInfo->link,
+							&sensor->functions);
+						mutex_unlock(&rfi_mutex);
+					}
+
+				} else {
+					/* A zero or 0xff in the function number
+					signals the end of the PDT */
+					printk(KERN_DEBUG "%s:   Found End of PDT\n",
+						__func__);
+					break;
+				}
+			} else {
+				/* failed to read next PDT entry - end PDT
+				scan - this may result in an incomplete set
+				of recognized functions - should probably
+				return an error but the driver may still be
+				viable for diagnostics and debugging so let's
+				let it continue. */
+				printk(KERN_ERR "%s: Read Error %d when reading next PDT entry - "
+					"ending PDT scan.\n",
+					__func__, retval);
+				break;
+			}
+		}
+		printk(KERN_DEBUG "%s: Done scanning.", __func__);
+
+		/* calculate the interrupt register count - used in the
+		ISR to read the correct number of interrupt registers */
+		interruptRegisterCount = (interruptCount + 7) / 8;
+		sensor->interruptRegisterCount = interruptRegisterCount;    /* TODO: Is this needed by the sensor anymore? */
+	}
+
+	return 0;
+
+exit_fail:
+	return retval;
+}
+EXPORT_SYMBOL(rmi_sensor_register_functions);
+
+int rmi_sensor_register_device(struct rmi_sensor_device *dev, int index)
+{
+	int status;
+
+	printk(KERN_INFO "%s: Registering sensor device.\n", __func__);
+
+	/* make name - sensor00, sensor01, etc. */
+	dev_set_name(&dev->dev, "sensor%02d", index);
+	status = device_register(&dev->dev);
+
+	return status;
+}
+EXPORT_SYMBOL(rmi_sensor_register_device);
+
+static void rmi_sensor_unregister_device(struct rmi_sensor_device *rmisensordev)
+{
+	printk(KERN_INFO "%s: Unregistering sensor device.\n", __func__);
+
+	device_unregister(&rmisensordev->dev);
+}
+EXPORT_SYMBOL(rmi_sensor_unregister_device);
+
+int rmi_sensor_register_driver(struct rmi_sensor_driver *driver)
+{
+	static int index;
+	int ret;
+	char *drvrname;
+
+	driver->workIsReady = false;
+
+	printk(KERN_INFO "%s: Registering sensor driver.\n", __func__);
+	driver->dispatchIRQs = dispatchIRQs;
+	driver->attention = attention;
+	driver->config = config;
+	driver->probe = probe;
+
+	/* assign the bus type for this driver to be rmi bus */
+	driver->drv.bus = &rmi_bus_type;
+	driver->drv.suspend = rmi_sensor_suspend;
+	driver->drv.resume = rmi_sensor_resume;
+	/* Create a function device and function driver for this Fn */
+	drvrname = kzalloc(sizeof(sensorname) + 4, GFP_KERNEL);
+	if (!drvrname) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_sensor_driver name.\n", __func__);
+		return -ENOMEM;
+	}
+	sprintf(drvrname, "sensor%02d", index++);
+
+	driver->drv.name = drvrname;
+	driver->module = driver->drv.owner;
+
+	/* register the sensor driver */
+	ret = driver_register(&driver->drv);
+	if (ret) {
+		printk(KERN_ERR "%s: Failed driver_register %d\n",
+			__func__, ret);
+		goto exit_fail;
+	}
+
+	/* register the functions on the sensor */
+	ret = rmi_sensor_register_functions(driver);
+	if (ret) {
+		printk(KERN_ERR "%s: Failed rmi_sensor_register_functions %d\n",
+			__func__, ret);
+	}
+
+	/* configure the sensor - enable interrupts for each function, init work, set polling timer or adjust report rate, etc. */
+	config(driver);
+
+	printk(KERN_DEBUG "%s: sensor driver registration completed.", __func__);
+
+exit_fail:
+	return ret;
+}
+EXPORT_SYMBOL(rmi_sensor_register_driver);
+
+static void rmi_sensor_unregister_driver(struct rmi_sensor_driver *driver)
+{
+	printk(KERN_DEBUG "%s: Unregistering sensor driver.\n", __func__);
+
+	/* Stop the polling timer if doing polling */
+	if (rmi_polling_required(driver))
+		hrtimer_cancel(&driver->timer);
+
+	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
+
+	driver_unregister(&driver->drv);
+}
+EXPORT_SYMBOL(rmi_sensor_unregister_driver);
+
+
+static int __init rmi_sensor_init(void)
+{
+	printk(KERN_DEBUG "%s: RMI Sensor Init\n", __func__);
+	return 0;
+}
+
+static void __exit rmi_sensor_exit(void)
+{
+	printk(KERN_DEBUG "%s: RMI Sensor Driver Exit\n", __func__);
+	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
+}
+
+
+module_init(rmi_sensor_init);
+module_exit(rmi_sensor_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Sensor Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_sensor.h b/drivers/input/touchscreen/rmi_sensor.h
new file mode 100644
index 0000000..967e78a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_sensor.h
@@ -0,0 +1,136 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) - RMI Sensor Module Header.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+#include <linux/device.h>
+
+#ifndef _RMI_SENSOR_H
+#define _RMI_SENSOR_H
+
+#include "rmi_platformdata.h"
+
+struct rmi_sensor_driver {
+	struct module *module;
+	struct device_driver drv;
+	struct rmi_sensor_device *sensor_device;
+
+	/* Attention Function
+	*  This function is called by the low level isr in the physical
+	* driver. It merely schedules work to be done.
+	*/
+	void (*attention)(struct rmi_phys_driver *physdrvr, int instance);
+	/* Probe Function
+	*  This function is called to give the sensor driver layer an
+	*  opportunity to claim an RMI device.  The sensor layer cannot
+	*  read RMI registers at this point since the rmi physical driver
+	*  has not been bound to it yet.  Defer that to the config
+	*  function call which occurs immediately after a successful probe.
+	*/
+	int (*probe)(struct rmi_sensor_driver *sensor);
+	/* Config Function
+	*  This function is called after a successful probe.  It gives the
+	*  sensor driver an opportunity to query and/or configure an RMI
+	*  device before data starts flowing.
+	*/
+	void (*config)(struct rmi_sensor_driver *sensor);
+
+	/* Functions can call this in order to dispatch IRQs. */
+	void (*dispatchIRQs)(struct rmi_sensor_driver *sensor,
+		unsigned int irqStatus);
+
+	/* Register Functions
+	*  This function is called in the rmi bus
+	* driver to have the sensor driver scan for any supported
+	* functions on the sensor and add devices for each one.
+	*/
+	void (*rmi_sensor_register_functions)(struct rmi_sensor_driver *sensor);
+
+	unsigned int interruptRegisterCount;
+
+	bool polling_required;
+
+	/* pointer to the corresponding phys driver info for this sensor */
+	/* The phys driver has the pointers to read, write, etc. */
+	struct rmi_phys_driver *rpd;
+
+	struct hrtimer timer;
+	struct work_struct work;
+	bool workIsReady;
+
+	/* This list is for keeping around the list of sensors.
+	*  Every time that a physical device is detected by the
+	*  physical layer - be it i2c, spi, or some other - then
+	*  we need to bind the physical layer to the device. When
+	*  the Page Descriptor Table is scanned and when Function $01
+	*  is found then a new sensor device is created. The corresponding
+	*  rmi_phys_driver struct pointer needs to be bound to the new
+	*  sensor since Function $01 will be used to control and get
+	*  interrupt information about the particular data source that is
+	*  doing the interrupt. The rmi_phys_driver contains the pointers
+	*  to the particular read, write, read_multiple, write_multiple
+	*  functions for this device. This rmi_phys_driver struct will
+	*  have to be up-bound to any drivers upstream that need it.
+	*/
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head sensor_drivers; /* link sensor drivers into list */
+
+	struct list_head functions;     /* List of rmi_function_infos */
+	struct rmi_functiondata_list *perfunctiondata;	/* Per function initialization data. */
+};
+
+/* macro to get the pointer to the device_driver struct from the sensor */
+#define to_rmi_sensor_driver(drv) container_of(drv, struct rmi_sensor_driver, drv);
+
+struct rmi_sensor_device {
+	struct rmi_sensor_driver *driver;
+	struct device dev;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head sensors; /* link sensors into list */
+};
+
+int rmi_sensor_register_device(struct rmi_sensor_device *dev, int index);
+int rmi_sensor_register_driver(struct rmi_sensor_driver *driver);
+int rmi_sensor_register_functions(struct rmi_sensor_driver *sensor);
+bool rmi_polling_required(struct rmi_sensor_driver *sensor);
+
+static inline void *rmi_sensor_get_functiondata(struct rmi_sensor_driver *driver, unsigned char function_index)
+{
+	int i;
+	for (i = 0; i < driver->perfunctiondata->count; i++) {
+		if (driver->perfunctiondata->functiondata[i].function_index == function_index)
+			return driver->perfunctiondata->functiondata[i].data;
+	}
+	return NULL;
+}
+
+#endif
+
