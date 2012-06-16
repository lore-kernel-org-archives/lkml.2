Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2FPWFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:05:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57460 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FPWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:04:59 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 09/10] fblog: register all handlers on module-init
Date: Sun, 17 Jun 2012 00:04:25 +0200
Message-Id: <1339884266-9201-10-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now create a new "fblog" device when initializing the fblog module. We
register the "active" sysfs-file with it so user-space can now access
fblog. We also register the framebuffer-notifier and console-handler so
fblog is ready to go.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/console/fblog.c |   59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
index 79bfbcc..9d3b072 100644
--- a/drivers/video/console/fblog.c
+++ b/drivers/video/console/fblog.c
@@ -92,6 +92,7 @@ struct fblog_fb {
 };
 
 static struct fblog_fb *fblog_fbs[FB_MAX];
+static struct device *fblog_device;
 static atomic_t fblog_active;
 
 static void fblog_buf_resize(struct fblog_buf *buf, size_t width,
@@ -609,13 +610,71 @@ static ssize_t fblog_dev_active_store(struct device *dev,
 static DEVICE_ATTR(active, S_IRUGO | S_IWUSR | S_IWGRP, fblog_dev_active_show,
 		   fblog_dev_active_store);
 
+static void fblog_dev_release(struct device *dev)
+{
+	kfree(dev);
+	module_put(THIS_MODULE);
+}
+
 static int __init fblog_init(void)
 {
+	int ret;
+
+	fblog_device = kzalloc(sizeof(*fblog_device), GFP_KERNEL);
+	if (!fblog_device) {
+		pr_err("fblog: cannot allocate device\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	__module_get(THIS_MODULE);
+	device_initialize(fblog_device);
+	fblog_device->class = fb_class;
+	fblog_device->release = fblog_dev_release;
+	dev_set_name(fblog_device, "fblog");
+
+	ret = device_add(fblog_device);
+	if (ret) {
+		pr_err("fblog: cannot add device\n");
+		goto err_dev;
+	}
+
+	ret = fb_register_client(&fblog_notifier);
+	if (ret) {
+		pr_err("fblog: cannot register framebuffer notifier\n");
+		goto err_dev_rm;
+	}
+
+	ret = device_create_file(fblog_device, &dev_attr_active);
+	if (ret) {
+		pr_err("fblog: cannot create sysfs entry\n");
+		goto err_fb;
+	}
+
+	register_console(&fblog_con_driver);
+
 	return 0;
+
+err_fb:
+	fb_unregister_client(&fblog_notifier);
+err_dev_rm:
+	device_del(fblog_device);
+err_dev:
+	put_device(fblog_device);
+err_out:
+	return ret;
 }
 
 static void __exit fblog_exit(void)
 {
+	unregister_console(&fblog_con_driver);
+	device_remove_file(fblog_device, &dev_attr_active);
+	device_del(fblog_device);
+	fb_unregister_client(&fblog_notifier);
+	console_lock();
+	fblog_deactivate();
+	console_unlock();
+	put_device(fblog_device);
 }
 
 module_init(fblog_init);
-- 
1.7.10.4

