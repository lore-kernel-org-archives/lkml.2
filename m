Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2JRU15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:27:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56833 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2JRU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:27:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 20/21] TTY: add port -> tty link
Date: Thu, 18 Oct 2012 22:26:46 +0200
Message-Id: <1350592007-9216-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For that purpose we have to temporarily introduce a second tty back
pointer into tty_port. It is because serial layer, and maybe others,
still do not use tty_port_tty_set/get. So that we cannot set the
tty_port->tty to NULL at will now.

Yes, the fix would be to convert whole serial layer and all its users
to tty_port_tty_set/get. However we are in the process of removing the
need of tty in most of the call sites, so this would lead to a
duplicated work.

Instead we have now tty_port->itty (internal tty) which will be used
only in flush_to_ldisc. For that one it is ensured that itty is valid
wherever the work is run. IOW, the work is synchronously cancelled
before we set itty to NULL and also before hangup is processed.

After we need only tty_port and not tty_struct in most code, this
shall be changed to tty_port_tty_set/get and itty removed completely.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c    | 2 ++
 drivers/tty/tty_io.c | 3 +++
 include/linux/tty.h  | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2728afe..c326908 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -345,6 +345,7 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	tty_port_init(ports[1]);
 	o_tty->port = ports[0];
 	tty->port = ports[1];
+	o_tty->port->itty = o_tty;
 
 	tty_driver_kref_get(driver);
 	tty->count++;
@@ -371,6 +372,7 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 
 static void pty_cleanup(struct tty_struct *tty)
 {
+	tty->port->itty = NULL;
 	kfree(tty->port);
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f90b621..202008f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1417,6 +1417,8 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 			"%s: %s driver does not set tty->port. This will crash the kernel later. Fix the driver!\n",
 			__func__, tty->driver->name);
 
+	tty->port->itty = tty;
+
 	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need
@@ -1552,6 +1554,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 		tty->ops->shutdown(tty);
 	tty_free_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
+	tty->port->itty = NULL;
 
 	if (tty->link)
 		tty_kref_put(tty->link);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b4b3c56..9be74d6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -189,6 +189,7 @@ struct tty_port_operations {
 	
 struct tty_port {
 	struct tty_struct	*tty;		/* Back pointer */
+	struct tty_struct	*itty;		/* internal back ptr */
 	const struct tty_port_operations *ops;	/* Port operations */
 	spinlock_t		lock;		/* Lock protecting tty field */
 	int			blocked_open;	/* Waiting to open */
-- 
1.7.12.3


