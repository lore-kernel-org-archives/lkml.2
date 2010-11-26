Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab0KZFwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 00:52:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59637 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab0KZFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 00:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bzCQaRBrF9Hg2PqIwpPLqDzC6Vb3LX4mOQitnMp2dQy1ZmSNXp7pV6qJZ361QwGwvZ
         RT00IAXhr46Zqq+xHPD0OKAn/ZXRD0se60dlzvbJW+o/IbXtXmJuT7jTmmWx9gkcBwy3
         anh/4CcphJ7hU9OVcUJjyQqFLs/W5/KsRhHgk=
Subject: [PATCH] Kernel fbcon UNICODE font support
From: Microcai <microcaicai@gmail.com>
Reply-To: microcai@fedoraproject.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, brad@neruo.com
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Fri, 26 Nov 2010 13:53:45 +0800
Message-ID: <1290750825.2372.59.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

 I know there are most people speaking only English, and never meet
non-ASCII characters on console. But, hey , what about others ?
 Then, some of you may come up with a idea than ,there is already fbterm
than supports non-ASCII characters in user-space.
 But, what if you forgot to run fbterm ? And what about some program
that must be run on native tty console ? Or I just want init script
display fine Native Language?

 So, here is the solution: Making framebuffer console handle UNICODE font in
kernel.
 The first thing I need to handle is that, currently there is no room
for adding UNICODE font, only 8bit for characters, how can you do?
 Also , some characters are double-width. So the solution is  make an
backing store. 0xFE and 0xFF stands for character value store else
where, and 0xFF means , left-half of the else where character, and 0xFE
means right-half of the else where character. 

 This is a basic solution, the best is that making vc->vc_screenbuf
store full UNICODE/attribute value, But changing it may break some
drivers, so , currently I won't try that way. 

The UNICODE font just too large to be included in e-mail, please follow

http://minilab.tk/0002-add-cjk-font-that-has-65536-chars.patch to get
that.
This font is copyrighted by youbest@sina.com, also he is the original
author of this patch. I don't have a chance to reach him. If there be
any license issue, just re-generated from WenWuanYi(http://wenq.org/)
open-source font. So , this should not be a big deal.

In future, we don't have to compile  that big font into kernel, we
should use setfont to load UNICODE font.
But, .psf does not support that much charcount (or maybe yes, and  I
need some search? ), new font format need to be discussed, or make
setfont using .pcf font that come with X11

So, here is the patch that add UNICODE font handling functionary.

know bugs:

	compile in UNICODE font , then never use setfont unless
	setfont updated to use PCF font. And also this patch
	updated to support that.
	if not , setfont will use non-unicode font replace the in-kernel
	unicode font, that's probably not what you want

>From ae73bb0d2b86ce87f23f56a906cd14b97521e5cd Mon Sep 17 00:00:00 2001
From: microcai <microcaicai@gmail.com>
Date: Fri, 26 Nov 2010 10:39:22 +0800
Subject: [PATCH 1/2] support UNICODE font that has more that 255 chars

Signed-off-by: microcai <microcaicai@gmail.com>

---
 drivers/char/selection.c               |    5 +-
 drivers/char/vt.c                      |  101
++++++++++++++++++++++++++------
 drivers/video/console/bitblit.c        |   57 +++++++++++++++---
 drivers/video/console/fbcon.c          |   70 ++++++++++++++++------
 drivers/video/console/fbcon.h          |    3 +
 drivers/video/console/fbcon_ccw.c      |   32 +++++++++-
 drivers/video/console/fbcon_cw.c       |   29 ++++++++-
 drivers/video/console/fbcon_ud.c       |   42 ++++++++++++-
 drivers/video/console/font_10x18.c     |    1 +
 drivers/video/console/font_6x11.c      |    1 +
 drivers/video/console/font_7x14.c      |    1 +
 drivers/video/console/font_8x16.c      |    1 +
 drivers/video/console/font_8x8.c       |    1 +
 drivers/video/console/font_acorn_8x8.c |    1 +
 drivers/video/console/font_mini_4x6.c  |    1 +
 drivers/video/console/font_pearl_8x8.c |    1 +
 drivers/video/console/font_sun12x22.c  |    1 +
 drivers/video/console/font_sun8x16.c   |    1 +
 include/linux/font.h                   |    1 +
 19 files changed, 290 insertions(+), 60 deletions(-)

diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index ebae344..0654717 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -60,8 +60,7 @@ static inline void highlight_pointer(const int where)
 static u16
 sel_pos(int n)
 {
-	return inverse_translate(sel_cons, screen_glyph(sel_cons, n),
-				use_unicode);
+	return screen_glyph(sel_cons, n);
 }
 
 /* remove the current selection highlight, if any,
@@ -296,6 +295,8 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 			}
 			obp = bp;
 		}
+		if (c > 0x80)
+			i += 2;
 	}
 	sel_buffer_lth = bp - sel_buffer;
 	return 0;
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bf07b26..db254f0 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -288,6 +288,20 @@ static inline unsigned short *screenpos(struct
vc_data *vc, int offset, int view
 	return p;
 }
 
+static inline unsigned short *screenpos_utf8(struct vc_data *vc, int
offset, int viewed)
+{
+	unsigned short *p;
+
+	if (!viewed)
+		p = (unsigned short *)(vc->vc_origin + offset +
vc->vc_screenbuf_size);
+	else if (!vc->vc_sw->con_screen_pos)
+		p = (unsigned short *)(vc->vc_visible_origin + offset +
vc->vc_screenbuf_size);
+	else
+		p = vc->vc_sw->con_screen_pos(vc, -offset - 1);
+	return p;
+}
+ 
+
 /* Called  from the keyboard irq path.. */
 static inline void scrolldelta(int lines)
 {
@@ -318,6 +332,11 @@ static void scrup(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
 	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
+	d += (vc->vc_screenbuf_size >> 1);
+	s += (vc->vc_screenbuf_size >> 1);
+	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, 0,
+		    vc->vc_size_row * nr);
 }
 
 static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b,
int nr)
@@ -335,6 +354,9 @@ static void scrdown(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
 	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
+  	s += (vc->vc_screenbuf_size >> 1);
+  	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
+  	scr_memsetw(s, 0, 2 * step);
 }
 
 static void do_update_region(struct vc_data *vc, unsigned long start,
int count)
@@ -502,6 +524,8 @@ void complement_pos(struct vc_data *vc, int offset)
 	static int old_offset = -1;
 	static unsigned short old;
 	static unsigned short oldx, oldy;
+	static unsigned short *p_ext = NULL;
+	static unsigned short old_ext = 0;
 
 	WARN_CONSOLE_UNLOCKED();
 
@@ -509,7 +533,7 @@ void complement_pos(struct vc_data *vc, int offset)
 	    old_offset < vc->vc_screenbuf_size) {
 		scr_writew(old, screenpos(vc, old_offset, 1));
 		if (DO_UPDATE(vc))
-			vc->vc_sw->con_putc(vc, old, oldy, oldx);
+			vc->vc_sw->con_putc(vc, (old_ext << 16)|old, oldy, oldx);
 	}
 
 	old_offset = offset;
@@ -519,13 +543,15 @@ void complement_pos(struct vc_data *vc, int
offset)
 		unsigned short new;
 		unsigned short *p;
 		p = screenpos(vc, offset, 1);
+		p_ext = screenpos_utf8(vc, offset, 1);
 		old = scr_readw(p);
+		old_ext = scr_readw(p_ext);
 		new = old ^ vc->vc_complement_mask;
 		scr_writew(new, p);
 		if (DO_UPDATE(vc)) {
 			oldx = (offset >> 1) % vc->vc_cols;
 			oldy = (offset >> 1) / vc->vc_cols;
-			vc->vc_sw->con_putc(vc, new, oldy, oldx);
+			vc->vc_sw->con_putc(vc, (old_ext << 16)|new, oldy, oldx);
 		}
 	}
 
@@ -789,7 +815,7 @@ int vc_allocate(unsigned int currcons)	/* return 0
on success */
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
-	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
+	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size * 2, GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
 		kfree(vc);
 		vc_cons[currcons].d = NULL;
@@ -873,7 +899,7 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	newscreen = kmalloc(new_screen_size, GFP_USER);
+	newscreen = kmalloc(new_screen_size * 2, GFP_USER);
 	if (!newscreen)
 		return -ENOMEM;
 
@@ -922,15 +948,23 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 	while (old_origin < end) {
 		scr_memcpyw((unsigned short *) new_origin,
 			    (unsigned short *) old_origin, rlth);
-		if (rrem)
+ 		scr_memcpyw((unsigned short *) new_origin + (new_screen_size >> 1),
+ 			    (unsigned short *) old_origin + (old_screen_size >> 1), rlth);
+		if (rrem){
 			scr_memsetw((void *)(new_origin + rlth),
 				    vc->vc_video_erase_char, rrem);
+ 			scr_memsetw((void *)(new_origin + rlth + (new_screen_size)),
+ 				    vc->vc_video_erase_char, rrem);
+		}
 		old_origin += old_row_size;
 		new_origin += new_row_size;
 	}
-	if (new_scr_end > new_origin)
+	if (new_scr_end > new_origin){
 		scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
 			    new_scr_end - new_origin);
+ 		scr_memsetw((void *)new_origin + (new_screen_size),
vc->vc_video_erase_char,
+ 			    new_scr_end - new_origin);
+	}
 	kfree(vc->vc_screenbuf);
 	vc->vc_screenbuf = newscreen;
 	vc->vc_screenbuf_size = new_screen_size;
@@ -2171,6 +2205,8 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
 		rescan = 0;
 		inverse = 0;
 		width = 1;
+		vc->vc_utf = 1;
+		vc->vc_disp_ctrl = 0;
 
 		/* Do no translation at all in control states */
 		if (vc->vc_state != ESnormal) {
@@ -2238,7 +2274,7 @@ rescan_last_byte:
 				continue;
 			    }
 			}
-			/* Nothing to do if an ASCII byte was received */
+
 		    }
 		    /* End of UTF-8 decoding. */
 		    /* c is the received character, or U+FFFD for invalid sequences.
*/
@@ -2324,10 +2360,30 @@ rescan_last_byte:
 				}
 				if (vc->vc_decim)
 					insert_char(vc, 1);
-				scr_writew(himask ?
-					     ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) +
(tc & 0xff) :
-					     (vc_attr << 8) + tc,
-					   (u16 *) vc->vc_pos);
+
+				if(is_double_width(c) && width==2)
+				{
+					tc = 0xFF;
+					scr_writew(himask ?
+							 ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc
& 0xff) :
+							 (vc_attr << 8) + tc,
+						   (u16 *) vc->vc_pos);
+					scr_writew(c, (u16 *) vc->vc_pos + (vc->vc_screenbuf_size >> 1));
+				}else if(is_double_width(c) && width==1){
+					tc = 0xFE;
+					scr_writew(himask ?
+							 ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc
& 0xff) :
+							 (vc_attr << 8) + tc,
+						   (u16 *) vc->vc_pos);
+					scr_writew(c, (u16 *) vc->vc_pos + (vc->vc_screenbuf_size >> 1));
+				}else{
+					scr_writew(himask ?
+							 ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc
& 0xff) :
+							 (vc_attr << 8) + tc,
+						   (u16 *) vc->vc_pos);
+					scr_writew(c, (u16 *) vc->vc_pos + (vc->vc_screenbuf_size >> 1));
+				}
+
 				if (DO_UPDATE(vc) && draw_x < 0) {
 					draw_x = vc->vc_x;
 					draw_from = vc->vc_pos;
@@ -2344,11 +2400,12 @@ rescan_last_byte:
 
 				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second
column */
 				if (tc < 0) tc = ' ';
-			}
-			notify_write(vc, c);
 
-			if (inverse) {
-				FLUSH
+				notify_write(vc, c);
+
+				if (inverse) {
+					FLUSH
+				}
 			}
 
 			if (rescan) {
@@ -2920,7 +2977,7 @@ static int __init con_init(void)
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
-		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
+		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size * 2, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}
@@ -4142,9 +4199,15 @@ u16 screen_glyph(struct vc_data *vc, int offset)
 	u16 w = scr_readw(screenpos(vc, offset, 1));
 	u16 c = w & 0xff;
 
-	if (w & vc->vc_hi_font_mask)
-		c |= 0x100;
-	return c;
+	u16 c_utf8 = scr_readw(screenpos_utf8(vc, offset, 1));
+
+	if ( (c == 0xff || c == 0xfe) && c_utf8 != 0){
+		return c_utf8;
+	}else{
+		if (w & vc->vc_hi_font_mask)
+			c |= 0x100;
+		return c;
+	}
 }
 EXPORT_SYMBOL_GPL(screen_glyph);
 
diff --git a/drivers/video/console/bitblit.c
b/drivers/video/console/bitblit.c
index 28b1a83..1d15a28 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -10,6 +10,7 @@
  *  more details.
  */
 
+#include <linux/font.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -43,6 +44,21 @@ static void update_attr(u8 *dst, u8 *src, int
attribute,
 	}
 }
 
+static inline u16 utf8_pos(struct vc_data *vc, const unsigned short
*utf8)
+{
+	unsigned long p = (long)utf8;
+	if (p >= vc->vc_origin && p < vc->vc_scr_end) {
+		return scr_readw((unsigned short *)(p + vc->vc_screenbuf_size));
+	} else if (vc->vc_num == fg_console && fbcon_is_softback(utf8)){
+		return scr_readw((unsigned short *)(p + fbcon_softback_size));
+	} else {
+		u16 extra_c;
+		int c = *(int*)utf8;
+		extra_c = (c >> 16 ) & 0x0000ffff;
+		return extra_c;
+	}
+}
+
 static void bit_bmove(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int dy, int dx, int height, int width)
 {
@@ -74,6 +90,34 @@ static void bit_clear(struct vc_data *vc, struct
fb_info *info, int sy,
 	info->fbops->fb_fillrect(info, &region);
 }
 
+u8 * font_bits(struct vc_data *vc, const u16 *s,u32 cellsize,
+					u16 charmask)
+{
+	u32	utf8_c;
+
+	u8 *src = vc->vc_font.data + (scr_readw(s)&
+				  charmask)*cellsize;
+
+	utf8_c = utf8_pos(vc, s);
+
+	if( utf8_c <= vc->vc_font.charcount)
+	{
+		/*
+		 * decide left-half char or right-half char.
+		 * Since non-English chars may double weight
+		 */
+		switch (scr_readw(s) & charmask) {
+			case 0xff:
+				src = vc->vc_font.data + (utf8_c * cellsize *2 );
+				break;
+			case 0xfe:
+				src = vc->vc_font.data + (utf8_c * cellsize *2 + cellsize);
+				break;
+		}
+	}
+	return src;
+}
+
 static inline void bit_putcs_aligned(struct vc_data *vc, struct fb_info
*info,
 				     const u16 *s, u32 attr, u32 cnt,
 				     u32 d_pitch, u32 s_pitch, u32 cellsize,
@@ -84,14 +128,12 @@ static inline void bit_putcs_aligned(struct vc_data
*vc, struct fb_info *info,
 	u8 *src;
 
 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
+		src = font_bits(vc,s++,cellsize,charmask);
 
 		if (attr) {
 			update_attr(buf, src, attr, vc);
 			src = buf;
 		}
-
 		if (likely(idx == 1))
 			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
 						image->height);
@@ -119,14 +161,11 @@ static inline void bit_putcs_unaligned(struct
vc_data *vc,
 	u8 *src;
 
 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
-
+		src = font_bits(vc,s++,cellsize,charmask);
 		if (attr) {
 			update_attr(buf, src, attr, vc);
 			src = buf;
 		}
-
 		fb_pad_unaligned_buffer(dst, d_pitch, src, idx,
 					image->height, shift_high,
 					shift_low, mod);
@@ -246,6 +285,8 @@ static void bit_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 	int err = 1;
 	char *src;
 
+	int cellsize = DIV_ROUND_UP(vc->vc_font.width,8) * vc->vc_font.height;
+
 	cursor.set = 0;
 
 	if (softback_lines) {
@@ -259,7 +300,7 @@ static void bit_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
-	src = vc->vc_font.data + ((c & charmask) * (w * vc->vc_font.height));
+	src = font_bits(vc,(u16*)vc->vc_pos,cellsize,charmask);
 
 	if (ops->cursor_state.image.data != src ||
 	    ops->cursor_reset) {
diff --git a/drivers/video/console/fbcon.c
b/drivers/video/console/fbcon.c
index 7ccc967..04c60f4 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -103,7 +103,8 @@ static int logo_lines;
    enums.  */
 static int logo_shown = FBCON_LOGO_CANSHOW;
 /* Software scrollback */
-static int fbcon_softback_size = 32768;
+/*I need to use it out side fbcon.c */
+int fbcon_softback_size = 32768;
 static unsigned long softback_buf, softback_curr;
 static unsigned long softback_in;
 static unsigned long softback_top, softback_end;
@@ -196,6 +197,14 @@ static void fbcon_start(void);
 static void fbcon_exit(void);
 static struct device *fbcon_device;
 
+int fbcon_is_softback(const unsigned short *str)
+{
+	unsigned long p = (long)str;
+	if(p >= softback_buf && p <softback_end)
+		return 1;
+	return 0;
+}
+
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
 static inline void fbcon_set_rotation(struct fb_info *info)
 {
@@ -965,7 +974,7 @@ static const char *fbcon_startup(void)
 			if (!softback_buf) {
 				softback_buf =
 				    (unsigned long)
-				    kmalloc(fbcon_softback_size,
+				    kmalloc(fbcon_softback_size * 2,
 					    GFP_KERNEL);
 				if (!softback_buf) {
 					fbcon_softback_size = 0;
@@ -995,7 +1004,8 @@ static const char *fbcon_startup(void)
 		vc->vc_font.width = font->width;
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
-		vc->vc_font.charcount = 256; /* FIXME  Need to support more fonts */
+		// read charcount from font_desc, yep, finally fixed
+		vc->vc_font.charcount = font->charcount;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1066,8 +1076,8 @@ static void fbcon_init(struct vc_data *vc, int
init)
 			vc->vc_font.width = font->width;
 			vc->vc_font.height = font->height;
 			vc->vc_font.data = (void *)(p->fontdata = font->data);
-			vc->vc_font.charcount = 256; /* FIXME  Need to
-							support more fonts */
+			// read charcount from font , finnaly fixed
+			vc->vc_font.charcount = font->charcount;
 		}
 	}
 
@@ -1268,10 +1278,7 @@ static void fbcon_putcs(struct vc_data *vc, const
unsigned short *s,
 
 static void fbcon_putc(struct vc_data *vc, int c, int ypos, int xpos)
 {
-	unsigned short chr;
-
-	scr_writew(c, &chr);
-	fbcon_putcs(vc, &chr, 1, ypos, xpos);
+	fbcon_putcs(vc, (unsigned short *)&c, 1, ypos, xpos);
 }
 
 static void fbcon_clear_margins(struct vc_data *vc, int bottom_only)
@@ -1522,6 +1529,7 @@ static __inline__ void ypan_down_redraw(struct
vc_data *vc, int t, int count)
 static void fbcon_redraw_softback(struct vc_data *vc, struct display
*p,
 				  long delta)
 {
+	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
 	int count = vc->vc_rows;
 	unsigned short *d, *s;
 	unsigned long n;
@@ -1584,6 +1592,8 @@ static void fbcon_redraw_softback(struct vc_data
*vc, struct display *p,
 					start = s;
 				}
 			}
+			if( ((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask)
== 0xfe) && scr_readw(s + (vc->vc_screenbuf_size >> 1)) != 0){
+			}else{
 			if (c == scr_readw(d)) {
 				if (s > start) {
 					fbcon_putcs(vc, start, s - start,
@@ -1595,6 +1605,7 @@ static void fbcon_redraw_softback(struct vc_data
*vc, struct display *p,
 					start++;
 				}
 			}
+			}
 			s++;
 			d++;
 		} while (s < le);
@@ -1677,6 +1688,7 @@ static void fbcon_redraw_blit(struct vc_data *vc,
struct fb_info *info,
 			}
 
 			scr_writew(c, d);
+			scr_writew(scr_readw(s + (vc->vc_screenbuf_size >> 1)), d +
(vc->vc_screenbuf_size >> 1));
 			console_conditional_schedule();
 			s++;
 			d++;
@@ -1699,6 +1711,7 @@ static void fbcon_redraw_blit(struct vc_data *vc,
struct fb_info *info,
 static void fbcon_redraw(struct vc_data *vc, struct display *p,
 			 int line, int count, int offset)
 {
+	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
 	unsigned short *d = (unsigned short *)
 	    (vc->vc_origin + vc->vc_size_row * line);
 	unsigned short *s = d + offset;
@@ -1721,18 +1734,22 @@ static void fbcon_redraw(struct vc_data *vc,
struct display *p,
 					start = s;
 				}
 			}
-			if (c == scr_readw(d)) {
-				if (s > start) {
-					fbcon_putcs(vc, start, s - start,
-						     line, x);
-					x += s - start + 1;
-					start = s + 1;
-				} else {
-					x++;
-					start++;
+			if( ((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask)
== 0xfe) && scr_readw(s + (vc->vc_screenbuf_size >> 1)) != 0){
+			}else{
+				if (c == scr_readw(d)) {
+					if (s > start) {
+						fbcon_putcs(vc, start, s - start,
+							     line, x);
+						x += s - start + 1;
+						start = s + 1;
+					} else {
+						x++;
+						start++;
+					}
 				}
 			}
 			scr_writew(c, d);
+			scr_writew(scr_readw(s + (vc->vc_screenbuf_size >> 1)), d +
(vc->vc_screenbuf_size >> 1));
 			console_conditional_schedule();
 			s++;
 			d++;
@@ -1762,6 +1779,7 @@ static inline void fbcon_softback_note(struct
vc_data *vc, int t,
 
 	while (count) {
 		scr_memcpyw((u16 *) softback_in, p, vc->vc_size_row);
+		scr_memcpyw((u16 *) softback_in + (fbcon_softback_size >> 1), p +
(vc->vc_screenbuf_size >> 1), vc->vc_size_row);
 		count--;
 		p = advance_row(p, 1);
 		softback_in += vc->vc_size_row;
@@ -2376,7 +2394,6 @@ static int fbcon_get_font(struct vc_data *vc,
struct console_font *font)
 
 	font->width = vc->vc_font.width;
 	font->height = vc->vc_font.height;
-	font->charcount = vc->vc_hi_font_mask ? 512 : 256;
 	if (!font->data)
 		return 0;
 
@@ -2672,6 +2689,19 @@ static u16 *fbcon_screen_pos(struct vc_data *vc,
int offset)
 	unsigned long p;
 	int line;
 	
+	if (offset < 0) {
+		offset = -offset - 1;
+		if (vc->vc_num != fg_console || !softback_lines)
+			return (u16 *)(vc->vc_origin + offset + (vc->vc_screenbuf_size));
+		line = offset / vc->vc_size_row;
+		if (line >= softback_lines)
+			return (u16 *) (vc->vc_origin + offset - softback_lines *
vc->vc_size_row + (vc->vc_screenbuf_size));
+		p = softback_curr + offset;
+		if (p >= softback_end)
+			p += softback_buf - softback_end;
+		return (u16 *) (p + (fbcon_softback_size));
+	}
+
 	if (vc->vc_num != fg_console || !softback_lines)
 		return (u16 *) (vc->vc_origin + offset);
 	line = offset / vc->vc_size_row;
@@ -2779,6 +2809,8 @@ static int fbcon_scrolldelta(struct vc_data *vc,
int lines)
 					q -= vc->vc_size_row;
 					scr_memcpyw((u16 *) q, (u16 *) p,
 						    vc->vc_size_row);
+					scr_memcpyw((u16 *) (q + (vc->vc_screenbuf_size >> 1)), (u16 *) (p
+ (fbcon_softback_size >> 1)),
+						    vc->vc_size_row);
 				}
 				softback_in = softback_curr = p;
 				update_region(vc, vc->vc_origin,
diff --git a/drivers/video/console/fbcon.h
b/drivers/video/console/fbcon.h
index 6bd2e0c..b41cb0f 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -260,5 +260,8 @@ extern void fbcon_set_rotate(struct fbcon_ops *ops);
 #define fbcon_set_rotate(x) do {} while(0)
 #endif /* CONFIG_FRAMEBUFFER_CONSOLE_ROTATION */
 
+extern int fbcon_softback_size;
+extern int fbcon_is_softback(const unsigned short *str);
+
 #endif /* _VIDEO_FBCON_H */
 
diff --git a/drivers/video/console/fbcon_ccw.c
b/drivers/video/console/fbcon_ccw.c
index 41b32ae..261f55a 100644
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -18,6 +18,8 @@
 #include "fbcon.h"
 #include "fbcon_rotate.h"
 
+extern u8 * font_bits(struct vc_data *vc, const u16 *s,u32 cellsize,
+		u16 charmask);
 /*
  * Rotation 270 degrees
  */
@@ -105,13 +107,23 @@ static inline void ccw_putcs_aligned(struct
vc_data *vc, struct fb_info *info,
 	u32 idx = (vc->vc_font.height + 7) >> 3;
 	u8 *src;
 
-	while (cnt--) {
-		src = ops->fontbuffer + (scr_readw(s--) & charmask)*cellsize;
 
+	while (cnt--) {
+		if(((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask) ==
0xfe )){
+			char dst[16];
+			src = font_bits(vc,s,cellsize,charmask);
+			memset(dst, 0, 16);
+			rotate_ccw(src, dst, vc->vc_font.width,
+				  vc->vc_font.height);
+			src = dst;
+		}else{
+			src = ops->fontbuffer + (scr_readw(s) & charmask)*cellsize;
+		}
 		if (attr) {
 			ccw_update_attr(buf, src, attr, vc);
 			src = buf;
 		}
+		s--;
 
 		if (likely(idx == 1))
 			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
@@ -225,12 +237,14 @@ static void ccw_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
 	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	int c_extra;
 	int w = (vc->vc_font.height + 7) >> 3, c;
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
 	int err = 1, dx, dy;
 	char *src;
 	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	int cellsize = DIV_ROUND_UP(vc->vc_font.width,8) * vc->vc_font.height;
 
 	if (!ops->fontbuffer)
 		return;
@@ -246,9 +260,19 @@ static void ccw_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 			y += softback_lines;
 	}
 
- 	c = scr_readw((u16 *) vc->vc_pos);
+	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
-	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
+
+	if(((c&charmask) == 0xff || (c & charmask) == 0xfe) && c_extra != 0){
+		char dst[16];
+		src = font_bits(vc,s,cellsize,charmask);
+		memset(dst, 0, 16);
+		rotate_ccw(src, dst, vc->vc_font.width,
+			  vc->vc_font.height);
+		src = dst;
+	}else{
+		src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
+	}
 
 	if (ops->cursor_state.image.data != src ||
 	    ops->cursor_reset) {
diff --git a/drivers/video/console/fbcon_cw.c
b/drivers/video/console/fbcon_cw.c
index 6a73782..c15138e 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -18,6 +18,8 @@
 #include "fbcon.h"
 #include "fbcon_rotate.h"
 
+extern u8 * font_bits(struct vc_data *vc, const u16 *s,u32 cellsize,
+		u16 charmask);
 /*
  * Rotation 90 degrees
  */
@@ -90,14 +92,22 @@ static inline void cw_putcs_aligned(struct vc_data
*vc, struct fb_info *info,
 	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
 	u32 idx = (vc->vc_font.height + 7) >> 3;
 	u8 *src;
-
 	while (cnt--) {
-		src = ops->fontbuffer + (scr_readw(s++) & charmask)*cellsize;
-
+		if(((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask) ==
0xfe ) &&  utf8_c != 0){
+			char dst[16];
+			src = font_bits(vc,s,cellsize,charmask);
+			memset(dst, 0, 16);
+			rotate_cw(src, dst, vc->vc_font.width,
+				  vc->vc_font.height);
+			src = dst;
+		}else{
+			src = ops->fontbuffer + (scr_readw(s) & charmask)*cellsize;
+		}
 		if (attr) {
 			cw_update_attr(buf, src, attr, vc);
 			src = buf;
 		}
+		s++;
 
 		if (likely(idx == 1))
 			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
@@ -209,12 +219,14 @@ static void cw_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
 	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	int c_extra;
 	int w = (vc->vc_font.height + 7) >> 3, c;
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
 	int err = 1, dx, dy;
 	char *src;
 	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	int cellsize = DIV_ROUND_UP(vc->vc_font.width,8) * vc->vc_font.height;
 
 	if (!ops->fontbuffer)
 		return;
@@ -232,7 +244,16 @@ static void cw_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
-	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
+	if(((c&charmask) == 0xff || (c & charmask) == 0xfe)){
+		char dst[16];
+		src = font_bits(vc,s,cellsize,charmask);
+		memset(dst, 0, 16);
+		rotate_cw(src, dst, vc->vc_font.width,
+			  vc->vc_font.height);
+		src = dst;
+	}else{
+		src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
+	}
 
 	if (ops->cursor_state.image.data != src ||
 	    ops->cursor_reset) {
diff --git a/drivers/video/console/fbcon_ud.c
b/drivers/video/console/fbcon_ud.c
index ff0872c..ed2022b 100644
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -18,6 +18,8 @@
 #include "fbcon.h"
 #include "fbcon_rotate.h"
 
+extern u8 * font_bits(struct vc_data *vc, const u16 *s,u32 cellsize,
+		u16 charmask);
 /*
  * Rotation 180 degrees
  */
@@ -93,12 +95,22 @@ static inline void ud_putcs_aligned(struct vc_data
*vc, struct fb_info *info,
 	u8 *src;
 
 	while (cnt--) {
-		src = ops->fontbuffer + (scr_readw(s--) & charmask)*cellsize;
 
+		if(((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask) ==
0xfe ) ){
+			char dst[16];
+			src = font_bits(vc,s,cellsize,charmask);
+			memset(dst, 0, 16);
+			rotate_ud(src, dst, vc->vc_font.width,
+				  vc->vc_font.height);
+			src = dst;
+		}else{
+			src = ops->fontbuffer + (scr_readw(s) & charmask)*cellsize;
+		}
 		if (attr) {
 			ud_update_attr(buf, src, attr, vc);
 			src = buf;
 		}
+		s--;
 
 		if (likely(idx == 1))
 			__fb_pad_aligned_buffer(dst, d_pitch, src, idx,
@@ -128,12 +140,21 @@ static inline void ud_putcs_unaligned(struct
vc_data *vc,
 	u8 *src;
 
 	while (cnt--) {
-		src = ops->fontbuffer + (scr_readw(s--) & charmask)*cellsize;
-
+		if(((scr_readw(s) & charmask) == 0xff || (scr_readw(s) & charmask) ==
0xfe )){
+			char dst[16];
+			src = font_bits(vc,s,cellsize,charmask);
+			memset(dst, 0, 16);
+			rotate_ud(src, dst, vc->vc_font.width,
+				  vc->vc_font.height);
+			src = dst;
+		}else{
+			src = ops->fontbuffer + (scr_readw(s) & charmask)*cellsize;
+		}
 		if (attr) {
 			ud_update_attr(buf, src, attr, vc);
 			src = buf;
 		}
+		s--;
 
 		fb_pad_unaligned_buffer(dst, d_pitch, src, idx,
 					image->height, shift_high,
@@ -255,6 +276,7 @@ static void ud_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
 	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	int c_extra;
 	int w = (vc->vc_font.width + 7) >> 3, c;
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
@@ -262,6 +284,7 @@ static void ud_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 	char *src;
 	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	int cellsize = DIV_ROUND_UP(vc->vc_font.width,8) * vc->vc_font.height;
 
 	if (!ops->fontbuffer)
 		return;
@@ -279,7 +302,18 @@ static void ud_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
-	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.height));
+	if(((c&charmask) == 0xff || (c & charmask) == 0xfe) ){
+		char dst[16];
+
+		src = font_bits(vc,s,cellsize,charmask);
+
+		memset(dst, 0, 16);
+		rotate_ud(src, dst, vc->vc_font.width,
+			  vc->vc_font.height);
+		src = dst;
+	}else{
+		src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.height));
+	}
 
 	if (ops->cursor_state.image.data != src ||
 	    ops->cursor_reset) {
diff --git a/drivers/video/console/font_10x18.c
b/drivers/video/console/font_10x18.c
index 6be72bb..8bd2857 100644
--- a/drivers/video/console/font_10x18.c
+++ b/drivers/video/console/font_10x18.c
@@ -5143,4 +5143,5 @@ const struct font_desc font_10x18 = {
 #else
 	.pref	= -1,
 #endif
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_6x11.c
b/drivers/video/console/font_6x11.c
index 46e86e6..0c73fc9 100644
--- a/drivers/video/console/font_6x11.c
+++ b/drivers/video/console/font_6x11.c
@@ -3349,4 +3349,5 @@ const struct font_desc font_vga_6x11 = {
 	.data	= fontdata_6x11,
 	/* Try avoiding this font if possible unless on MAC */
 	.pref	= -2000,
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_7x14.c
b/drivers/video/console/font_7x14.c
index 3b7dbf9..2b7f3f0 100644
--- a/drivers/video/console/font_7x14.c
+++ b/drivers/video/console/font_7x14.c
@@ -4115,4 +4115,5 @@ const struct font_desc font_7x14 = {
 	.height	= 14,
 	.data	= fontdata_7x14,
 	.pref	= 0,
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_8x16.c
b/drivers/video/console/font_8x16.c
index 00a0c67..2826dd2 100644
--- a/drivers/video/console/font_8x16.c
+++ b/drivers/video/console/font_8x16.c
@@ -4629,5 +4629,6 @@ const struct font_desc font_vga_8x16 = {
 	.height	= 16,
 	.data	= fontdata_8x16,
 	.pref	= 0,
+	.charcount = 255,
 };
 EXPORT_SYMBOL(font_vga_8x16);
diff --git a/drivers/video/console/font_8x8.c
b/drivers/video/console/font_8x8.c
index 9f56efe..3d924f3 100644
--- a/drivers/video/console/font_8x8.c
+++ b/drivers/video/console/font_8x8.c
@@ -2580,4 +2580,5 @@ const struct font_desc font_vga_8x8 = {
 	.height	= 8,
 	.data	= fontdata_8x8,
 	.pref	= 0,
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_acorn_8x8.c
b/drivers/video/console/font_acorn_8x8.c
index 639e31a..8c5a0f6 100644
--- a/drivers/video/console/font_acorn_8x8.c
+++ b/drivers/video/console/font_acorn_8x8.c
@@ -272,4 +272,5 @@ const struct font_desc font_acorn_8x8 = {
 #else
 	.pref	= 0,
 #endif
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_mini_4x6.c
b/drivers/video/console/font_mini_4x6.c
index a19a7f3..c6245a6 100644
--- a/drivers/video/console/font_mini_4x6.c
+++ b/drivers/video/console/font_mini_4x6.c
@@ -2154,5 +2154,6 @@ const struct font_desc font_mini_4x6 = {
 	.height	= 6,
 	.data	= fontdata_mini_4x6,
 	.pref	= 3,
+	.charcount = 255,
 };
 
diff --git a/drivers/video/console/font_pearl_8x8.c
b/drivers/video/console/font_pearl_8x8.c
index dc6ad53..a3ae722 100644
--- a/drivers/video/console/font_pearl_8x8.c
+++ b/drivers/video/console/font_pearl_8x8.c
@@ -2584,4 +2584,5 @@ const struct font_desc font_pearl_8x8 = {
 	.height	= 8,
 	.data	= fontdata_pearl8x8,
 	.pref	= 2,
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_sun12x22.c
b/drivers/video/console/font_sun12x22.c
index d364385..e61a98b 100644
--- a/drivers/video/console/font_sun12x22.c
+++ b/drivers/video/console/font_sun12x22.c
@@ -6162,4 +6162,5 @@ const struct font_desc font_sun_12x22 = {
 #else
 	.pref	= -1,
 #endif
+	.charcount = 255,
 };
diff --git a/drivers/video/console/font_sun8x16.c
b/drivers/video/console/font_sun8x16.c
index 5abf290..2151bfb 100644
--- a/drivers/video/console/font_sun8x16.c
+++ b/drivers/video/console/font_sun8x16.c
@@ -272,4 +272,5 @@ const struct font_desc font_sun_8x16 = {
 #else
 	.pref	= -1,
 #endif
+	.charcount = 255,
 };
diff --git a/include/linux/font.h b/include/linux/font.h
index 40a24ab..43676f0 100644
--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -19,6 +19,7 @@ struct font_desc {
     int width, height;
     const void *data;
     int pref;
+    int charcount;
 };
 
 #define VGA8x8_IDX	0
-- 
1.7.3.1






