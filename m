Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0FHH2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:28:37 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:50295 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0FHH2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dzuBUuyC2D1kDD8WklKNNoljQw8b8nWpnhffBI4Wgb9Eo9NAmv8fnav0bwcq+HbNDa
         CXLoMmxoPc3W+1mhbxhjeGb/wPUbhjHMnRFUDemangeMamaYVNbsqVEvkpvTwM5gWhb7
         OAIQUbPxaXBlAduy4zHetFrgeT/oEVCG3Deq8=
Subject: [PATCH] qcserial: fix a memory leak in qcprobe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Bernhard Rosenkraenzer <bero@arklinux.org>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Tue, 08 Jun 2010 15:29:23 +0800
Message-Id: <1275982163.17060.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implemtation, the "data" is not kfreed in qcprobe error path.
This patch moves the memory allocation a little bit latter and only
allocate memory when no error is detected in previous checking.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/serial/qcserial.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 04bb759..d30078c 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -109,13 +109,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 	ifnum = intf->desc.bInterfaceNumber;
 	dbg("This Interface = %d", ifnum);
 
-	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
-					 GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	spin_lock_init(&data->susp_lock);
-
 	switch (nintf) {
 	case 1:
 		/* QDL mode */
@@ -130,8 +123,10 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 		    usb_endpoint_is_bulk_out(&intf->endpoint[1].desc)) {
 			dbg("QDL port found");
 
-			if (serial->interface->num_altsetting == 1)
-				return 0;
+			if (serial->interface->num_altsetting == 1) {
+				retval = 0;
+				goto out;
+			}
 
 			retval = usb_set_interface(serial->dev, ifnum, 1);
 			if (retval < 0) {
@@ -140,7 +135,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					retval);
 				retval = -ENODEV;
 			}
-			return retval;
+			goto out;
 		}
 		break;
 
@@ -156,17 +151,26 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					retval);
 				retval = -ENODEV;
 			}
-			return retval;
+			goto out;
 		}
 		break;
 
 	default:
 		dev_err(&serial->dev->dev,
 			"unknown number of interfaces: %d\n", nintf);
-		return -ENODEV;
 	}
 
-	return retval;
+out:
+	if (retval)
+		return retval;
+
+	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
+					 GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	spin_lock_init(&data->susp_lock);
+	return 0;
 }
 
 static struct usb_serial_driver qcdevice = {
-- 
1.5.4.3



