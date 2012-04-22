Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2DVGDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 02:03:04 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43437 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2DVGCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 02:02:38 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlhUAE2ek09V5qnhPGdsb2JhbABEiiqnFhkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGE4gTuV0TkSAEm32NJg
X-IronPort-AV: E=Sophos;i="4.75,461,1330902000"; 
   d="scan'208";a="100771261"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 4/6] hid: Allow bus wildcard matching
Date: Sun, 22 Apr 2012 08:05:24 +0200
Message-Id: <1335074726-2276-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335074726-2276-1-git-send-email-rydberg@euromail.se>
References: <1335074726-2276-1-git-send-email-rydberg@euromail.se>
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
index 32a40879..5546426 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1158,7 +1158,7 @@ EXPORT_SYMBOL_GPL(hid_input_report);
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

