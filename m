Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1DZQJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:09:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45495
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754336Ab1DZQIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 22/25] Staging: hv: Use the remove() function in struct hv_driver
Date: Tue, 26 Apr 2011 09:20:39 -0700
Message-Id: <1303834842-5022-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced remove() function in struct hv_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   11 +++++------
 drivers/staging/hv/hv_mouse.c    |   11 +++++------
 drivers/staging/hv/netvsc_drv.c  |   13 ++++++-------
 drivers/staging/hv/storvsc_drv.c |   13 ++++++-------
 drivers/staging/hv/vmbus_drv.c   |    9 +++------
 5 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 20b9a53..80f7c0e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -537,19 +537,18 @@ out:
 /*
  * blkvsc_remove() - Callback when our device is removed
  */
-static int blkvsc_remove(struct device *device)
+static int blkvsc_remove(struct hv_device *dev)
 {
 	struct storvsc_driver_object *storvsc_drv_obj =
-				drv_to_stordrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
-	struct block_device_context *blkdev = dev_get_drvdata(device);
+				drv_to_stordrv(dev->device.driver);
+	struct block_device_context *blkdev = dev_get_drvdata(&dev->device);
 	unsigned long flags;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	storvsc_drv_obj->base.dev_rm(device_obj);
+	storvsc_drv_obj->base.dev_rm(dev);
 
 	/* Get to a known state */
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -883,7 +882,7 @@ static int blkvsc_drv_init(void)
 	drv->driver.name = storvsc_drv_obj->base.name;
 
 	drv->probe = blkvsc_probe;
-	drv->driver.remove = blkvsc_remove;
+	drv->remove = blkvsc_remove;
 	drv->driver.shutdown = blkvsc_shutdown;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index e2363b3..d49a51e 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -858,20 +858,19 @@ static int mousevsc_probe(struct hv_device *dev)
 	return 0;
 }
 
-static int mousevsc_remove(struct device *device)
+static int mousevsc_remove(struct hv_device *dev)
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
 
 	if (input_dev_ctx->connected) {
 		hidinput_disconnect(input_dev_ctx->hid_device);
@@ -885,7 +884,7 @@ static int mousevsc_remove(struct device *device)
 	 * Call to the vsc driver to let it know that the device
 	 * is being removed
 	 */
-	ret = mousevsc_drv_obj->base.dev_rm(device_obj);
+	ret = mousevsc_drv_obj->base.dev_rm(dev);
 
 	if (ret != 0) {
 		DPRINT_ERR(INPUTVSC_DRV,
@@ -1023,7 +1022,7 @@ static int __init mousevsc_init(void)
 	drv->driver.name = input_drv_obj->base.name;
 
 	drv->probe = mousevsc_probe;
-	drv->driver.remove = mousevsc_remove;
+	drv->remove = mousevsc_remove;
 
 	/* The driver belongs to vmbus */
 	vmbus_child_driver_register(&drv->driver);
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 685a6f5..f4c6000 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -408,16 +408,15 @@ static int netvsc_probe(struct hv_device *dev)
 	return ret;
 }
 
-static int netvsc_remove(struct device *device)
+static int netvsc_remove(struct hv_device *dev)
 {
 	struct netvsc_driver *net_drv_obj =
-		drv_to_netvscdrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
-	struct net_device *net = dev_get_drvdata(&device_obj->device);
+		drv_to_netvscdrv(dev->device.driver);
+	struct net_device *net = dev_get_drvdata(&dev->device);
 	int ret;
 
 	if (net == NULL) {
-		dev_err(device, "No net device to remove\n");
+		dev_err(&dev->device, "No net device to remove\n");
 		return 0;
 	}
 
@@ -434,7 +433,7 @@ static int netvsc_remove(struct device *device)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = net_drv_obj->base.dev_rm(device_obj);
+	ret = net_drv_obj->base.dev_rm(dev);
 	if (ret != 0) {
 		/* TODO: */
 		netdev_err(net, "unable to remove vsc device (ret %d)\n", ret);
@@ -501,7 +500,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv->driver.name = net_drv_obj->base.name;
 
 	drv->probe = netvsc_probe;
-	drv->driver.remove = netvsc_remove;
+	drv->remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
 	ret = vmbus_child_driver_register(&drv->driver);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2060206..e449481 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -128,7 +128,7 @@ static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd
 static int storvsc_device_alloc(struct scsi_device *);
 static int storvsc_device_configure(struct scsi_device *);
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
-static int storvsc_remove(struct device *dev);
+static int storvsc_remove(struct hv_device *dev);
 
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 						unsigned int sg_count,
@@ -214,7 +214,7 @@ static int storvsc_drv_init(void)
 	drv->driver.name = storvsc_drv_obj->base.name;
 
 	drv->probe = storvsc_probe;
-	drv->driver.remove = storvsc_remove;
+	drv->remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
 	ret = vmbus_child_driver_register(&drv->driver);
@@ -398,12 +398,11 @@ static int storvsc_probe(struct hv_device *device)
 /*
  * storvsc_remove - Callback when our device is removed
  */
-static int storvsc_remove(struct device *device)
+static int storvsc_remove(struct hv_device *dev)
 {
 	struct storvsc_driver_object *storvsc_drv_obj =
-			 drv_to_stordrv(device->driver);
-	struct hv_device *device_obj = device_to_hv_device(device);
-	struct Scsi_Host *host = dev_get_drvdata(device);
+			 drv_to_stordrv(dev->device.driver);
+	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
 	struct host_device_context *host_device_ctx =
 			(struct host_device_context *)host->hostdata;
 
@@ -411,7 +410,7 @@ static int storvsc_remove(struct device *device)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	storvsc_drv_obj->base.dev_rm(device_obj);
+	storvsc_drv_obj->base.dev_rm(dev);
 
 	if (host_device_ctx->request_pool) {
 		kmem_cache_destroy(host_device_ctx->request_pool);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 15e6497..e09b363 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -344,16 +344,13 @@ static int vmbus_remove(struct device *child_device)
 	int ret;
 	struct hv_driver *drv;
 
+	struct hv_device *dev = device_to_hv_device(child_device);
 
 	if (child_device->driver) {
 		drv = drv_to_hv_drv(child_device->driver);
 
-		/*
-		 * Let the specific open-source driver handles the removal if
-		 * it can
-		 */
-		if (drv->driver.remove) {
-			ret = drv->driver.remove(child_device);
+		if (drv->remove) {
+			ret = drv->remove(dev);
 		} else {
 			pr_err("remove not set for driver %s\n",
 				dev_name(child_device));
-- 
1.7.4.1

