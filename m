Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab1KIUeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:34:21 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37400 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab1KIUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:57 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 09/10] TTY: serial, fill uart_port_shutdown
Date: Wed,  9 Nov 2011 21:33:51 +0100
Message-Id: <1320870831-23778-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's fill the port_ops->shutdown. We will need this for hangup and
close port helpers.

We don't need to touch DTR/RTS registers in uart_port_shutdown. They
are set to off from port_close_start properly already.

Also we don't need to pin the TTY_IO_ERROR bit. This will be done in
close/hangup paths.

We leave uart_shutdown as is, because it is used (and will be) from
several paths now. Like from suspend.

The point is to not touch ASYNC_INITIALIZED bit. It will be set (and
checked) properly by the tty port helpers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   42 +++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index d7e8a5e..68763c0 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -61,6 +61,8 @@ static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
+static void uart_port_shutdown(struct tty_port *port);
+
 /*
  * This routine is used by the interrupt handler to schedule processing in
  * the software interrupt portion of the driver.
@@ -228,24 +230,7 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		if (!tty || (tty->termios->c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 
-		/*
-		 * clear delta_msr_wait queue to avoid mem leaks: we may free
-		 * the irq here so the queue might never be woken up.  Note
-		 * that we won't end up waiting on delta_msr_wait again since
-		 * any outstanding file descriptors should be pointing at
-		 * hung_up_tty_fops now.
-		 */
-		wake_up_interruptible(&port->delta_msr_wait);
-
-		/*
-		 * Free the IRQ and disable the port.
-		 */
-		uport->ops->shutdown(uport);
-
-		/*
-		 * Ensure that the IRQ handler isn't running on another CPU.
-		 */
-		synchronize_irq(uport->irq);
+		uart_port_shutdown(port);
 	}
 
 	/*
@@ -1411,6 +1396,27 @@ static int uart_port_activate(struct tty_port *port, struct tty_struct *tty)
 
 static void uart_port_shutdown(struct tty_port *port)
 {
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+
+	/*
+	 * clear delta_msr_wait queue to avoid mem leaks: we may free
+	 * the irq here so the queue might never be woken up.  Note
+	 * that we won't end up waiting on delta_msr_wait again since
+	 * any outstanding file descriptors should be pointing at
+	 * hung_up_tty_fops now.
+	 */
+	wake_up_interruptible(&port->delta_msr_wait);
+
+	/*
+	 * Free the IRQ and disable the port.
+	 */
+	uport->ops->shutdown(uport);
+
+	/*
+	 * Ensure that the IRQ handler isn't running on another CPU.
+	 */
+	synchronize_irq(uport->irq);
 }
 
 static int uart_carrier_raised(struct tty_port *port)
-- 
1.7.7


