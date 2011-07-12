Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1GLUn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:43:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:57735 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab1GLUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:43:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Andreas Bombe <aeb@debian.org>
Subject: [PATCH 1/3] TTY: serial, remove BTM from wait_until_sent
Date: Tue, 12 Jul 2011 22:43:18 +0200
Message-Id: <1310503400-28447-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the BKL removal process, the BKL was switched to tty_lock
(BTM). Now we should start pruning the BTM further. Let's start with
wait_until_sent of the serial layer. This will allow us to switch to
the tty port helpers and thus clean it up much.

In wait_until_sent there are some uport members accessed, but neither
of them is protected by BTM at the location they are set ('=>' means
function call):
* uport->fifosize (set in tty_ioctl => uart_ioctl => uart_set_info)
* uport->type (set in add_one_port prior to tty_register_device)
* uport->timeout (set usually in tty_ioctl => tty_mode_ioctl =>
  tty_set_termios => uart_set_termios => uart_change_speed =>
  uport->ops->set_termios => uart_update_timeout)
* call to uport->ops->tx_empty()

If the tx_empty hook needs some lock to protect accesses to registers,
it should take &uport->lock spinlock like 8250 does. Otherwise there
still might be races e.g. with ISRs.

This should also fix the issue Andreas is seeing (BTM in comparison to
BKL doesn't have any hidden functionality like unlocking during
sleeping).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
References: https://lkml.org/lkml/2011/5/25/562
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Bombe <aeb@debian.org>
---
 drivers/tty/serial/serial_core.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index db7912c..2cbf1bd 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -57,7 +57,7 @@ static struct lock_class_key port_lock_key;
 
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
-static void __uart_wait_until_sent(struct uart_port *port, int timeout);
+static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
 /*
@@ -1304,16 +1304,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
-		/*
-		 * hack: open-coded tty_wait_until_sent to avoid
-		 * recursive tty_lock
-		 */
-		long timeout = msecs_to_jiffies(port->closing_wait);
-		if (wait_event_interruptible_timeout(tty->write_wait,
-				!tty_chars_in_buffer(tty), timeout) >= 0)
-			__uart_wait_until_sent(uport, timeout);
-	}
+	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1329,7 +1321,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
-		__uart_wait_until_sent(uport, uport->timeout);
+		uart_wait_until_sent(tty, uport->timeout);
 	}
 
 	uart_shutdown(tty, state);
@@ -1363,8 +1355,10 @@ done:
 	mutex_unlock(&port->mutex);
 }
 
-static void __uart_wait_until_sent(struct uart_port *port, int timeout)
+static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 {
+	struct uart_state *state = tty->driver_data;
+	struct uart_port *port = state->uart_port;
 	unsigned long char_time, expire;
 
 	if (port->type == PORT_UNKNOWN || port->fifosize == 0)
@@ -1416,16 +1410,6 @@ static void __uart_wait_until_sent(struct uart_port *port, int timeout)
 	}
 }
 
-static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
-{
-	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->uart_port;
-
-	tty_lock();
-	__uart_wait_until_sent(port, timeout);
-	tty_unlock();
-}
-
 /*
  * This is called with the BKL held in
  *  linux/drivers/char/tty_io.c:do_tty_hangup()
-- 
1.7.6


