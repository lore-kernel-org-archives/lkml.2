Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2EAEHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:07:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33404 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2EAEHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:07:06 -0400
From: Preston Fick <pffick@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH 3/3] usb: cp210x: Add ioctl for GPIO support
Date: Mon, 30 Apr 2012 23:06:50 -0500
Message-Id: <1335845210-5147-3-git-send-email-preston.fick@silabs.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for GPIO for CP210x devices that support it through two
IOCTLs to get or set the GPIO latch on a CP210x device. The specification for
this can be found in Silicon Labs AN571 document on section 5.27.1-4.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index b3646b8..9d1e542 100644
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
@@ -175,6 +177,7 @@ static struct usb_serial_driver cp210x_device = {
 	.bulk_out_size		= 256,
 	.open			= cp210x_open,
 	.close			= cp210x_close,
+	.ioctl			= cp210x_ioctl,
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
 	.tiocmget 		= cp210x_tiocmget,
@@ -195,6 +198,10 @@ static struct usb_serial_driver * const serial_drivers[] = {
 #define CP2104_PARTNUM		0x04
 #define CP2105_PARTNUM		0x05
 
+/* IOCTLs */
+#define IOCTL_GPIOGET		0x8000
+#define IOCTL_GPIOSET		0x8001
+
 /* Config request types */
 #define REQTYPE_HOST_TO_INTERFACE	0x41
 #define REQTYPE_INTERFACE_TO_HOST	0xc1
@@ -235,6 +242,8 @@ static struct usb_serial_driver * const serial_drivers[] = {
 #define UART_DISABLE		0x0000
 
 /* CP210X_VENDOR_SPECIFIC */
+#define CP210X_WRITE_LATCH	0x37E1
+#define CP210X_READ_LATCH	0x00C2
 #define CP210X_GET_PARTNUM	0x370B
 
 /* CP210X_(SET|GET)_BAUDDIV */
@@ -467,6 +476,95 @@ static void cp210x_close(struct usb_serial_port *port)
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
-- 
1.7.5.4

