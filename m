Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1CGVZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:25:07 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35620
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754552Ab1CGVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:25:05 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 12/16] Staging: hv: Move probe_failed_work_item from vm_device
Date: Mon,  7 Mar 2011 13:34:27 -0800
Message-Id: <1299533667-22824-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all device related state into
struct hv_device, move probe_failed_work_item from vm_device to
hv_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h     |    1 -
 drivers/staging/hv/vmbus_api.h |    3 +++
 drivers/staging/hv/vmbus_drv.c |    5 +++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index a6be405..a12e9e5 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -30,7 +30,6 @@
 
 
 struct vm_device {
-	struct work_struct probe_failed_work_item;
 	struct hv_guid class_id;
 	struct hv_guid device_id;
 	int probe_error;
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 7f891fb..60e4000 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -26,6 +26,7 @@
 #define _VMBUS_API_H_
 
 #include <linux/device.h>
+#include <linux/workqueue.h>
 
 #define MAX_PAGE_BUFFER_COUNT				16
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -117,6 +118,8 @@ struct hv_device {
 
 	char name[64];
 
+	struct work_struct probe_failed_work_item;
+
 	/* the device type id of this device */
 	struct hv_guid dev_type;
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 9a9e426..36c4ec8 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -904,6 +904,7 @@ static int vmbus_probe(struct device *child_device)
 			drv_to_hv_drv(child_device->driver);
 	struct vm_device *device_ctx =
 			device_to_vm_device(child_device);
+	struct hv_device *dev = &device_ctx->device_obj;
 
 	/* Let the specific open-source driver handles the probe if it can */
 	if (drv->driver.probe) {
@@ -915,9 +916,9 @@ static int vmbus_probe(struct device *child_device)
 				   dev_name(child_device), child_device,
 				   child_device->driver->name, ret);
 
-			INIT_WORK(&device_ctx->probe_failed_work_item,
+			INIT_WORK(&dev->probe_failed_work_item,
 				  vmbus_probe_failed_cb);
-			schedule_work(&device_ctx->probe_failed_work_item);
+			schedule_work(&dev->probe_failed_work_item);
 		}
 	} else {
 		DPRINT_ERR(VMBUS_DRV, "probe() method not set for driver - %s",
-- 
1.5.5.6

