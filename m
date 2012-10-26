Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2JZAHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:07:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:53534 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2JZAHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 24/85] USB: cyberjack: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:42 -0700
Message-Id: <20121026000033.538266086@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a9556040119a63d06fd5238d47f5b683fba4178b upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Note that the write waitqueue was initialised but never used.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cyberjack.c |   48 ++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -57,9 +57,9 @@ static bool debug;
 #define CYBERJACK_PRODUCT_ID	0x0100
 
 /* Function prototypes */
-static int cyberjack_startup(struct usb_serial *serial);
 static void cyberjack_disconnect(struct usb_serial *serial);
-static void cyberjack_release(struct usb_serial *serial);
+static int cyberjack_port_probe(struct usb_serial_port *port);
+static int cyberjack_port_remove(struct usb_serial_port *port);
 static int  cyberjack_open(struct tty_struct *tty,
 	struct usb_serial_port *port);
 static void cyberjack_close(struct usb_serial_port *port);
@@ -85,9 +85,9 @@ static struct usb_serial_driver cyberjac
 	.description =		"Reiner SCT Cyberjack USB card reader",
 	.id_table =		id_table,
 	.num_ports =		1,
-	.attach =		cyberjack_startup,
 	.disconnect =		cyberjack_disconnect,
-	.release =		cyberjack_release,
+	.port_probe =		cyberjack_port_probe,
+	.port_remove =		cyberjack_port_remove,
 	.open =			cyberjack_open,
 	.close =		cyberjack_close,
 	.write =		cyberjack_write,
@@ -109,55 +109,45 @@ struct cyberjack_private {
 	short		wrsent;		/* Data already sent */
 };
 
-/* do some startup allocations not currently performed by usb_serial_probe() */
-static int cyberjack_startup(struct usb_serial *serial)
+static int cyberjack_port_probe(struct usb_serial_port *port)
 {
 	struct cyberjack_private *priv;
-	int i;
+	int result;
 
-	/* allocate the private data structure */
 	priv = kmalloc(sizeof(struct cyberjack_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	/* set initial values */
 	spin_lock_init(&priv->lock);
 	priv->rdtodo = 0;
 	priv->wrfilled = 0;
 	priv->wrsent = 0;
-	usb_set_serial_port_data(serial->port[0], priv);
 
-	init_waitqueue_head(&serial->port[0]->write_wait);
+	usb_set_serial_port_data(port, priv);
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		int result;
-		result = usb_submit_urb(serial->port[i]->interrupt_in_urb,
-					GFP_KERNEL);
-		if (result)
-			dev_err(&serial->dev->dev,
-				"usb_submit_urb(read int) failed\n");
-		dbg("%s - usb_submit_urb(int urb)", __func__);
-	}
+	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
+	if (result)
+		dev_err(&port->dev, "usb_submit_urb(read int) failed\n");
 
 	return 0;
 }
 
-static void cyberjack_disconnect(struct usb_serial *serial)
+static int cyberjack_port_remove(struct usb_serial_port *port)
 {
-	int i;
+	struct cyberjack_private *priv;
 
-	for (i = 0; i < serial->num_ports; ++i)
-		usb_kill_urb(serial->port[i]->interrupt_in_urb);
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
-static void cyberjack_release(struct usb_serial *serial)
+static void cyberjack_disconnect(struct usb_serial *serial)
 {
 	int i;
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		/* My special items, the standard routines free my urbs */
-		kfree(usb_get_serial_port_data(serial->port[i]));
-	}
+	for (i = 0; i < serial->num_ports; ++i)
+		usb_kill_urb(serial->port[i]->interrupt_in_urb);
 }
 
 static int  cyberjack_open(struct tty_struct *tty,


