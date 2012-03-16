Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032579Ab2CPKC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:02:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56423 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab2CPKCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:02:23 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Len Brown <lenb@kernel.org>, srivatsa.bhat@linux.vnet.ibm.com,
        deepthi@linux.vnet.ibm.com, venki@google.com, trenn@suse.de,
        bhelgaas@google.com
Cc: kernel-janitors@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/acpi/processor_driver.c: add missing kfree
Date: Fri, 16 Mar 2012 11:02:16 +0100
Message-Id: <1331892136-4790-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The function acpi_processor_add is stored in the ops.add field of a
acpi_driver structure.  This function is then called in
acpi_bus_driver_init.  On failure, this function clears the field
device->driver_data, but does not free its contents.  Thus the free has to
be done by the add function.  In acpi_processor_add, the corresponding
value is pr.  This value is currently freed on failure before storing it in
device->driver_data, but not after.  This free is added in the error
handling code at the end of the function.  The per_cpu variable
processors is also cleared so that it does not refer to a dangling pointer.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2: Adjusted the comment format

 drivers/acpi/processor_driver.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 2801b41..c5ce91c 100644
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
+		goto err_clear_processor;
 	}
 
 	/*
@@ -595,9 +595,16 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 err_remove_sysfs:
 	sysfs_remove_link(&device->dev.kobj, "sysdev");
+err_clear_processor:
+	/*
+	 * processor_device_array is not cleared to allow checks for buggy
+	 *  BIOSes
+	 */
+	per_cpu(processors, pr->id) = NULL;
 err_free_cpumask:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
-
+err_free_pr:
+	kfree(pr);
 	return result;
 }
 
