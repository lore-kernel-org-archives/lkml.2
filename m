Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2DBL4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:02 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48045 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 10/69] TTY: isdn, add tty_port
Date: Mon,  2 Apr 2012 13:53:54 +0200
Message-Id: <1333367693-3244-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use tty_port->flags now. Other members will follow.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   60 ++++++++++++++++++++++---------------------
 include/linux/isdn.h        |    3 ++-
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 74b0518..8ba526d 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1046,20 +1046,20 @@ isdn_tty_change_speed(modem_info *info)
 
 	/* CTS flow control flag and modem status interrupts */
 	if (cflag & CRTSCTS) {
-		info->flags |= ASYNC_CTS_FLOW;
+		info->port.flags |= ASYNC_CTS_FLOW;
 	} else
-		info->flags &= ~ASYNC_CTS_FLOW;
+		info->port.flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->flags &= ~ASYNC_CHECK_CD;
+		info->port.flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->flags |= ASYNC_CHECK_CD;
+		info->port.flags |= ASYNC_CHECK_CD;
 	}
 }
 
 static int
 isdn_tty_startup(modem_info *info)
 {
-	if (info->flags & ASYNC_INITIALIZED)
+	if (info->port.flags & ASYNC_INITIALIZED)
 		return 0;
 	isdn_lock_drivers();
 #ifdef ISDN_DEBUG_MODEM_OPEN
@@ -1076,7 +1076,7 @@ isdn_tty_startup(modem_info *info)
 	 */
 	isdn_tty_change_speed(info);
 
-	info->flags |= ASYNC_INITIALIZED;
+	info->port.flags |= ASYNC_INITIALIZED;
 	info->msr |= (UART_MSR_DSR | UART_MSR_CTS);
 	info->send_outstanding = 0;
 	return 0;
@@ -1089,7 +1089,7 @@ isdn_tty_startup(modem_info *info)
 static void
 isdn_tty_shutdown(modem_info *info)
 {
-	if (!(info->flags & ASYNC_INITIALIZED))
+	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "Shutting down isdnmodem port %d ....\n", info->line);
@@ -1109,7 +1109,7 @@ isdn_tty_shutdown(modem_info *info)
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-	info->flags &= ~ASYNC_INITIALIZED;
+	info->port.flags &= ~ASYNC_INITIALIZED;
 }
 
 /* isdn_tty_write() is the main send-routine. It is called from the upper
@@ -1496,11 +1496,11 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
+	    (info->port.flags & ASYNC_CLOSING)) {
+		if (info->port.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef MODEM_DO_RESTART
-		if (info->flags & ASYNC_HUP_NOTIFY)
+		if (info->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -1514,7 +1514,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ASYNC_NORMAL_ACTIVE;
+		info->port.flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 	if (tty->termios->c_cflag & CLOCAL)
@@ -1538,9 +1538,9 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ASYNC_INITIALIZED)) {
+		    !(info->port.flags & ASYNC_INITIALIZED)) {
 #ifdef MODEM_DO_RESTART
-			if (info->flags & ASYNC_HUP_NOTIFY)
+			if (info->port.flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1549,7 +1549,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 			break;
 		}
-		if (!(info->flags & ASYNC_CLOSING) &&
+		if (!(info->port.flags & ASYNC_CLOSING) &&
 		    (do_clocal || (info->msr & UART_MSR_DCD))) {
 			break;
 		}
@@ -1574,7 +1574,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 	if (retval)
 		return retval;
-	info->flags |= ASYNC_NORMAL_ACTIVE;
+	info->port.flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1600,6 +1600,7 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 	info->count++;
 	tty->driver_data = info;
 	info->tty = tty;
+	tty->port = &info->port;
 	/*
 	 * Start up serial port
 	 */
@@ -1664,7 +1665,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 #endif
 		return;
 	}
-	info->flags |= ASYNC_CLOSING;
+	info->port.flags |= ASYNC_CLOSING;
 
 	tty->closing = 1;
 	/*
@@ -1673,7 +1674,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * interrupt driver to stop checking the data ready bit in the
 	 * line status register.
 	 */
-	if (info->flags & ASYNC_INITIALIZED) {
+	if (info->port.flags & ASYNC_INITIALIZED) {
 		tty_wait_until_sent_from_close(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
@@ -1698,7 +1699,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		msleep_interruptible(500);
 		wake_up_interruptible(&info->open_wait);
 	}
-	info->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_close normal exit\n");
@@ -1717,7 +1718,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 		return;
 	isdn_tty_shutdown(info);
 	info->count = 0;
-	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -1881,6 +1882,7 @@ isdn_tty_modem_init(void)
 			goto err_unregister;
 		}
 #endif
+		tty_port_init(&info->port);
 		spin_lock_init(&info->readlock);
 		sprintf(info->last_cause, "0000");
 		sprintf(info->last_num, "none");
@@ -2055,12 +2057,12 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 #ifdef ISDN_DEBUG_MODEM_ICALL
 			printk(KERN_DEBUG "m_fi: match1 wret=%d\n", wret);
 			printk(KERN_DEBUG "m_fi: idx=%d flags=%08lx drv=%d ch=%d usg=%d\n", idx,
-			       info->flags, info->isdn_driver, info->isdn_channel,
-			       dev->usage[idx]);
+			       info->port.flags, info->isdn_driver,
+			       info->isdn_channel, dev->usage[idx]);
 #endif
 			if (
 #ifndef FIX_FILE_TRANSFER
-				(info->flags & ASYNC_NORMAL_ACTIVE) &&
+				(info->port.flags & ASYNC_NORMAL_ACTIVE) &&
 #endif
 				(info->isdn_driver == -1) &&
 				(info->isdn_channel == -1) &&
@@ -2099,7 +2101,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 	return (wret == 2) ? 3 : 0;
 }
 
-#define TTY_IS_ACTIVE(info)	(info->flags & ASYNC_NORMAL_ACTIVE)
+#define TTY_IS_ACTIVE(info)	(info->port.flags & ASYNC_NORMAL_ACTIVE)
 
 int
 isdn_tty_stat_callback(int i, isdn_ctrl *c)
@@ -2318,7 +2320,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 
 	spin_lock_irqsave(&info->readlock, flags);
 	tty = info->tty;
-	if ((info->flags & ASYNC_CLOSING) || (!tty)) {
+	if ((info->port.flags & ASYNC_CLOSING) || (!tty)) {
 		spin_unlock_irqrestore(&info->readlock, flags);
 		return;
 	}
@@ -2468,13 +2470,13 @@ isdn_tty_modem_result(int code, modem_info *info)
 	case RESULT_NO_CARRIER:
 #ifdef ISDN_DEBUG_MODEM_HUP
 		printk(KERN_DEBUG "modem_result: NO CARRIER %d %d\n",
-		       (info->flags & ASYNC_CLOSING),
+		       (info->port.flags & ASYNC_CLOSING),
 		       (!info->tty));
 #endif
 		m->mdmreg[REG_RINGCNT] = 0;
 		del_timer(&info->nc_timer);
 		info->ncarrier = 0;
-		if ((info->flags & ASYNC_CLOSING) || (!info->tty))
+		if ((info->port.flags & ASYNC_CLOSING) || (!info->tty))
 			return;
 
 #ifdef CONFIG_ISDN_AUDIO
@@ -2607,10 +2609,10 @@ isdn_tty_modem_result(int code, modem_info *info)
 		}
 	}
 	if (code == RESULT_NO_CARRIER) {
-		if ((info->flags & ASYNC_CLOSING) || (!info->tty))
+		if ((info->port.flags & ASYNC_CLOSING) || (!info->tty))
 			return;
 
-		if (info->flags & ASYNC_CHECK_CD)
+		if (info->port.flags & ASYNC_CHECK_CD)
 			tty_hangup(info->tty);
 	}
 }
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 63af320..bb71041 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -15,6 +15,7 @@
 #define __ISDN_H__
 
 #include <linux/ioctl.h>
+#include <linux/tty.h>
 
 #define ISDN_MAX_DRIVERS    32
 #define ISDN_MAX_CHANNELS   64
@@ -435,7 +436,7 @@ typedef struct atemu {
 /* Private data (similar to async_struct in <linux/serial.h>) */
 typedef struct modem_info {
   int			magic;
-  int			flags;		 /* defined in tty.h               */
+  struct tty_port	port;
   int			x_char;		 /* xon/xoff character             */
   int			mcr;		 /* Modem control register         */
   int                   msr;             /* Modem status register          */
-- 
1.7.9.2


