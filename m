Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1C1OGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab1C1OGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:06:31 -0400
Subject: [GIT PATCH] Fix memory leak in qcserial driver
From: Steven Hardy <shardy@redhat.com>
To: gregkh@suse.de, mjg@redhat.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 15:06:26 +0100
Message-ID: <1301321186.4397.13.camel@shardy.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been experimenting with kmemleak and noticed a recurring leak warning whenever I load & unload the qcserial driver.

Inspection of the code seems to indicate the leak is the serial->private data allocated in the qcprobe() function, 
which is never freed (apart from in some of the qcprobe error paths) as far as I can tell.

The patch below fixes the following problems:
1 - Always free the serial->private data allocated in qcprobe, added a new function qc_release which frees the memory rather 
than relying on the usb_wwan_release function which does not.  Without this cleanup, we leak the memory allocated in qcprobe 
when the kfree(serial) happens in usb-serial.c::destroy_serial()

2 - Ensure that the serial->private data is freed in the event of the probe failing and returning -ENODEV.  
This error-path leak is less likely but still possible, it was discussed previously but not actually fixed AFAICS: 
http://kerneltrap.org/mailarchive/linux-kernel/2010/6/14/4582980/thread, 
http://lkml.org/lkml/2010/6/20/234

3 - Don't assign serial->private when doing the kzalloc or serial->private ends up pointing to freed memory in the event we return -ENODEV, 
instead call usb_set_serial_data(serial, data) at the end of the function, and only have one return.

Please keep me on CC for any responses or review comments, since I'm not currently subscribed to LKML

Signed-off-by: Steve Hardy <shardy@redhat.com>

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 8858201..e66530a 100644
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
+				retval = 0;	/* Success */
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
 
@@ -166,6 +167,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		} else if (ifnum == 2) {
 			dbg("Modem port found");
@@ -177,7 +179,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 				retval = -ENODEV;
 				kfree(data);
 			}
-			return retval;
 		} else if (ifnum==3) {
 			/*
 			 * NMEA (serial line 9600 8N1)
@@ -191,6 +192,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		}
 		break;
@@ -198,13 +200,27 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	default:
 		dev_err(&serial->dev->dev,
 			"unknown number of interfaces: %d\n", nintf);
+		retval = -ENODEV;
 		kfree(data);
-		return -ENODEV;
 	}
 
+	/* Set serial->private may be null if -ENODEV */
+	usb_set_serial_data(serial, data);
 	return retval;
 }
 
+static void qc_release(struct usb_serial *serial)
+{
+	struct usb_wwan_intf_private *priv = usb_get_serial_data(serial);
+
+	dbg("%s", __func__);
+
+	/* Call usb_wwan release & free the private data allocated in qcprobe */
+	usb_wwan_release(serial);
+	usb_set_serial_data(serial, NULL);
+	kfree(priv);
+}
+
 static struct usb_serial_driver qcdevice = {
 	.driver = {
 		.owner     = THIS_MODULE,
@@ -222,7 +238,7 @@ static struct usb_serial_driver qcdevice = {
 	.chars_in_buffer     = usb_wwan_chars_in_buffer,
 	.attach		     = usb_wwan_startup,
 	.disconnect	     = usb_wwan_disconnect,
-	.release	     = usb_wwan_release,
+	.release	     = qc_release,
 #ifdef CONFIG_PM
 	.suspend	     = usb_wwan_suspend,
 	.resume		     = usb_wwan_resume,


