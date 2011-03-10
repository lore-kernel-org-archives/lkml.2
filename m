Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1CJV6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:58:31 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:38884
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753103Ab1CJV63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:58:29 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/21] Staging: hv: Cleanup root device handling
Date: Thu, 10 Mar 2011 14:08:06 -0800
Message-Id: <1299794886-1200-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can complete the cleanup of the root device
management. Use the preferred APIs for creating and
managing the root device. As part of this cleanup get rid
of the root device object from vmbus_driver_context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  126 ++++++----------------------------------
 1 files changed, 18 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b473f46..8b9394a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -19,6 +19,7 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/irq.h>
@@ -40,6 +41,8 @@
 #define VMBUS_IRQ		0x5
 #define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
 
+static struct device *root_dev; /* Root device */
+
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
 
@@ -47,8 +50,6 @@ struct vmbus_driver_context {
 	struct tasklet_struct msg_dpc;
 	struct tasklet_struct event_dpc;
 
-	/* The bus root device */
-	struct hv_device device_ctx;
 };
 
 static int vmbus_match(struct device *device, struct device_driver *driver);
@@ -60,7 +61,6 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env);
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
 static void vmbus_device_release(struct device *device);
-static void vmbus_bus_release(struct device *device);
 
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
@@ -117,54 +117,6 @@ static struct vmbus_driver_context vmbus_drv = {
 
 static const char *driver_name = "hyperv";
 
-/*
- * Windows vmbus does not defined this.
- * We defined this to be consistent with other devices
- */
-/* {c5295816-f63a-4d5f-8d1a-4daf999ca185} */
-static const struct hv_guid device_type = {
-	.data = {
-		0x16, 0x58, 0x29, 0xc5, 0x3a, 0xf6, 0x5f, 0x4d,
-		0x8d, 0x1a, 0x4d, 0xaf, 0x99, 0x9c, 0xa1, 0x85
-	}
-};
-
-/* {ac3760fc-9adf-40aa-9427-a70ed6de95c5} */
-static const struct hv_guid device_id = {
-	.data = {
-		0xfc, 0x60, 0x37, 0xac, 0xdf, 0x9a, 0xaa, 0x40,
-		0x94, 0x27, 0xa7, 0x0e, 0xd6, 0xde, 0x95, 0xc5
-	}
-};
-
-static struct hv_device *vmbus_device; /* vmbus root device */
-
-
-/*
- * vmbus_dev_add - Callback when the root bus device is added
- */
-static int vmbus_dev_add(struct hv_device *dev, void *info)
-{
-	u32 *irqvector = info;
-	int ret;
-
-	vmbus_device = dev;
-
-	memcpy(&vmbus_device->dev_type, &device_type, sizeof(struct hv_guid));
-	memcpy(&vmbus_device->dev_instance, &device_id,
-	       sizeof(struct hv_guid));
-
-	/* strcpy(dev->name, "vmbus"); */
-	/* SynIC setup... */
-	on_each_cpu(hv_synic_init, (void *)irqvector, 1);
-
-	/* Connect to VMBus in the root partition */
-	ret = vmbus_connect();
-
-	/* VmbusSendEvent(device->localPortId+1); */
-	return ret;
-}
-
 
 struct onmessage_work_context {
 	struct work_struct work;
@@ -416,17 +368,14 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  *
  * Here, we
  *	- initialize the vmbus driver context
- *	- setup various driver entry points
  *	- invoke the vmbus hv main init routine
  *	- get the irq resource
- *	- invoke the vmbus to add the vmbus root device
  *	- setup the vmbus root device
  *	- retrieve the channel offers
  */
 static int vmbus_bus_init(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
-	struct hv_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
 	unsigned int vector;
 
@@ -483,45 +432,34 @@ static int vmbus_bus_init(void)
 
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
-	/* Add the root device */
-	memset(dev_ctx, 0, sizeof(struct hv_device));
+	/* Register the root device */
+	root_dev = root_device_register(driver_name);
 
-	ret = vmbus_dev_add(dev_ctx, &vector);
-	if (ret != 0) {
+	if (IS_ERR(root_dev)) {
 		DPRINT_ERR(VMBUS_DRV,
-			   "ERROR - Unable to add vmbus root device");
+			   "ERROR - Unable to register vmbus root device");
 
 		free_irq(vmbus_irq, NULL);
-
 		bus_unregister(&vmbus_drv_ctx->bus);
 
-		ret = -1;
+		ret = PTR_ERR(root_dev);
 		goto cleanup;
 	}
-	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
-	dev_set_name(&dev_ctx->device, "vmbus_0_0");
-
-	/* No need to bind a driver to the root device. */
-	dev_ctx->device.parent = NULL;
-	/* NULL; vmbus_remove() does not get invoked */
-	dev_ctx->device.bus = &vmbus_drv_ctx->bus;
 
-	/* Setup the device dispatch table */
-	dev_ctx->device.release = vmbus_bus_release;
-
-	/* register the  root device */
-	ret = device_register(&dev_ctx->device);
+	/*
+	 * Notify the hypervisor of our irq and
+	 * connect to the host.
+	 */
+	on_each_cpu(hv_synic_init, (void *)&vector, 1);
+	ret = vmbus_connect();
 	if (ret) {
-		DPRINT_ERR(VMBUS_DRV,
-			   "ERROR - Unable to register vmbus root device");
-
+		root_device_unregister(root_dev);
 		free_irq(vmbus_irq, NULL);
 		bus_unregister(&vmbus_drv_ctx->bus);
-
-		ret = -1;
 		goto cleanup;
 	}
 
+
 	vmbus_request_offers();
 	wait_for_completion(&hv_channel_ready);
 
@@ -538,7 +476,6 @@ static void vmbus_bus_exit(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
-	struct hv_device *dev_ctx = &vmbus_drv.device_ctx;
 
 	vmbus_release_unattached_channels();
 	vmbus_disconnect();
@@ -547,7 +484,7 @@ static void vmbus_bus_exit(void)
 	hv_cleanup();
 
 	/* Unregister the root bus device */
-	device_unregister(&dev_ctx->device);
+	root_device_unregister(root_dev);
 
 	bus_unregister(&vmbus_drv_ctx->bus);
 
@@ -672,7 +609,7 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 
 	/* The new device belongs to this bus */
 	child_device_obj->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
-	child_device_obj->device.parent = &vmbus_device->device;
+	child_device_obj->device.parent = root_dev;
 	child_device_obj->device.release = vmbus_device_release;
 
 	/*
@@ -873,14 +810,6 @@ static int vmbus_remove(struct device *child_device)
 	int ret;
 	struct hv_driver *drv;
 
-	/* Special case root bus device */
-	if (child_device->parent == NULL) {
-		/*
-		 * No-op since it is statically defined and handle in
-		 * vmbus_bus_exit()
-		 */
-		return 0;
-	}
 
 	if (child_device->driver) {
 		drv = drv_to_hv_drv(child_device->driver);
@@ -909,14 +838,6 @@ static void vmbus_shutdown(struct device *child_device)
 {
 	struct hv_driver *drv;
 
-	/* Special case root bus device */
-	if (child_device->parent == NULL) {
-		/*
-		 * No-op since it is statically defined and handle in
-		 * vmbus_bus_exit()
-		 */
-		return;
-	}
 
 	/* The device may not be attached yet */
 	if (!child_device->driver)
@@ -931,17 +852,6 @@ static void vmbus_shutdown(struct device *child_device)
 	return;
 }
 
-/*
- * vmbus_bus_release - Final callback release of the vmbus root device
- */
-static void vmbus_bus_release(struct device *device)
-{
-	/* FIXME */
-	/* Empty release functions are a bug, or a major sign
-	 * of a problem design, this MUST BE FIXED! */
-	dev_err(device, "%s needs to be fixed!\n", __func__);
-	WARN_ON(1);
-}
 
 /*
  * vmbus_device_release - Final callback release of the vmbus child device
-- 
1.5.5.6

