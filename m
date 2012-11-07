Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2KGWIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:08:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2KGWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:08:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: Add of_find_backlight_by_node() function
Date: Wed,  7 Nov 2012 23:08:39 +0100
Message-Id: <1352326119-7301-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:01gRGG52NVl4HGD45lfsDgBQ+3Q4eog3joDyK+n89Sw
 770WXn5GqRIeLwIAwJ+9zaXputgFHPBQcCRTnoc/ESuBPi0XGu
 +DUkHstTAzm8dbDmytKy8myeQZKzXjyKxMRvpcb/OsRWypzVxK
 MO3ZR73tnGpz1TyCUt3XeQ12Zv51JZw9mFQUX0L6AKsZNDMHz2
 +0XNw/h+/Xn6Otq1BHJf9062snmqXGUqR59eyqOnkdhvBSpipA
 kgjsptRhnmEj2FDWRZ8tML1Ymu/9BDFqgRgdCH+ekU6t9Oesdb
 gCrEG1XvohwEEYZXQZonb4ofC+e1EzUhuUn2SR6ZJJYDFNvHTR
 lOGV160N/7IfL+ObeCVPpMTF+nUMTJvEJQd5pZz52GzupGGSCt
 BaS7gtzhOofABj3Chh4OPVzMmaz0+BtnUVekDh1bhJD4cAEzYK
 NRb0z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function finds the struct backlight_device for a given device tree
node. A dummy function is provided so that it safely compiles out if OF
support is disabled.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/video/backlight/backlight.c | 17 +++++++++++++++++
 include/linux/backlight.h           | 10 ++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 297db2f..0d1ed4f 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -370,6 +370,23 @@ void backlight_device_unregister(struct backlight_device *bd)
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
+#if IS_ENABLED(CONFIG_OF)
+static int of_parent_match(struct device *dev, void *data)
+{
+	return dev->parent && dev->parent->of_node == data;
+}
+
+struct backlight_device *of_find_backlight_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = class_find_device(backlight_class, NULL, node, of_parent_match);
+
+	return dev ? to_backlight_device(dev) : NULL;
+}
+EXPORT_SYMBOL(of_find_backlight_by_node);
+#endif
+
 static void __exit backlight_class_exit(void)
 {
 	class_destroy(backlight_class);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 5ffc6dd..11840e9 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -134,4 +134,14 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
+#if IS_ENABLED(CONFIG_OF)
+struct backlight_device *of_find_backlight_by_node(struct device_node *node);
+#else
+static inline struct backlight_device *
+of_find_backlight_by_node(struct device_node *node)
+{
+	return NULL;
+}
+#endif
+
 #endif
-- 
1.8.0

