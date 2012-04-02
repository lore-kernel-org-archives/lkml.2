Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2DBL4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48051 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 07/69] TTY: isdn, do not play with module refcounts
Date: Mon,  2 Apr 2012 13:53:51 +0200
Message-Id: <1333367693-3244-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module which called allocate_tty_driver is already refcounted by
the TTY layer automatically. And since THIS_MODULE is isdn_tty and it
allocated the tty_driver, there is no need to do the counts in isdn's
tty->ops->open/close.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   11 -----------
 include/linux/isdn.h        |    1 -
 2 files changed, 12 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index bcf4bbe..1ff3072 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1584,10 +1584,6 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 	info = &dev->mdm.info[tty->index];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
 		return -ENODEV;
-	if (!try_module_get(info->owner)) {
-		printk(KERN_WARNING "%s: cannot reserve module\n", __func__);
-		return -ENODEV;
-	}
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_open %s, count = %d\n", tty->name,
 	       info->count);
@@ -1603,7 +1599,6 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_open return after startup\n");
 #endif
-		module_put(info->owner);
 		return retval;
 	}
 	retval = isdn_tty_block_til_ready(tty, filp, info);
@@ -1611,7 +1606,6 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_open return after isdn_tty_block_til_ready \n");
 #endif
-		module_put(info->owner);
 		return retval;
 	}
 #ifdef ISDN_DEBUG_MODEM_OPEN
@@ -1659,7 +1653,6 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_close after info->count != 0\n");
 #endif
-		module_put(info->owner);
 		return;
 	}
 	info->flags |= ASYNC_CLOSING;
@@ -1692,7 +1685,6 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	info->tty = NULL;
 	info->ncarrier = 0;
 	tty->closing = 0;
-	module_put(info->owner);
 	if (info->blocked_open) {
 		msleep_interruptible(500);
 		wake_up_interruptible(&info->open_wait);
@@ -1880,9 +1872,6 @@ isdn_tty_modem_init(void)
 			goto err_unregister;
 		}
 #endif
-#ifdef MODULE
-		info->owner = THIS_MODULE;
-#endif
 		spin_lock_init(&info->readlock);
 		sprintf(info->last_cause, "0000");
 		sprintf(info->last_num, "none");
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 1b4b4c1..66d9d71 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -435,7 +435,6 @@ typedef struct atemu {
 /* Private data (similar to async_struct in <linux/serial.h>) */
 typedef struct modem_info {
   int			magic;
-  struct module		*owner;
   int			flags;		 /* defined in tty.h               */
   int			x_char;		 /* xon/xoff character             */
   int			mcr;		 /* Modem control register         */
-- 
1.7.9.2


