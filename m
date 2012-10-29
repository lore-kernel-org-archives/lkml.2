Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab2J2WJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:09:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:47576 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760979Ab2J2VhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 050/101] USB: omninet: fix port-data memory leak
Date: Mon, 29 Oct 2012 14:35:03 -0700
Message-Id: <20121029213245.818697435@linuxfoundation.org>
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

commit feffa7ca6008ab859dd7ab7448a5a899bf0aa98f upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/omninet.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -46,8 +46,8 @@ static int  omninet_write(struct tty_str
 				const unsigned char *buf, int count);
 static int  omninet_write_room(struct tty_struct *tty);
 static void omninet_disconnect(struct usb_serial *serial);
-static void omninet_release(struct usb_serial *serial);
-static int omninet_attach(struct usb_serial *serial);
+static int omninet_port_probe(struct usb_serial_port *port);
+static int omninet_port_remove(struct usb_serial_port *port);
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(ZYXEL_VENDOR_ID, ZYXEL_OMNINET_ID) },
@@ -64,7 +64,8 @@ static struct usb_serial_driver zyxel_om
 	.description =		"ZyXEL - omni.net lcd plus usb",
 	.id_table =		id_table,
 	.num_ports =		1,
-	.attach =		omninet_attach,
+	.port_probe =		omninet_port_probe,
+	.port_remove =		omninet_port_remove,
 	.open =			omninet_open,
 	.close =		omninet_close,
 	.write =		omninet_write,
@@ -72,7 +73,6 @@ static struct usb_serial_driver zyxel_om
 	.read_bulk_callback =	omninet_read_bulk_callback,
 	.write_bulk_callback =	omninet_write_bulk_callback,
 	.disconnect =		omninet_disconnect,
-	.release =		omninet_release,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {
@@ -114,18 +114,26 @@ struct omninet_data {
 	__u8	od_outseq;	/* Sequence number for bulk_out URBs */
 };
 
-static int omninet_attach(struct usb_serial *serial)
+static int omninet_port_probe(struct usb_serial_port *port)
 {
 	struct omninet_data *od;
-	struct usb_serial_port *port = serial->port[0];
 
 	od = kmalloc(sizeof(struct omninet_data), GFP_KERNEL);
-	if (!od) {
-		dev_err(&port->dev, "%s- kmalloc(%Zd) failed.\n",
-			__func__, sizeof(struct omninet_data));
+	if (!od)
 		return -ENOMEM;
-	}
+
 	usb_set_serial_port_data(port, od);
+
+	return 0;
+}
+
+static int omninet_port_remove(struct usb_serial_port *port)
+{
+	struct omninet_data *od;
+
+	od = usb_get_serial_port_data(port);
+	kfree(od);
+
 	return 0;
 }
 
@@ -291,14 +299,6 @@ static void omninet_disconnect(struct us
 	usb_kill_urb(wport->write_urb);
 }
 
-
-static void omninet_release(struct usb_serial *serial)
-{
-	struct usb_serial_port *port = serial->port[0];
-
-	kfree(usb_get_serial_port_data(port));
-}
-
 module_usb_serial_driver(serial_drivers, id_table);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);


