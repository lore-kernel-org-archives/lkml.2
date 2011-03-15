Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1COWSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:18:32 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:43429
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752539Ab1COWSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:18:23 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 03/12] Staging: hv: Cleanup irq management
Date: Tue, 15 Mar 2011 15:03:34 -0700
Message-Id: <1300226624-27004-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-2-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that vmbus_driver is a  pci driver,
cleanup the irq allocation mess by using the standard
irq allocation mechanisms.

Note that this patch generates an error when the checkpatch
script is run because of the IRQF_SAMPLE_RANDOM flag used in
request_irq() function. This interrupt may be the only
external event this VM will get and consequently if this
flag (IRQF_SAMPLE_RANDOM) is not  specified, experimentally
we have shown that the entropy in the VM will very very low.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 3d2789b..239b91c 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -17,6 +17,8 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *
+ * 3/9/2011: K. Y. Srinivasan	- Significant restructuring and cleanup
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -36,10 +38,6 @@
 #include "vmbus_private.h"
 
 
-/* FIXME! We need to do this dynamically for PIC and APIC system */
-#define VMBUS_IRQ		0x5
-#define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
-
 struct pci_dev *hv_pci_dev;
 
 /* Main vmbus driver data structure */
@@ -69,7 +67,6 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
-static int vmbus_irq = VMBUS_IRQ;
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
@@ -369,7 +366,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  *	- get the irq resource
  *	- retrieve the channel offers
  */
-static int vmbus_bus_init(void)
+static int vmbus_bus_init(struct pci_dev *pdev)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 	int ret;
@@ -412,21 +409,23 @@ static int vmbus_bus_init(void)
 	}
 
 	/* Get the interrupt resource */
-	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
-			  driver_name, NULL);
+	ret = request_irq(pdev->irq, vmbus_isr,
+			  IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			  driver_name, pdev);
 
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
-			   vmbus_irq);
+			   pdev->irq);
 
 		bus_unregister(&vmbus_drv_ctx->bus);
 
 		ret = -1;
 		goto cleanup;
 	}
-	vector = VMBUS_IRQ_VECTOR;
 
-	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
+	vector = IRQ0_VECTOR + pdev->irq;
+	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", pdev->irq,
+			vector);
 
 	/*
 	 * Notify the hypervisor of our irq and
@@ -435,7 +434,7 @@ static int vmbus_bus_init(void)
 	on_each_cpu(hv_synic_init, (void *)&vector, 1);
 	ret = vmbus_connect();
 	if (ret) {
-		free_irq(vmbus_irq, NULL);
+		free_irq(pdev->irq, pdev);
 		bus_unregister(&vmbus_drv_ctx->bus);
 		goto cleanup;
 	}
@@ -466,7 +465,7 @@ static void vmbus_bus_exit(void)
 
 	bus_unregister(&vmbus_drv_ctx->bus);
 
-	free_irq(vmbus_irq, NULL);
+	free_irq(hv_pci_dev->irq, hv_pci_dev);
 
 	tasklet_kill(&vmbus_drv_ctx->msg_dpc);
 	tasklet_kill(&vmbus_drv_ctx->event_dpc);
@@ -878,7 +877,7 @@ static int __devinit hv_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	err = vmbus_bus_init();
+	err = vmbus_bus_init(pdev);
 	if (err)
 		pci_disable_device(pdev);
 
@@ -918,7 +917,6 @@ static void __exit hv_pci_exit(void)
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
-module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);
 
 module_init(hv_pci_init);
-- 
1.5.5.6

