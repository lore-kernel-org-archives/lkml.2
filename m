Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab1JOATx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:19:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1JOATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:19:51 -0400
From: Terry Lambert <tlambert@chromium.org>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Terry Lambert <tlambert@chromium.org>
Subject: [PATCH] Driver for Primax keyboards violating USB HID spec
Date: Fri, 14 Oct 2011 17:18:54 -0700
Message-Id: <1318637934-30006-1-git-send-email-tlambert@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Primax keyboards with the issue this driver addresses report modifier
keys as in band key events instead of as out of band modifier bits,
resulting in the modifier keys generating key up events immediately
before the keys they are intended to modify.  This driver rewrites
the raw report data from such keyboards into USB HID 1.11 compliant
report data.  It only matches the USB vendor and product IDs for the
keyboard it has been tested on. Since there are several keyboards,
notably a number of laptops and folding USB keyboards known to have
similar unresolved problem reports, the list is expected to grow.

Signed-off-by: Terry Lambert <tlambert@chromium.org>
---
 drivers/hid/Kconfig      |    8 +++
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-ids.h    |    3 +
 drivers/hid/hid-primax.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-primax.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 1130a89..a097e17 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -441,6 +441,14 @@ config HID_PICOLCD_LEDS
 	---help---
 	  Provide access to PicoLCD's GPO pins via leds class.
 
+config HID_PRIMAX
+	tristate "Primax non-fully HID-compliant devices" if EXPERT
+	depends on USB_HID
+	default !EXPERT
+	---help---
+	Support for Primax devices that are not fully compliant with the
+	HID standard.
+
 config HID_QUANTA
 	tristate "Quanta Optical Touch panels"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0a0a38e..735b8cc 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_HID_QUANTA)	+= hid-quanta.o
 obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
+obj-$(CONFIG_HID_PRIMAX)	+= hid-primax.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
 obj-$(CONFIG_HID_ROCCAT_COMMON)	+= hid-roccat-common.o
 obj-$(CONFIG_HID_ROCCAT_ARVO)	+= hid-roccat-arvo.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 242353d..7d2d5d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1461,6 +1461,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7484e1b..bd2a2ec 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -693,4 +693,7 @@
 #define USB_VENDOR_ID_ZYDACRON	0x13EC
 #define USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL	0x0006
 
+#define USB_VENDOR_ID_PRIMAX	0x0461
+#define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
+
 #endif
diff --git a/drivers/hid/hid-primax.c b/drivers/hid/hid-primax.c
new file mode 100644
index 0000000..4d3c60d
--- /dev/null
+++ b/drivers/hid/hid-primax.c
@@ -0,0 +1,117 @@
+/*
+ * HID driver for primax and similar keyboards with in-band modifiers
+ *
+ * Copyright 2011 Google Inc. All Rights Reserved
+ *
+ * Author:
+ *	Terry Lambert <tlambert@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+static int px_raw_event(struct hid_device *hid, struct hid_report *report,
+	 u8 *data, int size)
+{
+	int idx = size;
+
+	switch (report->id) {
+	case 0:		/* keyboard input */
+		/*
+		 * Convert in-band modifier key values into out of band
+		 * modifier bits and pull the key strokes from the report.
+		 * Thus a report data set which looked like:
+		 *
+		 * [00][00][E0][30][00][00][00][00]
+		 * (no modifier bits + "Left Shift" key + "1" key)
+		 *
+		 * Would be converted to:
+		 *
+		 * [01][00][00][30][00][00][00][00]
+		 * (Left Shift modifier bit + "1" key)
+		 *
+		 * As long as it's in the size range, the upper level
+		 * drivers don't particularly care if there are in-band
+		 * 0-valued keys, so they don't stop parsing.
+		 */
+		while (--idx > 1) {
+			if (data[idx] < 0xE0 || data[idx] > 0xE7)
+				continue;
+			data[0] |= (1 << (data[idx] - 0xE0));
+			data[idx] = 0;
+		}
+		hid_report_raw_event(hid, HID_INPUT_REPORT, data, size, 0);
+		return 1;
+
+	default:	/* unknown report */
+		/* Unknown report type; pass upstream */
+		hid_info(hid, "unknown report type %d\n", report->id);
+		break;
+	}
+
+	return 0;
+}
+
+static int px_probe(struct hid_device *hid, const struct hid_device_id *id)
+{
+	int ret;
+
+	ret = hid_parse(hid);
+	if (ret) {
+		hid_err(hid, "parse failed\n");
+		goto fail;
+	}
+
+	ret = hid_hw_start(hid, HID_CONNECT_DEFAULT);
+	if (ret)
+		hid_err(hid, "hw start failed\n");
+
+fail:
+	return ret;
+}
+
+static void px_remove(struct hid_device *hid)
+{
+	hid_hw_stop(hid);
+}
+
+static const struct hid_device_id px_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, px_devices);
+
+static struct hid_driver px_driver = {
+	.name = "primax",
+	.id_table = px_devices,
+	.raw_event = px_raw_event,
+	.probe = px_probe,
+	.remove = px_remove,
+};
+
+static int __init px_init(void)
+{
+	return hid_register_driver(&px_driver);
+}
+
+static void __exit px_exit(void)
+{
+	hid_unregister_driver(&px_driver);
+}
+
+module_init(px_init);
+module_exit(px_exit);
+MODULE_AUTHOR("Terry Lambert <tlambert@google.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.3.1

