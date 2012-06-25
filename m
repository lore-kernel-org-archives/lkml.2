Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2FYREU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:04:20 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:31546 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2FYRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:04:18 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        andi@firstfloor.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 3/6] ACPI: Add _OST support for ACPI CPU hotplug
Date: Mon, 25 Jun 2012 10:59:30 -0600
Message-Id: <1340643573-28299-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
References: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed acpi_processor_hotplug_notify() to call ACPI _OST method
when ACPI CPU hotplug operation has completed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/processor_driver.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 0734086..971c454 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -701,9 +701,9 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 {
 	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 	int result;
 
-
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
@@ -715,14 +715,18 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 		if (!is_processor_present(handle))
 			break;
 
-		if (acpi_bus_get_device(handle, &device)) {
-			result = acpi_processor_device_add(handle, &device);
-			if (result)
-				printk(KERN_ERR PREFIX
-					    "Unable to add the device\n");
+		if (!acpi_bus_get_device(handle, &device))
+			break;
+
+		result = acpi_processor_device_add(handle, &device);
+		if (result) {
+			printk(KERN_ERR PREFIX "Unable to add the device\n");
 			break;
 		}
+
+		ost_code = ACPI_OST_SC_SUCCESS;
 		break;
+
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
@@ -736,15 +740,23 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 		if (!pr) {
 			printk(KERN_ERR PREFIX
 				    "Driver data is NULL, dropping EJECT\n");
-			return;
+			break;
 		}
+
+		/* REVISIT: update when eject is supported */
+		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
 		break;
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

