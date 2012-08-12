Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2HLOws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:52:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33220 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2HLOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:52:43 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-fbdev@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 09/11] fblog: register console driver
Date: Sun, 12 Aug 2012 16:53:23 +0200
Message-Id: <1344783205-2384-10-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to print the kernel log to all FBs so we need a console driver.
This registers the driver on startup and writes all messages to all
registered fblog instances.

We cannot share a console buffer between FBs because they might have
different resolutions. Therefore, we create one buffer per object. We
destroy the buffer during close() so we do not waste memory if it is not
used.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 150 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 8bcd0ce..2e39577 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -25,11 +25,34 @@
 
 #define pr_fmt(_fmt) KBUILD_MODNAME ": " _fmt
 
+#include <linux/console.h>
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 
+/**
+ * struct fblog_buf: Console text buffer
+ *
+ * Each framebuffer has its own text buffer which contains all characters that
+ * are currently printed on screen. The buffers might have different sizes and
+ * can be resized during runtime. When the buffer content changes, we redraw the
+ * screen.
+ *
+ * width: Width of buffer in characters
+ * height: Height of buffer in characters
+ * lines: Array of lines
+ * pos_x: Cursor x-position
+ * pos_y: Cursor y-position
+ */
+struct fblog_buf {
+	size_t width;
+	size_t height;
+	u16 **lines;
+	size_t pos_x;
+	size_t pos_y;
+};
+
 enum fblog_flags {
 	FBLOG_KILLED,
 	FBLOG_OPEN,
@@ -42,6 +65,7 @@ struct fblog_fb {
 	struct fb_info *info;
 	struct device dev;
 	struct mutex lock;
+	struct fblog_buf buf;
 };
 
 static DEFINE_MUTEX(fblog_registration_lock);
@@ -52,6 +76,106 @@ static bool main_only = false;
 
 #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
 
+static void fblog_buf_resize(struct fblog_buf *buf, size_t width,
+			     size_t height)
+{
+	u16 **lines = NULL;
+	size_t i, j, minw, minh;
+
+	if (buf->height == height && buf->width == width)
+		return;
+
+	if (width && height) {
+		lines = kzalloc(height * sizeof(char *), GFP_KERNEL);
+		if (!lines)
+			return;
+
+		for (i = 0; i < height; ++i) {
+			lines[i] = kzalloc(width * sizeof(u16), GFP_KERNEL);
+			if (!lines[i]) {
+				while (i--)
+					kfree(lines[i]);
+				return;
+			}
+		}
+
+		/* copy old lines */
+		minw = min(width, buf->width);
+		minh = min(height, buf->height);
+		if (height >= buf->height)
+			i = 0;
+		else
+			i = buf->height - height;
+
+		for (j = 0; j < minh; ++i, ++j)
+			memcpy(lines[j], buf->lines[i], minw * sizeof(u16));
+	} else {
+		width = 0;
+		height = 0;
+	}
+
+	for (i = 0; i < buf->height; ++i)
+		kfree(buf->lines[i]);
+	kfree(buf->lines);
+
+	buf->lines = lines;
+	buf->width = width;
+	buf->height = height;
+}
+
+static void fblog_buf_deinit(struct fblog_buf *buf)
+{
+	fblog_buf_resize(buf, 0, 0);
+}
+
+static void fblog_buf_rotate(struct fblog_buf *buf)
+{
+	u16 *line;
+
+	if (!buf->height)
+		return;
+
+	line = buf->lines[0];
+	memset(line, 0, sizeof(u16) * buf->width);
+
+	memmove(buf->lines, &buf->lines[1], sizeof(char*) * (buf->height - 1));
+	buf->lines[buf->height - 1] = line;
+}
+
+static void fblog_buf_write(struct fblog_buf *buf, const char *str, size_t len)
+{
+	char c;
+
+	if (!buf->height)
+		return;
+
+	while (len--) {
+		c = *str++;
+
+		if (c == 0)
+			c = '?';
+
+		if (c == '\n') {
+			buf->pos_x = 0;
+			if (++buf->pos_y >= buf->height) {
+				buf->pos_y = buf->height - 1;
+				fblog_buf_rotate(buf);
+			}
+		} else {
+			if (buf->pos_x >= buf->width) {
+				buf->pos_x = 0;
+				++buf->pos_y;
+			}
+			if (buf->pos_y >= buf->height) {
+				buf->pos_y = buf->height - 1;
+				fblog_buf_rotate(buf);
+			}
+
+			buf->lines[buf->pos_y][buf->pos_x++] = c;
+		}
+	}
+}
+
 /*
  * fblog_open/close()
  * These functions manage access to the underlying framebuffer. While opened, we
@@ -66,6 +190,7 @@ static bool main_only = false;
 
 static int fblog_open(struct fblog_fb *fb)
 {
+	static const char init_str[] = "Framebuffer log initialized\n";
 	int ret;
 
 	if (!active)
@@ -93,6 +218,8 @@ static int fblog_open(struct fblog_fb *fb)
 		goto out_unref;
 	}
 
+	fblog_buf_resize(&fb->buf, 80, 24);
+	fblog_buf_write(&fb->buf, init_str, sizeof(init_str) - 1);
 	set_bit(FBLOG_OPEN, &fb->flags);
 	mutex_unlock(&fb->lock);
 	return 0;
@@ -115,6 +242,7 @@ static void fblog_close(struct fblog_fb *fb, bool kill_dev)
 			fb->info->fbops->fb_release(fb->info, 0);
 		module_put(fb->info->fbops->owner);
 		clear_bit(FBLOG_OPEN, &fb->flags);
+		fblog_buf_deinit(&fb->buf);
 	}
 
 	if (kill_dev)
@@ -379,6 +507,26 @@ static struct notifier_block fblog_notifier = {
 	.notifier_call = fblog_event,
 };
 
+static void fblog_con_write(struct console *con, const char *buf,
+			    unsigned int len)
+{
+	int i;
+
+	mutex_lock(&fblog_registration_lock);
+	for (i = 0; i < FB_MAX; ++i) {
+		if (fblog_fbs[i]) {
+			fblog_buf_write(&fblog_fbs[i]->buf, buf, len);
+		}
+	}
+	mutex_unlock(&fblog_registration_lock);
+}
+
+static struct console fblog_con_driver = {
+	.name = "fblog",
+	.write = fblog_con_write,
+	.flags = CON_PRINTBUFFER | CON_ENABLED,
+};
+
 static int __init fblog_init(void)
 {
 	int ret;
@@ -390,6 +538,7 @@ static int __init fblog_init(void)
 	}
 
 	fblog_scan();
+	register_console(&fblog_con_driver);
 
 	return 0;
 }
@@ -399,6 +548,7 @@ static void __exit fblog_exit(void)
 	unsigned int i;
 	struct fb_info *info;
 
+	unregister_console(&fblog_con_driver);
 	fb_unregister_client(&fblog_notifier);
 
 	/* We scan through the whole registered_fb array here instead of
-- 
1.7.11.4

