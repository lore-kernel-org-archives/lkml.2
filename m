Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030545Ab2HXVAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:00:38 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9755 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030231Ab2HXVAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:00:34 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        prarit@redhat.com, imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2] ACPI: Add ACPI CPU hot-remove support
Date: Fri, 24 Aug 2012 14:54:59 -0600
Message-Id: <1345841699-20067-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CPU hot-remove support through an ACPI eject notification.
It calls acpi_bus_hot_remove_device(), which shares the same code
path with the sysfs eject operation.  acpi_os_hotplug_execute()
serializes hot-remove operations between ACPI hot-remove and sysfs
eject requests.

v2:
 - Rebased to 3.6-rc3.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: IgorMammedov <imammedo@redhat.com>
Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/acpi/processor_driver.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index bfc31cb..d12e9c3 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -694,8 +694,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
 static void acpi_processor_hotplug_notify(acpi_handle handle,
 					  u32 event, void *data)
 {
-	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
+	struct acpi_eject_event *ej_event = NULL;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 	int result;
 
@@ -727,20 +727,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
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
1.7.7.6

