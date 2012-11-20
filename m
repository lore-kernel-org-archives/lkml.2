Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2KTUx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:53:59 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:28010 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2KTUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:53:42 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v6 5/5] ACPI: Update Dock hotplug error messages
Date: Tue, 20 Nov 2012 13:44:54 -0700
Message-Id: <1353444294-25575-6-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Dock hotplug error messages with acpi_handle_<level>()
and pr_<level>().  Replaced acpi_get_name() & kfree() with
apci_handle_<level>().  Added error status to the messages where
needed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/dock.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index ae4ebf2..f32bd47 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/stddef.h>
+#include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -460,12 +461,8 @@ static void handle_dock(struct dock_station *ds, int dock)
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_buffer name_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	acpi_get_name(ds->handle, ACPI_FULL_PATHNAME, &name_buffer);
-
-	printk(KERN_INFO PREFIX "%s - %s\n",
-		(char *)name_buffer.pointer, dock ? "docking" : "undocking");
+	acpi_handle_info(ds->handle, "%s\n", dock ? "docking" : "undocking");
 
 	/* _DCK method has one argument */
 	arg_list.count = 1;
@@ -474,11 +471,10 @@ static void handle_dock(struct dock_station *ds, int dock)
 	arg.integer.value = dock;
 	status = acpi_evaluate_object(ds->handle, "_DCK", &arg_list, &buffer);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
-		ACPI_EXCEPTION((AE_INFO, status, "%s - failed to execute"
-			" _DCK\n", (char *)name_buffer.pointer));
+		acpi_handle_err(ds->handle, "Failed to execute _DCK (0x%x)\n",
+				status);
 
 	kfree(buffer.pointer);
-	kfree(name_buffer.pointer);
 }
 
 static inline void dock(struct dock_station *ds)
@@ -525,9 +521,11 @@ static void dock_lock(struct dock_station *ds, int lock)
 	status = acpi_evaluate_object(ds->handle, "_LCK", &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		if (lock)
-			printk(KERN_WARNING PREFIX "Locking device failed\n");
+			acpi_handle_warn(ds->handle,
+				"Locking device failed (0x%x)\n", status);
 		else
-			printk(KERN_WARNING PREFIX "Unlocking device failed\n");
+			acpi_handle_warn(ds->handle,
+				"Unlocking device failed (0x%x)\n", status);
 	}
 }
 
@@ -667,7 +665,7 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 	dock_lock(ds, 0);
 	eject_dock(ds);
 	if (dock_present(ds)) {
-		printk(KERN_ERR PREFIX "Unable to undock!\n");
+		acpi_handle_err(ds->handle, "Unable to undock!\n");
 		return -EBUSY;
 	}
 	complete_undock(ds);
@@ -715,7 +713,7 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 			begin_dock(ds);
 			dock(ds);
 			if (!dock_present(ds)) {
-				printk(KERN_ERR PREFIX "Unable to dock!\n");
+				acpi_handle_err(handle, "Unable to dock!\n");
 				complete_dock(ds);
 				break;
 			}
@@ -743,7 +741,7 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 			dock_event(ds, event, UNDOCK_EVENT);
 		break;
 	default:
-		printk(KERN_ERR PREFIX "Unknown dock event %d\n", event);
+		acpi_handle_err(handle, "Unknown dock event %d\n", event);
 	}
 }
 
@@ -987,7 +985,7 @@ err_rmgroup:
 	sysfs_remove_group(&dd->dev.kobj, &dock_attribute_group);
 err_unregister:
 	platform_device_unregister(dd);
-	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
+	acpi_handle_err(handle, "%s encountered error %d\n", __func__, ret);
 	return ret;
 }
 
@@ -1043,12 +1041,12 @@ static int __init dock_init(void)
 		ACPI_UINT32_MAX, find_dock_and_bay, NULL, NULL, NULL);
 
 	if (!dock_station_count) {
-		printk(KERN_INFO PREFIX "No dock devices found.\n");
+		pr_info(PREFIX "No dock devices found.\n");
 		return 0;
 	}
 
 	register_acpi_bus_notifier(&dock_acpi_notifier);
-	printk(KERN_INFO PREFIX "%s: %d docks/bays found\n",
+	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
 	return 0;
 }
-- 
1.7.11.7

