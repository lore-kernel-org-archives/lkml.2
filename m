Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2DBMHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:07:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48158 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2DBLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 58/69] TTY: 68328serial, use close_delay/closing_wait from tty_port
Date: Mon,  2 Apr 2012 13:54:42 +0200
Message-Id: <1333367693-3244-59-git-send-email-jslaby@suse.cz>
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
 drivers/tty/serial/68328serial.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 0c50f2e..e9fd13e 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -120,8 +120,6 @@ struct m68k_serial {
 	struct tty_struct	*tty;
 	int			custom_divisor;
 	int			x_char;		/* xon/xoff character */
-	int			close_delay;
-	unsigned short		closing_wait;
 	int			line;
 	unsigned char		*xmit_buf;
 	int			xmit_head;
@@ -828,8 +826,8 @@ static int get_serial_info(struct m68k_serial * info,
 	tmp.irq = info->irq;
 	tmp.flags = info->flags;
 	tmp.baud_base = info->baud_base;
-	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
+	tmp.close_delay = info->tport.close_delay;
+	tmp.closing_wait = info->tport.closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
@@ -840,6 +838,7 @@ static int get_serial_info(struct m68k_serial * info,
 static int set_serial_info(struct m68k_serial * info,
 			   struct serial_struct * new_info)
 {
+	struct tty_port *port = &info->tport;
 	struct serial_struct new_serial;
 	struct m68k_serial old_info;
 	int 			retval = 0;
@@ -853,7 +852,7 @@ static int set_serial_info(struct m68k_serial * info,
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((new_serial.baud_base != info->baud_base) ||
 		    (new_serial.type != info->type) ||
-		    (new_serial.close_delay != info->close_delay) ||
+		    (new_serial.close_delay != port->close_delay) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
@@ -863,7 +862,7 @@ static int set_serial_info(struct m68k_serial * info,
 		goto check_and_exit;
 	}
 
-	if (info->tport.count > 1)
+	if (port->count > 1)
 		return -EBUSY;
 
 	/*
@@ -875,8 +874,8 @@ static int set_serial_info(struct m68k_serial * info,
 	info->flags = ((info->flags & ~ASYNC_FLAGS) |
 			(new_serial.flags & ASYNC_FLAGS));
 	info->type = new_serial.type;
-	info->close_delay = new_serial.close_delay;
-	info->closing_wait = new_serial.closing_wait;
+	port->close_delay = new_serial.close_delay;
+	port->closing_wait = new_serial.closing_wait;
 
 check_and_exit:
 	retval = startup(info);
@@ -1048,8 +1047,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
-	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->closing_wait);
+	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		tty_wait_until_sent(tty, port->closing_wait);
 	/*
 	 * At this point we stop accepting input.  To do this, we
 	 * disable the receive line status interrupts, and tell the
@@ -1078,9 +1077,8 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	}
 #endif	
 	if (port->blocked_open) {
-		if (info->close_delay) {
-			msleep_interruptible(jiffies_to_msecs(info->close_delay));
-		}
+		if (port->close_delay)
+			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 		wake_up_interruptible(&port->open_wait);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
@@ -1296,8 +1294,6 @@ rs68328_init(void)
 	    info->tty = NULL;
 	    info->irq = uart_irqs[i];
 	    info->custom_divisor = 16;
-	    info->close_delay = 50;
-	    info->closing_wait = 3000;
 	    info->x_char = 0;
 	    info->line = i;
 	    info->is_cons = 1; /* Means shortcuts work */
-- 
1.7.9.2


