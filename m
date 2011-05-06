Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1EFRZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:25:01 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:60350 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1EFRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:24:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAJQtxE1bdWOb/2dsb2JhbACnQ8QghgkEj1iIOoYc
X-IronPort-AV: E=Sophos;i="4.64,327,1301868000"; 
   d="scan'208";a="361259265"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH] staging: sm7xx: Use kernel framebuffer mode setting
Date: Fri,  6 May 2011 19:24:56 +0200
Message-Id: <1304702696-9403-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements dynamic framebuffer mode setting.

Previous code works with mode setting in a hard code way. Previous hard
code configuration is used as default configuration if dynamic mode
setting or boot mode setting (via sm712vga_setup) is not used.

Tested with SM712 supporting 1024x600x16 as default hardware resolution.

Changes:

- Implement fb_check_var and fb_set_par callbacks
- Remove __maybe_unused decorator in function being used (sm712vga_setup)
- Minor cleanup on initialization structs related with mode settings
- Updated author copyright
- Updated TODO file

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/TODO     |    1 -
 drivers/staging/sm7xx/smtcfb.c |  112 +++++++++++++++++++++++++---------------
 2 files changed, 71 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/sm7xx/TODO b/drivers/staging/sm7xx/TODO
index a66d9e4..9750516 100644
--- a/drivers/staging/sm7xx/TODO
+++ b/drivers/staging/sm7xx/TODO
@@ -4,7 +4,6 @@ TODO:
 - use kernel coding style
 - checkpatch.pl clean
 - refine the code and remove unused code
-- use kernel framebuffer mode setting instead of hard code
 - move it to drivers/video/sm7xx/ or make it be drivers/video/sm7xxfb.c
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 3e2230f..140c148 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -8,6 +8,9 @@
  * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
  *
+ * Copyright (C) 2011 Igalia, S.L.
+ * Author: Javier M. Mellid <jmunhoz@igalia.com>
+ *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive for
  *  more details.
@@ -39,16 +42,16 @@
 #include <linux/pm.h>
 #endif
 
-struct screen_info smtc_screen_info;
-
 #include "smtcfb.h"
 
 #ifdef DEBUG
-#define smdbg(format, arg...)	printk(KERN_DEBUG format , ## arg)
+#define smdbg(format, arg...) printk(KERN_DEBUG format , ## arg)
 #else
 #define smdbg(format, arg...)
 #endif
 
+struct screen_info smtc_screen_info;
+
 /*
 * Private structure
 */
@@ -127,6 +130,29 @@ u16 smtc_ChipIDs[] = {
 
 #define numSMTCchipIDs (sizeof(smtc_ChipIDs) / sizeof(u16))
 
+static struct fb_var_screeninfo smtcfb_var = {
+	.xres           = 1024,
+	.yres           = 600,
+	.xres_virtual   = 1024,
+	.yres_virtual   = 600,
+	.bits_per_pixel = 16,
+	.red            = {16, 8, 0},
+	.green          = {8, 8, 0},
+	.blue           = {0, 8, 0},
+	.activate       = FB_ACTIVATE_NOW,
+	.height         = -1,
+	.width          = -1,
+	.vmode          = FB_VMODE_NONINTERLACED,
+};
+
+static struct fb_fix_screeninfo smtcfb_fix = {
+	.id             = "sm712fb",
+	.type           = FB_TYPE_PACKED_PIXELS,
+	.visual         = FB_VISUAL_TRUECOLOR,
+	.line_length    = 800 * 3,
+	.accel          = FB_ACCEL_SMI_LYNX,
+};
+
 static void sm712_set_timing(struct smtcfb_info *sfb,
 			     struct par_info *ppar_info)
 {
@@ -268,29 +294,6 @@ static void smtc_set_timing(struct smtcfb_info *sfb, struct par_info
 	}
 }
 
-static struct fb_var_screeninfo smtcfb_var = {
-	.xres = 1024,
-	.yres = 600,
-	.xres_virtual = 1024,
-	.yres_virtual = 600,
-	.bits_per_pixel = 16,
-	.red = {16, 8, 0},
-	.green = {8, 8, 0},
-	.blue = {0, 8, 0},
-	.activate = FB_ACTIVATE_NOW,
-	.height = -1,
-	.width = -1,
-	.vmode = FB_VMODE_NONINTERLACED,
-};
-
-static struct fb_fix_screeninfo smtcfb_fix = {
-	.id = "sm712fb",
-	.type = FB_TYPE_PACKED_PIXELS,
-	.visual = FB_VISUAL_TRUECOLOR,
-	.line_length = 800 * 3,
-	.accel = FB_ACCEL_SMI_LYNX,
-};
-
 /* chan_to_field
  *
  * convert a colour value into a field position
@@ -604,20 +607,6 @@ smtcfb_write(struct fb_info *info, const char __user *buf, size_t count,
 }
 #endif	/* ! __BIG_ENDIAN */
 
-static struct fb_ops smtcfb_ops = {
-	.owner = THIS_MODULE,
-	.fb_setcolreg = smtc_setcolreg,
-	.fb_blank = cfb_blank,
-	.fb_fillrect = cfb_fillrect,
-	.fb_imageblit = cfb_imageblit,
-	.fb_copyarea = cfb_copyarea,
-#ifdef __BIG_ENDIAN
-	.fb_read = smtcfb_read,
-	.fb_write = smtcfb_write,
-#endif
-
-};
-
 void smtcfb_setmode(struct smtcfb_info *sfb)
 {
 	switch (sfb->fb.var.bits_per_pixel) {
@@ -676,6 +665,47 @@ void smtcfb_setmode(struct smtcfb_info *sfb)
 	smtc_set_timing(sfb, &hw);
 }
 
+static int smtc_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	/* sanity checks */
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	/* set valid default bpp */
+	if ((var->bits_per_pixel != 8)  && (var->bits_per_pixel != 16) &&
+	    (var->bits_per_pixel != 24) && (var->bits_per_pixel != 32))
+		var->bits_per_pixel = 16;
+
+	return 0;
+}
+
+static int smtc_set_par(struct fb_info *info)
+{
+	struct smtcfb_info *sfb = (struct smtcfb_info *)info;
+
+	smtcfb_setmode(sfb);
+
+	return 0;
+}
+
+static struct fb_ops smtcfb_ops = {
+	.owner        = THIS_MODULE,
+	.fb_check_var = smtc_check_var,
+	.fb_set_par   = smtc_set_par,
+	.fb_setcolreg = smtc_setcolreg,
+	.fb_blank     = cfb_blank,
+	.fb_fillrect  = cfb_fillrect,
+	.fb_imageblit = cfb_imageblit,
+	.fb_copyarea  = cfb_copyarea,
+#ifdef __BIG_ENDIAN
+	.fb_read      = smtcfb_read,
+	.fb_write     = smtcfb_write,
+#endif
+};
+
 /*
  * Alloc struct smtcfb_info and assign the default value
  */
@@ -796,7 +826,7 @@ static void smtc_free_fb_info(struct smtcfb_info *sfb)
  *	Returns zero.
  *
  */
-static int __init __maybe_unused sm712vga_setup(char *options)
+static int __init sm712vga_setup(char *options)
 {
 	int index;
 
-- 
1.7.4.1

