Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3ABUXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:23:47 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57603 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3ABUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:23:04 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Schandinat <florianschandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-fbdev@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/4] video: vt8500: Make wmt_ge_rops optional
Date: Thu,  3 Jan 2013 09:23:02 +1300
Message-Id: <1357158184-18213-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357158184-18213-1-git-send-email-linux@prisktech.co.nz>
References: <1357158184-18213-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, accelerated raster ops are always enabled on VT8500
and WM8xxx series SoCs. This patch makes them optional.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/Kconfig       |   23 +++++++++++++----------
 drivers/video/vt8500lcdfb.c |   15 +++++++++++++++
 drivers/video/wm8505fb.c    |   15 +++++++++++++++
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index e7068c5..6678daf 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -190,14 +190,6 @@ config FB_SYS_FOPS
        depends on FB
        default n
 
-config FB_WMT_GE_ROPS
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include functions for accelerated rectangle filling and area
-	  copying using WonderMedia Graphics Engine operations.
-
 config FB_DEFERRED_IO
 	bool
 	depends on FB
@@ -1777,7 +1769,8 @@ config FB_AU1200
 config FB_VT8500
 	bool "VT8500 LCD Driver"
 	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_WMT_GE_ROPS
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
 	help
 	  This is the framebuffer driver for VIA VT8500 integrated LCD
@@ -1786,12 +1779,22 @@ config FB_VT8500
 config FB_WM8505
 	bool "WM8505 frame buffer support"
 	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_WMT_GE_ROPS
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
 	help
 	  This is the framebuffer driver for WonderMedia WM8505/WM8650
 	  integrated LCD controller.
 
+config FB_WMT_GE_ROPS
+	bool "VT8500/WM8xxx accelerated raster ops support"
+	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
+	default n
+	help
+	  This adds support for accelerated raster operations on the
+	  VIA VT8500 and Wondermedia 8xxx series SoCs.
+
+
 source "drivers/video/geode/Kconfig"
 
 config FB_HIT
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 9af8da7..e8853ac 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -33,7 +33,10 @@
 #include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "vt8500lcdfb.h"
+
+#ifdef CONFIG_FB_WMT_GE_ROPS
 #include "wmt_ge_rops.h"
+#endif
 
 #ifdef CONFIG_OF
 #include <linux/of.h>
@@ -249,12 +252,24 @@ static int vt8500lcd_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+#ifndef CONFIG_FB_WMT_GE_ROPS
+static int wmt_ge_sync(struct fb_info *p)
+{
+	return 0;
+}
+#endif
+
 static struct fb_ops vt8500lcd_ops = {
 	.owner		= THIS_MODULE,
 	.fb_set_par	= vt8500lcd_set_par,
 	.fb_setcolreg	= vt8500lcd_setcolreg,
+#ifdef CONFIG_FB_WMT_GE_ROPS
 	.fb_fillrect	= wmt_ge_fillrect,
 	.fb_copyarea	= wmt_ge_copyarea,
+#else
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+#endif
 	.fb_imageblit	= sys_imageblit,
 	.fb_sync	= wmt_ge_sync,
 	.fb_ioctl	= vt8500lcd_ioctl,
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 77539c1..a990708 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -35,7 +35,10 @@
 #include <linux/platform_data/video-vt8500lcdfb.h>
 
 #include "wm8505fb_regs.h"
+
+#ifdef CONFIG_FB_WMT_GE_ROPS
 #include "wmt_ge_rops.h"
+#endif
 
 #define DRIVER_NAME "wm8505-fb"
 
@@ -248,12 +251,24 @@ static int wm8505fb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
+#ifndef CONFIG_FB_WMT_GE_ROPS
+static int wmt_ge_sync(struct fb_info *p)
+{
+	return 0;
+}
+#endif
+
 static struct fb_ops wm8505fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_set_par	= wm8505fb_set_par,
 	.fb_setcolreg	= wm8505fb_setcolreg,
+#ifdef CONFIG_FB_WMT_GE_ROPS
 	.fb_fillrect	= wmt_ge_fillrect,
 	.fb_copyarea	= wmt_ge_copyarea,
+#else
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+#endif
 	.fb_imageblit	= sys_imageblit,
 	.fb_sync	= wmt_ge_sync,
 	.fb_pan_display	= wm8505fb_pan_display,
-- 
1.7.9.5

