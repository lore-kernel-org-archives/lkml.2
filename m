Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2DCPwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:52:05 -0400
Received: from realvnc.com ([146.101.152.142]:47570 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab2DCPwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:52:04 -0400
X-Greylist: delayed 2783 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 11:52:04 EDT
From: Simon Haggett <simon.haggett@realvnc.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Haggett <simon.haggett@realvnc.com>
Subject: [PATCH 1/1] usbhid: Check HID report descriptor contents after USB device reset
Date: Tue,  3 Apr 2012 16:04:15 +0100
Message-Id: <1333465455-17089-1-git-send-email-simon.haggett@realvnc.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a USB device reset occurs, usbcore will refetch the device and configuration
descriptors and compare them with those retrieved before the reset to ensure
that they have not changed. For USB HID devices, this implicitly includes the
HID class descriptor (as this is fetched with the configuration descriptor).
However, the HID report descriptor is not checked again.

Whilst a change in the size of the HID report descriptor will be detected (as
this is held in the class descriptor), content changes to the report descriptor
which do not result in a change in its size will be missed. If a firmware update
were applied to a USB HID device which resulted in such a change to the report
descriptor after device reset, then this would not be picked up by usbhid.

This patch fixes this issue by allowing usbhid to check the contents of the
report descriptor after the device reset, and trigger a rebind of the device
if there is a mismatch.

Reviewed-by: Toby Gray <toby.gray@realvnc.com>
Signed-off-by: Simon Haggett <simon.haggett@realvnc.com>
---
 drivers/hid/usbhid/hid-core.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5bf91db..79522ae 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -28,6 +28,7 @@
 #include <linux/input.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <linux/string.h>
 
 #include <linux/usb.h>
 
@@ -1347,7 +1348,34 @@ static int hid_post_reset(struct usb_interface *intf)
 	struct usb_device *dev = interface_to_usbdev (intf);
 	struct hid_device *hid = usb_get_intfdata(intf);
 	struct usbhid_device *usbhid = hid->driver_data;
+	struct usb_host_interface *interface = intf->cur_altsetting;
 	int status;
+	char *rdesc;
+
+	/* Fetch and examine the HID report descriptor. If this
+	 * has changed, then rebind. Since usbcore's check of the
+	 * configuration descriptors passed, we already know that
+	 * the size of the HID report descriptor has not changed.
+	 */
+	rdesc = kmalloc(hid->rsize, GFP_KERNEL);
+	if (!rdesc) {
+		dbg_hid("couldn't allocate rdesc memory (post_reset)\n");
+		return 1;
+	}
+	status = hid_get_class_descriptor(dev,
+				interface->desc.bInterfaceNumber,
+				HID_DT_REPORT, rdesc, hid->rsize);
+	if (status < 0) {
+		dbg_hid("reading report descriptor failed (post_reset)\n");
+		kfree(rdesc);
+		return 1;
+	}
+	status = memcmp(rdesc, hid->rdesc, hid->rsize);
+	kfree(rdesc);
+	if (status != 0) {
+		dbg_hid("report descriptor changed\n");
+		return 1;
+	}
 
 	spin_lock_irq(&usbhid->lock);
 	clear_bit(HID_RESET_PENDING, &usbhid->iofl);
-- 
1.7.4.1

