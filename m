Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1AXDus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 22:50:48 -0500
Received: from core.signal11.us ([64.251.29.136]:34912 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1AXDug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 22:50:36 -0500
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        greg@kroah.com, stern@rowland.harvard.edu
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v4 1/1] hid: Add HID Report Descriptor to sysfs.
Date: Sun, 23 Jan 2011 22:50:18 -0500
Message-Id: <1295841018-8561-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20110123225935.GB12488@kroah.com>
References: <20110123225935.GB12488@kroah.com>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan 23 22:50:35 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d3cf70b35002123370416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new binary sysfs entry called report_descriptor which contains
the HID report descriptor.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 Documentation/ABI/testing/sysfs-driver-hid |   10 ++++++++
 drivers/hid/hid-core.c                     |   33 ++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid

diff --git a/Documentation/ABI/testing/sysfs-driver-hid b/Documentation/ABI/testing/sysfs-driver-hid
new file mode 100644
index 0000000..b6490e1
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid
@@ -0,0 +1,10 @@
+What:		For USB devices	: /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/report_descriptor
+		For BT devices	: /sys/class/bluetooth/hci<addr>/<hid-bus>:<vendor-id>:<product-id>.<num>/report_descriptor
+		Symlink		: /sys/class/hidraw/hidraw<num>/device/report_descriptor
+Date:		Jan 2011
+KernelVersion:	2.0.39
+Contact:	Alan Ott <alan@signal11.us>
+Description:	When read, this file returns the device's raw binary HID
+		report descriptor.
+		This file cannot be written.
+Users:		HIDAPI library (http://www.signal11.us/oss/hidapi)
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..32bbd5d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1159,6 +1159,32 @@ static bool hid_hiddev(struct hid_device *hdev)
 	return !!hid_match_id(hdev, hid_hiddev_list);
 }
 
+
+static ssize_t
+read_report_descriptor(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+
+	if (off >= hdev->rsize)
+		return 0;
+
+	if (off + count > hdev->rsize)
+		count = hdev->rsize - off;
+
+	memcpy(buf, hdev->rdesc + off, count);
+
+	return count;
+}
+
+static struct bin_attribute dev_bin_attr_report_desc = {
+	.attr = { .name = "report_descriptor", .mode = 0444 },
+	.read = read_report_descriptor,
+	.size = HID_MAX_DESCRIPTOR_SIZE,
+};
+
 int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 {
 	static const char *types[] = { "Device", "Pointer", "Mouse", "Device",
@@ -1169,6 +1195,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	char buf[64];
 	unsigned int i;
 	int len;
+	int ret;
 
 	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
 		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
@@ -1230,6 +1257,11 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		bus = "<UNKNOWN>";
 	}
 
+	ret = device_create_bin_file(&hdev->dev, &dev_bin_attr_report_desc);
+	if (ret)
+		hid_warn(hdev,
+			 "can't create sysfs report descriptor attribute err: %d\n", ret);
+
 	hid_info(hdev, "%s: %s HID v%x.%02x %s [%s] on %s\n",
 		 buf, bus, hdev->version >> 8, hdev->version & 0xff,
 		 type, hdev->name, hdev->phys);
@@ -1240,6 +1272,7 @@ EXPORT_SYMBOL_GPL(hid_connect);
 
 void hid_disconnect(struct hid_device *hdev)
 {
+	device_remove_bin_file(&hdev->dev, &dev_bin_attr_report_desc);
 	if (hdev->claimed & HID_CLAIMED_INPUT)
 		hidinput_disconnect(hdev);
 	if (hdev->claimed & HID_CLAIMED_HIDDEV)
-- 
1.7.0.4


