Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397Ab2FDLkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44998 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 21/24] TTY: centralize fail paths in tty_register_driver
Date: Mon,  4 Jun 2012 13:35:35 +0200
Message-Id: <1338809738-18967-22-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, some failures are handled in if's false branches, some at
the end of tty_register_driver via goto-labels. Let us handle the
failures at the end of the functions to have the failure handling at
a single place. The only thing needed is to label the lines properly
and jump there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..d6e045b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3144,10 +3144,8 @@ int tty_register_driver(struct tty_driver *driver)
 		dev = MKDEV(driver->major, driver->minor_start);
 		error = register_chrdev_region(dev, driver->num, driver->name);
 	}
-	if (error < 0) {
-		kfree(p);
-		return error;
-	}
+	if (error < 0)
+		goto err_free_p;
 
 	if (p) {
 		driver->ttys = (struct tty_struct **)p;
@@ -3160,13 +3158,8 @@ int tty_register_driver(struct tty_driver *driver)
 	cdev_init(&driver->cdev, &tty_fops);
 	driver->cdev.owner = driver->owner;
 	error = cdev_add(&driver->cdev, dev, driver->num);
-	if (error) {
-		unregister_chrdev_region(dev, driver->num);
-		driver->ttys = NULL;
-		driver->termios = NULL;
-		kfree(p);
-		return error;
-	}
+	if (error)
+		goto err_unreg_char;
 
 	mutex_lock(&tty_mutex);
 	list_add(&driver->tty_drivers, &tty_drivers);
@@ -3193,13 +3186,14 @@ err:
 	list_del(&driver->tty_drivers);
 	mutex_unlock(&tty_mutex);
 
+err_unreg_char:
 	unregister_chrdev_region(dev, driver->num);
 	driver->ttys = NULL;
 	driver->termios = NULL;
+err_free_p:
 	kfree(p);
 	return error;
 }
-
 EXPORT_SYMBOL(tty_register_driver);
 
 /*
-- 
1.7.10.3


