Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1HYQmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:42:32 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60059
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753341Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 13/59] Staging: hv: vmbus: Support the notion of id tables in vmbus_match()
Date: Thu, 25 Aug 2011 09:48:39 -0700
Message-Id: <1314290965-2698-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce code to handle driver specific id tables to the vmbus core
(vmbus_match). This would allow us to handle more than one device type
with a given driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index a6e7dc5..abcd592 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -255,21 +255,31 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 	return ret;
 }
 
+static uuid_le null_guid;
+
+static inline  bool is_null_guid(const __u8 *guid)
+{
+	if (memcmp(guid, &null_guid, sizeof(uuid_le)))
+		return false;
+	return true;
+}
+
 
 /*
  * vmbus_match - Attempt to match the specified device to the specified driver
  */
 static int vmbus_match(struct device *device, struct device_driver *driver)
 {
-	int match = 0;
 	struct hv_driver *drv = drv_to_hv_drv(driver);
 	struct hv_device *hv_dev = device_to_hv_device(device);
+	const struct hv_vmbus_device_id *id_array = drv->id_table;
 
-	/* We found our driver ? */
-	if (!uuid_le_cmp(hv_dev->dev_type, drv->dev_type))
-		match = 1;
+	for (; !is_null_guid(id_array->guid); id_array++)
+		if (!memcmp(&id_array->guid, &hv_dev->dev_type.b,
+				sizeof(struct hv_vmbus_device_id)))
+			return 1;
 
-	return match;
+	return 0;
 }
 
 /*
-- 
1.7.4.1

