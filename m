Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2DBOyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:54:21 -0400
Received: from host171.canaca.com ([67.55.55.225]:39678 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2DBOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:54:20 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>, Simon Wood <simon@mungewell.org>
Subject: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
Date: Mon,  2 Apr 2012 07:54:03 -0700
Message-Id: <1333378444-3117-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org>
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org>
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

Use private data in hid-lg4ff to store device properties.

This code was writen by Michal, he asked me to check it and forward
it on to the list.

Signed-off-by: Michal Maly <madcatxster@gmail.com>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c |   96 +++++++++++++++++++++-------------------------
 1 files changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 1145292..c3146e0 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -51,10 +51,7 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
 
 static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);
 
-static bool list_inited;
-
 struct lg4ff_device_entry {
-	char  *device_id;	/* Use name in respective kobject structure's address as the ID */
 	__u16 range;
 	__u16 min_range;
 	__u16 max_range;
@@ -63,8 +60,6 @@ struct lg4ff_device_entry {
 	void (*set_range)(struct hid_device *hid, u16 range);
 };
 
-static struct lg4ff_device_entry device_list;
-
 static const signed short lg4ff_wheel_effects[] = {
 	FF_CONSTANT,
 	FF_AUTOCENTER,
@@ -285,18 +280,20 @@ static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_n
 /* Read current range and display it in terminal */
 static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct lg4ff_device_entry *uninitialized_var(entry);
-	struct list_head *h;
 	struct hid_device *hid = to_hid_device(dev);
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	struct lg_drv_data *uninitialized_var(drv_data);
 	size_t count;
 
-	list_for_each(h, &device_list.list) {
-		entry = list_entry(h, struct lg4ff_device_entry, list);
-		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
-			break;
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Private driver data not found!\n");
+		return 0;
 	}
-	if (h == &device_list.list) {
-		dbg_hid("Device not found!");
+
+	entry = drv_data->device_props;
+	if (!entry) {
+		hid_err(hid, "Device properties not found!\n");
 		return 0;
 	}
 
@@ -308,19 +305,21 @@ static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *att
  * according to the type of the wheel */
 static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct lg4ff_device_entry *uninitialized_var(entry);
-	struct list_head *h;
 	struct hid_device *hid = to_hid_device(dev);
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	struct lg_drv_data *drv_data;
 	__u16 range = simple_strtoul(buf, NULL, 10);
 
-	list_for_each(h, &device_list.list) {
-		entry = list_entry(h, struct lg4ff_device_entry, list);
-		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
-			break;
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Private driver data not found!\n");
+		return 0;
 	}
-	if (h == &device_list.list) {
-		dbg_hid("Device not found!");
-		return count;
+
+	entry = drv_data->device_props;
+	if (!entry) {
+		hid_err(hid, "Device properties not found!\n");
+		return 0;
 	}
 
 	if (range == 0)
@@ -344,6 +343,7 @@ int lg4ff_init(struct hid_device *hid)
 	struct hid_report *report;
 	struct hid_field *field;
 	struct lg4ff_device_entry *entry;
+	struct lg_drv_data *drv_data;
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
@@ -423,28 +423,24 @@ int lg4ff_init(struct hid_device *hid)
 		dev->ff->set_autocenter(dev, 0);
 	}
 
-		/* Initialize device_list if this is the first device to handle by lg4ff */
-	if (!list_inited) {
-		INIT_LIST_HEAD(&device_list.list);
-		list_inited = 1;
+	/* Get private driver data */
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Cannot add device, private driver data not allocated\n");
+		return -1;
 	}
-
-	/* Add the device to device_list */
+	
+	/* Initialize device properties */
 	entry = kzalloc(sizeof(struct lg4ff_device_entry), GFP_KERNEL);
 	if (!entry) {
-		hid_err(hid, "Cannot add device, insufficient memory.\n");
-		return -ENOMEM;
-	}
-	entry->device_id = kstrdup((&hid->dev)->kobj.name, GFP_KERNEL);
-	if (!entry->device_id) {
-		hid_err(hid, "Cannot set device_id, insufficient memory.\n");
-		kfree(entry);
+		hid_err(hid, "Cannot add device, insufficient memory to allocate device properties.\n");
 		return -ENOMEM;
 	}
+	drv_data->device_props = entry;
+
 	entry->min_range = lg4ff_devices[i].min_range;
 	entry->max_range = lg4ff_devices[i].max_range;
 	entry->set_range = lg4ff_devices[i].set_range;
-	list_add(&entry->list, &device_list.list);
 
 	/* Create sysfs interface */
 	error = device_create_file(&hid->dev, &dev_attr_range);
@@ -463,27 +459,23 @@ int lg4ff_init(struct hid_device *hid)
 
 int lg4ff_deinit(struct hid_device *hid)
 {
-	bool found = 0;
-	struct lg4ff_device_entry *entry;
-	struct list_head *h, *g;
+	struct lg4ff_device_entry *uninitialized_var(entry);
+	struct lg_drv_data *uninitialized_var(drv_data);
 	
 	device_remove_file(&hid->dev, &dev_attr_range);
-
-	list_for_each_safe(h, g, &device_list.list) {
-		entry = list_entry(h, struct lg4ff_device_entry, list);
-		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0) {
-			list_del(h);
-			kfree(entry->device_id);
-			kfree(entry);
-			found = 1;
-			break;
-		}
+	
+	drv_data = hid_get_drvdata(hid);
+	if (!drv_data) {
+		hid_err(hid, "Error while deinitializing device, no private driver data.\n");
+		return -1;
 	}
-
-	if (!found) {
-		hid_err(hid, "Device entry not found!\n");
+	entry = drv_data->device_props;
+	if (!entry) {
+		hid_err(hid, "Error while deinitializing device, no device properties data.\n");
 		return -1;
 	}
+	/* Deallocate memory */
+	kfree(entry);
 
 	dbg_hid("Device successfully unregistered\n");
 	return 0;
-- 
1.7.4.1

