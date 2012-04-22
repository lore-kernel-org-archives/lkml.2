Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2DVMSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:18:53 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:33160 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2DVMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:18:51 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AllUAPT1k09V5qnhPGdsb2JhbABEiiqnFRkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGExuFdoICuV0TkSAEm32NJoFa
X-IronPort-AV: E=Sophos;i="4.75,462,1330902000"; 
   d="scan'208";a="23075337"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/3] hid: Handle driver-specific device descriptor in core
Date: Sun, 22 Apr 2012 14:21:40 +0200
Message-Id: <1335097300-11881-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The low-level driver can read the report descriptor, but it cannot
determine driver-specific changes to it. The hid core can fixup
and parse the report descriptor during driver attach, but does
not have direct access to the descriptor when doing so.

To be able to handle attach/detach of hid drivers properly,
a semantic change to hid_parse_report() is needed. This function has
been used in two ways, both as descriptor reader in the ll drivers and
as a parsor in the probe of the drivers. This patch splits the usage
by introducing hid_open_report(), and modifies the hid_parse() macro
to call hid_open_report() instead. The only usage of hid_parse_report()
is then to read and store the device descriptor. As a consequence, we
can handle the report fixups automatically inside the hid core.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c |  112 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/hid.h    |   14 ++----
 2 files changed, 94 insertions(+), 32 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4da66b4..9ed4ff3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -546,12 +546,11 @@ static void hid_free_report(struct hid_report *report)
 }
 
 /*
- * Free a device structure, all reports, and all fields.
+ * Close report. This function returns the device
+ * state to the point prior to hid_open_report().
  */
-
-static void hid_device_release(struct device *dev)
+static void hid_close_report(struct hid_device *device)
 {
-	struct hid_device *device = container_of(dev, struct hid_device, dev);
 	unsigned i, j;
 
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
@@ -562,11 +561,34 @@ static void hid_device_release(struct device *dev)
 			if (report)
 				hid_free_report(report);
 		}
+		memset(report_enum, 0, sizeof(*report_enum));
+		INIT_LIST_HEAD(&report_enum->report_list);
 	}
 
 	kfree(device->rdesc);
+	device->rdesc = NULL;
+	device->rsize = 0;
+
 	kfree(device->collection);
-	kfree(device);
+	device->collection = NULL;
+	device->collection_size = 0;
+	device->maxcollection = 0;
+	device->maxapplication = 0;
+
+	device->status &= ~HID_STAT_PARSED;
+}
+
+/*
+ * Free a device structure, all reports, and all fields.
+ */
+
+static void hid_device_release(struct device *dev)
+{
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+
+	hid_close_report(hid);
+	kfree(hid->dev_rdesc);
+	kfree(hid);
 }
 
 /*
@@ -643,15 +665,37 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
  * @start: report start
  * @size: report size
  *
+ * Allocate the device report as read by the bus driver. This function should
+ * only be called from parse() in ll drivers.
+ */
+int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size)
+{
+	hid->dev_rdesc = kmemdup(start, size, GFP_KERNEL);
+	if (!hid->dev_rdesc)
+		return -ENOMEM;
+	hid->dev_rsize = size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hid_parse_report);
+
+/**
+ * hid_open_report - open a driver-specific device report
+ *
+ * @device: hid device
+ *
  * Parse a report description into a hid_device structure. Reports are
  * enumerated, fields are attached to these reports.
  * 0 returned on success, otherwise nonzero error value.
+ *
+ * This function (or the equivalent hid_parse() macro) should only be
+ * called from probe() in drivers, before starting the device.
  */
-int hid_parse_report(struct hid_device *device, __u8 *start,
-		unsigned size)
+int hid_open_report(struct hid_device *device)
 {
 	struct hid_parser *parser;
 	struct hid_item item;
+	unsigned int size;
+	__u8 *start;
 	__u8 *end;
 	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
@@ -662,6 +706,14 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		hid_parser_reserved
 	};
 
+	if (WARN_ON(device->status & HID_STAT_PARSED))
+		return -EBUSY;
+
+	start = device->dev_rdesc;
+	if (WARN_ON(!start))
+		return -ENODEV;
+	size = device->dev_rsize;
+
 	if (device->driver->report_fixup)
 		start = device->driver->report_fixup(device, start, &size);
 
@@ -679,6 +731,15 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 	parser->device = device;
 
 	end = start + size;
+
+	device->collection = kcalloc(HID_DEFAULT_NUM_COLLECTIONS,
+				     sizeof(struct hid_collection), GFP_KERNEL);
+	if (!device->collection) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+
 	ret = -EINVAL;
 	while ((start = fetch_item(start, end, &item)) != NULL) {
 
@@ -704,6 +765,7 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 				goto err;
 			}
 			vfree(parser);
+			device->status |= HID_STAT_PARSED;
 			return 0;
 		}
 	}
@@ -711,9 +773,10 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 	hid_err(device, "item fetching failed at offset %d\n", (int)(end - start));
 err:
 	vfree(parser);
+	hid_close_report(device);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hid_parse_report);
+EXPORT_SYMBOL_GPL(hid_open_report);
 
 /*
  * Convert a signed n-bit integer to signed 32-bit integer. Common
@@ -1718,12 +1781,14 @@ static int hid_device_probe(struct device *dev)
 		if (hdrv->probe) {
 			ret = hdrv->probe(hdev, id);
 		} else { /* default probe */
-			ret = hid_parse(hdev);
+			ret = hid_open_report(hdev);
 			if (!ret)
 				ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 		}
-		if (ret)
+		if (ret) {
+			hid_close_report(hdev);
 			hdev->driver = NULL;
+		}
 	}
 unlock:
 	up(&hdev->driver_lock);
@@ -1744,6 +1809,7 @@ static int hid_device_remove(struct device *dev)
 			hdrv->remove(hdev);
 		else /* default remove */
 			hid_hw_stop(hdev);
+		hid_close_report(hdev);
 		hdev->driver = NULL;
 	}
 
@@ -2075,6 +2141,16 @@ int hid_add_device(struct hid_device *hdev)
             && (hid_ignore(hdev) || (hdev->quirks & HID_QUIRK_IGNORE)))
 		return -ENODEV;
 
+	/*
+	 * Read the device report descriptor once and use as template
+	 * for the driver-specific modifications.
+	 */
+	ret = hdev->ll_driver->parse(hdev);
+	if (ret)
+		return ret;
+	if (!hdev->dev_rdesc)
+		return -ENODEV;
+
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
@@ -2103,7 +2179,6 @@ EXPORT_SYMBOL_GPL(hid_add_device);
 struct hid_device *hid_allocate_device(void)
 {
 	struct hid_device *hdev;
-	unsigned int i;
 	int ret = -ENOMEM;
 
 	hdev = kzalloc(sizeof(*hdev), GFP_KERNEL);
@@ -2114,23 +2189,13 @@ struct hid_device *hid_allocate_device(void)
 	hdev->dev.release = hid_device_release;
 	hdev->dev.bus = &hid_bus_type;
 
-	hdev->collection = kcalloc(HID_DEFAULT_NUM_COLLECTIONS,
-			sizeof(struct hid_collection), GFP_KERNEL);
-	if (hdev->collection == NULL)
-		goto err;
-	hdev->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
-
-	for (i = 0; i < HID_REPORT_TYPES; i++)
-		INIT_LIST_HEAD(&hdev->report_enum[i].report_list);
+	hid_close_report(hdev);
 
 	init_waitqueue_head(&hdev->debug_wait);
 	INIT_LIST_HEAD(&hdev->debug_list);
 	sema_init(&hdev->driver_lock, 1);
 
 	return hdev;
-err:
-	put_device(&hdev->dev);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(hid_allocate_device);
 
@@ -2141,6 +2206,9 @@ static void hid_remove_device(struct hid_device *hdev)
 		hid_debug_unregister(hdev);
 		hdev->status &= ~HID_STAT_ADDED;
 	}
+	kfree(hdev->dev_rdesc);
+	hdev->dev_rdesc = NULL;
+	hdev->dev_rsize = 0;
 }
 
 /**
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3a95da6..d8e7cc7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -467,6 +467,8 @@ struct hid_driver;
 struct hid_ll_driver;
 
 struct hid_device {							/* device report descriptor */
+	__u8 *dev_rdesc;
+	unsigned dev_rsize;
 	__u8 *rdesc;
 	unsigned rsize;
 	struct hid_collection *collection;				/* List of HID collections */
@@ -735,6 +737,7 @@ void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+int hid_open_report(struct hid_device *device);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
 void hid_disconnect(struct hid_device *hid);
@@ -805,16 +808,7 @@ static inline void hid_map_usage_clear(struct hid_input *hidinput,
  */
 static inline int __must_check hid_parse(struct hid_device *hdev)
 {
-	int ret;
-
-	if (hdev->status & HID_STAT_PARSED)
-		return 0;
-
-	ret = hdev->ll_driver->parse(hdev);
-	if (!ret)
-		hdev->status |= HID_STAT_PARSED;
-
-	return ret;
+	return hid_open_report(hdev);
 }
 
 /**
-- 
1.7.10

