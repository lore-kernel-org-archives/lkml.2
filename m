Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292Ab2EOCRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:49132 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885Ab2EOCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 028/179] USB: gamin_gps: Fix for data transfer problems in native mode
Date: Mon, 14 May 2012 22:12:04 -0400
Message-ID: <1337048075-6132-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hermann Kneissel <herkne@gmx.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b4026c4584cd70858d4d3450abfb1cd0714d4f32 upstream.

This patch fixes a problem where data received from the gps is sometimes
transferred incompletely to the serial port. If used in native mode now
all data received via the bulk queue will be forwarded to the serial
port.

Signed-off-by: Hermann Kneissel <herkne@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/garmin_gps.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index a42b29a..0f0a122 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1,7 +1,7 @@
 /*
  * Garmin GPS driver
  *
- * Copyright (C) 2006-2009 Hermann Kneissel herkne@users.sourceforge.net
+ * Copyright (C) 2006-2011 Hermann Kneissel herkne@gmx.de
  *
  * The latest version of the driver can be found at
  * http://sourceforge.net/projects/garmin-gps/
@@ -51,7 +51,7 @@ static int debug;
  */
 
 #define VERSION_MAJOR	0
-#define VERSION_MINOR	33
+#define VERSION_MINOR	36
 
 #define _STR(s) #s
 #define _DRIVER_VERSION(a, b) "v" _STR(a) "." _STR(b)
@@ -410,6 +410,7 @@ static int gsp_send_ack(struct garmin_data *garmin_data_p, __u8 pkt_id)
  */
 static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 {
+	unsigned long flags;
 	const __u8 *recpkt = garmin_data_p->inbuffer+GSP_INITIAL_OFFSET;
 	__le32 *usbdata = (__le32 *) garmin_data_p->inbuffer;
 
@@ -458,7 +459,9 @@ static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 	/* if this was an abort-transfer command, flush all
 	   queued data. */
 	if (isAbortTrfCmnd(garmin_data_p->inbuffer)) {
+		spin_lock_irqsave(&garmin_data_p->lock, flags);
 		garmin_data_p->flags |= FLAGS_DROP_DATA;
+		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 		pkt_clear(garmin_data_p);
 	}
 
@@ -943,7 +946,7 @@ static int garmin_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
 	garmin_data_p->mode  = initial_mode;
 	garmin_data_p->count = 0;
-	garmin_data_p->flags = 0;
+	garmin_data_p->flags &= FLAGS_SESSION_REPLY1_SEEN;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 	/* shutdown any bulk reads that might be going on */
@@ -1178,7 +1181,8 @@ static int garmin_write_room(struct tty_struct *tty)
 
 
 static void garmin_read_process(struct garmin_data *garmin_data_p,
-				 unsigned char *data, unsigned data_length)
+				 unsigned char *data, unsigned data_length,
+				 int bulk_data)
 {
 	unsigned long flags;
 
@@ -1193,7 +1197,8 @@ static void garmin_read_process(struct garmin_data *garmin_data_p,
 		   send it directly to the tty port */
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
-		} else if (getLayerId(data) == GARMIN_LAYERID_APPL) {
+		} else if (bulk_data ||
+			   getLayerId(data) == GARMIN_LAYERID_APPL) {
 
 			spin_lock_irqsave(&garmin_data_p->lock, flags);
 			garmin_data_p->flags |= APP_RESP_SEEN;
@@ -1237,7 +1242,7 @@ static void garmin_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev,
 				__func__, urb->actual_length, data);
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 1);
 
 	if (urb->actual_length == 0 &&
 			0 != (garmin_data_p->flags & FLAGS_BULK_IN_RESTART)) {
@@ -1347,7 +1352,7 @@ static void garmin_read_int_callback(struct urb *urb)
 			__func__, garmin_data_p->serial_num);
 	}
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 0);
 
 	port->interrupt_in_urb->dev = port->serial->dev;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -1462,6 +1467,7 @@ static int garmin_attach(struct usb_serial *serial)
 	garmin_data_p->timer.function = timeout_handler;
 	garmin_data_p->port = port;
 	garmin_data_p->state = 0;
+	garmin_data_p->flags = 0;
 	garmin_data_p->count = 0;
 	usb_set_serial_port_data(port, garmin_data_p);
 
-- 
1.7.9.6

