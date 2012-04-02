Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2DBMHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:07:31 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48161 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2DBLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 59/69] TTY: 68328serial, use flags from tty_port
Date: Mon,  2 Apr 2012 13:54:43 +0200
Message-Id: <1333367693-3244-60-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   39 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index e9fd13e..e3a1c55 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -105,8 +105,6 @@
 
 /*
  * This is our internal structure for each serial port's state.
- *
- * For definitions of the flags field, see serial.h
  */
 struct m68k_serial {
 	struct tty_port		tport;
@@ -115,7 +113,6 @@ struct m68k_serial {
 	int			baud_base;
 	int			port;
 	int			irq;
-	int			flags;		/* defined in tty.h */
 	int			type;		/* UART type */
 	struct tty_struct	*tty;
 	int			custom_divisor;
@@ -382,7 +379,7 @@ static int startup(struct m68k_serial * info)
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned long flags;
 	
-	if (info->flags & ASYNC_INITIALIZED)
+	if (info->tport.flags & ASYNC_INITIALIZED)
 		return 0;
 
 	if (!info->xmit_buf) {
@@ -422,7 +419,7 @@ static int startup(struct m68k_serial * info)
 
 	change_speed(info);
 
-	info->flags |= ASYNC_INITIALIZED;
+	info->tport.flags |= ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 	return 0;
 }
@@ -437,7 +434,7 @@ static void shutdown(struct m68k_serial * info)
 	unsigned long	flags;
 
 	uart->ustcnt = 0; /* All off! */
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->tport.flags & ASYNC_INITIALIZED))
 		return;
 
 	local_irq_save(flags);
@@ -450,7 +447,7 @@ static void shutdown(struct m68k_serial * info)
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 	
-	info->flags &= ~ASYNC_INITIALIZED;
+	info->tport.flags &= ~ASYNC_INITIALIZED;
 	local_irq_restore(flags);
 }
 
@@ -824,7 +821,7 @@ static int get_serial_info(struct m68k_serial * info,
 	tmp.line = info->line;
 	tmp.port = info->port;
 	tmp.irq = info->irq;
-	tmp.flags = info->flags;
+	tmp.flags = info->tport.flags;
 	tmp.baud_base = info->baud_base;
 	tmp.close_delay = info->tport.close_delay;
 	tmp.closing_wait = info->tport.closing_wait;
@@ -854,9 +851,9 @@ static int set_serial_info(struct m68k_serial * info,
 		    (new_serial.type != info->type) ||
 		    (new_serial.close_delay != port->close_delay) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (info->flags & ~ASYNC_USR_MASK)))
+		     (port->flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
-		info->flags = ((info->flags & ~ASYNC_USR_MASK) |
+		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		info->custom_divisor = new_serial.custom_divisor;
 		goto check_and_exit;
@@ -871,7 +868,7 @@ static int set_serial_info(struct m68k_serial * info,
 	 */
 
 	info->baud_base = new_serial.baud_base;
-	info->flags = ((info->flags & ~ASYNC_FLAGS) |
+	port->flags = ((port->flags & ~ASYNC_FLAGS) |
 			(new_serial.flags & ASYNC_FLAGS));
 	info->type = new_serial.type;
 	port->close_delay = new_serial.close_delay;
@@ -1041,7 +1038,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		local_irq_restore(flags);
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	port->flags |= ASYNC_CLOSING;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
 	 * the line discipline to only process XON/XOFF characters.
@@ -1081,7 +1078,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 		wake_up_interruptible(&port->open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&port->close_wait);
 	local_irq_restore(flags);
 }
@@ -1099,7 +1096,7 @@ void rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	shutdown(info);
 	info->tport.count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->tport.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
 }
@@ -1121,10 +1118,10 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * If the device is in the middle of being closed, then block
 	 * until it's done, and then try again.
 	 */
-	if (info->flags & ASYNC_CLOSING) {
+	if (port->flags & ASYNC_CLOSING) {
 		interruptible_sleep_on(&port->close_wait);
 #ifdef SERIAL_DO_RESTART
-		if (info->flags & ASYNC_HUP_NOTIFY)
+		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -1139,7 +1136,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ASYNC_NORMAL_ACTIVE;
+		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -1161,9 +1158,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	while (1) {
 		current->state = TASK_INTERRUPTIBLE;
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ASYNC_INITIALIZED)) {
+		    !(port->flags & ASYNC_INITIALIZED)) {
 #ifdef SERIAL_DO_RESTART
-			if (info->flags & ASYNC_HUP_NOTIFY)
+			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;	
@@ -1172,7 +1169,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 #endif
 			break;
 		}
-		if (!(info->flags & ASYNC_CLOSING) && do_clocal)
+		if (!(port->flags & ASYNC_CLOSING) && do_clocal)
 			break;
                 if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
@@ -1190,7 +1187,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 
 	if (retval)
 		return retval;
-	info->flags |= ASYNC_NORMAL_ACTIVE;
+	port->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }	
 
-- 
1.7.9.2


