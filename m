Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631Ab0HEWin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:38:43 -0400
Received: from kroah.org ([198.145.64.141]:37698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760842Ab0HEWYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/67] tty: untangle locking of wait_until_sent
Date: Thu,  5 Aug 2010 15:23:08 -0700
Message-Id: <1281047014-23429-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some wait_until_sent versions require the big
tty mutex, others don't and some callers of
wait_until_sent already hold it while other don't.
That leads to recursive use of the BTM in these
functions, which we're trying to get rid of.

This turns all cleans up the locking there so
that the driver's wait_until_sent function
never takes the BTM itself if it is already
called with that lock held.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/amiserial.c     |   11 +++++++++--
 drivers/serial/68360serial.c |    2 --
 drivers/serial/crisv10.c     |    2 --
 drivers/serial/serial_core.c |   31 ++++++++++++++++++++++---------
 4 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 1b21a7a..8228e61 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1528,6 +1528,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct async_struct * info = tty->driver_data;
 	unsigned long orig_jiffies, char_time;
+	int tty_was_locked = tty_locked();
 	int lsr;
 
 	if (serial_paranoia_check(info, tty->name, "rs_wait_until_sent"))
@@ -1538,7 +1539,12 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	orig_jiffies = jiffies;
 
-	tty_lock_nested(); /* tty_wait_until_sent is called from lots of places */
+	/*
+	 * tty_wait_until_sent is called from lots of places,
+	 * with or without the BTM.
+	 */
+	if (!tty_was_locked)
+		tty_lock();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1579,7 +1585,8 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	tty_unlock();
+	if (!tty_was_locked)
+		tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index 16f5f2f..edcf1cc 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1705,7 +1705,6 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 	printk("jiff=%lu...", jiffies);
 #endif
 
-	tty_lock_nested(); /* always held already since we come from ->close */
 	/* We go through the loop at least once because we can't tell
 	 * exactly when the last character exits the shifter.  There can
 	 * be at least two characters waiting to be sent after the buffers
@@ -1734,7 +1733,6 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 			bdp--;
 	} while (bdp->status & BD_SC_READY);
 	current->state = TASK_RUNNING;
-	tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index e6a1cb7..0825d4a 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3924,7 +3924,6 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Check R_DMA_CHx_STATUS bit 0-6=number of available bytes in FIFO
 	 * R_DMA_CHx_HWSW bit 31-16=nbr of bytes left in DMA buffer (0=64k)
 	 */
-	tty_lock_nested(); /* locked already when coming from close */
 	orig_jiffies = jiffies;
 	while (info->xmit.head != info->xmit.tail || /* More in send queue */
 	       (*info->ostatusadr & 0x007f) ||  /* more in FIFO */
@@ -3941,7 +3940,6 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			curr_time_usec - info->last_tx_active_usec;
 	}
 	set_current_state(TASK_RUNNING);
-	tty_unlock();
 }
 
 /*
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 851d7c2..cd85112 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -60,7 +60,7 @@ static struct lock_class_key port_lock_key;
 
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
-static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
+static void __uart_wait_until_sent(struct uart_port *port, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
 /*
@@ -1322,8 +1322,16 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
+	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
+		/*
+		 * hack: open-coded tty_wait_until_sent to avoid
+		 * recursive tty_lock
+		 */
+		long timeout = msecs_to_jiffies(port->closing_wait);
+		if (wait_event_interruptible_timeout(tty->write_wait,
+				!tty_chars_in_buffer(tty), timeout) >= 0)
+			__uart_wait_until_sent(uport, timeout);
+	}
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1339,7 +1347,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
-		uart_wait_until_sent(tty, uport->timeout);
+		__uart_wait_until_sent(uport, uport->timeout);
 	}
 
 	uart_shutdown(tty, state);
@@ -1373,17 +1381,13 @@ done:
 	mutex_unlock(&port->mutex);
 }
 
-static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
+static void __uart_wait_until_sent(struct uart_port *port, int timeout)
 {
-	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->uart_port;
 	unsigned long char_time, expire;
 
 	if (port->type == PORT_UNKNOWN || port->fifosize == 0)
 		return;
 
-	tty_lock_nested(); /* already locked when coming from close */
-
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1429,6 +1433,15 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	set_current_state(TASK_RUNNING); /* might not be needed */
+}
+
+static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
+{
+	struct uart_state *state = tty->driver_data;
+	struct uart_port *port = state->uart_port;
+
+	tty_lock();
+	__uart_wait_until_sent(port, timeout);
 	tty_unlock();
 }
 
-- 
1.7.2

