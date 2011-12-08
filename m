Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1LHGaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:30:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33993 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:30:21 -0500
From: Aman Deep <amandeep3986@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Robert Morell <rmorell@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andiry Xu <andiry.xu@amd.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aman Deep <amandeep3986@gmail.com>
Subject: [PATCH 1/1] USB: Adding #define in hub_configure() and hcd.c file
Date: Thu,  8 Dec 2011 12:05:22 +0530
Message-Id: <1323326122-23479-1-git-send-email-amandeep3986@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in succession of previous patch
commit c8421147926fcacf53081a36438a0bed394da9f5
        xHCI: Adding #define values used for hub descriptor

Hub descriptors characteristics #defines values are added in
hub_configure() in place of magic numbers as asked by Alan Stern.
And the indentation for switch and case is changed to be same.

Some #defines values are added in ch11.h for defining hub class
protocols and used in hub.c and hcd.c in which magic values were
used for hub class protocols.

Signed-off-by: Aman Deep <amandeep3986@gmail.com>
---
 drivers/usb/core/hcd.c   |    2 +-
 drivers/usb/core/hub.c   |   88 +++++++++++++++++++++++-----------------------
 include/linux/usb/ch11.h |   11 ++++++
 3 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 13222d3..13d75a0 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -658,7 +658,7 @@ error:
 				len > offsetof(struct usb_device_descriptor,
 						bDeviceProtocol))
 			((struct usb_device_descriptor *) ubuf)->
-					bDeviceProtocol = 1;
+				bDeviceProtocol = USB_HUB_PR_HS_SINGLE_TT;
 	}
 
 	/* any errors get returned through the urb completion */
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7978146..8e22153 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -84,7 +84,7 @@ struct usb_hub {
 
 static inline int hub_is_superspeed(struct usb_device *hdev)
 {
-	return (hdev->descriptor.bDeviceProtocol == 3);
+	return (hdev->descriptor.bDeviceProtocol == USB_HUB_PR_SS);
 }
 
 /* Protect struct usb_device->state and ->children members
@@ -1041,58 +1041,58 @@ static int hub_configure(struct usb_hub *hub,
 		dev_dbg(hub_dev, "standalone hub\n");
 
 	switch (wHubCharacteristics & HUB_CHAR_LPSM) {
-		case 0x00:
-			dev_dbg(hub_dev, "ganged power switching\n");
-			break;
-		case 0x01:
-			dev_dbg(hub_dev, "individual port power switching\n");
-			break;
-		case 0x02:
-		case 0x03:
-			dev_dbg(hub_dev, "no power switching (usb 1.0)\n");
-			break;
+	case HUB_CHAR_COMMON_LPSM:
+		dev_dbg(hub_dev, "ganged power switching\n");
+		break;
+	case HUB_CHAR_INDV_PORT_LPSM:
+		dev_dbg(hub_dev, "individual port power switching\n");
+		break;
+	case HUB_CHAR_NO_LPSM:
+	case HUB_CHAR_LPSM:
+		dev_dbg(hub_dev, "no power switching (usb 1.0)\n");
+		break;
 	}
 
 	switch (wHubCharacteristics & HUB_CHAR_OCPM) {
-		case 0x00:
-			dev_dbg(hub_dev, "global over-current protection\n");
-			break;
-		case 0x08:
-			dev_dbg(hub_dev, "individual port over-current protection\n");
-			break;
-		case 0x10:
-		case 0x18:
-			dev_dbg(hub_dev, "no over-current protection\n");
-                        break;
+	case HUB_CHAR_COMMON_OCPM:
+		dev_dbg(hub_dev, "global over-current protection\n");
+		break;
+	case HUB_CHAR_INDV_PORT_OCPM:
+		dev_dbg(hub_dev, "individual port over-current protection\n");
+		break;
+	case HUB_CHAR_NO_OCPM:
+	case HUB_CHAR_OCPM:
+		dev_dbg(hub_dev, "no over-current protection\n");
+		break;
 	}
 
 	spin_lock_init (&hub->tt.lock);
 	INIT_LIST_HEAD (&hub->tt.clear_list);
 	INIT_WORK(&hub->tt.clear_work, hub_tt_work);
 	switch (hdev->descriptor.bDeviceProtocol) {
-		case 0:
-			break;
-		case 1:
-			dev_dbg(hub_dev, "Single TT\n");
-			hub->tt.hub = hdev;
-			break;
-		case 2:
-			ret = usb_set_interface(hdev, 0, 1);
-			if (ret == 0) {
-				dev_dbg(hub_dev, "TT per port\n");
-				hub->tt.multi = 1;
-			} else
-				dev_err(hub_dev, "Using single TT (err %d)\n",
-					ret);
-			hub->tt.hub = hdev;
-			break;
-		case 3:
-			/* USB 3.0 hubs don't have a TT */
-			break;
-		default:
-			dev_dbg(hub_dev, "Unrecognized hub protocol %d\n",
-				hdev->descriptor.bDeviceProtocol);
-			break;
+	case USB_HUB_PR_FS:
+		break;
+	case USB_HUB_PR_HS_SINGLE_TT:
+		dev_dbg(hub_dev, "Single TT\n");
+		hub->tt.hub = hdev;
+		break;
+	case USB_HUB_PR_HS_MULTI_TT:
+		ret = usb_set_interface(hdev, 0, 1);
+		if (ret == 0) {
+			dev_dbg(hub_dev, "TT per port\n");
+			hub->tt.multi = 1;
+		} else
+			dev_err(hub_dev, "Using single TT (err %d)\n",
+				ret);
+		hub->tt.hub = hdev;
+		break;
+	case USB_HUB_PR_SS:
+		/* USB 3.0 hubs don't have a TT */
+		break;
+	default:
+		dev_dbg(hub_dev, "Unrecognized hub protocol %d\n",
+			hdev->descriptor.bDeviceProtocol);
+		break;
 	}
 
 	/* Note 8 FS bit times == (8 bits / 12000000 bps) ~= 666ns */
diff --git a/include/linux/usb/ch11.h b/include/linux/usb/ch11.h
index 537f354..ad6942b 100644
--- a/include/linux/usb/ch11.h
+++ b/include/linux/usb/ch11.h
@@ -207,6 +207,17 @@ struct usb_hub_status {
 #define USB_DT_HUB_NONVAR_SIZE		7
 #define USB_DT_SS_HUB_SIZE              12
 
+/*
+ * Hub Device descriptor
+ * USB Hub class device protocols
+ */
+
+#define USB_HUB_PR_FS		0 /* Full speed hub */
+#define USB_HUB_PR_HS_NO_TT	0 /* Hi-speed hub without TT */
+#define USB_HUB_PR_HS_SINGLE_TT	1 /* Hi-speed hub with single TT */
+#define USB_HUB_PR_HS_MULTI_TT	2 /* Hi-speed hub with multiple TT */
+#define USB_HUB_PR_SS		3 /* Super speed hub */
+
 struct usb_hub_descriptor {
 	__u8  bDescLength;
 	__u8  bDescriptorType;
-- 
1.7.6

