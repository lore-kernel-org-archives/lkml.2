Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab2JZAVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:21:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:53695 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab2JZAH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 40/85] USB: kl5kusb105: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:58 -0700
Message-Id: <20121026000035.151513573@linuxfoundation.org>
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

commit 99a6f73c495c420df826e5b267fb073fd6766fc3 upstream.

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
 drivers/usb/serial/kl5kusb105.c |   68 ++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 43 deletions(-)

--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -62,8 +62,8 @@ static bool debug;
 /*
  * Function prototypes
  */
-static int  klsi_105_startup(struct usb_serial *serial);
-static void klsi_105_release(struct usb_serial *serial);
+static int klsi_105_port_probe(struct usb_serial_port *port);
+static int klsi_105_port_remove(struct usb_serial_port *port);
 static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void klsi_105_close(struct usb_serial_port *port);
 static void klsi_105_set_termios(struct tty_struct *tty,
@@ -101,8 +101,8 @@ static struct usb_serial_driver kl5kusb1
 	/*.break_ctl =		klsi_105_break_ctl,*/
 	.tiocmget =		klsi_105_tiocmget,
 	.tiocmset =		klsi_105_tiocmset,
-	.attach =		klsi_105_startup,
-	.release =		klsi_105_release,
+	.port_probe =		klsi_105_port_probe,
+	.port_remove =		klsi_105_port_remove,
 	.throttle =		usb_serial_generic_throttle,
 	.unthrottle =		usb_serial_generic_unthrottle,
 	.process_read_urb =	klsi_105_process_read_urb,
@@ -225,58 +225,40 @@ static int klsi_105_get_line_state(struc
  * Driver's tty interface functions
  */
 
-static int klsi_105_startup(struct usb_serial *serial)
+static int klsi_105_port_probe(struct usb_serial_port *port)
 {
 	struct klsi_105_private *priv;
-	int i;
 
-	/* check if we support the product id (see keyspan.c)
-	 * FIXME
-	 */
-
-	/* allocate the private data structure */
-	for (i = 0; i < serial->num_ports; i++) {
-		priv = kmalloc(sizeof(struct klsi_105_private),
-						   GFP_KERNEL);
-		if (!priv) {
-			dbg("%skmalloc for klsi_105_private failed.", __func__);
-			i--;
-			goto err_cleanup;
-		}
-		/* set initial values for control structures */
-		priv->cfg.pktlen    = 5;
-		priv->cfg.baudrate  = kl5kusb105a_sio_b9600;
-		priv->cfg.databits  = kl5kusb105a_dtb_8;
-		priv->cfg.unknown1  = 0;
-		priv->cfg.unknown2  = 1;
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-		priv->line_state    = 0;
+	/* set initial values for control structures */
+	priv->cfg.pktlen    = 5;
+	priv->cfg.baudrate  = kl5kusb105a_sio_b9600;
+	priv->cfg.databits  = kl5kusb105a_dtb_8;
+	priv->cfg.unknown1  = 0;
+	priv->cfg.unknown2  = 1;
 
-		usb_set_serial_port_data(serial->port[i], priv);
+	priv->line_state    = 0;
 
-		spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->lock);
 
-		/* priv->termios is left uninitialized until port opening */
-		init_waitqueue_head(&serial->port[i]->write_wait);
-	}
+	/* priv->termios is left uninitialized until port opening */
 
-	return 0;
+	usb_set_serial_port_data(port, priv);
 
-err_cleanup:
-	for (; i >= 0; i--) {
-		priv = usb_get_serial_port_data(serial->port[i]);
-		kfree(priv);
-		usb_set_serial_port_data(serial->port[i], NULL);
-	}
-	return -ENOMEM;
+	return 0;
 }
 
-static void klsi_105_release(struct usb_serial *serial)
+static int klsi_105_port_remove(struct usb_serial_port *port)
 {
-	int i;
+	struct klsi_105_private *priv;
 
-	for (i = 0; i < serial->num_ports; ++i)
-		kfree(usb_get_serial_port_data(serial->port[i]));
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)


