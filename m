Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1CGVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:25:28 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36039
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756159Ab1CGVZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:25:26 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/16] Staging: hv: Remove probe_error from vm_device
Date: Mon,  7 Mar 2011 13:34:48 -0800
Message-Id: <1299533688-22849-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all device related state into
struct hv_device, move probe_error from vm_device to
hv_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h     |    1 -
 drivers/staging/hv/vmbus_api.h |    2 ++
 drivers/staging/hv/vmbus_drv.c |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index a12e9e5..ecd2d2f 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -32,7 +32,6 @@
 struct vm_device {
 	struct hv_guid class_id;
 	struct hv_guid device_id;
-	int probe_error;
 	struct hv_device device_obj;
 	struct device device;
 };
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 60e4000..4c5a38e 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -120,6 +120,8 @@ struct hv_device {
 
 	struct work_struct probe_failed_work_item;
 
+	int probe_error;
+
 	/* the device type id of this device */
 	struct hv_guid dev_type;
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 36c4ec8..0fcf377 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -742,7 +742,7 @@ int vmbus_child_device_register(struct hv_device *root_device_obj,
 	ret = device_register(&child_device_ctx->device);
 
 	/* vmbus_probe() error does not get propergate to device_register(). */
-	ret = child_device_ctx->probe_error;
+	ret = child_device_ctx->device_obj.probe_error;
 
 	if (ret)
 		DPRINT_ERR(VMBUS_DRV, "unable to register child device (%p)",
@@ -908,7 +908,7 @@ static int vmbus_probe(struct device *child_device)
 
 	/* Let the specific open-source driver handles the probe if it can */
 	if (drv->driver.probe) {
-		ret = device_ctx->probe_error =
+		ret = device_ctx->device_obj.probe_error =
 		drv->driver.probe(child_device);
 		if (ret != 0) {
 			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
-- 
1.5.5.6

