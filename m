Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab2JDVWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:22:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877Ab2JDVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kevin Daughtridge <kevin@kdau.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 36/58] HID: keep dev_rdesc unmodified and use it for comparisons
Date: Thu,  4 Oct 2012 14:19:43 -0700
Message-Id: <20121004210639.974132799@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Daughtridge <kevin@kdau.com>

commit 86e6b77eb7cf9ca2e9c7092b4dfd588f0a3307b6 upstream.

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
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c        |   16 +++++++++++++---
 drivers/hid/usbhid/hid-core.c |    6 +++---
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -757,6 +757,7 @@ int hid_open_report(struct hid_device *d
 	struct hid_item item;
 	unsigned int size;
 	__u8 *start;
+	__u8 *buf;
 	__u8 *end;
 	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
@@ -775,12 +776,21 @@ int hid_open_report(struct hid_device *d
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
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1423,20 +1423,20 @@ static int hid_post_reset(struct usb_int
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


