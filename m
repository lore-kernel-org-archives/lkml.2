Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2DCHEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:04:50 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:57887 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DCHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:04:33 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgBcAFKgek9V5qnhPGdsb2JhbABCihqqaoMBGQEBAQE3NIIKAQUnLyMQCBE4OQoUBoggt0gTkFsEm2CNGYFSFw
X-IronPort-AV: E=Sophos;i="4.75,362,1330902000"; 
   d="scan'208";a="303588773"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [RFC 1/5] hid: Remove multitouch quirk
Date: Tue,  3 Apr 2012 09:05:26 +0200
Message-Id: <1333436730-13008-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for a generic autoloading mechanism, remove
the temporary HID_QUIRK_MULTITOUCH quirk.
---
 drivers/hid/hid-core.c  |    5 -----
 drivers/hid/hid-input.c |   11 -----------
 include/linux/hid.h     |    1 -
 3 files changed, 17 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af08ce7..35ba9d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1230,11 +1230,6 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
 				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
 		hdev->claimed |= HID_CLAIMED_INPUT;
-	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
-		/* this device should be handled by hid-multitouch, skip it */
-		hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
-		return -ENODEV;
-	}
 
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
 			!hdev->hiddev_connect(hdev,
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 627850a..e15575a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -631,10 +631,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			map_key_clear(BTN_STYLUS2);
 			break;
 
-		case 0x51: /* ContactID */
-			device->quirks |= HID_QUIRK_MULTITOUCH;
-			goto unknown;
-
 		default:  goto unknown;
 		}
 		break;
@@ -1201,13 +1197,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 		}
 	}
 
-	if (hid->quirks & HID_QUIRK_MULTITOUCH) {
-		/* generic hid does not know how to handle multitouch devices */
-		if (hidinput)
-			goto out_cleanup;
-		goto out_unwind;
-	}
-
 	if (hidinput && input_register_device(hidinput->input))
 		goto out_cleanup;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3a95da6..5b3be43 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -317,7 +317,6 @@ struct hid_item {
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
-#define HID_QUIRK_MULTITOUCH			0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
-- 
1.7.9.5

