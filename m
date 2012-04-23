Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2DWKE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:04:27 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60743 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2DWKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:04:23 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArldAAQolU9V5qnhPGdsb2JhbABEiiqnGRkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGE4gTuXQTkSAEm32NJg
X-IronPort-AV: E=Sophos;i="4.75,466,1330902000"; 
   d="scan'208";a="319921062"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [PATCH v3 4/6] hid: Create a generic device group
Date: Mon, 23 Apr 2012 12:07:05 +0200
Message-Id: <1335175627-2270-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices that do not have a special driver are handled by the generic
driver. This patch does the same thing using device groups; Instead of
forcing a particular driver, the appropriate driver is picked up by
udev. As a consequence, one can now move a device from generic to
specific handling by a simple rebind. By adding a new device id to the
generic driver, the same thing can be done in reverse.

Cc: Gustavo Padovan <gustavo@padovan.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c        |    9 +--------
 drivers/hid/usbhid/hid-core.c |    2 +-
 include/linux/hid.h           |   12 ++++++------
 net/bluetooth/hidp/core.c     |    2 +-
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 20daee5..cb5a103 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1800,14 +1800,7 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
 		!strncmp(hdrv->name, "hid-multitouch", 14))
 		return 1;
 
-	if (!hid_match_device(hdev, hdrv))
-		return 0;
-
-	/* generic wants all that don't have specialized driver */
-	if (!strncmp(hdrv->name, "generic-", 8) && !hid_ignore_special_drivers)
-		return !hid_match_id(hdev, hid_have_special_driver);
-
-	return 1;
+	return hid_match_device(hdev, hdrv) != NULL;
 }
 
 static int hid_device_probe(struct device *dev)
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..9abf718 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1505,7 +1505,7 @@ static struct usb_driver hid_driver = {
 };
 
 static const struct hid_device_id hid_usb_table[] = {
-	{ HID_USB_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index f45d33d..dd694fb 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -586,12 +586,12 @@ struct hid_descriptor {
 	struct hid_class_descriptor desc[1];
 } __attribute__ ((packed));
 
-#define HID_DEVICE(b, ven, prod) \
-	.bus = (b), \
-	.vendor = (ven), .product = (prod)
-
-#define HID_USB_DEVICE(ven, prod)	HID_DEVICE(BUS_USB, ven, prod)
-#define HID_BLUETOOTH_DEVICE(ven, prod)	HID_DEVICE(BUS_BLUETOOTH, ven, prod)
+#define HID_DEVICE(b, g, ven, prod)					\
+	.bus = (b), .group = (g), .vendor = (ven), .product = (prod)
+#define HID_USB_DEVICE(ven, prod)				\
+	.bus = BUS_USB, .vendor = (ven), .product = (prod)
+#define HID_BLUETOOTH_DEVICE(ven, prod)					\
+	.bus = BUS_BLUETOOTH, .vendor = (ven), .product = (prod)
 
 #define HID_REPORT_ID(rep) \
 	.report_type = (rep)
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index d478be1..b6fa982 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1196,7 +1196,7 @@ int hidp_get_conninfo(struct hidp_conninfo *ci)
 }
 
 static const struct hid_device_id hidp_table[] = {
-	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
+	{ HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
 
-- 
1.7.10

