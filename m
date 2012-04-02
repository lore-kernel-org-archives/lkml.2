Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2DBLzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:03 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47934 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 05/69] TTY: isdn, remove callout
Date: Mon,  2 Apr 2012 13:53:49 +0200
Message-Id: <1333367693-3244-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder how this survived there during the whole 2.6 series until now
:D.

Callouts are not used for a decade, so let us remove it also from
isdn. This means removal of ISDN_ASYNC_CALLOUT_ACTIVE which is never
raised in info->flags and callout_termios which are never used.

This will help us to get rid of ISDN_ASYNC_* flags and use ASYNC ones
from serial.h. And then we will switch to tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   32 ++++++--------------------------
 include/linux/isdn.h        |    3 ---
 2 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 1d701cd..27f7092 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1504,18 +1504,11 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		if (info->flags & ISDN_ASYNC_CALLOUT_ACTIVE)
-			return -EBUSY;
 		info->flags |= ISDN_ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
-	if (info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) {
-		if (info->normal_termios.c_cflag & CLOCAL)
-			do_clocal = 1;
-	} else {
-		if (tty->termios->c_cflag & CLOCAL)
-			do_clocal = 1;
-	}
+	if (tty->termios->c_cflag & CLOCAL)
+		do_clocal = 1;
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
@@ -1546,8 +1539,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 #endif
 			break;
 		}
-		if (!(info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
-		    !(info->flags & ISDN_ASYNC_CLOSING) &&
+		if (!(info->flags & ISDN_ASYNC_CLOSING) &&
 		    (do_clocal || (info->msr & UART_MSR_DCD))) {
 			break;
 		}
@@ -1670,14 +1662,6 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		return;
 	}
 	info->flags |= ISDN_ASYNC_CLOSING;
-	/*
-	 * Save the termios structure, since this port may have
-	 * separate termios for callout and dialin.
-	 */
-	if (info->flags & ISDN_ASYNC_NORMAL_ACTIVE)
-		info->normal_termios = *tty->termios;
-	if (info->flags & ISDN_ASYNC_CALLOUT_ACTIVE)
-		info->callout_termios = *tty->termios;
 
 	tty->closing = 1;
 	/*
@@ -1731,7 +1715,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 		return;
 	isdn_tty_shutdown(info);
 	info->count = 0;
-	info->flags &= ~(ISDN_ASYNC_NORMAL_ACTIVE | ISDN_ASYNC_CALLOUT_ACTIVE);
+	info->flags &= ~ISDN_ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 	wake_up_interruptible(&info->open_wait);
 }
@@ -2116,8 +2100,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 	return (wret == 2) ? 3 : 0;
 }
 
-#define TTY_IS_ACTIVE(info)						\
-	(info->flags & (ISDN_ASYNC_NORMAL_ACTIVE | ISDN_ASYNC_CALLOUT_ACTIVE))
+#define TTY_IS_ACTIVE(info)	(info->flags & ISDN_ASYNC_NORMAL_ACTIVE)
 
 int
 isdn_tty_stat_callback(int i, isdn_ctrl *c)
@@ -2628,11 +2611,8 @@ isdn_tty_modem_result(int code, modem_info *info)
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
-		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
-		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
-		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
+		if (info->flags & ISDN_ASYNC_CHECK_CD)
 			tty_hangup(info->tty);
-		}
 	}
 }
 
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 292f27a..d13b76d 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -393,7 +393,6 @@ typedef struct isdn_net_dev_s {
 
 #define ISDN_ASYNC_MAGIC          0x49344C01 /* for paranoia-checking        */
 #define ISDN_ASYNC_INITIALIZED	  0x80000000 /* port was initialized         */
-#define ISDN_ASYNC_CALLOUT_ACTIVE 0x40000000 /* Call out device active       */
 #define ISDN_ASYNC_NORMAL_ACTIVE  0x20000000 /* Normal device active         */
 #define ISDN_ASYNC_CLOSING	  0x08000000 /* Serial port is closing       */
 #define ISDN_ASYNC_CTS_FLOW	  0x04000000 /* Do CTS flow control          */
@@ -498,8 +497,6 @@ typedef struct modem_info {
 #endif
   struct tty_struct 	*tty;            /* Pointer to corresponding tty   */
   atemu                 emu;             /* AT-emulator data               */
-  struct ktermios	normal_termios;  /* For saving termios structs     */
-  struct ktermios	callout_termios;
   wait_queue_head_t	open_wait, close_wait;
   spinlock_t	        readlock;
 } modem_info;
-- 
1.7.9.2


