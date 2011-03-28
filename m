Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1C1Ri7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1C1Ri6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:38:58 -0400
Date: Mon, 28 Mar 2011 18:38:55 +0100
From: Steven Hardy <shardy@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: mjg@redhat.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH 2/3] Resend : Fix memory leak in qcserial driver
Message-ID: <20110328173854.GB7030@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328142148.GA19521@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328142148.GA19521@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2 of 3, addresses the problem where serial->private can end up pointing to freed memory in the event qcprobe fails & returns -ENODEV

Original description:
3 - Don't assign serial->private when doing the kzalloc or serial->private ends up pointing to freed memory in the event we return -ENODEV, instead call usb_set_serial_data(serial, data) at the end of the function, and only have one return-point.


Signed-off-by: Steve Hardy <shardy@redhat.com>


diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 6e3b933..0463dab 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -111,7 +111,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	ifnum = intf->desc.bInterfaceNumber;
 	dbg("This Interface = %d", ifnum);
 
-	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
+	data = kzalloc(sizeof(struct usb_wwan_intf_private),
 					 GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -134,8 +134,10 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
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
@@ -145,7 +147,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 				retval = -ENODEV;
 				kfree(data);
 			}
-			return retval;
 		}
 		break;
 
@@ -177,7 +178,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 				retval = -ENODEV;
 				kfree(data);
 			}
-			return retval;
 		} else if (ifnum==3) {
 			/*
 			 * NMEA (serial line 9600 8N1)
@@ -199,9 +199,11 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		dev_err(&serial->dev->dev,
 			"unknown number of interfaces: %d\n", nintf);
 		kfree(data);
-		return -ENODEV;
+		retval = -ENODEV;
 	}
 
+	/* Set serial->private may be null if -ENODEV */
+	usb_set_serial_data(serial, data);
 	return retval;
 }
 
