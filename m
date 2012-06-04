Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2FDLnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:43:37 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44990 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 22/24] TTY: add ports array to tty_driver
Date: Mon,  4 Jun 2012 13:35:36 +0200
Message-Id: <1338809738-18967-23-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will hold tty_port structures for all drivers which do not want to
define tty->ops->install hook.

We ignore PTY here because it wants 1 million lines and it installs
tty_port in ->install anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c       |   18 +++++++++++++++++-
 include/linux/tty_driver.h |    1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d6e045b..ac96f74 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1407,6 +1407,9 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	if (retval < 0)
 		goto err_deinit_tty;
 
+	if (!tty->port)
+		tty->port = driver->ports[idx];
+
 	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need
@@ -3094,6 +3097,7 @@ static void destruct_tty_driver(struct kref *kref)
 		kfree(p);
 		cdev_del(&driver->cdev);
 	}
+	kfree(driver->ports);
 	kfree(driver);
 }
 
@@ -3132,6 +3136,18 @@ int tty_register_driver(struct tty_driver *driver)
 		if (!p)
 			return -ENOMEM;
 	}
+	/*
+	 * There is too many lines in PTY and we won't need the array there
+	 * since it has an ->install hook where it assigns ports properly.
+	 */
+	if (driver->type != TTY_DRIVER_TYPE_PTY) {
+		driver->ports = kcalloc(driver->num, sizeof(struct tty_port *),
+				GFP_KERNEL);
+		if (!driver->ports) {
+			error = -ENOMEM;
+			goto err_free_p;
+		}
+	}
 
 	if (!driver->major) {
 		error = alloc_chrdev_region(&dev, driver->minor_start,
@@ -3190,7 +3206,7 @@ err_unreg_char:
 	unregister_chrdev_region(dev, driver->num);
 	driver->ttys = NULL;
 	driver->termios = NULL;
-err_free_p:
+err_free_p: /* destruct_tty_driver will free driver->ports */
 	kfree(p);
 	return error;
 }
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 6e6dbb7..04419c1 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -313,6 +313,7 @@ struct tty_driver {
 	 * Pointer to the tty data structures
 	 */
 	struct tty_struct **ttys;
+	struct tty_port **ports;
 	struct ktermios **termios;
 	void *driver_state;
 
-- 
1.7.10.3


