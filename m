Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1CJWDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:03:06 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43992
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751911Ab1CJWDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:03:05 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/21] Get rid of the forward declaration for vmbus_uevent
Date: Thu, 10 Mar 2011 14:12:40 -0800
Message-Id: <1299795160-1375-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_uevent by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  151 ++++++++++++++++++++--------------------
 1 files changed, 75 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 7b9a2c8..97ebeb4 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -54,7 +54,6 @@ static int vmbus_match(struct device *device, struct device_driver *driver);
 static int vmbus_probe(struct device *device);
 static int vmbus_remove(struct device *device);
 static void vmbus_shutdown(struct device *device);
-static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env);
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
@@ -101,6 +100,81 @@ static struct device_attribute vmbus_device_attrs[] = {
 	__ATTR_NULL
 };
 
+/*
+ * vmbus_uevent - add uevent for our device
+ *
+ * This routine is invoked when a device is added or removed on the vmbus to
+ * generate a uevent to udev in the userspace. The udev will then look at its
+ * rule and the uevent generated here to load the appropriate driver
+ */
+static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
+{
+	struct hv_device *dev = device_to_hv_device(device);
+	int ret;
+
+	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
+		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
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
+
+	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
+			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
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
+
+	if (ret)
+		return ret;
+
+	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
+			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
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
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -649,81 +723,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 }
 
 /*
- * vmbus_uevent - add uevent for our device
- *
- * This routine is invoked when a device is added or removed on the vmbus to
- * generate a uevent to udev in the userspace. The udev will then look at its
- * rule and the uevent generated here to load the appropriate driver
- */
-static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
-{
-	struct hv_device *dev = device_to_hv_device(device);
-	int ret;
-
-	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
-		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    dev->dev_type.data[3], dev->dev_type.data[2],
-		    dev->dev_type.data[1], dev->dev_type.data[0],
-		    dev->dev_type.data[5], dev->dev_type.data[4],
-		    dev->dev_type.data[7], dev->dev_type.data[6],
-		    dev->dev_type.data[8], dev->dev_type.data[9],
-		    dev->dev_type.data[10],
-		    dev->dev_type.data[11],
-		    dev->dev_type.data[12],
-		    dev->dev_type.data[13],
-		    dev->dev_type.data[14],
-		    dev->dev_type.data[15]);
-
-	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_type.data[3],
-			     dev->dev_type.data[2],
-			     dev->dev_type.data[1],
-			     dev->dev_type.data[0],
-			     dev->dev_type.data[5],
-			     dev->dev_type.data[4],
-			     dev->dev_type.data[7],
-			     dev->dev_type.data[6],
-			     dev->dev_type.data[8],
-			     dev->dev_type.data[9],
-			     dev->dev_type.data[10],
-			     dev->dev_type.data[11],
-			     dev->dev_type.data[12],
-			     dev->dev_type.data[13],
-			     dev->dev_type.data[14],
-			     dev->dev_type.data[15]);
-
-	if (ret)
-		return ret;
-
-	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_instance.data[3],
-			     dev->dev_instance.data[2],
-			     dev->dev_instance.data[1],
-			     dev->dev_instance.data[0],
-			     dev->dev_instance.data[5],
-			     dev->dev_instance.data[4],
-			     dev->dev_instance.data[7],
-			     dev->dev_instance.data[6],
-			     dev->dev_instance.data[8],
-			     dev->dev_instance.data[9],
-			     dev->dev_instance.data[10],
-			     dev->dev_instance.data[11],
-			     dev->dev_instance.data[12],
-			     dev->dev_instance.data[13],
-			     dev->dev_instance.data[14],
-			     dev->dev_instance.data[15]);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-/*
  * vmbus_match - Attempt to match the specified device to the specified driver
  */
 static int vmbus_match(struct device *device, struct device_driver *driver)
-- 
1.5.5.6

