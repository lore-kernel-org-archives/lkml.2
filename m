Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0HJWIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:08:37 -0400
Received: from kroah.org ([198.145.64.141]:44909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327Ab0HJWAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/68] serial: fix termios settings in open
Date: Tue, 10 Aug 2010 14:58:56 -0700
Message-Id: <1281477570-18944-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index a55751a..3d2acc2 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1520,8 +1520,16 @@ static void uart_dtr_rts(struct tty_port *port, int onoff)
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
@@ -1636,15 +1644,6 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
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
1.7.2

