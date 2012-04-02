Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2DBL5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:57:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48064 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2DBLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 16/69] TTY: isdn, use tty_port_close_end helper
Date: Mon,  2 Apr 2012 13:54:00 +0200
Message-Id: <1333367693-3244-17-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code does almost the same, so there we can leverage the helper's
code. The only difference is locking. The helper protects counts by a
spinlock. This never hurts and should be added to other code parts
too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index ee8ba87..50d7246 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1699,13 +1699,8 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 	port->tty = NULL;
 	info->ncarrier = 0;
-	tty->closing = 0;
-	if (port->blocked_open) {
-		msleep_interruptible(500);
-		wake_up_interruptible(&port->open_wait);
-	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&port->close_wait);
+
+	tty_port_close_end(port, tty);
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_close normal exit\n");
 #endif
-- 
1.7.9.2


