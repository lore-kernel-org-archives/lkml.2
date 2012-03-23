Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab2CWTdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762Ab2CWTc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:32:59 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, ajax@redhat.com, Matthew Garrett <mjg@redhat.com>,
        hpa@zytor.com, matt.fleming@intel.com
Subject: [PATCH 4/4] efifb: Implement vga_default_device()
Date: Fri, 23 Mar 2012 15:32:38 -0400
Message-Id: <1332531158-2319-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1332531158-2319-1-git-send-email-mjg@redhat.com>
References: <1332531158-2319-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI doesn't typically make use of the legacy VGA ROM, but it may still be
configured to pass that through to a given video device. This may lead to
an inaccurate choice of default video device. Add support to efifb to pick
out the correct active video device.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: hpa@zytor.com
Cc: matt.fleming@intel.com
---
 arch/x86/include/asm/vga.h |    6 +++
 drivers/video/efifb.c      |   77 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
index c4b9dc2..2723c07 100644
--- a/arch/x86/include/asm/vga.h
+++ b/arch/x86/include/asm/vga.h
@@ -17,4 +17,10 @@
 #define vga_readb(x) (*(x))
 #define vga_writeb(x, y) (*(y) = (x))
 
+#if CONFIG_FB_EFI
+#define __ARCH_HAS_VGA_DEFAULT_DEVICE
+extern struct pci_dev *vga_default_device(void);
+extern void vga_set_default_device(struct pci_dev *pdev);
+#endif
+
 #endif /* _ASM_X86_VGA_H */
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 784139a..66ed991 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -18,6 +18,8 @@
 
 static bool request_mem_succeeded = false;
 
+static struct pci_dev *default_vga;
+
 static struct fb_var_screeninfo efifb_defined __devinitdata = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
@@ -298,35 +300,70 @@ static struct fb_ops efifb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
+struct pci_dev *vga_default_device(void)
+{
+	return default_vga;
+}
+
+void vga_set_default_device(struct pci_dev *pdev)
+{
+	default_vga = pdev;
+}
+
 static int __init efifb_setup(char *options)
 {
 	char *this_opt;
 	int i;
+	struct pci_dev *dev = NULL;
+
+	if (options && *options) {
+		while ((this_opt = strsep(&options, ",")) != NULL) {
+			if (!*this_opt) continue;
+
+			for (i = 0; i < M_UNKNOWN; i++) {
+				if (!strcmp(this_opt, dmi_list[i].optname) &&
+				    dmi_list[i].base != 0) {
+					screen_info.lfb_base = dmi_list[i].base;
+					screen_info.lfb_linelength = dmi_list[i].stride;
+					screen_info.lfb_width = dmi_list[i].width;
+					screen_info.lfb_height = dmi_list[i].height;
+				}
+			}
+			if (!strncmp(this_opt, "base:", 5))
+				screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
+			else if (!strncmp(this_opt, "stride:", 7))
+				screen_info.lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
+			else if (!strncmp(this_opt, "height:", 7))
+				screen_info.lfb_height = simple_strtoul(this_opt+7, NULL, 0);
+			else if (!strncmp(this_opt, "width:", 6))
+				screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
+		}
+	}
 
-	if (!options || !*options)
-		return 0;
+	for_each_pci_dev(dev) {
+		int i;
 
-	while ((this_opt = strsep(&options, ",")) != NULL) {
-		if (!*this_opt) continue;
+		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+			continue;
 
-		for (i = 0; i < M_UNKNOWN; i++) {
-			if (!strcmp(this_opt, dmi_list[i].optname) &&
-					dmi_list[i].base != 0) {
-				screen_info.lfb_base = dmi_list[i].base;
-				screen_info.lfb_linelength = dmi_list[i].stride;
-				screen_info.lfb_width = dmi_list[i].width;
-				screen_info.lfb_height = dmi_list[i].height;
-			}
+		for (i=0; i < DEVICE_COUNT_RESOURCE; i++) {
+			resource_size_t start, end;
+
+			if (!(pci_resource_flags(dev, i) & IORESOURCE_MEM))
+				continue;
+
+			start = pci_resource_start(dev, i);
+			end  = pci_resource_end(dev, i);
+
+			if (!start || !end)
+				continue;
+
+			if (screen_info.lfb_base >= start &&
+			    (screen_info.lfb_base + screen_info.lfb_size) < end)
+				default_vga = dev;
 		}
-		if (!strncmp(this_opt, "base:", 5))
-			screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
-		else if (!strncmp(this_opt, "stride:", 7))
-			screen_info.lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
-		else if (!strncmp(this_opt, "height:", 7))
-			screen_info.lfb_height = simple_strtoul(this_opt+7, NULL, 0);
-		else if (!strncmp(this_opt, "width:", 6))
-			screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
 	}
+
 	return 0;
 }
 
-- 
1.7.7.6

