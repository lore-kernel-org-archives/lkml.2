Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1KIUgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:36:19 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37397 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab1KIUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 04/10] TTY: serial, use tty_port_close_start helper
Date: Wed,  9 Nov 2011 21:33:46 +0100
Message-Id: <1320870831-23778-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patches, the code is almost identical. There are
few differences in the helper code:
1) flush_buffer when flow_stopped
   * when a user doesn't care about the data, delete it anyways
2) ASYNCB_INITIALIZED test before wait_until_sent_from
   * obviously, there is nothing to wait for if the port is dead
3) drain_delay wait
   * we don't set drain_delay

So we can use the helper now. It indeed removes a bunch of duplicated
code.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   40 +-------------------------------------
 1 files changed, 1 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2b1ee7c..fcb5342 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1267,46 +1267,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	pr_debug("uart_close(%d) called\n", uport->line);
 
-	spin_lock_irqsave(&port->lock, flags);
-
-	if (tty_hung_up_p(filp)) {
-		spin_unlock_irqrestore(&port->lock, flags);
+	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	}
-
-	if ((tty->count == 1) && (port->count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  port->count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		printk(KERN_ERR "uart_close: bad serial port count; tty->count is 1, "
-		       "port->count is %d\n", port->count);
-		port->count = 1;
-	}
-	if (--port->count < 0) {
-		printk(KERN_ERR "uart_close: bad serial port count for %s: %d\n",
-		       tty->name, port->count);
-		port->count = 0;
-	}
-	if (port->count) {
-		spin_unlock_irqrestore(&port->lock, flags);
-		return;
-	}
-
-	/*
-	 * Now we wait for the transmit buffer to clear; and we notify
-	 * the line discipline to only process XON/XOFF characters by
-	 * setting tty->closing.
-	 */
-	set_bit(ASYNCB_CLOSING, &port->flags);
-	tty->closing = 1;
-	spin_unlock_irqrestore(&port->lock, flags);
-
-	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent_from_close(tty, port->closing_wait);
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
-- 
1.7.7


