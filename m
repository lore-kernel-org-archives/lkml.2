Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab1DZQLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:11:24 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45479
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754303Ab1DZQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 20/25] Staging: hv: Use the probe function in struct hv_driver
Date: Tue, 26 Apr 2011 09:20:37 -0700
Message-Id: <1303834842-5022-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced probe function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   19 +++++++++----------
 drivers/staging/hv/hv_mouse.c    |   11 +++++------
 drivers/staging/hv/netvsc_drv.c  |   19 +++++++++----------
 drivers/staging/hv/storvsc_drv.c |   23 +++++++++++------------
 drivers/staging/hv/vmbus_drv.c   |    5 ++---
 5 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index ec6a761..20b9a53 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -140,7 +140,7 @@ MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
  * There is a circular dependency involving blkvsc_probe()
  * and block_ops.
  */
-static int blkvsc_probe(struct device *dev);
+static int blkvsc_probe(struct hv_device *dev);
 
 static int blk_vsc_on_device_add(struct hv_device *device,
 				void *additional_info)
@@ -882,7 +882,7 @@ static int blkvsc_drv_init(void)
 
 	drv->driver.name = storvsc_drv_obj->base.name;
 
-	drv->driver.probe = blkvsc_probe;
+	drv->probe = blkvsc_probe;
 	drv->driver.remove = blkvsc_remove;
 	drv->driver.shutdown = blkvsc_shutdown;
 
@@ -937,11 +937,10 @@ static void blkvsc_drv_exit(void)
 /*
  * blkvsc_probe - Add a new device for this driver
  */
-static int blkvsc_probe(struct device *device)
+static int blkvsc_probe(struct hv_device *dev)
 {
 	struct storvsc_driver_object *storvsc_drv_obj =
-				drv_to_stordrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
+			drv_to_stordrv(dev->device.driver);
 
 	struct block_device_context *blkdev = NULL;
 	struct storvsc_device_info device_info;
@@ -961,7 +960,7 @@ static int blkvsc_probe(struct device *device)
 	spin_lock_init(&blkdev->lock);
 
 
-	blkdev->request_pool = kmem_cache_create(dev_name(&device_obj->device),
+	blkdev->request_pool = kmem_cache_create(dev_name(&dev->device),
 					sizeof(struct blkvsc_request), 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 	if (!blkdev->request_pool) {
@@ -971,17 +970,17 @@ static int blkvsc_probe(struct device *device)
 
 
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->base.dev_add(device_obj, &device_info);
+	ret = storvsc_drv_obj->base.dev_add(dev, &device_info);
 	if (ret != 0)
 		goto cleanup;
 
-	blkdev->device_ctx = device_obj;
+	blkdev->device_ctx = dev;
 	/* this identified the device 0 or 1 */
 	blkdev->target = device_info.target_id;
 	/* this identified the ide ctrl 0 or 1 */
 	blkdev->path = device_info.path_id;
 
-	dev_set_drvdata(device, blkdev);
+	dev_set_drvdata(&dev->device, blkdev);
 
 	ret = stor_vsc_get_major_info(&device_info, &major_info);
 
@@ -1041,7 +1040,7 @@ static int blkvsc_probe(struct device *device)
 	return ret;
 
 remove:
-	storvsc_drv_obj->base.dev_rm(device_obj);
+	storvsc_drv_obj->base.dev_rm(dev);
 
 cleanup:
 	if (blkdev) {
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 4333247..e2363b3 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -832,23 +832,22 @@ static void mousevsc_hid_close(struct hid_device *hid)
 {
 }
 
-static int mousevsc_probe(struct device *device)
+static int mousevsc_probe(struct hv_device *dev)
 {
 	int ret = 0;
 
 	struct mousevsc_drv_obj *mousevsc_drv_obj =
-		drv_to_mousedrv(device->driver);
+		drv_to_mousedrv(dev->device.driver);
 
-	struct hv_device *device_obj = device_to_hv_device(device);
 	struct input_device_context *input_dev_ctx;
 
 	input_dev_ctx = kmalloc(sizeof(struct input_device_context),
 				GFP_KERNEL);
 
-	dev_set_drvdata(device, input_dev_ctx);
+	dev_set_drvdata(&dev->device, input_dev_ctx);
 
 	/* Call to the vsc driver to add the device */
-	ret = mousevsc_drv_obj->base.dev_add(device_obj, NULL);
+	ret = mousevsc_drv_obj->base.dev_add(dev, NULL);
 
 	if (ret != 0) {
 		DPRINT_ERR(INPUTVSC_DRV, "unable to add input vsc device");
@@ -1023,7 +1022,7 @@ static int __init mousevsc_init(void)
 
 	drv->driver.name = input_drv_obj->base.name;
 
-	drv->driver.probe = mousevsc_probe;
+	drv->probe = mousevsc_probe;
 	drv->driver.remove = mousevsc_remove;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e61eb7e..685a6f5 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -340,11 +340,10 @@ static void netvsc_send_garp(struct work_struct *w)
 }
 
 
-static int netvsc_probe(struct device *device)
+static int netvsc_probe(struct hv_device *dev)
 {
 	struct netvsc_driver *net_drv_obj =
-		drv_to_netvscdrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
+		drv_to_netvscdrv(dev->device.driver);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info device_info;
@@ -361,16 +360,16 @@ static int netvsc_probe(struct device *device)
 	netif_carrier_off(net);
 
 	net_device_ctx = netdev_priv(net);
-	net_device_ctx->device_ctx = device_obj;
+	net_device_ctx->device_ctx = dev;
 	net_device_ctx->avail = ring_size;
-	dev_set_drvdata(device, net);
+	dev_set_drvdata(&dev->device, net);
 	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
-	ret = net_drv_obj->base.dev_add(device_obj, &device_info);
+	ret = net_drv_obj->base.dev_add(dev, &device_info);
 	if (ret != 0) {
 		free_netdev(net);
-		dev_set_drvdata(device, NULL);
+		dev_set_drvdata(&dev->device, NULL);
 
 		netdev_err(net, "unable to add netvsc device (ret %d)\n", ret);
 		return ret;
@@ -397,12 +396,12 @@ static int netvsc_probe(struct device *device)
 	net->features = NETIF_F_SG;
 
 	SET_ETHTOOL_OPS(net, &ethtool_ops);
-	SET_NETDEV_DEV(net, device);
+	SET_NETDEV_DEV(net, &dev->device);
 
 	ret = register_netdev(net);
 	if (ret != 0) {
 		/* Remove the device and release the resource */
-		net_drv_obj->base.dev_rm(device_obj);
+		net_drv_obj->base.dev_rm(dev);
 		free_netdev(net);
 	}
 
@@ -501,7 +500,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 
 	drv->driver.name = net_drv_obj->base.name;
 
-	drv->driver.probe = netvsc_probe;
+	drv->probe = netvsc_probe;
 	drv->driver.remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 5ac2904..2060206 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -123,7 +123,7 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 }
 
 /* Static decl */
-static int storvsc_probe(struct device *dev);
+static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
 static int storvsc_device_alloc(struct scsi_device *);
 static int storvsc_device_configure(struct scsi_device *);
@@ -213,7 +213,7 @@ static int storvsc_drv_init(void)
 
 	drv->driver.name = storvsc_drv_obj->base.name;
 
-	drv->driver.probe = storvsc_probe;
+	drv->probe = storvsc_probe;
 	drv->driver.remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
@@ -320,12 +320,11 @@ static void storvsc_drv_exit(void)
 /*
  * storvsc_probe - Add a new device for this driver
  */
-static int storvsc_probe(struct device *device)
+static int storvsc_probe(struct hv_device *device)
 {
 	int ret;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				 drv_to_stordrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
+		 drv_to_stordrv(device->device.driver);
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
 	struct storvsc_device_info device_info;
@@ -340,16 +339,16 @@ static int storvsc_probe(struct device *device)
 		return -ENOMEM;
 	}
 
-	dev_set_drvdata(device, host);
+	dev_set_drvdata(&device->device, host);
 
 	host_device_ctx = (struct host_device_context *)host->hostdata;
 	memset(host_device_ctx, 0, sizeof(struct host_device_context));
 
 	host_device_ctx->port = host->host_no;
-	host_device_ctx->device_ctx = device_obj;
+	host_device_ctx->device_ctx = device;
 
 	host_device_ctx->request_pool =
-				kmem_cache_create(dev_name(&device_obj->device),
+				kmem_cache_create(dev_name(&device->device),
 					sizeof(struct storvsc_cmd_request), 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 
@@ -360,8 +359,8 @@ static int storvsc_probe(struct device *device)
 
 	device_info.port_number = host->host_no;
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->base.dev_add(device_obj,
-						(void *)&device_info);
+	ret = storvsc_drv_obj->base.dev_add(device, (void *)&device_info);
+
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi vsc device");
 		kmem_cache_destroy(host_device_ctx->request_pool);
@@ -381,11 +380,11 @@ static int storvsc_probe(struct device *device)
 	host->max_channel = STORVSC_MAX_CHANNELS - 1;
 
 	/* Register the HBA and start the scsi bus scan */
-	ret = scsi_add_host(host, device);
+	ret = scsi_add_host(host, &device->device);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi host device");
 
-		storvsc_drv_obj->base.dev_rm(device_obj);
+		storvsc_drv_obj->base.dev_rm(device);
 
 		kmem_cache_destroy(host_device_ctx->request_pool);
 		scsi_host_put(host);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 515311c..15e6497 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -321,10 +321,9 @@ static int vmbus_probe(struct device *child_device)
 			drv_to_hv_drv(child_device->driver);
 	struct hv_device *dev = device_to_hv_device(child_device);
 
-	/* Let the specific open-source driver handles the probe if it can */
-	if (drv->driver.probe) {
+	if (drv->probe) {
 		ret = dev->probe_error =
-		drv->driver.probe(child_device);
+		drv->probe(dev);
 		if (ret != 0)
 			pr_err("probe failed for device %s (%d)\n",
 			       dev_name(child_device), ret);
-- 
1.7.4.1

