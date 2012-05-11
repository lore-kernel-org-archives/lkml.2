Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab2EKQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:40:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21346 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EKQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:40:37 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 5/7] ACPI: Add _OST support for ACPI memory hotplug
Date: Fri, 11 May 2012 10:37:01 -0600
Message-Id: <1336754223-5346-6-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed acpi_memory_device_notify() to call ACPI _OST method
when ACPI memory hotplug operation has completed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c |   43 +++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d985713..24c807f 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -341,7 +341,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct acpi_memory_device *mem_device;
 	struct acpi_device *device;
-
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
@@ -354,15 +354,20 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 					  "\nReceived DEVICE CHECK notification for device\n"));
 		if (acpi_memory_get_device(handle, &mem_device)) {
 			printk(KERN_ERR PREFIX "Cannot find driver data\n");
-			return;
+			break;
 		}
 
-		if (!acpi_memory_check_device(mem_device)) {
-			if (acpi_memory_enable_device(mem_device))
-				printk(KERN_ERR PREFIX
-					    "Cannot enable memory device\n");
+		if (acpi_memory_check_device(mem_device))
+			break;
+
+		if (acpi_memory_enable_device(mem_device)) {
+			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
+			break;
 		}
+
+		ost_code = ACPI_OST_SC_SUCCESS;
 		break;
+
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "\nReceived EJECT REQUEST notification for device\n"));
@@ -383,19 +388,35 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 		 * TBD: Can also be disabled by Callback registration
 		 *      with generic sysfs driver
 		 */
-		if (acpi_memory_disable_device(mem_device))
-			printk(KERN_ERR PREFIX
-				    "Disable memory device\n");
+		if (acpi_memory_disable_device(mem_device)) {
+			printk(KERN_ERR PREFIX "Disable memory device\n");
+			/*
+			 * If _EJ0 was called but failed, _OST is not
+			 * necessary.
+			 */
+			if (mem_device->state == MEMORY_INVALID_STATE)
+				return;
+
+			break;
+		}
+
 		/*
 		 * TBD: Invoke acpi_bus_remove to cleanup data structures
 		 */
-		break;
+
+		/* _EJ0 succeeded; _OST is not necessary */
+		return;
+
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Unsupported event [0x%x]\n", event));
-		break;
+
+		/* non-hotplug event; possibly handled by other handler */
+		return;
 	}
 
+	/* Inform firmware that the hotplug operation has completed */
+	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
 	return;
 }
 
-- 
1.7.7.6

