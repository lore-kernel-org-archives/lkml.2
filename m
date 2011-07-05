Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1GEOvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:51:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50573 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1GEOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:51:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 35/49] gma500: begin the config based split
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:41:56 +0100
Message-ID: <20110705144154.23872.23538.stgit@localhost.localdomain>
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

We don't want to carry all the extra gunk around on every device so use the
splitting work so far to tidy this up. Poulsbo is still mandatory as it is
used in bits by the other drivers and not neatly modularised.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Kconfig   |   27 ++++++++++++++++++++++++---
 drivers/staging/gma500/Makefile  |   13 ++++++++-----
 drivers/staging/gma500/psb_drv.c |    9 ++++++++-
 drivers/staging/gma500/psb_irq.c |    5 ++++-
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gma500/Kconfig b/drivers/staging/gma500/Kconfig
index ce8beda..bfe2166 100644
--- a/drivers/staging/gma500/Kconfig
+++ b/drivers/staging/gma500/Kconfig
@@ -1,5 +1,5 @@
 config DRM_PSB
-	tristate "Intel GMA500 KMS Framebuffer"
+	tristate "Intel GMA5/600 KMS Framebuffer"
 	depends on DRM && PCI && X86
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
@@ -7,6 +7,27 @@ config DRM_PSB
         select DRM_KMS_HELPER
         select DRM_TTM
 	help
-	  Say yes for an experimental KMS framebuffer driver for the
-	  Intel GMA500 ('Poulsbo') graphics support.
+	  Say yes for an experimental 2D KMS framebuffer driver for the
+	  Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
+	  devices.
 
+config DRM_PSB_MRST
+	bool "Intel GMA600 support (Experimental)"
+	depends on DRM_PSB
+	help
+	  Say yes to include support for GMA600 (Intel Moorestown/Oaktrail)
+	  platforms with LVDS ports. HDMI and MIPI are not currently
+	  supported.
+
+config DRM_PSB_MFLD
+	bool "Intel Medfield support (Experimental)"
+	depends on DRM_PSB
+	help
+	  Say yes to include support for Intel Medfield platforms with MIPI
+	  interfaces.
+	
+config DRM_PSB_CDV
+	bool "Intel Cedarview support (Experimental)"
+	depends on DRM_PSB
+	help
+	  Say yes to include support for Intel Cedarview platforms
diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 0603949..aa60926 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -22,12 +22,15 @@ psb_gfx-y += gem_glue.o \
 	  psb_mmu.o \
 	  psb_irq.o \
 	  psb_device.o \
-	  cdv_device.o \
-	  mid_bios.o \
-	  mrst_device.o \
+	  mid_bios.o
+
+psb_gfx-$(CONFIG_DRM_PSB_CDV) +=  cdv_device.o
+
+psb_gfx-$(CONFIG_DRM_PSB_MRST) += mrst_device.o \
 	  mrst_crtc.o \
-	  mrst_lvds.o \
-	  mdfld_device.o \
+	  mrst_lvds.o
+
+psb_gfx-$(CONFIG_DRM_PSB_MFLD) += mdfld_device.o \
 	  mdfld_output.o \
 	  mdfld_pyr_cmd.o \
 	  mdfld_tmd_vid.o \
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 4114ffd..69ab61b 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -52,6 +52,7 @@ module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
+#if defined(CONFIG_DRM_PSB_MRST)	
 	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
@@ -60,6 +61,8 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x4105, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4106, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4107, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
+#endif
+#if defined(CONFIG_DRM_PSB_MFLD)
 	{ 0x8086, 0x0130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 	{ 0x8086, 0x0131, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 	{ 0x8086, 0x0132, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
@@ -68,6 +71,8 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x0135, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 	{ 0x8086, 0x0136, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 	{ 0x8086, 0x0137, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
+#endif
+#if defined(CONFIG_DRM_PSB_CDV)	
 	{ 0x8086, 0x0be0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
@@ -76,6 +81,7 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x0be5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
+#endif	
 	{ 0, 0, 0}
 };
 MODULE_DEVICE_TABLE(pci, pciidlist);
@@ -396,6 +402,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	dev->driver->get_vblank_counter = psb_get_vblank_counter;
 
+#if defined(CONFIG_DRM_PSB_MFLD)
 	/* FIXME: this is not the right place for this stuff ! */
 	if (IS_MFLD(dev)) {
 #ifdef CONFIG_MDFLD_DSI_DPU
@@ -406,7 +413,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 #endif /*CONFIG_MDFLD_DSI_DPU*/
 		/* INIT_WORK(&dev_priv->te_work, mdfld_te_handler_work);*/
 	}
-
+#endif
 	if (drm_psb_no_fb == 0) {
 		psb_modeset_init(dev);
 		psb_fbdev_init(dev);
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 3768cf1..8fc7070 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -455,11 +455,12 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
 	uint32_t reg_val = 0;
 	uint32_t pipeconf_reg = mid_pipeconf(pipe);
 
+#if defined(CONFIG_DRM_PSB_MFLD)
 	/* Medfield is different - we should perhaps extract out vblank
 	   and blacklight etc ops */
 	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
 		return mdfld_enable_te(dev, pipe);
-
+#endif
 	if (gma_power_begin(dev, false)) {
 		reg_val = REG_READ(pipeconf_reg);
 		gma_power_end(dev);
@@ -486,8 +487,10 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
 
+#if defined(CONFIG_DRM_PSB_MFLD)
 	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
 		mdfld_disable_te(dev, pipe);
+#endif
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	mid_disable_pipe_event(dev_priv, pipe);

