Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab1GMKbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:31:36 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:37555 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab1GMKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:31:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] TTY: remove tty_locked
Date: Wed, 13 Jul 2011 12:31:26 +0200
Message-Id: <1310553086-27427-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310553086-27427-1-git-send-email-jslaby@suse.cz>
References: <201107122325.35013.arnd@arndb.de>
 <1310553086-27427-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used it really only serial and ami_serial. The rest of the
callsites were BUG/WARN_ONs to check if BTM is held. Now that we
pruned tty_locked from both of the real users, we can get rid of
tty_lock along with __big_tty_mutex_owner.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |    4 ----
 drivers/tty/tty_ldisc.c          |    1 -
 drivers/tty/tty_mutex.c          |    8 --------
 drivers/tty/vt/selection.c       |    4 ++--
 include/linux/tty.h              |    2 --
 5 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 9df1664..af805d6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1246,8 +1246,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	struct uart_port *uport;
 	unsigned long flags;
 
-	BUG_ON(!tty_locked());
-
 	if (!state)
 		return;
 
@@ -1379,7 +1377,6 @@ static void uart_hangup(struct tty_struct *tty)
 	struct tty_port *port = &state->port;
 	unsigned long flags;
 
-	BUG_ON(!tty_locked());
 	pr_debug("uart_hangup(%d)\n", state->uart_port->line);
 
 	mutex_lock(&port->mutex);
@@ -1466,7 +1463,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	struct tty_port *port;
 	int retval, line = tty->index;
 
-	BUG_ON(!tty_locked());
 	pr_debug("uart_open(%d) called\n", line);
 
 	/*
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index ef925d5..512c49f 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -450,7 +450,6 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 	if (ld->ops->open) {
 		int ret;
                 /* BTM here locks versus a hangup event */
-		WARN_ON(!tty_locked());
 		ret = ld->ops->open(tty);
 		if (ret)
 			clear_bit(TTY_LDISC_OPEN, &tty->flags);
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 3b2bb77..7feada7 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -15,8 +15,6 @@
  * Don't use in new code.
  */
 static DEFINE_MUTEX(big_tty_mutex);
-struct task_struct *__big_tty_mutex_owner;
-EXPORT_SYMBOL_GPL(__big_tty_mutex_owner);
 
 /*
  * Getting the big tty mutex.
@@ -25,10 +23,7 @@ void __lockfunc tty_lock(void)
 {
 	struct task_struct *task = current;
 
-	WARN_ON(__big_tty_mutex_owner == task);
-
 	mutex_lock(&big_tty_mutex);
-	__big_tty_mutex_owner = task;
 }
 EXPORT_SYMBOL(tty_lock);
 
@@ -36,9 +31,6 @@ void __lockfunc tty_unlock(void)
 {
 	struct task_struct *task = current;
 
-	WARN_ON(__big_tty_mutex_owner != task);
-	__big_tty_mutex_owner = NULL;
-
 	mutex_unlock(&big_tty_mutex);
 }
 EXPORT_SYMBOL(tty_unlock);
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index fb864e7..7a0a12a 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -301,6 +301,8 @@ int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *t
 /* Insert the contents of the selection buffer into the
  * queue of the tty associated with the current console.
  * Invoked by ioctl().
+ *
+ * Locking: always called with BTM from vt_ioctl
  */
 int paste_selection(struct tty_struct *tty)
 {
@@ -310,8 +312,6 @@ int paste_selection(struct tty_struct *tty)
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
-	/* always called with BTM from vt_ioctl */
-	WARN_ON(!tty_locked());
 
 	console_lock();
 	poke_blanked_console();
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 44bc0c5..6d5eceb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -600,8 +600,6 @@ extern long vt_compat_ioctl(struct tty_struct *tty,
 /* functions for preparation of BKL removal */
 extern void __lockfunc tty_lock(void) __acquires(tty_lock);
 extern void __lockfunc tty_unlock(void) __releases(tty_lock);
-extern struct task_struct *__big_tty_mutex_owner;
-#define tty_locked()		(current == __big_tty_mutex_owner)
 
 /*
  * wait_event_interruptible_tty -- wait for a condition with the tty lock held
-- 
1.7.6


