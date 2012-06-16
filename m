Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2FPWE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:04:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35897 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FPWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:04:53 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 03/10] fblog: register framebuffer objects
Date: Sun, 17 Jun 2012 00:04:19 +0200
Message-Id: <1339884266-9201-4-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We register each available framebuffer in the system with the fblog driver
so we always know all active devices. We directly open the fb-driver,
initialize the buffer and load a font so we are ready for drawing
operations. If a device cannot be opened, we mark it as dead and ignore it
in all other functions.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c |  108 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 1504ba9..8038dcc 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -39,6 +39,14 @@
 #include <linux/font.h>
 #include <linux/module.h>
 
+#define FBLOG_STR(x) x, sizeof(x) - 1
+
+enum fblog_flags {
+	FBLOG_KILLED,
+	FBLOG_SUSPENDED,
+	FBLOG_BLANKED,
+};
+
 /**
  * struct fblog_buf: Console text buffer
  *
@@ -61,6 +69,30 @@ struct fblog_buf {
 	size_t pos_y;
 };
 
+/**
+ * struct fblog_fb: Framebuffer object
+ *
+ * For each framebuffer we register this object. It contains all data we need to
+ * display the console log on it. The index of a framebuffer in registered_fb[]
+ * is the same as in fblog_fbs[]. So the following must always be true if the
+ * pointers are non-NULL:
+ *     registered_fb[idx] == fblog_fbs[idx]->info
+ *     fblog_fbs[idx]->info->node == idx
+ *
+ * flags: Framebuffer flags (see fblog_flags)
+ * info: Pointer to the associated framebuffer device
+ * font: Currently used font
+ * buf: Console text buffer
+ */
+struct fblog_fb {
+	unsigned long flags;
+	struct fb_info *info;
+	const struct font_desc *font;
+	struct fblog_buf buf;
+};
+
+static struct fblog_fb *fblog_fbs[FB_MAX];
+
 static void fblog_buf_resize(struct fblog_buf *buf, size_t width,
 			     size_t height)
 {
@@ -165,6 +197,82 @@ static void fblog_buf_write(struct fblog_buf *buf, const char *str, size_t len)
 	}
 }
 
+static struct fblog_fb *fblog_info2fb(struct fb_info *info)
+{
+	if (!info || info->node < 0 || info->node >= FB_MAX ||
+	    !registered_fb[info->node])
+		return NULL;
+
+	return fblog_fbs[info->node];
+}
+
+static void fblog_register(struct fb_info *info)
+{
+	struct fblog_fb *fb;
+	struct fb_var_screeninfo var;
+	const struct fb_videomode *mode;
+	unsigned int width, height;
+
+	if (!info || info->node < 0 || info->node >= FB_MAX)
+		return;
+	if (!registered_fb[info->node] || fblog_fbs[info->node])
+		return;
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb)
+		return;
+
+	fblog_fbs[info->node] = fb;
+	fb->info = info;
+	fblog_buf_init(&fb->buf);
+	fblog_buf_write(&fb->buf, FBLOG_STR("Framebuffer log initialized\n"));
+
+	if (!try_module_get(info->fbops->owner))
+		goto out_killed;
+	if (info->fbops->fb_open && info->fbops->fb_open(info, 0))
+		goto out_unref;
+
+	var = info->var;
+	mode = fb_find_best_mode(&var, &info->modelist);
+	var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
+	fb_set_var(info, &var);
+
+	fb->font = get_default_font(info->var.xres, info->var.yres,
+				    info->pixmap.blit_x,
+				    info->pixmap.blit_y);
+	if (fb->font) {
+		width = info->var.xres / fb->font->width;
+		height = info->var.yres / fb->font->height;
+		fblog_buf_resize(&fb->buf, width, height);
+	}
+
+	return;
+
+out_unref:
+	module_put(info->fbops->owner);
+out_killed:
+	set_bit(FBLOG_KILLED, &fb->flags);
+}
+
+static void fblog_unregister(struct fblog_fb *fb)
+{
+	struct fb_info *info;
+
+	if (!fb)
+		return;
+
+	info = fb->info;
+	if (!test_bit(FBLOG_KILLED, &fb->flags)) {
+		if (info->fbops->fb_release)
+			info->fbops->fb_release(info, 0);
+		module_put(info->fbops->owner);
+	}
+
+	fblog_buf_deinit(&fb->buf);
+	fblog_fbs[info->node] = NULL;
+	kfree(fb);
+}
+
 static int __init fblog_init(void)
 {
 	return 0;
-- 
1.7.10.4

