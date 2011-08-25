Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1HYQlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:41:02 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60053
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753335Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 12/59] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Date: Thu, 25 Aug 2011 09:48:38 -0700
Message-Id: <1314290965-2698-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now generate appropriate uevent based on the modalias string. As part of this,
cleanup the existing uevent code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   60 ++++++++--------------------------------
 1 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b651968..a6e7dc5 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -237,58 +237,22 @@ static struct device_attribute vmbus_device_attrs[] = {
  * This routine is invoked when a device is added or removed on the vmbus to
  * generate a uevent to udev in the userspace. The udev will then look at its
  * rule and the uevent generated here to load the appropriate driver
+ *
+ * The alias string will be of the form vmbus:guid where guid is the string
+ * representation of the device guid (each byte of the guid will be
+ * represented with two hex characters.
  */
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct hv_device *dev = device_to_hv_device(device);
-	int ret;
-
-	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_type.b[3],
-			     dev->dev_type.b[2],
-			     dev->dev_type.b[1],
-			     dev->dev_type.b[0],
-			     dev->dev_type.b[5],
-			     dev->dev_type.b[4],
-			     dev->dev_type.b[7],
-			     dev->dev_type.b[6],
-			     dev->dev_type.b[8],
-			     dev->dev_type.b[9],
-			     dev->dev_type.b[10],
-			     dev->dev_type.b[11],
-			     dev->dev_type.b[12],
-			     dev->dev_type.b[13],
-			     dev->dev_type.b[14],
-			     dev->dev_type.b[15]);
-
-	if (ret)
-		return ret;
+	int i, ret;
+	char alias_name[((sizeof(struct hv_vmbus_device_id) + 1)) * 2];
 
-	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_instance.b[3],
-			     dev->dev_instance.b[2],
-			     dev->dev_instance.b[1],
-			     dev->dev_instance.b[0],
-			     dev->dev_instance.b[5],
-			     dev->dev_instance.b[4],
-			     dev->dev_instance.b[7],
-			     dev->dev_instance.b[6],
-			     dev->dev_instance.b[8],
-			     dev->dev_instance.b[9],
-			     dev->dev_instance.b[10],
-			     dev->dev_instance.b[11],
-			     dev->dev_instance.b[12],
-			     dev->dev_instance.b[13],
-			     dev->dev_instance.b[14],
-			     dev->dev_instance.b[15]);
-	if (ret)
-		return ret;
+	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
+		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
 
-	return 0;
+	ret = add_uevent_var(env, "MODALIAS=vmbus:%s", alias_name);
+	return ret;
 }
 
 
-- 
1.7.4.1

