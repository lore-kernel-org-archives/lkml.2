Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1ICBL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 21:11:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41675 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465Ab1ICBL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 21:11:26 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/QOIxYy9LQjNJpqWU2+s50LA1RTlVhBPs+aJ2fZp
	4UolINn7JO8q+a
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Bernie Thompson <bernie@plugable.com>, Martin Decky <martin@decky.cz>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] fbdev: allow multiple concurrent visible consoles
Date: Sat,  3 Sep 2011 01:29:20 +0000
Message-Id: <1315013361-3191-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1315013361-3191-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1315013361-3191-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows having multiple visible consoles that receive
display updates. For example one can have running "top" to monitor
the system on fb0 and at the same time work on a shell on fb1.
At the moment that works only with consoles, not with console and
graphical application nor with two graphical applications.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/console/fbcon.c |   34 ++++++++++++++++++++++++++++++----
 drivers/video/console/fbcon.h |    1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 8745637..ce9a686 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -94,6 +94,7 @@ enum {
 };
 
 static struct display fb_display[MAX_NR_CONSOLES];
+static struct vc_data *dummy_fg;
 
 static signed char con2fb_map[MAX_NR_CONSOLES];
 static signed char con2fb_map_boot[MAX_NR_CONSOLES];
@@ -816,7 +817,8 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	int oldidx = con2fb_map[unit];
 	struct fb_info *info = registered_fb[newidx];
 	struct fb_info *oldinfo = NULL;
- 	int found, err = 0;
+	struct fbcon_ops *ops;
+	int found, err = 0, visible = vc && CON_IS_VISIBLE(vc);
 
 	if (oldidx == newidx)
 		return 0;
@@ -839,6 +841,15 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
 
+	if (!err && vc && oldinfo && oldinfo->fbcon_par) {
+		ops = oldinfo->fbcon_par;
+		if (vc->vc_display_fg == &ops->vc_fg) {
+			if (CON_IS_VISIBLE(vc))
+				ops->vc_fg = NULL;
+
+			vc->vc_display_fg = &dummy_fg;
+		}
+	}
 
 	/*
 	 * If old fb is not mapped to any of the consoles,
@@ -852,6 +863,13 @@ static int set_con2fb_map(int unit, int newidx, int user)
  		int show_logo = (fg_console == 0 && !user &&
  				 logo_shown != FBCON_LOGO_DONTSHOW);
 
+		ops = info->fbcon_par;
+		if (!ops->vc_fg || visible)
+			ops->vc_fg = vc;
+
+		if (vc && vc->vc_display_fg == &dummy_fg)
+			vc->vc_display_fg = &ops->vc_fg;
+
  		if (!found)
  			fbcon_add_cursor_timer(info);
  		con2fb_map_boot[unit] = newidx;
@@ -1023,8 +1041,10 @@ static void fbcon_init(struct vc_data *vc, int init)
 	int logo = 1, new_rows, new_cols, rows, cols, charcnt = 256;
 	int cap, ret;
 
-	if (info_idx == -1 || info == NULL)
-	    return;
+	if (info_idx == -1 || info == NULL) {
+		vc->vc_display_fg = &dummy_fg;
+		return;
+	}
 
 	cap = info->flags;
 
@@ -1089,6 +1109,10 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con_copy_unimap(vc, svc);
 
 	ops = info->fbcon_par;
+	if (!ops->vc_fg)
+		ops->vc_fg = vc;
+
+	vc->vc_display_fg = &ops->vc_fg;
 	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
@@ -1184,8 +1208,10 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (!ops)
 		goto finished;
 
-	if (CON_IS_VISIBLE(vc))
+	if (CON_IS_VISIBLE(vc)) {
 		fbcon_del_cursor_timer(info);
+		ops->vc_fg = NULL;
+	}
 
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 6bd2e0c..adc7316 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -69,6 +69,7 @@ struct fbcon_ops {
 	struct timer_list cursor_timer; /* Cursor timer */
 	struct fb_cursor cursor_state;
 	struct display *p;
+	struct vc_data *vc_fg;
         int    currcon;	                /* Current VC. */
 	int    cursor_flash;
 	int    cursor_reset;
-- 
1.6.3.2

