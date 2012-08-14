Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2HNBp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:45:58 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:48834 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2HNBp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:45:56 -0400
From: Scott Liu <scott.liu@emc.com.tw>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, eleghost@gmail.com
Cc: Scott Liu <scott.liu@emc.com.tw>
Subject: [PATCH v3 1/1] HID:hid-multitouch: Add ELAN production request when resume.
Date: Tue, 14 Aug 2012 09:47:05 +0800
Message-Id: <1344908825-6691-1-git-send-email-scott.liu@emc.com.tw>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ELAN production request when resume

Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
Suggested-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 59c8b5c..e824c37 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -767,6 +767,32 @@ static int mt_reset_resume(struct hid_device *hdev)
 	mt_set_input_mode(hdev);
 	return 0;
 }
+
+static int mt_resume(struct hid_device *hdev)
+{
+	struct usb_interface *intf;
+	struct usb_host_interface *interface;
+	struct usb_device *dev;
+
+	if (hdev->bus != BUS_USB)
+		return 0;
+
+	intf = to_usb_interface(hdev->dev.parent);
+	interface = intf->cur_altsetting;
+	dev = hid_to_usb_dev(hdev);
+
+	/* Some Elan legacy devices require SET_IDLE to be set on resume.
+	 * It should be safe to send it to other devices too.
+	 * Tested on 3M, Stantum, Cypress, Zytronic, eGalax, and Elan panels. */
+
+	usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			HID_REQ_SET_IDLE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			0, interface->desc.bInterfaceNumber,
+			NULL, 0, USB_CTRL_SET_TIMEOUT);
+
+	return 0;
+}
 #endif
 
 static void mt_remove(struct hid_device *hdev)
@@ -1092,6 +1118,7 @@ static struct hid_driver mt_driver = {
 	.event = mt_event,
 #ifdef CONFIG_PM
 	.reset_resume = mt_reset_resume,
+	.resume = mt_resume,
 #endif
 };
 
-- 
1.7.9.5

