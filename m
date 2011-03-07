Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1CGVs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:48:59 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44932
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756509Ab1CGVs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:48:58 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/16] Staging: hv: Change the signature for vmbus_child_driver_unregister
Date: Mon,  7 Mar 2011 13:24:23 -0800
Message-Id: <1299533063-22636-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for moving the element driver from the
struct driver_context to struct hv_driver, change the
signature for the function vmbus_child_driver_unregister()
to take a pointer to struct device_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/hv_mouse.c    |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc_drv.c |    2 +-
 drivers/staging/hv/vmbus.h       |    2 +-
 drivers/staging/hv/vmbus_drv.c   |   11 +++++------
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index d5e1881..dee38d5 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -233,7 +233,7 @@ static void blkvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(&drv_ctx->driver);
 
 	return;
 }
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index d2290f8..4ab08ae 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -983,7 +983,7 @@ static void mousevsc_drv_exit(void)
 	if (mousevsc_drv_obj->Base.cleanup)
 		mousevsc_drv_obj->Base.cleanup(&mousevsc_drv_obj->Base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(&drv_ctx->driver);
 
 	return;
 }
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index a50a9a6..333586e 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -489,7 +489,7 @@ static void netvsc_drv_exit(void)
 	if (netvsc_drv_obj->base.cleanup)
 		netvsc_drv_obj->base.cleanup(&netvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(&drv_ctx->driver);
 
 	return;
 }
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 8ab8df5..ced611a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -209,7 +209,7 @@ static void storvsc_drv_exit(void)
 	if (storvsc_drv_obj->base.cleanup)
 		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
-	vmbus_child_driver_unregister(drv_ctx);
+	vmbus_child_driver_unregister(&drv_ctx->driver);
 	return;
 }
 
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 2295fe2..7a5e708 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -62,7 +62,7 @@ static inline struct driver_context *driver_to_driver_context(struct device_driv
 
 /* Vmbus interface */
 int vmbus_child_driver_register(struct device_driver *drv);
-void vmbus_child_driver_unregister(struct driver_context *driver_ctx);
+void vmbus_child_driver_unregister(struct device_driver *drv);
 
 extern struct completion hv_channel_ready;
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 685376b..1473809 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -646,23 +646,22 @@ EXPORT_SYMBOL(vmbus_child_driver_register);
 
 /**
  * vmbus_child_driver_unregister() - Unregister a vmbus's child driver
- * @driver_ctx:        Pointer to driver structure you want to un-register
+ * @drv:        Pointer to driver structure you want to un-register
  *
- * @driver_ctx is of type &struct driver_context
  *
  * Un-register the given driver with Linux through the 'driver_unregister()'
  * call. And ungegisters the driver from the Hyper-V vmbus handler.
  *
  * Mainly used by Hyper-V drivers.
  */
-void vmbus_child_driver_unregister(struct driver_context *driver_ctx)
+void vmbus_child_driver_unregister(struct device_driver *drv)
 {
 	DPRINT_INFO(VMBUS_DRV, "child driver (%p) unregistering - name %s",
-		    driver_ctx, driver_ctx->driver.name);
+		    drv, drv->name);
 
-	driver_unregister(&driver_ctx->driver);
+	driver_unregister(drv);
 
-	driver_ctx->driver.bus = NULL;
+	drv->bus = NULL;
 }
 EXPORT_SYMBOL(vmbus_child_driver_unregister);
 
-- 
1.5.5.6

