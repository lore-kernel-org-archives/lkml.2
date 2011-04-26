Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1DZQaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:30:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35860
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754369Ab1DZQaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:30:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/25] Staging: hv: Cleanup vmbus_probe() function
Date: Tue, 26 Apr 2011 09:20:30 -0700
Message-Id: <1303834842-5022-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic for handling probe failure was broken. Now that we have
cleaned up error handling, get rid of the vmbus_probe_failed_cb()
function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_api.h |    2 --
 drivers/staging/hv/vmbus_drv.c |   27 +--------------------------
 2 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 02e3587..c953d6e 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -105,8 +105,6 @@ struct hv_driver {
 struct hv_device {
 	char name[64];
 
-	struct work_struct probe_failed_work_item;
-
 	int probe_error;
 
 	/* the device type id of this device */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4d569ad..248dc8a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -313,27 +313,6 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	return match;
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
 /*
  * vmbus_probe - Add the new vmbus's child device
  */
@@ -348,14 +327,10 @@ static int vmbus_probe(struct device *child_device)
 	if (drv->driver.probe) {
 		ret = dev->probe_error =
 		drv->driver.probe(child_device);
-		if (ret != 0) {
+		if (ret != 0)
 			pr_err("probe failed for device %s (%d)\n",
 			       dev_name(child_device), ret);
 
-			INIT_WORK(&dev->probe_failed_work_item,
-				  vmbus_probe_failed_cb);
-			schedule_work(&dev->probe_failed_work_item);
-		}
 	} else {
 		pr_err("probe not set for driver %s\n",
 		       dev_name(child_device));
-- 
1.7.4.1

