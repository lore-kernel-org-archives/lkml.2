Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2BXTml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:42:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2BXTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:42:40 -0500
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 13:42:39 -0600
Message-ID: <CAJbtUMH_o10kh=ucL0UoBe7Vc4Vb8pwffLdLh08p77WxEhk1YA@mail.gmail.com>
Subject: [PATCH] usb: cp210x: Update to support CP2105 and multiple interface devices
From: Preston Fick <pffick@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the cp210x driver to support CP210x multiple
interface devices devices from Silicon Labs. The existing driver
always sends control requests to interface 0, which is hardcoded in
the usb_control_msg function calls. This only allows for single
interface devices to be used, and causes a bug when using ports on an
interface other than 0 in the multiple interface devices.

Here are the changes included in this patch:
- Updated the device list to contain the Silicon Labs factory default
VID/PID for multiple interface CP210x devices
- Created a cp210x_port_private struct created for each port on
startup, this struct holds the interface number
- Added a cp210x_release function to clean up the cp210x_port_private
memory created on startup
- Modified usb_get_config and usb_set_config to get a pointer to the
cp210x_port_private struct, and use the interface number there in the
usb_control_message wIndex param

Signed-off-by: Preston Fick <preston.fick@silabs.com>

---

diff -uprN linux.vanilla//linux-3.3-rc4/drivers/usb/serial/cp210x.c
linux.new//linux-3.3-rc4/drivers/usb/serial/cp210x.c
--- linux.vanilla//linux-3.3-rc4/drivers/usb/serial/cp210x.c	2012-02-18
17:53:33.000000000 -0600
+++ linux.new//linux-3.3-rc4/drivers/usb/serial/cp210x.c	2012-02-23
18:47:46.315748242 -0600
@@ -49,6 +49,7 @@ static int cp210x_tiocmset_port(struct u
 		unsigned int, unsigned int);
 static void cp210x_break_ctl(struct tty_struct *, int);
 static int cp210x_startup(struct usb_serial *);
+static void cp210x_release(struct usb_serial *);
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);

 static bool debug;
@@ -121,6 +122,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C4, 0xEA80) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA71) }, /* Infinity GPS-MIC-1 Radio Monophone */
 	{ USB_DEVICE(0x10C4, 0xF001) }, /* Elan Digital Systems USBscope50 */
 	{ USB_DEVICE(0x10C4, 0xF002) }, /* Elan Digital Systems USBwave12 */
@@ -147,6 +150,10 @@ static const struct usb_device_id id_tab

 MODULE_DEVICE_TABLE(usb, id_table);

+struct cp210x_port_private {
+	__u8			bInterfaceNumber;
+};
+
 static struct usb_driver cp210x_driver = {
 	.name		= "cp210x",
 	.probe		= usb_serial_probe,
@@ -172,6 +179,7 @@ static struct usb_serial_driver cp210x_d
 	.tiocmget 		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
+	.release		= cp210x_release,
 	.dtr_rts		= cp210x_dtr_rts
 };

@@ -259,6 +267,7 @@ static int cp210x_get_config(struct usb_
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
+	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
 	__le32 *buf;
 	int result, i, length;

@@ -274,7 +283,7 @@ static int cp210x_get_config(struct usb_
 	/* Issue the request, attempting to read 'size' bytes */
 	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
-				0, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size, 300);

 	/* Convert data into an array of integers */
 	for (i = 0; i < length; i++)
@@ -305,6 +314,7 @@ static int cp210x_set_config(struct usb_
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
+	struct cp210x_port_private *port_priv = usb_get_serial_port_data(port);
 	__le32 *buf;
 	int result, i, length;

@@ -326,12 +336,12 @@ static int cp210x_set_config(struct usb_
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
-				0, buf, size, 300);
+				port_priv->bInterfaceNumber, buf, size, 300);
 	} else {
 		result = usb_control_msg(serial->dev,
 				usb_sndctrlpipe(serial->dev, 0),
 				request, REQTYPE_HOST_TO_DEVICE, data[0],
-				0, NULL, 0, 300);
+				port_priv->bInterfaceNumber, NULL, 0, 300);
 	}

 	kfree(buf);
@@ -842,11 +852,39 @@ static void cp210x_break_ctl (struct tty

 static int cp210x_startup(struct usb_serial *serial)
 {
+	struct cp210x_port_private *port_priv;
+	int i;
+
 	/* cp210x buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
+
+	for (i = 0; i < serial->num_ports; i++) {
+		port_priv = kzalloc(sizeof(*port_priv), GFP_KERNEL);
+		if (!port_priv)
+			return -ENOMEM;
+
+		memset(port_priv, 0x00, sizeof(*port_priv));
+		port_priv->bInterfaceNumber =
+		    serial->interface->cur_altsetting->desc.bInterfaceNumber;
+
+		usb_set_serial_port_data(serial->port[i], port_priv);
+	}
+
 	return 0;
 }

+static void cp210x_release(struct usb_serial *serial)
+{
+	struct cp210x_port_private *port_priv;
+	int i;
+
+	for (i = 0; i < serial->num_ports; i++) {
+		port_priv = usb_get_serial_port_data(serial->port[i]);
+		kfree(port_priv);
+		usb_set_serial_port_data(serial->port[i], NULL);
+	}
+}
+
 static int __init cp210x_init(void)
 {
 	int retval;
