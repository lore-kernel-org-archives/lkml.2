Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab2CENxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:39 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34878 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab2CENxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 27/68] TTY: amiserial, use only one copy of async flags
Date: Mon,  5 Mar 2012 14:52:14 +0100
Message-Id: <1330955575-26641-28-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huh, why would one want to store two copies of them? Get rid of the
one from async_struct. That structure is going away as a whole soon.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   82 ++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index d5fac86..8556ca0 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -45,7 +45,7 @@
 
 #if defined(MODULE) && defined(SERIAL_DEBUG_MCOUNT)
 #define DBG_CNT(s) printk("(%s): [%x] refc=%d, serc=%d, ttyc=%d -> %s\n", \
- tty->name, (info->flags), serial_driver->refcount,info->count,tty->count,s)
+ tty->name, (info->state->flags), serial_driver->refcount,info->count,tty->count,s)
 #else
 #define DBG_CNT(s)
 #endif
@@ -297,7 +297,7 @@ static void receive_chars(struct async_struct *info)
 	    printk("handling break....");
 #endif
 	    flag = TTY_BREAK;
-	    if (info->flags & ASYNC_SAK)
+	    if (info->state->flags & ASYNC_SAK)
 	      do_SAK(tty);
 	  } else if (status & UART_LSR_PE)
 	    flag = TTY_PARITY;
@@ -378,7 +378,7 @@ static void check_modem_status(struct async_struct *info)
 		if (dstatus & SER_DCD) {
 			icount->dcd++;
 #ifdef CONFIG_HARD_PPS
-			if ((info->flags & ASYNC_HARDPPS_CD) &&
+			if ((info->state->flags & ASYNC_HARDPPS_CD) &&
 			    !(status & SER_DCD))
 				hardpps();
 #endif
@@ -388,7 +388,7 @@ static void check_modem_status(struct async_struct *info)
 		wake_up_interruptible(&info->delta_msr_wait);
 	}
 
-	if ((info->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
+	if ((info->state->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
 #if (defined(SERIAL_DEBUG_OPEN) || defined(SERIAL_DEBUG_INTR))
 		printk("ttyS%d CD now %s...", info->line,
 		       (!(status & SER_DCD)) ? "on" : "off");
@@ -403,7 +403,7 @@ static void check_modem_status(struct async_struct *info)
 				tty_hangup(info->tty);
 		}
 	}
-	if (info->flags & ASYNC_CTS_FLOW) {
+	if (info->state->flags & ASYNC_CTS_FLOW) {
 		if (info->tty->hw_stopped) {
 			if (!(status & SER_CTS)) {
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
@@ -516,7 +516,7 @@ static int startup(struct async_struct * info)
 
 	local_irq_save(flags);
 
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (info->state->flags & ASYNC_INITIALIZED) {
 		free_page(page);
 		goto errout;
 	}
@@ -569,13 +569,13 @@ static int startup(struct async_struct * info)
 	 * Set up the tty->alt_speed kludge
 	 */
 	if (info->tty) {
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			info->tty->alt_speed = 57600;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			info->tty->alt_speed = 115200;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			info->tty->alt_speed = 230400;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		if ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			info->tty->alt_speed = 460800;
 	}
 
@@ -584,7 +584,7 @@ static int startup(struct async_struct * info)
 	 */
 	change_speed(info, NULL);
 
-	info->flags |= ASYNC_INITIALIZED;
+	info->state->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 
@@ -602,7 +602,7 @@ static void shutdown(struct async_struct * info)
 	unsigned long	flags;
 	struct serial_state *state;
 
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->state->flags & ASYNC_INITIALIZED))
 		return;
 
 	state = info->state;
@@ -646,7 +646,7 @@ static void shutdown(struct async_struct * info)
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-	info->flags &= ~ASYNC_INITIALIZED;
+	info->state->flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 }
 
@@ -691,7 +691,7 @@ static void change_speed(struct async_struct *info,
 		baud = 9600;	/* B0 transition handled in rs_set_termios */
 	baud_base = info->state->baud_base;
 	if (baud == 38400 &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+	    ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
 		quot = info->state->custom_divisor;
 	else {
 		if (baud == 134)
@@ -709,7 +709,7 @@ static void change_speed(struct async_struct *info,
 		if (!baud)
 			baud = 9600;
 		if (baud == 38400 &&
-		    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+		    ((info->state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
 			quot = info->state->custom_divisor;
 		else {
 			if (baud == 134)
@@ -728,17 +728,17 @@ static void change_speed(struct async_struct *info,
 
 	/* CTS flow control flag and modem status interrupts */
 	info->IER &= ~UART_IER_MSI;
-	if (info->flags & ASYNC_HARDPPS_CD)
+	if (info->state->flags & ASYNC_HARDPPS_CD)
 		info->IER |= UART_IER_MSI;
 	if (cflag & CRTSCTS) {
-		info->flags |= ASYNC_CTS_FLOW;
+		info->state->flags |= ASYNC_CTS_FLOW;
 		info->IER |= UART_IER_MSI;
 	} else
-		info->flags &= ~ASYNC_CTS_FLOW;
+		info->state->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->flags &= ~ASYNC_CHECK_CD;
+		info->state->flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->flags |= ASYNC_CHECK_CD;
+		info->state->flags |= ASYNC_CHECK_CD;
 		info->IER |= UART_IER_MSI;
 	}
 	/* TBD:
@@ -1080,8 +1080,6 @@ static int set_serial_info(struct async_struct * info,
 			return -EPERM;
 		state->flags = ((state->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
-		info->flags = ((info->flags & ~ASYNC_USR_MASK) |
-			       (new_serial.flags & ASYNC_USR_MASK));
 		state->custom_divisor = new_serial.custom_divisor;
 		goto check_and_exit;
 	}
@@ -1099,15 +1097,13 @@ static int set_serial_info(struct async_struct * info,
 	state->baud_base = new_serial.baud_base;
 	state->flags = ((state->flags & ~ASYNC_FLAGS) |
 			(new_serial.flags & ASYNC_FLAGS));
-	info->flags = ((state->flags & ~ASYNC_INTERNAL_FLAGS) |
-		       (info->flags & ASYNC_INTERNAL_FLAGS));
 	state->custom_divisor = new_serial.custom_divisor;
 	state->close_delay = new_serial.close_delay * HZ/100;
 	state->closing_wait = new_serial.closing_wait * HZ/100;
-	info->tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (state->flags & ASYNC_INITIALIZED) {
 		if (((old_state.flags & ASYNC_SPD_MASK) !=
 		     (state->flags & ASYNC_SPD_MASK)) ||
 		    (old_state.custom_divisor != state->custom_divisor)) {
@@ -1437,7 +1433,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	state->flags |= ASYNC_CLOSING;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
 	 * the line discipline to only process XON/XOFF characters.
@@ -1452,7 +1448,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * line status register.
 	 */
 	info->read_status_mask &= ~UART_LSR_DR;
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (state->flags & ASYNC_INITIALIZED) {
 	        /* disable receive interrupts */
 	        custom.intena = IF_RBF;
 		mb();
@@ -1479,7 +1475,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		}
 		wake_up_interruptible(&info->open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 	local_irq_restore(flags);
 }
@@ -1563,7 +1559,7 @@ static void rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	shutdown(info);
 	state->count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	state->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -1591,11 +1587,11 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	    (state->flags & ASYNC_CLOSING)) {
+		if (state->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((state->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1608,7 +1604,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ASYNC_NORMAL_ACTIVE;
+		state->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -1642,9 +1638,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		local_irq_restore(flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ASYNC_INITIALIZED)) {
+		    !(state->flags & ASYNC_INITIALIZED)) {
 #ifdef SERIAL_DO_RESTART
-			if (info->flags & ASYNC_HUP_NOTIFY)
+			if (state->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1653,7 +1649,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(info->flags & ASYNC_CLOSING) &&
+		if (!(state->flags & ASYNC_CLOSING) &&
 		    (do_clocal || (!(ciab.pra & SER_DCD)) ))
 			break;
 		if (signal_pending(current)) {
@@ -1679,7 +1675,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 	if (retval)
 		return retval;
-	info->flags |= ASYNC_NORMAL_ACTIVE;
+	state->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1705,7 +1701,6 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 	init_waitqueue_head(&info->delta_msr_wait);
 #endif
 	info->port = sstate->port;
-	info->flags = sstate->flags;
 	info->xmit_fifo_size = sstate->xmit_fifo_size;
 	info->line = line;
 	info->state = sstate;
@@ -1741,17 +1736,17 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 #ifdef SERIAL_DEBUG_OPEN
 	printk("rs_open %s, count = %d\n", tty->name, info->state->count);
 #endif
-	info->tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	info->tty->low_latency = (info->state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	    (info->state->flags & ASYNC_CLOSING)) {
+		if (info->state->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->state->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1799,7 +1794,6 @@ static inline void line_info(struct seq_file *m, struct serial_state *state)
 	if (!info) {
 		info = &scr_info;	/* This is just for serial_{in,out} */
 
-		info->flags = state->flags;
 		info->quot = 0;
 		info->tty = NULL;
 	}
-- 
1.7.9.2


