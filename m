Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2DBMK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:10:59 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47932 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 18/69] TTY: isdn, use tty_port_block_til_ready helper
Date: Mon,  2 Apr 2012 13:54:02 +0200
Message-Id: <1333367693-3244-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a bunch of duplicated code which does the same as
tty_port_block_til_ready does.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   97 +------------------------------------------
 1 file changed, 1 insertion(+), 96 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index b41a80a..7bc5067 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1486,101 +1486,6 @@ isdn_tty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  * ------------------------------------------------------------
  */
 
-static int
-isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *info)
-{
-	struct tty_port *port = &info->port;
-	DECLARE_WAITQUEUE(wait, NULL);
-	int do_clocal = 0;
-	int retval;
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (tty_hung_up_p(filp) ||
-	    (port->flags & ASYNC_CLOSING)) {
-		if (port->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&port->close_wait);
-#ifdef MODEM_DO_RESTART
-		if (port->flags & ASYNC_HUP_NOTIFY)
-			return -EAGAIN;
-		else
-			return -ERESTARTSYS;
-#else
-		return -EAGAIN;
-#endif
-	}
-	/*
-	 * If non-blocking mode is set, then make the check up front
-	 * and then exit.
-	 */
-	if ((filp->f_flags & O_NONBLOCK) ||
-	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		port->flags |= ASYNC_NORMAL_ACTIVE;
-		return 0;
-	}
-	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
-	/*
-	 * Block waiting for the carrier detect and the line to become
-	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->count is dropped by one, so that
-	 * isdn_tty_close() knows when to free things.  We restore it upon
-	 * exit, either normal or abnormal.
-	 */
-	retval = 0;
-	add_wait_queue(&port->open_wait, &wait);
-#ifdef ISDN_DEBUG_MODEM_OPEN
-	printk(KERN_DEBUG "isdn_tty_block_til_ready before block: ttyi%d, count = %d\n",
-	       info->line, info->count);
-#endif
-	if (!(tty_hung_up_p(filp)))
-		port->count--;
-	port->blocked_open++;
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(port->flags & ASYNC_INITIALIZED)) {
-#ifdef MODEM_DO_RESTART
-			if (port->flags & ASYNC_HUP_NOTIFY)
-				retval = -EAGAIN;
-			else
-				retval = -ERESTARTSYS;
-#else
-			retval = -EAGAIN;
-#endif
-			break;
-		}
-		if (!(port->flags & ASYNC_CLOSING) &&
-		    (do_clocal || tty_port_carrier_raised(port))) {
-			break;
-		}
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-#ifdef ISDN_DEBUG_MODEM_OPEN
-		printk(KERN_DEBUG "isdn_tty_block_til_ready blocking: ttyi%d, count = %d\n",
-		       info->line, port->count);
-#endif
-		schedule();
-	}
-	current->state = TASK_RUNNING;
-	remove_wait_queue(&port->open_wait, &wait);
-	if (!tty_hung_up_p(filp))
-		port->count++;
-	port->blocked_open--;
-#ifdef ISDN_DEBUG_MODEM_OPEN
-	printk(KERN_DEBUG "isdn_tty_block_til_ready after blocking: ttyi%d, count = %d\n",
-	       info->line, port->count);
-#endif
-	if (retval)
-		return retval;
-	port->flags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}
-
 /*
  * This routine is called whenever a serial port is opened.  It
  * enables interrupts for a serial port, linking in its async structure into
@@ -1616,7 +1521,7 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 #endif
 		return retval;
 	}
-	retval = isdn_tty_block_til_ready(tty, filp, info);
+	retval = tty_port_block_til_ready(port, tty, filp);
 	if (retval) {
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_open return after isdn_tty_block_til_ready \n");
-- 
1.7.9.2


