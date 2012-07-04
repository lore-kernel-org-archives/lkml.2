Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GDVtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 17:49:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38067 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GDVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 17:48:51 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 2/2] fbcon: move bit_putcs() into separate source file
Date: Wed,  4 Jul 2012 23:48:34 +0200
Message-Id: <1341438514-1786-3-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341438514-1786-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341438514-1786-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to use font-draw-operations in other modules than fbcon, we
need to split this function off of fbcon headers and sources. This also
makes bit_putcs() totally independent of vc_* and fbcon_* structures.

As scr_read() cannot be called inside of non-fbcon/vt functions, we need
to assemble the buffer before passing it to fbdraw_font(). This slows down
this operations a little bit but my rough benchmark showed that it didn't
really matter. Anyway, if it does, we can still put it into VT_BUF_HAVE_RW
conditions so platforms that don't use it won't be affected. And for other
platforms we can add the buffer to the vc-struct so we can reuse it.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/bitblit.c | 127 ++++------------------------------------
 drivers/video/console/fbdraw.c  | 125 +++++++++++++++++++++++++++++++++++++++
 drivers/video/console/fbdraw.h  |   4 ++
 3 files changed, 139 insertions(+), 117 deletions(-)

diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 6ec2905..c5d897b 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -54,132 +54,25 @@ static void bit_clear(struct vc_data *vc, struct fb_info *info, int sy,
 	info->fbops->fb_fillrect(info, &region);
 }
 
-static inline void bit_putcs_aligned(struct vc_data *vc, struct fb_info *info,
-				     const u16 *s, u32 attr, u32 cnt,
-				     u32 d_pitch, u32 s_pitch, u32 cellsize,
-				     struct fb_image *image, u8 *buf, u8 *dst)
-{
-	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
-	u32 idx = vc->vc_font.width >> 3;
-	u8 *src;
-
-	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
-
-		if (attr) {
-			fbdraw_update_attr(buf, src, attr, &vc->vc_font);
-			src = buf;
-		}
-
-		if (likely(idx == 1))
-			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
-						image->height);
-		else
-			fb_pad_aligned_buffer(dst, d_pitch, src, idx,
-					      image->height);
-
-		dst += s_pitch;
-	}
-
-	info->fbops->fb_imageblit(info, image);
-}
-
-static inline void bit_putcs_unaligned(struct vc_data *vc,
-				       struct fb_info *info, const u16 *s,
-				       u32 attr, u32 cnt, u32 d_pitch,
-				       u32 s_pitch, u32 cellsize,
-				       struct fb_image *image, u8 *buf,
-				       u8 *dst)
-{
-	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
-	u32 shift_low = 0, mod = vc->vc_font.width % 8;
-	u32 shift_high = 8;
-	u32 idx = vc->vc_font.width >> 3;
-	u8 *src;
-
-	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
-
-		if (attr) {
-			fbdraw_update_attr(buf, src, attr, &vc->vc_font);
-			src = buf;
-		}
-
-		fb_pad_unaligned_buffer(dst, d_pitch, src, idx,
-					image->height, shift_high,
-					shift_low, mod);
-		shift_low += mod;
-		dst += (shift_low >= 8) ? s_pitch : s_pitch - 1;
-		shift_low &= 7;
-		shift_high = 8 - shift_low;
-	}
-
-	info->fbops->fb_imageblit(info, image);
-
-}
-
 static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      const unsigned short *s, int count, int yy, int xx,
 		      int fg, int bg)
 {
-	struct fb_image image;
-	u32 width = DIV_ROUND_UP(vc->vc_font.width, 8);
-	u32 cellsize = width * vc->vc_font.height;
-	u32 maxcnt = info->pixmap.size/cellsize;
-	u32 scan_align = info->pixmap.scan_align - 1;
-	u32 buf_align = info->pixmap.buf_align - 1;
-	u32 mod = vc->vc_font.width % 8, cnt, pitch, size;
+	u16 *buf;
+	int i;
 	u32 attribute = get_attribute(info, scr_readw(s));
-	u8 *dst, *buf = NULL;
 
-	image.fg_color = fg;
-	image.bg_color = bg;
-	image.dx = xx * vc->vc_font.width;
-	image.dy = yy * vc->vc_font.height;
-	image.height = vc->vc_font.height;
-	image.depth = 1;
+	buf = kmalloc(sizeof(*buf) * count, GFP_KERNEL);
+	if (!buf)
+		return;
 
-	if (attribute) {
-		buf = kmalloc(cellsize, GFP_KERNEL);
-		if (!buf)
-			return;
-	}
-
-	while (count) {
-		if (count > maxcnt)
-			cnt = maxcnt;
-		else
-			cnt = count;
-
-		image.width = vc->vc_font.width * cnt;
-		pitch = DIV_ROUND_UP(image.width, 8) + scan_align;
-		pitch &= ~scan_align;
-		size = pitch * image.height + buf_align;
-		size &= ~buf_align;
-		dst = fb_get_buffer_offset(info, &info->pixmap, size);
-		image.data = dst;
-
-		if (!mod)
-			bit_putcs_aligned(vc, info, s, attribute, cnt, pitch,
-					  width, cellsize, &image, buf, dst);
-		else
-			bit_putcs_unaligned(vc, info, s, attribute, cnt,
-					    pitch, width, cellsize, &image,
-					    buf, dst);
-
-		image.dx += cnt * vc->vc_font.width;
-		count -= cnt;
-		s += cnt;
-	}
+	for (i = 0; i < count; ++i)
+		buf[i] = scr_readw(s++);
 
-	/* buf is always NULL except when in monochrome mode, so in this case
-	   it's a gain to check buf against NULL even though kfree() handles
-	   NULL pointers just fine */
-	if (unlikely(buf))
-		kfree(buf);
+	fbdraw_font(info, &vc->vc_font, vc->vc_hi_font_mask, xx, yy, fg, bg,
+		    attribute, buf, count);
 
+	kfree(buf);
 }
 
 static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
diff --git a/drivers/video/console/fbdraw.c b/drivers/video/console/fbdraw.c
index 65e7003..e2e0661 100644
--- a/drivers/video/console/fbdraw.c
+++ b/drivers/video/console/fbdraw.c
@@ -41,6 +41,131 @@ void fbdraw_update_attr(u8 *dst, const u8 *src, int attribute,
 }
 EXPORT_SYMBOL(fbdraw_update_attr);
 
+static inline void bit_putcs_aligned(struct fb_info *info, bool hi_font,
+				     struct console_font *font, u32 attribute,
+				     u32 d_pitch, u32 s_pitch, u32 cellsize,
+				     struct fb_image *image, u8 *buf, u8 *dst,
+				     const u16 *chars, size_t cnt)
+{
+	u16 charmask = hi_font ? 0x1ff : 0xff;
+	u32 idx = font->width >> 3;
+	u8 *src;
+
+	while (cnt--) {
+		src = font->data + ((*chars++) & charmask) * cellsize;
+
+		if (attribute) {
+			fbdraw_update_attr(buf, src, attribute, font);
+			src = buf;
+		}
+
+		if (likely(idx == 1))
+			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
+						image->height);
+		else
+			fb_pad_aligned_buffer(dst, d_pitch, src, idx,
+					      image->height);
+
+		dst += s_pitch;
+	}
+
+	info->fbops->fb_imageblit(info, image);
+}
+
+static inline void bit_putcs_unaligned(struct fb_info *info, bool hi_font,
+				       struct console_font *font, u32 attribute,
+				       u32 d_pitch, u32 s_pitch, u32 cellsize,
+				       struct fb_image *image, u8 *buf, u8 *dst,
+				       const u16 *chars, size_t cnt)
+{
+	u16 charmask = hi_font ? 0x1ff : 0xff;
+	u32 shift_low = 0, mod = font->width % 8;
+	u32 shift_high = 8;
+	u32 idx = font->width >> 3;
+	u8 *src;
+
+	while (cnt--) {
+		src = font->data + ((*chars++) & charmask) * cellsize;
+
+		if (attribute) {
+			fbdraw_update_attr(buf, src, attribute, font);
+			src = buf;
+		}
+
+		fb_pad_unaligned_buffer(dst, d_pitch, src, idx,
+					image->height, shift_high,
+					shift_low, mod);
+		shift_low += mod;
+		dst += (shift_low >= 8) ? s_pitch : s_pitch - 1;
+		shift_low &= 7;
+		shift_high = 8 - shift_low;
+	}
+
+	info->fbops->fb_imageblit(info, image);
+}
+
+void fbdraw_font(struct fb_info *info, struct console_font *font, bool hi_font,
+		 unsigned int xpos, unsigned int ypos, int fg, int bg,
+		 u32 attribute, const u16 *chars, size_t count)
+{
+	struct fb_image image;
+	u32 width = DIV_ROUND_UP(font->width, 8);
+	u32 cellsize = width * font->height;
+	u32 maxcnt = info->pixmap.size / cellsize;
+	u32 scan_align = info->pixmap.scan_align - 1;
+	u32 buf_align = info->pixmap.buf_align - 1;
+	u32 mod = font->width % 8, cnt, pitch, size;
+	u8 *dst, *buf = NULL;
+
+	image.fg_color = fg;
+	image.bg_color = bg;
+	image.dx = xpos * font->width;
+	image.dy = ypos * font->height;
+	image.height = font->height;
+	image.depth = 1;
+
+	if (attribute) {
+		buf = kmalloc(cellsize, GFP_KERNEL);
+		if (!buf)
+			return;
+	}
+
+	while (count) {
+		if (count > maxcnt)
+			cnt = maxcnt;
+		else
+			cnt = count;
+
+		image.width = font->width * cnt;
+		pitch = DIV_ROUND_UP(image.width, 8) + scan_align;
+		pitch &= ~scan_align;
+		size = pitch * image.height + buf_align;
+		size &= ~buf_align;
+		dst = fb_get_buffer_offset(info, &info->pixmap, size);
+		image.data = dst;
+
+		if (!mod)
+			bit_putcs_aligned(info, hi_font, font, attribute,
+					  pitch, width, cellsize, &image, buf,
+					  dst, chars, cnt);
+		else
+			bit_putcs_unaligned(info, hi_font, font, attribute,
+					    pitch, width, cellsize, &image, buf,
+					    dst, chars, cnt);
+
+		image.dx += cnt * font->width;
+		count -= cnt;
+		chars += cnt;
+	}
+
+	/* buf is always NULL except when in monochrome mode, so in this case
+	   it's a gain to check buf against NULL even though kfree() handles
+	   NULL pointers just fine */
+	if (unlikely(buf))
+		kfree(buf);
+}
+EXPORT_SYMBOL(fbdraw_font);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("David Herrmann <dh.herrmann@googlemail.com>");
 MODULE_DESCRIPTION("Framebuffer helpers for image draw-operations");
diff --git a/drivers/video/console/fbdraw.h b/drivers/video/console/fbdraw.h
index 77edd7f..b9f1ffa 100644
--- a/drivers/video/console/fbdraw.h
+++ b/drivers/video/console/fbdraw.h
@@ -23,4 +23,8 @@
 void fbdraw_update_attr(u8 *dst, const u8 *src, int attribute,
 			struct console_font *font);
 
+void fbdraw_font(struct fb_info *info, struct console_font *font, bool hi_font,
+		 unsigned int xpos, unsigned int ypos, int fg, int bg,
+		 u32 attribute, const u16 *chars, size_t count);
+
 #endif /* _VIDEO_FBDRAW_H */
-- 
1.7.11.1

