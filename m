Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab1KIUeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:34:16 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37401 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1KIUd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:57 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 03/10] TTY: serial, switch closing_wait and close_delay to jiffies
Date: Wed,  9 Nov 2011 21:33:45 +0100
Message-Id: <1320870831-23778-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the tty_port helpers think closing_wait and close_delay are in
jiffies and we want to use the helpers (next patches), we have to
switch the closing_wait and close_delay from ms to jiffies now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/serial/serial_core.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 8d825a3..2b1ee7c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -659,10 +659,10 @@ static int uart_get_info(struct uart_state *state,
 	tmp.flags	    = uport->flags;
 	tmp.xmit_fifo_size  = uport->fifosize;
 	tmp.baud_base	    = uport->uartclk / 16;
-	tmp.close_delay	    = port->close_delay / 10;
+	tmp.close_delay	    = jiffies_to_msecs(port->close_delay) / 10;
 	tmp.closing_wait    = port->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-				port->closing_wait / 10;
+				jiffies_to_msecs(port->closing_wait) / 10;
 	tmp.custom_divisor  = uport->custom_divisor;
 	tmp.hub6	    = uport->hub6;
 	tmp.io_type         = uport->iotype;
@@ -696,9 +696,10 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 		new_port += (unsigned long) new_serial.port_high << HIGH_BITS_OFFSET;
 
 	new_serial.irq = irq_canonicalize(new_serial.irq);
-	close_delay = new_serial.close_delay * 10;
+	close_delay = msecs_to_jiffies(new_serial.close_delay * 10);
 	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(new_serial.closing_wait * 10);
 
 	/*
 	 * This semaphore protects port->count.  It is also
@@ -1305,8 +1306,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent_from_close(tty,
-				msecs_to_jiffies(port->closing_wait));
+		tty_wait_until_sent_from_close(tty, port->closing_wait);
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1338,7 +1338,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	if (port->blocked_open) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		if (port->close_delay)
-			msleep_interruptible(port->close_delay);
+			msleep_interruptible(
+					jiffies_to_msecs(port->close_delay));
 		spin_lock_irqsave(&port->lock, flags);
 	} else if (!uart_console(uport)) {
 		spin_unlock_irqrestore(&port->lock, flags);
@@ -2276,8 +2277,8 @@ int uart_register_driver(struct uart_driver *drv)
 
 		tty_port_init(port);
 		port->ops = &uart_port_ops;
-		port->close_delay     = 500;	/* .5 seconds */
-		port->closing_wait    = 30000;	/* 30 seconds */
+		port->close_delay     = HZ / 2;	/* .5 seconds */
+		port->closing_wait    = 30 * HZ;/* 30 seconds */
 	}
 
 	retval = tty_register_driver(normal);
-- 
1.7.7


