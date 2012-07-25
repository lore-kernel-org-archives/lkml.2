Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab2GYDmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab2GYDmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:46 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 23/52] ACPI: Add _OST support for ACPI memory hotplug
Date: Tue, 24 Jul 2012 23:41:19 -0400
Message-Id: <b1f00de66f8809b451a33ce47e461ef0e33c09e8.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshi Kani <toshi.kani@hp.com>

Changed acpi_memory_device_notify() to call ACPI _OST method
when ACPI memory hotplug operation has completed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpi_memhotplug.c | 43 +++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

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
1.7.12.rc0

