Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2DBMJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:09:34 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47945 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2DBLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 12/69] TTY: isdn, use counts from tty_port
Date: Mon,  2 Apr 2012 13:53:56 +0200
Message-Id: <1333367693-3244-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blocked_open and count this time.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   43 +++++++++++++++++++++----------------------
 include/linux/isdn.h        |    2 --
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 33764d0..c81a725 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1533,8 +1533,8 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	       info->line, info->count);
 #endif
 	if (!(tty_hung_up_p(filp)))
-		info->count--;
-	info->blocked_open++;
+		info->port.count--;
+	info->port.blocked_open++;
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
@@ -1559,18 +1559,18 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 		}
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_block_til_ready blocking: ttyi%d, count = %d\n",
-		       info->line, info->count);
+		       info->line, info->port.count);
 #endif
 		schedule();
 	}
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&info->port.open_wait, &wait);
 	if (!tty_hung_up_p(filp))
-		info->count++;
-	info->blocked_open--;
+		info->port.count++;
+	info->port.blocked_open--;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_block_til_ready after blocking: ttyi%d, count = %d\n",
-	       info->line, info->count);
+	       info->line, info->port.count);
 #endif
 	if (retval)
 		return retval;
@@ -1595,9 +1595,9 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_open %s, count = %d\n", tty->name,
-	       info->count);
+	       info->port.count);
 #endif
-	info->count++;
+	info->port.count++;
 	tty->driver_data = info;
 	info->tty = tty;
 	tty->port = &info->port;
@@ -1642,7 +1642,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 #endif
 		return;
 	}
-	if ((tty->count == 1) && (info->count != 1)) {
+	if ((tty->count == 1) && (info->port.count != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -1651,15 +1651,15 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "isdn_tty_close: bad port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
-		info->count = 1;
+		       "info->count is %d\n", info->port.count);
+		info->port.count = 1;
 	}
-	if (--info->count < 0) {
+	if (--info->port.count < 0) {
 		printk(KERN_ERR "isdn_tty_close: bad port count for ttyi%d: %d\n",
-		       info->line, info->count);
-		info->count = 0;
+		       info->line, info->port.count);
+		info->port.count = 0;
 	}
-	if (info->count) {
+	if (info->port.count) {
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_close after info->count != 0\n");
 #endif
@@ -1695,7 +1695,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	info->tty = NULL;
 	info->ncarrier = 0;
 	tty->closing = 0;
-	if (info->blocked_open) {
+	if (info->port.blocked_open) {
 		msleep_interruptible(500);
 		wake_up_interruptible(&info->port.open_wait);
 	}
@@ -1717,7 +1717,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_hangup"))
 		return;
 	isdn_tty_shutdown(info);
-	info->count = 0;
+	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->port.open_wait);
@@ -1896,8 +1896,6 @@ isdn_tty_modem_init(void)
 		info->line = i;
 		info->tty = NULL;
 		info->x_char = 0;
-		info->count = 0;
-		info->blocked_open = 0;
 		info->isdn_driver = -1;
 		info->isdn_channel = -1;
 		info->drv_index = -1;
@@ -2047,7 +2045,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 		modem_info *info = &dev->mdm.info[i];
 
-		if (info->count == 0)
+		if (info->port.count == 0)
 			continue;
 		if ((info->emu.mdmreg[REG_SI1] & si2bit[si1]) &&  /* SI1 is matching */
 		    (info->emu.mdmreg[REG_SI2] == si2))	{         /* SI2 is matching */
@@ -2190,7 +2188,7 @@ isdn_tty_stat_callback(int i, isdn_ctrl *c)
 			 * for incoming call of this device when
 			 * DCD follow the state of incoming carrier
 			 */
-			if (info->blocked_open &&
+			if (info->port.blocked_open &&
 			    (info->emu.mdmreg[REG_DCD] & BIT_DCD)) {
 				wake_up_interruptible(&info->port.open_wait);
 			}
@@ -2200,7 +2198,8 @@ isdn_tty_stat_callback(int i, isdn_ctrl *c)
 			 * set DCD-bit of its modem-status.
 			 */
 			if (TTY_IS_ACTIVE(info) ||
-			    (info->blocked_open && (info->emu.mdmreg[REG_DCD] & BIT_DCD))) {
+			    (info->port.blocked_open &&
+			     (info->emu.mdmreg[REG_DCD] & BIT_DCD))) {
 				info->msr |= UART_MSR_DCD;
 				info->emu.charge = 0;
 				if (info->dialing & 0xf)
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index c3ddf20..a4b71fe 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -442,8 +442,6 @@ typedef struct modem_info {
   int                   msr;             /* Modem status register          */
   int                   lsr;             /* Line status register           */
   int			line;
-  int			count;		 /* # of fd on device              */
-  int			blocked_open;	 /* # of blocked opens             */
   int                   online;          /* 1 = B-Channel is up, drop data */
 					 /* 2 = B-Channel is up, deliver d.*/
   int                   dialing;         /* Dial in progress or ATA        */
-- 
1.7.9.2


