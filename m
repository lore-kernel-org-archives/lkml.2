Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1FJNmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:42:54 -0400
Received: from smtp.nokia.com ([147.243.1.48]:39370 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab1FJNmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:42:36 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
Date: Fri, 10 Jun 2011 16:38:38 +0300
Message-Id: <1307713124-3946-2-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds HSI framework in to the linux kernel.

High Speed Synchronous Serial Interface (HSI) is a
serial interface mainly used for connecting application
engines (APE) with cellular modem engines (CMT) in cellular
handsets.

HSI provides multiplexing for up to 16 logical channels,
low-latency and full duplex communication.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/Kconfig             |    2 +
 drivers/Makefile            |    1 +
 drivers/hsi/Kconfig         |   17 ++
 drivers/hsi/Makefile        |    5 +
 drivers/hsi/hsi.c           |  496 +++++++++++++++++++++++++++++++++++++++++++
 drivers/hsi/hsi_boardinfo.c |   64 ++++++
 drivers/hsi/hsi_core.h      |   37 ++++
 include/linux/hsi/hsi.h     |  412 +++++++++++++++++++++++++++++++++++
 8 files changed, 1034 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hsi/Kconfig
 create mode 100644 drivers/hsi/Makefile
 create mode 100644 drivers/hsi/hsi.c
 create mode 100644 drivers/hsi/hsi_boardinfo.c
 create mode 100644 drivers/hsi/hsi_core.h
 create mode 100644 include/linux/hsi/hsi.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3bb154d..a644aae 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/hsi/Kconfig"
+
 source "drivers/pps/Kconfig"
 
 source "drivers/ptp/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 09f3232..09e2c10 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_TARGET_CORE)	+= target/
 obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
+obj-y				+= hsi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
new file mode 100644
index 0000000..937062e
--- /dev/null
+++ b/drivers/hsi/Kconfig
@@ -0,0 +1,17 @@
+#
+# HSI driver configuration
+#
+menuconfig HSI
+	tristate "HSI support"
+	---help---
+	  The "High speed synchronous Serial Interface" is
+	  synchronous serial interface used mainly to connect
+	  application engines and cellular modems.
+
+if HSI
+
+config HSI_BOARDINFO
+	bool
+	default y
+
+endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
new file mode 100644
index 0000000..ed94a3a
--- /dev/null
+++ b/drivers/hsi/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for HSI
+#
+obj-$(CONFIG_HSI_BOARDINFO)	+= hsi_boardinfo.o
+obj-$(CONFIG_HSI)		+= hsi.o
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
new file mode 100644
index 0000000..06b5743
--- /dev/null
+++ b/drivers/hsi/hsi.c
@@ -0,0 +1,496 @@
+/*
+ * hsi.c
+ *
+ * HSI core.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/hsi/hsi.h>
+#include <linux/compiler.h>
+#include <linux/rwsem.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/kobject.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include "hsi_core.h"
+
+static struct device_type hsi_ctrl = {
+	.name	= "hsi_controller",
+};
+
+static struct device_type hsi_cl = {
+	.name	= "hsi_client",
+};
+
+static struct device_type hsi_port = {
+	.name	= "hsi_port",
+};
+
+static ssize_t modalias_show(struct device *dev,
+			struct device_attribute *a __maybe_unused, char *buf)
+{
+	return sprintf(buf, "hsi:%s\n", dev_name(dev));
+}
+
+static struct device_attribute hsi_bus_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
+static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	if (dev->type == &hsi_cl)
+		add_uevent_var(env, "MODALIAS=hsi:%s", dev_name(dev));
+
+	return 0;
+}
+
+static int hsi_bus_match(struct device *dev, struct device_driver *driver)
+{
+	return strcmp(dev_name(dev), driver->name) == 0;
+}
+
+static struct bus_type hsi_bus_type = {
+	.name		= "hsi",
+	.dev_attrs	= hsi_bus_dev_attrs,
+	.match		= hsi_bus_match,
+	.uevent		= hsi_bus_uevent,
+};
+
+static void hsi_client_release(struct device *dev)
+{
+	kfree(to_hsi_client(dev));
+}
+
+static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
+{
+	struct hsi_client *cl;
+	unsigned long flags;
+
+	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
+	if (!cl)
+		return;
+	cl->device.type = &hsi_cl;
+	cl->tx_cfg = info->tx_cfg;
+	cl->rx_cfg = info->rx_cfg;
+	cl->device.bus = &hsi_bus_type;
+	cl->device.parent = &port->device;
+	cl->device.release = hsi_client_release;
+	dev_set_name(&cl->device, info->name);
+	cl->device.platform_data = info->platform_data;
+	spin_lock_irqsave(&port->clock, flags);
+	list_add_tail(&cl->link, &port->clients);
+	spin_unlock_irqrestore(&port->clock, flags);
+	if (info->archdata)
+		cl->device.archdata = *info->archdata;
+	if (device_register(&cl->device) < 0) {
+		pr_err("hsi: failed to register client: %s\n", info->name);
+		kfree(cl);
+	}
+}
+
+static void hsi_scan_board_info(struct hsi_controller *hsi)
+{
+	struct hsi_cl_info *cl_info;
+	struct hsi_port	*p;
+
+	list_for_each_entry(cl_info, &hsi_board_list, list)
+		if (cl_info->info.hsi_id == hsi->id) {
+			p = hsi_find_port_num(hsi, cl_info->info.port);
+			if (!p)
+				continue;
+			hsi_new_client(p, &cl_info->info);
+		}
+}
+
+static int hsi_remove_client(struct device *dev, void *data __maybe_unused)
+{
+	struct hsi_client *cl = to_hsi_client(dev);
+	struct hsi_port *port = to_hsi_port(dev->parent);
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->clock, flags);
+	list_del(&cl->link);
+	spin_unlock_irqrestore(&port->clock, flags);
+	device_unregister(dev);
+
+	return 0;
+}
+
+static int hsi_remove_port(struct device *dev, void *data __maybe_unused)
+{
+	device_for_each_child(dev, NULL, hsi_remove_client);
+	device_unregister(dev);
+
+	return 0;
+}
+
+static void hsi_controller_release(struct device *dev __maybe_unused)
+{
+}
+
+static void hsi_port_release(struct device *dev __maybe_unused)
+{
+}
+
+/**
+ * hsi_unregister_controller - Unregister an HSI controller
+ * @hsi: The HSI controller to register
+ */
+void hsi_unregister_controller(struct hsi_controller *hsi)
+{
+	device_for_each_child(&hsi->device, NULL, hsi_remove_port);
+	device_unregister(&hsi->device);
+}
+EXPORT_SYMBOL_GPL(hsi_unregister_controller);
+
+/**
+ * hsi_register_controller - Register an HSI controller and its ports
+ * @hsi: The HSI controller to register
+ *
+ * Returns -errno on failure, 0 on success.
+ */
+int hsi_register_controller(struct hsi_controller *hsi)
+{
+	unsigned int i;
+	int err;
+
+	hsi->device.type = &hsi_ctrl;
+	hsi->device.bus = &hsi_bus_type;
+	hsi->device.release = hsi_controller_release;
+	err = device_register(&hsi->device);
+	if (err < 0)
+		return err;
+	for (i = 0; i < hsi->num_ports; i++) {
+		hsi->port[i].device.parent = &hsi->device;
+		hsi->port[i].device.bus = &hsi_bus_type;
+		hsi->port[i].device.release = hsi_port_release;
+		hsi->port[i].device.type = &hsi_port;
+		INIT_LIST_HEAD(&hsi->port[i].clients);
+		spin_lock_init(&hsi->port[i].clock);
+		err = device_register(&hsi->port[i].device);
+		if (err < 0)
+			goto out;
+	}
+	/* Populate HSI bus with HSI clients */
+	hsi_scan_board_info(hsi);
+
+	return 0;
+out:
+	hsi_unregister_controller(hsi);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(hsi_register_controller);
+
+/**
+ * hsi_register_client_driver - Register an HSI client to the HSI bus
+ * @drv: HSI client driver to register
+ *
+ * Returns -errno on failure, 0 on success.
+ */
+int hsi_register_client_driver(struct hsi_client_driver *drv)
+{
+	drv->driver.bus = &hsi_bus_type;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(hsi_register_client_driver);
+
+static inline int hsi_dummy_msg(struct hsi_msg *msg __maybe_unused)
+{
+	return 0;
+}
+
+static inline int hsi_dummy_cl(struct hsi_client *cl __maybe_unused)
+{
+	return 0;
+}
+
+/**
+ * hsi_alloc_controller - Allocate an HSI controller and its ports
+ * @n_ports: Number of ports on the HSI controller
+ * @flags: Kernel allocation flags
+ *
+ * Return NULL on failure or a pointer to an hsi_controller on success.
+ */
+struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags)
+{
+	struct hsi_controller	*hsi;
+	struct hsi_port		*port;
+	unsigned int		i;
+
+	if (!n_ports)
+		return NULL;
+
+	port = kzalloc(sizeof(*port)*n_ports, flags);
+	if (!port)
+		return NULL;
+	hsi = kzalloc(sizeof(*hsi), flags);
+	if (!hsi)
+		goto out;
+	for (i = 0; i < n_ports; i++) {
+		dev_set_name(&port[i].device, "port%d", i);
+		port[i].num = i;
+		port[i].async = hsi_dummy_msg;
+		port[i].setup = hsi_dummy_cl;
+		port[i].flush = hsi_dummy_cl;
+		port[i].start_tx = hsi_dummy_cl;
+		port[i].stop_tx = hsi_dummy_cl;
+		port[i].release = hsi_dummy_cl;
+		mutex_init(&port[i].lock);
+	}
+	hsi->num_ports = n_ports;
+	hsi->port = port;
+
+	return hsi;
+out:
+	kfree(port);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(hsi_alloc_controller);
+
+/**
+ * hsi_free_controller - Free an HSI controller
+ * @hsi: Pointer to HSI controller
+ */
+void hsi_free_controller(struct hsi_controller *hsi)
+{
+	if (!hsi)
+		return;
+
+	kfree(hsi->port);
+	kfree(hsi);
+}
+EXPORT_SYMBOL_GPL(hsi_free_controller);
+
+/**
+ * hsi_free_msg - Free an HSI message
+ * @msg: Pointer to the HSI message
+ *
+ * Client is responsible to free the buffers pointed by the scatterlists.
+ */
+void hsi_free_msg(struct hsi_msg *msg)
+{
+	if (!msg)
+		return;
+	sg_free_table(&msg->sgt);
+	kfree(msg);
+}
+EXPORT_SYMBOL_GPL(hsi_free_msg);
+
+/**
+ * hsi_alloc_msg - Allocate an HSI message
+ * @nents: Number of memory entries
+ * @flags: Kernel allocation flags
+ *
+ * nents can be 0. This mainly makes sense for read transfer.
+ * In that case, HSI drivers will call the complete callback when
+ * there is data to be read without consuming it.
+ *
+ * Return NULL on failure or a pointer to an hsi_msg on success.
+ */
+struct hsi_msg *hsi_alloc_msg(unsigned int nents, gfp_t flags)
+{
+	struct hsi_msg *msg;
+	int err;
+
+	msg = kzalloc(sizeof(*msg), flags);
+	if (!msg)
+		return NULL;
+
+	if (!nents)
+		return msg;
+
+	err = sg_alloc_table(&msg->sgt, nents, flags);
+	if (unlikely(err)) {
+		kfree(msg);
+		msg = NULL;
+	}
+
+	return msg;
+}
+EXPORT_SYMBOL_GPL(hsi_alloc_msg);
+
+/**
+ * hsi_async - Submit an HSI transfer to the controller
+ * @cl: HSI client sending the transfer
+ * @msg: The HSI transfer passed to controller
+ *
+ * The HSI message must have the channel, ttype, complete and destructor
+ * fields set beforehand. If nents > 0 then the client has to initialize
+ * also the scatterlists to point to the buffers to write to or read from.
+ *
+ * HSI controllers relay on pre-allocated buffers from their clients and they
+ * do not allocate buffers on their own.
+ *
+ * Once the HSI message transfer finishes, the HSI controller calls the
+ * complete callback with the status and actual_len fields of the HSI message
+ * updated. The complete callback can be called before returning from
+ * hsi_async.
+ *
+ * Returns -errno on failure or 0 on success
+ */
+int hsi_async(struct hsi_client *cl, struct hsi_msg *msg)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+
+	WARN_ON_ONCE(!msg->destructor || !msg->complete);
+	msg->cl = cl;
+
+	return port->async(msg);
+}
+EXPORT_SYMBOL_GPL(hsi_async);
+
+/**
+ * hsi_claim_port - Claim the HSI client's port
+ * @cl: HSI client that wants to claim its port
+ * @share: Flag to indicate if the client wants to share the port or not.
+ *
+ * Returns -errno on failure, 0 on success.
+ */
+int hsi_claim_port(struct hsi_client *cl, unsigned int share)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	int err = 0;
+
+	mutex_lock(&port->lock);
+	if ((port->claimed) && (!port->shared || !share)) {
+		err = -EBUSY;
+		goto out;
+	}
+	if (!try_module_get(to_hsi_controller(port->device.parent)->owner)) {
+		err = -ENODEV;
+		goto out;
+	}
+	port->claimed++;
+	port->shared = !!share;
+	cl->pclaimed = 1;
+out:
+	mutex_unlock(&port->lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(hsi_claim_port);
+
+/**
+ * hsi_release_port - Release the HSI client's port
+ * @cl: HSI client which previously claimed its port
+ */
+void hsi_release_port(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+
+	mutex_lock(&port->lock);
+	/* Allow HW driver to do some cleanup */
+	port->release(cl);
+	if (cl->pclaimed)
+		port->claimed--;
+	BUG_ON(port->claimed < 0);
+	cl->pclaimed = 0;
+	if (!port->claimed)
+		port->shared = 0;
+	module_put(to_hsi_controller(port->device.parent)->owner);
+	mutex_unlock(&port->lock);
+}
+EXPORT_SYMBOL_GPL(hsi_release_port);
+
+static int hsi_start_rx(struct hsi_client *cl, void *data __maybe_unused)
+{
+	if (cl->hsi_start_rx)
+		(*cl->hsi_start_rx)(cl);
+
+	return 0;
+}
+
+static int hsi_stop_rx(struct hsi_client *cl, void *data __maybe_unused)
+{
+	if (cl->hsi_stop_rx)
+		(*cl->hsi_stop_rx)(cl);
+
+	return 0;
+}
+
+static int hsi_port_for_each_client(struct hsi_port *port, void *data,
+				int (*fn)(struct hsi_client *cl, void *data))
+{
+	struct hsi_client *cl;
+
+	spin_lock(&port->clock);
+	list_for_each_entry(cl, &port->clients, link) {
+		spin_unlock(&port->clock);
+		(*fn)(cl, data);
+		spin_lock(&port->clock);
+	}
+	spin_unlock(&port->clock);
+
+	return 0;
+}
+
+/**
+ * hsi_event -Notifies clients about port events
+ * @port: Port where the event occurred
+ * @event: The event type
+ *
+ * Clients should not be concerned about wake line behavior. However, due
+ * to a race condition in HSI HW protocol, clients need to be notified
+ * about wake line changes, so they can implement a workaround for it.
+ *
+ * Events:
+ * HSI_EVENT_START_RX - Incoming wake line high
+ * HSI_EVENT_STOP_RX - Incoming wake line down
+ */
+void hsi_event(struct hsi_port *port, unsigned int event)
+{
+	int (*fn)(struct hsi_client *cl, void *data);
+
+	switch (event) {
+	case HSI_EVENT_START_RX:
+		fn = hsi_start_rx;
+		break;
+	case HSI_EVENT_STOP_RX:
+		fn = hsi_stop_rx;
+		break;
+	default:
+		return;
+	}
+	hsi_port_for_each_client(port, NULL, fn);
+}
+EXPORT_SYMBOL_GPL(hsi_event);
+
+static int __init hsi_init(void)
+{
+	return bus_register(&hsi_bus_type);
+}
+postcore_initcall(hsi_init);
+
+static void __exit hsi_exit(void)
+{
+	bus_unregister(&hsi_bus_type);
+}
+module_exit(hsi_exit);
+
+MODULE_AUTHOR("Carlos Chinea <carlos.chinea@nokia.com>");
+MODULE_DESCRIPTION("High-speed Synchronous Serial Interface (HSI) framework");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hsi/hsi_boardinfo.c b/drivers/hsi/hsi_boardinfo.c
new file mode 100644
index 0000000..3a9e4e8
--- /dev/null
+++ b/drivers/hsi/hsi_boardinfo.c
@@ -0,0 +1,64 @@
+/*
+ * hsi_boardinfo.c
+ *
+ * HSI clients registration interface
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#include <linux/hsi/hsi.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include "hsi_core.h"
+
+/*
+ * hsi_board_list is only used internally by the HSI framework.
+ * No one else is allowed to make use of it.
+ */
+LIST_HEAD(hsi_board_list);
+EXPORT_SYMBOL_GPL(hsi_board_list);
+
+/**
+ * hsi_register_board_info - Register HSI clients information
+ * @info: Array of HSI clients on the board
+ * @len: Length of the array
+ *
+ * HSI clients are statically declared and registered on board files.
+ *
+ * HSI clients will be automatically registered to the HSI bus once the
+ * controller and the port where the clients wishes to attach are registered
+ * to it.
+ *
+ * Return -errno on failure, 0 on success.
+ */
+int __init hsi_register_board_info(struct hsi_board_info const *info,
+							unsigned int len)
+{
+	struct hsi_cl_info *cl_info;
+
+	cl_info = kzalloc(sizeof(*cl_info) * len, GFP_KERNEL);
+	if (!cl_info)
+		return -ENOMEM;
+
+	for (; len; len--, info++, cl_info++) {
+		cl_info->info = *info;
+		list_add_tail(&cl_info->list, &hsi_board_list);
+	}
+
+	return 0;
+}
diff --git a/drivers/hsi/hsi_core.h b/drivers/hsi/hsi_core.h
new file mode 100644
index 0000000..8005509
--- /dev/null
+++ b/drivers/hsi/hsi_core.h
@@ -0,0 +1,37 @@
+/*
+ * hsi_core.h
+ *
+ * HSI framework internal interfaces,
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_HSI_CORE_H__
+#define __LINUX_HSI_CORE_H__
+
+#include <linux/hsi/hsi.h>
+
+struct hsi_cl_info {
+	struct list_head	list;
+	struct hsi_board_info	info;
+};
+
+extern struct list_head hsi_board_list;
+
+#endif /* __LINUX_HSI_CORE_H__ */
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
new file mode 100644
index 0000000..304a1cc
--- /dev/null
+++ b/include/linux/hsi/hsi.h
@@ -0,0 +1,412 @@
+/*
+ * hsi.h
+ *
+ * HSI core header file.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_HSI_H__
+#define __LINUX_HSI_H__
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/module.h>
+
+/* HSI message ttype */
+#define HSI_MSG_READ	0
+#define HSI_MSG_WRITE	1
+
+/* HSI configuration values */
+enum {
+	HSI_MODE_STREAM	= 1,
+	HSI_MODE_FRAME,
+};
+
+enum {
+	HSI_FLOW_SYNC,	/* Synchronized flow */
+	HSI_FLOW_PIPE,	/* Pipelined flow */
+};
+
+enum {
+	HSI_ARB_RR,	/* Round-robin arbitration */
+	HSI_ARB_PRIO,	/* Channel priority arbitration */
+};
+
+#define HSI_MAX_CHANNELS	16
+
+/* HSI message status codes */
+enum {
+	HSI_STATUS_COMPLETED,	/* Message transfer is completed */
+	HSI_STATUS_PENDING,	/* Message pending to be read/write (POLL) */
+	HSI_STATUS_PROCEEDING,	/* Message transfer is ongoing */
+	HSI_STATUS_QUEUED,	/* Message waiting to be served */
+	HSI_STATUS_ERROR,	/* Error when message transfer was ongoing */
+};
+
+/* HSI port event codes */
+enum {
+	HSI_EVENT_START_RX,
+	HSI_EVENT_STOP_RX,
+};
+
+/**
+ * struct hsi_config - Configuration for RX/TX HSI modules
+ * @mode: Bit transmission mode (STREAM or FRAME)
+ * @channels: Number of channels to use [1..16]
+ * @speed: Max bit transmission speed (Kbit/s)
+ * @flow: RX flow type (SYNCHRONIZED or PIPELINE)
+ * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
+ */
+struct hsi_config {
+	unsigned int	mode;
+	unsigned int	channels;
+	unsigned int	speed;
+	union {
+		unsigned int	flow;		/* RX only */
+		unsigned int	arb_mode;	/* TX only */
+	};
+};
+
+/**
+ * struct hsi_board_info - HSI client board info
+ * @name: Name for the HSI device
+ * @hsi_id: HSI controller id where the client sits
+ * @port: Port number in the controller where the client sits
+ * @tx_cfg: HSI TX configuration
+ * @rx_cfg: HSI RX configuration
+ * @platform_data: Platform related data
+ * @archdata: Architecture-dependent device data
+ */
+struct hsi_board_info {
+	const char		*name;
+	unsigned int		hsi_id;
+	unsigned int		port;
+	struct hsi_config	tx_cfg;
+	struct hsi_config	rx_cfg;
+	void			*platform_data;
+	struct dev_archdata	*archdata;
+};
+
+#ifdef CONFIG_HSI_BOARDINFO
+extern int hsi_register_board_info(struct hsi_board_info const *info,
+							unsigned int len);
+#else
+static inline int hsi_register_board_info(struct hsi_board_info const *info,
+							unsigned int len)
+{
+	return 0;
+}
+#endif /* CONFIG_HSI_BOARDINFO */
+
+/**
+ * struct hsi_client - HSI client attached to an HSI port
+ * @device: Driver model representation of the device
+ * @tx_cfg: HSI TX configuration
+ * @rx_cfg: HSI RX configuration
+ * @hsi_start_rx: Called after incoming wake line goes high
+ * @hsi_stop_rx: Called after incoming wake line goes low
+ */
+struct hsi_client {
+	struct device		device;
+	struct hsi_config	tx_cfg;
+	struct hsi_config	rx_cfg;
+	void			(*hsi_start_rx)(struct hsi_client *cl);
+	void			(*hsi_stop_rx)(struct hsi_client *cl);
+	/* private: */
+	unsigned int		pclaimed:1;
+	struct list_head	link;
+};
+
+#define to_hsi_client(dev) container_of(dev, struct hsi_client, device)
+
+static inline void hsi_client_set_drvdata(struct hsi_client *cl, void *data)
+{
+	dev_set_drvdata(&cl->device, data);
+}
+
+static inline void *hsi_client_drvdata(struct hsi_client *cl)
+{
+	return dev_get_drvdata(&cl->device);
+}
+
+/**
+ * struct hsi_client_driver - Driver associated to an HSI client
+ * @driver: Driver model representation of the driver
+ */
+struct hsi_client_driver {
+	struct device_driver	driver;
+};
+
+#define to_hsi_client_driver(drv) container_of(drv, struct hsi_client_driver,\
+									driver)
+
+int hsi_register_client_driver(struct hsi_client_driver *drv);
+
+static inline void hsi_unregister_client_driver(struct hsi_client_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+
+/**
+ * struct hsi_msg - HSI message descriptor
+ * @link: Free to use by the current descriptor owner
+ * @cl: HSI device client that issues the transfer
+ * @sgt: Head of the scatterlist array
+ * @context: Client context data associated to the transfer
+ * @complete: Transfer completion callback
+ * @destructor: Destructor to free resources when flushing
+ * @status: Status of the transfer when completed
+ * @actual_len: Actual length of data transfered on completion
+ * @channel: Channel were to TX/RX the message
+ * @ttype: Transfer type (TX if set, RX otherwise)
+ * @break_frame: if true HSI will send/receive a break frame. Data buffers are
+ *		ignored in the request.
+ */
+struct hsi_msg {
+	struct list_head	link;
+	struct hsi_client	*cl;
+	struct sg_table		sgt;
+	void			*context;
+
+	void			(*complete)(struct hsi_msg *msg);
+	void			(*destructor)(struct hsi_msg *msg);
+
+	int			status;
+	unsigned int		actual_len;
+	unsigned int		channel;
+	unsigned int		ttype:1;
+	unsigned int		break_frame:1;
+};
+
+struct hsi_msg *hsi_alloc_msg(unsigned int n_frag, gfp_t flags);
+void hsi_free_msg(struct hsi_msg *msg);
+
+/**
+ * struct hsi_port - HSI port device
+ * @device: Driver model representation of the device
+ * @tx_cfg: Current TX path configuration
+ * @rx_cfg: Current RX path configuration
+ * @num: Port number
+ * @shared: Set when port can be shared by different clients
+ * @claimed: Reference count of clients which claimed the port
+ * @lock: Serialize port claim
+ * @async: Asynchronous transfer callback
+ * @setup: Callback to set the HSI client configuration
+ * @flush: Callback to clean the HW state and destroy all pending transfers
+ * @start_tx: Callback to inform that a client wants to TX data
+ * @stop_tx: Callback to inform that a client no longer wishes to TX data
+ * @release: Callback to inform that a client no longer uses the port
+ * @clients: List of hsi_clients using the port.
+ * @clock: Lock to serialize access to the clients list.
+ */
+struct hsi_port {
+	struct device			device;
+	struct hsi_config		tx_cfg;
+	struct hsi_config		rx_cfg;
+	unsigned int			num;
+	unsigned int			shared:1;
+	int				claimed;
+	struct mutex			lock;
+	int				(*async)(struct hsi_msg *msg);
+	int				(*setup)(struct hsi_client *cl);
+	int				(*flush)(struct hsi_client *cl);
+	int				(*start_tx)(struct hsi_client *cl);
+	int				(*stop_tx)(struct hsi_client *cl);
+	int				(*release)(struct hsi_client *cl);
+	struct list_head		clients;
+	spinlock_t			clock;
+};
+
+#define to_hsi_port(dev) container_of(dev, struct hsi_port, device)
+#define hsi_get_port(cl) to_hsi_port((cl)->device.parent)
+
+void hsi_event(struct hsi_port *port, unsigned int event);
+int hsi_claim_port(struct hsi_client *cl, unsigned int share);
+void hsi_release_port(struct hsi_client *cl);
+
+static inline int hsi_port_claimed(struct hsi_client *cl)
+{
+	return cl->pclaimed;
+}
+
+static inline void hsi_port_set_drvdata(struct hsi_port *port, void *data)
+{
+	dev_set_drvdata(&port->device, data);
+}
+
+static inline void *hsi_port_drvdata(struct hsi_port *port)
+{
+	return dev_get_drvdata(&port->device);
+}
+
+/**
+ * struct hsi_controller - HSI controller device
+ * @device: Driver model representation of the device
+ * @owner: Pointer to the module owning the controller
+ * @id: HSI controller ID
+ * @num_ports: Number of ports in the HSI controller
+ * @port: Array of HSI ports
+ */
+struct hsi_controller {
+	struct device		device;
+	struct module		*owner;
+	unsigned int		id;
+	unsigned int		num_ports;
+	struct hsi_port		*port;
+};
+
+#define to_hsi_controller(dev) container_of(dev, struct hsi_controller, device)
+
+struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
+void hsi_free_controller(struct hsi_controller *hsi);
+int hsi_register_controller(struct hsi_controller *hsi);
+void hsi_unregister_controller(struct hsi_controller *hsi);
+
+static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
+								void *data)
+{
+	dev_set_drvdata(&hsi->device, data);
+}
+
+static inline void *hsi_controller_drvdata(struct hsi_controller *hsi)
+{
+	return dev_get_drvdata(&hsi->device);
+}
+
+static inline struct hsi_port *hsi_find_port_num(struct hsi_controller *hsi,
+							unsigned int num)
+{
+	return (num < hsi->num_ports) ? &hsi->port[num] : NULL;
+}
+
+/*
+ * API for HSI clients
+ */
+int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
+
+/**
+ * hsi_id - Get HSI controller ID associated to a client
+ * @cl: Pointer to a HSI client
+ *
+ * Return the controller id where the client is attached to
+ */
+static inline unsigned int hsi_id(struct hsi_client *cl)
+{
+	return	to_hsi_controller(cl->device.parent->parent)->id;
+}
+
+/**
+ * hsi_port_id - Gets the port number a client is attached to
+ * @cl: Pointer to HSI client
+ *
+ * Return the port number associated to the client
+ */
+static inline unsigned int hsi_port_id(struct hsi_client *cl)
+{
+	return	to_hsi_port(cl->device.parent)->num;
+}
+
+/**
+ * hsi_setup - Configure the client's port
+ * @cl: Pointer to the HSI client
+ *
+ * When sharing ports, clients should either relay on a single
+ * client setup or have the same setup for all of them.
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_setup(struct hsi_client *cl)
+{
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+	return	hsi_get_port(cl)->setup(cl);
+}
+
+/**
+ * hsi_flush - Flush all pending transactions on the client's port
+ * @cl: Pointer to the HSI client
+ *
+ * This function will destroy all pending hsi_msg in the port and reset
+ * the HW port so it is ready to receive and transmit from a clean state.
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_flush(struct hsi_client *cl)
+{
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+	return hsi_get_port(cl)->flush(cl);
+}
+
+/**
+ * hsi_async_read - Submit a read transfer
+ * @cl: Pointer to the HSI client
+ * @msg: HSI message descriptor of the transfer
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_async_read(struct hsi_client *cl, struct hsi_msg *msg)
+{
+	msg->ttype = HSI_MSG_READ;
+	return hsi_async(cl, msg);
+}
+
+/**
+ * hsi_async_write - Submit a write transfer
+ * @cl: Pointer to the HSI client
+ * @msg: HSI message descriptor of the transfer
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_async_write(struct hsi_client *cl, struct hsi_msg *msg)
+{
+	msg->ttype = HSI_MSG_WRITE;
+	return hsi_async(cl, msg);
+}
+
+/**
+ * hsi_start_tx - Signal the port that the client wants to start a TX
+ * @cl: Pointer to the HSI client
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_start_tx(struct hsi_client *cl)
+{
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+	return hsi_get_port(cl)->start_tx(cl);
+}
+
+/**
+ * hsi_stop_tx - Signal the port that the client no longer wants to transmit
+ * @cl: Pointer to the HSI client
+ *
+ * Return -errno on failure, 0 on success
+ */
+static inline int hsi_stop_tx(struct hsi_client *cl)
+{
+	if (!hsi_port_claimed(cl))
+		return -EACCES;
+	return hsi_get_port(cl)->stop_tx(cl);
+}
+#endif /* __LINUX_HSI_H__ */
-- 
1.7.1

