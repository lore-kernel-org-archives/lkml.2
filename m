Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2JZAVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:21:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:53676 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab2JZAH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 38/85] USB: spcp8x5: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:56 -0700
Message-Id: <20121026000034.936361533@linuxfoundation.org>
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

commit bf90ff5f3b8f67e5b42df4ea4fd543f8010a2676 upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/spcp8x5.c |   48 +++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -159,13 +159,10 @@ struct spcp8x5_private {
 	u8 			line_status;
 };
 
-/* desc : when device plug in,this function would be called.
- * thanks to usb_serial subsystem,then do almost every things for us. And what
- * we should do just alloc the buffer */
-static int spcp8x5_startup(struct usb_serial *serial)
+static int spcp8x5_port_probe(struct usb_serial_port *port)
 {
+	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv;
-	int i;
 	enum spcp8x5_type type = SPCP825_007_TYPE;
 	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
 
@@ -182,34 +179,27 @@ static int spcp8x5_startup(struct usb_se
 		type = SPCP825_PHILIP_TYPE;
 	dev_dbg(&serial->dev->dev, "device type = %d\n", (int)type);
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		priv = kzalloc(sizeof(struct spcp8x5_private), GFP_KERNEL);
-		if (!priv)
-			goto cleanup;
-
-		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->delta_msr_wait);
-		priv->type = type;
-		usb_set_serial_port_data(serial->port[i] , priv);
-	}
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->delta_msr_wait);
+	priv->type = type;
+
+	usb_set_serial_port_data(port , priv);
 
 	return 0;
-cleanup:
-	for (--i; i >= 0; --i) {
-		priv = usb_get_serial_port_data(serial->port[i]);
-		kfree(priv);
-		usb_set_serial_port_data(serial->port[i] , NULL);
-	}
-	return -ENOMEM;
 }
 
-/* call when the device plug out. free all the memory alloced by probe */
-static void spcp8x5_release(struct usb_serial *serial)
+static int spcp8x5_port_remove(struct usb_serial_port *port)
 {
-	int i;
+	struct spcp8x5_private *priv;
 
-	for (i = 0; i < serial->num_ports; i++)
-		kfree(usb_get_serial_port_data(serial->port[i]));
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 /* set the modem control line of the device.
@@ -651,8 +641,8 @@ static struct usb_serial_driver spcp8x5_
 	.ioctl 			= spcp8x5_ioctl,
 	.tiocmget 		= spcp8x5_tiocmget,
 	.tiocmset 		= spcp8x5_tiocmset,
-	.attach 		= spcp8x5_startup,
-	.release 		= spcp8x5_release,
+	.port_probe		= spcp8x5_port_probe,
+	.port_remove		= spcp8x5_port_remove,
 	.process_read_urb	= spcp8x5_process_read_urb,
 };
 


