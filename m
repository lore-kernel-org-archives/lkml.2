Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0GKAbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 20:31:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47554 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0GKAbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 20:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hSRRN1MKJviGX/o3WTiZAn2JIe5YWNraGTS2zaJLwM+XhaFOgh+5/JNJs/criNxYVa
         dhpZ4UtkyoaYojF9AAtHPEGktPMHfgp6LdkdlxbxNPz8HnNIBvUR4Tfd/kNXm1yLmtwq
         /SZkvxabytmhL2OymMM4GMpBtcWx2dErr2N/k=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, gregkh@suse.de, jlee@novell.com, Dennis.Jansen@web.de,
       linux-acpi@vger.kernel.org
Subject: [PATCH] Add intel drm blacklist to intel_opregion_present detect
Date: Sun, 11 Jul 2010 08:30:44 +0800
Message-Id: <1278808244-6547-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
there are use poulsbo chip and drm driver not support it because legal issue.
Those machines's acpi backlight control actually work fine and don't need apply
the intel opregion support.
So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
brightness interface but not use intel opregion.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/acpi/video.c    |   17 ++++++++++++++++-
 include/linux/pci_ids.h |    1 +
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 9865d46..25a70e0 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -88,6 +88,11 @@ static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device, int type);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
 
+static const struct pci_device_id intel_drm_blacklist[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA) },
+	{ } /* Terminating entry */
+};
+
 static const struct acpi_device_id video_device_ids[] = {
 	{ACPI_VIDEO_HID, 0},
 	{"", 0},
@@ -2531,8 +2536,11 @@ static int __init intel_opregion_present(void)
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
@@ -2540,7 +2548,14 @@ static int __init intel_opregion_present(void)
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
index 3bedcc1..78858b1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2669,6 +2669,7 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_SCH_VGA	0x8108
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
-- 
1.6.0.2

