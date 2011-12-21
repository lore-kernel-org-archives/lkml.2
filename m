Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1LULTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:19:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:43586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1LULSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:23 -0500
Message-Id: <20111221111143.678537446@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/7] serial, 8250: Mostly avoid wakeups from under port->lock
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=8250.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While not a strict requirement (anymore), it is nice not to issue
wakeups (or have them connected by locks) from console output.

This patch avoids doing most wakeups from under port->lock, which is
connected to 8250console_write(). Only seriously challenged UARTs will
still do the wakeup, but since I don't actually have such a creature,
I'm less inclined to fix it up.

  [ INFO: possible circular locking dependency detected ]
  3.2.0-rc5-tip+ #185 Tainted: G        W
  -------------------------------------------------------
  watchdog/0/10 is trying to acquire lock:
   ((console_sem).lock){-.-...}, at:
  but task is already holding lock:
   (&rt_rq->rt_runtime_lock){-.-...}, at:
  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

   -> #5 (&rt_rq->rt_runtime_lock){-.-...}:
   -> #4 (&rq->lock){-.-.-.}:
   -> #3 (&p->pi_lock){-.-.-.}:
   -> #2 (&tty->write_wait){-.-...}:
   -> #1 (&port_lock_key){-.-...}:
   -> #0 ((console_sem).lock){-.-...}:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/tty/serial/8250.c |   62 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 12 deletions(-)
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1326,7 +1326,7 @@ static void serial8250_stop_tx(struct ua
 	}
 }
 
-static void transmit_chars(struct uart_8250_port *up);
+static int transmit_chars(struct uart_8250_port *up);
 
 static void serial8250_start_tx(struct uart_port *port)
 {
@@ -1343,8 +1343,15 @@ static void serial8250_start_tx(struct u
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 			if ((up->port.type == PORT_RM9000) ?
 				(lsr & UART_LSR_THRE) :
-				(lsr & UART_LSR_TEMT))
-				transmit_chars(up);
+				(lsr & UART_LSR_TEMT)) {
+				/*
+				 * This will nest a wakeup inside port->lock
+				 * and is thus less reliable than a well
+				 * functioning uart.
+				 */
+				if (transmit_chars(up))
+					uart_write_wakeup(&up->port);
+			}
 		}
 	}
 
@@ -1484,24 +1491,25 @@ receive_chars(struct uart_8250_port *up,
 	*status = lsr;
 }
 
-static void transmit_chars(struct uart_8250_port *up)
+static int transmit_chars(struct uart_8250_port *up)
 {
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int count;
+	int ret = 0;
 
 	if (up->port.x_char) {
 		serial_outp(up, UART_TX, up->port.x_char);
 		up->port.icount.tx++;
 		up->port.x_char = 0;
-		return;
+		goto out;
 	}
 	if (uart_tx_stopped(&up->port)) {
 		serial8250_stop_tx(&up->port);
-		return;
+		goto out;
 	}
 	if (uart_circ_empty(xmit)) {
 		__stop_tx(up);
-		return;
+		goto out;
 	}
 
 	count = up->tx_loadsz;
@@ -1514,12 +1522,15 @@ static void transmit_chars(struct uart_8
 	} while (--count > 0);
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-		uart_write_wakeup(&up->port);
+		ret = 1;
 
 	DEBUG_INTR("THRE...");
 
 	if (uart_circ_empty(xmit))
 		__stop_tx(up);
+
+out:
+	return ret;
 }
 
 static unsigned int check_modem_status(struct uart_8250_port *up)
@@ -1546,12 +1557,38 @@ static unsigned int check_modem_status(s
 }
 
 /*
+ * Unlocks port->lock and issues a uart_write_wakeup() outside of the lock.
+ *
+ * Duplicates parts of uart_write_wakeup().
+ */
+static void
+port_unlock_and_wake(struct uart_8250_port *up, unsigned long flags, int wake)
+{
+	struct uart_state *state;
+	struct tty_struct *tty;
+
+	if (!wake) {
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		return;
+	}
+
+	state = up->port.state;
+	BUG_ON(!state);
+	tty = state->port.tty;
+	tty_kref_get(tty);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
+}
+
+/*
  * This handles the interrupt from one port.
  */
 static void serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
 	unsigned long flags;
+	int wakeup = 0;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
@@ -1563,9 +1600,9 @@ static void serial8250_handle_port(struc
 		receive_chars(up, &status);
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)
-		transmit_chars(up);
+		wakeup = transmit_chars(up);
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	port_unlock_and_wake(up, flags, wakeup);
 }
 
 int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
@@ -1771,6 +1808,7 @@ static void serial8250_backup_timeout(un
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
 	unsigned int iir, ier = 0, lsr;
 	unsigned long flags;
+	int wakeup = 0;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
@@ -1801,12 +1839,12 @@ static void serial8250_backup_timeout(un
 	}
 
 	if (!(iir & UART_IIR_NO_INT))
-		transmit_chars(up);
+		wakeup = transmit_chars(up);
 
 	if (is_real_interrupt(up->port.irq))
 		serial_out(up, UART_IER, ier);
 
-	spin_unlock_irqrestore(&up->port.lock, flags);
+	port_unlock_and_wake(up, flags, wakeup);
 
 	/* Standard timer interval plus 0.2s to keep the port running */
 	mod_timer(&up->timer,


