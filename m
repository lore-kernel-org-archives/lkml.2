Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2DRV6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:58:01 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:57183 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2DRV56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:57:58 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqNgAPU3j09V5qnhPGdsb2JhbABEiienGRkBAQEBNzSCCgEFJy8TAQ8QCBE4OQoUBhOIE7scE5AiBJtxjSE
X-IronPort-AV: E=Sophos;i="4.75,444,1330902000"; 
   d="scan'208";a="316620598"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/5] hid: Add device group to modalias
Date: Thu, 19 Apr 2012 00:00:53 +0200
Message-Id: <1334786457-2124-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
References: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID devices are only partially presented to userland.  Hotplugged
devices emit events containing a modalias based on the basic bus,
vendor and product entities. However, in practise a hid device can
depend on details such as a single usb interface or a particular item
in a report descriptor.

This patch adds a device group to the hid device id, and broadcasts it
using uevent and the device modalias.  The module alias generation is
modified to match. As a consequence, a device with a non-zero group
will be processed by the corresponding group driver instead of by the
generic hid driver.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c          |   24 +++++++++++++++++++++---
 include/linux/hid.h             |    1 +
 include/linux/mod_devicetable.h |    2 +-
 scripts/mod/file2alias.c        |    3 ++-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4da66b4..f5a9660 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1158,7 +1158,7 @@ EXPORT_SYMBOL_GPL(hid_input_report);
 static bool hid_match_one_id(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	return id->bus == hdev->bus &&
+	return id->bus == hdev->bus && id->group == hdev->group &&
 		(id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
 		(id->product == HID_ANY_ID || id->product == hdev->product);
 }
@@ -1751,6 +1751,23 @@ static int hid_device_remove(struct device *dev)
 	return 0;
 }
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
+			     char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	int len;
+
+	len = snprintf(buf, PAGE_SIZE, "hid:b%04Xg%04Xv%08Xp%08X\n",
+		       hdev->bus, hdev->group, hdev->vendor, hdev->product);
+
+	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
+}
+
+static struct device_attribute hid_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL,
+};
+
 static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
@@ -1768,8 +1785,8 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (add_uevent_var(env, "HID_UNIQ=%s", hdev->uniq))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, "MODALIAS=hid:b%04Xv%08Xp%08X",
-			hdev->bus, hdev->vendor, hdev->product))
+	if (add_uevent_var(env, "MODALIAS=hid:b%04Xg%04Xv%08Xp%08X",
+			   hdev->bus, hdev->group, hdev->vendor, hdev->product))
 		return -ENOMEM;
 
 	return 0;
@@ -1777,6 +1794,7 @@ static int hid_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct bus_type hid_bus_type = {
 	.name		= "hid",
+	.dev_attrs	= hid_dev_attrs,
 	.match		= hid_bus_match,
 	.probe		= hid_device_probe,
 	.remove		= hid_device_remove,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3a95da6..85871f7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -474,6 +474,7 @@ struct hid_device {							/* device report descriptor */
 	unsigned maxcollection;						/* Number of parsed collections */
 	unsigned maxapplication;					/* Number of applications */
 	__u16 bus;							/* BUS ID */
+	__u16 group;							/* Report group */
 	__u32 vendor;							/* Vendor ID */
 	__u32 product;							/* Product ID */
 	__u32 version;							/* HID version */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 501da4c..108f78e 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -135,7 +135,7 @@ struct usb_device_id {
 
 struct hid_device_id {
 	__u16 bus;
-	__u16 pad1;
+	__u16 group;
 	__u32 vendor;
 	__u32 product;
 	kernel_ulong_t driver_data
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 8e730cc..66fafd0 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -336,10 +336,11 @@ static int do_hid_entry(const char *filename,
 			     struct hid_device_id *id, char *alias)
 {
 	id->bus = TO_NATIVE(id->bus);
+	id->group = TO_NATIVE(id->group);
 	id->vendor = TO_NATIVE(id->vendor);
 	id->product = TO_NATIVE(id->product);
 
-	sprintf(alias, "hid:b%04X", id->bus);
+	sprintf(alias, "hid:b%04Xg%04X", id->bus, id->group);
 	ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
 	ADD(alias, "p", id->product != HID_ANY_ID, id->product);
 
-- 
1.7.10

