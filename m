Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2CPTla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:41:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2CPTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:41:28 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 1/2] apple_bl: Add register/unregister functions
Date: Fri, 16 Mar 2012 14:41:21 -0500
Message-Id: <1331926882-22979-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
References: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to allow other modules to enable or disable apple_bl. This
will be used by the gmux driver to disable apple_bl when the gmux is
present, as it is a better and more reliable option for brightness
control.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/video/backlight/apple_bl.c |   23 +++++++++++++++++++++--
 include/linux/apple_bl.h           |   26 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/apple_bl.h

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index be98d15..a523b25 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/atomic.h>
 
 static struct backlight_device *apple_backlight_device;
 
@@ -221,14 +222,32 @@ static struct acpi_driver apple_bl_driver = {
 	},
 };
 
+static atomic_t apple_bl_registered = ATOMIC_INIT(0);
+
+int apple_bl_register(void)
+{
+	if (atomic_xchg(&apple_bl_registered, 1) == 0)
+		return acpi_bus_register_driver(&apple_bl_driver);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(apple_bl_register);
+
+void apple_bl_unregister(void)
+{
+	if (atomic_xchg(&apple_bl_registered, 0) == 1)
+		acpi_bus_unregister_driver(&apple_bl_driver);
+}
+EXPORT_SYMBOL_GPL(apple_bl_unregister);
+
 static int __init apple_bl_init(void)
 {
-	return acpi_bus_register_driver(&apple_bl_driver);
+	return apple_bl_register();
 }
 
 static void __exit apple_bl_exit(void)
 {
-	acpi_bus_unregister_driver(&apple_bl_driver);
+	apple_bl_unregister();
 }
 
 module_init(apple_bl_init);
diff --git a/include/linux/apple_bl.h b/include/linux/apple_bl.h
new file mode 100644
index 0000000..47bedc0
--- /dev/null
+++ b/include/linux/apple_bl.h
@@ -0,0 +1,26 @@
+/*
+ * apple_bl exported symbols
+ */
+
+#ifndef _LINUX_APPLE_BL_H
+#define _LINUX_APPLE_BL_H
+
+#ifdef CONFIG_BACKLIGHT_APPLE
+
+extern int apple_bl_register(void);
+extern void apple_bl_unregister(void);
+
+#else /* !CONFIG_BACKLIGHT_APPLE */
+
+static inline int apple_bl_register(void)
+{
+	return 0;
+}
+
+static inline void apple_bl_unregister(void)
+{
+}
+
+#endif /* !CONFIG_BACKLIGHT_APPLE */
+
+#endif /* _LINUX_APPLE_BL_H */
-- 
1.7.9.1

