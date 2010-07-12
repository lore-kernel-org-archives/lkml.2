Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0GLOr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:47:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0GLOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i2BFHRr538CVmQdUtGStBlfR3IbBKaj9OYFpNFsRDjiA0AkQYp3nGJWH5HENoWnrOH
         1s0sE43dJNxxUVMVpQlHGYSG7qe1EM/8fbH4DVb9vjyjWxSBAWDPuUe2AmUdhxnYQg+Z
         DtG299U/afhxDlmhikmnfNIrBYHZyH5JuvuAs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Tejun Heo <tj@kernel.org>, Stoyan Gaydarov <sgayda2@uiuc.edu>,
        =?UTF-8?q?N=C3=A9meth=20M=C3=A1rton?= <nm127@freemail.hu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: line6: fix leaks in line6_probe()
Date: Mon, 12 Jul 2010 18:47:30 +0400
Message-Id: <1278946051-30118-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If error occurs line6_probe() must put interface and usbdev that were
got before.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/line6/driver.c |   68 ++++++++++++++++++++++++----------------
 1 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 1d5a473..d1728be 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -679,8 +679,10 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 	usb_get_dev(usbdev);
 
 	/* we don't handle multiple configurations */
-	if (usbdev->descriptor.bNumConfigurations != 1)
-		return -ENODEV;
+	if (usbdev->descriptor.bNumConfigurations != 1) {
+		ret = -ENODEV;
+		goto err_put;
+	}
 
 	/* check vendor and product id */
 	for (devtype = ARRAY_SIZE(line6_id_table) - 1; devtype--;) {
@@ -692,16 +694,20 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 			break;
 	}
 
-	if (devtype < 0)
-		return -ENODEV;
+	if (devtype < 0) {
+		ret = -ENODEV;
+		goto err_put;
+	}
 
 	/* find free slot in device table: */
 	for (devnum = 0; devnum < LINE6_MAX_DEVICES; ++devnum)
 		if (line6_devices[devnum] == NULL)
 			break;
 
-	if (devnum == LINE6_MAX_DEVICES)
-		return -ENODEV;
+	if (devnum == LINE6_MAX_DEVICES) {
+		ret = -ENODEV;
+		goto err_put;
+	}
 
 	/* initialize device info: */
 	properties = &line6_properties_table[devtype];
@@ -762,13 +768,14 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 
 	default:
 		MISSING_CASE;
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put;
 	}
 
 	ret = usb_set_interface(usbdev, interface_number, alternate);
 	if (ret < 0) {
 		dev_err(&interface->dev, "set_interface failed\n");
-		return ret;
+		goto err_put;
 	}
 
 	/* initialize device data based on product id: */
@@ -815,7 +822,8 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 			break;
 
 		default:
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err_put;
 		}
 		break;
 
@@ -827,19 +835,22 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 
 	default:
 		MISSING_CASE;
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put;
 	}
 
 	if (size == 0) {
 		dev_err(line6->ifcdev, "driver bug: interface data size not set\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put;
 	}
 
 	line6 = kzalloc(size, GFP_KERNEL);
 
 	if (line6 == NULL) {
 		dev_err(&interface->dev, "Out of memory\n");
-		return -ENOMEM;
+		ret = -ENODEV;
+		goto err_put;
 	}
 
 	/* store basic data: */
@@ -875,16 +886,16 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 
 		if (line6->buffer_listen == NULL) {
 			dev_err(&interface->dev, "Out of memory\n");
-			line6_destruct(interface);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_destruct;
 		}
 
 		line6->buffer_message = kmalloc(LINE6_MESSAGE_MAXLEN, GFP_KERNEL);
 
 		if (line6->buffer_message == NULL) {
 			dev_err(&interface->dev, "Out of memory\n");
-			line6_destruct(interface);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_destruct;
 		}
 
 		line6->urb_listen = usb_alloc_urb(0, GFP_KERNEL);
@@ -892,15 +903,15 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 		if (line6->urb_listen == NULL) {
 			dev_err(&interface->dev, "Out of memory\n");
 			line6_destruct(interface);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_destruct;
 		}
 
 		ret = line6_start_listen(line6);
 		if (ret < 0) {
 			dev_err(&interface->dev, "%s: usb_submit_urb failed\n",
 				__func__);
-			line6_destruct(interface);
-			return ret;
+			goto err_destruct;
 		}
 	}
 
@@ -952,22 +963,25 @@ static int line6_probe(struct usb_interface *interface, const struct usb_device_
 		ret = -ENODEV;
 	}
 
-	if (ret < 0) {
-		line6_destruct(interface);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_destruct;
 
 	ret = sysfs_create_link(&interface->dev.kobj, &usbdev->dev.kobj,
 				"usb_device");
-	if (ret < 0) {
-		line6_destruct(interface);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_put;
 
 	dev_info(&interface->dev, "Line6 %s now attached\n",
 		 line6->properties->name);
 	line6_devices[devnum] = line6;
 	line6_list_devices();
+	return 0;
+
+err_destruct:
+	line6_destruct(interface);
+err_put:
+	usb_put_intf(interface);
+	usb_put_dev(usbdev);
 	return ret;
 }
 
-- 
1.7.0.4

