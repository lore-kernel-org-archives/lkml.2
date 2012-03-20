Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2CTX7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:59:31 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15889 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2CTX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:59:29 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2] ACPI: Add CPU hotplug support for processor device objects
Date: Tue, 20 Mar 2012 17:58:26 -0600
Message-Id: <1332287906-31568-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_processor_install_hotplug_notify() registers processor objects to
receive ACPI CPU hotplug event notifications. This patch additionally
registers processor device objects (ACPI0007) to receive the notifications
as well.

v2: Changed is_processor_device() to a boolean func.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/processor_driver.c |   54 ++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8ae05ce..71bdaf1 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -68,6 +68,7 @@
 #define ACPI_PROCESSOR_NOTIFY_PERFORMANCE 0x80
 #define ACPI_PROCESSOR_NOTIFY_POWER	0x81
 #define ACPI_PROCESSOR_NOTIFY_THROTTLING	0x82
+#define ACPI_PROCESSOR_DEVICE_HID	"ACPI0007"
 
 #define ACPI_PROCESSOR_LIMIT_USER	0
 #define ACPI_PROCESSOR_LIMIT_THERMAL	1
@@ -88,7 +89,7 @@ static int acpi_processor_start(struct acpi_processor *pr);
 
 static const struct acpi_device_id processor_device_ids[] = {
 	{ACPI_PROCESSOR_OBJECT_HID, 0},
-	{"ACPI0007", 0},
+	{ACPI_PROCESSOR_DEVICE_HID, 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
@@ -741,20 +742,48 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 	return;
 }
 
+static bool is_processor_device(acpi_handle handle)
+{
+	struct acpi_device_info *info;
+	char *hid;
+	acpi_status status;
+	bool is_proc;
+
+	status = acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	if (info->type == ACPI_TYPE_PROCESSOR) {
+		is_proc = true;	/* found a processor object */
+		goto cleanup;
+	}
+
+	if (!(info->valid & ACPI_VALID_HID)) {
+		is_proc = false;
+		goto cleanup;
+	}
+
+	hid = info->hardware_id.string;
+	if ((hid == NULL) || strcmp(hid, ACPI_PROCESSOR_DEVICE_HID)) {
+		is_proc = false;
+		goto cleanup;
+	}
+
+	is_proc = true;		/* found a processor device object */
+
+cleanup:
+	kfree(info);
+	return is_proc;
+}
+
 static acpi_status
 processor_walk_namespace_cb(acpi_handle handle,
 			    u32 lvl, void *context, void **rv)
 {
-	acpi_status status;
 	int *action = context;
-	acpi_object_type type = 0;
-
-	status = acpi_get_type(handle, &type);
-	if (ACPI_FAILURE(status))
-		return (AE_OK);
 
-	if (type != ACPI_TYPE_PROCESSOR)
-		return (AE_OK);
+	if (!is_processor_device(handle))
+		return AE_OK;	/* not a processor; continue to walk */
 
 	switch (*action) {
 	case INSTALL_NOTIFY_HANDLER:
@@ -772,7 +801,8 @@ processor_walk_namespace_cb(acpi_handle handle,
 		break;
 	}
 
-	return (AE_OK);
+	/* found a processor; skip walking underneath */
+	return AE_CTRL_DEPTH;
 }
 
 static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
@@ -830,7 +860,7 @@ void acpi_processor_install_hotplug_notify(void)
 {
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 	int action = INSTALL_NOTIFY_HANDLER;
-	acpi_walk_namespace(ACPI_TYPE_PROCESSOR,
+	acpi_walk_namespace(ACPI_TYPE_ANY,
 			    ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, NULL, &action, NULL);
@@ -843,7 +873,7 @@ void acpi_processor_uninstall_hotplug_notify(void)
 {
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 	int action = UNINSTALL_NOTIFY_HANDLER;
-	acpi_walk_namespace(ACPI_TYPE_PROCESSOR,
+	acpi_walk_namespace(ACPI_TYPE_ANY,
 			    ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, NULL, &action, NULL);
-- 
1.7.7.6

