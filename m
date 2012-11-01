Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798Ab2KAOuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:50:20 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8958 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761706Ab2KAOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:50:15 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com, prarit@redhat.com,
        bhelgaas@google.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 2/2] ACPI: Add ACPI CPU hot-remove support
Date: Thu,  1 Nov 2012 08:42:13 -0600
Message-Id: <1351780933-30560-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
References: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support of CPU hot-remove via an ACPI eject notification.
It calls acpi_bus_hot_remove_device(), which shares the same code
path with the sysfs eject operation.  acpi_os_hotplug_execute()
runs the hot-remove operation in kacpi_hotplug_wq and serializes
it between ACPI hot-remove and sysfs eject requests.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: IgorMammedov <imammedo@redhat.com>
Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/acpi/processor_driver.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index bd4e5dc..ac63b6f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -695,8 +695,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
 static void acpi_processor_hotplug_notify(acpi_handle handle,
 					  u32 event, void *data)
 {
-	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
+	struct acpi_eject_event *ej_event = NULL;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 	int result;
 
@@ -728,20 +728,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
 
 		if (acpi_bus_get_device(handle, &device)) {
-			printk(KERN_ERR PREFIX
-				    "Device don't exist, dropping EJECT\n");
+			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
 			break;
 		}
-		pr = acpi_driver_data(device);
-		if (!pr) {
-			printk(KERN_ERR PREFIX
-				    "Driver data is NULL, dropping EJECT\n");
+		if (!acpi_driver_data(device)) {
+			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
 			break;
 		}
 
-		/* REVISIT: update when eject is supported */
-		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-		break;
+		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+		if (!ej_event) {
+			pr_err(PREFIX "No memory, dropping EJECT\n");
+			break;
+		}
+
+		ej_event->handle = handle;
+		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
+		acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
+					(void *)ej_event);
+
+		/* eject is performed asynchronously */
+		return;
 
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-- 
1.7.11.7

