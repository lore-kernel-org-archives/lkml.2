Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2C1Od1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:33:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63244 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2C1OdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:33:24 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] HID: autoload hid-multitouch as needed
Date: Wed, 28 Mar 2012 16:33:18 +0200
Message-Id: <1332945198-2518-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

When the generic hid parsing of the report descriptors in hid-core
detects that the device contains the field ContactID, the device should
be handled by hid-multitouch, and hid-core should release it.
This patch implements a temporary fix for hid-core to automatically
call the loading of hid-multitouch. A better solution would involve
userspace.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

Hi guys,

This is the v3 of the patch.
Changes since v2:
- make the working queue global to the module. As noted by Henrik,
there is no need to have a per-device working queue.
- removed the boolean that tells if the working queue has been initialized
and filled: we have only one wq that is initialized at the loading of the
module. I didn't put any threading guards: as far as I understood, working
queues are thread safe.

There is still one problem: this works for hotplugged devices. Coldplugged
ones (before booting then) are not loading hid-multitouch on my computer.
I don't think the previous implementation worked either. However, I don't
think it's a big issue as we may ask end-user to add hid-multitouch in this
case in their /etc/modules-load.d/.

Cheers,
Benjamin

 drivers/hid/hid-core.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 990fe19..f694aa1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1210,6 +1210,39 @@ static struct bin_attribute dev_bin_attr_report_desc = {
 	.size = HID_MAX_DESCRIPTOR_SIZE,
 };
 
+#if defined(CONFIG_MODULES) && defined(MODULE)
+/* This is a temporary fix to make hid-multitouch loadable from
+ * the kernel before we come up with more robust attitude
+ * (with userspace involvement).
+ * In case we detect a multitouch device through the parsing of
+ * hid-core, we request hid-multitouch to be loaded. */
+static struct work_struct request_hid_mt_module_wk;
+
+static void hid_request_hid_mt_module_async(struct work_struct *work)
+{
+	request_module("hid-multitouch");
+}
+
+static inline void hid_request_hid_mt_module(void)
+{
+	schedule_work(&request_hid_mt_module_wk);
+}
+
+static inline void hid_flush_request_modules(void)
+{
+	flush_work_sync(&request_hid_mt_module_wk);
+}
+
+static inline void hid_init_request_modules(void)
+{
+	INIT_WORK(&request_hid_mt_module_wk, hid_request_hid_mt_module_async);
+}
+#else
+#define hid_request_hid_mt_module()
+#define hid_flush_request_modules()
+#define hid_init_request_modules()
+#endif /* CONFIG_MODULES */
+
 int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 {
 	static const char *types[] = { "Device", "Pointer", "Mouse", "Device",
@@ -1235,7 +1268,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
 	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
-		/* this device should be handled by hid-multitouch, skip it */
+		/* this device should be handled by hid-multitouch, request
+		 * for hid-multitouch to be loaded and leave the device to it */
+		hid_request_hid_mt_module();
 		return -ENODEV;
 	}
 
@@ -2210,6 +2245,8 @@ static int __init hid_init(void)
 
 	hid_debug_init();
 
+	hid_init_request_modules();
+
 	return 0;
 err_bus:
 	bus_unregister(&hid_bus_type);
@@ -2219,6 +2256,7 @@ err:
 
 static void __exit hid_exit(void)
 {
+	hid_flush_request_modules();
 	hid_debug_exit();
 	hidraw_exit();
 	bus_unregister(&hid_bus_type);
-- 
1.7.7.6

