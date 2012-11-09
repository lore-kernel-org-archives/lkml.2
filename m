Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2KIVeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:34:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52312 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2KIVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:34:02 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/4] staging/serqt_usb2: refactor qt_read_bulk_callback() in serqt_usb2.c
Date: Sat, 10 Nov 2012 06:33:56 +0900
Message-Id: <1352496836-7280-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified to eliminate the deep nesting and redundant description.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |  147 +++++++++++++++++--------------
 1 file changed, 80 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 9bc8923..0395bdf 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -291,22 +291,89 @@ static void qt_interrupt_callback(struct urb *urb)
 	/* FIXME */
 }
 
+static int qt_status_change(unsigned int limit,
+			    unsigned char *data,
+			    int i,
+			    struct quatech_port *qt_port,
+			    struct usb_serial_port *port)
+{
+	void (*fn)(struct quatech_port *, unsigned char);
+
+	if (0x00 == data[i + 2]) {
+		dev_dbg(&port->dev, "Line status status.\n");
+		fn = ProcessLineStatus;
+	} else {
+		dev_dbg(&port->dev, "Modem status status.\n");
+		fn = ProcessModemStatus;
+	}
+
+	if (i > limit) {
+		dev_dbg(&port->dev,
+			"Illegal escape seuences in received data\n");
+		return 0;
+	}
+
+	(*fn)(qt_port, data[i + 3]);
+
+	return 1;
+}
+
+static void qt_status_change_check(struct tty_struct *tty,
+				   struct urb *urb,
+				   struct quatech_port *qt_port,
+				   struct usb_serial_port *port)
+{
+	int flag, i;
+	unsigned char *data = urb->transfer_buffer;
+	unsigned int RxCount = urb->actual_length;
+
+	for (i = 0; i < RxCount; ++i) {
+		/* Look ahead code here */
+		if ((i <= (RxCount - 3)) && (data[i] == 0x1b)
+		    && (data[i + 1] == 0x1b)) {
+			flag = 0;
+			switch (data[i + 2]) {
+			case 0x00:
+			case 0x01:
+				flag = qt_status_change((RxCount - 4), data, i,
+							qt_port, port);
+				if (flag == 1)
+					i += 3;
+				break;
+
+			case 0xff:
+				dev_dbg(&port->dev, "No status sequence.\n");
+
+				ProcessRxChar(tty, port, data[i]);
+				ProcessRxChar(tty, port, data[i + 1]);
+
+				i += 2;
+				break;
+			}
+			if (flag == 1)
+				continue;
+		}
+
+		if (tty && urb->actual_length)
+			tty_insert_flip_char(tty, data[i], TTY_NORMAL);
+
+	}
+	tty_flip_buffer_push(tty);
+}
+
 static void qt_read_bulk_callback(struct urb *urb)
 {
 
 	struct usb_serial_port *port = urb->context;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port = qt_get_port_private(port);
-	unsigned char *data;
 	struct tty_struct *tty;
-	unsigned int index;
-	unsigned int RxCount;
-	int i, result;
-	int flag, flag_data;
+	int result;
 
 	if (urb->status) {
 		qt_port->ReadBulkStopped = 1;
-		dev_dbg(&urb->dev->dev, "%s - nonzero write bulk status received: %d\n",
+		dev_dbg(&urb->dev->dev,
+			"%s - nonzero write bulk status received: %d\n",
 			__func__, urb->status);
 		return;
 	}
@@ -315,13 +382,6 @@ static void qt_read_bulk_callback(struct urb *urb)
 	if (!tty)
 		return;
 
-	data = urb->transfer_buffer;
-
-	RxCount = urb->actual_length;
-
-	/* index = MINOR(port->tty->device) - serial->minor; */
-	index = tty->index - serial->minor;
-
 	dev_dbg(&port->dev,
 		"%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
@@ -354,62 +414,14 @@ static void qt_read_bulk_callback(struct urb *urb)
 	if (urb->status) {
 		qt_port->ReadBulkStopped = 1;
 
-		dev_dbg(&port->dev, "%s - nonzero read bulk status received: %d\n",
+		dev_dbg(&port->dev,
+			"%s - nonzero read bulk status received: %d\n",
 			__func__, urb->status);
 		goto exit;
 	}
 
-	if (RxCount) {
-		flag_data = 0;
-		for (i = 0; i < RxCount; ++i) {
-			/* Look ahead code here */
-			if ((i <= (RxCount - 3)) && (data[i] == 0x1b)
-			    && (data[i + 1] == 0x1b)) {
-				flag = 0;
-				switch (data[i + 2]) {
-				case 0x00:
-					/* line status change 4th byte must follow */
-					if (i > (RxCount - 4)) {
-						dev_dbg(&port->dev, "Illegal escape seuences in received data\n");
-						break;
-					}
-					ProcessLineStatus(qt_port, data[i + 3]);
-					i += 3;
-					flag = 1;
-					break;
-
-				case 0x01:
-					/* Modem status status change 4th byte must follow */
-					dev_dbg(&port->dev, "Modem status status.\n");
-					if (i > (RxCount - 4)) {
-						dev_dbg(&port->dev, "Illegal escape sequences in received data\n");
-						break;
-					}
-					ProcessModemStatus(qt_port,
-							   data[i + 3]);
-					i += 3;
-					flag = 1;
-					break;
-				case 0xff:
-					dev_dbg(&port->dev, "No status sequence.\n");
-
-					if (tty) {
-						ProcessRxChar(tty, port, data[i]);
-						ProcessRxChar(tty, port, data[i + 1]);
-					}
-					i += 2;
-					break;
-				}
-				if (flag == 1)
-					continue;
-			}
-
-			if (tty && urb->actual_length)
-				tty_insert_flip_char(tty, data[i], TTY_NORMAL);
-
-		}
-		tty_flip_buffer_push(tty);
-	}
+	if (urb->actual_length)
+		qt_status_change_check(tty, urb, qt_port, port);
 
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(port->read_urb, serial->dev,
@@ -420,10 +432,11 @@ static void qt_read_bulk_callback(struct urb *urb)
 			  qt_read_bulk_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (result)
-		dev_dbg(&port->dev, "%s - failed resubmitting read urb, error %d",
+		dev_dbg(&port->dev,
+			"%s - failed resubmitting read urb, error %d",
 			__func__, result);
 	else {
-		if (RxCount) {
+		if (urb->actual_length) {
 			tty_flip_buffer_push(tty);
 			tty_schedule_flip(tty);
 		}
-- 
1.7.9.5

