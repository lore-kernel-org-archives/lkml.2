Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2DBLzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:40 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48002 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2DBLzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 62/69] TTY: 68328serial, use tty_port_block_til_ready
Date: Mon,  2 Apr 2012 13:54:46 +0200
Message-Id: <1333367693-3244-63-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the code is identical, use the tty_port_block_til_ready helper
instead of re-implemented variant.

The code does not perform rtsdts handling, hence we do not need to
provide tty port hooks for them. The default ones will be used
instead. The only necessary thing is to provide tty_port_operations.
It is empty, but has to be there...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   96 ++------------------------------------
 1 file changed, 5 insertions(+), 91 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 77e10bb..3ed20e4 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -1104,96 +1104,6 @@ void rs_hangup(struct tty_struct *tty)
 }
 
 /*
- * ------------------------------------------------------------
- * rs_open() and friends
- * ------------------------------------------------------------
- */
-static int block_til_ready(struct tty_struct *tty, struct file * filp,
-			   struct m68k_serial *info)
-{
-	struct tty_port *port = &info->tport;
-	DECLARE_WAITQUEUE(wait, current);
-	int		retval;
-	int		do_clocal = 0;
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (port->flags & ASYNC_CLOSING) {
-		interruptible_sleep_on(&port->close_wait);
-#ifdef SERIAL_DO_RESTART
-		if (port->flags & ASYNC_HUP_NOTIFY)
-			return -EAGAIN;
-		else
-			return -ERESTARTSYS;
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
-
-	port->count--;
-	port->blocked_open++;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
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
-		if (!(port->flags & ASYNC_CLOSING) && do_clocal)
-			break;
-                if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-		tty_unlock();
-		schedule();
-		tty_lock();
-	}
-	current->state = TASK_RUNNING;
-	remove_wait_queue(&port->open_wait, &wait);
-	if (!tty_hung_up_p(filp))
-		port->count++;
-	port->blocked_open--;
-
-	if (retval)
-		return retval;
-	port->flags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}	
-
-/*
  * This routine is called whenever a serial port is opened.  It
  * enables interrupts for a serial port, linking in its S structure into
  * the IRQ chain.   It also performs the serial-specific
@@ -1220,7 +1130,7 @@ int rs_open(struct tty_struct *tty, struct file * filp)
 	if (retval)
 		return retval;
 
-	return block_til_ready(tty, filp, info);
+	return tty_port_block_til_ready(&info->tport, tty, filp);
 }
 
 /* Finally, routines used to initialize the serial driver. */
@@ -1248,6 +1158,9 @@ static const struct tty_operations rs_ops = {
 	.set_ldisc = rs_set_ldisc,
 };
 
+static const struct tty_port_operations rs_port_ops = {
+};
+
 /* rs_init inits the driver */
 static int __init
 rs68328_init(void)
@@ -1288,6 +1201,7 @@ rs68328_init(void)
 
 	    info = &m68k_soft[i];
 	    tty_port_init(&info->tport);
+	    info->tport.ops = &rs_port_ops;
 	    info->magic = SERIAL_MAGIC;
 	    info->port = (int) &uart_addr[i];
 	    info->irq = uart_irqs[i];
-- 
1.7.9.2


