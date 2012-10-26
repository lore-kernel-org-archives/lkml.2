Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2JZAUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:20:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:53705 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab2JZAH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 41/85] USB: io_edgeport: fix port-data memory leak
Date: Thu, 25 Oct 2012 17:05:59 -0700
Message-Id: <20121026000035.249018751@linuxfoundation.org>
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

commit c27f3efc56080a246f6ab7f57f0a6f56d256d769 upstream.

Fix port-data memory leak by moving port data allocation and
deallocation to port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_edgeport.c |   54 ++++++++++++++++++++-------------------
 drivers/usb/serial/io_tables.h   |    8 +++++
 2 files changed, 37 insertions(+), 25 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -228,6 +228,8 @@ static int  edge_get_icount(struct tty_s
 static int  edge_startup(struct usb_serial *serial);
 static void edge_disconnect(struct usb_serial *serial);
 static void edge_release(struct usb_serial *serial);
+static int edge_port_probe(struct usb_serial_port *port);
+static int edge_port_remove(struct usb_serial_port *port);
 
 #include "io_tables.h"	/* all of the devices that this driver supports */
 
@@ -2921,9 +2923,8 @@ static void load_application_firmware(st
 static int edge_startup(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial;
-	struct edgeport_port *edge_port;
 	struct usb_device *dev;
-	int i, j;
+	int i;
 	int response;
 	bool interrupt_in_found;
 	bool bulk_in_found;
@@ -3007,26 +3008,6 @@ static int edge_startup(struct usb_seria
 	/* we set up the pointers to the endpoints in the edge_open function,
 	 * as the structures aren't created yet. */
 
-	/* set up our port private structures */
-	for (i = 0; i < serial->num_ports; ++i) {
-		edge_port = kzalloc(sizeof(struct edgeport_port), GFP_KERNEL);
-		if (edge_port == NULL) {
-			dev_err(&serial->dev->dev, "%s - Out of memory\n",
-								   __func__);
-			for (j = 0; j < i; ++j) {
-				kfree(usb_get_serial_port_data(serial->port[j]));
-				usb_set_serial_port_data(serial->port[j],
-									NULL);
-			}
-			usb_set_serial_data(serial, NULL);
-			kfree(edge_serial);
-			return -ENOMEM;
-		}
-		spin_lock_init(&edge_port->ep_lock);
-		edge_port->port = serial->port[i];
-		usb_set_serial_port_data(serial->port[i], edge_port);
-	}
-
 	response = 0;
 
 	if (edge_serial->is_epic) {
@@ -3175,12 +3156,35 @@ static void edge_release(struct usb_seri
 
 	dbg("%s", __func__);
 
-	for (i = 0; i < serial->num_ports; ++i)
-		kfree(usb_get_serial_port_data(serial->port[i]));
-
 	kfree(edge_serial);
 }
 
+static int edge_port_probe(struct usb_serial_port *port)
+{
+	struct edgeport_port *edge_port;
+
+	edge_port = kzalloc(sizeof(*edge_port), GFP_KERNEL);
+	if (!edge_port)
+		return -ENOMEM;
+
+	spin_lock_init(&edge_port->ep_lock);
+	edge_port->port = port;
+
+	usb_set_serial_port_data(port, edge_port);
+
+	return 0;
+}
+
+static int edge_port_remove(struct usb_serial_port *port)
+{
+	struct edgeport_port *edge_port;
+
+	edge_port = usb_get_serial_port_data(port);
+	kfree(edge_port);
+
+	return 0;
+}
+
 module_usb_serial_driver(serial_drivers, id_table_combined);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
--- a/drivers/usb/serial/io_tables.h
+++ b/drivers/usb/serial/io_tables.h
@@ -110,6 +110,8 @@ static struct usb_serial_driver edgeport
 	.attach			= edge_startup,
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
+	.port_probe		= edge_port_probe,
+	.port_remove		= edge_port_remove,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -139,6 +141,8 @@ static struct usb_serial_driver edgeport
 	.attach			= edge_startup,
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
+	.port_probe		= edge_port_probe,
+	.port_remove		= edge_port_remove,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -168,6 +172,8 @@ static struct usb_serial_driver edgeport
 	.attach			= edge_startup,
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
+	.port_probe		= edge_port_probe,
+	.port_remove		= edge_port_remove,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -197,6 +203,8 @@ static struct usb_serial_driver epic_dev
 	.attach			= edge_startup,
 	.disconnect		= edge_disconnect,
 	.release		= edge_release,
+	.port_probe		= edge_port_probe,
+	.port_remove		= edge_port_remove,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,


