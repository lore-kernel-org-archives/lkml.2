Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2DPU0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2DPU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:26:27 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH V2 3/4] x86: Use vga_default_device() when determining whether an fb is primary
Date: Mon, 16 Apr 2012 16:26:04 -0400
Message-Id: <1334607965-9582-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1334607965-9582-1-git-send-email-mjg@redhat.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IORESOURCE_ROM_SHADOW is not necessarily an indication that the hardware
is the primary device. Add support for using the vgaarb functions and
fall back if nothing's set them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
---
 arch/x86/video/fbdev.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/video/fbdev.c b/arch/x86/video/fbdev.c
index c5ffb6a..d5644bb 100644
--- a/arch/x86/video/fbdev.c
+++ b/arch/x86/video/fbdev.c
@@ -9,24 +9,34 @@
 #include <linux/fb.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/vgaarb.h>
 
 int fb_is_primary_device(struct fb_info *info)
 {
 	struct device *device = info->device;
 	struct pci_dev *pci_dev = NULL;
+	struct pci_dev *default_device = vga_default_device();
 	struct resource *res = NULL;
-	int retval = 0;
 
 	if (device)
 		pci_dev = to_pci_dev(device);
 
-	if (pci_dev)
-		res = &pci_dev->resource[PCI_ROM_RESOURCE];
+	if (!pci_dev)
+		return 0;
+
+	if (default_device) {
+		if (pci_dev == default_device)
+			return 1;
+		else
+			return 0;
+	}
+
+	res = &pci_dev->resource[PCI_ROM_RESOURCE];
 
 	if (res && res->flags & IORESOURCE_ROM_SHADOW)
-		retval = 1;
+		return 1;
 
-	return retval;
+	return 0;
 }
 EXPORT_SYMBOL(fb_is_primary_device);
 MODULE_LICENSE("GPL");
-- 
1.7.10

