Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1K2MNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:13:50 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:45737 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1K2MNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:13:48 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH 2/3] HID: multitouch: use input_register callback
Date: Tue, 29 Nov 2011 13:13:11 +0100
Message-Id: <1322568792-4432-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the input_register mechanism to avoid a race in which the device
may emit events before the slots are ready.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 91c13bc..bd6e410 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -574,6 +574,29 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	}
 }
 
+static int mt_input_register(struct hid_device *hdev,
+		struct hid_input *hidinput)
+{
+	int ret;
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
+				GFP_KERNEL);
+	if (!td->slots) {
+		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
+		return -ENOMEM;
+	}
+
+	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
+	if (ret)
+		hid_warn(hdev,
+			 "can't create sysfs quirks attribute err: %d\n", ret);
+
+	mt_set_input_mode(hdev);
+
+	return 0;
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
@@ -610,19 +633,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
-	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
-				GFP_KERNEL);
-	if (!td->slots) {
-		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
-		hid_hw_stop(hdev);
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
-
-	mt_set_input_mode(hdev);
-
 	return 0;
 
 fail:
@@ -843,6 +853,7 @@ static struct hid_driver mt_driver = {
 	.input_mapping = mt_input_mapping,
 	.input_mapped = mt_input_mapped,
 	.feature_mapping = mt_feature_mapping,
+	.input_register = mt_input_register,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
 #ifdef CONFIG_PM
-- 
1.7.4.4

