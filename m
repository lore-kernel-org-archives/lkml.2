Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2KHUcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:32:21 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23512 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab2KHUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:32:13 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 2/4] ACPI: Update processor_driver to use .sys_notify
Date: Thu,  8 Nov 2012 13:23:45 -0700
Message-Id: <1352406227-32629-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the ACPI processor driver to use .sys_notify.  Removed
ACPI namespace walks and their call-back functions that register
and unregister the hotplug handler to all processor objects
through acpi_[install|remove]_notify_handler().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/processor_driver.c | 82 ++++-------------------------------------
 1 file changed, 7 insertions(+), 75 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8cc33d0..27f15f7 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -85,6 +85,10 @@ static void acpi_processor_notify(struct acpi_device *device, u32 event);
 static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr);
 static int acpi_processor_handle_eject(struct acpi_processor *pr);
 static int acpi_processor_start(struct acpi_processor *pr);
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+static void acpi_processor_hotplug_notify(acpi_handle handle, u32 event,
+		void *data);
+#endif
 
 static const struct acpi_device_id processor_device_ids[] = {
 	{ACPI_PROCESSOR_OBJECT_HID, 0},
@@ -104,6 +108,9 @@ static struct acpi_driver acpi_processor_driver = {
 		.add = acpi_processor_add,
 		.remove = acpi_processor_remove,
 		.notify = acpi_processor_notify,
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+		.sys_notify = acpi_processor_hotplug_notify,
+#endif
 		},
 	.drv.pm = &acpi_processor_pm,
 };
@@ -763,67 +770,6 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 	return;
 }
 
-static acpi_status is_processor_device(acpi_handle handle)
-{
-	struct acpi_device_info *info;
-	char *hid;
-	acpi_status status;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	if (info->type == ACPI_TYPE_PROCESSOR) {
-		kfree(info);
-		return AE_OK;	/* found a processor object */
-	}
-
-	if (!(info->valid & ACPI_VALID_HID)) {
-		kfree(info);
-		return AE_ERROR;
-	}
-
-	hid = info->hardware_id.string;
-	if ((hid == NULL) || strcmp(hid, ACPI_PROCESSOR_DEVICE_HID)) {
-		kfree(info);
-		return AE_ERROR;
-	}
-
-	kfree(info);
-	return AE_OK;	/* found a processor device object */
-}
-
-static acpi_status
-processor_walk_namespace_cb(acpi_handle handle,
-			    u32 lvl, void *context, void **rv)
-{
-	acpi_status status;
-	int *action = context;
-
-	status = is_processor_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* not a processor; continue to walk */
-
-	switch (*action) {
-	case INSTALL_NOTIFY_HANDLER:
-		acpi_install_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    acpi_processor_hotplug_notify,
-					    NULL);
-		break;
-	case UNINSTALL_NOTIFY_HANDLER:
-		acpi_remove_notify_handler(handle,
-					   ACPI_SYSTEM_NOTIFY,
-					   acpi_processor_hotplug_notify);
-		break;
-	default:
-		break;
-	}
-
-	/* found a processor; skip walking underneath */
-	return AE_CTRL_DEPTH;
-}
-
 static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
 {
 	acpi_handle handle = pr->handle;
@@ -891,26 +837,12 @@ static int acpi_processor_handle_eject(struct acpi_processor *pr)
 static
 void acpi_processor_install_hotplug_notify(void)
 {
-#ifdef CONFIG_ACPI_HOTPLUG_CPU
-	int action = INSTALL_NOTIFY_HANDLER;
-	acpi_walk_namespace(ACPI_TYPE_ANY,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    processor_walk_namespace_cb, NULL, &action, NULL);
-#endif
 	register_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 static
 void acpi_processor_uninstall_hotplug_notify(void)
 {
-#ifdef CONFIG_ACPI_HOTPLUG_CPU
-	int action = UNINSTALL_NOTIFY_HANDLER;
-	acpi_walk_namespace(ACPI_TYPE_ANY,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    processor_walk_namespace_cb, NULL, &action, NULL);
-#endif
 	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
-- 
1.7.11.7

