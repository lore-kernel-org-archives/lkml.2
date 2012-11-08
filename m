Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2KHUct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:32:49 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39161 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2KHUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:32:18 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 4/4] ACPI: Update container to use .sys_notify
Date: Thu,  8 Nov 2012 13:23:47 -0700
Message-Id: <1352406227-32629-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the ACPI container driver to use .sys_notify.  Removed
ACPI namespace walks and their call-back functions that register
and unregister the hotplug handler to all container objects
through acpi_[install|remove]_notify_handler().  Renamed the
notify handler to container_notify() for consistency.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c | 77 ++----------------------------------------------
 1 file changed, 3 insertions(+), 74 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 69e2d6b..d4e8b71 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -53,6 +53,7 @@ MODULE_LICENSE("GPL");
 
 static int acpi_container_add(struct acpi_device *device);
 static int acpi_container_remove(struct acpi_device *device, int type);
+static void container_notify(acpi_handle handle, u32 type, void *context);
 
 static const struct acpi_device_id container_device_ids[] = {
 	{"ACPI0004", 0},
@@ -69,6 +70,7 @@ static struct acpi_driver acpi_container_driver = {
 	.ops = {
 		.add = acpi_container_add,
 		.remove = acpi_container_remove,
+		.sys_notify = container_notify,
 		},
 };
 
@@ -92,19 +94,6 @@ static int is_device_present(acpi_handle handle)
 	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
-static bool is_container_device(const char *hid)
-{
-	const struct acpi_device_id *container_id;
-
-	for (container_id = container_device_ids;
-	     container_id->id[0]; container_id++) {
-		if (!strcmp((char *)container_id->id, hid))
-			return true;
-	}
-
-	return false;
-}
-
 /*******************************************************************/
 static int acpi_container_add(struct acpi_device *device)
 {
@@ -165,7 +154,7 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
 	return result;
 }
 
-static void container_notify_cb(acpi_handle handle, u32 type, void *context)
+static void container_notify(acpi_handle handle, u32 type, void *context)
 {
 	struct acpi_device *device = NULL;
 	int result;
@@ -224,80 +213,20 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 	return;
 }
 
-static acpi_status
-container_walk_namespace_cb(acpi_handle handle,
-			    u32 lvl, void *context, void **rv)
-{
-	char *hid = NULL;
-	struct acpi_device_info *info;
-	acpi_status status;
-	int *action = context;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status)) {
-		return AE_OK;
-	}
-
-	if (info->valid & ACPI_VALID_HID)
-		hid = info->hardware_id.string;
-
-	if (hid == NULL) {
-		goto end;
-	}
-
-	if (!is_container_device(hid))
-		goto end;
-
-	switch (*action) {
-	case INSTALL_NOTIFY_HANDLER:
-		acpi_install_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    container_notify_cb, NULL);
-		break;
-	case UNINSTALL_NOTIFY_HANDLER:
-		acpi_remove_notify_handler(handle,
-					   ACPI_SYSTEM_NOTIFY,
-					   container_notify_cb);
-		break;
-	default:
-		break;
-	}
-
-      end:
-	kfree(info);
-
-	return AE_OK;
-}
-
 static int __init acpi_container_init(void)
 {
 	int result = 0;
-	int action = INSTALL_NOTIFY_HANDLER;
 
 	result = acpi_bus_register_driver(&acpi_container_driver);
 	if (result < 0) {
 		return (result);
 	}
 
-	/* register notify handler to every container device */
-	acpi_walk_namespace(ACPI_TYPE_DEVICE,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    container_walk_namespace_cb, NULL, &action, NULL);
-
 	return (0);
 }
 
 static void __exit acpi_container_exit(void)
 {
-	int action = UNINSTALL_NOTIFY_HANDLER;
-
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE,
-			    ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    container_walk_namespace_cb, NULL, &action, NULL);
-
 	acpi_bus_unregister_driver(&acpi_container_driver);
 
 	return;
-- 
1.7.11.7

