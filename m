Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0IITR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab0IITRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:17:49 -0400
From: Peter Jones <pjones@redhat.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH 1/2] Make efifb check that the base address is plausible on pci systems.
Date: Thu,  9 Sep 2010 15:16:48 -0400
Message-Id: <1284059809-9973-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Apple machines have identical DMI data but different memory
configurations for the video. Given that, check that the address in our
table is actually within the range of a PCI BAR on a VGA deivce in the
machine.

This also fixes up the return value from set_system(), which has
always been wrong, but never resulted in bad behavior since there's only
ever been one matching entry in the dmi table.

This also adds me as the efifb maintainer, since I've effectively been
acting as such for quite some time.

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 MAINTAINERS           |    6 +++++
 drivers/video/efifb.c |   61 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 087912a..431280f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2189,6 +2189,12 @@ W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/eeepc-laptop.c
 
+EFIFB FRAMEBUFFER DRIVER
+L:	linux-fbdev@vger.kernel.org
+M:	Peter Jones <pjones@redhat.com>
+S:	Maintained
+F:	drivers/video/efifb.c
+
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 815f84b..c082b61 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <linux/dmi.h>
-
+#include <linux/pci.h>
 #include <video/vga.h>
 
 static struct fb_var_screeninfo efifb_defined __devinitdata = {
@@ -116,7 +116,7 @@ static int set_system(const struct dmi_system_id *id)
 {
 	struct efifb_dmi_info *info = id->driver_data;
 	if (info->base == 0)
-		return -ENODEV;
+		return 0;
 
 	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at %p "
 			 "(%dx%d, stride %d)\n", id->ident,
@@ -124,18 +124,55 @@ static int set_system(const struct dmi_system_id *id)
 			 info->stride);
 
 	/* Trust the bootloader over the DMI tables */
-	if (screen_info.lfb_base == 0)
+	if (screen_info.lfb_base == 0) {
+#if defined(CONFIG_PCI)
+		struct pci_dev *dev = NULL;
+		int found_bar = 0;
+#endif
 		screen_info.lfb_base = info->base;
-	if (screen_info.lfb_linelength == 0)
-		screen_info.lfb_linelength = info->stride;
-	if (screen_info.lfb_width == 0)
-		screen_info.lfb_width = info->width;
-	if (screen_info.lfb_height == 0)
-		screen_info.lfb_height = info->height;
-	if (screen_info.orig_video_isVGA == 0)
-		screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
 
-	return 0;
+#if defined(CONFIG_PCI)
+		/* make sure that the address in the table is actually on a
+		 * VGA device's PCI BAR */
+
+		for_each_pci_dev(dev) {
+			int i;
+			if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+				continue;
+			for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+				resource_size_t start, end;
+
+				start = pci_resource_start(dev, i);
+				if (start == 0)
+					break;
+				end = pci_resource_end(dev, i);
+				if (screen_info.lfb_base >= start &&
+						screen_info.lfb_base < end) {
+					found_bar = 1;
+				}
+			}
+		}
+		if (!found_bar)
+			screen_info.lfb_base = 0;
+#endif
+	}
+	if (screen_info.lfb_base) {
+		if (screen_info.lfb_linelength == 0)
+			screen_info.lfb_linelength = info->stride;
+		if (screen_info.lfb_width == 0)
+			screen_info.lfb_width = info->width;
+		if (screen_info.lfb_height == 0)
+			screen_info.lfb_height = info->height;
+		if (screen_info.orig_video_isVGA == 0)
+			screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
+	} else {
+		screen_info.lfb_linelength = 0;
+		screen_info.lfb_width = 0;
+		screen_info.lfb_height = 0;
+		screen_info.orig_video_isVGA = 0;
+		return 0;
+	}
+	return 1;
 }
 
 static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
-- 
1.7.2.2

