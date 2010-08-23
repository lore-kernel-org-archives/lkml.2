Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0HWLmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:42:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63646 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0HWLmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Km9n9mTQJ1nnXqEt+sEtnqiQ2JY1r/HwlJojh4Mu45T4mtEey+58+6Y+mP9mD3DMBb
         Mpt/oK4iCVvCxZv+a1oGDFEoq/Mx6GlEhwu8HtD4iUA5zSjCkPYh9vbEfvo0tCvW2Ti2
         LZEFuwQ1WbSUJsLecZMgOiyNTlntq2tyRNqDs=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jlee@novell.com,
        Dennis.Jansen@web.de, linux-acpi@vger.kernel.org, trenn@suse.de
Subject: [PATCH] Add intel drm blacklist to intel_opregion_present detect
Date: Mon, 23 Aug 2010 19:40:48 +0800
Message-Id: <1282563648-21935-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
there are use poulsbo chip and drm driver not support it because legal issue.
Those machines's acpi backlight control actually work fine and don't need apply
the intel opregion support.
So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
brightness interface on Poulsbo/Morrestown.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/acpi/video.c    |   26 +++++++++++++++++++++++++-
 include/linux/pci_ids.h |   10 ++++++++++
 2 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 67dec0c..de16769 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -88,6 +88,20 @@ static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device, int type);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
 
+static const struct pci_device_id intel_drm_blacklist[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_5) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_7) },
+	{ } /* Terminating entry */
+};
+
 static const struct acpi_device_id video_device_ids[] = {
 	{ACPI_VIDEO_HID, 0},
 	{"", 0},
@@ -2558,8 +2572,11 @@ static int __init intel_opregion_present(void)
 #if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
 	struct pci_dev *dev = NULL;
 	u32 address;
+	int i;
+	bool in_blacklist;
 
 	for_each_pci_dev(dev) {
+		in_blacklist = 0;
 		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
 			continue;
 		if (dev->vendor != PCI_VENDOR_ID_INTEL)
@@ -2567,7 +2584,14 @@ static int __init intel_opregion_present(void)
 		pci_read_config_dword(dev, 0xfc, &address);
 		if (!address)
 			continue;
-		return 1;
+		for (i = 0; intel_drm_blacklist[i].device != 0; i++) {
+			if (dev->device == intel_drm_blacklist[i].device) {
+				in_blacklist = 1;
+				break;
+			}
+		}
+		if (!in_blacklist)
+			return 1;
 	}
 #endif
 	return 0;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f6a3b2d..d7866d0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2675,6 +2675,8 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_SCH_VGA_0	0x8108
+#define PCI_DEVICE_ID_INTEL_SCH_VGA_1	0x8109
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
@@ -2685,6 +2687,14 @@
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_0	0x4100
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_1	0x4101
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_2	0x4102
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_3	0x4103
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_4	0x4104
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_5	0x4105
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_6	0x4106
+#define PCI_DEVICE_ID_INTEL_MRST_VGA_7	0x4107
 
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
-- 
1.6.0.2

