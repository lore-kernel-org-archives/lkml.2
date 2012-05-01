Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2EAEHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:07:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33404 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2EAEHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:07:04 -0400
From: Preston Fick <pffick@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH 2/3] usb: cp210x: Added in support to get and store part number
Date: Mon, 30 Apr 2012 23:06:49 -0500
Message-Id: <1335845210-5147-2-git-send-email-preston.fick@silabs.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change gets the part number of the device when the driver is loaded and
stores it in the private portion of the port structure. This addition will
allow for part specific functionality to be added to the driver if needed.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index e67ccf3..b3646b8 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -154,6 +154,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct cp210x_port_private {
 	__u8			bInterfaceNumber;
+	__u8			bPartNumber;
 };
 
 static struct usb_driver cp210x_driver = {
@@ -187,6 +188,13 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&cp210x_device, NULL
 };
 
+/* Part number definitions */
+#define CP2101_PARTNUM		0x01
+#define CP2102_PARTNUM		0x02
+#define CP2103_PARTNUM		0x03
+#define CP2104_PARTNUM		0x04
+#define CP2105_PARTNUM		0x05
+
 /* Config request types */
 #define REQTYPE_HOST_TO_INTERFACE	0x41
 #define REQTYPE_INTERFACE_TO_HOST	0xc1
@@ -220,11 +228,15 @@ static struct usb_serial_driver * const serial_drivers[] = {
 #define CP210X_SET_CHARS	0x19
 #define CP210X_GET_BAUDRATE	0x1D
 #define CP210X_SET_BAUDRATE	0x1E
+#define CP210X_VENDOR_SPECIFIC	0xFF
 
 /* CP210X_IFC_ENABLE */
 #define UART_ENABLE		0x0001
 #define UART_DISABLE		0x0000
 
+/* CP210X_VENDOR_SPECIFIC */
+#define CP210X_GET_PARTNUM	0x370B
+
 /* CP210X_(SET|GET)_BAUDDIV */
 #define BAUD_RATE_GEN_FREQ	0x384000
 
@@ -862,6 +874,7 @@ static int cp210x_startup(struct usb_serial *serial)
 {
 	struct cp210x_port_private *port_priv;
 	int i;
+	unsigned int partNum;
 
 	/* cp210x buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
@@ -876,6 +889,17 @@ static int cp210x_startup(struct usb_serial *serial)
 		    serial->interface->cur_altsetting->desc.bInterfaceNumber;
 
 		usb_set_serial_port_data(serial->port[i], port_priv);
+
+		/* Get the 1-byte part number of the cp210x device */
+		usb_control_msg(serial->dev,
+			usb_rcvctrlpipe(serial->dev, 0),
+			CP210X_VENDOR_SPECIFIC,
+			REQTYPE_DEVICE_TO_HOST,
+			CP210X_GET_PARTNUM,
+			port_priv->bInterfaceNumber,
+			&partNum, 1,
+			USB_CTRL_GET_TIMEOUT);
+		port_priv->bPartNumber = partNum & 0xFF;
 	}
 
 	return 0;
-- 
1.7.5.4

