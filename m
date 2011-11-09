Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1KIUhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:37:47 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37367 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/7] TTY: extract driver lookup from tty_open
Date: Wed,  9 Nov 2011 21:33:20 +0100
Message-Id: <1320870804-23687-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling in tty_open became unbearable. There were many
errors fixed recently. Extract the tty driver lookup from tty_open to
a separate function. This reduces the fail paths significantly and
makes tty_open more readable.

In the next patch we will move the fail path handling to the end of
the function.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |   93 +++++++++++++++++++++++++++++--------------------
 1 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1b90c98..00b8498 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1824,6 +1824,53 @@ static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
 }
 
 /**
+ *	tty_lookup_driver - lookup a tty driver for a given device file
+ *	@device: device number
+ *	@filp: file pointer to tty
+ *	@noctty: set if the device should not become a controlling tty
+ *	@index: index for the device in the @return driver
+ *	@return: driver for this inode (with increased refcount)
+ *
+ * 	If @return is not erroneous, the caller is responsible to decrement the
+ * 	refcount by tty_driver_kref_put.
+ *
+ *	Locking: tty_mutex protects get_tty_driver
+ */
+static struct tty_driver *tty_lookup_driver(dev_t device, struct file *filp,
+		int *noctty, int *index)
+{
+	struct tty_driver *driver;
+
+#ifdef CONFIG_VT
+	if (device == MKDEV(TTY_MAJOR, 0)) {
+		extern struct tty_driver *console_driver;
+		driver = tty_driver_kref_get(console_driver);
+		*index = fg_console;
+		*noctty = 1;
+		return driver;
+	}
+#endif
+	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
+		struct tty_driver *console_driver = console_device(index);
+		if (console_driver) {
+			driver = tty_driver_kref_get(console_driver);
+			if (driver) {
+				/* Don't let /dev/console block */
+				filp->f_flags |= O_NONBLOCK;
+				*noctty = 1;
+				return driver;
+			}
+		}
+		return ERR_PTR(-ENODEV);
+	}
+
+	driver = get_tty_driver(device, index);
+	if (!driver)
+		return ERR_PTR(-ENODEV);
+	return driver;
+}
+
+/**
  *	tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
@@ -1839,7 +1886,7 @@ static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
  *	The termios state of a pty is reset on first open so that
  *	settings don't persist across reuse.
  *
- *	Locking: tty_mutex protects tty, get_tty_driver and tty_init_dev work.
+ *	Locking: tty_mutex protects tty, tty_lookup_driver and tty_init_dev.
  *		 tty->count should protect the rest.
  *		 ->siglock protects ->signal/->sighand
  */
@@ -1873,47 +1920,17 @@ retry_open:
 		mutex_unlock(&tty_mutex);
 		tty_free_file(filp);
 		return PTR_ERR(tty);
-	} else if (tty)
-		goto got_driver;
-
-#ifdef CONFIG_VT
-	if (device == MKDEV(TTY_MAJOR, 0)) {
-		extern struct tty_driver *console_driver;
-		driver = tty_driver_kref_get(console_driver);
-		index = fg_console;
-		noctty = 1;
-		goto got_driver;
-	}
-#endif
-	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
-		struct tty_driver *console_driver = console_device(&index);
-		if (console_driver) {
-			driver = tty_driver_kref_get(console_driver);
-			if (driver) {
-				/* Don't let /dev/console block */
-				filp->f_flags |= O_NONBLOCK;
-				noctty = 1;
-				goto got_driver;
-			}
+	} else if (!tty) {
+		driver = tty_lookup_driver(device, filp, &noctty, &index);
+		if (IS_ERR(driver)) {
+			tty_unlock();
+			mutex_unlock(&tty_mutex);
+			tty_free_file(filp);
+			return PTR_ERR(driver);
 		}
-		tty_unlock();
-		mutex_unlock(&tty_mutex);
-		tty_free_file(filp);
-		return -ENODEV;
-	}
 
-	driver = get_tty_driver(device, &index);
-	if (!driver) {
-		tty_unlock();
-		mutex_unlock(&tty_mutex);
-		tty_free_file(filp);
-		return -ENODEV;
-	}
-got_driver:
-	if (!tty) {
 		/* check whether we're reopening an existing tty */
 		tty = tty_driver_lookup_tty(driver, inode, index);
-
 		if (IS_ERR(tty)) {
 			tty_unlock();
 			mutex_unlock(&tty_mutex);
-- 
1.7.7


