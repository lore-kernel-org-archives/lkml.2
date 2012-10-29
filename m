Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab2J2UJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:09:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:42719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2J2UJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:09:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 20/34] USB: sierra: fix memory leak in probe error path
Date: Mon, 29 Oct 2012 13:07:51 -0700
Message-Id: <20121029200422.799301912@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 084817d79399ab5ccab2f90a148b0369912a8369 upstream.

Move interface data allocation to attach so that it is deallocated on
errors in usb-serial probe.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


