Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1CJWD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:03:56 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47088
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751514Ab1CJWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:03:55 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/21] Staging: hv: Get rid of the forward declaration for vmbus_match
Date: Thu, 10 Mar 2011 14:13:32 -0800
Message-Id: <1299795212-1434-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_match by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   49 ++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 97ebeb4..e15c465 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -50,7 +50,6 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
-static int vmbus_match(struct device *device, struct device_driver *driver);
 static int vmbus_probe(struct device *device);
 static int vmbus_remove(struct device *device);
 static void vmbus_shutdown(struct device *device);
@@ -175,6 +174,31 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 	return 0;
 }
 
+
+/*
+ * vmbus_match - Attempt to match the specified device to the specified driver
+ */
+static int vmbus_match(struct device *device, struct device_driver *driver)
+{
+	int match = 0;
+	struct hv_driver *drv = drv_to_hv_drv(driver);
+	struct hv_device *device_ctx = device_to_hv_device(device);
+
+	/* We found our driver ? */
+	if (memcmp(&device_ctx->dev_type, &drv->dev_type,
+		   sizeof(struct hv_guid)) == 0) {
+
+		device_ctx->drv = drv->priv;
+		DPRINT_INFO(VMBUS_DRV,
+			    "device object (%p) set to driver object (%p)",
+			    &device_ctx,
+			    device_ctx->drv);
+
+		match = 1;
+	}
+	return match;
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -722,29 +746,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 		    &device_obj->device);
 }
 
-/*
- * vmbus_match - Attempt to match the specified device to the specified driver
- */
-static int vmbus_match(struct device *device, struct device_driver *driver)
-{
-	int match = 0;
-	struct hv_driver *drv = drv_to_hv_drv(driver);
-	struct hv_device *device_ctx = device_to_hv_device(device);
-
-	/* We found our driver ? */
-	if (memcmp(&device_ctx->dev_type, &drv->dev_type,
-		   sizeof(struct hv_guid)) == 0) {
-
-		device_ctx->drv = drv->priv;
-		DPRINT_INFO(VMBUS_DRV,
-			    "device object (%p) set to driver object (%p)",
-			    &device_ctx,
-			    device_ctx->drv);
-
-		match = 1;
-	}
-	return match;
-}
 
 /*
  * vmbus_probe_failed_cb - Callback when a driver probe failed in vmbus_probe()
-- 
1.5.5.6

