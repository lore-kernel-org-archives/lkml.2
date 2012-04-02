Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2DBMHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:07:34 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48160 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2DBLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 60/69] TTY: 68328serial, propagate tty
Date: Mon,  2 Apr 2012 13:54:44 +0200
Message-Id: <1333367693-3244-61-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need tty at some places, but info->tty might be NULL at those. Let
us propagate tty from callers where we know we have a valid tty. This
will make a switch to tty refcounting simpler.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   53 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index e3a1c55..fde573b 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -140,7 +140,7 @@ m68328_uart *uart_addr = (m68328_uart *)USTCNT_ADDR;
 
 struct tty_driver *serial_driver;
 
-static void change_speed(struct m68k_serial *info);
+static void change_speed(struct m68k_serial *info, struct tty_struct *tty);
 
 /*
  *	Setup for console. Argument comes from the boot command line.
@@ -263,9 +263,9 @@ static void rs_start(struct tty_struct *tty)
 	local_irq_restore(flags);
 }
 
-static void receive_chars(struct m68k_serial *info, unsigned short rx)
+static void receive_chars(struct m68k_serial *info, struct tty_struct *tty,
+		unsigned short rx)
 {
-	struct tty_struct *tty = info->tty;
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned char ch, flag;
 
@@ -317,7 +317,7 @@ clear_and_exit:
 	return;
 }
 
-static void transmit_chars(struct m68k_serial *info)
+static void transmit_chars(struct m68k_serial *info, struct tty_struct *tty)
 {
 	m68328_uart *uart = &uart_addr[info->line];
 
@@ -328,7 +328,7 @@ static void transmit_chars(struct m68k_serial *info)
 		goto clear_and_return;
 	}
 
-	if((info->xmit_cnt <= 0) || info->tty->stopped) {
+	if ((info->xmit_cnt <= 0) || !tty || tty->stopped) {
 		/* That's peculiar... TX ints off */
 		uart->ustcnt &= ~USTCNT_TX_INTR_MASK;
 		goto clear_and_return;
@@ -356,6 +356,7 @@ clear_and_return:
 irqreturn_t rs_interrupt(int irq, void *dev_id)
 {
 	struct m68k_serial *info = dev_id;
+	struct tty_struct *tty = info->tty;
 	m68328_uart *uart;
 	unsigned short rx;
 	unsigned short tx;
@@ -366,15 +367,17 @@ irqreturn_t rs_interrupt(int irq, void *dev_id)
 #ifdef USE_INTS
 	tx = uart->utx.w;
 
-	if (rx & URX_DATA_READY) receive_chars(info, rx);
-	if (tx & UTX_TX_AVAIL)   transmit_chars(info);
+	if (rx & URX_DATA_READY)
+		receive_chars(info, tty, rx);
+	if (tx & UTX_TX_AVAIL)
+		transmit_chars(info, tty);
 #else
-	receive_chars(info, rx);		
+	receive_chars(info, tty, rx);
 #endif
 	return IRQ_HANDLED;
 }
 
-static int startup(struct m68k_serial * info)
+static int startup(struct m68k_serial *info, struct tty_struct *tty)
 {
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned long flags;
@@ -409,15 +412,15 @@ static int startup(struct m68k_serial * info)
 	uart->ustcnt = USTCNT_UEN | USTCNT_RXEN | USTCNT_RX_INTR_MASK;
 #endif
 
-	if (info->tty)
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (tty)
+		clear_bit(TTY_IO_ERROR, &tty->flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 
 	/*
 	 * and set the speed of the serial port
 	 */
 
-	change_speed(info);
+	change_speed(info, tty);
 
 	info->tport.flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
@@ -428,7 +431,7 @@ static int startup(struct m68k_serial * info)
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct m68k_serial * info)
+static void shutdown(struct m68k_serial *info, struct tty_struct *tty)
 {
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned long	flags;
@@ -444,8 +447,8 @@ static void shutdown(struct m68k_serial * info)
 		info->xmit_buf = 0;
 	}
 
-	if (info->tty)
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (tty)
+		set_bit(TTY_IO_ERROR, &tty->flags);
 	
 	info->tport.flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
@@ -503,7 +506,7 @@ struct {
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static void change_speed(struct m68k_serial *info)
+static void change_speed(struct m68k_serial *info, struct tty_struct *tty)
 {
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned short port;
@@ -511,9 +514,7 @@ static void change_speed(struct m68k_serial *info)
 	unsigned cflag;
 	int	i;
 
-	if (!info->tty || !info->tty->termios)
-		return;
-	cflag = info->tty->termios->c_cflag;
+	cflag = tty->termios->c_cflag;
 	if (!(port = info->port))
 		return;
 
@@ -832,7 +833,7 @@ static int get_serial_info(struct m68k_serial * info,
 	return 0;
 }
 
-static int set_serial_info(struct m68k_serial * info,
+static int set_serial_info(struct m68k_serial *info, struct tty_struct *tty,
 			   struct serial_struct * new_info)
 {
 	struct tty_port *port = &info->tport;
@@ -875,7 +876,7 @@ static int set_serial_info(struct m68k_serial * info,
 	port->closing_wait = new_serial.closing_wait;
 
 check_and_exit:
-	retval = startup(info);
+	retval = startup(info, tty);
 	return retval;
 }
 
@@ -961,7 +962,7 @@ static int rs_ioctl(struct tty_struct *tty,
 			return get_serial_info(info,
 				       (struct serial_struct *) arg);
 		case TIOCSSERIAL:
-			return set_serial_info(info,
+			return set_serial_info(info, tty,
 					       (struct serial_struct *) arg);
 		case TIOCSERGETLSR: /* Get line status register */
 			return get_lsr_info(info, (unsigned int *) arg);
@@ -980,7 +981,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct m68k_serial *info = (struct m68k_serial *)tty->driver_data;
 
-	change_speed(info);
+	change_speed(info, tty);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -1056,7 +1057,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	uart->ustcnt &= ~USTCNT_RXEN;
 	uart->ustcnt &= ~(USTCNT_RXEN | USTCNT_RX_INTR_MASK);
 
-	shutdown(info);
+	shutdown(info, tty);
 	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
@@ -1094,7 +1095,7 @@ void rs_hangup(struct tty_struct *tty)
 		return;
 	
 	rs_flush_buffer(tty);
-	shutdown(info);
+	shutdown(info, tty);
 	info->tport.count = 0;
 	info->tport.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -1214,7 +1215,7 @@ int rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * Start up serial port
 	 */
-	retval = startup(info);
+	retval = startup(info, tty);
 	if (retval)
 		return retval;
 
-- 
1.7.9.2


