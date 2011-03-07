Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1CGVLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:11:44 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:37305
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756177Ab1CGVLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:11:43 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/16] Staging: hv: Use generic device_driver probe function
Date: Mon,  7 Mar 2011 13:20:57 -0800
Message-Id: <1299532857-22493-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving all the state from struct driver_context
to struct hv_driver, eliminate the probe() function from
struct driver_context and use generic device_driver probe
function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/hv_mouse.c    |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc_drv.c |    2 +-
 drivers/staging/hv/vmbus_drv.c   |    5 +++--
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 36a0adb..0dff557 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -186,7 +186,7 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = blkvsc_probe;
+	drv_ctx->driver.probe = blkvsc_probe;
 	drv_ctx->remove = blkvsc_remove;
 	drv_ctx->shutdown = blkvsc_shutdown;
 
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 1aaaef4..4a25f3b 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -1021,7 +1021,7 @@ static int __init mousevsc_init(void)
 	memcpy(&drv_ctx->class_id, &input_drv_obj->Base.dev_type,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = mousevsc_probe;
+	drv_ctx->driver.probe = mousevsc_probe;
 	drv_ctx->remove = mousevsc_remove;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 03f9740..083f0d3 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -511,7 +511,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	memcpy(&drv_ctx->class_id, &net_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = netvsc_probe;
+	drv_ctx->driver.probe = netvsc_probe;
 	drv_ctx->remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index a8427ff..3fe4bdb 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -164,7 +164,7 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
-	drv_ctx->probe = storvsc_probe;
+	drv_ctx->driver.probe = storvsc_probe;
 	drv_ctx->remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 459c707..fee2a8f 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -919,8 +919,9 @@ static int vmbus_probe(struct device *child_device)
 			device_to_vm_device(child_device);
 
 	/* Let the specific open-source driver handles the probe if it can */
-	if (driver_ctx->probe) {
-		ret = device_ctx->probe_error = driver_ctx->probe(child_device);
+	if (driver_ctx->driver.probe) {
+		ret = device_ctx->probe_error =
+		driver_ctx->driver.probe(child_device);
 		if (ret != 0) {
 			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
 				   "(%p) on driver %s (%d)...",
-- 
1.5.5.6

