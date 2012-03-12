Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab2CLQDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:03:21 -0400
Received: from host171.canaca.com ([67.55.55.225]:53385 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2CLQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:03:19 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
Date: Mon, 12 Mar 2012 08:17:38 -0700
Message-Id: <1331565459-1892-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the G27 LEDs. The LEDs are controlled
by a 5bit value (0-31) where bit0 is the right most LED, the LEDs
are mirrored to the left.

Arrangement on wheel is:
   G G Y Y R R(bit4) Y Y G G(bit0)

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c |   84 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 6ecc9e2..4f3b744 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -49,7 +49,12 @@ static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
 static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
 static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
 
+static void hid_lg4ff_set_leds(struct hid_device *hid, __u8 leds);
+static ssize_t lg4ff_leds_show(struct device *dev, struct device_attribute *attr, char *buf);
+static ssize_t lg4ff_leds_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
+
 static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);
+static DEVICE_ATTR(leds, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_leds_show, lg4ff_leds_store);
 
 static bool list_inited;
 
@@ -336,6 +341,67 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 	return count;
 }
 
+/* Read current state of leds and display it in terminal */
+static ssize_t lg4ff_leds_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	struct list_head *h;
+	struct hid_device *hid = to_hid_device(dev);
+	size_t count;
+
+	list_for_each(h, &device_list.list) {
+		entry = list_entry(h, struct lg4ff_device_entry, list);
+		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
+			break;
+	}
+	if (h == &device_list.list) {
+		dbg_hid("Device not found!");
+		return 0;
+	}
+
+	count = scnprintf(buf, PAGE_SIZE, "%u\n", entry->leds);
+	return count;
+}
+
+static ssize_t lg4ff_leds_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	struct list_head *h;
+	struct hid_device *hid = to_hid_device(dev);
+	__u8 leds = (__u8) simple_strtoul(buf, NULL, 10) & 0x1F; /* values 0 to 31 */
+
+	list_for_each(h, &device_list.list) {
+		entry = list_entry(h, struct lg4ff_device_entry, list);
+		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
+			break;
+	}
+	if (h == &device_list.list) {
+		dbg_hid("Device not found!");
+		return count;
+	}
+
+	/* Set leds to user specified value: 5 wide bit field for leds on right (mirrored to left) */
+	hid_lg4ff_set_leds(hid, leds);
+	entry->leds = leds;
+
+	return count;
+}
+
+static void hid_lg4ff_set_leds(struct hid_device *hid, __u8 leds)
+{
+	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
+
+	report->field[0]->value[0] = 0xf8;
+	report->field[0]->value[1] = 0x12;
+	report->field[0]->value[2] = leds;
+	report->field[0]->value[3] = 0x00;
+	report->field[0]->value[4] = 0x00;
+	report->field[0]->value[5] = 0x00;
+	report->field[0]->value[6] = 0x00;
+	usbhid_submit_report(hid, report, USB_DIR_OUT);
+}
+
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
@@ -446,17 +512,30 @@ int lg4ff_init(struct hid_device *hid)
 	entry->set_range = lg4ff_devices[i].set_range;
 	list_add(&entry->list, &device_list.list);
 
-	/* Create sysfs interface */
+	/* Create sysfs interface for range */
 	error = device_create_file(&hid->dev, &dev_attr_range);
 	if (error)
 		return error;
-	dbg_hid("sysfs interface created\n");
+	dbg_hid("sysfs interface created for range\n");
 
 	/* Set the maximum range to start with */
 	entry->range = entry->max_range;
 	if (entry->set_range != NULL)
 		entry->set_range(hid, entry->range);
 
+	/* Create sysfs interface for leds - G27 only */
+	if (rev_maj == G27_REV_MAJ && rev_min == G27_REV_MIN) {
+		error = device_create_file(&hid->dev, &dev_attr_leds);
+		if (error)
+			return error;
+
+		dbg_hid("sysfs interface created for leds\n");
+
+		/* Turn off all leds */
+		entry->leds = 0;
+		hid_lg4ff_set_leds(hid, 0);
+	}
+
 	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by Simon Wood <simon@mungewell.org>\n");
 	return 0;
 }
@@ -483,6 +562,7 @@ int lg4ff_deinit(struct hid_device *hid)
 	}
 
 	device_remove_file(&hid->dev, &dev_attr_range);
+	device_remove_file(&hid->dev, &dev_attr_leds);
 	dbg_hid("Device successfully unregistered\n");
 	return 0;
 }
-- 
1.7.4.1

