Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2KIOE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:04:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2KIOEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:04:53 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: Add of_find_backlight_by_node() function
Date: Fri,  9 Nov 2012 15:04:38 +0100
Message-Id: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:0CF3TaqZbHuuaA5Of5bNs8B5Ct6Cjc63q4ZfrBMmFFS
 SDj5NzLAuwPiTmMkO4/k3o5FcXjRM4kqnZ02i1MzjR0x27CFI+
 cr1XZaJYvIw7McUlA8ml/KgeDdTpyXfYtNBn0stFiiWu/b1jor
 jNbL4VnXuwYdn7ev3KHHtwteegZy7lrIfviXoR5ugBtgpj4Ae8
 ucWqTHoCTgufq0KqYPuwU1uccuOp0v/Ee0NkJ3jaSOg2oNaT9d
 djlQ4OC2qsf1MPRYCRWcPrE+q0HT/sIM1xO3gdQj43Y80fERi4
 zw2Tw5cKBAoBrFx+zzU3KAqzO7S0XUO/gfdZc5TiARCePJWDrn
 /CLcejudZPxeYyZRAELu51alqoND+TB8a9LdH0wmVPub0Te7m/
 peuRuDyr+HlHUEcnlb/7NVMsIOveAht+Gy8lH+Un1DDJOpHFUn
 dwsh1
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

