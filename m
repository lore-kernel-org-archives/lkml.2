Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2KIVeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:34:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2KIVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:34:18 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/4] staging/serqt_usb2: refactor qt_open() in serqt_usb2.c
Date: Sat, 10 Nov 2012 06:34:11 +0900
Message-Id: <1352496851-7314-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified to eliminate the deep nesting.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   51 ++++++++++++++++---------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0395bdf..4c475ed 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -840,6 +840,31 @@ static void qt_release(struct usb_serial *serial)
 
 }
 
+static void qt_submit_urb_from_open(struct usb_serial *serial,
+				    struct usb_serial_port *port)
+{
+	int result;
+	struct usb_serial_port *port0 = serial->port[0];
+
+	/* set up interrupt urb */
+	usb_fill_int_urb(port0->interrupt_in_urb,
+			 serial->dev,
+			 usb_rcvintpipe(serial->dev,
+					port0->interrupt_in_endpointAddress),
+			 port0->interrupt_in_buffer,
+			 port0->interrupt_in_urb->transfer_buffer_length,
+			 qt_interrupt_callback, serial,
+			 port0->interrupt_in_urb->interval);
+
+	result = usb_submit_urb(port0->interrupt_in_urb,
+				GFP_KERNEL);
+	if (result) {
+		dev_err(&port->dev,
+			"%s - Error %d submitting interrupt urb\n",
+			__func__, result);
+	}
+}
+
 static int qt_open(struct tty_struct *tty,
 		   struct usb_serial_port *port)
 {
@@ -900,30 +925,8 @@ static int qt_open(struct tty_struct *tty,
 
 	/*  Check to see if we've set up our endpoint info yet */
 	if (port0->open_ports == 1) {
-		if (serial->port[0]->interrupt_in_buffer == NULL) {
-			/* set up interrupt urb */
-			usb_fill_int_urb(serial->port[0]->interrupt_in_urb,
-					 serial->dev,
-					 usb_rcvintpipe(serial->dev,
-							serial->port[0]->interrupt_in_endpointAddress),
-					 serial->port[0]->interrupt_in_buffer,
-					 serial->port[0]->
-					 interrupt_in_urb->transfer_buffer_length,
-					 qt_interrupt_callback, serial,
-					 serial->port[0]->
-					 interrupt_in_urb->interval);
-
-			result =
-			    usb_submit_urb(serial->port[0]->interrupt_in_urb,
-					   GFP_KERNEL);
-			if (result) {
-				dev_err(&port->dev,
-					"%s - Error %d submitting "
-					"interrupt urb\n", __func__, result);
-			}
-
-		}
-
+		if (serial->port[0]->interrupt_in_buffer == NULL)
+			qt_submit_urb_from_open(serial, port);
 	}
 
 	dev_dbg(&port->dev, "port number is %d\n", port->number);
-- 
1.7.9.5

