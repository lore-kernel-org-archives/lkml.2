Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1COVy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:54:28 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53210
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758129Ab1COVxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 04/12] Staging: hv: Rename vmbus_driver_context structure
Date: Tue, 15 Mar 2011 15:03:35 -0700
Message-Id: <1300226624-27004-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-3-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/vmbus_drv.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 239b91c..f292b03 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -41,7 +41,7 @@
 struct pci_dev *hv_pci_dev;
 
 /* Main vmbus driver data structure */
-struct vmbus_driver_context {
+struct hv_bus {
 	struct bus_type bus;
 	struct tasklet_struct msg_dpc;
 	struct tasklet_struct event_dpc;
@@ -99,7 +99,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 };
 
 /* The one and only one */
-static struct vmbus_driver_context vmbus_drv = {
+static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
 	.bus.match =		vmbus_match,
 	.bus.shutdown =		vmbus_shutdown,
@@ -368,7 +368,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  */
 static int vmbus_bus_init(struct pci_dev *pdev)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 	int ret;
 	unsigned int vector;
 
@@ -393,16 +392,16 @@ static int vmbus_bus_init(struct pci_dev *pdev)
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
@@ -417,7 +416,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
 			   pdev->irq);
 
-		bus_unregister(&vmbus_drv_ctx->bus);
+		bus_unregister(&hv_bus.bus);
 
 		ret = -1;
 		goto cleanup;
@@ -435,7 +434,7 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	ret = vmbus_connect();
 	if (ret) {
 		free_irq(pdev->irq, pdev);
-		bus_unregister(&vmbus_drv_ctx->bus);
+		bus_unregister(&hv_bus.bus);
 		goto cleanup;
 	}
 
@@ -454,7 +453,6 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
 
 	vmbus_release_unattached_channels();
@@ -463,12 +461,12 @@ static void vmbus_bus_exit(void)
 
 	hv_cleanup();
 
-	bus_unregister(&vmbus_drv_ctx->bus);
+	bus_unregister(&hv_bus.bus);
 
 	free_irq(hv_pci_dev->irq, hv_pci_dev);
 
-	tasklet_kill(&vmbus_drv_ctx->msg_dpc);
-	tasklet_kill(&vmbus_drv_ctx->event_dpc);
+	tasklet_kill(&hv_bus.msg_dpc);
+	tasklet_kill(&hv_bus.event_dpc);
 }
 
 
@@ -491,7 +489,7 @@ int vmbus_child_driver_register(struct device_driver *drv)
 		    drv, drv->name);
 
 	/* The child driver on this vmbus */
-	drv->bus = &vmbus_drv.bus;
+	drv->bus = &hv_bus.bus;
 
 	ret = driver_register(drv);
 
@@ -585,7 +583,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_obj->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
+	child_device_obj->device.bus = &hv_bus.bus; /* device->dev.bus; */
 	child_device_obj->device.parent = &hv_pci_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
@@ -853,10 +851,10 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
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

