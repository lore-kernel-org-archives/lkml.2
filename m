Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2J2WIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:08:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:47614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761263Ab2J2Vh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 046/101] USB: mct_u232: fix port-data memory leak
Date: Mon, 29 Oct 2012 14:34:59 -0700
Message-Id: <20121029213245.384991630@linuxfoundation.org>
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

commit a8f2ae7a3aa59079d7e7e1ddf5007f03532f458c upstream.

Fix port-data memory leak by moving port data allocation and
deallocation to port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Note that the write waitqueue was initialised but never used.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mct_u232.c |   45 +++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -51,7 +51,8 @@ static bool debug;
  * Function prototypes
  */
 static int  mct_u232_startup(struct usb_serial *serial);
-static void mct_u232_release(struct usb_serial *serial);
+static int  mct_u232_port_probe(struct usb_serial_port *port);
+static int  mct_u232_port_remove(struct usb_serial_port *remove);
 static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void mct_u232_close(struct usb_serial_port *port);
 static void mct_u232_dtr_rts(struct usb_serial_port *port, int on);
@@ -101,7 +102,8 @@ static struct usb_serial_driver mct_u232
 	.tiocmget =	     mct_u232_tiocmget,
 	.tiocmset =	     mct_u232_tiocmset,
 	.attach =	     mct_u232_startup,
-	.release =	     mct_u232_release,
+	.port_probe =        mct_u232_port_probe,
+	.port_remove =       mct_u232_port_remove,
 	.ioctl =             mct_u232_ioctl,
 	.get_icount =        mct_u232_get_icount,
 };
@@ -392,18 +394,8 @@ static void mct_u232_msr_to_state(unsign
 
 static int mct_u232_startup(struct usb_serial *serial)
 {
-	struct mct_u232_private *priv;
 	struct usb_serial_port *port, *rport;
 
-	priv = kzalloc(sizeof(struct mct_u232_private), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-	spin_lock_init(&priv->lock);
-	init_waitqueue_head(&priv->msr_wait);
-	usb_set_serial_port_data(serial->port[0], priv);
-
-	init_waitqueue_head(&serial->port[0]->write_wait);
-
 	/* Puh, that's dirty */
 	port = serial->port[0];
 	rport = serial->port[1];
@@ -416,18 +408,31 @@ static int mct_u232_startup(struct usb_s
 	return 0;
 } /* mct_u232_startup */
 
+static int mct_u232_port_probe(struct usb_serial_port *port)
+{
+	struct mct_u232_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-static void mct_u232_release(struct usb_serial *serial)
+	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->msr_wait);
+
+	usb_set_serial_port_data(port, priv);
+
+	return 0;
+}
+
+static int mct_u232_port_remove(struct usb_serial_port *port)
 {
 	struct mct_u232_private *priv;
-	int i;
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		/* My special items, the standard routines free my urbs */
-		priv = usb_get_serial_port_data(serial->port[i]);
-		kfree(priv);
-	}
-} /* mct_u232_release */
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
+}
 
 static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 {


