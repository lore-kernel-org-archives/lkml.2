Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1CJWfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:35:21 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45217
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751606Ab1CJWfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:35:20 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/21] [PATCH 13/21] Staging: hv: Rename vmbus_driver_context structure
Date: Thu, 10 Mar 2011 14:12:11 -0800
Message-Id: <1299795131-1335-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that struct vmbus_driver_context is properly
cleaned up, rename this structure appropriately and
cleanup the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4e45016..7b9a2c8 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -44,12 +44,10 @@ static struct device *root_dev; /* Root device */
 struct pci_dev *hv_pci_dev;
 
 /* Main vmbus driver data structure */
-struct vmbus_driver_context {
-
+struct hv_bus {
 	struct bus_type bus;
 	struct tasklet_struct msg_dpc;
 	struct tasklet_struct event_dpc;
-
 };
 
 static int vmbus_match(struct device *device, struct device_driver *driver);
@@ -104,7 +102,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 };
 
 /* The one and only one */
-static struct vmbus_driver_context vmbus_drv = {
+static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
 	.bus.match =		vmbus_match,
 	.bus.shutdown =		vmbus_shutdown,
@@ -374,7 +372,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  */
 static int vmbus_bus_init(struct pci_dev *pdev)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 	int ret;
 	unsigned int vector;
 
@@ -399,16 +396,16 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	}
 
 
-	vmbus_drv_ctx->bus.name = driver_name;
+	hv_bus.bus.name = driver_name;
 
 	/* Initialize the bus context */
-	tasklet_init(&vmbus_drv_ctx->msg_dpc, vmbus_on_msg_dpc,
+	tasklet_init(&hv_bus.msg_dpc, vmbus_on_msg_dpc,
 		     (unsigned long)NULL);
-	tasklet_init(&vmbus_drv_ctx->event_dpc, vmbus_on_event,
+	tasklet_init(&hv_bus.event_dpc, vmbus_on_event,
 		     (unsigned long)NULL);
 
 	/* Now, register the bus  with LDM */
-	ret = bus_register(&vmbus_drv_ctx->bus);
+	ret = bus_register(&hv_bus.bus);
 	if (ret) {
 		ret = -1;
 		goto cleanup;
@@ -423,7 +420,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
 			   pdev->irq);
 
-		bus_unregister(&vmbus_drv_ctx->bus);
+		bus_unregister(&hv_bus.bus);
 
 		ret = -1;
 		goto cleanup;
@@ -441,7 +438,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 			   "ERROR - Unable to register vmbus root device");
 
 		free_irq(pdev->irq, pdev);
-		bus_unregister(&vmbus_drv_ctx->bus);
+		bus_unregister(&hv_bus.bus);
 
 		ret = PTR_ERR(root_dev);
 		goto cleanup;
@@ -456,7 +453,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	if (ret) {
 		root_device_unregister(root_dev);
 		free_irq(pdev->irq, pdev);
-		bus_unregister(&vmbus_drv_ctx->bus);
+		bus_unregister(&hv_bus.bus);
 		goto cleanup;
 	}
 
@@ -475,7 +472,6 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
 
 	vmbus_release_unattached_channels();
@@ -487,12 +483,12 @@ static void vmbus_bus_exit(void)
 	/* Unregister the root bus device */
 	root_device_unregister(root_dev);
 
-	bus_unregister(&vmbus_drv_ctx->bus);
+	bus_unregister(&hv_bus.bus);
 
 	free_irq(hv_pci_dev->irq, hv_pci_dev);
 
-	tasklet_kill(&vmbus_drv_ctx->msg_dpc);
-	tasklet_kill(&vmbus_drv_ctx->event_dpc);
+	tasklet_kill(&hv_bus.msg_dpc);
+	tasklet_kill(&hv_bus.event_dpc);
 }
 
 
@@ -515,7 +511,7 @@ int vmbus_child_driver_register(struct device_driver *drv)
 		    drv, drv->name);
 
 	/* The child driver on this vmbus */
-	drv->bus = &vmbus_drv.bus;
+	drv->bus = &hv_bus.bus;
 
 	ret = driver_register(drv);
 
@@ -609,7 +605,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_obj->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
+	child_device_obj->device.bus = &hv_bus.bus; /* device->dev.bus; */
 	child_device_obj->device.parent = root_dev;
 	child_device_obj->device.release = vmbus_device_release;
 
@@ -877,10 +873,10 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	/* Schedules a dpc if necessary */
 	if (ret > 0) {
 		if (test_bit(0, (unsigned long *)&ret))
-			tasklet_schedule(&vmbus_drv.msg_dpc);
+			tasklet_schedule(&hv_bus.msg_dpc);
 
 		if (test_bit(1, (unsigned long *)&ret))
-			tasklet_schedule(&vmbus_drv.event_dpc);
+			tasklet_schedule(&hv_bus.event_dpc);
 
 		return IRQ_HANDLED;
 	} else {
-- 
1.5.5.6

