Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab2KGFtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:49:41 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:47252 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGFtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:49:39 -0500
Date: Wed, 7 Nov 2012 13:49:34 +0800
From: Alexandra Chin <Alexandra.Chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: [PATCH v4] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121107134934.b37e923588f4a24af146a93b@tw.synaptics.com>
In-Reply-To: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to MT-B because Synaptics touch devices are capable of tracking
identifiable fingers.

Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
---
Changes from v4:
        - Incorporated Henrik's review comments
          *split function synpatics_rmi4_touchscreen_report
          *split function synaptics_rmi4_i2c_query_device

Changes from v3:
	- Incorporated Henrik's review comments
	  *remove 'else' after an error path return
	  *add input_mt_sync_frame() for pointer emulation effects
	  *correct names of touchscreen
	- Replace printk with dev_err

Changes from v2:
	- Incorporated Henrik's review comments
	  *directly report finger state with Type-B
	- Against 3.7-rcX
	  *call input_mt_init_slots with INPUT_MT_DIRECT flag
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |  375 ++++++++++++++-----------
 1 files changed, 215 insertions(+), 160 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 277491a..ef3fd0c 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -1,10 +1,11 @@
 /**
  *
- * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
- * Copyright (c) 2007-2010, Synaptics Incorporated
+ * Synaptics Register Mapped Interface (RMI4) I2C Touchscreen Driver.
+ * Copyright (c) 2007-2012, Synaptics Incorporated
  *
  * Author: Js HA <js.ha@stericsson.com> for ST-Ericsson
  * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com> for ST-Ericsson
+ * Author: Alexandra Chin <alexandra.chin@tw.synaptics.com>
  * Copyright 2010 (c) ST-Ericsson AB
  */
 /*
@@ -31,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/input/mt.h>
 #include "synaptics_i2c_rmi4.h"
 
 /* TODO: for multiple device support will need a per-device mutex */
@@ -63,12 +65,11 @@
 #define MASK_4BIT		0x0F
 #define MASK_3BIT		0x07
 #define MASK_2BIT		0x03
-#define TOUCHPAD_CTRL_INTR	0x8
+#define TOUCHSCREEN_CTRL_INTR	0x8
 #define PDT_START_SCAN_LOCATION (0x00E9)
 #define PDT_END_SCAN_LOCATION	(0x000A)
 #define PDT_ENTRY_SIZE		(0x0006)
-#define RMI4_NUMBER_OF_MAX_FINGERS		(8)
-#define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM	(0x11)
+#define SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM	(0x11)
 #define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM	(0x01)
 
 /**
@@ -164,6 +165,7 @@ struct synaptics_rmi4_device_info {
  * @regulator: pointer to the regulator structure
  * @wait: wait queue structure variable
  * @touch_stopped: flag to stop the thread function
+ * @fingers_supported: maximum supported fingers
  *
  * This structure gives the device data information.
  */
@@ -184,6 +186,8 @@ struct synaptics_rmi4_data {
 	struct regulator	*regulator;
 	wait_queue_head_t	wait;
 	bool			touch_stopped;
+	unsigned char		fingers_supported;
+	int			finger_status_register_count;
 };
 
 /**
@@ -291,34 +295,100 @@ exit:
 }
 
 /**
- * synpatics_rmi4_touchpad_report() - reports for the rmi4 touchpad device
+ * synpatics_rmi4_finger_report() - finger reports
  * @pdata: pointer to synaptics_rmi4_data structure
  * @rfi: pointer to synaptics_rmi4_fn structure
+ * @finger: finger index
+ * @values: pointer to buffer of status registers
  *
- * This function calls to reports for the rmi4 touchpad device
+ * This function calls to report multi-finger data to input subsystem
+ * and returns true if finger status is non zero
  */
-static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
+static bool synpatics_rmi4_finger_report(struct synaptics_rmi4_data *pdata,
+						struct synaptics_rmi4_fn *rfi,
+						int finger,
+						unsigned char *values)
+{
+	int	retval;
+	int	x, y;
+	int	wx, wy;
+	int	reg;
+	int	finger_shift;
+	int	finger_status;
+	int	finger_registers = pdata->finger_status_register_count;
+	unsigned char	data[DATA_LEN];
+	unsigned char	data_reg_blk_size = rfi->size_of_data_register_block;
+	unsigned short	data_offset;
+	unsigned short	data_base_addr = rfi->fn_desc.data_base_addr;
+	struct	i2c_client *client = pdata->i2c_client;
+	struct	input_dev *input_dev = pdata->input_dev;
+
+	/* determine which data byte the finger status is in */
+	reg = finger / 4;
+	/* bit shift to get finger's status */
+	finger_shift	= (finger % 4) * 2;
+	finger_status	= (values[reg] >> finger_shift) & MASK_2BIT;
+
+	/*
+	 * if finger status indicates a finger is present then
+	 * read the finger data and report it
+	 */
+	input_mt_slot(input_dev, finger);
+	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
+						finger_status != 0);
+	if (finger_status) {
+		/* Read the finger data */
+		data_offset = data_base_addr +
+				((finger * data_reg_blk_size) +
+				finger_registers);
+		retval = synaptics_rmi4_i2c_block_read(pdata,
+					data_offset, data,
+					data_reg_blk_size);
+		if (retval != data_reg_blk_size) {
+			dev_err(&client->dev, "%s:read data failed\n",
+							__func__);
+			return false;
+		}
+		x = (data[0] << 4) | (data[2] & MASK_4BIT);
+		y = (data[1] << 4) | ((data[2] >> 4) & MASK_4BIT);
+		wy = (data[3] >> 4) & MASK_4BIT;
+		wx = (data[3] & MASK_4BIT);
+
+		if (pdata->board->x_flip)
+			x = pdata->sensor_max_x - x;
+		if (pdata->board->y_flip)
+			y = pdata->sensor_max_y - y;
+
+		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+							max(wx, wy));
+		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+		return true;
+	}
+	return false;
+}
+
+/**
+ * synpatics_rmi4_touchscreen_report() - reports for the rmi4
+ * touchscreen device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn structure
+ *
+ * This function calls to reports for the rmi4 touchscreen device
+ */
+static int synpatics_rmi4_touchscreen_report(struct synaptics_rmi4_data *pdata,
 						struct synaptics_rmi4_fn *rfi)
 {
 	/* number of touch points - fingers down in this case */
 	int	touch_count = 0;
 	int	finger;
-	int	fingers_supported;
-	int	finger_registers;
-	int	reg;
-	int	finger_shift;
-	int	finger_status;
+	int	finger_registers = pdata->finger_status_register_count;
 	int	retval;
 	unsigned short	data_base_addr;
-	unsigned short	data_offset;
-	unsigned char	data_reg_blk_size;
 	unsigned char	values[2];
-	unsigned char	data[DATA_LEN];
-	int	x[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	y[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	wx[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	wy[RMI4_NUMBER_OF_MAX_FINGERS];
-	struct	i2c_client *client = pdata->i2c_client;
+	unsigned char	fingers_supported = pdata->fingers_supported;
+	struct i2c_client *client = pdata->i2c_client;
+	struct input_dev *input_dev = pdata->input_dev;
 
 	/* get 2D sensor finger data */
 	/*
@@ -333,8 +403,6 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 	 *	10 = finger present but data may not be accurate,
 	 *	11 = reserved for product use.
 	 */
-	fingers_supported	= rfi->num_of_data_points;
-	finger_registers	= (fingers_supported + 3)/4;
 	data_base_addr		= rfi->fn_desc.data_base_addr;
 	retval = synaptics_rmi4_i2c_block_read(pdata, data_base_addr, values,
 							finger_registers);
@@ -347,70 +415,14 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 	 * For each finger present, read the proper number of registers
 	 * to get absolute data.
 	 */
-	data_reg_blk_size = rfi->size_of_data_register_block;
 	for (finger = 0; finger < fingers_supported; finger++) {
-		/* determine which data byte the finger status is in */
-		reg = finger/4;
-		/* bit shift to get finger's status */
-		finger_shift	= (finger % 4) * 2;
-		finger_status	= (values[reg] >> finger_shift) & 3;
-		/*
-		 * if finger status indicates a finger is present then
-		 * read the finger data and report it
-		 */
-		if (finger_status == 1 || finger_status == 2) {
-			/* Read the finger data */
-			data_offset = data_base_addr +
-					((finger * data_reg_blk_size) +
-					finger_registers);
-			retval = synaptics_rmi4_i2c_block_read(pdata,
-						data_offset, data,
-						data_reg_blk_size);
-			if (retval != data_reg_blk_size) {
-				printk(KERN_ERR "%s:read data failed\n",
-								__func__);
-				return 0;
-			} else {
-				x[touch_count]	=
-					(data[0] << 4) | (data[2] & MASK_4BIT);
-				y[touch_count]	=
-					(data[1] << 4) |
-					((data[2] >> 4) & MASK_4BIT);
-				wy[touch_count]	=
-						(data[3] >> 4) & MASK_4BIT;
-				wx[touch_count]	=
-						(data[3] & MASK_4BIT);
-
-				if (pdata->board->x_flip)
-					x[touch_count] =
-						pdata->sensor_max_x -
-								x[touch_count];
-				if (pdata->board->y_flip)
-					y[touch_count] =
-						pdata->sensor_max_y -
-								y[touch_count];
-			}
-			/* number of active touch points */
-			touch_count++;
-		}
+		touch_count += synpatics_rmi4_finger_report(pdata, rfi, finger,
+								values);
 	}
 
-	/* report to input subsystem */
-	if (touch_count) {
-		for (finger = 0; finger < touch_count; finger++) {
-			input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR,
-						max(wx[finger] , wy[finger]));
-			input_report_abs(pdata->input_dev, ABS_MT_POSITION_X,
-								x[finger]);
-			input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y,
-								y[finger]);
-			input_mt_sync(pdata->input_dev);
-		}
-	} else
-		input_mt_sync(pdata->input_dev);
-
 	/* sync after groups of events */
-	input_sync(pdata->input_dev);
+	input_mt_sync_frame(input_dev);
+	input_sync(input_dev);
 	/* return the number of touch points */
 	return touch_count;
 }
@@ -428,15 +440,16 @@ static int synaptics_rmi4_report_device(struct synaptics_rmi4_data *pdata,
 	int touch = 0;
 	struct	i2c_client *client = pdata->i2c_client;
 	static int num_error_reports;
-	if (rfi->fn_number != SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
+	if (rfi->fn_number != SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM) {
 		num_error_reports++;
 		if (num_error_reports < MAX_ERROR_REPORT)
 			dev_err(&client->dev, "%s:report not supported\n",
 								__func__);
 	} else
-		touch = synpatics_rmi4_touchpad_report(pdata, rfi);
+		touch = synpatics_rmi4_touchscreen_report(pdata, rfi);
 	return touch;
 }
+
 /**
  * synaptics_rmi4_sensor_report() - reports to input subsystem
  * @pdata: pointer to synaptics_rmi4_data structure
@@ -448,10 +461,10 @@ static int synaptics_rmi4_sensor_report(struct synaptics_rmi4_data *pdata)
 {
 	unsigned char	intr_status[4];
 	/* number of touch points - fingers or buttons */
-	int touch = 0;
-	unsigned int retval;
-	struct synaptics_rmi4_fn		*rfi;
-	struct synaptics_rmi4_device_info	*rmi;
+	int		touch = 0;
+	unsigned int	retval;
+	struct	synaptics_rmi4_fn		*rfi;
+	struct	synaptics_rmi4_device_info	*rmi;
 	struct	i2c_client *client = pdata->i2c_client;
 
 	/*
@@ -510,18 +523,18 @@ static irqreturn_t synaptics_rmi4_irq(int irq, void *data)
 }
 
 /**
- * synpatics_rmi4_touchpad_detect() - detects the rmi4 touchpad device
+ * synpatics_rmi4_touchscreen_detect() - detects the rmi4 touchscreen device
  * @pdata: pointer to synaptics_rmi4_data structure
  * @rfi: pointer to synaptics_rmi4_fn structure
  * @fd: pointer to synaptics_rmi4_fn_desc structure
- * @interruptcount: count the number of interrupts
+ * @intr_count: count the number of interrupts
  *
- * This function calls to detects the rmi4 touchpad device
+ * This function calls to detects the rmi4 touchscreen device
  */
-static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
+static int synpatics_rmi4_touchscreen_detect(struct synaptics_rmi4_data *pdata,
 					struct synaptics_rmi4_fn *rfi,
 					struct synaptics_rmi4_fn_desc *fd,
-					unsigned int interruptcount)
+					unsigned int intr_count)
 {
 	unsigned char	queries[QUERY_LEN];
 	unsigned short	intr_offset;
@@ -575,15 +588,18 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 		if ((queries[1] & MASK_3BIT) == 5)
 			rfi->num_of_data_points = 10;
 	}
+	pdata->fingers_supported = rfi->num_of_data_points;
+	pdata->finger_status_register_count = (rfi->num_of_data_points + 3) / 4;
+
 	/* Need to get interrupt info for handling interrupts */
-	rfi->index_to_intr_reg = (interruptcount + 7)/8;
+	rfi->index_to_intr_reg = (intr_count + 7) / 8;
 	if (rfi->index_to_intr_reg != 0)
 		rfi->index_to_intr_reg -= 1;
 	/*
 	 * loop through interrupts for each source in fn $11
 	 * and or in a bit to the interrupt mask for each.
 	 */
-	intr_offset = interruptcount % 8;
+	intr_offset = intr_count % 8;
 	rfi->intr_mask = 0;
 	for (i = intr_offset;
 		i < ((fd->intr_src_count & MASK_3BIT) + intr_offset); i++)
@@ -655,13 +671,13 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 }
 
 /**
- * synaptics_rmi4_touchpad_config() - configures the rmi4 touchpad device
+ * synaptics_rmi4_touchscreen_config() - configures the rmi4 touchscreen device
  * @pdata: pointer to synaptics_rmi4_data structure
  * @rfi: pointer to synaptics_rmi4_fn structure
  *
- * This function calls to configures the rmi4 touchpad device
+ * This function calls to configures the rmi4 touchscreen device
  */
-int synaptics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
+int synaptics_rmi4_touchscreen_config(struct synaptics_rmi4_data *pdata,
 						struct synaptics_rmi4_fn *rfi)
 {
 	/*
@@ -702,6 +718,95 @@ int synaptics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
 }
 
 /**
+ * synaptics_rmi4_query_function() - query rmi4 functions
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn structure
+ *
+ * This function is used to query rmi4 functions.
+ */
+static int synaptics_rmi4_query_function(struct synaptics_rmi4_data *pdata,
+						struct synaptics_rmi4_fn *rfi)
+{
+	int	retval;
+	unsigned int	ctrl_offset;
+	struct	synaptics_rmi4_device_info *rmi;
+	struct	i2c_client *client = pdata->i2c_client;
+
+	rmi = &(pdata->rmi4_mod_info);
+	list_for_each_entry(rfi, &rmi->support_fn_list, link) {
+		if (rfi->num_of_data_sources) {
+			if (rfi->fn_number ==
+				SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM) {
+				retval = synaptics_rmi4_touchscreen_config(
+								pdata, rfi);
+				if (retval < 0)
+					return retval;
+			} else
+				dev_err(&client->dev,
+					"%s:fn_number not supported\n",
+							__func__);
+			/*
+			 * Turn on interrupts for this
+			 * function's data sources.
+			 */
+			ctrl_offset = pdata->fn01_ctrl_base_addr + 1 +
+						rfi->index_to_intr_reg;
+			retval = synaptics_rmi4_i2c_byte_write(pdata,
+						ctrl_offset,
+						rfi->intr_mask);
+			if (retval < 0)
+				return retval;
+		}
+	}
+	return 0;
+}
+
+/**
+ * synaptics_rmi4_explore_function() - explore rmi4 functions
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rmi_fd: pointer to synaptics_rmi4_fn_desc structure
+ * @rfi: pointer to point of synaptics_rmi4_fn structure
+ * @intr_count: count the number of interrupts
+ *
+ * This function is used to explore rmi4 functions.
+ */
+static int synaptics_rmi4_explore_function(struct synaptics_rmi4_data *pdata,
+					struct synaptics_rmi4_fn_desc *rmi_fd,
+					struct synaptics_rmi4_fn **rfi,
+					unsigned int intr_count)
+{
+	int retval;
+	struct i2c_client *client = pdata->i2c_client;
+
+	switch (rmi_fd->fn_number) {
+	case SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM:
+		pdata->fn01_query_base_addr =
+				rmi_fd->query_base_addr;
+		pdata->fn01_ctrl_base_addr =
+				rmi_fd->ctrl_base_addr;
+		pdata->fn01_data_base_addr =
+				rmi_fd->data_base_addr;
+		break;
+	case SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM:
+		if (rmi_fd->intr_src_count) {
+			*rfi = kmalloc(sizeof(**rfi), GFP_KERNEL);
+			if (!rfi) {
+				dev_err(&client->dev, "%s:kmalloc failed\n",
+						__func__);
+				return -ENOMEM;
+			}
+			retval = synpatics_rmi4_touchscreen_detect(pdata,
+						*rfi, rmi_fd, intr_count);
+			if (retval < 0) {
+				kfree(*rfi);
+				return retval;
+			}
+		}
+		break;
+	}
+	return 0;
+}
+/**
  * synaptics_rmi4_i2c_query_device() - query the rmi4 device
  * @pdata: pointer to synaptics_rmi4_data structure
  *
@@ -711,13 +816,11 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 {
 	int i;
 	int retval;
+	int data_sources = 0;
 	unsigned char std_queries[STD_QUERY_LEN];
 	unsigned char intr_count = 0;
-	int data_sources = 0;
-	unsigned int ctrl_offset;
 	struct synaptics_rmi4_fn *rfi;
 	struct synaptics_rmi4_fn_desc	rmi_fd;
-	struct synaptics_rmi4_device_info *rmi;
 	struct	i2c_client *client = pdata->i2c_client;
 
 	/*
@@ -742,38 +845,13 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 		}
 		rfi = NULL;
 		if (rmi_fd.fn_number) {
-			switch (rmi_fd.fn_number & MASK_8BIT) {
-			case SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM:
-				pdata->fn01_query_base_addr =
-						rmi_fd.query_base_addr;
-				pdata->fn01_ctrl_base_addr =
-						rmi_fd.ctrl_base_addr;
-				pdata->fn01_data_base_addr =
-						rmi_fd.data_base_addr;
-				break;
-			case SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM:
-				if (rmi_fd.intr_src_count) {
-					rfi = kmalloc(sizeof(*rfi),
-								GFP_KERNEL);
-					if (!rfi) {
-						dev_err(&client->dev,
-							"%s:kmalloc failed\n",
-								__func__);
-							return -ENOMEM;
-					}
-					retval = synpatics_rmi4_touchpad_detect
-								(pdata,	rfi,
-								&rmi_fd,
-								intr_count);
-					if (retval < 0) {
-						kfree(rfi);
-						return retval;
-					}
-				}
-				break;
-			}
+			retval = synaptics_rmi4_explore_function(pdata, &rmi_fd,
+							&rfi, intr_count);
+			if (retval < 0)
+				return retval;
 			/* interrupt count for next iteration */
 			intr_count += (rmi_fd.intr_src_count & MASK_3BIT);
+
 			/*
 			 * We only want to add functions to the list
 			 * that have data associated with them.
@@ -850,32 +928,7 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 	list_for_each_entry(rfi, &pdata->rmi4_mod_info.support_fn_list, link)
 		data_sources += rfi->num_of_data_sources;
 	if (data_sources) {
-		rmi = &(pdata->rmi4_mod_info);
-		list_for_each_entry(rfi, &rmi->support_fn_list, link) {
-			if (rfi->num_of_data_sources) {
-				if (rfi->fn_number ==
-					SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
-					retval = synaptics_rmi4_touchpad_config
-								(pdata, rfi);
-					if (retval < 0)
-						return retval;
-				} else
-					dev_err(&client->dev,
-						"%s:fn_number not supported\n",
-								__func__);
-				/*
-				 * Turn on interrupts for this
-				 * function's data sources.
-				 */
-				ctrl_offset = pdata->fn01_ctrl_base_addr + 1 +
-							rfi->index_to_intr_reg;
-				retval = synaptics_rmi4_i2c_byte_write(pdata,
-							ctrl_offset,
-							rfi->intr_mask);
-				if (retval < 0)
-					return retval;
-			}
-		}
+		return synaptics_rmi4_query_function(pdata, rfi);
 	}
 	return 0;
 }
@@ -988,6 +1041,8 @@ static int __devinit synaptics_rmi4_probe
 					rmi4_data->sensor_max_y, 0, 0);
 	input_set_abs_params(rmi4_data->input_dev, ABS_MT_TOUCH_MAJOR, 0,
 						MAX_TOUCH_MAJOR, 0, 0);
+	input_mt_init_slots(rmi4_data->input_dev,
+				rmi4_data->fingers_supported, INPUT_MT_DIRECT);
 
 	/* Clear interrupts */
 	synaptics_rmi4_i2c_block_read(rmi4_data,
@@ -1076,7 +1131,7 @@ static int synaptics_rmi4_suspend(struct device *dev)
 
 	retval = synaptics_rmi4_i2c_byte_write(rmi4_data,
 					rmi4_data->fn01_ctrl_base_addr + 1,
-					(intr_status & ~TOUCHPAD_CTRL_INTR));
+					(intr_status & ~TOUCHSCREEN_CTRL_INTR));
 	if (retval < 0)
 		return retval;
 
@@ -1112,7 +1167,7 @@ static int synaptics_rmi4_resume(struct device *dev)
 
 	retval = synaptics_rmi4_i2c_byte_write(rmi4_data,
 					rmi4_data->fn01_ctrl_base_addr + 1,
-					(intr_status | TOUCHPAD_CTRL_INTR));
+					(intr_status | TOUCHSCREEN_CTRL_INTR));
 	if (retval < 0)
 		return retval;
 
-- 
1.7.5.4

