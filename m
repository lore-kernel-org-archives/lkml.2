Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1CWJsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:48:45 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54663 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1CWJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:48:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Julian Anastasov <ja@ssi.bg>
Subject: [PATCH 2/6] TTY: unify pty_install fail path handling
Date: Wed, 23 Mar 2011 10:48:33 +0100
Message-Id: <1300873717-27941-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change it so that we call the deinit functions at one place at the end
of the function (by gotos). And while at it use some sane label names.

This is a preparation for the deinitialization of tty in the next
patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Julian Anastasov <ja@ssi.bg>
---
 drivers/tty/pty.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2107747..f511918 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -295,8 +295,8 @@ static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 		return -ENOMEM;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
-		free_tty_struct(o_tty);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_free_tty;
 	}
 	initialize_tty_struct(o_tty, driver->other, idx);
 
@@ -304,13 +304,11 @@ static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 	   the easy way .. */
 	retval = tty_init_termios(tty);
 	if (retval)
-		goto free_mem_out;
+		goto err_module_put;
 
 	retval = tty_init_termios(o_tty);
-	if (retval) {
-		tty_free_termios(tty);
-		goto free_mem_out;
-	}
+	if (retval)
+		goto err_free_termios;
 
 	/*
 	 * Everything allocated ... set up the o_tty structure.
@@ -327,10 +325,13 @@ static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
 	tty->count++;
 	driver->ttys[idx] = tty;
 	return 0;
-free_mem_out:
+err_free_termios:
+	tty_free_termios(tty);
+err_module_put:
 	module_put(o_tty->driver->owner);
+err_free_tty:
 	free_tty_struct(o_tty);
-	return -ENOMEM;
+	return retval;
 }
 
 static int pty_bsd_ioctl(struct tty_struct *tty,
-- 
1.7.4.1


