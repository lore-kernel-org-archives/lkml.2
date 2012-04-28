Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2D1Qzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 12:55:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41636 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2D1Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 12:55:45 -0400
From: Preston Fick <pffick@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Date: Sat, 28 Apr 2012 11:55:34 -0500
Message-Id: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix contains several changes that allow toggling of GPIO on CP210x
devices that support it. Changes inclue:
* Added in part number support, necessary to see if the connected device
supports the GPIO functionality
* Added two IOCTLs and ioctl function to allow GET/SET of GPIO
* Modified cp210x_get/set_config functions to allow for both interface and
device requests (also modified all calling functions)
* Removed cp210x_set_config_single since the new cp210x_set_config allows for
variable length requests to be sent
* Added in new #defines for partnum support, new USB requests and changed
"Config request types" section to contain more correct definitions

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c |  239 ++++++++++++++++++++++++++++++-------------
 1 files changed, 170 insertions(+), 69 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ec30f95..188eb78 100644
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
 
@@ -267,8 +290,8 @@ static struct usb_serial_driver * const serial_drivers[] = {
  * 'data' is a pointer to a pre-allocated array of integers large
  * enough to hold 'size' bytes (with 4 bytes to each integer)
  */
-static int cp210x_get_config(struct usb_serial_port *port, u8 request,
-		unsigned int *data, int size)
+static int cp210x_get_config(struct usb_serial_port *port, u8 requestType,
+		u8 request, int value, unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
 	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
@@ -286,7 +309,7 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
 
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
+				request, requestType, value,
 				port_priv->bInterfaceNumber, buf, size,
 				USB_CTRL_GET_TIMEOUT);
 
@@ -315,45 +338,39 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
  * Values less than 16 bits wide are sent directly
  * 'size' is specified in bytes.
  */
-static int cp210x_set_config(struct usb_serial_port *port, u8 request,
-		unsigned int *data, int size)
+static int cp210x_set_config(struct usb_serial_port *port, u8 requestType,
+		u8 request, int value, unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
 	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
-	__le32 *buf;
-	int result, i, length;
+	__le32 *buf = NULL;
+	int result, i, length = 0;
 
-	/* Number of integers required to contain the array */
-	length = (((size - 1) | 3) + 1)/4;
-
-	buf = kmalloc(length * sizeof(__le32), GFP_KERNEL);
-	if (!buf) {
-		dev_err(&port->dev, "%s - out of memory.\n",
-				__func__);
-		return -ENOMEM;
-	}
+	if (size) {
+		/* Number of integers required to contain the array */
+		length = (((size - 1) | 3) + 1)/4;
 
-	/* Array of integers into bytes */
-	for (i = 0; i < length; i++)
-		buf[i] = cpu_to_le32(data[i]);
+		buf = kmalloc(length * sizeof(__le32), GFP_KERNEL);
+		if (!buf) {
+			dev_err(&port->dev, "%s - out of memory.\n",
+					__func__);
+			return -ENOMEM;
+		}
 
-	if (size > 2) {
-		result = usb_control_msg(serial->dev,
-				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
-				port_priv->bInterfaceNumber, buf, size,
-				USB_CTRL_SET_TIMEOUT);
-	} else {
-		result = usb_control_msg(serial->dev,
-				usb_sndctrlpipe(serial->dev, 0),
-				request, REQTYPE_HOST_TO_DEVICE, data[0],
-				port_priv->bInterfaceNumber, NULL, 0,
-				USB_CTRL_SET_TIMEOUT);
+		/* Array of integers into bytes */
+		for (i = 0; i < length; i++)
+			buf[i] = cpu_to_le32(data[i]);
 	}
 
+	result = usb_control_msg(serial->dev,
+			usb_sndctrlpipe(serial->dev, 0),
+			request, requestType, value,
+			port_priv->bInterfaceNumber, buf, size,
+			USB_CTRL_SET_TIMEOUT);
+
 	kfree(buf);
 
-	if ((size > 2 && result != size) || result < 0) {
+	if (result != size) {
 		dbg("%s - Unable to send request, "
 				"request=0x%x size=%d result=%d",
 				__func__, request, size, result);
@@ -367,17 +384,6 @@ static int cp210x_set_config(struct usb_serial_port *port, u8 request,
 }
 
 /*
- * cp210x_set_config_single
- * Convenience function for calling cp210x_set_config on single data values
- * without requiring an integer pointer
- */
-static inline int cp210x_set_config_single(struct usb_serial_port *port,
-		u8 request, unsigned int data)
-{
-	return cp210x_set_config(port, request, &data, 2);
-}
-
-/*
  * cp210x_quantise_baudrate
  * Quantises the baud rate as per AN205 Table 1
  */
@@ -424,8 +430,8 @@ static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	result = cp210x_set_config_single(port, CP210X_IFC_ENABLE,
-								UART_ENABLE);
+	result = cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_IFC_ENABLE, UART_ENABLE, NULL, 0);
 	if (result) {
 		dev_err(&port->dev, "%s - Unable to enable UART\n", __func__);
 		return result;
@@ -449,10 +455,79 @@ static void cp210x_close(struct usb_serial_port *port)
 
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected)
-		cp210x_set_config_single(port, CP210X_IFC_ENABLE, UART_DISABLE);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_IFC_ENABLE, UART_DISABLE, NULL, 0);
 	mutex_unlock(&port->serial->disc_mutex);
 }
 
+static int cp210x_ioctl(struct tty_struct *tty,
+	unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
+	int result = 0;
+	unsigned int latch_mask_setting_to_write = 0;
+
+	switch (cmd) {
+
+	case IOCTL_GPIOGET:
+		if ((port_priv->bPartNumber == CP2103_PARTNUM) ||
+			(port_priv->bPartNumber == CP2104_PARTNUM)) {
+			return cp210x_get_config(port, REQTYPE_DEVICE_TO_HOST,
+						CP210X_VENDOR_SPECIFIC,
+						CP210X_READ_LATCH,
+						(unsigned int *)arg, 1);
+		} else if (port_priv->bPartNumber == CP2105_PARTNUM) {
+			return cp210x_get_config(port,
+						REQTYPE_INTERFACE_TO_HOST,
+						CP210X_VENDOR_SPECIFIC,
+						CP210X_READ_LATCH,
+						(unsigned int *)arg, 1);
+		} else {
+			return -ENOTSUPP;
+		}
+		break;
+
+	case IOCTL_GPIOSET:
+		if ((port_priv->bPartNumber == CP2103_PARTNUM) ||
+			(port_priv->bPartNumber == CP2104_PARTNUM)) {
+			latch_mask_setting_to_write =
+				*(unsigned int *)arg & 0x000000FF;
+			latch_mask_setting_to_write |=
+				(*(unsigned int *)arg & 0x00FF0000) >> 8;
+			result = usb_control_msg(port->serial->dev,
+					usb_sndctrlpipe(port->serial->dev, 0),
+					CP210X_VENDOR_SPECIFIC,
+					REQTYPE_HOST_TO_DEVICE,
+					CP210X_WRITE_LATCH,
+					latch_mask_setting_to_write,
+					NULL, 0, USB_CTRL_SET_TIMEOUT);
+			if (result != 0)
+				return -EPROTO;
+
+			return 0;
+		} else if (port_priv->bPartNumber == CP2105_PARTNUM) {
+			latch_mask_setting_to_write =
+				*(unsigned int *)arg & 0x000000FF;
+			latch_mask_setting_to_write |=
+				(*(unsigned int *)arg & 0x00FF0000) >> 8;
+			return cp210x_set_config(port,
+					REQTYPE_HOST_TO_INTERFACE,
+					CP210X_VENDOR_SPECIFIC,
+					CP210X_WRITE_LATCH,
+					&latch_mask_setting_to_write, 2);
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
@@ -490,14 +565,16 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 
 	dbg("%s - port %d", __func__, port->number);
 
-	cp210x_get_config(port, CP210X_GET_BAUDRATE, &baud, 4);
+	cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+			CP210X_GET_BAUDRATE, 0, &baud, 4);
 
 	dbg("%s - baud rate = %d", __func__, baud);
 	*baudp = baud;
 
 	cflag = *cflagp;
 
-	cp210x_get_config(port, CP210X_GET_LINE_CTL, &bits, 2);
+	cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+			CP210X_GET_LINE_CTL, 0, &bits, 2);
 	cflag &= ~CSIZE;
 	switch (bits & BITS_DATA_MASK) {
 	case BITS_DATA_5:
@@ -522,14 +599,16 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 		cflag |= CS8;
 		bits &= ~BITS_DATA_MASK;
 		bits |= BITS_DATA_8;
-		cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2);
 		break;
 	default:
 		dbg("%s - Unknown number of data bits, using 8", __func__);
 		cflag |= CS8;
 		bits &= ~BITS_DATA_MASK;
 		bits |= BITS_DATA_8;
-		cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2);
 		break;
 	}
 
@@ -560,7 +639,8 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 		dbg("%s - Unknown parity mode, disabling parity", __func__);
 		cflag &= ~PARENB;
 		bits &= ~BITS_PARITY_MASK;
-		cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2);
 		break;
 	}
 
@@ -573,7 +653,8 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 		dbg("%s - stop bits = 1.5 (not supported, using 1 stop bit)",
 								__func__);
 		bits &= ~BITS_STOP_MASK;
-		cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2);
 		break;
 	case BITS_STOP_2:
 		dbg("%s - stop bits = 2", __func__);
@@ -583,11 +664,13 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
 		dbg("%s - Unknown number of stop bits, using 1 stop bit",
 								__func__);
 		bits &= ~BITS_STOP_MASK;
-		cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2);
 		break;
 	}
 
-	cp210x_get_config(port, CP210X_GET_FLOW, modem_ctl, 16);
+	cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+			CP210X_GET_FLOW, 0, modem_ctl, 16);
 	if (modem_ctl[0] & 0x0008) {
 		dbg("%s - flow control = CRTSCTS", __func__);
 		cflag |= CRTSCTS;
@@ -640,8 +723,8 @@ static void cp210x_change_speed(struct tty_struct *tty,
 	baud = cp210x_quantise_baudrate(baud);
 
 	dbg("%s - setting baud rate to %u", __func__, baud);
-	if (cp210x_set_config(port, CP210X_SET_BAUDRATE, &baud,
-							sizeof(baud))) {
+	if (cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+			CP210X_SET_BAUDRATE, 0, &baud, sizeof(baud))) {
 		dev_warn(&port->dev, "failed to set baud rate to %u\n", baud);
 		if (old_termios)
 			baud = old_termios->c_ospeed;
@@ -672,7 +755,8 @@ static void cp210x_set_termios(struct tty_struct *tty,
 
 	/* If the number of data bits is to be updated */
 	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
-		cp210x_get_config(port, CP210X_GET_LINE_CTL, &bits, 2);
+		cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+				CP210X_GET_LINE_CTL, 0, &bits, 2);
 		bits &= ~BITS_DATA_MASK;
 		switch (cflag & CSIZE) {
 		case CS5:
@@ -702,14 +786,16 @@ static void cp210x_set_termios(struct tty_struct *tty,
 				bits |= BITS_DATA_8;
 				break;
 		}
-		if (cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2))
+		if (cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2))
 			dbg("Number of data bits requested "
 					"not supported by device");
 	}
 
 	if ((cflag     & (PARENB|PARODD|CMSPAR)) !=
 	    (old_cflag & (PARENB|PARODD|CMSPAR))) {
-		cp210x_get_config(port, CP210X_GET_LINE_CTL, &bits, 2);
+		cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+				CP210X_GET_LINE_CTL, 0, &bits, 2);
 		bits &= ~BITS_PARITY_MASK;
 		if (cflag & PARENB) {
 			if (cflag & CMSPAR) {
@@ -730,12 +816,14 @@ static void cp210x_set_termios(struct tty_struct *tty,
 			    }
 			}
 		}
-		if (cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2))
+		if (cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2))
 			dbg("Parity mode not supported by device");
 	}
 
 	if ((cflag & CSTOPB) != (old_cflag & CSTOPB)) {
-		cp210x_get_config(port, CP210X_GET_LINE_CTL, &bits, 2);
+		cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+				CP210X_GET_LINE_CTL, 0, &bits, 2);
 		bits &= ~BITS_STOP_MASK;
 		if (cflag & CSTOPB) {
 			bits |= BITS_STOP_2;
@@ -744,13 +832,15 @@ static void cp210x_set_termios(struct tty_struct *tty,
 			bits |= BITS_STOP_1;
 			dbg("%s - stop bits = 1", __func__);
 		}
-		if (cp210x_set_config(port, CP210X_SET_LINE_CTL, &bits, 2))
+		if (cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_LINE_CTL, 0, &bits, 2))
 			dbg("Number of stop bits requested "
 					"not supported by device");
 	}
 
 	if ((cflag & CRTSCTS) != (old_cflag & CRTSCTS)) {
-		cp210x_get_config(port, CP210X_GET_FLOW, modem_ctl, 16);
+		cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+				CP210X_GET_FLOW, 0, modem_ctl, 16);
 		dbg("%s - read modem controls = 0x%.4x 0x%.4x 0x%.4x 0x%.4x",
 				__func__, modem_ctl[0], modem_ctl[1],
 				modem_ctl[2], modem_ctl[3]);
@@ -770,7 +860,8 @@ static void cp210x_set_termios(struct tty_struct *tty,
 		dbg("%s - write modem controls = 0x%.4x 0x%.4x 0x%.4x 0x%.4x",
 				__func__, modem_ctl[0], modem_ctl[1],
 				modem_ctl[2], modem_ctl[3]);
-		cp210x_set_config(port, CP210X_SET_FLOW, modem_ctl, 16);
+		cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_FLOW, 0, modem_ctl, 16);
 	}
 
 }
@@ -808,7 +899,8 @@ static int cp210x_tiocmset_port(struct usb_serial_port *port,
 
 	dbg("%s - control = 0x%.4x", __func__, control);
 
-	return cp210x_set_config(port, CP210X_SET_MHS, &control, 2);
+	return cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+				CP210X_SET_MHS, 0, &control, 2);
 }
 
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on)
@@ -827,7 +919,8 @@ static int cp210x_tiocmget (struct tty_struct *tty)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	cp210x_get_config(port, CP210X_GET_MDMSTS, &control, 1);
+	cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
+			CP210X_GET_MDMSTS, 0, &control, 1);
 
 	result = ((control & CONTROL_DTR) ? TIOCM_DTR : 0)
 		|((control & CONTROL_RTS) ? TIOCM_RTS : 0)
@@ -853,13 +946,15 @@ static void cp210x_break_ctl (struct tty_struct *tty, int break_state)
 		state = BREAK_ON;
 	dbg("%s - turning break %s", __func__,
 			state == BREAK_OFF ? "off" : "on");
-	cp210x_set_config(port, CP210X_SET_BREAK, &state, 2);
+	cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
+			CP210X_SET_BREAK, 0, &state, 2);
 }
 
 static int cp210x_startup(struct usb_serial *serial)
 {
 	struct cp210x_port_private *port_priv;
 	int i;
+	unsigned int partNum;
 
 	/* cp210x buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
@@ -874,6 +969,12 @@ static int cp210x_startup(struct usb_serial *serial)
 		    serial->interface->cur_altsetting->desc.bInterfaceNumber;
 
 		usb_set_serial_port_data(serial->port[i], port_priv);
+
+		/* Get the 1-byte part number of the cp210x device */
+		cp210x_get_config(serial->port[i],
+			REQTYPE_DEVICE_TO_HOST, CP210X_VENDOR_SPECIFIC,
+			CP210X_GET_PARTNUM, &partNum, 1);
+		port_priv->bPartNumber = partNum & 0xFF;
 	}
 
 	return 0;
-- 
1.7.5.4

