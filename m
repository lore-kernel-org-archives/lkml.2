Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1GEOvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:51:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59149 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1GEOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:50:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 30/49] gma500: the 'mrst' BIOS is actually MID generic
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:40:43 +0100
Message-ID: <20110705144041.23872.60957.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Shuffle the naming so this reflects better and we can try and build some
sort of ordering to the naming scheme.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile       |    2 
 drivers/staging/gma500/mdfld_device.c |    2 
 drivers/staging/gma500/mid_bios.c     |  271 +++++++++++++++++++++++++++++++++
 drivers/staging/gma500/mid_bios.h     |   21 +++
 drivers/staging/gma500/mrst_bios.c    |  271 ---------------------------------
 drivers/staging/gma500/mrst_bios.h    |   21 ---
 drivers/staging/gma500/mrst_device.c  |    2 
 drivers/staging/gma500/psb_drv.c      |    2 
 8 files changed, 296 insertions(+), 296 deletions(-)
 create mode 100644 drivers/staging/gma500/mid_bios.c
 create mode 100644 drivers/staging/gma500/mid_bios.h
 delete mode 100644 drivers/staging/gma500/mrst_bios.c
 delete mode 100644 drivers/staging/gma500/mrst_bios.h

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 1b525ac..2ad6b1c 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -23,10 +23,10 @@ psb_gfx-y += gem_glue.o \
 	  psb_irq.o \
 	  psb_device.o \
 	  cdv_device.o \
+	  mid_bios.o \
 	  mrst_device.o \
 	  mrst_crtc.o \
 	  mrst_lvds.o \
-	  mrst_bios.o \
 	  mdfld_device.o \
 	  mdfld_output.o \
 	  mdfld_pyr_cmd.o \
diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index daa9487..f258b06 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -26,7 +26,7 @@
 #include "psb_drv.h"
 #include "mdfld_output.h"
 #include "mdfld_dsi_output.h"
-#include "mrst_bios.h"
+#include "mid_bios.h"
 
 /*
  *	Provide the Medfield specific backlight management
diff --git a/drivers/staging/gma500/mid_bios.c b/drivers/staging/gma500/mid_bios.c
new file mode 100644
index 0000000..9a7731c
--- /dev/null
+++ b/drivers/staging/gma500/mid_bios.c
@@ -0,0 +1,271 @@
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
+#include "mid_bios.h"
+#include "mdfld_output.h"
+
+static int panel_id = GCT_DETECT;
+module_param_named(panel_id, panel_id, int, 0600);
+MODULE_PARM_DESC(panel_id, "Panel Identifier");
+
+
+static void mid_get_fuse_settings(struct drm_device *dev)
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
+static void mid_get_pci_revID(struct drm_psb_private *dev_priv)
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
+static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
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
+	if (IS_MFLD(dev_priv->dev)){
+		if (panel_id == GCT_DETECT) {
+			if (dev_priv->gct_data.bpi == 2) {
+				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
+				dev_priv->panel_id = PYR_CMD;
+				panel_id = PYR_CMD;
+			}
+			else if(dev_priv->gct_data.bpi == 0) {
+				dev_info(dev->dev, "[GFX] TMD Panel Detected.\n");
+				dev_priv->panel_id = TMD_VID;
+				panel_id = TMD_VID;
+			}
+			else {
+				dev_info(dev->dev, "[GFX] Default Panel (TPO)\n");
+				dev_priv->panel_id = TPO_CMD;
+				panel_id = TPO_CMD;
+			}
+		} else {
+			dev_info(dev->dev, "[GFX] Panel Parameter Passed in through cmd line\n");
+			dev_priv->panel_id = panel_id;
+		}
+	}
+}
+
+int mid_chip_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	mid_get_fuse_settings(dev);
+	mid_get_vbt_data(dev_priv);
+	mid_get_pci_revID(dev_priv);
+	return 0;
+}
\ No newline at end of file
diff --git a/drivers/staging/gma500/mid_bios.h b/drivers/staging/gma500/mid_bios.h
new file mode 100644
index 0000000..00e7d56
--- /dev/null
+++ b/drivers/staging/gma500/mid_bios.h
@@ -0,0 +1,21 @@
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
+extern int mid_chip_setup(struct drm_device *dev);
+
diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
deleted file mode 100644
index cf015df..0000000
--- a/drivers/staging/gma500/mrst_bios.c
+++ /dev/null
@@ -1,271 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2011, Intel Corporation.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- **************************************************************************/
-
-/* TODO
- * - Split functions by vbt type
- * - Make them all take drm_device
- * - Check ioremap failures
- */
-
-#include <drm/drmP.h>
-#include <drm/drm.h>
-#include "psb_drm.h"
-#include "psb_drv.h"
-#include "mrst_bios.h"
-#include "mdfld_output.h"
-
-static int panel_id = GCT_DETECT;
-module_param_named(panel_id, panel_id, int, 0600);
-MODULE_PARM_DESC(panel_id, "Panel Identifier");
-
-
-static void mid_get_fuse_settings(struct drm_device *dev)
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
-	 /* Prevent runtime suspend at start*/
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
-	dev_dbg(dev->dev, "SKU values is 0x%x.\n", fuse_value);
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
-	dev_dbg(dev->dev, "LNC core clk is %dMHz.\n", dev_priv->core_freq);
-	pci_dev_put(pci_root);
-}
-
-/*
- *	Get the revison ID, B0:D2:F0;0x08
- */
-static void mid_get_pci_revID(struct drm_psb_private *dev_priv)
-{
-	uint32_t platform_rev_id = 0;
-	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
-
-	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
-	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
-	pci_dev_put(pci_gfx_root);
-	dev_dbg(dev_priv->dev->dev, "platform_rev_id is %x\n",
-					dev_priv->platform_rev_id);
-}
-
-static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
-{
-	struct drm_device *dev = dev_priv->dev;
-	struct mrst_vbt *vbt = &dev_priv->vbt_data;
-	u32 addr;
-	u16 new_size;
-	u8 *vbt_virtual;
-	u8 bpi;
-	u8 number_desc = 0;
-	struct mrst_timing_info *dp_ti = &dev_priv->gct_data.DTD;
-	struct gct_r10_timing_info ti;
-	void *pGCT;
-	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
-
-	/* Get the address of the platform config vbt, B0:D2:F0;0xFC */
-	pci_read_config_dword(pci_gfx_root, 0xFC, &addr);
-	pci_dev_put(pci_gfx_root);
-
-	dev_dbg(dev->dev, "drm platform config address is %x\n", addr);
-
-	/* check for platform config address == 0. */
-	/* this means fw doesn't support vbt */
-
-	if (addr == 0) {
-		vbt->size = 0;
-		return;
-	}
-
-	/* get the virtual address of the vbt */
-	vbt_virtual = ioremap(addr, sizeof(*vbt));
-
-	memcpy(vbt, vbt_virtual, sizeof(*vbt));
-	iounmap(vbt_virtual); /* Free virtual address space */
-
-	dev_dbg(dev->dev, "GCT revision is %x\n", vbt->revision);
-
-	switch (vbt->revision) {
-	case 0:
-		vbt->mrst_gct = ioremap(addr + sizeof(*vbt) - 4,
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
-		vbt->mrst_gct = ioremap(addr + sizeof(*vbt) - 4,
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
-		vbt->mrst_gct = ioremap(addr + GCT_R10_HEADER_SIZE,
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
-		/* Move the MIPI_Display_Descriptor data from GCT to dev priv */
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-							*((u8 *)pGCT + 0x0d);
-		dev_priv->gct_data.Panel_MIPI_Display_Descriptor |=
-						(*((u8 *)pGCT + 0x0e)) << 8;
-		break;
-	default:
-		dev_err(dev->dev, "Unknown revision of GCT!\n");
-		vbt->size = 0;
-	}
-	if (IS_MFLD(dev_priv->dev)){
-		if (panel_id == GCT_DETECT) {
-			if (dev_priv->gct_data.bpi == 2) {
-				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
-				dev_priv->panel_id = PYR_CMD;
-				panel_id = PYR_CMD;
-			}
-			else if(dev_priv->gct_data.bpi == 0) {
-				dev_info(dev->dev, "[GFX] TMD Panel Detected.\n");
-				dev_priv->panel_id = TMD_VID;
-				panel_id = TMD_VID;
-			}
-			else {
-				dev_info(dev->dev, "[GFX] Default Panel (TPO)\n");
-				dev_priv->panel_id = TPO_CMD;
-				panel_id = TPO_CMD;
-			}
-		} else {
-			dev_info(dev->dev, "[GFX] Panel Parameter Passed in through cmd line\n");
-			dev_priv->panel_id = panel_id;
-		}
-	}
-}
-
-int mid_chip_setup(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	mid_get_fuse_settings(dev);
-	mid_get_vbt_data(dev_priv);
-	mid_get_pci_revID(dev_priv);
-	return 0;
-}
\ No newline at end of file
diff --git a/drivers/staging/gma500/mrst_bios.h b/drivers/staging/gma500/mrst_bios.h
deleted file mode 100644
index 00e7d56..0000000
--- a/drivers/staging/gma500/mrst_bios.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2011, Intel Corporation.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- **************************************************************************/
-
-extern int mid_chip_setup(struct drm_device *dev);
-
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index d71e8d3..195a25b 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -25,7 +25,7 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include <asm/intel_scu_ipc.h>
-#include "mrst_bios.h"
+#include "mid_bios.h"
 
 /* IPC message and command defines used to enable/disable mipi panel voltages */
 #define IPC_MSG_PANEL_ON_OFF    0xE9
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index cf5fe91..ba47178 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -27,7 +27,7 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_bios.h"
-#include "mrst_bios.h"
+#include "mid_bios.h"
 #include "mdfld_dsi_dbi.h"
 #include <drm/drm_pciids.h>
 #include "psb_powermgmt.h"

