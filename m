Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2JZATZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:19:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:53764 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2JZAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 35/85] USB: kobil_sct: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:53 -0700
Message-Id: <20121026000034.646877788@linuxfoundation.org>
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

commit 95940a04bfe8a4d246f4ca17c6a3b00148bdead0 upstream.

Fix port-data memory leak by replacing attach and release with
port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/kobil_sct.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -56,8 +56,8 @@ static bool debug;
 
 
 /* Function prototypes */
-static int  kobil_startup(struct usb_serial *serial);
-static void kobil_release(struct usb_serial *serial);
+static int kobil_port_probe(struct usb_serial_port *probe);
+static int kobil_port_remove(struct usb_serial_port *probe);
 static int  kobil_open(struct tty_struct *tty, struct usb_serial_port *port);
 static void kobil_close(struct usb_serial_port *port);
 static int  kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
@@ -91,8 +91,8 @@ static struct usb_serial_driver kobil_de
 	.description =		"KOBIL USB smart card terminal",
 	.id_table =		id_table,
 	.num_ports =		1,
-	.attach =		kobil_startup,
-	.release =		kobil_release,
+	.port_probe =		kobil_port_probe,
+	.port_remove =		kobil_port_remove,
 	.ioctl =		kobil_ioctl,
 	.set_termios =		kobil_set_termios,
 	.init_termios =		kobil_init_termios,
@@ -119,9 +119,10 @@ struct kobil_private {
 };
 
 
-static int kobil_startup(struct usb_serial *serial)
+static int kobil_port_probe(struct usb_serial_port *port)
 {
 	int i;
+	struct usb_serial *serial = port->serial;
 	struct kobil_private *priv;
 	struct usb_device *pdev;
 	struct usb_host_config *actconfig;
@@ -152,7 +153,7 @@ static int kobil_startup(struct usb_seri
 		printk(KERN_DEBUG "KOBIL KAAN SIM detected\n");
 		break;
 	}
-	usb_set_serial_port_data(serial->port[0], priv);
+	usb_set_serial_port_data(port, priv);
 
 	/* search for the necessary endpoints */
 	pdev = serial->dev;
@@ -180,12 +181,14 @@ static int kobil_startup(struct usb_seri
 }
 
 
-static void kobil_release(struct usb_serial *serial)
+static int kobil_port_remove(struct usb_serial_port *port)
 {
-	int i;
+	struct kobil_private *priv;
 
-	for (i = 0; i < serial->num_ports; ++i)
-		kfree(usb_get_serial_port_data(serial->port[i]));
+	priv = usb_get_serial_port_data(port);
+	kfree(priv);
+
+	return 0;
 }
 
 static void kobil_init_termios(struct tty_struct *tty)


