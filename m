Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2KIVeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:34:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2KIVee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:34:34 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/4] staging/serqt_usb2: refactor qt_unthrottle() in serqt_usb2.c
Date: Sat, 10 Nov 2012 06:34:27 +0900
Message-Id: <1352496867-7349-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified to eliminate the deep nesting.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   39 ++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 4c475ed..f68a855 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1473,12 +1473,32 @@ static void qt_throttle(struct tty_struct *tty)
 	mutex_unlock(&qt_port->lock);
 }
 
+static void qt_submit_urb_from_unthrottle(struct usb_serial_port *port,
+					  struct usb_serial *serial)
+{
+	int result;
+
+	/* Start reading from the device */
+	usb_fill_bulk_urb(port->read_urb, serial->dev,
+			  usb_rcvbulkpipe(serial->dev,
+					  port->bulk_in_endpointAddress),
+			  port->read_urb->transfer_buffer,
+			  port->read_urb->transfer_buffer_length,
+			  qt_read_bulk_callback, port);
+
+	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+
+	if (result)
+		dev_err(&port->dev,
+			"%s - failed restarting read urb, error %d\n",
+			__func__, result);
+}
+
 static void qt_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port;
-	unsigned int result;
 
 	if (!serial)
 		return;
@@ -1494,21 +1514,8 @@ static void qt_unthrottle(struct tty_struct *tty)
 		dev_dbg(&port->dev, "%s - qt_port->RxHolding = 0\n", __func__);
 
 		/* if we have a bulk endpoint, start it up */
-		if ((serial->num_bulk_in) && (qt_port->ReadBulkStopped == 1)) {
-			/* Start reading from the device */
-			usb_fill_bulk_urb(port->read_urb, serial->dev,
-					  usb_rcvbulkpipe(serial->dev,
-							  port->bulk_in_endpointAddress),
-					  port->read_urb->transfer_buffer,
-					  port->read_urb->
-					  transfer_buffer_length,
-					  qt_read_bulk_callback, port);
-			result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
-			if (result)
-				dev_err(&port->dev,
-					"%s - failed restarting read urb, error %d\n",
-					__func__, result);
-		}
+		if ((serial->num_bulk_in) && (qt_port->ReadBulkStopped == 1))
+			qt_submit_urb_from_unthrottle(port, serial);
 	}
 	mutex_unlock(&qt_port->lock);
 }
-- 
1.7.9.5

