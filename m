Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1F1WI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:08:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41002 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1F1WIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:08:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 20/29] gma500: Extract BIOSisy stuff from psb_drv
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:07:49 +0100
Message-ID: <20110628220747.898.13700.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is too big already so lets rip out more of the device specific crud. It
also means we pull the ugly stuff that needs work out of our main line of
cleanup.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile    |    1 
 drivers/staging/gma500/mrst_bios.c |  236 ++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/mrst_bios.h |   22 +++
 drivers/staging/gma500/psb_drv.c   |  209 --------------------------------
 4 files changed, 260 insertions(+), 208 deletions(-)
 create mode 100644 drivers/staging/gma500/mrst_bios.c
 create mode 100644 drivers/staging/gma500/mrst_bios.h


diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 4c9c475..fdaac63 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -23,6 +23,7 @@ psb_gfx-y += gem_glue.o \
 	  psb_irq.o \
 	  mrst_crtc.o \
 	  mrst_lvds.o \
+	  mrst_bios.o \
 	  mdfld_output.o \
 	  mdfld_pyr_cmd.o \
 	  mdfld_tmd_vid.o \
diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
new file mode 100644
index 0000000..0d944c4
--- /dev/null
+++ b/drivers/staging/gma500/mrst_bios.c
@@ -0,0 +1,236 @@
+/**************************************************************************
+ * Copyright (c) 2011, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+/* TODO
+ * - Split functions by vbt type
+ * - Make them all take drm_device
+ * - Check ioremap failures
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+#include "mrst_bios.h"
+
+void mrst_get_fuse_settings(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	uint32_t fuse_value = 0;
+	uint32_t fuse_value_tmp = 0;
+
+#define FB_REG06 0xD0810600
+#define FB_MIPI_DISABLE  (1 << 11)
+#define FB_REG09 0xD0810900
+#define FB_REG09 0xD0810900
+#define FB_SKU_MASK  0x7000
+#define FB_SKU_SHIFT 12
+#define FB_SKU_100 0
+#define FB_SKU_100L 1
+#define FB_SKU_83 2
+	pci_write_config_dword(pci_root, 0xD0, FB_REG06);
+	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
+
+	/* FB_MIPI_DISABLE doesn't mean LVDS on with Medfield */
+	if (IS_MRST(dev))
+		dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
+
+	DRM_INFO("internal display is %s\n",
+		 dev_priv->iLVDS_enable ? "LVDS display" : "MIPI display");
+
+	 /* Prevent runtime suspend at start*/
+	 if (dev_priv->iLVDS_enable) {
+		dev_priv->is_lvds_on = true;
+		dev_priv->is_mipi_on = false;
+	} else {
+		dev_priv->is_mipi_on = true;
+		dev_priv->is_lvds_on = false;
+	}
+
+	dev_priv->video_device_fuse = fuse_value;
+
+	pci_write_config_dword(pci_root, 0xD0, FB_REG09);
+	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
+
+	dev_dbg(dev->dev, "SKU values is 0x%x.\n", fuse_value);
+	fuse_value_tmp = (fuse_value & FB_SKU_MASK) >> FB_SKU_SHIFT;
+
+	dev_priv->fuse_reg_value = fuse_value;
+
+	switch (fuse_value_tmp) {
+	case FB_SKU_100:
+		dev_priv->core_freq = 200;
+		break;
+	case FB_SKU_100L:
+		dev_priv->core_freq = 100;
+		break;
+	case FB_SKU_83:
+		dev_priv->core_freq = 166;
+		break;
+	default:
+		dev_warn(dev->dev, "Invalid SKU values, SKU value = 0x%08x\n",
+								fuse_value_tmp);
+		dev_priv->core_freq = 0;
+	}
+	dev_dbg(dev->dev, "LNC core clk is %dMHz.\n", dev_priv->core_freq);
+	pci_dev_put(pci_root);
+}
+
+/*
+ *	Get the revison ID, B0:D2:F0;0x08
+ */
+void mid_get_pci_revID(struct drm_psb_private *dev_priv)
+{
+	uint32_t platform_rev_id = 0;
+	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
+
+	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
+	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
+	pci_dev_put(pci_gfx_root);
+	dev_dbg(dev_priv->dev->dev, "platform_rev_id is %x\n",
+					dev_priv->platform_rev_id);
+}
+
+void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
+{
+	struct drm_device *dev = dev_priv->dev;
+	struct mrst_vbt *vbt = &dev_priv->vbt_data;
+	u32 addr;
+	u16 new_size;
+	u8 *vbt_virtual;
+	u8 bpi;
+	u8 number_desc = 0;
+	struct mrst_timing_info *dp_ti = &dev_priv->gct_data.DTD;
+	struct gct_r10_timing_info ti;
+	void *pGCT;
+	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
+
+	/* Get the address of the platform config vbt, B0:D2:F0;0xFC */
+	pci_read_config_dword(pci_gfx_root, 0xFC, &addr);
+	pci_dev_put(pci_gfx_root);
+
+	dev_dbg(dev->dev, "drm platform config address is %x\n", addr);
+
+	/* check for platform config address == 0. */
+	/* this means fw doesn't support vbt */
+
+	if (addr == 0) {
+		vbt->size = 0;
+		return;
+	}
+
+	/* get the virtual address of the vbt */
+	vbt_virtual = ioremap(addr, sizeof(*vbt));
+
+	memcpy(vbt, vbt_virtual, sizeof(*vbt));
+	iounmap(vbt_virtual); /* Free virtual address space */
+
+	dev_dbg(dev->dev, "GCT revision is %x\n", vbt->revision);
+
+	switch (vbt->revision) {
+	case 0:
+		vbt->mrst_gct = ioremap(addr + sizeof(*vbt) - 4,
+					vbt->size - sizeof(*vbt) + 4);
+		pGCT = vbt->mrst_gct;
+		bpi = ((struct mrst_gct_v1 *)pGCT)->PD.BootPanelIndex;
+		dev_priv->gct_data.bpi = bpi;
+		dev_priv->gct_data.pt =
+			((struct mrst_gct_v1 *)pGCT)->PD.PanelType;
+		memcpy(&dev_priv->gct_data.DTD,
+			&((struct mrst_gct_v1 *)pGCT)->panel[bpi].DTD,
+				sizeof(struct mrst_timing_info));
+		dev_priv->gct_data.Panel_Port_Control =
+		  ((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_Port_Control;
+		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
+			((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
+		break;
+	case 1:
+		vbt->mrst_gct = ioremap(addr + sizeof(*vbt) - 4,
+					vbt->size - sizeof(*vbt) + 4);
+		pGCT = vbt->mrst_gct;
+		bpi = ((struct mrst_gct_v2 *)pGCT)->PD.BootPanelIndex;
+		dev_priv->gct_data.bpi = bpi;
+		dev_priv->gct_data.pt =
+			((struct mrst_gct_v2 *)pGCT)->PD.PanelType;
+		memcpy(&dev_priv->gct_data.DTD,
+			&((struct mrst_gct_v2 *)pGCT)->panel[bpi].DTD,
+				sizeof(struct mrst_timing_info));
+		dev_priv->gct_data.Panel_Port_Control =
+		  ((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_Port_Control;
+		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
+			((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
+		break;
+	case 0x10:
+		/*header definition changed from rev 01 (v2) to rev 10h. */
+		/*so, some values have changed location*/
+		new_size = vbt->checksum; /*checksum contains lo size byte*/
+		/*LSB of mrst_gct contains hi size byte*/
+		new_size |= ((0xff & (unsigned int)vbt->mrst_gct)) << 8;
+
+		vbt->checksum = vbt->size; /*size contains the checksum*/
+		if (new_size > 0xff)
+			vbt->size = 0xff; /*restrict size to 255*/
+		else
+			vbt->size = new_size;
+
+		/* number of descriptors defined in the GCT */
+		number_desc = ((0xff00 & (unsigned int)vbt->mrst_gct)) >> 8;
+		bpi = ((0xff0000 & (unsigned int)vbt->mrst_gct)) >> 16;
+		vbt->mrst_gct = ioremap(addr + GCT_R10_HEADER_SIZE,
+				GCT_R10_DISPLAY_DESC_SIZE * number_desc);
+		pGCT = vbt->mrst_gct;
+		pGCT = (u8 *)pGCT + (bpi*GCT_R10_DISPLAY_DESC_SIZE);
+		dev_priv->gct_data.bpi = bpi; /*save boot panel id*/
+
+		/*copy the GCT display timings into a temp structure*/
+		memcpy(&ti, pGCT, sizeof(struct gct_r10_timing_info));
+
+		/*now copy the temp struct into the dev_priv->gct_data*/
+		dp_ti->pixel_clock = ti.pixel_clock;
+		dp_ti->hactive_hi = ti.hactive_hi;
+		dp_ti->hactive_lo = ti.hactive_lo;
+		dp_ti->hblank_hi = ti.hblank_hi;
+		dp_ti->hblank_lo = ti.hblank_lo;
+		dp_ti->hsync_offset_hi = ti.hsync_offset_hi;
+		dp_ti->hsync_offset_lo = ti.hsync_offset_lo;
+		dp_ti->hsync_pulse_width_hi = ti.hsync_pulse_width_hi;
+		dp_ti->hsync_pulse_width_lo = ti.hsync_pulse_width_lo;
+		dp_ti->vactive_hi = ti.vactive_hi;
+		dp_ti->vactive_lo = ti.vactive_lo;
+		dp_ti->vblank_hi = ti.vblank_hi;
+		dp_ti->vblank_lo = ti.vblank_lo;
+		dp_ti->vsync_offset_hi = ti.vsync_offset_hi;
+		dp_ti->vsync_offset_lo = ti.vsync_offset_lo;
+		dp_ti->vsync_pulse_width_hi = ti.vsync_pulse_width_hi;
+		dp_ti->vsync_pulse_width_lo = ti.vsync_pulse_width_lo;
+
+		/* Move the MIPI_Display_Descriptor data from GCT to dev priv */
+		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
+							*((u8 *)pGCT + 0x0d);
+		dev_priv->gct_data.Panel_MIPI_Display_Descriptor |=
+						(*((u8 *)pGCT + 0x0e)) << 8;
+		break;
+	default:
+		dev_err(dev->dev, "Unknown revision of GCT!\n");
+		vbt->size = 0;
+	}
+	/* FIXME: Need to sort out Medfield panel identifiers in future */
+}
+
diff --git a/drivers/staging/gma500/mrst_bios.h b/drivers/staging/gma500/mrst_bios.h
new file mode 100644
index 0000000..a257306
--- /dev/null
+++ b/drivers/staging/gma500/mrst_bios.h
@@ -0,0 +1,22 @@
+/**************************************************************************
+ * Copyright (c) 2011, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+extern void mrst_get_fuse_settings(struct drm_device *dev);
+extern void mid_get_pci_revID(struct drm_psb_private *dev_priv);
+extern void mrst_get_vbt_data(struct drm_psb_private *dev_priv);
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 8df9c58..cbdc02c 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -27,6 +27,7 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_bios.h"
+#include "mrst_bios.h"
 #include <drm/drm_pciids.h>
 #include "psb_powermgmt.h"
 #include <linux/cpu.h>
@@ -165,214 +166,6 @@ static void psb_do_takedown(struct drm_device *dev)
 	/* FIXME: do we need to clean up the gtt here ? */
 }
 
-void mrst_get_fuse_settings(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
-	uint32_t fuse_value = 0;
-	uint32_t fuse_value_tmp = 0;
-
-#define FB_REG06 0xD0810600
-#define FB_MIPI_DISABLE  (1 << 11)
-#define FB_REG09 0xD0810900
-#define FB_REG09 0xD0810900
-#define FB_SKU_MASK  0x7000
-#define FB_SKU_SHIFT 12
-#define FB_SKU_100 0
-#define FB_SKU_100L 1
-#define FB_SKU_83 2
-	pci_write_config_dword(pci_root, 0xD0, FB_REG06);
-	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
-
-	/* FB_MIPI_DISABLE doesn't mean LVDS on with Medfield */
-	if (IS_MRST(dev))
-		dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
-
-	DRM_INFO("internal display is %s\n",
-		 dev_priv->iLVDS_enable ? "LVDS display" : "MIPI display");
-
-	 /*prevent Runtime suspend at start*/
-	 if (dev_priv->iLVDS_enable) {
-		dev_priv->is_lvds_on = true;
-		dev_priv->is_mipi_on = false;
-	} else {
-		dev_priv->is_mipi_on = true;
-		dev_priv->is_lvds_on = false;
-	}
-
-	dev_priv->video_device_fuse = fuse_value;
-
-	pci_write_config_dword(pci_root, 0xD0, FB_REG09);
-	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
-
-	DRM_INFO("SKU values is 0x%x.\n", fuse_value);
-	fuse_value_tmp = (fuse_value & FB_SKU_MASK) >> FB_SKU_SHIFT;
-
-	dev_priv->fuse_reg_value = fuse_value;
-
-	switch (fuse_value_tmp) {
-	case FB_SKU_100:
-		dev_priv->core_freq = 200;
-		break;
-	case FB_SKU_100L:
-		dev_priv->core_freq = 100;
-		break;
-	case FB_SKU_83:
-		dev_priv->core_freq = 166;
-		break;
-	default:
-		dev_warn(dev->dev, "Invalid SKU values, SKU value = 0x%08x\n",
-								fuse_value_tmp);
-		dev_priv->core_freq = 0;
-	}
-	DRM_INFO("LNC core clk is %dMHz.\n", dev_priv->core_freq);
-	pci_dev_put(pci_root);
-}
-
-void mid_get_pci_revID(struct drm_psb_private *dev_priv)
-{
-	uint32_t platform_rev_id = 0;
-	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
-
-	/*get the revison ID, B0:D2:F0;0x08 */
-	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
-	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
-	pci_dev_put(pci_gfx_root);
-	dev_info(dev_priv->dev->dev, "platform_rev_id is %x\n",
-					dev_priv->platform_rev_id);
-}
-
-void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
-{
-	struct mrst_vbt *vbt = &dev_priv->vbt_data;
-	u32 platform_config_address;
-	u16 new_size;
-	u8 *vbt_virtual;
-	u8 bpi;
-	u8 number_desc = 0;
-	struct mrst_timing_info *dp_ti = &dev_priv->gct_data.DTD;
-	struct gct_r10_timing_info ti;
-	void *pGCT;
-	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
-
-	/*get the address of the platform config vbt, B0:D2:F0;0xFC */
-	pci_read_config_dword(pci_gfx_root, 0xFC, &platform_config_address);
-	pci_dev_put(pci_gfx_root);
-	DRM_INFO("drm platform config address is %x\n",
-			platform_config_address);
-
-	/* check for platform config address == 0. */
-	/* this means fw doesn't support vbt */
-
-	if (platform_config_address == 0) {
-		vbt->size = 0;
-		return;
-	}
-
-	/* get the virtual address of the vbt */
-	vbt_virtual = ioremap(platform_config_address, sizeof(*vbt));
-
-	memcpy(vbt, vbt_virtual, sizeof(*vbt));
-	iounmap(vbt_virtual); /* Free virtual address space */
-
-	printk(KERN_ALERT "GCT revision is %x\n", vbt->revision);
-
-	switch (vbt->revision) {
-	case 0:
-		vbt->mrst_gct = NULL;
-		vbt->mrst_gct = \
-			ioremap(platform_config_address + sizeof(*vbt) - 4,
-					vbt->size - sizeof(*vbt) + 4);
-		pGCT = vbt->mrst_gct;
-		bpi = ((struct mrst_gct_v1 *)pGCT)->PD.BootPanelIndex;
-		dev_priv->gct_data.bpi = bpi;
-		dev_priv->gct_data.pt =
-			((struct mrst_gct_v1 *)pGCT)->PD.PanelType;
-		memcpy(&dev_priv->gct_data.DTD,
-			&((struct mrst_gct_v1 *)pGCT)->panel[bpi].DTD,
-				sizeof(struct mrst_timing_info));
-		dev_priv->gct_data.Panel_Port_Control =
-		  ((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_Port_Control;
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-			((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
-		break;
-	case 1:
-		vbt->mrst_gct = NULL;
-		vbt->mrst_gct = \
-			ioremap(platform_config_address + sizeof(*vbt) - 4,
-					vbt->size - sizeof(*vbt) + 4);
-		pGCT = vbt->mrst_gct;
-		bpi = ((struct mrst_gct_v2 *)pGCT)->PD.BootPanelIndex;
-		dev_priv->gct_data.bpi = bpi;
-		dev_priv->gct_data.pt =
-			((struct mrst_gct_v2 *)pGCT)->PD.PanelType;
-		memcpy(&dev_priv->gct_data.DTD,
-			&((struct mrst_gct_v2 *)pGCT)->panel[bpi].DTD,
-				sizeof(struct mrst_timing_info));
-		dev_priv->gct_data.Panel_Port_Control =
-		  ((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_Port_Control;
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-			((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
-		break;
-	case 0x10:
-		/*header definition changed from rev 01 (v2) to rev 10h. */
-		/*so, some values have changed location*/
-		new_size = vbt->checksum; /*checksum contains lo size byte*/
-		/*LSB of mrst_gct contains hi size byte*/
-		new_size |= ((0xff & (unsigned int)vbt->mrst_gct)) << 8;
-
-		vbt->checksum = vbt->size; /*size contains the checksum*/
-		if (new_size > 0xff)
-			vbt->size = 0xff; /*restrict size to 255*/
-		else
-			vbt->size = new_size;
-
-		/* number of descriptors defined in the GCT */
-		number_desc = ((0xff00 & (unsigned int)vbt->mrst_gct)) >> 8;
-		bpi = ((0xff0000 & (unsigned int)vbt->mrst_gct)) >> 16;
-		vbt->mrst_gct = NULL;
-		vbt->mrst_gct = \
-			ioremap(platform_config_address + GCT_R10_HEADER_SIZE,
-				GCT_R10_DISPLAY_DESC_SIZE * number_desc);
-		pGCT = vbt->mrst_gct;
-		pGCT = (u8 *)pGCT + (bpi*GCT_R10_DISPLAY_DESC_SIZE);
-		dev_priv->gct_data.bpi = bpi; /*save boot panel id*/
-
-		/*copy the GCT display timings into a temp structure*/
-		memcpy(&ti, pGCT, sizeof(struct gct_r10_timing_info));
-
-		/*now copy the temp struct into the dev_priv->gct_data*/
-		dp_ti->pixel_clock = ti.pixel_clock;
-		dp_ti->hactive_hi = ti.hactive_hi;
-		dp_ti->hactive_lo = ti.hactive_lo;
-		dp_ti->hblank_hi = ti.hblank_hi;
-		dp_ti->hblank_lo = ti.hblank_lo;
-		dp_ti->hsync_offset_hi = ti.hsync_offset_hi;
-		dp_ti->hsync_offset_lo = ti.hsync_offset_lo;
-		dp_ti->hsync_pulse_width_hi = ti.hsync_pulse_width_hi;
-		dp_ti->hsync_pulse_width_lo = ti.hsync_pulse_width_lo;
-		dp_ti->vactive_hi = ti.vactive_hi;
-		dp_ti->vactive_lo = ti.vactive_lo;
-		dp_ti->vblank_hi = ti.vblank_hi;
-		dp_ti->vblank_lo = ti.vblank_lo;
-		dp_ti->vsync_offset_hi = ti.vsync_offset_hi;
-		dp_ti->vsync_offset_lo = ti.vsync_offset_lo;
-		dp_ti->vsync_pulse_width_hi = ti.vsync_pulse_width_hi;
-		dp_ti->vsync_pulse_width_lo = ti.vsync_pulse_width_lo;
-
-		/*mov the MIPI_Display_Descriptor data from GCT to dev priv*/
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-							*((u8 *)pGCT + 0x0d);
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor |=
-						(*((u8 *)pGCT + 0x0e)) << 8;
-		break;
-	default:
-		printk(KERN_ERR "Unknown revision of GCT!\n");
-		vbt->size = 0;
-	}
-	/* FIXME: Need to sort out Medfield panel identifiers in future */
-}
-
 static void psb_get_core_freq(struct drm_device *dev)
 {
 	uint32_t clock;

