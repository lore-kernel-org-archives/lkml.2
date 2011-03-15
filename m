Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab1COVx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:53:58 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33869
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758673Ab1COVxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/12] Staging: hv: Get rid of the forward declaration for vmbus_probe
Date: Tue, 15 Mar 2011 15:03:39 -0700
Message-Id: <1300226624-27004-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-7-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <1300226624-27004-7-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_probe by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  107 ++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 5dcfd98..8153a4d 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,7 +47,6 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
-static int vmbus_probe(struct device *device);
 static int vmbus_remove(struct device *device);
 static void vmbus_shutdown(struct device *device);
 
@@ -196,6 +195,59 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	return match;
 }
 
+
+/*
+ * vmbus_probe_failed_cb - Callback when a driver probe failed in vmbus_probe()
+ *
+ * We need a callback because we cannot invoked device_unregister() inside
+ * vmbus_probe() since vmbus_probe() may be invoked inside device_register()
+ * i.e. we cannot call device_unregister() inside device_register()
+ */
+static void vmbus_probe_failed_cb(struct work_struct *context)
+{
+	struct hv_device *device_ctx = (struct hv_device *)context;
+
+	/*
+	 * Kick off the process of unregistering the device.
+	 * This will call vmbus_remove() and eventually vmbus_device_release()
+	 */
+	device_unregister(&device_ctx->device);
+
+	/* put_device(&device_ctx->device); */
+}
+
+/*
+ * vmbus_probe - Add the new vmbus's child device
+ */
+static int vmbus_probe(struct device *child_device)
+{
+	int ret = 0;
+	struct hv_driver *drv =
+			drv_to_hv_drv(child_device->driver);
+	struct hv_device *dev = device_to_hv_device(child_device);
+
+	/* Let the specific open-source driver handles the probe if it can */
+	if (drv->driver.probe) {
+		ret = dev->probe_error =
+		drv->driver.probe(child_device);
+		if (ret != 0) {
+			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
+				   "(%p) on driver %s (%d)...",
+				   dev_name(child_device), child_device,
+				   child_device->driver->name, ret);
+
+			INIT_WORK(&dev->probe_failed_work_item,
+				  vmbus_probe_failed_cb);
+			schedule_work(&dev->probe_failed_work_item);
+		}
+	} else {
+		DPRINT_ERR(VMBUS_DRV, "probe() method not set for driver - %s",
+			   child_device->driver->name);
+		ret = -1;
+	}
+	return ret;
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -724,59 +776,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 		    &device_obj->device);
 }
 
-
-/*
- * vmbus_probe_failed_cb - Callback when a driver probe failed in vmbus_probe()
- *
- * We need a callback because we cannot invoked device_unregister() inside
- * vmbus_probe() since vmbus_probe() may be invoked inside device_register()
- * i.e. we cannot call device_unregister() inside device_register()
- */
-static void vmbus_probe_failed_cb(struct work_struct *context)
-{
-	struct hv_device *device_ctx = (struct hv_device *)context;
-
-	/*
-	 * Kick off the process of unregistering the device.
-	 * This will call vmbus_remove() and eventually vmbus_device_release()
-	 */
-	device_unregister(&device_ctx->device);
-
-	/* put_device(&device_ctx->device); */
-}
-
-/*
- * vmbus_probe - Add the new vmbus's child device
- */
-static int vmbus_probe(struct device *child_device)
-{
-	int ret = 0;
-	struct hv_driver *drv =
-			drv_to_hv_drv(child_device->driver);
-	struct hv_device *dev = device_to_hv_device(child_device);
-
-	/* Let the specific open-source driver handles the probe if it can */
-	if (drv->driver.probe) {
-		ret = dev->probe_error =
-		drv->driver.probe(child_device);
-		if (ret != 0) {
-			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
-				   "(%p) on driver %s (%d)...",
-				   dev_name(child_device), child_device,
-				   child_device->driver->name, ret);
-
-			INIT_WORK(&dev->probe_failed_work_item,
-				  vmbus_probe_failed_cb);
-			schedule_work(&dev->probe_failed_work_item);
-		}
-	} else {
-		DPRINT_ERR(VMBUS_DRV, "probe() method not set for driver - %s",
-			   child_device->driver->name);
-		ret = -1;
-	}
-	return ret;
-}
-
 /*
  * vmbus_remove - Remove a vmbus device
  */
-- 
1.5.5.6

