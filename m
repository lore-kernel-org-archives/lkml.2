Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2HLOyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 10:54:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41246 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2HLOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 10:52:37 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-fbdev@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 04/11] fbdev: export get_fb_info()/put_fb_info()
Date: Sun, 12 Aug 2012 16:53:18 +0200
Message-Id: <1344783205-2384-5-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding other internal users of the framebuffer subsystem, we need a
way to get references to framebuffers. These two functions already exist
so export them.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/fbmem.c | 6 ++++--
 include/linux/fb.h    | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0dff12a..1312ba2 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -46,7 +46,7 @@ static DEFINE_MUTEX(registration_lock);
 struct fb_info *registered_fb[FB_MAX] __read_mostly;
 int num_registered_fb __read_mostly;
 
-static struct fb_info *get_fb_info(unsigned int idx)
+struct fb_info *get_fb_info(unsigned int idx)
 {
 	struct fb_info *fb_info;
 
@@ -61,14 +61,16 @@ static struct fb_info *get_fb_info(unsigned int idx)
 
 	return fb_info;
 }
+EXPORT_SYMBOL_GPL(get_fb_info);
 
-static void put_fb_info(struct fb_info *fb_info)
+void put_fb_info(struct fb_info *fb_info)
 {
 	if (!atomic_dec_and_test(&fb_info->count))
 		return;
 	if (fb_info->fbops->fb_destroy)
 		fb_info->fbops->fb_destroy(fb_info);
 }
+EXPORT_SYMBOL_GPL(put_fb_info);
 
 int lock_fb_info(struct fb_info *info)
 {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index ac3f1c6..2d51c0e 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1033,6 +1033,9 @@ static inline void unlock_fb_info(struct fb_info *info)
 	mutex_unlock(&info->lock);
 }
 
+extern struct fb_info *get_fb_info(unsigned int idx);
+extern void put_fb_info(struct fb_info *fb_info);
+
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
 {
-- 
1.7.11.4

