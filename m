Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0DRSXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:23:23 -0400
Received: from tex.lwn.net ([70.33.254.29]:35343 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0DRSV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:21:29 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 02/11] viafb: use proper pci config API
Date: Sun, 18 Apr 2010 12:21:04 -0600
Message-Id: <1271614873-5952-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271614873-5952-1-git-send-email-corbet@lwn.net>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

This patch alters viafb to use the proper Linux in-kernel API to access
PCI configuration space, rather than poking at I/O ports by itself.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/video/via/hw.c       |   62 +++++++++++++++++++++++++----------------
 drivers/video/via/hw.h       |    4 +-
 drivers/video/via/viafbdev.c |    4 +++
 3 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index b1e6dc9..69acae1 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2474,24 +2474,37 @@ static void disable_second_display_channel(void)
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
+static u_int16_t via_function3[] = {
+	CLE266_FUNCTION3, KM400_FUNCTION3, CN400_FUNCTION3, CN700_FUNCTION3,
+	CX700_FUNCTION3, KM800_FUNCTION3, KM890_FUNCTION3, P4M890_FUNCTION3,
+	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3,
+};
+
+/* Get the BIOS-configured framebuffer size from PCI configuration space
+ * of function 3 in the respective chipset */
 int viafb_get_fb_size_from_pci(void)
 {
-	unsigned long configid, deviceid, FBSize = 0;
-	int VideoMemSize;
-	int DeviceFound = false;
-
-	for (configid = 0x80000000; configid < 0x80010800; configid += 0x100) {
-		outl(configid, (unsigned long)0xCF8);
-		deviceid = (inl((unsigned long)0xCFC) >> 16) & 0xffff;
-
-		switch (deviceid) {
-		case CLE266:
-		case KM400:
-			outl(configid + 0xE0, (unsigned long)0xCF8);
-			FBSize = inl((unsigned long)0xCFC);
-			DeviceFound = true;	/* Found device id */
-			break;
+	int i;
+	u_int8_t offset = 0;
+	u_int32_t FBSize;
+	u_int32_t VideoMemSize;
+
+	/* search for the "FUNCTION3" device in this chipset */
+	for (i = 0; i < ARRAY_SIZE(via_function3); i++) {
+		struct pci_dev *pdev;
+
+		pdev = pci_get_device(PCI_VENDOR_ID_VIA, via_function3[i],
+				      NULL);
+		if (!pdev)
+			continue;
+
+		DEBUG_MSG(KERN_INFO "Device ID = %x\n", pdev->device);
 
+		switch (pdev->device) {
+		case CLE266_FUNCTION3:
+		case KM400_FUNCTION3:
+			offset = 0xE0;
+			break;
 		case CN400_FUNCTION3:
 		case CN700_FUNCTION3:
 		case CX700_FUNCTION3:
@@ -2501,21 +2514,22 @@ int viafb_get_fb_size_from_pci(void)
 		case P4M900_FUNCTION3:
 		case VX800_FUNCTION3:
 		case VX855_FUNCTION3:
-			/*case CN750_FUNCTION3: */
-			outl(configid + 0xA0, (unsigned long)0xCF8);
-			FBSize = inl((unsigned long)0xCFC);
-			DeviceFound = true;	/* Found device id */
-			break;
-
-		default:
+		/*case CN750_FUNCTION3: */
+			offset = 0xA0;
 			break;
 		}
 
-		if (DeviceFound)
+		if (!offset)
 			break;
+
+		pci_read_config_dword(pdev, offset, &FBSize);
+		pci_dev_put(pdev);
 	}
 
-	DEBUG_MSG(KERN_INFO "Device ID = %lx\n", deviceid);
+	if (!offset) {
+		printk(KERN_ERR "cannot determine framebuffer size\n");
+		return -EIO;
+	}
 
 	FBSize = FBSize & 0x00007000;
 	DEBUG_MSG(KERN_INFO "FB Size = %x\n", FBSize);
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 12ef32d..d6b25ac 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -823,8 +823,8 @@ struct iga2_crtc_timing {
 };
 
 /* device ID */
-#define CLE266              0x3123
-#define KM400               0x3205
+#define CLE266_FUNCTION3    0x3123
+#define KM400_FUNCTION3     0x3205
 #define CN400_FUNCTION2     0x2259
 #define CN400_FUNCTION3     0x3259
 /* support VT3314 chipset */
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index b7018ef..8af405b 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1782,6 +1782,10 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	viafb_init_chip_info(pdev, ent);
 	viaparinfo->fbmem = pci_resource_start(pdev, 0);
 	viaparinfo->memsize = viafb_get_fb_size_from_pci();
+	if (viaparinfo->memsize < 0) {
+		rc = viaparinfo->memsize;
+		goto out_delete_i2c;
+	}
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
 	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
-- 
1.7.0.1

