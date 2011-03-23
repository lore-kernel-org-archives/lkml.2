Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1CWJtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:49:10 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54668 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1CWJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:48:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Julian Anastasov <ja@ssi.bg>
Subject: [PATCH 3/6] TTY: unify pty_unix98_install fail path handling
Date: Wed, 23 Mar 2011 10:48:34 +0100
Message-Id: <1300873717-27941-3-git-send-email-jslaby@suse.cz>
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
 drivers/tty/pty.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index f511918..b25d6c4 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -560,20 +560,19 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 		return -ENOMEM;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
-		free_tty_struct(o_tty);
-		return -ENOMEM;
+		goto err_free_tty;
 	}
 	initialize_tty_struct(o_tty, driver->other, idx);
 
 	tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
 	if (tty->termios == NULL)
-		goto free_mem_out;
+		goto err_free_mem;
 	*tty->termios = driver->init_termios;
 	tty->termios_locked = tty->termios + 1;
 
 	o_tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
 	if (o_tty->termios == NULL)
-		goto free_mem_out;
+		goto err_free_mem;
 	*o_tty->termios = driver->other->init_termios;
 	o_tty->termios_locked = o_tty->termios + 1;
 
@@ -592,11 +591,12 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	tty->count++;
 	pty_count++;
 	return 0;
-free_mem_out:
+err_free_mem:
 	kfree(o_tty->termios);
+	kfree(tty->termios);
 	module_put(o_tty->driver->owner);
+err_free_tty:
 	free_tty_struct(o_tty);
-	kfree(tty->termios);
 	return -ENOMEM;
 }
 
-- 
1.7.4.1


