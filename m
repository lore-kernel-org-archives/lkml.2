Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1FPHiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:38:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43788 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab1FPHAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:38 -0400
X-Sasl-enc: yIV6e0yeoJdj/ivBrU8nSBAa7lZe6wo0KXSJBNK0W/TH 1308207638
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.533224938@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Subject: [26/89] serial: core, move termios handling to uart_startup
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit c7d7abff40c27f82fe78b1091ab3fad69b2546f9 upstream.

We should not fiddle with speed and cflags in .dtr_rts hook. Actually
we might not have tty at that moment already.

So move the console cflag copy and speed setup into uart_startup.
Actually the speed setup is already there, but we need to call it
unconditionally (uart_startup is called from uart_open with hw_init =
0).

This means we move uart_change_speed before dtr/rts setup in .dtr_rts.
But this should not matter as the setup should be called after
uart_change_speed anyway.
Before:                             After:
dtr/rts setup (dtr_rts)             uart_change_speed (startup)
uart_change_speed (update_termios)  dtr/rts setup (dtr_rts)
dtr/rts setup (update_termios)      dtr/rts setup (update_termios)

The second setup will dismiss with the next patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/serial_core.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -172,12 +172,16 @@ static int uart_startup(struct tty_struc
 
 	retval = uport->ops->startup(uport);
 	if (retval == 0) {
-		if (init_hw) {
-			/*
-			 * Initialise the hardware port settings.
-			 */
-			uart_change_speed(tty, state, NULL);
+		if (uart_console(uport) && uport->cons->cflag) {
+			tty->termios->c_cflag = uport->cons->cflag;
+			uport->cons->cflag = 0;
+		}
+		/*
+		 * Initialise the hardware port settings.
+		 */
+		uart_change_speed(tty, state, NULL);
 
+		if (init_hw) {
 			/*
 			 * Setup the RTS and DTR signals once the
 			 * port is open and ready to respond.
@@ -1481,11 +1485,6 @@ static void uart_update_termios(struct t
 {
 	struct uart_port *port = state->uart_port;
 
-	if (uart_console(port) && port->cons->cflag) {
-		tty->termios->c_cflag = port->cons->cflag;
-		port->cons->cflag = 0;
-	}
-
 	/*
 	 * If the device failed to grab its irq resources,
 	 * or some other error occurred, don't try to talk
@@ -1493,11 +1492,6 @@ static void uart_update_termios(struct t
 	 */
 	if (!(tty->flags & (1 << TTY_IO_ERROR))) {
 		/*
-		 * Make termios settings take effect.
-		 */
-		uart_change_speed(tty, state, NULL);
-
-		/*
 		 * And finally enable the RTS and DTR signals.
 		 */
 		if (tty->termios->c_cflag & CBAUD)


