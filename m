Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2GDVtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 17:49:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58100 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2GDVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 17:48:51 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 1/2] fbcon: move update_attr() into separate source file
Date: Wed,  4 Jul 2012 23:48:33 +0200
Message-Id: <1341438514-1786-2-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341438514-1786-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341438514-1786-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to use update_attr() independently from fbcon, we need to split
it off from bitblit.c and fbcon.h. Therefore, introduce a new header and
source file (fbdraw.[ch]) which does not depende on vc_* and fbcon_*
structures in any way.

This does not introduce any new code nor does it make the paths deeper,
it simply splits the function off.

The other update_attr() functions (inside the rotation sources) seem
similar but are significantly different and I haven't found a way to merge
them efficiently (which is probably the reason why they are split off
now). Furthermore, I do not intend to use them in the coming code so there
is no need to split them off.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/Makefile  |  3 ++-
 drivers/video/console/bitblit.c | 26 +++--------------------
 drivers/video/console/fbcon.h   |  5 +----
 drivers/video/console/fbdraw.c  | 46 +++++++++++++++++++++++++++++++++++++++++
 drivers/video/console/fbdraw.h  | 26 +++++++++++++++++++++++
 5 files changed, 78 insertions(+), 28 deletions(-)
 create mode 100644 drivers/video/console/fbdraw.c
 create mode 100644 drivers/video/console/fbdraw.h

diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
index a862e91..9a52226 100644
--- a/drivers/video/console/Makefile
+++ b/drivers/video/console/Makefile
@@ -25,7 +25,8 @@ obj-$(CONFIG_SGI_NEWPORT_CONSOLE) += newport_con.o font.o
 obj-$(CONFIG_STI_CONSOLE)         += sticon.o sticore.o font.o
 obj-$(CONFIG_VGA_CONSOLE)         += vgacon.o
 obj-$(CONFIG_MDA_CONSOLE)         += mdacon.o
-obj-$(CONFIG_FRAMEBUFFER_CONSOLE) += fbcon.o bitblit.o font.o softcursor.o
+obj-$(CONFIG_FRAMEBUFFER_CONSOLE) += fbcon.o bitblit.o font.o softcursor.o \
+                                     fbdraw.o
 ifeq ($(CONFIG_FB_TILEBLITTING),y)
 obj-$(CONFIG_FRAMEBUFFER_CONSOLE)     += tileblit.o
 endif
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 28b1a83..6ec2905 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -22,26 +22,6 @@
 /*
  * Accelerated handlers.
  */
-static void update_attr(u8 *dst, u8 *src, int attribute,
-			       struct vc_data *vc)
-{
-	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
-	int width = DIV_ROUND_UP(vc->vc_font.width, 8);
-	unsigned int cellsize = vc->vc_font.height * width;
-	u8 c;
-
-	offset = cellsize - (offset * width);
-	for (i = 0; i < cellsize; i++) {
-		c = src[i];
-		if (attribute & FBCON_ATTRIBUTE_UNDERLINE && i >= offset)
-			c = 0xff;
-		if (attribute & FBCON_ATTRIBUTE_BOLD)
-			c |= c >> 1;
-		if (attribute & FBCON_ATTRIBUTE_REVERSE)
-			c = ~c;
-		dst[i] = c;
-	}
-}
 
 static void bit_bmove(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int dy, int dx, int height, int width)
@@ -88,7 +68,7 @@ static inline void bit_putcs_aligned(struct vc_data *vc, struct fb_info *info,
 					  charmask)*cellsize;
 
 		if (attr) {
-			update_attr(buf, src, attr, vc);
+			fbdraw_update_attr(buf, src, attr, &vc->vc_font);
 			src = buf;
 		}
 
@@ -123,7 +103,7 @@ static inline void bit_putcs_unaligned(struct vc_data *vc,
 					  charmask)*cellsize;
 
 		if (attr) {
-			update_attr(buf, src, attr, vc);
+			fbdraw_update_attr(buf, src, attr, &vc->vc_font);
 			src = buf;
 		}
 
@@ -275,7 +255,7 @@ static void bit_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 			return;
 		kfree(ops->cursor_data);
 		ops->cursor_data = dst;
-		update_attr(dst, src, attribute, vc);
+		fbdraw_update_attr(dst, src, attribute, &vc->vc_font);
 		src = dst;
 	}
 
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 6bd2e0c..8623bac 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -16,6 +16,7 @@
 #include <linux/vt_kern.h>
 
 #include <asm/io.h>
+#include "fbdraw.h"
 
 #define FBCON_FLAGS_INIT         1
 #define FBCON_FLAGS_CURSOR_TIMER 2
@@ -219,10 +220,6 @@ extern void fbcon_set_tileops(struct vc_data *vc, struct fb_info *info);
 extern void fbcon_set_bitops(struct fbcon_ops *ops);
 extern int  soft_cursor(struct fb_info *info, struct fb_cursor *cursor);
 
-#define FBCON_ATTRIBUTE_UNDERLINE 1
-#define FBCON_ATTRIBUTE_REVERSE   2
-#define FBCON_ATTRIBUTE_BOLD      4
-
 static inline int real_y(struct display *p, int ypos)
 {
 	int rows = p->vrows;
diff --git a/drivers/video/console/fbdraw.c b/drivers/video/console/fbdraw.c
new file mode 100644
index 0000000..65e7003
--- /dev/null
+++ b/drivers/video/console/fbdraw.c
@@ -0,0 +1,46 @@
+/*
+ * Framebuffer helpers for image draw-operations
+ *
+ * Copyright (c) 2004 Antonino Daplas <adaplas @pol.net>
+ * Copyright (c) 2012 David Herrmann <dh.herrmann@googlemail.com>
+ *
+ * Originally from drivers/video/console/bitblit.c which itself originally is
+ * from the 'accel_*' routines in drivers/video/console/fbcon.c.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#include <linux/console.h>
+#include <linux/fb.h>
+#include <linux/kd.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include "fbdraw.h"
+
+void fbdraw_update_attr(u8 *dst, const u8 *src, int attribute,
+			struct console_font *font)
+{
+	int i, offset = (font->height < 10) ? 1 : 2;
+	int width = DIV_ROUND_UP(font->width, 8);
+	unsigned int cellsize = font->height * width;
+	u8 c;
+
+	offset = cellsize - (offset * width);
+	for (i = 0; i < cellsize; i++) {
+		c = src[i];
+		if (attribute & FBCON_ATTRIBUTE_UNDERLINE && i >= offset)
+			c = 0xff;
+		if (attribute & FBCON_ATTRIBUTE_BOLD)
+			c |= c >> 1;
+		if (attribute & FBCON_ATTRIBUTE_REVERSE)
+			c = ~c;
+		dst[i] = c;
+	}
+}
+EXPORT_SYMBOL(fbdraw_update_attr);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("David Herrmann <dh.herrmann@googlemail.com>");
+MODULE_DESCRIPTION("Framebuffer helpers for image draw-operations");
diff --git a/drivers/video/console/fbdraw.h b/drivers/video/console/fbdraw.h
new file mode 100644
index 0000000..77edd7f
--- /dev/null
+++ b/drivers/video/console/fbdraw.h
@@ -0,0 +1,26 @@
+/*
+ * Framebuffer helpers for image draw-operations
+ *
+ * Copyright (c) 2012 David Herrmann <dh.herrmann@googlemail.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#ifndef _VIDEO_FBDRAW_H
+#define _VIDEO_FBDRAW_H
+
+#include <linux/console.h>
+#include <linux/fb.h>
+#include <linux/kd.h>
+
+/* fbcon character attributes */
+#define FBCON_ATTRIBUTE_UNDERLINE 1
+#define FBCON_ATTRIBUTE_REVERSE   2
+#define FBCON_ATTRIBUTE_BOLD      4
+
+void fbdraw_update_attr(u8 *dst, const u8 *src, int attribute,
+			struct console_font *font);
+
+#endif /* _VIDEO_FBDRAW_H */
-- 
1.7.11.1

