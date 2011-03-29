Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1C2WLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:11:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:60303 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1C2WLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:11:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] serial: core, remove uart_update_termios
Date: Wed, 30 Mar 2011 00:10:57 +0200
Message-Id: <1301436657-20410-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301436657-20410-1-git-send-email-jslaby@suse.cz>
References: <4D91F667.3060603@suse.cz>
 <1301436657-20410-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, uart_update_termios is empty, so it's time to remove it. We no
longer need a live tty in .dtr_rts. So this should prune all the bugs
where tty is zeroed in port->tty during tty_port_block_til_ready.

There is one thing to note. We don't set ASYNC_NORMAL_ACTIVE now. It's
because this is done already in tty_port_block_til_ready.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/serial/serial_core.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 3aae8ed..d4bd465 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1470,21 +1470,6 @@ static void uart_hangup(struct tty_struct *tty)
 	mutex_unlock(&port->mutex);
 }
 
-/**
- *	uart_update_termios	-	update the terminal hw settings
- *	@tty: tty associated with UART
- *	@state: UART to update
- *
- *	Copy across the serial console cflag setting into the termios settings
- *	for the initial open of the port.  This allows continuity between the
- *	kernel settings, and the settings init adopts when it opens the port
- *	for the first time.
- */
-static void uart_update_termios(struct tty_struct *tty,
-						struct uart_state *state)
-{
-}
-
 static int uart_carrier_raised(struct tty_port *port)
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
@@ -1504,16 +1489,8 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = state->uart_port;
 
-	if (onoff) {
+	if (onoff)
 		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
-
-		/*
-		 * If this is the first open to succeed,
-		 * adjust things to suit.
-		 */
-		if (!test_and_set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags))
-			uart_update_termios(port->tty, state);
-	}
 	else
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
-- 
1.7.4.1


