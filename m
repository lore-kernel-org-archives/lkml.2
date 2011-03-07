Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1CGVYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:24:44 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54527
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755572Ab1CGVYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:24:43 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/16] Staging: hv: Eliminate storvsc_driver_context structure
Date: Mon,  7 Mar 2011 13:34:01 -0800
Message-Id: <1299533641-22796-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the consolidation of all driver state into one data structure;
storvsc_driver_context structure is not needed; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3300993..9722734 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -63,9 +63,6 @@ struct storvsc_cmd_request {
 	 * Which sounds like a very bad design... */
 };
 
-struct storvsc_driver_context {
-	struct storvsc_driver_object drv_obj;
-};
 
 /* Static decl */
 static int storvsc_probe(struct device *dev);
@@ -97,7 +94,7 @@ module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 /* The one and only one */
-static struct storvsc_driver_context g_storvsc_drv;
+static struct storvsc_driver_object g_storvsc_drv;
 
 /* Scsi driver */
 static struct scsi_host_template scsi_driver = {
@@ -134,8 +131,8 @@ static struct scsi_host_template scsi_driver = {
 static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
 	int ret;
-	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_storvsc_drv.drv_obj.base;
+	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv;
+	struct hv_driver *drv = &g_storvsc_drv.base;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
@@ -179,8 +176,8 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void storvsc_drv_exit(void)
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_storvsc_drv.drv_obj.base;
+	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv;
+	struct hv_driver *drv = &g_storvsc_drv.base;
 	struct device *current_dev = NULL;
 	int ret;
 
@@ -218,10 +215,7 @@ static int storvsc_probe(struct device *device)
 	int ret;
 	struct hv_driver *drv =
 				drv_to_hv_drv(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-				(struct storvsc_driver_context *)drv->priv;
-	struct storvsc_driver_object *storvsc_drv_obj =
-				&storvsc_drv_ctx->drv_obj;
+	struct storvsc_driver_object *storvsc_drv_obj = drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
 	struct Scsi_Host *host;
@@ -303,10 +297,7 @@ static int storvsc_remove(struct device *device)
 	int ret;
 	struct hv_driver *drv =
 			drv_to_hv_drv(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-			(struct storvsc_driver_context *)drv->priv;
-	struct storvsc_driver_object *storvsc_drv_obj =
-			&storvsc_drv_ctx->drv_obj;
+	struct storvsc_driver_object *storvsc_drv_obj = drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
 	struct Scsi_Host *host = dev_get_drvdata(device);
@@ -601,10 +592,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct vm_device *device_ctx = host_device_ctx->device_ctx;
 	struct hv_driver *drv =
 		drv_to_hv_drv(device_ctx->device.driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-		(struct storvsc_driver_context *)drv->priv;
-	struct storvsc_driver_object *storvsc_drv_obj =
-		&storvsc_drv_ctx->drv_obj;
+	struct storvsc_driver_object *storvsc_drv_obj = drv->priv;
 	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
 	unsigned int request_size = 0;
-- 
1.5.5.6

