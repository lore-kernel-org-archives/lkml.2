Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2F2Ovg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:51:36 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32529 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2F2Ovf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:51:35 -0400
From: y@domain.invalid
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Add ACPI CPU hot-remove support
Date: Fri, 29 Jun 2012 08:47:58 -0600
Message-Id: <1340981278-6468-1-git-send-email-y>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshi Kani <toshi.kani@hp.com>

Added CPU hot-remove support through an ACPI eject notification.
It calls acpi_bus_hot_remove_device(), which shares the same code
path with the sysfs eject operation.  acpi_os_hotplug_execute()
serializes hot-remove operations between ACPI hot-remove and sysfs
eject requests.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>

---
This patch applies on top of the patchset below.

[PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
http://marc.info/?l=linux-acpi&m=134074381322973&w=2

---
 drivers/acpi/processor_driver.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index f9fa1b2..a6f6bde 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -699,8 +699,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
 static void acpi_processor_hotplug_notify(acpi_handle handle,
 					  u32 event, void *data)
 {
-	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
+	struct acpi_eject_event *ej_event = NULL;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 	int result;
 
@@ -732,20 +732,27 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
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

