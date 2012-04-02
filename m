Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2DBL4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:36 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48154 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2DBLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 57/69] TTY: 68328serial, use open/close_wait from tty_port
Date: Mon,  2 Apr 2012 13:54:41 +0200
Message-Id: <1333367693-3244-58-git-send-email-jslaby@suse.cz>
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
 drivers/tty/serial/68328serial.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 848662c..0c50f2e 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -127,8 +127,6 @@ struct m68k_serial {
 	int			xmit_head;
 	int			xmit_tail;
 	int			xmit_cnt;
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
 };
 
 #define SERIAL_MAGIC 0x5301
@@ -1083,10 +1081,10 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		if (info->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(info->close_delay));
 		}
-		wake_up_interruptible(&info->open_wait);
+		wake_up_interruptible(&port->open_wait);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
+	wake_up_interruptible(&port->close_wait);
 	local_irq_restore(flags);
 }
 
@@ -1105,7 +1103,7 @@ void rs_hangup(struct tty_struct *tty)
 	info->tport.count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
-	wake_up_interruptible(&info->open_wait);
+	wake_up_interruptible(&info->tport.open_wait);
 }
 
 /*
@@ -1126,7 +1124,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * until it's done, and then try again.
 	 */
 	if (info->flags & ASYNC_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
+		interruptible_sleep_on(&port->close_wait);
 #ifdef SERIAL_DO_RESTART
 		if (info->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
@@ -1158,7 +1156,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
-	add_wait_queue(&info->open_wait, &wait);
+	add_wait_queue(&port->open_wait, &wait);
 
 	port->count--;
 	port->blocked_open++;
@@ -1187,7 +1185,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		tty_lock();
 	}
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&info->open_wait, &wait);
+	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
 		port->count++;
 	port->blocked_open--;
@@ -1301,8 +1299,6 @@ rs68328_init(void)
 	    info->close_delay = 50;
 	    info->closing_wait = 3000;
 	    info->x_char = 0;
-	    init_waitqueue_head(&info->open_wait);
-	    init_waitqueue_head(&info->close_wait);
 	    info->line = i;
 	    info->is_cons = 1; /* Means shortcuts work */
 	    
-- 
1.7.9.2


