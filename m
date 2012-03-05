Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126Ab2CEOAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:14 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34794 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964816Ab2CENxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 62/68] TTY: amiserial, use tty_port_close_start
Date: Mon,  5 Mar 2012 14:52:49 +0100
Message-Id: <1330955575-26641-63-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, no need to duplicate the code. Let's use the helper.

Amiserial changes are only free of compilation errors. I have no
access to the hardware.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   44 ++------------------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 9c8b199..afadcd43d 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1389,53 +1389,13 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *state = tty->driver_data;
 	struct tty_port *port = &state->tport;
-	unsigned long flags;
 
-	if (!state || serial_paranoia_check(state, tty->name, "rs_close"))
+	if (serial_paranoia_check(state, tty->name, "rs_close"))
 		return;
 
-	local_irq_save(flags);
-
-	if (tty_hung_up_p(filp)) {
-		DBG_CNT("before DEC-hung");
-		local_irq_restore(flags);
+	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	}
 
-#ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttys%d, count = %d\n", state->line, port->count);
-#endif
-	if ((tty->count == 1) && (port->count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  port->count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "port->count is %d\n", state->tport.count);
-		port->count = 1;
-	}
-	if (--port->count < 0) {
-		printk("rs_close: bad serial port count for ttys%d: %d\n",
-		       tty->index, port->count);
-		port->count = 0;
-	}
-	if (port->count) {
-		DBG_CNT("before DEC-2");
-		local_irq_restore(flags);
-		return;
-	}
-	port->flags |= ASYNC_CLOSING;
-	/*
-	 * Now we wait for the transmit buffer to clear; and we notify 
-	 * the line discipline to only process XON/XOFF characters.
-	 */
-	tty->closing = 1;
-	local_irq_restore(flags);
-	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, port->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
-- 
1.7.9.2


