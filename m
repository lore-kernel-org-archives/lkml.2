Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1CUXWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:22:13 -0400
Received: from kroah.org ([198.145.64.141]:52806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab1CUXSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:28 2011
Message-Id: <20110321230328.786808023@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: [69/78] HID: ACRUX - activate the device immediately after binding
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 0ae43810976bc969ee158510c4acbe70ed136e61 upstream.

This device does not tolerate delayed opening and goes into a coma if
we try to that. Ubuntu even has a crutch for udev that opened the device
upon seeing it for the first time, but it did not work if we happened to
boot with the device attached, since by the time userspace got around
opening the device it was too late. Let's start the device immediately
to deal with this issue.

Reported-by: Sergei Kolzun <x0r@dv-life.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/Kconfig    |   10 ++++++++--
 drivers/hid/Makefile   |    2 +-
 drivers/hid/hid-axff.c |   31 ++++++++++++++++++++++++++++---
 drivers/hid/hid-core.c |    2 --
 4 files changed, 37 insertions(+), 8 deletions(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -68,9 +68,15 @@ config HID_A4TECH
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
-config HID_ACRUX_FF
-	tristate "ACRUX force feedback"
+config HID_ACRUX
+	tristate "ACRUX game controller support"
 	depends on USB_HID
+	---help---
+	Say Y here if you want to enable support for ACRUX game controllers.
+
+config HID_ACRUX_FF
+	tristate "ACRUX force feedback support"
+	depends on HID_ACRUX
 	select INPUT_FF_MEMLESS
 	---help---
 	Say Y here if you want to enable force feedback support for ACRUX
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -27,7 +27,7 @@ endif
 
 obj-$(CONFIG_HID_3M_PCT)	+= hid-3m-pct.o
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
-obj-$(CONFIG_HID_ACRUX_FF)	+= hid-axff.o
+obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
 obj-$(CONFIG_HID_CANDO)		+= hid-cando.o
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -33,6 +33,8 @@
 #include <linux/hid.h>
 
 #include "hid-ids.h"
+
+#ifdef CONFIG_HID_ACRUX_FF
 #include "usbhid/usbhid.h"
 
 struct axff_device {
@@ -109,6 +111,12 @@ err_free_mem:
 	kfree(axff);
 	return error;
 }
+#else
+static inline int axff_init(struct hid_device *hid)
+{
+	return 0;
+}
+#endif
 
 static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
@@ -139,9 +147,25 @@ static int ax_probe(struct hid_device *h
 			 error);
 	}
 
+	/*
+	 * We need to start polling device right away, otherwise
+	 * it will go into a coma.
+	 */
+	error = hid_hw_open(hdev);
+	if (error) {
+		dev_err(&hdev->dev, "hw open failed\n");
+		return error;
+	}
+
 	return 0;
 }
 
+static void ax_remove(struct hid_device *hdev)
+{
+	hid_hw_close(hdev);
+	hid_hw_stop(hdev);
+}
+
 static const struct hid_device_id ax_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802), },
 	{ }
@@ -149,9 +173,10 @@ static const struct hid_device_id ax_dev
 MODULE_DEVICE_TABLE(hid, ax_devices);
 
 static struct hid_driver ax_driver = {
-	.name = "acrux",
-	.id_table = ax_devices,
-	.probe = ax_probe,
+	.name		= "acrux",
+	.id_table	= ax_devices,
+	.probe		= ax_probe,
+	.remove		= ax_remove,
 };
 
 static int __init ax_init(void)
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1256,9 +1256,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_RP_649) },
-#if defined(CONFIG_HID_ACRUX_FF) || defined(CONFIG_HID_ACRUX_FF_MODULE)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
-#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },


