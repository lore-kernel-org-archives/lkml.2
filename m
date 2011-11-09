Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1KIUeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:34:22 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37426 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1KIUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:34:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 10/10] TTY: serial, extract uart_port_startup
Date: Wed,  9 Nov 2011 21:34:14 +0100
Message-Id: <1320870854-23868-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract ASYNC_INITIALIZED/TTY_IO_ERROR handling from uart_startup.
This will be useful for tty port helpers. These flags are handled
by the helpers instead.

So we create a new function uart_port_startup without touching these
flags there. And we keep uart_startup with the exact behavior as
before. We need that one because we start/stop the device from other
paths than open/close/hangup.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   43 ++++++++++++++++++++++++-------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 68763c0..d2990f7 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -131,24 +131,16 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
  * Startup the port.  This will be called once per open.  All calls
  * will be serialised by the per-port mutex.
  */
-static int uart_startup(struct tty_struct *tty, struct uart_state *state, int init_hw)
+static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
+		int init_hw)
 {
 	struct uart_port *uport = state->uart_port;
 	struct tty_port *port = &state->port;
 	unsigned long page;
 	int retval = 0;
 
-	if (port->flags & ASYNC_INITIALIZED)
-		return 0;
-
-	/*
-	 * Set the TTY IO error marker - we will only clear this
-	 * once we have successfully opened the port.
-	 */
-	set_bit(TTY_IO_ERROR, &tty->flags);
-
 	if (uport->type == PORT_UNKNOWN)
-		return 0;
+		return 1;
 
 	/*
 	 * Initialise and allocate the transmit and temporary
@@ -190,10 +182,6 @@ static int uart_startup(struct tty_struct *tty, struct uart_state *state, int in
 				tty->hw_stopped = 1;
 			spin_unlock_irq(&uport->lock);
 		}
-
-		set_bit(ASYNCB_INITIALIZED, &port->flags);
-
-		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 
 	/*
@@ -202,6 +190,31 @@ static int uart_startup(struct tty_struct *tty, struct uart_state *state, int in
 	 * now.
 	 */
 	if (retval && capable(CAP_SYS_ADMIN))
+		return 1;
+
+	return retval;
+}
+
+static int uart_startup(struct tty_struct *tty, struct uart_state *state,
+		int init_hw)
+{
+	struct tty_port *port = &state->port;
+	int retval;
+
+	if (port->flags & ASYNC_INITIALIZED)
+		return 0;
+
+	/*
+	 * Set the TTY IO error marker - we will only clear this
+	 * once we have successfully opened the port.
+	 */
+	set_bit(TTY_IO_ERROR, &tty->flags);
+
+	retval = uart_port_startup(tty, state, init_hw);
+	if (!retval) {
+		set_bit(ASYNCB_INITIALIZED, &port->flags);
+		clear_bit(TTY_IO_ERROR, &tty->flags);
+	} else if (retval > 0)
 		retval = 0;
 
 	return retval;
-- 
1.7.7


