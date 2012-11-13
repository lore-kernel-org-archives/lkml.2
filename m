Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2KMMMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:12:18 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:8069 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2KMMMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:12:16 -0500
Date: Tue, 13 Nov 2012 20:12:12 +0800
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
Subject: [PATCH v6] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121113201212.8550fb074e1f7cce78f29d97@tw.synaptics.com>
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

Convert to MT-B because Synaptics touch devices are capable
of tracking identifiable fingers.
 
Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
---
This patch was tested on Pandaboard.

Changes from v6:
        - Incorporated Henrik's review comments
          *remove irrelevant changes within the patch

Changes from v5:
        - Incorporated Henrik's review comments
          *rollback to v3 from v4
          *fix odd line break in v3

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
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |   76 +++++++++++--------------
 1 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 277491a..ed304e0 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/input/mt.h>
 #include "synaptics_i2c_rmi4.h"
 
 /* TODO: for multiple device support will need a per-device mutex */
@@ -67,7 +68,6 @@
 #define PDT_START_SCAN_LOCATION (0x00E9)
 #define PDT_END_SCAN_LOCATION	(0x000A)
 #define PDT_ENTRY_SIZE		(0x0006)
-#define RMI4_NUMBER_OF_MAX_FINGERS		(8)
 #define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM	(0x11)
 #define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM	(0x01)
 
@@ -164,6 +164,7 @@ struct synaptics_rmi4_device_info {
  * @regulator: pointer to the regulator structure
  * @wait: wait queue structure variable
  * @touch_stopped: flag to stop the thread function
+ * @fingers_supported: maximum supported fingers
  *
  * This structure gives the device data information.
  */
@@ -184,6 +185,7 @@ struct synaptics_rmi4_data {
 	struct regulator	*regulator;
 	wait_queue_head_t	wait;
 	bool			touch_stopped;
+	unsigned char		fingers_supported;
 };
 
 /**
@@ -303,22 +305,21 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 	/* number of touch points - fingers down in this case */
 	int	touch_count = 0;
 	int	finger;
-	int	fingers_supported;
 	int	finger_registers;
 	int	reg;
 	int	finger_shift;
 	int	finger_status;
 	int	retval;
+	int	x, y;
+	int	wx, wy;
 	unsigned short	data_base_addr;
 	unsigned short	data_offset;
 	unsigned char	data_reg_blk_size;
 	unsigned char	values[2];
 	unsigned char	data[DATA_LEN];
-	int	x[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	y[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	wx[RMI4_NUMBER_OF_MAX_FINGERS];
-	int	wy[RMI4_NUMBER_OF_MAX_FINGERS];
+	unsigned char	fingers_supported = pdata->fingers_supported;
 	struct	i2c_client *client = pdata->i2c_client;
+	struct	input_dev *input_dev = pdata->input_dev;
 
 	/* get 2D sensor finger data */
 	/*
@@ -333,7 +334,6 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 	 *	10 = finger present but data may not be accurate,
 	 *	11 = reserved for product use.
 	 */
-	fingers_supported	= rfi->num_of_data_points;
 	finger_registers	= (fingers_supported + 3)/4;
 	data_base_addr		= rfi->fn_desc.data_base_addr;
 	retval = synaptics_rmi4_i2c_block_read(pdata, data_base_addr, values,
@@ -358,7 +358,11 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 		 * if finger status indicates a finger is present then
 		 * read the finger data and report it
 		 */
-		if (finger_status == 1 || finger_status == 2) {
+		input_mt_slot(input_dev, finger);
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
+							finger_status != 0);
+
+		if (finger_status) {
 			/* Read the finger data */
 			data_offset = data_base_addr +
 					((finger * data_reg_blk_size) +
@@ -367,50 +371,33 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
 						data_offset, data,
 						data_reg_blk_size);
 			if (retval != data_reg_blk_size) {
-				printk(KERN_ERR "%s:read data failed\n",
+				dev_err(&client->dev, "%s:read data failed\n",
 								__func__);
 				return 0;
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
 			}
+			x = (data[0] << 4) | (data[2] & MASK_4BIT);
+			y = (data[1] << 4) | ((data[2] >> 4) & MASK_4BIT);
+			wy = (data[3] >> 4) & MASK_4BIT;
+			wx = (data[3] & MASK_4BIT);
+
+			if (pdata->board->x_flip)
+				x = pdata->sensor_max_x - x;
+			if (pdata->board->y_flip)
+				y = pdata->sensor_max_y - y;
+
+			input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+								max(wx, wy));
+			input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+			input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+
 			/* number of active touch points */
 			touch_count++;
 		}
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
@@ -575,6 +562,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 		if ((queries[1] & MASK_3BIT) == 5)
 			rfi->num_of_data_points = 10;
 	}
+	pdata->fingers_supported = rfi->num_of_data_points;
 	/* Need to get interrupt info for handling interrupts */
 	rfi->index_to_intr_reg = (interruptcount + 7)/8;
 	if (rfi->index_to_intr_reg != 0)
@@ -988,6 +976,8 @@ static int __devinit synaptics_rmi4_probe
 					rmi4_data->sensor_max_y, 0, 0);
 	input_set_abs_params(rmi4_data->input_dev, ABS_MT_TOUCH_MAJOR, 0,
 						MAX_TOUCH_MAJOR, 0, 0);
+	input_mt_init_slots(rmi4_data->input_dev,
+				rmi4_data->fingers_supported, 0);
 
 	/* Clear interrupts */
 	synaptics_rmi4_i2c_block_read(rmi4_data,
-- 
1.7.5.4

