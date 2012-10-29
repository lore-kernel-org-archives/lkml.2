Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2J2WKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:10:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:47555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234Ab2J2VhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 048/101] USB: option: fix interface-data memory leak in error path
Date: Mon, 29 Oct 2012 14:35:01 -0700
Message-Id: <20121029213245.605874387@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c2dd4a8eac7821fed2c2d19e4607d0986b53b0fe upstream.

Move interface data allocation to attach so that it is deallocated
should usb-serial probe fail.

Note that the usb device id is stored at probe so that it can be used
in attach to determine send-setup blacklisting.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -47,6 +47,7 @@
 /* Function prototypes */
 static int  option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id);
+static int option_attach(struct usb_serial *serial);
 static void option_release(struct usb_serial *serial);
 static int option_send_setup(struct usb_serial_port *port);
 static void option_instat_callback(struct urb *urb);
@@ -1288,6 +1289,7 @@ static struct usb_serial_driver option_1
 	.tiocmget          = usb_wwan_tiocmget,
 	.tiocmset          = usb_wwan_tiocmset,
 	.ioctl             = usb_wwan_ioctl,
+	.attach            = option_attach,
 	.release           = option_release,
 	.port_probe        = usb_wwan_port_probe,
 	.port_remove	   = usb_wwan_port_remove,
@@ -1337,8 +1339,6 @@ static bool is_blacklisted(const u8 ifnu
 static int option_probe(struct usb_serial *serial,
 			const struct usb_device_id *id)
 {
-	struct usb_wwan_intf_private *data;
-	struct option_private *priv;
 	struct usb_interface_descriptor *iface_desc =
 				&serial->interface->cur_altsetting->desc;
 	struct usb_device_descriptor *dev_desc = &serial->dev->descriptor;
@@ -1376,6 +1376,19 @@ static int option_probe(struct usb_seria
 		iface_desc->bInterfaceClass != USB_CLASS_CDC_DATA)
 		return -ENODEV;
 
+	/* Store device id so we can use it during attach. */
+	usb_set_serial_data(serial, (void *)id);
+
+	return 0;
+}
+
+static int option_attach(struct usb_serial *serial)
+{
+	struct usb_interface_descriptor *iface_desc;
+	const struct usb_device_id *id;
+	struct usb_wwan_intf_private *data;
+	struct option_private *priv;
+
 	data = kzalloc(sizeof(struct usb_wwan_intf_private), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -1386,6 +1399,10 @@ static int option_probe(struct usb_seria
 		return -ENOMEM;
 	}
 
+	/* Retrieve device id stored at probe. */
+	id = usb_get_serial_data(serial);
+	iface_desc = &serial->interface->cur_altsetting->desc;
+
 	priv->bInterfaceNumber = iface_desc->bInterfaceNumber;
 	data->private = priv;
 


