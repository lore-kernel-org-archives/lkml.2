Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292Ab2J2Vhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:47585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761118Ab2J2VhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 051/101] USB: qcserial: fix interface-data memory leak in error path
Date: Mon, 29 Oct 2012 14:35:04 -0700
Message-Id: <20121029213245.926454169@linuxfoundation.org>
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

commit 961be09e1ead58509ed4bed0d5819a15d8613d8d upstream.

Move interface data allocation to attach so that it is deallocated
should usb-serial probe fail.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -140,7 +140,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 {
-	struct usb_wwan_intf_private *data;
 	struct usb_host_interface *intf = serial->interface->cur_altsetting;
 	struct device *dev = &serial->dev->dev;
 	int retval = -ENODEV;
@@ -156,13 +155,6 @@ static int qcprobe(struct usb_serial *se
 	ifnum = intf->desc.bInterfaceNumber;
 	dev_dbg(dev, "This Interface = %d\n", ifnum);
 
-	data = kzalloc(sizeof(struct usb_wwan_intf_private),
-					 GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	spin_lock_init(&data->susp_lock);
-
 	if (nintf == 1) {
 		/* QDL mode */
 		/* Gobi 2000 has a single altsetting, older ones have two */
@@ -255,20 +247,28 @@ done:
 		}
 	}
 
-	/* Set serial->private if not returning error */
-	if (retval == 0)
-		usb_set_serial_data(serial, data);
-	else
-		kfree(data);
-
 	return retval;
 }
 
+static int qc_attach(struct usb_serial *serial)
+{
+	struct usb_wwan_intf_private *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	spin_lock_init(&data->susp_lock);
+
+	usb_set_serial_data(serial, data);
+
+	return 0;
+}
+
 static void qc_release(struct usb_serial *serial)
 {
 	struct usb_wwan_intf_private *priv = usb_get_serial_data(serial);
 
-	/* Free the private data allocated in qcprobe */
 	usb_set_serial_data(serial, NULL);
 	kfree(priv);
 }
@@ -287,6 +287,7 @@ static struct usb_serial_driver qcdevice
 	.write		     = usb_wwan_write,
 	.write_room	     = usb_wwan_write_room,
 	.chars_in_buffer     = usb_wwan_chars_in_buffer,
+	.attach              = qc_attach,
 	.release	     = qc_release,
 	.port_probe          = usb_wwan_port_probe,
 	.port_remove	     = usb_wwan_port_remove,


