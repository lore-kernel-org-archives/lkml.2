Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2J2WI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:08:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:47632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761271Ab2J2Vh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 056/101] USB: metro-usb: fix port-data memory leak
Date: Mon, 29 Oct 2012 14:35:09 -0700
Message-Id: <20121029213246.488506694@linuxfoundation.org>
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

commit 50dde8686eec41bf3d7cbec7a6f76c073ab01903 upstream.

Fix port-data memory leak by moving port data allocation and
deallocation to port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Note that the call to metrousb_clean (close) in shutdown was redundant.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/metro-usb.c |   50 ++++++++++-------------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

--- a/drivers/usb/serial/metro-usb.c
+++ b/drivers/usb/serial/metro-usb.c
@@ -280,51 +280,27 @@ static int metrousb_set_modem_ctrl(struc
 	return retval;
 }
 
-static void metrousb_shutdown(struct usb_serial *serial)
+static int metrousb_port_probe(struct usb_serial_port *port)
 {
-	int i = 0;
+	struct metrousb_private *metro_priv;
 
-	dev_dbg(&serial->dev->dev, "%s\n", __func__);
+	metro_priv = kzalloc(sizeof(*metro_priv), GFP_KERNEL);
+	if (!metro_priv)
+		return -ENOMEM;
 
-	/* Stop reading and writing on all ports. */
-	for (i = 0; i < serial->num_ports; ++i) {
-		/* Close any open urbs. */
-		metrousb_cleanup(serial->port[i]);
+	spin_lock_init(&metro_priv->lock);
 
-		/* Free memory. */
-		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i], NULL);
+	usb_set_serial_port_data(port, metro_priv);
 
-		dev_dbg(&serial->dev->dev, "%s - freed port number=%d\n",
-			__func__, serial->port[i]->number);
-	}
+	return 0;
 }
 
-static int metrousb_startup(struct usb_serial *serial)
+static int metrousb_port_remove(struct usb_serial_port *port)
 {
 	struct metrousb_private *metro_priv;
-	struct usb_serial_port *port;
-	int i = 0;
-
-	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
-	/* Loop through the serial ports setting up the private structures.
-	 * Currently we only use one port. */
-	for (i = 0; i < serial->num_ports; ++i) {
-		port = serial->port[i];
-
-		/* Declare memory. */
-		metro_priv = kzalloc(sizeof(struct metrousb_private), GFP_KERNEL);
-		if (!metro_priv)
-			return -ENOMEM;
-
-		/* Initialize memory. */
-		spin_lock_init(&metro_priv->lock);
-		usb_set_serial_port_data(port, metro_priv);
-
-		dev_dbg(&serial->dev->dev, "%s - port number=%d\n ",
-			__func__, port->number);
-	}
+	metro_priv = usb_get_serial_port_data(port);
+	kfree(metro_priv);
 
 	return 0;
 }
@@ -423,8 +399,8 @@ static struct usb_serial_driver metrousb
 	.close			= metrousb_cleanup,
 	.read_int_callback	= metrousb_read_int_callback,
 	.write_int_callback	= metrousb_write_int_callback,
-	.attach			= metrousb_startup,
-	.release		= metrousb_shutdown,
+	.port_probe		= metrousb_port_probe,
+	.port_remove		= metrousb_port_remove,
 	.throttle		= metrousb_throttle,
 	.unthrottle		= metrousb_unthrottle,
 	.tiocmget		= metrousb_tiocmget,


