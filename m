Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1FFWou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:44:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39407
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758166Ab1FFWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 15/49] Staging: hv: vmbus: Make vmbus an acpi bus driver
Date: Mon,  6 Jun 2011 15:49:39 -0700
Message-Id: <1307400613-13234-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, make the vmbus driver an ACPI bus driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   56 ++++++---------------------------------
 1 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 5d7ecfd..176a8cd 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -39,7 +39,7 @@
 #include "hyperv_vmbus.h"
 
 
-static struct pci_dev *hv_pci_dev;
+static struct acpi_device  *hv_acpi_dev;
 
 static struct tasklet_struct msg_dpc;
 static struct tasklet_struct event_dpc;
@@ -49,7 +49,6 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
-static int pci_probe_error;
 static struct completion probe_event;
 static int irq;
 
@@ -553,7 +552,7 @@ static int vmbus_bus_init(int irq)
 
 	/* Get the interrupt resource */
 	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
-			driver_name, hv_pci_dev);
+			driver_name, hv_acpi_dev);
 
 	if (ret != 0) {
 		pr_err("Unable to request IRQ %d\n",
@@ -574,7 +573,7 @@ static int vmbus_bus_init(int irq)
 	on_each_cpu(hv_synic_init, (void *)&vector, 1);
 	ret = vmbus_connect();
 	if (ret) {
-		free_irq(irq, hv_pci_dev);
+		free_irq(irq, hv_acpi_dev);
 		bus_unregister(&hv_bus);
 		goto cleanup;
 	}
@@ -674,7 +673,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 
 	/* The new device belongs to this bus */
 	child_device_obj->device.bus = &hv_bus; /* device->dev.bus; */
-	child_device_obj->device.parent = &hv_pci_dev->dev;
+	child_device_obj->device.parent = &hv_acpi_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
 	/*
@@ -731,6 +730,8 @@ static int vmbus_acpi_add(struct acpi_device *device)
 {
 	acpi_status result;
 
+	hv_acpi_dev = device;
+
 	result =
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS,
 			vmbus_walk_resources, &irq);
@@ -777,25 +778,6 @@ static void vmbus_acpi_exit(void)
 }
 
 
-static int __devinit hv_pci_probe(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
-{
-	hv_pci_dev = pdev;
-
-	pci_probe_error = pci_enable_device(pdev);
-	if (pci_probe_error)
-		goto probe_cleanup;
-
-	pci_probe_error = vmbus_bus_init(irq);
-
-	if (pci_probe_error)
-		pci_disable_device(pdev);
-
-probe_cleanup:
-	complete(&probe_event);
-	return pci_probe_error;
-}
-
 /*
  * We use a PCI table to determine if we should autoload this driver  This is
  * needed by distro tools to determine if the hyperv drivers should be
@@ -808,13 +790,7 @@ static const struct pci_device_id microsoft_hv_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
 
-static struct pci_driver hv_bus_driver = {
-	.name =           "hv_bus",
-	.probe =          hv_pci_probe,
-	.id_table =       microsoft_hv_pci_table,
-};
-
-static int __init hv_pci_init(void)
+static int __init hv_acpi_init(void)
 {
 	int ret;
 
@@ -835,21 +811,7 @@ static int __init hv_pci_init(void)
 		return -ENODEV;
 	}
 
-	vmbus_acpi_exit();
-	init_completion(&probe_event);
-	ret = pci_register_driver(&hv_bus_driver);
-	if (ret)
-		return ret;
-	/*
-	 * All the vmbus initialization occurs within the
-	 * hv_pci_probe() function. Wait for hv_pci_probe()
-	 * to complete.
-	 */
-	wait_for_completion(&probe_event);
-
-	if (pci_probe_error)
-		pci_unregister_driver(&hv_bus_driver);
-	return pci_probe_error;
+	return vmbus_bus_init(irq);
 }
 
 
@@ -857,4 +819,4 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 module_param(vmbus_loglevel, int, S_IRUGO|S_IWUSR);
 
-module_init(hv_pci_init);
+module_init(hv_acpi_init);
-- 
1.7.4.1

