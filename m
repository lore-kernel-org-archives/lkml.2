Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2DRV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:58:08 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:51841 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab2DRV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:58:03 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqRgAPU3j09V5qnhPGdsb2JhbABEiienGRkBAQEBNzSCCgEFJy8TAQ8QCBE4OQoUBhMbh3i7HBOKR4VbBJtxjSGBUg
X-IronPort-AV: E=Sophos;i="4.75,444,1330902000"; 
   d="scan'208";a="98044817"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/5] hid: Parse the device before adding it
Date: Thu, 19 Apr 2012 00:00:54 +0200
Message-Id: <1334786457-2124-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
References: <1334786457-2124-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hid bus is populated by devices created by the usb and bluetooth
subsystems. The hid device is then broadcast to userland via uevents.
Currently, the parsing of the hid reports is done during probe of
the hid device, after the device has been broadcast. In order to
allow for the report descriptors to influence the device properties,
it is desirable to parse the device _before_ it is broadcast to
userland.

Specific device drivers, in particular those with report fixup
routines, are not affected by this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f5a9660..1c4db36 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -662,7 +662,7 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		hid_parser_reserved
 	};
 
-	if (device->driver->report_fixup)
+	if (device->driver && device->driver->report_fixup)
 		start = device->driver->report_fixup(device, start, &size);
 
 	device->rdesc = kmemdup(start, size, GFP_KERNEL);
@@ -2093,6 +2093,16 @@ int hid_add_device(struct hid_device *hdev)
             && (hid_ignore(hdev) || (hdev->quirks & HID_QUIRK_IGNORE)))
 		return -ENODEV;
 
+	/*
+	 * Parse generically handled devices early to allow for
+	 * report-defined device groups.
+	 */
+	if (!hid_match_id(hdev, hid_have_special_driver)) {
+		ret = hid_parse(hdev);
+		if (ret)
+			return ret;
+	}
+
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
-- 
1.7.10

