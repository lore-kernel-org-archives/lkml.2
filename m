Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2CFQ5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:57:31 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38560 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab2CFQ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:57:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.216.136.232 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] HID: autoload hid-multitouch as needed
Date: Tue,  6 Mar 2012 17:57:05 +0100
Message-Id: <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

The code is inspired from the one present in the bttv module.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

As I mentioned in the mail 0/5, I'd really like to have your opinion on this
one. I copied the code from bttv, but it forces us to change hid_device which
is not very good for ABI changes reasons.

Thanks,
Benjamin

 drivers/hid/hid-core.c |   27 +++++++++++++++++++++++++++
 include/linux/hid.h    |    4 ++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2390e00..0dcb6c6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1204,6 +1204,28 @@ static struct bin_attribute dev_bin_attr_report_desc = {
 	.size = HID_MAX_DESCRIPTOR_SIZE,
 };
 
+#if defined(CONFIG_MODULES) && defined(MODULE)
+static void hid_request_module_async(struct work_struct *work)
+{
+	request_module("hid-multitouch");
+}
+
+static void hid_request_hid_multitouch(struct hid_device *dev)
+{
+	dev->multitouch = 1;
+	INIT_WORK(&dev->request_module_wk, hid_request_module_async);
+	schedule_work(&dev->request_module_wk);
+}
+
+static void hid_flush_request_modules(struct hid_device *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
+#else
+#define hid_request_hid_multitouch(dev)
+#define hid_flush_request_modules(dev)
+#endif /* CONFIG_MODULES */
+
 int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 {
 	static const char *types[] = { "Device", "Pointer", "Mouse", "Device",
@@ -1230,6 +1252,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		hdev->claimed |= HID_CLAIMED_INPUT;
 	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
 		/* this device should be handled by hid-multitouch, skip it */
+		hid_request_hid_multitouch(hdev);
 		return -ENODEV;
 	}
 
@@ -2089,6 +2112,8 @@ struct hid_device *hid_allocate_device(void)
 	INIT_LIST_HEAD(&hdev->debug_list);
 	sema_init(&hdev->driver_lock, 1);
 
+	hdev->multitouch = 0;
+
 	return hdev;
 err:
 	put_device(&hdev->dev);
@@ -2103,6 +2128,8 @@ static void hid_remove_device(struct hid_device *hdev)
 		hid_debug_unregister(hdev);
 		hdev->status &= ~HID_STAT_ADDED;
 	}
+	if (hdev->multitouch)
+		hid_flush_request_modules(hdev);
 }
 
 /**
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c235e4e..79f484b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -498,6 +498,10 @@ struct hid_device {							/* device report descriptor */
 
 	void *driver_data;
 
+	/* used to make hid-multitouch autoloadable */
+	struct work_struct request_module_wk;
+	bool multitouch;
+
 	/* temporary hid_ff handling (until moved to the drivers) */
 	int (*ff_init)(struct hid_device *);
 
-- 
1.7.7.6

