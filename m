Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1ICQS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 12:18:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35148 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752244Ab1ICQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 12:18:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18KU6BQhrYKgxfB7g4iRVtAYfXP+exUeNyU1lVSWJ
	WLwbDDOxyn9ceH
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Bernie Thompson <bernie@plugable.com>,
        Martin Decky <martin@decky.cz>
Subject: Re: [PATCH 2/2] vt: dirty hack
Date: Sat,  3 Sep 2011 16:36:26 +0000
Message-Id: <1315067786-3278-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1315013361-3191-1-git-send-email-FlorianSchandinat@gmx.de>	<1315013361-3191-3-git-send-email-FlorianSchandinat@gmx.de> <20110903112542.5d3cbfcc@lxorguk.ukuu.org.uk>
In-Reply-To: <20110903112542.5d3cbfcc@lxorguk.ukuu.org.uk>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 09/03/2011 10:25 AM, Alan Cox wrote:
> On Sat,  3 Sep 2011 01:29:21 +0000
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
> All of the vt stuff wants doing properly not as hacks.
> 
> I think the fundamental change you need is to instroduce some sort of
> vc->group pointer and vc group object that holds all the globals in the
> vt layer for each group (ie move fg_console, console_blanked etc).

It sounds like a good idea. But I doubt that I need all of them for what
I want to achieve. For example, I think fg_console should be a console 
that gets keyboard data, but in my setup I have only one keyboard so that 
would not be needed. Note that the concept of visibility is already 
available for drivers via vc_display_fg which is used by CON_IS_VISIBLE()
my problem is just that it does not help if no updates are performed 
because everything is blanked (due to the lack of per display blanking).
Still your suggestion would be interesting to pursue later on to build 
multiple terminals, I guess Bernie would like that.

> That can be done in steps, and once done you can then start to use
> vc->group-> within the fbcon driver and possibly also have a per fb
> group data attached to vc->group->fb or similar.

Okay, I tried to implement this for blanking as it was already done for 
vc_display_fg, see the patch below. Does it look better?

> Hacks are fine for early prototyping but doing it right means thinking
> about the data structures you ultimately need so that existing systems
> work, multi-monitor continues to work and you can do proper multi-console
> stuff.
>
> I'm all for it happening done right, and some things like being able to
> attach an fb console to arbitary GEM objects would allow very nice
> integration of the console into things like Wayland.
> 
> Alan


Thanks,

Florian Tobias Schandinat


vt: allow per display blanking

At the moment blanking always affects all displays as it is done in
a global variable. This patch allows display driver to override it
and have their private blanking. The design is pretty much the same
as for vc_display_fg which is used for implementing per
driver/display visibility.
---
 drivers/tty/vt/vt.c            |   32 ++++++++++++++++----------------
 drivers/video/console/fbcon.c  |    9 ++++++---
 drivers/video/console/fbcon.h  |    1 +
 include/linux/console_struct.h |    1 +
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b3915b7..bc42f8e 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -277,7 +277,7 @@ static void notify_update(struct vc_data *vc)
 #ifdef VT_BUF_VRAM_ONLY
 #define DO_UPDATE(vc)	0
 #else
-#define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !console_blanked)
+#define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !*vc->vc_display_blanked)
 #endif
 
 static inline unsigned short *screenpos(struct vc_data *vc, int offset, int viewed)
@@ -619,7 +619,7 @@ static void hide_cursor(struct vc_data *vc)
 
 static void set_cursor(struct vc_data *vc)
 {
-	if (!IS_FG(vc) || console_blanked ||
+	if (!IS_FG(vc) || *vc->vc_display_blanked ||
 	    vc->vc_mode == KD_GRAPHICS)
 		return;
 	if (vc->vc_deccm) {
@@ -753,6 +753,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	__module_get(vc->vc_sw->owner);
 	vc->vc_num = num;
 	vc->vc_display_fg = &master_display_fg;
+	vc->vc_display_blanked = &console_blanked;
 	vc->vc_uni_pagedir_loc = &vc->vc_uni_pagedir;
 	vc->vc_uni_pagedir = 0;
 	vc->vc_hi_font_mask = 0;
@@ -2684,7 +2685,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			console_unlock();
 			break;
 		case TIOCL_BLANKEDSCREEN:
-			ret = console_blanked;
+			ret = *vc_cons[fg_console].d->vc_display_blanked;
 			break;
 		default:
 			ret = -EINVAL;
@@ -3454,9 +3455,9 @@ int con_debug_enter(struct vc_data *vc)
 	saved_last_console = last_console;
 	saved_want_console = want_console;
 	saved_vc_mode = vc->vc_mode;
-	saved_console_blanked = console_blanked;
+	saved_console_blanked = *vc->vc_display_blanked;
 	vc->vc_mode = KD_TEXT;
-	console_blanked = 0;
+	*vc->vc_display_blanked = 0;
 	if (vc->vc_sw->con_debug_enter)
 		ret = vc->vc_sw->con_debug_enter(vc);
 #ifdef CONFIG_KGDB_KDB
@@ -3498,10 +3499,9 @@ int con_debug_leave(void)
 	fg_console = saved_fg_console;
 	last_console = saved_last_console;
 	want_console = saved_want_console;
-	console_blanked = saved_console_blanked;
-	vc_cons[fg_console].d->vc_mode = saved_vc_mode;
-
 	vc = vc_cons[fg_console].d;
+	*vc->vc_display_blanked = saved_console_blanked;
+	vc->vc_mode = saved_vc_mode;
 	if (vc->vc_sw->con_debug_leave)
 		ret = vc->vc_sw->con_debug_leave(vc);
 	return ret;
@@ -3727,7 +3727,7 @@ void do_blank_screen(int entering_gfx)
 
 	WARN_CONSOLE_UNLOCKED();
 
-	if (console_blanked) {
+	if (*vc->vc_display_blanked) {
 		if (blank_state == blank_vesa_wait) {
 			blank_state = blank_off;
 			vc->vc_sw->con_blank(vc, vesa_blank_mode + 1, 0);
@@ -3740,7 +3740,7 @@ void do_blank_screen(int entering_gfx)
 		hide_cursor(vc);
 		save_screen(vc);
 		vc->vc_sw->con_blank(vc, -1, 1);
-		console_blanked = fg_console + 1;
+		*vc->vc_display_blanked = fg_console + 1;
 		blank_state = blank_off;
 		set_origin(vc);
 		return;
@@ -3752,7 +3752,7 @@ void do_blank_screen(int entering_gfx)
 
 	/* don't blank graphics */
 	if (vc->vc_mode != KD_TEXT) {
-		console_blanked = fg_console + 1;
+		*vc->vc_display_blanked = fg_console + 1;
 		return;
 	}
 
@@ -3763,7 +3763,7 @@ void do_blank_screen(int entering_gfx)
 	save_screen(vc);
 	/* In case we need to reset origin, blanking hook returns 1 */
 	i = vc->vc_sw->con_blank(vc, vesa_off_interval ? 1 : (vesa_blank_mode + 1), 0);
-	console_blanked = fg_console + 1;
+	*vc->vc_display_blanked = fg_console + 1;
 	if (i)
 		set_origin(vc);
 
@@ -3795,8 +3795,6 @@ void do_unblank_screen(int leaving_gfx)
 	WARN_CONSOLE_UNLOCKED();
 
 	ignore_poke = 0;
-	if (!console_blanked)
-		return;
 	if (!vc_cons_allocated(fg_console)) {
 		/* impossible */
 		pr_warning("unblank_screen: tty %d not allocated ??\n",
@@ -3804,6 +3802,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	}
 	vc = vc_cons[fg_console].d;
+	if (!*vc->vc_display_blanked)
+		return;
 	/* Try to unblank in oops case too */
 	if (vc->vc_mode != KD_TEXT && !vt_force_oops_output(vc))
 		return; /* but leave console_blanked != 0 */
@@ -3813,7 +3813,7 @@ void do_unblank_screen(int leaving_gfx)
 		blank_state = blank_normal_wait;
 	}
 
-	console_blanked = 0;
+	*vc->vc_display_blanked = 0;
 	if (vc->vc_sw->con_blank(vc, 0, leaving_gfx) || vt_force_oops_output(vc))
 		/* Low-level driver cannot restore -> do it ourselves */
 		update_screen(vc);
@@ -3871,7 +3871,7 @@ void poke_blanked_console(void)
 
 	if (ignore_poke || !vc_cons[fg_console].d || vc_cons[fg_console].d->vc_mode == KD_GRAPHICS)
 		return;
-	if (console_blanked)
+	if (*vc_cons[fg_console].d->vc_display_blanked)
 		unblank_screen();
 	else if (blankinterval) {
 		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index ce9a686..bb2bc13 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -294,7 +294,7 @@ static int get_color(struct vc_data *vc, struct fb_info *info,
 	int depth = fb_get_color_depth(&info->var, &info->fix);
 	int color = 0;
 
-	if (console_blanked) {
+	if (*vc->vc_display_blanked) {
 		unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
 
 		c = vc->vc_video_erase_char & charmask;
@@ -312,7 +312,7 @@ static int get_color(struct vc_data *vc, struct fb_info *info,
 		int fg = (info->fix.visual != FB_VISUAL_MONO01) ? col : 0;
 		int bg = (info->fix.visual != FB_VISUAL_MONO01) ? 0 : col;
 
-		if (console_blanked)
+		if (*vc->vc_display_blanked)
 			fg = bg;
 
 		color = (is_fg) ? fg : bg;
@@ -867,8 +867,10 @@ static int set_con2fb_map(int unit, int newidx, int user)
 		if (!ops->vc_fg || visible)
 			ops->vc_fg = vc;
 
-		if (vc && vc->vc_display_fg == &dummy_fg)
+		if (vc && vc->vc_display_fg == &dummy_fg) {
 			vc->vc_display_fg = &ops->vc_fg;
+			vc->vc_display_blanked = &ops->vc_blanked;
+		}
 
  		if (!found)
  			fbcon_add_cursor_timer(info);
@@ -1113,6 +1115,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		ops->vc_fg = vc;
 
 	vc->vc_display_fg = &ops->vc_fg;
+	vc->vc_display_blanked = &ops->vc_blanked;
 	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index adc7316..8d5f173 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -70,6 +70,7 @@ struct fbcon_ops {
 	struct fb_cursor cursor_state;
 	struct display *p;
 	struct vc_data *vc_fg;
+	int    vc_blanked;
         int    currcon;	                /* Current VC. */
 	int    cursor_flash;
 	int    cursor_reset;
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 7f0c329..086e623 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -104,6 +104,7 @@ struct vc_data {
 	unsigned int	vc_bell_pitch;		/* Console bell pitch */
 	unsigned int	vc_bell_duration;	/* Console bell duration */
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
+		 int	*vc_display_blanked;
 	unsigned long	vc_uni_pagedir;
 	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
 	bool vc_panic_force_write; /* when oops/panic this VC can accept forced output/blanking */
-- 
1.6.3.2

