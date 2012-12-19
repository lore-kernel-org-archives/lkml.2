Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2LSAsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:48:13 -0500
Received: from [12.239.217.82] ([12.239.217.82]:62136 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755346Ab2LSAsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:48:05 -0500
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
Subject: =?UTF-8?q?=5BPATCH=2004/05=5D=20input=3A=20F01=20Device=20control?=
Date: Tue, 18 Dec 2012 16:46:35 -0800
Message-Id: <1355877996-1433-5-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
References: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the changes described in 0/0 of this patchset, this patch
includes:

* changes to the handling of sysfs as requested in feedback to our
previous patch.

* device serialization updated to conform to the latest specification.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_f01.c |  733 ++++++++++++++++++++++++------------------
 drivers/input/rmi4/rmi_f01.h |   29 +--
 2 files changed, 425 insertions(+), 337 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index d7461d7..d33fa16 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -2,19 +2,9 @@
  * Copyright (c) 2011-2012 Synaptics Incorporated
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

 #include <linux/kernel.h>
@@ -26,6 +16,8 @@
 #include "rmi_driver.h"
 #include "rmi_f01.h"

+#define FUNCTION_NUMBER 0x01
+
 /**
  * @reset - set this bit to force a firmware reset of the sensor.
  */
@@ -109,11 +101,17 @@ struct f01_ds4_queries {
 	u8 reset_pin_number:4;
 } __attribute__((__packed__));

+/*
+ *
+ * @serialization - 7 bytes of device serialization data.  The meaning of
+ * these bytes varies from product to product, consult your product spec sheet.
+ */
 struct f01_data {
 	struct f01_device_control device_control;
 	struct f01_basic_queries basic_queries;
 	struct f01_device_status device_status;
-	u8 product_id[RMI_PRODUCT_ID_LENGTH + 1];
+	u8 serialization[F01_SERIALIZATION_SIZE];
+	u8 product_id[RMI_PRODUCT_ID_LENGTH+1];

 	u16 interrupt_enable_addr;
 	u16 doze_interval_addr;
@@ -136,19 +134,19 @@ struct f01_data {
 #ifdef CONFIG_RMI4_DEBUG
 struct f01_debugfs_data {
 	bool done;
-	struct rmi_function *fn;
+	struct rmi_function_dev *fn_dev;
 };

 static int f01_debug_open(struct inode *inodep, struct file *filp)
 {
 	struct f01_debugfs_data *data;
-	struct rmi_function *fn = inodep->i_private;
+	struct rmi_function_dev *fn_dev = inodep->i_private;

 	data = kzalloc(sizeof(struct f01_debugfs_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;

-	data->fn = fn;
+	data->fn_dev = fn_dev;
 	filp->private_data = data;
 	return 0;
 }
@@ -167,7 +165,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 	char local_buf[size];
 	char *current_buf = local_buf;
 	struct f01_debugfs_data *data = filp->private_data;
-	struct f01_data *f01 = data->fn->data;
+	struct f01_data *f01 = data->fn_dev->data;

 	if (data->done)
 		return 0;
@@ -197,7 +195,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 			current_buf += len;
 			total_len += len;
 		} else {
-			dev_err(&data->fn->dev, "Failed to build interrupt_enable buffer, code = %d.\n",
+			dev_err(&data->fn_dev->dev, "Failed to build interrupt_enable buffer, code = %d.\n",
 						len);
 			return snprintf(local_buf, size, "unknown\n");
 		}
@@ -206,7 +204,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 	if (len > 0)
 		total_len += len;
 	else
-		dev_warn(&data->fn->dev, "%s: Failed to append carriage return.\n",
+		dev_warn(&data->fn_dev->dev, "%s: Failed to append carriage return.\n",
 			 __func__);

 	if (copy_to_user(buffer, local_buf, total_len))
@@ -224,7 +222,7 @@ static ssize_t interrupt_enable_write(struct file *filp,
 	int irq_count = 0;
 	int irq_reg = 0;
 	struct f01_debugfs_data *data = filp->private_data;
-	struct f01_data *f01 = data->fn->data;
+	struct f01_data *f01 = data->fn_dev->data;

 	retval = copy_from_user(buf, buffer, size);
 	if (retval)
@@ -244,7 +242,7 @@ static ssize_t interrupt_enable_write(struct file *filp,
 		result = sscanf(local_buf, "%u", &interrupt_enable);
 		if ((result != 1) ||
 			(interrupt_enable != 0 && interrupt_enable != 1)) {
-			dev_err(&data->fn->dev, "Interrupt enable[%d] is not a valid value 0x%x.\n",
+			dev_err(&data->fn_dev->dev, "Interrupt enable[%d] is not a valid value 0x%x.\n",
 				i, interrupt_enable);
 			return -EINVAL;
 		}
@@ -259,17 +257,18 @@ static ssize_t interrupt_enable_write(struct file *filp,

 	/* Make sure the irq count matches */
 	if (irq_count != f01->irq_count) {
-		dev_err(&data->fn->dev, "Interrupt enable count of %d doesn't match device count of %d.\n",
+		dev_err(&data->fn_dev->dev, "Interrupt enable count of %d doesn't match device count of %d.\n",
 			 irq_count, f01->irq_count);
 		return -EINVAL;
 	}

 	/* write back to the control register */
-	retval = rmi_write_block(data->fn->rmi_dev, f01->interrupt_enable_addr,
+	retval = rmi_write_block(data->fn_dev->rmi_dev,
+			f01->interrupt_enable_addr,
 			f01->device_control.interrupt_enable,
 			f01->num_of_irq_regs);
 	if (retval < 0) {
-		dev_err(&data->fn->dev, "Could not write interrupt_enable mask to %#06x\n",
+		dev_err(&data->fn_dev->dev, "Could not write interrupt_enable mask to %#06x\n",
 			f01->interrupt_enable_addr);
 		return retval;
 	}
@@ -285,17 +284,18 @@ static const struct file_operations interrupt_enable_fops = {
 	.write = interrupt_enable_write,
 };

-static int setup_debugfs(struct rmi_function *fn)
+static int setup_debugfs(struct rmi_function_dev *fn_dev)
 {
-	struct f01_data *data = fn->data;
+	struct f01_data *data = fn_dev->data;

-	if (!fn->debugfs_root)
+	if (!fn_dev->debugfs_root)
 		return -ENODEV;

 	data->debugfs_interrupt_enable = debugfs_create_file("interrupt_enable",
-		RMI_RW_ATTR, fn->debugfs_root, fn, &interrupt_enable_fops);
+		RMI_RW_ATTR, fn_dev->debugfs_root, fn_dev,
+		&interrupt_enable_fops);
 	if (!data->debugfs_interrupt_enable)
-		dev_warn(&fn->dev,
+		dev_warn(&fn_dev->dev,
 			 "Failed to create debugfs interrupt_enable.\n");

 	return 0;
@@ -306,26 +306,19 @@ static void teardown_debugfs(struct f01_data *f01)
 	if (f01->debugfs_interrupt_enable)
 		debugfs_remove(f01->debugfs_interrupt_enable);
 }
-
 #else
-
-static inline int setup_debugfs(struct rmi_function *fn)
-{
-	return 0;
-}
-
-static inline void teardown_debugfs(struct f01_data *f01)
-{
-}
-
+#define setup_debugfs(fn_dev) 0
+#define teardown_debugfs(f01)
 #endif

 static ssize_t rmi_fn_01_productinfo_show(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "0x%02x 0x%02x\n",
 			data->basic_queries.productinfo_1,
@@ -336,8 +329,10 @@ static ssize_t rmi_fn_01_productid_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%s\n", data->product_id);
 }
@@ -346,34 +341,44 @@ static ssize_t rmi_fn_01_manufacturer_show(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "0x%02x\n",
 			data->basic_queries.manufacturer_id);
 }

-static ssize_t rmi_fn_01_datecode_show(struct device *dev,
+static ssize_t rmi_fn_01_serialization_show(struct device *dev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	int i, n, count = 0;
+	char *local_buf = buf;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);

-	return snprintf(buf, PAGE_SIZE, "20%02u-%02u-%02u\n",
-			data->basic_queries.year,
-			data->basic_queries.month,
-			data->basic_queries.day);
+	data = fn_dev->data;
+
+	for (i = 0; i < F01_SERIALIZATION_SIZE; i++) {
+		n = snprintf(local_buf, PAGE_SIZE - count, "%02X ",
+			     data->serialization[i]);
+		count += n;
+		local_buf += n;
+	}
+	return count;
 }

 static ssize_t rmi_fn_01_reset_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
+	struct rmi_function_dev *fn_dev = NULL;
 	unsigned int reset;
 	int retval = 0;

+	fn_dev = to_rmi_function_dev(dev);

 	if (sscanf(buf, "%u", &reset) != 1)
 		return -EINVAL;
@@ -386,8 +391,9 @@ static ssize_t rmi_fn_01_reset_store(struct device *dev,
 		struct f01_device_commands commands = {
 			.reset = 1
 		};
-		retval = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
-				&commands, sizeof(commands));
+		retval = rmi_write_block(fn_dev->rmi_dev,
+					 fn_dev->fd.command_base_addr,
+					 &commands, sizeof(commands));
 		if (retval < 0) {
 			dev_err(dev, "Failed to issue reset command, code = %d.",
 						retval);
@@ -402,8 +408,10 @@ static ssize_t rmi_fn_01_sleepmode_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE,
 			"%d\n", data->device_control.ctrl0.sleep_mode);
@@ -413,10 +421,12 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || !RMI_IS_VALID_SLEEPMODE(new_value)) {
@@ -426,7 +436,7 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,

 	dev_dbg(dev, "Setting sleep mode to %ld.", new_value);
 	data->device_control.ctrl0.sleep_mode = new_value;
-	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
@@ -439,21 +449,25 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,
 static ssize_t rmi_fn_01_nosleep_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
-			data->device_control.ctrl0.nosleep);
+		data->device_control.ctrl0.nosleep);
 }

 static ssize_t rmi_fn_01_nosleep_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 1) {
@@ -462,22 +476,23 @@ static ssize_t rmi_fn_01_nosleep_store(struct device *dev,
 	}

 	data->device_control.ctrl0.nosleep = new_value;
-	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
 		retval = count;
 	else
 		dev_err(dev, "Failed to write nosleep bit.\n");
-
 	return retval;
 }

 static ssize_t rmi_fn_01_chargerinput_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.charger_input);
@@ -487,10 +502,12 @@ static ssize_t rmi_fn_01_chargerinput_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 1) {
@@ -499,22 +516,23 @@ static ssize_t rmi_fn_01_chargerinput_store(struct device *dev,
 	}

 	data->device_control.ctrl0.charger_input = new_value;
-	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
 		retval = count;
 	else
 		dev_err(dev, "Failed to write chargerinput bit.\n");
-
 	return retval;
 }

 static ssize_t rmi_fn_01_reportrate_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.report_rate);
@@ -524,10 +542,12 @@ static ssize_t rmi_fn_01_reportrate_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 1) {
@@ -536,25 +556,26 @@ static ssize_t rmi_fn_01_reportrate_store(struct device *dev,
 	}

 	data->device_control.ctrl0.report_rate = new_value;
-	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
 		retval = count;
 	else
 		dev_err(dev, "Failed to write reportrate bit.\n");
-
 	return retval;
 }

 static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct rmi_function_dev *fn_dev;
+	struct f01_data *data;
 	int i, len, total_len = 0;
 	char *current_buf = buf;

+	fn_dev = to_rmi_function_dev(dev);
+	data = fn_dev->data;
 	/* loop through each irq value and copy its
 	 * string representation into buf */
 	for (i = 0; i < data->irq_count; i++) {
@@ -596,8 +617,10 @@ static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
 static ssize_t rmi_fn_01_doze_interval_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.doze_interval);
@@ -608,11 +631,14 @@ static ssize_t rmi_fn_01_doze_interval_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;
-	u16 ctrl_base_addr;
+	u16 ctrl_addr;
+
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 255) {
@@ -621,19 +647,18 @@ static ssize_t rmi_fn_01_doze_interval_store(struct device *dev,
 	}

 	data->device_control.doze_interval = new_value;
-	ctrl_base_addr = fn->fd.control_base_addr + sizeof(u8) +
+	ctrl_addr = fn_dev->fd.control_base_addr + sizeof(u8) +
 			(sizeof(u8)*(data->num_of_irq_regs));
 	dev_dbg(dev, "doze_interval store address %x, value %d",
-		ctrl_base_addr, data->device_control.doze_interval);
+		ctrl_addr, data->device_control.doze_interval);

-	retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, data->doze_interval_addr,
 			&data->device_control.doze_interval,
 			sizeof(u8));
 	if (retval >= 0)
 		retval = count;
 	else
 		dev_err(dev, "Failed to write doze interval.\n");
-
 	return retval;

 }
@@ -642,8 +667,10 @@ static ssize_t rmi_fn_01_wakeup_threshold_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.wakeup_threshold);
@@ -653,11 +680,14 @@ static ssize_t rmi_fn_01_wakeup_threshold_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;

+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;
+
 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 255) {
 		dev_err(dev, "%s: Invalid wakeup threshold %s.", __func__, buf);
@@ -665,7 +695,7 @@ static ssize_t rmi_fn_01_wakeup_threshold_store(struct device *dev,
 	}

 	data->device_control.doze_interval = new_value;
-	retval = rmi_write_block(fn->rmi_dev, data->wakeup_threshold_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, data->wakeup_threshold_addr,
 			&data->device_control.wakeup_threshold,
 			sizeof(u8));
 	if (retval >= 0)
@@ -680,8 +710,10 @@ static ssize_t rmi_fn_01_doze_holdoff_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.doze_holdoff);
@@ -693,11 +725,14 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
 	unsigned long new_value;
 	int retval;

+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;
+
 	retval = strict_strtoul(buf, 10, &new_value);
 	if (retval < 0 || new_value > 255) {
 		dev_err(dev, "%s: Invalid doze holdoff %s.", __func__, buf);
@@ -705,14 +740,13 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 	}

 	data->device_control.doze_interval = new_value;
-	retval = rmi_write_block(fn->rmi_dev, data->doze_holdoff_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, data->doze_holdoff_addr,
 			&data->device_control.doze_holdoff,
 			sizeof(u8));
 	if (retval >= 0)
 		retval = count;
 	else
 		dev_err(dev, "Failed to write doze holdoff.\n");
-
 	return retval;

 }
@@ -720,8 +754,10 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 static ssize_t rmi_fn_01_configured_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.configured);
@@ -730,8 +766,10 @@ static ssize_t rmi_fn_01_configured_show(struct device *dev,
 static ssize_t rmi_fn_01_unconfigured_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_status.unconfigured);
@@ -740,8 +778,10 @@ static ssize_t rmi_fn_01_unconfigured_show(struct device *dev,
 static ssize_t rmi_fn_01_flashprog_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_status.flash_prog);
@@ -750,154 +790,147 @@ static ssize_t rmi_fn_01_flashprog_show(struct device *dev,
 static ssize_t rmi_fn_01_statuscode_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = NULL;
+	struct rmi_function_dev *fn_dev = to_rmi_function_dev(dev);
+
+	data = fn_dev->data;

 	return snprintf(buf, PAGE_SIZE, "0x%02x\n",
 			data->device_status.status_code);
 }

-#define RMI_F01_ATTR(_name)			\
-	DEVICE_ATTR(_name, RMI_RW_ATTR,		\
-		    rmi_fn_01_##_name##_show,	\
-		    rmi_fn_01_##_name##_store)
-
-#define RMI_F01_RO_ATTR(_name)			\
-	DEVICE_ATTR(_name, RMI_RO_ATTR,		\
-		    rmi_fn_01_##_name##_show,	\
-		    NULL)
-
-#define RMI_F01_WO_ATTR(_name)			\
-	DEVICE_ATTR(_name, RMI_RO_ATTR,		\
-		    NULL,			\
-		    rmi_fn_01_##_name##_store)
-
-
-static RMI_F01_RO_ATTR(productinfo);
-static RMI_F01_RO_ATTR(productid);
-static RMI_F01_RO_ATTR(manufacturer);
-static RMI_F01_RO_ATTR(datecode);
-
-/* Control register access */
-static RMI_F01_ATTR(sleepmode);
-static RMI_F01_ATTR(nosleep);
-static RMI_F01_ATTR(chargerinput);
-static RMI_F01_ATTR(reportrate);
-
-/*
- * We don't want arbitrary callers changing the interrupt enable mask,
+static struct device_attribute dev_attr_doze_interval =
+		__ATTR(doze_interval, RMI_RW_ATTR,
+			rmi_fn_01_doze_interval_show,
+				rmi_fn_01_doze_interval_store);
+static struct device_attribute dev_attr_wakeup_threshold =
+		__ATTR(wakeup_threshold, RMI_RW_ATTR,
+			rmi_fn_01_wakeup_threshold_show,
+			rmi_fn_01_wakeup_threshold_store);
+static struct device_attribute dev_attr_doze_holdoff =
+		__ATTR(doze_holdoff, RMI_RW_ATTR,
+			rmi_fn_01_doze_holdoff_show,
+			rmi_fn_01_doze_holdoff_store);
+
+static struct device_attribute dev_attr_productinfo =
+	__ATTR(productinfo, RMI_RO_ATTR,
+	       rmi_fn_01_productinfo_show, NULL);
+static struct device_attribute dev_attr_productid =
+	__ATTR(productid, RMI_RO_ATTR,
+	       rmi_fn_01_productid_show, NULL);
+static struct device_attribute dev_attr_manufacturer =
+	__ATTR(manufacturer, RMI_RO_ATTR,
+	       rmi_fn_01_manufacturer_show, NULL);
+
+/* control register access */
+static struct device_attribute dev_attr_sleepmode =
+	__ATTR(sleepmode, RMI_RW_ATTR,
+	       rmi_fn_01_sleepmode_show, rmi_fn_01_sleepmode_store);
+static struct device_attribute dev_attr_nosleep =
+	__ATTR(nosleep, RMI_RW_ATTR,
+	       rmi_fn_01_nosleep_show, rmi_fn_01_nosleep_store);
+static struct device_attribute dev_attr_chargerinput =
+	__ATTR(chargerinput, RMI_RW_ATTR,
+	       rmi_fn_01_chargerinput_show, rmi_fn_01_chargerinput_store);
+static struct device_attribute dev_attr_reportrate =
+	__ATTR(reportrate, RMI_RW_ATTR,
+	       rmi_fn_01_reportrate_show, rmi_fn_01_reportrate_store);
+/* We don't want arbitrary callers changing the interrupt enable mask,
  * so it's read only.
  */
-static RMI_F01_RO_ATTR(interrupt_enable);
-static RMI_F01_ATTR(doze_interval);
-static RMI_F01_ATTR(wakeup_threshold);
-static RMI_F01_ATTR(doze_holdoff);
+static struct device_attribute dev_attr_interrupt_enable =
+	__ATTR(interrupt_enable, RMI_RO_ATTR,
+	       rmi_fn_01_interrupt_enable_show, NULL);

-/*
- * We make report rate RO, since the driver uses that to look for
+/* We make configured RO, since the driver uses that to look for
  * resets.  We don't want someone faking us out by changing that
  * bit.
  */
-static RMI_F01_RO_ATTR(configured);
+static struct device_attribute dev_attr_configured =
+	__ATTR(configured, RMI_RO_ATTR,
+	       rmi_fn_01_configured_show, NULL);

 /* Command register access. */
-static RMI_F01_WO_ATTR(reset);
+static struct device_attribute dev_attr_reset =
+	__ATTR(reset, RMI_WO_ATTR,
+	       NULL, rmi_fn_01_reset_store);

 /* Status register access. */
-static RMI_F01_RO_ATTR(unconfigured);
-static RMI_F01_RO_ATTR(flashprog);
-static RMI_F01_RO_ATTR(statuscode);
-
-static struct attribute *rmi_fn_01_attrs[] = {
+static struct device_attribute dev_attr_unconfigured =
+	__ATTR(unconfigured, RMI_RO_ATTR,
+	       rmi_fn_01_unconfigured_show, NULL);
+static struct device_attribute dev_attr_flashprog =
+	__ATTR(flashprog, RMI_RO_ATTR,
+	       rmi_fn_01_flashprog_show, NULL);
+static struct device_attribute dev_attr_statuscode =
+	__ATTR(statuscode, RMI_RO_ATTR,
+	       rmi_fn_01_statuscode_show, NULL);
+static struct device_attribute dev_attr_serialization =
+	__ATTR(serialization, RMI_RO_ATTR,
+	       rmi_fn_01_serialization_show, NULL);
+
+static struct attribute *attrs[] = {
 	&dev_attr_productinfo.attr,
 	&dev_attr_productid.attr,
 	&dev_attr_manufacturer.attr,
-	&dev_attr_datecode.attr,
 	&dev_attr_sleepmode.attr,
 	&dev_attr_nosleep.attr,
 	&dev_attr_chargerinput.attr,
 	&dev_attr_reportrate.attr,
 	&dev_attr_interrupt_enable.attr,
-	&dev_attr_doze_interval.attr,
-	&dev_attr_wakeup_threshold.attr,
-	&dev_attr_doze_holdoff.attr,
 	&dev_attr_configured.attr,
 	&dev_attr_reset.attr,
 	&dev_attr_unconfigured.attr,
 	&dev_attr_flashprog.attr,
 	&dev_attr_statuscode.attr,
+	&dev_attr_serialization.attr,
 	NULL
 };

-static umode_t rmi_fn_01_attr_visible(struct kobject *kobj,
-				      struct attribute *attr, int n)
-{
-	struct device *dev = kobj_to_dev(kobj);
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct f01_data *data = fn->data;
-	umode_t mode = attr->mode;
-
-	if (attr == &dev_attr_doze_interval.attr) {
-		if (!data->basic_queries.has_lts)
-			mode = 0;
-	} else if (attr == &dev_attr_wakeup_threshold.attr) {
-		if (!data->basic_queries.has_adjustable_doze)
-			mode = 0;
-	} else if (attr == &dev_attr_doze_holdoff.attr) {
-		if (!data->basic_queries.has_adjustable_doze_holdoff)
-			mode = 0;
-	}
-
-	return mode;
-}
-
-static struct attribute_group rmi_fn_01_attr_group = {
-	.is_visible	= rmi_fn_01_attr_visible,
-	.attrs		= rmi_fn_01_attrs,
-};
+static struct attribute_group fn01_attrs = GROUP(attrs);

-static int rmi_f01_alloc_memory(struct rmi_function *fn,
-				int num_of_irq_regs)
+static int rmi_f01_alloc_memory(struct rmi_function_dev *fn_dev,
+	int num_of_irq_regs)
 {
 	struct f01_data *f01;

-	f01 = devm_kzalloc(&fn->dev, sizeof(struct f01_data), GFP_KERNEL);
+	f01 = devm_kzalloc(&fn_dev->dev, sizeof(struct f01_data), GFP_KERNEL);
 	if (!f01) {
-		dev_err(&fn->dev, "Failed to allocate fn_01_data.\n");
+		dev_err(&fn_dev->dev, "Failed to allocate fn_01_data.\n");
 		return -ENOMEM;
 	}

-	f01->device_control.interrupt_enable = devm_kzalloc(&fn->dev,
+	f01->device_control.interrupt_enable = devm_kzalloc(&fn_dev->dev,
 			sizeof(u8)*(num_of_irq_regs),
 			GFP_KERNEL);
 	if (!f01->device_control.interrupt_enable) {
-		dev_err(&fn->dev, "Failed to allocate interrupt enable.\n");
+		dev_err(&fn_dev->dev, "Failed to allocate interrupt enable.\n");
 		return -ENOMEM;
 	}
-	fn->data = f01;
+	fn_dev->data = f01;

 	return 0;
 }

-static int rmi_f01_initialize(struct rmi_function *fn)
+static int rmi_f01_initialize(struct rmi_function_dev *fn_dev)
 {
 	u8 temp;
-	int error;
-	u16 ctrl_base_addr;
-	struct rmi_device *rmi_dev = fn->rmi_dev;
+	int retval;
+	u16 query_addr = fn_dev->fd.query_base_addr;
+	u16 ctrl_addr = fn_dev->fd.control_base_addr;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
-	struct f01_data *data = fn->data;
+	struct f01_data *data = fn_dev->data;
 	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);

 	/* Set the configured bit and (optionally) other important stuff
 	 * in the device control register. */
-	ctrl_base_addr = fn->fd.control_base_addr;
-	error = rmi_read_block(rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_read_block(rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read F01 control.\n");
-		return error;
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read F01 control.\n");
+		return retval;
 	}
 	switch (pdata->power_management.nosleep) {
 	case RMI_F01_NOSLEEP_DEFAULT:
@@ -914,242 +947,295 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 	 * is certain to function.
 	 */
 	if (data->device_control.ctrl0.sleep_mode != RMI_SLEEP_MODE_NORMAL) {
-		dev_warn(&fn->dev,
+		dev_warn(&fn_dev->dev,
 			 "WARNING: Non-zero sleep mode found. Clearing...\n");
 		data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;
 	}

 	data->device_control.ctrl0.configured = 1;
-	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to write F01 control.\n");
-		return error;
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to write F01 control.\n");
+		return retval;
 	}

 	data->irq_count = driver_data->irq_count;
 	data->num_of_irq_regs = driver_data->num_of_irq_regs;
-	ctrl_base_addr += sizeof(struct f01_device_control_0);
+	ctrl_addr += sizeof(struct f01_device_control_0);

-	data->interrupt_enable_addr = ctrl_base_addr;
-	error = rmi_read_block(rmi_dev, ctrl_base_addr,
+	data->interrupt_enable_addr = ctrl_addr;
+	retval = rmi_read_block(rmi_dev, ctrl_addr,
 			data->device_control.interrupt_enable,
 			sizeof(u8)*(data->num_of_irq_regs));
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read F01 control interrupt enable register.\n");
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read F01 control interrupt enable register.\n");
 		goto error_exit;
 	}
-	ctrl_base_addr += data->num_of_irq_regs;
+	ctrl_addr += data->num_of_irq_regs;

 	/* dummy read in order to clear irqs */
-	error = rmi_read(rmi_dev, fn->fd.data_base_addr + 1, &temp);
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read Interrupt Status.\n");
-		return error;
+	retval = rmi_read(rmi_dev, fn_dev->fd.data_base_addr + 1, &temp);
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read Interrupt Status.\n");
+		return retval;
 	}

-	error = rmi_read_block(rmi_dev, fn->fd.query_base_addr,
-				&data->basic_queries,
+	/* read queries */
+	retval = rmi_read_block(rmi_dev, query_addr, &data->basic_queries,
 				sizeof(data->basic_queries));
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read device query registers.\n");
-		return error;
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read device query registers.\n");
+		return retval;
 	}
+	query_addr += sizeof(data->basic_queries);

-	error = rmi_read_block(rmi_dev,
-		fn->fd.query_base_addr + sizeof(data->basic_queries),
-		data->product_id, RMI_PRODUCT_ID_LENGTH);
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read product ID.\n");
-		return error;
+	retval = rmi_read_block(rmi_dev, query_addr, data->serialization,
+				F01_SERIALIZATION_SIZE);
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read device serialization.\n");
+		return retval;
+	}
+	query_addr += F01_SERIALIZATION_SIZE;
+
+	retval = rmi_read_block(rmi_dev, query_addr, data->product_id,
+				RMI_PRODUCT_ID_LENGTH);
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read product ID.\n");
+		return retval;
 	}
 	data->product_id[RMI_PRODUCT_ID_LENGTH] = '\0';
-	dev_info(&fn->dev, "found RMI device, manufacturer: %s, product: %s\n",
+	dev_info(&fn_dev->dev, "found RMI device, manufacturer: %s, product: %s\n",
 		 data->basic_queries.manufacturer_id == 1 ?
 							"synaptics" : "unknown",
 		 data->product_id);

 	/* read control register */
 	if (data->basic_queries.has_adjustable_doze) {
-		data->doze_interval_addr = ctrl_base_addr;
-		ctrl_base_addr++;
+		data->doze_interval_addr = ctrl_addr;
+		ctrl_addr++;

 		if (pdata->power_management.doze_interval) {
 			data->device_control.doze_interval =
 				pdata->power_management.doze_interval;
-			error = rmi_write(rmi_dev, data->doze_interval_addr,
+			retval = rmi_write(rmi_dev, data->doze_interval_addr,
 					data->device_control.doze_interval);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to configure F01 doze interval register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to configure F01 doze interval register.\n");
 				goto error_exit;
 			}
 		} else {
-			error = rmi_read(rmi_dev, data->doze_interval_addr,
+			retval = rmi_read(rmi_dev, data->doze_interval_addr,
 					&data->device_control.doze_interval);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to read F01 doze interval register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to read F01 doze interval register.\n");
 				goto error_exit;
 			}
 		}

-		data->wakeup_threshold_addr = ctrl_base_addr;
-		ctrl_base_addr++;
+		data->wakeup_threshold_addr = ctrl_addr;
+		ctrl_addr++;

 		if (pdata->power_management.wakeup_threshold) {
 			data->device_control.wakeup_threshold =
 				pdata->power_management.wakeup_threshold;
-			error = rmi_write(rmi_dev, data->wakeup_threshold_addr,
+			retval = rmi_write(rmi_dev, data->wakeup_threshold_addr,
 					data->device_control.wakeup_threshold);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to configure F01 wakeup threshold register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to configure F01 wakeup threshold register.\n");
 				goto error_exit;
 			}
 		} else {
-			error = rmi_read(rmi_dev, data->wakeup_threshold_addr,
+			retval = rmi_read(rmi_dev, data->wakeup_threshold_addr,
 					&data->device_control.wakeup_threshold);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to read F01 wakeup threshold register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to read F01 wakeup threshold register.\n");
 				goto error_exit;
 			}
 		}
 	}

 	if (data->basic_queries.has_adjustable_doze_holdoff) {
-		data->doze_holdoff_addr = ctrl_base_addr;
-		ctrl_base_addr++;
+		data->doze_holdoff_addr = ctrl_addr;
+		ctrl_addr++;

 		if (pdata->power_management.doze_holdoff) {
 			data->device_control.doze_holdoff =
 				pdata->power_management.doze_holdoff;
-			error = rmi_write(rmi_dev, data->doze_holdoff_addr,
+			retval = rmi_write(rmi_dev, data->doze_holdoff_addr,
 					data->device_control.doze_holdoff);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to configure F01 doze holdoff register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to configure F01 doze holdoff register.\n");
 				goto error_exit;
 			}
 		} else {
-			error = rmi_read(rmi_dev, data->doze_holdoff_addr,
+			retval = rmi_read(rmi_dev, data->doze_holdoff_addr,
 					&data->device_control.doze_holdoff);
-			if (error < 0) {
-				dev_err(&fn->dev, "Failed to read F01 doze holdoff register.\n");
+			if (retval < 0) {
+				dev_err(&fn_dev->dev, "Failed to read F01 doze holdoff register.\n");
 				goto error_exit;
 			}
 		}
 	}

-	error = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
+	retval = rmi_read_block(rmi_dev, fn_dev->fd.data_base_addr,
 		&data->device_status, sizeof(data->device_status));
-	if (error < 0) {
-		dev_err(&fn->dev, "Failed to read device status.\n");
+	if (retval < 0) {
+		dev_err(&fn_dev->dev, "Failed to read device status.\n");
 		goto error_exit;
 	}

 	if (data->device_status.unconfigured) {
-		dev_err(&fn->dev, "Device reset during configuration process, status: %#02x!\n",
+		dev_err(&fn_dev->dev, "Device reset during configuration process, status: %#02x!\n",
 				data->device_status.status_code);
-		error = -EINVAL;
+		retval = -EINVAL;
 		goto error_exit;
 	}

-	error = setup_debugfs(fn);
-	if (error)
-		dev_warn(&fn->dev, "Failed to setup debugfs, error: %d.\n",
-			 error);
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
+		retval = setup_debugfs(fn_dev);
+		if (retval < 0)
+			dev_warn(&fn_dev->dev, "Failed to setup debugfs. Code: %d.\n",
+				retval);
+	}

-	return 0;
+	return retval;

  error_exit:
 	kfree(data);
-	return error;
+	return retval;
 }

-static int rmi_f01_config(struct rmi_function *fn)
+static int rmi_f01_create_sysfs(struct rmi_function_dev *fn_dev)
 {
-	struct f01_data *data = fn->data;
+	int retval = 0;
+	struct f01_data *data = fn_dev->data;
+
+	dev_dbg(&fn_dev->dev, "Creating sysfs files.");
+	if (sysfs_create_group(&fn_dev->dev.kobj, &fn01_attrs) < 0) {
+		dev_err(&fn_dev->dev, "Failed to create query sysfs files.");
+		return -ENODEV;
+	}
+	if (data->basic_queries.has_lts) {
+		retval = sysfs_create_file(&fn_dev->dev.kobj,
+			&dev_attr_doze_interval.attr);
+		if (retval < 0) {
+			dev_err(&fn_dev->dev, "Failed to create sysfs file for doze internal.");
+			goto err_remove_sysfs_group;
+		}
+	}
+	if (data->basic_queries.has_adjustable_doze) {
+		retval = sysfs_create_file(&fn_dev->dev.kobj,
+			&dev_attr_wakeup_threshold.attr);
+		if (retval < 0) {
+			dev_err(&fn_dev->dev, "Failed to create sysfs file for wakeup threshold.");
+			goto err_remove_sysfs_doze_interval;
+		}
+	}
+	if (data->basic_queries.has_adjustable_doze_holdoff) {
+		retval = sysfs_create_file(&fn_dev->dev.kobj,
+			&dev_attr_doze_holdoff.attr);
+		if (retval < 0) {
+			dev_err(&fn_dev->dev, "Failed to create sysfs file for doze holdoff.");
+			goto err_remove_sysfs_wakeup_threshold;
+		}
+	}
+	return 0;
+
+err_remove_sysfs_wakeup_threshold:
+	sysfs_remove_file(&fn_dev->dev.kobj, &dev_attr_wakeup_threshold.attr);
+
+err_remove_sysfs_doze_interval:
+	sysfs_remove_file(&fn_dev->dev.kobj, &dev_attr_doze_interval.attr);
+
+err_remove_sysfs_group:
+	sysfs_remove_group(&fn_dev->dev.kobj, &fn01_attrs);
+	return retval;
+}
+
+static int rmi_f01_config(struct rmi_function_dev *fn_dev)
+{
+	struct f01_data *data = fn_dev->data;
 	int retval;

-	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0) {
-		dev_err(&fn->dev, "Failed to write device_control.reg.\n");
+		dev_err(&fn_dev->dev, "Failed to write device_control.reg.\n");
 		return retval;
 	}

-	retval = rmi_write_block(fn->rmi_dev, data->interrupt_enable_addr,
+	retval = rmi_write_block(fn_dev->rmi_dev, data->interrupt_enable_addr,
 			data->device_control.interrupt_enable,
 			sizeof(u8)*(data->num_of_irq_regs));

 	if (retval < 0) {
-		dev_err(&fn->dev, "Failed to write interrupt enable.\n");
+		dev_err(&fn_dev->dev, "Failed to write interrupt enable.\n");
 		return retval;
 	}
 	if (data->basic_queries.has_lts) {
-		retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
-				&data->device_control.doze_interval,
-				sizeof(u8));
+		retval = rmi_write_block(fn_dev->rmi_dev,
+					data->doze_interval_addr,
+					&data->device_control.doze_interval,
+					sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fn->dev, "Failed to write doze interval.\n");
+			dev_err(&fn_dev->dev, "Failed to write doze interval.\n");
 			return retval;
 		}
 	}

 	if (data->basic_queries.has_adjustable_doze) {
 		retval = rmi_write_block(
-				fn->rmi_dev, data->wakeup_threshold_addr,
+				fn_dev->rmi_dev, data->wakeup_threshold_addr,
 				&data->device_control.wakeup_threshold,
 				sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fn->dev, "Failed to write wakeup threshold.\n");
+			dev_err(&fn_dev->dev, "Failed to write wakeup threshold.\n");
 			return retval;
 		}
 	}

 	if (data->basic_queries.has_adjustable_doze_holdoff) {
-		retval = rmi_write_block(fn->rmi_dev, data->doze_holdoff_addr,
-				&data->device_control.doze_holdoff,
-				sizeof(u8));
+		retval = rmi_write_block(fn_dev->rmi_dev,
+					data->doze_holdoff_addr,
+					&data->device_control.doze_holdoff,
+					sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fn->dev, "Failed to write doze holdoff.\n");
+			dev_err(&fn_dev->dev, "Failed to write doze holdoff.\n");
 			return retval;
 		}
 	}
 	return 0;
 }

-static int rmi_f01_probe(struct rmi_function *fn)
+static int rmi_f01_probe(struct rmi_function_dev *fn_dev)
 {
 	struct rmi_driver_data *driver_data =
-			dev_get_drvdata(&fn->rmi_dev->dev);
+			dev_get_drvdata(&fn_dev->rmi_dev->dev);
 	int error;

-	error = rmi_f01_alloc_memory(fn, driver_data->num_of_irq_regs);
-	if (error)
+	error = rmi_f01_alloc_memory(fn_dev, driver_data->num_of_irq_regs);
+	if (error < 0)
 		return error;

-	error = rmi_f01_initialize(fn);
-	if (error)
+	error = rmi_f01_initialize(fn_dev);
+	if (error < 0)
 		return error;

-	error = sysfs_create_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
-	if (error)
+	error = rmi_f01_create_sysfs(fn_dev);
+	if (error < 0)
 		return error;

 	return 0;
 }

-static void rmi_f01_remove(struct rmi_function *fn)
-{
-	teardown_debugfs(fn->data);
-	sysfs_remove_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
-}
-
 #ifdef CONFIG_PM
-static int rmi_f01_suspend(struct rmi_function *fn)
+static int rmi_f01_suspend(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f01_data *data = fn->data;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f01_data *data = fn_dev->data;
 	int retval = 0;

 	if (data->suspended)
@@ -1160,11 +1246,11 @@ static int rmi_f01_suspend(struct rmi_function *fn)
 	data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_SENSOR_SLEEP;

 	retval = rmi_write_block(rmi_dev,
-			fn->fd.control_base_addr,
+			fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0) {
-		dev_err(&fn->dev, "Failed to write sleep mode. Code: %d.\n",
+		dev_err(&fn_dev->dev, "Failed to write sleep mode. Code: %d.\n",
 			retval);
 		data->device_control.ctrl0.nosleep = data->old_nosleep;
 		data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;
@@ -1176,10 +1262,10 @@ static int rmi_f01_suspend(struct rmi_function *fn)
 	return retval;
 }

-static int rmi_f01_resume(struct rmi_function *fn)
+static int rmi_f01_resume(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f01_data *data = fn->data;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f01_data *data = fn_dev->data;
 	int retval = 0;

 	if (!data->suspended)
@@ -1188,11 +1274,11 @@ static int rmi_f01_resume(struct rmi_function *fn)
 	data->device_control.ctrl0.nosleep = data->old_nosleep;
 	data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;

-	retval = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
+	retval = rmi_write_block(rmi_dev, fn_dev->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0)
-		dev_err(&fn->dev,
+		dev_err(&fn_dev->dev,
 			"Failed to restore normal operation. Code: %d.\n",
 			retval);
 	else {
@@ -1204,22 +1290,46 @@ static int rmi_f01_resume(struct rmi_function *fn)
 }
 #endif /* CONFIG_PM */

-static int rmi_f01_attention(struct rmi_function *fn,
-			     unsigned long *irq_bits)
+static int rmi_f01_remove(struct rmi_function_dev *fn_dev)
+{
+	struct f01_data *data = fn_dev->data;
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG))
+		teardown_debugfs(fn_dev->data);
+
+	sysfs_remove_group(&fn_dev->dev.kobj, &fn01_attrs);
+
+	if (data->basic_queries.has_lts)
+		sysfs_remove_file(&fn_dev->dev.kobj,
+				  &dev_attr_doze_interval.attr);
+
+	if (data->basic_queries.has_adjustable_doze)
+		sysfs_remove_file(&fn_dev->dev.kobj,
+				  &dev_attr_wakeup_threshold.attr);
+
+	if (data->basic_queries.has_adjustable_doze_holdoff)
+		sysfs_remove_file(&fn_dev->dev.kobj,
+				  &dev_attr_doze_holdoff.attr);
+
+	return 0;
+}
+
+static int rmi_f01_attention(struct rmi_function_dev *fn_dev,
+						unsigned long *irq_bits)
 {
-	struct rmi_device *rmi_dev = fn->rmi_dev;
-	struct f01_data *data = fn->data;
+	struct rmi_device *rmi_dev = fn_dev->rmi_dev;
+	struct f01_data *data = fn_dev->data;
 	int retval;

-	retval = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
+	retval = rmi_read_block(rmi_dev, fn_dev->fd.data_base_addr,
 		&data->device_status, sizeof(data->device_status));
 	if (retval < 0) {
-		dev_err(&fn->dev, "Failed to read device status, code: %d.\n",
+		dev_err(&fn_dev->dev, "Failed to read device status, code: %d.\n",
 			retval);
 		return retval;
 	}
 	if (data->device_status.unconfigured) {
-		dev_warn(&fn->dev, "Device reset detected.\n");
+		dev_warn(&fn_dev->dev, "Device reset detected.\n");
 		retval = rmi_dev->driver->reset_handler(rmi_dev);
 		if (retval < 0)
 			return retval;
@@ -1227,15 +1337,16 @@ static int rmi_f01_attention(struct rmi_function *fn,
 	return 0;
 }

-struct rmi_function_handler rmi_f01_handler = {
+struct rmi_function_driver rmi_f01_driver = {
 	.driver = {
 		.name = "rmi_f01",
 	},
-	.func = 0x01,
+	.func = FUNCTION_NUMBER,
 	.probe = rmi_f01_probe,
 	.remove = rmi_f01_remove,
 	.config = rmi_f01_config,
 	.attention = rmi_f01_attention,
+
 #ifdef CONFIG_PM
 	.suspend = rmi_f01_suspend,
 	.resume = rmi_f01_resume,
diff --git a/drivers/input/rmi4/rmi_f01.h b/drivers/input/rmi4/rmi_f01.h
index 8092b7f..511b389 100644
--- a/drivers/input/rmi4/rmi_f01.h
+++ b/drivers/input/rmi4/rmi_f01.h
@@ -30,6 +30,8 @@

 #define F01_RESET_MASK 0x01

+#define F01_SERIALIZATION_SIZE 7
+
 /**
  * @manufacturer_id - reports the identity of the manufacturer of the RMI
  * device. Synaptics RMI devices report a Manufacturer ID of $01.
@@ -49,19 +51,6 @@
  * product spec sheet.
  * @productinfo_2 - meaning varies from product to product, consult your
  * product spec sheet.
- * @year - year of manufacture MOD 2000.
- * @month - month of manufacture
- * @day - day of manufacture
- * @wafer_id1_lsb - The wafer-lot ID registers record the lot number of the
- * wafer from which the module’s touch controller was produced.
- * @wafer_id1_msb - The wafer-lot ID registers record the lot number of the
- * wafer from which the module’s touch controller was produced.
- * @wafer_id2_lsb - The wafer-lot ID registers record the lot number of the
- * wafer from which the module’s touch controller was produced.
- * @wafer_id2_msb - The wafer-lot ID registers record the lot number of the
- * wafer from which the module’s touch controller was produced.
- * @wafer_id3_lsb - The wafer-lot ID registers record the lot number of the
- * wafer from which the module’s touch controller was produced.
  */
 struct f01_basic_queries {
 	u8 manufacturer_id:8;
@@ -77,21 +66,9 @@ struct f01_basic_queries {

 	u8 productinfo_1:7;
 	u8 q2_bit_7:1;
-
 	u8 productinfo_2:7;
 	u8 q3_bit_7:1;

-	u8 year:5;
-	u8 month:4;
-	u8 day:5;
-	u8 cp1:1;
-	u8 cp2:1;
-
-	u8 wafer_id1_lsb:8;
-	u8 wafer_id1_msb:8;
-	u8 wafer_id2_lsb:8;
-	u8 wafer_id2_msb:8;
-	u8 wafer_id3_lsb:8;
 } __attribute__((__packed__));

 /** The status code field reports the most recent device status event.
@@ -120,7 +97,7 @@ enum rmi_device_status {
  * @unconfigured - the device has lost its configuration for some reason.
  */
 struct f01_device_status {
-	u8 status_code:4;
+	enum rmi_device_status status_code:4;
 	u8 reserved:2;
 	u8 flash_prog:1;
 	u8 unconfigured:1;
