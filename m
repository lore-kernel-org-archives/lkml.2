Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DWKEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:04:24 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:35066 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2DWKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:04:21 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArldAAQolU9V5qnhPGdsb2JhbABEiiqnGRkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGE4gTuXQTkSAEm32NJg
X-IronPort-AV: E=Sophos;i="4.75,466,1330902000"; 
   d="scan'208";a="318166045"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 3/6] hid: Allow bus wildcard matching
Date: Mon, 23 Apr 2012 12:07:04 +0200
Message-Id: <1335175627-2270-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most HID drivers do not need to know what bus driver is in use.
A generic group driver can drive any hid device, and the device
list should not need to be duplicated for each new bus.

This patch adds wildcard matching to the HID bus, simplifying device
list handling for group drivers.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c          |    2 +-
 include/linux/mod_devicetable.h |    1 +
 scripts/mod/file2alias.c        |    3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f932cd5..20daee5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1273,7 +1273,7 @@ EXPORT_SYMBOL_GPL(hid_input_report);
 static bool hid_match_one_id(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	return id->bus == hdev->bus &&
+	return (id->bus == HID_BUS_ANY || id->bus == hdev->bus) &&
 		(id->group == HID_GROUP_ANY || id->group == hdev->group) &&
 		(id->vendor == HID_ANY_ID || id->vendor == hdev->vendor) &&
 		(id->product == HID_ANY_ID || id->product == hdev->product);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 55ed0b0..5db9382 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -132,6 +132,7 @@ struct usb_device_id {
 #define USB_DEVICE_ID_MATCH_INT_PROTOCOL	0x0200
 
 #define HID_ANY_ID				(~0)
+#define HID_BUS_ANY				0xffff
 #define HID_GROUP_ANY				0x0000
 
 struct hid_device_id {
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index fe967ce..056de31 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -340,7 +340,8 @@ static int do_hid_entry(const char *filename,
 	id->vendor = TO_NATIVE(id->vendor);
 	id->product = TO_NATIVE(id->product);
 
-	sprintf(alias, "hid:b%04X", id->bus);
+	sprintf(alias, "hid:");
+	ADD(alias, "b", id->bus != HID_BUS_ANY, id->bus);
 	ADD(alias, "g", id->group != HID_GROUP_ANY, id->group);
 	ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
 	ADD(alias, "p", id->product != HID_ANY_ID, id->product);
-- 
1.7.10

