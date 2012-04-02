Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2DBMHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:07:32 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48159 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2DBLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 56/69] TTY: 68328serial, add tty_port
Date: Mon,  2 Apr 2012 13:54:40 +0200
Message-Id: <1333367693-3244-57-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use count and blocked_count from that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/tty/serial/68328serial.c |   40 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 116d932..848662c 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -109,6 +109,7 @@
  * For definitions of the flags field, see serial.h
  */
 struct m68k_serial {
+	struct tty_port		tport;
 	char			is_cons;	/* Is this our console. */
 	int			magic;
 	int			baud_base;
@@ -122,8 +123,6 @@ struct m68k_serial {
 	int			close_delay;
 	unsigned short		closing_wait;
 	int			line;
-	int			count;		/* # of fd on device */
-	int			blocked_open;	/* # of blocked opens */
 	unsigned char		*xmit_buf;
 	int			xmit_head;
 	int			xmit_tail;
@@ -866,7 +865,7 @@ static int set_serial_info(struct m68k_serial * info,
 		goto check_and_exit;
 	}
 
-	if (info->count > 1)
+	if (info->tport.count > 1)
 		return -EBUSY;
 
 	/*
@@ -1010,6 +1009,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
 	struct m68k_serial * info = (struct m68k_serial *)tty->driver_data;
+	struct tty_port *port = &info->tport;
 	m68328_uart *uart = &uart_addr[info->line];
 	unsigned long flags;
 
@@ -1023,7 +1023,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		return;
 	}
 	
-	if ((tty->count == 1) && (info->count != 1)) {
+	if ((tty->count == 1) && (port->count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -1032,15 +1032,15 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		 * serial port won't be shutdown.
 		 */
 		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
-		info->count = 1;
+		       "port->count is %d\n", port->count);
+		port->count = 1;
 	}
-	if (--info->count < 0) {
+	if (--port->count < 0) {
 		printk("rs_close: bad serial port count for ttyS%d: %d\n",
-		       info->line, info->count);
-		info->count = 0;
+		       info->line, port->count);
+		port->count = 0;
 	}
-	if (info->count) {
+	if (port->count) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -1079,7 +1079,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 			(tty->ldisc.open)(tty);
 	}
 #endif	
-	if (info->blocked_open) {
+	if (port->blocked_open) {
 		if (info->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(info->close_delay));
 		}
@@ -1102,7 +1102,7 @@ void rs_hangup(struct tty_struct *tty)
 	
 	rs_flush_buffer(tty);
 	shutdown(info);
-	info->count = 0;
+	info->tport.count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
@@ -1116,6 +1116,7 @@ void rs_hangup(struct tty_struct *tty)
 static int block_til_ready(struct tty_struct *tty, struct file * filp,
 			   struct m68k_serial *info)
 {
+	struct tty_port *port = &info->tport;
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
 	int		do_clocal = 0;
@@ -1152,15 +1153,15 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, info->count is dropped by one, so that
+	 * this loop, port->count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
 	add_wait_queue(&info->open_wait, &wait);
 
-	info->count--;
-	info->blocked_open++;
+	port->count--;
+	port->blocked_open++;
 	while (1) {
 		current->state = TASK_INTERRUPTIBLE;
 		if (tty_hung_up_p(filp) ||
@@ -1188,8 +1189,8 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&info->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
-		info->count++;
-	info->blocked_open--;
+		port->count++;
+	port->blocked_open--;
 
 	if (retval)
 		return retval;
@@ -1213,7 +1214,7 @@ int rs_open(struct tty_struct *tty, struct file * filp)
 	if (serial_paranoia_check(info, tty->name, "rs_open"))
 		return -ENODEV;
 
-	info->count++;
+	info->tport.count++;
 	tty->driver_data = info;
 	info->tty = tty;
 
@@ -1291,6 +1292,7 @@ rs68328_init(void)
 	for(i=0;i<NR_PORTS;i++) {
 
 	    info = &m68k_soft[i];
+	    tty_port_init(&info->tport);
 	    info->magic = SERIAL_MAGIC;
 	    info->port = (int) &uart_addr[i];
 	    info->tty = NULL;
@@ -1299,8 +1301,6 @@ rs68328_init(void)
 	    info->close_delay = 50;
 	    info->closing_wait = 3000;
 	    info->x_char = 0;
-	    info->count = 0;
-	    info->blocked_open = 0;
 	    init_waitqueue_head(&info->open_wait);
 	    init_waitqueue_head(&info->close_wait);
 	    info->line = i;
-- 
1.7.9.2


