Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422Ab0EDWev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:34:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482Ab0EDWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/13] tty: untangle locking of wait_until_sent
Date: Wed,  5 May 2010 00:33:49 +0200
Message-Id: <1273012433-6125-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LTNPSB5BLOMKq/r84ckulMacAkUhCZ8B+fR2
 yMQjWnkLTlwvrs9GzyUt6NgZZXhjNZdE5qBzBXlcI0z9hUONmK
 VPmef0Mot0lLpRvOFmckw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some wait_until_sent versions require the big
tty mutex, others don't and some callers of
wait_until_sent already hold it while other don't.
That leads to recursive use of the BTM in these
functions, which we're trying to get rid of.

This patch changes both the implementations and
the users of wait_until_sent so that the
device driver implementations are always called
with the lock held so they don't need to get
it themselves.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/amiserial.c      |    6 +++---
 drivers/char/generic_serial.c |    2 +-
 drivers/char/hvc_console.c    |    2 +-
 drivers/char/hvcs.c           |    2 +-
 drivers/char/ip2/ip2main.c    |   20 +++++++++++++++++---
 drivers/char/serial167.c      |    6 +++---
 drivers/char/specialix.c      |    2 +-
 drivers/char/tty_ioctl.c      |   36 ++++++++++++++++++++++++++++++++++--
 drivers/char/tty_port.c       |    2 +-
 drivers/isdn/i4l/isdn_tty.c   |    2 +-
 drivers/serial/68328serial.c  |    2 +-
 drivers/serial/68360serial.c  |    5 ++---
 drivers/serial/crisv10.c      |   12 +++++++-----
 drivers/serial/serial_core.c  |    5 +----
 include/linux/tty.h           |    1 +
 net/irda/ircomm/ircomm_tty.c  |    2 +-
 16 files changed, 76 insertions(+), 31 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 5bd382e..bfcf520 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1479,7 +1479,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 */
 	tty->closing = 1;
 	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+		tty_wait_until_sent_locked(tty, info->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
@@ -1537,7 +1537,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	orig_jiffies = jiffies;
 
-	tty_lock_nested(); /* tty_wait_until_sent is called from lots of places */
+	WARN_ON(!tty_locked());
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1578,12 +1578,12 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
 }
 
+
 /*
  * rs_hangup() --- called by tty_hangup() when a hangup is signaled.
  */
diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index 5954ee1..400830d 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -557,7 +557,7 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 	 */
 	tty->closing = 1;
 	/* if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-	   tty_wait_until_sent(tty, port->closing_wait); */
+	   tty_wait_until_sent_locked(tty, port->closing_wait); */
 
 	/*
 	 * At this point we stop accepting input.  To do this, we
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 35cca4c..79d45cc 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -385,7 +385,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 * there is no buffered data otherwise sleeps on a wait queue
 		 * waking periodically to check chars_in_buffer().
 		 */
-		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
+		tty_wait_until_sent_locked(tty, HVC_CLOSE_WAIT);
 	} else {
 		if (hp->count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index bedc6c1..4710438 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -1228,7 +1228,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 		irq = hvcsd->vdev->irq;
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
 
-		tty_wait_until_sent(tty, HVCS_CLOSE_WAIT);
+		tty_wait_until_sent_locked(tty, HVCS_CLOSE_WAIT);
 
 		/*
 		 * This line is important because it tells hvcs_open that this
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 911e1da..68642ee 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -193,6 +193,7 @@ static void do_input(struct work_struct *);
 static void do_status(struct work_struct *);
 
 static void ip2_wait_until_sent(PTTY,int);
+static void __ip2_wait_until_sent(PTTY,int);
 
 static void set_params (i2ChanStrPtr, struct ktermios *);
 static int get_serial_info(i2ChanStrPtr, struct serial_struct __user *);
@@ -1634,7 +1635,7 @@ ip2_close( PTTY tty, struct file *pFile )
 		 * This uses an timeout, after which the close
 		 * completes.
 		 */
-		ip2_wait_until_sent(tty, pCh->ClosingWaitTime );
+		__ip2_wait_until_sent(tty, pCh->ClosingWaitTime );
 	}
 	/*
 	 * At this point we stop accepting input. Here we flush the channel
@@ -1925,16 +1926,29 @@ ip2_flush_buffer( PTTY tty )
 /* indeterminate number of bytes buffered on the board.                       */
 /******************************************************************************/
 static void
-ip2_wait_until_sent ( PTTY tty, int timeout )
+__ip2_wait_until_sent ( PTTY tty, int timeout )
 {
 	int i = jiffies;
 	i2ChanStrPtr  pCh = tty->driver_data;
 
-	tty_wait_until_sent(tty, timeout );
+	tty_wait_until_sent_locked(tty, timeout );
 	if ( (i = timeout - (jiffies -i)) > 0)
 		i2DrainOutput( pCh, i );
 }
 
+static void
+ip2_wait_until_sent ( PTTY tty, int timeout )
+{
+	/*
+	 * BTM is held when coming from close,
+	 * but not from ->ioctl
+	 */
+	tty_lock();
+	__ip2_wait_until_sent(tty, timeout);
+	tty_unlock();
+}
+
+
 /******************************************************************************/
 /******************************************************************************/
 /* Device Input Section                                                       */
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 26a7089..ae495f1 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1571,7 +1571,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		ret_val = tty_check_change(tty);
 		if (ret_val)
 			break;
-		tty_wait_until_sent(tty, 0);
+		tty_wait_until_sent_locked(tty, 0);
 		if (!arg)
 			send_break(info, HZ / 4);	/* 1/4 second */
 		break;
@@ -1579,7 +1579,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		ret_val = tty_check_change(tty);
 		if (ret_val)
 			break;
-		tty_wait_until_sent(tty, 0);
+		tty_wait_until_sent_locked(tty, 0);
 		send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
 		break;
 
@@ -1670,7 +1670,7 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 		return;
 	info->flags |= ASYNC_CLOSING;
 	if (info->flags & ASYNC_INITIALIZED)
-		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
+		tty_wait_until_sent_locked(tty, 3000);	/* 30 seconds timeout */
 	shutdown(info);
 	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 234aefc..79ac31a 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1516,7 +1516,7 @@ static void sx_close(struct tty_struct *tty, struct file *filp)
 	spin_unlock_irqrestore(&port->lock, flags);
 	dprintk(SX_DEBUG_OPEN, "Closing\n");
 	if (port->port.closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, port->port.closing_wait);
+		tty_wait_until_sent_locked(tty, port->port.closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 6455434..0d402eb 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -146,7 +146,7 @@ EXPORT_SYMBOL(tty_unthrottle);
  *	Wait for characters pending in a tty driver to hit the wire, or
  *	for a timeout to occur (eg due to flow control)
  *
- *	Locking: none
+ *	Locking: must be called with BTM not held
  */
 
 void tty_wait_until_sent(struct tty_struct *tty, long timeout)
@@ -156,6 +156,38 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 
 	printk(KERN_DEBUG "%s wait until sent...\n", tty_name(tty, buf));
 #endif
+	WARN_ON_ONCE(tty_locked());
+	if (!timeout)
+		timeout = MAX_SCHEDULE_TIMEOUT;
+	if (wait_event_interruptible_timeout(tty->write_wait,
+			!tty_chars_in_buffer(tty), timeout) >= 0) {
+		if (tty->ops->wait_until_sent) {
+			tty_lock();
+			tty->ops->wait_until_sent(tty, timeout);
+			tty_unlock();
+		}
+	}
+}
+EXPORT_SYMBOL(tty_wait_until_sent);
+
+/**
+ *	tty_wait_until_sent	-	wait for I/O to finish
+ *	@tty: tty we are waiting for
+ *	@timeout: how long we will wait
+ *
+ *	Wait for characters pending in a tty driver to hit the wire, or
+ *	for a timeout to occur (eg due to flow control)
+ *
+ *	Locking: must be called with BTM held
+ */
+void tty_wait_until_sent_locked(struct tty_struct *tty, long timeout)
+{
+#ifdef TTY_DEBUG_WAIT_UNTIL_SENT
+	char buf[64];
+
+	printk(KERN_DEBUG "%s wait until sent...\n", tty_name(tty, buf));
+#endif
+	WARN_ON_ONCE(!tty_locked());
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
 	if (wait_event_interruptible_timeout_tty(tty->write_wait,
@@ -164,7 +196,7 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 			tty->ops->wait_until_sent(tty, timeout);
 	}
 }
-EXPORT_SYMBOL(tty_wait_until_sent);
+EXPORT_SYMBOL(tty_wait_until_sent_locked);
 
 
 /*
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 70e1349..7ee4999 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -348,7 +348,7 @@ int tty_port_close_start(struct tty_port *port,
 		tty_driver_flush_buffer(tty);
 	if (test_bit(ASYNCB_INITIALIZED, &port->flags) &&
 			port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, port->closing_wait);
+		tty_wait_until_sent_locked(tty, port->closing_wait);
 	if (port->drain_delay) {
 		unsigned int bps = tty_get_baud_rate(tty);
 		long timeout;
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index fd91de8..50102a8 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1695,7 +1695,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * line status register.
 	 */
 	if (info->flags & ISDN_ASYNC_INITIALIZED) {
-		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
+		tty_wait_until_sent_locked(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 78ed24b..f20d90c 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -1108,7 +1108,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 */
 	tty->closing = 1;
 	if (info->closing_wait != S_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+		tty_wait_until_sent_locked(tty, info->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index c17a595..a56c5a5 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1626,7 +1626,7 @@ static void rs_360_close(struct tty_struct *tty, struct file * filp)
 	 */
 	tty->closing = 1;
 	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+		tty_wait_until_sent_locked(tty, info->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
@@ -1705,7 +1705,7 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 	printk("jiff=%lu...", jiffies);
 #endif
 
-	tty_lock_nested(); /* always held already since we come from ->close */
+	WARN_ON(!tty_locked()); /* always held already since we come from ->close */
 	/* We go through the loop at least once because we can't tell
 	 * exactly when the last character exits the shifter.  There can
 	 * be at least two characters waiting to be sent after the buffers
@@ -1734,7 +1734,6 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 			bdp--;
 	} while (bdp->status & BD_SC_READY);
 	current->state = TASK_RUNNING;
-	tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index e6a1cb7..9047384 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3254,7 +3254,9 @@ rs_write(struct tty_struct *tty,
 		 */
 
 		/* Sleep until all sent */
-		tty_wait_until_sent(tty, 0);
+		tty_lock_nested();
+		tty_wait_until_sent_locked(tty, 0);
+		tty_unlock();
 #ifdef CONFIG_ETRAX_FAST_TIMER
 		/* Now sleep a little more so that shift register is empty */
 		schedule_usleep(info->char_time_usec * 2);
@@ -3825,7 +3827,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	 */
 	tty->closing = 1;
 	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+		tty_wait_until_sent_locked(tty, info->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the serial receiver and the DMA receive interrupt.
@@ -3844,7 +3846,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		 * has completely drained; this is especially
 		 * important as we have a transmit FIFO!
 		 */
-		rs_wait_until_sent(tty, HZ);
+		__rs_wait_until_sent(tty, HZ);
 	}
 #endif
 
@@ -3920,11 +3922,12 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 		(curr_time - info->last_tx_active) * (1000000/HZ) +
 		curr_time_usec - info->last_tx_active_usec;
 
+	WARN_ON_ONCE(!tty_locked());
+
 	/*
 	 * Check R_DMA_CHx_STATUS bit 0-6=number of available bytes in FIFO
 	 * R_DMA_CHx_HWSW bit 31-16=nbr of bytes left in DMA buffer (0=64k)
 	 */
-	tty_lock_nested(); /* locked already when coming from close */
 	orig_jiffies = jiffies;
 	while (info->xmit.head != info->xmit.tail || /* More in send queue */
 	       (*info->ostatusadr & 0x007f) ||  /* more in FIFO */
@@ -3941,7 +3944,6 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			curr_time_usec - info->last_tx_active_usec;
 	}
 	set_current_state(TASK_RUNNING);
-	tty_unlock();
 }
 
 /*
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index a9d51eb..4fb1d31 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1316,7 +1316,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty->closing = 1;
 
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
+		tty_wait_until_sent_locked(tty, msecs_to_jiffies(port->closing_wait));
 
 	/*
 	 * At this point, we stop accepting input.  To do this, we
@@ -1369,8 +1369,6 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 	if (port->type == PORT_UNKNOWN || port->fifosize == 0)
 		return;
 
-	tty_lock_nested(); /* already locked when coming from close */
-
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1416,7 +1414,6 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	set_current_state(TASK_RUNNING); /* might not be needed */
-	tty_unlock();
 }
 
 /*
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1659ba8..8ddd952 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -388,6 +388,7 @@ extern void tty_kref_put(struct tty_struct *tty);
 extern int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 			      const char *routine);
 extern char *tty_name(struct tty_struct *tty, char *buf);
+extern void tty_wait_until_sent_locked(struct tty_struct *tty, long timeout);
 extern void tty_wait_until_sent(struct tty_struct *tty, long timeout);
 extern int tty_check_change(struct tty_struct *tty);
 extern void stop_tty(struct tty_struct *tty);
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index faa82ca..a176b9c 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -550,7 +550,7 @@ static void ircomm_tty_close(struct tty_struct *tty, struct file *filp)
 	 */
 	tty->closing = 1;
 	if (self->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, self->closing_wait);
+		tty_wait_until_sent_locked(tty, self->closing_wait);
 
 	ircomm_tty_shutdown(self);
 
-- 
1.7.0.4

