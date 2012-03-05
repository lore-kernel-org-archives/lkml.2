Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047Ab2CEN70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:59:26 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34813 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964835Ab2CENxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:24 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 56/68] TTY: amiserial, define local tty_port pointer
Date: Mon,  5 Mar 2012 14:52:43 +0100
Message-Id: <1330955575-26641-57-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use it to make the code more readable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   81 ++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 7d79826..a9f5da6 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -361,6 +361,7 @@ static void transmit_chars(struct serial_state *info)
 
 static void check_modem_status(struct serial_state *info)
 {
+	struct tty_port *port = &info->tport;
 	unsigned char status = ciab.pra & (SER_DCD | SER_CTS | SER_DSR);
 	unsigned char dstatus;
 	struct	async_icount *icount;
@@ -377,45 +378,45 @@ static void check_modem_status(struct serial_state *info)
 		if (dstatus & SER_DCD) {
 			icount->dcd++;
 #ifdef CONFIG_HARD_PPS
-			if ((info->tport.flags & ASYNC_HARDPPS_CD) &&
+			if ((port->flags & ASYNC_HARDPPS_CD) &&
 			    !(status & SER_DCD))
 				hardpps();
 #endif
 		}
 		if (dstatus & SER_CTS)
 			icount->cts++;
-		wake_up_interruptible(&info->tport.delta_msr_wait);
+		wake_up_interruptible(&port->delta_msr_wait);
 	}
 
-	if ((info->tport.flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
+	if ((port->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
 #if (defined(SERIAL_DEBUG_OPEN) || defined(SERIAL_DEBUG_INTR))
 		printk("ttyS%d CD now %s...", info->line,
 		       (!(status & SER_DCD)) ? "on" : "off");
 #endif
 		if (!(status & SER_DCD))
-			wake_up_interruptible(&info->tport.open_wait);
+			wake_up_interruptible(&port->open_wait);
 		else {
 #ifdef SERIAL_DEBUG_OPEN
 			printk("doing serial hangup...");
 #endif
-			if (info->tport.tty)
-				tty_hangup(info->tport.tty);
+			if (port->tty)
+				tty_hangup(port->tty);
 		}
 	}
-	if (info->tport.flags & ASYNC_CTS_FLOW) {
-		if (info->tport.tty->hw_stopped) {
+	if (port->flags & ASYNC_CTS_FLOW) {
+		if (port->tty->hw_stopped) {
 			if (!(status & SER_CTS)) {
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
 				printk("CTS tx start...");
 #endif
-				info->tport.tty->hw_stopped = 0;
+				port->tty->hw_stopped = 0;
 				info->IER |= UART_IER_THRI;
 				custom.intena = IF_SETCLR | IF_TBE;
 				mb();
 				/* set a pending Tx Interrupt, transmitter should restart now */
 				custom.intreq = IF_SETCLR | IF_TBE;
 				mb();
-				tty_wakeup(info->tport.tty);
+				tty_wakeup(port->tty);
 				return;
 			}
 		} else {
@@ -423,7 +424,7 @@ static void check_modem_status(struct serial_state *info)
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
 				printk("CTS tx stop...");
 #endif
-				info->tport.tty->hw_stopped = 1;
+				port->tty->hw_stopped = 1;
 				info->IER &= ~UART_IER_THRI;
 				/* disable Tx interrupt and remove any pending interrupts */
 				custom.intena = IF_TBE;
@@ -1371,6 +1372,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *state = tty->driver_data;
+	struct tty_port *port = &state->tport;
 	unsigned long flags;
 
 	if (!state || serial_paranoia_check(state, tty->name, "rs_close"))
@@ -1385,38 +1387,38 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttys%d, count = %d\n", state->line, state->tport.count);
+	printk("rs_close ttys%d, count = %d\n", state->line, port->count);
 #endif
-	if ((tty->count == 1) && (state->tport.count != 1)) {
+	if ((tty->count == 1) && (port->count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  state->tport.count should always
+		 * structure will be freed.  port->count should always
 		 * be one in these conditions.  If it's greater than
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
 		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "state->tport.count is %d\n", state->tport.count);
-		state->tport.count = 1;
+		       "port->count is %d\n", state->tport.count);
+		port->count = 1;
 	}
-	if (--state->tport.count < 0) {
+	if (--port->count < 0) {
 		printk("rs_close: bad serial port count for ttys%d: %d\n",
-		       state->line, state->tport.count);
-		state->tport.count = 0;
+		       state->line, port->count);
+		port->count = 0;
 	}
-	if (state->tport.count) {
+	if (port->count) {
 		DBG_CNT("before DEC-2");
 		local_irq_restore(flags);
 		return;
 	}
-	state->tport.flags |= ASYNC_CLOSING;
+	port->flags |= ASYNC_CLOSING;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	if (state->tport.closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, state->tport.closing_wait);
+	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent(tty, port->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
@@ -1424,7 +1426,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * line status register.
 	 */
 	state->read_status_mask &= ~UART_LSR_DR;
-	if (state->tport.flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 	        /* disable receive interrupts */
 	        custom.intena = IF_RBF;
 		mb();
@@ -1444,15 +1446,15 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	state->tport.tty = NULL;
-	if (state->tport.blocked_open) {
-		if (state->tport.close_delay) {
-			msleep_interruptible(jiffies_to_msecs(state->tport.close_delay));
+	port->tty = NULL;
+	if (port->blocked_open) {
+		if (port->close_delay) {
+			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 		}
-		wake_up_interruptible(&state->tport.open_wait);
+		wake_up_interruptible(&port->open_wait);
 	}
-	state->tport.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&state->tport.close_wait);
+	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	wake_up_interruptible(&port->close_wait);
 	local_irq_restore(flags);
 }
 
@@ -1661,29 +1663,30 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 static int rs_open(struct tty_struct *tty, struct file * filp)
 {
 	struct serial_state *info = rs_table + tty->index;
+	struct tty_port *port = &info->tport;
 	int retval;
 
-	info->tport.count++;
-	info->tport.tty = tty;
+	port->count++;
+	port->tty = tty;
 	tty->driver_data = info;
-	tty->port = &info->tport;
+	tty->port = port;
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
 #ifdef SERIAL_DEBUG_OPEN
 	printk("rs_open %s, count = %d\n", tty->name, info->count);
 #endif
-	tty->low_latency = (info->tport.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->tport.flags & ASYNC_CLOSING)) {
-		if (info->tport.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->tport.close_wait);
+	    (port->flags & ASYNC_CLOSING)) {
+		if (port->flags & ASYNC_CLOSING)
+			interruptible_sleep_on(&port->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->tport.flags & ASYNC_HUP_NOTIFY) ?
+		return ((port->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
-- 
1.7.9.2


