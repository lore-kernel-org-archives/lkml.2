Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2DVGDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 02:03:03 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:45173 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2DVGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 02:02:30 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AllUAE2ek09V5qnhPGdsb2JhbABEiiqnFhkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGExuHeLldE5EgBJt9jSY
X-IronPort-AV: E=Sophos;i="4.75,461,1330902000"; 
   d="scan'208";a="317576303"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 3/6] hid: Create a generic device group
Date: Sun, 22 Apr 2012 08:05:23 +0200
Message-Id: <1335074726-2276-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335074726-2276-1-git-send-email-rydberg@euromail.se>
References: <1335074726-2276-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices that do not have a special driver are handled by the generic
driver. This patch does the same thing using device groups; Instead of
forcing a particular driver, the appropriate driver is picked up by
udev. As a consequence, one can now move a device from generic to
specific handling by a simple rebind. By adding a new device id to the
generic driver, the same thing can be done in reverse.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c        |   14 ++++++--------
 drivers/hid/usbhid/hid-core.c |    2 +-
 include/linux/hid.h           |   17 +++++++++++------
 net/bluetooth/hidp/core.c     |    2 +-
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5378cf6..32a40879 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1685,14 +1685,7 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
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
@@ -2104,6 +2097,11 @@ int hid_add_device(struct hid_device *hdev)
 		ret = hid_parse(hdev);
 		if (ret)
 			return ret;
+		/*
+		 * Generic handler picks up all non-assigned devices.
+		 */
+		if (hdev->group == HID_GROUP_ANY)
+			hdev->group = HID_GROUP_GENERIC;
 	}
 
 	/* XXX hack, any other cleaner solution after the driver core
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
index 85871f7..96197f7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -325,6 +325,11 @@ struct hid_item {
 #define HID_QUIRK_NO_INPUT_SYNC			0x80000000
 
 /*
+ * HID device groups
+ */
+#define HID_GROUP_GENERIC			0x0001
+
+/*
  * This is the global environment of the parser. This information is
  * persistent for main-items. The global environment can be saved and
  * restored with PUSH/POP statements.
@@ -579,12 +584,12 @@ struct hid_descriptor {
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

