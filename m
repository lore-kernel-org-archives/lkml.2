Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1E0MS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:18:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:34937 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1E0MS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:18:27 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 08:18:26 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: Andreas Bombe <aeb@debian.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com,
        arnd@arndb.de, jirislaby@gmail.com
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Date: Fri, 27 May 2011 14:11:45 +0200
Message-Id: <1306498305-5486-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <20110527004104.GB4369@amos.fritz.box>
References: <20110527004104.GB4369@amos.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > At any point you can show the code sleeps you can drop and retake the
> > tty mutex either side of it, so you should be able to do that in the
> > close timeout case. You may need to think about the order of locking with
> > the port mutex but I suspect you can drop and retake both there.
>
> #basically emulating the BKL semantics? Sounds more doable. I'll look
> into it.

Actually the best would be to get rid of tty_lock completely. Here I
have a patch removing tty_lock from wait_until_sent path. I've been
using a kernel with the patch applied for about month without any
problems. But I have only 8250-based serial.

Why I ahven't sent it is that I need to re-investigate users whether
this will hurt. (I already did, but stopped in the middle to do other
things.) Mostly wait_until_sent hooks in uart drivers do simple reads
from device.

The patch is only the first step. When this patch is OK and works, we
can move the whole uart thing to use tty_port_open/close helpers.

Does the patch below fix the issue?

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
1.7.4.2


