Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2KTUxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:53:38 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:27962 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2KTUxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:53:36 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v6 2/5] ACPI: Update CPU hotplug error messages
Date: Tue, 20 Nov 2012 13:44:51 -0700
Message-Id: <1353444294-25575-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated CPU hotplug error messages with acpi_handle_<level>(),
dev_<level>() and pr_<level>().  Modified some messages for
clarity.  Added error status / id info to the messages where
needed.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/acpi/processor_driver.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8cc33d0..e83311b 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -44,6 +44,7 @@
 #include <linux/moduleparam.h>
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 
 #include <asm/io.h>
 #include <asm/cpu.h>
@@ -282,7 +283,9 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		/* Declared with "Processor" statement; match ProcessorID */
 		status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
 		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX "Evaluating processor object\n");
+			dev_err(&device->dev,
+				"Failed to evaluate processor object (0x%x)\n",
+				status);
 			return -ENODEV;
 		}
 
@@ -301,8 +304,9 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
 						NULL, &value);
 		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX
-			    "Evaluating processor _UID [%#x]\n", status);
+			dev_err(&device->dev,
+				"Failed to evaluate processor _UID (0x%x)\n",
+				status);
 			return -ENODEV;
 		}
 		device_declaration = 1;
@@ -345,7 +349,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	if (!object.processor.pblk_address)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
 	else if (object.processor.pblk_length != 6)
-		printk(KERN_ERR PREFIX "Invalid PBLK length [%d]\n",
+		dev_err(&device->dev, "Invalid PBLK length [%d]\n",
 			    object.processor.pblk_length);
 	else {
 		pr->throttling.address = object.processor.pblk_address;
@@ -430,8 +434,8 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 		 * Initialize missing things
 		 */
 		if (pr->flags.need_hotplug_init) {
-			printk(KERN_INFO "Will online and init hotplugged "
-			       "CPU: %d\n", pr->id);
+			pr_info("Will online and init hotplugged CPU: %d\n",
+				pr->id);
 			WARN(acpi_processor_start(pr), "Failed to start CPU:"
 				" %d\n", pr->id);
 			pr->flags.need_hotplug_init = 0;
@@ -492,14 +496,16 @@ static __ref int acpi_processor_start(struct acpi_processor *pr)
 				   &pr->cdev->device.kobj,
 				   "thermal_cooling");
 	if (result) {
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		dev_err(&device->dev,
+			"Failed to create sysfs link 'thermal_cooling'\n");
 		goto err_thermal_unregister;
 	}
 	result = sysfs_create_link(&pr->cdev->device.kobj,
 				   &device->dev.kobj,
 				   "device");
 	if (result) {
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		dev_err(&pr->cdev->device,
+			"Failed to create sysfs link 'device'\n");
 		goto err_remove_sysfs_thermal;
 	}
 
@@ -561,8 +567,9 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	 */
 	if (per_cpu(processor_device_array, pr->id) != NULL &&
 	    per_cpu(processor_device_array, pr->id) != device) {
-		printk(KERN_WARNING "BIOS reported wrong ACPI id "
-			"for the processor\n");
+		dev_warn(&device->dev,
+			"BIOS reported wrong ACPI id %d for the processor\n",
+			pr->id);
 		result = -ENODEV;
 		goto err_free_cpumask;
 	}
@@ -716,7 +723,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 
 		result = acpi_processor_device_add(handle, &device);
 		if (result) {
-			printk(KERN_ERR PREFIX "Unable to add the device\n");
+			acpi_handle_err(handle, "Unable to add the device\n");
 			break;
 		}
 
@@ -728,17 +735,19 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
 				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));
 
 		if (acpi_bus_get_device(handle, &device)) {
-			pr_err(PREFIX "Device don't exist, dropping EJECT\n");
+			acpi_handle_err(handle,
+				"Device don't exist, dropping EJECT\n");
 			break;
 		}
 		if (!acpi_driver_data(device)) {
-			pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
+			acpi_handle_err(handle,
+				"Driver data is NULL, dropping EJECT\n");
 			break;
 		}
 
 		ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
 		if (!ej_event) {
-			pr_err(PREFIX "No memory, dropping EJECT\n");
+			acpi_handle_err(handle, "No memory, dropping EJECT\n");
 			break;
 		}
 
@@ -848,7 +857,7 @@ static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
 	 * and do it when the CPU gets online the first time
 	 * TBD: Cleanup above functions and try to do this more elegant.
 	 */
-	printk(KERN_INFO "CPU %d got hotplugged\n", pr->id);
+	pr_info("CPU %d got hotplugged\n", pr->id);
 	pr->flags.need_hotplug_init = 1;
 
 	return AE_OK;
-- 
1.7.11.7

