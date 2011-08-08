Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1HHKTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:19:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35186 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751255Ab1HHKTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:19:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+uFfYh4QCuucbptyDpp7ccuuE7ipV7MGTR+H0eRL
	/pyJEAZIF5KSoL
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [RFC] fbdev: allow multiple concurrent visible consoles
Date: Mon,  8 Aug 2011 10:37:44 +0000
Message-Id: <1312799864-3468-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
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
 drivers/video/console/fbcon.c |   13 ++++++++++++-
 drivers/video/console/fbcon.h |    1 +
 2 files changed, 13 insertions(+), 1 deletions(-)

There are probably still some bugs in this and it requires a lot of 
review and testing before it ready for inclusion. I just want to 
know whether it looks good and whether the approach taken 
(it's my 3rd) is acceptable. I think the feature is desirable 
and I hope that we can avoid the limitation to consoles only one day. 
The problem that causes it is that the vt.c has a global blanking 
variable it sets as soon as any graphical application starts and 
hence no console updates go through anymore.

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 8745637..5246a15 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -710,8 +710,11 @@ static int con2fb_acquire_newinfo(struct vc_data *vc, struct fb_info *info,
 	if (!err) {
 		info->fbcon_par = ops;
 
-		if (vc)
+		if (vc) {
+			ops->vc_fg = vc;
+			vc->vc_display_fg = &ops->vc_fg;
 			set_blitting_type(vc, info);
+		}
 	}
 
 	if (err) {
@@ -814,6 +817,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 {
 	struct vc_data *vc = vc_cons[unit].d;
 	int oldidx = con2fb_map[unit];
+	struct fbcon_ops *ops;
 	struct fb_info *info = registered_fb[newidx];
 	struct fb_info *oldinfo = NULL;
  	int found, err = 0;
@@ -839,6 +843,11 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
 
+	if (!err && oldinfo) {
+		ops = oldinfo->fbcon_par;
+		if (vc == ops->vc_fg)
+			ops->vc_fg = NULL;
+	}
 
 	/*
 	 * If old fb is not mapped to any of the consoles,
@@ -849,6 +858,8 @@ static int set_con2fb_map(int unit, int newidx, int user)
  					     found);
 
  	if (!err) {
+		ops = info->fbcon_par;
+		vc->vc_display_fg = &ops->vc_fg;
  		int show_logo = (fg_console == 0 && !user &&
  				 logo_shown != FBCON_LOGO_DONTSHOW);
 
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

