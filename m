Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1BQV3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:23 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34388 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab1BQV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: xgifb: copy PCI ROM properly
Date: Thu, 17 Feb 2011 23:29:13 +0200
Message-Id: <1297978157-14927-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper helper functions to copy the PCI ROM. Also use dynamic memory
allocation. The original code mapped incorrect amount of memory and will
crash on some platforms.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   61 +++++++++++------------------------
 1 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2328926..90dca40 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -54,6 +54,8 @@ int XGIfb_accel = 0;
 #define GPIOG_READ  (1<<1)
 int XGIfb_GetXG21DefaultLVDSModeIdx(void);
 
+#define XGIFB_ROM_SIZE	65536
+
 /* -------------------- Macro definitions ---------------------------- */
 
 #undef XGIFBDEBUG
@@ -2881,52 +2883,26 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 	return 0;
 }
 
-static unsigned char VBIOS_BUF[65535];
-
-static unsigned char *attempt_map_rom(struct pci_dev *dev, void *copy_address)
+static unsigned char *xgifb_copy_rom(struct pci_dev *dev)
 {
-	u32 rom_size = 0;
-	u32 rom_address = 0;
-	int j;
-
-	/*  Get the size of the expansion rom */
-	pci_write_config_dword(dev, PCI_ROM_ADDRESS, 0xFFFFFFFF);
-	pci_read_config_dword(dev, PCI_ROM_ADDRESS, &rom_size);
-	if ((rom_size & 0x01) == 0) {
-		printk("No ROM\n");
-		return NULL;
-	}
+	void __iomem *rom_address;
+	unsigned char *rom_copy;
+	size_t rom_size;
 
-	rom_size &= 0xFFFFF800;
-	rom_size = (~rom_size) + 1;
-
-	rom_address = pci_resource_start(dev, 0);
-	if (rom_address == 0 || rom_address == 0xFFFFFFF0) {
-		printk("No suitable rom address found\n");
+	rom_address = pci_map_rom(dev, &rom_size);
+	if (rom_address == NULL)
 		return NULL;
-	}
 
-	printk("ROM Size is %dK, Address is %x\n", rom_size / 1024, rom_address);
+	rom_copy = vzalloc(XGIFB_ROM_SIZE);
+	if (rom_copy == NULL)
+		goto done;
 
-	/*  Map ROM */
-	pci_write_config_dword(dev, PCI_ROM_ADDRESS, rom_address
-			| PCI_ROM_ADDRESS_ENABLE);
+	rom_size = min_t(size_t, rom_size, XGIFB_ROM_SIZE);
+	memcpy_fromio(rom_copy, rom_address, rom_size);
 
-	/* memcpy(copy_address, rom_address, rom_size); */
-	{
-		unsigned char *virt_addr = ioremap(rom_address, 0x8000000);
-
-		unsigned char *from = (unsigned char *) virt_addr;
-		unsigned char *to = (unsigned char *) copy_address;
-		for (j = 0; j < 65536 /*rom_size*/; j++)
-			*to++ = *from++;
-	}
-
-	pci_write_config_dword(dev, PCI_ROM_ADDRESS, 0);
-
-	printk("Copy is done\n");
-
-	return copy_address;
+done:
+	pci_unmap_rom(dev, rom_address);
+	return rom_copy;
 }
 
 static int __devinit xgifb_probe(struct pci_dev *pdev,
@@ -3039,8 +3015,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	XGIhw_ext.pDevice = NULL;
 	if ((xgi_video_info.chip == XG21) || (XGIfb_userom)) {
-		XGIhw_ext.pjVirtualRomBase = attempt_map_rom(pdev, VBIOS_BUF);
-
+		XGIhw_ext.pjVirtualRomBase = xgifb_copy_rom(pdev);
 		if (XGIhw_ext.pjVirtualRomBase)
 			printk(KERN_INFO "XGIfb: Video ROM found and mapped to %p\n", XGIhw_ext.pjVirtualRomBase);
 		else
@@ -3434,6 +3409,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	return 0;
 
 error:
+	vfree(XGIhw_ext.pjVirtualRomBase);
 	vfree(XGIhw_ext.pSR);
 	vfree(XGIhw_ext.pCR);
 	framebuffer_release(fb_info);
@@ -3449,6 +3425,7 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 	/* Unregister the framebuffer */
 	/* if (xgi_video_info.registered) { */
 	unregister_framebuffer(fb_info);
+	vfree(XGIhw_ext.pjVirtualRomBase);
 	framebuffer_release(fb_info);
 	/* } */
 
-- 
1.5.6.5

