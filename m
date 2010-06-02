Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab0FBPJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0FBPJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:09:37 -0400
Date: Wed, 2 Jun 2010 11:09:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix colors for Mach64
Message-ID: <Pine.LNX.4.64.1006021106580.23275@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The maintainer is nonexistent, so sending to Linus.

Mikulas

---

Use the same color-calculating algorithm as in atyfb_imageblit in this driver
or in generic cfb_fillrect.

This patch fixes bad colors when using an accelerator in 15-bit and 16-bit
modes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/video/aty/mach64_accel.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc2-devel/drivers/video/aty/mach64_accel.c
===================================================================
--- linux-2.6.31-rc2-devel.orig/drivers/video/aty/mach64_accel.c	2009-07-07 15:56:15.000000000 +0200
+++ linux-2.6.31-rc2-devel/drivers/video/aty/mach64_accel.c	2009-07-07 16:08:03.000000000 +0200
@@ -242,7 +242,7 @@ void atyfb_copyarea(struct fb_info *info
 void atyfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
-	u32 color = rect->color, dx = rect->dx, width = rect->width, rotation = 0;
+	u32 color, dx = rect->dx, width = rect->width, rotation = 0;
 
 	if (par->asleep)
 		return;
@@ -253,8 +253,11 @@ void atyfb_fillrect(struct fb_info *info
 		return;
 	}
 
-	color |= (rect->color << 8);
-	color |= (rect->color << 16);
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    info->fix.visual == FB_VISUAL_DIRECTCOLOR)
+		color = ((u32 *)(info->pseudo_palette))[rect->color];
+	else
+		color = rect->color;
 
 	if (info->var.bits_per_pixel == 24) {
 		/* In 24 bpp, the engine is in 8 bpp - this requires that all */
