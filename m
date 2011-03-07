Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1CGVXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:23:39 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57714
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752815Ab1CGVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:23:37 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/16] Staging: hv: Eliminate blkvsc_driver_context structure
Date: Mon,  7 Mar 2011 13:32:58 -0800
Message-Id: <1299533578-22718-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the consolidation of all driver state into one data structure;
blkvsc_driver_context structure is not needed; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index af0a529..0f9fb05 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -115,10 +115,6 @@ struct block_device_context {
 	int users;
 };
 
-/* Per driver */
-struct blkvsc_driver_context {
-	struct storvsc_driver_object drv_obj;
-};
 
 /* Static decl */
 static DEFINE_MUTEX(blkvsc_mutex);
@@ -153,7 +149,7 @@ module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
 
 /* The one and only one */
-static struct blkvsc_driver_context g_blkvsc_drv;
+static  struct storvsc_driver_object g_blkvsc_drv;
 
 static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
@@ -170,8 +166,8 @@ static const struct block_device_operations block_ops = {
  */
 static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_blkvsc_drv.drv_obj.base;
+	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv;
+	struct hv_driver *drv = &g_blkvsc_drv.base;
 	int ret;
 
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
@@ -202,8 +198,8 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void blkvsc_drv_exit(void)
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_blkvsc_drv.drv_obj.base;
+	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv;
+	struct hv_driver *drv = &g_blkvsc_drv.base;
 	struct device *current_dev;
 	int ret;
 
@@ -242,10 +238,8 @@ static int blkvsc_probe(struct device *device)
 {
 	struct hv_driver *drv =
 				drv_to_hv_drv(device->driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				&blkvsc_drv_ctx->drv_obj;
+				drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
 
@@ -727,10 +721,8 @@ static int blkvsc_remove(struct device *device)
 {
 	struct hv_driver *drv =
 				drv_to_hv_drv(device->driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-				&blkvsc_drv_ctx->drv_obj;
+				drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
 	struct block_device_context *blkdev = dev_get_drvdata(device);
@@ -850,10 +842,8 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	struct vm_device *device_ctx = blkdev->device_ctx;
 	struct hv_driver *drv =
 			drv_to_hv_drv(device_ctx->device.driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-			(struct blkvsc_driver_context *)drv->priv;
 	struct storvsc_driver_object *storvsc_drv_obj =
-			&blkvsc_drv_ctx->drv_obj;
+			drv->priv;
 	struct hv_storvsc_request *storvsc_req;
 	int ret;
 
-- 
1.5.5.6

