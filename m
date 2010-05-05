Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934774Ab0EEKlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:41:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54822 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934639Ab0EEKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:41:49 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 18/20] serial: add port helpers
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:03:21 +0100
Message-ID: <20100505100321.3595.41635.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can make this the same as the ones that will be needed by the tty_port
helper logic that we want to move to but still call them from the existing
code base.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/serial_core.c |   51 ++++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 14 deletions(-)


diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 424b1c7..2379045 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1501,6 +1501,34 @@ static void uart_update_termios(struct tty_struct *tty,
 	}
 }
 
+static int uart_carrier_raised(struct tty_port *port)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	int mctrl;
+	mutex_lock(&port->mutex);
+	spin_lock_irq(&uport->lock);
+	uport->ops->enable_ms(uport);
+	mctrl = uport->ops->get_mctrl(uport);
+	spin_unlock_irq(&uport->lock);
+	mutex_unlock(&port->mutex);
+	if (mctrl & TIOCM_CAR)
+		return 1;
+	return 0;
+}
+
+static void uart_dtr_rts(struct tty_port *port, int onoff)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	mutex_lock(&port->mutex);
+	if (onoff)
+		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+	else
+		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+	mutex_unlock(&port->mutex);
+}
+
 /*
  * Block the open until the port is ready.  We must be called with
  * the per-port semaphore held.
@@ -1509,9 +1537,7 @@ static int
 uart_block_til_ready(struct file *filp, struct uart_state *state)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	struct uart_port *uport = state->uart_port;
 	struct tty_port *port = &state->port;
-	unsigned int mctrl;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -1555,23 +1581,14 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 		 * not set RTS here - we want to make sure we catch
 		 * the data from the modem.
 		 */
-		if (port->tty->termios->c_cflag & CBAUD) {
-			mutex_lock(&port->mutex);
-			uart_set_mctrl(uport, TIOCM_DTR);
-			mutex_unlock(&port->mutex);
-		}
+		if (port->tty->termios->c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
 
 		/*
 		 * and wait for the carrier to indicate that the
 		 * modem is ready for us.
 		 */
-		mutex_lock(&port->mutex);
-		spin_lock_irq(&uport->lock);
-		uport->ops->enable_ms(uport);
-		mctrl = uport->ops->get_mctrl(uport);
-		spin_unlock_irq(&uport->lock);
-		mutex_unlock(&port->mutex);
-		if (mctrl & TIOCM_CAR)
+		if (tty_port_carrier_raised(port))
 			break;
 
 		schedule();
@@ -2349,6 +2366,11 @@ static const struct tty_operations uart_ops = {
 #endif
 };
 
+static const struct tty_port_operations uart_port_ops = {
+	.carrier_raised = uart_carrier_raised,
+	.dtr_rts	= uart_dtr_rts,
+};
+
 /**
  *	uart_register_driver - register a driver with the uart core layer
  *	@drv: low level driver structure
@@ -2405,6 +2427,7 @@ int uart_register_driver(struct uart_driver *drv)
 		struct tty_port *port = &state->port;
 
 		tty_port_init(port);
+		port->ops = &uart_port_ops;
 		port->close_delay     = 500;	/* .5 seconds */
 		port->closing_wait    = 30000;	/* 30 seconds */
 		tasklet_init(&state->tlet, uart_tasklet_action,

