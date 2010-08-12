Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab0HLAEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:48 -0400
Received: from kroah.org ([198.145.64.141]:60257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759337Ab0HLAEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:23 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:26 2010
Message-Id: <20100812000126.266143442@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Dibowitz <phil@ipom.com>
Subject: [33/54] USB delay init quirk for logitech Harmony 700-series devices
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Dibowitz <phil@ipom.com>

commit 93362a875fc69881ae69299efaf19a55a1f57db0 upstream.

The Logitech Harmony 700 series needs an extra delay during
initialization.  This patch adds a USB quirk which enables such a delay
and adds the device to the quirks list.

Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c     |    6 +++++-
 drivers/usb/core/quirks.c  |    3 +++
 include/linux/usb/quirks.h |    4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <linux/pm_runtime.h>
+#include <linux/usb/quirks.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1790,7 +1791,6 @@ int usb_new_device(struct usb_device *ud
 	pm_runtime_set_active(&udev->dev);
 	pm_runtime_enable(&udev->dev);
 
-	usb_detect_quirks(udev);
 	err = usb_enumerate_device(udev);	/* Read descriptors */
 	if (err < 0)
 		goto fail;
@@ -3100,6 +3100,10 @@ static void hub_port_connect_change(stru
 		if (status < 0)
 			goto loop;
 
+		usb_detect_quirks(udev);
+		if (udev->quirks & USB_QUIRK_DELAY_INIT)
+			msleep(1000);
+
 		/* consecutive bus-powered hubs aren't reliable; they can
 		 * violate the voltage drop budget.  if the new child has
 		 * a "powered" LED, users should notice we didn't enable it
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -38,6 +38,9 @@ static const struct usb_device_id usb_qu
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Harmony 700-series */
+	{ USB_DEVICE(0x046d, 0xc122), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -22,4 +22,8 @@
 /*device will morph if reset, don't use reset for handling errors */
 #define USB_QUIRK_RESET_MORPHS		0x00000010
 
+/* device needs a pause during initialization, after we read the device
+   descriptor */
+#define USB_QUIRK_DELAY_INIT		0x00000040
+
 #endif /* __LINUX_USB_QUIRKS_H */


