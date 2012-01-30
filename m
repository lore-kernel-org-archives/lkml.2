Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2A3UUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:20:36 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:39602 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2A3UUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:20:34 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, jirislaby@gmail.com,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 1/5] TTY: provide tty_standard_install helper
Date: Mon, 30 Jan 2012 21:14:28 +0100
Message-Id: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently many cut&paste copies of what
tty_driver_install_tty does when custom ->install method is not
provided. Let's get rid of the copies and create a helper with this
setup code.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/tty_io.c |   30 +++++++++++++++---------------
 include/linux/tty.h  |    2 ++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fbcc140..44736f9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1271,6 +1271,19 @@ int tty_init_termios(struct tty_struct *tty)
 }
 EXPORT_SYMBOL_GPL(tty_init_termios);
 
+int tty_standard_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	int ret = tty_init_termios(tty);
+	if (ret)
+		return ret;
+
+	tty_driver_kref_get(driver);
+	tty->count++;
+	driver->ttys[tty->index] = tty;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tty_standard_install);
+
 /**
  *	tty_driver_install_tty() - install a tty entry in the driver
  *	@driver: the driver for the tty
@@ -1286,21 +1299,8 @@ EXPORT_SYMBOL_GPL(tty_init_termios);
 static int tty_driver_install_tty(struct tty_driver *driver,
 						struct tty_struct *tty)
 {
-	int idx = tty->index;
-	int ret;
-
-	if (driver->ops->install) {
-		ret = driver->ops->install(driver, tty);
-		return ret;
-	}
-
-	if (tty_init_termios(tty) == 0) {
-		tty_driver_kref_get(driver);
-		tty->count++;
-		driver->ttys[idx] = tty;
-		return 0;
-	}
-	return -ENOMEM;
+	return driver->ops->install ? driver->ops->install(driver, tty) :
+		tty_standard_install(driver, tty);
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f801a85..653fc57 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -490,6 +490,8 @@ extern void deinitialize_tty_struct(struct tty_struct *tty);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx);
 extern int tty_release(struct inode *inode, struct file *filp);
 extern int tty_init_termios(struct tty_struct *tty);
+extern int tty_standard_install(struct tty_driver *driver,
+		struct tty_struct *tty);
 
 extern struct tty_struct *tty_pair_get_tty(struct tty_struct *tty);
 extern struct tty_struct *tty_pair_get_pty(struct tty_struct *tty);
-- 
1.7.8.3


