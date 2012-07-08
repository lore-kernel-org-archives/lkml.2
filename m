Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2GHV6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:58:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64593 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2GHV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:57:04 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de,
        linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, bonbons@linux-vserver.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 07/11] fblog: allow selecting fbs via sysfs
Date: Sun,  8 Jul 2012 23:56:50 +0200
Message-Id: <1341784614-2797-8-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fblog is mainly useful during boot, reboot, panics and maintenance. In all
cases you often want to control which monitors are used for console
output. Moreover, in multi-seat environments it is desireable to reduce
system-overhead by not drawing the console to all framebuffers. Two
mechanisms to select framebuffers for fblog are added:

1) "active" module parameter: This parameter selects whether new
framebuffers are opened automatically. By default this is on, that is, all
framebuffers are automatically used by fblog during boot. By passing
fblog.active=0 you can deactivate this.
The init process can set this to 0 via
/sys/modules/fblog/parameters/active, too. However, this does not affect
already available and used framebuffers in any way.

2) "active" sysfs attribute for each fblog object. Reading this value
returns whether a framebuffer is currently active. Writing it opens/closes
the framebuffer. This allows runtime control which fbs are used. For
instance, init can set these to 0 after bootup.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c | 50 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 113be36..b490dba 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -42,6 +42,7 @@ struct fblog_fb {
 
 static DEFINE_MUTEX(fblog_registration_lock);
 static struct fblog_fb *fblog_fbs[FB_MAX];
+static bool active = 1;
 
 #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
 
@@ -116,6 +117,37 @@ static void fblog_close(struct fblog_fb *fb, bool kill_dev, bool locked)
 	mutex_unlock(&fb->lock);
 }
 
+static ssize_t fblog_dev_active_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct fblog_fb *fb = to_fblog_dev(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			!!test_bit(FBLOG_OPEN, &fb->flags));
+}
+
+static ssize_t fblog_dev_active_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t count)
+{
+	struct fblog_fb *fb = to_fblog_dev(dev);
+	unsigned long num;
+	int ret = 0;
+
+	num = simple_strtoul(buf, NULL, 10);
+	if (num)
+		ret = fblog_open(fb, false);
+	else
+		fblog_close(fb, false, false);
+
+	return ret ? ret : count;
+}
+
+static DEVICE_ATTR(active, S_IRUGO | S_IWUSR | S_IWGRP, fblog_dev_active_show,
+		   fblog_dev_active_store);
+
 /*
  * fblog framebuffer list
  * The fblog_fbs[] array contains all currently registered framebuffers. If a
@@ -149,6 +181,7 @@ static void fblog_do_unregister(struct fb_info *info)
 	fblog_fbs[info->node] = NULL;
 
 	fblog_close(fb, true, false);
+	device_remove_file(&fb->dev, &dev_attr_active);
 	device_del(&fb->dev);
 	put_device(&fb->dev);
 }
@@ -157,6 +190,7 @@ static void fblog_do_register(struct fb_info *info, bool force)
 {
 	struct fblog_fb *fb;
 	int ret;
+	bool do_open = true;
 
 	fb = fblog_fbs[info->node];
 	if (fb && fb->info != info) {
@@ -187,7 +221,18 @@ static void fblog_do_register(struct fb_info *info, bool force)
 		return;
 	}
 
-	fblog_open(fb, true);
+	ret = device_create_file(&fb->dev, &dev_attr_active);
+	if (ret) {
+		pr_err("fblog: cannot create sysfs entry");
+		/* do not open fb if we cannot create control file */
+		do_open = false;
+	}
+
+	if (!active)
+		do_open = false;
+
+	if (do_open)
+		fblog_open(fb, true);
 }
 
 static void fblog_register(struct fb_info *info, bool force)
@@ -314,6 +359,9 @@ static void __exit fblog_exit(void)
 	}
 }
 
+module_param(active, bool, S_IRUGO);
+MODULE_PARM_DESC(active, "Activate fblog by default");
+
 module_init(fblog_init);
 module_exit(fblog_exit);
 MODULE_LICENSE("GPL");
-- 
1.7.11.1

