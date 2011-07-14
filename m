Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1GNMfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:35:24 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51362 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1GNMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:35:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH v2 3/6] TTY: serial, remove tasklet for tty_wakeup
Date: Thu, 14 Jul 2011 14:35:12 +0200
Message-Id: <1310646915-3032-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_wakeup can be called from any context. So there is no need to have
an extra tasklet for calling that. Hence save some space and remove
the tasklet completely.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   20 +-------------------
 include/linux/serial_core.h      |    1 -
 2 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2cbf1bd..4786232 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -72,7 +72,7 @@ void uart_write_wakeup(struct uart_port *port)
 	 * closed.  No cookie for you.
 	 */
 	BUG_ON(!state);
-	tasklet_schedule(&state->tlet);
+	tty_wakeup(state->port.tty);
 }
 
 static void uart_stop(struct tty_struct *tty)
@@ -107,12 +107,6 @@ static void uart_start(struct tty_struct *tty)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-static void uart_tasklet_action(unsigned long data)
-{
-	struct uart_state *state = (struct uart_state *)data;
-	tty_wakeup(state->port.tty);
-}
-
 static inline void
 uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 {
@@ -250,11 +244,6 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 	}
 
 	/*
-	 * kill off our tasklet
-	 */
-	tasklet_kill(&state->tlet);
-
-	/*
 	 * Free the transmit buffer page.
 	 */
 	if (state->xmit.buf) {
@@ -2277,8 +2266,6 @@ int uart_register_driver(struct uart_driver *drv)
 		port->ops = &uart_port_ops;
 		port->close_delay     = 500;	/* .5 seconds */
 		port->closing_wait    = 30000;	/* 30 seconds */
-		tasklet_init(&state->tlet, uart_tasklet_action,
-			     (unsigned long)state);
 	}
 
 	retval = tty_register_driver(normal);
@@ -2439,11 +2426,6 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	uport->type = PORT_UNKNOWN;
 
-	/*
-	 * Kill the tasklet, and free resources.
-	 */
-	tasklet_kill(&state->tlet);
-
 	state->uart_port = NULL;
 	mutex_unlock(&port_mutex);
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a5c3114..76e1103 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -384,7 +384,6 @@ struct uart_state {
 	int			pm_state;
 	struct circ_buf		xmit;
 
-	struct tasklet_struct	tlet;
 	struct uart_port	*uart_port;
 };
 
-- 
1.7.6


