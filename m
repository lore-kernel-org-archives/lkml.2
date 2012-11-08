Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2KHUcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:32:13 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23492 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab2KHUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:32:11 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 1/4] ACPI: Support system notify handler via .sys_notify
Date: Thu,  8 Nov 2012 13:23:44 -0700
Message-Id: <1352406227-32629-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new .sys_notify interface, which allows ACPI drivers to
register their system-level (ex. hotplug) notify handlers through
their acpi_driver table.  This removes redundant ACPI namespace
walks from ACPI drivers for faster booting.

The global notify handler acpi_bus_notify() is called for all
system-level ACPI notifications, which then calls an appropriate
driver's handler if any.  ACPI drivers no longer need to register
or unregister driver's handler to each ACPI device object.  It also
supports dynamic ACPI namespace with LoadTable & Unload opcode
without any modification in ACPI drivers.

Added a common system notify handler acpi_bus_sys_notify(), which
allows ACPI drivers to set it to .sys_notify when this function is
fully implemented.  It removes functional conflict between driver's
notify handler and the global notify handler acpi_bus_notify().

Note that the changes maintain backward compatibility for ACPI
drivers.  Any drivers registered their hotplug handler through the
existing interfaces, such as acpi_install_notify_handler() and
register_acpi_bus_notifier(), will continue to work as before.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/bus.c      | 64 ++++++++++++++++++++++++++++----------
 drivers/acpi/scan.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  6 ++++
 3 files changed, 137 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 07a20ee..b256bcf2 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -779,21 +779,16 @@ void unregister_acpi_bus_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(unregister_acpi_bus_notifier);
 
 /**
- * acpi_bus_notify
- * ---------------
- * Callback for all 'system-level' device notifications (values 0x00-0x7F).
+ * acpi_bus_sys_notify: Common system notify handler
+ *
+ * ACPI drivers may specify this common handler to its sys_notify entry.
+ * TBD: This handler is not implemented yet.
  */
-static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
+void acpi_bus_sys_notify(acpi_handle handle, u32 type, void *data)
 {
-	struct acpi_device *device = NULL;
-	struct acpi_driver *driver;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
 			  type, handle));
 
-	blocking_notifier_call_chain(&acpi_bus_notify_list,
-		type, (void *)handle);
-
 	switch (type) {
 
 	case ACPI_NOTIFY_BUS_CHECK:
@@ -842,14 +837,51 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 				  type));
 		break;
 	}
+}
+
+/**
+ * acpi_bus_drv_notify: Call driver's system-level notify handler
+ */
+void acpi_bus_drv_notify(struct acpi_driver *driver,
+		struct acpi_device *device, acpi_handle handle,
+		u32 type, void *data)
+{
+	BUG_ON(!driver);
+
+	if (driver->ops.sys_notify)
+		driver->ops.sys_notify(handle, type, data);
+	else if (device && driver->ops.notify &&
+		 (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
+		driver->ops.notify(device, type);
+
+	return;
+}
+
+/**
+ * acpi_bus_notify: The system-level global notify handler
+ *
+ * The global notify handler for all 'system-level' device notifications
+ * (values 0x00-0x7F).  This handler calls a driver's notify handler for
+ * the notified ACPI device.
+ */
+static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
+{
+	struct acpi_device *device = NULL;
+
+	/* call registered handlers in the bus notify list */
+	blocking_notifier_call_chain(&acpi_bus_notify_list,
+						type, (void *)handle);
 
+	/* obtain an associated driver if already bound */
 	acpi_bus_get_device(handle, &device);
-	if (device) {
-		driver = device->driver;
-		if (driver && driver->ops.notify &&
-		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
-			driver->ops.notify(device, type);
-	}
+
+	/* call the driver's system-level notify handler */
+	if (device && device->driver)
+		acpi_bus_drv_notify(device->driver, device, handle, type, data);
+	else
+		acpi_lookup_drv_notify(handle, type, data);
+
+	return;
 }
 
 /* --------------------------------------------------------------------------
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 95ff1e8..333e57f 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1758,3 +1758,86 @@ int __init acpi_scan_init(void)
 
 	return result;
 }
+
+/* callback args for acpi_match_drv_notify() */
+struct acpi_notify_args {
+	struct acpi_device	*device;
+	acpi_handle		handle;
+	u32			event;
+	void			*data;
+};
+
+static int acpi_match_drv_notify(struct device_driver *drv, void *data)
+{
+	struct acpi_driver *driver = to_acpi_driver(drv);
+	struct acpi_notify_args *args = (struct acpi_notify_args *) data;
+
+	/* check if this driver matches with the device */
+	if (acpi_match_device_ids(args->device, driver->ids))
+		return 0;
+
+	/* call the driver's notify handler */
+	acpi_bus_drv_notify(driver, NULL, args->handle,
+					args->event, args->data);
+
+	return 1;
+}
+
+/**
+ * acpi_lookup_drv_notify: Look up and call driver's notify handler
+ * @handle: ACPI handle of the notified device object
+ * @event: Notify event
+ * @data: Context
+ *
+ * Look up and call the associated driver's notify handler for the ACPI
+ * device object by walking through the list of ACPI drivers.
+ */
+void acpi_lookup_drv_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct acpi_notify_args args;
+	struct acpi_device *device;
+	unsigned long long sta;
+	int type;
+	int ret;
+
+	/* allocate a temporary device object */
+	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
+	if (!device) {
+		pr_err(PREFIX "No memory to allocate a tmp device\n");
+		return;
+	}
+	INIT_LIST_HEAD(&device->pnp.ids);
+
+	/* obtain device type */
+	ret = acpi_bus_type_and_status(handle, &type, &sta);
+	if (ret) {
+		pr_err(PREFIX "Failed to get device type\n");
+		goto out;
+	}
+
+	/* setup this temporary device object */
+	device->device_type = type;
+	device->handle = handle;
+	device->parent = acpi_bus_get_parent(handle);
+	device->dev.bus = &acpi_bus_type;
+	device->driver = NULL;
+	STRUCT_TO_INT(device->status) = sta;
+	device->status.present = 1;
+
+	/* set HID to this device object */
+	acpi_device_set_id(device);
+
+	/* set args */
+	args.device = device;
+	args.handle = handle;
+	args.event = event;
+	args.data = data;
+
+	/* call a matched driver's notify handler */
+	(void) bus_for_each_drv(device->dev.bus, NULL,
+					&args, acpi_match_drv_notify);
+
+out:
+	acpi_device_release(&device->dev);
+	return;
+}
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2242c10..4052406 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -94,6 +94,7 @@ typedef int (*acpi_op_start) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
+typedef void (*acpi_op_sys_notify) (acpi_handle handle, u32 event, void *data);
 
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
@@ -107,6 +108,7 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+	acpi_op_sys_notify sys_notify;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
@@ -328,6 +330,10 @@ extern int unregister_acpi_notifier(struct notifier_block *);
 
 extern int register_acpi_bus_notifier(struct notifier_block *nb);
 extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
+extern void acpi_lookup_drv_notify(acpi_handle handle, u32 event, void *data);
+extern void acpi_bus_drv_notify(struct acpi_driver *driver,
+	struct acpi_device *device, acpi_handle handle, u32 type, void *data);
+
 /*
  * External Functions
  */
-- 
1.7.11.7

