Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1CGVtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:49:03 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46606
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756543Ab1CGVtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:49:00 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/16] Staging: hv: Eliminate driver_context structure
Date: Mon,  7 Mar 2011 13:32:31 -0800
Message-Id: <1299533551-22693-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to move the following elements from struct driver_context:
class_id and driver in one step. As part of this operation get rid of
the struct driver_context. With this patch we will have
consolidated all driver state into one data structure:
struct hv_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   43 +++++++++++++++++--------------------
 drivers/staging/hv/hv_mouse.c    |   32 +++++++++++++---------------
 drivers/staging/hv/netvsc_drv.c  |   40 +++++++++++++++-------------------
 drivers/staging/hv/storvsc_drv.c |   41 ++++++++++++++++-------------------
 drivers/staging/hv/vmbus.h       |   10 +-------
 drivers/staging/hv/vmbus_api.h   |   14 ++++++++++++
 drivers/staging/hv/vmbus_drv.c   |   41 +++++++++++++-----------------------
 7 files changed, 103 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index dee38d5..af0a529 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -117,9 +117,6 @@ struct block_device_context {
 
 /* Per driver */
 struct blkvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* FIXME this is a bug! */
-	struct driver_context drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -174,24 +171,24 @@ static const struct block_device_operations block_ops = {
 static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_blkvsc_drv.drv_obj.base;
 	int ret;
 
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
 
+	drv->priv = storvsc_drv_obj;
+
 	/* Callback to client driver to complete the initialization */
 	drv_init(&storvsc_drv_obj->base);
 
-	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
-	       sizeof(struct hv_guid));
+	drv->driver.name = storvsc_drv_obj->base.name;
 
-	drv_ctx->driver.probe = blkvsc_probe;
-	drv_ctx->driver.remove = blkvsc_remove;
-	drv_ctx->driver.shutdown = blkvsc_shutdown;
+	drv->driver.probe = blkvsc_probe;
+	drv->driver.remove = blkvsc_remove;
+	drv->driver.shutdown = blkvsc_shutdown;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv_ctx->driver);
+	ret = vmbus_child_driver_register(&drv->driver);
 
 	return ret;
 }
@@ -206,7 +203,7 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 static void blkvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_blkvsc_drv.drv_obj.base;
 	struct device *current_dev;
 	int ret;
 
@@ -214,7 +211,7 @@ static void blkvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     (void *) &current_dev,
 					     blkvsc_drv_exit_cb);
 
@@ -233,7 +230,7 @@ static void blkvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(&drv_ctx->driver);
+	vmbus_child_driver_unregister(&drv->driver);
 
 	return;
 }
@@ -243,10 +240,10 @@ static void blkvsc_drv_exit(void)
  */
 static int blkvsc_probe(struct device *device)
 {
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+				drv_to_hv_drv(device->driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+				(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -728,10 +725,10 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
  */
 static int blkvsc_remove(struct device *device)
 {
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+				drv_to_hv_drv(device->driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+				(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -851,10 +848,10 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct vm_device *device_ctx = blkdev->device_ctx;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(device_ctx->device.driver);
+	struct hv_driver *drv =
+			drv_to_hv_drv(device_ctx->device.driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-			(struct blkvsc_driver_context *)driver_ctx;
+			(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&blkvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *storvsc_req;
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 4ab08ae..f762a8a 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -778,7 +778,6 @@ struct input_device_context {
 };
 
 struct mousevsc_driver_context {
-	struct driver_context	drv_ctx;
 	struct mousevsc_drv_obj	drv_obj;
 };
 
@@ -823,10 +822,10 @@ static int mousevsc_probe(struct device *device)
 {
 	int ret = 0;
 
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+		drv_to_hv_drv(device->driver);
 	struct mousevsc_driver_context *mousevsc_drv_ctx =
-		(struct mousevsc_driver_context *)driver_ctx;
+		(struct mousevsc_driver_context *)drv->priv;
 	struct mousevsc_drv_obj *mousevsc_drv_obj = &mousevsc_drv_ctx->drv_obj;
 
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -854,10 +853,10 @@ static int mousevsc_remove(struct device *device)
 {
 	int ret = 0;
 
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+		drv_to_hv_drv(device->driver);
 	struct mousevsc_driver_context *mousevsc_drv_ctx =
-		(struct mousevsc_driver_context *)driver_ctx;
+		(struct mousevsc_driver_context *)drv->priv;
 	struct mousevsc_drv_obj *mousevsc_drv_obj = &mousevsc_drv_ctx->drv_obj;
 
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -958,7 +957,7 @@ static int mousevsc_drv_exit_cb(struct device *dev, void *data)
 static void mousevsc_drv_exit(void)
 {
 	struct mousevsc_drv_obj *mousevsc_drv_obj = &g_mousevsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_mousevsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_mousevsc_drv.drv_obj.Base;
 	int ret;
 
 	struct device *current_dev = NULL;
@@ -967,7 +966,7 @@ static void mousevsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     (void *)&current_dev,
 					     mousevsc_drv_exit_cb);
 		if (ret)
@@ -983,7 +982,7 @@ static void mousevsc_drv_exit(void)
 	if (mousevsc_drv_obj->Base.cleanup)
 		mousevsc_drv_obj->Base.cleanup(&mousevsc_drv_obj->Base);
 
-	vmbus_child_driver_unregister(&drv_ctx->driver);
+	vmbus_child_driver_unregister(&drv->driver);
 
 	return;
 }
@@ -1010,22 +1009,21 @@ static int mouse_vsc_initialize(struct hv_driver *Driver)
 static int __init mousevsc_init(void)
 {
 	struct mousevsc_drv_obj *input_drv_obj = &g_mousevsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_mousevsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_mousevsc_drv.drv_obj.Base;
 
 	DPRINT_INFO(INPUTVSC_DRV, "Hyper-V Mouse driver initializing.");
 
 	/* Callback to client driver to complete the initialization */
 	mouse_vsc_initialize(&input_drv_obj->Base);
 
-	drv_ctx->driver.name = input_drv_obj->Base.name;
-	memcpy(&drv_ctx->class_id, &input_drv_obj->Base.dev_type,
-	       sizeof(struct hv_guid));
+	drv->driver.name = input_drv_obj->Base.name;
+	drv->priv = input_drv_obj;
 
-	drv_ctx->driver.probe = mousevsc_probe;
-	drv_ctx->driver.remove = mousevsc_remove;
+	drv->driver.probe = mousevsc_probe;
+	drv->driver.remove = mousevsc_remove;
 
 	/* The driver belongs to vmbus */
-	vmbus_child_driver_register(&drv_ctx->driver);
+	vmbus_child_driver_register(&drv->driver);
 
 	return 0;
 }
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 333586e..fdcc8aa 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -49,9 +49,6 @@ struct net_device_context {
 };
 
 struct netvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* Which is a bug FIXME! */
-	struct driver_context drv_ctx;
 	struct netvsc_driver drv_obj;
 };
 
@@ -135,10 +132,10 @@ static void netvsc_xmit_completion(void *context)
 static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct driver_context *driver_ctx =
-	    driver_to_driver_context(net_device_ctx->device_ctx->device.driver);
+	struct hv_driver *drv =
+	    drv_to_hv_drv(net_device_ctx->device_ctx->device.driver);
 	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+		(struct netvsc_driver_context *)drv->priv;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hv_netvsc_packet *packet;
 	int ret;
@@ -340,10 +337,10 @@ static const struct net_device_ops device_ops = {
 
 static int netvsc_probe(struct device *device)
 {
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+		drv_to_hv_drv(device->driver);
 	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+		(struct netvsc_driver_context *)drv->priv;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
@@ -412,10 +409,10 @@ static int netvsc_probe(struct device *device)
 
 static int netvsc_remove(struct device *device)
 {
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+		drv_to_hv_drv(device->driver);
 	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+		(struct netvsc_driver_context *)drv->priv;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
@@ -462,7 +459,7 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 static void netvsc_drv_exit(void)
 {
 	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_netvsc_drv.drv_obj.base;
 	struct device *current_dev;
 	int ret;
 
@@ -470,7 +467,7 @@ static void netvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     &current_dev, netvsc_drv_exit_cb);
 		if (ret)
 			DPRINT_WARN(NETVSC_DRV,
@@ -489,7 +486,7 @@ static void netvsc_drv_exit(void)
 	if (netvsc_drv_obj->base.cleanup)
 		netvsc_drv_obj->base.cleanup(&netvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(&drv_ctx->driver);
+	vmbus_child_driver_unregister(&drv->driver);
 
 	return;
 }
@@ -497,25 +494,24 @@ static void netvsc_drv_exit(void)
 static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
 	struct netvsc_driver *net_drv_obj = &g_netvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_netvsc_drv.drv_obj.base;
 	int ret;
 
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
 	net_drv_obj->recv_cb = netvsc_recv_callback;
 	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
+	drv->priv = net_drv_obj;
 
 	/* Callback to client driver to complete the initialization */
 	drv_init(&net_drv_obj->base);
 
-	drv_ctx->driver.name = net_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &net_drv_obj->base.dev_type,
-	       sizeof(struct hv_guid));
+	drv->driver.name = net_drv_obj->base.name;
 
-	drv_ctx->driver.probe = netvsc_probe;
-	drv_ctx->driver.remove = netvsc_remove;
+	drv->driver.probe = netvsc_probe;
+	drv->driver.remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv_ctx->driver);
+	ret = vmbus_child_driver_register(&drv->driver);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ced611a..3300993 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -64,9 +64,6 @@ struct storvsc_cmd_request {
 };
 
 struct storvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* FIXME this is a bug... */
-	struct driver_context drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -138,13 +135,15 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
 	int ret;
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_storvsc_drv.drv_obj.base;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
 	drv_init(&storvsc_drv_obj->base);
 
+	drv->priv = storvsc_drv_obj;
+
 	DPRINT_INFO(STORVSC_DRV,
 		    "request extension size %u, max outstanding reqs %u",
 		    storvsc_drv_obj->request_ext_size,
@@ -160,15 +159,13 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 		return -1;
 	}
 
-	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
-	       sizeof(struct hv_guid));
+	drv->driver.name = storvsc_drv_obj->base.name;
 
-	drv_ctx->driver.probe = storvsc_probe;
-	drv_ctx->driver.remove = storvsc_remove;
+	drv->driver.probe = storvsc_probe;
+	drv->driver.remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv_ctx->driver);
+	ret = vmbus_child_driver_register(&drv->driver);
 
 	return ret;
 }
@@ -183,7 +180,7 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 static void storvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hv_driver *drv = &g_storvsc_drv.drv_obj.base;
 	struct device *current_dev = NULL;
 	int ret;
 
@@ -191,7 +188,7 @@ static void storvsc_drv_exit(void)
 		current_dev = NULL;
 
 		/* Get the device */
-		ret = driver_for_each_device(&drv_ctx->driver, NULL,
+		ret = driver_for_each_device(&drv->driver, NULL,
 					     (void *) &current_dev,
 					     storvsc_drv_exit_cb);
 
@@ -209,7 +206,7 @@ static void storvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(&drv_ctx->driver);
+	vmbus_child_driver_unregister(&drv->driver);
 	return;
 }
 
@@ -219,10 +216,10 @@ static void storvsc_drv_exit(void)
 static int storvsc_probe(struct device *device)
 {
 	int ret;
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+				drv_to_hv_drv(device->driver);
 	struct storvsc_driver_context *storvsc_drv_ctx =
-				(struct storvsc_driver_context *)driver_ctx;
+				(struct storvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&storvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -304,10 +301,10 @@ static int storvsc_probe(struct device *device)
 static int storvsc_remove(struct device *device)
 {
 	int ret;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(device->driver);
+	struct hv_driver *drv =
+			drv_to_hv_drv(device->driver);
 	struct storvsc_driver_context *storvsc_drv_ctx =
-			(struct storvsc_driver_context *)driver_ctx;
+			(struct storvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -602,10 +599,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	struct vm_device *device_ctx = host_device_ctx->device_ctx;
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device_ctx->device.driver);
+	struct hv_driver *drv =
+		drv_to_hv_drv(device_ctx->device.driver);
 	struct storvsc_driver_context *storvsc_drv_ctx =
-		(struct storvsc_driver_context *)driver_ctx;
+		(struct storvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 7a5e708..a6be405 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -28,12 +28,6 @@
 #include <linux/device.h>
 #include "vmbus_api.h"
 
-struct driver_context {
-	struct hv_guid class_id;
-
-	struct device_driver driver;
-
-};
 
 struct vm_device {
 	struct work_struct probe_failed_work_item;
@@ -54,9 +48,9 @@ static inline struct vm_device *device_to_vm_device(struct device *d)
 	return container_of(d, struct vm_device, device);
 }
 
-static inline struct driver_context *driver_to_driver_context(struct device_driver *d)
+static inline struct hv_driver *drv_to_hv_drv(struct device_driver *d)
 {
-	return container_of(d, struct driver_context, driver);
+	return container_of(d, struct hv_driver, driver);
 }
 
 
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 635ce22..7f891fb 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -25,6 +25,8 @@
 #ifndef _VMBUS_API_H_
 #define _VMBUS_API_H_
 
+#include <linux/device.h>
+
 #define MAX_PAGE_BUFFER_COUNT				16
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
 
@@ -91,6 +93,18 @@ struct hv_driver {
 	/* the device type supported by this driver */
 	struct hv_guid dev_type;
 
+	/*
+	 * Device type specific drivers (net, blk etc.)
+	 * need a mechanism to get a pointer to
+	 * device type specific driver structure given
+	 * a pointer to the base hyperv driver structure.
+	 * The current code solves this problem using
+	 * a hack. Support this need explicitly
+	 */
+	void *priv;
+
+	struct device_driver driver;
+
 	int (*dev_add)(struct hv_device *device, void *data);
 	int (*dev_rm)(struct hv_device *device);
 	void (*cleanup)(struct hv_driver *driver);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 1473809..9a9e426 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -42,11 +42,6 @@
 
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* FIXME, this is a bug */
-	/* The driver field is not used in here. Instead, the bus field is */
-	/* used to represent the driver */
-	struct driver_context drv_ctx;
 	struct hv_driver drv_obj;
 
 	struct bus_type bus;
@@ -861,20 +856,14 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
-	struct driver_context *driver_ctx = driver_to_driver_context(driver);
+	struct hv_driver *drv = drv_to_hv_drv(driver);
 	struct vm_device *device_ctx = device_to_vm_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&device_ctx->class_id, &driver_ctx->class_id,
+	if (memcmp(&device_ctx->class_id, &drv->dev_type,
 		   sizeof(struct hv_guid)) == 0) {
-		/*
-		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
-		 * it here to access the struct hv_driver field
-		 */
-		struct vmbus_driver_context *vmbus_drv_ctx =
-			(struct vmbus_driver_context *)driver_ctx;
 
-		device_ctx->device_obj.drv = &vmbus_drv_ctx->drv_obj;
+		device_ctx->device_obj.drv = drv->priv;
 		DPRINT_INFO(VMBUS_DRV,
 			    "device object (%p) set to driver object (%p)",
 			    &device_ctx->device_obj,
@@ -911,15 +900,15 @@ static void vmbus_probe_failed_cb(struct work_struct *context)
 static int vmbus_probe(struct device *child_device)
 {
 	int ret = 0;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(child_device->driver);
+	struct hv_driver *drv =
+			drv_to_hv_drv(child_device->driver);
 	struct vm_device *device_ctx =
 			device_to_vm_device(child_device);
 
 	/* Let the specific open-source driver handles the probe if it can */
-	if (driver_ctx->driver.probe) {
+	if (drv->driver.probe) {
 		ret = device_ctx->probe_error =
-		driver_ctx->driver.probe(child_device);
+		drv->driver.probe(child_device);
 		if (ret != 0) {
 			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
 				   "(%p) on driver %s (%d)...",
@@ -944,7 +933,7 @@ static int vmbus_probe(struct device *child_device)
 static int vmbus_remove(struct device *child_device)
 {
 	int ret;
-	struct driver_context *driver_ctx;
+	struct hv_driver *drv;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -956,14 +945,14 @@ static int vmbus_remove(struct device *child_device)
 	}
 
 	if (child_device->driver) {
-		driver_ctx = driver_to_driver_context(child_device->driver);
+		drv = drv_to_hv_drv(child_device->driver);
 
 		/*
 		 * Let the specific open-source driver handles the removal if
 		 * it can
 		 */
-		if (driver_ctx->driver.remove) {
-			ret = driver_ctx->driver.remove(child_device);
+		if (drv->driver.remove) {
+			ret = drv->driver.remove(child_device);
 		} else {
 			DPRINT_ERR(VMBUS_DRV,
 				   "remove() method not set for driver - %s",
@@ -980,7 +969,7 @@ static int vmbus_remove(struct device *child_device)
  */
 static void vmbus_shutdown(struct device *child_device)
 {
-	struct driver_context *driver_ctx;
+	struct hv_driver *drv;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -995,11 +984,11 @@ static void vmbus_shutdown(struct device *child_device)
 	if (!child_device->driver)
 		return;
 
-	driver_ctx = driver_to_driver_context(child_device->driver);
+	drv = drv_to_hv_drv(child_device->driver);
 
 	/* Let the specific open-source driver handles the removal if it can */
-	if (driver_ctx->driver.shutdown)
-		driver_ctx->driver.shutdown(child_device);
+	if (drv->driver.shutdown)
+		drv->driver.shutdown(child_device);
 
 	return;
 }
-- 
1.5.5.6

