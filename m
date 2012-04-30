Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2D3U10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:27:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54937 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2D3U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:27:24 -0400
From: Preston Fick <pffick@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Date: Mon, 30 Apr 2012 15:27:17 -0500
Message-Id: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix contains several changes that allow toggling of GPIO on CP210x
devices that support it. Changes include:
* Added in part number support, necessary to see if the connected device
supports the GPIO functionality
* Added two IOCTLs and ioctl function to allow GET/SET of GPIO
* Added in new #defines for partnum support, new USB requests
* Changed "Config request types" section to contain more correct definitions
for request recipient

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c |  134 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 129 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ec30f95..9d1e542 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -35,6 +35,8 @@
  */
 static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *);
 static void cp210x_close(struct usb_serial_port *);
+static int cp210x_ioctl(struct tty_struct *tty,
+	unsigned int cmd, unsigned long arg);
 static void cp210x_get_termios(struct tty_struct *,
 	struct usb_serial_port *port);
 static void cp210x_get_termios_port(struct usb_serial_port *port,
@@ -154,6 +156,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 struct cp210x_port_private {
 	__u8			bInterfaceNumber;
+	__u8			bPartNumber;
 };
 
 static struct usb_driver cp210x_driver = {
@@ -174,6 +177,7 @@ static struct usb_serial_driver cp210x_device = {
 	.bulk_out_size		= 256,
 	.open			= cp210x_open,
 	.close			= cp210x_close,
+	.ioctl			= cp210x_ioctl,
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tiocmget 		= cp210x_tiocmget,
@@ -187,9 +191,22 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&cp210x_device, NULL
 };
 
+/* Part number definitions */
+#define CP2101_PARTNUM		0x01
+#define CP2102_PARTNUM		0x02
+#define CP2103_PARTNUM		0x03
+#define CP2104_PARTNUM		0x04
+#define CP2105_PARTNUM		0x05
+
+/* IOCTLs */
+#define IOCTL_GPIOGET		0x8000
+#define IOCTL_GPIOSET		0x8001
+
 /* Config request types */
-#define REQTYPE_HOST_TO_DEVICE	0x41
-#define REQTYPE_DEVICE_TO_HOST	0xc1
+#define REQTYPE_HOST_TO_INTERFACE	0x41
+#define REQTYPE_INTERFACE_TO_HOST	0xc1
+#define REQTYPE_HOST_TO_DEVICE	0x40
+#define REQTYPE_DEVICE_TO_HOST	0xc0
 
 /* Config request codes */
 #define CP210X_IFC_ENABLE	0x00
@@ -218,11 +235,17 @@ static struct usb_serial_driver * const serial_drivers[] = {
 #define CP210X_SET_CHARS	0x19
 #define CP210X_GET_BAUDRATE	0x1D
 #define CP210X_SET_BAUDRATE	0x1E
+#define CP210X_VENDOR_SPECIFIC	0xFF
 
 /* CP210X_IFC_ENABLE */
 #define UART_ENABLE		0x0001
 #define UART_DISABLE		0x0000
 
+/* CP210X_VENDOR_SPECIFIC */
+#define CP210X_WRITE_LATCH	0x37E1
+#define CP210X_READ_LATCH	0x00C2
+#define CP210X_GET_PARTNUM	0x370B
+
 /* CP210X_(SET|GET)_BAUDDIV */
 #define BAUD_RATE_GEN_FREQ	0x384000
 
@@ -286,7 +309,7 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
 
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
+				request, REQTYPE_INTERFACE_TO_HOST, 0x0000,
 				port_priv->bInterfaceNumber, buf, size,
 				USB_CTRL_GET_TIMEOUT);
 
@@ -340,13 +363,13 @@ static int cp210x_set_config(struct usb_serial_port *port, u8 request,
 	if (size > 2) {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
+				request, REQTYPE_HOST_TO_INTERFACE, 0x0000,
 				port_priv->bInterfaceNumber, buf, size,
 				USB_CTRL_SET_TIMEOUT);
 	} else {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, data[0],
+				request, REQTYPE_HOST_TO_INTERFACE, data[0],
 				port_priv->bInterfaceNumber, NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
 	}
@@ -453,6 +476,95 @@ static void cp210x_close(struct usb_serial_port *port)
 	mutex_unlock(&port->serial->disc_mutex);
 }
 
+static int cp210x_ioctl(struct tty_struct *tty,
+	unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
+	int result = 0;
+	unsigned int latch_setting = 0;
+
+	switch (cmd) {
+
+	case IOCTL_GPIOGET:
+		if ((port_priv->bPartNumber == CP2103_PARTNUM) ||
+			(port_priv->bPartNumber == CP2104_PARTNUM)) {
+			result = usb_control_msg(port->serial->dev,
+					usb_rcvctrlpipe(port->serial->dev, 0),
+					CP210X_VENDOR_SPECIFIC,
+					REQTYPE_DEVICE_TO_HOST,
+					CP210X_READ_LATCH,
+					port_priv->bInterfaceNumber,
+					&latch_setting, 1,
+					USB_CTRL_GET_TIMEOUT);
+			if (result != 1)
+				return -EPROTO;
+			*(unsigned long *)arg = (unsigned long)latch_setting;
+			return 0;
+		} else if (port_priv->bPartNumber == CP2105_PARTNUM) {
+			result = usb_control_msg(port->serial->dev,
+					usb_rcvctrlpipe(port->serial->dev, 0),
+					CP210X_VENDOR_SPECIFIC,
+					REQTYPE_INTERFACE_TO_HOST,
+					CP210X_READ_LATCH,
+					port_priv->bInterfaceNumber,
+					&latch_setting, 1,
+					USB_CTRL_GET_TIMEOUT);
+			if (result != 1)
+				return -EPROTO;
+			*(unsigned long *)arg = (unsigned long)latch_setting;
+			return 0;
+		} else {
+			return -ENOTSUPP;
+		}
+		break;
+
+	case IOCTL_GPIOSET:
+		if ((port_priv->bPartNumber == CP2103_PARTNUM) ||
+			(port_priv->bPartNumber == CP2104_PARTNUM)) {
+			latch_setting =
+				*(unsigned int *)arg & 0x000000FF;
+			latch_setting |=
+				(*(unsigned int *)arg & 0x00FF0000) >> 8;
+			result = usb_control_msg(port->serial->dev,
+					usb_sndctrlpipe(port->serial->dev, 0),
+					CP210X_VENDOR_SPECIFIC,
+					REQTYPE_HOST_TO_DEVICE,
+					CP210X_WRITE_LATCH,
+					latch_setting,
+					NULL, 0,
+					USB_CTRL_SET_TIMEOUT);
+			if (result != 0)
+				return -EPROTO;
+			return 0;
+		} else if (port_priv->bPartNumber == CP2105_PARTNUM) {
+			latch_setting =
+				*(unsigned int *)arg & 0x000000FF;
+			latch_setting |=
+				(*(unsigned int *)arg & 0x00FF0000) >> 8;
+			result = usb_control_msg(port->serial->dev,
+					usb_sndctrlpipe(port->serial->dev, 0),
+					CP210X_VENDOR_SPECIFIC,
+					REQTYPE_HOST_TO_INTERFACE,
+					CP210X_WRITE_LATCH,
+					port_priv->bInterfaceNumber,
+					&latch_setting, 2,
+					USB_CTRL_SET_TIMEOUT);
+			if (result != 2)
+				return -EPROTO;
+			return 0;
+		} else {
+			return -ENOTSUPP;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
 /*
  * cp210x_get_termios
  * Reads the baud rate, data bits, parity, stop bits and flow control mode
@@ -860,6 +972,7 @@ static int cp210x_startup(struct usb_serial *serial)
 {
 	struct cp210x_port_private *port_priv;
 	int i;
+	unsigned int partNum;
 
 	/* cp210x buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
@@ -874,6 +987,17 @@ static int cp210x_startup(struct usb_serial *serial)
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

