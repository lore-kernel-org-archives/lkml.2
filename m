Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731Ab0HEWm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:42:59 -0400
Received: from kroah.org ([198.145.64.141]:37650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328Ab0HEWYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/67] serial: Change the wait for carrier locking
Date: Thu,  5 Aug 2010 15:22:57 -0700
Message-Id: <1281047014-23429-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We want to push the lock/unlock into the helper functions so that we
can prepare to move to using the tty_port helper. The expansion initially
comes out a bit ugly but its worth the temporary expansion IMHO just so
we can produce a nice testable series of changes.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   44 +++++++++++++++++++++++++++++++++--------
 1 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 570dca2..424b1c7 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1272,6 +1272,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	struct uart_state *state = tty->driver_data;
 	struct tty_port *port;
 	struct uart_port *uport;
+	unsigned long flags;
 
 	BUG_ON(!kernel_locked());
 
@@ -1284,9 +1285,12 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	pr_debug("uart_close(%d) called\n", uport->line);
 
 	mutex_lock(&port->mutex);
+	spin_lock_irqsave(&port->lock, flags);
 
-	if (tty_hung_up_p(filp))
+	if (tty_hung_up_p(filp)) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		goto done;
+	}
 
 	if ((tty->count == 1) && (port->count != 1)) {
 		/*
@@ -1305,8 +1309,10 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 		       tty->name, port->count);
 		port->count = 0;
 	}
-	if (port->count)
+	if (port->count) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		goto done;
+	}
 
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify
@@ -1314,6 +1320,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 * setting tty->closing.
 	 */
 	tty->closing = 1;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
 		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
@@ -1340,20 +1347,26 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	tty_ldisc_flush(tty);
 
-	tty->closing = 0;
 	tty_port_tty_set(port, NULL);
+	spin_lock_irqsave(&port->lock, flags);
+	tty->closing = 0;
 
 	if (port->blocked_open) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		if (port->close_delay)
 			msleep_interruptible(port->close_delay);
+		spin_lock_irqsave(&port->lock, flags);
 	} else if (!uart_console(uport)) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		uart_change_pm(state, 3);
+		spin_lock_irqsave(&port->lock, flags);
 	}
 
 	/*
 	 * Wake up anyone trying to open this port.
 	 */
 	clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
+	spin_unlock_irqrestore(&port->lock, flags);
 	wake_up_interruptible(&port->open_wait);
 
 done:
@@ -1429,6 +1442,7 @@ static void uart_hangup(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
 	struct tty_port *port = &state->port;
+	unsigned long flags;
 
 	BUG_ON(!kernel_locked());
 	pr_debug("uart_hangup(%d)\n", state->uart_port->line);
@@ -1437,8 +1451,10 @@ static void uart_hangup(struct tty_struct *tty)
 	if (port->flags & ASYNC_NORMAL_ACTIVE) {
 		uart_flush_buffer(tty);
 		uart_shutdown(tty, state);
+		spin_lock_irqsave(&port->lock, flags);
 		port->count = 0;
 		clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
+		spin_unlock_irqrestore(&port->lock, flags);
 		tty_port_tty_set(port, NULL);
 		wake_up_interruptible(&port->open_wait);
 		wake_up_interruptible(&port->delta_msr_wait);
@@ -1496,9 +1512,13 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 	struct uart_port *uport = state->uart_port;
 	struct tty_port *port = &state->port;
 	unsigned int mctrl;
+	unsigned long flags;
 
+	spin_lock_irqsave(&port->lock, flags);
+	if (!tty_hung_up_p(filp))
+		port->count--;
 	port->blocked_open++;
-	port->count--;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	add_wait_queue(&port->open_wait, &wait);
 	while (1) {
@@ -1535,23 +1555,26 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 		 * not set RTS here - we want to make sure we catch
 		 * the data from the modem.
 		 */
-		if (port->tty->termios->c_cflag & CBAUD)
+		if (port->tty->termios->c_cflag & CBAUD) {
+			mutex_lock(&port->mutex);
 			uart_set_mctrl(uport, TIOCM_DTR);
+			mutex_unlock(&port->mutex);
+		}
 
 		/*
 		 * and wait for the carrier to indicate that the
 		 * modem is ready for us.
 		 */
+		mutex_lock(&port->mutex);
 		spin_lock_irq(&uport->lock);
 		uport->ops->enable_ms(uport);
 		mctrl = uport->ops->get_mctrl(uport);
 		spin_unlock_irq(&uport->lock);
+		mutex_unlock(&port->mutex);
 		if (mctrl & TIOCM_CAR)
 			break;
 
-		mutex_unlock(&port->mutex);
 		schedule();
-		mutex_lock(&port->mutex);
 
 		if (signal_pending(current))
 			break;
@@ -1559,8 +1582,11 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 
-	port->count++;
+	spin_lock_irqsave(&port->lock, flags);
+	if (!tty_hung_up_p(filp))
+		port->count++;
 	port->blocked_open--;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (signal_pending(current))
 		return -ERESTARTSYS;
@@ -1677,9 +1703,9 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * If we succeeded, wait until the port is ready.
 	 */
+	mutex_unlock(&port->mutex);
 	if (retval == 0)
 		retval = uart_block_til_ready(filp, state);
-	mutex_unlock(&port->mutex);
 
 	/*
 	 * If this is the first open to succeed, adjust things to suit.
-- 
1.7.2

