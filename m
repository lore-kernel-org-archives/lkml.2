Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2ITTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:00:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2ITTAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:00:36 -0400
Date: Thu, 20 Sep 2012 12:00:32 -0700
From: "Kevin Daughtridge" <kevin@kdau.com>
To: linux-input@vger.kernel.org, jkosina@suse.cz
Cc: kevin@kdau.com, rydberg@euromail.se, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v3] HID: keep dev_rdesc unmodified and use it for
 comparisons
Message-ID: <505b67d0.jarbgcy4b522QzyI%kevin@kdau.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_rdesc member of the hid_device structure is meant to store the original
report descriptor received from the device, but it is currently passed to any
report_fixup method before it is copied to the rdesc member. This patch uses a
temporary buffer to shield dev_rdesc from the side effects of many HID drivers'
report_fixup implementations.

usbhid's hid_post_reset checks the report descriptor currently returned by the
device against a descriptor that may have been modified by a driver's
report_fixup method. That leaves some devices nonfunctional after a resume, with
a "reset_resume error 1" reported. This patch checks the new descriptor against
the unmodified dev_rdesc instead and uses the original, instead of modified,
report size.

BugLink: http://bugs.launchpad.net/bugs/1049623
Signed-off-by: Kevin Daughtridge <kevin@kdau.com>
---
 drivers/hid/hid-core.c        |   16 +++++++++++++---
 drivers/hid/usbhid/hid-core.c |    6 +++---
 2 files changed, 16 insertions(+), 6 deletions(-)

Changed in this version: added a temporary buffer to work around report_fixup
inconsistencies; using dev_rsize instead of rsize to allocate and read new
descriptor.

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8bcd168..5de3bb3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -757,6 +757,7 @@ int hid_open_report(struct hid_device *device)
 	struct hid_item item;
 	unsigned int size;
 	__u8 *start;
+	__u8 *buf;
 	__u8 *end;
 	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
@@ -775,12 +776,21 @@ int hid_open_report(struct hid_device *device)
 		return -ENODEV;
 	size = device->dev_rsize;
 
+	buf = kmemdup(start, size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
 	if (device->driver->report_fixup)
-		start = device->driver->report_fixup(device, start, &size);
+		start = device->driver->report_fixup(device, buf, &size);
+	else
+		start = buf;
 
-	device->rdesc = kmemdup(start, size, GFP_KERNEL);
-	if (device->rdesc == NULL)
+	start = kmemdup(start, size, GFP_KERNEL);
+	kfree(buf);
+	if (start == NULL)
 		return -ENOMEM;
+
+	device->rdesc = start;
 	device->rsize = size;
 
 	parser = vzalloc(sizeof(struct hid_parser));
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index dedd8e4..8e0c4bf94 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1415,20 +1415,20 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
 	if (!rdesc) {
 		dbg_hid("couldn't allocate rdesc memory (post_reset)\n");
 		return 1;
 	}
 	status = hid_get_class_descriptor(dev,
 				interface->desc.bInterfaceNumber,
-				HID_DT_REPORT, rdesc, hid->rsize);
+				HID_DT_REPORT, rdesc, hid->dev_rsize);
 	if (status < 0) {
 		dbg_hid("reading report descriptor failed (post_reset)\n");
 		kfree(rdesc);
 		return 1;
 	}
-	status = memcmp(rdesc, hid->rdesc, hid->rsize);
+	status = memcmp(rdesc, hid->dev_rdesc, hid->dev_rsize);
 	kfree(rdesc);
 	if (status != 0) {
 		dbg_hid("report descriptor changed\n");
