Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2JUErJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:47:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57040 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2JUErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:47:07 -0400
From: anish kumar <anish198519851985@gmail.com>
To: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] extcon: driver model release call not needed
Date: Sun, 21 Oct 2012 13:46:51 +0900
Message-Id: <1350794811-12388-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

There was a case where free and list_del can be called twice
on the same pointer.So fixed it by re-arranging the code and
removing a function which was not needed.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-class.c |   71 ++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 754f133..347db10 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -544,47 +544,10 @@ static int create_extcon_class(void)
 	return 0;
 }
 
-static void extcon_cleanup(struct extcon_dev *edev, bool skip)
-{
-	mutex_lock(&extcon_dev_list_lock);
-	list_del(&edev->entry);
-	mutex_unlock(&extcon_dev_list_lock);
-
-	if (!skip && get_device(edev->dev)) {
-		int index;
-
-		if (edev->mutually_exclusive && edev->max_supported) {
-			for (index = 0; edev->mutually_exclusive[index];
-			     index++)
-				kfree(edev->d_attrs_muex[index].attr.name);
-			kfree(edev->d_attrs_muex);
-			kfree(edev->attrs_muex);
-		}
-
-		for (index = 0; index < edev->max_supported; index++)
-			kfree(edev->cables[index].attr_g.name);
-
-		if (edev->max_supported) {
-			kfree(edev->extcon_dev_type.groups);
-			kfree(edev->cables);
-		}
-
-#if defined(CONFIG_ANDROID)
-		if (switch_class)
-			class_compat_remove_link(switch_class, edev->dev, NULL);
-#endif
-		device_unregister(edev->dev);
-		put_device(edev->dev);
-	}
-
-	kfree(edev->dev);
-}
-
 static void extcon_dev_release(struct device *dev)
 {
-	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
-
-	extcon_cleanup(edev, true);
+	struct extcon_dev *edev = dev_get_drvdata(dev);
+	kfree(edev->dev);
 }
 
 static const char *muex_name = "mutually_exclusive";
@@ -810,7 +773,35 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
  */
 void extcon_dev_unregister(struct extcon_dev *edev)
 {
-	extcon_cleanup(edev, false);
+	mutex_lock(&extcon_dev_list_lock);
+	list_del(&edev->entry);
+	mutex_unlock(&extcon_dev_list_lock);
+
+	if (get_device(edev->dev) != NULL) {
+		int index;
+		if (edev->mutually_exclusive && edev->max_supported) {
+			for (index = 0; edev->mutually_exclusive[index];
+					index++)
+				kfree(edev->d_attrs_muex[index].attr.name);
+			kfree(edev->d_attrs_muex);
+			kfree(edev->attrs_muex);
+		}
+
+		for (index = 0; index < edev->max_supported; index++)
+			kfree(edev->cables[index].attr_g.name);
+
+		if (edev->max_supported) {
+			kfree(edev->extcon_dev_type.groups);
+			kfree(edev->cables);
+		}
+
+#if defined(CONFIG_ANDROID)
+		if (switch_class)
+			class_compat_remove_link(switch_class, edev->dev, NULL);
+#endif
+		device_unregister(edev->dev);
+		put_device(edev->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
-- 
1.7.1

