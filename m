Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab2J2WL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:11:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:47500 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761219Ab2J2VhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 043/101] USB: ch341: fix port-data memory leak
Date: Mon, 29 Oct 2012 14:34:56 -0700
Message-Id: <20121029213245.034508191@linuxfoundation.org>
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

commit 456c5be56ed070a4d883c60b587bcc1c97a8cf3e upstream.

Fix port-data memory leak by moving port data allocation to port_probe
and actually implementing deallocation.

Note that this driver has never even bothered to try to deallocate it's
port data...

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -241,13 +241,11 @@ out:	kfree(buffer);
 	return r;
 }
 
-/* allocate private data */
-static int ch341_attach(struct usb_serial *serial)
+static int ch341_port_probe(struct usb_serial_port *port)
 {
 	struct ch341_private *priv;
 	int r;
 
-	/* private data */
 	priv = kzalloc(sizeof(struct ch341_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -257,17 +255,27 @@ static int ch341_attach(struct usb_seria
 	priv->baud_rate = DEFAULT_BAUD_RATE;
 	priv->line_control = CH341_BIT_RTS | CH341_BIT_DTR;
 
-	r = ch341_configure(serial->dev, priv);
+	r = ch341_configure(port->serial->dev, priv);
 	if (r < 0)
 		goto error;
 
-	usb_set_serial_port_data(serial->port[0], priv);
+	usb_set_serial_port_data(port, priv);
 	return 0;
 
 error:	kfree(priv);
 	return r;
 }
 
+static int ch341_port_remove(struct usb_serial_port *port)
+{
+	struct ch341_private *priv;
+
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
+}
+
 static int ch341_carrier_raised(struct usb_serial_port *port)
 {
 	struct ch341_private *priv = usb_get_serial_port_data(port);
@@ -303,7 +311,7 @@ static void ch341_close(struct usb_seria
 static int ch341_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct ch341_private *priv = usb_get_serial_port_data(serial->port[0]);
+	struct ch341_private *priv = usb_get_serial_port_data(port);
 	int r;
 
 	priv->baud_rate = DEFAULT_BAUD_RATE;
@@ -606,7 +614,8 @@ static struct usb_serial_driver ch341_de
 	.tiocmget          = ch341_tiocmget,
 	.tiocmset          = ch341_tiocmset,
 	.read_int_callback = ch341_read_int_callback,
-	.attach            = ch341_attach,
+	.port_probe        = ch341_port_probe,
+	.port_remove       = ch341_port_remove,
 	.reset_resume      = ch341_reset_resume,
 };
 


