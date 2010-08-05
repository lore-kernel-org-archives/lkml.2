Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab0HEWq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:46:29 -0400
Received: from kroah.org ([198.145.64.141]:37603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0HEWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/67] rocket: kill BKL
Date: Thu,  5 Aug 2010 15:22:44 -0700
Message-Id: <1281047014-23429-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We can use the port mutex for this and also for the hangup path so removing
the problematic use of the hangup mutex in this driver. Fix up the locking
on the various port flags while we are at it.

Ultimately this driver needs to be using tty_port_ helpers which would sort
this out far better.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/rocket.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 0e29a23..79c3bc6 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -73,7 +73,6 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
@@ -1017,6 +1016,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
 
+	mutex_lock(&port->mutex);
 	cp = &info->channel;
 	/*
 	 * Before we drop DTR, make sure the UART transmitter
@@ -1060,9 +1060,13 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 			info->xmit_buf = NULL;
 		}
 	}
+	spin_lock_irq(&port->lock);
 	info->port.flags &= ~(ASYNC_INITIALIZED | ASYNC_CLOSING | ASYNC_NORMAL_ACTIVE);
 	tty->closing = 0;
+	spin_unlock_irq(&port->lock);
+	mutex_unlock(&port->mutex);
 	tty_port_tty_set(port, NULL);
+
 	wake_up_interruptible(&port->close_wait);
 	complete_all(&info->close_wait);
 	atomic_dec(&rp_num_ports_open);
@@ -1210,11 +1214,13 @@ static int get_config(struct r_port *info, struct rocket_config __user *retinfo)
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof (tmp));
+	mutex_lock(&info->port.mutex);
 	tmp.line = info->line;
 	tmp.flags = info->flags;
 	tmp.close_delay = info->port.close_delay;
 	tmp.closing_wait = info->port.closing_wait;
 	tmp.port = rcktpt_io_addr[(info->line >> 5) & 3];
+	mutex_unlock(&info->port.mutex);
 
 	if (copy_to_user(retinfo, &tmp, sizeof (*retinfo)))
 		return -EFAULT;
@@ -1229,10 +1235,13 @@ static int set_config(struct tty_struct *tty, struct r_port *info,
 	if (copy_from_user(&new_serial, new_info, sizeof (new_serial)))
 		return -EFAULT;
 
+	mutex_lock(&info->port.mutex);
 	if (!capable(CAP_SYS_ADMIN))
 	{
-		if ((new_serial.flags & ~ROCKET_USR_MASK) != (info->flags & ~ROCKET_USR_MASK))
+		if ((new_serial.flags & ~ROCKET_USR_MASK) != (info->flags & ~ROCKET_USR_MASK)) {
+			mutex_unlock(&info->port.mutex);
 			return -EPERM;
+		}
 		info->flags = ((info->flags & ~ROCKET_USR_MASK) | (new_serial.flags & ROCKET_USR_MASK));
 		configure_r_port(tty, info, NULL);
 		return 0;
@@ -1250,6 +1259,7 @@ static int set_config(struct tty_struct *tty, struct r_port *info,
 		tty->alt_speed = 230400;
 	if ((info->flags & ROCKET_SPD_MASK) == ROCKET_SPD_WARP)
 		tty->alt_speed = 460800;
+	mutex_unlock(&info->port.mutex);
 
 	configure_r_port(tty, info, NULL);
 	return 0;
@@ -1325,8 +1335,6 @@ static int rp_ioctl(struct tty_struct *tty, struct file *file,
 	if (cmd != RCKP_GET_PORTS && rocket_paranoia_check(info, "rp_ioctl"))
 		return -ENXIO;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case RCKP_GET_STRUCT:
 		if (copy_to_user(argp, info, sizeof (struct r_port)))
@@ -1350,7 +1358,6 @@ static int rp_ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
 	return ret;
 }
 
@@ -1471,7 +1478,6 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 	       jiffies);
 	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif
-	lock_kernel();
 	while (1) {
 		txcnt = sGetTxCnt(cp);
 		if (!txcnt) {
@@ -1499,7 +1505,6 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	unlock_kernel();
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
@@ -1512,6 +1517,7 @@ static void rp_hangup(struct tty_struct *tty)
 {
 	CHANNEL_t *cp;
 	struct r_port *info = tty->driver_data;
+	unsigned long flags;
 
 	if (rocket_paranoia_check(info, "rp_hangup"))
 		return;
@@ -1520,11 +1526,15 @@ static void rp_hangup(struct tty_struct *tty)
 	printk(KERN_INFO "rp_hangup of ttyR%d...\n", info->line);
 #endif
 	rp_flush_buffer(tty);
-	if (info->port.flags & ASYNC_CLOSING)
+	spin_lock_irqsave(&info->port.lock, flags);
+	if (info->port.flags & ASYNC_CLOSING) {
+		spin_unlock_irqrestore(&info->port.lock, flags);
 		return;
+	}
 	if (info->port.count)
 		atomic_dec(&rp_num_ports_open);
 	clear_bit((info->aiop * 8) + info->chan, (void *) &xmit_flags[info->board]);
+	spin_unlock_irqrestore(&info->port.lock, flags);
 
 	tty_port_hangup(&info->port);
 
@@ -1535,7 +1545,7 @@ static void rp_hangup(struct tty_struct *tty)
 	sDisCTSFlowCtl(cp);
 	sDisTxSoftFlowCtl(cp);
 	sClrTxXOFF(cp);
-	info->port.flags &= ~ASYNC_INITIALIZED;
+	clear_bit(ASYNCB_INITIALIZED, &info->port.flags);
 
 	wake_up_interruptible(&info->port.open_wait);
 }
-- 
1.7.2

