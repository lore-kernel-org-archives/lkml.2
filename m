Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2DBMK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:10:58 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47930 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 06/69] TTY: isdn, remove ISDN_ASYNC_* flags
Date: Mon,  2 Apr 2012 13:53:50 +0200
Message-Id: <1333367693-3244-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same as TTY ones. So there is no need to redefine them.
Remove ISDN_ASYNC_* and use only ASYNC_*. Except the MAGIC number, of
course.

While we are there, remove also the SERIAL_TYPE flags which are
unused.

Perhaps we should move the ASYNC flags from serial.h to tty.h given
they are used by the tty layer and tty drivers, not only serial?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   59 ++++++++++++++++++++++---------------------
 include/linux/isdn.h        |   12 ---------
 2 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 27f7092..bcf4bbe 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -11,6 +11,7 @@
 #undef ISDN_TTY_STAT_DEBUG
 
 #include <linux/isdn.h>
+#include <linux/serial.h> /* ASYNC_* flags */
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
@@ -1036,20 +1037,20 @@ isdn_tty_change_speed(modem_info *info)
 
 	/* CTS flow control flag and modem status interrupts */
 	if (cflag & CRTSCTS) {
-		info->flags |= ISDN_ASYNC_CTS_FLOW;
+		info->flags |= ASYNC_CTS_FLOW;
 	} else
-		info->flags &= ~ISDN_ASYNC_CTS_FLOW;
+		info->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
-		info->flags &= ~ISDN_ASYNC_CHECK_CD;
+		info->flags &= ~ASYNC_CHECK_CD;
 	else {
-		info->flags |= ISDN_ASYNC_CHECK_CD;
+		info->flags |= ASYNC_CHECK_CD;
 	}
 }
 
 static int
 isdn_tty_startup(modem_info *info)
 {
-	if (info->flags & ISDN_ASYNC_INITIALIZED)
+	if (info->flags & ASYNC_INITIALIZED)
 		return 0;
 	isdn_lock_drivers();
 #ifdef ISDN_DEBUG_MODEM_OPEN
@@ -1066,7 +1067,7 @@ isdn_tty_startup(modem_info *info)
 	 */
 	isdn_tty_change_speed(info);
 
-	info->flags |= ISDN_ASYNC_INITIALIZED;
+	info->flags |= ASYNC_INITIALIZED;
 	info->msr |= (UART_MSR_DSR | UART_MSR_CTS);
 	info->send_outstanding = 0;
 	return 0;
@@ -1079,7 +1080,7 @@ isdn_tty_startup(modem_info *info)
 static void
 isdn_tty_shutdown(modem_info *info)
 {
-	if (!(info->flags & ISDN_ASYNC_INITIALIZED))
+	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "Shutting down isdnmodem port %d ....\n", info->line);
@@ -1099,7 +1100,7 @@ isdn_tty_shutdown(modem_info *info)
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
-	info->flags &= ~ISDN_ASYNC_INITIALIZED;
+	info->flags &= ~ASYNC_INITIALIZED;
 }
 
 /* isdn_tty_write() is the main send-routine. It is called from the upper
@@ -1486,11 +1487,11 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) ||
-	    (info->flags & ISDN_ASYNC_CLOSING)) {
-		if (info->flags & ISDN_ASYNC_CLOSING)
+	    (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
 #ifdef MODEM_DO_RESTART
-		if (info->flags & ISDN_ASYNC_HUP_NOTIFY)
+		if (info->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -1504,7 +1505,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		info->flags |= ISDN_ASYNC_NORMAL_ACTIVE;
+		info->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 	if (tty->termios->c_cflag & CLOCAL)
@@ -1528,9 +1529,9 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(info->flags & ISDN_ASYNC_INITIALIZED)) {
+		    !(info->flags & ASYNC_INITIALIZED)) {
 #ifdef MODEM_DO_RESTART
-			if (info->flags & ISDN_ASYNC_HUP_NOTIFY)
+			if (info->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
@@ -1539,7 +1540,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 			break;
 		}
-		if (!(info->flags & ISDN_ASYNC_CLOSING) &&
+		if (!(info->flags & ASYNC_CLOSING) &&
 		    (do_clocal || (info->msr & UART_MSR_DCD))) {
 			break;
 		}
@@ -1564,7 +1565,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 	if (retval)
 		return retval;
-	info->flags |= ISDN_ASYNC_NORMAL_ACTIVE;
+	info->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -1661,7 +1662,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		module_put(info->owner);
 		return;
 	}
-	info->flags |= ISDN_ASYNC_CLOSING;
+	info->flags |= ASYNC_CLOSING;
 
 	tty->closing = 1;
 	/*
@@ -1670,7 +1671,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	 * interrupt driver to stop checking the data ready bit in the
 	 * line status register.
 	 */
-	if (info->flags & ISDN_ASYNC_INITIALIZED) {
+	if (info->flags & ASYNC_INITIALIZED) {
 		tty_wait_until_sent_from_close(tty, 3000);	/* 30 seconds timeout */
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
@@ -1696,7 +1697,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		msleep_interruptible(500);
 		wake_up_interruptible(&info->open_wait);
 	}
-	info->flags &= ~(ISDN_ASYNC_NORMAL_ACTIVE | ISDN_ASYNC_CLOSING);
+	info->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_close normal exit\n");
@@ -1715,7 +1716,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 		return;
 	isdn_tty_shutdown(info);
 	info->count = 0;
-	info->flags &= ~ISDN_ASYNC_NORMAL_ACTIVE;
+	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -2061,7 +2062,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 #endif
 			if (
 #ifndef FIX_FILE_TRANSFER
-				(info->flags & ISDN_ASYNC_NORMAL_ACTIVE) &&
+				(info->flags & ASYNC_NORMAL_ACTIVE) &&
 #endif
 				(info->isdn_driver == -1) &&
 				(info->isdn_channel == -1) &&
@@ -2100,7 +2101,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 	return (wret == 2) ? 3 : 0;
 }
 
-#define TTY_IS_ACTIVE(info)	(info->flags & ISDN_ASYNC_NORMAL_ACTIVE)
+#define TTY_IS_ACTIVE(info)	(info->flags & ASYNC_NORMAL_ACTIVE)
 
 int
 isdn_tty_stat_callback(int i, isdn_ctrl *c)
@@ -2319,7 +2320,7 @@ isdn_tty_at_cout(char *msg, modem_info *info)
 
 	spin_lock_irqsave(&info->readlock, flags);
 	tty = info->tty;
-	if ((info->flags & ISDN_ASYNC_CLOSING) || (!tty)) {
+	if ((info->flags & ASYNC_CLOSING) || (!tty)) {
 		spin_unlock_irqrestore(&info->readlock, flags);
 		return;
 	}
@@ -2469,15 +2470,15 @@ isdn_tty_modem_result(int code, modem_info *info)
 	case RESULT_NO_CARRIER:
 #ifdef ISDN_DEBUG_MODEM_HUP
 		printk(KERN_DEBUG "modem_result: NO CARRIER %d %d\n",
-		       (info->flags & ISDN_ASYNC_CLOSING),
+		       (info->flags & ASYNC_CLOSING),
 		       (!info->tty));
 #endif
 		m->mdmreg[REG_RINGCNT] = 0;
 		del_timer(&info->nc_timer);
 		info->ncarrier = 0;
-		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
+		if ((info->flags & ASYNC_CLOSING) || (!info->tty))
 			return;
-		}
+
 #ifdef CONFIG_ISDN_AUDIO
 		if (info->vonline & 1) {
 #ifdef ISDN_DEBUG_MODEM_VOICE
@@ -2608,10 +2609,10 @@ isdn_tty_modem_result(int code, modem_info *info)
 		}
 	}
 	if (code == RESULT_NO_CARRIER) {
-		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
+		if ((info->flags & ASYNC_CLOSING) || (!info->tty))
 			return;
-		}
-		if (info->flags & ISDN_ASYNC_CHECK_CD)
+
+		if (info->flags & ASYNC_CHECK_CD)
 			tty_hangup(info->tty);
 	}
 }
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index d13b76d..1b4b4c1 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -392,20 +392,8 @@ typedef struct isdn_net_dev_s {
 /*======================= Start of ISDN-tty stuff ===========================*/
 
 #define ISDN_ASYNC_MAGIC          0x49344C01 /* for paranoia-checking        */
-#define ISDN_ASYNC_INITIALIZED	  0x80000000 /* port was initialized         */
-#define ISDN_ASYNC_NORMAL_ACTIVE  0x20000000 /* Normal device active         */
-#define ISDN_ASYNC_CLOSING	  0x08000000 /* Serial port is closing       */
-#define ISDN_ASYNC_CTS_FLOW	  0x04000000 /* Do CTS flow control          */
-#define ISDN_ASYNC_CHECK_CD	  0x02000000 /* i.e., CLOCAL                 */
-#define ISDN_ASYNC_HUP_NOTIFY         0x0001 /* Notify tty on hangups/closes */
-#define ISDN_ASYNC_SESSION_LOCKOUT    0x0100 /* Lock cua opens on session    */
-#define ISDN_ASYNC_PGRP_LOCKOUT       0x0200 /* Lock cua opens on pgrp       */
-#define ISDN_ASYNC_CALLOUT_NOHUP      0x0400 /* No hangup for cui            */
-#define ISDN_ASYNC_SPLIT_TERMIOS      0x0008 /* Sep. termios for dialin/out  */
 #define ISDN_SERIAL_XMIT_SIZE           1024 /* Default bufsize for write    */
 #define ISDN_SERIAL_XMIT_MAX            4000 /* Maximum bufsize for write    */
-#define ISDN_SERIAL_TYPE_NORMAL            1
-#define ISDN_SERIAL_TYPE_CALLOUT           2
 
 #ifdef CONFIG_ISDN_AUDIO
 /* For using sk_buffs with audio we need some private variables
-- 
1.7.9.2


