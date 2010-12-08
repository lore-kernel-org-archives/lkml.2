Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0LHAr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:29 -0500
Received: from kroah.org ([198.145.64.141]:58400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab0LHAr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:27 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:30 2010
Message-Id: <20101208004430.598126137@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Jones <pjones@redhat.com>, maximilian attems <max@stro.at>
Subject: [063/127] efifb: check that the base address is plausible on pci systems
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Jones <pjones@redhat.com>

commit 85a00d9bbfb4704fbf368944b1cb9fed8f1598c5 upstream.

Some Apple machines have identical DMI data but different memory
configurations for the video.  Given that, check that the address in our
table is actually within the range of a PCI BAR on a VGA device in the
machine.

This also fixes up the return value from set_system(), which has always
been wrong, but never resulted in bad behavior since there's only ever
been one matching entry in the dmi table.

The patch

1) stops people's machines from crashing when we get their display wrong,
   which seems to be unfortunately inevitable,

2) allows us to support identical dmi data with differing video memory
   configurations

This also adds me as the efifb maintainer, since I've effectively been
acting as such for quite some time.

Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS           |    6 ++++
 drivers/video/efifb.c |   61 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 55 insertions(+), 12 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1974,6 +1974,12 @@ W:	http://acpi4asus.sf.net
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
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <linux/dmi.h>
-
+#include <linux/pci.h>
 #include <video/vga.h>
 
 static struct fb_var_screeninfo efifb_defined __initdata = {
@@ -113,7 +113,7 @@ static int set_system(const struct dmi_s
 {
 	struct efifb_dmi_info *info = id->driver_data;
 	if (info->base == 0)
-		return -ENODEV;
+		return 0;
 
 	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at %p "
 			 "(%dx%d, stride %d)\n", id->ident,
@@ -121,18 +121,55 @@ static int set_system(const struct dmi_s
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


