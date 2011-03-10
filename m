Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1CJVyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:54:18 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33381
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751413Ab1CJVyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:54:17 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/21] Staging: hv: Simplify root device management
Date: Thu, 10 Mar 2011 14:03:51 -0800
Message-Id: <1299794631-863-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of simplifying root device management,
get rid of the hv_driver object from
vmbus_driver_context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   41 ++++++++++-----------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 159dfda..884a4c6 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -42,7 +42,6 @@
 
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
-	struct hv_driver drv_obj;
 
 	struct bus_type bus;
 	struct tasklet_struct msg_dpc;
@@ -458,7 +457,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 static int vmbus_bus_init(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	struct hv_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
 	unsigned int vector;
@@ -474,13 +472,6 @@ static int vmbus_bus_init(void)
 			sizeof(struct vmbus_channel_packet_page_buffer),
 			sizeof(struct vmbus_channel_packet_multipage_buffer));
 
-	driver->name = driver_name;
-	memcpy(&driver->dev_type, &device_type, sizeof(struct hv_guid));
-
-	/* Setup dispatch table */
-	driver->dev_add	= vmbus_dev_add;
-	driver->dev_rm	= vmbus_dev_rm;
-	driver->cleanup	= vmbus_cleanup;
 
 	/* Hypervisor initialization...setup hypercall page..etc */
 	ret = hv_init();
@@ -490,22 +481,16 @@ static int vmbus_bus_init(void)
 		goto cleanup;
 	}
 
-	/* Sanity checks */
-	if (!driver->dev_add) {
-		DPRINT_ERR(VMBUS_DRV, "OnDeviceAdd() routine not set");
-		ret = -1;
-		goto cleanup;
-	}
 
-	vmbus_drv_ctx->bus.name = driver->name;
+	vmbus_drv_ctx->bus.name = driver_name;
 
 	/* Initialize the bus context */
 	tasklet_init(&vmbus_drv_ctx->msg_dpc, vmbus_msg_dpc,
-		     (unsigned long)driver);
+		     (unsigned long)NULL);
 	tasklet_init(&vmbus_drv_ctx->event_dpc, vmbus_event_dpc,
-		     (unsigned long)driver);
+		     (unsigned long)NULL);
 
-	/* Now, register the bus driver with LDM */
+	/* Now, register the bus  with LDM */
 	ret = bus_register(&vmbus_drv_ctx->bus);
 	if (ret) {
 		ret = -1;
@@ -514,7 +499,7 @@ static int vmbus_bus_init(void)
 
 	/* Get the interrupt resource */
 	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
-			  driver->name, NULL);
+			  driver_name, NULL);
 
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
@@ -529,10 +514,10 @@ static int vmbus_bus_init(void)
 
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
-	/* Call to bus driver to add the root device */
+	/* Add the root device */
 	memset(dev_ctx, 0, sizeof(struct hv_device));
 
-	ret = driver->dev_add(dev_ctx, &vector);
+	ret = vmbus_dev_add(dev_ctx, &vector);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to add vmbus root device");
@@ -555,7 +540,7 @@ static int vmbus_bus_init(void)
 	/* Setup the device dispatch table */
 	dev_ctx->device.release = vmbus_bus_release;
 
-	/* Setup the bus as root device */
+	/* register the  root device */
 	ret = device_register(&dev_ctx->device);
 	if (ret) {
 		DPRINT_ERR(VMBUS_DRV,
@@ -582,17 +567,14 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
 	struct hv_device *dev_ctx = &vmbus_drv.device_ctx;
 
 	/* Remove the root device */
-	if (driver->dev_rm)
-		driver->dev_rm(dev_ctx);
+	vmbus_dev_rm(dev_ctx);
 
-	if (driver->cleanup)
-		driver->cleanup(driver);
+	vmbus_cleanup(NULL);
 
 	/* Unregister the root bus device */
 	device_unregister(&dev_ctx->device);
@@ -1026,11 +1008,10 @@ static void vmbus_event_dpc(unsigned long data)
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	int ret;
 
 	/* Call to bus driver to handle interrupt */
-	ret = vmbus_on_isr(driver);
+	ret = vmbus_on_isr(NULL);
 
 	/* Schedules a dpc if necessary */
 	if (ret > 0) {
-- 
1.5.5.6

