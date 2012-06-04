Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2FDLhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:37:42 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:45001 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 15/24] PTY: merge pty_install implementations
Date: Mon,  4 Jun 2012 13:35:29 +0200
Message-Id: <1338809738-18967-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently two instances of code which handles PTY install.
One for the legacy BSD PTY's, one for unix98's PTY's. Both of them are
very similar and differ only in termios allocation and handling.

Since we will need to allocate a tty_port at that place, this would
require editing two places with the same pattern. Instead, let us move
the implementation to one common place and call it from both places.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c |  110 ++++++++++++++++++++++-------------------------------
 1 file changed, 45 insertions(+), 65 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 4bcaf89..881888f 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -282,39 +282,53 @@ done:
 	return 0;
 }
 
-/* Traditional BSD devices */
-#ifdef CONFIG_LEGACY_PTYS
-
-static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
+static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
+		bool legacy)
 {
 	struct tty_struct *o_tty;
 	int idx = tty->index;
-	int retval;
+	int retval = -ENOMEM;
 
 	o_tty = alloc_tty_struct();
 	if (!o_tty)
-		return -ENOMEM;
+		goto err;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
-		retval = -ENOMEM;
 		goto err_free_tty;
 	}
 	initialize_tty_struct(o_tty, driver->other, idx);
 
-	/* We always use new tty termios data so we can do this
-	   the easy way .. */
-	retval = tty_init_termios(tty);
-	if (retval)
-		goto err_deinit_tty;
-
-	retval = tty_init_termios(o_tty);
-	if (retval)
-		goto err_free_termios;
+	if (legacy) {
+		/* We always use new tty termios data so we can do this
+		   the easy way .. */
+		retval = tty_init_termios(tty);
+		if (retval)
+			goto err_deinit_tty;
+
+		retval = tty_init_termios(o_tty);
+		if (retval)
+			goto err_free_termios;
+
+		driver->other->ttys[idx] = o_tty;
+		driver->ttys[idx] = tty;
+	} else {
+		tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
+		if (tty->termios == NULL)
+			goto err_deinit_tty;
+		*tty->termios = driver->init_termios;
+		tty->termios_locked = tty->termios + 1;
+
+		o_tty->termios = kzalloc(sizeof(struct ktermios[2]),
+				GFP_KERNEL);
+		if (o_tty->termios == NULL)
+			goto err_free_termios;
+		*o_tty->termios = driver->other->init_termios;
+		o_tty->termios_locked = o_tty->termios + 1;
+	}
 
 	/*
 	 * Everything allocated ... set up the o_tty structure.
 	 */
-	driver->other->ttys[idx] = o_tty;
 	tty_driver_kref_get(driver->other);
 	if (driver->subtype == PTY_TYPE_MASTER)
 		o_tty->count++;
@@ -324,18 +338,29 @@ static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 
 	tty_driver_kref_get(driver);
 	tty->count++;
-	driver->ttys[idx] = tty;
 	return 0;
 err_free_termios:
-	tty_free_termios(tty);
+	if (legacy)
+		tty_free_termios(tty);
+	else
+		kfree(tty->termios);
 err_deinit_tty:
 	deinitialize_tty_struct(o_tty);
 	module_put(o_tty->driver->owner);
 err_free_tty:
 	free_tty_struct(o_tty);
+err:
 	return retval;
 }
 
+/* Traditional BSD devices */
+#ifdef CONFIG_LEGACY_PTYS
+
+static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	return pty_common_install(driver, tty, true);
+}
+
 static int pty_bsd_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -509,52 +534,7 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 
 static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	struct tty_struct *o_tty;
-	int idx = tty->index;
-
-	o_tty = alloc_tty_struct();
-	if (!o_tty)
-		return -ENOMEM;
-	if (!try_module_get(driver->other->owner)) {
-		/* This cannot in fact currently happen */
-		goto err_free_tty;
-	}
-	initialize_tty_struct(o_tty, driver->other, idx);
-
-	tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
-	if (tty->termios == NULL)
-		goto err_free_mem;
-	*tty->termios = driver->init_termios;
-	tty->termios_locked = tty->termios + 1;
-
-	o_tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
-	if (o_tty->termios == NULL)
-		goto err_free_mem;
-	*o_tty->termios = driver->other->init_termios;
-	o_tty->termios_locked = o_tty->termios + 1;
-
-	tty_driver_kref_get(driver->other);
-	if (driver->subtype == PTY_TYPE_MASTER)
-		o_tty->count++;
-	/* Establish the links in both directions */
-	tty->link   = o_tty;
-	o_tty->link = tty;
-	/*
-	 * All structures have been allocated, so now we install them.
-	 * Failures after this point use release_tty to clean up, so
-	 * there's no need to null out the local pointers.
-	 */
-	tty_driver_kref_get(driver);
-	tty->count++;
-	return 0;
-err_free_mem:
-	deinitialize_tty_struct(o_tty);
-	kfree(o_tty->termios);
-	kfree(tty->termios);
-	module_put(o_tty->driver->owner);
-err_free_tty:
-	free_tty_struct(o_tty);
-	return -ENOMEM;
+	return pty_common_install(driver, tty, false);
 }
 
 static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
-- 
1.7.10.3


