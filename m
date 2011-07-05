Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1GEOv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:51:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50578 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1GEOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:51:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 36/49] gma500: Rename the psb_intel_bios code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:42:11 +0100
Message-ID: <20110705144207.23872.13625.stgit@localhost.localdomain>
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

This is generic for the PC class devices and also very similar to the i915
intel_bios.c so rename it. That way the commonality will be obvious and we
can look at merging them one day, or at least synching them up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile         |    2 
 drivers/staging/gma500/intel_bios.c     |  299 +++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_intel_bios.c |  299 -------------------------------
 3 files changed, 300 insertions(+), 300 deletions(-)
 create mode 100644 drivers/staging/gma500/intel_bios.c
 delete mode 100644 drivers/staging/gma500/psb_intel_bios.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index aa60926..7f76a19 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -9,9 +9,9 @@ psb_gfx-y += gem_glue.o \
 	  framebuffer.o \
 	  gem.o \
 	  gtt.o \
+	  intel_bios.o \
 	  power.o \
 	  psb_drv.o \
-	  psb_intel_bios.o \
 	  psb_intel_opregion.o \
 	  psb_intel_display.o \
 	  psb_intel_i2c.o \
diff --git a/drivers/staging/gma500/intel_bios.c b/drivers/staging/gma500/intel_bios.c
new file mode 100644
index 0000000..5b3e88c
--- /dev/null
+++ b/drivers/staging/gma500/intel_bios.c
@@ -0,0 +1,299 @@
+/*
+ * Copyright (c) 2006 Intel Corporation
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
+ * Authors:
+ *    Eric Anholt <eric@anholt.net>
+ *
+ */
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_bios.h"
+
+
+static void *find_section(struct bdb_header *bdb, int section_id)
+{
+	u8 *base = (u8 *)bdb;
+	int index = 0;
+	u16 total, current_size;
+	u8 current_id;
+
+	/* skip to first section */
+	index += bdb->header_size;
+	total = bdb->bdb_size;
+
+	/* walk the sections looking for section_id */
+	while (index < total) {
+		current_id = *(base + index);
+		index++;
+		current_size = *((u16 *)(base + index));
+		index += 2;
+		if (current_id == section_id)
+			return base + index;
+		index += current_size;
+	}
+
+	return NULL;
+}
+
+static void fill_detail_timing_data(struct drm_display_mode *panel_fixed_mode,
+			struct lvds_dvo_timing *dvo_timing)
+{
+	panel_fixed_mode->hdisplay = (dvo_timing->hactive_hi << 8) |
+		dvo_timing->hactive_lo;
+	panel_fixed_mode->hsync_start = panel_fixed_mode->hdisplay +
+		((dvo_timing->hsync_off_hi << 8) | dvo_timing->hsync_off_lo);
+	panel_fixed_mode->hsync_end = panel_fixed_mode->hsync_start +
+		dvo_timing->hsync_pulse_width;
+	panel_fixed_mode->htotal = panel_fixed_mode->hdisplay +
+		((dvo_timing->hblank_hi << 8) | dvo_timing->hblank_lo);
+
+	panel_fixed_mode->vdisplay = (dvo_timing->vactive_hi << 8) |
+		dvo_timing->vactive_lo;
+	panel_fixed_mode->vsync_start = panel_fixed_mode->vdisplay +
+		dvo_timing->vsync_off;
+	panel_fixed_mode->vsync_end = panel_fixed_mode->vsync_start +
+		dvo_timing->vsync_pulse_width;
+	panel_fixed_mode->vtotal = panel_fixed_mode->vdisplay +
+		((dvo_timing->vblank_hi << 8) | dvo_timing->vblank_lo);
+	panel_fixed_mode->clock = dvo_timing->clock * 10;
+	panel_fixed_mode->type = DRM_MODE_TYPE_PREFERRED;
+
+	/* Some VBTs have bogus h/vtotal values */
+	if (panel_fixed_mode->hsync_end > panel_fixed_mode->htotal)
+		panel_fixed_mode->htotal = panel_fixed_mode->hsync_end + 1;
+	if (panel_fixed_mode->vsync_end > panel_fixed_mode->vtotal)
+		panel_fixed_mode->vtotal = panel_fixed_mode->vsync_end + 1;
+
+	drm_mode_set_name(panel_fixed_mode);
+}
+
+static void parse_backlight_data(struct drm_psb_private *dev_priv,
+				struct bdb_header *bdb)
+{
+	struct bdb_lvds_backlight *vbt_lvds_bl = NULL;
+	struct bdb_lvds_backlight *lvds_bl;
+	u8 p_type = 0;
+	void *bl_start = NULL;
+	struct bdb_lvds_options *lvds_opts
+				= find_section(bdb, BDB_LVDS_OPTIONS);
+
+	dev_priv->lvds_bl = NULL;
+
+	if (lvds_opts)
+		p_type = lvds_opts->panel_type;
+	else
+		return;
+
+	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
+	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
+
+	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
+	if (!lvds_bl) {
+		dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
+		return;
+	}
+	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
+	dev_priv->lvds_bl = lvds_bl;
+}
+
+/* Try to find integrated panel data */
+static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
+			    struct bdb_header *bdb)
+{
+	struct bdb_lvds_options *lvds_options;
+	struct bdb_lvds_lfp_data *lvds_lfp_data;
+	struct bdb_lvds_lfp_data_entry *entry;
+	struct lvds_dvo_timing *dvo_timing;
+	struct drm_display_mode *panel_fixed_mode;
+
+	/* Defaults if we can't find VBT info */
+	dev_priv->lvds_dither = 0;
+	dev_priv->lvds_vbt = 0;
+
+	lvds_options = find_section(bdb, BDB_LVDS_OPTIONS);
+	if (!lvds_options)
+		return;
+
+	dev_priv->lvds_dither = lvds_options->pixel_dither;
+	if (lvds_options->panel_type == 0xff)
+		return;
+
+	lvds_lfp_data = find_section(bdb, BDB_LVDS_LFP_DATA);
+	if (!lvds_lfp_data)
+		return;
+
+	dev_priv->lvds_vbt = 1;
+
+	entry = &lvds_lfp_data->data[lvds_options->panel_type];
+	dvo_timing = &entry->dvo_timing;
+
+	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode),
+				      GFP_KERNEL);
+
+	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
+
+	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {
+		dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
+		drm_mode_debug_printmodeline(panel_fixed_mode);
+	} else {
+		dev_dbg(dev_priv->dev->dev, "ignoring invalid LVDS VBT\n");
+		dev_priv->lvds_vbt = 0;
+		kfree(panel_fixed_mode);
+	}
+	return;
+}
+
+/* Try to find sdvo panel data */
+static void parse_sdvo_panel_data(struct drm_psb_private *dev_priv,
+		      struct bdb_header *bdb)
+{
+	struct bdb_sdvo_lvds_options *sdvo_lvds_options;
+	struct lvds_dvo_timing *dvo_timing;
+	struct drm_display_mode *panel_fixed_mode;
+
+	dev_priv->sdvo_lvds_vbt_mode = NULL;
+
+	sdvo_lvds_options = find_section(bdb, BDB_SDVO_LVDS_OPTIONS);
+	if (!sdvo_lvds_options)
+		return;
+
+	dvo_timing = find_section(bdb, BDB_SDVO_PANEL_DTDS);
+	if (!dvo_timing)
+		return;
+
+	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode), GFP_KERNEL);
+
+	if (!panel_fixed_mode)
+		return;
+
+	fill_detail_timing_data(panel_fixed_mode,
+			dvo_timing + sdvo_lvds_options->panel_type);
+
+	dev_priv->sdvo_lvds_vbt_mode = panel_fixed_mode;
+
+	return;
+}
+
+static void parse_general_features(struct drm_psb_private *dev_priv,
+		       struct bdb_header *bdb)
+{
+	struct bdb_general_features *general;
+
+	/* Set sensible defaults in case we can't find the general block */
+	dev_priv->int_tv_support = 1;
+	dev_priv->int_crt_support = 1;
+
+	general = find_section(bdb, BDB_GENERAL_FEATURES);
+	if (general) {
+		dev_priv->int_tv_support = general->int_tv_support;
+		dev_priv->int_crt_support = general->int_crt_support;
+		dev_priv->lvds_use_ssc = general->enable_ssc;
+
+		if (dev_priv->lvds_use_ssc) {
+			dev_priv->lvds_ssc_freq
+				= general->ssc_freq ? 100 : 96;
+		}
+	}
+}
+
+/**
+ * psb_intel_init_bios - initialize VBIOS settings & find VBT
+ * @dev: DRM device
+ *
+ * Loads the Video BIOS and checks that the VBT exists.  Sets scratch registers
+ * to appropriate values.
+ *
+ * VBT existence is a sanity check that is relied on by other i830_bios.c code.
+ * Note that it would be better to use a BIOS call to get the VBT, as BIOSes may
+ * feed an updated VBT back through that, compared to what we'll fetch using
+ * this method of groping around in the BIOS data.
+ *
+ * Returns 0 on success, nonzero on failure.
+ */
+bool psb_intel_init_bios(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct pci_dev *pdev = dev->pdev;
+	struct vbt_header *vbt = NULL;
+	struct bdb_header *bdb;
+	u8 __iomem *bios;
+	size_t size;
+	int i;
+
+	bios = pci_map_rom(pdev, &size);
+	if (!bios)
+		return -1;
+
+	/* Scour memory looking for the VBT signature */
+	for (i = 0; i + 4 < size; i++) {
+		if (!memcmp(bios + i, "$VBT", 4)) {
+			vbt = (struct vbt_header *)(bios + i);
+			break;
+		}
+	}
+
+	if (!vbt) {
+		dev_err(dev->dev, "VBT signature missing\n");
+		pci_unmap_rom(pdev, bios);
+		return -1;
+	}
+
+	bdb = (struct bdb_header *)(bios + i + vbt->bdb_offset);
+
+	/* Grab useful general definitions */
+	parse_general_features(dev_priv, bdb);
+	parse_lfp_panel_data(dev_priv, bdb);
+	parse_sdvo_panel_data(dev_priv, bdb);
+	parse_backlight_data(dev_priv, bdb);
+
+	pci_unmap_rom(pdev, bios);
+
+	return 0;
+}
+
+/**
+ * Destroy and free VBT data
+ */
+void psb_intel_destroy_bios(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_display_mode *sdvo_lvds_vbt_mode =
+				dev_priv->sdvo_lvds_vbt_mode;
+	struct drm_display_mode *lfp_lvds_vbt_mode =
+				dev_priv->lfp_lvds_vbt_mode;
+	struct bdb_lvds_backlight *lvds_bl =
+				dev_priv->lvds_bl;
+
+	/*free sdvo panel mode*/
+	if (sdvo_lvds_vbt_mode) {
+		dev_priv->sdvo_lvds_vbt_mode = NULL;
+		kfree(sdvo_lvds_vbt_mode);
+	}
+
+	if (lfp_lvds_vbt_mode) {
+		dev_priv->lfp_lvds_vbt_mode = NULL;
+		kfree(lfp_lvds_vbt_mode);
+	}
+
+	if (lvds_bl) {
+		dev_priv->lvds_bl = NULL;
+		kfree(lvds_bl);
+	}
+}
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
deleted file mode 100644
index 5b3e88c..0000000
--- a/drivers/staging/gma500/psb_intel_bios.c
+++ /dev/null
@@ -1,299 +0,0 @@
-/*
- * Copyright (c) 2006 Intel Corporation
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
- * Authors:
- *    Eric Anholt <eric@anholt.net>
- *
- */
-#include <drm/drmP.h>
-#include <drm/drm.h>
-#include "psb_drm.h"
-#include "psb_drv.h"
-#include "psb_intel_drv.h"
-#include "psb_intel_reg.h"
-#include "psb_intel_bios.h"
-
-
-static void *find_section(struct bdb_header *bdb, int section_id)
-{
-	u8 *base = (u8 *)bdb;
-	int index = 0;
-	u16 total, current_size;
-	u8 current_id;
-
-	/* skip to first section */
-	index += bdb->header_size;
-	total = bdb->bdb_size;
-
-	/* walk the sections looking for section_id */
-	while (index < total) {
-		current_id = *(base + index);
-		index++;
-		current_size = *((u16 *)(base + index));
-		index += 2;
-		if (current_id == section_id)
-			return base + index;
-		index += current_size;
-	}
-
-	return NULL;
-}
-
-static void fill_detail_timing_data(struct drm_display_mode *panel_fixed_mode,
-			struct lvds_dvo_timing *dvo_timing)
-{
-	panel_fixed_mode->hdisplay = (dvo_timing->hactive_hi << 8) |
-		dvo_timing->hactive_lo;
-	panel_fixed_mode->hsync_start = panel_fixed_mode->hdisplay +
-		((dvo_timing->hsync_off_hi << 8) | dvo_timing->hsync_off_lo);
-	panel_fixed_mode->hsync_end = panel_fixed_mode->hsync_start +
-		dvo_timing->hsync_pulse_width;
-	panel_fixed_mode->htotal = panel_fixed_mode->hdisplay +
-		((dvo_timing->hblank_hi << 8) | dvo_timing->hblank_lo);
-
-	panel_fixed_mode->vdisplay = (dvo_timing->vactive_hi << 8) |
-		dvo_timing->vactive_lo;
-	panel_fixed_mode->vsync_start = panel_fixed_mode->vdisplay +
-		dvo_timing->vsync_off;
-	panel_fixed_mode->vsync_end = panel_fixed_mode->vsync_start +
-		dvo_timing->vsync_pulse_width;
-	panel_fixed_mode->vtotal = panel_fixed_mode->vdisplay +
-		((dvo_timing->vblank_hi << 8) | dvo_timing->vblank_lo);
-	panel_fixed_mode->clock = dvo_timing->clock * 10;
-	panel_fixed_mode->type = DRM_MODE_TYPE_PREFERRED;
-
-	/* Some VBTs have bogus h/vtotal values */
-	if (panel_fixed_mode->hsync_end > panel_fixed_mode->htotal)
-		panel_fixed_mode->htotal = panel_fixed_mode->hsync_end + 1;
-	if (panel_fixed_mode->vsync_end > panel_fixed_mode->vtotal)
-		panel_fixed_mode->vtotal = panel_fixed_mode->vsync_end + 1;
-
-	drm_mode_set_name(panel_fixed_mode);
-}
-
-static void parse_backlight_data(struct drm_psb_private *dev_priv,
-				struct bdb_header *bdb)
-{
-	struct bdb_lvds_backlight *vbt_lvds_bl = NULL;
-	struct bdb_lvds_backlight *lvds_bl;
-	u8 p_type = 0;
-	void *bl_start = NULL;
-	struct bdb_lvds_options *lvds_opts
-				= find_section(bdb, BDB_LVDS_OPTIONS);
-
-	dev_priv->lvds_bl = NULL;
-
-	if (lvds_opts)
-		p_type = lvds_opts->panel_type;
-	else
-		return;
-
-	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
-	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
-
-	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
-	if (!lvds_bl) {
-		dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
-		return;
-	}
-	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
-	dev_priv->lvds_bl = lvds_bl;
-}
-
-/* Try to find integrated panel data */
-static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
-			    struct bdb_header *bdb)
-{
-	struct bdb_lvds_options *lvds_options;
-	struct bdb_lvds_lfp_data *lvds_lfp_data;
-	struct bdb_lvds_lfp_data_entry *entry;
-	struct lvds_dvo_timing *dvo_timing;
-	struct drm_display_mode *panel_fixed_mode;
-
-	/* Defaults if we can't find VBT info */
-	dev_priv->lvds_dither = 0;
-	dev_priv->lvds_vbt = 0;
-
-	lvds_options = find_section(bdb, BDB_LVDS_OPTIONS);
-	if (!lvds_options)
-		return;
-
-	dev_priv->lvds_dither = lvds_options->pixel_dither;
-	if (lvds_options->panel_type == 0xff)
-		return;
-
-	lvds_lfp_data = find_section(bdb, BDB_LVDS_LFP_DATA);
-	if (!lvds_lfp_data)
-		return;
-
-	dev_priv->lvds_vbt = 1;
-
-	entry = &lvds_lfp_data->data[lvds_options->panel_type];
-	dvo_timing = &entry->dvo_timing;
-
-	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode),
-				      GFP_KERNEL);
-
-	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
-
-	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {
-		dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
-		drm_mode_debug_printmodeline(panel_fixed_mode);
-	} else {
-		dev_dbg(dev_priv->dev->dev, "ignoring invalid LVDS VBT\n");
-		dev_priv->lvds_vbt = 0;
-		kfree(panel_fixed_mode);
-	}
-	return;
-}
-
-/* Try to find sdvo panel data */
-static void parse_sdvo_panel_data(struct drm_psb_private *dev_priv,
-		      struct bdb_header *bdb)
-{
-	struct bdb_sdvo_lvds_options *sdvo_lvds_options;
-	struct lvds_dvo_timing *dvo_timing;
-	struct drm_display_mode *panel_fixed_mode;
-
-	dev_priv->sdvo_lvds_vbt_mode = NULL;
-
-	sdvo_lvds_options = find_section(bdb, BDB_SDVO_LVDS_OPTIONS);
-	if (!sdvo_lvds_options)
-		return;
-
-	dvo_timing = find_section(bdb, BDB_SDVO_PANEL_DTDS);
-	if (!dvo_timing)
-		return;
-
-	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode), GFP_KERNEL);
-
-	if (!panel_fixed_mode)
-		return;
-
-	fill_detail_timing_data(panel_fixed_mode,
-			dvo_timing + sdvo_lvds_options->panel_type);
-
-	dev_priv->sdvo_lvds_vbt_mode = panel_fixed_mode;
-
-	return;
-}
-
-static void parse_general_features(struct drm_psb_private *dev_priv,
-		       struct bdb_header *bdb)
-{
-	struct bdb_general_features *general;
-
-	/* Set sensible defaults in case we can't find the general block */
-	dev_priv->int_tv_support = 1;
-	dev_priv->int_crt_support = 1;
-
-	general = find_section(bdb, BDB_GENERAL_FEATURES);
-	if (general) {
-		dev_priv->int_tv_support = general->int_tv_support;
-		dev_priv->int_crt_support = general->int_crt_support;
-		dev_priv->lvds_use_ssc = general->enable_ssc;
-
-		if (dev_priv->lvds_use_ssc) {
-			dev_priv->lvds_ssc_freq
-				= general->ssc_freq ? 100 : 96;
-		}
-	}
-}
-
-/**
- * psb_intel_init_bios - initialize VBIOS settings & find VBT
- * @dev: DRM device
- *
- * Loads the Video BIOS and checks that the VBT exists.  Sets scratch registers
- * to appropriate values.
- *
- * VBT existence is a sanity check that is relied on by other i830_bios.c code.
- * Note that it would be better to use a BIOS call to get the VBT, as BIOSes may
- * feed an updated VBT back through that, compared to what we'll fetch using
- * this method of groping around in the BIOS data.
- *
- * Returns 0 on success, nonzero on failure.
- */
-bool psb_intel_init_bios(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct pci_dev *pdev = dev->pdev;
-	struct vbt_header *vbt = NULL;
-	struct bdb_header *bdb;
-	u8 __iomem *bios;
-	size_t size;
-	int i;
-
-	bios = pci_map_rom(pdev, &size);
-	if (!bios)
-		return -1;
-
-	/* Scour memory looking for the VBT signature */
-	for (i = 0; i + 4 < size; i++) {
-		if (!memcmp(bios + i, "$VBT", 4)) {
-			vbt = (struct vbt_header *)(bios + i);
-			break;
-		}
-	}
-
-	if (!vbt) {
-		dev_err(dev->dev, "VBT signature missing\n");
-		pci_unmap_rom(pdev, bios);
-		return -1;
-	}
-
-	bdb = (struct bdb_header *)(bios + i + vbt->bdb_offset);
-
-	/* Grab useful general definitions */
-	parse_general_features(dev_priv, bdb);
-	parse_lfp_panel_data(dev_priv, bdb);
-	parse_sdvo_panel_data(dev_priv, bdb);
-	parse_backlight_data(dev_priv, bdb);
-
-	pci_unmap_rom(pdev, bios);
-
-	return 0;
-}
-
-/**
- * Destroy and free VBT data
- */
-void psb_intel_destroy_bios(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_display_mode *sdvo_lvds_vbt_mode =
-				dev_priv->sdvo_lvds_vbt_mode;
-	struct drm_display_mode *lfp_lvds_vbt_mode =
-				dev_priv->lfp_lvds_vbt_mode;
-	struct bdb_lvds_backlight *lvds_bl =
-				dev_priv->lvds_bl;
-
-	/*free sdvo panel mode*/
-	if (sdvo_lvds_vbt_mode) {
-		dev_priv->sdvo_lvds_vbt_mode = NULL;
-		kfree(sdvo_lvds_vbt_mode);
-	}
-
-	if (lfp_lvds_vbt_mode) {
-		dev_priv->lfp_lvds_vbt_mode = NULL;
-		kfree(lfp_lvds_vbt_mode);
-	}
-
-	if (lvds_bl) {
-		dev_priv->lvds_bl = NULL;
-		kfree(lvds_bl);
-	}
-}

