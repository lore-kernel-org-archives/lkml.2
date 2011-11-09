Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679Ab1KJD0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934664Ab1KJD0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:12 2011
Message-Id: <20111109212712.408415160@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [117/262] viafb: improve pitch handling
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

commit 936a3f770b8de7042d793272f008ef1bb08522e9 upstream.

This patch adds checks for minimum and maximum pitch size to prevent
invalid settings which could otherwise crash the machine. Also the
alignment is done in a slightly more readable way.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/via/via_modesetting.h |    5 +++++
 drivers/video/via/viafbdev.c        |   11 ++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/video/via/via_modesetting.h
+++ b/drivers/video/via/via_modesetting.h
@@ -28,6 +28,11 @@
 
 #include <linux/types.h>
 
+
+#define VIA_PITCH_SIZE	(1<<3)
+#define VIA_PITCH_MAX	0x3FF8
+
+
 void via_set_primary_address(u32 addr);
 void via_set_secondary_address(u32 addr);
 void via_set_primary_pitch(u32 pitch);
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -151,7 +151,8 @@ static void viafb_update_fix(struct fb_i
 
 	info->fix.visual =
 		bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	info->fix.line_length = (info->var.xres_virtual * bpp / 8 + 7) & ~7;
+	info->fix.line_length = ALIGN(info->var.xres_virtual * bpp / 8,
+		VIA_PITCH_SIZE);
 }
 
 static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
@@ -238,8 +239,12 @@ static int viafb_check_var(struct fb_var
 		depth = 24;
 
 	viafb_fill_var_color_info(var, depth);
-	line = (var->xres_virtual * var->bits_per_pixel / 8 + 7) & ~7;
-	if (line * var->yres_virtual > ppar->memsize)
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+
+	line = ALIGN(var->xres_virtual * var->bits_per_pixel / 8,
+		VIA_PITCH_SIZE);
+	if (line > VIA_PITCH_MAX || line * var->yres_virtual > ppar->memsize)
 		return -EINVAL;
 
 	/* Based on var passed in to calculate the refresh,


