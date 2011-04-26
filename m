Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1DZQKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:10:54 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33058
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754317Ab1DZQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 24/25] Staging: hv: Use the shutdown() function in struct hv_driver
Date: Tue, 26 Apr 2011 09:20:41 -0700
Message-Id: <1303834842-5022-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced  shutdown() function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    6 +++---
 drivers/staging/hv/vmbus_drv.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 80f7c0e..db44cf6 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -585,9 +585,9 @@ static int blkvsc_remove(struct hv_device *dev)
 
 }
 
-static void blkvsc_shutdown(struct device *device)
+static void blkvsc_shutdown(struct hv_device *dev)
 {
-	struct block_device_context *blkdev = dev_get_drvdata(device);
+	struct block_device_context *blkdev = dev_get_drvdata(&dev->device);
 	unsigned long flags;
 
 	if (!blkdev)
@@ -883,7 +883,7 @@ static int blkvsc_drv_init(void)
 
 	drv->probe = blkvsc_probe;
 	drv->remove = blkvsc_remove;
-	drv->driver.shutdown = blkvsc_shutdown;
+	drv->shutdown = blkvsc_shutdown;
 
 	/* The driver belongs to vmbus */
 	ret = vmbus_child_driver_register(&drv->driver);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index e09b363..f95ec2b 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -368,6 +368,7 @@ static int vmbus_remove(struct device *child_device)
 static void vmbus_shutdown(struct device *child_device)
 {
 	struct hv_driver *drv;
+	struct hv_device *dev = device_to_hv_device(child_device);
 
 
 	/* The device may not be attached yet */
@@ -376,9 +377,8 @@ static void vmbus_shutdown(struct device *child_device)
 
 	drv = drv_to_hv_drv(child_device->driver);
 
-	/* Let the specific open-source driver handles the removal if it can */
-	if (drv->driver.shutdown)
-		drv->driver.shutdown(child_device);
+	if (drv->shutdown)
+		drv->shutdown(dev);
 
 	return;
 }
-- 
1.7.4.1

