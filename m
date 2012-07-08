Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2GHV6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:58:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2GHV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:57:04 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de,
        linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, bonbons@linux-vserver.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 06/11] fblog: open fb on registration
Date: Sun,  8 Jul 2012 23:56:49 +0200
Message-Id: <1341784614-2797-7-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This opens the framebuffer upon registration so we can use it for
drawing-operations. On unregistration we close it again.

To avoid deadlocks, we need to tell fblog_open/close() whether the
framebuffer is currently locked. This is because some fb-notifiers are
called with the lock held and others without it. We cannot release it in
the notifier as this might confuse other registered callbacks if they
actually depend on the lock to be continously held (such a callback is
currently no available in the kernel, but may be added some time later).

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 91 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 3e0b471..113be36 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -30,12 +30,14 @@
 
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
@@ -43,6 +45,77 @@ static struct fblog_fb *fblog_fbs[FB_MAX];
 
 #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
 
+static int fblog_open(struct fblog_fb *fb, bool locked)
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
+	if (!locked)
+		mutex_lock(&fb->info->lock);
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
+	if (!locked)
+		mutex_unlock(&fb->info->lock);
+
+	set_bit(FBLOG_OPEN, &fb->flags);
+	mutex_unlock(&fb->lock);
+	return 0;
+
+out_unref:
+	module_put(fb->info->fbops->owner);
+out_killed:
+	if (!locked)
+		mutex_unlock(&fb->info->lock);
+	set_bit(FBLOG_KILLED, &fb->flags);
+unlock:
+	mutex_unlock(&fb->lock);
+	return ret;
+}
+
+static void fblog_close(struct fblog_fb *fb, bool kill_dev, bool locked)
+{
+	mutex_lock(&fb->lock);
+
+	if (test_bit(FBLOG_OPEN, &fb->flags)) {
+		if (!locked)
+			mutex_lock(&fb->info->lock);
+
+		if (fb->info->fbops->fb_release)
+			fb->info->fbops->fb_release(fb->info, 0);
+		module_put(fb->info->fbops->owner);
+
+		if (!locked)
+			mutex_unlock(&fb->info->lock);
+
+		clear_bit(FBLOG_OPEN, &fb->flags);
+	}
+
+	if (kill_dev)
+		set_bit(FBLOG_KILLED, &fb->flags);
+
+	mutex_unlock(&fb->lock);
+}
+
 /*
  * fblog framebuffer list
  * The fblog_fbs[] array contains all currently registered framebuffers. If a
@@ -75,6 +148,7 @@ static void fblog_do_unregister(struct fb_info *info)
 
 	fblog_fbs[info->node] = NULL;
 
+	fblog_close(fb, true, false);
 	device_del(&fb->dev);
 	put_device(&fb->dev);
 }
@@ -97,6 +171,7 @@ static void fblog_do_register(struct fb_info *info, bool force)
 		return;
 
 	fb->info = info;
+	mutex_init(&fb->lock);
 	__module_get(THIS_MODULE);
 	device_initialize(&fb->dev);
 	fb->dev.class = fb_class;
@@ -111,6 +186,8 @@ static void fblog_do_register(struct fb_info *info, bool force)
 		put_device(&fb->dev);
 		return;
 	}
+
+	fblog_open(fb, true);
 }
 
 static void fblog_register(struct fb_info *info, bool force)
@@ -132,6 +209,7 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 {
 	struct fb_event *event = data;
 	struct fb_info *info = event->info;
+	struct fblog_fb *fb;
 
 	switch(action) {
 	case FB_EVENT_FB_REGISTERED:
@@ -146,6 +224,17 @@ static int fblog_event(struct notifier_block *self, unsigned long action,
 		 * lock might not be held. */
 		fblog_unregister(info);
 		break;
+	case FB_EVENT_FB_UNBIND:
+		/* Called directly before unregistering an FB. The FB is still
+		 * valid here and the registration lock is held but the console
+		 * lock might not be held (really?). */
+		mutex_lock(&fblog_registration_lock);
+		fb = fblog_fbs[info->node];
+		mutex_unlock(&fblog_registration_lock);
+
+		if (fb)
+			fblog_close(fb, true, true);
+		break;
 	}
 
 	return 0;
@@ -161,7 +250,9 @@ static void fblog_scan(void)
 		if (!info || IS_ERR(info))
 			continue;
 
+		mutex_lock(&info->lock);
 		fblog_register(info, false);
+		mutex_unlock(&info->lock);
 
 		/* There is a very subtle race-condition. Even though we might
 		 * own a reference to the fb, it may still get unregistered
-- 
1.7.11.1

