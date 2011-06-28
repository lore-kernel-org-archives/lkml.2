Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1F1WGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:06:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40975 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1F1WGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:06:25 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/29] gma500: nuke the PSB debug stuff
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:05:59 +0100
Message-ID: <20110628220557.898.80115.stgit@bob.linux.org.uk>
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

Lose all the PSB debug gunge. We can replace it with dev_dbg() like normal
drivers if and when we need debug on stuff.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_crtc.c          |   23 ++----
 drivers/staging/gma500/mrst_lvds.c          |   12 +--
 drivers/staging/gma500/psb_bl.c             |    8 --
 drivers/staging/gma500/psb_drv.c            |   33 +++------
 drivers/staging/gma500/psb_drv.h            |   96 +++-----------------------
 drivers/staging/gma500/psb_fb.c             |   34 +--------
 drivers/staging/gma500/psb_gem.c            |    6 +-
 drivers/staging/gma500/psb_gtt.c            |    6 +-
 drivers/staging/gma500/psb_intel_bios.c     |   17 +----
 drivers/staging/gma500/psb_intel_display.c  |   99 +++------------------------
 drivers/staging/gma500/psb_intel_lvds.c     |   53 ++------------
 drivers/staging/gma500/psb_intel_opregion.c |    7 --
 drivers/staging/gma500/psb_intel_sdvo.c     |   34 ++++-----
 drivers/staging/gma500/psb_irq.c            |   33 ++-------
 14 files changed, 87 insertions(+), 374 deletions(-)


diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index fd97c80..fb9f2a2 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -103,7 +103,7 @@ static const struct mrst_limit_t *mrst_limit(struct drm_crtc *crtc)
 		}
 	} else {
 		limit = NULL;
-		PSB_DEBUG_ENTRY("mrst_limit Wrong display type.\n");
+		dev_err(dev->dev, "mrst_limit Wrong display type.\n");
 	}
 
 	return limit;
@@ -117,7 +117,7 @@ static void mrst_clock(int refclk, struct mrst_clock_t *clock)
 
 void mrstPrintPll(char *prefix, struct mrst_clock_t *clock)
 {
-	PSB_DEBUG_ENTRY("%s: dotclock = %d,  m = %d, p1 = %d.\n",
+	pr_debug("%s: dotclock = %d,  m = %d, p1 = %d.\n",
 	     prefix, clock->dot, clock->m, clock->p1);
 }
 
@@ -149,8 +149,7 @@ mrstFindBestPLL(struct drm_crtc *crtc, int target, int refclk,
 			}
 		}
 	}
-	DRM_DEBUG("mrstFindBestPLL err = %d.\n", err);
-
+	dev_dbg(crtc->dev->dev, "mrstFindBestPLL err = %d.\n", err);
 	return err != target;
 }
 
@@ -172,8 +171,6 @@ static void mrst_crtc_dpms(struct drm_crtc *crtc, int mode)
 	u32 temp;
 	bool enabled;
 
-	PSB_DEBUG_ENTRY("mode = %d, pipe = %d\n", mode, pipe);
-
 	if (!gma_power_begin(dev, true))
 		return;
 
@@ -320,8 +317,6 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 	uint64_t scalingType = DRM_MODE_SCALE_FULLSCREEN;
 	struct drm_encoder *encoder;
 
-	PSB_DEBUG_ENTRY("pipe = 0x%x\n", pipe);
-
 	if (!gma_power_begin(dev, true))
 		return 0;
 
@@ -446,10 +441,9 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 	ok = mrstFindBestPLL(crtc, adjusted_mode->clock, refclk, &clock);
 
 	if (!ok) {
-		PSB_DEBUG_ENTRY(
-			"mrstFindBestPLL fail in mrst_crtc_mode_set.\n");
+		dev_dbg(dev->dev, "mrstFindBestPLL fail in mrst_crtc_mode_set.\n");
 	} else {
-		PSB_DEBUG_ENTRY("mrst_crtc_mode_set pixel clock = %d,"
+		dev_dbg(dev->dev, "mrst_crtc_mode_set pixel clock = %d,"
 			 "m = %x, p1 = %x.\n", clock.dot, clock.m,
 			 clock.p1);
 	}
@@ -540,11 +534,9 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	u32 dspcntr;
 	int ret = 0;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	/* no fb bound */
 	if (!crtc->fb) {
-		DRM_DEBUG("No FB bound\n");
+		dev_dbg(dev->dev, "No FB bound\n");
 		return 0;
 	}
 
@@ -574,13 +566,12 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
 		break;
 	default:
-		DRM_ERROR("Unknown color depth\n");
+		dev_err(dev->dev, "Unknown color depth\n");
 		ret = -EINVAL;
 		goto pipe_set_base_exit;
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
 
-	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 	if (0 /* FIXMEAC - check what PSB needs */) {
 		REG_WRITE(dspbase, offset);
 		REG_READ(dspbase);
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index e07cead..07e74f9 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -47,7 +47,6 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 {
 	u32 pp_status;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	PSB_DEBUG_ENTRY("\n");
 
 	if (!gma_power_begin(dev, true))
 		return;
@@ -77,8 +76,6 @@ static void mrst_lvds_dpms(struct drm_encoder *encoder, int mode)
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (mode == DRM_MODE_DPMS_ON)
 		mrst_lvds_set_power(dev, output, true);
 	else
@@ -97,8 +94,6 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 	u32 lvds_port;
 	uint64_t v = DRM_MODE_SCALE_FULLSCREEN;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (!gma_power_begin(dev, true))
 		return;
 
@@ -252,8 +247,6 @@ void mrst_lvds_init(struct drm_device *dev,
 	struct i2c_adapter *i2c_adap;
 	struct drm_display_mode *scan;	/* *modes, *bios_mode; */
 
-	PSB_DEBUG_ENTRY("\n");
-
 	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
 	if (!psb_intel_output)
 		return;
@@ -348,8 +341,7 @@ void mrst_lvds_init(struct drm_device *dev,
 
 	/* If we still don't have a mode after all that, give up. */
 	if (!mode_dev->panel_fixed_mode) {
-		DRM_DEBUG
-		    ("Found no modes on the lvds, ignoring the LVDS\n");
+		dev_err(dev->dev, "Found no modes on the lvds, ignoring the LVDS\n");
 		goto failed_find;
 	}
 
@@ -358,7 +350,7 @@ out:
 	return;
 
 failed_find:
-	DRM_DEBUG("No LVDS modes found, disabling.\n");
+	dev_dbg(dev->dev, "No LVDS modes found, disabling.\n");
 	if (psb_intel_output->ddc_bus)
 		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
 
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 2f9674d..4a00047 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -56,8 +56,6 @@ int psb_set_brightness(struct backlight_device *bd)
 	struct drm_device *dev = bl_get_data(psb_backlight_device);
 	int level = bd->props.brightness;
 
-	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
-
 	/* Percentage 1-100% being valid */
 	if (level < 1)
 		level = 1;
@@ -75,8 +73,6 @@ int mrst_set_brightness(struct backlight_device *bd)
 	u32 blc_pwm_ctl;
 	u32 max_pwm_blc;
 
-	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
-
 	/* Percentage 1-100% being valid */
 	if (level < 1)
 		level = 1;
@@ -111,8 +107,6 @@ int mrst_set_brightness(struct backlight_device *bd)
 
 int psb_get_brightness(struct backlight_device *bd)
 {
-	DRM_DEBUG_DRIVER("brightness = 0x%x\n", psb_brightness);
-
 	/* return locally cached var instead of HW read (due to DPST etc.) */
 	/* FIXME: ideally return actual value in case firmware fiddled with
 	   it */
@@ -144,7 +138,7 @@ static int device_backlight_init(struct drm_device *dev)
 	} else {
 		/* get bl_max_freq and pol from dev_priv*/
 		if (!dev_priv->lvds_bl) {
-			DRM_ERROR("Has no valid LVDS backlight info\n");
+			dev_err(dev->dev, "Has no valid LVDS backlight info\n");
 			return 1;
 		}
 		bl_max_freq = dev_priv->lvds_bl->freq;
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index ab1da30..6ea06dd 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -35,17 +35,14 @@
 #include <linux/pm_runtime.h>
 #include <acpi/video.h>
 
-int drm_psb_debug;
 static int drm_psb_trap_pagefaults;
 
 int drm_psb_no_fb;
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 
-MODULE_PARM_DESC(debug, "Enable debug output");
 MODULE_PARM_DESC(no_fb, "Disable FBdev");
 MODULE_PARM_DESC(trap_pagefaults, "Error and reset on MMU pagefaults");
-module_param_named(debug, drm_psb_debug, int, 0600);
 module_param_named(no_fb, drm_psb_no_fb, int, 0600);
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 
@@ -215,7 +212,8 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 		dev_priv->core_freq = 166;
 		break;
 	default:
-		DRM_ERROR("Invalid SKU values, SKU value = 0x%08x\n", fuse_value_tmp);
+		dev_warn(dev->dev, "Invalid SKU values, SKU value = 0x%08x\n",
+								fuse_value_tmp);
 		dev_priv->core_freq = 0;
 	}
 	DRM_INFO("LNC core clk is %dMHz.\n", dev_priv->core_freq);
@@ -231,7 +229,8 @@ void mid_get_pci_revID (struct drm_psb_private *dev_priv)
 	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
 	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
 	pci_dev_put(pci_gfx_root);
-	PSB_DEBUG_ENTRY("platform_rev_id is %x\n",	dev_priv->platform_rev_id);
+	dev_info(dev_priv->dev->dev, "platform_rev_id is %x\n",
+							dev_priv->platform_rev_id);
 }
 
 void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
@@ -413,7 +412,7 @@ static int psb_do_init(struct drm_device *dev)
 	int ret = -ENOMEM;
 
 	if (pg->mmu_gatt_start & 0x0FFFFFFF) {
-		DRM_ERROR("Gatt must be 256M aligned. This is a bug.\n");
+		dev_err(dev->dev, "Gatt must be 256M aligned. This is a bug.\n");
 		ret = -EINVAL;
 		goto out_err;
 	}
@@ -447,9 +446,6 @@ static int psb_do_init(struct drm_device *dev)
 
 	spin_lock_init(&dev_priv->irqmask_lock);
 
-	/* FIXME: can we kill ta_mem_size ? */
-	dev_priv->sizes.ta_mem_size = 0;
-
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
 	PSB_RSGX32(PSB_CR_BIF_BANK1);
@@ -553,7 +549,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev->dev_private = (void *) dev_priv;
 	dev_priv->chipset = chipset;
 
-	PSB_DEBUG_INIT("Mapping MMIO\n");
 	resource_start = pci_resource_start(dev->pdev, PSB_MMIO_RESOURCE);
 
 	dev_priv->vdc_reg =
@@ -679,7 +674,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	pm_runtime_set_active(&dev->pdev->dev);
 #endif
 	/*Intel drm driver load is done, continue doing pvr load*/
-	DRM_DEBUG("Pvr driver load\n");
 	return 0;
 out_err:
 	psb_driver_unload(dev);
@@ -721,7 +715,7 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 		obj = drm_mode_object_find(dev, obj_id,
 				DRM_MODE_OBJECT_CRTC);
 		if (!obj) {
-			DRM_DEBUG("Invalid CRTC object.\n");
+			dev_dbg(dev->dev, "Invalid CRTC object.\n");
 			return -EINVAL;
 		}
 
@@ -741,7 +735,7 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 		obj = drm_mode_object_find(dev, obj_id,
 				DRM_MODE_OBJECT_CONNECTOR);
 		if (!obj) {
-			DRM_DEBUG("Invalid connector id.\n");
+			dev_dbg(dev->dev, "Invalid connector id.\n");
 			return -EINVAL;
 		}
 
@@ -753,8 +747,6 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 
 		return 0;
 	}
-
-	DRM_DEBUG("Bad flags 0x%x\n", flags);
 	return -EINVAL;
 }
 
@@ -832,7 +824,7 @@ static int psb_gamma_ioctl(struct drm_device *dev, void *data,
 	obj_id = lut_arg->output_id;
 	obj = drm_mode_object_find(dev, obj_id, DRM_MODE_OBJECT_CONNECTOR);
 	if (!obj) {
-		DRM_DEBUG("Invalid Connector object.\n");
+		dev_dbg(dev->dev, "Invalid Connector object.\n");
 		return -EINVAL;
 	}
 
@@ -873,7 +865,7 @@ static int psb_mode_operation_ioctl(struct drm_device *dev, void *data,
 	case PSB_MODE_OPERATION_SET_DC_BASE:
 		obj = drm_mode_object_find(dev, obj_id, DRM_MODE_OBJECT_FB);
 		if (!obj) {
-			DRM_ERROR("Invalid FB id %d\n", obj_id);
+			dev_dbg(dev->dev, "Invalid FB id %d\n", obj_id);
 			return -EINVAL;
 		}
 
@@ -945,7 +937,7 @@ mode_op_out:
 		return ret;
 
 	default:
-		DRM_DEBUG("Unsupported psb mode operation");
+		dev_dbg(dev->dev, "Unsupported psb mode operation\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1336,9 +1328,6 @@ static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
 	struct drm_device *dev = file_priv->minor->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	static unsigned int runtime_allowed;
-	unsigned int nr = DRM_IOCTL_NR(cmd);
-
-	DRM_DEBUG("cmd = %x, nr = %x\n", cmd, nr);
 
 	if (runtime_allowed == 1 && dev_priv->is_lvds_on) {
 		runtime_allowed++;
@@ -1439,7 +1428,7 @@ static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	/* MLD Added this from Inaky's patch */
 	if (pci_enable_msi(pdev))
-		DRM_ERROR("Enable MSI failed!\n");
+                dev_warn(&pdev->dev, "Enable MSI failed!\n");
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index c0468ee..45752aa 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -659,54 +659,12 @@ extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 #define PSB_D_MSVDX   (1 << 9)
 #define PSB_D_TOPAZ   (1 << 10)
 
-#ifndef DRM_DEBUG_CODE
-/* To enable debug printout, set drm_psb_debug in psb_drv.c
- * to any combination of above print flags.
- */
-/* #define DRM_DEBUG_CODE 2 */
-#endif
-
-extern int drm_psb_debug;
 extern int drm_psb_no_fb;
 extern int drm_idle_check_interval;
 
-#define PSB_DEBUG_GENERAL(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_GENERAL, _fmt, ##_arg)
-#define PSB_DEBUG_INIT(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_INIT, _fmt, ##_arg)
-#define PSB_DEBUG_IRQ(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_IRQ, _fmt, ##_arg)
-#define PSB_DEBUG_ENTRY(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_ENTRY, _fmt, ##_arg)
-#define PSB_DEBUG_HV(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_HV, _fmt, ##_arg)
-#define PSB_DEBUG_DBI_BF(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_DBI_BF, _fmt, ##_arg)
-#define PSB_DEBUG_PM(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_PM, _fmt, ##_arg)
-#define PSB_DEBUG_RENDER(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_RENDER, _fmt, ##_arg)
-#define PSB_DEBUG_REG(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_REG, _fmt, ##_arg)
-#define PSB_DEBUG_MSVDX(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_MSVDX, _fmt, ##_arg)
-#define PSB_DEBUG_TOPAZ(_fmt, _arg...) \
-	PSB_DEBUG(PSB_D_TOPAZ, _fmt, ##_arg)
-
-#if DRM_DEBUG_CODE
-#define PSB_DEBUG(_flag, _fmt, _arg...)					\
-	do {								\
-		if (unlikely((_flag) & drm_psb_debug))			\
-			printk(KERN_DEBUG				\
-			       "[psb:0x%02x:%s] " _fmt , _flag,		\
-			       __func__ , ##_arg);			\
-	} while (0)
-#else
-#define PSB_DEBUG(_fmt, _arg...)     do { } while (0)
-#endif
 
 /*
- *Utilities
+ *	Utilities
  */
 
 static inline u32 MRST_MSG_READ32(uint port, uint offset)
@@ -749,19 +707,15 @@ static inline void MDFLD_MSG_WRITE32(uint port, uint offset, u32 value)
 static inline uint32_t REGISTER_READ(struct drm_device *dev, uint32_t reg)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	int reg_val = ioread32(dev_priv->vdc_reg + (reg));
-	PSB_DEBUG_REG("reg = 0x%x. reg_val = 0x%x. \n", reg, reg_val);
-	return reg_val;
+	return ioread32(dev_priv->vdc_reg + reg);
 }
 
 #define REG_READ(reg)	       REGISTER_READ(dev, (reg))
+
 static inline void REGISTER_WRITE(struct drm_device *dev, uint32_t reg,
 				      uint32_t val)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	if ((reg < 0x70084 || reg >0x70088) && (reg < 0xa000 || reg >0xa3ff))
-		PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
-
 	iowrite32((val), dev_priv->vdc_reg + (reg));
 }
 
@@ -771,9 +725,6 @@ static inline void REGISTER_WRITE16(struct drm_device *dev,
 					uint32_t reg, uint32_t val)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
-
 	iowrite16((val), dev_priv->vdc_reg + (reg));
 }
 
@@ -783,20 +734,13 @@ static inline void REGISTER_WRITE8(struct drm_device *dev,
 				       uint32_t reg, uint32_t val)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
-
 	iowrite8((val), dev_priv->vdc_reg + (reg));
 }
 
-#define REG_WRITE8(reg, val)	 REGISTER_WRITE8(dev, (reg), (val))
+#define REG_WRITE8(reg, val)		REGISTER_WRITE8(dev, (reg), (val))
 
-#define PSB_ALIGN_TO(_val, _align) \
-  (((_val) + ((_align) - 1)) & ~((_align) - 1))
-#define PSB_WVDC32(_val, _offs) \
-  iowrite32(_val, dev_priv->vdc_reg + (_offs))
-#define PSB_RVDC32(_offs) \
-  ioread32(dev_priv->vdc_reg + (_offs))
+#define PSB_WVDC32(_val, _offs)		iowrite32(_val, dev_priv->vdc_reg + (_offs))
+#define PSB_RVDC32(_offs)		ioread32(dev_priv->vdc_reg + (_offs))
 
 /* #define TRAP_SGX_PM_FAULT 1 */
 #ifdef TRAP_SGX_PM_FAULT
@@ -810,33 +754,13 @@ static inline void REGISTER_WRITE8(struct drm_device *dev,
     ioread32(dev_priv->sgx_reg + (_offs));			\
 })
 #else
-#define PSB_RSGX32(_offs)					\
-  ioread32(dev_priv->sgx_reg + (_offs))
+#define PSB_RSGX32(_offs)		ioread32(dev_priv->sgx_reg + (_offs))
 #endif
-#define PSB_WSGX32(_val, _offs) \
-  iowrite32(_val, dev_priv->sgx_reg + (_offs))
+#define PSB_WSGX32(_val, _offs)		iowrite32(_val, dev_priv->sgx_reg + (_offs))
 
 #define MSVDX_REG_DUMP 0
-#if MSVDX_REG_DUMP
-
-#define PSB_WMSVDX32(_val, _offs) \
-  printk("MSVDX: write %08x to reg 0x%08x\n", (unsigned int)(_val), (unsigned int)(_offs));\
-  iowrite32(_val, dev_priv->msvdx_reg + (_offs))
-#define PSB_RMSVDX32(_offs) \
-  ioread32(dev_priv->msvdx_reg + (_offs))
-
-#else
-
-#define PSB_WMSVDX32(_val, _offs) \
-  iowrite32(_val, dev_priv->msvdx_reg + (_offs))
-#define PSB_RMSVDX32(_offs) \
-  ioread32(dev_priv->msvdx_reg + (_offs))
-
-#endif
 
-#define PSB_ALPL(_val, _base)			\
-  (((_val) >> (_base ## _ALIGNSHIFT)) << (_base ## _SHIFT))
-#define PSB_ALPLM(_val, _base)			\
-  ((((_val) >> (_base ## _ALIGNSHIFT)) << (_base ## _SHIFT)) & (_base ## _MASK))
+#define PSB_WMSVDX32(_val, _offs)	iowrite32(_val, dev_priv->msvdx_reg + (_offs))
+#define PSB_RMSVDX32(_offs)		ioread32(dev_priv->msvdx_reg + (_offs))
 
 #endif
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 0a77abf..988f4db 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -100,7 +100,6 @@ static int psbfb_kms_off(struct drm_device *dev, int suspend)
 {
 	struct drm_framebuffer *fb = 0;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
-	DRM_DEBUG("psbfb_kms_off_ioctl\n");
 
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
@@ -134,8 +133,6 @@ static int psbfb_kms_on(struct drm_device *dev, int resume)
 	struct drm_framebuffer *fb = 0;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
-	DRM_DEBUG("psbfb_kms_on_ioctl\n");
-
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
 		struct fb_info *info = psbfb->fbdev;
@@ -217,12 +214,10 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 static void psbfb_vm_open(struct vm_area_struct *vma)
 {
-	DRM_DEBUG("vm_open\n");
 }
 
 static void psbfb_vm_close(struct vm_area_struct *vma)
 {
-	DRM_DEBUG("vm_close\n");
 }
 
 static struct vm_operations_struct psbfb_vm_ops = {
@@ -237,7 +232,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	char *fb_screen_base = NULL;
 	struct drm_device *dev = psbfb->base.dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -249,10 +243,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 
 	fb_screen_base = (char *)info->screen_base;
 
-	DRM_DEBUG("vm_pgoff 0x%lx, screen base %p vram_addr %p\n",
-				vma->vm_pgoff, fb_screen_base,
-                                dev_priv->vram_addr);
-
         /* If this is a GEM object then info->screen_base is the virtual
            kernel remapping of the object. FIXME: Review if this is
            suitable for our mmap work */
@@ -523,14 +513,10 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	info->pixmap.flags = FB_PIXMAP_SYSTEM;
 	info->pixmap.scan_align = 1;
 
-	DRM_DEBUG("fb depth is %d\n", fb->depth);
-	DRM_DEBUG("   pitch is %d\n", fb->pitch);
-
-	printk(KERN_INFO"allocated %dx%d fb\n",
-				psbfb->base.width, psbfb->base.height);
+	dev_info(dev->dev, "allocated %dx%d fb\n",
+					psbfb->base.width, psbfb->base.height);
 
 	mutex_unlock(&dev->struct_mutex);
-
 	return 0;
 out_unref:
         if (backing->stolen)
@@ -575,13 +561,11 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 static void psbfb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
 							u16 blue, int regno)
 {
-	DRM_DEBUG("%s\n", __func__);
 }
 
 static void psbfb_gamma_get(struct drm_crtc *crtc, u16 *red,
 					u16 *green, u16 *blue, int regno)
 {
-	DRM_DEBUG("%s\n", __func__);
 }
 
 static int psbfb_probe(struct drm_fb_helper *helper,
@@ -591,8 +575,6 @@ static int psbfb_probe(struct drm_fb_helper *helper,
 	int new_fb = 0;
 	int ret;
 
-	DRM_DEBUG("%s\n", __func__);
-
 	if (!helper->fb) {
 		ret = psbfb_create(psb_fbdev, sizes);
 		if (ret)
@@ -650,7 +632,7 @@ int psb_fbdev_init(struct drm_device *dev)
 
 	fbdev = kzalloc(sizeof(struct psb_fbdev), GFP_KERNEL);
 	if (!fbdev) {
-		DRM_ERROR("no memory\n");
+		dev_err(dev->dev, "no memory\n");
 		return -ENOMEM;
 	}
 
@@ -781,8 +763,6 @@ static void psb_setup_outputs(struct drm_device *dev)
 	    (struct drm_psb_private *) dev->dev_private;
 	struct drm_connector *connector;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	drm_mode_create_scaling_mode_property(dev);
 
 	psb_create_backlight_property(dev);
@@ -791,7 +771,7 @@ static void psb_setup_outputs(struct drm_device *dev)
 		if (dev_priv->iLVDS_enable)
 			mrst_lvds_init(dev, &dev_priv->mode_dev);
 		else
-			DRM_ERROR("DSI is not supported\n");
+			dev_err(dev->dev, "DSI is not supported\n");
 	} else {
 		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
 		psb_intel_sdvo_init(dev, SDVOB);
@@ -811,7 +791,6 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_SDVO);
 			break;
 		case INTEL_OUTPUT_LVDS:
-			PSB_DEBUG_ENTRY("LVDS.\n");
 			if (IS_MRST(dev))
 				crtc_mask = (1 << 0);
 			else
@@ -819,17 +798,14 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_LVDS);
 			break;
 		case INTEL_OUTPUT_MIPI:
-			PSB_DEBUG_ENTRY("MIPI.\n");
 			crtc_mask = (1 << 0);
 			clone_mask = (1 << INTEL_OUTPUT_MIPI);
 			break;
 		case INTEL_OUTPUT_MIPI2:
-			PSB_DEBUG_ENTRY("MIPI2.\n");
 			crtc_mask = (1 << 2);
 			clone_mask = (1 << INTEL_OUTPUT_MIPI2);
 			break;
 		case INTEL_OUTPUT_HDMI:
-			PSB_DEBUG_ENTRY("HDMI.\n");
 			crtc_mask = (1 << 1);
 			clone_mask = (1 << INTEL_OUTPUT_HDMI);
 			break;
@@ -849,8 +825,6 @@ void psb_modeset_init(struct drm_device *dev)
 	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	int i;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	drm_mode_config_init(dev);
 
 	dev->mode_config.min_width = 0;
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 125ea6b..7f6f479 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -87,7 +87,7 @@ static int psb_gem_create_mmap_offset(struct drm_gem_object *obj)
 	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
 					obj->size / PAGE_SIZE, 0, 0);
 	if (!list->file_offset_node) {
-		DRM_ERROR("failed to allocate offset for bo %d\n", obj->name);
+		dev_err(dev->dev, "failed to allocate offset for bo %d\n", obj->name);
 		ret = -ENOSPC;
 		goto free_it;
 	}
@@ -100,7 +100,7 @@ static int psb_gem_create_mmap_offset(struct drm_gem_object *obj)
 	list->hash.key = list->file_offset_node->start;
 	ret = drm_ht_insert_item(&mm->offset_hash, &list->hash);
 	if (ret) {
-		DRM_ERROR("failed to add to map hash\n");
+		dev_err(dev->dev, "failed to add to map hash\n");
 		goto free_mm;
 	}
 	return 0;
@@ -283,7 +283,7 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (r->mmapping == 0) {
 		ret = psb_gtt_pin(r);
 		if (ret < 0) {
-		        DRM_ERROR("gma500: pin failed: %d\n", ret);
+		        dev_err(dev->dev, "gma500: pin failed: %d\n", ret);
 		        goto fail;
                 }
 		r->mmapping = 1;
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 8fcb833..54a9308 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -456,7 +456,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	if (resume && (gtt_pages != pg->gtt_pages) &&
 	    (stolen_size != pg->stolen_size)) {
-		DRM_ERROR("GTT resume error.\n");
+		dev_err(dev->dev, "GTT resume error.\n");
 		ret = -EINVAL;
 		goto out_err;
 	}
@@ -470,14 +470,14 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	 */
 	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
 	if (!dev_priv->gtt_map) {
-		DRM_ERROR("Failure to map gtt.\n");
+		dev_err(dev->dev, "Failure to map gtt.\n");
 		ret = -ENOMEM;
 		goto out_err;
 	}
 
 	dev_priv->vram_addr = ioremap_wc(dev_priv->stolen_base, stolen_size);
 	if (!dev_priv->vram_addr) {
-		DRM_ERROR("Failure to map stolen base.\n");
+		dev_err(dev->dev, "Failure to map stolen base.\n");
 		ret = -ENOMEM;
 		goto out_err;
 	}
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
index 417965d..5b3e88c 100644
--- a/drivers/staging/gma500/psb_intel_bios.c
+++ b/drivers/staging/gma500/psb_intel_bios.c
@@ -96,25 +96,20 @@ static void parse_backlight_data(struct drm_psb_private *dev_priv,
 
 	dev_priv->lvds_bl = NULL;
 
-	if (lvds_opts) {
-		DRM_DEBUG("lvds_options found at %p\n", lvds_opts);
+	if (lvds_opts)
 		p_type = lvds_opts->panel_type;
-	} else {
-		DRM_DEBUG("no lvds_options\n");
+	else
 		return;
-	}
 
 	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
 	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
 
 	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
 	if (!lvds_bl) {
-		DRM_DEBUG("No memory\n");
+		dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
 		return;
 	}
-
 	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
-
 	dev_priv->lvds_bl = lvds_bl;
 }
 
@@ -156,14 +151,12 @@ static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
 
 	if (panel_fixed_mode->htotal > 0 && panel_fixed_mode->vtotal > 0) {
 		dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
-		DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
 		drm_mode_debug_printmodeline(panel_fixed_mode);
 	} else {
-		DRM_DEBUG("Ignoring bogus LVDS VBT mode.\n");
+		dev_dbg(dev_priv->dev->dev, "ignoring invalid LVDS VBT\n");
 		dev_priv->lvds_vbt = 0;
 		kfree(panel_fixed_mode);
 	}
-
 	return;
 }
 
@@ -257,7 +250,7 @@ bool psb_intel_init_bios(struct drm_device *dev)
 	}
 
 	if (!vbt) {
-		DRM_ERROR("VBT signature missing\n");
+		dev_err(dev->dev, "VBT signature missing\n");
 		pci_unmap_rom(pdev, bios);
 		return -1;
 	}
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index c7c55b1..be7e1f9 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -350,14 +350,12 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	u32 dspcntr;
 	int ret = 0;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (!gma_power_begin(dev, true))
 		return 0;
 
 	/* no fb bound */
 	if (!crtc->fb) {
-		DRM_DEBUG("No FB bound\n");
+		dev_dbg(dev->dev, "No FB bound\n");
 		goto psb_intel_pipe_cleaner;
 	}
 
@@ -390,7 +388,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
 		break;
 	default:
-		DRM_ERROR("Unknown color depth\n");
+                dev_err(dev->dev, "Unknown color depth\n");
 		ret = -EINVAL;
 		psb_gtt_unpin(psbfb->gtt);
 		goto psb_intel_pipe_set_base_exit;
@@ -398,7 +396,6 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	REG_WRITE(dspcntr_reg, dspcntr);
 
 
-	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 	if (0 /* FIXMEAC - check what PSB needs */) {
 		REG_WRITE(dspbase, offset);
 		REG_READ(dspbase);
@@ -650,7 +647,7 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	ok = psb_intel_find_best_PLL(crtc, adjusted_mode->clock, refclk,
 				 &clock);
 	if (!ok) {
-		DRM_ERROR("Couldn't find PLL settings for mode!\n");
+		dev_err(dev->dev, "Couldn't find PLL settings for mode!\n");
 		return 0;
 	}
 
@@ -714,7 +711,6 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	if (psb_intel_panel_fitter_pipe(dev) == pipe)
 		REG_WRITE(PFIT_CONTROL, 0);
 
-	DRM_DEBUG("Mode for pipe %c:\n", pipe == 0 ? 'A' : 'B');
 	drm_mode_debug_printmodeline(mode);
 
 	if (dpll & DPLL_VCO_ENABLE) {
@@ -825,7 +821,7 @@ void psb_intel_crtc_load_lut(struct drm_crtc *crtc)
 		palreg = PALETTE_C;
 		break;
 	default:
-		DRM_ERROR("Illegal Pipe Number.\n");
+		dev_err(dev->dev, "Illegal Pipe Number.\n");
 		return;
 	}
 
@@ -868,10 +864,8 @@ static void psb_intel_crtc_save(struct drm_crtc *crtc)
 	uint32_t paletteReg;
 	int i;
 
-	DRM_DEBUG("\n");
-
 	if (!crtc_state) {
-		DRM_DEBUG("No CRTC state found\n");
+		dev_err(dev->dev, "No CRTC state found\n");
 		return;
 	}
 
@@ -895,25 +889,6 @@ static void psb_intel_crtc_save(struct drm_crtc *crtc)
 
 	crtc_state->saveDSPBASE = REG_READ(pipeA ? DSPABASE : DSPBBASE);
 
-	DRM_DEBUG("(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
-			crtc_state->saveDSPCNTR,
-			crtc_state->savePIPECONF,
-			crtc_state->savePIPESRC,
-			crtc_state->saveFP0,
-			crtc_state->saveFP1,
-			crtc_state->saveDPLL,
-			crtc_state->saveHTOTAL,
-			crtc_state->saveHBLANK,
-			crtc_state->saveHSYNC,
-			crtc_state->saveVTOTAL,
-			crtc_state->saveVBLANK,
-			crtc_state->saveVSYNC,
-			crtc_state->saveDSPSTRIDE,
-			crtc_state->saveDSPSIZE,
-			crtc_state->saveDSPPOS,
-			crtc_state->saveDSPBASE
-		);
-
 	paletteReg = pipeA ? PALETTE_A : PALETTE_B;
 	for (i = 0; i < 256; ++i)
 		crtc_state->savePalette[i] = REG_READ(paletteReg + (i << 2));
@@ -934,60 +909,15 @@ static void psb_intel_crtc_restore(struct drm_crtc *crtc)
 	uint32_t paletteReg;
 	int i;
 
-	DRM_DEBUG("\n");
-
 	if (!crtc_state) {
-		DRM_DEBUG("No crtc state\n");
+		dev_err(dev->dev, "No crtc state\n");
 		return;
 	}
 
-	DRM_DEBUG(
-		"current:(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
-		REG_READ(pipeA ? DSPACNTR : DSPBCNTR),
-		REG_READ(pipeA ? PIPEACONF : PIPEBCONF),
-		REG_READ(pipeA ? PIPEASRC : PIPEBSRC),
-		REG_READ(pipeA ? FPA0 : FPB0),
-		REG_READ(pipeA ? FPA1 : FPB1),
-		REG_READ(pipeA ? DPLL_A : DPLL_B),
-		REG_READ(pipeA ? HTOTAL_A : HTOTAL_B),
-		REG_READ(pipeA ? HBLANK_A : HBLANK_B),
-		REG_READ(pipeA ? HSYNC_A : HSYNC_B),
-		REG_READ(pipeA ? VTOTAL_A : VTOTAL_B),
-		REG_READ(pipeA ? VBLANK_A : VBLANK_B),
-		REG_READ(pipeA ? VSYNC_A : VSYNC_B),
-		REG_READ(pipeA ? DSPASTRIDE : DSPBSTRIDE),
-		REG_READ(pipeA ? DSPASIZE : DSPBSIZE),
-		REG_READ(pipeA ? DSPAPOS : DSPBPOS),
-		REG_READ(pipeA ? DSPABASE : DSPBBASE)
-		);
-
-	DRM_DEBUG(
-		"saved: (%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
-		crtc_state->saveDSPCNTR,
-		crtc_state->savePIPECONF,
-		crtc_state->savePIPESRC,
-		crtc_state->saveFP0,
-		crtc_state->saveFP1,
-		crtc_state->saveDPLL,
-		crtc_state->saveHTOTAL,
-		crtc_state->saveHBLANK,
-		crtc_state->saveHSYNC,
-		crtc_state->saveVTOTAL,
-		crtc_state->saveVBLANK,
-		crtc_state->saveVSYNC,
-		crtc_state->saveDSPSTRIDE,
-		crtc_state->saveDSPSIZE,
-		crtc_state->saveDSPPOS,
-		crtc_state->saveDSPBASE
-		);
-
-
 	if (crtc_state->saveDPLL & DPLL_VCO_ENABLE) {
 		REG_WRITE(pipeA ? DPLL_A : DPLL_B,
 			crtc_state->saveDPLL & ~DPLL_VCO_ENABLE);
 		REG_READ(pipeA ? DPLL_A : DPLL_B);
-		DRM_DEBUG("write dpll: %x\n",
-				REG_READ(pipeA ? DPLL_A : DPLL_B));
 		udelay(150);
 	}
 
@@ -1044,11 +974,8 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	struct drm_gem_object *obj;
 	int ret;
 
-	DRM_DEBUG("\n");
-
 	/* if we want to turn of the cursor ignore width and height */
 	if (!handle) {
-		DRM_DEBUG("cursor off\n");
 		/* turn off the cursor */
 		temp = CURSOR_MODE_DISABLE;
 
@@ -1072,7 +999,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 	/* Currently we only support 64x64 cursors */
 	if (width != 64 || height != 64) {
-		DRM_ERROR("we currently only support 64x64 cursors\n");
+		dev_dbg(dev->dev, "we currently only support 64x64 cursors\n");
 		return -EINVAL;
 	}
 
@@ -1081,7 +1008,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		return -ENOENT;
 
 	if (obj->size < width * height * 4) {
-		DRM_ERROR("buffer is to small\n");
+		dev_dbg(dev->dev, "buffer is to small\n");
 		return -ENOMEM;
 	}
 
@@ -1090,7 +1017,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	/* Pin the memory into the GTT */
 	ret = psb_gtt_pin(gt);
 	if (ret) {
-		DRM_ERROR("Can not pin down handle 0x%x\n", handle);
+		dev_err(dev->dev, "Can not pin down handle 0x%x\n", handle);
 		return ret;
 	}
 
@@ -1359,8 +1286,6 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	int i;
 	uint16_t *r_base, *g_base, *b_base;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	/* We allocate a extra array of drm_connector pointers
 	 * for fbdev after the crtc */
 	psb_intel_crtc =
@@ -1373,7 +1298,7 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->crtc_state =
 		kzalloc(sizeof(struct psb_intel_crtc_state), GFP_KERNEL);
 	if (!psb_intel_crtc->crtc_state) {
-		DRM_INFO("Crtc state error: No memory\n");
+		dev_err(dev->dev, "Crtc state error: No memory\n");
 		kfree(psb_intel_crtc);
 		return;
 	}
@@ -1430,7 +1355,7 @@ int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,
 	struct psb_intel_crtc *crtc;
 
 	if (!dev_priv) {
-		DRM_ERROR("called with no initialization\n");
+		dev_err(dev->dev, "called with no initialization\n");
 		return -EINVAL;
 	}
 
@@ -1438,7 +1363,7 @@ int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,
 			DRM_MODE_OBJECT_CRTC);
 
 	if (!drmmode_obj) {
-		DRM_ERROR("no such CRTC id\n");
+		dev_err(dev->dev, "no such CRTC id\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index b0a225b..1cbc9bc 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -126,13 +126,13 @@ static int psb_lvds_i2c_set_brightness(struct drm_device *dev,
 	out_buf[1] = (u8)blc_i2c_brightness;
 
 	if (i2c_transfer(&lvds_i2c_bus->adapter, msgs, 1) == 1) {
-		DRM_DEBUG("I2C set brightness.(command, value) (%d, %d)\n",
+		dev_dbg(dev->dev, "I2C set brightness.(command, value) (%d, %d)\n",
 			dev_priv->lvds_bl->brightnesscmd,
 			blc_i2c_brightness);
 		return 0;
 	}
 
-	DRM_ERROR("I2C transfer error\n");
+	dev_err(dev->dev, "I2C transfer error\n");
 	return -1;
 }
 
@@ -172,10 +172,10 @@ void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
 	struct drm_psb_private *dev_priv =
 			(struct drm_psb_private *)dev->dev_private;
 
-	DRM_DEBUG("backlight level is %d\n", level);
+	dev_dbg(dev->dev, "backlight level is %d\n", level);
 
 	if (!dev_priv->lvds_bl) {
-		DRM_ERROR("NO LVDS Backlight Info\n");
+		dev_err(dev->dev, "NO LVDS Backlight Info\n");
 		return;
 	}
 
@@ -289,7 +289,7 @@ static void psb_intel_lvds_save(struct drm_connector *connector)
 		dev_priv->backlight_duty_cycle =
 		psb_intel_lvds_get_max_backlight(dev);
 
-	DRM_DEBUG("(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
+	dev_dbg(dev->dev, "(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
 			lvds_priv->savePP_ON,
 			lvds_priv->savePP_OFF,
 			lvds_priv->saveLVDS,
@@ -310,7 +310,7 @@ static void psb_intel_lvds_restore(struct drm_connector *connector)
 	struct psb_intel_lvds_priv *lvds_priv =
 		(struct psb_intel_lvds_priv *)psb_intel_output->dev_priv;
 
-	DRM_DEBUG("(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
+	dev_dbg(dev->dev, "(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
 			lvds_priv->savePP_ON,
 			lvds_priv->savePP_OFF,
 			lvds_priv->saveLVDS,
@@ -351,8 +351,6 @@ int psb_intel_lvds_mode_valid(struct drm_connector *connector,
 	struct drm_display_mode *fixed_mode =
 	    psb_intel_output->mode_dev->panel_fixed_mode;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
 		fixed_mode = psb_intel_output->mode_dev->panel_fixed_mode2;
 
@@ -387,9 +385,6 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	struct psb_intel_output *psb_intel_output =
 					enc_to_psb_intel_output(encoder);
 
-	PSB_DEBUG_ENTRY("type = 0x%x, pipe = %d.\n",
-			psb_intel_output->type, psb_intel_crtc->pipe);
-
 	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
 		panel_fixed_mode = mode_dev->panel_fixed_mode2;
 
@@ -448,8 +443,6 @@ void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
 	struct psb_intel_mode_device *mode_dev = output->mode_dev;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (!gma_power_begin(dev, true))
 		return;
 
@@ -468,8 +461,6 @@ void psb_intel_lvds_commit(struct drm_encoder *encoder)
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
 	struct psb_intel_mode_device *mode_dev = output->mode_dev;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (mode_dev->backlight_duty_cycle == 0)
 		mode_dev->backlight_duty_cycle =
 		    psb_intel_lvds_get_max_backlight(dev);
@@ -585,15 +576,11 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 {
 	struct drm_encoder *pEncoder = connector->encoder;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (!strcmp(property->name, "scaling mode") && pEncoder) {
 		struct psb_intel_crtc *pPsbCrtc =
 					to_psb_intel_crtc(pEncoder->crtc);
 		uint64_t curValue;
 
-		PSB_DEBUG_ENTRY("scaling mode\n");
-
 		if (!pPsbCrtc)
 			goto set_prop_error;
 
@@ -631,8 +618,6 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 				goto set_prop_error;
 		}
 	} else if (!strcmp(property->name, "backlight") && pEncoder) {
-		PSB_DEBUG_ENTRY("backlight\n");
-
 		if (drm_connector_property_set_value(connector,
 							property,
 							value))
@@ -647,7 +632,6 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 	} else if (!strcmp(property->name, "DPMS") && pEncoder) {
 		struct drm_encoder_helper_funcs *pEncHFuncs
 						= pEncoder->helper_private;
-		PSB_DEBUG_ENTRY("DPMS\n");
 		pEncHFuncs->dpms(pEncoder, value);
 	}
 
@@ -722,7 +706,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	lvds_priv = kzalloc(sizeof(struct psb_intel_lvds_priv), GFP_KERNEL);
 	if (!lvds_priv) {
 		kfree(psb_intel_output);
-		DRM_DEBUG("LVDS private allocation error\n");
+		dev_err(dev->dev, "LVDS private allocation error\n");
 		return;
 	}
 
@@ -838,8 +822,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 
 	/* If we still don't have a mode after all that, give up. */
 	if (!mode_dev->panel_fixed_mode) {
-		DRM_DEBUG
-			("Found no modes on the lvds, ignoring the LVDS\n");
+		dev_err(dev->dev, "Found no modes on the lvds, ignoring the LVDS\n");
 		goto failed_find;
 	}
 
@@ -849,26 +832,6 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	 */
 out:
 	drm_sysfs_connector_add(connector);
-
-	PSB_DEBUG_ENTRY("hdisplay = %d\n",
-		 mode_dev->panel_fixed_mode->hdisplay);
-	PSB_DEBUG_ENTRY(" vdisplay = %d\n",
-		 mode_dev->panel_fixed_mode->vdisplay);
-	PSB_DEBUG_ENTRY(" hsync_start = %d\n",
-		 mode_dev->panel_fixed_mode->hsync_start);
-	PSB_DEBUG_ENTRY(" hsync_end = %d\n",
-		 mode_dev->panel_fixed_mode->hsync_end);
-	PSB_DEBUG_ENTRY(" htotal = %d\n",
-		 mode_dev->panel_fixed_mode->htotal);
-	PSB_DEBUG_ENTRY(" vsync_start = %d\n",
-		 mode_dev->panel_fixed_mode->vsync_start);
-	PSB_DEBUG_ENTRY(" vsync_end = %d\n",
-		 mode_dev->panel_fixed_mode->vsync_end);
-	PSB_DEBUG_ENTRY(" vtotal = %d\n",
-		 mode_dev->panel_fixed_mode->vtotal);
-	PSB_DEBUG_ENTRY(" clock = %d\n",
-		 mode_dev->panel_fixed_mode->clock);
-
 	return;
 
 failed_find:
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
index 65e3e9b..51cf1d6 100644
--- a/drivers/staging/gma500/psb_intel_opregion.c
+++ b/drivers/staging/gma500/psb_intel_opregion.c
@@ -58,11 +58,8 @@ int psb_intel_opregion_init(struct drm_device *dev)
 	dev_priv->lid_state = NULL;
 
 	pci_read_config_dword(dev->pdev, 0xfc, &opregion_phy);
-	if (opregion_phy == 0) {
-		DRM_DEBUG("Opregion not supported, won't support lid-switch\n");
+	if (opregion_phy == 0)
 		return -ENOTSUPP;
-	}
-	DRM_DEBUG("OpRegion detected at 0x%8x\n", opregion_phy);
 
 	base = ioremap(opregion_phy, 8*1024);
 	if (!base)
@@ -70,8 +67,6 @@ int psb_intel_opregion_init(struct drm_device *dev)
 
 	lid_state = base + 0x01ac;
 
-	DRM_DEBUG("Lid switch state 0x%08x\n", *lid_state);
-
 	dev_priv->lid_state = lid_state;
 	dev_priv->lid_last_state = *lid_state;
 	return 0;
diff --git a/drivers/staging/gma500/psb_intel_sdvo.c b/drivers/staging/gma500/psb_intel_sdvo.c
index df1c006..e313ce2 100644
--- a/drivers/staging/gma500/psb_intel_sdvo.c
+++ b/drivers/staging/gma500/psb_intel_sdvo.c
@@ -107,14 +107,10 @@ static bool psb_intel_sdvo_read_byte(
 
 	ret = i2c_transfer(&sdvo_priv->i2c_bus->adapter, msgs, 2);
 	if (ret == 2) {
-		/* DRM_DEBUG("got back from addr %02X = %02x\n",
-		 * out_buf[0], buf[0]);
-		 */
 		*ch = buf[0];
 		return true;
 	}
 
-	DRM_DEBUG("i2c transfer returned %d\n", ret);
 	return false;
 }
 
@@ -205,24 +201,24 @@ static void psb_intel_sdvo_write_cmd(struct psb_intel_output *psb_intel_output,
 	int i;
 
 	if (0) {
-		DRM_DEBUG("%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
+		printk(KERN_DEBUG "%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
 		for (i = 0; i < args_len; i++)
-			printk(KERN_INFO"%02X ", ((u8 *) args)[i]);
+			printk(KERN_CONT "%02X ", ((u8 *) args)[i]);
 		for (; i < 8; i++)
-			printk("   ");
+			printk(KERN_CONT "   ");
 		for (i = 0;
 		     i <
 		     sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]);
 		     i++) {
 			if (cmd == sdvo_cmd_names[i].cmd) {
-				printk("(%s)", sdvo_cmd_names[i].name);
+				printk(KERN_CONT "(%s)", sdvo_cmd_names[i].name);
 				break;
 			}
 		}
 		if (i ==
 		    sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]))
-			printk("(%02X)", cmd);
-		printk("\n");
+			printk(KERN_CONT "(%02X)", cmd);
+		printk(KERN_CONT "\n");
 	}
 
 	for (i = 0; i < args_len; i++) {
@@ -267,17 +263,17 @@ static u8 psb_intel_sdvo_read_response(
 					 &status);
 
 		if (0) {
-			DRM_DEBUG("%s: R: ", SDVO_NAME(sdvo_priv));
+			pr_debug("%s: R: ", SDVO_NAME(sdvo_priv));
 			for (i = 0; i < response_len; i++)
-				printk(KERN_INFO"%02X ", ((u8 *) response)[i]);
+				printk(KERN_CONT "%02X ", ((u8 *) response)[i]);
 			for (; i < 8; i++)
 				printk("   ");
 			if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
-				printk(KERN_INFO"(%s)",
+				printk(KERN_CONT "(%s)",
 					 cmd_status_names[status]);
 			else
-				printk(KERN_INFO"(??? %d)", status);
-			printk("\n");
+				printk(KERN_CONT "(??? %d)", status);
+			printk(KERN_CONT "\n");
 		}
 
 		if (status != SDVO_CMD_STATUS_PENDING)
@@ -997,7 +993,6 @@ int psb_intel_sdvo_supports_hotplug(struct drm_connector *connector)
 	u8 response[2];
 	u8 status;
 	struct psb_intel_output *psb_intel_output;
-	DRM_DEBUG("\n");
 
 	if (!connector)
 		return 0;
@@ -1198,7 +1193,7 @@ void psb_intel_sdvo_init(struct drm_device *dev, int output_device)
 	/* Read the regs to test if we can talk to the device */
 	for (i = 0; i < 0x40; i++) {
 		if (!psb_intel_sdvo_read_byte(psb_intel_output, i, &ch[i])) {
-			DRM_DEBUG("No SDVO device found on SDVO%c\n",
+			dev_dbg(dev->dev, "No SDVO device found on SDVO%c\n",
 				  output_device == SDVOB ? 'B' : 'C');
 			goto err_i2c;
 		}
@@ -1242,8 +1237,7 @@ void psb_intel_sdvo_init(struct drm_device *dev, int output_device)
 		unsigned char bytes[2];
 
 		memcpy(bytes, &sdvo_priv->caps.output_flags, 2);
-		DRM_DEBUG
-		    ("%s: No active RGB or TMDS outputs (0x%02x%02x)\n",
+		dev_dbg(dev->dev, "%s: No active RGB or TMDS outputs (0x%02x%02x)\n",
 		     SDVO_NAME(sdvo_priv), bytes[0], bytes[1]);
 		goto err_i2c;
 	}
@@ -1267,7 +1261,7 @@ void psb_intel_sdvo_init(struct drm_device *dev, int output_device)
 					       pixel_clock_max);
 
 
-	DRM_DEBUG("%s device VID/DID: %02X:%02X.%02X, "
+	dev_dbg(dev->dev, "%s device VID/DID: %02X:%02X.%02X, "
 		  "clock range %dMHz - %dMHz, "
 		  "input 1: %c, input 2: %c, "
 		  "output 1: %c, output 2: %c\n",
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 9ea37e5..1cbfeb6 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -187,7 +187,8 @@ static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
 	}
 
 	if (i == WAIT_STATUS_CLEAR_LOOP_COUNT)
-		DRM_ERROR("%s, can't clear the status bits in pipe_stat_reg, its value = 0x%x.\n",
+		dev_err(dev->dev,
+	"%s, can't clear the status bits in pipe_stat_reg, its value = 0x%x.\n",
 			__func__, PSB_RVDC32(pipe_stat_reg));
 
 	if (pipe_stat_val & PIPE_VBLANK_STATUS)
@@ -219,21 +220,11 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
-	if (vdc_stat & _MDFLD_DISP_ALL_IRQ_FLAG) {
-		PSB_DEBUG_IRQ("Got DISP interrupt\n");
+	if (vdc_stat & _MDFLD_DISP_ALL_IRQ_FLAG)
 		dsp_int = 1;
-	}
 
-	if (vdc_stat & _PSB_IRQ_SGX_FLAG) {
-		PSB_DEBUG_IRQ("Got SGX interrupt\n");
+	if (vdc_stat & _PSB_IRQ_SGX_FLAG)
 		sgx_int = 1;
-	}
-	if (vdc_stat & _PSB_IRQ_MSVDX_FLAG)
-		PSB_DEBUG_IRQ("Got MSVDX interrupt\n");
-
-	if (vdc_stat & _LNC_IRQ_TOPAZ_FLAG)
-		PSB_DEBUG_IRQ("Got TOPAZ interrupt\n");
-
 
 	vdc_stat &= dev_priv->vdc_irq_mask;
 	spin_unlock(&dev_priv->irqmask_lock);
@@ -293,8 +284,6 @@ int psb_irq_postinstall(struct drm_device *dev)
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	/* This register is safe even if display island is off */
@@ -326,8 +315,6 @@ void psb_irq_uninstall(struct drm_device *dev)
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
@@ -395,8 +382,6 @@ int psb_irq_enable_dpst(struct drm_device *dev)
 		(struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	/* enable DPST */
@@ -435,8 +420,6 @@ int psb_irq_disable_dpst(struct drm_device *dev)
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	mid_disable_pipe_event(dev_priv, 0);
@@ -472,8 +455,6 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
 	uint32_t reg_val = 0;
 	uint32_t pipeconf_reg = mid_pipeconf(pipe);
 
-	PSB_DEBUG_ENTRY("\n");
-
 	if (gma_power_begin(dev, false)) {
 		reg_val = REG_READ(pipeconf_reg);
 		gma_power_end(dev);
@@ -500,8 +481,6 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	mid_disable_pipe_event(dev_priv, pipe);
@@ -535,7 +514,7 @@ u32 psb_get_vblank_counter(struct drm_device *dev, int pipe)
 		pipeconf_reg = PIPECCONF;
 		break;
 	default:
-		DRM_ERROR("%s, invalded pipe.\n", __func__);
+		dev_err(dev->dev, "%s, invalid pipe.\n", __func__);
 		return 0;
 	}
 
@@ -545,7 +524,7 @@ u32 psb_get_vblank_counter(struct drm_device *dev, int pipe)
 	reg_val = REG_READ(pipeconf_reg);
 
 	if (!(reg_val & PIPEACONF_ENABLE)) {
-		DRM_ERROR("trying to get vblank count for disabled pipe %d\n",
+		dev_err(dev->dev, "trying to get vblank count for disabled pipe %d\n",
 								pipe);
 		goto psb_get_vblank_counter_exit;
 	}

