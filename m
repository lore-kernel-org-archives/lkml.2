Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2DBLzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:17 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48043 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 11/69] TTY: isdn, use open/close_wait from tty_port
Date: Mon,  2 Apr 2012 13:53:55 +0200
Message-Id: <1333367693-3244-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, the isdn ones were initialized twice.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_common.c |    2 --
 drivers/isdn/i4l/isdn_tty.c    |   16 +++++++---------
 include/linux/isdn.h           |    1 -
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index d9f5524..2ffa0b73 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -2327,8 +2327,6 @@ static int __init isdn_init(void)
 		dev->chanmap[i] = -1;
 		dev->m_idx[i] = -1;
 		strcpy(dev->num[i], "???");
-		init_waitqueue_head(&dev->mdm.info[i].open_wait);
-		init_waitqueue_head(&dev->mdm.info[i].close_wait);
 	}
 	if (register_chrdev(ISDN_MAJOR, "isdn", &isdn_fops)) {
 		printk(KERN_WARNING "isdn: Could not register control devices\n");
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 8ba526d..33764d0 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1498,7 +1498,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	if (tty_hung_up_p(filp) ||
 	    (info->port.flags & ASYNC_CLOSING)) {
 		if (info->port.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			interruptible_sleep_on(&info->port.close_wait);
 #ifdef MODEM_DO_RESTART
 		if (info->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
@@ -1527,7 +1527,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->open_wait, &wait);
+	add_wait_queue(&info->port.open_wait, &wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_block_til_ready before block: ttyi%d, count = %d\n",
 	       info->line, info->count);
@@ -1564,7 +1564,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 		schedule();
 	}
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&info->open_wait, &wait);
+	remove_wait_queue(&info->port.open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		info->count++;
 	info->blocked_open--;
@@ -1697,10 +1697,10 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	tty->closing = 0;
 	if (info->blocked_open) {
 		msleep_interruptible(500);
-		wake_up_interruptible(&info->open_wait);
+		wake_up_interruptible(&info->port.open_wait);
 	}
 	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
+	wake_up_interruptible(&info->port.close_wait);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_close normal exit\n");
 #endif
@@ -1720,7 +1720,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 	info->count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
-	wake_up_interruptible(&info->open_wait);
+	wake_up_interruptible(&info->port.open_wait);
 }
 
 /* This routine initializes all emulator-data.
@@ -1898,8 +1898,6 @@ isdn_tty_modem_init(void)
 		info->x_char = 0;
 		info->count = 0;
 		info->blocked_open = 0;
-		init_waitqueue_head(&info->open_wait);
-		init_waitqueue_head(&info->close_wait);
 		info->isdn_driver = -1;
 		info->isdn_channel = -1;
 		info->drv_index = -1;
@@ -2194,7 +2192,7 @@ isdn_tty_stat_callback(int i, isdn_ctrl *c)
 			 */
 			if (info->blocked_open &&
 			    (info->emu.mdmreg[REG_DCD] & BIT_DCD)) {
-				wake_up_interruptible(&info->open_wait);
+				wake_up_interruptible(&info->port.open_wait);
 			}
 
 			/* Schedule CONNECT-Message to any tty
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index bb71041..c3ddf20 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -483,7 +483,6 @@ typedef struct modem_info {
 #endif
   struct tty_struct 	*tty;            /* Pointer to corresponding tty   */
   atemu                 emu;             /* AT-emulator data               */
-  wait_queue_head_t	open_wait, close_wait;
   spinlock_t	        readlock;
 } modem_info;
 
-- 
1.7.9.2


