Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2DBL4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:13 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48054 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 64/69] TTY: usb/u_serial, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:48 +0200
Message-Id: <1333367693-3244-65-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/u_serial.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index a6212ff..d038a90 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -98,7 +98,6 @@ struct gs_port {
 	spinlock_t		port_lock;	/* guard port_* access */
 
 	struct gserial		*port_usb;
-	struct tty_struct	*port_tty;
 
 	bool			openclose;	/* open/close in progress */
 	u8			port_num;
@@ -412,8 +411,8 @@ __acquires(&port->port_lock)
 			break;
 	}
 
-	if (do_tty_wake && port->port_tty)
-		tty_wakeup(port->port_tty);
+	if (do_tty_wake && port->port.tty)
+		tty_wakeup(port->port.tty);
 	return status;
 }
 
@@ -435,7 +434,7 @@ __acquires(&port->port_lock)
 		struct tty_struct	*tty;
 
 		/* no more rx if closed */
-		tty = port->port_tty;
+		tty = port->port.tty;
 		if (!tty)
 			break;
 
@@ -488,7 +487,7 @@ static void gs_rx_push(unsigned long _port)
 
 	/* hand any queued data to the tty */
 	spin_lock_irq(&port->port_lock);
-	tty = port->port_tty;
+	tty = port->port.tty;
 	while (!list_empty(queue)) {
 		struct usb_request	*req;
 
@@ -699,7 +698,7 @@ static int gs_start_io(struct gs_port *port)
 
 	/* unblock any pending writes into our circular buffer */
 	if (started) {
-		tty_wakeup(port->port_tty);
+		tty_wakeup(port->port.tty);
 	} else {
 		gs_free_requests(ep, head, &port->read_allocated);
 		gs_free_requests(port->port_usb->in, &port->write_pool,
@@ -793,7 +792,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	/* REVISIT maybe wait for "carrier detect" */
 
 	tty->driver_data = port;
-	port->port_tty = tty;
+	port->port.tty = tty;
 
 	port->port.count = 1;
 	port->openclose = false;
@@ -879,7 +878,7 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 		gs_buf_clear(&port->port_write_buf);
 
 	tty->driver_data = NULL;
-	port->port_tty = NULL;
+	port->port.tty = NULL;
 
 	port->openclose = false;
 
@@ -1318,8 +1317,8 @@ void gserial_disconnect(struct gserial *gser)
 	gser->ioport = NULL;
 	if (port->port.count > 0 || port->openclose) {
 		wake_up_interruptible(&port->drain_wait);
-		if (port->port_tty)
-			tty_hangup(port->port_tty);
+		if (port->port.tty)
+			tty_hangup(port->port.tty);
 	}
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
-- 
1.7.9.2


