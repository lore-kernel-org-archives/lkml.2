Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab2CENxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:23 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34734 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964773Ab2CENxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 35/68] TTY: amiserial, pass tty down to functions
Date: Mon,  5 Mar 2012 14:52:22 +0100
Message-Id: <1330955575-26641-36-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids pain with tty refcounting and touching tty_port in the
future. It allows us to remove some info->tty tests because the tty
passed down to them can never be NULL.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   91 ++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 49 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 165cd79..5b87744 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -102,7 +102,8 @@ static struct tty_driver *serial_driver;
 
 static unsigned char current_ctl_bits;
 
-static void change_speed(struct serial_state *info, struct ktermios *old);
+static void change_speed(struct tty_struct *tty, struct serial_state *info,
+		struct ktermios *old);
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
 
 
@@ -500,7 +501,7 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
  * ---------------------------------------------------------------
  */
 
-static int startup(struct serial_state *info)
+static int startup(struct tty_struct *tty, struct serial_state *info)
 {
 	unsigned long flags;
 	int	retval=0;
@@ -534,9 +535,7 @@ static int startup(struct serial_state *info)
 	retval = request_irq(IRQ_AMIGA_VERTB, ser_vbl_int, 0, "serial status", info);
 	if (retval) {
 	  if (serial_isroot()) {
-	    if (info->tty)
-	      set_bit(TTY_IO_ERROR,
-		      &info->tty->flags);
+	      set_bit(TTY_IO_ERROR, &tty->flags);
 	    retval = 0;
 	  }
 	  goto errout;
@@ -551,32 +550,29 @@ static int startup(struct serial_state *info)
 	current_ctl_bits = ciab.pra & (SER_DCD | SER_CTS | SER_DSR);
 
 	info->MCR = 0;
-	if (info->tty->termios->c_cflag & CBAUD)
+	if (C_BAUD(tty))
 	  info->MCR = SER_DTR | SER_RTS;
 	rtsdtr_ctrl(info->MCR);
 
-	if (info->tty)
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 	info->xmit.head = info->xmit.tail = 0;
 
 	/*
 	 * Set up the tty->alt_speed kludge
 	 */
-	if (info->tty) {
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			info->tty->alt_speed = 57600;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			info->tty->alt_speed = 115200;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-			info->tty->alt_speed = 230400;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-			info->tty->alt_speed = 460800;
-	}
+	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		tty->alt_speed = 57600;
+	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		tty->alt_speed = 115200;
+	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		tty->alt_speed = 230400;
+	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		tty->alt_speed = 460800;
 
 	/*
 	 * and set the speed of the serial port
 	 */
-	change_speed(info, NULL);
+	change_speed(tty, info, NULL);
 
 	info->flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
@@ -591,7 +587,7 @@ errout:
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct serial_state *info)
+static void shutdown(struct tty_struct *tty, struct serial_state *info)
 {
 	unsigned long	flags;
 	struct serial_state *state;
@@ -631,12 +627,11 @@ static void shutdown(struct serial_state *info)
 	custom.adkcon = AC_UARTBRK;
 	mb();
 
-	if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
+	if (tty->termios->c_cflag & HUPCL)
 		info->MCR &= ~(SER_DTR|SER_RTS);
 	rtsdtr_ctrl(info->MCR);
 
-	if (info->tty)
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 
 	info->flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
@@ -647,7 +642,7 @@ static void shutdown(struct serial_state *info)
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static void change_speed(struct serial_state *info,
+static void change_speed(struct tty_struct *tty, struct serial_state *info,
 			 struct ktermios *old_termios)
 {
 	int	quot = 0, baud_base, baud;
@@ -655,9 +650,7 @@ static void change_speed(struct serial_state *info,
 	int	bits;
 	unsigned long	flags;
 
-	if (!info->tty || !info->tty->termios)
-		return;
-	cflag = info->tty->termios->c_cflag;
+	cflag = tty->termios->c_cflag;
 
 	/* Byte size is always 8 bits plus parity bit if requested */
 
@@ -678,7 +671,7 @@ static void change_speed(struct serial_state *info,
 #endif
 
 	/* Determine divisor based on baud rate */
-	baud = tty_get_baud_rate(info->tty);
+	baud = tty_get_baud_rate(tty);
 	if (!baud)
 		baud = 9600;	/* B0 transition handled in rs_set_termios */
 	baud_base = info->baud_base;
@@ -695,9 +688,9 @@ static void change_speed(struct serial_state *info,
 	/* If the quotient is zero refuse the change */
 	if (!quot && old_termios) {
 		/* FIXME: Will need updating for new tty in the end */
-		info->tty->termios->c_cflag &= ~CBAUD;
-		info->tty->termios->c_cflag |= (old_termios->c_cflag & CBAUD);
-		baud = tty_get_baud_rate(info->tty);
+		tty->termios->c_cflag &= ~CBAUD;
+		tty->termios->c_cflag |= (old_termios->c_cflag & CBAUD);
+		baud = tty_get_baud_rate(tty);
 		if (!baud)
 			baud = 9600;
 		if (baud == 38400 &&
@@ -742,24 +735,24 @@ static void change_speed(struct serial_state *info,
 	 */
 
 	info->read_status_mask = UART_LSR_OE | UART_LSR_DR;
-	if (I_INPCK(info->tty))
+	if (I_INPCK(tty))
 		info->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (I_BRKINT(info->tty) || I_PARMRK(info->tty))
+	if (I_BRKINT(tty) || I_PARMRK(tty))
 		info->read_status_mask |= UART_LSR_BI;
 
 	/*
 	 * Characters to ignore
 	 */
 	info->ignore_status_mask = 0;
-	if (I_IGNPAR(info->tty))
+	if (I_IGNPAR(tty))
 		info->ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
-	if (I_IGNBRK(info->tty)) {
+	if (I_IGNBRK(tty)) {
 		info->ignore_status_mask |= UART_LSR_BI;
 		/*
 		 * If we're ignore parity and break indicators, ignore 
 		 * overruns too.  (For real raw support).
 		 */
-		if (I_IGNPAR(info->tty))
+		if (I_IGNPAR(tty))
 			info->ignore_status_mask |= UART_LSR_OE;
 	}
 	/*
@@ -1038,7 +1031,7 @@ static int get_serial_info(struct serial_state *state,
 	return 0;
 }
 
-static int set_serial_info(struct serial_state *state,
+static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 			   struct serial_struct __user * new_info)
 {
 	struct serial_struct new_serial;
@@ -1086,23 +1079,23 @@ static int set_serial_info(struct serial_state *state,
 	state->custom_divisor = new_serial.custom_divisor;
 	state->close_delay = new_serial.close_delay * HZ/100;
 	state->closing_wait = new_serial.closing_wait * HZ/100;
-	state->tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+	tty->low_latency = (state->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
 	if (state->flags & ASYNC_INITIALIZED) {
 		if (change_spd) {
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-				state->tty->alt_speed = 57600;
+				tty->alt_speed = 57600;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-				state->tty->alt_speed = 115200;
+				tty->alt_speed = 115200;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-				state->tty->alt_speed = 230400;
+				tty->alt_speed = 230400;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-				state->tty->alt_speed = 460800;
-			change_speed(state, NULL);
+				tty->alt_speed = 460800;
+			change_speed(tty, state, NULL);
 		}
 	} else
-		retval = startup(state);
+		retval = startup(tty, state);
 	tty_unlock();
 	return retval;
 }
@@ -1256,7 +1249,7 @@ static int rs_ioctl(struct tty_struct *tty,
 		case TIOCGSERIAL:
 			return get_serial_info(info, argp);
 		case TIOCSSERIAL:
-			return set_serial_info(info, argp);
+			return set_serial_info(tty, info, argp);
 		case TIOCSERCONFIG:
 			return 0;
 
@@ -1319,7 +1312,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	change_speed(info, old_termios);
+	change_speed(tty, info, old_termios);
 
 	/* Handle transition to B0 status */
 	if ((old_termios->c_cflag & CBAUD) &&
@@ -1444,7 +1437,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		 */
 		rs_wait_until_sent(tty, state->timeout);
 	}
-	shutdown(state);
+	shutdown(tty, state);
 	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
@@ -1535,7 +1528,7 @@ static void rs_hangup(struct tty_struct *tty)
 		return;
 
 	rs_flush_buffer(tty);
-	shutdown(info);
+	shutdown(tty, info);
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -1696,7 +1689,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * Start up serial port
 	 */
-	retval = startup(info);
+	retval = startup(tty, info);
 	if (retval) {
 		return retval;
 	}
-- 
1.7.9.2


