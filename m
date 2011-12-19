Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1LSUyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:54:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37106 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1LSUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:54:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gma500: Final enables for Oaktrail
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Mon, 19 Dec 2011 21:06:35 +0000
Message-ID: <20111219210615.27346.83876.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This switches the ifdef to match the Kconfig so that Oaktrail probing occurs
and adds some additional minor bulletproofing.

Tested on a Fujtisu Stylistic Q550 internal display. HDMI might work but that
remains to be seen.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/mid_bios.c |   14 ++++++++++++++
 drivers/gpu/drm/gma500/psb_drv.c  |    2 +-
 2 files changed, 15 insertions(+), 1 deletions(-)


diff --git a/drivers/gpu/drm/gma500/mid_bios.c b/drivers/gpu/drm/gma500/mid_bios.c
index 128e6bb..55fee10 100644
--- a/drivers/gpu/drm/gma500/mid_bios.c
+++ b/drivers/gpu/drm/gma500/mid_bios.c
@@ -45,6 +45,12 @@ static void mid_get_fuse_settings(struct drm_device *dev)
 #define FB_SKU_100 0
 #define FB_SKU_100L 1
 #define FB_SKU_83 2
+	if (pci_root == NULL) {
+		WARN_ON(1);
+		return;
+	}
+
+
 	pci_write_config_dword(pci_root, 0xD0, FB_REG06);
 	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
 
@@ -101,6 +107,10 @@ static void mid_get_pci_revID(struct drm_psb_private *dev_priv)
 	uint32_t platform_rev_id = 0;
 	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
 
+	if (pci_gfx_root == NULL) {
+		WARN_ON(1);
+		return;
+	}
 	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
 	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
 	pci_dev_put(pci_gfx_root);
@@ -138,6 +148,10 @@ static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
 
 	/* get the virtual address of the vbt */
 	vbt_virtual = ioremap(addr, sizeof(*vbt));
+	if (vbt_virtual == NULL) {
+		vbt->size = 0;
+		return;
+	}
 
 	memcpy(vbt, vbt_virtual, sizeof(*vbt));
 	iounmap(vbt_virtual); /* Free virtual address space */
diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index add3156..1751132 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -52,7 +52,7 @@ module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
-#if defined(CONFIG_DRM_OAKTRAIL)
+#if defined(CONFIG_DRM_GMA600)
 	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &oaktrail_chip_ops},
 	{ 0x8086, 0x4101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &oaktrail_chip_ops},
 	{ 0x8086, 0x4102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &oaktrail_chip_ops},

