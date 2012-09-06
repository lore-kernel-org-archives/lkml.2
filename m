Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2IFXqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:46:46 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:22521 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2IFXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:46:22 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com, liuj97@gmail.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 4/4] ACPI: Update container to use .sys_notify
Date: Thu,  6 Sep 2012 17:40:28 -0600
Message-Id: <1346974828-12500-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1346974828-12500-1-git-send-email-toshi.kani@hp.com>
References: <1346974828-12500-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the ACPI container driver to use .sys_notify.  Removed
ACPI namespace walks and their call-back function that register
and unregister the hotplug handler to all container objects
through acpi_[install|remove]_notify_handler().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c |   66 ++-------------------------------------------
 1 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 1f9f7d7..d4e8b71 100644
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
 
@@ -152,7 +154,7 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
 	return result;
 }
 
-static void container_notify_cb(acpi_handle handle, u32 type, void *context)
+static void container_notify(acpi_handle handle, u32 type, void *context)
 {
 	struct acpi_device *device = NULL;
 	int result;
@@ -211,82 +213,20 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
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
-	if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
-	    strcmp(hid, "PNP0A06")) {
-		goto end;
-	}
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
1.7.7.6

