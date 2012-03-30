Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860Ab2C3LSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:18:39 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189Ab2C3LSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 65/76] ACPI: processor_driver: add missing kfree
Date: Fri, 30 Mar 2012 06:14:08 -0400
Message-id: <c80f5b31f3c55a197f5323b93d1e3553429a427e.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
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
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_driver.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8ae05ce..fce0066 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -535,8 +535,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		return -ENOMEM;
 
 	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
-		kfree(pr);
-		return -ENOMEM;
+		result = -ENOMEM;
+		goto err_free_pr;
 	}
 
 	pr->handle = device->handle;
@@ -576,7 +576,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 	dev = get_cpu_device(pr->id);
 	if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
 		result = -EFAULT;
-		goto err_free_cpumask;
+		goto err_clear_processor;
 	}
 
 	/*
@@ -594,9 +594,15 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 
 err_remove_sysfs:
 	sysfs_remove_link(&device->dev.kobj, "sysdev");
+err_clear_processor:
+	/*
+	 * processor_device_array is not cleared to allow checks for buggy BIOS
+	 */ 
+	per_cpu(processors, pr->id) = NULL;
 err_free_cpumask:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
-
+err_free_pr:
+	kfree(pr);
 	return result;
 }
 
-- 
1.7.10.rc2.19.gfae9d

