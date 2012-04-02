Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DBMIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:08:44 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47943 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2DBLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 15/69] TTY: isdn, define local tty_port
Date: Mon,  2 Apr 2012 13:53:59 +0200
Message-Id: <1333367693-3244-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some functions we use tty_port much. So let us have a local pointer
to that variable instead of having info->port all over the code.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   98 +++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index dfb83e6..ee8ba87 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1003,20 +1003,21 @@ isdn_tty_paranoia_check(modem_info *info, char *name, const char *routine)
 static void
 isdn_tty_change_speed(modem_info *info)
 {
+	struct tty_port *port = &info->port;
 	uint cflag,
 		cval,
 		quot;
 	int i;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!port->tty || !port->tty->termios)
 		return;
-	cflag = info->port.tty->termios->c_cflag;
+	cflag = port->tty->termios->c_cflag;
 
 	quot = i = cflag & CBAUD;
 	if (i & CBAUDEX) {
 		i &= ~CBAUDEX;
 		if (i < 1 || i > 2)
-			info->port.tty->termios->c_cflag &= ~CBAUDEX;
+			port->tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			i += 15;
 	}
@@ -1046,13 +1047,13 @@ isdn_tty_change_speed(modem_info *info)
 
 	/* CTS flow control flag and modem status interrupts */
 	if (cflag & CRTSCTS) {
-		info->port.flags |= ASYNC_CTS_FLOW;
+		port->flags |= ASYNC_CTS_FLOW;
 	} else
-		info->port.flags &= ~ASYNC_CTS_FLOW;
+		port->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->port.flags &= ~ASYNC_CHECK_CD;
+		port->flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->port.flags |= ASYNC_CHECK_CD;
+		port->flags |= ASYNC_CHECK_CD;
 	}
 }
 
@@ -1487,6 +1488,7 @@ isdn_tty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 static int
 isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *info)
 {
+	struct tty_port *port = &info->port;
 	DECLARE_WAITQUEUE(wait, NULL);
 	int do_clocal = 0;
 	int retval;
@@ -1496,11 +1498,11 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->port.flags & ASYNC_CLOSING)) {
-		if (info->port.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->port.close_wait);
+	    (port->flags & ASYNC_CLOSING)) {
+		if (port->flags & ASYNC_CLOSING)
+			interruptible_sleep_on(&port->close_wait);
 #ifdef MODEM_DO_RESTART
-		if (info->port.flags & ASYNC_HUP_NOTIFY)
+		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -1514,7 +1516,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->port.flags |= ASYNC_NORMAL_ACTIVE;
+		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 	if (tty->termios->c_cflag & CLOCAL)
@@ -1527,20 +1529,20 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->port.open_wait, &wait);
+	add_wait_queue(&port->open_wait, &wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_block_til_ready before block: ttyi%d, count = %d\n",
 	       info->line, info->count);
 #endif
 	if (!(tty_hung_up_p(filp)))
-		info->port.count--;
-	info->port.blocked_open++;
+		port->count--;
+	port->blocked_open++;
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->port.flags & ASYNC_INITIALIZED)) {
+		    !(port->flags & ASYNC_INITIALIZED)) {
 #ifdef MODEM_DO_RESTART
-			if (info->port.flags & ASYNC_HUP_NOTIFY)
+			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1549,7 +1551,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 			break;
 		}
-		if (!(info->port.flags & ASYNC_CLOSING) &&
+		if (!(port->flags & ASYNC_CLOSING) &&
 		    (do_clocal || (info->msr & UART_MSR_DCD))) {
 			break;
 		}
@@ -1559,22 +1561,22 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 		}
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_block_til_ready blocking: ttyi%d, count = %d\n",
-		       info->line, info->port.count);
+		       info->line, port->count);
 #endif
 		schedule();
 	}
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&info->port.open_wait, &wait);
+	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
-		info->port.count++;
-	info->port.blocked_open--;
+		port->count++;
+	port->blocked_open--;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_block_til_ready after blocking: ttyi%d, count = %d\n",
-	       info->line, info->port.count);
+	       info->line, port->count);
 #endif
 	if (retval)
 		return retval;
-	info->port.flags |= ASYNC_NORMAL_ACTIVE;
+	port->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1587,20 +1589,22 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 static int
 isdn_tty_open(struct tty_struct *tty, struct file *filp)
 {
+	struct tty_port *port;
 	modem_info *info;
 	int retval;
 
 	info = &dev->mdm.info[tty->index];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
 		return -ENODEV;
+	port = &info->port;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_open %s, count = %d\n", tty->name,
-	       info->port.count);
+	       port->count);
 #endif
-	info->port.count++;
+	port->count++;
 	tty->driver_data = info;
-	info->port.tty = tty;
-	tty->port = &info->port;
+	port->tty = tty;
+	tty->port = port;
 	/*
 	 * Start up serial port
 	 */
@@ -1632,6 +1636,7 @@ static void
 isdn_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
+	struct tty_port *port = &info->port;
 	ulong timeout;
 
 	if (!info || isdn_tty_paranoia_check(info, tty->name, "isdn_tty_close"))
@@ -1642,7 +1647,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 #endif
 		return;
 	}
-	if ((tty->count == 1) && (info->port.count != 1)) {
+	if ((tty->count == 1) && (port->count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -1651,21 +1656,21 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "isdn_tty_close: bad port count; tty->count is 1, "
-		       "info->count is %d\n", info->port.count);
-		info->port.count = 1;
+		       "info->count is %d\n", port->count);
+		port->count = 1;
 	}
-	if (--info->port.count < 0) {
+	if (--port->count < 0) {
 		printk(KERN_ERR "isdn_tty_close: bad port count for ttyi%d: %d\n",
-		       info->line, info->port.count);
-		info->port.count = 0;
+		       info->line, port->count);
+		port->count = 0;
 	}
-	if (info->port.count) {
+	if (port->count) {
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_close after info->count != 0\n");
 #endif
 		return;
 	}
-	info->port.flags |= ASYNC_CLOSING;
+	port->flags |= ASYNC_CLOSING;
 
 	tty->closing = 1;
 	/*
@@ -1674,7 +1679,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * interrupt driver to stop checking the data ready bit in the
 	 * line status register.
 	 */
-	if (info->port.flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 		tty_wait_until_sent_from_close(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
@@ -1692,15 +1697,15 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	isdn_tty_shutdown(info);
 	isdn_tty_flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->port.tty = NULL;
+	port->tty = NULL;
 	info->ncarrier = 0;
 	tty->closing = 0;
-	if (info->port.blocked_open) {
+	if (port->blocked_open) {
 		msleep_interruptible(500);
-		wake_up_interruptible(&info->port.open_wait);
+		wake_up_interruptible(&port->open_wait);
 	}
-	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&info->port.close_wait);
+	port->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+	wake_up_interruptible(&port->close_wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_close normal exit\n");
 #endif
@@ -1713,14 +1718,15 @@ static void
 isdn_tty_hangup(struct tty_struct *tty)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
+	struct tty_port *port = &info->port;
 
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_hangup"))
 		return;
 	isdn_tty_shutdown(info);
-	info->port.count = 0;
-	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->port.tty = NULL;
-	wake_up_interruptible(&info->port.open_wait);
+	port->count = 0;
+	port->flags &= ~ASYNC_NORMAL_ACTIVE;
+	port->tty = NULL;
+	wake_up_interruptible(&port->open_wait);
 }
 
 /* This routine initializes all emulator-data.
-- 
1.7.9.2


