Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1C2WLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:11:03 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:60304 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1C2WLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:11:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] serial: core, do not set DTR/RTS twice on startup
Date: Wed, 30 Mar 2011 00:10:56 +0200
Message-Id: <1301436657-20410-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301436657-20410-1-git-send-email-jslaby@suse.cz>
References: <4D91F667.3060603@suse.cz>
 <1301436657-20410-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In .dtr_rts we do:
  uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS)
and call uart_update_termios. It does:
  uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS)
once again. As the only callsite of uart_update_termios is .dtr_rts,
remove the uart_set_mctrl from uart_update_termios to not set it twice.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/serial/serial_core.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 47657cf..3aae8ed 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1483,20 +1483,6 @@ static void uart_hangup(struct tty_struct *tty)
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
-- 
1.7.4.1


