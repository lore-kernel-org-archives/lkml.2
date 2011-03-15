Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab1COVyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:54:20 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53263
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758807Ab1COVxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/12] Staging: hv: Get rid of the forward declaration for vmbus_match
Date: Tue, 15 Mar 2011 15:03:38 -0700
Message-Id: <1300226624-27004-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-6-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
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
index 5243d98..5dcfd98 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,7 +47,6 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
-static int vmbus_match(struct device *device, struct device_driver *driver);
 static int vmbus_probe(struct device *device);
 static int vmbus_remove(struct device *device);
 static void vmbus_shutdown(struct device *device);
@@ -172,6 +171,31 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
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
@@ -700,29 +724,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
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

