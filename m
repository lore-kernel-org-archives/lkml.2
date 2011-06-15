Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1FPHAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48725 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab1FPHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:40 -0400
X-Sasl-enc: 8Qb3a4fqAkxzAEtZWkQB4gkUxU1S0TOYAwSXJxUaGwku 1308207639
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.633249416@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Subject: [27/89] serial: core, do not set DTR/RTS twice on startup
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 303a7a1199c20f7c9452f024a6e17bf348b6b398 upstream.

In .dtr_rts we do:
  uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS)
and call uart_update_termios. It does:
  uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS)
once again. As the only callsite of uart_update_termios is .dtr_rts,
remove the uart_set_mctrl from uart_update_termios to not set it twice.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/serial_core.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1483,20 +1483,6 @@ static void uart_hangup(struct tty_struc
 static void uart_update_termios(struct tty_struct *tty,
 						struct uart_state *state)
 {
-	struct uart_port *port = state->uart_port;
-
-	/*
-	 * If the device failed to grab its irq resources,
-	 * or some other error occurred, don't try to talk
-	 * to the port hardware.
-	 */
-	if (!(tty->flags & (1 << TTY_IO_ERROR))) {
-		/*
-		 * And finally enable the RTS and DTR signals.
-		 */
-		if (tty->termios->c_cflag & CBAUD)
-			uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
-	}
 }
 
 static int uart_carrier_raised(struct tty_port *port)


