Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2GOTHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:07:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37337 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2GOTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:35 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 10/11] fblog: draw console to framebuffers
Date: Sun, 15 Jul 2012 21:04:45 +0200
Message-Id: <1342379086-7583-11-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not disabled or suspended, we now blit the console data to each
framebuffer. We only redraw on changes to avoid consuming too much CPU
power.

This isn't optimized for speed, currently. However, fblog is mainly used
for debugging purposes so this can be optimized later.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 107 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index ae01742..81b0b42 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -28,8 +28,11 @@
 #include <linux/console.h>
 #include <linux/device.h>
 #include <linux/fb.h>
+#include <linux/font.h>
+#include <linux/kd.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include "fbdraw.h"
 
 /**
  * struct fblog_buf: Console text buffer
@@ -66,6 +69,7 @@ struct fblog_fb {
 	struct device dev;
 	struct mutex lock;
 	struct fblog_buf buf;
+	struct console_font font;
 };
 
 static DEFINE_MUTEX(fblog_registration_lock);
@@ -174,6 +178,58 @@ static void fblog_buf_write(struct fblog_buf *buf, const char *str, size_t len)
 	}
 }
 
+static void fblog_redraw_clear(struct fblog_fb *fb)
+{
+	struct fb_fillrect region;
+	struct fb_info *info = fb->info;
+
+	region.color = 0;
+	region.dx = 0;
+	region.dy = 0;
+	region.width = info->var.xres;
+	region.height = info->var.yres;
+	region.rop = ROP_COPY;
+
+	info->fbops->fb_fillrect(info, &region);
+}
+
+static void fblog_redraw(struct fblog_fb *fb)
+{
+	size_t i;
+
+	mutex_lock(&fb->lock);
+	if (!test_bit(FBLOG_OPEN, &fb->flags) ||
+	    test_bit(FBLOG_SUSPENDED, &fb->flags) ||
+	    test_bit(FBLOG_BLANKED, &fb->flags)) {
+		mutex_unlock(&fb->lock);
+		return;
+	}
+
+	fblog_redraw_clear(fb);
+
+	for (i = 0; i < fb->buf.height; ++i) {
+		fbdraw_font(fb->info, &fb->font, false, 0, i, 7, 0, 0,
+			    fb->buf.lines[i], fb->buf.width);
+	}
+
+	mutex_unlock(&fb->lock);
+}
+
+static void fblog_refresh(struct fblog_fb *fb)
+{
+	unsigned int width, height;
+
+	mutex_lock(&fb->lock);
+	if (test_bit(FBLOG_OPEN, &fb->flags)) {
+		width = fb->info->var.xres / fb->font.width;
+		height = fb->info->var.yres / fb->font.height;
+		fblog_buf_resize(&fb->buf, width, height);
+	}
+	mutex_unlock(&fb->lock);
+
+	fblog_redraw(fb);
+}
+
 /*
  * fblog_open/close()
  * These functions manage access to the underlying framebuffer. While opened, we
@@ -190,6 +246,10 @@ static int fblog_open(struct fblog_fb *fb)
 {
 	static const char init_str[] = "Framebuffer log initialized\n";
 	int ret;
+	struct fb_var_screeninfo var;
+	const struct fb_videomode *mode;
+	unsigned int width, height;
+	const struct font_desc *font;
 
 	mutex_lock(&fb->lock);
 
@@ -203,6 +263,13 @@ static int fblog_open(struct fblog_fb *fb)
 		goto unlock;
 	}
 
+	font = get_default_font(var.xres, var.yres, fb->info->pixmap.blit_x,
+				fb->info->pixmap.blit_y);
+	if (!font) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	if (!try_module_get(fb->info->fbops->owner)) {
 		ret = -ENODEV;
 		goto out_killed;
@@ -213,10 +280,22 @@ static int fblog_open(struct fblog_fb *fb)
 		goto out_unref;
 	}
 
-	fblog_buf_resize(&fb->buf, 80, 24);
+	var = fb->info->var;
+	mode = fb_find_best_mode(&var, &fb->info->modelist);
+	var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
+	fb_set_var(fb->info, &var);
+
+	fb->font.width = font->width;
+	fb->font.height = font->height;
+	fb->font.data = (void*)font->data;
+
+	width = var.xres / fb->font.width;
+	height = var.yres / fb->font.height;
+	fblog_buf_resize(&fb->buf, width, height);
 	fblog_buf_write(&fb->buf, init_str, sizeof(init_str) - 1);
 	set_bit(FBLOG_OPEN, &fb->flags);
 	mutex_unlock(&fb->lock);
+	fblog_redraw(fb);
 	return 0;
 
 out_unref:
@@ -453,6 +532,31 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 		else
 			set_bit(FBLOG_BLANKED, &fb->flags);
 		break;
+	case FB_EVENT_MODE_DELETE:
+		/* This is sent when a video mode is removed. The current video
+		 * mode is never removed! The console lock is held while this is
+		 * called. */
+		/* fallthrough */
+	case FB_EVENT_NEW_MODELIST:
+		/* This is sent when the modelist got changed. The console-lock
+		 * is held and we should reset the mode. */
+		/* fallthrough */
+	case FB_EVENT_MODE_CHANGE_ALL:
+		/* This is the same as below but notifies us that the user used
+		 * the FB_ACTIVATE_ALL flag when setting the video mode. */
+		/* fallthrough */
+	case FB_EVENT_MODE_CHANGE:
+		/* This is called when the _user_ changes the video mode via
+		 * ioctls. It is not sent, when the kernel changes the mode
+		 * internally. This callback is called inside fb_set_var() so
+		 * the console lock is held. */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (fb)
+			fblog_refresh(fb);
+		break;
 	}
 
 	return 0;
@@ -509,6 +613,7 @@ static void fblog_con_write(struct console *con, const char *buf,
 	for (i = 0; i < FB_MAX; ++i) {
 		if (fblog_fbs[i]) {
 			fblog_buf_write(&fblog_fbs[i]->buf, buf, len);
+			fblog_redraw(fblog_fbs[i]);
 		}
 	}
 	mutex_unlock(&fblog_registration_lock);
-- 
1.7.11.2

