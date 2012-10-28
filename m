Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2J1XpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:45:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41892 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab2J1X10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:26 -0400
Message-Id: <20121028231603.353113832@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 085/105] USB: sierra: fix memory leak in probe error path
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 084817d79399ab5ccab2f90a148b0369912a8369 upstream.

Move interface data allocation to attach so that it is deallocated on
errors in usb-serial probe.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -171,7 +171,6 @@ static int sierra_probe(struct usb_seria
 {
 	int result = 0;
 	struct usb_device *udev;
-	struct sierra_intf_private *data;
 	u8 ifnum;
 
 	udev = serial->dev;
@@ -199,11 +198,6 @@ static int sierra_probe(struct usb_seria
 		return -ENODEV;
 	}
 
-	data = serial->private = kzalloc(sizeof(struct sierra_intf_private), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	spin_lock_init(&data->susp_lock);
-
 	return result;
 }
 
@@ -915,6 +909,7 @@ static void sierra_dtr_rts(struct usb_se
 static int sierra_startup(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
+	struct sierra_intf_private *intfdata;
 	struct sierra_port_private *portdata;
 	struct sierra_iface_info *himemoryp = NULL;
 	int i;
@@ -922,6 +917,14 @@ static int sierra_startup(struct usb_ser
 
 	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
+	intfdata = kzalloc(sizeof(*intfdata), GFP_KERNEL);
+	if (!intfdata)
+		return -ENOMEM;
+
+	spin_lock_init(&intfdata->susp_lock);
+
+	usb_set_serial_data(serial, intfdata);
+
 	/* Set Device mode to D0 */
 	sierra_set_power_state(serial->dev, 0x0000);
 
@@ -979,6 +982,7 @@ err:
 		portdata = usb_get_serial_port_data(serial->port[i]);
 		kfree(portdata);
 	}
+	kfree(intfdata);
 
 	return -ENOMEM;
 }


