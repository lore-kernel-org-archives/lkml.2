Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0EZHC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:02:26 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:46972 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0EZHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=szI+Mkw44V2TxAsRFo2Im3kx/tYrQVZ0koEsqdX8Hd6sw9hkaMZapSzQ/9UyMq6PdG
         jpxmFOjxt0zzDoLMA+2RDR/pgT16GrdQuf/nsqCWNo7wvAwmsZobJaA3j5G65C1qBmDI
         gCFHXLgUC/KL2YQs4x8a9yHyX3ESU5w7uiPC8=
MIME-Version: 1.0
In-Reply-To: <AANLkTilpVGUQFvQr7iuK41Te9wtvRuMxLjbIlMpTrndt@mail.gmail.com>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 
	<AANLkTilpVGUQFvQr7iuK41Te9wtvRuMxLjbIlMpTrndt@mail.gmail.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 26 May 2010 15:02:04 +0800
Message-ID: <AANLkTikkizcpec9lJ1vT0-0tcKUcFJjemLaXOIErg7BZ@mail.gmail.com>
Subject: [PATCH 2/2] Enlarge the storage of chars in virtual terminal
To: Alan Cox <alan@linux.intel.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change fbcon to fit the new virtual terminal.

Signed-off-by: Frank Pan <frankpzh@gmail.com>
---
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index af88651..5534c4f 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -61,7 +61,7 @@ static void bit_bmove(struct vc_data *vc, struct
fb_info *info, int sy,
 static void bit_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int height, int width)
 {
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
+	int bgshift = vc->vc_hi_font_mask ? 5 : 4;
 	struct fb_fillrect region;

 	region.color = attr_bgcol_ec(bgshift, vc, info);
@@ -75,17 +75,19 @@ static void bit_clear(struct vc_data *vc, struct
fb_info *info, int sy,
 }

 static inline void bit_putcs_aligned(struct vc_data *vc, struct fb_info *info,
-				     const u16 *s, u32 attr, u32 cnt,
+				     const u32 *s, u32 attr, u32 cnt,
 				     u32 d_pitch, u32 s_pitch, u32 cellsize,
 				     struct fb_image *image, u8 *buf, u8 *dst)
 {
-	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	u32 ch;
 	u32 idx = vc->vc_font.width >> 3;
 	u8 *src;

 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
+		ch = scr_readw(s++) & ~VT_BUF_ATTR_MASK;
+		if (ch >= vc->vc_font.charcount)
+			ch = vc->vc_font.charcount - 1;
+		src = vc->vc_font.data + ch * cellsize;

 		if (attr) {
 			update_attr(buf, src, attr, vc);
@@ -106,21 +108,23 @@ static inline void bit_putcs_aligned(struct
vc_data *vc, struct fb_info *info,
 }

 static inline void bit_putcs_unaligned(struct vc_data *vc,
-				       struct fb_info *info, const u16 *s,
+				       struct fb_info *info, const u32 *s,
 				       u32 attr, u32 cnt, u32 d_pitch,
 				       u32 s_pitch, u32 cellsize,
 				       struct fb_image *image, u8 *buf,
 				       u8 *dst)
 {
-	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	u32 ch;
 	u32 shift_low = 0, mod = vc->vc_font.width % 8;
 	u32 shift_high = 8;
 	u32 idx = vc->vc_font.width >> 3;
 	u8 *src;

 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
+		ch = scr_readw(s++) & ~VT_BUF_ATTR_MASK;
+		if (ch >= vc->vc_font.charcount)
+			ch = vc->vc_font.charcount - 1;
+		src = vc->vc_font.data + ch * cellsize;

 		if (attr) {
 			update_attr(buf, src, attr, vc);
@@ -141,7 +145,7 @@ static inline void bit_putcs_unaligned(struct vc_data *vc,
 }

 static void bit_putcs(struct vc_data *vc, struct fb_info *info,
-		      const unsigned short *s, int count, int yy, int xx,
+		      const u32 *s, int count, int yy, int xx,
 		      int fg, int bg)
 {
 	struct fb_image image;
@@ -205,7 +209,7 @@ static void bit_putcs(struct vc_data *vc, struct
fb_info *info,
 static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only)
 {
-	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
+	int bgshift = vc->vc_hi_font_mask ? 5 : 4;
 	unsigned int cw = vc->vc_font.width;
 	unsigned int ch = vc->vc_font.height;
 	unsigned int rw = info->var.xres - (vc->vc_cols*cw);
@@ -239,12 +243,13 @@ static void bit_cursor(struct vc_data *vc,
struct fb_info *info, int mode,
 {
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
-	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
-	int w = DIV_ROUND_UP(vc->vc_font.width, 8), c;
+	u32 charmask = ~VT_BUF_ATTR_MASK;
+	int w = DIV_ROUND_UP(vc->vc_font.width, 8);
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
 	int err = 1;
 	char *src;
+	u32 c;

 	cursor.set = 0;

@@ -257,7 +262,7 @@ static void bit_cursor(struct vc_data *vc, struct
fb_info *info, int mode,
 			y += softback_lines;
 	}

- 	c = scr_readw((u16 *) vc->vc_pos);
+ 	c = scr_readw((u32 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = vc->vc_font.data + ((c & charmask) * (w * vc->vc_font.height));

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b0a3fa0..e51de79 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -143,7 +143,7 @@ static const struct consw fb_con;

 #define CM_SOFTBACK	(8)

-#define advance_row(p, delta) (unsigned short *)((unsigned long)(p) +
(delta) * vc->vc_size_row)
+#define advance_row(p, delta) (u32 *)((unsigned long)(p) + (delta) *
vc->vc_size_row)

 static int fbcon_set_origin(struct vc_data *);

@@ -163,8 +163,8 @@ static void fbcon_init(struct vc_data *vc, int init);
 static void fbcon_deinit(struct vc_data *vc);
 static void fbcon_clear(struct vc_data *vc, int sy, int sx, int height,
 			int width);
-static void fbcon_putc(struct vc_data *vc, int c, int ypos, int xpos);
-static void fbcon_putcs(struct vc_data *vc, const unsigned short *s,
+static void fbcon_putc(struct vc_data *vc, u32 c, int ypos, int xpos);
+static void fbcon_putcs(struct vc_data *vc, const u32 *s,
 			int count, int ypos, int xpos);
 static void fbcon_clear_margins(struct vc_data *vc, int bottom_only);
 static void fbcon_cursor(struct vc_data *vc, int mode);
@@ -287,20 +287,20 @@ static inline int fbcon_is_inactive(struct
vc_data *vc, struct fb_info *info)
 }

 static inline int get_color(struct vc_data *vc, struct fb_info *info,
-	      u16 c, int is_fg)
+	      u32 c, int is_fg)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
 	int color = 0;

 	if (console_blanked) {
-		unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+		u32 charmask = ~VT_BUF_ATTR_MASK;

 		c = vc->vc_video_erase_char & charmask;
 	}

 	if (depth != 1)
-		color = (is_fg) ? attr_fgcol((vc->vc_hi_font_mask) ? 9 : 8, c)
-			: attr_bgcol((vc->vc_hi_font_mask) ? 13 : 12, c);
+		color = is_fg ? attr_fgcol((vc->vc_hi_font_mask == 0x100) ? 1 : 0, c)
+			: attr_bgcol((vc->vc_hi_font_mask == 0x100) ? 5 : 4, c);

 	switch (depth) {
 	case 1:
@@ -371,7 +371,7 @@ static void fb_flashcursor(struct work_struct *work)
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p;
 	struct vc_data *vc = NULL;
-	int c;
+	u32 c;
 	int mode;

 	acquire_console_sem();
@@ -386,7 +386,7 @@ static void fb_flashcursor(struct work_struct *work)
 	}

 	p = &fb_display[vc->vc_num];
-	c = scr_readw((u16 *) vc->vc_pos);
+	c = scr_readw((u32 *) vc->vc_pos);
 	mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
 		CM_ERASE : CM_DRAW;
 	ops->cursor(vc, info, mode, softback_lines, get_color(vc, info, c, 1),
@@ -565,7 +565,7 @@ static void fbcon_prepare_logo(struct vc_data *vc,
struct fb_info *info,
 	/* Need to make room for the logo */
 	struct fbcon_ops *ops = info->fbcon_par;
 	int cnt, erase = vc->vc_video_erase_char, step;
-	unsigned short *save = NULL, *r, *q;
+	u32 *save = NULL, *r, *q;
 	int logo_height;

 	if (info->flags & FBINFO_MODULE) {
@@ -581,20 +581,20 @@ static void fbcon_prepare_logo(struct vc_data
*vc, struct fb_info *info,
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, ops->rotate);
 	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
-	q = (unsigned short *) (vc->vc_origin +
+	q = (u32 *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
 	for (r = q - logo_lines * cols; r < q; r++)
 		if (scr_readw(r) != vc->vc_video_erase_char)
 			break;
 	if (r != q && new_rows >= rows + logo_lines) {
-		save = kmalloc(logo_lines * new_cols * 2, GFP_KERNEL);
+		save = kmalloc(logo_lines * new_cols * 4, GFP_KERNEL);
 		if (save) {
 			int i = cols < new_cols ? cols : new_cols;
-			scr_memsetw(save, erase, logo_lines * new_cols * 2);
+			scr_memsetw(save, erase, logo_lines * new_cols * 4);
 			r = q - step;
 			for (cnt = 0; cnt < logo_lines; cnt++, r += i)
-				scr_memcpyw(save + cnt * new_cols, r, 2 * i);
+				scr_memcpyw(save + cnt * new_cols, r, 4 * i);
 			r = q;
 		}
 	}
@@ -615,7 +615,7 @@ static void fbcon_prepare_logo(struct vc_data *vc,
struct fb_info *info,
 			vc->vc_pos += lines * vc->vc_size_row;
 		}
 	}
-	scr_memsetw((unsigned short *) vc->vc_origin,
+	scr_memsetw((u32 *) vc->vc_origin,
 		    erase,
 		    vc->vc_size_row * logo_lines);

@@ -625,10 +625,10 @@ static void fbcon_prepare_logo(struct vc_data
*vc, struct fb_info *info,
 	}

 	if (save) {
-		q = (unsigned short *) (vc->vc_origin +
+		q = (u32 *) (vc->vc_origin +
 					vc->vc_size_row *
 					rows);
-		scr_memcpyw(q, save, logo_lines * new_cols * 2);
+		scr_memcpyw(q, save, logo_lines * new_cols * 4);
 		vc->vc_y += logo_lines;
 		vc->vc_pos += logo_lines * vc->vc_size_row;
 		kfree(save);
@@ -1050,6 +1050,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 						    fvc->vc_font.data);
 			vc->vc_font.width = fvc->vc_font.width;
 			vc->vc_font.height = fvc->vc_font.height;
+			vc->vc_font.charcount = fvc->vc_font.charcount;
 			p->userfont = t->userfont;

 			if (p->userfont)
@@ -1074,7 +1075,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		charcnt = FNTCHARCNT(p->fontdata);

 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
-	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
+	vc->vc_complement_mask = (vc->vc_can_do_color ? 0x77 : 0x08) <<
VT_BUF_ATTR_SHIFT;
 	if (charcnt == 256) {
 		vc->vc_hi_font_mask = 0;
 	} else {
@@ -1251,7 +1252,8 @@ static void fbcon_clear(struct vc_data *vc, int
sy, int sx, int height,
 		ops->clear(vc, info, real_y(p, sy), sx, height, width);
 }

-static void fbcon_putcs(struct vc_data *vc, const unsigned short *s,
+
+static void fbcon_putcs(struct vc_data *vc, const u32 *s,
 			int count, int ypos, int xpos)
 {
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
@@ -1264,9 +1266,9 @@ static void fbcon_putcs(struct vc_data *vc,
const unsigned short *s,
 			   get_color(vc, info, scr_readw(s), 0));
 }

-static void fbcon_putc(struct vc_data *vc, int c, int ypos, int xpos)
+static void fbcon_putc(struct vc_data *vc, u32 c, int ypos, int xpos)
 {
-	unsigned short chr;
+	u32 chr;

 	scr_writew(c, &chr);
 	fbcon_putcs(vc, &chr, 1, ypos, xpos);
@@ -1286,7 +1288,7 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 	int y;
- 	int c = scr_readw((u16 *) vc->vc_pos);
+ 	u32 c = scr_readw((u32 *) vc->vc_pos);

 	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
@@ -1342,6 +1344,7 @@ static void fbcon_set_disp(struct fb_info *info,
struct fb_var_screeninfo *var,
 		vc->vc_font.data = (void *)(p->fontdata = t->fontdata);
 		vc->vc_font.width = (*default_mode)->vc_font.width;
 		vc->vc_font.height = (*default_mode)->vc_font.height;
+		vc->vc_font.charcount = (*default_mode)->vc_font.charcount;
 		p->userfont = t->userfont;
 		if (p->userfont)
 			REFCOUNT(p->fontdata)++;
@@ -1356,7 +1359,7 @@ static void fbcon_set_disp(struct fb_info *info,
struct fb_var_screeninfo *var,
 	fb_set_var(info, var);
 	ops->var = info->var;
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
-	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
+	vc->vc_complement_mask = (vc->vc_can_do_color ? 0x77 : 0x08) <<
VT_BUF_ATTR_SHIFT;
 	if (charcnt == 256) {
 		vc->vc_hi_font_mask = 0;
 	} else {
@@ -1521,13 +1524,13 @@ static void fbcon_redraw_softback(struct
vc_data *vc, struct display *p,
 				  long delta)
 {
 	int count = vc->vc_rows;
-	unsigned short *d, *s;
+	u32 *d, *s;
 	unsigned long n;
 	int line = 0;

-	d = (u16 *) softback_curr;
-	if (d == (u16 *) softback_in)
-		d = (u16 *) vc->vc_origin;
+	d = (u32 *) softback_curr;
+	if (d == (u32 *) softback_in)
+		d = (u32 *) vc->vc_origin;
 	n = softback_curr + delta * vc->vc_size_row;
 	softback_lines -= delta;
 	if (delta < 0) {
@@ -1559,22 +1562,22 @@ static void fbcon_redraw_softback(struct
vc_data *vc, struct display *p,
 	if (n == softback_curr)
 		return;
 	softback_curr = n;
-	s = (u16 *) softback_curr;
-	if (s == (u16 *) softback_in)
-		s = (u16 *) vc->vc_origin;
+	s = (u32 *) softback_curr;
+	if (s == (u32 *) softback_in)
+		s = (u32 *) vc->vc_origin;
 	while (count--) {
-		unsigned short *start;
-		unsigned short *le;
-		unsigned short c;
+		u32 *start;
+		u32 *le;
+		u32 c;
 		int x = 0;
-		unsigned short attr = 1;
+		u32 attr = 1;

 		start = s;
 		le = advance_row(s, 1);
 		do {
 			c = scr_readw(s);
-			if (attr != (c & 0xff00)) {
-				attr = c & 0xff00;
+			if (attr != (c & VT_BUF_ATTR_MASK)) {
+				attr = c & VT_BUF_ATTR_MASK;
 				if (s > start) {
 					fbcon_putcs(vc, start, s - start,
 						    line, x);
@@ -1599,34 +1602,33 @@ static void fbcon_redraw_softback(struct
vc_data *vc, struct display *p,
 		if (s > start)
 			fbcon_putcs(vc, start, s - start, line, x);
 		line++;
-		if (d == (u16 *) softback_end)
-			d = (u16 *) softback_buf;
-		if (d == (u16 *) softback_in)
-			d = (u16 *) vc->vc_origin;
-		if (s == (u16 *) softback_end)
-			s = (u16 *) softback_buf;
-		if (s == (u16 *) softback_in)
-			s = (u16 *) vc->vc_origin;
+		if (d == (u32 *) softback_end)
+			d = (u32 *) softback_buf;
+		if (d == (u32 *) softback_in)
+			d = (u32 *) vc->vc_origin;
+		if (s == (u32 *) softback_end)
+			s = (u32 *) softback_buf;
+		if (s == (u32 *) softback_in)
+			s = (u32 *) vc->vc_origin;
 	}
 }

 static void fbcon_redraw_move(struct vc_data *vc, struct display *p,
 			      int line, int count, int dy)
 {
-	unsigned short *s = (unsigned short *)
-		(vc->vc_origin + vc->vc_size_row * line);
+	u32 *s = (u32 *)(vc->vc_origin + vc->vc_size_row * line);

 	while (count--) {
-		unsigned short *start = s;
-		unsigned short *le = advance_row(s, 1);
-		unsigned short c;
+		u32 *start = s;
+		u32 *le = advance_row(s, 1);
+		u32 c;
 		int x = 0;
-		unsigned short attr = 1;
+		u32 attr = 1;

 		do {
 			c = scr_readw(s);
-			if (attr != (c & 0xff00)) {
-				attr = c & 0xff00;
+			if (attr != (c & VT_BUF_ATTR_MASK)) {
+				attr = c & VT_BUF_ATTR_MASK;
 				if (s > start) {
 					fbcon_putcs(vc, start, s - start,
 						    dy, x);
@@ -1648,15 +1650,14 @@ static void fbcon_redraw_blit(struct vc_data
*vc, struct fb_info *info,
 			struct display *p, int line, int count, int ycount)
 {
 	int offset = ycount * vc->vc_cols;
-	unsigned short *d = (unsigned short *)
-	    (vc->vc_origin + vc->vc_size_row * line);
-	unsigned short *s = d + offset;
+	u32 *d = (u32 *)(vc->vc_origin + vc->vc_size_row * line);
+	u32 *s = d + offset;
 	struct fbcon_ops *ops = info->fbcon_par;

 	while (count--) {
-		unsigned short *start = s;
-		unsigned short *le = advance_row(s, 1);
-		unsigned short c;
+		u32 *start = s;
+		u32 *le = advance_row(s, 1);
+		u32 c;
 		int x = 0;

 		do {
@@ -1697,21 +1698,20 @@ static void fbcon_redraw_blit(struct vc_data
*vc, struct fb_info *info,
 static void fbcon_redraw(struct vc_data *vc, struct display *p,
 			 int line, int count, int offset)
 {
-	unsigned short *d = (unsigned short *)
-	    (vc->vc_origin + vc->vc_size_row * line);
-	unsigned short *s = d + offset;
+	u32 *d = (u32 *)(vc->vc_origin + vc->vc_size_row * line);
+	u32 *s = d + offset;

 	while (count--) {
-		unsigned short *start = s;
-		unsigned short *le = advance_row(s, 1);
-		unsigned short c;
+		u32 *start = s;
+		u32 *le = advance_row(s, 1);
+		u32 c;
 		int x = 0;
-		unsigned short attr = 1;
+		u32 attr = 1;

 		do {
 			c = scr_readw(s);
-			if (attr != (c & 0xff00)) {
-				attr = c & 0xff00;
+			if (attr != (c & VT_BUF_ATTR_MASK)) {
+				attr = c & VT_BUF_ATTR_MASK;
 				if (s > start) {
 					fbcon_putcs(vc, start, s - start,
 						    line, x);
@@ -1743,8 +1743,8 @@ static void fbcon_redraw(struct vc_data *vc,
struct display *p,
 		else {
 			line--;
 			/* NOTE: We subtract two lines from these pointers */
-			s -= vc->vc_size_row;
-			d -= vc->vc_size_row;
+			s -= vc->vc_cols * 2;
+			d -= vc->vc_cols * 2;
 		}
 	}
 }
@@ -1752,14 +1752,14 @@ static void fbcon_redraw(struct vc_data *vc,
struct display *p,
 static inline void fbcon_softback_note(struct vc_data *vc, int t,
 				       int count)
 {
-	unsigned short *p;
+	u32 *p;

 	if (vc->vc_num != fg_console)
 		return;
-	p = (unsigned short *) (vc->vc_origin + t * vc->vc_size_row);
+	p = (u32 *) (vc->vc_origin + t * vc->vc_size_row);

 	while (count) {
-		scr_memcpyw((u16 *) softback_in, p, vc->vc_size_row);
+		scr_memcpyw((u32 *) softback_in, p, vc->vc_size_row);
 		count--;
 		p = advance_row(p, 1);
 		softback_in += vc->vc_size_row;
@@ -1805,9 +1805,9 @@ static int fbcon_scroll(struct vc_data *vc, int
t, int b, int dir,
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
 				     count);
 			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
-			scr_memsetw((unsigned short *) (vc->vc_origin +
-							vc->vc_size_row *
-							(b - count)),
+			scr_memsetw((u32 *) (vc->vc_origin +
+						vc->vc_size_row *
+						(b - count)),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
@@ -1877,9 +1877,9 @@ static int fbcon_scroll(struct vc_data *vc, int
t, int b, int dir,
 			fbcon_redraw(vc, p, t, b - t - count,
 				     count * vc->vc_cols);
 			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
-			scr_memsetw((unsigned short *) (vc->vc_origin +
-							vc->vc_size_row *
-							(b - count)),
+			scr_memsetw((u32 *) (vc->vc_origin +
+						vc->vc_size_row *
+						(b - count)),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
@@ -1896,9 +1896,9 @@ static int fbcon_scroll(struct vc_data *vc, int
t, int b, int dir,
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,
 				     -count);
 			fbcon_clear(vc, t, 0, count, vc->vc_cols);
-			scr_memsetw((unsigned short *) (vc->vc_origin +
-							vc->vc_size_row *
-							t),
+			scr_memsetw((u32 *) (vc->vc_origin +
+						vc->vc_size_row *
+						t),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
@@ -1966,9 +1966,9 @@ static int fbcon_scroll(struct vc_data *vc, int
t, int b, int dir,
 			fbcon_redraw(vc, p, b - 1, b - t - count,
 				     -count * vc->vc_cols);
 			fbcon_clear(vc, t, 0, count, vc->vc_cols);
-			scr_memsetw((unsigned short *) (vc->vc_origin +
-							vc->vc_size_row *
-							t),
+			scr_memsetw((u32 *) (vc->vc_origin +
+						vc->vc_size_row *
+						t),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
@@ -2225,7 +2225,7 @@ static int fbcon_switch(struct vc_data *vc)
 	}

 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
-	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
+	vc->vc_complement_mask = (vc->vc_can_do_color ? 0x77 : 0x08) <<
VT_BUF_ATTR_SHIFT;

 	if (p->userfont)
 		charcnt = FNTCHARCNT(vc->vc_font.data);
@@ -2281,9 +2281,8 @@ static void fbcon_generic_blank(struct vc_data
*vc, struct fb_info *info,
 	struct fb_event event;

 	if (blank) {
-		unsigned short charmask = vc->vc_hi_font_mask ?
-			0x1ff : 0xff;
-		unsigned short oldc;
+		u32 charmask = VT_BUF_ATTR_MASK;
+		u32 oldc;

 		oldc = vc->vc_video_erase_char;
 		vc->vc_video_erase_char &= charmask;
@@ -2418,6 +2417,7 @@ static int fbcon_do_set_font(struct vc_data *vc,
int w, int h,
 		REFCOUNT(data)++;
 	vc->vc_font.width = w;
 	vc->vc_font.height = h;
+	vc->vc_font.charcount = cnt;
 	if (vc->vc_hi_font_mask && cnt == 256) {
 		vc->vc_hi_font_mask = 0;
 		if (vc->vc_can_do_color) {
@@ -2427,18 +2427,18 @@ static int fbcon_do_set_font(struct vc_data
*vc, int w, int h,
 			
 		/* ++Edmund: reorder the attribute bits */
 		if (vc->vc_can_do_color) {
-			unsigned short *cp =
-			    (unsigned short *) vc->vc_origin;
-			int count = vc->vc_screenbuf_size / 2;
-			unsigned short c;
+			u32 *cp = (u32 *) vc->vc_origin;
+			int count = vc->vc_screenbuf_size / 4;
+			u32 c;
 			for (; count > 0; count--, cp++) {
 				c = scr_readw(cp);
-				scr_writew(((c & 0xfe00) >> 1) |
-					   (c & 0xff), cp);
+				scr_writew(((c & VT_BUF_ATTR_MASK) >> 1) |
+					   (c & ~VT_BUF_ATTR_MASK), cp);
 			}
 			c = vc->vc_video_erase_char;
 			vc->vc_video_erase_char =
-			    ((c & 0xfe00) >> 1) | (c & 0xff);
+				((c & VT_BUF_ATTR_MASK) >> 1) |
+				(c & ~VT_BUF_ATTR_MASK);
 			vc->vc_attr >>= 1;
 		}
 	} else if (!vc->vc_hi_font_mask && cnt == 512) {
@@ -2450,28 +2450,26 @@ static int fbcon_do_set_font(struct vc_data
*vc, int w, int h,
 			
 		/* ++Edmund: reorder the attribute bits */
 		{
-			unsigned short *cp =
-			    (unsigned short *) vc->vc_origin;
-			int count = vc->vc_screenbuf_size / 2;
-			unsigned short c;
+			u32 *cp = (u32 *) vc->vc_origin;
+			int count = vc->vc_screenbuf_size / 4;
+			u32 c;
 			for (; count > 0; count--, cp++) {
-				unsigned short newc;
+				u32 newc;
 				c = scr_readw(cp);
 				if (vc->vc_can_do_color)
-					newc =
-					    ((c & 0xff00) << 1) | (c &
-								   0xff);
+					newc = ((c & VT_BUF_ATTR_MASK) << 1) |
+						(c & ~VT_BUF_ATTR_MASK);
 				else
-					newc = c & ~0x100;
+					newc = c;
 				scr_writew(newc, cp);
 			}
 			c = vc->vc_video_erase_char;
 			if (vc->vc_can_do_color) {
 				vc->vc_video_erase_char =
-				    ((c & 0xff00) << 1) | (c & 0xff);
+					((c & VT_BUF_ATTR_MASK) << 1) |
+					(c & ~VT_BUF_ATTR_MASK);
 				vc->vc_attr <<= 1;
-			} else
-				vc->vc_video_erase_char = c & ~0x100;
+			}
 		}

 	}
@@ -2641,21 +2639,21 @@ static int fbcon_set_palette(struct vc_data
*vc, unsigned char *table)
 	return fb_set_cmap(&palette_cmap, info);
 }

-static u16 *fbcon_screen_pos(struct vc_data *vc, int offset)
+static u32 *fbcon_screen_pos(struct vc_data *vc, int offset)
 {
 	unsigned long p;
 	int line;
 	
 	if (vc->vc_num != fg_console || !softback_lines)
-		return (u16 *) (vc->vc_origin + offset);
+		return (u32 *) (vc->vc_origin + offset);
 	line = offset / vc->vc_size_row;
 	if (line >= softback_lines)
-		return (u16 *) (vc->vc_origin + offset -
+		return (u32 *) (vc->vc_origin + offset -
 				softback_lines * vc->vc_size_row);
 	p = softback_curr + offset;
 	if (p >= softback_end)
 		p += softback_buf - softback_end;
-	return (u16 *) p;
+	return (u32 *) p;
 }

 static unsigned long fbcon_getxy(struct vc_data *vc, unsigned long pos,
@@ -2665,22 +2663,22 @@ static unsigned long fbcon_getxy(struct
vc_data *vc, unsigned long pos,
 	int x, y;

 	if (pos >= vc->vc_origin && pos < vc->vc_scr_end) {
-		unsigned long offset = (pos - vc->vc_origin) / 2;
+		unsigned long offset = (pos - vc->vc_origin) / 4;

 		x = offset % vc->vc_cols;
 		y = offset / vc->vc_cols;
 		if (vc->vc_num == fg_console)
 			y += softback_lines;
-		ret = pos + (vc->vc_cols - x) * 2;
+		ret = pos + (vc->vc_cols - x) * 4;
 	} else if (vc->vc_num == fg_console && softback_lines) {
 		unsigned long offset = pos - softback_curr;

 		if (pos < softback_curr)
 			offset += softback_end - softback_buf;
-		offset /= 2;
+		offset /= 4;
 		x = offset % vc->vc_cols;
 		y = offset / vc->vc_cols;
-		ret = pos + (vc->vc_cols - x) * 2;
+		ret = pos + (vc->vc_cols - x) * 4;
 		if (ret == softback_end)
 			ret = softback_buf;
 		if (ret == softback_in)
@@ -2699,23 +2697,27 @@ static unsigned long fbcon_getxy(struct
vc_data *vc, unsigned long pos,

 /* As we might be inside of softback, we may work with non-contiguous buffer,
    that's why we have to use a separate routine. */
-static void fbcon_invert_region(struct vc_data *vc, u16 * p, int cnt)
+static void fbcon_invert_region(struct vc_data *vc, u32 * p, int cnt)
 {
 	while (cnt--) {
-		u16 a = scr_readw(p);
+		u32 a = scr_readw(p);
 		if (!vc->vc_can_do_color)
-			a ^= 0x0800;
+			a ^= 0x08 << VT_BUF_ATTR_SHIFT;
 		else if (vc->vc_hi_font_mask == 0x100)
-			a = ((a) & 0x11ff) | (((a) & 0xe000) >> 4) |
-			    (((a) & 0x0e00) << 4);
+			a = (a & ~VT_BUF_ATTR_MASK) |
+				(a & (0x10 << VT_BUF_ATTR_SHIFT)) |
+				((a & (0xe0 << VT_BUF_ATTR_SHIFT)) >> 4) |
+				((a & (0x0e << VT_BUF_ATTR_SHIFT)) << 4);
 		else
-			a = ((a) & 0x88ff) | (((a) & 0x7000) >> 4) |
-			    (((a) & 0x0700) << 4);
+			a = (a & ~VT_BUF_ATTR_MASK) |
+				(a & (0x88 << VT_BUF_ATTR_SHIFT)) |
+				((a & (0x70 << VT_BUF_ATTR_SHIFT)) >> 4) |
+				((a & (0x07 << VT_BUF_ATTR_SHIFT)) << 4);
 		scr_writew(a, p++);
-		if (p == (u16 *) softback_end)
-			p = (u16 *) softback_buf;
-		if (p == (u16 *) softback_in)
-			p = (u16 *) vc->vc_origin;
+		if (p == (u32 *) softback_end)
+			p = (u32 *) softback_buf;
+		if (p == (u32 *) softback_in)
+			p = (u32 *) vc->vc_origin;
 	}
 }

@@ -2751,7 +2753,7 @@ static int fbcon_scrolldelta(struct vc_data *vc,
int lines)
 						p = softback_end;
 					p -= vc->vc_size_row;
 					q -= vc->vc_size_row;
-					scr_memcpyw((u16 *) q, (u16 *) p,
+					scr_memcpyw((u32 *) q, (u32 *) p,
 						    vc->vc_size_row);
 				}
 				softback_in = softback_curr = p;
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 89a3468..c773878 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -57,7 +57,7 @@ struct fbcon_ops {
 	void (*clear)(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int height, int width);
 	void (*putcs)(struct vc_data *vc, struct fb_info *info,
-		      const unsigned short *s, int count, int yy, int xx,
+		      const u32 *s, int count, int yy, int xx,
 		      int fg, int bg);
 	void (*clear_margins)(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only);
@@ -90,19 +90,19 @@ struct fbcon_ops {

 /* Color */
 #define attr_fgcol(fgshift,s)    \
-	(((s) >> (fgshift)) & 0x0f)
+	(((s) >> (fgshift + VT_BUF_ATTR_SHIFT)) & 0x0f)
 #define attr_bgcol(bgshift,s)    \
-	(((s) >> (bgshift)) & 0x0f)
+	(((s) >> (bgshift + VT_BUF_ATTR_SHIFT)) & 0x0f)

 /* Monochrome */
 #define attr_bold(s) \
-	((s) & 0x200)
+	((s) & (0x2 << VT_BUF_ATTR_SHIFT))
 #define attr_reverse(s) \
-	((s) & 0x800)
+	((s) & (0x8 << VT_BUF_ATTR_SHIFT))
 #define attr_underline(s) \
-	((s) & 0x400)
+	((s) & (0x4 << VT_BUF_ATTR_SHIFT))
 #define attr_blink(s) \
-	((s) & 0x8000)
+	((s) & (0x80 << VT_BUF_ATTR_SHIFT))
 	

 static inline int mono_col(const struct fb_info *info)
@@ -231,7 +231,7 @@ static inline int real_y(struct display *p, int ypos)
 }


-static inline int get_attribute(struct fb_info *info, u16 c)
+static inline int get_attribute(struct fb_info *info, u32 c)
 {
 	int attribute = 0;
