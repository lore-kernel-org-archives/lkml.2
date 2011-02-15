Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1BOPHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:07:32 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55520
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753001Ab1BOPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:07:30 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Date: Tue, 15 Feb 2011 07:15:37 -0800
Message-Id: <1297782937-24082-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/vmbus_drv.c |   49 +++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 459c707..f279e6a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -36,9 +36,7 @@
 #include "vmbus_private.h"
 
 
-/* FIXME! We need to do this dynamically for PIC and APIC system */
-#define VMBUS_IRQ		0x5
-#define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
+static int vmbus_irq;
 
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
@@ -57,6 +55,25 @@ struct vmbus_driver_context {
 	struct vm_device device_ctx;
 };
 
+/*
+ * Find an un-used IRQ that the VMBUS can use. If none is available; return -1.
+ */
+
+static int vmbus_get_irq(void)
+{
+	unsigned int avail_irq_mask;
+	int irq = -1;
+	/*
+	 * Pick the first unused interrupt. HyperV can
+	 * interrupt us on any interrupt line we specify.
+	 */
+	avail_irq_mask = probe_irq_on();
+	if (avail_irq_mask != 0)
+		irq = ffs(avail_irq_mask);
+	probe_irq_off(avail_irq_mask);
+	return irq;
+}
+
 static int vmbus_match(struct device *device, struct device_driver *driver);
 static int vmbus_probe(struct device *device);
 static int vmbus_remove(struct device *device);
@@ -80,7 +97,6 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
-static int vmbus_irq = VMBUS_IRQ;
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
@@ -466,7 +482,7 @@ static int vmbus_bus_init(void)
 	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
-	unsigned int vector;
+	unsigned int vector, prev_irq = ~0;
 
 	DPRINT_INFO(VMBUS, "+++++++ HV Driver version = %s +++++++",
 		    HV_DRV_VERSION);
@@ -518,19 +534,23 @@ static int vmbus_bus_init(void)
 	}
 
 	/* Get the interrupt resource */
-	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
-			  driver->name, NULL);
-
-	if (ret != 0) {
-		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
-			   vmbus_irq);
-
+get_irq_again:
+	vmbus_irq = vmbus_get_irq();
+	if ((vmbus_irq < 0) || (prev_irq == vmbus_irq)) {
+		printk(KERN_WARNING "VMBUS_DRV: Failed to allocate IRQ\n");
 		bus_unregister(&vmbus_drv_ctx->bus);
-
 		ret = -1;
 		goto cleanup;
 	}
-	vector = VMBUS_IRQ_VECTOR;
+	prev_irq = vmbus_irq;
+
+	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
+			  driver->name, NULL);
+
+	if (ret != 0)
+		goto get_irq_again;
+
+	vector = IRQ0_VECTOR + vmbus_irq;
 
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
@@ -1117,7 +1137,6 @@ MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
-module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);
 
 module_init(vmbus_init);
-- 
1.5.5.6

