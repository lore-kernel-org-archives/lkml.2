Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1CJWFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:05:31 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52219
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751077Ab1CJWFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:05:30 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 18/21] Staging: hv: Get rid of the forward declaration for vmbus_shutdown
Date: Thu, 10 Mar 2011 14:15:05 -0800
Message-Id: <1299795305-1528-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_shutdown by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   44 ++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index db5e735..6f4094b 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -50,7 +50,6 @@ struct hv_bus {
 	struct tasklet_struct event_dpc;
 };
 
-static void vmbus_shutdown(struct device *device);
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
@@ -279,6 +278,28 @@ static int vmbus_remove(struct device *child_device)
 	return 0;
 }
 
+
+/*
+ * vmbus_shutdown - Shutdown a vmbus device
+ */
+static void vmbus_shutdown(struct device *child_device)
+{
+	struct hv_driver *drv;
+
+
+	/* The device may not be attached yet */
+	if (!child_device->driver)
+		return;
+
+	drv = drv_to_hv_drv(child_device->driver);
+
+	/* Let the specific open-source driver handles the removal if it can */
+	if (drv->driver.shutdown)
+		drv->driver.shutdown(child_device);
+
+	return;
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -826,27 +847,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 		    &device_obj->device);
 }
 
-/*
- * vmbus_shutdown - Shutdown a vmbus device
- */
-static void vmbus_shutdown(struct device *child_device)
-{
-	struct hv_driver *drv;
-
-
-	/* The device may not be attached yet */
-	if (!child_device->driver)
-		return;
-
-	drv = drv_to_hv_drv(child_device->driver);
-
-	/* Let the specific open-source driver handles the removal if it can */
-	if (drv->driver.shutdown)
-		drv->driver.shutdown(child_device);
-
-	return;
-}
-
 
 /*
  * vmbus_device_release - Final callback release of the vmbus child device
-- 
1.5.5.6

