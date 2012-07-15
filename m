Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2GOTGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:06:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50941 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2GOTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:29 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 06/11] fblog: open fb on registration
Date: Sun, 15 Jul 2012 21:04:41 +0200
Message-Id: <1342379086-7583-7-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This opens the framebuffer upon registration so we can use it for
drawing-operations. On unregistration we close it again.

While opening/closing or accessing the fb in any other way, we must hold
the fb-mutex. However, since the notifiers are often called with the mutex
already held, we cannot lock it _after_ taking the
fblog_registration_lock. Therefore, we require the caller to make sure the
fb-mutex is held.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 94 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 279f4d8..1c526c5 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -32,12 +32,14 @@
 
 enum fblog_flags {
 	FBLOG_KILLED,
+	FBLOG_OPEN,
 };
 
 struct fblog_fb {
 	unsigned long flags;
 	struct fb_info *info;
 	struct device dev;
+	struct mutex lock;
 };
 
 static DEFINE_MUTEX(fblog_registration_lock);
@@ -46,6 +48,74 @@ static struct fblog_fb *fblog_fbs[FB_MAX];
 #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
 
 /*
+ * fblog_open/close()
+ * These functions manage access to the underlying framebuffer. While opened, we
+ * have a valid reference to the fb and can use it for drawing operations. When
+ * the fb is unregistered, we drop our reference and close the fb so it can get
+ * deleted properly. We also mark it as dead so no further fblog_open() call
+ * will succeed.
+ * Both functions must be called with the fb->info->lock mutex held! But make
+ * sure to lock it _before_ locking the fblog-registration-lock. Otherwise, we
+ * will dead-lock with fb-registration.
+ */
+
+static int fblog_open(struct fblog_fb *fb)
+{
+	int ret;
+
+	mutex_lock(&fb->lock);
+
+	if (test_bit(FBLOG_KILLED, &fb->flags)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	if (test_bit(FBLOG_OPEN, &fb->flags)) {
+		ret = 0;
+		goto unlock;
+	}
+
+	if (!try_module_get(fb->info->fbops->owner)) {
+		ret = -ENODEV;
+		goto out_killed;
+	}
+
+	if (fb->info->fbops->fb_open && fb->info->fbops->fb_open(fb->info, 0)) {
+		ret = -EIO;
+		goto out_unref;
+	}
+
+	set_bit(FBLOG_OPEN, &fb->flags);
+	mutex_unlock(&fb->lock);
+	return 0;
+
+out_unref:
+	module_put(fb->info->fbops->owner);
+out_killed:
+	set_bit(FBLOG_KILLED, &fb->flags);
+unlock:
+	mutex_unlock(&fb->lock);
+	return ret;
+}
+
+static void fblog_close(struct fblog_fb *fb, bool kill_dev)
+{
+	mutex_lock(&fb->lock);
+
+	if (test_bit(FBLOG_OPEN, &fb->flags)) {
+		if (fb->info->fbops->fb_release)
+			fb->info->fbops->fb_release(fb->info, 0);
+		module_put(fb->info->fbops->owner);
+		clear_bit(FBLOG_OPEN, &fb->flags);
+	}
+
+	if (kill_dev)
+		set_bit(FBLOG_KILLED, &fb->flags);
+
+	mutex_unlock(&fb->lock);
+}
+
+/*
  * fblog framebuffer list
  * The fblog_fbs[] array contains all currently registered framebuffers. If a
  * framebuffer is in that list, we always must make sure that we own a reference
@@ -77,6 +147,7 @@ static void fblog_do_unregister(struct fb_info *info)
 
 	fblog_fbs[info->node] = NULL;
 
+	fblog_close(fb, true);
 	device_del(&fb->dev);
 	put_device(&fb->dev);
 }
@@ -99,6 +170,7 @@ static void fblog_do_register(struct fb_info *info, bool force)
 		return;
 
 	fb->info = info;
+	mutex_init(&fb->lock);
 	__module_get(THIS_MODULE);
 	device_initialize(&fb->dev);
 	fb->dev.class = fb_class;
@@ -113,6 +185,8 @@ static void fblog_do_register(struct fb_info *info, bool force)
 		put_device(&fb->dev);
 		return;
 	}
+
+	fblog_open(fb);
 }
 
 static void fblog_register(struct fb_info *info, bool force)
@@ -134,6 +208,7 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 {
 	struct fb_event *event = data;
 	struct fb_info *info = event->info;
+	struct fblog_fb *fb;
 
 	switch(action) {
 	case FB_EVENT_FB_REGISTERED:
@@ -145,8 +220,21 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 	case FB_EVENT_FB_UNREGISTERED:
 		/* This is called when a low-level system driver unregisters a
 		 * framebuffer. The registration lock is held but the console
-		 * lock might not be held. */
+		 * lock might not be held. The fb-lock is not held, either! */
+		mutex_lock(&info->lock);
 		fblog_unregister(info);
+		mutex_unlock(&info->lock);
+		break;
+	case FB_EVENT_FB_UNBIND:
+		/* Called directly before unregistering an FB. The FB is still
+		 * valid here and the registration lock is held but the console
+		 * lock might not be held (really?). */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (fb)
+			fblog_close(fb, true);
 		break;
 	}
 
@@ -163,7 +251,9 @@ static void fblog_scan(void)
 		if (!info || IS_ERR(info))
 			continue;
 
+		mutex_lock(&info->lock);
 		fblog_register(info, false);
+		mutex_unlock(&info->lock);
 
 		/* There is a very subtle race-condition. Even though we might
 		 * own a reference to the fb, it may still get unregistered
@@ -224,7 +314,9 @@ static void __exit fblog_exit(void)
 		if (!info || IS_ERR(info))
 			continue;
 
+		mutex_lock(&info->lock);
 		fblog_unregister(info);
+		mutex_unlock(&info->lock);
 		put_fb_info(info);
 	}
 }
-- 
1.7.11.2

