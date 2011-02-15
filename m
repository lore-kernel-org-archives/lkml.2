Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1BOTrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:47:32 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49189
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755216Ab1BOTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:47:30 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Date: Tue, 15 Feb 2011 11:55:35 -0800
Message-Id: <1297799735-25917-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/vmbus_drv.c |   72 +++++++++++++++++++++++++++++++---------
 1 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 459c707..441ce85 100644
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
@@ -57,6 +55,27 @@ struct vmbus_driver_context {
 	struct vm_device device_ctx;
 };
 
+/*
+ * Find an un-used IRQ that the VMBUS can use. If none is available;
+ * return -EBUSY.
+ */
+static int vmbus_get_irq(void)
+{
+	unsigned int avail_irq_mask;
+	int irq = -EBUSY;
+
+	/*
+	 * Pick the first unused interrupt. HyperV can
+	 * interrupt us on any interrupt line we specify.
+	 */
+
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
@@ -80,7 +99,6 @@ EXPORT_SYMBOL(vmbus_loglevel);
 	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
 	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
-static int vmbus_irq = VMBUS_IRQ;
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
@@ -467,6 +485,7 @@ static int vmbus_bus_init(void)
 	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
 	unsigned int vector;
+	bool irq_assigned = false;
 
 	DPRINT_INFO(VMBUS, "+++++++ HV Driver version = %s +++++++",
 		    HV_DRV_VERSION);
@@ -517,20 +536,42 @@ static int vmbus_bus_init(void)
 		goto cleanup;
 	}
 
-	/* Get the interrupt resource */
-	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
-			  driver->name, NULL);
-
-	if (ret != 0) {
-		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
-			   vmbus_irq);
+	/*
+	 * Get an unused interrupt line and register our handler.
+	 * Since there is a window between getting an unused
+	 * interrupt line and registering our handler, we close
+	 * this window by repeating the sequence if we raced.
+	 * This loop will terminate under the following conditions:
+	 *
+	 * 1) If we succeed in registering our handler OR
+	 * 2) If there are no free interrupt lines for our use OR
+	 * 3) request_irq fails for reasons other than an irq collision
+	 */
+	while (!irq_assigned) {
+		vmbus_irq = vmbus_get_irq();
 
-		bus_unregister(&vmbus_drv_ctx->bus);
+		if (vmbus_irq < 0) {
+			bus_unregister(&vmbus_drv_ctx->bus);
+			ret = -EBUSY;
+			goto cleanup;
+		}
 
-		ret = -1;
-		goto cleanup;
+		ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
+			  driver->name, NULL);
+		switch (ret) {
+		case -EBUSY:
+			 /* We raced and lost; try again.*/
+			continue;
+		case 0:
+			irq_assigned = true;
+			break;
+		default:
+			/* Failed to request_irq; cleanup */
+			goto cleanup;
+		}
 	}
-	vector = VMBUS_IRQ_VECTOR;
+
+	vector = IRQ0_VECTOR + vmbus_irq;
 
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
@@ -1117,7 +1158,6 @@ MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
-module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);
 
 module_init(vmbus_init);
-- 
1.5.5.6

