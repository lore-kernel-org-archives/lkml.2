Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1AUGT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:19:57 -0500
Received: from core.signal11.us ([64.251.29.136]:37678 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab1AUGTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:19:51 -0500
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 1/1] hid: Add HID Report Descriptor to sysfs.
Date: Fri, 21 Jan 2011 01:19:45 -0500
Message-Id: <1295590785-7101-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295590785-7101-1-git-send-email-alan@signal11.us>
References: <1295590785-7101-1-git-send-email-alan@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 21 01:19:51 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d392587121634507285470
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new sysfs entry called report_descriptor which contains the HID report
descriptor.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/hid-core.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..0ff1ba2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1159,6 +1159,28 @@ static bool hid_hiddev(struct hid_device *hdev)
 	return !!hid_match_id(hdev, hid_hiddev_list);
 }
 
+
+static ssize_t show_report_descriptor(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	int i, cur = 0;
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+
+	for (i = 0; i < hdev->rsize; i++) {
+		if (cur + 4 >= PAGE_SIZE)
+			break;
+		sprintf(buf + cur, "%02hhx ", hdev->rdesc[i]);
+		cur += 3;
+	}
+	/* Replace the last space with a newline. */
+	buf[cur-1] = '\n';
+	buf[PAGE_SIZE-1] = '\0';
+	return cur + 1;
+}
+
+static DEVICE_ATTR(report_descriptor, S_IRUGO, show_report_descriptor, NULL);
+
 int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 {
 	static const char *types[] = { "Device", "Pointer", "Mouse", "Device",
@@ -1169,6 +1191,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	char buf[64];
 	unsigned int i;
 	int len;
+	int ret;
 
 	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
 		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
@@ -1230,6 +1253,11 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		bus = "<UNKNOWN>";
 	}
 
+	ret = device_create_file(&hdev->dev, &dev_attr_report_descriptor);
+	if (ret)
+		hid_warn(hdev,
+			 "can't create sysfs report descriptor attribute err: %d\n", ret);
+
 	hid_info(hdev, "%s: %s HID v%x.%02x %s [%s] on %s\n",
 		 buf, bus, hdev->version >> 8, hdev->version & 0xff,
 		 type, hdev->name, hdev->phys);
-- 
1.7.0.4


