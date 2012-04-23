Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2DWKEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:04:08 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60688 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2DWKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:04:05 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArldAMcnlU9V5qnhPGdsb2JhbABEiiqnGRkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGExuHeLl0E5EgBJt9jSY
X-IronPort-AV: E=Sophos;i="4.75,466,1330902000"; 
   d="scan'208";a="23553297"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/6] hid: Scan the device for group info before adding it
Date: Mon, 23 Apr 2012 12:07:03 +0200
Message-Id: <1335175627-2270-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow the report descriptor to influence the hid device
properties, one needs to parse the descriptor early, without reference
to any driver. Scan the descriptor for group information during device
add, before the device has been broadcast to userland. The device
modalias will contain group information which can be used to
differentiate between modules. For starters, just handle the generic
group.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h    |    5 ++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index cfcb69e..f932cd5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -658,6 +658,58 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 	return NULL;
 }
 
+static void hid_scan_usage(struct hid_device *hid, u32 usage)
+{
+}
+
+/*
+ * Scan a report descriptor before the device is added to the bus.
+ * Sets device groups and other properties that determine what driver
+ * to load.
+ */
+static int hid_scan_report(struct hid_device *hid)
+{
+	unsigned int page = 0, delim = 0;
+	__u8 *start = hid->dev_rdesc;
+	__u8 *end = start + hid->dev_rsize;
+	unsigned int u, u_min = 0, u_max = 0;
+	struct hid_item item;
+
+	hid->group = HID_GROUP_GENERIC;
+	while ((start = fetch_item(start, end, &item)) != NULL) {
+		if (item.format != HID_ITEM_FORMAT_SHORT)
+			return -EINVAL;
+		if (item.type == HID_ITEM_TYPE_GLOBAL) {
+			if (item.tag == HID_GLOBAL_ITEM_TAG_USAGE_PAGE)
+				page = item_udata(&item) << 16;
+		} else if (item.type == HID_ITEM_TYPE_LOCAL) {
+			if (delim > 1)
+				break;
+			u = item_udata(&item);
+			if (item.size <= 2)
+				u += page;
+			switch (item.tag) {
+			case HID_LOCAL_ITEM_TAG_DELIMITER:
+				delim += !!u;
+				break;
+			case HID_LOCAL_ITEM_TAG_USAGE:
+				hid_scan_usage(hid, u);
+				break;
+			case HID_LOCAL_ITEM_TAG_USAGE_MINIMUM:
+				u_min = u;
+				break;
+			case HID_LOCAL_ITEM_TAG_USAGE_MAXIMUM:
+				u_max = u;
+				for (u = u_min; u <= u_max; u++)
+					hid_scan_usage(hid, u);
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /**
  * hid_parse_report - parse device report
  *
@@ -2171,6 +2223,16 @@ int hid_add_device(struct hid_device *hdev)
 	if (!hdev->dev_rdesc)
 		return -ENODEV;
 
+	/*
+	 * Scan generic devices for group information
+	 */
+	if (hid_ignore_special_drivers ||
+	    !hid_match_id(hdev, hid_have_special_driver)) {
+		ret = hid_scan_report(hdev);
+		if (ret)
+			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
+	}
+
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a0e27dd..f45d33d 100644
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
-- 
1.7.10

