Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0JVShK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:37:10 -0400
Received: from kroah.org ([198.145.64.141]:41899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab0JVSVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/49] tty_io: check return code of tty_register_device
Date: Fri, 22 Oct 2010 11:20:59 -0700
Message-Id: <1287771688-14805-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function tty_register_device may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d6c659f..e185db3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3004,6 +3004,7 @@ int tty_register_driver(struct tty_driver *driver)
 	int i;
 	dev_t dev;
 	void **p = NULL;
+	struct device *d;
 
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
 		p = kzalloc(driver->num * 2 * sizeof(void *), GFP_KERNEL);
@@ -3051,12 +3052,31 @@ int tty_register_driver(struct tty_driver *driver)
 	mutex_unlock(&tty_mutex);
 
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV)) {
-		for (i = 0; i < driver->num; i++)
-		    tty_register_device(driver, i, NULL);
+		for (i = 0; i < driver->num; i++) {
+			d = tty_register_device(driver, i, NULL);
+			if (IS_ERR(d)) {
+				error = PTR_ERR(d);
+				goto err;
+			}
+		}
 	}
 	proc_tty_register_driver(driver);
 	driver->flags |= TTY_DRIVER_INSTALLED;
 	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		tty_unregister_device(driver, i);
+
+	mutex_lock(&tty_mutex);
+	list_del(&driver->tty_drivers);
+	mutex_unlock(&tty_mutex);
+
+	unregister_chrdev_region(dev, driver->num);
+	driver->ttys = NULL;
+	driver->termios = NULL;
+	kfree(p);
+	return error;
 }
 
 EXPORT_SYMBOL(tty_register_driver);
-- 
1.7.2

