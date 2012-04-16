Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DPU03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2DPU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:26:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, benh@kernel.crashing.org,
        airlied@redhat.com
Subject: [PATCH V2 1/4] vgaarb: Add support for setting the default video device
Date: Mon, 16 Apr 2012 16:26:02 -0400
Message-Id: <1334607965-9582-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default VGA device is a somewhat fluid concept on platforms with
multiple GPUs. Add support for setting it so switching code can update
things appropriately, and make sure that the sysfs code returns the right
device if it's changed.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: benh@kernel.crashing.org
Cc: airlied@redhat.com
---
Updated to fix builds when __ARCH_HAS_VGA_DEFAULT_DEVICE is false.

 drivers/gpu/vga/vgaarb.c |    7 +++++++
 drivers/pci/pci-sysfs.c  |    5 +++++
 include/linux/vgaarb.h   |    2 ++
 3 files changed, 14 insertions(+)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 111d956..e223b96 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -136,6 +136,11 @@ struct pci_dev *vga_default_device(void)
 {
 	return vga_default;
 }
+
+void vga_set_default_device(struct pci_dev *pdev)
+{
+	vga_default = pdev;
+}
 #endif
 
 static inline void vga_irq_set_state(struct vga_device *vgadev, bool state)
@@ -605,10 +610,12 @@ static bool vga_arbiter_del_pci_device(struct pci_dev *pdev)
 		goto bail;
 	}
 
+#ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
 	if (vga_default == pdev) {
 		pci_dev_put(vga_default);
 		vga_default = NULL;
 	}
+#endif
 
 	if (vgadev->decodes & (VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM))
 		vga_decode_count--;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index a3cd8ca..7dd9f2b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
+#include <linux/vgaarb.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -414,6 +415,10 @@ static ssize_t
 boot_vga_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_dev *vga_dev = vga_default_device();
+
+	if (vga_dev)
+		return sprintf(buf, "%u\n", (pdev == vga_dev));
 
 	return sprintf(buf, "%u\n",
 		!!(pdev->resource[PCI_ROM_RESOURCE].flags &
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 9c3120d..759a25b 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -31,6 +31,7 @@
 #ifndef LINUX_VGA_H
 #define LINUX_VGA_H
 
+#include <video/vga.h>
 
 /* Legacy VGA regions */
 #define VGA_RSRC_NONE	       0x00
@@ -181,6 +182,7 @@ extern void vga_put(struct pci_dev *pdev, unsigned int rsrc);
 
 #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
 extern struct pci_dev *vga_default_device(void);
+extern void vga_set_default_device(struct pci_dev *pdev);
 #endif
 
 /**
-- 
1.7.10

