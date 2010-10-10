Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0JJGsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 02:48:08 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:41977 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0JJGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 02:48:05 -0400
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH 2/3] Add Opticon OPN2001 write support
Date: Sun, 10 Oct 2010 08:32:19 +0200
Message-id: <1286692340-18639-3-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.6.3.3
In-reply-to: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPN2001 expects write operations to arrive as a vendor-specific command
through the control pipe (instead of using a separate bulk-out pipe).

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
---
 drivers/usb/serial/opticon.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 9ff19c8..4fe7c3d 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -187,6 +187,9 @@ static void opticon_write_bulk_callback(struct urb *urb)
 	/* free up the transfer buffer, as usb_free_urb() does not do this */
 	kfree(urb->transfer_buffer);
 
+	/* setup packet may be set if we're using it for writing */
+	kfree(urb->setup_packet);
+
 	if (status)
 		dbg("%s - nonzero write bulk status received: %d",
 		    __func__, status);
@@ -237,10 +240,29 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	usb_serial_debug_data(debug, &port->dev, __func__, count, buffer);
 
-	usb_fill_bulk_urb(urb, serial->dev,
-			  usb_sndbulkpipe(serial->dev,
-					  port->bulk_out_endpointAddress),
-			  buffer, count, opticon_write_bulk_callback, priv);
+	if (port->bulk_out_endpointAddress) {
+		usb_fill_bulk_urb(urb, serial->dev,
+				  usb_sndbulkpipe(serial->dev,
+						  port->bulk_out_endpointAddress),
+				  buffer, count, opticon_write_bulk_callback, priv);
+	} else {
+		struct usb_ctrlrequest *dr;
+
+		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+		if (!dr)
+			return -ENOMEM;
+
+		dr->bRequestType = USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT;
+		dr->bRequest = 0x01;
+		dr->wValue = 0;
+		dr->wIndex = 0;
+		dr->wLength = cpu_to_le16(count);
+
+		usb_fill_control_urb(urb, serial->dev,
+			usb_sndctrlpipe(serial->dev, 0),
+			(unsigned char *)dr, buffer, count,
+			opticon_write_bulk_callback, priv);
+	}
 
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
-- 
1.6.3.3

