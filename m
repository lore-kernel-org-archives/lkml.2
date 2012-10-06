Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2JFEL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 00:11:27 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28716 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752057Ab2JFELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 00:11:18 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 02/06] input/rmi4: Core files
Date: Fri,  5 Oct 2012 21:09:59 -0700
Message-Id: <1349496603-20775-3-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rmi_bus.c implements the basic functionality of the RMI bus.  This file is
greatly simplified compared to the previous patch - we've switched from
"do it yourself" device/driver binding to using device_type to distinguish
between the two kinds of devices on the bus (sensor devices and function
specific devices) and using the standard bus implementation to manage devices
and drivers.


rmi_driver.c is a driver for the general functionality of the RMI sensor as a
whole, managing those behaviors not specific to any RMI4 function.  This file
is also greatly simplified, mainly for the same reasons as rmi_bus.c was.

The rmi_driver.c implementation has been significantly decoupled from the F01
implementation, although it's unlikely that the dependencies on F01 can be
eliminated completely.  Special dependencies from F01 back to rmi_driver.c
have been eliminated, though (see notes on rmi_f01.c for details).

IRQ management has been shifted from the physical layer into rmi_driver.c.
This simplifies the code and eliminates a bug where unserviced IRQs would
significantly impede the boot process.

One request from previously that we did not address with this patch is using
irq_chip to dispatch the attention IRQs to the various functions.  We felt that
with the major overhaul of the bus structure, there was enough to consider with
the current changes.  We're currently investigating the use of irq_chip - the
request hasn't been forgotten.


The header file rmi_driver.h provides definitions that are shared among
the modules of the RMI implementation, but not thought to be necessary
outside it.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---

 drivers/input/rmi4/rmi_bus.c    |  231 ++++++
 drivers/input/rmi4/rmi_driver.c | 1529 +++++++++++++++++++++++++++++++++++++++
 drivers/input/rmi4/rmi_driver.h |  438 +++++++++++
 3 files changed, 2198 insertions(+), 0 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
new file mode 100644
index 0000000..7b64cf4
--- /dev/null
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -0,0 +1,231 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/kconfig.h>
+#include <linux/list.h>
+#include <linux/pm.h>
+#include <linux/rmi.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#ifdef CONFIG_RMI4_DEBUG
+#include <linux/debugfs.h>
+#endif
+#include "rmi_driver.h"
+
+DEFINE_MUTEX(rmi_bus_mutex);
+
+static struct attribute *function_dev_attrs[] = {
+	NULL,
+};
+
+static struct attribute_group function_dev_attr_group = {
+	.attrs = function_dev_attrs,
+};
+
+static struct attribute_group *function_dev_attr_groups[] = {
+	&function_dev_attr_group,
+	NULL,
+};
+
+struct device_type rmi_function_type = {
+	.name = "rmi_function",
+	.groups = function_dev_attr_groups,
+};
+EXPORT_SYMBOL_GPL(rmi_function_type);
+
+static struct attribute *sensor_dev_attrs[] = {
+	NULL,
+};
+static struct attribute_group sensor_dev_attr_group = {
+	.attrs = sensor_dev_attrs,
+};
+
+static struct attribute_group *sensor_dev_attr_groups[] = {
+	&sensor_dev_attr_group,
+	NULL,
+};
+
+struct device_type rmi_sensor_type = {
+	.name = "rmi_sensor",
+	.groups = sensor_dev_attr_groups,
+};
+EXPORT_SYMBOL_GPL(rmi_sensor_type);
+
+static atomic_t physical_device_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_RMI4_DEBUG
+static struct dentry *rmi_debugfs_root;
+#endif
+
+#ifdef CONFIG_PM
+static int rmi_bus_suspend(struct device *dev)
+{
+	struct device_driver *driver = dev->driver;
+	const struct dev_pm_ops *pm;
+
+	if (!driver)
+		return 0;
+
+	pm = driver->pm;
+	if (pm && pm->suspend)
+		return pm->suspend(dev);
+	if (driver->suspend)
+		return driver->suspend(dev, PMSG_SUSPEND);
+
+	return 0;
+}
+
+static int rmi_bus_resume(struct device *dev)
+{
+	struct device_driver *driver = dev->driver;
+	const struct dev_pm_ops *pm;
+
+	if (!driver)
+		return 0;
+
+	pm = driver->pm;
+	if (pm && pm->resume)
+		return pm->resume(dev);
+	if (driver->resume)
+		return driver->resume(dev);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rmi_bus_pm_ops,
+			 rmi_bus_suspend, rmi_bus_resume);
+
+struct bus_type rmi_bus_type = {
+	.name		= "rmi",
+	.pm		= &rmi_bus_pm_ops
+};
+EXPORT_SYMBOL_GPL(rmi_bus_type);
+
+static void release_rmidev_device(struct device *dev)
+{
+	device_unregister(dev);
+}
+
+int rmi_register_phys_device(struct rmi_phys_device *phys)
+{
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+	struct rmi_device *rmi_dev;
+
+	if (!pdata) {
+		dev_err(phys->dev, "no platform data!\n");
+		return -EINVAL;
+	}
+
+	rmi_dev = kzalloc(sizeof(struct rmi_device), GFP_KERNEL);
+	if (!rmi_dev)
+		return -ENOMEM;
+
+	rmi_dev->phys = phys;
+	rmi_dev->dev.bus = &rmi_bus_type;
+	rmi_dev->dev.type = &rmi_sensor_type;
+
+	rmi_dev->number = atomic_inc_return(&physical_device_count) - 1;
+	rmi_dev->dev.release = release_rmidev_device;
+
+	dev_set_name(&rmi_dev->dev, "sensor%02d", rmi_dev->number);
+	dev_dbg(phys->dev, "%s: Registered %s as %s.\n", __func__,
+		pdata->sensor_name, dev_name(&rmi_dev->dev));
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_debugfs_root) {
+		rmi_dev->debugfs_root = debugfs_create_dir(
+			dev_name(&rmi_dev->dev), rmi_debugfs_root);
+		if (!rmi_dev->debugfs_root)
+			dev_err(&rmi_dev->dev, "Failed to create debugfs root.\n");
+	}
+
+	phys->rmi_dev = rmi_dev;
+	return device_register(&rmi_dev->dev);
+}
+EXPORT_SYMBOL(rmi_register_phys_device);
+
+void rmi_unregister_phys_device(struct rmi_phys_device *phys)
+{
+	struct rmi_device *rmi_dev = phys->rmi_dev;
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_dev->debugfs_root)
+		debugfs_remove(rmi_dev->debugfs_root);
+
+	kfree(rmi_dev);
+}
+EXPORT_SYMBOL(rmi_unregister_phys_device);
+
+int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data))
+{
+	int retval;
+	mutex_lock(&rmi_bus_mutex);
+	retval = bus_for_each_dev(&rmi_bus_type, NULL, data, func);
+	mutex_unlock(&rmi_bus_mutex);
+	return retval;
+}
+EXPORT_SYMBOL_GPL(rmi_for_each_dev);
+
+static int __init rmi_bus_init(void)
+{
+	int error;
+
+	mutex_init(&rmi_bus_mutex);
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
+		rmi_debugfs_root = debugfs_create_dir(rmi_bus_type.name, NULL);
+		if (!rmi_debugfs_root)
+			pr_err("%s: Failed to create debugfs root.\n",
+			       __func__);
+		else if (IS_ERR(rmi_debugfs_root)) {
+			pr_err("%s: Kernel may not contain debugfs support, code=%ld\n",
+				__func__, PTR_ERR(rmi_debugfs_root));
+			rmi_debugfs_root = NULL;
+		}
+	}
+
+	error = bus_register(&rmi_bus_type);
+	if (error < 0) {
+		pr_err("%s: error registering the RMI bus: %d\n", __func__,
+		       error);
+		return error;
+	}
+	pr_debug("%s: successfully registered RMI bus.\n", __func__);
+
+	return 0;
+}
+
+static void __exit rmi_bus_exit(void)
+{
+	/* We should only ever get here if all drivers are unloaded, so
+	 * all we have to do at this point is unregister ourselves.
+	 */
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG) && rmi_debugfs_root)
+		debugfs_remove(rmi_debugfs_root);
+	bus_unregister(&rmi_bus_type);
+}
+
+module_init(rmi_bus_init);
+module_exit(rmi_bus_exit);
+
+MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com");
+MODULE_DESCRIPTION("RMI bus");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(RMI_DRIVER_VERSION);
diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
new file mode 100644
index 0000000..209fa41
--- /dev/null
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -0,0 +1,1529 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
+ *
+ * This driver adds support for generic RMI4 devices from Synpatics. It
+ * implements the mandatory f01 RMI register and depends on the presence of
+ * other required RMI functions.
+ *
+ * The RMI4 specification can be found here (URL split after files/ for
+ * style reasons):
+ * http://www.synaptics.com/sites/default/files/
+ *           511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/gpio.h>
+#include <linux/kconfig.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/rmi.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "rmi_driver.h"
+#include "rmi_f01.h"
+
+#define HAS_NONSTANDARD_PDT_MASK 0x40
+#define RMI4_MAX_PAGE 0xff
+#define RMI4_PAGE_SIZE 0x100
+
+#define RMI_DEVICE_RESET_CMD	0x01
+#define DEFAULT_RESET_DELAY_MS	100
+
+#define IRQ_DEBUG(data) (IS_ENABLED(CONFIG_RMI4_DEBUG) && data->irq_debug)
+
+/* sysfs files for attributes for driver values. */
+static ssize_t rmi_driver_bsr_show(struct device *dev,
+				   struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_driver_bsr_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count);
+
+static ssize_t rmi_driver_enabled_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf);
+
+static ssize_t rmi_driver_enabled_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count);
+
+#ifdef	CONFIG_RMI4_DEBUG
+struct driver_debugfs_data {
+	bool done;
+	struct rmi_device *rmi_dev;
+};
+
+static int debug_open(struct inode *inodep, struct file *filp)
+{
+	struct driver_debugfs_data *data;
+	struct rmi_device *rmi_dev;
+
+	rmi_dev = inodep->i_private;
+	data = devm_kzalloc(&rmi_dev->dev, sizeof(struct driver_debugfs_data),
+				GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->rmi_dev = inodep->i_private;
+	filp->private_data = data;
+	return 0;
+}
+
+#define DELAY_NAME "delay"
+
+static ssize_t delay_read(struct file *filp, char __user *buffer, size_t size,
+		    loff_t *offset) {
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_device_platform_data *pdata =
+			data->rmi_dev->phys->dev->platform_data;
+	int retval;
+	char local_buf[size];
+
+	if (data->done)
+		return 0;
+
+	data->done = 1;
+
+	retval = snprintf(local_buf, size, "%d %d %d %d %d\n",
+		pdata->spi_data.read_delay_us, pdata->spi_data.write_delay_us,
+		pdata->spi_data.block_delay_us,
+		pdata->spi_data.pre_delay_us, pdata->spi_data.post_delay_us);
+
+	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
+		return -EFAULT;
+
+	return retval;
+}
+
+static ssize_t delay_write(struct file *filp, const char __user *buffer,
+			   size_t size, loff_t *offset) {
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_device_platform_data *pdata =
+			data->rmi_dev->phys->dev->platform_data;
+	int retval;
+	char local_buf[size];
+	unsigned int new_read_delay;
+	unsigned int new_write_delay;
+	unsigned int new_block_delay;
+	unsigned int new_pre_delay;
+	unsigned int new_post_delay;
+
+	retval = copy_from_user(local_buf, buffer, size);
+	if (retval)
+		return -EFAULT;
+
+	retval = sscanf(local_buf, "%u %u %u %u %u", &new_read_delay,
+			&new_write_delay, &new_block_delay,
+			&new_pre_delay, &new_post_delay);
+	if (retval != 5) {
+		dev_err(&data->rmi_dev->dev,
+			"Incorrect number of values provided for delay.");
+		return -EINVAL;
+	}
+	if (new_read_delay < 0) {
+		dev_err(&data->rmi_dev->dev,
+			"Byte delay must be positive microseconds.\n");
+		return -EINVAL;
+	}
+	if (new_write_delay < 0) {
+		dev_err(&data->rmi_dev->dev,
+			"Write delay must be positive microseconds.\n");
+		return -EINVAL;
+	}
+	if (new_block_delay < 0) {
+		dev_err(&data->rmi_dev->dev,
+			"Block delay must be positive microseconds.\n");
+		return -EINVAL;
+	}
+	if (new_pre_delay < 0) {
+		dev_err(&data->rmi_dev->dev,
+			"Pre-transfer delay must be positive microseconds.\n");
+		return -EINVAL;
+	}
+	if (new_post_delay < 0) {
+		dev_err(&data->rmi_dev->dev,
+			"Post-transfer delay must be positive microseconds.\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(&data->rmi_dev->dev,
+		 "Setting delays to %u %u %u %u %u.\n", new_read_delay,
+		 new_write_delay, new_block_delay, new_pre_delay,
+		 new_post_delay);
+	pdata->spi_data.read_delay_us = new_read_delay;
+	pdata->spi_data.write_delay_us = new_write_delay;
+	pdata->spi_data.block_delay_us = new_block_delay;
+	pdata->spi_data.pre_delay_us = new_pre_delay;
+	pdata->spi_data.post_delay_us = new_post_delay;
+
+	return size;
+}
+
+static const struct file_operations delay_fops = {
+	.owner = THIS_MODULE,
+	.open = debug_open,
+	.read = delay_read,
+	.write = delay_write,
+};
+
+#define PHYS_NAME "phys"
+
+static ssize_t phys_read(struct file *filp, char __user *buffer, size_t size,
+		    loff_t *offset) {
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_phys_info *info = &data->rmi_dev->phys->info;
+	int retval;
+	char local_buf[size];
+
+	if (data->done)
+		return 0;
+
+	data->done = 1;
+
+	retval = snprintf(local_buf, size,
+		"%-5s %ld %ld %ld %ld %ld %ld\n",
+		 info->proto ? info->proto : "unk",
+		 info->tx_count, info->tx_bytes, info->tx_errs,
+		 info->rx_count, info->rx_bytes, info->rx_errs);
+	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
+		return -EFAULT;
+
+	return retval;
+}
+
+static const struct file_operations phys_fops = {
+	.owner = THIS_MODULE,
+	.open = debug_open,
+	.read = phys_read,
+};
+
+static ssize_t attn_count_read(struct file *filp, char __user *buffer,
+		size_t size, loff_t *offset) {
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_driver_data *rmi_data = dev_get_drvdata(&data->rmi_dev->dev);
+	int retval;
+	char local_buf[size];
+
+	if (data->done)
+		return 0;
+
+	data->done = 1;
+
+	retval = snprintf(local_buf, size, "%d\n",
+			  rmi_data->attn_count.counter);
+	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
+		return -EFAULT;
+
+	return retval;
+}
+
+static const struct file_operations attn_count_fops = {
+	.owner = THIS_MODULE,
+	.open = debug_open,
+	.read = attn_count_read,
+};
+
+static ssize_t irq_debug_read(struct file *filp, char __user *buffer,
+			size_t size, loff_t *offset) {
+	int retval;
+	char local_buf[size];
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_driver_data *rmi_data = dev_get_drvdata(&data->rmi_dev->dev);
+
+	if (data->done)
+		return 0;
+
+	data->done = 1;
+
+	retval = snprintf(local_buf, size, "%u\n", rmi_data->irq_debug);
+
+	if (retval <= 0 || copy_to_user(buffer, local_buf, retval))
+		return -EFAULT;
+
+	return retval;
+}
+
+static ssize_t irq_debug_write(struct file *filp, const char __user *buffer,
+			   size_t size, loff_t *offset) {
+	int retval;
+	char local_buf[size];
+	unsigned int new_value;
+	struct driver_debugfs_data *data = filp->private_data;
+	struct rmi_driver_data *rmi_data = dev_get_drvdata(&data->rmi_dev->dev);
+
+	retval = copy_from_user(local_buf, buffer, size);
+	if (retval)
+		return -EFAULT;
+
+	retval = sscanf(local_buf, "%u", &new_value);
+	if (retval != 1 || new_value > 1)
+		return -EINVAL;
+
+	rmi_data->irq_debug = new_value;
+
+	return size;
+}
+
+static const struct file_operations irq_debug_fops = {
+	.owner = THIS_MODULE,
+	.open = debug_open,
+	.read = irq_debug_read,
+	.write = irq_debug_write,
+};
+
+static int setup_debugfs(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_phys_info *info = &rmi_dev->phys->info;
+	int retval = 0;
+
+	if (!rmi_dev->debugfs_root)
+		return -ENODEV;
+
+	if (IS_ENABLED(CONFIG_RMI4_SPI) && !strncmp("spi", info->proto, 3)) {
+		data->debugfs_delay = debugfs_create_file(DELAY_NAME,
+				RMI_RW_ATTR, rmi_dev->debugfs_root, rmi_dev,
+				&delay_fops);
+		if (!data->debugfs_delay || IS_ERR(data->debugfs_delay)) {
+			dev_warn(&rmi_dev->dev, "Failed to create debugfs delay.\n");
+			data->debugfs_delay = NULL;
+		}
+	}
+
+	data->debugfs_phys = debugfs_create_file(PHYS_NAME, RMI_RO_ATTR,
+				rmi_dev->debugfs_root, rmi_dev, &phys_fops);
+	if (!data->debugfs_phys || IS_ERR(data->debugfs_phys)) {
+		dev_warn(&rmi_dev->dev, "Failed to create debugfs phys.\n");
+		data->debugfs_phys = NULL;
+	}
+
+	data->debugfs_irq = debugfs_create_file("irq_debug",
+			RMI_RW_ATTR,
+			rmi_dev->debugfs_root,
+			rmi_dev, &irq_debug_fops);
+	if (!data->debugfs_irq || IS_ERR(data->debugfs_irq)) {
+		dev_warn(&rmi_dev->dev, "Failed to create debugfs irq_debug.\n");
+		data->debugfs_irq = NULL;
+	}
+
+	data->debugfs_attn_count = debugfs_create_file("attn_count",
+				RMI_RO_ATTR,
+				rmi_dev->debugfs_root,
+				rmi_dev, &attn_count_fops);
+	if (!data->debugfs_phys || IS_ERR(data->debugfs_attn_count)) {
+		dev_warn(&rmi_dev->dev, "Failed to create debugfs attn_count.\n");
+		data->debugfs_attn_count = NULL;
+	}
+
+	return retval;
+}
+
+static void teardown_debugfs(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+
+	if (IS_ENABLED(CONFIG_RMI4_SPI) && data->debugfs_delay)
+		debugfs_remove(data->debugfs_delay);
+	if (data->debugfs_phys)
+		debugfs_remove(data->debugfs_phys);
+	if (data->debugfs_irq)
+		debugfs_remove(data->debugfs_irq);
+	if (data->debugfs_attn_count)
+		debugfs_remove(data->debugfs_attn_count);
+}
+#else
+#define teardown_debugfs(rmi_dev)
+#define setup_debugfs(rmi_dev) 0
+#endif
+
+static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev);
+
+static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev);
+
+static int rmi_driver_irq_restore(struct rmi_device *rmi_dev);
+
+/** This sysfs attribute is deprecated, and will be removed in a future release.
+ */
+static struct device_attribute attrs[] = {
+	__ATTR(enabled, RMI_RW_ATTR,
+	       rmi_driver_enabled_show, rmi_driver_enabled_store),
+};
+
+static struct device_attribute bsr_attribute = __ATTR(bsr, RMI_RW_ATTR,
+	       rmi_driver_bsr_show, rmi_driver_bsr_store);
+
+/* Useful helper functions for u8* */
+
+static bool u8_is_any_set(u8 *target, int size)
+{
+	int i;
+	/* We'd like to use find_first_bit, but it ALWAYS returns 1,
+	*  no matter what we pass it.  So we have to do this the hard way.
+	*  return find_first_bit((long unsigned int *)  target, size) != 0;
+	*/
+	for (i = 0; i < size; i++) {
+		if (target[i])
+			return true;
+	}
+	return false;
+}
+
+/** This is here because all those casts made for some ugly code.
+ */
+static void u8_and(u8 *dest, u8 *target1, u8 *target2, int nbits)
+{
+	bitmap_and((long unsigned int *) dest,
+		   (long unsigned int *) target1,
+		   (long unsigned int *) target2,
+		   nbits);
+}
+
+static void rmi_free_function_list(struct rmi_device *rmi_dev)
+{
+	struct rmi_function_container *entry, *n;
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+
+	if (!data) {
+		dev_err(&rmi_dev->dev, "WTF: No driver data in %s\n", __func__);
+		return;
+	}
+
+	data->f01_container = NULL;
+
+	if (list_empty(&data->rmi_functions.list))
+		return;
+
+	list_for_each_entry_safe(entry, n, &data->rmi_functions.list, list) {
+		device_unregister(&entry->dev);
+		list_del(&entry->list);
+	}
+}
+
+static void release_fc_device(struct device *dev)
+{
+	dev_dbg(dev, "REMOVING KOBJ!");
+	kobject_put(&dev->kobj);
+}
+
+static int reset_one_function(struct rmi_function_container *fc)
+{
+	struct rmi_function_handler *fh;
+	int retval = 0;
+
+	if (!fc || !fc->dev.driver)
+		return 0;
+
+	fh = to_rmi_function_handler(fc->dev.driver);
+	if (fh->reset) {
+		retval = fh->reset(fc);
+		if (retval < 0)
+			dev_err(&fc->dev, "Reset failed with code %d.\n",
+				retval);
+	}
+
+	return retval;
+}
+
+static int configure_one_function(struct rmi_function_container *fc)
+{
+	struct rmi_function_handler *fh;
+	int retval = 0;
+
+	if (!fc || !fc->dev.driver)
+		return 0;
+
+	fh = to_rmi_function_handler(fc->dev.driver);
+	if (fh->config) {
+		retval = fh->config(fc);
+		if (retval < 0)
+			dev_err(&fc->dev, "Config failed with code %d.\n",
+				retval);
+	}
+
+	return retval;
+}
+
+static int rmi_driver_process_reset_requests(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_function_container *entry;
+	int retval;
+
+	if (list_empty(&data->rmi_functions.list))
+		return 0;
+
+	list_for_each_entry(entry, &data->rmi_functions.list, list) {
+		retval = reset_one_function(entry);
+		if (retval < 0)
+			return retval;
+	}
+
+	return 0;
+}
+
+static int rmi_driver_process_config_requests(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_function_container *entry;
+	int retval;
+
+	if (list_empty(&data->rmi_functions.list))
+		return 0;
+
+	list_for_each_entry(entry, &data->rmi_functions.list, list) {
+		retval = configure_one_function(entry);
+		if (retval < 0)
+			return retval;
+	}
+
+	return 0;
+}
+
+static void process_one_interrupt(struct rmi_function_container *fc,
+		u8 *irq_status, struct rmi_driver_data *data)
+{
+	struct rmi_function_handler *fh;
+	u8 irq_bits[data->num_of_irq_regs];
+
+	if (!fc || !fc->dev.driver)
+		return;
+
+	fh = to_rmi_function_handler(fc->dev.driver);
+	if (fc->irq_mask && fh->attention) {
+		u8_and(irq_bits, irq_status, fc->irq_mask,
+				data->irq_count);
+		if (u8_is_any_set(irq_bits, data->num_of_irq_regs))
+			fh->attention(fc, irq_bits);
+	}
+
+}
+
+static int process_interrupt_requests(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct device *dev = &rmi_dev->dev;
+	struct rmi_function_container *entry;
+	u8 irq_status[data->num_of_irq_regs];
+	int error;
+
+	error = rmi_read_block(rmi_dev,
+				data->f01_container->fd.data_base_addr + 1,
+				irq_status, data->num_of_irq_regs);
+	if (error < 0) {
+		dev_err(dev, "Failed to read irqs, code=%d\n", error);
+		return error;
+	}
+
+	mutex_lock(&data->irq_mutex);
+
+	u8_and(irq_status, irq_status, data->current_irq_mask,
+	       data->irq_count);
+	/* At this point, irq_status has all bits that are set in the
+	 * interrupt status register and are enabled.
+	 */
+
+	list_for_each_entry(entry, &data->rmi_functions.list, list)
+		if (entry->irq_mask)
+			process_one_interrupt(entry, irq_status,
+					      data);
+
+	mutex_unlock(&data->irq_mutex);
+	return 0;
+}
+
+static int rmi_driver_irq_handler(struct rmi_device *rmi_dev, int irq)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+
+	might_sleep();
+	/* Can get called before the driver is fully ready to deal with
+	 * interrupts.
+	 */
+	if (!data || !data->f01_container) {
+		dev_dbg(&rmi_dev->dev,
+			 "Not ready to handle interrupts yet!\n");
+		return 0;
+	}
+
+	return process_interrupt_requests(rmi_dev);
+}
+
+static int rmi_driver_reset_handler(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	int error;
+
+	/* Can get called before the driver is fully ready to deal with
+	 * this situation.
+	 */
+	if (!data || !data->f01_container) {
+		dev_warn(&rmi_dev->dev,
+			 "Not ready to handle reset yet!\n");
+		return 0;
+	}
+
+	error = rmi_driver_process_reset_requests(rmi_dev);
+	if (error < 0)
+		return error;
+
+
+	error = rmi_driver_process_config_requests(rmi_dev);
+	if (error < 0)
+		return error;
+
+	if (data->irq_stored) {
+		error = rmi_driver_irq_restore(rmi_dev);
+		if (error < 0)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Construct a function's IRQ mask. This should be called once and stored.
+ */
+static u8 *rmi_driver_irq_get_mask(struct rmi_device *rmi_dev,
+				   struct rmi_function_container *fc) {
+	int i;
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+
+	/* call devm_kcalloc when it will be defined in kernel in future */
+	u8 *irq_mask = devm_kzalloc(&rmi_dev->dev, data->num_of_irq_regs,
+			GFP_KERNEL);
+
+	if (irq_mask)
+		for (i = 0; i < fc->num_of_irqs; i++)
+			set_bit(fc->irq_pos+i, (long unsigned int *) irq_mask);
+
+	return irq_mask;
+}
+
+/*
+ * This pair of functions allows functions like function 54 to request to have
+ * other interupts disabled until the restore function is called. Only one store
+ * happens at a time.
+ */
+static int rmi_driver_irq_save(struct rmi_device *rmi_dev, u8 * new_ints)
+{
+	int retval = 0;
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct device *dev = &rmi_dev->dev;
+
+	mutex_lock(&data->irq_mutex);
+	if (!data->irq_stored) {
+		/* Save current enabled interrupts */
+		retval = rmi_read_block(rmi_dev,
+				data->f01_container->fd.control_base_addr+1,
+				data->irq_mask_store, data->num_of_irq_regs);
+		if (retval < 0) {
+			dev_err(dev, "%s: Failed to read enabled interrupts!",
+								__func__);
+			goto error_unlock;
+		}
+		/*
+		 * Disable every interrupt except for function 54
+		 * TODO:Will also want to not disable function 1-like functions.
+		 * No need to take care of this now, since there's no good way
+		 * to identify them.
+		 */
+		retval = rmi_write_block(rmi_dev,
+				data->f01_container->fd.control_base_addr+1,
+				new_ints, data->num_of_irq_regs);
+		if (retval < 0) {
+			dev_err(dev, "%s: Failed to change enabled interrupts!",
+								__func__);
+			goto error_unlock;
+		}
+		memcpy(data->current_irq_mask, new_ints,
+					data->num_of_irq_regs * sizeof(u8));
+		data->irq_stored = true;
+	} else {
+		retval = -ENOSPC; /* No space to store IRQs.*/
+		dev_err(dev, "Attempted to save IRQs when already stored!");
+	}
+
+error_unlock:
+	mutex_unlock(&data->irq_mutex);
+	return retval;
+}
+
+static int rmi_driver_irq_restore(struct rmi_device *rmi_dev)
+{
+	int retval = 0;
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct device *dev = &rmi_dev->dev;
+	mutex_lock(&data->irq_mutex);
+
+	if (data->irq_stored) {
+		retval = rmi_write_block(rmi_dev,
+				data->f01_container->fd.control_base_addr+1,
+				data->irq_mask_store, data->num_of_irq_regs);
+		if (retval < 0) {
+			dev_err(dev, "%s: Failed to write enabled interupts!",
+								__func__);
+			goto error_unlock;
+		}
+		memcpy(data->current_irq_mask, data->irq_mask_store,
+					data->num_of_irq_regs * sizeof(u8));
+		data->irq_stored = false;
+	} else {
+		retval = -EINVAL;
+		dev_err(dev, "%s: Attempted to restore values when not stored!",
+			__func__);
+	}
+
+error_unlock:
+	mutex_unlock(&data->irq_mutex);
+	return retval;
+}
+
+static int init_function_device(struct rmi_device *rmi_dev,
+			     struct rmi_function_container *fc)
+{
+	int retval;
+
+	/* This memset might not be what we want to do... */
+	memset(&(fc->dev), 0, sizeof(struct device));
+	dev_set_name(&(fc->dev), "%s.fn%02x", dev_name(&rmi_dev->dev),
+			fc->fd.function_number);
+	fc->dev.release = release_fc_device;
+
+	fc->dev.parent = &rmi_dev->dev;
+	fc->dev.type = &rmi_function_type;
+	fc->dev.bus = &rmi_bus_type;
+	dev_dbg(&rmi_dev->dev, "Register F%02X.\n", fc->fd.function_number);
+	retval = device_register(&fc->dev);
+	if (retval) {
+		dev_err(&rmi_dev->dev, "Failed device_register for F%02X.\n",
+			fc->fd.function_number);
+		return retval;
+	}
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
+		char dirname[12];
+
+		snprintf(dirname, 12, "F%02X", fc->fd.function_number);
+		fc->debugfs_root = debugfs_create_dir(dirname,
+						      rmi_dev->debugfs_root);
+		if (!fc->debugfs_root)
+			dev_warn(&fc->dev, "Failed to create debugfs dir.\n");
+	}
+
+	return 0;
+}
+
+static int create_function_container(struct rmi_device *rmi_dev,
+				     struct pdt_entry *pdt_ptr,
+				     int *current_irq_count,
+				     u16 page_start)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_function_container *fc = NULL;
+	int retval = 0;
+	struct device *dev = &rmi_dev->dev;
+	struct rmi_device_platform_data *pdata;
+
+	pdata = to_rmi_platform_data(rmi_dev);
+
+	dev_dbg(dev, "Initializing F%02X for %s.\n", pdt_ptr->function_number,
+		pdata->sensor_name);
+
+	fc = devm_kzalloc(dev, sizeof(struct rmi_function_container),
+			GFP_KERNEL);
+	if (!fc) {
+		dev_err(dev, "Failed to allocate F%02X container.\n",
+			pdt_ptr->function_number);
+		return -ENOMEM;
+	}
+
+	copy_pdt_entry_to_fd(pdt_ptr, &fc->fd, page_start);
+
+	fc->rmi_dev = rmi_dev;
+	fc->num_of_irqs = pdt_ptr->interrupt_source_count;
+
+	fc->irq_pos = *current_irq_count;
+	*current_irq_count += fc->num_of_irqs;
+
+	retval = init_function_device(rmi_dev, fc);
+	if (retval < 0) {
+		dev_err(dev, "Failed to initialize F%02X device.\n",
+			pdt_ptr->function_number);
+		goto error_free_data;
+	}
+
+	INIT_LIST_HEAD(&fc->list);
+	/* we need to ensure that F01 is at the head of the list.
+	 */
+	if (pdt_ptr->function_number == 0x01) {
+		list_add(&fc->list, &data->rmi_functions.list);
+		data->f01_container = fc;
+	} else
+		list_add_tail(&fc->list, &data->rmi_functions.list);
+	return 0;
+
+error_free_data:
+	return retval;
+}
+
+/*
+ * Once we find F01, we need to see if we're in bootloader mode.  If we are,
+ * we'll stop scanning the PDT with the current page (usually 0x00 in that
+ * case).
+ */
+static void check_bootloader_mode(struct rmi_device *rmi_dev,
+				     struct pdt_entry *pdt_ptr,
+				     u16 page_start)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	union f01_device_status device_status;
+	int retval = 0;
+
+	retval = rmi_read(rmi_dev, pdt_ptr->data_base_addr+page_start,
+			  device_status.regs);
+	if (retval < 0) {
+		dev_err(&rmi_dev->dev, "Failed to read device status.\n");
+		return;
+	}
+	data->f01_bootloader_mode = device_status.flash_prog;
+	if (device_status.flash_prog)
+		dev_warn(&rmi_dev->dev,
+			 "WARNING: RMI4 device is in bootloader mode!\n");
+
+}
+
+/*
+ * Scan the PDT for F01 so we can force a reset before anything else
+ * is done.  This forces the sensor into a known state, and also
+ * forces application of any pending updates from reflashing the
+ * firmware or configuration.  We have to do this before actually
+ * building the PDT because the reflash might cause various registers
+ * to move around.
+ */
+static int do_initial_reset(struct rmi_device *rmi_dev)
+{
+	struct pdt_entry pdt_entry;
+	int page;
+	struct device *dev = &rmi_dev->dev;
+	bool done = false;
+	bool has_f01 = false;
+	bool has_f34 = false;
+	struct pdt_entry f34_pdt, f01_pdt;
+	int i;
+	int retval;
+	struct rmi_device_platform_data *pdata;
+
+	dev_dbg(dev, "Initial reset.\n");
+	pdata = to_rmi_platform_data(rmi_dev);
+	for (page = 0; (page <= RMI4_MAX_PAGE) && !done; page++) {
+		u16 page_start = RMI4_PAGE_SIZE * page;
+		u16 pdt_start = page_start + PDT_START_SCAN_LOCATION;
+		u16 pdt_end = page_start + PDT_END_SCAN_LOCATION;
+
+		done = true;
+		for (i = pdt_start; i >= pdt_end; i -= sizeof(pdt_entry)) {
+			retval = rmi_read_block(rmi_dev, i, (u8 *)&pdt_entry,
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
+
+			if (pdt_entry.function_number == 0x01) {
+				u16 cmd_addr = page_start +
+					pdt_entry.command_base_addr;
+				u8 cmd_buf = RMI_DEVICE_RESET_CMD;
+				retval = rmi_write_block(rmi_dev, cmd_addr,
+						&cmd_buf, 1);
+				if (retval < 0) {
+					dev_err(dev, "Initial reset failed. Code = %d.\n",
+						retval);
+					return retval;
+				}
+				mdelay(pdata->reset_delay_ms);
+				if (IS_ENABLED(CONFIG_RMI4_FWLIB))
+					memcpy(&f01_pdt, &pdt_entry,
+							sizeof(pdt_entry));
+				else
+					done = true;
+				has_f01 = true;
+				break;
+			} else if (IS_ENABLED(CONFIG_RMI4_FWLIB) &&
+					pdt_entry.function_number == 0x34) {
+				memcpy(&f34_pdt, &pdt_entry, sizeof(pdt_entry));
+				has_f34 = true;
+			}
+		}
+	}
+
+	if (!has_f01) {
+		dev_warn(dev, "WARNING: Failed to find F01 for initial reset.\n");
+		return -ENODEV;
+	}
+
+	if (IS_ENABLED(CONFIG_RMI4_FWLIB)) {
+		if (has_f34)
+			rmi4_fw_update(rmi_dev, &f01_pdt, &f34_pdt);
+		else
+			dev_warn(dev, "WARNING: No F34, firmware update will not be done.\n");
+	}
+
+	return 0;
+}
+
+static int rmi_scan_pdt(struct rmi_device *rmi_dev)
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
+	dev_dbg(dev, "Scanning PDT...\n");
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
+			retval = rmi_read_block(rmi_dev, i, (u8 *)&pdt_entry,
+					       sizeof(pdt_entry));
+			if (retval != sizeof(pdt_entry)) {
+				dev_err(dev, "Read of PDT entry at %#06x failed.\n",
+					i);
+				goto error_exit;
+			}
+
+			if (RMI4_END_OF_PDT(pdt_entry.function_number))
+				break;
+
+			dev_dbg(dev, "Found F%02X on page %#04x\n",
+					pdt_entry.function_number, page);
+			done = false;
+
+			if (pdt_entry.function_number == 0x01)
+				check_bootloader_mode(rmi_dev, &pdt_entry,
+						      page_start);
+
+			retval = create_function_container(rmi_dev,
+					&pdt_entry, &irq_count, page_start);
+
+			if (retval)
+				goto error_exit;
+		}
+		done = done || data->f01_bootloader_mode;
+	}
+	data->irq_count = irq_count;
+	data->num_of_irq_regs = (irq_count + 7) / 8;
+	dev_dbg(dev, "%s: Done with PDT scan.\n", __func__);
+	retval = 0;
+
+error_exit:
+	mutex_unlock(&data->pdt_mutex);
+	return retval;
+}
+
+static irqreturn_t rmi_irq_thread(int irq, void *p)
+{
+	struct rmi_phys_device *phys = p;
+	struct rmi_device *rmi_dev = phys->rmi_dev;
+	struct rmi_driver *driver = rmi_dev->driver;
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+	struct rmi_driver_data *data;
+
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	if IRQ_DEBUG(data)
+		dev_dbg(phys->dev, "ATTN gpio, value: %d.\n",
+				gpio_get_value(pdata->attn_gpio));
+
+	if (gpio_get_value(pdata->attn_gpio) == pdata->attn_polarity) {
+		atomic_inc(&data->attn_count);
+		if (driver && driver->irq_handler && rmi_dev)
+			driver->irq_handler(rmi_dev, irq);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int enable_sensor(struct rmi_device *rmi_dev);
+static void disable_sensor(struct rmi_device *rmi_dev);
+
+static int __devinit rmi_driver_probe(struct device *dev)
+{
+	struct rmi_driver *rmi_driver;
+	struct rmi_driver_data *data = NULL;
+	struct rmi_function_container *fc;
+	struct rmi_device_platform_data *pdata;
+	int retval = 0;
+	int attr_count = 0;
+	struct rmi_device *rmi_dev;
+
+	dev_dbg(dev, "%s: Starting probe.\n", __func__);
+	if (!dev->driver) {
+		dev_err(dev, "No driver for RMI4 device during probe!\n");
+		return -ENODEV;
+	}
+
+	if (dev->type != &rmi_sensor_type) {
+		dev_dbg(dev, "Not a sensor device.\n");
+		return 1;
+	}
+
+	rmi_dev = to_rmi_device(dev);
+	rmi_driver = to_rmi_driver(dev->driver);
+	rmi_dev->driver = rmi_driver;
+
+	pdata = to_rmi_platform_data(rmi_dev);
+
+	data = devm_kzalloc(dev, sizeof(struct rmi_driver_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(dev, "%s: Failed to allocate driver data.\n", __func__);
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&data->rmi_functions.list);
+	dev_set_drvdata(&rmi_dev->dev, data);
+	mutex_init(&data->pdt_mutex);
+
+	/* Right before a warm boot, the sensor might be in some unusual state,
+	 * such as F54 diagnostics, or F34 bootloader mode.  In order to clear
+	 * the sensor to a known state, we issue a initial reset to clear any
+	 * previous settings and force it into normal operation.
+	 *
+	 * For a number of reasons, this initial reset may fail to return
+	 * within the specified time, but we'll still be able to bring up the
+	 * driver normally after that failure.  This occurs most commonly in
+	 * a cold boot situation (where then firmware takes longer to come up
+	 * than from a warm boot) and the reset_delay_ms in the platform data
+	 * has been set too short to accomodate that.  Since the sensor will
+	 * eventually come up and be usable, we don't want to just fail here
+	 * and leave the customer's device unusable.  So we warn them, and
+	 * continue processing.
+	 */
+	if (!pdata->reset_delay_ms)
+		pdata->reset_delay_ms = DEFAULT_RESET_DELAY_MS;
+	retval = do_initial_reset(rmi_dev);
+	if (retval)
+		dev_warn(dev, "RMI initial reset failed! Continuing in spite of this.\n");
+
+
+	retval = rmi_scan_pdt(rmi_dev);
+	if (retval) {
+		dev_err(dev, "PDT scan for %s failed with code %d.\n",
+			pdata->sensor_name, retval);
+		goto err_free_data;
+	}
+
+	if (!data->f01_container) {
+		dev_err(dev, "missing F01 container!\n");
+		retval = -EINVAL;
+		goto err_free_data;
+	}
+
+	list_for_each_entry(fc, &data->rmi_functions.list, list)
+		fc->irq_mask = rmi_driver_irq_get_mask(rmi_dev, fc);
+
+	retval = rmi_read(rmi_dev, PDT_PROPERTIES_LOCATION,
+			 data->pdt_props.regs);
+	if (retval < 0) {
+		/* we'll print out a warning and continue since
+		 * failure to get the PDT properties is not a cause to fail
+		 */
+		dev_warn(dev, "Could not read PDT properties from %#06x. Assuming 0x00.\n",
+			 PDT_PROPERTIES_LOCATION);
+	}
+
+	dev_dbg(dev, "%s: Creating sysfs files.", __func__);
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		retval = device_create_file(dev, &attrs[attr_count]);
+		if (retval < 0) {
+			dev_err(dev, "%s: Failed to create sysfs file %s.\n",
+				__func__, attrs[attr_count].attr.name);
+			goto err_free_data;
+		}
+	}
+	if (data->pdt_props.has_bsr) {
+		retval = device_create_file(dev, &bsr_attribute);
+		if (retval < 0) {
+			dev_err(dev, "%s: Failed to create sysfs file bsr.\n",
+				__func__);
+			goto err_free_data;
+		}
+	}
+
+	mutex_init(&data->irq_mutex);
+	/* call devm_kcalloc when it will be defined in kernel in furture */
+	data->current_irq_mask = devm_kzalloc(dev,
+					data->num_of_irq_regs,
+					GFP_KERNEL);
+	if (!data->current_irq_mask) {
+		dev_err(dev, "Failed to allocate current_irq_mask.\n");
+		retval = -ENOMEM;
+		goto err_free_data;
+	}
+	retval = rmi_read_block(rmi_dev,
+				data->f01_container->fd.control_base_addr+1,
+				data->current_irq_mask, data->num_of_irq_regs);
+	if (retval < 0) {
+		dev_err(dev, "%s: Failed to read current IRQ mask.\n",
+			__func__);
+		goto err_free_data;
+	}
+
+	/* call devm_kcalloc when it will be defined in kernel in furture */
+	data->irq_mask_store = devm_kzalloc(dev,
+					data->num_of_irq_regs,
+					GFP_KERNEL);
+	if (!data->irq_mask_store) {
+		dev_err(dev, "Failed to allocate mask store.\n");
+		retval = -ENOMEM;
+		goto err_free_data;
+	}
+
+	if (IS_ENABLED(CONFIG_PM)) {
+		data->pm_data = pdata->pm_data;
+		data->pre_suspend = pdata->pre_suspend;
+		data->post_suspend = pdata->post_suspend;
+		data->pre_resume = pdata->pre_resume;
+		data->post_resume = pdata->post_resume;
+
+		mutex_init(&data->suspend_mutex);
+	}
+
+	data->irq = gpio_to_irq(pdata->attn_gpio);
+	if (pdata->level_triggered) {
+		data->irq_flags = IRQF_ONESHOT |
+			((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
+			? IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
+	} else {
+		data->irq_flags =
+			(pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH)
+			? IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
+	}
+
+	if (data->f01_container->dev.driver) {
+		/* Driver already bound, so enable ATTN now. */
+		enable_sensor(rmi_dev);
+	}
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
+		retval = setup_debugfs(rmi_dev);
+		if (retval < 0)
+			dev_warn(&fc->dev, "Failed to setup debugfs. Code: %d.\n",
+				retval);
+	}
+
+	return 0;
+
+ err_free_data:
+	rmi_free_function_list(rmi_dev);
+	for (attr_count--; attr_count >= 0; attr_count--)
+		device_remove_file(dev, &attrs[attr_count]);
+	if (data->pdt_props.has_bsr)
+		device_remove_file(dev, &bsr_attribute);
+	return retval;
+}
+
+static void disable_sensor(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+
+	if (!data->enabled)
+		return;
+
+	if (rmi_dev->phys->disable_device)
+		rmi_dev->phys->disable_device(rmi_dev->phys);
+
+	disable_irq(data->irq);
+	free_irq(data->irq, rmi_dev->phys);
+
+	data->enabled = false;
+}
+
+static int enable_sensor(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
+	struct rmi_phys_device *rmi_phys;
+	int retval = 0;
+
+	if (data->enabled)
+		return 0;
+
+	if (rmi_dev->phys->enable_device) {
+		retval = rmi_dev->phys->enable_device(rmi_dev->phys);
+		if (retval)
+			return retval;
+	}
+
+	rmi_phys = rmi_dev->phys;
+	retval = request_threaded_irq(data->irq,
+			rmi_phys->hard_irq ? rmi_phys->hard_irq : NULL,
+			rmi_phys->irq_thread ?
+				rmi_phys->irq_thread : rmi_irq_thread,
+			data->irq_flags,
+			dev_name(&rmi_dev->dev), rmi_phys);
+	if (retval)
+		return retval;
+
+
+	data->enabled = true;
+	return 0;
+}
+
+static int f01_notifier_call(struct notifier_block *nb,
+				unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct rmi_function_container *fc;
+
+	if (dev->type != &rmi_function_type)
+		return 0;
+
+	fc = to_rmi_function_container(dev);
+	if (fc->fd.function_number != 0x01)
+		return 0;
+
+	switch (action) {
+	case BUS_NOTIFY_BOUND_DRIVER:
+		dev_dbg(dev, "%s: F01 driver bound.\n", __func__);
+		enable_sensor(fc->rmi_dev);
+		break;
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		dev_dbg(dev, "%s: F01 driver going away.\n", __func__);
+		disable_sensor(fc->rmi_dev);
+		break;
+	}
+	return 0;
+}
+
+static struct notifier_block rmi_bus_notifier = {
+	.notifier_call = f01_notifier_call,
+};
+
+#ifdef CONFIG_PM
+static int suspend_one_device(struct rmi_function_container *fc)
+{
+	struct rmi_function_handler *fh;
+	int retval = 0;
+
+	if (!fc->dev.driver)
+		return 0;
+
+	fh = to_rmi_function_handler(fc->dev.driver);
+
+	if (fh->suspend) {
+		retval = fh->suspend(fc);
+		if (retval < 0)
+			dev_err(&fc->dev, "Suspend failed, code: %d",
+				retval);
+	}
+
+	return retval;
+}
+
+static int standard_suspend(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data;
+	struct rmi_function_container *entry;
+	int retval = 0;
+
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	mutex_lock(&data->suspend_mutex);
+	if (data->suspended)
+		goto exit;
+
+	if (data->pre_suspend) {
+		retval = data->pre_suspend(data->pm_data);
+		if (retval)
+			goto exit;
+	}
+
+	disable_sensor(rmi_dev);
+
+	/** Do it backwards so F01 comes last. */
+	list_for_each_entry_reverse(entry, &data->rmi_functions.list, list)
+		if (suspend_one_device(entry) < 0)
+			goto exit;
+
+	data->suspended = true;
+
+	if (data->post_suspend)
+		retval = data->post_suspend(data->pm_data);
+
+exit:
+	mutex_unlock(&data->suspend_mutex);
+	return retval;
+}
+
+static int resume_one_device(struct rmi_function_container *fc)
+{
+	struct rmi_function_handler *fh;
+	int retval = 0;
+
+	if (!fc->dev.driver)
+		return 0;
+
+	fh = to_rmi_function_handler(fc->dev.driver);
+
+	if (fh->resume) {
+		retval = fh->resume(fc);
+		if (retval < 0)
+			dev_err(&fc->dev, "Resume failed, code: %d",
+				retval);
+	}
+
+	return retval;
+}
+
+static int standard_resume(struct rmi_device *rmi_dev)
+{
+	struct rmi_driver_data *data;
+	struct rmi_function_container *entry;
+	int retval = 0;
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	mutex_lock(&data->suspend_mutex);
+	if (!data->suspended)
+		goto exit;
+
+	if (data->pre_resume) {
+		retval = data->pre_resume(data->pm_data);
+		if (retval)
+			goto exit;
+	}
+
+	/** Do it forwards, so F01 comes first. */
+	list_for_each_entry(entry, &data->rmi_functions.list, list)
+		if (resume_one_device(entry) < 0)
+			goto exit;
+
+	retval = enable_sensor(rmi_dev);
+	if (retval)
+		goto exit;
+
+
+	if (data->post_resume) {
+		retval = data->post_resume(data->pm_data);
+		if (retval)
+			goto exit;
+	}
+
+	data->suspended = false;
+exit:
+	mutex_unlock(&data->suspend_mutex);
+	return retval;
+}
+
+static int rmi_driver_suspend(struct device *dev)
+{
+	struct rmi_device *rmi_dev = to_rmi_device(dev);
+	return standard_suspend(rmi_dev);
+}
+
+static int rmi_driver_resume(struct device *dev)
+{
+	struct rmi_device *rmi_dev = to_rmi_device(dev);
+	return standard_resume(rmi_dev);
+}
+
+#endif /* CONFIG_PM */
+
+static int __devexit rmi_driver_remove(struct device *dev)
+{
+	struct rmi_driver_data *data;
+	int i;
+	struct rmi_device *rmi_dev = to_rmi_device(dev);
+
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	disable_sensor(rmi_dev);
+
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG))
+		teardown_debugfs(rmi_dev);
+
+	rmi_free_function_list(rmi_dev);
+	for (i = 0; i < ARRAY_SIZE(attrs); i++)
+		device_remove_file(&rmi_dev->dev, &attrs[i]);
+	if (data->pdt_props.has_bsr)
+		device_remove_file(&rmi_dev->dev, &bsr_attribute);
+	return 0;
+}
+
+static UNIVERSAL_DEV_PM_OPS(rmi_driver_pm, rmi_driver_suspend,
+			    rmi_driver_resume, NULL);
+
+static struct rmi_driver sensor_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "rmi_generic",
+		.bus = &rmi_bus_type,
+		.pm = &rmi_driver_pm,
+		.probe = rmi_driver_probe,
+		.remove = __devexit_p(rmi_driver_remove),
+	},
+	.irq_handler = rmi_driver_irq_handler,
+	.reset_handler = rmi_driver_reset_handler,
+	.get_func_irq_mask = rmi_driver_irq_get_mask,
+	.store_irq_mask = rmi_driver_irq_save,
+	.restore_irq_mask = rmi_driver_irq_restore,
+};
+
+/* sysfs show and store fns for driver attributes */
+
+static ssize_t rmi_driver_bsr_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct rmi_device *rmi_dev;
+	struct rmi_driver_data *data;
+	rmi_dev = to_rmi_device(dev);
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", data->bsr);
+}
+
+static ssize_t rmi_driver_bsr_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int retval;
+	unsigned long val;
+	struct rmi_device *rmi_dev;
+	struct rmi_driver_data *data;
+
+	rmi_dev = to_rmi_device(dev);
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	/* need to convert the string data to an actual value */
+	retval = strict_strtoul(buf, 10, &val);
+	if (retval < 0 || val > 255) {
+		dev_err(dev, "Invalid value '%s' written to BSR.\n", buf);
+		return -EINVAL;
+	}
+
+	retval = rmi_write(rmi_dev, BSR_LOCATION, (u8)val);
+	if (retval < 0) {
+		dev_err(dev, "%s : failed to write bsr %lu to %#06x\n",
+			__func__, val, BSR_LOCATION);
+		return retval;
+	}
+
+	data->bsr = val;
+
+	return count;
+}
+
+static ssize_t rmi_driver_enabled_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct rmi_device *rmi_dev;
+	struct rmi_driver_data *data;
+
+	rmi_dev = to_rmi_device(dev);
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", data->enabled);
+}
+
+static ssize_t rmi_driver_enabled_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	int retval;
+	int new_value;
+	struct rmi_device *rmi_dev;
+	struct rmi_driver_data *data;
+
+	rmi_dev = to_rmi_device(dev);
+	data = dev_get_drvdata(&rmi_dev->dev);
+
+	if (sysfs_streq(buf, "0"))
+		new_value = false;
+	else if (sysfs_streq(buf, "1"))
+		new_value = true;
+	else
+		return -EINVAL;
+
+	if (new_value) {
+		retval = enable_sensor(rmi_dev);
+		if (retval) {
+			dev_err(dev, "Failed to enable sensor, code=%d.\n",
+				retval);
+			return -EIO;
+		}
+	} else {
+		disable_sensor(rmi_dev);
+	}
+
+	return count;
+}
+
+static int __init rmi_driver_init(void)
+{
+	int retval;
+
+	retval = driver_register(&sensor_driver.driver);
+	if (retval) {
+		pr_err("%s: driver register failed, code=%d.\n", __func__,
+		       retval);
+		return retval;
+	}
+
+	/* Ask the bus to let us know when drivers are bound to devices. */
+	retval = bus_register_notifier(&rmi_bus_type, &rmi_bus_notifier);
+	if (retval) {
+		pr_err("%s: failed to register bus notifier, code=%d.\n",
+		       __func__, retval);
+		return retval;
+	}
+
+	return retval;
+}
+
+static void __exit rmi_driver_exit(void)
+{
+	bus_unregister_notifier(&rmi_bus_type, &rmi_bus_notifier);
+	driver_unregister(&sensor_driver.driver);
+}
+
+module_init(rmi_driver_init);
+module_exit(rmi_driver_exit);
+
+MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com");
+MODULE_DESCRIPTION("RMI generic driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(RMI_DRIVER_VERSION);
diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
new file mode 100644
index 0000000..a5121b7
--- /dev/null
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -0,0 +1,438 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _RMI_DRIVER_H
+#define _RMI_DRIVER_H
+
+#define RMI_DRIVER_VERSION "1.5"
+
+#define RMI_PRODUCT_ID_LENGTH    10
+#define RMI_PRODUCT_INFO_LENGTH   2
+#define RMI_DATE_CODE_LENGTH      3
+
+#include <linux/ctype.h>
+/* Sysfs related macros */
+
+/* You must define FUNCTION_DATA and FNUM to use these functions. */
+#if defined(FNUM) && defined(FUNCTION_DATA)
+
+#define tricat(x, y, z) tricat_(x, y, z)
+
+#define tricat_(x, y, z) x##y##z
+
+#define show_union_struct_prototype(propname)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
+					struct device *dev, \
+					struct device_attribute *attr, \
+					char *buf);\
+\
+static DEVICE_ATTR(propname, RMI_RO_ATTR,\
+		tricat(rmi_fn_, FNUM, _##propname##_show), \
+		rmi_store_error);
+
+#define store_union_struct_prototype(propname)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
+					struct device *dev,\
+					struct device_attribute *attr,\
+					const char *buf, size_t count);\
+\
+static DEVICE_ATTR(propname, RMI_WO_ATTR,\
+		rmi_show_error,\
+		tricat(rmi_fn_, FNUM, _##propname##_store));
+
+#define show_store_union_struct_prototype(propname)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
+					struct device *dev,\
+					struct device_attribute *attr,\
+					char *buf);\
+\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
+					struct device *dev,\
+					struct device_attribute *attr,\
+					const char *buf, size_t count);\
+\
+static DEVICE_ATTR(propname, RMI_RW_ATTR,\
+		tricat(rmi_fn_, FNUM, _##propname##_show),\
+		tricat(rmi_fn_, FNUM, _##propname##_store));
+
+#define simple_show_union_struct(regtype, propname, fmt)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
+				struct device_attribute *attr, char *buf) {\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+\
+	return snprintf(buf, PAGE_SIZE, fmt,\
+			data->regtype.propname);\
+}
+
+#define simple_show_union_struct2(regtype, reg_group, propname, fmt)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
+				struct device_attribute *attr, char *buf) {\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+\
+	return snprintf(buf, PAGE_SIZE, fmt,\
+			data->regtype.reg_group->propname);\
+}
+
+#define show_union_struct(regtype, reg_group, propname, fmt)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(\
+					struct device *dev,\
+					struct device_attribute *attr,\
+					char *buf) {\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+	int result;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+\
+	mutex_lock(&data->regtype##_mutex);\
+	/* Read current regtype values */\
+	result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
+				(u8 *)data->regtype.reg_group,\
+				sizeof(data->regtype.reg_group->regs));\
+	mutex_unlock(&data->regtype##_mutex);\
+	if (result < 0) {\
+		dev_dbg(dev, "%s : Could not read regtype at 0x%x\\n",\
+					__func__,\
+					data->regtype.reg_group->address);\
+		return result;\
+	} \
+	return snprintf(buf, PAGE_SIZE, fmt,\
+			data->regtype.reg_group->propname);\
+}
+
+#define show_store_union_struct(regtype, reg_group, propname, fmt)\
+show_union_struct(regtype, reg_group, propname, fmt)\
+\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(\
+					struct device *dev,\
+					struct device_attribute *attr,\
+					const char *buf, size_t count) {\
+	int result;\
+	unsigned long val;\
+	unsigned long old_val;\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+\
+	/* need to convert the string data to an actual value */\
+	result = strict_strtoul(buf, 10, &val);\
+\
+	/* if an error occured, return it */\
+	if (result)\
+		return result;\
+	/* Check value maybe */\
+\
+	/* Read current regtype values */\
+	mutex_lock(&data->regtype##_mutex);\
+	result =\
+	    rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
+				(u8 *)data->regtype.reg_group,\
+				sizeof(data->regtype.reg_group->regs));\
+\
+	if (result < 0) {\
+		mutex_unlock(&data->regtype##_mutex);\
+		dev_dbg(dev, "%s : Could not read regtype at 0x%x\\n",\
+					 __func__,\
+					data->regtype.reg_group->address);\
+		return result;\
+	} \
+	/* if the current regtype registers are already set as we want them,\
+	 * do nothing to them */\
+	if (data->regtype.reg_group->propname == val) {\
+		mutex_unlock(&data->regtype##_mutex);\
+		return count;\
+	} \
+	/* Write the regtype back to the regtype register */\
+	old_val = data->regtype.reg_group->propname;\
+	data->regtype.reg_group->propname = val;\
+	result =\
+	    rmi_write_block(fc->rmi_dev, data->regtype.reg_group->address,\
+				(u8 *)data->regtype.reg_group,\
+				sizeof(data->regtype.reg_group->regs));\
+	if (result < 0) {\
+		dev_dbg(dev, "%s : Could not write regtype to 0x%x\\n",\
+					__func__,\
+					data->regtype.reg_group->address);\
+		/* revert change to local value if value not written */\
+		data->regtype.reg_group->propname = old_val;\
+		mutex_unlock(&data->regtype##_mutex);\
+		return result;\
+	} \
+	mutex_unlock(&data->regtype##_mutex);\
+	return count;\
+}
+
+
+#define show_repeated_union_struct(regtype, reg_group, propname, fmt)\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device *dev,\
+					struct device_attribute *attr,\
+					char *buf) {\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+	int reg_length;\
+	int result, size = 0;\
+	char *temp;\
+	int i;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+	mutex_lock(&data->regtype##_mutex);\
+\
+	/* Read current regtype values */\
+	reg_length = data->regtype.reg_group->length;\
+	result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
+			(u8 *) data->regtype.reg_group->regs,\
+			reg_length * sizeof(u8));\
+	mutex_unlock(&data->regtype##_mutex);\
+	if (result < 0) {\
+		dev_dbg(dev, "%s : Could not read regtype at 0x%x\n"\
+					"Data may be outdated.", __func__,\
+					data->regtype.reg_group->address);\
+	} \
+	temp = buf;\
+	for (i = 0; i < reg_length; i++) {\
+		result = snprintf(temp, PAGE_SIZE - size, fmt " ",\
+				data->regtype.reg_group->regs[i].propname);\
+		if (result < 0) {\
+			dev_err(dev, "%s : Could not write output.", __func__);\
+			return result;\
+		} \
+		size += result;\
+		temp += result;\
+	} \
+	result = snprintf(temp, PAGE_SIZE - size, "\n");\
+	if (result < 0) {\
+			dev_err(dev, "%s : Could not write output.", __func__);\
+			return result;\
+	} \
+	return size + result;\
+}
+
+#define show_store_repeated_union_struct(regtype, reg_group, propname, fmt)\
+show_repeated_union_struct(regtype, reg_group, propname, fmt)\
+\
+static ssize_t tricat(rmi_fn_, FNUM, _##propname##_store)(struct device *dev,\
+				   struct device_attribute *attr,\
+				   const char *buf, size_t count) {\
+	struct rmi_function_container *fc;\
+	struct FUNCTION_DATA *data;\
+	int reg_length;\
+	int result;\
+	const char *temp;\
+	int i;\
+	unsigned int newval;\
+\
+	fc = to_rmi_function_container(dev);\
+	data = fc->data;\
+	mutex_lock(&data->regtype##_mutex);\
+\
+	/* Read current regtype values */\
+\
+	reg_length = data->regtype.reg_group->length;\
+	result = rmi_read_block(fc->rmi_dev, data->regtype.reg_group->address,\
+			(u8 *) data->regtype.reg_group->regs,\
+			reg_length * sizeof(u8));\
+\
+	if (result < 0) {\
+		dev_dbg(dev, "%s: Could not read regtype at %#06x. "\
+					"Data may be outdated.", __func__,\
+					data->regtype.reg_group->address);\
+	} \
+	\
+	/* parse input */\
+	temp = buf;\
+	for (i = 0; i < reg_length; i++) {\
+		if (sscanf(temp, fmt, &newval) == 1) {\
+			data->regtype.reg_group->regs[i].propname = newval;\
+		} else {\
+			/* If we don't read a value for each position, abort, \
+			 * restore previous values locally by rereading */\
+			result = rmi_read_block(fc->rmi_dev, \
+					data->regtype.reg_group->address,\
+					(u8 *) data->regtype.reg_group->regs,\
+					reg_length * sizeof(u8));\
+\
+			if (result < 0) {\
+				dev_dbg(dev, "%s: Couldn't read regtype at "\
+					"%#06x. Local data may be inaccurate", \
+					__func__,\
+					data->regtype.reg_group->address);\
+			} \
+			return -EINVAL;\
+		} \
+		/* move to next number */\
+		while (*temp != 0) {\
+			temp++;\
+			if (isspace(*(temp - 1)) && !isspace(*temp))\
+				break;\
+		} \
+	} \
+	result = rmi_write_block(fc->rmi_dev, data->regtype.reg_group->address,\
+			(u8 *) data->regtype.reg_group->regs,\
+			reg_length * sizeof(u8));\
+	mutex_unlock(&data->regtype##_mutex);\
+	if (result < 0) {\
+		dev_dbg(dev, "%s: Could not write new values to %#06x\n", \
+				__func__, data->regtype.reg_group->address);\
+		return result;\
+	} \
+	return count;\
+}
+
+/* Create templates for given types */
+#define simple_show_union_struct_unsigned(regtype, propname)\
+simple_show_union_struct(regtype, propname, "%u\n")
+
+#define simple_show_union_struct_unsigned2(regtype, reg_group, propname)\
+simple_show_union_struct2(regtype, reg_group, propname, "%u\n")
+
+#define show_union_struct_unsigned(regtype, reg_group, propname)\
+show_union_struct(regtype, reg_group, propname, "%u\n")
+
+#define show_store_union_struct_unsigned(regtype, reg_group, propname)\
+show_store_union_struct(regtype, reg_group, propname, "%u\n")
+
+#define show_repeated_union_struct_unsigned(regtype, reg_group, propname)\
+show_repeated_union_struct(regtype, reg_group, propname, "%u")
+
+#define show_store_repeated_union_struct_unsigned(regtype, reg_group, propname)\
+show_store_repeated_union_struct(regtype, reg_group, propname, "%u")
+
+/* Remove access to raw format string versions */
+/*#undef simple_show_union_struct
+#undef show_union_struct_unsigned
+#undef show_store_union_struct
+#undef show_repeated_union_struct
+#undef show_store_repeated_union_struct*/
+
+#endif
+
+#define GROUP(_attrs) { \
+	.attrs = _attrs,  \
+}
+
+#define attrify(nm) (&dev_attr_##nm.attr)
+
+#define PDT_PROPERTIES_LOCATION 0x00EF
+#define BSR_LOCATION 0x00FE
+
+union pdt_properties {
+	struct {
+		u8 reserved_1:6;
+		u8 has_bsr:1;
+		u8 reserved_2:1;
+	} __attribute__((__packed__));
+	u8 regs[1];
+};
+
+struct rmi_driver_data {
+	struct rmi_function_container rmi_functions;
+
+	struct rmi_function_container *f01_container;
+	bool f01_bootloader_mode;
+
+	atomic_t attn_count;
+	bool irq_debug;
+	int irq;
+	int irq_flags;
+	int num_of_irq_regs;
+	int irq_count;
+	u8 *current_irq_mask;
+	u8 *irq_mask_store;
+	bool irq_stored;
+	struct mutex irq_mutex;
+	struct mutex pdt_mutex;
+
+	union pdt_properties pdt_props;
+	u8 bsr;
+	bool enabled;
+
+#ifdef CONFIG_PM
+	bool suspended;
+	struct mutex suspend_mutex;
+
+	void *pm_data;
+	int (*pre_suspend) (const void *pm_data);
+	int (*post_suspend) (const void *pm_data);
+	int (*pre_resume) (const void *pm_data);
+	int (*post_resume) (const void *pm_data);
+#endif
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_delay;
+	struct dentry *debugfs_phys;
+	struct dentry *debugfs_reg_ctl;
+	struct dentry *debugfs_reg;
+	struct dentry *debugfs_irq;
+	struct dentry *debugfs_attn_count;
+	u16 reg_debug_addr;
+	u8 reg_debug_size;
+#endif
+
+	void *data;
+};
+
+
+#define PDT_START_SCAN_LOCATION 0x00e9
+#define PDT_END_SCAN_LOCATION	0x0005
+#define RMI4_END_OF_PDT(id) ((id) == 0x00 || (id) == 0xff)
+
+struct pdt_entry {
+	u8 query_base_addr:8;
+	u8 command_base_addr:8;
+	u8 control_base_addr:8;
+	u8 data_base_addr:8;
+	u8 interrupt_source_count:3;
+	u8 bits3and4:2;
+	u8 function_version:2;
+	u8 bit7:1;
+	u8 function_number:8;
+} __attribute__((__packed__));
+
+static inline void copy_pdt_entry_to_fd(struct pdt_entry *pdt,
+				 struct rmi_function_descriptor *fd,
+				 u16 page_start)
+{
+	fd->query_base_addr = pdt->query_base_addr + page_start;
+	fd->command_base_addr = pdt->command_base_addr + page_start;
+	fd->control_base_addr = pdt->control_base_addr + page_start;
+	fd->data_base_addr = pdt->data_base_addr + page_start;
+	fd->function_number = pdt->function_number;
+	fd->interrupt_source_count = pdt->interrupt_source_count;
+	fd->function_version = pdt->function_version;
+}
+
+#ifdef	CONFIG_RMI4_FWLIB
+extern void rmi4_fw_update(struct rmi_device *rmi_dev,
+		struct pdt_entry *f01_pdt, struct pdt_entry *f34_pdt);
+#else
+#define rmi4_fw_update(rmi_dev, f01_pdt, f34_pdt)
+#endif
+
+#endif
