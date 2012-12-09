Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab2LILpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:45:09 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45006 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2LILpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:45:07 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] HID: autodetect USB HID sensor hubs.
Date: Sun,  9 Dec 2012 12:44:30 +0100
Message-Id: <1355053470-3939-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <50C47811.7010503@ahsoftware.de>
References: <50C47811.7010503@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should not be necessary to add IDs for HID sensor hubs to lists
in hid-core.c and hid-sensor-hub.c. So instead of a whitelist,
autodetect such USB HID sensor hubs, based on a collection of type
physical inside a useage page of type sensor. If some sensor hubs
stil must be usable as raw devices, a blacklist might be created.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/hid/hid-core.c         |   11 ++++++++++-
 drivers/hid/hid-sensor-hub.c   |   32 +-------------------------------
 include/linux/hid-sensor-ids.h |    1 -
 include/linux/hid.h            |    2 ++
 4 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f4109fd..7df5399 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -713,7 +713,12 @@ static int hid_scan_report(struct hid_device *hid)
 					hid_scan_usage(hid, u);
 				break;
 			}
-		}
+		} else if (page == HID_UP_SENSOR &&
+			item.type == HID_ITEM_TYPE_MAIN &&
+			item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
+			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL &&
+			hid->bus == BUS_USB)
+			hid->group = HID_GROUP_SENSOR_HUB;
 	}
 
 	return 0;
@@ -1465,6 +1470,10 @@ EXPORT_SYMBOL_GPL(hid_disconnect);
  * there is a proper autodetection and autoloading in place (based on presence
  * of HID_DG_CONTACTID), so those devices don't need to be added to this list,
  * as we are doing the right thing in hid_scan_usage().
+ *
+ * Autodetection for (USB) HID sensor hubs exists too. If a collection of type
+ * physical is found inside a usage page of type sensor, hid-sensor-hub will be
+ * used as a driver. See hid_scan_report().
  */
 static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index d9d73e9..ca88ddc 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -82,23 +82,6 @@ struct hid_sensor_hub_callbacks_list {
 	void *priv;
 };
 
-static int sensor_hub_check_for_sensor_page(struct hid_device *hdev)
-{
-	int i;
-	int ret = -EINVAL;
-
-	for (i = 0; i < hdev->maxcollection; i++) {
-		struct hid_collection *col = &hdev->collection[i];
-		if (col->type == HID_COLLECTION_PHYSICAL &&
-		   (col->usage & HID_USAGE_PAGE) == HID_UP_SENSOR) {
-			ret = 0;
-			break;
-		}
-	}
-
-	return ret;
-}
-
 static struct hid_report *sensor_hub_report(int id, struct hid_device *hdev,
 						int dir)
 {
@@ -524,10 +507,6 @@ static int sensor_hub_probe(struct hid_device *hdev,
 		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
-	if (sensor_hub_check_for_sensor_page(hdev) < 0) {
-		hid_err(hdev, "sensor page not found\n");
-		goto err_free;
-	}
 	INIT_LIST_HEAD(&hdev->inputs);
 
 	ret = hid_hw_start(hdev, 0);
@@ -630,16 +609,7 @@ static void sensor_hub_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id sensor_hub_devices[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8086,
-			USB_DEVICE_ID_SENSOR_HUB_1020) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8087,
-			USB_DEVICE_ID_SENSOR_HUB_1020) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8086,
-			USB_DEVICE_ID_SENSOR_HUB_09FA) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_INTEL_8087,
-			USB_DEVICE_ID_SENSOR_HUB_09FA) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
-			USB_DEVICE_ID_SENSOR_HUB_7014) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_SENSOR_HUB, HID_ANY_ID, HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sensor_hub_devices);
diff --git a/include/linux/hid-sensor-ids.h b/include/linux/hid-sensor-ids.h
index ca8d7e9..55f2773 100644
--- a/include/linux/hid-sensor-ids.h
+++ b/include/linux/hid-sensor-ids.h
@@ -19,7 +19,6 @@
 #ifndef _HID_SENSORS_IDS_H
 #define _HID_SENSORS_IDS_H
 
-#define HID_UP_SENSOR						0x00200000
 #define HID_MAX_PHY_DEVICES					0xFF
 
 /* Accel 3D (200073) */
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c076041..c5f6ec2 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -167,6 +167,7 @@ struct hid_item {
 #define HID_UP_MSVENDOR		0xff000000
 #define HID_UP_CUSTOM		0x00ff0000
 #define HID_UP_LOGIVENDOR	0xffbc0000
+#define HID_UP_SENSOR		0x00200000
 
 #define HID_USAGE		0x0000ffff
 
@@ -292,6 +293,7 @@ struct hid_item {
  */
 #define HID_GROUP_GENERIC			0x0001
 #define HID_GROUP_MULTITOUCH			0x0002
+#define HID_GROUP_SENSOR_HUB			0x0003
 
 /*
  * This is the global environment of the parser. This information is
-- 
1.7.8.6

