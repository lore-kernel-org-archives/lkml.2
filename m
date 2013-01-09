Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3AILPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:15:39 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37259 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab3AILPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:15:36 -0500
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] driver core: add helper macro for platform_driver_probe() boilerplate
Date: Wed,  9 Jan 2013 12:15:26 +0100
Message-Id: <1357730128-23018-2-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
References: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simple modules that contain a single platform_driver without any
additional setup code then ends up being a block of duplicated
boilerplate.  This patch adds a new macro,
module_platform_driver_probe(), which replaces the
module_init()/module_exit() registrations with template functions.

This macro use the same idea of module_platform_driver().

This macro is useful to stop the misuse of module_platform_driver() for
removing the platform_driver_probe() boilerplate.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/platform_device.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index a9ded9a..c082c71 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -204,6 +204,24 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
 	module_driver(__platform_driver, platform_driver_register, \
 			platform_driver_unregister)
 
+/* module_platform_driver_probe() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_platform_driver_probe(__platform_driver, __platform_probe) \
+static int __init __platform_driver##_init(void) \
+{ \
+	return platform_driver_probe(&(__platform_driver), \
+				     __platform_probe);    \
+} \
+module_init(__platform_driver##_init); \
+static void __exit __platform_driver##_exit(void) \
+{ \
+	platform_driver_unregister(&(__platform_driver)); \
+} \
+module_exit(__platform_driver##_exit);
+
 extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
 					int (*probe)(struct platform_device *),
 					struct resource *res, unsigned int n_res,
-- 
1.8.0.3

