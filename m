Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562Ab2J2WFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:05:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:47761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761224Ab2J2Vhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 066/101] USB: sierra: fix port-data memory leak
Date: Mon, 29 Oct 2012 14:35:19 -0700
Message-Id: <20121029213247.641207579@linuxfoundation.org>
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

commit f525c05babc7938cc1d4236550fd8a659fb05960 upstream.

Fix port-data memory leak by moving port data allocation and
deallocation to port_probe and port_remove.

Since commit 0998d0631001288 (device-core: Ensure drvdata = NULL when no
driver is bound) the port private data is no longer freed at release as
it is no longer accessible.

Note also that urb-count for multi-port interfaces has not been changed
even though the usb-serial port number is now determined from the port
and interface minor numbers.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |  127 ++++++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 68 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -880,12 +880,7 @@ static void sierra_dtr_rts(struct usb_se
 
 static int sierra_startup(struct usb_serial *serial)
 {
-	struct usb_serial_port *port;
 	struct sierra_intf_private *intfdata;
-	struct sierra_port_private *portdata;
-	struct sierra_iface_info *himemoryp = NULL;
-	int i;
-	u8 ifnum;
 
 	intfdata = kzalloc(sizeof(*intfdata), GFP_KERNEL);
 	if (!intfdata)
@@ -902,77 +897,71 @@ static int sierra_startup(struct usb_ser
 	if (nmea)
 		sierra_vsc_set_nmea(serial->dev, 1);
 
-	/* Now setup per port private data */
-	for (i = 0; i < serial->num_ports; i++) {
-		port = serial->port[i];
-		portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
-		if (!portdata) {
-			dev_dbg(&port->dev, "%s: kmalloc for "
-				"sierra_port_private (%d) failed!\n",
-				__func__, i);
-			goto err;
-		}
-		spin_lock_init(&portdata->lock);
-		init_usb_anchor(&portdata->active);
-		init_usb_anchor(&portdata->delayed);
-		ifnum = i;
-		/* Assume low memory requirements */
-		portdata->num_out_urbs = N_OUT_URB;
-		portdata->num_in_urbs  = N_IN_URB;
-
-		/* Determine actual memory requirements */
-		if (serial->num_ports == 1) {
-			/* Get interface number for composite device */
-			ifnum = sierra_calc_interface(serial);
-			himemoryp =
-			    (struct sierra_iface_info *)&typeB_interface_list;
-			if (is_himemory(ifnum, himemoryp)) {
-				portdata->num_out_urbs = N_OUT_URB_HM;
-				portdata->num_in_urbs  = N_IN_URB_HM;
-			}
-		}
-		else {
-			himemoryp =
-			    (struct sierra_iface_info *)&typeA_interface_list;
-			if (is_himemory(i, himemoryp)) {
-				portdata->num_out_urbs = N_OUT_URB_HM;
-				portdata->num_in_urbs  = N_IN_URB_HM;
-			}
-		}
-		dev_dbg(&serial->dev->dev,
-			"Memory usage (urbs) interface #%d, in=%d, out=%d\n",
-			ifnum,portdata->num_in_urbs, portdata->num_out_urbs );
-		/* Set the port private data pointer */
-		usb_set_serial_port_data(port, portdata);
-	}
-
 	return 0;
-err:
-	for (--i; i >= 0; --i) {
-		portdata = usb_get_serial_port_data(serial->port[i]);
-		kfree(portdata);
-	}
-	kfree(intfdata);
-
-	return -ENOMEM;
 }
 
 static void sierra_release(struct usb_serial *serial)
 {
-	int i;
-	struct usb_serial_port *port;
+	struct sierra_intf_private *intfdata;
+
+	intfdata = usb_get_serial_data(serial);
+	kfree(intfdata);
+}
+
+static int sierra_port_probe(struct usb_serial_port *port)
+{
+	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
+	const struct sierra_iface_info *himemoryp;
+	u8 ifnum;
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		port = serial->port[i];
-		if (!port)
-			continue;
-		portdata = usb_get_serial_port_data(port);
-		if (!portdata)
-			continue;
-		kfree(portdata);
+	portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
+	if (!portdata)
+		return -ENOMEM;
+
+	spin_lock_init(&portdata->lock);
+	init_usb_anchor(&portdata->active);
+	init_usb_anchor(&portdata->delayed);
+
+	/* Assume low memory requirements */
+	portdata->num_out_urbs = N_OUT_URB;
+	portdata->num_in_urbs  = N_IN_URB;
+
+	/* Determine actual memory requirements */
+	if (serial->num_ports == 1) {
+		/* Get interface number for composite device */
+		ifnum = sierra_calc_interface(serial);
+		himemoryp = &typeB_interface_list;
+	} else {
+		/* This is really the usb-serial port number of the interface
+		 * rather than the interface number.
+		 */
+		ifnum = port->number - serial->minor;
+		himemoryp = &typeA_interface_list;
+	}
+
+	if (is_himemory(ifnum, himemoryp)) {
+		portdata->num_out_urbs = N_OUT_URB_HM;
+		portdata->num_in_urbs  = N_IN_URB_HM;
 	}
-	kfree(serial->private);
+
+	dev_dbg(&port->dev,
+			"Memory usage (urbs) interface #%d, in=%d, out=%d\n",
+			ifnum, portdata->num_in_urbs, portdata->num_out_urbs);
+
+	usb_set_serial_port_data(port, portdata);
+
+	return 0;
+}
+
+static int sierra_port_remove(struct usb_serial_port *port)
+{
+	struct sierra_port_private *portdata;
+
+	portdata = usb_get_serial_port_data(port);
+	kfree(portdata);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1076,6 +1065,8 @@ static struct usb_serial_driver sierra_d
 	.tiocmset          = sierra_tiocmset,
 	.attach            = sierra_startup,
 	.release           = sierra_release,
+	.port_probe        = sierra_port_probe,
+	.port_remove       = sierra_port_remove,
 	.suspend	   = sierra_suspend,
 	.resume		   = sierra_resume,
 	.read_int_callback = sierra_instat_callback,


