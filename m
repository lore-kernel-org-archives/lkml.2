Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2JFPas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:30:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2JFPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:30:44 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        Gaohuai Han <hangaohuai@huawei.com>
Subject: [RFC PATCH v3 06/28] ACPIHP: introduce interfaces to scan and walk ACPI devices connecting to a slot
Date: Sat,  6 Oct 2012 23:27:14 +0800
Message-Id: <1349537256-21670-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances acpi_bus_scan() to implement acpihp_add_devices(),
which creates ACPI devices for hot-added system devices connecting to
an ACPI hotplug slot, but don't cross the slot boundary.

It also introduces a new interface to walk all ACPI devices connecting
to an ACPI hotplug slot.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Gaohuai Han <hangaohuai@huawei.com>
---
 drivers/acpi/hotplug/Makefile |    2 +-
 drivers/acpi/hotplug/acpihp.h |    1 +
 drivers/acpi/hotplug/device.c |  123 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h       |    2 +
 drivers/acpi/scan.c           |   11 +++-
 include/acpi/acpi_bus.h       |    2 +
 include/acpi/acpi_hotplug.h   |   15 +++++
 7 files changed, 154 insertions(+), 2 deletions(-)
 create mode 100644 drivers/acpi/hotplug/device.c

diff --git a/drivers/acpi/hotplug/Makefile b/drivers/acpi/hotplug/Makefile
index c19b350..6e5daf6 100644
--- a/drivers/acpi/hotplug/Makefile
+++ b/drivers/acpi/hotplug/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_ACPI_HOTPLUG)			+= acpihp.o
-acpihp-y					= core.o
+acpihp-y					= core.o device.o
 
 obj-$(CONFIG_ACPI_HOTPLUG_SLOT)			+= acpihp_slot.o
 acpihp_slot-y					= slot.o
diff --git a/drivers/acpi/hotplug/acpihp.h b/drivers/acpi/hotplug/acpihp.h
index 7c49eab..54d9d95 100644
--- a/drivers/acpi/hotplug/acpihp.h
+++ b/drivers/acpi/hotplug/acpihp.h
@@ -26,6 +26,7 @@
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_hotplug.h>
+#include "../internal.h"
 
 extern struct acpi_device *acpi_root;
 extern struct acpihp_slot_ops acpihp_slot_ej0;
diff --git a/drivers/acpi/hotplug/device.c b/drivers/acpi/hotplug/device.c
new file mode 100644
index 0000000..fb0451f
--- /dev/null
+++ b/drivers/acpi/hotplug/device.c
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2012 Huawei Tech. Co., Ltd.
+ * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <linux/types.h>
+#include <linux/device.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_hotplug.h>
+#include "acpihp.h"
+
+/*
+ * When creating ACPI devices for hot-added system devices connecting to slot,
+ * don't cross the slot boundary. Otherwise it will cause inconsistence
+ * to other hotplug slots.
+ */
+static acpi_status acpihp_filter_device(acpi_handle hdl, u32 level, void *arg)
+{
+	/* Skip if the handle corresponds to a child hotplug slot. */
+	if (level > 0 && acpihp_is_slot(hdl))
+		return AE_CTRL_DEPTH;
+
+	return AE_OK;
+}
+
+/* Create ACPI devices for hot-added system devices connecting to a slot. */
+int acpihp_add_devices(acpi_handle handle, struct acpi_device **child)
+{
+	struct acpi_bus_ops ops;
+
+	memset(&ops, 0, sizeof(ops));
+	ops.acpi_op_add = 1;
+	ops.acpi_op_filter_fn = &acpihp_filter_device;
+	ops.acpi_op_filter_arg = NULL;
+
+	return acpi_bus_scan(handle, &ops, child);
+}
+EXPORT_SYMBOL_GPL(acpihp_add_devices);
+
+struct acpihp_walk_arg {
+	acpihp_walk_device_cb cb;
+	void *arg;
+	acpi_status status;
+};
+
+static int acpihp_walk_cb(struct device *dev, void *data)
+{
+	acpi_status status;
+	struct acpihp_walk_arg *argp = (struct acpihp_walk_arg *)data;
+	struct acpi_device *acpi_dev;
+
+	if (dev->bus != &acpi_bus_type)
+		return 0;
+
+	/* Skip if the handle corresponds to a child hotplug slot. */
+	acpi_dev = container_of(dev, struct acpi_device, dev);
+	if (acpihp_is_slot(acpi_dev->handle))
+		return 0;
+
+	status = argp->cb(acpi_dev, argp->arg);
+	if (status == AE_OK) {
+		return device_for_each_child(dev, data, &acpihp_walk_cb);
+	} else if (status == AE_CTRL_DEPTH || status == AE_CTRL_SKIP) {
+		return 0;
+	} else {
+		argp->status = status;
+		return -1;
+	}
+}
+
+/*
+ * Walk all ACPI devices connecting to a hotplug slot, but don't cross the
+ * hotplug slot boundary.
+ */
+int acpihp_walk_devices(acpi_handle handle, acpihp_walk_device_cb cb,
+			void *argp)
+{
+	acpi_status status;
+	struct acpi_device *device;
+	struct acpihp_walk_arg arg;
+
+	if (acpi_bus_get_device(handle, &device))
+		return -ENODEV;
+
+	status = (*cb)(device, argp);
+	if (ACPI_SUCCESS(status)) {
+		arg.cb = cb;
+		arg.arg = argp;
+		arg.status = AE_OK;
+		(void) device_for_each_child(&device->dev, &arg,
+					     &acpihp_walk_cb);
+		status = arg.status;
+	}
+
+	if (status == AE_CTRL_DEPTH || status == AE_CTRL_TERMINATE ||
+	    status == AE_CTRL_SKIP)
+		status = AE_OK;
+	else if (ACPI_FAILURE(status))
+		ACPIHP_DEBUG("fails to walk devices under %p.\n", handle);
+
+	acpi_device_put(device);
+
+	return status == AE_OK ? 0 : -ENODEV;
+}
+EXPORT_SYMBOL_GPL(acpihp_walk_devices);
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 70843c0..6f0632d 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -95,5 +95,7 @@ static inline void suspend_nvs_restore(void) {}
 
 extern struct rw_semaphore acpi_device_data_handler_sem;
 void acpi_bus_data_handler(acpi_handle handle, void *context);
+int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
+		  struct acpi_device **child);
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index a1d5188..028294d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1431,6 +1431,14 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
 		return AE_CTRL_DEPTH;
 	}
 
+	/* Hooks for ACPI based system device hotplug */
+	if (ops->acpi_op_filter_fn != NULL) {
+		result = ops->acpi_op_filter_fn(handle, lvl,
+						ops->acpi_op_filter_arg);
+		if (result != AE_OK)
+			return result;
+	}
+
 	/*
 	 * We may already have an acpi_device from a previous enumeration.  If
 	 * so, we needn't add it again, but we may still have to start it.
@@ -1454,7 +1462,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
 	return AE_OK;
 }
 
-static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
+int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
 			 struct acpi_device **child)
 {
 	acpi_status status;
@@ -1612,6 +1620,7 @@ int __init acpi_scan_init(void)
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_add = 1;
 	ops.acpi_op_start = 1;
+	ops.acpi_op_filter_fn = NULL;
 
 	result = bus_register(&acpi_bus_type);
 	if (result) {
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0a109fc..8136dd7 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -127,6 +127,8 @@ typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
 	u32 acpi_op_start:1;
+	acpi_status (*acpi_op_filter_fn)(acpi_handle, u32, void *);
+	void *acpi_op_filter_arg;
 };
 
 struct acpi_device_ops {
diff --git a/include/acpi/acpi_hotplug.h b/include/acpi/acpi_hotplug.h
index 0b61a10..5025a16 100644
--- a/include/acpi/acpi_hotplug.h
+++ b/include/acpi/acpi_hotplug.h
@@ -175,6 +175,21 @@ extern acpi_status acpihp_slot_get_status(struct acpihp_slot *slot,
 extern acpi_status acpihp_slot_poweron(struct acpihp_slot *slot);
 extern acpi_status acpihp_slot_poweroff(struct acpihp_slot *slot);
 
+/*
+ * Add device objects for ACPI devices connecting to an ACPI hotplug slot,
+ * but don't cross the hotplug slot boundary.
+ */
+extern int acpihp_add_devices(acpi_handle handle, struct acpi_device **child);
+
+/*
+ * Walk all ACPI devices connecting to an ACPI hotplug slot,
+ * but don't cross the hotplug slot boundary.
+ */
+typedef acpi_status (*acpihp_walk_device_cb)(struct acpi_device *acpi_device,
+					     void *argp);
+extern int acpihp_walk_devices(acpi_handle handle, acpihp_walk_device_cb cb,
+			       void *argp);
+
 extern int acpihp_debug;
 
 #define ACPIHP_WARN(fmt, ...) \
-- 
1.7.9.5

