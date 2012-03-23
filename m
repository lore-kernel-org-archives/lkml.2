Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab2CWTc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695Ab2CWTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:32:56 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, ajax@redhat.com, Matthew Garrett <mjg@redhat.com>,
        benh@kernel.crashing.org
Subject: [PATCH 1/4] vgaarb: Add support for setting the default video device
Date: Fri, 23 Mar 2012 15:32:35 -0400
Message-Id: <1332531158-2319-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1332531158-2319-1-git-send-email-mjg@redhat.com>
References: <1332531158-2319-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
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
 drivers/gpu/vga/vgaarb.c |    7 +++++++
 drivers/pci/pci-sysfs.c  |    5 +++++
 include/linux/vgaarb.h   |    3 +++
 3 files changed, 15 insertions(+), 0 deletions(-)

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
index 9c3120d..7ad7f2a 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -31,6 +31,7 @@
 #ifndef LINUX_VGA_H
 #define LINUX_VGA_H
 
+#include <video/vga.h>
 
 /* Legacy VGA regions */
 #define VGA_RSRC_NONE	       0x00
@@ -177,10 +178,12 @@ extern void vga_put(struct pci_dev *pdev, unsigned int rsrc);
  *     I suppose it's a matter of having the proper arch hook telling
  *     us about it, so we basically never allow anybody to succeed a
  *     vga_get()...
+ *
  */
 
 #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
 extern struct pci_dev *vga_default_device(void);
+extern void vga_set_default_device(struct pci_dev *pdev)
 #endif
 
 /**
-- 
1.7.7.6

