Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab1BZB7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:59:11 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50120
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751087Ab1BZB7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:59:10 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 6/6] Staging: hv: Cleanup hyperv_driver variable names
Date: Fri, 25 Feb 2011 18:07:58 -0800
Message-Id: <1298686078-30945-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The title says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc_drv.c  |   46 +++++++++++++++---------------
 drivers/staging/hv/netvsc_drv.c  |   44 +++++++++++++++---------------
 drivers/staging/hv/storvsc_drv.c |   36 ++++++++++++------------
 drivers/staging/hv/vmbus.h       |    4 +-
 drivers/staging/hv/vmbus_drv.c   |   56 +++++++++++++++++++-------------------
 5 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index ceba20c..c924920 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -119,7 +119,7 @@ struct block_device_context {
 struct blkvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* FIXME this is a bug! */
-	struct hyperv_driver drv_ctx;
+	struct hyperv_driver drv;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -174,7 +174,7 @@ static const struct block_device_operations block_ops = {
 static int blkvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_blkvsc_drv.drv;
 	int ret;
 
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
@@ -182,16 +182,16 @@ static int blkvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 	/* Callback to client driver to complete the initialization */
 	drv_init(&storvsc_drv_obj->base);
 
-	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.class_id,
+	drv->driver.name = storvsc_drv_obj->base.name;
+	memcpy(&drv->class_id, &storvsc_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = blkvsc_probe;
-	drv_ctx->remove = blkvsc_remove;
-	drv_ctx->shutdown = blkvsc_shutdown;
+	drv->probe = blkvsc_probe;
+	drv->remove = blkvsc_remove;
+	drv->shutdown = blkvsc_shutdown;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(drv);
 
 	return ret;
 }
@@ -206,7 +206,7 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 static void blkvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_blkvsc_drv.drv;
 	struct device *current_dev;
 	int ret;
 
@@ -214,7 +214,7 @@ static void blkvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     (void *) &current_dev,
 					     blkvsc_drv_exit_cb);
 
@@ -233,7 +233,7 @@ static void blkvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(drv);
 
 	return;
 }
@@ -243,12 +243,12 @@ static void blkvsc_drv_exit(void)
  */
 static int blkvsc_probe(struct device *device)
 {
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 				driver_to_hyperv_driver(device->driver);
-	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
-				(struct blkvsc_hyperv_driver *)driver_ctx;
+	struct blkvsc_hyperv_driver *blkvsc_drv =
+				(struct blkvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				&blkvsc_drv_ctx->drv_obj;
+				&blkvsc_drv->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
 	struct block_device_context *blkdev = NULL;
@@ -727,12 +727,12 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
  */
 static int blkvsc_remove(struct device *device)
 {
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 				driver_to_hyperv_driver(device->driver);
-	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
-				(struct blkvsc_hyperv_driver *)driver_ctx;
+	struct blkvsc_hyperv_driver *blkvsc_drv =
+				(struct blkvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				&blkvsc_drv_ctx->drv_obj;
+				&blkvsc_drv->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct block_device_context *blkdev = dev_get_drvdata(device);
 	unsigned long flags;
@@ -849,12 +849,12 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct hyperv_device *device_obj = blkdev->device_obj;
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 			driver_to_hyperv_driver(device_obj->device.driver);
-	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
-			(struct blkvsc_hyperv_driver *)driver_ctx;
+	struct blkvsc_hyperv_driver *blkvsc_drv =
+			(struct blkvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-			&blkvsc_drv_ctx->drv_obj;
+			&blkvsc_drv->drv_obj;
 	struct hv_storvsc_request *storvsc_req;
 	int ret;
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 359d596..af1f9eb 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -51,7 +51,7 @@ struct net_device_context {
 struct netvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* Which is a bug FIXME! */
-	struct hyperv_driver drv_ctx;
+	struct hyperv_driver drv;
 	struct netvsc_driver drv_obj;
 };
 
@@ -135,11 +135,11 @@ static void netvsc_xmit_completion(void *context)
 static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	struct net_device_context *net_device_obj = netdev_priv(net);
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 	    driver_to_hyperv_driver(net_device_obj->device_obj->device.driver);
-	struct netvsc_hyperv_driver *net_drv_ctx =
-		(struct netvsc_hyperv_driver *)driver_ctx;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_hyperv_driver *net_drv =
+		(struct netvsc_hyperv_driver *)drv;
+	struct netvsc_driver *net_drv_obj = &net_drv->drv_obj;
 	struct hv_netvsc_packet *packet;
 	int ret;
 	unsigned int i, num_pages;
@@ -338,11 +338,11 @@ static const struct net_device_ops device_ops = {
 
 static int netvsc_probe(struct device *device)
 {
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 		driver_to_hyperv_driver(device->driver);
-	struct netvsc_hyperv_driver *net_drv_ctx =
-		(struct netvsc_hyperv_driver *)driver_ctx;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_hyperv_driver *net_drv =
+		(struct netvsc_hyperv_driver *)drv;
+	struct netvsc_driver *net_drv_obj = &net_drv->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_obj;
@@ -409,11 +409,11 @@ static int netvsc_probe(struct device *device)
 
 static int netvsc_remove(struct device *device)
 {
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 		driver_to_hyperv_driver(device->driver);
-	struct netvsc_hyperv_driver *net_drv_ctx =
-		(struct netvsc_hyperv_driver *)driver_ctx;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_hyperv_driver *net_drv =
+		(struct netvsc_hyperv_driver *)drv;
+	struct netvsc_driver *net_drv_obj = &net_drv->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
 	int ret;
@@ -458,7 +458,7 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 static void netvsc_drv_exit(void)
 {
 	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_netvsc_drv.drv;
 	struct device *current_dev;
 	int ret;
 
@@ -466,7 +466,7 @@ static void netvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     &current_dev, netvsc_drv_exit_cb);
 		if (ret)
 			DPRINT_WARN(NETVSC_DRV,
@@ -485,7 +485,7 @@ static void netvsc_drv_exit(void)
 	if (netvsc_drv_obj->base.cleanup)
 		netvsc_drv_obj->base.cleanup(&netvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(drv);
 
 	return;
 }
@@ -493,7 +493,7 @@ static void netvsc_drv_exit(void)
 static int netvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	struct netvsc_driver *net_drv_obj = &g_netvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_netvsc_drv.drv;
 	int ret;
 
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
@@ -503,15 +503,15 @@ static int netvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 	/* Callback to client driver to complete the initialization */
 	drv_init(&net_drv_obj->base);
 
-	drv_ctx->driver.name = net_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &net_drv_obj->base.class_id,
+	drv->driver.name = net_drv_obj->base.name;
+	memcpy(&drv->class_id, &net_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = netvsc_probe;
-	drv_ctx->remove = netvsc_remove;
+	drv->probe = netvsc_probe;
+	drv->remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(drv);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 659d385..28f6568 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -67,7 +67,7 @@ struct storvsc_cmd_request {
 struct storvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* FIXME this is a bug... */
-	struct hyperv_driver drv_ctx;
+	struct hyperv_driver drv;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -139,7 +139,7 @@ static int storvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	int ret;
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_storvsc_drv.drv;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
@@ -161,15 +161,15 @@ static int storvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 		return -1;
 	}
 
-	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.class_id,
+	drv->driver.name = storvsc_drv_obj->base.name;
+	memcpy(&drv->class_id, &storvsc_drv_obj->base.class_id,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = storvsc_probe;
-	drv_ctx->remove = storvsc_remove;
+	drv->probe = storvsc_probe;
+	drv->remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(drv);
 
 	return ret;
 }
@@ -184,7 +184,7 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 static void storvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct hyperv_driver *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hyperv_driver *drv = &g_storvsc_drv.drv;
 	struct device *current_dev = NULL;
 	int ret;
 
@@ -192,7 +192,7 @@ static void storvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     (void *) &current_dev,
 					     storvsc_drv_exit_cb);
 
@@ -210,7 +210,7 @@ static void storvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(drv);
 	return;
 }
 
@@ -220,12 +220,12 @@ static void storvsc_drv_exit(void)
 static int storvsc_probe(struct device *device)
 {
 	int ret;
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 				driver_to_hyperv_driver(device->driver);
-	struct storvsc_hyperv_driver *storvsc_drv_ctx =
-				(struct storvsc_hyperv_driver *)driver_ctx;
+	struct storvsc_hyperv_driver *storvsc_drv =
+				(struct storvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				&storvsc_drv_ctx->drv_obj;
+				&storvsc_drv->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
@@ -304,10 +304,10 @@ static int storvsc_probe(struct device *device)
 static int storvsc_remove(struct device *device)
 {
 	int ret;
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 			driver_to_hyperv_driver(device->driver);
 	struct storvsc_hyperv_driver *storvsc_drv_ctx =
-			(struct storvsc_hyperv_driver *)driver_ctx;
+			(struct storvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
@@ -601,10 +601,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct host_device_context *host_device_obj =
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	struct hyperv_device *device_obj = host_device_obj->device_obj;
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 		driver_to_hyperv_driver(device_obj->device.driver);
 	struct storvsc_hyperv_driver *storvsc_drv_ctx =
-		(struct storvsc_hyperv_driver *)driver_ctx;
+		(struct storvsc_hyperv_driver *)drv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 617c3ed..65efb49 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -77,8 +77,8 @@ driver_to_hyperv_driver(struct device_driver *d)
 
 
 /* Vmbus interface */
-int vmbus_child_driver_register(struct hyperv_driver *driver_ctx);
-void vmbus_child_driver_unregister(struct hyperv_driver *driver_ctx);
+int vmbus_child_driver_register(struct hyperv_driver *drv);
+void vmbus_child_driver_unregister(struct hyperv_driver *drv);
 
 extern struct completion hv_channel_ready;
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index c7e8a36..40c641f 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -46,7 +46,7 @@ struct vmbus_hyperv_driver {
 	/* FIXME, this is a bug */
 	/* The driver field is not used in here. Instead, the bus field is */
 	/* used to represent the driver */
-	struct hyperv_driver drv_ctx;
+	struct hyperv_driver dummy;
 	struct hyperv_driver drv_obj;
 
 	struct bus_type bus;
@@ -613,9 +613,9 @@ static void vmbus_bus_exit(void)
 
 /**
  * vmbus_child_driver_register() - Register a vmbus's child driver
- * @driver_ctx:        Pointer to driver structure you want to register
+ * @drv:        Pointer to driver structure you want to register
  *
- * @driver_ctx is of type &struct hyperv_driver
+ * @drv is of type &struct hyperv_driver
  *
  * Registers the given driver with Linux through the 'driver_register()' call
  * And sets up the hyper-v vmbus handling for this driver.
@@ -623,17 +623,17 @@ static void vmbus_bus_exit(void)
  *
  * Mainly used by Hyper-V drivers.
  */
-int vmbus_child_driver_register(struct hyperv_driver *driver_ctx)
+int vmbus_child_driver_register(struct hyperv_driver *drv)
 {
 	int ret;
 
 	DPRINT_INFO(VMBUS_DRV, "child driver (%p) registering - name %s",
-		    driver_ctx, driver_ctx->driver.name);
+		    drv, drv->driver.name);
 
 	/* The child driver on this vmbus */
-	driver_ctx->driver.bus = &vmbus_drv.bus;
+	drv->driver.bus = &vmbus_drv.bus;
 
-	ret = driver_register(&driver_ctx->driver);
+	ret = driver_register(&drv->driver);
 
 	vmbus_request_offers();
 
@@ -643,23 +643,23 @@ EXPORT_SYMBOL(vmbus_child_driver_register);
 
 /**
  * vmbus_child_driver_unregister() - Unregister a vmbus's child driver
- * @driver_ctx:        Pointer to driver structure you want to un-register
+ * @drv:        Pointer to driver structure you want to un-register
  *
- * @driver_ctx is of type &struct hyperv_driver
+ * @drv is of type &struct hyperv_driver
  *
  * Un-register the given driver with Linux through the 'driver_unregister()'
  * call. And ungegisters the driver from the Hyper-V vmbus handler.
  *
  * Mainly used by Hyper-V drivers.
  */
-void vmbus_child_driver_unregister(struct hyperv_driver *driver_ctx)
+void vmbus_child_driver_unregister(struct hyperv_driver *drv)
 {
 	DPRINT_INFO(VMBUS_DRV, "child driver (%p) unregistering - name %s",
-		    driver_ctx, driver_ctx->driver.name);
+		    drv, drv->driver.name);
 
-	driver_unregister(&driver_ctx->driver);
+	driver_unregister(&drv->driver);
 
-	driver_ctx->driver.bus = NULL;
+	drv->driver.bus = NULL;
 }
 EXPORT_SYMBOL(vmbus_child_driver_unregister);
 
@@ -849,18 +849,18 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
-	struct hyperv_driver *driver_ctx = driver_to_hyperv_driver(driver);
+	struct hyperv_driver *drv = driver_to_hyperv_driver(driver);
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&device_obj->class_id, &driver_ctx->class_id,
+	if (memcmp(&device_obj->class_id, &drv->class_id,
 		   sizeof(struct hv_guid)) == 0) {
 		/*
-		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
+		 * !! NOTE: The drv is not a vmbus_drv_ctx. We typecast
 		 * it here to access the struct hyperv_driver field
 		 */
 		struct vmbus_hyperv_driver *vmbus_drv_ctx =
-			(struct vmbus_hyperv_driver *)driver_ctx;
+			(struct vmbus_hyperv_driver *)drv;
 
 		device_obj->drv = &vmbus_drv_ctx->drv_obj;
 		DPRINT_INFO(VMBUS_DRV,
@@ -899,14 +899,14 @@ static void vmbus_probe_failed_cb(struct work_struct *context)
 static int vmbus_probe(struct device *child_device)
 {
 	int ret = 0;
-	struct hyperv_driver *driver_ctx =
+	struct hyperv_driver *drv =
 			driver_to_hyperv_driver(child_device->driver);
 	struct hyperv_device *device_obj =
 			device_to_hyperv_device(child_device);
 
 	/* Let the specific open-source driver handles the probe if it can */
-	if (driver_ctx->probe) {
-		ret = device_obj->probe_error = driver_ctx->probe(child_device);
+	if (drv->probe) {
+		ret = device_obj->probe_error = drv->probe(child_device);
 		if (ret != 0) {
 			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
 				   "(%p) on driver %s (%d)...",
@@ -931,7 +931,7 @@ static int vmbus_probe(struct device *child_device)
 static int vmbus_remove(struct device *child_device)
 {
 	int ret;
-	struct hyperv_driver *driver_ctx;
+	struct hyperv_driver *drv;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -943,14 +943,14 @@ static int vmbus_remove(struct device *child_device)
 	}
 
 	if (child_device->driver) {
-		driver_ctx = driver_to_hyperv_driver(child_device->driver);
+		drv = driver_to_hyperv_driver(child_device->driver);
 
 		/*
 		 * Let the specific open-source driver handles the removal if
 		 * it can
 		 */
-		if (driver_ctx->remove) {
-			ret = driver_ctx->remove(child_device);
+		if (drv->remove) {
+			ret = drv->remove(child_device);
 		} else {
 			DPRINT_ERR(VMBUS_DRV,
 				   "remove() method not set for driver - %s",
@@ -967,7 +967,7 @@ static int vmbus_remove(struct device *child_device)
  */
 static void vmbus_shutdown(struct device *child_device)
 {
-	struct hyperv_driver *driver_ctx;
+	struct hyperv_driver *drv;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -982,11 +982,11 @@ static void vmbus_shutdown(struct device *child_device)
 	if (!child_device->driver)
 		return;
 
-	driver_ctx = driver_to_hyperv_driver(child_device->driver);
+	drv = driver_to_hyperv_driver(child_device->driver);
 
 	/* Let the specific open-source driver handles the removal if it can */
-	if (driver_ctx->shutdown)
-		driver_ctx->shutdown(child_device);
+	if (drv->shutdown)
+		drv->shutdown(child_device);
 
 	return;
 }
-- 
1.5.5.6

