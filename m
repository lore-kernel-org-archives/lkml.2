Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab2CJRF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 12:05:57 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59193 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2CJRFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 12:05:53 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Len Brown <lenb@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/acpi/processor_driver.c: add missing kfree
Date: Sat, 10 Mar 2012 18:05:45 +0100
Message-Id: <1331399145-6508-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function acpi_processor_add is stored in the ops.add field of a
acpi_driver structure.  This function is then called in
acpi_bus_driver_init.  On failure, this function clears the field
device->driver_data, but does not free its contents.  Thus the free has to
be done by the add function.  In acpi_processor_add, the corresponding
value is pr.  This value is currently freed on failure before storing it in
device->driver_data, but not after.  This free is added in the error
handling code at the end of the function.  The static global variable
processors is also cleared so that it does not refer to a dangling pointer.
processor_device_array is cleared as well.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is only compile tested.  In particular, I don't know if it is correct
to add per_cpu(processor_device_array, pr->id) = NULL;.  It has nothing to
do with pr, but it looks like stale information in the case of a failure.

 drivers/acpi/processor_driver.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 2801b41..9bb0017 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -536,8 +536,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		return -ENOMEM;
 
 	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
-		kfree(pr);
-		return -ENOMEM;
+		result = -ENOMEM;
+		goto err_free_pr;
 	}
 
 	pr->handle = device->handle;
@@ -577,7 +577,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	dev = get_cpu_device(pr->id);
 	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
 		result = -EFAULT;
-		goto err_free_cpumask;
+		goto err_clear_processors;
 	}
 
 	/*
@@ -595,9 +595,13 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 err_remove_sysfs:
 	sysfs_remove_link(&device->dev.kobj, "sysdev");
+err_clear_processors:
+	per_cpu(processors, pr->id) = NULL;
+	per_cpu(processor_device_array, pr->id) = NULL;
 err_free_cpumask:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
-
+err_free_pr:
+	kfree(pr);
 	return result;
 }
 

