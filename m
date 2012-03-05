Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088Ab2CEOCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:02:46 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34726 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2CENxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 60/68] TTY: amiserial, use tty_port_block_til_ready
Date: Mon,  5 Mar 2012 14:52:47 +0100
Message-Id: <1330955575-26641-61-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, 150 lines of duplicated stuff is gone now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |  148 +----------------------------------------------
 1 file changed, 1 insertion(+), 147 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 61d7461..8cc8e15 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1556,119 +1556,6 @@ static void rs_hangup(struct tty_struct *tty)
 }
 
 /*
- * ------------------------------------------------------------
- * rs_open() and friends
- * ------------------------------------------------------------
- */
-static int block_til_ready(struct tty_struct *tty, struct file * filp,
-			   struct serial_state *info)
-{
-#ifdef DECLARE_WAITQUEUE
-	DECLARE_WAITQUEUE(wait, current);
-#else
-	struct wait_queue wait = { current, NULL };
-#endif
-	struct tty_port *port = &info->tport;
-	int		retval;
-	int		do_clocal = 0, extra_count = 0;
-	unsigned long	flags;
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (tty_hung_up_p(filp) ||
-	    (port->flags & ASYNC_CLOSING)) {
-		if (port->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&port->close_wait);
-#ifdef SERIAL_DO_RESTART
-		return ((port->flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
-	 * If non-blocking mode is set, or the port is not enabled,
-	 * then make the check up front and then exit.
-	 */
-	if ((filp->f_flags & O_NONBLOCK) ||
-	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		port->flags |= ASYNC_NORMAL_ACTIVE;
-		return 0;
-	}
-
-	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
-
-	/*
-	 * Block waiting for the carrier detect and the line to become
-	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, port->count is dropped by one, so that
-	 * rs_close() knows when to free things.  We restore it upon
-	 * exit, either normal or abnormal.
-	 */
-	retval = 0;
-	add_wait_queue(&port->open_wait, &wait);
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready before block: ttys%d, count = %d\n",
-	       info->line, port->count);
-#endif
-	local_irq_save(flags);
-	if (!tty_hung_up_p(filp)) {
-		extra_count = 1;
-		port->count--;
-	}
-	local_irq_restore(flags);
-	port->blocked_open++;
-	while (1) {
-		if (tty->termios->c_cflag & CBAUD)
-			tty_port_raise_dtr_rts(port);
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(port->flags & ASYNC_INITIALIZED)) {
-#ifdef SERIAL_DO_RESTART
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
-		    (do_clocal || tty_port_carrier_raised(port)))
-			break;
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-#ifdef SERIAL_DEBUG_OPEN
-		printk("block_til_ready blocking: ttys%d, count = %d\n",
-		       info->line, port->count);
-#endif
-		tty_unlock();
-		schedule();
-		tty_lock();
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->open_wait, &wait);
-	if (extra_count)
-		port->count++;
-	port->blocked_open--;
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready after blocking: ttys%d, count = %d\n",
-	       info->line, port->count);
-#endif
-	if (retval)
-		return retval;
-	port->flags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}
-
-/*
  * This routine is called whenever a serial port is opened.  It
  * enables interrupts for a serial port, linking in its async structure into
  * the IRQ chain.   It also performs the serial-specific
@@ -1687,47 +1574,14 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_open %s, count = %d\n", tty->name, info->count);
-#endif
 	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
-	/*
-	 * If the port is the middle of closing, bail out now
-	 */
-	if (tty_hung_up_p(filp) ||
-	    (port->flags & ASYNC_CLOSING)) {
-		if (port->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&port->close_wait);
-#ifdef SERIAL_DO_RESTART
-		return ((port->flags & ASYNC_HUP_NOTIFY) ?
-			-EAGAIN : -ERESTARTSYS);
-#else
-		return -EAGAIN;
-#endif
-	}
-
-	/*
-	 * Start up serial port
-	 */
 	retval = startup(tty, info);
 	if (retval) {
 		return retval;
 	}
 
-	retval = block_til_ready(tty, filp, info);
-	if (retval) {
-#ifdef SERIAL_DEBUG_OPEN
-		printk("rs_open returning after block_til_ready with %d\n",
-		       retval);
-#endif
-		return retval;
-	}
-
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_open %s successful...", tty->name);
-#endif
-	return 0;
+	return tty_port_block_til_ready(port, tty, filp);
 }
 
 /*
-- 
1.7.9.2


