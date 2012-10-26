Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2JZAUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:20:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:53714 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab2JZAIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 42/85] USB: keyspan_pda: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:06:00 -0700
Message-Id: <20121026000035.344346518@linuxfoundation.org>
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

commit 94ab71ce288921490ca857e25ad174e1921b1e29 upstream.

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
 drivers/usb/serial/keyspan_pda.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -735,29 +735,33 @@ MODULE_FIRMWARE("keyspan_pda/keyspan_pda
 MODULE_FIRMWARE("keyspan_pda/xircom_pgs.fw");
 #endif
 
-static int keyspan_pda_startup(struct usb_serial *serial)
+static int keyspan_pda_port_probe(struct usb_serial_port *port)
 {
 
 	struct keyspan_pda_private *priv;
 
-	/* allocate the private data structures for all ports. Well, for all
-	   one ports. */
-
 	priv = kmalloc(sizeof(struct keyspan_pda_private), GFP_KERNEL);
 	if (!priv)
-		return 1; /* error */
-	usb_set_serial_port_data(serial->port[0], priv);
-	init_waitqueue_head(&serial->port[0]->write_wait);
+		return -ENOMEM;
+
 	INIT_WORK(&priv->wakeup_work, keyspan_pda_wakeup_write);
 	INIT_WORK(&priv->unthrottle_work, keyspan_pda_request_unthrottle);
-	priv->serial = serial;
-	priv->port = serial->port[0];
+	priv->serial = port->serial;
+	priv->port = port;
+
+	usb_set_serial_port_data(port, priv);
+
 	return 0;
 }
 
-static void keyspan_pda_release(struct usb_serial *serial)
+static int keyspan_pda_port_remove(struct usb_serial_port *port)
 {
-	kfree(usb_get_serial_port_data(serial->port[0]));
+	struct keyspan_pda_private *priv;
+
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 #ifdef KEYSPAN
@@ -808,8 +812,8 @@ static struct usb_serial_driver keyspan_
 	.break_ctl =		keyspan_pda_break_ctl,
 	.tiocmget =		keyspan_pda_tiocmget,
 	.tiocmset =		keyspan_pda_tiocmset,
-	.attach =		keyspan_pda_startup,
-	.release =		keyspan_pda_release,
+	.port_probe =		keyspan_pda_port_probe,
+	.port_remove =		keyspan_pda_port_remove,
 };
 
 static struct usb_serial_driver * const serial_drivers[] = {


