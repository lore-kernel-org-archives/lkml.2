Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1AXBuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 20:50:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65028 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1AXBuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 20:50:52 -0500
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-kernel@vger.kernel.org
Cc: damm@opensource.se, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/2] platform_device: Add early_platform_add_device_one function
Date: Mon, 24 Jan 2011 10:45:16 +0900
Message-Id: <1295833516-5868-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_platform_add_devices supports only array.
And it is necessary to prepare for array more when user adds one device.

With this patch, user adds early_platform_add_device_one function, which user
can add only one device to, and early_platform_add_devices is changed to use
early_platform_add_device_one.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/base/platform.c         |   30 ++++++++++++++++++++----------
 include/linux/platform_device.h |    1 +
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..0bb2e8b2f 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1108,6 +1108,24 @@ int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 }
 
 /**
+ * early_platform_add_device_one - adds one of early platform device
+ * @pdev: struct of early platform device to add
+ *
+ * Used by early architecture code to register early platform devices and
+ * their platform data.
+ */
+void __init early_platform_add_device_one(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	if (!dev->devres_head.next) {
+		INIT_LIST_HEAD(&dev->devres_head);
+		list_add_tail(&dev->devres_head,
+			      &early_platform_device_list);
+	}
+}
+
+/**
  * early_platform_add_devices - adds a number of early platform devices
  * @devs: array of early platform devices to add
  * @num: number of early platform devices in array
@@ -1117,19 +1135,11 @@ int __init early_platform_driver_register(struct early_platform_driver *epdrv,
  */
 void __init early_platform_add_devices(struct platform_device **devs, int num)
 {
-	struct device *dev;
 	int i;
 
 	/* simply add the devices to list */
-	for (i = 0; i < num; i++) {
-		dev = &devs[i]->dev;
-
-		if (!dev->devres_head.next) {
-			INIT_LIST_HEAD(&dev->devres_head);
-			list_add_tail(&dev->devres_head,
-				      &early_platform_device_list);
-		}
-	}
+	for (i = 0; i < num; i++)
+		early_platform_add_device_one(devs[i]);
 }
 
 /**
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2e700ec..d0f4365 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -156,6 +156,7 @@ struct early_platform_driver {
 
 extern int early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf);
+extern void early_platform_add_device_one(struct platform_device *pdev);
 extern void early_platform_add_devices(struct platform_device **devs, int num);
 
 static inline int is_early_platform_device(struct platform_device *pdev)
-- 
1.7.2.3

