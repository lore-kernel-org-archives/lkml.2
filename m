Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1FPHAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:47 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45389 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316Ab1FPHAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:41 -0400
X-Sasl-enc: 3iLRXMyb36gOv8ltWPZsiJ5nw1fm/HmvR0m34EvGdWpk 1308207641
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.738343164@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Subject: [28/89] serial: core, remove uart_update_termios
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 6f5c24ad0f7619502199185a026a228174a27e68 upstream.

Now, uart_update_termios is empty, so it's time to remove it. We no
longer need a live tty in .dtr_rts. So this should prune all the bugs
where tty is zeroed in port->tty during tty_port_block_til_ready.

There is one thing to note. We don't set ASYNC_NORMAL_ACTIVE now. It's
because this is done already in tty_port_block_til_ready.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/serial_core.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1470,21 +1470,6 @@ static void uart_hangup(struct tty_struc
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
@@ -1504,16 +1489,8 @@ static void uart_dtr_rts(struct tty_port
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


