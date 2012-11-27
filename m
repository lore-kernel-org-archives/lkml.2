Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab2K0JWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:22:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab2K0JVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:21:44 -0500
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 1/4] Input RMI4 - rename rmi_function_container to rmi_function
Date: Tue, 27 Nov 2012 01:21:35 -0800
Message-Id: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To save my old fingers...

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

It looks like this driver(s) need some love and I might have some time so I
will refresh my "synaptics" branch with the patches you have sent and start
working off it. If you have updates I would appreciate if you also make them
available relative to that branch. When we are ready we'll squash them all
together and apply to the official branch.

Thanks.

 drivers/input/rmi4/rmi_driver.c | 158 +++++++++++----------
 drivers/input/rmi4/rmi_driver.h |   4 +-
 drivers/input/rmi4/rmi_f01.c    | 298 ++++++++++++++++++++--------------------
 drivers/input/rmi4/rmi_f11.c    | 258 +++++++++++++++++-----------------
 include/linux/rmi.h             |  22 ++-
 5 files changed, 368 insertions(+), 372 deletions(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 05a73ae..e8a4b52 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -594,7 +594,7 @@ static struct device_attribute bsr_attribute = __ATTR(bsr, RMI_RW_ATTR,
 
 static void rmi_free_function_list(struct rmi_device *rmi_dev)
 {
-	struct rmi_function_container *entry, *n;
+	struct rmi_function *entry, *n;
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
 
 	if (!data) {
@@ -613,44 +613,44 @@ static void rmi_free_function_list(struct rmi_device *rmi_dev)
 	}
 }
 
-static void release_fc_device(struct device *dev)
+static void release_function_device(struct device *dev)
 {
 	dev_dbg(dev, "REMOVING KOBJ!");
 	kobject_put(&dev->kobj);
 }
 
-static int reset_one_function(struct rmi_function_container *fc)
+static int reset_one_function(struct rmi_function *fn)
 {
 	struct rmi_function_handler *fh;
 	int retval = 0;
 
-	if (!fc || !fc->dev.driver)
+	if (!fn || !fn->dev.driver)
 		return 0;
 
-	fh = to_rmi_function_handler(fc->dev.driver);
+	fh = to_rmi_function_handler(fn->dev.driver);
 	if (fh->reset) {
-		retval = fh->reset(fc);
+		retval = fh->reset(fn);
 		if (retval < 0)
-			dev_err(&fc->dev, "Reset failed with code %d.\n",
+			dev_err(&fn->dev, "Reset failed with code %d.\n",
 				retval);
 	}
 
 	return retval;
 }
 
-static int configure_one_function(struct rmi_function_container *fc)
+static int configure_one_function(struct rmi_function *fn)
 {
 	struct rmi_function_handler *fh;
 	int retval = 0;
 
-	if (!fc || !fc->dev.driver)
+	if (!fn || !fn->dev.driver)
 		return 0;
 
-	fh = to_rmi_function_handler(fc->dev.driver);
+	fh = to_rmi_function_handler(fn->dev.driver);
 	if (fh->config) {
-		retval = fh->config(fc);
+		retval = fh->config(fn);
 		if (retval < 0)
-			dev_err(&fc->dev, "Config failed with code %d.\n",
+			dev_err(&fn->dev, "Config failed with code %d.\n",
 				retval);
 	}
 
@@ -660,7 +660,7 @@ static int configure_one_function(struct rmi_function_container *fc)
 static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function_container *entry;
+	struct rmi_function *entry;
 	int retval;
 
 	if (list_empty(&data->rmi_functions.list))
@@ -678,7 +678,7 @@ static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev)
 static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function_container *entry;
+	struct rmi_function *entry;
 	int retval;
 
 	if (list_empty(&data->rmi_functions.list))
@@ -693,30 +693,29 @@ static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev)
 	return 0;
 }
 
-static void process_one_interrupt(struct rmi_function_container *fc,
+static void process_one_interrupt(struct rmi_function *fn,
 		unsigned long *irq_status, struct rmi_driver_data *data)
 {
 	struct rmi_function_handler *fh;
 	DECLARE_BITMAP(irq_bits, data->num_of_irq_regs);
 
-	if (!fc || !fc->dev.driver)
+	if (!fn || !fn->dev.driver)
 		return;
 
-	fh = to_rmi_function_handler(fc->dev.driver);
-	if (fc->irq_mask && fh->attention) {
-		bitmap_and(irq_bits, irq_status, fc->irq_mask,
+	fh = to_rmi_function_handler(fn->dev.driver);
+	if (fn->irq_mask && fh->attention) {
+		bitmap_and(irq_bits, irq_status, fn->irq_mask,
 				data->irq_count);
 		if (!bitmap_empty(irq_bits, data->irq_count))
-			fh->attention(fc, irq_bits);
+			fh->attention(fn, irq_bits);
 	}
-
 }
 
 static int process_interrupt_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
 	struct device *dev = &rmi_dev->dev;
-	struct rmi_function_container *entry;
+	struct rmi_function *entry;
 	int error;
 
 	error = rmi_read_block(rmi_dev,
@@ -904,65 +903,65 @@ static int rmi_driver_reset_handler(struct rmi_device *rmi_dev)
  * Construct a function's IRQ mask. This should be called once and stored.
  */
 int rmi_driver_irq_get_mask(struct rmi_device *rmi_dev,
-		struct rmi_function_container *fc) {
+		struct rmi_function *fn) {
 	int i;
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
 
 	/* call devm_kcalloc when it will be defined in kernel in future */
-	fc->irq_mask = devm_kzalloc(&rmi_dev->dev,
+	fn->irq_mask = devm_kzalloc(&rmi_dev->dev,
 			BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
 			GFP_KERNEL);
 
-	if (fc->irq_mask) {
-		for (i = 0; i < fc->num_of_irqs; i++)
-			set_bit(fc->irq_pos+i, fc->irq_mask);
+	if (fn->irq_mask) {
+		for (i = 0; i < fn->num_of_irqs; i++)
+			set_bit(fn->irq_pos+i, fn->irq_mask);
 		return 0;
 	} else
 		return -ENOMEM;
 }
 
 static int init_function_device(struct rmi_device *rmi_dev,
-			     struct rmi_function_container *fc)
+			     struct rmi_function *fn)
 {
 	int retval;
 
 	/* This memset might not be what we want to do... */
-	memset(&(fc->dev), 0, sizeof(struct device));
-	dev_set_name(&(fc->dev), "%s.fn%02x", dev_name(&rmi_dev->dev),
-			fc->fd.function_number);
-	fc->dev.release = release_fc_device;
-
-	fc->dev.parent = &rmi_dev->dev;
-	fc->dev.type = &rmi_function_type;
-	fc->dev.bus = &rmi_bus_type;
-	dev_dbg(&rmi_dev->dev, "Register F%02X.\n", fc->fd.function_number);
-	retval = device_register(&fc->dev);
+	memset(&fn->dev, 0, sizeof(struct device));
+	dev_set_name(&fn->dev, "%s.fn%02x", dev_name(&rmi_dev->dev),
+			fn->fd.function_number);
+	fn->dev.release = release_function_device;
+
+	fn->dev.parent = &rmi_dev->dev;
+	fn->dev.type = &rmi_function_type;
+	fn->dev.bus = &rmi_bus_type;
+	dev_dbg(&rmi_dev->dev, "Register F%02X.\n", fn->fd.function_number);
+	retval = device_register(&fn->dev);
 	if (retval) {
 		dev_err(&rmi_dev->dev, "Failed device_register for F%02X.\n",
-			fc->fd.function_number);
+			fn->fd.function_number);
 		return retval;
 	}
 
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 		char dirname[12];
 
-		snprintf(dirname, 12, "F%02X", fc->fd.function_number);
-		fc->debugfs_root = debugfs_create_dir(dirname,
+		snprintf(dirname, 12, "F%02X", fn->fd.function_number);
+		fn->debugfs_root = debugfs_create_dir(dirname,
 						      rmi_dev->debugfs_root);
-		if (!fc->debugfs_root)
-			dev_warn(&fc->dev, "Failed to create debugfs dir.\n");
+		if (!fn->debugfs_root)
+			dev_warn(&fn->dev, "Failed to create debugfs dir.\n");
 	}
 
 	return 0;
 }
 
-static int create_function_container(struct rmi_device *rmi_dev,
+static int create_function(struct rmi_device *rmi_dev,
 				     struct pdt_entry *pdt_ptr,
 				     int *current_irq_count,
 				     u16 page_start)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function_container *fc = NULL;
+	struct rmi_function *fn = NULL;
 	int retval = 0;
 	struct device *dev = &rmi_dev->dev;
 	struct rmi_device_platform_data *pdata;
@@ -972,37 +971,37 @@ static int create_function_container(struct rmi_device *rmi_dev,
 	dev_dbg(dev, "Initializing F%02X for %s.\n", pdt_ptr->function_number,
 		pdata->sensor_name);
 
-	fc = devm_kzalloc(dev, sizeof(struct rmi_function_container),
+	fn = devm_kzalloc(dev, sizeof(struct rmi_function),
 			GFP_KERNEL);
-	if (!fc) {
+	if (!fn) {
 		dev_err(dev, "Failed to allocate F%02X container.\n",
 			pdt_ptr->function_number);
 		return -ENOMEM;
 	}
 
-	copy_pdt_entry_to_fd(pdt_ptr, &fc->fd, page_start);
+	copy_pdt_entry_to_fd(pdt_ptr, &fn->fd, page_start);
 
-	fc->rmi_dev = rmi_dev;
-	fc->num_of_irqs = pdt_ptr->interrupt_source_count;
+	fn->rmi_dev = rmi_dev;
+	fn->num_of_irqs = pdt_ptr->interrupt_source_count;
 
-	fc->irq_pos = *current_irq_count;
-	*current_irq_count += fc->num_of_irqs;
+	fn->irq_pos = *current_irq_count;
+	*current_irq_count += fn->num_of_irqs;
 
-	retval = init_function_device(rmi_dev, fc);
+	retval = init_function_device(rmi_dev, fn);
 	if (retval < 0) {
 		dev_err(dev, "Failed to initialize F%02X device.\n",
 			pdt_ptr->function_number);
 		goto error_free_data;
 	}
 
-	INIT_LIST_HEAD(&fc->list);
+	INIT_LIST_HEAD(&fn->list);
 	/* we need to ensure that F01 is at the head of the list.
 	 */
 	if (pdt_ptr->function_number == 0x01) {
-		list_add(&fc->list, &data->rmi_functions.list);
-		data->f01_container = fc;
+		list_add(&fn->list, &data->rmi_functions.list);
+		data->f01_container = fn;
 	} else
-		list_add_tail(&fc->list, &data->rmi_functions.list);
+		list_add_tail(&fn->list, &data->rmi_functions.list);
 	return 0;
 
 error_free_data:
@@ -1032,7 +1031,6 @@ static void check_bootloader_mode(struct rmi_device *rmi_dev,
 	if (device_status.flash_prog)
 		dev_warn(&rmi_dev->dev,
 			 "WARNING: RMI4 device is in bootloader mode!\n");
-
 }
 
 /*
@@ -1203,7 +1201,7 @@ static int rmi_scan_pdt(struct rmi_device *rmi_dev)
 						      page_start);
 
 
-			retval = create_function_container(rmi_dev,
+			retval = create_function(rmi_dev,
 					&pdt_entry, &irq_count, page_start);
 
 			if (retval)
@@ -1228,23 +1226,23 @@ static int f01_notifier_call(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 
 	if (dev->type != &rmi_function_type)
 		return 0;
 
-	fc = to_rmi_function_container(dev);
-	if (fc->fd.function_number != 0x01)
+	fn = to_rmi_function(dev);
+	if (fn->fd.function_number != 0x01)
 		return 0;
 
 	switch (action) {
 	case BUS_NOTIFY_BOUND_DRIVER:
 		dev_dbg(dev, "%s: F01 driver bound.\n", __func__);
-		enable_sensor(fc->rmi_dev);
+		enable_sensor(fn->rmi_dev);
 		break;
 	case BUS_NOTIFY_UNBIND_DRIVER:
 		dev_dbg(dev, "%s: F01 driver going away.\n", __func__);
-		disable_sensor(fc->rmi_dev);
+		disable_sensor(fn->rmi_dev);
 		break;
 	}
 	return 0;
@@ -1255,20 +1253,20 @@ static struct notifier_block rmi_bus_notifier = {
 };
 
 #ifdef CONFIG_PM
-static int suspend_one_device(struct rmi_function_container *fc)
+static int suspend_one_device(struct rmi_function *fn)
 {
 	struct rmi_function_handler *fh;
 	int retval = 0;
 
-	if (!fc->dev.driver)
+	if (!fn->dev.driver)
 		return 0;
 
-	fh = to_rmi_function_handler(fc->dev.driver);
+	fh = to_rmi_function_handler(fn->dev.driver);
 
 	if (fh->suspend) {
-		retval = fh->suspend(fc);
+		retval = fh->suspend(fn);
 		if (retval < 0)
-			dev_err(&fc->dev, "Suspend failed, code: %d",
+			dev_err(&fn->dev, "Suspend failed, code: %d",
 				retval);
 	}
 
@@ -1278,7 +1276,7 @@ static int suspend_one_device(struct rmi_function_container *fc)
 static int rmi_driver_suspend(struct device *dev)
 {
 	struct rmi_driver_data *data;
-	struct rmi_function_container *entry;
+	struct rmi_function *entry;
 	int retval = 0;
 	struct rmi_device *rmi_dev = to_rmi_device(dev);
 
@@ -1311,20 +1309,20 @@ exit:
 	return retval;
 }
 
-static int resume_one_device(struct rmi_function_container *fc)
+static int resume_one_device(struct rmi_function *fn)
 {
 	struct rmi_function_handler *fh;
 	int retval = 0;
 
-	if (!fc->dev.driver)
+	if (!fn->dev.driver)
 		return 0;
 
-	fh = to_rmi_function_handler(fc->dev.driver);
+	fh = to_rmi_function_handler(fn->dev.driver);
 
 	if (fh->resume) {
-		retval = fh->resume(fc);
+		retval = fh->resume(fn);
 		if (retval < 0)
-			dev_err(&fc->dev, "Resume failed, code: %d",
+			dev_err(&fn->dev, "Resume failed, code: %d",
 				retval);
 	}
 
@@ -1334,7 +1332,7 @@ static int resume_one_device(struct rmi_function_container *fc)
 static int rmi_driver_resume(struct device *dev)
 {
 	struct rmi_driver_data *data;
-	struct rmi_function_container *entry;
+	struct rmi_function *entry;
 	int retval = 0;
 	struct rmi_device *rmi_dev = to_rmi_device(dev);
 
@@ -1399,7 +1397,7 @@ static int __devinit rmi_driver_probe(struct device *dev)
 {
 	struct rmi_driver *rmi_driver;
 	struct rmi_driver_data *data = NULL;
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 	struct rmi_device_platform_data *pdata;
 	int retval = 0;
 	int attr_count = 0;
@@ -1467,8 +1465,8 @@ static int __devinit rmi_driver_probe(struct device *dev)
 		goto err_free_data;
 	}
 
-	list_for_each_entry(fc, &data->rmi_functions.list, list) {
-		retval = rmi_driver_irq_get_mask(rmi_dev, fc);
+	list_for_each_entry(fn, &data->rmi_functions.list, list) {
+		retval = rmi_driver_irq_get_mask(rmi_dev, fn);
 		if (retval < 0) {
 			dev_err(dev, "%s: Failed to create irq_mask.\n",
 				__func__);
@@ -1573,7 +1571,7 @@ static int __devinit rmi_driver_probe(struct device *dev)
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 		retval = setup_debugfs(rmi_dev);
 		if (retval < 0)
-			dev_warn(&fc->dev, "Failed to setup debugfs. Code: %d.\n",
+			dev_warn(&fn->dev, "Failed to setup debugfs. Code: %d.\n",
 				retval);
 	}
 
diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
index f5b221a..1fc4676 100644
--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -44,10 +44,10 @@ struct pdt_properties {
 } __attribute__((__packed__));
 
 struct rmi_driver_data {
-	struct rmi_function_container rmi_functions;
+	struct rmi_function rmi_functions;
 	struct rmi_device *rmi_dev;
 
-	struct rmi_function_container *f01_container;
+	struct rmi_function *f01_container;
 	bool f01_bootloader_mode;
 
 	atomic_t attn_count;
diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index b6352ba..5e6bef6 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -138,19 +138,19 @@ struct f01_data {
 #ifdef CONFIG_RMI4_DEBUG
 struct f01_debugfs_data {
 	bool done;
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 };
 
 static int f01_debug_open(struct inode *inodep, struct file *filp)
 {
 	struct f01_debugfs_data *data;
-	struct rmi_function_container *fc = inodep->i_private;
+	struct rmi_function *fn = inodep->i_private;
 
 	data = kzalloc(sizeof(struct f01_debugfs_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->fc = fc;
+	data->fn = fn;
 	filp->private_data = data;
 	return 0;
 }
@@ -169,7 +169,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 	char local_buf[size];
 	char *current_buf = local_buf;
 	struct f01_debugfs_data *data = filp->private_data;
-	struct f01_data *f01 = data->fc->data;
+	struct f01_data *f01 = data->fn->data;
 
 	if (data->done)
 		return 0;
@@ -199,7 +199,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 			current_buf += len;
 			total_len += len;
 		} else {
-			dev_err(&data->fc->dev, "Failed to build interrupt_enable buffer, code = %d.\n",
+			dev_err(&data->fn->dev, "Failed to build interrupt_enable buffer, code = %d.\n",
 						len);
 			return snprintf(local_buf, size, "unknown\n");
 		}
@@ -208,7 +208,7 @@ static ssize_t interrupt_enable_read(struct file *filp, char __user *buffer,
 	if (len > 0)
 		total_len += len;
 	else
-		dev_warn(&data->fc->dev, "%s: Failed to append carriage return.\n",
+		dev_warn(&data->fn->dev, "%s: Failed to append carriage return.\n",
 			 __func__);
 
 	if (copy_to_user(buffer, local_buf, total_len))
@@ -226,7 +226,7 @@ static ssize_t interrupt_enable_write(struct file *filp,
 	int irq_count = 0;
 	int irq_reg = 0;
 	struct f01_debugfs_data *data = filp->private_data;
-	struct f01_data *f01 = data->fc->data;
+	struct f01_data *f01 = data->fn->data;
 
 	retval = copy_from_user(buf, buffer, size);
 	if (retval)
@@ -246,7 +246,7 @@ static ssize_t interrupt_enable_write(struct file *filp,
 		result = sscanf(local_buf, "%u", &interrupt_enable);
 		if ((result != 1) ||
 			(interrupt_enable != 0 && interrupt_enable != 1)) {
-			dev_err(&data->fc->dev, "Interrupt enable[%d] is not a valid value 0x%x.\n",
+			dev_err(&data->fn->dev, "Interrupt enable[%d] is not a valid value 0x%x.\n",
 				i, interrupt_enable);
 			return -EINVAL;
 		}
@@ -261,17 +261,17 @@ static ssize_t interrupt_enable_write(struct file *filp,
 
 	/* Make sure the irq count matches */
 	if (irq_count != f01->irq_count) {
-		dev_err(&data->fc->dev, "Interrupt enable count of %d doesn't match device count of %d.\n",
+		dev_err(&data->fn->dev, "Interrupt enable count of %d doesn't match device count of %d.\n",
 			 irq_count, f01->irq_count);
 		return -EINVAL;
 	}
 
 	/* write back to the control register */
-	retval = rmi_write_block(data->fc->rmi_dev, f01->interrupt_enable_addr,
+	retval = rmi_write_block(data->fn->rmi_dev, f01->interrupt_enable_addr,
 			f01->device_control.interrupt_enable,
 			f01->num_of_irq_regs);
 	if (retval < 0) {
-		dev_err(&data->fc->dev, "Could not write interrupt_enable mask to %#06x\n",
+		dev_err(&data->fn->dev, "Could not write interrupt_enable mask to %#06x\n",
 			f01->interrupt_enable_addr);
 		return retval;
 	}
@@ -287,17 +287,17 @@ static const struct file_operations interrupt_enable_fops = {
 	.write = interrupt_enable_write,
 };
 
-static int setup_debugfs(struct rmi_function_container *fc)
+static int setup_debugfs(struct rmi_function *fn)
 {
-	struct f01_data *data = fc->data;
+	struct f01_data *data = fn->data;
 
-	if (!fc->debugfs_root)
+	if (!fn->debugfs_root)
 		return -ENODEV;
 
 	data->debugfs_interrupt_enable = debugfs_create_file("interrupt_enable",
-		RMI_RW_ATTR, fc->debugfs_root, fc, &interrupt_enable_fops);
+		RMI_RW_ATTR, fn->debugfs_root, fn, &interrupt_enable_fops);
 	if (!data->debugfs_interrupt_enable)
-		dev_warn(&fc->dev,
+		dev_warn(&fn->dev,
 			 "Failed to create debugfs interrupt_enable.\n");
 
 	return 0;
@@ -311,7 +311,7 @@ static void teardown_debugfs(struct f01_data *f01)
 
 #else
 
-static inline int setup_debugfs(struct rmi_function_container *fc)
+static inline int setup_debugfs(struct rmi_function *fn)
 {
 	return 0;
 }
@@ -326,8 +326,8 @@ static ssize_t rmi_fn_01_productinfo_show(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "0x%02x 0x%02x\n",
 			data->basic_queries.productinfo_1,
@@ -338,8 +338,8 @@ static ssize_t rmi_fn_01_productid_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", data->product_id);
 }
@@ -348,8 +348,8 @@ static ssize_t rmi_fn_01_manufacturer_show(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "0x%02x\n",
 			data->basic_queries.manufacturer_id);
@@ -359,8 +359,8 @@ static ssize_t rmi_fn_01_datecode_show(struct device *dev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "20%02u-%02u-%02u\n",
 			data->basic_queries.year,
@@ -372,7 +372,7 @@ static ssize_t rmi_fn_01_reset_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
+	struct rmi_function *fn = to_rmi_function(dev);
 	unsigned int reset;
 	int retval = 0;
 
@@ -388,7 +388,7 @@ static ssize_t rmi_fn_01_reset_store(struct device *dev,
 		struct f01_device_commands commands = {
 			.reset = 1
 		};
-		retval = rmi_write_block(fc->rmi_dev, fc->fd.command_base_addr,
+		retval = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
 				&commands, sizeof(commands));
 		if (retval < 0) {
 			dev_err(dev, "Failed to issue reset command, code = %d.",
@@ -404,8 +404,8 @@ static ssize_t rmi_fn_01_sleepmode_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE,
 			"%d\n", data->device_control.ctrl0.sleep_mode);
@@ -415,8 +415,8 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -428,7 +428,7 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,
 
 	dev_dbg(dev, "Setting sleep mode to %ld.", new_value);
 	data->device_control.ctrl0.sleep_mode = new_value;
-	retval = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
@@ -441,8 +441,8 @@ static ssize_t rmi_fn_01_sleepmode_store(struct device *dev,
 static ssize_t rmi_fn_01_nosleep_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.nosleep);
@@ -452,8 +452,8 @@ static ssize_t rmi_fn_01_nosleep_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -464,7 +464,7 @@ static ssize_t rmi_fn_01_nosleep_store(struct device *dev,
 	}
 
 	data->device_control.ctrl0.nosleep = new_value;
-	retval = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
@@ -478,8 +478,8 @@ static ssize_t rmi_fn_01_nosleep_store(struct device *dev,
 static ssize_t rmi_fn_01_chargerinput_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.charger_input);
@@ -489,8 +489,8 @@ static ssize_t rmi_fn_01_chargerinput_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -501,7 +501,7 @@ static ssize_t rmi_fn_01_chargerinput_store(struct device *dev,
 	}
 
 	data->device_control.ctrl0.charger_input = new_value;
-	retval = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
@@ -515,8 +515,8 @@ static ssize_t rmi_fn_01_chargerinput_store(struct device *dev,
 static ssize_t rmi_fn_01_reportrate_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.report_rate);
@@ -526,8 +526,8 @@ static ssize_t rmi_fn_01_reportrate_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -538,7 +538,7 @@ static ssize_t rmi_fn_01_reportrate_store(struct device *dev,
 	}
 
 	data->device_control.ctrl0.report_rate = new_value;
-	retval = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval >= 0)
@@ -552,8 +552,8 @@ static ssize_t rmi_fn_01_reportrate_store(struct device *dev,
 static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	int i, len, total_len = 0;
 	char *current_buf = buf;
 
@@ -598,8 +598,8 @@ static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
 static ssize_t rmi_fn_01_doze_interval_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.doze_interval);
@@ -610,8 +610,8 @@ static ssize_t rmi_fn_01_doze_interval_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 	u16 ctrl_base_addr;
@@ -623,12 +623,12 @@ static ssize_t rmi_fn_01_doze_interval_store(struct device *dev,
 	}
 
 	data->device_control.doze_interval = new_value;
-	ctrl_base_addr = fc->fd.control_base_addr + sizeof(u8) +
+	ctrl_base_addr = fn->fd.control_base_addr + sizeof(u8) +
 			(sizeof(u8)*(data->num_of_irq_regs));
 	dev_dbg(dev, "doze_interval store address %x, value %d",
 		ctrl_base_addr, data->device_control.doze_interval);
 
-	retval = rmi_write_block(fc->rmi_dev, data->doze_interval_addr,
+	retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
 			&data->device_control.doze_interval,
 			sizeof(u8));
 	if (retval >= 0)
@@ -644,8 +644,8 @@ static ssize_t rmi_fn_01_wakeup_threshold_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.wakeup_threshold);
@@ -655,8 +655,8 @@ static ssize_t rmi_fn_01_wakeup_threshold_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -667,7 +667,7 @@ static ssize_t rmi_fn_01_wakeup_threshold_store(struct device *dev,
 	}
 
 	data->device_control.doze_interval = new_value;
-	retval = rmi_write_block(fc->rmi_dev, data->wakeup_threshold_addr,
+	retval = rmi_write_block(fn->rmi_dev, data->wakeup_threshold_addr,
 			&data->device_control.wakeup_threshold,
 			sizeof(u8));
 	if (retval >= 0)
@@ -682,8 +682,8 @@ static ssize_t rmi_fn_01_doze_holdoff_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.doze_holdoff);
@@ -695,8 +695,8 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	unsigned long new_value;
 	int retval;
 
@@ -707,7 +707,7 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 	}
 
 	data->device_control.doze_interval = new_value;
-	retval = rmi_write_block(fc->rmi_dev, data->doze_holdoff_addr,
+	retval = rmi_write_block(fn->rmi_dev, data->doze_holdoff_addr,
 			&data->device_control.doze_holdoff,
 			sizeof(u8));
 	if (retval >= 0)
@@ -722,8 +722,8 @@ static ssize_t rmi_fn_01_doze_holdoff_store(struct device *dev,
 static ssize_t rmi_fn_01_configured_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_control.ctrl0.configured);
@@ -732,8 +732,8 @@ static ssize_t rmi_fn_01_configured_show(struct device *dev,
 static ssize_t rmi_fn_01_unconfigured_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_status.unconfigured);
@@ -742,8 +742,8 @@ static ssize_t rmi_fn_01_unconfigured_show(struct device *dev,
 static ssize_t rmi_fn_01_flashprog_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			data->device_status.flash_prog);
@@ -752,8 +752,8 @@ static ssize_t rmi_fn_01_flashprog_show(struct device *dev,
 static ssize_t rmi_fn_01_statuscode_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "0x%02x\n",
 			data->device_status.status_code);
@@ -835,8 +835,8 @@ static umode_t rmi_fn_01_attr_visible(struct kobject *kobj,
 				      struct attribute *attr, int n)
 {
 	struct device *dev = kobj_to_dev(kobj); 
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
-	struct f01_data *data = fc->data;
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct f01_data *data = fn->data;
 	umode_t mode = attr->mode;
 
 	if (attr == &dev_attr_doze_interval.attr) {
@@ -858,47 +858,47 @@ static struct attribute_group rmi_fn_01_attr_group = {
 	.attrs		= rmi_fn_01_attrs,
 };
 
-static int rmi_f01_alloc_memory(struct rmi_function_container *fc,
+static int rmi_f01_alloc_memory(struct rmi_function *fn,
 				int num_of_irq_regs)
 {
 	struct f01_data *f01;
 
-	f01 = devm_kzalloc(&fc->dev, sizeof(struct f01_data), GFP_KERNEL);
+	f01 = devm_kzalloc(&fn->dev, sizeof(struct f01_data), GFP_KERNEL);
 	if (!f01) {
-		dev_err(&fc->dev, "Failed to allocate fn_01_data.\n");
+		dev_err(&fn->dev, "Failed to allocate fn_01_data.\n");
 		return -ENOMEM;
 	}
 
-	f01->device_control.interrupt_enable = devm_kzalloc(&fc->dev,
+	f01->device_control.interrupt_enable = devm_kzalloc(&fn->dev,
 			sizeof(u8)*(num_of_irq_regs),
 			GFP_KERNEL);
 	if (!f01->device_control.interrupt_enable) {
-		dev_err(&fc->dev, "Failed to allocate interrupt enable.\n");
+		dev_err(&fn->dev, "Failed to allocate interrupt enable.\n");
 		return -ENOMEM;
 	}
-	fc->data = f01;
+	fn->data = f01;
 
 	return 0;
 }
 
-static int rmi_f01_initialize(struct rmi_function_container *fc)
+static int rmi_f01_initialize(struct rmi_function *fn)
 {
 	u8 temp;
 	int error;
 	u16 ctrl_base_addr;
-	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
-	struct f01_data *data = fc->data;
+	struct f01_data *data = fn->data;
 	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
 
 	/* Set the configured bit and (optionally) other important stuff
 	 * in the device control register. */
-	ctrl_base_addr = fc->fd.control_base_addr;
-	error = rmi_read_block(rmi_dev, fc->fd.control_base_addr,
+	ctrl_base_addr = fn->fd.control_base_addr;
+	error = rmi_read_block(rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read F01 control.\n");
+		dev_err(&fn->dev, "Failed to read F01 control.\n");
 		return error;
 	}
 	switch (pdata->power_management.nosleep) {
@@ -916,17 +916,17 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 	 * is certain to function.
 	 */
 	if (data->device_control.ctrl0.sleep_mode != RMI_SLEEP_MODE_NORMAL) {
-		dev_warn(&fc->dev,
+		dev_warn(&fn->dev,
 			 "WARNING: Non-zero sleep mode found. Clearing...\n");
 		data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;
 	}
 
 	data->device_control.ctrl0.configured = 1;
-	error = rmi_write_block(rmi_dev, fc->fd.control_base_addr,
+	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to write F01 control.\n");
+		dev_err(&fn->dev, "Failed to write F01 control.\n");
 		return error;
 	}
 
@@ -939,35 +939,35 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 			data->device_control.interrupt_enable,
 			sizeof(u8)*(data->num_of_irq_regs));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read F01 control interrupt enable register.\n");
+		dev_err(&fn->dev, "Failed to read F01 control interrupt enable register.\n");
 		goto error_exit;
 	}
 	ctrl_base_addr += data->num_of_irq_regs;
 
 	/* dummy read in order to clear irqs */
-	error = rmi_read(rmi_dev, fc->fd.data_base_addr + 1, &temp);
+	error = rmi_read(rmi_dev, fn->fd.data_base_addr + 1, &temp);
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read Interrupt Status.\n");
+		dev_err(&fn->dev, "Failed to read Interrupt Status.\n");
 		return error;
 	}
 
-	error = rmi_read_block(rmi_dev, fc->fd.query_base_addr,
+	error = rmi_read_block(rmi_dev, fn->fd.query_base_addr,
 				&data->basic_queries,
 				sizeof(data->basic_queries));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read device query registers.\n");
+		dev_err(&fn->dev, "Failed to read device query registers.\n");
 		return error;
 	}
 
 	error = rmi_read_block(rmi_dev,
-		fc->fd.query_base_addr + sizeof(data->basic_queries),
+		fn->fd.query_base_addr + sizeof(data->basic_queries),
 		data->product_id, RMI_PRODUCT_ID_LENGTH);
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read product ID.\n");
+		dev_err(&fn->dev, "Failed to read product ID.\n");
 		return error;
 	}
 	data->product_id[RMI_PRODUCT_ID_LENGTH] = '\0';
-	dev_info(&fc->dev, "found RMI device, manufacturer: %s, product: %s\n",
+	dev_info(&fn->dev, "found RMI device, manufacturer: %s, product: %s\n",
 		 data->basic_queries.manufacturer_id == 1 ?
 							"synaptics" : "unknown",
 		 data->product_id);
@@ -983,14 +983,14 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 			error = rmi_write(rmi_dev, data->doze_interval_addr,
 					data->device_control.doze_interval);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to configure F01 doze interval register.\n");
+				dev_err(&fn->dev, "Failed to configure F01 doze interval register.\n");
 				goto error_exit;
 			}
 		} else {
 			error = rmi_read(rmi_dev, data->doze_interval_addr,
 					&data->device_control.doze_interval);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to read F01 doze interval register.\n");
+				dev_err(&fn->dev, "Failed to read F01 doze interval register.\n");
 				goto error_exit;
 			}
 		}
@@ -1004,14 +1004,14 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 			error = rmi_write(rmi_dev, data->wakeup_threshold_addr,
 					data->device_control.wakeup_threshold);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to configure F01 wakeup threshold register.\n");
+				dev_err(&fn->dev, "Failed to configure F01 wakeup threshold register.\n");
 				goto error_exit;
 			}
 		} else {
 			error = rmi_read(rmi_dev, data->wakeup_threshold_addr,
 					&data->device_control.wakeup_threshold);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to read F01 wakeup threshold register.\n");
+				dev_err(&fn->dev, "Failed to read F01 wakeup threshold register.\n");
 				goto error_exit;
 			}
 		}
@@ -1027,36 +1027,36 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 			error = rmi_write(rmi_dev, data->doze_holdoff_addr,
 					data->device_control.doze_holdoff);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to configure F01 doze holdoff register.\n");
+				dev_err(&fn->dev, "Failed to configure F01 doze holdoff register.\n");
 				goto error_exit;
 			}
 		} else {
 			error = rmi_read(rmi_dev, data->doze_holdoff_addr,
 					&data->device_control.doze_holdoff);
 			if (error < 0) {
-				dev_err(&fc->dev, "Failed to read F01 doze holdoff register.\n");
+				dev_err(&fn->dev, "Failed to read F01 doze holdoff register.\n");
 				goto error_exit;
 			}
 		}
 	}
 
-	error = rmi_read_block(rmi_dev, fc->fd.data_base_addr,
+	error = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
 		&data->device_status, sizeof(data->device_status));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read device status.\n");
+		dev_err(&fn->dev, "Failed to read device status.\n");
 		goto error_exit;
 	}
 
 	if (data->device_status.unconfigured) {
-		dev_err(&fc->dev, "Device reset during configuration process, status: %#02x!\n",
+		dev_err(&fn->dev, "Device reset during configuration process, status: %#02x!\n",
 				data->device_status.status_code);
 		error = -EINVAL;
 		goto error_exit;
 	}
 
-	error = setup_debugfs(fc);
+	error = setup_debugfs(fn);
 	if (error)
-		dev_warn(&fc->dev, "Failed to setup debugfs, error: %d.\n",
+		dev_warn(&fn->dev, "Failed to setup debugfs, error: %d.\n",
 			 error);
 
 	return 0;
@@ -1066,75 +1066,75 @@ static int rmi_f01_initialize(struct rmi_function_container *fc)
 	return error;
 }
 
-static int rmi_f01_config(struct rmi_function_container *fc)
+static int rmi_f01_config(struct rmi_function *fn)
 {
-	struct f01_data *data = fc->data;
+	struct f01_data *data = fn->data;
 	int retval;
 
-	retval = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0) {
-		dev_err(&fc->dev, "Failed to write device_control.reg.\n");
+		dev_err(&fn->dev, "Failed to write device_control.reg.\n");
 		return retval;
 	}
 
-	retval = rmi_write_block(fc->rmi_dev, data->interrupt_enable_addr,
+	retval = rmi_write_block(fn->rmi_dev, data->interrupt_enable_addr,
 			data->device_control.interrupt_enable,
 			sizeof(u8)*(data->num_of_irq_regs));
 
 	if (retval < 0) {
-		dev_err(&fc->dev, "Failed to write interrupt enable.\n");
+		dev_err(&fn->dev, "Failed to write interrupt enable.\n");
 		return retval;
 	}
 	if (data->basic_queries.has_lts) {
-		retval = rmi_write_block(fc->rmi_dev, data->doze_interval_addr,
+		retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
 				&data->device_control.doze_interval,
 				sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fc->dev, "Failed to write doze interval.\n");
+			dev_err(&fn->dev, "Failed to write doze interval.\n");
 			return retval;
 		}
 	}
 
 	if (data->basic_queries.has_adjustable_doze) {
 		retval = rmi_write_block(
-				fc->rmi_dev, data->wakeup_threshold_addr,
+				fn->rmi_dev, data->wakeup_threshold_addr,
 				&data->device_control.wakeup_threshold,
 				sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fc->dev, "Failed to write wakeup threshold.\n");
+			dev_err(&fn->dev, "Failed to write wakeup threshold.\n");
 			return retval;
 		}
 	}
 
 	if (data->basic_queries.has_adjustable_doze_holdoff) {
-		retval = rmi_write_block(fc->rmi_dev, data->doze_holdoff_addr,
+		retval = rmi_write_block(fn->rmi_dev, data->doze_holdoff_addr,
 				&data->device_control.doze_holdoff,
 				sizeof(u8));
 		if (retval < 0) {
-			dev_err(&fc->dev, "Failed to write doze holdoff.\n");
+			dev_err(&fn->dev, "Failed to write doze holdoff.\n");
 			return retval;
 		}
 	}
 	return 0;
 }
 
-static int f01_device_init(struct rmi_function_container *fc)
+static int f01_device_init(struct rmi_function *fn)
 {
 	struct rmi_driver_data *driver_data =
-			dev_get_drvdata(&fc->rmi_dev->dev);
+			dev_get_drvdata(&fn->rmi_dev->dev);
 	int error;
 
-	error = rmi_f01_alloc_memory(fc, driver_data->num_of_irq_regs);
+	error = rmi_f01_alloc_memory(fn, driver_data->num_of_irq_regs);
 	if (error)
 		return error;
 
-	error = rmi_f01_initialize(fc);
+	error = rmi_f01_initialize(fn);
 	if (error)
 		return error;
 
-	error = sysfs_create_group(&fc->dev.kobj, &rmi_fn_01_attr_group);
+	error = sysfs_create_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
 	if (error)
 		return error;
 
@@ -1142,10 +1142,10 @@ static int f01_device_init(struct rmi_function_container *fc)
 }
 
 #ifdef CONFIG_PM
-static int rmi_f01_suspend(struct rmi_function_container *fc)
+static int rmi_f01_suspend(struct rmi_function *fn)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f01_data *data = fc->data;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f01_data *data = fn->data;
 	int retval = 0;
 
 	if (data->suspended)
@@ -1156,11 +1156,11 @@ static int rmi_f01_suspend(struct rmi_function_container *fc)
 	data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_SENSOR_SLEEP;
 
 	retval = rmi_write_block(rmi_dev,
-			fc->fd.control_base_addr,
+			fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0) {
-		dev_err(&fc->dev, "Failed to write sleep mode. Code: %d.\n",
+		dev_err(&fn->dev, "Failed to write sleep mode. Code: %d.\n",
 			retval);
 		data->device_control.ctrl0.nosleep = data->old_nosleep;
 		data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;
@@ -1172,10 +1172,10 @@ static int rmi_f01_suspend(struct rmi_function_container *fc)
 	return retval;
 }
 
-static int rmi_f01_resume(struct rmi_function_container *fc)
+static int rmi_f01_resume(struct rmi_function *fn)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f01_data *data = fc->data;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f01_data *data = fn->data;
 	int retval = 0;
 
 	if (!data->suspended)
@@ -1184,11 +1184,11 @@ static int rmi_f01_resume(struct rmi_function_container *fc)
 	data->device_control.ctrl0.nosleep = data->old_nosleep;
 	data->device_control.ctrl0.sleep_mode = RMI_SLEEP_MODE_NORMAL;
 
-	retval = rmi_write_block(rmi_dev, fc->fd.control_base_addr,
+	retval = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
 			&data->device_control.ctrl0,
 			sizeof(data->device_control.ctrl0));
 	if (retval < 0)
-		dev_err(&fc->dev,
+		dev_err(&fn->dev,
 			"Failed to restore normal operation. Code: %d.\n",
 			retval);
 	else {
@@ -1202,30 +1202,30 @@ static int rmi_f01_resume(struct rmi_function_container *fc)
 
 static int f01_remove(struct device *dev)
 {
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
+	struct rmi_function *fn = to_rmi_function(dev);
 
-	teardown_debugfs(fc->data);
-	sysfs_remove_group(&fc->dev.kobj, &rmi_fn_01_attr_group);
+	teardown_debugfs(fn->data);
+	sysfs_remove_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
 
 	return 0;
 }
 
-static int rmi_f01_attention(struct rmi_function_container *fc,
+static int rmi_f01_attention(struct rmi_function *fn,
 						unsigned long *irq_bits)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f01_data *data = fc->data;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f01_data *data = fn->data;
 	int retval;
 
-	retval = rmi_read_block(rmi_dev, fc->fd.data_base_addr,
+	retval = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
 		&data->device_status, sizeof(data->device_status));
 	if (retval < 0) {
-		dev_err(&fc->dev, "Failed to read device status, code: %d.\n",
+		dev_err(&fn->dev, "Failed to read device status, code: %d.\n",
 			retval);
 		return retval;
 	}
 	if (data->device_status.unconfigured) {
-		dev_warn(&fc->dev, "Device reset detected.\n");
+		dev_warn(&fn->dev, "Device reset detected.\n");
 		retval = rmi_dev->driver->reset_handler(rmi_dev);
 		if (retval < 0)
 			return retval;
@@ -1235,16 +1235,16 @@ static int rmi_f01_attention(struct rmi_function_container *fc,
 
 static int f01_probe(struct device *dev)
 {
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 
 	if (dev->type != &rmi_function_type)
 		return 1;
 
-	fc = to_rmi_function_container(dev);
-	if (fc->fd.function_number != FUNCTION_NUMBER)
+	fn = to_rmi_function(dev);
+	if (fn->fd.function_number != FUNCTION_NUMBER)
 		return 1;
 
-	return f01_device_init(fc);
+	return f01_device_init(fn);
 }
 
 static struct rmi_function_handler function_handler = {
diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index b9a84bc..dd270b4 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -825,7 +825,7 @@ struct f11_2d_sensor {
 	enum rmi_f11_sensor_type sensor_type;
 	struct input_dev *input;
 	struct input_dev *mouse_input;
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 	char input_phys[NAME_BUFFER_SIZE];
 	char input_phys_mouse[NAME_BUFFER_SIZE];
 
@@ -876,11 +876,11 @@ static ssize_t f11_maxPos_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 	struct f11_data *data;
 
-	fc = to_rmi_function_container(dev);
-	data = fc->data;
+	fn = to_rmi_function(dev);
+	data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%u %u\n",
 			data->sensors[0].max_x, data->sensors[0].max_y);
@@ -890,11 +890,11 @@ static ssize_t f11_relreport_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 	struct f11_data *instance_data;
 
-	fc = to_rmi_function_container(dev);
-	instance_data = fc->data;
+	fn = to_rmi_function(dev);
+	instance_data = fn->data;
 
 	return snprintf(buf, PAGE_SIZE, "%u\n",
 			instance_data->
@@ -906,12 +906,12 @@ static ssize_t f11_relreport_store(struct device *dev,
 					 const char *buf,
 					 size_t count)
 {
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 	struct f11_data *instance_data;
 	unsigned int new_value;
 
-	fc = to_rmi_function_container(dev);
-	instance_data = fc->data;
+	fn = to_rmi_function(dev);
+	instance_data = fn->data;
 
 
 	if (sscanf(buf, "%u", &new_value) != 1)
@@ -927,11 +927,11 @@ static ssize_t f11_rezero_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	struct rmi_function_container *fc = NULL;
+	struct rmi_function *fn = NULL;
 	unsigned int rezero;
 	int retval = 0;
 
-	fc = to_rmi_function_container(dev);
+	fn = to_rmi_function(dev);
 
 	if (sscanf(buf, "%u", &rezero) != 1)
 		return -EINVAL;
@@ -945,7 +945,7 @@ static ssize_t f11_rezero_store(struct device *dev,
 			.rezero = true,
 		};
 
-		retval = rmi_write_block(fc->rmi_dev, fc->fd.command_base_addr,
+		retval = rmi_write_block(fn->rmi_dev, fn->fd.command_base_addr,
 				&commands, sizeof(commands));
 		if (retval < 0) {
 			dev_err(dev, "%s: failed to issue rezero command, error = %d.",
@@ -1058,7 +1058,7 @@ static ssize_t delta_threshold_read(struct file *filp, char __user *buffer,
 	int retval;
 	char *local_buf;
 	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fc->data;
+	struct f11_data *f11 = data->sensor->fn->data;
 	struct f11_2d_ctrl *ctrl = &f11->dev_controls;
 
 	if (data->done)
@@ -1090,9 +1090,9 @@ static ssize_t delta_threshold_write(struct file *filp,
 	u8 save_X, save_Y;
 	int rc;
 	struct sensor_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->sensor->fc->data;
+	struct f11_data *f11 = data->sensor->fn->data;
 	struct f11_2d_ctrl *ctrl = &f11->dev_controls;
-	struct rmi_device *rmi_dev =  data->sensor->fc->rmi_dev;
+	struct rmi_device *rmi_dev =  data->sensor->fn->rmi_dev;
 
 	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
 	if (!local_buf)
@@ -1117,7 +1117,7 @@ static ssize_t delta_threshold_write(struct file *filp,
 	rc = rmi_write_block(rmi_dev, ctrl->ctrl0_9_address,
 			ctrl->ctrl0_9, sizeof(*ctrl->ctrl0_9));
 	if (rc < 0) {
-		dev_warn(&data->sensor->fc->dev,
+		dev_warn(&data->sensor->fn->dev,
 			"Failed to write to delta_threshold. Code: %d.\n",
 			rc);
 		ctrl->ctrl0_9->delta_x_threshold = save_X;
@@ -1392,58 +1392,58 @@ static int setup_sensor_debugfs(struct f11_2d_sensor *sensor)
 {
 	int retval = 0;
 	char fname[NAME_BUFFER_SIZE];
-	struct rmi_function_container *fc = sensor->fc;
+	struct rmi_function *fn = sensor->fn;
 
-	if (!fc->debugfs_root)
+	if (!fn->debugfs_root)
 		return -ENODEV;
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "flip.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_flip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor, &flip_fops);
+				fn->debugfs_root, sensor, &flip_fops);
 	if (!sensor->debugfs_flip)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "clip.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor, &clip_fops);
+				fn->debugfs_root, sensor, &clip_fops);
 	if (!sensor->debugfs_clip)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "delta_threshold.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_clip = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor,
+				fn->debugfs_root, sensor,
 				&delta_threshold_fops);
 	if (!sensor->debugfs_delta_threshold)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "offset.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_offset = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor, &offset_fops);
+				fn->debugfs_root, sensor, &offset_fops);
 	if (!sensor->debugfs_offset)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "swap.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_swap = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor, &swap_fops);
+				fn->debugfs_root, sensor, &swap_fops);
 	if (!sensor->debugfs_swap)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	retval = snprintf(fname, NAME_BUFFER_SIZE, "type_a.%d",
 			  sensor->sensor_index);
 	sensor->debugfs_type_a = debugfs_create_file(fname, RMI_RW_ATTR,
-				fc->debugfs_root, sensor, &type_a_fops);
+				fn->debugfs_root, sensor, &type_a_fops);
 	if (!sensor->debugfs_type_a)
-		dev_warn(&fc->dev, "Failed to create debugfs %s.\n",
+		dev_warn(&fn->dev, "Failed to create debugfs %s.\n",
 			 fname);
 
 	return retval;
@@ -1469,20 +1469,20 @@ static void teardown_sensor_debugfs(struct f11_2d_sensor *sensor)
 
 struct f11_debugfs_data {
 	bool done;
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 };
 
 static int f11_debug_open(struct inode *inodep, struct file *filp)
 {
 	struct f11_debugfs_data *data;
-	struct rmi_function_container *fc = inodep->i_private;
+	struct rmi_function *fn = inodep->i_private;
 
-	data = devm_kzalloc(&fc->dev, sizeof(struct f11_debugfs_data),
+	data = devm_kzalloc(&fn->dev, sizeof(struct f11_debugfs_data),
 		GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->fc = fc;
+	data->fn = fn;
 	filp->private_data = data;
 	return 0;
 }
@@ -1492,7 +1492,7 @@ static ssize_t rezero_wait_read(struct file *filp, char __user *buffer,
 	int retval;
 	char *local_buf;
 	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fc->data;
+	struct f11_data *f11 = data->fn->data;
 
 	if (data->done)
 		return 0;
@@ -1519,7 +1519,7 @@ static ssize_t rezero_wait_write(struct file *filp, const char __user *buffer,
 	char *local_buf;
 	int new_value;
 	struct f11_debugfs_data *data = filp->private_data;
-	struct f11_data *f11 = data->fc->data;
+	struct f11_data *f11 = data->fn->data;
 
 	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
 	if (!local_buf)
@@ -1547,17 +1547,17 @@ static const struct file_operations rezero_wait_fops = {
 	.write = rezero_wait_write,
 };
 
-static int setup_f11_debugfs(struct rmi_function_container *fc)
+static int setup_f11_debugfs(struct rmi_function *fn)
 {
-	struct f11_data *f11 = fc->data;
+	struct f11_data *f11 = fn->data;
 
-	if (!fc->debugfs_root)
+	if (!fn->debugfs_root)
 		return -ENODEV;
 
 	f11->debugfs_rezero_wait = debugfs_create_file("rezero_wait",
-		RMI_RW_ATTR, fc->debugfs_root, fc, &rezero_wait_fops);
+		RMI_RW_ATTR, fn->debugfs_root, fn, &rezero_wait_fops);
 	if (!f11->debugfs_rezero_wait)
-		dev_warn(&fc->dev,
+		dev_warn(&fn->dev,
 			 "Failed to create debugfs rezero_wait.\n");
 
 	return 0;
@@ -1698,7 +1698,7 @@ static void rmi_f11_abs_pos_report(struct f11_data *f11,
 		input_report_abs(sensor->input, ABS_MT_ORIENTATION, orient);
 		input_report_abs(sensor->input, ABS_MT_POSITION_X, x);
 		input_report_abs(sensor->input, ABS_MT_POSITION_Y, y);
-		dev_dbg(&sensor->fc->dev,
+		dev_dbg(&sensor->fn->dev,
 			"finger[%d]:%d - x:%d y:%d z:%d w_max:%d w_min:%d\n",
 			n_finger, finger_state, x, y, z, w_max, w_min);
 	}
@@ -1840,9 +1840,9 @@ static int f11_2d_construct_data(struct f11_2d_sensor *sensor)
 	return 0;
 }
 
-static int f11_read_control_regs(struct rmi_function_container *fc,
+static int f11_read_control_regs(struct rmi_function *fn,
 				struct f11_2d_ctrl *ctrl, u16 ctrl_base_addr) {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
 	u16 read_address = ctrl_base_addr;
 	int error = 0;
 
@@ -1850,7 +1850,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 	error = rmi_read_block(rmi_dev, read_address, ctrl->ctrl0_9,
 		sizeof(*ctrl->ctrl0_9));
 	if (error < 0) {
-		dev_err(&fc->dev, "Failed to read ctrl0, code: %d.\n", error);
+		dev_err(&fn->dev, "Failed to read ctrl0, code: %d.\n", error);
 		return error;
 	}
 	read_address += sizeof(*ctrl->ctrl0_9);
@@ -1859,7 +1859,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl10, sizeof(*ctrl->ctrl10));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl10, code: %d.\n", error);
 			return error;
 		}
@@ -1870,7 +1870,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl11, sizeof(*ctrl->ctrl11));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl11, code: %d.\n", error);
 			return error;
 		}
@@ -1881,7 +1881,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl14, sizeof(*ctrl->ctrl14));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl14, code: %d.\n", error);
 			return error;
 		}
@@ -1892,7 +1892,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl15, sizeof(*ctrl->ctrl15));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl15, code: %d.\n", error);
 			return error;
 		}
@@ -1903,7 +1903,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl16, sizeof(*ctrl->ctrl16));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl16, code: %d.\n", error);
 			return error;
 		}
@@ -1914,7 +1914,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl17, sizeof(*ctrl->ctrl17));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl17, code: %d.\n", error);
 			return error;
 		}
@@ -1925,7 +1925,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl18_19, sizeof(*ctrl->ctrl18_19));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl18_19, code: %d.\n", error);
 			return error;
 		}
@@ -1936,7 +1936,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl20_21, sizeof(*ctrl->ctrl20_21));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl20_21, code: %d.\n", error);
 			return error;
 		}
@@ -1947,7 +1947,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl22_26, sizeof(*ctrl->ctrl22_26));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl22_26, code: %d.\n", error);
 			return error;
 		}
@@ -1958,7 +1958,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl27, sizeof(*ctrl->ctrl27));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl27, code: %d.\n", error);
 			return error;
 		}
@@ -1969,7 +1969,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl28, sizeof(*ctrl->ctrl28));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl28, code: %d.\n", error);
 			return error;
 		}
@@ -1980,7 +1980,7 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 		error = rmi_read_block(rmi_dev, read_address,
 			ctrl->ctrl29_30, sizeof(*ctrl->ctrl29_30));
 		if (error < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read ctrl29_30, code: %d.\n", error);
 			return error;
 		}
@@ -1989,39 +1989,39 @@ static int f11_read_control_regs(struct rmi_function_container *fc,
 	return 0;
 }
 
-static int f11_allocate_control_regs(struct rmi_function_container *fc,
+static int f11_allocate_control_regs(struct rmi_function *fn,
 				struct f11_2d_device_query *device_query,
 				struct f11_2d_sensor_queries *sensor_query,
 				struct f11_2d_ctrl *ctrl,
 				u16 ctrl_base_addr) {
 
-	ctrl->ctrl0_9 = devm_kzalloc(&fc->dev, sizeof(struct f11_2d_ctrl0_9),
+	ctrl->ctrl0_9 = devm_kzalloc(&fn->dev, sizeof(struct f11_2d_ctrl0_9),
 				       GFP_KERNEL);
 	if (!ctrl->ctrl0_9)
 		return -ENOMEM;
 	if (has_gesture_bits(&sensor_query->gesture_info, 0)) {
-		ctrl->ctrl10 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl10 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl10), GFP_KERNEL);
 		if (!ctrl->ctrl10)
 			return -ENOMEM;
 	}
 
 	if (has_gesture_bits(&sensor_query->gesture_info, 1)) {
-		ctrl->ctrl11 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl11 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl11), GFP_KERNEL);
 		if (!ctrl->ctrl11)
 			return -ENOMEM;
 	}
 
 	if (device_query->has_query9 && sensor_query->query9.has_pen) {
-		ctrl->ctrl20_21 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl20_21 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl20_21), GFP_KERNEL);
 		if (!ctrl->ctrl20_21)
 			return -ENOMEM;
 	}
 
 	if (device_query->has_query9 && sensor_query->query9.has_proximity) {
-		ctrl->ctrl22_26 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl22_26 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl22_26), GFP_KERNEL);
 		if (!ctrl->ctrl22_26)
 			return -ENOMEM;
@@ -2030,14 +2030,14 @@ static int f11_allocate_control_regs(struct rmi_function_container *fc,
 	if (device_query->has_query9 &&
 		(sensor_query->query9.has_palm_det_sensitivity ||
 		sensor_query->query9.has_suppress_on_palm_detect)) {
-		ctrl->ctrl27 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl27 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl27), GFP_KERNEL);
 		if (!ctrl->ctrl27)
 			return -ENOMEM;
 	}
 
 	if (sensor_query->gesture_info.has_multi_finger_scroll) {
-		ctrl->ctrl28 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl28 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl28), GFP_KERNEL);
 		if (!ctrl->ctrl28)
 			return -ENOMEM;
@@ -2045,7 +2045,7 @@ static int f11_allocate_control_regs(struct rmi_function_container *fc,
 
 	if (device_query->has_query11 &&
 			sensor_query->features_1.has_z_tuning) {
-		ctrl->ctrl29_30 = devm_kzalloc(&fc->dev,
+		ctrl->ctrl29_30 = devm_kzalloc(&fn->dev,
 			sizeof(struct f11_2d_ctrl29_30), GFP_KERNEL);
 		if (!ctrl->ctrl29_30)
 			return -ENOMEM;
@@ -2054,12 +2054,12 @@ static int f11_allocate_control_regs(struct rmi_function_container *fc,
 	return 0;
 }
 
-static int f11_write_control_regs(struct rmi_function_container *fc,
+static int f11_write_control_regs(struct rmi_function *fn,
 					struct f11_2d_sensor_queries *query,
 					struct f11_2d_ctrl *ctrl,
 					u16 ctrl_base_addr)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
 	u16 write_address = ctrl_base_addr;
 	int error;
 
@@ -2269,9 +2269,9 @@ static int rmi_f11_get_query_parameters(struct rmi_device *rmi_dev,
 /* This operation is done in a number of places, so we have a handy routine
  * for it.
  */
-static void f11_set_abs_params(struct rmi_function_container *fc, int index)
+static void f11_set_abs_params(struct rmi_function *fn, int index)
 {
-	struct f11_data *f11 = fc->data;
+	struct f11_data *f11 = fn->data;
 	struct f11_2d_sensor *sensor = &f11->sensors[index];
 	struct input_dev *input = sensor->input;
 	int device_x_max =
@@ -2314,7 +2314,7 @@ static void f11_set_abs_params(struct rmi_function_container *fc, int index)
 	else
 		y_max = device_y_max;
 
-	dev_dbg(&fc->dev, "Set ranges X=[%d..%d] Y=[%d..%d].",
+	dev_dbg(&fn->dev, "Set ranges X=[%d..%d] Y=[%d..%d].",
 			x_min, x_max, y_min, y_max);
 
 	input_set_abs_params(input, ABS_MT_PRESSURE, 0,
@@ -2344,9 +2344,9 @@ static void f11_set_abs_params(struct rmi_function_container *fc, int index)
 				     0, MT_TOOL_FINGER, 0, 0);
 }
 
-static int rmi_f11_initialize(struct rmi_function_container *fc)
+static int rmi_f11_initialize(struct rmi_function *fn)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
 	struct f11_data *f11;
 	struct f11_2d_ctrl *ctrl;
 	u8 query_offset;
@@ -2357,21 +2357,21 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 	int i;
 	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
 
-	dev_dbg(&fc->dev, "Initializing F11 values for %s.\n",
+	dev_dbg(&fn->dev, "Initializing F11 values for %s.\n",
 		 pdata->sensor_name);
 
 	/*
 	** init instance data, fill in values and create any sysfs files
 	*/
-	f11 = devm_kzalloc(&fc->dev, sizeof(struct f11_data), GFP_KERNEL);
+	f11 = devm_kzalloc(&fn->dev, sizeof(struct f11_data), GFP_KERNEL);
 	if (!f11)
 		return -ENOMEM;
 
-	fc->data = f11;
+	fn->data = f11;
 	f11->rezero_wait_ms = pdata->f11_rezero_wait;
 
-	query_base_addr = fc->fd.query_base_addr;
-	control_base_addr = fc->fd.control_base_addr;
+	query_base_addr = fn->fd.query_base_addr;
+	control_base_addr = fn->fd.control_base_addr;
 
 	rc = rmi_read(rmi_dev, query_base_addr, &f11->dev_query);
 	if (rc < 0)
@@ -2382,7 +2382,7 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
 		struct f11_2d_sensor *sensor = &f11->sensors[i];
 		sensor->sensor_index = i;
-		sensor->fc = fc;
+		sensor->fn = fn;
 
 		rc = rmi_f11_get_query_parameters(rmi_dev, &f11->dev_query,
 				&sensor->sens_query, query_offset);
@@ -2390,19 +2390,19 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 			return rc;
 		query_offset += rc;
 
-		rc = f11_allocate_control_regs(fc,
+		rc = f11_allocate_control_regs(fn,
 				&f11->dev_query, &sensor->sens_query,
 				&f11->dev_controls, control_base_addr);
 		if (rc < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to allocate F11 control params.\n");
 			return rc;
 		}
 
-		rc = f11_read_control_regs(fc, &f11->dev_controls,
+		rc = f11_read_control_regs(fn, &f11->dev_controls,
 				control_base_addr);
 		if (rc < 0) {
-			dev_err(&fc->dev,
+			dev_err(&fn->dev,
 				"Failed to read F11 control params.\n");
 			return rc;
 		}
@@ -2448,7 +2448,7 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 					ctrl->ctrl0_9,
 					sizeof(*ctrl->ctrl0_9));
 			if (rc < 0)
-				dev_warn(&fc->dev, "Failed to write to delta_x_threshold %d. Code: %d.\n",
+				dev_warn(&fn->dev, "Failed to write to delta_x_threshold %d. Code: %d.\n",
 					i, rc);
 
 		}
@@ -2461,22 +2461,22 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 					ctrl->ctrl0_9,
 					sizeof(*ctrl->ctrl0_9));
 			if (rc < 0)
-				dev_warn(&fc->dev, "Failed to write to delta_y_threshold %d. Code: %d.\n",
+				dev_warn(&fn->dev, "Failed to write to delta_y_threshold %d. Code: %d.\n",
 					i, rc);
 		}
 
 		if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 			rc = setup_sensor_debugfs(sensor);
 			if (rc < 0)
-				dev_warn(&fc->dev, "Failed to setup debugfs for F11 sensor %d. Code: %d.\n",
+				dev_warn(&fn->dev, "Failed to setup debugfs for F11 sensor %d. Code: %d.\n",
 					i, rc);
 		}
 	}
 
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		rc = setup_f11_debugfs(fc);
+		rc = setup_f11_debugfs(fn);
 		if (rc < 0)
-			dev_warn(&fc->dev, "Failed to setup debugfs for F11. Code: %d.\n",
+			dev_warn(&fn->dev, "Failed to setup debugfs for F11. Code: %d.\n",
 				rc);
 	}
 
@@ -2484,10 +2484,10 @@ static int rmi_f11_initialize(struct rmi_function_container *fc)
 	return 0;
 }
 
-static int rmi_f11_register_devices(struct rmi_function_container *fc)
+static int rmi_f11_register_devices(struct rmi_function *fn)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f11_data *f11 = fc->data;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f11_data *f11 = fn->data;
 	struct input_dev *input_dev;
 	struct input_dev *input_dev_mouse;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
@@ -2513,14 +2513,14 @@ static int rmi_f11_register_devices(struct rmi_function_container *fc)
 		if (driver->set_input_params) {
 			rc = driver->set_input_params(rmi_dev, input_dev);
 			if (rc < 0) {
-				dev_err(&fc->dev,
+				dev_err(&fn->dev,
 				"%s: Error in setting input device.\n",
 				__func__);
 				goto error_unregister;
 			}
 		}
 		sprintf(sensor->input_phys, "%s.abs%d/input0",
-			dev_name(&fc->dev), i);
+			dev_name(&fn->dev), i);
 		input_dev->phys = sensor->input_phys;
 		input_dev->dev.parent = &rmi_dev->dev;
 		input_set_drvdata(input_dev, f11);
@@ -2529,7 +2529,7 @@ static int rmi_f11_register_devices(struct rmi_function_container *fc)
 		set_bit(EV_ABS, input_dev->evbit);
 		input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
 
-		f11_set_abs_params(fc, i);
+		f11_set_abs_params(fn, i);
 
 		if (sensor->sens_query.info.has_rel) {
 			set_bit(EV_REL, input_dev->evbit);
@@ -2556,14 +2556,14 @@ static int rmi_f11_register_devices(struct rmi_function_container *fc)
 				rc = driver->set_input_params(rmi_dev,
 					input_dev_mouse);
 				if (rc < 0) {
-					dev_err(&fc->dev,
+					dev_err(&fn->dev,
 					"%s: Error in setting input device.\n",
 					__func__);
 					goto error_unregister;
 				}
 			}
 			sprintf(sensor->input_phys_mouse, "%s.rel%d/input0",
-				dev_name(&fc->dev), i);
+				dev_name(&fn->dev), i);
 			set_bit(EV_REL, input_dev_mouse->evbit);
 			set_bit(REL_X, input_dev_mouse->relbit);
 			set_bit(REL_Y, input_dev_mouse->relbit);
@@ -2605,9 +2605,9 @@ error_unregister:
 	return rc;
 }
 
-static void rmi_f11_free_devices(struct rmi_function_container *fc)
+static void rmi_f11_free_devices(struct rmi_function *fn)
 {
-	struct f11_data *f11 = fc->data;
+	struct f11_data *f11 = fn->data;
 	int i;
 
 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
@@ -2618,15 +2618,15 @@ static void rmi_f11_free_devices(struct rmi_function_container *fc)
 	}
 }
 
-static int rmi_f11_create_sysfs(struct rmi_function_container *fc)
+static int rmi_f11_create_sysfs(struct rmi_function *fn)
 {
 	int attr_count = 0;
 	int rc;
 
 	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
 		if (sysfs_create_file
-		    (&fc->dev.kobj, &attrs[attr_count].attr) < 0) {
-			dev_err(&fc->dev, "Failed to create sysfs file for %s.",
+		    (&fn->dev.kobj, &attrs[attr_count].attr) < 0) {
+			dev_err(&fn->dev, "Failed to create sysfs file for %s.",
 				attrs[attr_count].attr.name);
 			rc = -ENODEV;
 			goto err_remove_sysfs;
@@ -2637,19 +2637,19 @@ static int rmi_f11_create_sysfs(struct rmi_function_container *fc)
 
 err_remove_sysfs:
 	for (attr_count--; attr_count >= 0; attr_count--)
-		sysfs_remove_file(&fc->dev.kobj, &attrs[attr_count].attr);
+		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
 	return rc;
 }
 
-static int rmi_f11_config(struct rmi_function_container *fc)
+static int rmi_f11_config(struct rmi_function *fn)
 {
-	struct f11_data *f11 = fc->data;
+	struct f11_data *f11 = fn->data;
 	int i;
 	int rc;
 
 	for (i = 0; i < (f11->dev_query.nbr_of_sensors + 1); i++) {
-		rc = f11_write_control_regs(fc, &f11->sensors[i].sens_query,
-				   &f11->dev_controls, fc->fd.query_base_addr);
+		rc = f11_write_control_regs(fn, &f11->sensors[i].sens_query,
+				   &f11->dev_controls, fn->fd.query_base_addr);
 		if (rc < 0)
 			return rc;
 	}
@@ -2657,12 +2657,12 @@ static int rmi_f11_config(struct rmi_function_container *fc)
 	return 0;
 }
 
-int rmi_f11_attention(struct rmi_function_container *fc,
+int rmi_f11_attention(struct rmi_function *fn,
 						unsigned long *irq_bits)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f11_data *f11 = fc->data;
-	u16 data_base_addr = fc->fd.data_base_addr;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f11_data *f11 = fn->data;
+	u16 data_base_addr = fn->fd.data_base_addr;
 	u16 data_base_addr_offset = 0;
 	int error;
 	int i;
@@ -2683,26 +2683,26 @@ int rmi_f11_attention(struct rmi_function_container *fc,
 }
 
 #ifdef CONFIG_PM
-static int rmi_f11_resume(struct rmi_function_container *fc)
+static int rmi_f11_resume(struct rmi_function *fn)
 {
-	struct rmi_device *rmi_dev = fc->rmi_dev;
-	struct f11_data *data = fc->data;
+	struct rmi_device *rmi_dev = fn->rmi_dev;
+	struct f11_data *data = fn->data;
 	/* Command register always reads as 0, so we can just use a local. */
 	struct f11_2d_commands commands = {
 		.rezero = true,
 	};
 	int retval = 0;
 
-	dev_dbg(&fc->dev, "Resuming...\n");
+	dev_dbg(&fn->dev, "Resuming...\n");
 	if (!data->rezero_wait_ms)
 		return 0;
 
 	mdelay(data->rezero_wait_ms);
 
-	retval = rmi_write_block(rmi_dev, fc->fd.command_base_addr,
+	retval = rmi_write_block(rmi_dev, fn->fd.command_base_addr,
 			&commands, sizeof(commands));
 	if (retval < 0) {
-		dev_err(&fc->dev, "%s: failed to issue rezero command, error = %d.",
+		dev_err(&fn->dev, "%s: failed to issue rezero command, error = %d.",
 			__func__, retval);
 		return retval;
 	}
@@ -2715,9 +2715,9 @@ static int f11_remove_device(struct device *dev)
 {
 	int attr_count = 0;
 	struct f11_data *f11;
-	struct rmi_function_container *fc = to_rmi_function_container(dev);
+	struct rmi_function *fn = to_rmi_function(dev);
 
-	f11 = fc->data;
+	f11 = fn->data;
 
 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 		int i;
@@ -2728,25 +2728,25 @@ static int f11_remove_device(struct device *dev)
 	}
 
 	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
-		sysfs_remove_file(&fc->dev.kobj, &attrs[attr_count].attr);
+		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
 
-	rmi_f11_free_devices(fc);
+	rmi_f11_free_devices(fn);
 	return 0;
 }
 
-static int f11_device_init(struct rmi_function_container *fc)
+static int f11_device_init(struct rmi_function *fn)
 {
 	int rc;
 
-	rc = rmi_f11_initialize(fc);
+	rc = rmi_f11_initialize(fn);
 	if (rc < 0)
 		return rc;
 
-	rc = rmi_f11_register_devices(fc);
+	rc = rmi_f11_register_devices(fn);
 	if (rc < 0)
 		return rc;
 
-	rc = rmi_f11_create_sysfs(fc);
+	rc = rmi_f11_create_sysfs(fn);
 	if (rc < 0)
 		return rc;
 
@@ -2755,16 +2755,16 @@ static int f11_device_init(struct rmi_function_container *fc)
 
 static __devinit int f11_probe(struct device *dev)
 {
-	struct rmi_function_container *fc;
+	struct rmi_function *fn;
 
 	if (dev->type != &rmi_function_type)
 		return 1;
 
-	fc = to_rmi_function_container(dev);
-	if (fc->fd.function_number != FUNCTION_NUMBER)
+	fn = to_rmi_function(dev);
+	if (fn->fd.function_number != FUNCTION_NUMBER)
 		return 1;
 
-	return f11_device_init(fc);
+	return f11_device_init(fn);
 }
 
 
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index a41c874..fa8a352e 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -338,7 +338,7 @@ struct rmi_function_descriptor {
 	u8 function_version;
 };
 
-struct rmi_function_container;
+struct rmi_function;
 struct rmi_device;
 
 /**
@@ -365,13 +365,12 @@ struct rmi_function_handler {
 	struct device_driver driver;
 
 	u8 func;
-	int (*config)(struct rmi_function_container *fc);
-	int (*reset)(struct rmi_function_container *fc);
-	int (*attention)(struct rmi_function_container *fc,
-				unsigned long *irq_bits);
+	int (*config)(struct rmi_function *fn);
+	int (*reset)(struct rmi_function *fn);
+	int (*attention)(struct rmi_function *fn, unsigned long *irq_bits);
 #ifdef CONFIG_PM
-	int (*suspend)(struct rmi_function_container *fc);
-	int (*resume)(struct rmi_function_container *fc);
+	int (*suspend)(struct rmi_function *fn);
+	int (*resume)(struct rmi_function *fn);
 #endif
 };
 
@@ -379,7 +378,7 @@ struct rmi_function_handler {
 		container_of(d, struct rmi_function_handler, driver)
 
 /**
- * struct rmi_function_container - represents the implementation of an RMI4
+ * struct rmi_function - represents the implementation of an RMI4
  * function for a particular device (basically, a driver for that RMI4 function)
  *
  * @fd: The function descriptor of the RMI function
@@ -396,8 +395,7 @@ struct rmi_function_handler {
  * @debugfs_root: used during debugging
  *
  */
-struct rmi_function_container {
-
+struct rmi_function {
 	struct rmi_function_descriptor fd;
 	struct rmi_device *rmi_dev;
 	struct device dev;
@@ -412,8 +410,8 @@ struct rmi_function_container {
 #endif
 };
 
-#define to_rmi_function_container(d) \
-		container_of(d, struct rmi_function_container, dev)
+#define to_rmi_function(d) \
+		container_of(d, struct rmi_function, dev)
 
 /**
  * struct rmi_driver - driver for an RMI4 sensor on the RMI bus.
-- 
1.7.11.7

