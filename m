Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0ISP3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:29:51 -0400
Received: from legolas.restena.lu ([158.64.1.34]:45180 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0ISP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:29:48 -0400
Date: Sun, 19 Sep 2010 17:28:33 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bernie Thompson <bernie@plugable.com>
Subject: [Patch, RFC] Make struct fb_info ref-counted with kref
Message-ID: <20100919172833.14bf291e@neptune.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For USB-attached (or other hot-(un)pluggable) framebuffers the current
fbdev infrastructure is not very helpful. Each such driver currently
needs to perform the ref-counting on its own in .fbops.fb_open and
.fbops.fb_release callbacks.

This patch moves the ref-counting in fbdev infrastructure.
(drivers have not been adjusted, all those releasing fb_info in
 .fbops.fb_destroy will not work -- patch for those will follow
 later on, all the others will continue to work fine)

API-wise the following changes are done:
- num_registered_fb and registered_fb variables are no more exported.
  New functions fb_get_registered() and fb_is_registered() replace
  them.
  The only know user of those was fbcon, thus the large diff on fbcon.c

  Note: the accesses to registered_fb and num_registered_fb look racy
  as there was not protection at all around them, potentially letting
  register_framebuffer() register two framebuffers on the same minor
  concurrently, fbcon access should have been safe by combination of
  its use of console_semaphore and reaction to events.
  In this patch I combined most of fbcon's accesses to registered_fb
  and num_registered_fb into fb_is_registered(), though I'm not sure
  if the num-check optimization is worth to keep or its check should
  be put into a separate function.

- framebuffer_release() is mapped to fb_put() but will go away
  when converting drivers

Reference count for fb_info can be increased with fb_get(fb_info) and
later released with fb_put(fb_info).


If you have concerns regarding the API changes, please let me know.


Thanks,
Bruno



 drivers/video/console/fbcon.c |  285 ++++++++++++++++++++++++++---------------
 drivers/video/fbmem.c         |  254 +++++++++++++++++++++++++++----------
 drivers/video/fbsysfs.c       |   10 +-
 include/linux/fb.h            |   20 +++-
 4 files changed, 396 insertions(+), 173 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 84f8423..011ef4c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -211,14 +211,11 @@ static inline void fbcon_set_rotation(struct fb_info *info)
 static void fbcon_rotate(struct fb_info *info, u32 rotate)
 {
 	struct fbcon_ops *ops= info->fbcon_par;
-	struct fb_info *fb_info;
 
 	if (!ops || ops->currcon == -1)
 		return;
 
-	fb_info = registered_fb[con2fb_map[ops->currcon]];
-
-	if (info == fb_info) {
+	if (fb_is_registered(info, con2fb_map[ops->currcon])) {
 		struct display *p = &fb_display[ops->currcon];
 
 		if (rotate < 4)
@@ -241,9 +238,11 @@ static void fbcon_rotate_all(struct fb_info *info, u32 rotate)
 		return;
 
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		struct fb_info *fb_info;
 		vc = vc_cons[i].d;
-		if (!vc || vc->vc_mode != KD_TEXT ||
-		    registered_fb[con2fb_map[i]] != info)
+		if (!vc || vc->vc_mode != KD_TEXT)
+			continue;
+		if (!fb_is_registered(info, con2fb_map[i]))
 			continue;
 
 		p = &fb_display[vc->vc_num];
@@ -380,7 +379,7 @@ static void fb_flashcursor(struct work_struct *work)
 		vc = vc_cons[ops->currcon].d;
 
 	if (!vc || !CON_IS_VISIBLE(vc) ||
- 	    registered_fb[con2fb_map[vc->vc_num]] != info ||
+ 	    !fb_is_registered(info, con2fb_map[vc->vc_num]) ||
 	    vc->vc_deccm != 1) {
 		release_console_sem();
 		return;
@@ -529,7 +528,7 @@ static int fbcon_takeover(int show_logo)
 {
 	int err, i;
 
-	if (!num_registered_fb)
+	if (!fb_is_registered(NULL, -1))
 		return -ENODEV;
 
 	if (!show_logo)
@@ -793,11 +792,12 @@ static void con2fb_init_display(struct vc_data *vc, struct fb_info *info,
 	if (show_logo) {
 		struct vc_data *fg_vc = vc_cons[fg_console].d;
 		struct fb_info *fg_info =
-			registered_fb[con2fb_map[fg_console]];
+			fb_get_registered(con2fb_map[fg_console]);
 
 		fbcon_prepare_logo(fg_vc, fg_info, fg_vc->vc_cols,
 				   fg_vc->vc_rows, fg_vc->vc_cols,
 				   fg_vc->vc_rows);
+		fb_put(fg_info);
 	}
 
 	update_screen(vc_cons[fg_console].d);
@@ -816,23 +816,24 @@ static int set_con2fb_map(int unit, int newidx, int user)
 {
 	struct vc_data *vc = vc_cons[unit].d;
 	int oldidx = con2fb_map[unit];
-	struct fb_info *info = registered_fb[newidx];
-	struct fb_info *oldinfo = NULL;
+	struct fb_info *info, *oldinfo = NULL;
  	int found, err = 0;
 
 	if (oldidx == newidx)
 		return 0;
 
-	if (!info || fbcon_has_exited)
+	info = fbcon_has_exited ? NULL : fb_get_registered(newidx);
+	if (!info)
 		return -EINVAL;
 
  	if (!err && !search_for_mapped_con()) {
 		info_idx = newidx;
+		fb_put(info);
 		return fbcon_takeover(0);
 	}
 
 	if (oldidx != -1)
-		oldinfo = registered_fb[oldidx];
+		oldinfo = fb_get_registered(oldidx);
 
 	found = search_fb_in_map(newidx);
 
@@ -864,6 +865,8 @@ static int set_con2fb_map(int unit, int newidx, int user)
 		info_idx = newidx;
 
 	release_console_sem();
+	fb_put(oldinfo);
+	fb_put(info);
  	return err;
 }
 
@@ -926,30 +929,34 @@ static const char *fbcon_startup(void)
 	int rows, cols;
 
 	/*
-	 *  If num_registered_fb is zero, this is a call for the dummy part.
-	 *  The frame buffer devices weren't initialized yet.
+	 *  If fb_is_registered(NULL, -1) returns zero, this is a call for the
+	 *  dummy part. The frame buffer devices weren't initialized yet.
 	 */
-	if (!num_registered_fb || info_idx == -1)
+	if (!fb_is_registered(NULL, -1) || info_idx == -1)
 		return display_desc;
 	/*
-	 * Instead of blindly using registered_fb[0], we use info_idx, set by
+	 * Instead of blindly using minor 0, we use info_idx, set by
 	 * fb_console_init();
 	 */
-	info = registered_fb[info_idx];
+	info = fb_get_registered(info_idx);
 	if (!info)
 		return NULL;
 	
 	owner = info->fbops->owner;
-	if (!try_module_get(owner))
+	if (!try_module_get(owner)) {
+		fb_put(info);
 		return NULL;
+	}
 	if (info->fbops->fb_open && info->fbops->fb_open(info, 0)) {
 		module_put(owner);
+		fb_put(info);
 		return NULL;
 	}
 
 	ops = kzalloc(sizeof(struct fbcon_ops), GFP_KERNEL);
 	if (!ops) {
 		module_put(owner);
+		fb_put(info);
 		return NULL;
 	}
 
@@ -1012,12 +1019,13 @@ static const char *fbcon_startup(void)
 
 	fbcon_add_cursor_timer(info);
 	fbcon_has_exited = 0;
+	fb_put(info);
 	return display_desc;
 }
 
 static void fbcon_init(struct vc_data *vc, int init)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops;
 	struct vc_data **default_mode = vc->vc_display_fg;
 	struct vc_data *svc = *default_mode;
@@ -1026,7 +1034,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	int cap, ret;
 
 	if (info_idx == -1 || info == NULL)
-	    return;
+		goto out;
 
 	cap = info->flags;
 
@@ -1035,7 +1043,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		logo = 0;
 
 	if (var_to_display(p, &info->var, info))
-		return;
+		goto out;
 
 	if (!info->fbcon_par)
 		con2fb_acquire_newinfo(vc, info, vc->vc_num, -1);
@@ -1153,6 +1161,8 @@ static void fbcon_init(struct vc_data *vc, int init)
 	}
 
 	ops->p = &fb_display[fg_console];
+out:
+	fb_put(info);
 }
 
 static void fbcon_free_font(struct display *p)
@@ -1166,7 +1176,7 @@ static void fbcon_free_font(struct display *p)
 static void fbcon_deinit(struct vc_data *vc)
 {
 	struct display *p = &fb_display[vc->vc_num];
-	struct fb_info *info;
+	struct fb_info *info = NULL;
 	struct fbcon_ops *ops;
 	int idx;
 
@@ -1176,7 +1186,7 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (idx == -1)
 		goto finished;
 
-	info = registered_fb[idx];
+	info = fb_get_registered(idx);
 
 	if (!info)
 		goto finished;
@@ -1192,6 +1202,7 @@ static void fbcon_deinit(struct vc_data *vc)
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
 
+	fb_put(info);
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
 
@@ -1226,17 +1237,17 @@ finished:
 static void fbcon_clear(struct vc_data *vc, int sy, int sx, int height,
 			int width)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	struct display *p = &fb_display[vc->vc_num];
 	u_int y_break;
 
 	if (fbcon_is_inactive(vc, info))
-		return;
+		goto out;
 
 	if (!height || !width)
-		return;
+		goto out;
 
 	if (sy < vc->vc_top && vc->vc_top == logo_lines)
 		vc->vc_top = 0;
@@ -1251,12 +1262,14 @@ static void fbcon_clear(struct vc_data *vc, int sy, int sx, int height,
 				 width);
 	} else
 		ops->clear(vc, info, real_y(p, sy), sx, height, width);
+out:
+	fb_put(info);
 }
 
 static void fbcon_putcs(struct vc_data *vc, const unsigned short *s,
 			int count, int ypos, int xpos)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct display *p = &fb_display[vc->vc_num];
 	struct fbcon_ops *ops = info->fbcon_par;
 
@@ -1264,6 +1277,7 @@ static void fbcon_putcs(struct vc_data *vc, const unsigned short *s,
 		ops->putcs(vc, info, s, count, real_y(p, ypos), xpos,
 			   get_color(vc, info, scr_readw(s), 1),
 			   get_color(vc, info, scr_readw(s), 0));
+	fb_put(info);
 }
 
 static void fbcon_putc(struct vc_data *vc, int c, int ypos, int xpos)
@@ -1276,22 +1290,23 @@ static void fbcon_putc(struct vc_data *vc, int c, int ypos, int xpos)
 
 static void fbcon_clear_margins(struct vc_data *vc, int bottom_only)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	if (!fbcon_is_inactive(vc, info))
 		ops->clear_margins(vc, info, bottom_only);
+	fb_put(info);
 }
 
 static void fbcon_cursor(struct vc_data *vc, int mode)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);
 
 	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
-		return;
+		goto out;
 
 	if (vc->vc_cursor_type & 0x10)
 		fbcon_del_cursor_timer(info);
@@ -1311,6 +1326,8 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	ops->cursor(vc, info, mode, y, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 	vbl_cursor_cnt = CURSOR_DRAW_DELAY;
+out:
+	fb_put(info);
 }
 
 static int scrollback_phys_max = 0;
@@ -1387,7 +1404,7 @@ static void fbcon_set_disp(struct fb_info *info, struct fb_var_screeninfo *var,
 
 static __inline__ void ywrap_up(struct vc_data *vc, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 	
@@ -1402,11 +1419,12 @@ static __inline__ void ywrap_up(struct vc_data *vc, int count)
 	if (scrollback_max > scrollback_phys_max)
 		scrollback_max = scrollback_phys_max;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static __inline__ void ywrap_down(struct vc_data *vc, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 	
@@ -1421,11 +1439,12 @@ static __inline__ void ywrap_down(struct vc_data *vc, int count)
 	if (scrollback_max < 0)
 		scrollback_max = 0;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static __inline__ void ypan_up(struct vc_data *vc, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct display *p = &fb_display[vc->vc_num];
 	struct fbcon_ops *ops = info->fbcon_par;
 
@@ -1445,11 +1464,12 @@ static __inline__ void ypan_up(struct vc_data *vc, int count)
 	if (scrollback_max > scrollback_phys_max)
 		scrollback_max = scrollback_phys_max;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static __inline__ void ypan_up_redraw(struct vc_data *vc, int t, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 
@@ -1469,11 +1489,12 @@ static __inline__ void ypan_up_redraw(struct vc_data *vc, int t, int count)
 	if (scrollback_max > scrollback_phys_max)
 		scrollback_max = scrollback_phys_max;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static __inline__ void ypan_down(struct vc_data *vc, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct display *p = &fb_display[vc->vc_num];
 	struct fbcon_ops *ops = info->fbcon_par;
 	
@@ -1493,11 +1514,12 @@ static __inline__ void ypan_down(struct vc_data *vc, int count)
 	if (scrollback_max < 0)
 		scrollback_max = 0;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static __inline__ void ypan_down_redraw(struct vc_data *vc, int t, int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 
@@ -1517,6 +1539,7 @@ static __inline__ void ypan_down_redraw(struct vc_data *vc, int t, int count)
 	if (scrollback_max < 0)
 		scrollback_max = 0;
 	scrollback_current = 0;
+	fb_put(info);
 }
 
 static void fbcon_redraw_softback(struct vc_data *vc, struct display *p,
@@ -1779,12 +1802,14 @@ static inline void fbcon_softback_note(struct vc_data *vc, int t,
 static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			int count)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct display *p = &fb_display[vc->vc_num];
 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
 
-	if (fbcon_is_inactive(vc, info))
+	if (fbcon_is_inactive(vc, info)) {
+		fb_put(info);
 		return -EINVAL;
+	}
 
 	fbcon_cursor(vc, CM_ERASE);
 
@@ -1812,6 +1837,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							(b - count)),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
+			fb_put(info);
 			return 1;
 			break;
 
@@ -1884,6 +1910,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							(b - count)),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
+			fb_put(info);
 			return 1;
 		}
 		break;
@@ -1903,6 +1930,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							t),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
+			fb_put(info);
 			return 1;
 			break;
 
@@ -1973,9 +2001,11 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							t),
 				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
+			fb_put(info);
 			return 1;
 		}
 	}
+	fb_put(info);
 	return 0;
 }
 
@@ -1983,14 +2013,14 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 static void fbcon_bmove(struct vc_data *vc, int sy, int sx, int dy, int dx,
 			int height, int width)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct display *p = &fb_display[vc->vc_num];
 	
 	if (fbcon_is_inactive(vc, info))
-		return;
+		goto out;
 
 	if (!width || !height)
-		return;
+		goto out;
 
 	/*  Split blits that cross physical y_wrap case.
 	 *  Pathological case involves 4 blits, better to use recursive
@@ -2001,12 +2031,14 @@ static void fbcon_bmove(struct vc_data *vc, int sy, int sx, int dy, int dx,
 	 */
 	fbcon_bmove_rec(vc, p, sy, sx, dy, dx, height, width,
 			p->vrows - p->yscroll);
+out:
+	fb_put(info);
 }
 
 static void fbcon_bmove_rec(struct vc_data *vc, struct display *p, int sy, int sx, 
 			    int dy, int dx, int height, int width, u_int y_break)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	u_int b;
 
@@ -2023,7 +2055,7 @@ static void fbcon_bmove_rec(struct vc_data *vc, struct display *p, int sy, int s
 			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
 					y_break);
 		}
-		return;
+		goto out;
 	}
 
 	if (dy < y_break && dy + height > y_break) {
@@ -2039,10 +2071,12 @@ static void fbcon_bmove_rec(struct vc_data *vc, struct display *p, int sy, int s
 			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
 					y_break);
 		}
-		return;
+		goto out;
 	}
 	ops->bmove(vc, info, real_y(p, sy), sx, real_y(p, dy), dx,
 		   height, width);
+out:
+	fb_put(info);
 }
 
 static void updatescrollmode(struct display *p,
@@ -2095,7 +2129,7 @@ static void updatescrollmode(struct display *p,
 static int fbcon_resize(struct vc_data *vc, unsigned int width, 
 			unsigned int height, unsigned int user)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 	struct fb_var_screeninfo var = info->var;
@@ -2118,12 +2152,12 @@ static int fbcon_resize(struct vc_data *vc, unsigned int width,
 		DPRINTK("attempting resize %ix%i\n", var.xres, var.yres);
 		mode = fb_find_best_mode(&var, &info->modelist);
 		if (mode == NULL)
-			return -EINVAL;
+			goto einval;
 		display_to_var(&var, p);
 		fb_videomode_to_var(&var, mode);
 
 		if (virt_w > var.xres/virt_fw || virt_h > var.yres/virt_fh)
-			return -EINVAL;
+			goto einval;
 
 		DPRINTK("resize now %ix%i\n", var.xres, var.yres);
 		if (CON_IS_VISIBLE(vc)) {
@@ -2135,7 +2169,11 @@ static int fbcon_resize(struct vc_data *vc, unsigned int width,
 		ops->var = info->var;
 	}
 	updatescrollmode(p, info, vc);
+	fb_put(info);
 	return 0;
+einval:
+	fb_put(info);
+	return -EINVAL;
 }
 
 static int fbcon_switch(struct vc_data *vc)
@@ -2146,7 +2184,7 @@ static int fbcon_switch(struct vc_data *vc)
 	struct fb_var_screeninfo var;
 	int i, ret, prev_console, charcnt = 256;
 
-	info = registered_fb[con2fb_map[vc->vc_num]];
+	info = fb_get_registered(con2fb_map[vc->vc_num]);
 	ops = info->fbcon_par;
 
 	if (softback_top) {
@@ -2168,7 +2206,7 @@ static int fbcon_switch(struct vc_data *vc)
 
 	prev_console = ops->currcon;
 	if (prev_console != -1)
-		old_info = registered_fb[con2fb_map[prev_console]];
+		old_info = fb_get_registered(con2fb_map[prev_console]);
 	/*
 	 * FIXME: If we have multiple fbdev's loaded, we need to
 	 * update all info->currcon.  Perhaps, we can place this
@@ -2178,11 +2216,13 @@ static int fbcon_switch(struct vc_data *vc)
 	 * info->currcon = vc->vc_num;
 	 */
 	for (i = 0; i < FB_MAX; i++) {
-		if (registered_fb[i] != NULL && registered_fb[i]->fbcon_par) {
-			struct fbcon_ops *o = registered_fb[i]->fbcon_par;
+		struct fb_info *fb = fb_get_registered(i);
+		if (fb != NULL && fb->fbcon_par) {
+			struct fbcon_ops *o = fb->fbcon_par;
 
 			o->currcon = vc->vc_num;
 		}
+		fb_put(fb);
 	}
 	memset(&var, 0, sizeof(struct fb_var_screeninfo));
 	display_to_var(&var, p);
@@ -2272,8 +2312,12 @@ static int fbcon_switch(struct vc_data *vc)
 			      vc->vc_origin + vc->vc_size_row * vc->vc_top,
 			      vc->vc_size_row * (vc->vc_bottom -
 						 vc->vc_top) / 2);
+		fb_put(info);
+		fb_put(old_info);
 		return 0;
 	}
+	fb_put(info);
+	fb_put(old_info);
 	return 1;
 }
 
@@ -2304,7 +2348,7 @@ static void fbcon_generic_blank(struct vc_data *vc, struct fb_info *info,
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	if (mode_switch) {
@@ -2341,12 +2385,13 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 	else
 		fbcon_add_cursor_timer(info);
 
+	fb_put(info);
 	return 0;
 }
 
 static int fbcon_debug_enter(struct vc_data *vc)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	ops->save_graphics = ops->graphics;
@@ -2354,17 +2399,19 @@ static int fbcon_debug_enter(struct vc_data *vc)
 	if (info->fbops->fb_debug_enter)
 		info->fbops->fb_debug_enter(info);
 	fbcon_set_palette(vc, color_table);
+	fb_put(info);
 	return 0;
 }
 
 static int fbcon_debug_leave(struct vc_data *vc)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	ops->graphics = ops->save_graphics;
 	if (info->fbops->fb_debug_leave)
 		info->fbops->fb_debug_leave(info);
+	fb_put(info);
 	return 0;
 }
 
@@ -2422,7 +2469,7 @@ static int fbcon_get_font(struct vc_data *vc, struct console_font *font)
 static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 			     const u8 * data, int userfont)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *p = &fb_display[vc->vc_num];
 	int resize;
@@ -2520,6 +2567,7 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 
 	if (old_data && (--REFCOUNT(old_data) == 0))
 		kfree(old_data - FONT_EXTRA_WORDS * sizeof(int));
+	fb_put(info);
 	return 0;
 }
 
@@ -2547,7 +2595,7 @@ static int fbcon_copy_font(struct vc_data *vc, int con)
 
 static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigned flags)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	unsigned charcount = font->charcount;
 	int w = font->width;
 	int h = font->height;
@@ -2558,24 +2606,32 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigne
 
 	/* Is there a reason why fbconsole couldn't handle any charcount >256?
 	 * If not this check should be changed to charcount < 256 */
-	if (charcount != 256 && charcount != 512)
+	if (charcount != 256 && charcount != 512) {
+		fb_put(info);
 		return -EINVAL;
+	}
 
 	/* Make sure drawing engine can handle the font */
 	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
-	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+	    !(info->pixmap.blit_y & (1 << (font->height - 1)))) {
+	    	fb_put(info);
 		return -EINVAL;
+	}
 
 	/* Make sure driver can handle the font length */
-	if (fbcon_invalid_charcount(info, charcount))
+	if (fbcon_invalid_charcount(info, charcount)) {
+		fb_put(info);
 		return -EINVAL;
+	}
 
 	size = h * pitch * charcount;
 
 	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
 
-	if (!new_data)
+	if (!new_data) {
+		fb_put(info);
 		return -ENOMEM;
+	}
 
 	new_data += FONT_EXTRA_WORDS * sizeof(int);
 	FNTSIZE(new_data) = size;
@@ -2605,22 +2661,26 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigne
 			break;
 		}
 	}
+	fb_put(info);
 	return fbcon_do_set_font(vc, font->width, font->height, new_data, 1);
 }
 
 static int fbcon_set_def_font(struct vc_data *vc, struct console_font *font, char *name)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
 	const struct font_desc *f;
 
 	if (!name)
 		f = get_default_font(info->var.xres, info->var.yres,
 				     info->pixmap.blit_x, info->pixmap.blit_y);
-	else if (!(f = find_font(name)))
+	else if (!(f = find_font(name))) {
+		fb_put(info);
 		return -ENOENT;
+	}
 
 	font->width = f->width;
 	font->height = f->height;
+	fb_put(info);
 	return fbcon_do_set_font(vc, f->width, f->height, f->data, 0);
 }
 
@@ -2634,15 +2694,19 @@ static struct fb_cmap palette_cmap = {
 
 static int fbcon_set_palette(struct vc_data *vc, unsigned char *table)
 {
-	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
-	int i, j, k, depth;
+	struct fb_info *info = fb_get_registered(con2fb_map[vc->vc_num]);
+	int i, j, k, depth, ret;
 	u8 val;
 
-	if (fbcon_is_inactive(vc, info))
-		return -EINVAL;
+	if (fbcon_is_inactive(vc, info)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (!CON_IS_VISIBLE(vc))
-		return 0;
+	if (!CON_IS_VISIBLE(vc)) {
+		ret = 0;
+		goto out;
+	}
 
 	depth = fb_get_color_depth(&info->var, &info->fix);
 	if (depth > 3) {
@@ -2664,7 +2728,10 @@ static int fbcon_set_palette(struct vc_data *vc, unsigned char *table)
 	} else
 		fb_copy_cmap(fb_default_cmap(1 << depth), &palette_cmap);
 
-	return fb_set_cmap(&palette_cmap, info);
+	ret = fb_set_cmap(&palette_cmap, info);
+out:
+	fb_put(info);
+	return ret;
 }
 
 static u16 *fbcon_screen_pos(struct vc_data *vc, int offset)
@@ -2747,16 +2814,16 @@ static void fbcon_invert_region(struct vc_data *vc, u16 * p, int cnt)
 
 static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 {
-	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
+	struct fb_info *info = fb_get_registered(con2fb_map[fg_console]);
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct display *disp = &fb_display[fg_console];
-	int offset, limit, scrollback_old;
+	int offset, limit, scrollback_old, ret = 0;
 
 	if (softback_top) {
 		if (vc->vc_num != fg_console)
-			return 0;
+			goto out;
 		if (vc->vc_mode != KD_TEXT || !lines)
-			return 0;
+			goto out;
 		if (logo_shown >= 0) {
 			struct vc_data *conp2 = vc_cons[logo_shown].d;
 
@@ -2789,11 +2856,13 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 		fbcon_cursor(vc, CM_ERASE | CM_SOFTBACK);
 		fbcon_redraw_softback(vc, disp, lines);
 		fbcon_cursor(vc, CM_DRAW | CM_SOFTBACK);
-		return 0;
+		goto out;
 	}
 
-	if (!scrollback_phys_max)
-		return -ENOSYS;
+	if (!scrollback_phys_max) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
 	scrollback_old = scrollback_current;
 	scrollback_current -= lines;
@@ -2802,10 +2871,10 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 	else if (scrollback_current > scrollback_max)
 		scrollback_current = scrollback_max;
 	if (scrollback_current == scrollback_old)
-		return 0;
+		goto out;
 
 	if (fbcon_is_inactive(vc, info))
-		return 0;
+		goto out;
 
 	fbcon_cursor(vc, CM_ERASE);
 
@@ -2832,7 +2901,10 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 
 	if (!scrollback_current)
 		fbcon_cursor(vc, CM_DRAW);
-	return 0;
+
+out:
+	fb_put(info);
+	return ret;
 }
 
 static int fbcon_set_origin(struct vc_data *vc)
@@ -2878,7 +2950,7 @@ static void fbcon_modechanged(struct fb_info *info)
 		return;
 	vc = vc_cons[ops->currcon].d;
 	if (vc->vc_mode != KD_TEXT ||
-	    registered_fb[con2fb_map[ops->currcon]] != info)
+	    !fb_is_registered(info, con2fb_map[ops->currcon]))
 		return;
 
 	p = &fb_display[vc->vc_num];
@@ -2920,7 +2992,7 @@ static void fbcon_set_all_vcs(struct fb_info *info)
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		vc = vc_cons[i].d;
 		if (!vc || vc->vc_mode != KD_TEXT ||
-		    registered_fb[con2fb_map[i]] != info)
+		    !fb_is_registered(info, con2fb_map[i]))
 			continue;
 
 		if (CON_IS_VISIBLE(vc)) {
@@ -2945,7 +3017,6 @@ static void fbcon_set_all_vcs(struct fb_info *info)
 static int fbcon_mode_deleted(struct fb_info *info,
 			      struct fb_videomode *mode)
 {
-	struct fb_info *fb_info;
 	struct display *p;
 	int i, j, found = 0;
 
@@ -2954,8 +3025,7 @@ static int fbcon_mode_deleted(struct fb_info *info,
 		j = con2fb_map[i];
 		if (j == -1)
 			continue;
-		fb_info = registered_fb[j];
-		if (fb_info != info)
+		if (!fb_is_registered(info, j))
 			continue;
 		p = &fb_display[i];
 		if (!p || !p->mode)
@@ -3028,7 +3098,9 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 		info_idx = -1;
 
 		for (i = 0; i < FB_MAX; i++) {
-			if (registered_fb[i] != NULL) {
+			struct fb_info *fb_info = fb_get_registered(i);
+			fb_put(fb_info);
+			if (fb_info != NULL) {
 				info_idx = i;
 				break;
 			}
@@ -3045,7 +3117,7 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	if (primary_device == idx)
 		primary_device = -1;
 
-	if (!num_registered_fb)
+	if (!fb_is_registered(NULL, -1))
 		unregister_con_driver(&fb_con);
 
 	return 0;
@@ -3132,7 +3204,7 @@ static void fbcon_fb_blanked(struct fb_info *info, int blank)
 
 	vc = vc_cons[ops->currcon].d;
 	if (vc->vc_mode != KD_TEXT ||
-			registered_fb[con2fb_map[ops->currcon]] != info)
+			!fb_is_registered(info, con2fb_map[ops->currcon]))
 		return;
 
 	if (CON_IS_VISIBLE(vc)) {
@@ -3152,7 +3224,7 @@ static void fbcon_new_modelist(struct fb_info *info)
 	const struct fb_videomode *mode;
 
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
-		if (registered_fb[con2fb_map[i]] != info)
+		if (!fb_is_registered(info, con2fb_map[i]))
 			continue;
 		if (!fb_display[i].mode)
 			continue;
@@ -3324,12 +3396,13 @@ static ssize_t store_rotate(struct device *device,
 	acquire_console_sem();
 	idx = con2fb_map[fg_console];
 
-	if (idx == -1 || registered_fb[idx] == NULL)
+	info = fb_get_registered(idx);
+	if (!info);
 		goto err;
 
-	info = registered_fb[idx];
 	rotate = simple_strtoul(buf, last, 0);
 	fbcon_rotate(info, rotate);
+	fb_put(info);
 err:
 	release_console_sem();
 	return count;
@@ -3349,12 +3422,13 @@ static ssize_t store_rotate_all(struct device *device,
 	acquire_console_sem();
 	idx = con2fb_map[fg_console];
 
-	if (idx == -1 || registered_fb[idx] == NULL)
+	info = fb_get_registered(idx);
+	if (!info)
 		goto err;
 
-	info = registered_fb[idx];
 	rotate = simple_strtoul(buf, last, 0);
 	fbcon_rotate_all(info, rotate);
+	fb_put(info);
 err:
 	release_console_sem();
 	return count;
@@ -3372,11 +3446,12 @@ static ssize_t show_rotate(struct device *device,
 	acquire_console_sem();
 	idx = con2fb_map[fg_console];
 
-	if (idx == -1 || registered_fb[idx] == NULL)
+	info = fb_get_registered(idx);
+	if (!info)
 		goto err;
 
-	info = registered_fb[idx];
 	rotate = fbcon_get_rotate(info);
+	fb_put(info);
 err:
 	release_console_sem();
 	return snprintf(buf, PAGE_SIZE, "%d\n", rotate);
@@ -3395,10 +3470,10 @@ static ssize_t show_cursor_blink(struct device *device,
 	acquire_console_sem();
 	idx = con2fb_map[fg_console];
 
-	if (idx == -1 || registered_fb[idx] == NULL)
+	info = fb_get_registered(idx);
+	if (!info)
 		goto err;
 
-	info = registered_fb[idx];
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -3406,6 +3481,7 @@ static ssize_t show_cursor_blink(struct device *device,
 
 	blink = (ops->flags & FBCON_FLAGS_CURSOR_TIMER) ? 1 : 0;
 err:
+	fb_put(info);
 	release_console_sem();
 	return snprintf(buf, PAGE_SIZE, "%d\n", blink);
 }
@@ -3424,11 +3500,10 @@ static ssize_t store_cursor_blink(struct device *device,
 	acquire_console_sem();
 	idx = con2fb_map[fg_console];
 
-	if (idx == -1 || registered_fb[idx] == NULL)
+	info = fb_get_registered(idx);
+	if (!info)
 		goto err;
 
-	info = registered_fb[idx];
-
 	if (!info->fbcon_par)
 		goto err;
 
@@ -3443,6 +3518,7 @@ static ssize_t store_cursor_blink(struct device *device,
 	}
 
 err:
+	fb_put(info);
 	release_console_sem();
 	return count;
 }
@@ -3479,13 +3555,15 @@ static int fbcon_init_device(void)
 
 static void fbcon_start(void)
 {
-	if (num_registered_fb) {
+	if (fb_is_registered(NULL, -1)) {
 		int i;
 
 		acquire_console_sem();
 
 		for (i = 0; i < FB_MAX; i++) {
-			if (registered_fb[i] != NULL) {
+			struct fb_info *fb_info = fb_get_registered(i);
+			if (fb_info) {
+				fb_put(fb_info);
 				info_idx = i;
 				break;
 			}
@@ -3511,7 +3589,7 @@ static void fbcon_exit(void)
 		int pending;
 
 		mapped = 0;
-		info = registered_fb[i];
+		info = fb_get_registered(i);
 
 		if (info == NULL)
 			continue;
@@ -3542,6 +3620,7 @@ static void fbcon_exit(void)
 			if (info->queue.func == fb_flashcursor)
 				info->queue.func = NULL;
 		}
+		fb_put(info);
 	}
 
 	fbcon_has_exited = 1;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index b066475..eb89523 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -42,8 +42,60 @@
 
 #define FBPIXMAPSIZE	(1024 * 8)
 
-struct fb_info *registered_fb[FB_MAX] __read_mostly;
-int num_registered_fb __read_mostly;
+static spinlock_t lock_registered_fb = SPIN_LOCK_UNLOCKED;
+static struct fb_info *registered_fb[FB_MAX] __read_mostly;
+static int num_registered_fb __read_mostly;
+
+/**
+ * fb_get_registered - get a reference to framebuffer registered
+ * at @fbidx.
+ *
+ * Note: returns pointer to registered framebuffer with incremented
+ * refcount.
+ */
+struct fb_info *fb_get_registered(int fbidx)
+{
+	unsigned long flags;
+	struct fb_info *ret;
+
+	if (fbidx < 0 || fbidx >= FB_MAX)
+		return NULL;
+	spin_lock_irqsave(&lock_registered_fb, flags);
+	ret = registered_fb[fbidx];
+	if (IS_ERR(ret))
+		ret = NULL;
+	if (ret)
+		kref_get(&ret->refcount);
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
+	return ret;
+}
+
+/**
+ * fb_is_registered - check if a framebuffer is registered
+ *
+ * @fbidx:   -1 to check at position fb_info->node, other
+ *           make sure framebuffer is registered at mentioned
+ *           index
+ * @fb_info: NULL to request count of registered framebuffers,
+ *           otherwise framebuffer to verify is registered
+ */
+int fb_is_registered(struct fb_info *fb_info, int fbidx)
+{
+	unsigned long flags;
+	int ret;
+
+	if (fbidx < -1 || fbidx >= FB_MAX)
+		return 0;
+	spin_lock_irqsave(&lock_registered_fb, flags);
+	if (fbidx >= 0)
+		ret = registered_fb[fbidx] == fb_info;
+	else if (!fb_info)
+		ret = num_registered_fb;
+	else
+		ret = registered_fb[fb_info->node] == fb_info;
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
+	return ret;
+}
 
 int lock_fb_info(struct fb_info *info)
 {
@@ -663,10 +715,12 @@ static void fb_seq_stop(struct seq_file *m, void *v)
 static int fb_seq_show(struct seq_file *m, void *v)
 {
 	int i = *(loff_t *)v;
-	struct fb_info *fi = registered_fb[i];
+	struct fb_info *fi = fb_get_registered(i);
 
-	if (fi)
+	if (fi) {
 		seq_printf(m, "%d %s\n", fi->node, fi->fix.id);
+		fb_put(fi);
+	}
 	return 0;
 }
 
@@ -696,28 +750,34 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = fb_get_registered(fbidx);
 	u32 *buffer, *dst;
 	u32 __iomem *src;
 	int c, i, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || ! info->screen_base)
-		return -ENODEV;
+	if (!info || ! info->screen_base) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (info->state != FBINFO_STATE_RUNNING) {
+		err = -EPERM;
+		goto out;
+	}
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (info->fbops->fb_read) {
+		cnt = info->fbops->fb_read(info, buf, count, ppos);
+		goto out;
+	}
 
-	if (info->fbops->fb_read)
-		return info->fbops->fb_read(info, buf, count, ppos);
-	
 	total_size = info->screen_size;
 
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
 	if (p >= total_size)
-		return 0;
+		goto out;
 
 	if (count >= total_size)
 		count = total_size;
@@ -727,8 +787,10 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	src = (u32 __iomem *) (info->screen_base + p);
 
@@ -762,6 +824,9 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	kfree(buffer);
 
+out:
+	if (info)
+		fb_put(info);
 	return (err) ? err : cnt;
 }
 
@@ -771,28 +836,36 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = fb_get_registered(fbidx);
 	u32 *buffer, *src;
 	u32 __iomem *dst;
 	int c, i, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || !info->screen_base)
-		return -ENODEV;
+	if (!info || !info->screen_base) {
+		err = -ENODEV;
+		goto out;
+	}
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (info->state != FBINFO_STATE_RUNNING) {
+		err = -EPERM;
+		goto out;
+	}
 
-	if (info->fbops->fb_write)
-		return info->fbops->fb_write(info, buf, count, ppos);
+	if (info->fbops->fb_write) {
+		cnt = info->fbops->fb_write(info, buf, count, ppos);
+		goto out;
+	}
 	
 	total_size = info->screen_size;
 
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
-	if (p > total_size)
-		return -EFBIG;
+	if (p > total_size) {
+		err = -EFBIG;
+		goto out;
+	}
 
 	if (count > total_size) {
 		err = -EFBIG;
@@ -808,8 +881,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	dst = (u32 __iomem *) (info->screen_base + p);
 
@@ -846,6 +921,9 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	kfree(buffer);
 
+out:
+	if (info)
+		fb_put(info);
 	return (cnt) ? cnt : err;
 }
 
@@ -1121,6 +1199,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EINVAL;
 		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 			return -EINVAL;
+		/* FIXME: these should never hit as fb_ioctl() looks for info before calling us! */
 		if (!registered_fb[con2fb.framebuffer])
 			request_module("fb%d", con2fb.framebuffer);
 		if (!registered_fb[con2fb.framebuffer]) {
@@ -1161,9 +1240,15 @@ static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = fb_get_registered(fbidx);
+	long ret;
+
+	if (!info)
+		return -ENODEV;
 
-	return do_fb_ioctl(info, cmd, arg);
+	ret = do_fb_ioctl(info, cmd, arg);
+	fb_put(info);
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1285,10 +1370,14 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
-	struct fb_ops *fb = info->fbops;
+	struct fb_info *info = fb_get_registered(fbidx);
+	struct fb_ops *fb;
 	long ret = -ENOIOCTLCMD;
 
+	if (!info)
+		return -ENODEV;
+	fb = info->fbops;
+
 	switch(cmd) {
 	case FBIOGET_VSCREENINFO:
 	case FBIOPUT_VSCREENINFO:
@@ -1314,6 +1403,7 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			ret = fb->fb_compat_ioctl(info, cmd, arg);
 		break;
 	}
+	fb_put(info);
 	return ret;
 }
 #endif
@@ -1322,23 +1412,31 @@ static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
-	struct fb_info *info = registered_fb[fbidx];
-	struct fb_ops *fb = info->fbops;
+	struct fb_info *info = fb_get_registered(fbidx);
+	struct fb_ops *fb;
 	unsigned long off;
 	unsigned long start;
 	u32 len;
+	int ret = 0;
 
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
-		return -EINVAL;
-	off = vma->vm_pgoff << PAGE_SHIFT;
-	if (!fb)
+	if (!info)
 		return -ENODEV;
+	fb = info->fbops;
+
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	off = vma->vm_pgoff << PAGE_SHIFT;
+	if (!fb) {
+		ret = -ENODEV;
+		goto out;
+	}
 	mutex_lock(&info->mm_lock);
 	if (fb->fb_mmap) {
-		int res;
-		res = fb->fb_mmap(info, vma);
+		ret = fb->fb_mmap(info, vma);
 		mutex_unlock(&info->mm_lock);
-		return res;
+		goto out;
 	}
 
 	/* frame buffer memory */
@@ -1349,15 +1447,18 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 		off -= len;
 		if (info->var.accel_flags) {
 			mutex_unlock(&info->mm_lock);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		start = info->fix.mmio_start;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
 	}
 	mutex_unlock(&info->mm_lock);
 	start &= PAGE_MASK;
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
+	if ((vma->vm_end - vma->vm_start + off) > len) {
+		ret = -EINVAL;
+		goto out;
+	}
 	off += start;
 	vma->vm_pgoff = off >> PAGE_SHIFT;
 	/* This is an IO map - tell maydump to skip this VMA */
@@ -1365,9 +1466,13 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	fb_pgprotect(file, vma, off);
 	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+			     vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+out:
+	fb_put(info);
+	return ret;
 }
 
 static int
@@ -1381,12 +1486,13 @@ __releases(&info->lock)
 
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
-	info = registered_fb[fbidx];
-	if (!info)
+	info = fb_get_registered(fbidx);
+	if (!info) {
 		request_module("fb%d", fbidx);
-	info = registered_fb[fbidx];
-	if (!info)
-		return -ENODEV;
+		info = fb_get_registered(fbidx);
+		if (!info)
+			return -ENODEV;
+	}
 	mutex_lock(&info->lock);
 	if (!try_module_get(info->fbops->owner)) {
 		res = -ENODEV;
@@ -1404,6 +1510,8 @@ __releases(&info->lock)
 #endif
 out:
 	mutex_unlock(&info->lock);
+	if (res)
+		fb_put(info);
 	return res;
 }
 
@@ -1419,6 +1527,7 @@ __releases(&info->lock)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
 	mutex_unlock(&info->lock);
+	fb_put(info);
 	return 0;
 }
 
@@ -1513,22 +1622,25 @@ void remove_conflicting_framebuffers(struct apertures_struct *a,
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for (i = 0 ; i < FB_MAX; i++) {
 		struct apertures_struct *gen_aper;
-		if (!registered_fb[i])
+		struct fb_info *info = fb_get_registered(i);
+		if (!info)
 			continue;
 
-		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
-			continue;
+		if (!(info->flags & FBINFO_MISC_FIRMWARE))
+			goto done;
 
-		gen_aper = registered_fb[i]->apertures;
+		gen_aper = info->apertures;
 		if (fb_do_apertures_overlap(gen_aper, a) ||
 			(primary && gen_aper && gen_aper->count &&
 			 gen_aper->ranges[0].base == VGA_FB_PHYS)) {
 
 			printk(KERN_ERR "fb: conflicting fb hw usage "
 			       "%s vs %s - removing generic driver\n",
-			       name, registered_fb[i]->fix.id);
-			unregister_framebuffer(registered_fb[i]);
+			       name, info->fix.id);
+			unregister_framebuffer(info);
 		}
+done:
+		fb_put(info);
 	}
 }
 EXPORT_SYMBOL(remove_conflicting_framebuffers);
@@ -1549,9 +1661,7 @@ register_framebuffer(struct fb_info *fb_info)
 	int i;
 	struct fb_event event;
 	struct fb_videomode mode;
-
-	if (num_registered_fb == FB_MAX)
-		return -ENXIO;
+	unsigned long flags;
 
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
@@ -1559,11 +1669,19 @@ register_framebuffer(struct fb_info *fb_info)
 	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
 					 fb_is_primary_device(fb_info));
 
+	spin_lock_irqsave(&lock_registered_fb, flags);
+	if (num_registered_fb == FB_MAX) {
+		spin_unlock_irqrestore(&lock_registered_fb, flags);
+		return -ENXIO;
+	}
+
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
 		if (!registered_fb[i])
 			break;
+	registered_fb[i] = ERR_PTR(-EBUSY);
 	fb_info->node = i;
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
 	mutex_init(&fb_info->lock);
 	mutex_init(&fb_info->mm_lock);
 
@@ -1599,7 +1717,9 @@ register_framebuffer(struct fb_info *fb_info)
 
 	fb_var_to_videomode(&mode, &fb_info->var);
 	fb_add_videomode(&mode, &fb_info->modelist);
+	spin_lock_irqsave(&lock_registered_fb, flags);
 	registered_fb[i] = fb_info;
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
 
 	event.info = fb_info;
 	if (!lock_fb_info(fb_info))
@@ -1632,12 +1752,15 @@ unregister_framebuffer(struct fb_info *fb_info)
 {
 	struct fb_event event;
 	int i, ret = 0;
+	unsigned long flags;
 
 	i = fb_info->node;
-	if (!registered_fb[i]) {
+	spin_lock_irqsave(&lock_registered_fb, flags);
+	if (registered_fb[i] != fb_info)
 		ret = -EINVAL;
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
+	if (ret)
 		goto done;
-	}
 
 
 	if (!lock_fb_info(fb_info))
@@ -1655,16 +1778,17 @@ unregister_framebuffer(struct fb_info *fb_info)
 	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
 		kfree(fb_info->pixmap.addr);
 	fb_destroy_modelist(&fb_info->modelist);
+	spin_lock_irqsave(&lock_registered_fb, flags);
 	registered_fb[i]=NULL;
 	num_registered_fb--;
+	spin_unlock_irqrestore(&lock_registered_fb, flags);
 	fb_cleanup_device(fb_info);
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 
 	/* this may free fb info */
-	if (fb_info->fbops->fb_destroy)
-		fb_info->fbops->fb_destroy(fb_info);
+	fb_put(fb_info);
 done:
 	return ret;
 }
@@ -1864,10 +1988,10 @@ __setup("video=", video_setup);
      *  Visible symbols for modules
      */
 
+EXPORT_SYMBOL(fb_get_registered);
+EXPORT_SYMBOL(fb_is_registered);
 EXPORT_SYMBOL(register_framebuffer);
 EXPORT_SYMBOL(unregister_framebuffer);
-EXPORT_SYMBOL(num_registered_fb);
-EXPORT_SYMBOL(registered_fb);
 EXPORT_SYMBOL(fb_show_logo);
 EXPORT_SYMBOL(fb_set_var);
 EXPORT_SYMBOL(fb_blank);
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 0a08f13..be5f342 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -58,6 +58,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 		info->par = p + fb_info_size;
 
 	info->device = dev;
+	kref_init(&info->refcount);
 
 #ifdef CONFIG_FB_BACKLIGHT
 	mutex_init(&info->bl_curve_mutex);
@@ -78,12 +79,17 @@ EXPORT_SYMBOL(framebuffer_alloc);
  * framebuffer info structure.
  *
  */
-void framebuffer_release(struct fb_info *info)
+void _fb_destroy(struct kref *ref)
 {
+	struct fb_info *info = container_of(ref, struct fb_info, refcount);
+
+	if (info->fbops->fb_destroy)
+		info->fbops->fb_destroy(info);
+
 	kfree(info->apertures);
 	kfree(info);
 }
-EXPORT_SYMBOL(framebuffer_release);
+EXPORT_SYMBOL(_fb_destroy);
 
 static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index f0268de..9d59684 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -834,6 +834,7 @@ struct fb_info {
 	int flags;
 	struct mutex lock;		/* Lock for open/release/ioctl funcs */
 	struct mutex mm_lock;		/* Lock for fb_mmap and smem_* fields */
+	struct kref refcount;		/* Reference count of framebuffer */
 	struct fb_var_screeninfo var;	/* Current var */
 	struct fb_fix_screeninfo fix;	/* Current fix */
 	struct fb_monspecs monspecs;	/* Current Monitor specs */
@@ -986,6 +987,8 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 			    size_t count, loff_t *ppos);
 
 /* drivers/video/fbmem.c */
+extern struct fb_info *fb_get_registered(int fbidx);
+extern int fb_is_registered(struct fb_info *fb_info, int fbidx);
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
 extern void remove_conflicting_framebuffers(struct apertures_struct *a,
@@ -1002,8 +1005,8 @@ extern int fb_get_color_depth(struct fb_var_screeninfo *var,
 extern int fb_get_options(char *name, char **option);
 extern int fb_new_modelist(struct fb_info *info);
 
-extern struct fb_info *registered_fb[FB_MAX];
-extern int num_registered_fb;
+/* extern struct fb_info *registered_fb[FB_MAX];
+extern int num_registered_fb; */
 extern struct class *fb_class;
 
 extern int lock_fb_info(struct fb_info *info);
@@ -1057,11 +1060,22 @@ static inline bool fb_be_math(struct fb_info *info)
 
 /* drivers/video/fbsysfs.c */
 extern struct fb_info *framebuffer_alloc(size_t size, struct device *dev);
-extern void framebuffer_release(struct fb_info *info);
+#define framebuffer_release(a) fb_put(a)
+extern void _fb_destroy(struct kref *ref);
 extern int fb_init_device(struct fb_info *fb_info);
 extern void fb_cleanup_device(struct fb_info *head);
 extern void fb_bl_default_curve(struct fb_info *fb_info, u8 off, u8 min, u8 max);
 
+static inline void fb_get(struct fb_info *fb_info)
+{
+	kref_get(&fb_info->refcount);
+}
+static inline void fb_put(struct fb_info *fb_info)
+{
+	if (fb_info)
+		kref_put(&fb_info->refcount, _fb_destroy);
+}
+
 /* drivers/video/fbmon.c */
 #define FB_MAXTIMINGS		0
 #define FB_VSYNCTIMINGS		1
