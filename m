Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0HEOms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:42:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41633 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab0HEOk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:27 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/9] fb: add hooks to handle KDB enter/exit
Date: Thu,  5 Aug 2010 09:39:53 -0500
Message-Id: <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:06.0904 (UTC) FILETIME=[19061780:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

Add fb ops to handle enter/exit of the kernel debugger.  If present, the
fb core will register them with KGDB and they'll be called when the
debugger is entered and exited.  The new functions are responsible for
switching to an appropriate debug framebuffer and restoring the
interrupted state at exit time.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/video/console/fbcon.c |   26 ++++++++++++++++++++++++++
 drivers/video/console/fbcon.h |    1 +
 include/linux/fb.h            |   13 +++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b0a3fa0..3b3f574 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2342,6 +2342,30 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 	return 0;
 }
 
+static int fbcon_debug_enter(struct vc_data *vc)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	ops->save_graphics = ops->graphics;
+	ops->graphics = 0;
+	if (info->fbops->fb_debug_enter)
+		info->fbops->fb_debug_enter(info);
+	fbcon_set_palette(vc, color_table);
+	return 0;
+}
+
+static int fbcon_debug_leave(struct vc_data *vc)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	ops->graphics = ops->save_graphics;
+	if (info->fbops->fb_debug_leave)
+		info->fbops->fb_debug_leave(info);
+	return 0;
+}
+
 static int fbcon_get_font(struct vc_data *vc, struct console_font *font)
 {
 	u8 *fontdata = vc->vc_font.data;
@@ -3276,6 +3300,8 @@ static const struct consw fb_con = {
 	.con_screen_pos 	= fbcon_screen_pos,
 	.con_getxy 		= fbcon_getxy,
 	.con_resize             = fbcon_resize,
+	.con_debug_enter	= fbcon_debug_enter,
+	.con_debug_leave	= fbcon_debug_leave,
 };
 
 static struct notifier_block fbcon_event_notifier = {
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 89a3468..6bd2e0c 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -74,6 +74,7 @@ struct fbcon_ops {
 	int    cursor_reset;
 	int    blank_state;
 	int    graphics;
+	int    save_graphics; /* for debug enter/leave */
 	int    flags;
 	int    rotate;
 	int    cur_rotate;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index e7445df..0c5659c 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -3,6 +3,9 @@
 
 #include <linux/types.h>
 #include <linux/i2c.h>
+#ifdef __KERNEL__
+#include <linux/kgdb.h>
+#endif /* __KERNEL__ */
 
 /* Definitions of frame buffers						*/
 
@@ -607,6 +610,12 @@ struct fb_deferred_io {
  * LOCKING NOTE: those functions must _ALL_ be called with the console
  * semaphore held, this is the only suitable locking mechanism we have
  * in 2.6. Some may be called at interrupt time at this point though.
+ *
+ * The exception to this is the debug related hooks.  Putting the fb
+ * into a debug state (e.g. flipping to the kernel console) and restoring
+ * it must be done in a lock-free manner, so low level drivers should
+ * keep track of the initial console (if applicable) and may need to
+ * perform direct, unlocked hardware writes in these hooks.
  */
 
 struct fb_ops {
@@ -676,6 +685,10 @@ struct fb_ops {
 
 	/* teardown any resources to do with this framebuffer */
 	void (*fb_destroy)(struct fb_info *info);
+
+	/* called at KDB enter and leave time to prepare the console */
+	int (*fb_debug_enter)(struct fb_info *info);
+	int (*fb_debug_leave)(struct fb_info *info);
 };
 
 #ifdef CONFIG_FB_TILEBLITTING
-- 
1.6.4.rc1

