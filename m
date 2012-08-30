Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2H3UWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:22:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:43535 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2H3UWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:22:00 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 2/5] ACPI: Support system notify handler via .sys_notify
Date: Thu, 30 Aug 2012 14:16:03 -0600
Message-Id: <1346357766-14030-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1346357766-14030-1-git-send-email-toshi.kani@hp.com>
References: <1346357766-14030-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new .sys_notify interface, which allows ACPI drivers to
register their system-level (ex. hotplug) notify handlers in their
acpi_driver table.  The global notify handler acpi_bus_notify()
is called for all system-level ACPI notification, which is changed
to call an appropriate driver's handler if any.  With .sys_notify,
ACPI drivers no longer need to register or unregister driver's
handler to each ACPI device object.  It also supports dynamic ACPI
namespace with LoadTable & Unload opcode without any modification.

Added a common system notify handler acpi_bus_sys_notify(), which
allows ACPI drivers to set it to .sys_notify when this function is
fully implemented.

Note that the changes maintain the backward compatibility of ACPI
drivers.  Any ACPI driver registered its hotplug handler through
the existing interfaces, such as acpi_install_notify_handler() and
register_acpi_bus_notifier(), will continue to work as before.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/bus.c      |   48 ++++++++++++++++++++++++++++++++++------------
 include/acpi/acpi_bus.h |    2 +
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9628652..4b941c9 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -760,21 +760,16 @@ void unregister_acpi_bus_notifier(struct notifier_block *nb)
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
@@ -823,14 +818,41 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 				  type));
 		break;
 	}
+}
 
+/**
+ * acpi_bus_notify: The system global notify handler
+ * 
+ * The global notify handler for all 'system-level' device notifications
+ * (values 0x00-0x7F).  This handler calls a driver's notify handler for
+ * the notified ACPI device.
+ */
+static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
+{
+	struct acpi_device *device = NULL;
+	struct acpi_driver *driver;
+
+	/* obtain associated driver object */
 	acpi_bus_get_device(handle, &device);
-	if (device) {
+	if (device && device->driver)
 		driver = device->driver;
-		if (driver && driver->ops.notify &&
-		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
+	else
+		driver = acpi_lookup_driver(handle, type);
+
+	/* call a driver's handler */
+	if (driver) {
+		if (driver->ops.sys_notify)
+			driver->ops.sys_notify(handle, type, data);
+		else if (device && driver->ops.notify &&
+			 (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
 			driver->ops.notify(device, type);
 	}
+
+	/* call handlers in the bus notify list */
+	blocking_notifier_call_chain(&acpi_bus_notify_list,
+		type, (void *)handle);
+
+	return;
 }
 
 /* --------------------------------------------------------------------------
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a773b46..575fd2f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -123,6 +123,7 @@ typedef int (*acpi_op_start) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
+typedef void (*acpi_op_sys_notify) (acpi_handle handle, u32 event, void *data);
 
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
@@ -136,6 +137,7 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+	acpi_op_sys_notify sys_notify;
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
-- 
1.7.7.6

