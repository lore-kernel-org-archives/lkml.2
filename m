Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1CGVOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:14:22 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:38553
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753215Ab1CGVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:14:21 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/16] Staging: hv: Change the signature for vmbus_child_driver_register
Date: Mon,  7 Mar 2011 13:23:43 -0800
Message-Id: <1299533023-22609-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the element driver from the
struct driver_context to struct hv_driver, change the
signature for the function vmbus_child_driver_register()
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
index 9ccd5dc..d5e1881 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -191,7 +191,7 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_ctx->driver.shutdown = blkvsc_shutdown;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(&drv_ctx->driver);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 6e2a937..d2290f8 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -1025,7 +1025,7 @@ static int __init mousevsc_init(void)
 	drv_ctx->driver.remove = mousevsc_remove;
 
 	/* The driver belongs to vmbus */
-	vmbus_child_driver_register(drv_ctx);
+	vmbus_child_driver_register(&drv_ctx->driver);
 
 	return 0;
 }
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e2013b5..a50a9a6 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -515,7 +515,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_ctx->driver.remove = netvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(&drv_ctx->driver);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3855271..8ab8df5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -168,7 +168,7 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_ctx->driver.remove = storvsc_remove;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(drv_ctx);
+	ret = vmbus_child_driver_register(&drv_ctx->driver);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 8bcfb40..2295fe2 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -61,7 +61,7 @@ static inline struct driver_context *driver_to_driver_context(struct device_driv
 
 
 /* Vmbus interface */
-int vmbus_child_driver_register(struct driver_context *driver_ctx);
+int vmbus_child_driver_register(struct device_driver *drv);
 void vmbus_child_driver_unregister(struct driver_context *driver_ctx);
 
 extern struct completion hv_channel_ready;
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 6ef5bee..685376b 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -617,9 +617,8 @@ static void vmbus_bus_exit(void)
 
 /**
  * vmbus_child_driver_register() - Register a vmbus's child driver
- * @driver_ctx:        Pointer to driver structure you want to register
+ * @drv:        Pointer to driver structure you want to register
  *
- * @driver_ctx is of type &struct driver_context
  *
  * Registers the given driver with Linux through the 'driver_register()' call
  * And sets up the hyper-v vmbus handling for this driver.
@@ -627,17 +626,17 @@ static void vmbus_bus_exit(void)
  *
  * Mainly used by Hyper-V drivers.
  */
-int vmbus_child_driver_register(struct driver_context *driver_ctx)
+int vmbus_child_driver_register(struct device_driver *drv)
 {
 	int ret;
 
 	DPRINT_INFO(VMBUS_DRV, "child driver (%p) registering - name %s",
-		    driver_ctx, driver_ctx->driver.name);
+		    drv, drv->name);
 
 	/* The child driver on this vmbus */
-	driver_ctx->driver.bus = &vmbus_drv.bus;
+	drv->bus = &vmbus_drv.bus;
 
-	ret = driver_register(&driver_ctx->driver);
+	ret = driver_register(drv);
 
 	vmbus_request_offers();
 
-- 
1.5.5.6

