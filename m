Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2IFXqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:46:25 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:22521 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2IFXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:46:22 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com, liuj97@gmail.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 3/4] ACPI: Update acpi_memhotplug to use .sys_notify
Date: Thu,  6 Sep 2012 17:40:27 -0600
Message-Id: <1346974828-12500-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1346974828-12500-1-git-send-email-toshi.kani@hp.com>
References: <1346974828-12500-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the ACPI memory hotplug driver to use .sys_notify.  Removed
ACPI namespace walks and their call-back functions that register and
unregister the hotplug handler to all memory device objects through
acpi_[install|remove]_notify_handler().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c |   93 +--------------------------------------
 1 files changed, 3 insertions(+), 90 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24c807f..1f62686 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -54,6 +54,8 @@ MODULE_LICENSE("GPL");
 
 static int acpi_memory_device_add(struct acpi_device *device);
 static int acpi_memory_device_remove(struct acpi_device *device, int type);
+static void acpi_memory_device_notify(acpi_handle handle, u32 event,
+	void *data);
 
 static const struct acpi_device_id memory_device_ids[] = {
 	{ACPI_MEMORY_DEVICE_HID, 0},
@@ -68,6 +70,7 @@ static struct acpi_driver acpi_memory_device_driver = {
 	.ops = {
 		.add = acpi_memory_device_add,
 		.remove = acpi_memory_device_remove,
+		.sys_notify = acpi_memory_device_notify,
 		},
 };
 
@@ -484,111 +487,21 @@ static int acpi_memory_device_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-/*
- * Helper function to check for memory device
- */
-static acpi_status is_memory_device(acpi_handle handle)
-{
-	char *hardware_id;
-	acpi_status status;
-	struct acpi_device_info *info;
-
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	if (!(info->valid & ACPI_VALID_HID)) {
-		kfree(info);
-		return AE_ERROR;
-	}
-
-	hardware_id = info->hardware_id.string;
-	if ((hardware_id == NULL) ||
-	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
-		status = AE_ERROR;
-
-	kfree(info);
-	return status;
-}
-
-static acpi_status
-acpi_memory_register_notify_handler(acpi_handle handle,
-				    u32 level, void *ctxt, void **retv)
-{
-	acpi_status status;
-
-
-	status = is_memory_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* continue */
-
-	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					     acpi_memory_device_notify, NULL);
-	/* continue */
-	return AE_OK;
-}
-
-static acpi_status
-acpi_memory_deregister_notify_handler(acpi_handle handle,
-				      u32 level, void *ctxt, void **retv)
-{
-	acpi_status status;
-
-
-	status = is_memory_device(handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;	/* continue */
-
-	status = acpi_remove_notify_handler(handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    acpi_memory_device_notify);
-
-	return AE_OK;	/* continue */
-}
-
 static int __init acpi_memory_device_init(void)
 {
 	int result;
-	acpi_status status;
-
 
 	result = acpi_bus_register_driver(&acpi_memory_device_driver);
 
 	if (result < 0)
 		return -ENODEV;
 
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX,
-				     acpi_memory_register_notify_handler, NULL,
-				     NULL, NULL);
-
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status, "walk_namespace failed"));
-		acpi_bus_unregister_driver(&acpi_memory_device_driver);
-		return -ENODEV;
-	}
-
 	acpi_hotmem_initialized = 1;
 	return 0;
 }
 
 static void __exit acpi_memory_device_exit(void)
 {
-	acpi_status status;
-
-
-	/*
-	 * Adding this to un-install notification handlers for all the device
-	 * handles.
-	 */
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX,
-				     acpi_memory_deregister_notify_handler, NULL,
-				     NULL, NULL);
-
-	if (ACPI_FAILURE(status))
-		ACPI_EXCEPTION((AE_INFO, status, "walk_namespace failed"));
-
 	acpi_bus_unregister_driver(&acpi_memory_device_driver);
 
 	return;
-- 
1.7.7.6

