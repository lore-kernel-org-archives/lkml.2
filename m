Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2HCJAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:00:19 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:4992 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2HCJAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:00:14 -0400
From: =?UTF-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>
To: "'benjamin.tissoires'" <benjamin.tissoires@gmail.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Jiri Kosina'" <jkosina@suse.cz>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eleghost@gmail.com>
Subject: [PATCH 1/1]hid:hid-multitouch:  add mt_resume for ELAN's production
Date: Fri, 3 Aug 2012 17:00:10 +0800
Message-ID: <4DB89EF0F5744C73BDA0747DA3D3E879@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac1xGjHEBRYSyRTjQJqau7+ELBbK3gAOn8Pg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some of ELAN’s production need to issue set_idle when resume.

Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
---
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 mode change 100644 => 100755 drivers/hid/hid-ids.h
 mode change 100644 => 100755 drivers/hid/hid-multitouch.c

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
old mode 100644
new mode 100755
index 41c34f2..703aaed
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -829,4 +829,7 @@
 #define USB_VENDOR_ID_PRIMAX  0x0461
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD     0x4e05
 
+#define USB_VENDOR_ID_ELAN      0x04f3
+#define USB_DEVICE_ID_ELAN_MOCCA 0x000a
+
 #endif
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
old mode 100644
new mode 100755
index 59c8b5c..2c898bb
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -767,6 +767,32 @@ static int mt_reset_resume(struct hid_device *hdev)
       mt_set_input_mode(hdev);
       return 0;
 }
+
+static int mt_resume(struct hid_device *hdev)
+{
+      struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+      struct usb_host_interface *interface = intf->cur_altsetting;
+
+      struct usb_device *dev = hid_to_usb_dev(hdev);
+
+
+      if (hdev->vendor == USB_VENDOR_ID_ELAN && 
+                      hdev->product == USB_DEVICE_ID_ELAN_MOCCA) {
+
+              usb_control_msg(dev, 
+                                              usb_sndctrlpipe(dev, 0),                                          
+                              HID_REQ_SET_IDLE, 
+                                              USB_TYPE_CLASS | USB_RECIP_INTERFACE, 
+                                              0,
+                              interface->desc.bInterfaceNumber, 
+                                              NULL, 
+                                              0, 
+                                              USB_CTRL_SET_TIMEOUT);
+      }
+
+      return 0;
+}
+
 #endif
 
 static void mt_remove(struct hid_device *hdev)
@@ -1092,6 +1118,7 @@ static struct hid_driver mt_driver = {
       .event = mt_event,
 #ifdef CONFIG_PM
       .reset_resume = mt_reset_resume,
+      .resume=mt_resume,
 #endif
 };
 
-- 
1.7.9.5

