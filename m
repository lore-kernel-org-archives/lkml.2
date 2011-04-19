Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1DSUUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:20:07 -0400
Received: from kroah.org ([198.145.64.141]:35724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1DSURm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.614535681@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Hardy <shardy@redhat.com>
Subject: [60/70] usb: qcserial avoid pointing to freed memory
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Hardy <shardy@redhat.com>

commit 99ab3f9e4eaec35fd2d7159c31b71f17f7e613e3 upstream.

Rework the qcprobe logic such that serial->private is not set when
qcprobe exits with -ENODEV, otherwise serial->private will point to freed
memory on -ENODEV

Signed-off-by: Steven Hardy <shardy@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -111,7 +111,7 @@ static int qcprobe(struct usb_serial *se
 	ifnum = intf->desc.bInterfaceNumber;
 	dbg("This Interface = %d", ifnum);
 
-	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
+	data = kzalloc(sizeof(struct usb_wwan_intf_private),
 					 GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -134,8 +134,10 @@ static int qcprobe(struct usb_serial *se
 		    usb_endpoint_is_bulk_out(&intf->endpoint[1].desc)) {
 			dbg("QDL port found");
 
-			if (serial->interface->num_altsetting == 1)
-				return 0;
+			if (serial->interface->num_altsetting == 1) {
+				retval = 0; /* Success */
+				break;
+			}
 
 			retval = usb_set_interface(serial->dev, ifnum, 1);
 			if (retval < 0) {
@@ -145,7 +147,6 @@ static int qcprobe(struct usb_serial *se
 				retval = -ENODEV;
 				kfree(data);
 			}
-			return retval;
 		}
 		break;
 
@@ -177,7 +178,6 @@ static int qcprobe(struct usb_serial *se
 				retval = -ENODEV;
 				kfree(data);
 			}
-			return retval;
 		} else if (ifnum==3) {
 			/*
 			 * NMEA (serial line 9600 8N1)
@@ -199,9 +199,12 @@ static int qcprobe(struct usb_serial *se
 		dev_err(&serial->dev->dev,
 			"unknown number of interfaces: %d\n", nintf);
 		kfree(data);
-		return -ENODEV;
+		retval = -ENODEV;
 	}
 
+	/* Set serial->private if not returning -ENODEV */
+	if (retval != -ENODEV)
+		usb_set_serial_data(serial, data);
 	return retval;
 }
 


