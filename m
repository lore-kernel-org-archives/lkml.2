Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab2CEOFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:05:10 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34688 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2CENxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 40/68] TTY: amiserial/simserial, use flags from tty_port
Date: Mon,  5 Mar 2012 14:52:27 +0100
Message-Id: <1330955575-26641-41-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes flags' type to ulong which is appropriate for all the
set/clear_bits performed in the drivers..

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   33 +++++------
 drivers/tty/amiserial.c      |  129 +++++++++++++++++++++---------------------
 include/linux/serialP.h      |    1 -
 3 files changed, 83 insertions(+), 80 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index baa2b1e..c65c49d 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -448,7 +448,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 {
 	unsigned long	flags;
 
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->tport.flags & ASYNC_INITIALIZED))
 		return;
 
 #ifdef SIMSERIAL_DEBUG
@@ -468,7 +468,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 
 		set_bit(TTY_IO_ERROR, &tty->flags);
 
-		info->flags &= ~ASYNC_INITIALIZED;
+		info->tport.flags &= ~ASYNC_INITIALIZED;
 	}
 	local_irq_restore(flags);
 }
@@ -523,7 +523,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	info->tport.flags |= ASYNC_CLOSING;
 	local_irq_restore(flags);
 
 	/*
@@ -539,7 +539,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 			schedule_timeout_interruptible(info->tport.close_delay);
 		wake_up_interruptible(&info->tport.open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	info->tport.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->tport.close_wait);
 }
 
@@ -563,12 +563,12 @@ static void rs_hangup(struct tty_struct *tty)
 #endif
 
 	rs_flush_buffer(tty);
-	if (info->flags & ASYNC_CLOSING)
+	if (info->tport.flags & ASYNC_CLOSING)
 		return;
 	shutdown(tty, info);
 
 	info->tport.count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->tport.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tport.tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
 }
@@ -576,6 +576,7 @@ static void rs_hangup(struct tty_struct *tty)
 
 static int startup(struct tty_struct *tty, struct serial_state *state)
 {
+	struct tty_port *port = &state->tport;
 	unsigned long flags;
 	int	retval=0;
 	unsigned long page;
@@ -586,7 +587,7 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 
 	local_irq_save(flags);
 
-	if (state->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 		free_page(page);
 		goto errout;
 	}
@@ -630,16 +631,16 @@ static int startup(struct tty_struct *tty, struct serial_state *state)
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 		tty->alt_speed = 57600;
-	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 		tty->alt_speed = 115200;
-	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 		tty->alt_speed = 230400;
-	if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 		tty->alt_speed = 460800;
 
-	state->flags |= ASYNC_INITIALIZED;
+	port->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 
@@ -669,7 +670,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 #ifdef SIMSERIAL_DEBUG
 	printk("rs_open %s, count = %d\n", tty->name, info->tport.count);
 #endif
-	tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (info->tport.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	if (!tmp_buf) {
 		page = get_zeroed_page(GFP_KERNEL);
@@ -684,11 +685,11 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
-	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	if (tty_hung_up_p(filp) || (info->tport.flags & ASYNC_CLOSING)) {
+		if (info->tport.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->tport.close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->tport.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 8ad64a0..7d79826 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -45,7 +45,7 @@
 
 #if defined(MODULE) && defined(SERIAL_DEBUG_MCOUNT)
 #define DBG_CNT(s) printk("(%s): [%x] refc=%d, serc=%d, ttyc=%d -> %s\n", \
- tty->name, (info->flags), serial_driver->refcount,info->count,tty->count,s)
+ tty->name, (info->tport.flags), serial_driver->refcount,info->count,tty->count,s)
 #else
 #define DBG_CNT(s)
 #endif
@@ -296,7 +296,7 @@ static void receive_chars(struct serial_state *info)
 	    printk("handling break....");
 #endif
 	    flag = TTY_BREAK;
-	    if (info->flags & ASYNC_SAK)
+	    if (info->tport.flags & ASYNC_SAK)
 	      do_SAK(tty);
 	  } else if (status & UART_LSR_PE)
 	    flag = TTY_PARITY;
@@ -377,7 +377,7 @@ static void check_modem_status(struct serial_state *info)
 		if (dstatus & SER_DCD) {
 			icount->dcd++;
 #ifdef CONFIG_HARD_PPS
-			if ((info->flags & ASYNC_HARDPPS_CD) &&
+			if ((info->tport.flags & ASYNC_HARDPPS_CD) &&
 			    !(status & SER_DCD))
 				hardpps();
 #endif
@@ -387,7 +387,7 @@ static void check_modem_status(struct serial_state *info)
 		wake_up_interruptible(&info->tport.delta_msr_wait);
 	}
 
-	if ((info->flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
+	if ((info->tport.flags & ASYNC_CHECK_CD) && (dstatus & SER_DCD)) {
 #if (defined(SERIAL_DEBUG_OPEN) || defined(SERIAL_DEBUG_INTR))
 		printk("ttyS%d CD now %s...", info->line,
 		       (!(status & SER_DCD)) ? "on" : "off");
@@ -402,7 +402,7 @@ static void check_modem_status(struct serial_state *info)
 				tty_hangup(info->tport.tty);
 		}
 	}
-	if (info->flags & ASYNC_CTS_FLOW) {
+	if (info->tport.flags & ASYNC_CTS_FLOW) {
 		if (info->tport.tty->hw_stopped) {
 			if (!(status & SER_CTS)) {
 #if (defined(SERIAL_DEBUG_INTR) || defined(SERIAL_DEBUG_FLOW))
@@ -503,6 +503,7 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
 
 static int startup(struct tty_struct *tty, struct serial_state *info)
 {
+	struct tty_port *port = &info->tport;
 	unsigned long flags;
 	int	retval=0;
 	unsigned long page;
@@ -513,7 +514,7 @@ static int startup(struct tty_struct *tty, struct serial_state *info)
 
 	local_irq_save(flags);
 
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 		free_page(page);
 		goto errout;
 	}
@@ -560,13 +561,13 @@ static int startup(struct tty_struct *tty, struct serial_state *info)
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 		tty->alt_speed = 57600;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 		tty->alt_speed = 115200;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 		tty->alt_speed = 230400;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+	if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 		tty->alt_speed = 460800;
 
 	/*
@@ -574,7 +575,7 @@ static int startup(struct tty_struct *tty, struct serial_state *info)
 	 */
 	change_speed(tty, info, NULL);
 
-	info->flags |= ASYNC_INITIALIZED;
+	port->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 
@@ -592,7 +593,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 	unsigned long	flags;
 	struct serial_state *state;
 
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->tport.flags & ASYNC_INITIALIZED))
 		return;
 
 	state = info;
@@ -633,7 +634,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 
 	set_bit(TTY_IO_ERROR, &tty->flags);
 
-	info->flags &= ~ASYNC_INITIALIZED;
+	info->tport.flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 }
 
@@ -645,6 +646,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 static void change_speed(struct tty_struct *tty, struct serial_state *info,
 			 struct ktermios *old_termios)
 {
+	struct tty_port *port = &info->tport;
 	int	quot = 0, baud_base, baud;
 	unsigned cflag, cval = 0;
 	int	bits;
@@ -675,8 +677,7 @@ static void change_speed(struct tty_struct *tty, struct serial_state *info,
 	if (!baud)
 		baud = 9600;	/* B0 transition handled in rs_set_termios */
 	baud_base = info->baud_base;
-	if (baud == 38400 &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+	if (baud == 38400 && (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
 		quot = info->custom_divisor;
 	else {
 		if (baud == 134)
@@ -694,7 +695,7 @@ static void change_speed(struct tty_struct *tty, struct serial_state *info,
 		if (!baud)
 			baud = 9600;
 		if (baud == 38400 &&
-		    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+		    (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
 			quot = info->custom_divisor;
 		else {
 			if (baud == 134)
@@ -713,17 +714,17 @@ static void change_speed(struct tty_struct *tty, struct serial_state *info,
 
 	/* CTS flow control flag and modem status interrupts */
 	info->IER &= ~UART_IER_MSI;
-	if (info->flags & ASYNC_HARDPPS_CD)
+	if (port->flags & ASYNC_HARDPPS_CD)
 		info->IER |= UART_IER_MSI;
 	if (cflag & CRTSCTS) {
-		info->flags |= ASYNC_CTS_FLOW;
+		port->flags |= ASYNC_CTS_FLOW;
 		info->IER |= UART_IER_MSI;
 	} else
-		info->flags &= ~ASYNC_CTS_FLOW;
+		port->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->flags &= ~ASYNC_CHECK_CD;
+		port->flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->flags |= ASYNC_CHECK_CD;
+		port->flags |= ASYNC_CHECK_CD;
 		info->IER |= UART_IER_MSI;
 	}
 	/* TBD:
@@ -1019,7 +1020,7 @@ static int get_serial_info(struct serial_state *state,
 	tmp.line = state->line;
 	tmp.port = state->port;
 	tmp.irq = state->irq;
-	tmp.flags = state->flags;
+	tmp.flags = state->tport.flags;
 	tmp.xmit_fifo_size = state->xmit_fifo_size;
 	tmp.baud_base = state->baud_base;
 	tmp.close_delay = state->tport.close_delay;
@@ -1034,6 +1035,7 @@ static int get_serial_info(struct serial_state *state,
 static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 			   struct serial_struct __user * new_info)
 {
+	struct tty_port *port = &state->tport;
 	struct serial_struct new_serial;
 	bool change_spd;
 	int 			retval = 0;
@@ -1042,7 +1044,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 		return -EFAULT;
 
 	tty_lock();
-	change_spd = ((new_serial.flags ^ state->flags) & ASYNC_SPD_MASK) ||
+	change_spd = ((new_serial.flags ^ port->flags) & ASYNC_SPD_MASK) ||
 		new_serial.custom_divisor != state->custom_divisor;
 	if (new_serial.irq != state->irq || new_serial.port != state->port ||
 			new_serial.xmit_fifo_size != state->xmit_fifo_size) {
@@ -1052,12 +1054,12 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
   
 	if (!serial_isroot()) {
 		if ((new_serial.baud_base != state->baud_base) ||
-		    (new_serial.close_delay != state->tport.close_delay) ||
+		    (new_serial.close_delay != port->close_delay) ||
 		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (state->flags & ~ASYNC_USR_MASK)))
+		     (port->flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
-		state->flags = ((state->flags & ~ASYNC_USR_MASK) |
+		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		state->custom_divisor = new_serial.custom_divisor;
 		goto check_and_exit;
@@ -1074,23 +1076,23 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 	 */
 
 	state->baud_base = new_serial.baud_base;
-	state->flags = ((state->flags & ~ASYNC_FLAGS) |
+	port->flags = ((port->flags & ~ASYNC_FLAGS) |
 			(new_serial.flags & ASYNC_FLAGS));
 	state->custom_divisor = new_serial.custom_divisor;
-	state->tport.close_delay = new_serial.close_delay * HZ/100;
-	state->tport.closing_wait = new_serial.closing_wait * HZ/100;
-	tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	port->close_delay = new_serial.close_delay * HZ/100;
+	port->closing_wait = new_serial.closing_wait * HZ/100;
+	tty->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
-	if (state->flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 		if (change_spd) {
-			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+			if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 				tty->alt_speed = 57600;
-			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+			if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 				tty->alt_speed = 115200;
-			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+			if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 				tty->alt_speed = 230400;
-			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+			if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 				tty->alt_speed = 460800;
 			change_speed(tty, state, NULL);
 		}
@@ -1407,7 +1409,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	state->flags |= ASYNC_CLOSING;
+	state->tport.flags |= ASYNC_CLOSING;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
 	 * the line discipline to only process XON/XOFF characters.
@@ -1422,7 +1424,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * line status register.
 	 */
 	state->read_status_mask &= ~UART_LSR_DR;
-	if (state->flags & ASYNC_INITIALIZED) {
+	if (state->tport.flags & ASYNC_INITIALIZED) {
 	        /* disable receive interrupts */
 	        custom.intena = IF_RBF;
 		mb();
@@ -1449,7 +1451,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		}
 		wake_up_interruptible(&state->tport.open_wait);
 	}
-	state->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	state->tport.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&state->tport.close_wait);
 	local_irq_restore(flags);
 }
@@ -1530,7 +1532,7 @@ static void rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	shutdown(tty, info);
 	info->tport.count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->tport.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tport.tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
 }
@@ -1548,6 +1550,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #else
 	struct wait_queue wait = { current, NULL };
 #endif
+	struct tty_port *port = &info->tport;
 	int		retval;
 	int		do_clocal = 0, extra_count = 0;
 	unsigned long	flags;
@@ -1557,11 +1560,11 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->tport.close_wait);
+	    (port->flags & ASYNC_CLOSING)) {
+		if (port->flags & ASYNC_CLOSING)
+			interruptible_sleep_on(&port->close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((port->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1574,7 +1577,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ASYNC_NORMAL_ACTIVE;
+		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -1584,23 +1587,23 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->tport.count is dropped by one, so that
+	 * this loop, port->count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->tport.open_wait, &wait);
+	add_wait_queue(&port->open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttys%d, count = %d\n",
-	       info->line, info->tport.count);
+	       info->line, port->count);
 #endif
 	local_irq_save(flags);
 	if (!tty_hung_up_p(filp)) {
 		extra_count = 1;
-		info->tport.count--;
+		port->count--;
 	}
 	local_irq_restore(flags);
-	info->tport.blocked_open++;
+	port->blocked_open++;
 	while (1) {
 		local_irq_save(flags);
 		if (tty->termios->c_cflag & CBAUD)
@@ -1608,9 +1611,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		local_irq_restore(flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ASYNC_INITIALIZED)) {
+		    !(port->flags & ASYNC_INITIALIZED)) {
 #ifdef SERIAL_DO_RESTART
-			if (info->flags & ASYNC_HUP_NOTIFY)
+			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1619,7 +1622,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(info->flags & ASYNC_CLOSING) &&
+		if (!(port->flags & ASYNC_CLOSING) &&
 		    (do_clocal || (!(ciab.pra & SER_DCD)) ))
 			break;
 		if (signal_pending(current)) {
@@ -1628,24 +1631,24 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 #ifdef SERIAL_DEBUG_OPEN
 		printk("block_til_ready blocking: ttys%d, count = %d\n",
-		       info->line, info->tport.count);
+		       info->line, port->count);
 #endif
 		tty_unlock();
 		schedule();
 		tty_lock();
 	}
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&info->tport.open_wait, &wait);
+	remove_wait_queue(&port->open_wait, &wait);
 	if (extra_count)
-		info->tport.count++;
-	info->tport.blocked_open--;
+		port->count++;
+	port->blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttys%d, count = %d\n",
-	       info->line, info->tport.count);
+	       info->line, port->count);
 #endif
 	if (retval)
 		return retval;
-	info->flags |= ASYNC_NORMAL_ACTIVE;
+	port->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1670,17 +1673,17 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 #ifdef SERIAL_DEBUG_OPEN
 	printk("rs_open %s, count = %d\n", tty->name, info->count);
 #endif
-	tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (info->tport.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	/*
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	    (info->tport.flags & ASYNC_CLOSING)) {
+		if (info->tport.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->tport.close_wait);
 #ifdef SERIAL_DO_RESTART
-		return ((info->flags & ASYNC_HUP_NOTIFY) ?
+		return ((info->tport.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 #else
 		return -EAGAIN;
@@ -1723,7 +1726,7 @@ static inline void line_info(struct seq_file *m, struct serial_state *state)
 
 	local_irq_save(flags);
 	status = ciab.pra;
-	control = (state->flags & ASYNC_INITIALIZED) ? state->MCR : status;
+	control = (state->tport.flags & ASYNC_INITIALIZED) ? state->MCR : status;
 	local_irq_restore(flags);
 
 	stat_buf[0] = 0;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index a6612b9..e5e8442 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -30,7 +30,6 @@ struct serial_state {
 	int	baud_base;
 	unsigned long	port;
 	int	irq;
-	int	flags;
 	int	type;
 	int	line;
 	int	xmit_fifo_size;
-- 
1.7.9.2


