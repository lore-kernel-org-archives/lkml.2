Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2DCHEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:04:52 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:39510 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2DCHEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:04:39 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AltXAFKgek9V5qnhPGdsb2JhbABCihqtaxkBAQEBNzSCCgEFJy8TAQ8QCBE4OQoUBhOIDbdIE4pthW4Em2CNGYFS
X-IronPort-AV: E=Sophos;i="4.75,362,1330902000"; 
   d="scan'208";a="303588870"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [RFC 3/5] hid: Parse the device before adding it
Date: Tue,  3 Apr 2012 09:05:28 +0200
Message-Id: <1333436730-13008-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hid bus is populated by devices created by the usb and bluetooth
subsystems. The hid device is then broadcast to userland via uevents.
Currently, the parsing of the hid reports is done during probe of
the hid device, after the device has been broadcast. In order to
allow for the report descriptors to influence the device properties,
it is desirable to parse the device _before_ it is broadcast to
userland. In actuality, the parsing depends only accidentally on
the driver being present, so it can be trivially achieved.

Something also needs to be done for the report_fixup handler, which
seems to be the only hard device-driver coupling in the code.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c        |    2 +-
 drivers/hid/usbhid/hid-core.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 35ba9d9..8a7b59e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -658,7 +658,7 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		hid_parser_reserved
 	};
 
-	if (device->driver->report_fixup)
+	if (device->driver && device->driver->report_fixup)
 		start = device->driver->report_fixup(device, start, &size);
 
 	device->rdesc = kmemdup(start, size, GFP_KERNEL);
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..e63613b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1266,6 +1266,11 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
 		hid->uniq[0] = 0;
 
+	ret = hid_parse(hid);
+	if (ret)
+		goto err;
+
+
 	usbhid = kzalloc(sizeof(*usbhid), GFP_KERNEL);
 	if (usbhid == NULL) {
 		ret = -ENOMEM;
-- 
1.7.9.5

