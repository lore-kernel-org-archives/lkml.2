Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab1JERNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:13:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63038 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934481Ab1JERNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:13:37 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: linux-kernel@vger.kernel.org
Cc: kernelnewbies@kernelnewbies.org,
        Himanshu Chauhan <hschauhan@nulltrace.org>
Subject: [PATCH] hwmon class driver registration with a device number
Date: Wed,  5 Oct 2011 22:43:11 +0530
Message-Id: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a way to register a hwmon class driver
with a device number rather than the default MK_DEV(0,0).
This would help in creating required "dev" file under
sysfs which in turn can be used in populating /dev tree
during bootup (helpful to driver which want to show up
a char interface along with sysfs).

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
---
 drivers/hwmon/hwmon.c |   28 ++++++++++++++++++++++------
 include/linux/hwmon.h |    1 +
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index a61e781..36961c5 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -31,15 +31,17 @@ static DEFINE_IDR(hwmon_idr);
 static DEFINE_SPINLOCK(idr_lock);
 
 /**
- * hwmon_device_register - register w/ hwmon
- * @dev: the device to register
+ * hwmon_device_register_numbered - register hwmon class dev
+ * with specific device number.
+ * @dev: Device to register.
+ * @dev_id: device number to register.
  *
- * hwmon_device_unregister() must be called when the device is no
- * longer needed.
+ * hwmon_device_unregister() must be called when the device
+ * is no longer needed.
  *
  * Returns the pointer to the new device.
  */
-struct device *hwmon_device_register(struct device *dev)
+struct device* hwmon_device_register_numbered(struct device *dev, dev_t dev_id)
 {
 	struct device *hwdev;
 	int id, err;
@@ -58,7 +60,7 @@ again:
 		return ERR_PTR(err);
 
 	id = id & MAX_ID_MASK;
-	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
+	hwdev = device_create(hwmon_class, dev, dev_id, NULL,
 			      HWMON_ID_FORMAT, id);
 
 	if (IS_ERR(hwdev)) {
@@ -71,6 +73,20 @@ again:
 }
 
 /**
+ * hwmon_device_register - register w/ hwmon
+ * @dev: the device to register
+ *
+ * hwmon_device_unregister() must be called when the device is no
+ * longer needed.
+ *
+ * Returns the pointer to the new device.
+ */
+struct device *hwmon_device_register(struct device *dev)
+{
+	return hwmon_device_register_numbered(dev, MK_DEV(0,0));
+}
+
+/**
  * hwmon_device_unregister - removes the previously registered class device
  *
  * @dev: the class device to destroy
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 6b6ee70..d816cbe 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 
+struct device *hwmon_device_register_numbered(struct device *dev, dev_t dev_id);
 struct device *hwmon_device_register(struct device *dev);
 
 void hwmon_device_unregister(struct device *dev);
-- 
1.7.4.1

