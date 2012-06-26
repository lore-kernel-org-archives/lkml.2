Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2FZUrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:47:11 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:46386 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2FZUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:47:08 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        andi@firstfloor.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v6 5/6] ACPI: Add _OST support for ACPI container hotplug
Date: Tue, 26 Jun 2012 14:42:53 -0600
Message-Id: <1340743374-18535-6-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340743374-18535-1-git-send-email-toshi.kani@hp.com>
References: <1340743374-18535-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed container_notify_cb() to call ACPI _OST method when ACPI
container hotplug operation has completed. Slightly restructured
the code with the same logic except that the hot-add case will
fail a request whenever device is set. This makes the error check
to be more comprehensive.

The function sets eject_pending bit for an eject request since it
does not initiate hot-remove operation. This bit is checked by the
sysfs eject handler to determine if the request is originated from
an ACPI eject notification.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/container.c |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 45cd03b..01a986d 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -158,9 +158,7 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 	int result;
 	int present;
 	acpi_status status;
-
-
-	present = is_device_present(handle);
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
@@ -169,32 +167,47 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
 		printk(KERN_WARNING "Container driver received %s event\n",
 		       (type == ACPI_NOTIFY_BUS_CHECK) ?
 		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
+
+		present = is_device_present(handle);
 		status = acpi_bus_get_device(handle, &device);
-		if (present) {
-			if (ACPI_FAILURE(status) || !device) {
-				result = container_device_add(&device, handle);
-				if (!result)
-					kobject_uevent(&device->dev.kobj,
-						       KOBJ_ONLINE);
-				else
-					printk(KERN_WARNING
-					       "Failed to add container\n");
-			}
-		} else {
+		if (!present) {
 			if (ACPI_SUCCESS(status)) {
 				/* device exist and this is a remove request */
+				device->flags.eject_pending = 1;
 				kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
+				return;
 			}
+			break;
+		}
+
+		if (!ACPI_FAILURE(status) || device)
+			break;
+
+		result = container_device_add(&device, handle);
+		if (result) {
+			pr_warn("Failed to add container\n");
+			break;
 		}
+
+		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
+		ost_code = ACPI_OST_SC_SUCCESS;
 		break;
+
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		if (!acpi_bus_get_device(handle, &device) && device) {
+			device->flags.eject_pending = 1;
 			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
+			return;
 		}
 		break;
+
 	default:
-		break;
+		/* non-hotplug event; possibly handled by other handler */
+		return;
 	}
+
+	/* Inform firmware that the hotplug operation has completed */
+	(void) acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 	return;
 }
 
-- 
1.7.7.6

