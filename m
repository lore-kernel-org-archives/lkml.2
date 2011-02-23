Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab1BWULx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:11:53 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:50271
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755632Ab1BWULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:11:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/4] staging: hv: Fix the code depending on struct vmbus_driver_context data order
Date: Wed, 23 Feb 2011 12:19:55 -0800
Message-Id: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixed the code depending on the exact order of fields in the
struct vmbus_driver_context, so the unused field drv_ctx can be removed,
and drv_obj doesn't have to be the second field in this structure.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc_drv.c  |    2 ++
 drivers/staging/hv/netvsc_drv.c  |    2 ++
 drivers/staging/hv/storvsc_drv.c |    2 ++
 drivers/staging/hv/vmbus.h       |    2 +-
 drivers/staging/hv/vmbus_drv.c   |   14 +-------------
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 36a0adb..293ab8e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -177,6 +177,8 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
 	int ret;
 
+	drv_ctx->hv_drv = &storvsc_drv_obj->base;
+
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 03f9740..364b6c7 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -500,6 +500,8 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
 	int ret;
 
+	drv_ctx->hv_drv = &net_drv_obj->base;
+
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
 	net_drv_obj->recv_cb = netvsc_recv_callback;
 	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index a8427ff..33acee5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -140,6 +140,8 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
 	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
 
+	drv_ctx->hv_drv = &storvsc_drv_obj->base;
+
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 42f2adb..fd9d00f 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -30,8 +30,8 @@
 
 struct driver_context {
 	struct hv_guid class_id;
-
 	struct device_driver driver;
+	struct hv_driver *hv_drv;
 
 	/*
 	 * Use these methods instead of the struct device_driver so 2.6 kernel
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 459c707..1f4e46d 100644
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
@@ -869,14 +864,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	/* We found our driver ? */
 	if (memcmp(&device_ctx->class_id, &driver_ctx->class_id,
 		   sizeof(struct hv_guid)) == 0) {
-		/*
-		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
-		 * it here to access the struct hv_driver field
-		 */
-		struct vmbus_driver_context *vmbus_drv_ctx =
-			(struct vmbus_driver_context *)driver_ctx;
-
-		device_ctx->device_obj.drv = &vmbus_drv_ctx->drv_obj;
+		device_ctx->device_obj.drv = driver_ctx->hv_drv;
 		DPRINT_INFO(VMBUS_DRV,
 			    "device object (%p) set to driver object (%p)",
 			    &device_ctx->device_obj,
-- 
1.6.3.2

