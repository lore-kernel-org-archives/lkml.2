Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2K1Fl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:41:58 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59944 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2K1Flx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:41:53 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 1/2] Input: RMI4 - rework F11 sysfs and debugfs attributes
Date: Tue, 27 Nov 2012 21:41:47 -0800
Message-Id: <1354081308-21636-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid rolling our own debugfs operations and use the standar ones instead.
Also switch to using attribute groups to create sysfs attributes.

The max_x and max_y can be retrieced via EVIOGABS and so attributes moved
over to debugfs.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f11.c | 918 +++++++++----------------------------------
 include/linux/rmi.h          |  20 +-
 2 files changed, 186 insertions(+), 752 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index 8457ab4..717e2d8 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -20,6 +20,7 @@
 #define FUNCTION_DATA f11_data
 
 #include <linux/kernel.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/input.h>
@@ -29,12 +30,6 @@
 #include <linux/slab.h>
 #include "rmi_driver.h"
 
-#ifdef CONFIG_RMI4_DEBUG
-#include <linux/debugfs.h>
-#include <linux/fs.h>
-#include <linux/uaccess.h>
-#endif
-
 #define F11_MAX_NUM_OF_SENSORS		8
 #define F11_MAX_NUM_OF_FINGERS		10
 #define F11_MAX_NUM_OF_TOUCH_SHAPES	16
@@ -787,19 +782,7 @@ struct f11_2d_data {
  * @input - input device for absolute pointing stream
  * @mouse_input - input device for relative pointing stream.
  * @input_phys - buffer for the absolute phys name for this sensor.
- * @input_mouse_phys - buffer for the relative phys name for this sensor.
- * @debugfs_flip - inverts one or both axes.  Useful in prototyping new
- * systems.
- * @debugfs_flip - coordinate clipping range for one or both axes.  Useful in
- * prototyping new systems.
- * @debugfs_delta_threshold - adjusts motion sensitivity for relative reports
- * and (in reduced reporting mode) absolute reports.  Useful in prototyping new
- * systems.
- * @debugfs_offset - offsets one or both axes.  Useful in prototyping new
- * systems.
- * @debugfs_swap - swaps X and Y axes.  Useful in prototyping new systems.
- * @debugfs_type_a - forces type A behavior.  Useful in bringing up old systems
- * when you're not sure if you've got a Type A or Type B sensor.
+ * @input_phys_mouse - buffer for the relative phys name for this sensor.
  */
 struct f11_2d_sensor {
 	struct rmi_f11_2d_axis_alignment axis_align;
@@ -811,22 +794,13 @@ struct f11_2d_sensor {
 	u8 *data_pkt;
 	int pkt_size;
 	u8 sensor_index;
-	bool type_a;
+	u32 type_a;	/* boolean but debugfs API requires u32 */
 	enum rmi_f11_sensor_type sensor_type;
 	struct input_dev *input;
 	struct input_dev *mouse_input;
 	struct rmi_function *fn;
 	char input_phys[NAME_BUFFER_SIZE];
 	char input_phys_mouse[NAME_BUFFER_SIZE];
-
-#ifdef CONFIG_RMI4_DEBUG
-	struct dentry *debugfs_flip;
-	struct dentry *debugfs_clip;
-	struct dentry *debugfs_delta_threshold;
-	struct dentry *debugfs_offset;
-	struct dentry *debugfs_swap;
-	struct dentry *debugfs_type_a;
-#endif
 };
 
 /** Data pertaining to F11 in general.  For per-sensor data, see struct
@@ -849,10 +823,6 @@ struct f11_data {
 	struct mutex dev_controls_mutex;
 	u16 rezero_wait_ms;
 	struct f11_2d_sensor sensors[F11_MAX_NUM_OF_SENSORS];
-
-#ifdef CONFIG_RMI4_DEBUG
-	struct dentry *debugfs_rezero_wait;
-#endif
 };
 
 enum finger_state_values {
@@ -862,71 +832,56 @@ enum finger_state_values {
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
+static ssize_t rmi_f11_relreport_show(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
 {
-	struct rmi_function *fn;
-	struct f11_data *instance_data;
-
-	fn = to_rmi_function(dev);
-	instance_data = fn->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f11_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			instance_data->
-			sensors[0].axis_align.rel_report_enabled);
+			data->sensors[0].axis_align.rel_report_enabled);
 }
 
-static ssize_t f11_relreport_store(struct device *dev,
-					 struct device_attribute *attr,
-					 const char *buf,
-					 size_t count)
+static ssize_t rmi_f11_relreport_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf,
+				       size_t count)
 {
-	struct rmi_function *fn;
-	struct f11_data *instance_data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f11_data *data = fn->data;
 	unsigned int new_value;
+	int error;
 
-	fn = to_rmi_function(dev);
-	instance_data = fn->data;
-
+	error = kstrtouint(buf, 0, &new_value);
+	if (error)
+		return error;
 
-	if (sscanf(buf, "%u", &new_value) != 1)
-		return -EINVAL;
 	if (new_value > 1)
-		return -EINVAL;
-	instance_data->sensors[0].axis_align.rel_report_enabled = new_value;
+		return -ERANGE;
+
+	data->sensors[0].axis_align.rel_report_enabled = new_value;
 
 	return count;
 }
 
-static ssize_t f11_rezero_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
+static DEVICE_ATTR(relreport, RMI_RW_ATTR,
+		   rmi_f11_relreport_show, rmi_f11_relreport_store);
+
+static ssize_t rmi_f11_rezero_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
 {
-	struct rmi_function *fn = NULL;
+	struct rmi_function *fn = to_rmi_function(dev);
 	unsigned int rezero;
-	int retval = 0;
+	int error;
 
-	fn = to_rmi_function(dev);
+	error = kstrtouint(buf, 0, &rezero);
+	if (error)
+		return error;
 
-	if (sscanf(buf, "%u", &rezero) != 1)
-		return -EINVAL;
 	if (rezero > 1)
-		return -EINVAL;
+		return -ERANGE;
 
 	/* Per spec, 0 has no effect, so we skip it entirely. */
 	if (rezero) {
@@ -935,628 +890,152 @@ static ssize_t f11_rezero_store(struct device *dev,
 			.rezero = true,
 		};
 
-		retval = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
-				&commands, sizeof(commands));
-		if (retval < 0) {
-			dev_err(dev, "%s: failed to issue rezero command, error = %d.",
-				__func__, retval);
-			return retval;
+		error = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
+					&commands, sizeof(commands));
+		if (error < 0) {
+			dev_err(dev,
+				"%s: failed to issue rezero command, error = %d.",
+				__func__, error);
+			return error;
 		}
 	}
 
 	return count;
 }
 
-static struct device_attribute attrs[] = {
-	__ATTR(relreport, RMI_RW_ATTR, f11_relreport_show, f11_relreport_store),
-	__ATTR(maxPos, RMI_RO_ATTR, f11_maxPos_show, NULL),
-	__ATTR(rezero, RMI_WO_ATTR, NULL, f11_rezero_store)
-};
-
-#ifdef CONFIG_RMI4_DEBUG
-
-struct sensor_debugfs_data {
-	bool done;
-	struct f11_2d_sensor *sensor;
-};
-
-static int sensor_debug_open(struct inode *inodep, struct file *filp)
-{
-	struct sensor_debugfs_data *data;
-	struct f11_2d_sensor *sensor = inodep->i_private;
-
-	data = kzalloc(sizeof(struct sensor_debugfs_data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->sensor = sensor;
-	filp->private_data = data;
-	return 0;
-}
-
-static int sensor_debug_release(struct inode *inodep, struct file *filp)
-{
-	kfree(filp->private_data);
-	return 0;
-}
-
-static ssize_t flip_read(struct file *filp, char __user *buffer, size_t size,
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
-	retval = snprintf(local_buf, size, "%u %u\n",
-			data->sensor->axis_align.flip_x,
-			data->sensor->axis_align.flip_y);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t flip_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	unsigned int new_X;
-	unsigned int new_Y;
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
-
-	retval = sscanf(local_buf, "%u %u", &new_X, &new_Y);
-	kfree(local_buf);
-	if (retval != 2 || new_X > 1 || new_Y > 1)
-		return -EINVAL;
-
-	data->sensor->axis_align.flip_x = new_X;
-	data->sensor->axis_align.flip_y = new_Y;
-
-	return size;
-}
-
-static const struct file_operations flip_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = flip_read,
-	.write = flip_write,
-};
-
-static ssize_t delta_threshold_read(struct file *filp, char __user *buffer,
-		size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fn->data;
-	struct f11_2d_ctrl *ctrl = &f11->dev_controls;
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
-	retval = snprintf(local_buf, size, "%u %u\n",
-			ctrl->ctrl0_9->delta_x_threshold,
-			ctrl->ctrl0_9->delta_y_threshold);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-
-}
-
-static ssize_t delta_threshold_write(struct file *filp,
-		const char __user *buffer, size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	unsigned int new_X, new_Y;
-	u8 save_X, save_Y;
-	int rc;
-	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fn->data;
-	struct f11_2d_ctrl *ctrl = &f11->dev_controls;
-	struct rmi_device *rmi_dev =  data->sensor->fn->rmi_dev;
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
-
-	retval = sscanf(local_buf, "%u %u", &new_X, &new_Y);
-	kfree(local_buf);
-	if (retval != 2 || new_X > 1 || new_Y > 1)
-		return -EINVAL;
-
-	save_X = ctrl->ctrl0_9->delta_x_threshold;
-	save_Y = ctrl->ctrl0_9->delta_y_threshold;
-
-	ctrl->ctrl0_9->delta_x_threshold = new_X;
-	ctrl->ctrl0_9->delta_y_threshold = new_Y;
-	rc = rmi_write_block(rmi_dev, ctrl->ctrl0_9_address,
-			ctrl->ctrl0_9, sizeof(*ctrl->ctrl0_9));
-	if (rc < 0) {
-		dev_warn(&data->sensor->fn->dev,
-			"Failed to write to delta_threshold. Code: %d.\n",
-			rc);
-		ctrl->ctrl0_9->delta_x_threshold = save_X;
-		ctrl->ctrl0_9->delta_y_threshold = save_Y;
-	}
-
-	return size;
-}
-
-static const struct file_operations delta_threshold_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = delta_threshold_read,
-	.write = delta_threshold_write,
-};
-
-static ssize_t offset_read(struct file *filp, char __user *buffer, size_t size,
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
-	retval = snprintf(local_buf, size, "%u %u\n",
-			data->sensor->axis_align.offset_X,
-			data->sensor->axis_align.offset_Y);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t offset_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
-{
-	int retval;
-	char *local_buf;
-	int new_X;
-	int new_Y;
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
-	retval = sscanf(local_buf, "%u %u", &new_X, &new_Y);
-	kfree(local_buf);
-	if (retval != 2)
-		return -EINVAL;
-
-	data->sensor->axis_align.offset_X = new_X;
-	data->sensor->axis_align.offset_Y = new_Y;
-
-	return size;
-}
-
-static const struct file_operations offset_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = offset_read,
-	.write = offset_write,
-};
-
-static ssize_t clip_read(struct file *filp, char __user *buffer, size_t size,
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
-	retval = snprintf(local_buf, size, "%u %u %u %u\n",
-			data->sensor->axis_align.clip_X_low,
-			data->sensor->axis_align.clip_X_high,
-			data->sensor->axis_align.clip_Y_low,
-			data->sensor->axis_align.clip_Y_high);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t clip_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
-{
-	int retval;
-	char *local_buf;
-	unsigned int new_X_low, new_X_high, new_Y_low, new_Y_high;
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
-
-	retval = sscanf(local_buf, "%u %u %u %u",
-		&new_X_low, &new_X_high, &new_Y_low, &new_Y_high);
-	kfree(local_buf);
-	if (retval != 4)
-		return -EINVAL;
-
-	if (new_X_low >= new_X_high || new_Y_low >= new_Y_high)
-		return -EINVAL;
-
-	data->sensor->axis_align.clip_X_low = new_X_low;
-	data->sensor->axis_align.clip_X_high = new_X_high;
-	data->sensor->axis_align.clip_Y_low = new_Y_low;
-	data->sensor->axis_align.clip_Y_high = new_Y_high;
-
-	return size;
-}
-
-static const struct file_operations clip_fops = {
-	.owner = THIS_MODULE,
-	.open = sensor_debug_open,
-	.release = sensor_debug_release,
-	.read = clip_read,
-	.write = clip_write,
-};
-
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
+static DEVICE_ATTR(rezero, RMI_WO_ATTR, NULL, rmi_f11_rezero_store);
 
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t swap_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
-{
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
+static struct attribute *rmi_f11_attrs[] = {
+	&dev_attr_relreport.attr,
+	&dev_attr_rezero.attr,
+	NULL
 };
 
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
-
-static ssize_t type_a_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
-{
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
-
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
+static struct attribute_group rmi_f11_attr_group = {
+	.attrs = rmi_f11_attrs,
 };
 
-static int setup_sensor_debugfs(struct f11_2d_sensor *sensor)
+#ifdef CONFIG_RMI4_DEBUG
+static void rmi_f11_setup_sensor_debugfs(struct f11_2d_sensor *sensor)
 {
-	int retval = 0;
-	char fname[NAME_BUFFER_SIZE];
 	struct rmi_function *fn = sensor->fn;
+	struct dentry *sensor_root;
+	char dirname[sizeof("sensorNNN")];
 
 	if (!fn->debugfs_root)
-		return -ENODEV;
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "flip.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_flip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &flip_fops);
-	if (!sensor->debugfs_flip)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "clip.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &clip_fops);
-	if (!sensor->debugfs_clip)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "delta_threshold.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor,
-				&delta_threshold_fops);
-	if (!sensor->debugfs_delta_threshold)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "offset.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_offset = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &offset_fops);
-	if (!sensor->debugfs_offset)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "swap.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_swap = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &swap_fops);
-	if (!sensor->debugfs_swap)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	retval = snprintf(fname, NAME_BUFFER_SIZE, "type_a.%d",
-			  sensor->sensor_index);
-	sensor->debugfs_type_a = debugfs_create_file(fname, RMI_RW_ATTR,
-				fn->debugfs_root, sensor, &type_a_fops);
-	if (!sensor->debugfs_type_a)
-		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
-			 fname);
-
-	return retval;
-}
+		return;
 
-static void teardown_sensor_debugfs(struct f11_2d_sensor *sensor)
-{
-	if (sensor->debugfs_flip)
-		debugfs_remove(sensor->debugfs_flip);
-
-	if (sensor->debugfs_clip)
-		debugfs_remove(sensor->debugfs_clip);
+	snprintf(dirname, sizeof(dirname), "input%3u", sensor->sensor_index);
+	sensor_root = debugfs_create_dir(dirname, fn->debugfs_root);
+	if (!sensor_root) {
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs directory %s for sensor %d\n",
+			 dirname, sensor->sensor_index);
+		return;
+	}
 
-	if (sensor->debugfs_offset)
-		debugfs_remove(sensor->debugfs_offset);
+	if (!debugfs_create_bool("type_a", RMI_RW_ATTR, sensor_root,
+				 &sensor->type_a))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs type_a for sensor %d.\n",
+			 sensor->sensor_index);
 
-	if (sensor->debugfs_swap)
-		debugfs_remove(sensor->debugfs_swap);
+	if (!debugfs_create_u16("max_x", RMI_RW_ATTR, sensor_root,
+				&sensor->max_x))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs max_x for sensor %d.\n",
+			 sensor->sensor_index);
 
-	if (sensor->debugfs_type_a)
-		debugfs_remove(sensor->debugfs_type_a);
-}
+	if (!debugfs_create_u16("max_xy", RMI_RW_ATTR, sensor_root,
+				&sensor->max_y))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs max_y for sensor %d.\n",
+			 sensor->sensor_index);
 
-struct f11_debugfs_data {
-	bool done;
-	struct rmi_function *fn;
-};
+	if (!debugfs_create_bool("flip_x", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.flip_x))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs flip_x for sensor %d.\n",
+			 sensor->sensor_index);
 
-static int f11_debug_open(struct inode *inodep, struct file *filp)
-{
-	struct f11_debugfs_data *data;
-	struct rmi_function *fn = inodep->i_private;
+	if (!debugfs_create_bool("flip_y", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.flip_y))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs flip_y for sensor %d.\n",
+			 sensor->sensor_index);
 
-	data = devm_kzalloc(&fn->dev, sizeof(struct f11_debugfs_data),
-		GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!debugfs_create_u16("clip_x_low", RMI_RW_ATTR, sensor_root,
+				&sensor->axis_align.clip_x_low))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs clip_x_low for sensor %d.\n",
+			 sensor->sensor_index);
 
-	data->fn = fn;
-	filp->private_data = data;
-	return 0;
-}
+	if (!debugfs_create_u16("clip_x_high", RMI_RW_ATTR, sensor_root,
+				&sensor->axis_align.clip_x_high))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs clip_x_high for sensor %d.\n",
+			 sensor->sensor_index);
 
-static ssize_t rezero_wait_read(struct file *filp, char __user *buffer,
-		size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fn->data;
+	if (!debugfs_create_u16("clip_y_low", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.clip_y_low))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs clip_y_low for sensor %d.\n",
+			 sensor->sensor_index);
 
-	if (data->done)
-		return 0;
+	if (!debugfs_create_u16("clip_y_high", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.clip_y_high))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs clip_y_high for sensor %d.\n",
+			 sensor->sensor_index);
 
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
+	if (!debugfs_create_u8("delta_x_threshold", RMI_RW_ATTR, sensor_root,
+				&sensor->axis_align.delta_x_threshold))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs delta_x_threshold for sensor %d.\n",
+			 sensor->sensor_index);
 
-	data->done = 1;
+	if (!debugfs_create_u8("delta_y_threshold", RMI_RW_ATTR, sensor_root,
+				&sensor->axis_align.delta_y_threshold))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs delta_y_threshold for sensor %d.\n",
+			 sensor->sensor_index);
 
-	retval = snprintf(local_buf, size, "%u\n", f11->rezero_wait_ms);
+	if (!debugfs_create_u16("offset_x", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.offset_x))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs offset_x for sensor %d.\n",
+			 sensor->sensor_index);
 
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
+	if (!debugfs_create_u16("offset_x", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.offset_x))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs offset_y for sensor %d.\n",
+			 sensor->sensor_index);
 
-	return retval;
+	if (!debugfs_create_bool("swap", RMI_RW_ATTR, sensor_root,
+				 &sensor->axis_align.swap_axes))
+		dev_warn(&fn->dev,
+			 "Failed to create debugfs swap for sensor %d.\n",
+			 sensor->sensor_index);
 }
 
-static ssize_t rezero_wait_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset)
+static void rmi_f11_setup_debugfs(struct rmi_function *fn)
 {
-	int retval;
-	char *local_buf;
-	int new_value;
-	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fn->data;
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
-
-	retval = sscanf(local_buf, "%u", &new_value);
-	kfree(local_buf);
-	if (retval != 1 || new_value > 65535)
-		return -EINVAL;
+	struct f11_data *f11 = fn->data;
 
-	f11->rezero_wait_ms = new_value;
-	return size;
+	if (fn->debugfs_root)
+		if (!debugfs_create_u16("rezero_wait", RMI_RW_ATTR,
+					fn->debugfs_root,
+					&f11->rezero_wait_ms))
+			dev_warn(&fn->dev,
+				 "Failed to create debugfs rezero_wait.\n");
 }
-
-static const struct file_operations rezero_wait_fops = {
-	.owner = THIS_MODULE,
-	.open = f11_debug_open,
-	.read = rezero_wait_read,
-	.write = rezero_wait_write,
-};
-
-static int setup_f11_debugfs(struct rmi_function *fn)
+#else
+static inline void rmi_f11_setup_sensor_debugfs(struct f11_2d_sensor *sensor)
 {
-	struct f11_data *f11 = fn->data;
-
-	if (!fn->debugfs_root)
-		return -ENODEV;
-
-	f11->debugfs_rezero_wait = debugfs_create_file("rezero_wait",
-		RMI_RW_ATTR, fn->debugfs_root, fn, &rezero_wait_fops);
-	if (!f11->debugfs_rezero_wait)
-		dev_warn(&fn->dev,
-			 "Failed to create debugfs rezero_wait.\n");
-
-	return 0;
 }
-
-static void teardown_f11_debugfs(struct f11_data *f11)
+static inline void rmi_f11_setup_debugfs(struct rmi_function *fn)
 {
-	if (f11->debugfs_rezero_wait)
-		debugfs_remove(f11->debugfs_rezero_wait);
 }
 #endif
 /* End adding debugfs */
@@ -1611,7 +1090,7 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 {
 	struct f11_2d_data *data = &sensor->data;
 	struct rmi_f11_2d_axis_alignment *axis_align = &sensor->axis_align;
-	int x, y, z;
+	u16 x, y, z;
 	int w_x, w_y, w_max, w_min, orient;
 	int temp;
 
@@ -1651,14 +1130,14 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 		* or we could get funny values that are outside
 		* clipping boundaries.
 		*/
-		x += axis_align->offset_X;
-		y += axis_align->offset_Y;
-		x =  max(axis_align->clip_X_low, x);
-		y =  max(axis_align->clip_Y_low, y);
-		if (axis_align->clip_X_high)
-			x = min(axis_align->clip_X_high, x);
-		if (axis_align->clip_Y_high)
-			y =  min(axis_align->clip_Y_high, y);
+		x += axis_align->offset_x;
+		y += axis_align->offset_y;
+		x =  max(axis_align->clip_x_low, x);
+		y =  max(axis_align->clip_y_low, y);
+		if (axis_align->clip_x_high)
+			x = min(axis_align->clip_x_high, x);
+		if (axis_align->clip_y_high)
+			y =  min(axis_align->clip_y_high, y);
 
 	}
 
@@ -2264,11 +1743,11 @@ static void f11_set_abs_params(struct rmi_function *fn, int index)
 	struct f11_data *f11 = fn->data;
 	struct f11_2d_sensor *sensor = &f11->sensors[index];
 	struct input_dev *input = sensor->input;
-	int device_x_max =
+	u16 device_x_max =
 		f11->dev_controls.ctrl0_9->sensor_max_x_pos;
-	int device_y_max =
+	u16 device_y_max =
 		f11->dev_controls.ctrl0_9->sensor_max_y_pos;
-	int x_min, x_max, y_min, y_max;
+	u16 x_min, x_max, y_min, y_max;
 	unsigned int input_flags;
 
 	/* We assume touchscreen unless demonstrably a touchpad or specified
@@ -2290,17 +1769,17 @@ static void f11_set_abs_params(struct rmi_function *fn, int index)
 	/* Use the max X and max Y read from the device, or the clip values,
 	 * whichever is stricter.
 	 */
-	x_min = sensor->axis_align.clip_X_low;
-	if (sensor->axis_align.clip_X_high)
-		x_max = min((int) device_x_max,
-			sensor->axis_align.clip_X_high);
+	x_min = sensor->axis_align.clip_x_low;
+	if (sensor->axis_align.clip_x_high)
+		x_max = min(device_x_max,
+			sensor->axis_align.clip_x_high);
 	else
 		x_max = device_x_max;
 
-	y_min = sensor->axis_align.clip_Y_low;
-	if (sensor->axis_align.clip_Y_high)
-		y_max = min((int) device_y_max,
-			sensor->axis_align.clip_Y_high);
+	y_min = sensor->axis_align.clip_y_low;
+	if (sensor->axis_align.clip_y_high)
+		y_max = min(device_y_max,
+			sensor->axis_align.clip_y_high);
 	else
 		y_max = device_y_max;
 
@@ -2455,20 +1934,10 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 					i, rc);
 		}
 
-		if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-			rc = setup_sensor_debugfs(sensor);
-			if (rc < 0)
-				dev_warn(&fn->dev, "Failed to setup debugfs for F11 sensor %d. Code: %d.\n",
-					i, rc);
-		}
+		rmi_f11_setup_sensor_debugfs(sensor);
 	}
 
-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		rc = setup_f11_debugfs(fn);
-		if (rc < 0)
-			dev_warn(&fn->dev, "Failed to setup debugfs for F11. Code: %d.\n",
-				rc);
-	}
+	rmi_f11_setup_debugfs(fn);
 
 	mutex_init(&f11->dev_controls_mutex);
 	return 0;
@@ -2608,29 +2077,6 @@ static void rmi_f11_free_devices(struct rmi_function *fn)
 	}
 }
 
-static int rmi_f11_create_sysfs(struct rmi_function *fn)
-{
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
-	}
-
-	return 0;
-
-err_remove_sysfs:
-	for (attr_count--; attr_count >= 0; attr_count--)
-		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
-	return rc;
-}
-
 static int rmi_f11_config(struct rmi_function *fn)
 {
 	struct f11_data *f11 = fn->data;
@@ -2703,43 +2149,31 @@ static int rmi_f11_resume(struct rmi_function *fn)
 
 static int rmi_f11_probe(struct rmi_function *fn)
 {
-	int rc;
+	int error;
 
-	rc = rmi_f11_initialize(fn);
-	if (rc < 0)
-		return rc;
+	error = rmi_f11_initialize(fn);
+	if (error)
+		return error;
 
-	rc = rmi_f11_register_devices(fn);
-	if (rc < 0)
-		return rc;
+	error = rmi_f11_register_devices(fn);
+	if (error)
+		return error;
 
-	rc = rmi_f11_create_sysfs(fn);
-	if (rc < 0)
-		return rc;
+	error = sysfs_create_group(&fn->dev.kobj, &rmi_f11_attr_group);
+	if (error)
+		return error;
 
 	return 0;
 }
 
 static void rmi_f11_remove(struct rmi_function *fn)
 {
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
+	debugfs_remove_recursive(fn->debugfs_root);
+	sysfs_remove_group(&fn->dev.kobj, &rmi_f11_attr_group);
 
 	rmi_f11_free_devices(fn);
 }
 
-
 static struct rmi_function_handler rmi_f11_handler = {
 	.driver = {
 		.name = "rmi_f11",
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index daca41b..d4e1438 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -73,16 +73,16 @@ enum rmi_attn_polarity {
  *               automatically enabled for this sensor.
  */
 struct rmi_f11_2d_axis_alignment {
-	bool swap_axes;
-	bool flip_x;
-	bool flip_y;
-	int clip_X_low;
-	int clip_Y_low;
-	int clip_X_high;
-	int clip_Y_high;
-	int offset_X;
-	int offset_Y;
-	int rel_report_enabled;
+	bool rel_report_enabled;
+	u32 swap_axes;	/* boolean, but u32 is needed by debugfs API */
+	u32 flip_x;	/* boolean */
+	u32 flip_y;	/* boolean */
+	u16 clip_x_low;
+	u16 clip_y_low;
+	u16 clip_x_high;
+	u16 clip_y_high;
+	u16 offset_x;
+	u16 offset_y;
 	u8 delta_x_threshold;
 	u8 delta_y_threshold;
 };
-- 
1.7.11.7

