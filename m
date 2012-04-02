Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2DBL4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:11 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48060 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2DBLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 63/69] TTY: usb/u_serial, add tty_port
Date: Mon,  2 Apr 2012 13:54:47 +0200
Message-Id: <1333367693-3244-64-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use count from there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/u_serial.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 6c23938..a6212ff 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -94,12 +94,12 @@ struct gs_buf {
  * (and thus for each /dev/ node).
  */
 struct gs_port {
+	struct tty_port		port;
 	spinlock_t		port_lock;	/* guard port_* access */
 
 	struct gserial		*port_usb;
 	struct tty_struct	*port_tty;
 
-	unsigned		open_count;
 	bool			openclose;	/* open/close in progress */
 	u8			port_num;
 
@@ -734,9 +734,9 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 			spin_lock_irq(&port->port_lock);
 
 			/* already open?  Great. */
-			if (port->open_count) {
+			if (port->port.count) {
 				status = 0;
-				port->open_count++;
+				port->port.count++;
 
 			/* currently opening/closing? wait ... */
 			} else if (port->openclose) {
@@ -795,7 +795,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	tty->driver_data = port;
 	port->port_tty = tty;
 
-	port->open_count = 1;
+	port->port.count = 1;
 	port->openclose = false;
 
 	/* if connected, start the I/O stream */
@@ -837,11 +837,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	spin_lock_irq(&port->port_lock);
 
-	if (port->open_count != 1) {
-		if (port->open_count == 0)
+	if (port->port.count != 1) {
+		if (port->port.count == 0)
 			WARN_ON(1);
 		else
-			--port->open_count;
+			--port->port.count;
 		goto exit;
 	}
 
@@ -851,7 +851,7 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	 * and sleep if necessary
 	 */
 	port->openclose = true;
-	port->open_count = 0;
+	port->port.count = 0;
 
 	gser = port->port_usb;
 	if (gser && gser->disconnect)
@@ -1034,6 +1034,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 	if (port == NULL)
 		return -ENOMEM;
 
+	tty_port_init(&port->port);
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->close_wait);
 	init_waitqueue_head(&port->drain_wait);
@@ -1155,7 +1156,7 @@ static int gs_closed(struct gs_port *port)
 	int cond;
 
 	spin_lock_irq(&port->port_lock);
-	cond = (port->open_count == 0) && !port->openclose;
+	cond = (port->port.count == 0) && !port->openclose;
 	spin_unlock_irq(&port->port_lock);
 	return cond;
 }
@@ -1268,7 +1269,7 @@ int gserial_connect(struct gserial *gser, u8 port_num)
 	/* if it's already open, start I/O ... and notify the serial
 	 * protocol about open/close status (connect/disconnect).
 	 */
-	if (port->open_count) {
+	if (port->port.count) {
 		pr_debug("gserial_connect: start ttyGS%d\n", port->port_num);
 		gs_start_io(port);
 		if (gser->connect)
@@ -1315,7 +1316,7 @@ void gserial_disconnect(struct gserial *gser)
 
 	port->port_usb = NULL;
 	gser->ioport = NULL;
-	if (port->open_count > 0 || port->openclose) {
+	if (port->port.count > 0 || port->openclose) {
 		wake_up_interruptible(&port->drain_wait);
 		if (port->port_tty)
 			tty_hangup(port->port_tty);
@@ -1331,7 +1332,7 @@ void gserial_disconnect(struct gserial *gser)
 
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
-	if (port->open_count == 0 && !port->openclose)
+	if (port->port.count == 0 && !port->openclose)
 		gs_buf_free(&port->port_write_buf);
 	gs_free_requests(gser->out, &port->read_pool, NULL);
 	gs_free_requests(gser->out, &port->read_queue, NULL);
-- 
1.7.9.2


