Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2GOTHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:07:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62804 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2GOTFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:32 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 09/11] fblog: register console driver
Date: Sun, 15 Jul 2012 21:04:44 +0200
Message-Id: <1342379086-7583-10-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
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
index 9b975bc..ae01742 100644
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
@@ -50,6 +74,106 @@ static bool active = 1;
 
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
@@ -64,6 +188,7 @@ static bool active = 1;
 
 static int fblog_open(struct fblog_fb *fb)
 {
+	static const char init_str[] = "Framebuffer log initialized\n";
 	int ret;
 
 	mutex_lock(&fb->lock);
@@ -88,6 +213,8 @@ static int fblog_open(struct fblog_fb *fb)
 		goto out_unref;
 	}
 
+	fblog_buf_resize(&fb->buf, 80, 24);
+	fblog_buf_write(&fb->buf, init_str, sizeof(init_str) - 1);
 	set_bit(FBLOG_OPEN, &fb->flags);
 	mutex_unlock(&fb->lock);
 	return 0;
@@ -110,6 +237,7 @@ static void fblog_close(struct fblog_fb *fb, bool kill_dev)
 			fb->info->fbops->fb_release(fb->info, 0);
 		module_put(fb->info->fbops->owner);
 		clear_bit(FBLOG_OPEN, &fb->flags);
+		fblog_buf_deinit(&fb->buf);
 	}
 
 	if (kill_dev)
@@ -372,6 +500,26 @@ static struct notifier_block fblog_notifier = {
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
@@ -383,6 +531,7 @@ static int __init fblog_init(void)
 	}
 
 	fblog_scan();
+	register_console(&fblog_con_driver);
 
 	return 0;
 }
@@ -392,6 +541,7 @@ static void __exit fblog_exit(void)
 	unsigned int i;
 	struct fb_info *info;
 
+	unregister_console(&fblog_con_driver);
 	fb_unregister_client(&fblog_notifier);
 
 	/* We scan through the whole registered_fb array here instead of
-- 
1.7.11.2

