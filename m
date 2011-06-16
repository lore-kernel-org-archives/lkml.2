Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1FPHKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46192 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756615Ab1FPHKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:44 -0400
X-Sasl-enc: JLlPWydydD+MRWZ7svoLp6Gz1UD2SK+YruYOElEYYWOe 1308208243
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:06 2011
Message-Id: <20110616002906.899938943@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hermann Kneissel <herkne@gmx.de>
Subject: [31/85] USB: gamin_gps: Fix for data transfer problems in native
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 mode

From: Hermann Kneissel <herkne@gmx.de>

commit b4026c4584cd70858d4d3450abfb1cd0714d4f32 upstream.

This patch fixes a problem where data received from the gps is sometimes
transferred incompletely to the serial port. If used in native mode now
all data received via the bulk queue will be forwarded to the serial
port.

Signed-off-by: Hermann Kneissel <herkne@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/garmin_gps.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

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
@@ -411,6 +411,7 @@ static int gsp_send_ack(struct garmin_da
  */
 static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 {
+	unsigned long flags;
 	const __u8 *recpkt = garmin_data_p->inbuffer+GSP_INITIAL_OFFSET;
 	__le32 *usbdata = (__le32 *) garmin_data_p->inbuffer;
 
@@ -459,7 +460,9 @@ static int gsp_rec_packet(struct garmin_
 	/* if this was an abort-transfer command, flush all
 	   queued data. */
 	if (isAbortTrfCmnd(garmin_data_p->inbuffer)) {
+		spin_lock_irqsave(&garmin_data_p->lock, flags);
 		garmin_data_p->flags |= FLAGS_DROP_DATA;
+		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 		pkt_clear(garmin_data_p);
 	}
 
@@ -944,7 +947,7 @@ static int garmin_open(struct tty_struct
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
 	garmin_data_p->mode  = initial_mode;
 	garmin_data_p->count = 0;
-	garmin_data_p->flags = 0;
+	garmin_data_p->flags &= FLAGS_SESSION_REPLY1_SEEN;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 	/* shutdown any bulk reads that might be going on */
@@ -1179,7 +1182,8 @@ static int garmin_write_room(struct tty_
 
 
 static void garmin_read_process(struct garmin_data *garmin_data_p,
-				 unsigned char *data, unsigned data_length)
+				 unsigned char *data, unsigned data_length,
+				 int bulk_data)
 {
 	unsigned long flags;
 
@@ -1194,7 +1198,8 @@ static void garmin_read_process(struct g
 		   send it directly to the tty port */
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
-		} else if (getLayerId(data) == GARMIN_LAYERID_APPL) {
+		} else if (bulk_data ||
+			   getLayerId(data) == GARMIN_LAYERID_APPL) {
 
 			spin_lock_irqsave(&garmin_data_p->lock, flags);
 			garmin_data_p->flags |= APP_RESP_SEEN;
@@ -1238,7 +1243,7 @@ static void garmin_read_bulk_callback(st
 	usb_serial_debug_data(debug, &port->dev,
 				__func__, urb->actual_length, data);
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 1);
 
 	if (urb->actual_length == 0 &&
 			0 != (garmin_data_p->flags & FLAGS_BULK_IN_RESTART)) {
@@ -1348,7 +1353,7 @@ static void garmin_read_int_callback(str
 			__func__, garmin_data_p->serial_num);
 	}
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 0);
 
 	port->interrupt_in_urb->dev = port->serial->dev;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -1463,6 +1468,7 @@ static int garmin_attach(struct usb_seri
 	garmin_data_p->timer.function = timeout_handler;
 	garmin_data_p->port = port;
 	garmin_data_p->state = 0;
+	garmin_data_p->flags = 0;
 	garmin_data_p->count = 0;
 	usb_set_serial_port_data(port, garmin_data_p);
 


