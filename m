Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2GOTG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:06:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47266 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2GOTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:27 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 05/11] fblog: register one fblog object per framebuffer
Date: Sun, 15 Jul 2012 21:04:40 +0200
Message-Id: <1342379086-7583-6-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
References: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fblog object is associated to each registered framebuffer. This way,
we can draw the console to each framebuffer. When a framebuffer driver
unregisters a framebuffer, we also unregister our fblog object. That is,
our lifetime is coupled to the lifetime of the framebuffer. However, this
does not mean that we are always active. On the contrary, we do not even
own a reference to the framebuffer. We don't need it as we are notified
_before_ the last reference is dropped.

However, if other users have a reference to our object, we simply mark it
as dead when the associated framebuffer dies and leave it alone. When the
last reference is dropped, it will be automatically freed.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 195 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 195 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index fb39737..279f4d8 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -23,15 +23,210 @@
  * all fblog instances before running other graphics applications.
  */
 
+#define pr_fmt(_fmt) KBUILD_MODNAME ": " _fmt
+
+#include <linux/device.h>
+#include <linux/fb.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
+
+enum fblog_flags {
+	FBLOG_KILLED,
+};
+
+struct fblog_fb {
+	unsigned long flags;
+	struct fb_info *info;
+	struct device dev;
+};
+
+static DEFINE_MUTEX(fblog_registration_lock);
+static struct fblog_fb *fblog_fbs[FB_MAX];
+
+#define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
+
+/*
+ * fblog framebuffer list
+ * The fblog_fbs[] array contains all currently registered framebuffers. If a
+ * framebuffer is in that list, we always must make sure that we own a reference
+ * to it. If it is added through the notifier callbacks, then this is always
+ * guaranteed.
+ * We are only interested in registered framebuffers. That is, if a driver calls
+ * unregister_framebuffer() we directly unlink it from our list. This guarantees
+ * that the associated fb_info is always valid. However, we might still have
+ * pending users so we mark it as dead so no further framebuffer actions are
+ * done. If the last user then drops a reference, the memory gets freed
+ * automatically.
+ */
+
+static void fblog_release(struct device *dev)
+{
+	struct fblog_fb *fb = to_fblog_dev(dev);
+
+	kfree(fb);
+	module_put(THIS_MODULE);
+}
+
+static void fblog_do_unregister(struct fb_info *info)
+{
+	struct fblog_fb *fb;
+
+	fb = fblog_fbs[info->node];
+	if (!fb || fb->info != info)
+		return;
+
+	fblog_fbs[info->node] = NULL;
+
+	device_del(&fb->dev);
+	put_device(&fb->dev);
+}
+
+static void fblog_do_register(struct fb_info *info, bool force)
+{
+	struct fblog_fb *fb;
+	int ret;
+
+	fb = fblog_fbs[info->node];
+	if (fb && fb->info != info) {
+		if (!force)
+			return;
+
+		fblog_do_unregister(fb->info);
+	}
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb)
+		return;
+
+	fb->info = info;
+	__module_get(THIS_MODULE);
+	device_initialize(&fb->dev);
+	fb->dev.class = fb_class;
+	fb->dev.release = fblog_release;
+	dev_set_name(&fb->dev, "fblog%d", info->node);
+	fblog_fbs[info->node] = fb;
+
+	ret = device_add(&fb->dev);
+	if (ret) {
+		fblog_fbs[info->node] = NULL;
+		set_bit(FBLOG_KILLED, &fb->flags);
+		put_device(&fb->dev);
+		return;
+	}
+}
+
+static void fblog_register(struct fb_info *info, bool force)
+{
+	mutex_lock(&fblog_registration_lock);
+	fblog_do_register(info, force);
+	mutex_unlock(&fblog_registration_lock);
+}
+
+static void fblog_unregister(struct fb_info *info)
+{
+	mutex_lock(&fblog_registration_lock);
+	fblog_do_unregister(info);
+	mutex_unlock(&fblog_registration_lock);
+}
+
+static int fblog_event(struct notifier_block *self, unsigned long action,
+		       void *data)
+{
+	struct fb_event *event = data;
+	struct fb_info *info = event->info;
+
+	switch(action) {
+	case FB_EVENT_FB_REGISTERED:
+		/* This is called when a low-level system driver registers a new
+		 * framebuffer. The registration lock is held but the console
+		 * lock might not be held when this is called. */
+		fblog_register(info, true);
+		break;
+	case FB_EVENT_FB_UNREGISTERED:
+		/* This is called when a low-level system driver unregisters a
+		 * framebuffer. The registration lock is held but the console
+		 * lock might not be held. */
+		fblog_unregister(info);
+		break;
+	}
+
+	return 0;
+}
+
+static void fblog_scan(void)
+{
+	unsigned int i;
+	struct fb_info *info, *tmp;
+
+	for (i = 0; i < FB_MAX; ++i) {
+		info = get_fb_info(i);
+		if (!info || IS_ERR(info))
+			continue;
+
+		fblog_register(info, false);
+
+		/* There is a very subtle race-condition. Even though we might
+		 * own a reference to the fb, it may still get unregistered
+		 * between our call from get_fb_info() and fblog_register().
+		 * Therefore, we simply check whether the same fb still is
+		 * registered by calling get_fb_info() again. Only if they
+		 * differ we know that it got unregistered, therefore, we
+		 * call fblog_unregister() with the old pointer. */
+
+		tmp = get_fb_info(i);
+		if (tmp && !IS_ERR(tmp))
+			put_fb_info(tmp);
+		if (tmp != info)
+			fblog_unregister(info);
+
+		/* Here we either called fblog_unregister() and therefore do not
+		 * need any reference to the fb, or we can be sure that the FB
+		 * is registered and FB_EVENT_FB_UNREGISTERED will be called
+		 * before the last reference is dropped. Hence, we can drop our
+		 * reference here. */
+
+		put_fb_info(info);
+	}
+}
+
+static struct notifier_block fblog_notifier = {
+	.notifier_call = fblog_event,
+};
 
 static int __init fblog_init(void)
 {
+	int ret;
+
+	ret = fb_register_client(&fblog_notifier);
+	if (ret) {
+		pr_err("cannot register framebuffer notifier\n");
+		return ret;
+	}
+
+	fblog_scan();
+
 	return 0;
 }
 
 static void __exit fblog_exit(void)
 {
+	unsigned int i;
+	struct fb_info *info;
+
+	fb_unregister_client(&fblog_notifier);
+
+	/* We scan through the whole registered_fb array here instead of
+	 * fblog_fbs because we need to get the device lock _before_ the
+	 * fblog-registration-lock. */
+
+	for (i = 0; i < FB_MAX; ++i) {
+		info = get_fb_info(i);
+		if (!info || IS_ERR(info))
+			continue;
+
+		fblog_unregister(info);
+		put_fb_info(info);
+	}
 }
 
 module_init(fblog_init);
-- 
1.7.11.2

