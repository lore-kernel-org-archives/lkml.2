Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab0LaFoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:44:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55711 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0LaFn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZAARBkMnng1rrVfssYPL+/QXBR3G6K3lL6YUhj3qRG/L1eLpvwksH+zDUgJjkofNv8
         EdcX0exDIHsiCBjqYngYT4fCkYGw0hezMwusIHN9OCXOAkT9ytHrES0c2Dg55a3IE46L
         Uy4SFVk9FqxX4R+Ih4NAqwXK34GV45qylp2A0=
From: Brent Cook <busterb@gmail.com>
To: Linux-fbdev-devel@lists.sourceforge.net
Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>, linux-kernel@vger.kernel.org,
        Brent Cook <busterb@gmail.com>
Subject: [PATCH] Fix the HGA framebuffer driver
Date: Thu, 30 Dec 2010 23:43:40 -0600
Message-Id: <1293774220-4423-1-git-send-email-busterb@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resurrected some old hardware and fixed up the hgafb driver to work again. Only
tested with fbcon, since most fbdev-based software appears to only support
12bpp and up. It does not appear that this driver has worked for at least the
entire 2.6.x series, perhaps since 2002.

Signed-off-by: Brent Cook <busterb@gmail.com>

Hercules graphics hardware uses packed pixels horizontally, but rows are not
linear. In other words, the pixels are not packed vertically. This means that
custom imageblit, fillrect and copyarea need to be written specific to the
hardware.

 * Removed the experimental acceleration option, since it is required for the
   hardware to work.
 * Fixed imageblit to work with fb_image's wider than 8 pixels.
 * Updated configuration text (HGA hardware is from 1984)
---
 drivers/video/Kconfig |   14 ++------------
 drivers/video/hgafb.c |   22 +++++++++-------------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 27c1fb4..d6af5a2 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -750,24 +750,14 @@ config FB_N411
 config FB_HGA
 	tristate "Hercules mono graphics support"
 	depends on FB && X86
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
 	help
 	  Say Y here if you have a Hercules mono graphics card.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called hgafb.
 
-	  As this card technology is 15 years old, most people will answer N
-	  here.
-
-config FB_HGA_ACCEL
-	bool "Hercules mono Acceleration functions (EXPERIMENTAL)"
-	depends on FB_HGA && EXPERIMENTAL
-	---help---
-	This will compile the Hercules mono graphics with
-	acceleration functions.
+	  As this card technology is at least 25 years old,
+	  most people will answer N here.
 
 config FB_SGIVW
 	tristate "SGI Visual Workstation framebuffer support"
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index af8f0f2..4052718 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -454,7 +454,6 @@ static int hgafb_blank(int blank_mode, struct fb_info *info)
 /*
  * Accel functions
  */
-#ifdef CONFIG_FB_HGA_ACCEL
 static void hgafb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 {
 	u_int rows, y;
@@ -466,7 +465,7 @@ static void hgafb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 		dest = rowaddr(info, y) + (rect->dx >> 3);
 		switch (rect->rop) {
 		case ROP_COPY:
-			//fb_memset(dest, rect->color, (rect->width >> 3));
+			memset_io(dest, rect->color, (rect->width >> 3));
 			break;
 		case ROP_XOR:
 			fb_writeb(~(fb_readb(dest)), dest);
@@ -488,7 +487,7 @@ static void hgafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 		for (rows = area->height; rows--; ) {
 			src = rowaddr(info, y1) + (area->sx >> 3);
 			dest = rowaddr(info, y2) + (area->dx >> 3);
-			//fb_memmove(dest, src, (area->width >> 3));
+			memmove(dest, src, (area->width >> 3));
 			y1++;
 			y2++;
 		}
@@ -499,7 +498,7 @@ static void hgafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 		for (rows = area->height; rows--;) {
 			src = rowaddr(info, y1) + (area->sx >> 3);
 			dest = rowaddr(info, y2) + (area->dx >> 3);
-			//fb_memmove(dest, src, (area->width >> 3));
+			memmove(dest, src, (area->width >> 3));
 			y1--;
 			y2--;
 		}
@@ -511,20 +510,17 @@ static void hgafb_imageblit(struct fb_info *info, const struct fb_image *image)
 	u8 __iomem *dest;
 	u8 *cdat = (u8 *) image->data;
 	u_int rows, y = image->dy;
+	u_int x;
 	u8 d;
 
 	for (rows = image->height; rows--; y++) {
-		d = *cdat++;
-		dest = rowaddr(info, y) + (image->dx >> 3);
-		fb_writeb(d, dest);
+		for (x = 0; x < image->width; x+= 8) {
+			d = *cdat++;
+			dest = rowaddr(info, y) + ((image->dx + x)>> 3);
+			fb_writeb(d, dest);
+		}
 	}
 }
-#else /* !CONFIG_FB_HGA_ACCEL */
-#define hgafb_fillrect cfb_fillrect
-#define hgafb_copyarea cfb_copyarea
-#define hgafb_imageblit cfb_imageblit
-#endif /* CONFIG_FB_HGA_ACCEL */
-
 
 static struct fb_ops hgafb_ops = {
 	.owner		= THIS_MODULE,
-- 
1.7.2.3

