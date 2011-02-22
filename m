Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1BVUDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1BVUDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:03:38 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] staging: Use generic IGD opregion code for gma500
Date: Tue, 22 Feb 2011 15:03:14 -0500
Message-Id: <1298404994-2907-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1298404994-2907-1-git-send-email-mjg@redhat.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gma500 driver currently includes its own IGD opregion implementation.
Rework it to use the generic one instead. Note that this is missing a
certain level of functionality - the driver does nothing to enable
opregion interrupts right now, and so will simply poll for updates rather
than doing anything sensible.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/staging/gma500/Kconfig              |    1 +
 drivers/staging/gma500/Makefile             |    1 -
 drivers/staging/gma500/psb_drv.c            |   28 ++++++++--
 drivers/staging/gma500/psb_drv.h            |   21 +-------
 drivers/staging/gma500/psb_gfx.mod.c        |    4 +-
 drivers/staging/gma500/psb_intel_drv.h      |    3 +-
 drivers/staging/gma500/psb_intel_lvds.c     |    4 +-
 drivers/staging/gma500/psb_intel_opregion.c |   78 ---------------------------
 8 files changed, 31 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/staging/gma500/psb_intel_opregion.c

diff --git a/drivers/staging/gma500/Kconfig b/drivers/staging/gma500/Kconfig
index 5501eb9..f3ab6cb 100644
--- a/drivers/staging/gma500/Kconfig
+++ b/drivers/staging/gma500/Kconfig
@@ -1,6 +1,7 @@
 config DRM_PSB
 	tristate "Intel GMA500 KMS Framebuffer"
 	depends on DRM && PCI
+	depends on ACPI_IGD_OPREGION
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
         select FB_CFB_IMAGEBLIT
diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 21381eb..dba41e3 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -8,7 +8,6 @@ psb_gfx-y += psb_bl.o \
 	  psb_fb.o \
 	  psb_gtt.o \
 	  psb_intel_bios.o \
-	  psb_intel_opregion.o \
 	  psb_intel_display.o \
 	  psb_intel_i2c.o \
 	  psb_intel_lvds.o \
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 2fe09c8..f1775e1 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -29,6 +29,7 @@
 #include "psb_intel_bios.h"
 #include <drm/drm_pciids.h>
 #include "psb_powermgmt.h"
+#include <acpi/video.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
@@ -294,6 +295,18 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 		      DRM_AUTH),
 };
 
+static void psb_lid_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct igd_opregion *opregion = &dev_priv->opregion_dev.opregion;
+
+	if (!opregion->acpi)
+		return;
+
+	dev_priv->lid_state = &opregion->acpi->clid;
+	dev_priv->lid_last_state = *dev_priv->lid_state;
+}
+
 static void psb_set_uopt(struct drm_psb_uopt *uopt)
 {
 	return;
@@ -515,6 +528,8 @@ static int psb_driver_unload(struct drm_device *dev)
 
 	/* Kill vblank etc here */
 
+	acpi_video_unregister();
+
 	psb_backlight_exit(); /*writes minimum value to backlight HW reg */
 
 	if (drm_psb_no_fb == 0)
@@ -662,7 +677,10 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		goto out_err;
 
 	psb_get_core_freq(dev);
-	psb_intel_opregion_init(dev);
+	dev_priv->opregion_dev.drm_dev = dev;
+	dev_priv->opregion_dev.max_backlight = psb_intel_lvds_get_max_backlight(dev);
+	dev_priv->opregion_dev.set_backlight = psb_intel_lvds_set_brightness;
+	igd_opregion_setup(&dev_priv->opregion_dev);
 	psb_intel_init_bios(dev);
 
 	PSB_DEBUG_INIT("Init TTM fence and BO driver\n");
@@ -765,11 +783,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (ret)
 		return ret;
 
-	/**
-	 *  Init lid switch timer.
-	 *  NOTE: must do this after psb_intel_opregion_init
-	 *  and psb_backlight_init
-	 */
+	igd_opregion_init(&dev_priv->opregion_dev);
+	acpi_video_register();
+	psb_lid_init(dev);
 	if (dev_priv->lid_state)
 		psb_lid_timer_init(dev_priv);
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index b75b9d8..30d161e 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -23,6 +23,7 @@
 #include <linux/version.h>
 
 #include <drm/drmP.h>
+#include <acpi/acpi_igd_opregion.h>
 #include "drm_global.h"
 #include "psb_drm.h"
 #include "psb_reg.h"
@@ -253,19 +254,6 @@ enum {
 #define MDFLD_PLANE_MAX_WIDTH		2048
 #define MDFLD_PLANE_MAX_HEIGHT		2048
 
-struct opregion_header;
-struct opregion_acpi;
-struct opregion_swsci;
-struct opregion_asle;
-
-struct psb_intel_opregion {
-	struct opregion_header *header;
-	struct opregion_acpi *acpi;
-	struct opregion_swsci *swsci;
-	struct opregion_asle *asle;
-	int enabled;
-};
-
 /*
  *User options.
  */
@@ -692,7 +680,7 @@ struct drm_psb_private {
 	 */
 	spinlock_t lid_lock;
 	struct timer_list lid_timer;
-	struct psb_intel_opregion opregion;
+	struct opregion_dev opregion_dev;
 	u32 *lid_state;
 	u32 lid_last_state;
 
@@ -902,11 +890,6 @@ extern int lnc_video_getparam(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv);
 
 /*
- * psb_opregion.c
- */
-extern int psb_intel_opregion_init(struct drm_device *dev);
-
-/*
  *psb_fb.c
  */
 extern int psbfb_probed(struct drm_device *dev);
diff --git a/drivers/staging/gma500/psb_gfx.mod.c b/drivers/staging/gma500/psb_gfx.mod.c
index 1a663ab..14772c4 100644
--- a/drivers/staging/gma500/psb_gfx.mod.c
+++ b/drivers/staging/gma500/psb_gfx.mod.c
@@ -19,9 +19,9 @@ MODULE_INFO(staging, "Y");
 static const char __module_depends[]
 __used
 __attribute__((section(".modinfo"))) =
-"depends=ttm,drm,drm_kms_helper,i2c-core,cfbfillrect,cfbimgblt,cfbcopyarea,i2c-algo-bit";
+"depends=video";
 
 MODULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");
 MODULE_ALIAS("pci:v00008086d00008109sv*sd*bc*sc*i*");
 
-MODULE_INFO(srcversion, "933CCC78041722973001B78");
+MODULE_INFO(srcversion, "B869B52B58BF27553563032");
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index cb0a91b..67a3789 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -197,7 +197,8 @@ extern void psb_intel_dvo_init(struct drm_device *dev);
 extern void psb_intel_tv_init(struct drm_device *dev);
 extern void psb_intel_lvds_init(struct drm_device *dev,
 			    struct psb_intel_mode_device *mode_dev);
-extern void psb_intel_lvds_set_brightness(struct drm_device *dev, int level);
+extern u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev);
+extern void psb_intel_lvds_set_brightness(struct drm_device *dev, u32 level);
 extern void mrst_lvds_init(struct drm_device *dev,
 			   struct psb_intel_mode_device *mode_dev);
 extern void mrst_wait_for_INTR_PKT_SENT(struct drm_device *dev);
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index d3d210a..dec391d 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -78,7 +78,7 @@ struct psb_intel_lvds_priv {
 /**
  * Returns the maximum level of the backlight duty cycle field.
  */
-static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
+u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 retVal;
@@ -171,7 +171,7 @@ static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
 /**
  * Set LVDS backlight level either by I2C or PWM
  */
-void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
+void psb_intel_lvds_set_brightness(struct drm_device *dev, u32 level)
 {
 	/*u32 blc_pwm_ctl;*/
 	struct drm_psb_private *dev_priv =
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
deleted file mode 100644
index 65e3e9b..0000000
--- a/drivers/staging/gma500/psb_intel_opregion.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright 2010 Intel Corporation
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the next
- * paragraph) shall be included in all copies or substantial portions of the
- * Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
- */
-
-#include "psb_drv.h"
-
-struct opregion_header {
-	u8 signature[16];
-	u32 size;
-	u32 opregion_ver;
-	u8 bios_ver[32];
-	u8 vbios_ver[16];
-	u8 driver_ver[16];
-	u32 mboxes;
-	u8 reserved[164];
-} __attribute__((packed));
-
-struct opregion_apci {
-	/*FIXME: add it later*/
-} __attribute__((packed));
-
-struct opregion_swsci {
-	/*FIXME: add it later*/
-} __attribute__((packed));
-
-struct opregion_acpi {
-	/*FIXME: add it later*/
-} __attribute__((packed));
-
-int psb_intel_opregion_init(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	/*struct psb_intel_opregion * opregion = &dev_priv->opregion;*/
-	u32 opregion_phy;
-	void *base;
-	u32 *lid_state;
-
-	dev_priv->lid_state = NULL;
-
-	pci_read_config_dword(dev->pdev, 0xfc, &opregion_phy);
-	if (opregion_phy == 0) {
-		DRM_DEBUG("Opregion not supported, won't support lid-switch\n");
-		return -ENOTSUPP;
-	}
-	DRM_DEBUG("OpRegion detected at 0x%8x\n", opregion_phy);
-
-	base = ioremap(opregion_phy, 8*1024);
-	if (!base)
-		return -ENOMEM;
-
-	lid_state = base + 0x01ac;
-
-	DRM_DEBUG("Lid switch state 0x%08x\n", *lid_state);
-
-	dev_priv->lid_state = lid_state;
-	dev_priv->lid_last_state = *lid_state;
-	return 0;
-}
-- 
1.7.4.1

