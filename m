Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2JZA1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:27:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:53444 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab2JZAHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 30/85] USB: f81232: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:48 -0700
Message-Id: <20121026000034.146564648@linuxfoundation.org>
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

commit 3124d1d71d3df59d40b913b5481df58099e811d1 upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/f81232.c |   43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -319,39 +319,30 @@ static int f81232_ioctl(struct tty_struc
 	return -ENOIOCTLCMD;
 }
 
-static int f81232_startup(struct usb_serial *serial)
+static int f81232_port_probe(struct usb_serial_port *port)
 {
 	struct f81232_private *priv;
-	int i;
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		priv = kzalloc(sizeof(struct f81232_private), GFP_KERNEL);
-		if (!priv)
-			goto cleanup;
-		spin_lock_init(&priv->lock);
-		init_waitqueue_head(&priv->delta_msr_wait);
-		usb_set_serial_port_data(serial->port[i], priv);
-	}
-	return 0;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->delta_msr_wait);
+
+	usb_set_serial_port_data(port, priv);
 
-cleanup:
-	for (--i; i >= 0; --i) {
-		priv = usb_get_serial_port_data(serial->port[i]);
-		kfree(priv);
-		usb_set_serial_port_data(serial->port[i], NULL);
-	}
-	return -ENOMEM;
+	return 0;
 }
 
-static void f81232_release(struct usb_serial *serial)
+static int f81232_port_remove(struct usb_serial_port *port)
 {
-	int i;
 	struct f81232_private *priv;
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		priv = usb_get_serial_port_data(serial->port[i]);
-		kfree(priv);
-	}
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 static struct usb_serial_driver f81232_device = {
@@ -374,8 +365,8 @@ static struct usb_serial_driver f81232_d
 	.tiocmset =		f81232_tiocmset,
 	.process_read_urb =	f81232_process_read_urb,
 	.read_int_callback =	f81232_read_int_callback,
-	.attach =		f81232_startup,
-	.release =		f81232_release,
+	.port_probe =		f81232_port_probe,
+	.port_remove =		f81232_port_remove,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {


