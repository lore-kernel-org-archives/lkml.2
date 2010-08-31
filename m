Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0HaSlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:41:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51760 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0HaSlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:41:17 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6 v2] HID: magicmouse: don't allow hidinput to initialize the device
Date: Tue, 31 Aug 2010 14:41:03 -0400
Message-Id: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@ubuntu.com>

The driver listens only for raw events from the device. If we allow
the hidinput layer to initialize, we can hit NULL pointer dereferences
in the hidinput layer because disconnecting only removes the hidinput
devices from the hid device while leaving the hid fields configured.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
Note that this mimics what the hid-picolcd module does.

 drivers/hid/hid-magicmouse.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 319b0e5..d38b529 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -404,15 +404,20 @@ static int magicmouse_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	/* When registering a hid device, one of hidinput, hidraw, or hiddev
+	 * subsystems must claim the device. We are bypassing hidinput due to
+	 * our raw event processing, and hidraw and hiddev may not claim the
+	 * device. We get around this by telling hid_hw_start that input has
+	 * claimed the device already, and then flipping the bit back.
+	 */
+	hdev->claimed = HID_CLAIMED_INPUT;
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDINPUT);
+	hdev->claimed &= ~HID_CLAIMED_INPUT;
 	if (ret) {
 		dev_err(&hdev->dev, "magicmouse hw start failed\n");
 		goto err_free;
 	}
 
-	/* we are handling the input ourselves */
-	hidinput_disconnect(hdev);
-
 	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
 	if (!report) {
 		dev_err(&hdev->dev, "unable to register touch report\n");
-- 
1.7.1

