Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1CGV0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:26:11 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33564
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754991Ab1CGV0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:26:09 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 15/16] Staging: hv: Eliminate device_id from vm_device
Date: Mon,  7 Mar 2011 13:35:30 -0800
Message-Id: <1299533730-22898-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both device abstractions: vm_device and hv_device maintain state
to reperesent the device instance (and they refer to them by different
names - device_id in vm_device and dev_instance in hv_device). 
In preparation for consolidating all device state in
struct hv_device; eliminate device_id from struct vm_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h     |    1 -
 drivers/staging/hv/vmbus_drv.c |   35 ++++++++++++++++-------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index a809f00..ab296bb 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -30,7 +30,6 @@
 
 
 struct vm_device {
-	struct hv_guid device_id;
 	struct hv_device device_obj;
 	struct device device;
 };
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index d9d138d..8193662 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -546,8 +546,6 @@ static int vmbus_bus_init(void)
 	}
 	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
 	dev_set_name(&dev_ctx->device, "vmbus_0_0");
-	memcpy(&dev_ctx->device_id, &dev_ctx->device_obj.dev_instance,
-		sizeof(struct hv_guid));
 
 	/* No need to bind a driver to the root device. */
 	dev_ctx->device.parent = NULL;
@@ -702,7 +700,6 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 	memcpy(&child_device_obj->dev_instance, instance,
 	       sizeof(struct hv_guid));
 
-	memcpy(&child_device_ctx->device_id, instance, sizeof(struct hv_guid));
 
 	return child_device_obj;
 }
@@ -826,22 +823,22 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
 			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     device_ctx->device_id.data[3],
-			     device_ctx->device_id.data[2],
-			     device_ctx->device_id.data[1],
-			     device_ctx->device_id.data[0],
-			     device_ctx->device_id.data[5],
-			     device_ctx->device_id.data[4],
-			     device_ctx->device_id.data[7],
-			     device_ctx->device_id.data[6],
-			     device_ctx->device_id.data[8],
-			     device_ctx->device_id.data[9],
-			     device_ctx->device_id.data[10],
-			     device_ctx->device_id.data[11],
-			     device_ctx->device_id.data[12],
-			     device_ctx->device_id.data[13],
-			     device_ctx->device_id.data[14],
-			     device_ctx->device_id.data[15]);
+			     dev->dev_instance.data[3],
+			     dev->dev_instance.data[2],
+			     dev->dev_instance.data[1],
+			     dev->dev_instance.data[0],
+			     dev->dev_instance.data[5],
+			     dev->dev_instance.data[4],
+			     dev->dev_instance.data[7],
+			     dev->dev_instance.data[6],
+			     dev->dev_instance.data[8],
+			     dev->dev_instance.data[9],
+			     dev->dev_instance.data[10],
+			     dev->dev_instance.data[11],
+			     dev->dev_instance.data[12],
+			     dev->dev_instance.data[13],
+			     dev->dev_instance.data[14],
+			     dev->dev_instance.data[15]);
 	if (ret)
 		return ret;
 
-- 
1.5.5.6

