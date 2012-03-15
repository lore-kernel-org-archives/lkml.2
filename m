Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161629Ab2COVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:32:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab2COVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:32:12 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 1/2] apple_bl: Add register/unregister functions
Date: Thu, 15 Mar 2012 16:32:07 -0500
Message-Id: <1331847128-16339-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331847128-16339-1-git-send-email-seth.forshee@canonical.com>
References: <1331847128-16339-1-git-send-email-seth.forshee@canonical.com>
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
 include/linux/apple_bl.h           |   11 +++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/apple_bl.h

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index be98d15..87332ce 100644
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
 
+atomic_t apple_bl_register_count = ATOMIC_INIT(0);
+
+int apple_bl_register(void)
+{
+	if (atomic_xchg(&apple_bl_register_count, 1) == 0)
+		return acpi_bus_register_driver(&apple_bl_driver);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(apple_bl_register);
+
+void apple_bl_unregister(void)
+{
+	if (atomic_xchg(&apple_bl_register_count, 0) == 1)
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
index 0000000..5c86ae5
--- /dev/null
+++ b/include/linux/apple_bl.h
@@ -0,0 +1,11 @@
+/*
+ * apple_bl exported symbols
+ */
+
+#ifndef _LINUX_APPLE_BL_H
+#define _LINUX_APPLE_BL_H
+
+extern int apple_bl_register(void);
+extern void apple_bl_unregister(void);
+
+#endif
-- 
1.7.9.1

