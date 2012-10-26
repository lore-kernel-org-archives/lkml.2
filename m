Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2JZA0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:26:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:53484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2JZAHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 34/85] USB: ssu100: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:52 -0700
Message-Id: <20121026000034.543990681@linuxfoundation.org>
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

commit 638b9e15233c9570bce65301aa9877235316b9f0 upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ssu100.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -69,13 +69,6 @@ struct ssu100_port_private {
 	struct async_icount icount;
 };
 
-static void ssu100_release(struct usb_serial *serial)
-{
-	struct ssu100_port_private *priv = usb_get_serial_port_data(*serial->port);
-
-	kfree(priv);
-}
-
 static inline int ssu100_control_msg(struct usb_device *dev,
 				     u8 request, u16 data, u16 index)
 {
@@ -444,21 +437,33 @@ static int ssu100_ioctl(struct tty_struc
 
 static int ssu100_attach(struct usb_serial *serial)
 {
+	return ssu100_initdevice(serial->dev);
+}
+
+static int ssu100_port_probe(struct usb_serial_port *port)
+{
 	struct ssu100_port_private *priv;
-	struct usb_serial_port *port = *serial->port;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&port->dev, "%s- kmalloc(%Zd) failed.\n", __func__,
-			sizeof(*priv));
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&priv->status_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
+
 	usb_set_serial_port_data(port, priv);
 
-	return ssu100_initdevice(serial->dev);
+	return 0;
+}
+
+static int ssu100_port_remove(struct usb_serial_port *port)
+{
+	struct ssu100_port_private *priv;
+
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 static int ssu100_tiocmget(struct tty_struct *tty)
@@ -649,7 +654,8 @@ static struct usb_serial_driver ssu100_d
 	.open		     = ssu100_open,
 	.close		     = ssu100_close,
 	.attach              = ssu100_attach,
-	.release             = ssu100_release,
+	.port_probe          = ssu100_port_probe,
+	.port_remove         = ssu100_port_remove,
 	.dtr_rts             = ssu100_dtr_rts,
 	.process_read_urb    = ssu100_process_read_urb,
 	.tiocmget            = ssu100_tiocmget,


