Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2LSArs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:47:48 -0500
Received: from [12.239.217.82] ([12.239.217.82]:6486 "EHLO venom.synaptics.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754977Ab2LSAro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:47:44 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/05] input: F11 2D input
Date: Tue, 18 Dec 2012 16:46:36 -0800
Message-Id: <1355877996-1433-6-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
References: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the changes described in 0/0 of this patchset, this patch
includes:

* elimination of unused sysfs and debugfs parameters.

* some fixes to the input device parameters.

* removal of some stray Android stuff.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_f11.c | 1187 +++++++-----------------------------------
 1 files changed, 197 insertions(+), 990 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index 8457ab4..7a8b806 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -2,38 +2,26 @@
  * Copyright (c) 2011,2012 Synaptics Incorporated
  * Copyright (c) 2011 Unixphere
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
  */

 #define FUNCTION_DATA f11_data
+#define FUNCTION_NUMBER 0x11

 #include <linux/kernel.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/fs.h>
 #include <linux/input.h>
 #include <linux/input/mt.h>
 #include <linux/kconfig.h>
 #include <linux/rmi.h>
 #include <linux/slab.h>
-#include "rmi_driver.h"
-
-#ifdef CONFIG_RMI4_DEBUG
-#include <linux/debugfs.h>
-#include <linux/fs.h>
 #include <linux/uaccess.h>
-#endif
+#include "rmi_driver.h"

 #define F11_MAX_NUM_OF_SENSORS		8
 #define F11_MAX_NUM_OF_FINGERS		10
@@ -54,7 +42,6 @@
 #define DEFAULT_MIN_ABS_MT_TRACKING_ID 1
 #define DEFAULT_MAX_ABS_MT_TRACKING_ID 10
 #define NAME_BUFFER_SIZE 256
-#define FUNCTION_NUMBER 0x11

 /** A note about RMI4 F11 register structure.
  *
@@ -439,195 +426,9 @@ struct f11_2d_ctrl0_9 {
 	u8 ctrl9_reserved:4;
 } __attribute__((__packed__));

-/**
- * @single_tap_int_enable - enable tap gesture recognition.
- * @tap_n_hold_int_enable - enable tap-and-hold gesture recognition.
- * @double_tap_int_enable - enable double-tap gesture recognition.
- * @early_tap_int_enable - enable early tap notification.
- * @flick_int_enable - enable flick detection.
- * @press_int_enable - enable press gesture recognition.
- * @pinch_int_enable - enable pinch detection.
- */
-struct f11_2d_ctrl10 {
-	u8 single_tap_int_enable:1;
-	u8 tap_n_hold_int_enable:1;
-	u8 double_tap_int_enable:1;
-	u8 early_tap_int_enable:1;
-	u8 flick_int_enable:1;
-	u8 press_int_enable:1;
-	u8 pinch_int_enable:1;
-	u8 reserved:1;
-} __attribute__((__packed__));
-
-/**
- * @palm_detect_int_enable - enable palm detection feature.
- * @rotate_int_enable - enable rotate gesture detection.
- * @touch_shape_int_enable - enable the TouchShape feature.
- * @scroll_zone_int_enable - enable scroll zone reporting.
- * @multi_finger_scroll_int_enable - enable the multfinger scroll feature.
- */
-struct f11_2d_ctrl11 {
-	u8 palm_detect_int_enable:1;
-	u8 rotate_int_enable:1;
-	u8 touch_shape_int_enable:1;
-	u8 scroll_zone_int_enable:1;
-	u8 multi_finger_scroll_int_enable:1;
-	u8 reserved:3;
-} __attribute__((__packed__));
-
-/**
- * @sens_adjustment - allows a host to alter the overall sensitivity of a
- * 2-D sensor. A positive value in this register will make the sensor more
- * sensitive than the factory defaults, and a negative value will make it
- * less sensitive.
- * @hyst_adjustment - increase the touch/no-touch hysteresis by 2 Z-units for
- * each one unit increment in this setting.
- */
-struct f11_2d_ctrl14 {
-	s8 sens_adjustment:5;
-	u8 hyst_adjustment:3;
-} __attribute__((__packed__));
-
-/**
- * @max_tap_time - the maximum duration of a tap, in 10-millisecond units.
- */
-struct f11_2d_ctrl15 {
-	u8 max_tap_time:8;
-} __attribute__((__packed__));
-
-/**
- * @min_press_time - The minimum duration required for stationary finger(s) to
- * generate a press gesture, in 10-millisecond units.
- */
-struct f11_2d_ctrl16 {
-	u8 min_press_time:8;
-} __attribute__((__packed__));
-
-/**
- * @max_tap_distance - Determines the maximum finger movement allowed during
- * a tap, in 0.1-millimeter units.
- */
-struct f11_2d_ctrl17 {
-	u8 max_tap_distance:8;
-} __attribute__((__packed__));
-
-/**
- * @min_flick_distance - the minimum finger movement for a flick gesture,
- * in 1-millimeter units.
- * @min_flick_speed - the minimum finger speed for a flick gesture, in
- * 10-millimeter/second units.
- */
-struct f11_2d_ctrl18_19 {
-	u8 min_flick_distance:8;
-	u8 min_flick_speed:8;
-} __attribute__((__packed__));
-
-/**
- * @pen_detect_enable - enable reporting of stylus activity.
- * @pen_jitter_filter_enable - Setting this enables the stylus anti-jitter
- * filter.
- * @pen_z_threshold - This is the stylus-detection lower threshold. Smaller
- * values result in higher sensitivity.
- */
-struct f11_2d_ctrl20_21 {
-	u8 pen_detect_enable:1;
-	u8 pen_jitter_filter_enable:1;
-	u8 ctrl20_reserved:6;
-	u8 pen_z_threshold:8;
-} __attribute__((__packed__));
-
-/**
- * These are not accessible through sysfs yet.
- *
- * @proximity_detect_int_en - enable proximity detection feature.
- * @proximity_jitter_filter_en - enables an anti-jitter filter on proximity
- * data.
- * @proximity_detection_z_threshold - the threshold for finger-proximity
- * detection.
- * @proximity_delta_x_threshold - In reduced-reporting modes, this is the
- * threshold for proximate-finger movement in the direction parallel to the
- * X-axis.
- * @proximity_delta_y_threshold - In reduced-reporting modes, this is the
- * threshold for proximate-finger movement in the direction parallel to the
- * Y-axis.
- * * @proximity_delta_Z_threshold - In reduced-reporting modes, this is the
- * threshold for proximate-finger movement in the direction parallel to the
- * Z-axis.
- */
-struct f11_2d_ctrl22_26 {
-	/* control 22 */
-	u8 proximity_detect_int_en:1;
-	u8 proximity_jitter_filter_en:1;
-	u8 f11_2d_ctrl6_b3__7:6;
-
-	/* control 23 */
-	u8 proximity_detection_z_threshold;
-
-	/* control 24 */
-	u8 proximity_delta_x_threshold;
-
-	/* control 25 */
-	u8 proximity_delta_y_threshold;
-
-	/* control 26 */
-	u8 proximity_delta_z_threshold;
-} __attribute__((__packed__));
-
-/**
- * @palm_detecy_sensitivity - When this value is small, smaller objects will
- * be identified as palms; when this value is large, only larger objects will
- * be identified as palms. 0 represents the factory default.
- * @suppress_on_palm_detect - when set, all F11 interrupts except palm_detect
- * are suppressed while a palm is detected.
- */
-struct f11_2d_ctrl27 {
-	s8 palm_detect_sensitivity:4;
-	u8 suppress_on_palm_detect:1;
-	u8 f11_2d_ctrl27_b5__7:3;
-} __attribute__((__packed__));
-
-/**
- * @multi_finger_scroll_mode - allows choice of multi-finger scroll mode and
- * determines whether and how X or Y displacements are reported.
- * @edge_motion_en - enables the edge_motion feature.
- * @multi_finger_scroll_momentum - controls the length of time that scrolling
- * continues after fingers have been lifted.
- */
-struct f11_2d_ctrl28 {
-	u8 multi_finger_scroll_mode:2;
-	u8 edge_motion_en:1;
-	u8 f11_2d_ctrl28b_3:1;
-	u8 multi_finger_scroll_momentum:4;
-} __attribute__((__packed__));
-
-/**
- * @z_touch_threshold - Specifies the finger-arrival Z threshold. Large values
- * may cause smaller fingers to be rejected.
- * @z_touch_hysteresis - Specifies the difference between the finger-arrival
- * Z threshold and the finger-departure Z threshold.
- */
-struct f11_2d_ctrl29_30 {
-	u8 z_touch_threshold;
-	u8 z_touch_hysteresis;
-} __attribute__((__packed__));
-
-
 struct f11_2d_ctrl {
 	struct f11_2d_ctrl0_9		 *ctrl0_9;
 	u16				ctrl0_9_address;
-	struct f11_2d_ctrl10		*ctrl10;
-	struct f11_2d_ctrl11		*ctrl11;
-	u8				ctrl12_size;
-	struct f11_2d_ctrl14		*ctrl14;
-	struct f11_2d_ctrl15		*ctrl15;
-	struct f11_2d_ctrl16		*ctrl16;
-	struct f11_2d_ctrl17		*ctrl17;
-	struct f11_2d_ctrl18_19		*ctrl18_19;
-	struct f11_2d_ctrl20_21		*ctrl20_21;
-	struct f11_2d_ctrl22_26		*ctrl22_26;
-	struct f11_2d_ctrl27		*ctrl27;
-	struct f11_2d_ctrl28		*ctrl28;
-	struct f11_2d_ctrl29_30		*ctrl29_30;
 };

 /**
@@ -658,114 +459,10 @@ struct f11_2d_data_6_7 {
 	s8 delta_y;
 } __attribute__((__packed__));

-/**
- * @single_tap - a single tap was recognized.
- * @tap_and_hold - a tap-and-hold gesture was recognized.
- * @double_tap - a double tap gesture was recognized.
- * @early_tap - a tap gesture might be happening.
- * @flick - a flick gesture was detected.
- * @press - a press gesture was recognized.
- * @pinch - a pinch gesture was detected.
- */
-struct f11_2d_data_8 {
-	bool single_tap:1;
-	bool tap_and_hold:1;
-	bool double_tap:1;
-	bool early_tap:1;
-	bool flick:1;
-	bool press:1;
-	bool pinch:1;
-} __attribute__((__packed__));
-
-/**
- * @palm_detect - a palm or other large object is in contact with the sensor.
- * @rotate - a rotate gesture was detected.
- * @shape - a TouchShape has been activated.
- * @scrollzone - scrolling data is available.
- * @finger_count - number of fingers involved in the reported gesture.
- */
-struct f11_2d_data_9 {
-	bool palm_detect:1;
-	bool rotate:1;
-	bool shape:1;
-	bool scrollzone:1;
-	u8 finger_count:3;
-} __attribute__((__packed__));
-
-/**
- * @pinch_motion - when a pinch gesture is detected, this is the change in
- * distance between the two fingers since this register was last read.
- */
-struct f11_2d_data_10 {
-	s8 pinch_motion;
-} __attribute__((__packed__));
-
-/**
- * @x_flick_dist - when a flick gesture is detected,  the distance of flick
- * gesture in X direction.
- * @y_flick_dist - when a flick gesture is detected,  the distance of flick
- * gesture in Y direction.
- * @flick_time - the total time of the flick gesture, in 10ms units.
- */
-struct f11_2d_data_10_12 {
-	s8 x_flick_dist;
-	s8 y_flick_dist;
-	u8 flick_time;
-} __attribute__((__packed__));
-
-/**
- * @motion - when a rotate gesture is detected, the accumulated distance
- * of the rotate motion. Clockwise motion is positive and counterclockwise
- * motion is negative.
- * @finger_separation - when a rotate gesture is detected, the distance
- * between the fingers.
- */
-struct f11_2d_data_11_12 {
-	s8 motion;
-	u8 finger_separation;
-} __attribute__((__packed__));
-
-/**
- * @shape_n - a bitmask of the currently activate TouchShapes (if any).
- */
-struct f11_2d_data_13 {
-	u8 shape_n;
-} __attribute__((__packed__));
-
-/**
- * @horizontal - chiral scrolling distance in the X direction.
- * @vertical - chiral scrolling distance in the Y direction.
- */
-struct f11_2d_data_14_15 {
-	s8 horizontal;
-	s8 vertical;
-} __attribute__((__packed__));
-
-/**
- * @x_low - scroll zone motion along the lower edge of the sensor.
- * @y_right - scroll zone motion along the right edge of the sensor.
- * @x_upper - scroll zone motion along the upper edge of the sensor.
- * @y_left - scroll zone motion along the left edge of the sensor.
- */
-struct f11_2d_data_14_17 {
-	s8 x_low;
-	s8 y_right;
-	s8 x_upper;
-	s8 y_left;
-} __attribute__((__packed__));
-
 struct f11_2d_data {
 	u8				*f_state;
 	const struct f11_2d_data_1_5	*abs_pos;
 	const struct f11_2d_data_6_7	*rel_pos;
-	const struct f11_2d_data_8	*gest_1;
-	const struct f11_2d_data_9	*gest_2;
-	const struct f11_2d_data_10	*pinch;
-	const struct f11_2d_data_10_12	*flick;
-	const struct f11_2d_data_11_12	*rotate;
-	const struct f11_2d_data_13	*shapes;
-	const struct f11_2d_data_14_15	*multi_scroll;
-	const struct f11_2d_data_14_17	*scroll_zones;
 };

 /**
@@ -800,6 +497,7 @@ struct f11_2d_data {
  * @debugfs_swap - swaps X and Y axes.  Useful in prototyping new systems.
  * @debugfs_type_a - forces type A behavior.  Useful in bringing up old systems
  * when you're not sure if you've got a Type A or Type B sensor.
+ * @input_phys_mouse - buffer for the relative phys name for this sensor.
  */
 struct f11_2d_sensor {
 	struct rmi_f11_2d_axis_alignment axis_align;
@@ -811,15 +509,18 @@ struct f11_2d_sensor {
 	u8 *data_pkt;
 	int pkt_size;
 	u8 sensor_index;
-	bool type_a;
+	u8 *button_map;
+	u32 type_a;
 	enum rmi_f11_sensor_type sensor_type;
 	struct input_dev *input;
 	struct input_dev *mouse_input;
-	struct rmi_function *fn;
+	struct rmi_function_dev *fn_dev;
 	char input_phys[NAME_BUFFER_SIZE];
 	char input_phys_mouse[NAME_BUFFER_SIZE];

 #ifdef CONFIG_RMI4_DEBUG
+	struct dentry *sensor_root;
+	struct dentry *debugfs_maxPos;
 	struct dentry *debugfs_flip;
 	struct dentry *debugfs_clip;
 	struct dentry *debugfs_delta_threshold;
@@ -862,66 +563,15 @@ enum finger_state_values {
 	F11_RESERVED	= 0x03
 };

-static ssize_t f11_maxPos_show(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
-{
-	struct rmi_function *fn;
-	struct f11_data *data;
-
-	fn = to_rmi_function(dev);
-	data = fn->data;
-
-	return snprintf(buf, PAGE_SIZE, "%u %u\n",
-			data->sensors[0].max_x, data->sensors[0].max_y);
-}
-
-static ssize_t f11_relreport_show(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	struct rmi_function *fn;
-	struct f11_data *instance_data;
-
-	fn = to_rmi_function(dev);
-	instance_data = fn->data;
-
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			instance_data->
-			sensors[0].axis_align.rel_report_enabled);
-}
-
-static ssize_t f11_relreport_store(struct device *dev,
-					 struct device_attribute *attr,
-					 const char *buf,
-					 size_t count)
-{
-	struct rmi_function *fn;
-	struct f11_data *instance_data;
-	unsigned int new_value;
-
-	fn = to_rmi_function(dev);
-	instance_data = fn->data;
-
-
-	if (sscanf(buf, "%u", &new_value) != 1)
-		return -EINVAL;
-	if (new_value > 1)
-		return -EINVAL;
-	instance_data->sensors[0].axis_align.rel_report_enabled = new_value;
-
-	return count;
-}
-
 static ssize_t f11_rezero_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	struct rmi_function *fn = NULL;
+	struct rmi_function_dev *fn_dev = NULL;
 	unsigned int rezero;
 	int retval = 0;

-	fn = to_rmi_function(dev);
+	fn_dev = to_rmi_function_dev(dev);

 	if (sscanf(buf, "%u", &rezero) != 1)
 		return -EINVAL;
@@ -935,8 +585,9 @@ static ssize_t f11_rezero_store(struct device *dev,
 			.rezero = true,
 		};

-		retval = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
-				&commands, sizeof(commands));
+		retval = rmi_write_block(fn_dev->rmi_dev,
+					fn_dev->fd.command_base_addr,
+					&commands, sizeof(commands));
 		if (retval < 0) {
 			dev_err(dev, "%s: failed to issue rezero command, error = %d.",
 				__func__, retval);
@@ -947,11 +598,14 @@ static ssize_t f11_rezero_store(struct device *dev,
 	return count;
 }

-static struct device_attribute attrs[] = {
-	__ATTR(relreport, RMI_RW_ATTR, f11_relreport_show, f11_relreport_store),
-	__ATTR(maxPos, RMI_RO_ATTR, f11_maxPos_show, NULL),
-	__ATTR(rezero, RMI_WO_ATTR, NULL, f11_rezero_store)
+static struct device_attribute dev_attr_rezero =
+	__ATTR(rezero, RMI_WO_ATTR, NULL, f11_rezero_store);
+
+static struct attribute *attrs[] = {
+	&dev_attr_rezero.attr,
+	NULL,
 };
+static struct attribute_group fn11_attrs = GROUP(attrs);

 #ifdef CONFIG_RMI4_DEBUG

@@ -979,6 +633,39 @@ static int sensor_debug_release(struct inode *inodep, struct file *filp)
 	kfree(filp->private_data);
 	return 0;
 }
+static ssize_t maxPos_read(struct file *filp, char __user *buffer, size_t size,
+		    loff_t *offset) {
+	int retval;
+	char *local_buf;
+	struct sensor_debugfs_data *data = filp->private_data;
+
+	if (data->done)
+		return 0;
+
+	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
+	if (!local_buf)
+		return -ENOMEM;
+
+	data->done = 1;
+
+	retval = snprintf(local_buf, size, "%u %u\n",
+			data->sensor->max_x,
+			data->sensor->max_y);
+
+	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
+		retval = -EFAULT;
+	kfree(local_buf);
+
+	return retval;
+}
+
+static const struct file_operations maxPos_fops = {
+	.owner = THIS_MODULE,
+	.open = sensor_debug_open,
+	.release = sensor_debug_release,
+	.read = maxPos_read,
+};
+

 static ssize_t flip_read(struct file *filp, char __user *buffer, size_t size,
 		    loff_t *offset) {
@@ -1048,7 +735,7 @@ static ssize_t delta_threshold_read(struct file *filp, char __user *buffer,
 	int retval;
 	char *local_buf;
 	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fn->data;
+	struct f11_data *f11 = data->sensor->fn_dev->data;
 	struct f11_2d_ctrl *ctrl = &f11->dev_controls;

 	if (data->done)
@@ -1080,9 +767,9 @@ static ssize_t delta_threshold_write(struct file *filp,
 	u8 save_X, save_Y;
 	int rc;
 	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fn->data;
+	struct f11_data *f11 = data->sensor->fn_dev->data;
 	struct f11_2d_ctrl *ctrl = &f11->dev_controls;
-	struct rmi_device *rmi_dev =  data->sensor->fn->rmi_dev;
+	struct rmi_device *rmi_dev =  data->sensor->fn_dev->rmi_dev;

 	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
 	if (!local_buf)
@@ -1107,7 +794,7 @@ static ssize_t delta_threshold_write(struct file *filp,
 	rc = rmi_write_block(rmi_dev, ctrl->ctrl0_9_address,
 			ctrl->ctrl0_9, sizeof(*ctrl->ctrl0_9));
 	if (rc < 0) {
-		dev_warn(&data->sensor->fn->dev,
+		dev_warn(&data->sensor->fn_dev->dev,
 			"Failed to write to delta_threshold. Code: %d.\n",
 			rc);
 		ctrl->ctrl0_9->delta_x_threshold = save_X;
@@ -1259,220 +946,99 @@ static const struct file_operations clip_fops = {
 	.write = clip_write,
 };

-static ssize_t swap_read(struct file *filp, char __user *buffer, size_t size,
-		    loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct sensor_debugfs_data *data = filp->private_data;
-
-	if (data->done)
-		return 0;
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-
-	data->done = 1;
-
-	retval = snprintf(local_buf, size, "%u\n",
-			data->sensor->axis_align.swap_axes);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
+static void rmi_f11_setup_sensor_debugfs(struct f11_2d_sensor *sensor)

-	return retval;
-}
-
-static ssize_t swap_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
 {
-	int retval;
-	char *local_buf;
-	int new_value;
-	struct sensor_debugfs_data *data = filp->private_data;
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-
-	retval = copy_from_user(local_buf, buffer, size);
-	if (retval) {
-		kfree(local_buf);
-		return -EFAULT;
-	}
-	retval = sscanf(local_buf, "%u", &new_value);
-	kfree(local_buf);
-	if (retval != 1 || new_value > 1)
-		return -EINVAL;
-
-	data->sensor->axis_align.swap_axes = new_value;
-	return size;
-}
-
-static const struct file_operations swap_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = swap_read,
-	.write = swap_write,
-};
-
-static ssize_t type_a_read(struct file *filp, char __user *buffer, size_t size,
-		    loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct sensor_debugfs_data *data = filp->private_data;
-
-	if (data->done)
-		return 0;
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-
-	data->done = 1;
-
-	retval = snprintf(local_buf, size, "%u\n",
-			data->sensor->type_a);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
+	int retval = 0;
+	char fname[NAME_BUFFER_SIZE];
+	struct rmi_function_dev *fn_dev = sensor->fn_dev;
+	struct dentry *sensor_root;
+	char dirname[sizeof("sensorNN")];

-static ssize_t type_a_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
-{
-	int retval;
-	char *local_buf;
-	int new_value;
-	struct sensor_debugfs_data *data = filp->private_data;

-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
+	if (!fn_dev->debugfs_root)
+		return;

-	retval = copy_from_user(local_buf, buffer, size);
-	if (retval) {
-		kfree(local_buf);
-		return -EFAULT;
+	snprintf(dirname, sizeof(dirname), "input%3u", sensor->sensor_index);
+	sensor_root = debugfs_create_dir(dirname, fn_dev->debugfs_root);
+	if (!sensor_root) {
+		dev_warn(&fn_dev->dev,
+			 "Failed to create debugfs directory %s for sensor %d\n",
+			 dirname, sensor->sensor_index);
+		return;
 	}

-	retval = sscanf(local_buf, "%u", &new_value);
-	kfree(local_buf);
-	if (retval != 1 || new_value > 1)
-		return -EINVAL;
-
-	data->sensor->type_a = new_value;
-	return size;
-}
-
-static const struct file_operations type_a_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = type_a_read,
-	.write = type_a_write,
-};
-
-static int setup_sensor_debugfs(struct f11_2d_sensor *sensor)
-{
-	int retval = 0;
-	char fname[NAME_BUFFER_SIZE];
-	struct rmi_function *fn = sensor->fn;
-
-	if (!fn->debugfs_root)
-		return -ENODEV;
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "maxPos");
+	sensor->debugfs_maxPos = debugfs_create_file(fname, RMI_RO_ATTR,
+				sensor_root, sensor, &maxPos_fops);
+	if (!sensor->debugfs_maxPos)
+		dev_warn(&fn_dev->dev, "Failed to create debugfs %s.\n",
+			 fname);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "flip.%d",
-			  sensor->sensor_index);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "flip");
 	sensor->debugfs_flip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &flip_fops);
+				sensor_root, sensor, &flip_fops);
 	if (!sensor->debugfs_flip)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn_dev->dev, "Failed to create debugfs %s.\n",
 			 fname);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "clip.%d",
-			  sensor->sensor_index);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "clip");
 	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &clip_fops);
+				sensor_root, sensor, &clip_fops);
 	if (!sensor->debugfs_clip)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn_dev->dev, "Failed to create debugfs %s.\n",
 			 fname);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "delta_threshold.%d",
-			  sensor->sensor_index);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "delta_threshold");
 	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor,
+				sensor_root, sensor,
 				&delta_threshold_fops);
 	if (!sensor->debugfs_delta_threshold)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn_dev->dev, "Failed to create debugfs %s.\n",
 			 fname);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "offset.%d",
-			  sensor->sensor_index);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "offset");
 	sensor->debugfs_offset = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &offset_fops);
+				sensor_root, sensor, &offset_fops);
 	if (!sensor->debugfs_offset)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn_dev->dev, "Failed to create debugfs %s.\n",
 			 fname);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "swap.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_swap = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &swap_fops);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "swap");
+	sensor->debugfs_swap = debugfs_create_bool(fname, RMI_RW_ATTR,
+				sensor_root, &sensor->axis_align.swap_axes);
 	if (!sensor->debugfs_swap)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
+		dev_warn(&fn_dev->dev,
+			"Failed to create debugfs swap for sensor %d.\n",
+			 sensor->sensor_index);

-	retval = snprintf(fname, NAME_BUFFER_SIZE, "type_a.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_type_a = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &type_a_fops);
+	retval = snprintf(fname, NAME_BUFFER_SIZE, "type_a");
+	sensor->debugfs_type_a = debugfs_create_bool(fname, RMI_RW_ATTR,
+				sensor_root, &sensor->type_a);
 	if (!sensor->debugfs_type_a)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	return retval;
-}
-
-static void teardown_sensor_debugfs(struct f11_2d_sensor *sensor)
-{
-	if (sensor->debugfs_flip)
-		debugfs_remove(sensor->debugfs_flip);
+		dev_warn(&fn_dev->dev,
+			 "Failed to create debugfs type_a for sensor %d.\n",
+			 sensor->sensor_index);

-	if (sensor->debugfs_clip)
-		debugfs_remove(sensor->debugfs_clip);
-
-	if (sensor->debugfs_offset)
-		debugfs_remove(sensor->debugfs_offset);
-
-	if (sensor->debugfs_swap)
-		debugfs_remove(sensor->debugfs_swap);
-
-	if (sensor->debugfs_type_a)
-		debugfs_remove(sensor->debugfs_type_a);
+	return;
 }

 struct f11_debugfs_data {
 	bool done;
-	struct rmi_function *fn;
+	struct rmi_function_dev *fn_dev;
 };

 static int f11_debug_open(struct inode *inodep, struct file *filp)
 {
 	struct f11_debugfs_data *data;
-	struct rmi_function *fn = inodep->i_private;
+	struct rmi_function_dev *fn_dev = inodep->i_private;

-	data = devm_kzalloc(&fn->dev, sizeof(struct f11_debugfs_data),
+	data = devm_kzalloc(&fn_dev->dev, sizeof(struct f11_debugfs_data),
 		GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;

-	data->fn = fn;
+	data->fn_dev = fn_dev;
 	filp->private_data = data;
 	return 0;
 }
@@ -1482,7 +1048,7 @@ static ssize_t rezero_wait_read(struct file *filp, char __user *buffer,
 	int retval;
 	char *local_buf;
 	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fn->data;
+	struct f11_data *f11 = data->fn_dev->data;

 	if (data->done)
 		return 0;
@@ -1509,7 +1075,7 @@ static ssize_t rezero_wait_write(struct file *filp, const char __user *buffer,
 	char *local_buf;
 	int new_value;
 	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fn->data;
+	struct f11_data *f11 = data->fn_dev->data;

 	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
 	if (!local_buf)
@@ -1537,27 +1103,25 @@ static const struct file_operations rezero_wait_fops = {
 	.write = rezero_wait_write,
 };

-static int setup_f11_debugfs(struct rmi_function *fn)
+static inline int rmi_f11_setup_debugfs(struct rmi_function_dev *fn_dev)
 {
-	struct f11_data *f11 = fn->data;
+	struct f11_data *f11 = fn_dev->data;

-	if (!fn->debugfs_root)
+	if (!fn_dev->debugfs_root)
 		return -ENODEV;

 	f11->debugfs_rezero_wait = debugfs_create_file("rezero_wait",
-		RMI_RW_ATTR, fn->debugfs_root, fn, &rezero_wait_fops);
+		RMI_RW_ATTR, fn_dev->debugfs_root, fn_dev, &rezero_wait_fops);
 	if (!f11->debugfs_rezero_wait)
-		dev_warn(&fn->dev,
+		dev_warn(&fn_dev->dev,
 			 "Failed to create debugfs rezero_wait.\n");

 	return 0;
 }

-static void teardown_f11_debugfs(struct f11_data *f11)
-{
-	if (f11->debugfs_rezero_wait)
-		debugfs_remove(f11->debugfs_rezero_wait);
-}
+#else
+#define rmi_f11_setup_sensor_debugfs(s) 0
+#define rmi_f11_setup_debugfs(d) 0
 #endif
 /* End adding debugfs */

@@ -1688,7 +1252,7 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 		input_report_abs(sensor->input, ABS_MT_ORIENTATION, orient);
 		input_report_abs(sensor->input, ABS_MT_POSITION_X, x);
 		input_report_abs(sensor->input, ABS_MT_POSITION_Y, y);
-		dev_dbg(&sensor->fn->dev,
+		dev_dbg(&sensor->fn_dev->dev,
 			"finger[%d]:%d - x:%d y:%d z:%d w_max:%d w_min:%d\n",
 			n_finger, finger_state, x, y, z, w_max, w_min);
 	}
@@ -1724,7 +1288,7 @@ static void rmi_f11_finger_handler(struct f11_data *f11,
 		if (sensor->data.rel_pos)
 			rmi_f11_rel_pos_report(sensor, i);
 	}
-	input_mt_sync(sensor->input);
+	input_mt_sync_frame(sensor->input);
 	input_sync(sensor->input);
 }

@@ -1786,53 +1350,12 @@ static int f11_2d_construct_data(struct f11_2d_sensor *sensor)
 		i += (sensor->nbr_fingers * 2);
 	}

-	if (has_gesture_bits(&query->gesture_info, 0)) {
-		data->gest_1 = (struct f11_2d_data_8 *)&sensor->data_pkt[i];
-		i++;
-	}
-
-	if (has_gesture_bits(&query->gesture_info, 0) ||
-				has_gesture_bits(&query->gesture_info, 1)) {
-		data->gest_2 = (struct f11_2d_data_9 *)&sensor->data_pkt[i];
-		i++;
-	}
-
-	if (query->gesture_info.has_pinch) {
-		data->pinch = (struct f11_2d_data_10 *)&sensor->data_pkt[i];
-		i++;
-	}
-
-	if (query->gesture_info.has_flick) {
-		if (query->gesture_info.has_pinch) {
-			data->flick = (struct f11_2d_data_10_12 *)data->pinch;
-			i += 2;
-		} else {
-			data->flick = (struct f11_2d_data_10_12 *)
-					&sensor->data_pkt[i];
-			i += 3;
-		}
-	}
-
-	if (query->gesture_info.has_rotate) {
-		if (query->gesture_info.has_flick) {
-			data->rotate = (struct f11_2d_data_11_12 *)
-					(data->flick + 1);
-		} else {
-			data->rotate = (struct f11_2d_data_11_12 *)
-					&sensor->data_pkt[i];
-			i += 2;
-		}
-	}
-
-	if (query->gesture_info.has_touch_shapes)
-		data->shapes = (struct f11_2d_data_13 *)&sensor->data_pkt[i];
-
 	return 0;
 }

-static int f11_read_control_regs(struct rmi_function *fn,
+static int f11_read_control_regs(struct rmi_function_dev *fn_dev,
 				struct f11_2d_ctrl *ctrl, u16 ctrl_base_addr) {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
 	u16 read_address = ctrl_base_addr;
 	int error = 0;

@@ -1840,216 +1363,35 @@ static int f11_read_control_regs(struct rmi_function *fn,
 	error = rmi_read_block(rmi_dev, read_address, ctrl->ctrl0_9,
 		sizeof(*ctrl->ctrl0_9));
 	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read ctrl0, code: %d.\n", error);
+		dev_err(&fn_dev->dev, "Failed to read ctrl0, code: %d.\n",
+			error);
 		return error;
 	}
 	read_address += sizeof(*ctrl->ctrl0_9);

-	if (ctrl->ctrl10) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl10, sizeof(*ctrl->ctrl10));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl10, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl10);
-	}
-
-	if (ctrl->ctrl11) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl11, sizeof(*ctrl->ctrl11));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl11, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl11);
-	}
-
-	if (ctrl->ctrl14) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl14, sizeof(*ctrl->ctrl14));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl14, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl14);
-	}
-
-	if (ctrl->ctrl15) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl15, sizeof(*ctrl->ctrl15));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl15, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl15);
-	}
-
-	if (ctrl->ctrl16) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl16, sizeof(*ctrl->ctrl16));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl16, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl16);
-	}
-
-	if (ctrl->ctrl17) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl17, sizeof(*ctrl->ctrl17));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl17, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl17);
-	}
-
-	if (ctrl->ctrl18_19) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl18_19, sizeof(*ctrl->ctrl18_19));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl18_19, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl18_19);
-	}
-
-	if (ctrl->ctrl20_21) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl20_21, sizeof(*ctrl->ctrl20_21));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl20_21, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl20_21);
-	}
-
-	if (ctrl->ctrl22_26) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl22_26, sizeof(*ctrl->ctrl22_26));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl22_26, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl22_26);
-	}
-
-	if (ctrl->ctrl27) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl27, sizeof(*ctrl->ctrl27));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl27, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl27);
-	}
-
-	if (ctrl->ctrl28) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl28, sizeof(*ctrl->ctrl28));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl28, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl28);
-	}
-
-	if (ctrl->ctrl29_30) {
-		error = rmi_read_block(rmi_dev, read_address,
-			ctrl->ctrl29_30, sizeof(*ctrl->ctrl29_30));
-		if (error < 0) {
-			dev_err(&fn->dev,
-				"Failed to read ctrl29_30, code: %d.\n", error);
-			return error;
-		}
-		read_address += sizeof(*ctrl->ctrl29_30);
-	}
 	return 0;
 }

-static int f11_allocate_control_regs(struct rmi_function *fn,
+static int f11_allocate_control_regs(struct rmi_function_dev *fn_dev,
 				struct f11_2d_device_query *device_query,
 				struct f11_2d_sensor_queries *sensor_query,
 				struct f11_2d_ctrl *ctrl,
 				u16 ctrl_base_addr) {

-	ctrl->ctrl0_9 = devm_kzalloc(&fn->dev, sizeof(struct f11_2d_ctrl0_9),
-				       GFP_KERNEL);
+	ctrl->ctrl0_9 = devm_kzalloc(&fn_dev->dev,
+				     sizeof(struct f11_2d_ctrl0_9), GFP_KERNEL);
 	if (!ctrl->ctrl0_9)
 		return -ENOMEM;
-	if (has_gesture_bits(&sensor_query->gesture_info, 0)) {
-		ctrl->ctrl10 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl10), GFP_KERNEL);
-		if (!ctrl->ctrl10)
-			return -ENOMEM;
-	}
-
-	if (has_gesture_bits(&sensor_query->gesture_info, 1)) {
-		ctrl->ctrl11 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl11), GFP_KERNEL);
-		if (!ctrl->ctrl11)
-			return -ENOMEM;
-	}
-
-	if (device_query->has_query9 && sensor_query->query9.has_pen) {
-		ctrl->ctrl20_21 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl20_21), GFP_KERNEL);
-		if (!ctrl->ctrl20_21)
-			return -ENOMEM;
-	}
-
-	if (device_query->has_query9 && sensor_query->query9.has_proximity) {
-		ctrl->ctrl22_26 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl22_26), GFP_KERNEL);
-		if (!ctrl->ctrl22_26)
-			return -ENOMEM;
-	}
-
-	if (device_query->has_query9 &&
-		(sensor_query->query9.has_palm_det_sensitivity ||
-		sensor_query->query9.has_suppress_on_palm_detect)) {
-		ctrl->ctrl27 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl27), GFP_KERNEL);
-		if (!ctrl->ctrl27)
-			return -ENOMEM;
-	}
-
-	if (sensor_query->gesture_info.has_multi_finger_scroll) {
-		ctrl->ctrl28 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl28), GFP_KERNEL);
-		if (!ctrl->ctrl28)
-			return -ENOMEM;
-	}
-
-	if (device_query->has_query11 &&
-			sensor_query->features_1.has_z_tuning) {
-		ctrl->ctrl29_30 = devm_kzalloc(&fn->dev,
-			sizeof(struct f11_2d_ctrl29_30), GFP_KERNEL);
-		if (!ctrl->ctrl29_30)
-			return -ENOMEM;
-	}

 	return 0;
 }

-static int f11_write_control_regs(struct rmi_function *fn,
+static int f11_write_control_regs(struct rmi_function_dev *fn_dev,
 					struct f11_2d_sensor_queries *query,
 					struct f11_2d_ctrl *ctrl,
 					u16 ctrl_base_addr)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
 	u16 write_address = ctrl_base_addr;
 	int error;

@@ -2060,103 +1402,6 @@ static int f11_write_control_regs(struct rmi_function *fn,
 		return error;
 	write_address += sizeof(ctrl->ctrl0_9);

-	if (ctrl->ctrl10) {
-		error = rmi_write_block(rmi_dev, write_address,
-					ctrl->ctrl10, sizeof(*ctrl->ctrl10));
-		if (error < 0)
-			return error;
-		write_address++;
-	}
-
-	if (ctrl->ctrl11) {
-		error = rmi_write_block(rmi_dev, write_address,
-					ctrl->ctrl11, sizeof(*ctrl->ctrl11));
-		if (error < 0)
-			return error;
-		write_address++;
-	}
-
-	if (ctrl->ctrl14) {
-		error = rmi_write_block(rmi_dev, write_address,
-				ctrl->ctrl14, sizeof(ctrl->ctrl14));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl15);
-	}
-
-	if (ctrl->ctrl15) {
-		error = rmi_write_block(rmi_dev, write_address,
-				ctrl->ctrl15, sizeof(*ctrl->ctrl15));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl15);
-	}
-
-	if (ctrl->ctrl16) {
-		error = rmi_write_block(rmi_dev, write_address,
-				ctrl->ctrl16, sizeof(*ctrl->ctrl16));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl16);
-	}
-
-	if (ctrl->ctrl17) {
-		error = rmi_write_block(rmi_dev, write_address,
-				ctrl->ctrl17, sizeof(*ctrl->ctrl17));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl17);
-	}
-
-	if (ctrl->ctrl18_19) {
-		error = rmi_write_block(rmi_dev, write_address,
-			ctrl->ctrl18_19, sizeof(*ctrl->ctrl18_19));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl18_19);
-	}
-
-	if (ctrl->ctrl20_21) {
-		error = rmi_write_block(rmi_dev, write_address,
-			ctrl->ctrl20_21, sizeof(*ctrl->ctrl20_21));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl20_21);
-	}
-
-	if (ctrl->ctrl22_26) {
-		error = rmi_write_block(rmi_dev, write_address,
-			ctrl->ctrl22_26, sizeof(*ctrl->ctrl22_26));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl22_26);
-	}
-
-	if (ctrl->ctrl27) {
-		error = rmi_write_block(rmi_dev, write_address,
-			ctrl->ctrl27, sizeof(*ctrl->ctrl27));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl27);
-	}
-
-	if (ctrl->ctrl28) {
-		error = rmi_write_block(rmi_dev, write_address,
-			ctrl->ctrl28, sizeof(*ctrl->ctrl28));
-		if (error < 0)
-			return error;
-		write_address += sizeof(*ctrl->ctrl28);
-	}
-
-	if (ctrl->ctrl29_30) {
-		error = rmi_write_block(rmi_dev, write_address,
-					ctrl->ctrl29_30,
-					sizeof(struct f11_2d_ctrl29_30));
-		if (error < 0)
-			return error;
-		write_address += sizeof(struct f11_2d_ctrl29_30);
-	}
-
 	return 0;
 }

@@ -2259,9 +1504,9 @@ static int rmi_f11_get_query_parameters(struct rmi_device *rmi_dev,
 /* This operation is done in a number of places, so we have a handy routine
  * for it.
  */
-static void f11_set_abs_params(struct rmi_function *fn, int index)
+static void f11_set_abs_params(struct rmi_function_dev *fn_dev, int index)
 {
-	struct f11_data *f11 = fn->data;
+	struct f11_data *f11 = fn_dev->data;
 	struct f11_2d_sensor *sensor = &f11->sensors[index];
 	struct input_dev *input = sensor->input;
 	int device_x_max =
@@ -2304,7 +1549,7 @@ static void f11_set_abs_params(struct rmi_function *fn, int index)
 	else
 		y_max = device_y_max;

-	dev_dbg(&fn->dev, "Set ranges X=[%d..%d] Y=[%d..%d].",
+	dev_dbg(&fn_dev->dev, "Set ranges X=[%d..%d] Y=[%d..%d].",
 			x_min, x_max, y_min, y_max);

 	input_set_abs_params(input, ABS_MT_PRESSURE, 0,
@@ -2334,9 +1579,9 @@ static void f11_set_abs_params(struct rmi_function *fn, int index)
 				     0, MT_TOOL_FINGER, 0, 0);
 }

-static int rmi_f11_initialize(struct rmi_function *fn)
+static int rmi_f11_initialize(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
 	struct f11_data *f11;
 	struct f11_2d_ctrl *ctrl;
 	u8 query_offset;
@@ -2347,21 +1592,21 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 	int i;
 	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);

-	dev_dbg(&fn->dev, "Initializing F11 values for %s.\n",
+	dev_dbg(&fn_dev->dev, "Initializing F11 values for %s.\n",
 		 pdata->sensor_name);

 	/*
 	** init instance data, fill in values and create any sysfs files
 	*/
-	f11 = devm_kzalloc(&fn->dev, sizeof(struct f11_data), GFP_KERNEL);
+	f11 = devm_kzalloc(&fn_dev->dev, sizeof(struct f11_data), GFP_KERNEL);
 	if (!f11)
 		return -ENOMEM;

-	fn->data = f11;
+	fn_dev->data = f11;
 	f11->rezero_wait_ms = pdata->f11_rezero_wait;

-	query_base_addr = fn->fd.query_base_addr;
-	control_base_addr = fn->fd.control_base_addr;
+	query_base_addr = fn_dev->fd.query_base_addr;
+	control_base_addr = fn_dev->fd.control_base_addr;

 	rc = rmi_read(rmi_dev, query_base_addr, &f11->dev_query);
 	if (rc < 0)
@@ -2372,7 +1617,7 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
 		struct f11_2d_sensor *sensor = &f11->sensors[i];
 		sensor->sensor_index = i;
-		sensor->fn = fn;
+		sensor->fn_dev = fn_dev;

 		rc = rmi_f11_get_query_parameters(rmi_dev, &f11->dev_query,
 				&sensor->sens_query, query_offset);
@@ -2380,19 +1625,19 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 			return rc;
 		query_offset += rc;

-		rc = f11_allocate_control_regs(fn,
+		rc = f11_allocate_control_regs(fn_dev,
 				&f11->dev_query, &sensor->sens_query,
 				&f11->dev_controls, control_base_addr);
 		if (rc < 0) {
-			dev_err(&fn->dev,
+			dev_err(&fn_dev->dev,
 				"Failed to allocate F11 control params.\n");
 			return rc;
 		}

-		rc = f11_read_control_regs(fn, &f11->dev_controls,
+		rc = f11_read_control_regs(fn_dev, &f11->dev_controls,
 				control_base_addr);
 		if (rc < 0) {
-			dev_err(&fn->dev,
+			dev_err(&fn_dev->dev,
 				"Failed to read F11 control params.\n");
 			return rc;
 		}
@@ -2438,7 +1683,7 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 					ctrl->ctrl0_9,
 					sizeof(*ctrl->ctrl0_9));
 			if (rc < 0)
-				dev_warn(&fn->dev, "Failed to write to delta_x_threshold %d. Code: %d.\n",
+				dev_warn(&fn_dev->dev, "Failed to write to delta_x_threshold %d. Code: %d.\n",
 					i, rc);

 		}
@@ -2451,33 +1696,24 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 					ctrl->ctrl0_9,
 					sizeof(*ctrl->ctrl0_9));
 			if (rc < 0)
-				dev_warn(&fn->dev, "Failed to write to delta_y_threshold %d. Code: %d.\n",
+				dev_warn(&fn_dev->dev, "Failed to write to delta_y_threshold %d. Code: %d.\n",
 					i, rc);
 		}

-		if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-			rc = setup_sensor_debugfs(sensor);
-			if (rc < 0)
-				dev_warn(&fn->dev, "Failed to setup debugfs for F11 sensor %d. Code: %d.\n",
-					i, rc);
-		}
-	}
+		rmi_f11_setup_sensor_debugfs(sensor);

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		rc = setup_f11_debugfs(fn);
-		if (rc < 0)
-			dev_warn(&fn->dev, "Failed to setup debugfs for F11. Code: %d.\n",
-				rc);
 	}

+	rmi_f11_setup_debugfs(fn_dev);
+
 	mutex_init(&f11->dev_controls_mutex);
 	return 0;
 }

-static int rmi_f11_register_devices(struct rmi_function *fn)
+static int rmi_f11_register_devices(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f11_data *f11 = fn->data;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f11_data *f11 = fn_dev->data;
 	struct input_dev *input_dev;
 	struct input_dev *input_dev_mouse;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
@@ -2503,14 +1739,14 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
 		if (driver->set_input_params) {
 			rc = driver->set_input_params(rmi_dev, input_dev);
 			if (rc < 0) {
-				dev_err(&fn->dev,
+				dev_err(&fn_dev->dev,
 				"%s: Error in setting input device.\n",
 				__func__);
 				goto error_unregister;
 			}
 		}
 		sprintf(sensor->input_phys, "%s.abs%d/input0",
-			dev_name(&fn->dev), i);
+			dev_name(&fn_dev->dev), i);
 		input_dev->phys = sensor->input_phys;
 		input_dev->dev.parent = &rmi_dev->dev;
 		input_set_drvdata(input_dev, f11);
@@ -2519,7 +1755,7 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
 		set_bit(EV_ABS, input_dev->evbit);
 		input_set_capability(input_dev, EV_KEY, BTN_TOUCH);

-		f11_set_abs_params(fn, i);
+		f11_set_abs_params(fn_dev, i);

 		if (sensor->sens_query.info.has_rel) {
 			set_bit(EV_REL, input_dev->evbit);
@@ -2546,14 +1782,14 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
 				rc = driver->set_input_params(rmi_dev,
 					input_dev_mouse);
 				if (rc < 0) {
-					dev_err(&fn->dev,
+					dev_err(&fn_dev->dev,
 					"%s: Error in setting input device.\n",
 					__func__);
 					goto error_unregister;
 				}
 			}
 			sprintf(sensor->input_phys_mouse, "%s.rel%d/input0",
-				dev_name(&fn->dev), i);
+				dev_name(&fn_dev->dev), i);
 			set_bit(EV_REL, input_dev_mouse->evbit);
 			set_bit(REL_X, input_dev_mouse->relbit);
 			set_bit(REL_Y, input_dev_mouse->relbit);
@@ -2595,9 +1831,9 @@ error_unregister:
 	return rc;
 }

-static void rmi_f11_free_devices(struct rmi_function *fn)
+static void rmi_f11_free_devices(struct rmi_function_dev *fn_dev)
 {
-	struct f11_data *f11 = fn->data;
+	struct f11_data *f11 = fn_dev->data;
 	int i;

 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
@@ -2608,38 +1844,24 @@ static void rmi_f11_free_devices(struct rmi_function *fn)
 	}
 }

-static int rmi_f11_create_sysfs(struct rmi_function *fn)
+static int rmi_f11_create_sysfs(struct rmi_function_dev *fn_dev)
 {
-	int attr_count = 0;
-	int rc;
-
-	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
-		if (sysfs_create_file
-		    (&fn->dev.kobj, &attrs[attr_count].attr) < 0) {
-			dev_err(&fn->dev, "Failed to create sysfs file for %s.",
-				attrs[attr_count].attr.name);
-			rc = -ENODEV;
-			goto err_remove_sysfs;
-		}
+	if (sysfs_create_group(&fn_dev->dev.kobj, &fn11_attrs) < 0) {
+		dev_err(&fn_dev->dev, "Failed to create query sysfs files.");
+		return -ENODEV;
 	}
-
 	return 0;
-
-err_remove_sysfs:
-	for (attr_count--; attr_count >= 0; attr_count--)
-		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
-	return rc;
 }

-static int rmi_f11_config(struct rmi_function *fn)
+static int rmi_f11_config(struct rmi_function_dev *fn_dev)
 {
-	struct f11_data *f11 = fn->data;
+	struct f11_data *f11 = fn_dev->data;
 	int i;
 	int rc;

 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
-		rc = f11_write_control_regs(fn, &f11->sensors[i].sens_query,
-				   &f11->dev_controls, fn->fd.query_base_addr);
+		rc = f11_write_control_regs(fn_dev, &f11->sensors[i].sens_query,
+				&f11->dev_controls, fn_dev->fd.query_base_addr);
 		if (rc < 0)
 			return rc;
 	}
@@ -2647,12 +1869,12 @@ static int rmi_f11_config(struct rmi_function *fn)
 	return 0;
 }

-int rmi_f11_attention(struct rmi_function *fn,
+int rmi_f11_attention(struct rmi_function_dev *fn_dev,
 						unsigned long *irq_bits)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f11_data *f11 = fn->data;
-	u16 data_base_addr = fn->fd.data_base_addr;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f11_data *f11 = fn_dev->data;
+	u16 data_base_addr = fn_dev->fd.data_base_addr;
 	u16 data_base_addr_offset = 0;
 	int error;
 	int i;
@@ -2673,26 +1895,26 @@ int rmi_f11_attention(struct rmi_function *fn,
 }

 #ifdef CONFIG_PM
-static int rmi_f11_resume(struct rmi_function *fn)
+static int rmi_f11_resume(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f11_data *data = fn->data;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f11_data *data = fn_dev->data;
 	/* Command register always reads as 0, so we can just use a local. */
 	struct f11_2d_commands commands = {
 		.rezero = true,
 	};
 	int retval = 0;

-	dev_dbg(&fn->dev, "Resuming...\n");
+	dev_dbg(&fn_dev->dev, "Resuming...\n");
 	if (!data->rezero_wait_ms)
 		return 0;

 	mdelay(data->rezero_wait_ms);

-	retval = rmi_write_block(rmi_dev, fn->fd.command_base_addr,
+	retval = rmi_write_block(rmi_dev, fn_dev->fd.command_base_addr,
 			&commands, sizeof(commands));
 	if (retval < 0) {
-		dev_err(&fn->dev, "%s: failed to issue rezero command, error = %d.",
+		dev_err(&fn_dev->dev, "%s: failed to issue rezero command, error = %d.",
 			__func__, retval);
 		return retval;
 	}
@@ -2701,62 +1923,47 @@ static int rmi_f11_resume(struct rmi_function *fn)
 }
 #endif /* CONFIG_PM */

-static int rmi_f11_probe(struct rmi_function *fn)
+static int rmi_f11_remove(struct rmi_function_dev *fn_dev)
+{
+	debugfs_remove_recursive(fn_dev->debugfs_root);
+	sysfs_remove_group(&fn_dev->dev.kobj, &fn11_attrs);
+
+	rmi_f11_free_devices(fn_dev);
+	return 0;
+}
+
+static int rmi_f11_probe(struct rmi_function_dev *fn_dev)
 {
 	int rc;

-	rc = rmi_f11_initialize(fn);
+	rc = rmi_f11_initialize(fn_dev);
 	if (rc < 0)
 		return rc;

-	rc = rmi_f11_register_devices(fn);
+	rc = rmi_f11_register_devices(fn_dev);
 	if (rc < 0)
 		return rc;

-	rc = rmi_f11_create_sysfs(fn);
+	rc = rmi_f11_create_sysfs(fn_dev);
 	if (rc < 0)
 		return rc;

 	return 0;
 }

-static void rmi_f11_remove(struct rmi_function *fn)
-{
-	struct f11_data *f11 = fn->data;
-	int attr_count = 0;
-
-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		int i;
-
-		for (i = 0; i < f11->dev_query.nbr_of_sensors + 1; i++)
-			teardown_sensor_debugfs(&f11->sensors[i]);
-		teardown_f11_debugfs(f11);
-	}
-
-	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
-		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
-
-	rmi_f11_free_devices(fn);
-}
-
-
-static struct rmi_function_handler rmi_f11_handler = {
+static struct rmi_function_driver function_driver = {
 	.driver = {
 		.name = "rmi_f11",
 	},
-	.func = 0x11,
+	.func = FUNCTION_NUMBER,
 	.probe = rmi_f11_probe,
 	.remove = rmi_f11_remove,
 	.config = rmi_f11_config,
 	.attention = rmi_f11_attention,
-#ifdef CONFIG_HAS_EARLYSUSPEND
-	.late_resume = rmi_f11_resume
-#elif defined(CONFIG_PM)
 	.resume = rmi_f11_resume
-#endif  /* defined(CONFIG_HAS_EARLYSUSPEND) */
 };

-module_rmi_driver(rmi_f11_handler);
+module_rmi_function_driver(function_driver);

 MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com");
 MODULE_DESCRIPTION("RMI F11 module");
