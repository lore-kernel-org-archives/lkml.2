Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2KFPLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:11:03 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46345 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2KFPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:10:21 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        imammedo@redhat.com, prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 RESEND 3/5] ACPI: Update Memory hotplug error messages
Date: Tue,  6 Nov 2012 08:02:08 -0700
Message-Id: <1352214130-12055-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated Memory hotplug error messages with acpi_pr_<level>(),
dev_<level>() and pr_<level>().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_memhotplug.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 92c973a..d00de4b 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -178,7 +178,7 @@ acpi_memory_get_device(acpi_handle handle,
 	/* Get the parent device */
 	result = acpi_bus_get_device(phandle, &pdevice);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot get acpi bus device");
+		acpi_pr_warn(phandle, "Cannot get acpi bus device\n");
 		return -EINVAL;
 	}
 
@@ -188,14 +188,14 @@ acpi_memory_get_device(acpi_handle handle,
 	 */
 	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
 	if (result) {
-		printk(KERN_WARNING PREFIX "Cannot add acpi bus");
+		acpi_pr_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;
 	}
 
       end:
 	*mem_device = acpi_driver_data(device);
 	if (!(*mem_device)) {
-		printk(KERN_ERR "\n driver data not found");
+		dev_err(&device->dev, "driver data not found\n");
 		return -ENODEV;
 	}
 
@@ -232,7 +232,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 	/* Get the range from the _CRS */
 	result = acpi_memory_get_device_resources(mem_device);
 	if (result) {
-		printk(KERN_ERR PREFIX "get_device_resources failed\n");
+		dev_err(&mem_device->device->dev,
+			"get_device_resources failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return result;
 	}
@@ -267,7 +268,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 	}
 	mutex_unlock(&mem_device->list_lock);
 	if (!num_enabled) {
-		printk(KERN_ERR PREFIX "add_memory failed\n");
+		dev_err(&mem_device->device->dev, "add_memory failed\n");
 		mem_device->state = MEMORY_INVALID_STATE;
 		return -EINVAL;
 	}
@@ -377,7 +378,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					  "\nReceived DEVICE CHECK notification for device\n"));
 		if (acpi_memory_get_device(handle, &mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot find driver data\n");
+			acpi_pr_err(handle, "Cannot find driver data\n");
 			break;
 		}
 
@@ -385,7 +386,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 			break;
 
 		if (acpi_memory_enable_device(mem_device)) {
-			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
+			acpi_pr_err(handle, "Cannot enable memory device\n");
 			break;
 		}
 
@@ -397,12 +398,12 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 				  "\nReceived EJECT REQUEST notification for device\n"));
 
 		if (acpi_bus_get_device(handle, &device)) {
-			printk(KERN_ERR PREFIX "Device doesn't exist\n");
+			acpi_pr_err(handle, "Device doesn't exist\n");
 			break;
 		}
 		mem_device = acpi_driver_data(device);
 		if (!mem_device) {
-			printk(KERN_ERR PREFIX "Driver Data is NULL\n");
+			acpi_pr_err(handle, "Driver Data is NULL\n");
 			break;
 		}
 
@@ -413,7 +414,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 		 *      with generic sysfs driver
 		 */
 		if (acpi_memory_disable_device(mem_device)) {
-			printk(KERN_ERR PREFIX "Disable memory device\n");
+			acpi_pr_err(handle, "Failed to remove memory device\n");
 			/*
 			 * If _EJ0 was called but failed, _OST is not
 			 * necessary.
@@ -475,7 +476,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	/* Set the device state */
 	mem_device->state = MEMORY_POWER_ON_STATE;
 
-	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
+	pr_debug("%s\n", acpi_device_name(device));
 
 	/*
 	 * Early boot code has recognized memory area by EFI/E820.
@@ -490,7 +491,7 @@ static int acpi_memory_device_add(struct acpi_device *device)
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
 		if (result)
-			printk(KERN_ERR PREFIX
+			dev_err(&device->dev,
 				"Error in acpi_memory_enable_device\n");
 	}
 	return result;
-- 
1.7.11.7

