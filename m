Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374Ab0EZG7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:59:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45953 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934264Ab0EZG7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vwB5N6PJcLqvC18Z9aNN809mexK7jqCM+rWQIqP3LEogcd3ZB1lr4vgtdx79WzvBFd
         c66NBjiGQ7YwLrE7hfdGpj/WhIDbARt4AqD9N2ScH4H9SQzrZgMt0YbO5RFnpYh2q3S4
         WxTauFtPCSee9M3DzcrqQ5HKzpVLlaP8aa548=
MIME-Version: 1.0
In-Reply-To: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 26 May 2010 14:59:30 +0800
Message-ID: <AANLkTilpVGUQFvQr7iuK41Te9wtvRuMxLjbIlMpTrndt@mail.gmail.com>
Subject: [PATCH 1/2] Enlarge the storage of chars in virtual terminal
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

Enlarge the storage of char in virtual terminal.

Signed-off-by: Frank Pan <frankpzh@gmail.com>
---
diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index f97b9e8..200a790 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -158,8 +158,8 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 	  ys = limit(ys, vc->vc_rows - 1);
 	  xe = limit(xe, vc->vc_cols - 1);
 	  ye = limit(ye, vc->vc_rows - 1);
-	  ps = ys * vc->vc_size_row + (xs << 1);
-	  pe = ye * vc->vc_size_row + (xe << 1);
+	  ps = ys * vc->vc_size_row + (xs << 2);
+	  pe = ye * vc->vc_size_row + (xe << 2);

 	  if (sel_mode == TIOCL_SELCLEAR) {
 	      /* useful for screendump without selection highlights */
@@ -194,7 +194,7 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 			break;
 		case TIOCL_SELWORD:	/* word-by-word selection */
 			spc = isspace(sel_pos(ps));
-			for (new_sel_start = ps; ; ps -= 2)
+			for (new_sel_start = ps; ; ps -= 4)
 			{
 				if ((spc && !isspace(sel_pos(ps))) ||
 				    (!spc && !inword(sel_pos(ps))))
@@ -204,20 +204,20 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 					break;
 			}
 			spc = isspace(sel_pos(pe));
-			for (new_sel_end = pe; ; pe += 2)
+			for (new_sel_end = pe; ; pe += 4)
 			{
 				if ((spc && !isspace(sel_pos(pe))) ||
 				    (!spc && !inword(sel_pos(pe))))
 					break;
 				new_sel_end = pe;
-				if (!((pe + 2) % vc->vc_size_row))
+				if (!((pe + 4) % vc->vc_size_row))
 					break;
 			}
 			break;
 		case TIOCL_SELLINE:	/* line-by-line selection */
 			new_sel_start = ps - ps % vc->vc_size_row;
 			new_sel_end = pe + vc->vc_size_row
-				    - pe % vc->vc_size_row - 2;
+				    - pe % vc->vc_size_row - 4;
 			break;
 		case TIOCL_SELPOINTER:
 			highlight_pointer(pe);
@@ -233,7 +233,7 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 	if (new_sel_end > new_sel_start &&
 		!atedge(new_sel_end, vc->vc_size_row) &&
 		isspace(sel_pos(new_sel_end))) {
-		for (pe = new_sel_end + 2; ; pe += 2)
+		for (pe = new_sel_end + 4; ; pe += 4)
 			if (!isspace(sel_pos(pe)) ||
 			    atedge(pe, vc->vc_size_row))
 				break;
@@ -247,16 +247,16 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 		if (new_sel_end == sel_end)	/* no action required */
 			return 0;
 		else if (new_sel_end > sel_end)	/* extend to right */
-			highlight(sel_end + 2, new_sel_end);
+			highlight(sel_end + 4, new_sel_end);
 		else				/* contract from right */
-			highlight(new_sel_end + 2, sel_end);
+			highlight(new_sel_end + 4, sel_end);
 	}
 	else if (new_sel_end == sel_end)
 	{
 		if (new_sel_start < sel_start)	/* extend to left */
-			highlight(new_sel_start, sel_start - 2);
+			highlight(new_sel_start, sel_start - 4);
 		else				/* contract from left */
-			highlight(sel_start, new_sel_start - 2);
+			highlight(sel_start, new_sel_start - 4);
 	}
 	else	/* some other case; start selection from scratch */
 	{
@@ -278,7 +278,7 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 	sel_buffer = bp;

 	obp = bp;
-	for (i = sel_start; i <= sel_end; i += 2) {
+	for (i = sel_start; i <= sel_end; i += 4) {
 		c = sel_pos(i);
 		if (use_unicode)
 			bp += store_utf8(c, bp);
@@ -286,7 +286,7 @@ int set_selection(const struct tiocl_selection
__user *sel, struct tty_struct *t
 			*bp++ = c;
 		if (!isspace(c))
 			obp = bp;
-		if (! ((i + 2) % vc->vc_size_row)) {
+		if (! ((i + 4) % vc->vc_size_row)) {
 			/* strip trailing blanks from line and add newline,
 			   unless non-space at end of line. */
 			if (obp != bp) {
diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index c1791a6..b4018b4 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -105,7 +105,7 @@ vcs_read(struct file *file, char __user *buf,
size_t count, loff_t *ppos)
 	long pos;
 	long viewed, attr, read;
 	int col, maxcol;
-	unsigned short *org = NULL;
+	u32 *org = NULL;
 	ssize_t ret;

 	mutex_lock(&con_buf_mtx);
@@ -279,7 +279,7 @@ vcs_write(struct file *file, const char __user
*buf, size_t count, loff_t *ppos)
 	long viewed, attr, size, written;
 	char *con_buf0;
 	int col, maxcol;
-	u16 *org0 = NULL, *org = NULL;
+	u32 *org0 = NULL, *org = NULL;
 	size_t ret;

 	mutex_lock(&con_buf_mtx);
@@ -369,7 +369,7 @@ vcs_write(struct file *file, const char __user
*buf, size_t count, loff_t *ppos)

 				this_round--;
 				vcs_scr_writew(vc,
-					       (vcs_scr_readw(vc, org) & 0xff00) | c, org);
+					       (vcs_scr_readw(vc, org) & VT_BUF_ATTR_MASK) | c, org);
 				org++;
 				if (++col == maxcol) {
 					org = screen_pos(vc, p, viewed);
@@ -400,7 +400,7 @@ vcs_write(struct file *file, const char __user
*buf, size_t count, loff_t *ppos)
 					c = *con_buf0++;
 #ifdef __BIG_ENDIAN
 					vcs_scr_writew(vc, c |
-					     (vcs_scr_readw(vc, org) & 0xff00), org);
+					     (vcs_scr_readw(vc, org) & VT_BUF_ATTR_MASK), org);
 #else
 					vcs_scr_writew(vc, (c << 8) |
 					     (vcs_scr_readw(vc, org) & 0xff), org);
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..2c5ebd4 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -267,14 +267,14 @@ static void notify_update(struct vc_data *vc)
 #define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !console_blanked)
 #endif

-static inline unsigned short *screenpos(struct vc_data *vc, int
offset, int viewed)
+static inline u32 *screenpos(struct vc_data *vc, int offset, int viewed)
 {
-	unsigned short *p;
+	u32 *p;
 	
 	if (!viewed)
-		p = (unsigned short *)(vc->vc_origin + offset);
+		p = (u32 *)(vc->vc_origin + offset);
 	else if (!vc->vc_sw->con_screen_pos)
-		p = (unsigned short *)(vc->vc_visible_origin + offset);
+		p = (u32 *)(vc->vc_visible_origin + offset);
 	else
 		p = vc->vc_sw->con_screen_pos(vc, offset);
 	return p;
@@ -293,7 +293,7 @@ void schedule_console_callback(void)

 static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 {
-	unsigned short *d, *s;
+	u32 *d, *s;

 	if (t+nr >= b)
 		nr = b - t - 1;
@@ -301,8 +301,8 @@ static void scrup(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)
 		return;
 	if (CON_IS_VISIBLE(vc) && vc->vc_sw->con_scroll(vc, t, b, SM_UP, nr))
 		return;
-	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
-	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
+	d = (u32 *)(vc->vc_origin + vc->vc_size_row * t);
+	s = (u32 *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
 	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
@@ -310,7 +310,7 @@ static void scrup(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)

 static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 {
-	unsigned short *s;
+	u32 *s;
 	unsigned int step;

 	if (t+nr >= b)
@@ -319,21 +319,21 @@ static void scrdown(struct vc_data *vc, unsigned
int t, unsigned int b, int nr)
 		return;
 	if (CON_IS_VISIBLE(vc) && vc->vc_sw->con_scroll(vc, t, b, SM_DOWN, nr))
 		return;
-	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
+	s = (u32 *)(vc->vc_origin + vc->vc_size_row * t);
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
+	scr_memsetw(s, vc->vc_video_erase_char, 4 * step);
 }

 static void do_update_region(struct vc_data *vc, unsigned long start,
int count)
 {
 #ifndef VT_BUF_VRAM_ONLY
 	unsigned int xx, yy, offset;
-	u16 *p;
+	u32 *p;

-	p = (u16 *) start;
+	p = (u32 *) start;
 	if (!vc->vc_sw->con_getxy) {
-		offset = (start - vc->vc_origin) / 2;
+		offset = (start - vc->vc_origin) / 4;
 		xx = offset % vc->vc_cols;
 		yy = offset / vc->vc_cols;
 	} else {
@@ -342,16 +342,16 @@ static void do_update_region(struct vc_data *vc,
unsigned long start, int count)
 		xx = nxx; yy = nyy;
 	}
 	for(;;) {
-		u16 attrib = scr_readw(p) & 0xff00;
+		u32 attrib = scr_readw(p) & VT_BUF_ATTR_MASK;
 		int startx = xx;
-		u16 *q = p;
+		u32 *q = p;
 		while (xx < vc->vc_cols && count) {
-			if (attrib != (scr_readw(p) & 0xff00)) {
+			if (attrib != (scr_readw(p) & VT_BUF_ATTR_MASK)) {
 				if (p > q)
 					vc->vc_sw->con_putcs(vc, q, p-q, yy, startx);
 				startx = xx;
 				q = p;
-				attrib = scr_readw(p) & 0xff00;
+				attrib = scr_readw(p) & VT_BUF_ATTR_MASK;
 			}
 			p++;
 			xx++;
@@ -364,7 +364,7 @@ static void do_update_region(struct vc_data *vc,
unsigned long start, int count)
 		xx = 0;
 		yy++;
 		if (vc->vc_sw->con_getxy) {
-			p = (u16 *)start;
+			p = (u32 *)start;
 			start = vc->vc_sw->con_getxy(vc, start, NULL, NULL);
 		}
 	}
@@ -411,7 +411,7 @@ static u8 build_attr(struct vc_data *vc, u8
_color, u8 _intensity, u8 _blink,
 		       (_reverse ? 8 : 0) |
 		       (_blink ? 0x80 : 0);
 	if (_italic)
-		a = (a & 0xF0) | vc->vc_itcolor;
+		a = (a & 0xf0) | vc->vc_itcolor;
 	else if (_underline)
 		a = (a & 0xf0) | vc->vc_ulcolor;
 	else if (_intensity == 0)
@@ -436,44 +436,51 @@ static void update_attr(struct vc_data *vc)
 	vc->vc_attr = build_attr(vc, vc->vc_color, vc->vc_intensity,
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
-	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1,
vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
+	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1,
+	              vc->vc_blink, 0, vc->vc_decscnm, 0) << VT_BUF_ATTR_SHIFT) | ' ';
 }

 /* Note: inverting the screen twice should revert to the original state */
 void invert_screen(struct vc_data *vc, int offset, int count, int viewed)
 {
-	unsigned short *p;
+	u32 *p;

 	WARN_CONSOLE_UNLOCKED();

-	count /= 2;
+	count /= 4;
 	p = screenpos(vc, offset, viewed);
 	if (vc->vc_sw->con_invert_region)
 		vc->vc_sw->con_invert_region(vc, p, count);
 #ifndef VT_BUF_VRAM_ONLY
 	else {
-		u16 *q = p;
+		u32 *q = p;
 		int cnt = count;
-		u16 a;
+		u32 a;

 		if (!vc->vc_can_do_color) {
 			while (cnt--) {
 			    a = scr_readw(q);
-			    a ^= 0x0800;
+			    a ^= 0x08 << VT_BUF_ATTR_SHIFT;
 			    scr_writew(a, q);
 			    q++;
 			}
 		} else if (vc->vc_hi_font_mask == 0x100) {
 			while (cnt--) {
 				a = scr_readw(q);
-				a = ((a) & 0x11ff) | (((a) & 0xe000) >> 4) | (((a) & 0x0e00) << 4);
+				a = (a & ~VT_BUF_ATTR_MASK) |
+				  (a & (0x10 << VT_BUF_ATTR_SHIFT)) |
+				  ((a & (0xe0 << VT_BUF_ATTR_SHIFT)) >> 4) |
+				  ((a & (0x0e << VT_BUF_ATTR_SHIFT)) << 4);
 				scr_writew(a, q);
 				q++;
 			}
 		} else {
 			while (cnt--) {
 				a = scr_readw(q);
-				a = ((a) & 0x88ff) | (((a) & 0x7000) >> 4) | (((a) & 0x0700) << 4);
+				a = (a & ~VT_BUF_ATTR_MASK) |
+				  (a & (0x88 << VT_BUF_ATTR_SHIFT)) |
+				  ((a & (0x70 << VT_BUF_ATTR_SHIFT)) >> 4) |
+				  ((a & (0x07 << VT_BUF_ATTR_SHIFT)) << 4);
 				scr_writew(a, q);
 				q++;
 			}
@@ -488,7 +495,7 @@ void invert_screen(struct vc_data *vc, int offset,
int count, int viewed)
 void complement_pos(struct vc_data *vc, int offset)
 {
 	static int old_offset = -1;
-	static unsigned short old;
+	static u32 old;
 	static unsigned short oldx, oldy;

 	WARN_CONSOLE_UNLOCKED();
@@ -504,15 +511,15 @@ void complement_pos(struct vc_data *vc, int offset)

 	if (offset != -1 && offset >= 0 &&
 	    offset < vc->vc_screenbuf_size) {
-		unsigned short new;
-		unsigned short *p;
+		u32 new;
+		u32 *p;
 		p = screenpos(vc, offset, 1);
 		old = scr_readw(p);
 		new = old ^ vc->vc_complement_mask;
 		scr_writew(new, p);
 		if (DO_UPDATE(vc)) {
-			oldx = (offset >> 1) % vc->vc_cols;
-			oldy = (offset >> 1) / vc->vc_cols;
+			oldx = (offset >> 2) % vc->vc_cols;
+			oldy = (offset >> 2) / vc->vc_cols;
 			vc->vc_sw->con_putc(vc, new, oldy, oldx);
 		}
 	}
@@ -521,18 +528,18 @@ void complement_pos(struct vc_data *vc, int offset)

 static void insert_char(struct vc_data *vc, unsigned int nr)
 {
-	unsigned short *p, *q = (unsigned short *)vc->vc_pos;
+	u32 *p, *q = (u32 *)vc->vc_pos;

 	p = q + vc->vc_cols - nr - vc->vc_x;
 	while (--p >= q)
 		scr_writew(scr_readw(p), p + nr);
-	scr_memsetw(q, vc->vc_video_erase_char, nr * 2);
+	scr_memsetw(q, vc->vc_video_erase_char, nr * 4);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc)) {
-		unsigned short oldattr = vc->vc_attr;
+		u8 oldattr = vc->vc_attr;
 		vc->vc_sw->con_bmove(vc, vc->vc_y, vc->vc_x, vc->vc_y, vc->vc_x + nr, 1,
 				     vc->vc_cols - vc->vc_x - nr);
-		vc->vc_attr = vc->vc_video_erase_char >> 8;
+		vc->vc_attr = vc->vc_video_erase_char >> VT_BUF_ATTR_SHIFT;
 		while (nr--)
 			vc->vc_sw->con_putc(vc, vc->vc_video_erase_char, vc->vc_y, vc->vc_x + nr);
 		vc->vc_attr = oldattr;
@@ -542,19 +549,19 @@ static void insert_char(struct vc_data *vc,
unsigned int nr)
 static void delete_char(struct vc_data *vc, unsigned int nr)
 {
 	unsigned int i = vc->vc_x;
-	unsigned short *p = (unsigned short *)vc->vc_pos;
+	u32 *p = (u32 *)vc->vc_pos;

 	while (++i <= vc->vc_cols - nr) {
-		scr_writew(scr_readw(p+nr), p);
+		scr_writew(scr_readw(p + nr), p);
 		p++;
 	}
-	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
+	scr_memsetw(p, vc->vc_video_erase_char, nr * 4);
 	vc->vc_need_wrap = 0;
 	if (DO_UPDATE(vc)) {
-		unsigned short oldattr = vc->vc_attr;
+		u8 oldattr = vc->vc_attr;
 		vc->vc_sw->con_bmove(vc, vc->vc_y, vc->vc_x + nr, vc->vc_y, vc->vc_x, 1,
 				     vc->vc_cols - vc->vc_x - nr);
-		vc->vc_attr = vc->vc_video_erase_char >> 8;
+		vc->vc_attr = vc->vc_video_erase_char >> VT_BUF_ATTR_SHIFT;
 		while (nr--)
 			vc->vc_sw->con_putc(vc, vc->vc_video_erase_char, vc->vc_y,
 				     vc->vc_cols - 1 - nr);
@@ -562,21 +569,29 @@ static void delete_char(struct vc_data *vc,
unsigned int nr)
 	}
 }

-static int softcursor_original;
+static u32 softcursor_original;

 static void add_softcursor(struct vc_data *vc)
 {
-	int i = scr_readw((u16 *) vc->vc_pos);
+	u32 i = scr_readw((u32 *) vc->vc_pos);
 	u32 type = vc->vc_cursor_type;

-	if (! (type & 0x10)) return;
-	if (softcursor_original != -1) return;
+	if (! (type & 0x10))
+		return;
+	if (softcursor_original != -1)
+		return;
 	softcursor_original = i;
-	i |= ((type >> 8) & 0xff00 );
-	i ^= ((type) & 0xff00 );
-	if ((type & 0x20) && ((softcursor_original & 0x7000) == (i &
0x7000))) i ^= 0x7000;
-	if ((type & 0x40) && ((i & 0x700) == ((i & 0x7000) >> 4))) i ^= 0x0700;
-	scr_writew(i, (u16 *) vc->vc_pos);
+	i |= (((type >> 16) & 0xff) << VT_BUF_ATTR_SHIFT);
+	i ^= (((type >> 8) & 0xff) << VT_BUF_ATTR_SHIFT);
+	if ((type & 0x20) &&
+	    ((softcursor_original & (0x70 << VT_BUF_ATTR_SHIFT)) ==
+	     (i & (0x70 << VT_BUF_ATTR_SHIFT))))
+		i ^= 0x70 << VT_BUF_ATTR_SHIFT;
+	if ((type & 0x40) &&
+	    ((i & (0x07 << VT_BUF_ATTR_SHIFT)) ==
+	     ((i & (0x70 << VT_BUF_ATTR_SHIFT)) >> 4)))
+		i ^= 0x07 << VT_BUF_ATTR_SHIFT;
+	scr_writew(i, (u32 *) vc->vc_pos);
 	if (DO_UPDATE(vc))
 		vc->vc_sw->con_putc(vc, i, vc->vc_y, vc->vc_x);
 }
@@ -584,7 +599,7 @@ static void add_softcursor(struct vc_data *vc)
 static void hide_softcursor(struct vc_data *vc)
 {
 	if (softcursor_original != -1) {
-		scr_writew(softcursor_original, (u16 *)vc->vc_pos);
+		scr_writew(softcursor_original, (u32 *)vc->vc_pos);
 		if (DO_UPDATE(vc))
 			vc->vc_sw->con_putc(vc, softcursor_original,
 					vc->vc_y, vc->vc_x);
@@ -625,7 +640,7 @@ static void set_origin(struct vc_data *vc)
 		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 	vc->vc_visible_origin = vc->vc_origin;
 	vc->vc_scr_end = vc->vc_origin + vc->vc_screenbuf_size;
-	vc->vc_pos = vc->vc_origin + vc->vc_size_row * vc->vc_y + 2 * vc->vc_x;
+	vc->vc_pos = vc->vc_origin + vc->vc_size_row * vc->vc_y + 4 * vc->vc_x;
 }

 static inline void save_screen(struct vc_data *vc)
@@ -642,12 +657,12 @@ static inline void save_screen(struct vc_data *vc)

 static void clear_buffer_attributes(struct vc_data *vc)
 {
-	unsigned short *p = (unsigned short *)vc->vc_origin;
-	int count = vc->vc_screenbuf_size / 2;
-	int mask = vc->vc_hi_font_mask | 0xff;
+	u32 *p = (u32 *)vc->vc_origin;
+	int count = vc->vc_screenbuf_size / 4;
+	u32 mask = ~VT_BUF_ATTR_MASK;

 	for (; count > 0; count--, p++) {
-		scr_writew((scr_readw(p)&mask) | (vc->vc_video_erase_char & ~mask), p);
+		scr_writew((scr_readw(p) & mask) | (vc->vc_video_erase_char & ~mask), p);
 	}
 }

@@ -699,7 +714,7 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			clear_buffer_attributes(vc);
 		}
 		if (update && vc->vc_mode != KD_GRAPHICS)
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 4);
 	}
 	set_cursor(vc);
 	if (is_switch) {
@@ -738,9 +753,9 @@ static void visual_init(struct vc_data *vc, int
num, int init)
 	vc->vc_can_do_color = 0;
 	vc->vc_sw->con_init(vc, init);
 	if (!vc->vc_complement_mask)
-		vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
+		vc->vc_complement_mask = (vc->vc_can_do_color ?	0x77 : 0x08) <<
VT_BUF_ATTR_SHIFT;
 	vc->vc_s_complement_mask = vc->vc_complement_mask;
-	vc->vc_size_row = vc->vc_cols << 1;
+	vc->vc_size_row = vc->vc_cols << 2;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }

@@ -834,7 +849,7 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
 	unsigned int end, user;
-	unsigned short *newscreen;
+	u32 *newscreen;

 	WARN_CONSOLE_UNLOCKED();

@@ -849,7 +864,7 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,

 	new_cols = (cols ? cols : vc->vc_cols);
 	new_rows = (lines ? lines : vc->vc_rows);
-	new_row_size = new_cols << 1;
+	new_row_size = new_cols << 2;
 	new_screen_size = new_row_size * new_rows;

 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
@@ -894,7 +909,7 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 			 * Cursor is in no man's land, copy 1/2 screenful
 			 * from the top and bottom of cursor position
 			 */
-			old_origin += (vc->vc_y - new_rows/2) * old_row_size;
+			old_origin += (vc->vc_y - new_rows / 2) * old_row_size;
 			end = old_origin + (old_row_size * new_rows);
 		}
 	} else
@@ -908,8 +923,8 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 	update_attr(vc);

 	while (old_origin < end) {
-		scr_memcpyw((unsigned short *) new_origin,
-			    (unsigned short *) old_origin, rlth);
+		scr_memcpyw((u32 *) new_origin,
+			    (u32 *) old_origin, rlth);
 		if (rrem)
 			scr_memsetw((void *)(new_origin + rlth),
 				    vc->vc_video_erase_char, rrem);
@@ -917,7 +932,7 @@ static int vc_do_resize(struct tty_struct *tty,
struct vc_data *vc,
 		new_origin += new_row_size;
 	}
 	if (new_scr_end > new_origin)
-		scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
+		scr_memsetw((u32 *)new_origin, vc->vc_video_erase_char,
 			    new_scr_end - new_origin);
 	kfree(vc->vc_screenbuf);
 	vc->vc_screenbuf = newscreen;
@@ -1072,7 +1087,7 @@ static void gotoxy(struct vc_data *vc, int
new_x, int new_y)
 		vc->vc_y = max_y - 1;
 	else
 		vc->vc_y = new_y;
-	vc->vc_pos = vc->vc_origin + vc->vc_y * vc->vc_size_row + (vc->vc_x<<1);
+	vc->vc_pos = vc->vc_origin + vc->vc_y * vc->vc_size_row + (vc->vc_x << 2);
 	vc->vc_need_wrap = 0;
 }

@@ -1127,7 +1142,7 @@ static void ri(struct vc_data *vc)

 static inline void cr(struct vc_data *vc)
 {
-	vc->vc_pos -= vc->vc_x << 1;
+	vc->vc_pos -= vc->vc_x << 2;
 	vc->vc_need_wrap = vc->vc_x = 0;
 	notify_write(vc, '\r');
 }
@@ -1135,7 +1150,7 @@ static inline void cr(struct vc_data *vc)
 static inline void bs(struct vc_data *vc)
 {
 	if (vc->vc_x) {
-		vc->vc_pos -= 2;
+		vc->vc_pos -= 4;
 		vc->vc_x--;
 		vc->vc_need_wrap = 0;
 		notify_write(vc, '\b');
@@ -1150,12 +1165,12 @@ static inline void del(struct vc_data *vc)
 static void csi_J(struct vc_data *vc, int vpar)
 {
 	unsigned int count;
-	unsigned short * start;
+	u32 *start;

 	switch (vpar) {
 		case 0:	/* erase from cursor to end of display */
-			count = (vc->vc_scr_end - vc->vc_pos) >> 1;
-			start = (unsigned short *)vc->vc_pos;
+			count = (vc->vc_scr_end - vc->vc_pos) >> 2;
+			start = (u32 *)vc->vc_pos;
 			if (DO_UPDATE(vc)) {
 				/* do in two stages */
 				vc->vc_sw->con_clear(vc, vc->vc_y, vc->vc_x, 1,
@@ -1166,8 +1181,8 @@ static void csi_J(struct vc_data *vc, int vpar)
 			}
 			break;
 		case 1:	/* erase from start to cursor */
-			count = ((vc->vc_pos - vc->vc_origin) >> 1) + 1;
-			start = (unsigned short *)vc->vc_origin;
+			count = ((vc->vc_pos - vc->vc_origin) >> 2) + 1;
+			start = (u32 *)vc->vc_origin;
 			if (DO_UPDATE(vc)) {
 				/* do in two stages */
 				vc->vc_sw->con_clear(vc, 0, 0, vc->vc_y,
@@ -1178,7 +1193,7 @@ static void csi_J(struct vc_data *vc, int vpar)
 			break;
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
-			start = (unsigned short *)vc->vc_origin;
+			start = (u32 *)vc->vc_origin;
 			if (DO_UPDATE(vc))
 				vc->vc_sw->con_clear(vc, 0, 0,
 					      vc->vc_rows,
@@ -1187,32 +1202,32 @@ static void csi_J(struct vc_data *vc, int vpar)
 		default:
 			return;
 	}
-	scr_memsetw(start, vc->vc_video_erase_char, 2 * count);
+	scr_memsetw(start, vc->vc_video_erase_char, 4 * count);
 	vc->vc_need_wrap = 0;
 }

 static void csi_K(struct vc_data *vc, int vpar)
 {
 	unsigned int count;
-	unsigned short * start;
+	u32 *start;

 	switch (vpar) {
 		case 0:	/* erase from cursor to end of line */
 			count = vc->vc_cols - vc->vc_x;
-			start = (unsigned short *)vc->vc_pos;
+			start = (u32 *)vc->vc_pos;
 			if (DO_UPDATE(vc))
 				vc->vc_sw->con_clear(vc, vc->vc_y, vc->vc_x, 1,
 						     vc->vc_cols - vc->vc_x);
 			break;
 		case 1:	/* erase from start of line to cursor */
-			start = (unsigned short *)(vc->vc_pos - (vc->vc_x << 1));
+			start = (u32 *)(vc->vc_pos - (vc->vc_x << 2));
 			count = vc->vc_x + 1;
 			if (DO_UPDATE(vc))
 				vc->vc_sw->con_clear(vc, vc->vc_y, 0, 1,
 						     vc->vc_x + 1);
 			break;
 		case 2: /* erase whole line */
-			start = (unsigned short *)(vc->vc_pos - (vc->vc_x << 1));
+			start = (u32 *)(vc->vc_pos - (vc->vc_x << 2));
 			count = vc->vc_cols;
 			if (DO_UPDATE(vc))
 				vc->vc_sw->con_clear(vc, vc->vc_y, 0, 1,
@@ -1221,7 +1236,7 @@ static void csi_K(struct vc_data *vc, int vpar)
 		default:
 			return;
 	}
-	scr_memsetw(start, vc->vc_video_erase_char, 2 * count);
+	scr_memsetw(start, vc->vc_video_erase_char, 4 * count);
 	vc->vc_need_wrap = 0;
 }

@@ -1233,7 +1248,7 @@ static void csi_X(struct vc_data *vc, int vpar)
/* erase the following vpar posi
 		vpar++;
 	count = (vpar > vc->vc_cols - vc->vc_x) ? (vc->vc_cols - vc->vc_x) : vpar;

-	scr_memsetw((unsigned short *)vc->vc_pos, vc->vc_video_erase_char, 2 * count);
+	scr_memsetw((u32 *)vc->vc_pos, vc->vc_video_erase_char, 4 * count);
 	if (DO_UPDATE(vc))
 		vc->vc_sw->con_clear(vc, vc->vc_y, vc->vc_x, 1, count);
 	vc->vc_need_wrap = 0;
@@ -1681,13 +1696,13 @@ static void do_con_trol(struct tty_struct
*tty, struct vc_data *vc, int c)
 		bs(vc);
 		return;
 	case 9:
-		vc->vc_pos -= (vc->vc_x << 1);
+		vc->vc_pos -= (vc->vc_x << 2);
 		while (vc->vc_x < vc->vc_cols - 1) {
 			vc->vc_x++;
 			if (vc->vc_tab_stop[vc->vc_x >> 5] & (1 << (vc->vc_x & 31)))
 				break;
 		}
-		vc->vc_pos += (vc->vc_x << 1);
+		vc->vc_pos += (vc->vc_x << 2);
 		notify_write(vc, '\t');
 		return;
 	case 10: case 11: case 12:
@@ -2008,11 +2023,11 @@ static void do_con_trol(struct tty_struct
*tty, struct vc_data *vc, int c)
 		if (c == '8') {
 			/* DEC screen alignment test. kludge :-) */
 			vc->vc_video_erase_char =
-				(vc->vc_video_erase_char & 0xff00) | 'E';
+				(vc->vc_video_erase_char & VT_BUF_ATTR_MASK) | 'E';
 			csi_J(vc, 2);
 			vc->vc_video_erase_char =
-				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+				(vc->vc_video_erase_char & VT_BUF_ATTR_MASK) | ' ';
+			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 4);
 		}
 		return;
 	case ESsetG0:
@@ -2104,7 +2119,7 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
 #define FLUSH do { } while(0);
 #else
 #define FLUSH if (draw_x >= 0) { \
-	vc->vc_sw->con_putcs(vc, (u16 *)draw_from, (u16 *)draw_to - (u16
*)draw_from, vc->vc_y, draw_x); \
+	vc->vc_sw->con_putcs(vc, (u32 *)draw_from, (u32 *)draw_to - (u32
*)draw_from, vc->vc_y, draw_x); \
 	draw_x = -1; \
 	}
 #endif
@@ -2118,7 +2133,8 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
 	uint8_t rescan;
 	uint8_t inverse;
 	uint8_t width;
-	u16 himask, charmask;
+	u32 charmask = ~VT_BUF_ATTR_MASK;
+	uint8_t char_found;

 	if (in_interrupt())
 		return count;
@@ -2141,9 +2157,6 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
 	    return 0;
 	}

-	himask = vc->vc_hi_font_mask;
-	charmask = himask ? 0x1ff : 0xff;
-
 	/* undraw cursor first */
 	if (IS_FG(vc))
 		hide_cursor(vc);
@@ -2267,6 +2280,7 @@ rescan_last_byte:
 			/* Now try to find out how to display it */
 			tc = conv_uni_to_pc(vc, tc);
 			if (tc & ~charmask) {
+				char_found = 0;
 				if (tc == -1 || tc == -2) {
 				    continue; /* nothing to display */
 				}
@@ -2288,6 +2302,9 @@ rescan_last_byte:
 				    }
 				}
 			}
+			else {
+				char_found = 1;
+			}

 			if (!inverse) {
 				vc_attr = vc->vc_attr;
@@ -2312,26 +2329,31 @@ rescan_last_byte:
 				}
 				if (vc->vc_decim)
 					insert_char(vc, 1);
-				scr_writew(himask ?
-					     ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) +
(tc & 0xff) :
-					     (vc_attr << 8) + tc,
-					   (u16 *) vc->vc_pos);
+				scr_writew((vc_attr << VT_BUF_ATTR_SHIFT) + tc,
+					   (u32 *) vc->vc_pos);
 				if (DO_UPDATE(vc) && draw_x < 0) {
 					draw_x = vc->vc_x;
 					draw_from = vc->vc_pos;
 				}
 				if (vc->vc_x == vc->vc_cols - 1) {
 					vc->vc_need_wrap = vc->vc_decawm;
-					draw_to = vc->vc_pos + 2;
+					draw_to = vc->vc_pos + 4;
 				} else {
 					vc->vc_x++;
-					draw_to = (vc->vc_pos += 2);
+					draw_to = (vc->vc_pos += 4);
 				}

 				if (!--width) break;

-				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second column */
-				if (tc < 0) tc = ' ';
+				if (char_found) {
+					/* The 2nd half of wide char is right after the 1st */
+					tc++;
+				}
+				else {
+					/* A space is printed in the second column */
+					tc = conv_uni_to_pc(vc, ' ');
+					if (tc < 0) tc = ' ';
+				}
 			}
 			notify_write(vc, c);

@@ -2473,7 +2495,7 @@ static void vt_console_print(struct console *co,
const char *b, unsigned count)
 	struct vc_data *vc = vc_cons[fg_console].d;
 	unsigned char c;
 	static DEFINE_SPINLOCK(printing_lock);
-	const ushort *start;
+	const u32 *start;
 	ushort cnt = 0;
 	ushort myx;
 	int kmsg_console;
@@ -2505,7 +2527,7 @@ static void vt_console_print(struct console *co,
const char *b, unsigned count)
 	if (IS_FG(vc))
 		hide_cursor(vc);

-	start = (ushort *)vc->vc_pos;
+	start = (u32 *)vc->vc_pos;

 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
@@ -2522,26 +2544,26 @@ static void vt_console_print(struct console
*co, const char *b, unsigned count)
 			}
 			if (c == 8) {		/* backspace */
 				bs(vc);
-				start = (ushort *)vc->vc_pos;
+				start = (u32 *)vc->vc_pos;
 				myx = vc->vc_x;
 				continue;
 			}
 			if (c != 13)
 				lf(vc);
 			cr(vc);
-			start = (ushort *)vc->vc_pos;
+			start = (u32 *)vc->vc_pos;
 			myx = vc->vc_x;
 			if (c == 10 || c == 13)
 				continue;
 		}
-		scr_writew((vc->vc_attr << 8) + c, (unsigned short *)vc->vc_pos);
+		scr_writew((vc->vc_attr << VT_BUF_ATTR_SHIFT) + c, (u32 *)vc->vc_pos);
 		notify_write(vc, c);
 		cnt++;
 		if (myx == vc->vc_cols - 1) {
 			vc->vc_need_wrap = 1;
 			continue;
 		}
-		vc->vc_pos += 2;
+		vc->vc_pos += 4;
 		myx++;
 	}
 	if (cnt > 0) {
@@ -2843,7 +2865,7 @@ static void vc_init(struct vc_data *vc, unsigned int rows,

 	vc->vc_cols = cols;
 	vc->vc_rows = rows;
-	vc->vc_size_row = cols << 1;
+	vc->vc_size_row = cols << 2;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;

 	set_origin(vc);
@@ -4057,19 +4079,15 @@ int con_font_op(struct vc_data *vc, struct
console_font_op *op)
 /* used by selection */
 u16 screen_glyph(struct vc_data *vc, int offset)
 {
-	u16 w = scr_readw(screenpos(vc, offset, 1));
-	u16 c = w & 0xff;
-
-	if (w & vc->vc_hi_font_mask)
-		c |= 0x100;
-	return c;
+	u32 w = scr_readw(screenpos(vc, offset, 1));
+	return w & ~VT_BUF_ATTR_MASK;
 }
 EXPORT_SYMBOL_GPL(screen_glyph);

 /* used by vcs - note the word offset */
-unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
+u32 *screen_pos(struct vc_data *vc, int w_offset, int viewed)
 {
-	return screenpos(vc, 2 * w_offset, viewed);
+	return screenpos(vc, 4 * w_offset, viewed);
 }

 void getconsxy(struct vc_data *vc, unsigned char *p)
@@ -4085,14 +4103,14 @@ void putconsxy(struct vc_data *vc, unsigned char *p)
 	set_cursor(vc);
 }

-u16 vcs_scr_readw(struct vc_data *vc, const u16 *org)
+u32 vcs_scr_readw(struct vc_data *vc, const u32 *org)
 {
 	if ((unsigned long)org == vc->vc_pos && softcursor_original != -1)
 		return softcursor_original;
 	return scr_readw(org);
 }

-void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org)
+void vcs_scr_writew(struct vc_data *vc, u32 val, u32 *org)
 {
 	scr_writew(val, org);
 	if ((unsigned long)org == vc->vc_pos) {
diff --git a/include/linux/console.h b/include/linux/console.h
index dcca533..ff374f9 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -34,8 +34,8 @@ struct consw {
 	void	(*con_init)(struct vc_data *, int);
 	void	(*con_deinit)(struct vc_data *);
 	void	(*con_clear)(struct vc_data *, int, int, int, int);
-	void	(*con_putc)(struct vc_data *, int, int, int);
-	void	(*con_putcs)(struct vc_data *, const unsigned short *, int, int, int);
+	void	(*con_putc)(struct vc_data *, u32, int, int);
+	void	(*con_putcs)(struct vc_data *, const u32 *, int, int, int);
 	void	(*con_cursor)(struct vc_data *, int);
 	int	(*con_scroll)(struct vc_data *, int, int, int, int);
 	void	(*con_bmove)(struct vc_data *, int, int, int, int, int, int);
@@ -52,8 +52,8 @@ struct consw {
 	int	(*con_set_origin)(struct vc_data *);
 	void	(*con_save_screen)(struct vc_data *);
 	u8	(*con_build_attr)(struct vc_data *, u8, u8, u8, u8, u8, u8);
-	void	(*con_invert_region)(struct vc_data *, u16 *, int);
-	u16    *(*con_screen_pos)(struct vc_data *, int);
+	void	(*con_invert_region)(struct vc_data *, u32 *, int);
+	u32    *(*con_screen_pos)(struct vc_data *, int);
 	unsigned long (*con_getxy)(struct vc_data *, unsigned long, int *, int *);
 };

diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 38fe59d..767596d 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -31,7 +31,7 @@ struct vc_data {
 	unsigned long	vc_visible_origin;	/* [!] Top of visible window */
 	unsigned int	vc_top, vc_bottom;	/* Scrolling region */
 	const struct consw *vc_sw;
-	unsigned short	*vc_screenbuf;		/* In-memory character/attribute buffer */
+	unsigned int	*vc_screenbuf;		/* In-memory character/attribute buffer */
 	unsigned int	vc_screenbuf_size;
 	unsigned char	vc_mode;		/* KD_TEXT, ... */
 	/* attributes for all characters on screen */
@@ -44,15 +44,15 @@ struct vc_data {
 	unsigned char	vc_halfcolor;		/* Color for half intensity mode */
 	/* cursor */
 	unsigned int	vc_cursor_type;
-	unsigned short	vc_complement_mask;	/* [#] Xor mask for mouse pointer */
-	unsigned short	vc_s_complement_mask;	/* Saved mouse pointer mask */
+	unsigned int	vc_complement_mask;	/* [#] Xor mask for mouse pointer */
+	unsigned int	vc_s_complement_mask;	/* Saved mouse pointer mask */
 	unsigned int	vc_x, vc_y;		/* Cursor position */
 	unsigned int	vc_saved_x, vc_saved_y;
 	unsigned long	vc_pos;			/* Cursor address */
 	/* fonts */	
 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256
chars of font or 0 if not supported */
 	struct console_font vc_font;		/* Current VC font set */
-	unsigned short	vc_video_erase_char;	/* Background erase character */
+	unsigned int	vc_video_erase_char;	/* Background erase character */
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
diff --git a/include/linux/selection.h b/include/linux/selection.h
index 8cdaa11..6570574 100644
--- a/include/linux/selection.h
+++ b/include/linux/selection.h
@@ -29,7 +29,7 @@ extern int default_red[];
 extern int default_grn[];
 extern int default_blu[];

-extern unsigned short *screen_pos(struct vc_data *vc, int w_offset,
int viewed);
+extern u32 *screen_pos(struct vc_data *vc, int w_offset, int viewed);
 extern u16 screen_glyph(struct vc_data *vc, int offset);
 extern void complement_pos(struct vc_data *vc, int offset);
 extern void invert_screen(struct vc_data *vc, int offset, int count,
int shift);
@@ -37,7 +37,7 @@ extern void invert_screen(struct vc_data *vc, int
offset, int count, int shift);
 extern void getconsxy(struct vc_data *vc, unsigned char *p);
 extern void putconsxy(struct vc_data *vc, unsigned char *p);

-extern u16 vcs_scr_readw(struct vc_data *vc, const u16 *org);
-extern void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org);
+extern u32 vcs_scr_readw(struct vc_data *vc, const u32 *org);
+extern void vcs_scr_writew(struct vc_data *vc, u32 val, u32 *org);

 #endif
diff --git a/include/linux/vt_buffer.h b/include/linux/vt_buffer.h
index 057db7d..e4669fa 100644
--- a/include/linux/vt_buffer.h
+++ b/include/linux/vt_buffer.h
@@ -28,30 +28,30 @@
 #endif

 #ifndef VT_BUF_HAVE_MEMSETW
-static inline void scr_memsetw(u16 *s, u16 c, unsigned int count)
+static inline void scr_memsetw(u32 *s, u32 c, unsigned int count)
 {
-	count /= 2;
+	count /= 4;
 	while (count--)
 		scr_writew(c, s++);
 }
 #endif

 #ifndef VT_BUF_HAVE_MEMCPYW
-static inline void scr_memcpyw(u16 *d, const u16 *s, unsigned int count)
+static inline void scr_memcpyw(u32 *d, const u32 *s, unsigned int count)
 {
-	count /= 2;
+	count /= 4;
 	while (count--)
 		scr_writew(scr_readw(s++), d++);
 }
 #endif

 #ifndef VT_BUF_HAVE_MEMMOVEW
-static inline void scr_memmovew(u16 *d, const u16 *s, unsigned int count)
+static inline void scr_memmovew(u32 *d, const u32 *s, unsigned int count)
 {
 	if (d < s)
 		scr_memcpyw(d, s, count);
 	else {
-		count /= 2;
+		count /= 4;
 		d += count;
 		s += count;
 		while (count--)
@@ -60,4 +60,7 @@ static inline void scr_memmovew(u16 *d, const u16
*s, unsigned int count)
 }
 #endif

+#define VT_BUF_ATTR_MASK 0xff000000
+#define VT_BUF_ATTR_SHIFT 24
+
 #endif
