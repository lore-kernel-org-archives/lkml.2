Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0F2Ub4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:31:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0F2Uby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:31:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH] serial: fix termios settings in open
Date: Tue, 29 Jun 2010 22:31:40 +0200
Message-Id: <1277843500-14680-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V01U2FsdGVkX1+qwrU3PbgYBUbYGRyHtETZakGb9oAh2tpp8G1
 iPJQPcpjhHyBAanS4IG+VXIBriTDPMj60X6j2x9JydVRPsmMFe
 cuFsriZ786FCulFEyEMmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move termios initialization in open into uart_dtr_rts to make sure
it always gets called when necessary. Based on a suggestion from
Alan Cox.

Alan writes:
Ok this sort of makes sense. Something isn't getting initialised and both
getty and minicom will do a termios set which is sorting it out.
This is occurring because the generic block_til_ready sets
ASYNCB_NORMAL_ACTIVE so the termios updating gets skipped.

This patch should cure it and then we can think about doing it more
elegantly by getting the serial layer to use tty_port_open, kfifo and
the like and removing the tons of repeated crap in all the drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Tony Luck <tony.luck@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
---

Greg, please apply to you tty series. I thought there was a bug
in this patch but it turns out that this was incorrect. There
is still something fishy on my system with hardware flow control,
but it seems to be a preexisting condition, so this patch is actually
good, unlike what I said before. Please apply next to "serial: Use
block_til_ready helper", which introduces the ploblem.

 drivers/serial/serial_core.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 78b1eac..cd85112 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1533,8 +1533,16 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport = state->uart_port;
 
-	if (onoff)
+	if (onoff) {
 		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+
+		/*
+		 * If this is the first open to succeed,
+		 * adjust things to suit.
+		 */
+		if (!test_and_set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags))
+			uart_update_termios(port->tty, state);
+	}
 	else
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
@@ -1649,15 +1657,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	if (retval == 0)
 		retval = tty_port_block_til_ready(port, tty, filp);
 
-	/*
-	 * If this is the first open to succeed, adjust things to suit.
-	 */
-	if (retval == 0 && !(port->flags & ASYNC_NORMAL_ACTIVE)) {
-		set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
-
-		uart_update_termios(tty, state);
-	}
-
 fail:
 	return retval;
 }
-- 
1.7.1

