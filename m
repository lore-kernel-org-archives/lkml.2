Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab0HJWIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:08:51 -0400
Received: from kroah.org ([198.145.64.141]:44907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab0HJWAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/68] serial: Use block_til_ready helper
Date: Tue, 10 Aug 2010 14:58:55 -0700
Message-Id: <1281477570-18944-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Our code now rather closely resembles the helper, so switch to it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   87 +-----------------------------------------
 1 files changed, 1 insertions(+), 86 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0603e0d..a55751a 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1526,91 +1526,6 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
-/*
- * Block the open until the port is ready.  We must be called with
- * the per-port semaphore held.
- */
-static int
-uart_block_til_ready(struct file *filp, struct uart_state *state)
-{
-	DECLARE_WAITQUEUE(wait, current);
-	struct tty_port *port = &state->port;
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->lock, flags);
-	if (!tty_hung_up_p(filp))
-		port->count--;
-	port->blocked_open++;
-	spin_unlock_irqrestore(&port->lock, flags);
-
-	add_wait_queue(&port->open_wait, &wait);
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/*
-		 * If we have been hung up, tell userspace/restart open.
-		 */
-		if (tty_hung_up_p(filp) || port->tty == NULL)
-			break;
-
-		/*
-		 * If the port has been closed, tell userspace/restart open.
-		 */
-		if (!(port->flags & ASYNC_INITIALIZED))
-			break;
-
-		/*
-		 * If non-blocking mode is set, or CLOCAL mode is set,
-		 * we don't want to wait for the modem status lines to
-		 * indicate that the port is ready.
-		 *
-		 * Also, if the port is not enabled/configured, we want
-		 * to allow the open to succeed here.  Note that we will
-		 * have set TTY_IO_ERROR for a non-existant port.
-		 */
-		if ((filp->f_flags & O_NONBLOCK) ||
-		    (port->tty->termios->c_cflag & CLOCAL) ||
-		    (port->tty->flags & (1 << TTY_IO_ERROR)))
-			break;
-
-		/*
-		 * Set DTR to allow modem to know we're waiting.  Do
-		 * not set RTS here - we want to make sure we catch
-		 * the data from the modem.
-		 */
-		if (port->tty->termios->c_cflag & CBAUD)
-			tty_port_raise_dtr_rts(port);
-
-		/*
-		 * and wait for the carrier to indicate that the
-		 * modem is ready for us.
-		 */
-		if (tty_port_carrier_raised(port))
-			break;
-
-		schedule();
-
-		if (signal_pending(current))
-			break;
-	}
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->open_wait, &wait);
-
-	spin_lock_irqsave(&port->lock, flags);
-	if (!tty_hung_up_p(filp))
-		port->count++;
-	port->blocked_open--;
-	spin_unlock_irqrestore(&port->lock, flags);
-
-	if (signal_pending(current))
-		return -ERESTARTSYS;
-
-	if (!port->tty || tty_hung_up_p(filp))
-		return -EAGAIN;
-
-	return 0;
-}
-
 static struct uart_state *uart_get(struct uart_driver *drv, int line)
 {
 	struct uart_state *state;
@@ -1719,7 +1634,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	 */
 	mutex_unlock(&port->mutex);
 	if (retval == 0)
-		retval = uart_block_til_ready(filp, state);
+		retval = tty_port_block_til_ready(port, tty, filp);
 
 	/*
 	 * If this is the first open to succeed, adjust things to suit.
-- 
1.7.2

