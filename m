Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2EKQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:40:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21103 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EKQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:40:26 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 3/7] ACPI: Add _OST support for sysfs eject
Date: Fri, 11 May 2012 10:36:59 -0600
Message-Id: <1336754223-5346-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
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
to support asynchronous call.

Added macro definitions of _OST source events and status codes.
Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
since this _OSC bit is not specific to CPU hotplug. This bit is
defined in Table 6-147 of ACPI 5.0 as follows.

  Bits:       3
  Field Name: Insertion / Ejection _OST Processing Support
  Definition: This bit is set if OSPM will evaluate the _OST
              object defined under a device when processing
              insertion and ejection source event codes.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c     |   58 +++++++++++++++++++++++++++++++++++++++-------
 include/acpi/acpi_bus.h |    9 ++++++-
 include/linux/acpi.h    |   31 ++++++++++++++++++++++++-
 3 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7417267..84ba717 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -83,19 +83,29 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static void acpi_bus_hot_remove_device(void *context)
+/*
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
index 7309113..b836800 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -151,7 +151,8 @@ struct acpi_device_flags {
 	u32 suprise_removal_ok:1;
 	u32 power_manageable:1;
 	u32 performance_manageable:1;
-	u32 reserved:24;
+	u32 eject_pending:1;
+	u32 reserved:23;
 };
 
 /* File System */
@@ -303,6 +304,11 @@ struct acpi_bus_event {
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
@@ -340,6 +346,7 @@ int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_add(struct acpi_device **child, struct acpi_device *parent,
 		 acpi_handle handle, int type);
+void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f421dd8..a4b1d3d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -277,7 +277,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_PAD_SUPPORT		1
 #define OSC_SB_PPC_OST_SUPPORT		2
 #define OSC_SB_PR3_SUPPORT		4
-#define OSC_SB_CPUHP_OST_SUPPORT	8
+#define OSC_SB_HOTPLUG_OST_SUPPORT	8
 #define OSC_SB_APEI_SUPPORT		16
 
 extern bool osc_sb_apei_support_acked;
@@ -309,6 +309,35 @@ extern bool osc_sb_apei_support_acked;
 
 extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
 					     u32 *mask, u32 req);
+
+/* _OST Source Event Code (OSPM Action) */
+#define ACPI_OST_EC_OSPM_SHUTDOWN		0x100
+#define ACPI_OST_EC_OSPM_EJECT			0x103
+#define ACPI_OST_EC_OSPM_INSERTION		0x200
+
+/* _OST General Processing Status Code */
+#define ACPI_OST_SC_SUCCESS			0x0
+#define ACPI_OST_SC_NON_SPECIFIC_FAILURE	0x1
+#define ACPI_OST_SC_UNRECOGNIZED_NOTIFY		0x2
+
+/* _OST OS Shutdown Processing (0x100) Status Code */
+#define ACPI_OST_SC_OS_SHUTDOWN_DENIED		0x80
+#define ACPI_OST_SC_OS_SHUTDOWN_IN_PROGRESS	0x81
+#define ACPI_OST_SC_OS_SHUTDOWN_COMPLETED	0x82
+#define ACPI_OST_SC_OS_SHUTDOWN_NOT_SUPPORTED	0x83
+
+/* _OST Ejection Request (0x3, 0x103) Status Code */
+#define ACPI_OST_SC_EJECT_NOT_SUPPORTED		0x80
+#define ACPI_OST_SC_DEVICE_IN_USE		0x81
+#define ACPI_OST_SC_DEVICE_BUSY			0x82
+#define ACPI_OST_SC_EJECT_DEPENDENCY_BUSY	0x83
+#define ACPI_OST_SC_EJECT_IN_PROGRESS		0x84
+
+/* _OST Insertion Request (0x200) Status Code */
+#define ACPI_OST_SC_INSERT_IN_PROGRESS		0x80
+#define ACPI_OST_SC_DRIVER_LOAD_FAILURE		0x81
+#define ACPI_OST_SC_INSERT_NOT_SUPPORTED	0x82
+
 extern void acpi_early_init(void);
 
 extern int acpi_nvs_register(__u64 start, __u64 size);
-- 
1.7.7.6

