Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2DBLz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48057 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 65/69] TTY: usb/u_serial use close_wait from tty_port
Date: Mon,  2 Apr 2012 13:54:49 +0200
Message-Id: <1333367693-3244-66-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/u_serial.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index d038a90..71ecae7 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -102,8 +102,6 @@ struct gs_port {
 	bool			openclose;	/* open/close in progress */
 	u8			port_num;
 
-	wait_queue_head_t	close_wait;	/* wait for last close */
-
 	struct list_head	read_pool;
 	int read_started;
 	int read_allocated;
@@ -885,7 +883,7 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	pr_debug("gs_close: ttyGS%d (%p,%p) done!\n",
 			port->port_num, tty, file);
 
-	wake_up_interruptible(&port->close_wait);
+	wake_up_interruptible(&port->port.close_wait);
 exit:
 	spin_unlock_irq(&port->port_lock);
 }
@@ -1035,7 +1033,6 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 
 	tty_port_init(&port->port);
 	spin_lock_init(&port->port_lock);
-	init_waitqueue_head(&port->close_wait);
 	init_waitqueue_head(&port->drain_wait);
 
 	tasklet_init(&port->push, gs_rx_push, (unsigned long) port);
@@ -1194,7 +1191,7 @@ void gserial_cleanup(void)
 		tasklet_kill(&port->push);
 
 		/* wait for old opens to finish */
-		wait_event(port->close_wait, gs_closed(port));
+		wait_event(port->port.close_wait, gs_closed(port));
 
 		WARN_ON(port->port_usb != NULL);
 
-- 
1.7.9.2


