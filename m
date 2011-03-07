Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1CGVZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:25:52 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56295
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755246Ab1CGVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:25:51 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/16] Staging: hv: Get rid of class_id from vm_device
Date: Mon,  7 Mar 2011 13:35:10 -0800
Message-Id: <1299533710-22876-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both device abstractions: vm_device and hv_device maintain state
to reperesent the device type (and they refer to them by different
names - class_id in vm_device and dev_type in hv_device). 
In preparation for consolidating all device state in
struct hv_device; eliminate class_id from struct vm_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h     |    1 -
 drivers/staging/hv/vmbus_drv.c |   60 +++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index ecd2d2f..a809f00 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -30,7 +30,6 @@
 
 
 struct vm_device {
-	struct hv_guid class_id;
 	struct hv_guid device_id;
 	struct hv_device device_obj;
 	struct device device;
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 0fcf377..d9d138d 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -546,8 +546,6 @@ static int vmbus_bus_init(void)
 	}
 	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
 	dev_set_name(&dev_ctx->device, "vmbus_0_0");
-	memcpy(&dev_ctx->class_id, &dev_ctx->device_obj.dev_type,
-		sizeof(struct hv_guid));
 	memcpy(&dev_ctx->device_id, &dev_ctx->device_obj.dev_instance,
 		sizeof(struct hv_guid));
 
@@ -704,7 +702,6 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 	memcpy(&child_device_obj->dev_instance, instance,
 	       sizeof(struct hv_guid));
 
-	memcpy(&child_device_ctx->class_id, type, sizeof(struct hv_guid));
 	memcpy(&child_device_ctx->device_id, instance, sizeof(struct hv_guid));
 
 	return child_device_obj;
@@ -785,42 +782,43 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct vm_device *device_ctx = device_to_vm_device(device);
+	struct hv_device *dev = &device_ctx->device_obj;
 	int ret;
 
 	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
 		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    device_ctx->class_id.data[3], device_ctx->class_id.data[2],
-		    device_ctx->class_id.data[1], device_ctx->class_id.data[0],
-		    device_ctx->class_id.data[5], device_ctx->class_id.data[4],
-		    device_ctx->class_id.data[7], device_ctx->class_id.data[6],
-		    device_ctx->class_id.data[8], device_ctx->class_id.data[9],
-		    device_ctx->class_id.data[10],
-		    device_ctx->class_id.data[11],
-		    device_ctx->class_id.data[12],
-		    device_ctx->class_id.data[13],
-		    device_ctx->class_id.data[14],
-		    device_ctx->class_id.data[15]);
+		    dev->dev_type.data[3], dev->dev_type.data[2],
+		    dev->dev_type.data[1], dev->dev_type.data[0],
+		    dev->dev_type.data[5], dev->dev_type.data[4],
+		    dev->dev_type.data[7], dev->dev_type.data[6],
+		    dev->dev_type.data[8], dev->dev_type.data[9],
+		    dev->dev_type.data[10],
+		    dev->dev_type.data[11],
+		    dev->dev_type.data[12],
+		    dev->dev_type.data[13],
+		    dev->dev_type.data[14],
+		    dev->dev_type.data[15]);
 
 	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
 			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     device_ctx->class_id.data[3],
-			     device_ctx->class_id.data[2],
-			     device_ctx->class_id.data[1],
-			     device_ctx->class_id.data[0],
-			     device_ctx->class_id.data[5],
-			     device_ctx->class_id.data[4],
-			     device_ctx->class_id.data[7],
-			     device_ctx->class_id.data[6],
-			     device_ctx->class_id.data[8],
-			     device_ctx->class_id.data[9],
-			     device_ctx->class_id.data[10],
-			     device_ctx->class_id.data[11],
-			     device_ctx->class_id.data[12],
-			     device_ctx->class_id.data[13],
-			     device_ctx->class_id.data[14],
-			     device_ctx->class_id.data[15]);
+			     dev->dev_type.data[3],
+			     dev->dev_type.data[2],
+			     dev->dev_type.data[1],
+			     dev->dev_type.data[0],
+			     dev->dev_type.data[5],
+			     dev->dev_type.data[4],
+			     dev->dev_type.data[7],
+			     dev->dev_type.data[6],
+			     dev->dev_type.data[8],
+			     dev->dev_type.data[9],
+			     dev->dev_type.data[10],
+			     dev->dev_type.data[11],
+			     dev->dev_type.data[12],
+			     dev->dev_type.data[13],
+			     dev->dev_type.data[14],
+			     dev->dev_type.data[15]);
 
 	if (ret)
 		return ret;
@@ -860,7 +858,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 	struct vm_device *device_ctx = device_to_vm_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&device_ctx->class_id, &drv->dev_type,
+	if (memcmp(&device_ctx->device_obj.dev_type, &drv->dev_type,
 		   sizeof(struct hv_guid)) == 0) {
 
 		device_ctx->device_obj.drv = drv->priv;
-- 
1.5.5.6

