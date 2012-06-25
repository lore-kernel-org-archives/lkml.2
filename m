Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2FYREO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:04:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:8913 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2FYREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:04:12 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        andi@firstfloor.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 2/6] ACPI: Add _OST support for sysfs eject
Date: Mon, 25 Jun 2012 10:59:29 -0600
Message-Id: <1340643573-28299-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
References: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed acpi_bus_hot_remove_device() to support _OST. This function is
also changed to global so that it can be called from hotplug notify
handlers to perform hot-remove operation.

Changed acpi_eject_store(), which is the sysfs eject handler. It checks
eject_pending to see if the request was originated from ACPI eject
notification. If not, it calls _OST(0x103,84,) per Figure 6-37 in ACPI
5.0 spec.

Added eject_pending bit to acpi_device_flags. This bit is set when the
kernel has received an ACPI eject notification, but does not initiate
its hot-remove operation by itself.

Added struct acpi_eject_event. This structure is used to pass extended
information to acpi_bus_hot_remove_device(), which has a single argument
to support asynchronous call

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c     |   58 +++++++++++++++++++++++++++++++++++++++-------
 include/acpi/acpi_bus.h |    9 ++++++-
 2 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c8a1f3b..148556a 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -83,19 +83,29 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static void acpi_bus_hot_remove_device(void *context)
+/**
+ * acpi_bus_hot_remove_device: hot-remove a device and its children
+ * @context: struct acpi_eject_event pointer (freed in this func)
+ *
+ * Hot-remove a device and its children. This function frees up the
+ * memory space passed by arg context, so that the caller may call
+ * this function asynchronously through acpi_os_hotplug_execute().
+ */
+void acpi_bus_hot_remove_device(void *context)
 {
+	struct acpi_eject_event *ej_event = (struct acpi_eject_event *) context;
 	struct acpi_device *device;
-	acpi_handle handle = context;
+	acpi_handle handle = ej_event->handle;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 	acpi_status status = AE_OK;
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 
 	if (acpi_bus_get_device(handle, &device))
-		return;
+		goto err_out;
 
 	if (!device)
-		return;
+		goto err_out;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
@@ -103,7 +113,7 @@ static void acpi_bus_hot_remove_device(void *context)
 	if (acpi_bus_trim(device, 1)) {
 		printk(KERN_ERR PREFIX
 				"Removing device failed\n");
-		return;
+		goto err_out;
 	}
 
 	/* power off device */
@@ -129,10 +139,21 @@ static void acpi_bus_hot_remove_device(void *context)
 	 * TBD: _EJD support.
 	 */
 	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status))
-		printk(KERN_WARNING PREFIX
-				"Eject device failed\n");
+	if (ACPI_FAILURE(status)) {
+		if (status != AE_NOT_FOUND)
+			printk(KERN_WARNING PREFIX
+					"Eject device failed\n");
+		goto err_out;
+	}
+
+	kfree(context);
+	return;
 
+err_out:
+	/* Inform firmware the hot-remove operation has completed w/ error */
+	(void) acpi_evaluate_hotplug_ost(handle,
+				ej_event->event, ost_code, NULL);
+	kfree(context);
 	return;
 }
 
@@ -144,6 +165,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 	acpi_status status;
 	acpi_object_type type = 0;
 	struct acpi_device *acpi_device = to_acpi_device(d);
+	struct acpi_eject_event *ej_event;
 
 	if ((!count) || (buf[0] != '1')) {
 		return -EINVAL;
@@ -160,7 +182,25 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 		goto err;
 	}
 
-	acpi_os_hotplug_execute(acpi_bus_hot_remove_device, acpi_device->handle);
+	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+	if (!ej_event) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ej_event->handle = acpi_device->handle;
+	if (acpi_device->flags.eject_pending) {
+		/* event originated from ACPI eject notification */
+		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
+		acpi_device->flags.eject_pending = 0;
+	} else {
+		/* event originated from user */
+		ej_event->event = ACPI_OST_EC_OSPM_EJECT;
+		(void) acpi_evaluate_hotplug_ost(ej_event->handle,
+			ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+	}
+
+	acpi_os_hotplug_execute(acpi_bus_hot_remove_device, (void *)ej_event);
 err:
 	return ret;
 }
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 1d9e432..b22b774 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -182,7 +182,8 @@ struct acpi_device_flags {
 	u32 suprise_removal_ok:1;
 	u32 power_manageable:1;
 	u32 performance_manageable:1;
-	u32 reserved:24;
+	u32 eject_pending:1;
+	u32 reserved:23;
 };
 
 /* File System */
@@ -334,6 +335,11 @@ struct acpi_bus_event {
 	u32 data;
 };
 
+struct acpi_eject_event {
+	acpi_handle	handle;
+	u32		event;
+};
+
 extern struct kobject *acpi_kobj;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 void acpi_bus_private_data_handler(acpi_handle, void *);
@@ -371,6 +377,7 @@ int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_add(struct acpi_device **child, struct acpi_device *parent,
 		 acpi_handle handle, int type);
+void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
-- 
1.7.7.6

