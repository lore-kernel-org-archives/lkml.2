Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2KTXwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:52:01 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:23505 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2KTXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:51:27 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v7 3/5] ACPI: Update Memory hotplug error messages
Date: Tue, 20 Nov 2012 16:42:28 -0700
Message-Id: <1353454950-17010-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353454950-17010-1-git-send-email-toshi.kani@hp.com>
References: <1353454950-17010-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Memory hotplug error messages with acpi_handle_<level>(),
dev_<level>() and pr_<level>().  Added missing "\n".

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index e0f7425..eb30e5a 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -31,6 +31,7 @@
 #include <linux/types.h>
 #include <linux/memory_hotplug.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 #include <acpi/acpi_drivers.h>
 
 #define ACPI_MEMORY_DEVICE_CLASS		"memory"
@@ -175,7 +176,7 @@ acpi_memory_get_device(acpi_handle handle,
 	/* Get the parent device */
 	result = acpi_bus_get_device(phandle, &pdevice);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot get acpi bus device");
+		acpi_handle_warn(phandle, "Cannot get acpi bus device\n");
 		return -EINVAL;
 	}
 
@@ -185,14 +186,14 @@ acpi_memory_get_device(acpi_handle handle,
 	 */
 	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot add acpi bus");
+		acpi_handle_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;
 	}
 
       end:
 	*mem_device = acpi_driver_data(device);
 	if (!(*mem_device)) {
-		printk(KERN_ERR "\n driver data not found");
+		dev_err(&device->dev, "driver data not found\n");
 		return -ENODEV;
 	}
 
@@ -229,7 +230,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
-		printk(KERN_ERR PREFIX "get_device_resources failed\n");
+		dev_err(&mem_device->device->dev,
+			"get_device_resources failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return result;
 	}
@@ -276,7 +278,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 		num_enabled++;
 	}
 	if (!num_enabled) {
-		printk(KERN_ERR PREFIX "add_memory failed\n");
+		dev_err(&mem_device->device->dev, "add_memory failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return -EINVAL;
 	}
@@ -336,7 +338,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "\nReceived DEVICE CHECK notification for device\n"));
 		if (acpi_memory_get_device(handle, &mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot find driver data\n");
+			acpi_handle_err(handle, "Cannot find driver data\n");
 			break;
 		}
 
@@ -344,7 +346,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			break;
 
 		if (acpi_memory_enable_device(mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
+			acpi_handle_err(handle,"Cannot enable memory device\n");
 			break;
 		}
 
@@ -356,12 +358,12 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 				  "\nReceived EJECT REQUEST notification for device\n"));
 
 		if (acpi_bus_get_device(handle, &device)) {
-			printk(KERN_ERR PREFIX "Device doesn't exist\n");
+			acpi_handle_err(handle, "Device doesn't exist\n");
 			break;
 		}
 		mem_device = acpi_driver_data(device);
 		if (!mem_device) {
-			printk(KERN_ERR PREFIX "Driver Data is NULL\n");
+			acpi_handle_err(handle, "Driver Data is NULL\n");
 			break;
 		}
 
@@ -429,13 +431,13 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Set the device state */
 	mem_device->state = MEMORY_POWER_ON_STATE;
 
-	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
+	pr_debug("%s\n", acpi_device_name(device));
 
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
 		if (result) {
-			printk(KERN_ERR PREFIX
+			dev_err(&device->dev,
 				"Error in acpi_memory_enable_device\n");
 			acpi_memory_device_free(mem_device);
 		}
-- 
1.7.11.7

