Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab0HJWAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:01 -0400
Received: from kroah.org ([198.145.64.141]:44844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab0HJV7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/68] cyclades: Kill off BKL usage
Date: Tue, 10 Aug 2010 14:58:41 -0700
Message-Id: <1281477570-18944-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Use the port mutext for config setting, the rest is locked sufficiently
anyway that the BKL makes no odds.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9824b41..51acfe3 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -65,7 +65,6 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
-#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
@@ -1655,7 +1654,6 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 		return;		/* Just in case.... */
 
 	orig_jiffies = jiffies;
-	lock_kernel();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1702,7 +1700,6 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
-	unlock_kernel();
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
 #endif
@@ -1959,7 +1956,6 @@ static int cy_chars_in_buffer(struct tty_struct *tty)
 		int char_count;
 		__u32 tx_put, tx_get, tx_bufsize;
 
-		lock_kernel();
 		tx_get = readl(&buf_ctrl->tx_get);
 		tx_put = readl(&buf_ctrl->tx_put);
 		tx_bufsize = readl(&buf_ctrl->tx_bufsize);
@@ -1971,7 +1967,6 @@ static int cy_chars_in_buffer(struct tty_struct *tty)
 		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
 			info->line, info->xmit_cnt + char_count);
 #endif
-		unlock_kernel();
 		return info->xmit_cnt + char_count;
 	}
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
@@ -2359,17 +2354,22 @@ cy_set_serial_info(struct cyclades_port *info, struct tty_struct *tty,
 		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
+	int ret;
 
 	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
+	mutex_lock(&info->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (new_serial.close_delay != info->port.close_delay ||
 				new_serial.baud_base != info->baud ||
 				(new_serial.flags & ASYNC_FLAGS &
 					~ASYNC_USR_MASK) !=
 				(info->port.flags & ASYNC_FLAGS & ~ASYNC_USR_MASK))
+		{
+			mutex_unlock(&info->port.mutex);
 			return -EPERM;
+		}
 		info->port.flags = (info->port.flags & ~ASYNC_USR_MASK) |
 				(new_serial.flags & ASYNC_USR_MASK);
 		info->baud = new_serial.baud_base;
@@ -2392,10 +2392,12 @@ cy_set_serial_info(struct cyclades_port *info, struct tty_struct *tty,
 check_and_exit:
 	if (info->port.flags & ASYNC_INITIALIZED) {
 		cy_set_line_char(info, tty);
-		return 0;
+		ret = 0;
 	} else {
-		return cy_startup(info, tty);
+		ret = cy_startup(info, tty);
 	}
+	mutex_unlock(&info->port.mutex);
+	return ret;
 }				/* set_serial_info */
 
 /*
@@ -2438,7 +2440,6 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 
 	card = info->card;
 
-	lock_kernel();
 	if (!cy_is_Z(card)) {
 		unsigned long flags;
 		int channel = info->line - card->first_line;
@@ -2478,7 +2479,6 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 			((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
 	}
 end:
-	unlock_kernel();
 	return result;
 }				/* cy_tiomget */
 
@@ -2696,7 +2696,6 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
 		info->line, cmd, arg);
 #endif
-	lock_kernel();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -2817,7 +2816,6 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
 
 #ifdef CY_DEBUG_OTHER
 	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
-- 
1.7.2

