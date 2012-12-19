Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2LSAsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:48:17 -0500
Received: from [12.239.217.82] ([12.239.217.82]:38224 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755292Ab2LSAsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:48:07 -0500
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 02/05] input: Core files
Date: Tue, 18 Dec 2012 16:46:33 -0800
Message-Id: <1355877996-1433-3-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
References: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the changes described in 0/0 of this patch set, these files
are updated as follows:

* initialization sequence rearranged to support the merging of rmi_f01 and
rmi_driver into the RMI4 core.

* the initial reset and firmware update PDT scans are split into their own
functions in order to account for the fact that the PDT may change after
the initial reset.

* Problems with release_rmidev_device() identified by Greg KH are fixed and
tested.

* EXPORT_SYMBOL() changed to EXPORT_SYMBOL_GPL(), per Greg KH input.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_bus.c    |  232 ++++++++-------
 drivers/input/rmi4/rmi_driver.c |  655 ++++++++++++++++++++-------------------
 drivers/input/rmi4/rmi_driver.h |   32 +--
 3 files changed, 468 insertions(+), 451 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
index acbfd3d..71bc201 100644
--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -2,19 +2,9 @@
  * Copyright (c) 2011, 2012 Synaptics Incorporated
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
@@ -75,7 +65,8 @@ static struct dentry *rmi_debugfs_root;

 static void release_rmidev_device(struct device *dev)
 {
-	device_unregister(dev);
+	struct rmi_device *rmi_dev = to_rmi_device(dev);
+	kfree(rmi_dev);
 }

 /**
@@ -110,17 +101,19 @@ int rmi_register_phys_device(struct rmi_phys_device *phys)
 	dev_dbg(phys->dev, "%s: Registered %s as %s.\n", __func__,
 		pdata->sensor_name, dev_name(&rmi_dev->dev));

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_debugfs_root) {
+#ifdef	CONFIG_RMI4_DEBUG
+	if (rmi_debugfs_root) {
 		rmi_dev->debugfs_root = debugfs_create_dir(
 			dev_name(&rmi_dev->dev), rmi_debugfs_root);
 		if (!rmi_dev->debugfs_root)
 			dev_err(&rmi_dev->dev, "Failed to create debugfs root.\n");
 	}
+#endif

 	phys->rmi_dev = rmi_dev;
 	return device_register(&rmi_dev->dev);
 }
-EXPORT_SYMBOL(rmi_register_phys_device);
+EXPORT_SYMBOL_GPL(rmi_register_phys_device);

 /**
  * rmi_unregister_phys_device - unregister a physical device connection
@@ -131,102 +124,84 @@ void rmi_unregister_phys_device(struct rmi_phys_device *phys)
 {
 	struct rmi_device *rmi_dev = phys->rmi_dev;

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_dev->debugfs_root)
+#ifdef	CONFIG_RMI4_DEBUG
+	if (rmi_dev->debugfs_root)
 		debugfs_remove(rmi_dev->debugfs_root);
+#endif

-	kfree(rmi_dev);
+	device_unregister(&rmi_dev->dev);
 }
-EXPORT_SYMBOL(rmi_unregister_phys_device);
+EXPORT_SYMBOL_GPL(rmi_unregister_phys_device);

-/**
- * rmi_register_function_handler - register a handler for an RMI function
- * @handler: RMI handler that should be registered.
- * @module: pointer to module that implements the handler
- * @mod_name: name of the module implementing the handler
- *
- * This function performs additional setup of RMI function handler and
- * registers it with the RMI core so that it can be bound to
- * RMI function devices.
- */
-int __rmi_register_function_handler(struct rmi_function_handler *handler,
-				     struct module *owner,
-				     const char *mod_name)
+static int rmi_bus_match(struct device *dev, struct device_driver *drv)
 {
-	int error;
+	struct rmi_function_driver *fn_drv;
+	struct rmi_function_dev *fn;

-	handler->driver.bus = &rmi_bus_type;
-	handler->driver.owner = owner;
-	handler->driver.mod_name = mod_name;
+	/*
+	 * This seems a little broken to me.  It  means a system can only ever
+	 * have one kind of sensor driver.  It'll work for now, but I think in
+	 * the long run we need to revisit this.
+	 */
+	if (dev->type == &rmi_sensor_type && drv == &rmi_sensor_driver.driver)
+		return 1;

-	error = driver_register(&handler->driver);
-	if (error) {
-		pr_err("driver_register() failed for %s, error: %d\n",
-			handler->driver.name, error);
-		return error;
-	}
+	if (dev->type != &rmi_function_type)
+		return 0;

-	return 0;
-}
-EXPORT_SYMBOL(__rmi_register_function_handler);
+	fn = to_rmi_function_dev(dev);
+	fn_drv = to_rmi_function_driver(drv);

-/**
- * rmi_unregister_function_handler - unregister given RMI function handler
- * @handler: RMI handler that should be unregistered.
- *
- * This function unregisters given function handler from RMI core which
- * causes it to be unbound from the function devices.
- */
-void rmi_unregister_function_handler(struct rmi_function_handler *handler)
-{
-	driver_unregister(&handler->driver);
+	return fn->fd.function_number == fn_drv->func;
 }
-EXPORT_SYMBOL(rmi_unregister_function_handler);

-
-static int rmi_function_match(struct device *dev, struct device_driver *drv)
+static int rmi_function_probe(struct device *dev)
 {
-	struct rmi_function_handler *handler;
-	struct rmi_function *fn;
+	struct rmi_function_driver *fn_drv;
+	struct rmi_function_dev *fn = to_rmi_function_dev(dev);

-	if (dev->type != &rmi_function_type)
-		return 0;
+	fn_drv = to_rmi_function_driver(dev->driver);

-	if (drv == &rmi_sensor_driver.driver)
-		return 0;
+	if (fn_drv->probe)
+		return fn_drv->probe(fn);

-	fn = to_rmi_function(dev);
-	handler = to_rmi_function_handler(drv);
-
-	return fn->fd.function_number == handler->func;
+	return 0;
 }

-static int rmi_function_probe(struct device *dev)
+static int rmi_function_remove(struct device *dev)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct rmi_function_handler *handler =
-					to_rmi_function_handler(dev->driver);
-	int error;
+	struct rmi_function_driver *fn_drv;
+	struct rmi_function_dev *fn = to_rmi_function_dev(dev);

-	if (handler->probe) {
-		error = handler->probe(fn);
-		return error;
-	}
+	fn_drv = to_rmi_function_driver(dev->driver);
+
+	if (fn_drv->remove)
+		return fn_drv->remove(fn);

 	return 0;
 }

-static int rmi_function_remove(struct device *dev)
+static int rmi_sensor_remove(struct device *dev)
 {
-	struct rmi_function *fn = to_rmi_function(dev);
-	struct rmi_function_handler *handler =
-					to_rmi_function_handler(dev->driver);
+	struct rmi_driver *driver;
+	struct rmi_device *rmi_dev = to_rmi_device(dev);

-	if (handler->remove)
-		handler->remove(fn);
+	driver = to_rmi_driver(dev->driver);

+	if (!driver->remove)
+		return driver->remove(rmi_dev);
 	return 0;
 }

+static int rmi_bus_remove(struct device *dev)
+{
+	if (dev->type == &rmi_function_type)
+		return rmi_function_remove(dev);
+	else if (dev->type == &rmi_sensor_type)
+		return rmi_sensor_remove(dev);
+	return -EINVAL;
+}
+
 #ifdef CONFIG_PM
 static int rmi_bus_suspend(struct device *dev)
 {
@@ -267,12 +242,58 @@ static SIMPLE_DEV_PM_OPS(rmi_bus_pm_ops,
 			 rmi_bus_suspend, rmi_bus_resume);

 struct bus_type rmi_bus_type = {
-	.match		= rmi_function_match,
-	.probe		= rmi_function_probe,
-	.remove		= rmi_function_remove,
 	.name		= "rmi",
+	.match		= rmi_bus_match,
+	.remove		= rmi_bus_remove,
 	.pm		= &rmi_bus_pm_ops,
 };
+EXPORT_SYMBOL_GPL(rmi_bus_type);
+
+/**
+ * rmi_register_function_driver - register a driver for an RMI function
+ * @fn_drv: RMI driver that should be registered.
+ * @module: pointer to module that implements the driver
+ * @mod_name: name of the module implementing the driver
+ *
+ * This function performs additional setup of RMI function driver and
+ * registers it with the RMI core so that it can be bound to
+ * RMI function devices.
+ */
+int __rmi_register_function_driver(struct rmi_function_driver *fn_drv,
+				     struct module *owner,
+				     const char *mod_name)
+{
+	int error;
+
+	fn_drv->driver.bus = &rmi_bus_type;
+	fn_drv->driver.owner = owner;
+	if (!fn_drv->driver.probe)
+		fn_drv->driver.probe = rmi_function_probe;
+	fn_drv->driver.mod_name = mod_name;
+
+	error = driver_register(&fn_drv->driver);
+	if (error) {
+		pr_err("driver_register() failed for %s, error: %d\n",
+			fn_drv->driver.name, error);
+		return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__rmi_register_function_driver);
+
+/**
+ * rmi_unregister_function_driver - unregister given RMI function driver
+ * @fn_drv: RMI driver that should be unregistered.
+ *
+ * This function unregisters given function driver from RMI core which
+ * causes it to be unbound from the function devices.
+ */
+void rmi_unregister_function_driver(struct rmi_function_driver *fn_drv)
+{
+	driver_unregister(&fn_drv->driver);
+}
+EXPORT_SYMBOL_GPL(rmi_unregister_function_driver);

 /**
  * rmi_for_each_dev - provides a way for other parts of the system to enumerate
@@ -289,7 +310,7 @@ int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data))
 	mutex_unlock(&rmi_bus_mutex);
 	return retval;
 }
-EXPORT_SYMBOL(rmi_for_each_dev);
+EXPORT_SYMBOL_GPL(rmi_for_each_dev);

 static int __init rmi_bus_init(void)
 {
@@ -304,9 +325,21 @@ static int __init rmi_bus_init(void)
 		return error;
 	}

-	error = rmi_register_function_handler(&rmi_f01_handler);
+#ifdef CONFIG_RMI4_DEBUG
+	rmi_debugfs_root = debugfs_create_dir(rmi_bus_type.name, NULL);
+	if (!rmi_debugfs_root)
+		pr_err("%s: Failed to create debugfs root.\n",
+			__func__);
+	else if (IS_ERR(rmi_debugfs_root)) {
+		pr_err("%s: Kernel may not contain debugfs support, code=%ld\n",
+			__func__, PTR_ERR(rmi_debugfs_root));
+		rmi_debugfs_root = NULL;
+	}
+#endif
+
+	error = rmi_register_function_driver(&rmi_f01_driver);
 	if (error) {
-		pr_err("%s: error registering the RMI F01 handler: %d\n",
+		pr_err("%s: error registering the RMI F01 driver: %d\n",
 			__func__, error);
 		goto err_unregister_bus;
 	}
@@ -318,22 +351,10 @@ static int __init rmi_bus_init(void)
 		goto err_unregister_f01;
 	}

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		rmi_debugfs_root = debugfs_create_dir(rmi_bus_type.name, NULL);
-		if (!rmi_debugfs_root)
-			pr_err("%s: Failed to create debugfs root.\n",
-			       __func__);
-		else if (IS_ERR(rmi_debugfs_root)) {
-			pr_err("%s: Kernel may not contain debugfs support, code=%ld\n",
-				__func__, PTR_ERR(rmi_debugfs_root));
-			rmi_debugfs_root = NULL;
-		}
-	}
-
 	return 0;

 err_unregister_f01:
-	rmi_unregister_function_handler(&rmi_f01_handler);
+	rmi_unregister_function_driver(&rmi_f01_driver);
 err_unregister_bus:
 	bus_unregister(&rmi_bus_type);
 	return error;
@@ -345,11 +366,12 @@ static void __exit rmi_bus_exit(void)
 	 * We should only ever get here if all drivers are unloaded, so
 	 * all we have to do at this point is unregister ourselves.
 	 */
-	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_debugfs_root)
+#ifdef CONFIG_RMI4_DEBUG
+	if (rmi_debugfs_root)
 		debugfs_remove(rmi_debugfs_root);
-
+#endif
 	rmi_unregister_sensor_driver();
-	rmi_unregister_function_handler(&rmi_f01_handler);
+	rmi_unregister_function_driver(&rmi_f01_driver);
 	bus_unregister(&rmi_bus_type);
 }

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index bbd23f9..f98ed33 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -2,28 +2,16 @@
  * Copyright (c) 2011, 2012 Synaptics Incorporated
  * Copyright (c) 2011 Unixphere
  *
- * This driver adds support for generic RMI4 devices from Synpatics. It
- * implements the mandatory f01 RMI register and depends on the presence of
- * other required RMI functions.
+ * This driver provides the core support for a single RMI4-based device.
  *
  * The RMI4 specification can be found here (URL split after files/ for
  * style reasons):
  * http://www.synaptics.com/sites/default/files/
  *           511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf
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
@@ -40,7 +28,6 @@
 #include <linux/rmi.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
-#include <uapi/linux/input.h>
 #include "rmi_driver.h"
 #include "rmi_f01.h"

@@ -235,66 +222,6 @@ static const struct file_operations attn_count_fops = {
 	.read = attn_count_read,
 };

-static ssize_t irq_debug_read(struct file *filp, char __user *buffer,
-			size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	struct driver_debugfs_data *data = filp->private_data;
-	struct rmi_driver_data *rmi_data = dev_get_drvdata(&data->rmi_dev->dev);
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
-	retval = snprintf(local_buf, size, "%u\n", rmi_data->irq_debug);
-
-	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
-		retval = -EFAULT;
-	kfree(local_buf);
-
-	return retval;
-}
-
-static ssize_t irq_debug_write(struct file *filp, const char __user *buffer,
-			   size_t size, loff_t *offset) {
-	int retval;
-	char *local_buf;
-	unsigned int new_value;
-	struct driver_debugfs_data *data = filp->private_data;
-	struct rmi_driver_data *rmi_data = dev_get_drvdata(&data->rmi_dev->dev);
-
-
-	local_buf = kcalloc(size, sizeof(u8), GFP_KERNEL);
-	if (!local_buf)
-		return -ENOMEM;
-	retval = copy_from_user(local_buf, buffer, size);
-	if (retval) {
-		kfree(local_buf);
-		return -EFAULT;
-	}
-
-	retval = sscanf(local_buf, "%u", &new_value);
-	if (retval != 1 || new_value > 1)
-		retval = -EINVAL;
-	kfree(local_buf);
-	rmi_data->irq_debug = new_value;
-
-	return size;
-}
-
-static const struct file_operations irq_debug_fops = {
-	.owner = THIS_MODULE,
-	.open = debug_open,
-	.release = debug_release,
-	.read = irq_debug_read,
-	.write = irq_debug_write,
-};
-
 static int setup_debugfs(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
@@ -321,10 +248,8 @@ static int setup_debugfs(struct rmi_device *rmi_dev)
 		data->debugfs_phys = NULL;
 	}

-	data->debugfs_irq = debugfs_create_file("irq_debug",
-			RMI_RW_ATTR,
-			rmi_dev->debugfs_root,
-			rmi_dev, &irq_debug_fops);
+	data->debugfs_irq = debugfs_create_bool("irq_debug",
+			RMI_RW_ATTR, rmi_dev->debugfs_root, &data->irq_debug);
 	if (!data->debugfs_irq || IS_ERR(data->debugfs_irq)) {
 		dev_warn(&rmi_dev->dev, "Failed to create debugfs irq_debug.\n");
 		data->debugfs_irq = NULL;
@@ -594,7 +519,7 @@ static struct device_attribute bsr_attribute = __ATTR(bsr, RMI_RW_ATTR,

 static void rmi_free_function_list(struct rmi_device *rmi_dev)
 {
-	struct rmi_function *entry, *n;
+	struct rmi_function_dev *entry, *n;
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);

 	if (!data) {
@@ -602,7 +527,7 @@ static void rmi_free_function_list(struct rmi_device *rmi_dev)
 		return;
 	}

-	data->f01_container = NULL;
+	data->f01_dev = NULL;

 	if (list_empty(&data->rmi_functions.list))
 		return;
@@ -613,44 +538,43 @@ static void rmi_free_function_list(struct rmi_device *rmi_dev)
 	}
 }

-static void release_function_device(struct device *dev)
+static void release_fndev_device(struct device *dev)
 {
-	dev_dbg(dev, "REMOVING KOBJ!");
 	kobject_put(&dev->kobj);
 }

-static int reset_one_function(struct rmi_function *fn)
+static int reset_one_function(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_function_handler *fh;
+	struct rmi_function_driver *fn_drv;
 	int retval = 0;

-	if (!fn || !fn->dev.driver)
+	if (!fn_dev || !fn_dev->dev.driver)
 		return 0;

-	fh = to_rmi_function_handler(fn->dev.driver);
-	if (fh->reset) {
-		retval = fh->reset(fn);
+	fn_drv = to_rmi_function_driver(fn_dev->dev.driver);
+	if (fn_drv->reset) {
+		retval = fn_drv->reset(fn_dev);
 		if (retval < 0)
-			dev_err(&fn->dev, "Reset failed with code %d.\n",
+			dev_err(&fn_dev->dev, "Reset failed with code %d.\n",
 				retval);
 	}

 	return retval;
 }

-static int configure_one_function(struct rmi_function *fn)
+static int configure_one_function(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_function_handler *fh;
+	struct rmi_function_driver *fn_drv;
 	int retval = 0;

-	if (!fn || !fn->dev.driver)
+	if (!fn_dev || !fn_dev->dev.driver)
 		return 0;

-	fh = to_rmi_function_handler(fn->dev.driver);
-	if (fh->config) {
-		retval = fh->config(fn);
+	fn_drv = to_rmi_function_driver(fn_dev->dev.driver);
+	if (fn_drv->config) {
+		retval = fn_drv->config(fn_dev);
 		if (retval < 0)
-			dev_err(&fn->dev, "Config failed with code %d.\n",
+			dev_err(&fn_dev->dev, "Config failed with code %d.\n",
 				retval);
 	}

@@ -660,7 +584,7 @@ static int configure_one_function(struct rmi_function *fn)
 static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function *entry;
+	struct rmi_function_dev *entry;
 	int retval;

 	if (list_empty(&data->rmi_functions.list))
@@ -678,7 +602,7 @@ static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev)
 static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function *entry;
+	struct rmi_function_dev *entry;
 	int retval;

 	if (list_empty(&data->rmi_functions.list))
@@ -693,21 +617,21 @@ static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev)
 	return 0;
 }

-static void process_one_interrupt(struct rmi_function *fn,
+static void process_one_interrupt(struct rmi_function_dev *fn_dev,
 		unsigned long *irq_status, struct rmi_driver_data *data)
 {
-	struct rmi_function_handler *fh;
+	struct rmi_function_driver *fn_drv;
 	DECLARE_BITMAP(irq_bits, data->num_of_irq_regs);

-	if (!fn || !fn->dev.driver)
+	if (!fn_dev || !fn_dev->dev.driver)
 		return;

-	fh = to_rmi_function_handler(fn->dev.driver);
-	if (fn->irq_mask && fh->attention) {
-		bitmap_and(irq_bits, irq_status, fn->irq_mask,
+	fn_drv = to_rmi_function_driver(fn_dev->dev.driver);
+	if (fn_dev->irq_mask && fn_drv->attention) {
+		bitmap_and(irq_bits, irq_status, fn_dev->irq_mask,
 				data->irq_count);
 		if (!bitmap_empty(irq_bits, data->irq_count))
-			fh->attention(fn, irq_bits);
+			fn_drv->attention(fn_dev, irq_bits);
 	}
 }

@@ -715,11 +639,11 @@ static int process_interrupt_requests(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
 	struct device *dev = &rmi_dev->dev;
-	struct rmi_function *entry;
+	struct rmi_function_dev *entry;
 	int error;

 	error = rmi_read_block(rmi_dev,
-				data->f01_container->fd.data_base_addr + 1,
+				data->f01_dev->fd.data_base_addr + 1,
 				data->irq_status, data->num_of_irq_regs);
 	if (error < 0) {
 		dev_err(dev, "Failed to read irqs, code=%d\n", error);
@@ -743,8 +667,7 @@ static int process_interrupt_requests(struct rmi_device *rmi_dev)
 	 */
 	list_for_each_entry(entry, &data->rmi_functions.list, list) {
 		if (entry->irq_mask)
-			process_one_interrupt(entry, data->irq_status,
-					      data);
+			process_one_interrupt(entry, data->irq_status, data);
 	}

 	return 0;
@@ -786,7 +709,7 @@ static int rmi_driver_irq_save(struct rmi_device *rmi_dev,
 	if (!data->irq_stored) {
 		/* Save current enabled interrupts */
 		retval = rmi_read_block(rmi_dev,
-				data->f01_container->fd.control_base_addr+1,
+				data->f01_dev->fd.control_base_addr+1,
 				data->irq_mask_store, data->num_of_irq_regs);
 		if (retval < 0) {
 			dev_err(dev, "%s: Failed to read enabled interrupts!",
@@ -800,7 +723,7 @@ static int rmi_driver_irq_save(struct rmi_device *rmi_dev,
 		 * to identify them.
 		 */
 		retval = rmi_write_block(rmi_dev,
-				data->f01_container->fd.control_base_addr+1,
+				data->f01_dev->fd.control_base_addr+1,
 				new_ints, data->num_of_irq_regs);
 		if (retval < 0) {
 			dev_err(dev, "%s: Failed to change enabled interrupts!",
@@ -829,7 +752,7 @@ static int rmi_driver_irq_restore(struct rmi_device *rmi_dev)

 	if (data->irq_stored) {
 		retval = rmi_write_block(rmi_dev,
-				data->f01_container->fd.control_base_addr+1,
+				data->f01_dev->fd.control_base_addr+1,
 				data->irq_mask_store, data->num_of_irq_regs);
 		if (retval < 0) {
 			dev_err(dev, "%s: Failed to write enabled interupts!",
@@ -858,7 +781,7 @@ static int rmi_driver_irq_handler(struct rmi_device *rmi_dev, int irq)
 	/* Can get called before the driver is fully ready to deal with
 	 * interrupts.
 	 */
-	if (!data || !data->f01_container) {
+	if (!data || !data->f01_dev) {
 		dev_dbg(&rmi_dev->dev,
 			 "Not ready to handle interrupts yet!\n");
 		return 0;
@@ -875,7 +798,7 @@ static int rmi_driver_reset_handler(struct rmi_device *rmi_dev)
 	/* Can get called before the driver is fully ready to deal with
 	 * this situation.
 	 */
-	if (!data || !data->f01_container) {
+	if (!data || !data->f01_dev) {
 		dev_warn(&rmi_dev->dev,
 			 "Not ready to handle reset yet!\n");
 		return 0;
@@ -903,65 +826,66 @@ static int rmi_driver_reset_handler(struct rmi_device *rmi_dev)
  * Construct a function's IRQ mask. This should be called once and stored.
  */
 int rmi_driver_irq_get_mask(struct rmi_device *rmi_dev,
-		struct rmi_function *fn) {
+		struct rmi_function_dev *fn_dev) {
 	int i;
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);

 	/* call devm_kcalloc when it will be defined in kernel in future */
-	fn->irq_mask = devm_kzalloc(&rmi_dev->dev,
+	fn_dev->irq_mask = devm_kzalloc(&rmi_dev->dev,
 			BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
 			GFP_KERNEL);

-	if (fn->irq_mask) {
-		for (i = 0; i < fn->num_of_irqs; i++)
-			set_bit(fn->irq_pos+i, fn->irq_mask);
-		return 0;
-	} else
+	if (!fn_dev->irq_mask)
 		return -ENOMEM;
+
+	for (i = 0; i < fn_dev->num_of_irqs; i++)
+		set_bit(fn_dev->irq_pos+i, fn_dev->irq_mask);
+	return 0;
 }

 static int init_function_device(struct rmi_device *rmi_dev,
-			     struct rmi_function *fn)
+			     struct rmi_function_dev *fn_dev)
 {
 	int retval;

 	/* This memset might not be what we want to do... */
-	memset(&fn->dev, 0, sizeof(struct device));
-	dev_set_name(&fn->dev, "%s.fn%02x", dev_name(&rmi_dev->dev),
-			fn->fd.function_number);
-	fn->dev.release = release_function_device;
-
-	fn->dev.parent = &rmi_dev->dev;
-	fn->dev.type = &rmi_function_type;
-	fn->dev.bus = &rmi_bus_type;
-	dev_dbg(&rmi_dev->dev, "Register F%02X.\n", fn->fd.function_number);
-	retval = device_register(&fn->dev);
-	if (retval) {
-		dev_err(&rmi_dev->dev, "Failed device_register for F%02X.\n",
-			fn->fd.function_number);
-		return retval;
-	}
+	memset(&(fn_dev->dev), 0, sizeof(struct device));
+	dev_set_name(&(fn_dev->dev), "%s.fn%02x", dev_name(&rmi_dev->dev),
+			fn_dev->fd.function_number);
+	fn_dev->dev.release = release_fndev_device;
+
+	fn_dev->dev.parent = &rmi_dev->dev;
+	fn_dev->dev.type = &rmi_function_type;
+	fn_dev->dev.bus = &rmi_bus_type;

 	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
 		char dirname[12];

-		snprintf(dirname, 12, "F%02X", fn->fd.function_number);
-		fn->debugfs_root = debugfs_create_dir(dirname,
+		snprintf(dirname, 12, "F%02X", fn_dev->fd.function_number);
+		fn_dev->debugfs_root = debugfs_create_dir(dirname,
 						      rmi_dev->debugfs_root);
-		if (!fn->debugfs_root)
-			dev_warn(&fn->dev, "Failed to create debugfs dir.\n");
+		if (!fn_dev->debugfs_root)
+			dev_warn(&fn_dev->dev, "Failed to create debugfs dir.\n");
+	}
+
+	dev_dbg(&rmi_dev->dev, "Register F%02X.\n", fn_dev->fd.function_number);
+	retval = device_register(&fn_dev->dev);
+	if (retval) {
+		dev_err(&rmi_dev->dev, "Failed device_register for F%02X.\n",
+			fn_dev->fd.function_number);
+		return retval;
 	}

 	return 0;
 }

-static int create_function(struct rmi_device *rmi_dev,
+static int create_function_dev(struct rmi_device *rmi_dev,
 				     struct pdt_entry *pdt_ptr,
 				     int *current_irq_count,
 				     u16 page_start)
 {
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_function *fn = NULL;
+	struct rmi_function_dev *fn_dev = NULL;
 	int retval = 0;
 	struct device *dev = &rmi_dev->dev;
 	struct rmi_device_platform_data *pdata;
@@ -971,41 +895,45 @@ static int create_function(struct rmi_device *rmi_dev,
 	dev_dbg(dev, "Initializing F%02X for %s.\n", pdt_ptr->function_number,
 		pdata->sensor_name);

-	fn = devm_kzalloc(dev, sizeof(struct rmi_function),
+	fn_dev = devm_kzalloc(dev, sizeof(struct rmi_function_dev),
 			GFP_KERNEL);
-	if (!fn) {
-		dev_err(dev, "Failed to allocate F%02X container.\n",
+	if (!fn_dev) {
+		dev_err(dev, "Failed to allocate F%02X device.\n",
 			pdt_ptr->function_number);
 		return -ENOMEM;
 	}

-	copy_pdt_entry_to_fd(pdt_ptr, &fn->fd, page_start);
+	copy_pdt_entry_to_fd(pdt_ptr, &fn_dev->fd, page_start);

-	fn->rmi_dev = rmi_dev;
-	fn->num_of_irqs = pdt_ptr->interrupt_source_count;
+	fn_dev->rmi_dev = rmi_dev;
+	fn_dev->num_of_irqs = pdt_ptr->interrupt_source_count;
+	fn_dev->irq_pos = *current_irq_count;
+	*current_irq_count += fn_dev->num_of_irqs;

-	fn->irq_pos = *current_irq_count;
-	*current_irq_count += fn->num_of_irqs;
+	retval = rmi_driver_irq_get_mask(rmi_dev, fn_dev);
+	if (retval < 0) {
+		dev_err(dev, "%s: Failed to create irq_mask for F%02X.\n",
+			__func__, pdt_ptr->function_number);
+		return retval;
+	}

-	retval = init_function_device(rmi_dev, fn);
+	retval = init_function_device(rmi_dev, fn_dev);
 	if (retval < 0) {
 		dev_err(dev, "Failed to initialize F%02X device.\n",
 			pdt_ptr->function_number);
-		goto error_free_data;
+		return retval;
 	}

-	INIT_LIST_HEAD(&fn->list);
+	INIT_LIST_HEAD(&fn_dev->list);
 	/* we need to ensure that F01 is at the head of the list.
 	 */
 	if (pdt_ptr->function_number == 0x01) {
-		list_add(&fn->list, &data->rmi_functions.list);
-		data->f01_container = fn;
+		list_add(&fn_dev->list, &data->rmi_functions.list);
+		data->f01_dev = fn_dev;
 	} else
-		list_add_tail(&fn->list, &data->rmi_functions.list);
-	return 0;
+		list_add_tail(&fn_dev->list, &data->rmi_functions.list);

-error_free_data:
-	return retval;
+	return 0;
 }

 /*
@@ -1031,41 +959,107 @@ static void check_bootloader_mode(struct rmi_device *rmi_dev,
 	if (device_status.flash_prog)
 		dev_warn(&rmi_dev->dev,
 			 "WARNING: RMI4 device is in bootloader mode!\n");
+
 }

 /*
- * Scan the PDT for F01 so we can force a reset before anything else
- * is done.  This forces the sensor into a known state, and also
- * forces application of any pending updates from reflashing the
- * firmware or configuration.
- *
- * At this time, we also reflash the device if (a) in kernel reflashing is
+ * We also reflash the device if (a) in kernel reflashing is
  * enabled, and (b) the reflash module decides it requires reflashing.
  *
  * We have to do this before actually building the PDT because the reflash
  * might cause various registers to move around.
  */
-static int reset_and_reflash(struct rmi_device *rmi_dev)
+static int rmi_device_reflash(struct rmi_device *rmi_dev)
 {
 	struct pdt_entry pdt_entry;
 	int page;
 	struct device *dev = &rmi_dev->dev;
-	bool done = false;
+	bool done;
 	bool has_f01 = false;
 	bool has_f34 = false;
 	struct pdt_entry f34_pdt, f01_pdt;
 	int i;
 	int retval;
 	struct rmi_device_platform_data *pdata;
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);

-	dev_dbg(dev, "Initial reset.\n");
+	dev_dbg(dev, "Initial reflash.\n");
 	pdata = to_rmi_platform_data(rmi_dev);
-	for (page = 0; (page <= RMI4_MAX_PAGE) && !done; page++) {
+	data->f01_bootloader_mode = false;
+	for (page = 0; (page <= RMI4_MAX_PAGE); page++) {
 		u16 page_start = RMI4_PAGE_SIZE * page;
 		u16 pdt_start = page_start + PDT_START_SCAN_LOCATION;
 		u16 pdt_end = page_start + PDT_END_SCAN_LOCATION;
+		done = true;
+		for (i = pdt_start; i >= pdt_end ; i -= sizeof(pdt_entry)) {
+			retval = rmi_read_block(rmi_dev, i, &pdt_entry,
+					       sizeof(pdt_entry));
+			if (retval != sizeof(pdt_entry)) {
+				dev_err(dev, "Read PDT entry at %#06x failed, code = %d.\n",
+						i, retval);
+				return retval;
+			}
+
+			if (RMI4_END_OF_PDT(pdt_entry.function_number))
+				break;
+			done = false;
+			if (pdt_entry.function_number == 0x01) {
+				memcpy(&f01_pdt, &pdt_entry, sizeof(pdt_entry));
+				has_f01 = true;
+				check_bootloader_mode(rmi_dev, &pdt_entry,
+						      page_start);
+			} else if (pdt_entry.function_number == 0x34) {
+				memcpy(&f34_pdt, &pdt_entry, sizeof(pdt_entry));
+				has_f34 = true;
+			}
+
+			if (has_f01 && has_f34) {
+				done = true;
+				break;
+			}
+		}
+
+		if (data->f01_bootloader_mode || done)
+			break;
+	}

+	if (!has_f01) {
+		dev_warn(dev, "WARNING: Failed to find F01 for initial reflash.\n");
+		return -ENODEV;
+	}
+
+	if (has_f34)
+		rmi4_fw_update(rmi_dev, &f01_pdt, &f34_pdt);
+	else
+		dev_warn(dev, "WARNING: No F34 , firmware update will not be done.\n");
+	return 0;
+}
+
+/*
+ * Scan the PDT for F01 so we can force a reset before anything else
+ * is done.  This forces the sensor into a known state, and also
+ * forces application of any pending updates from reflashing the
+ * firmware or configuration.
+ *
+ */
+static int rmi_device_reset(struct rmi_device *rmi_dev)
+{
+	struct pdt_entry pdt_entry;
+	int page;
+	struct device *dev = &rmi_dev->dev;
+	int i;
+	int retval;
+	bool done = false;
+	struct rmi_device_platform_data *pdata;
+
+	dev_dbg(dev, "Initial reset.\n");
+	pdata = to_rmi_platform_data(rmi_dev);
+	for (page = 0; (page <= RMI4_MAX_PAGE)  && !done; page++) {
+		u16 page_start = RMI4_PAGE_SIZE * page;
+		u16 pdt_start = page_start + PDT_START_SCAN_LOCATION;
+		u16 pdt_end = page_start + PDT_END_SCAN_LOCATION;
 		done = true;
+
 		for (i = pdt_start; i >= pdt_end; i -= sizeof(pdt_entry)) {
 			retval = rmi_read_block(rmi_dev, i, &pdt_entry,
 					       sizeof(pdt_entry));
@@ -1091,39 +1085,16 @@ static int reset_and_reflash(struct rmi_device *rmi_dev)
 					return retval;
 				}
 				mdelay(pdata->reset_delay_ms);
-				if (IS_ENABLED(CONFIG_RMI4_FWLIB))
-					memcpy(&f01_pdt, &pdt_entry,
-							sizeof(pdt_entry));
-				else
-					done = true;
-				has_f01 = true;
-				break;
-			} else if (IS_ENABLED(CONFIG_RMI4_FWLIB) &&
-					pdt_entry.function_number == 0x34) {
-				memcpy(&f34_pdt, &pdt_entry, sizeof(pdt_entry));
-				has_f34 = true;
+				return 0;
 			}
 		}
 	}

-	if (!has_f01) {
-		dev_warn(dev, "WARNING: Failed to find F01 for initial reset.\n");
-		return -ENODEV;
-	}
-
-	if (IS_ENABLED(CONFIG_RMI4_FWLIB)) {
-		if (has_f34)
-			rmi4_fw_update(rmi_dev, &f01_pdt, &f34_pdt);
-		else
-			dev_warn(dev, "WARNING: No F34, firmware update will not be done.\n");
-	}
-
-	return 0;
+	return -ENODEV;
 }

-
-/* extract product ID */
-void get_prod_id(struct rmi_device *rmi_dev, struct rmi_driver_data *drvdata)
+static void get_prod_id(struct rmi_device *rmi_dev,
+			struct rmi_driver_data *drvdata)
 {
 	struct device *dev = &rmi_dev->dev;
 	int retval;
@@ -1134,7 +1105,7 @@ void get_prod_id(struct rmi_device *rmi_dev, struct rmi_driver_data *drvdata)
 	u8 product_id[RMI_PRODUCT_ID_LENGTH+1];

 	retval = rmi_read_block(rmi_dev,
-		drvdata->f01_container->fd.query_base_addr+
+		drvdata->f01_dev->fd.query_base_addr+
 		sizeof(struct f01_basic_queries),
 		product_id, RMI_PRODUCT_ID_LENGTH);
 	if (retval < 0) {
@@ -1146,7 +1117,7 @@ void get_prod_id(struct rmi_device *rmi_dev, struct rmi_driver_data *drvdata)
 	for (i = 0; i < sizeof(product_id); i++)
 		product_id[i] = tolower(product_id[i]);

-	for (i = 0; i < sizeof(pattern); i++) {
+	for (i = 0; i < ARRAY_SIZE(pattern); i++) {
 		retval = sscanf(product_id, pattern[i], &board, &rev);
 		if (retval)
 			break;
@@ -1158,6 +1129,55 @@ void get_prod_id(struct rmi_device *rmi_dev, struct rmi_driver_data *drvdata)
 		drvdata->board, drvdata->rev);
 }

+static int rmi_count_irqs(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data;
+	struct pdt_entry pdt_entry;
+	int page;
+	struct device *dev = &rmi_dev->dev;
+	int irq_count = 0;
+	bool done = false;
+	int i;
+	int retval;
+
+	data = dev_get_drvdata(&rmi_dev->dev);
+	mutex_lock(&data->pdt_mutex);
+
+	for (page = 0; (page <= RMI4_MAX_PAGE) && !done; page++) {
+		u16 page_start = RMI4_PAGE_SIZE * page;
+		u16 pdt_start = page_start + PDT_START_SCAN_LOCATION;
+		u16 pdt_end = page_start + PDT_END_SCAN_LOCATION;
+
+		done = true;
+		for (i = pdt_start; i >= pdt_end; i -= sizeof(pdt_entry)) {
+			retval = rmi_read_block(rmi_dev, i, &pdt_entry,
+					       sizeof(pdt_entry));
+			if (retval != sizeof(pdt_entry)) {
+				dev_err(dev, "Read of PDT entry at %#06x failed.\n",
+					i);
+				goto error_exit;
+			}
+
+			if (RMI4_END_OF_PDT(pdt_entry.function_number))
+				break;
+			irq_count += pdt_entry.interrupt_source_count;
+			done = false;
+
+			if (pdt_entry.function_number == 0x01)
+				check_bootloader_mode(rmi_dev, &pdt_entry,
+						      page_start);
+		}
+		done = done || data->f01_bootloader_mode;
+	}
+	data->irq_count = irq_count;
+	data->num_of_irq_regs = (irq_count + 7) / 8;
+	retval = 0;
+
+error_exit:
+	mutex_unlock(&data->pdt_mutex);
+	return retval;
+}
+
 static int rmi_scan_pdt(struct rmi_device *rmi_dev)
 {
 	struct rmi_driver_data *data;
@@ -1201,7 +1221,7 @@ static int rmi_scan_pdt(struct rmi_device *rmi_dev)
 						      page_start);


-			retval = create_function(rmi_dev,
+			retval = create_function_dev(rmi_dev,
 					&pdt_entry, &irq_count, page_start);

 			if (retval)
@@ -1212,8 +1232,6 @@ static int rmi_scan_pdt(struct rmi_device *rmi_dev)
 		}
 		done = done || data->f01_bootloader_mode;
 	}
-	data->irq_count = irq_count;
-	data->num_of_irq_regs = (irq_count + 7) / 8;
 	dev_dbg(dev, "%s: Done with PDT scan.\n", __func__);
 	retval = 0;

@@ -1226,23 +1244,21 @@ static int f01_notifier_call(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct rmi_function *fn;
+	struct rmi_function_dev *fn_dev;

 	if (dev->type != &rmi_function_type)
 		return 0;

-	fn = to_rmi_function(dev);
-	if (fn->fd.function_number != 0x01)
+	fn_dev = to_rmi_function_dev(dev);
+	if (fn_dev->fd.function_number != 0x01)
 		return 0;

 	switch (action) {
 	case BUS_NOTIFY_BOUND_DRIVER:
-		dev_dbg(dev, "%s: F01 driver bound.\n", __func__);
-		enable_sensor(fn->rmi_dev);
+		enable_sensor(fn_dev->rmi_dev);
 		break;
 	case BUS_NOTIFY_UNBIND_DRIVER:
-		dev_dbg(dev, "%s: F01 driver going away.\n", __func__);
-		disable_sensor(fn->rmi_dev);
+		disable_sensor(fn_dev->rmi_dev);
 		break;
 	}
 	return 0;
@@ -1253,20 +1269,20 @@ static struct notifier_block rmi_bus_notifier = {
 };

 #ifdef CONFIG_PM
-static int suspend_one_device(struct rmi_function *fn)
+static int suspend_one_device(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_function_handler *fh;
+	struct rmi_function_driver *fn_drv;
 	int retval = 0;

-	if (!fn->dev.driver)
+	if (!fn_dev->dev.driver)
 		return 0;

-	fh = to_rmi_function_handler(fn->dev.driver);
+	fn_drv = to_rmi_function_driver(fn_dev->dev.driver);

-	if (fh->suspend) {
-		retval = fh->suspend(fn);
+	if (fn_drv->suspend) {
+		retval = fn_drv->suspend(fn_dev);
 		if (retval < 0)
-			dev_err(&fn->dev, "Suspend failed, code: %d",
+			dev_err(&fn_dev->dev, "Suspend failed, code: %d",
 				retval);
 	}

@@ -1276,7 +1292,7 @@ static int suspend_one_device(struct rmi_function *fn)
 static int rmi_driver_suspend(struct device *dev)
 {
 	struct rmi_driver_data *data;
-	struct rmi_function *entry;
+	struct rmi_function_dev *entry;
 	int retval = 0;
 	struct rmi_device *rmi_dev = to_rmi_device(dev);

@@ -1309,20 +1325,20 @@ exit:
 	return retval;
 }

-static int resume_one_device(struct rmi_function *fn)
+static int resume_one_device(struct rmi_function_dev *fn_dev)
 {
-	struct rmi_function_handler *fh;
+	struct rmi_function_driver *fn_drv;
 	int retval = 0;

-	if (!fn->dev.driver)
+	if (!fn_dev->dev.driver)
 		return 0;

-	fh = to_rmi_function_handler(fn->dev.driver);
+	fn_drv = to_rmi_function_driver(fn_dev->dev.driver);

-	if (fh->resume) {
-		retval = fh->resume(fn);
+	if (fn_drv->resume) {
+		retval = fn_drv->resume(fn_dev);
 		if (retval < 0)
-			dev_err(&fn->dev, "Resume failed, code: %d",
+			dev_err(&fn_dev->dev, "Resume failed, code: %d",
 				retval);
 	}

@@ -1332,7 +1348,7 @@ static int resume_one_device(struct rmi_function *fn)
 static int rmi_driver_resume(struct device *dev)
 {
 	struct rmi_driver_data *data;
-	struct rmi_function *entry;
+	struct rmi_function_dev *entry;
 	int retval = 0;
 	struct rmi_device *rmi_dev = to_rmi_device(dev);

@@ -1357,7 +1373,6 @@ static int rmi_driver_resume(struct device *dev)
 	if (retval)
 		goto exit;

-
 	if (data->post_resume) {
 		retval = data->post_resume(data->pm_data);
 		if (retval)
@@ -1372,18 +1387,14 @@ exit:

 #endif /* CONFIG_PM */

-static int __devexit rmi_driver_remove(struct device *dev)
+static int rmi_driver_remove(struct rmi_device *rmi_dev)
 {
-	struct rmi_driver_data *data;
 	int i;
-	struct rmi_device *rmi_dev = to_rmi_device(dev);
-
-	data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);

 	disable_sensor(rmi_dev);

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG))
-		teardown_debugfs(rmi_dev);
+	teardown_debugfs(rmi_dev);

 	rmi_free_function_list(rmi_dev);
 	for (i = 0; i < ARRAY_SIZE(attrs); i++)
@@ -1397,22 +1408,18 @@ static int __devinit rmi_driver_probe(struct device *dev)
 {
 	struct rmi_driver *rmi_driver;
 	struct rmi_driver_data *data = NULL;
-	struct rmi_function *fn;
 	struct rmi_device_platform_data *pdata;
 	int retval = 0;
 	int attr_count = 0;
 	struct rmi_device *rmi_dev;

-	dev_dbg(dev, "%s: Starting probe.\n", __func__);
 	if (!dev->driver) {
 		dev_err(dev, "No driver for RMI4 device during probe!\n");
 		return -ENODEV;
 	}

-	if (dev->type != &rmi_sensor_type) {
-		dev_dbg(dev, "Not a sensor device.\n");
-		return 1;
-	}
+	if (dev->type != &rmi_sensor_type)
+		return -ENODEV;

 	rmi_dev = to_rmi_device(dev);
 	rmi_driver = to_rmi_driver(dev->driver);
@@ -1447,40 +1454,90 @@ static int __devinit rmi_driver_probe(struct device *dev)
 	 */
 	if (!pdata->reset_delay_ms)
 		pdata->reset_delay_ms = DEFAULT_RESET_DELAY_MS;
-	retval = reset_and_reflash(rmi_dev);
+	retval = rmi_device_reset(rmi_dev);
 	if (retval)
 		dev_warn(dev, "RMI initial reset failed! Continuing in spite of this.\n");

+	retval = rmi_device_reflash(rmi_dev);
+	if (retval)
+		dev_warn(dev, "RMI reflash failed! Continuing in spite of this.\n");

-	retval = rmi_scan_pdt(rmi_dev);
+	retval = rmi_read(rmi_dev, PDT_PROPERTIES_LOCATION, &data->pdt_props);
+	if (retval < 0) {
+		/* we'll print out a warning and continue since
+		 * failure to get the PDT properties is not a cause to fail
+		 */
+		dev_warn(dev, "Could not read PDT properties from %#06x. Assuming 0x00.\n",
+			 PDT_PROPERTIES_LOCATION);
+	}
+
+	if (pdata->attn_gpio) {
+		data->irq = gpio_to_irq(pdata->attn_gpio);
+		if (pdata->level_triggered) {
+			data->irq_flags = IRQF_ONESHOT |
+				((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
+				? IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
+		} else {
+			data->irq_flags =
+				(pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
+				? IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
+		}
+		dev_dbg(dev, "Mapped IRQ %d for GPIO %d.\n",
+			data->irq, pdata->attn_gpio);
+	} else
+		data->poll_interval = ktime_set(0,
+			(pdata->poll_interval_ms ? pdata->poll_interval_ms :
+			DEFAULT_POLL_INTERVAL_MS) * 1000);
+
+	retval = rmi_count_irqs(rmi_dev);
 	if (retval) {
-		dev_err(dev, "PDT scan for %s failed with code %d.\n",
+		dev_err(dev, "IRQ counting for %s failed with code %d.\n",
 			pdata->sensor_name, retval);
 		goto err_free_data;
 	}

-	if (!data->f01_container) {
-		dev_err(dev, "missing F01 container!\n");
-		retval = -EINVAL;
+	mutex_init(&data->irq_mutex);
+	data->irq_status = devm_kzalloc(dev,
+		BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
+		GFP_KERNEL);
+	if (!data->irq_status) {
+		dev_err(dev, "Failed to allocate irq_status.\n");
+		retval = -ENOMEM;
 		goto err_free_data;
 	}

-	list_for_each_entry(fn, &data->rmi_functions.list, list) {
-		retval = rmi_driver_irq_get_mask(rmi_dev, fn);
-		if (retval < 0) {
-			dev_err(dev, "%s: Failed to create irq_mask.\n",
-				__func__);
-			goto err_free_data;
-		}
+	data->current_irq_mask = devm_kzalloc(dev, data->num_of_irq_regs,
+				GFP_KERNEL);
+	if (!data->current_irq_mask) {
+		dev_err(dev, "Failed to allocate current_irq_mask.\n");
+		retval = -ENOMEM;
+		goto err_free_data;
 	}

-	retval = rmi_read(rmi_dev, PDT_PROPERTIES_LOCATION, &data->pdt_props);
-	if (retval < 0) {
-		/* we'll print out a warning and continue since
-		 * failure to get the PDT properties is not a cause to fail
-		 */
-		dev_warn(dev, "Could not read PDT properties from %#06x. Assuming 0x00.\n",
-			 PDT_PROPERTIES_LOCATION);
+	data->irq_mask_store = devm_kzalloc(dev,
+		BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
+		GFP_KERNEL);
+	if (!data->irq_mask_store) {
+		dev_err(dev, "Failed to allocate mask store.\n");
+		retval = -ENOMEM;
+		goto err_free_data;
+	}
+
+	retval = setup_debugfs(rmi_dev);
+	if (retval < 0)
+		dev_warn(dev, "Failed to setup debugfs. Code: %d.\n", retval);
+
+	retval = rmi_scan_pdt(rmi_dev);
+	if (retval) {
+		dev_err(dev, "PDT scan for %s failed with code %d.\n",
+			pdata->sensor_name, retval);
+		goto err_free_data;
+	}
+
+	if (!data->f01_dev) {
+		dev_err(dev, "missing F01 device!\n");
+		retval = -EINVAL;
+		goto err_free_data;
 	}

 	dev_dbg(dev, "%s: Creating sysfs files.", __func__);
@@ -1501,27 +1558,8 @@ static int __devinit rmi_driver_probe(struct device *dev)
 		}
 	}

-	mutex_init(&data->irq_mutex);
-	data->irq_status = devm_kzalloc(dev,
-		BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
-		GFP_KERNEL);
-	if (!data->irq_status) {
-		dev_err(dev, "Failed to allocate irq_status.\n");
-		retval = -ENOMEM;
-		goto err_free_data;
-	}
-
-	data->current_irq_mask = devm_kzalloc(dev,
-				data->num_of_irq_regs,
-				GFP_KERNEL);
-	if (!data->current_irq_mask) {
-		dev_err(dev, "Failed to allocate current_irq_mask.\n");
-		retval = -ENOMEM;
-		goto err_free_data;
-	}
-
 	retval = rmi_read_block(rmi_dev,
-				data->f01_container->fd.control_base_addr+1,
+				data->f01_dev->fd.control_base_addr+1,
 				data->current_irq_mask, data->num_of_irq_regs);
 	if (retval < 0) {
 		dev_err(dev, "%s: Failed to read current IRQ mask.\n",
@@ -1529,14 +1567,6 @@ static int __devinit rmi_driver_probe(struct device *dev)
 		goto err_free_data;
 	}

-	data->irq_mask_store = devm_kzalloc(dev,
-		BITS_TO_LONGS(data->irq_count)*sizeof(unsigned long),
-		GFP_KERNEL);
-	if (!data->irq_mask_store) {
-		dev_err(dev, "Failed to allocate mask store.\n");
-		retval = -ENOMEM;
-		goto err_free_data;
-	}
 	if (IS_ENABLED(CONFIG_PM)) {
 		data->pm_data = pdata->pm_data;
 		data->pre_suspend = pdata->pre_suspend;
@@ -1547,34 +1577,11 @@ static int __devinit rmi_driver_probe(struct device *dev)
 		mutex_init(&data->suspend_mutex);
 	}

-	if (pdata->attn_gpio) {
-		data->irq = gpio_to_irq(pdata->attn_gpio);
-		if (pdata->level_triggered) {
-			data->irq_flags = IRQF_ONESHOT |
-				((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
-				? IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
-		} else {
-			data->irq_flags =
-				(pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
-				? IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
-		}
-	} else
-		data->poll_interval = ktime_set(0,
-			(pdata->poll_interval_ms ? pdata->poll_interval_ms :
-			DEFAULT_POLL_INTERVAL_MS) * 1000);
-
-	if (data->f01_container->dev.driver) {
+	if (data->f01_dev->dev.driver) {
 		/* Driver already bound, so enable ATTN now. */
 		enable_sensor(rmi_dev);
 	}

-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		retval = setup_debugfs(rmi_dev);
-		if (retval < 0)
-			dev_warn(&fn->dev, "Failed to setup debugfs. Code: %d.\n",
-				retval);
-	}
-
 	if (IS_ENABLED(CONFIG_RMI4_DEV) && pdata->attn_gpio) {
 		retval = gpio_export(pdata->attn_gpio, false);
 		if (retval) {
@@ -1615,32 +1622,32 @@ struct rmi_driver rmi_sensor_driver = {
 		.bus = &rmi_bus_type,
 		.pm = &rmi_driver_pm,
 		.probe = rmi_driver_probe,
-		.remove = __devexit_p(rmi_driver_remove),
 	},
 	.irq_handler = rmi_driver_irq_handler,
 	.reset_handler = rmi_driver_reset_handler,
 	.store_irq_mask = rmi_driver_irq_save,
 	.restore_irq_mask = rmi_driver_irq_restore,
 	.set_input_params = rmi_driver_set_input_params,
+	.remove = rmi_driver_remove,
 };

 int __init rmi_register_sensor_driver(void)
 {
-	int error;
+	int retval;

-	error = driver_register(&rmi_sensor_driver.driver);
-	if (error) {
+	retval = driver_register(&rmi_sensor_driver.driver);
+	if (retval) {
 		pr_err("%s: driver register failed, code=%d.\n", __func__,
-		       error);
-		return error;
+		       retval);
+		return retval;
 	}

 	/* Ask the bus to let us know when drivers are bound to devices. */
-	error = bus_register_notifier(&rmi_bus_type, &rmi_bus_notifier);
-	if (error) {
+	retval = bus_register_notifier(&rmi_bus_type, &rmi_bus_notifier);
+	if (retval) {
 		pr_err("%s: failed to register bus notifier, code=%d.\n",
-		       __func__, error);
-		return error;
+		       __func__, retval);
+		return retval;
 	}

 	return 0;
diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
index 2866f7d..e709a63 100644
--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -2,20 +2,11 @@
  * Copyright (c) 2011, 2012 Synaptics Incorporated
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
+
 #ifndef _RMI_DRIVER_H
 #define _RMI_DRIVER_H

@@ -23,7 +14,7 @@
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>

-#define RMI_DRIVER_VERSION "1.6"
+#define RMI_DRIVER_VERSION "1.7"

 #define SYNAPTICS_INPUT_DEVICE_NAME "Synaptics RMI4 Touch Sensor"
 #define SYNAPTICS_VENDOR_ID 0x06cb
@@ -32,8 +23,6 @@
 	.attrs = _attrs,  \
 }

-#define attrify(nm) (&dev_attr_##nm.attr)
-
 #define PDT_PROPERTIES_LOCATION 0x00EF
 #define BSR_LOCATION 0x00FE

@@ -44,14 +33,14 @@ struct pdt_properties {
 } __attribute__((__packed__));

 struct rmi_driver_data {
-	struct rmi_function rmi_functions;
+	struct rmi_function_dev rmi_functions;
 	struct rmi_device *rmi_dev;

-	struct rmi_function *f01_container;
+	struct rmi_function_dev *f01_dev;
 	bool f01_bootloader_mode;

 	atomic_t attn_count;
-	bool irq_debug;
+	u32 irq_debug;
 	int irq;
 	int irq_flags;
 	int num_of_irq_regs;
@@ -66,7 +55,6 @@ struct rmi_driver_data {
 	struct hrtimer poll_timer;
 	struct work_struct poll_work;
 	ktime_t poll_interval;
-
 	struct mutex pdt_mutex;
 	struct pdt_properties pdt_props;
 	u8 bsr;
@@ -133,11 +121,11 @@ static inline void copy_pdt_entry_to_fd(struct pdt_entry *pdt,
 extern void rmi4_fw_update(struct rmi_device *rmi_dev,
 		struct pdt_entry *f01_pdt, struct pdt_entry *f34_pdt);
 #else
-#define rmi4_fw_update(rmi_dev, f01_pdt, f34_pdt)
+#define rmi4_fw_update(rmi_dev, f01_pdt, f34_pdt) 0
 #endif

 extern struct rmi_driver rmi_sensor_driver;
-extern struct rmi_function_handler rmi_f01_handler;
+extern struct rmi_function_driver rmi_f01_driver;

 int rmi_register_sensor_driver(void);
 void rmi_unregister_sensor_driver(void);
