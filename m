Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1DASEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:04:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37987 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756266Ab1DASEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:04:52 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 6/9] gma500: begin tidying up the power management
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:42:08 +0100
Message-ID: <20110401174145.18112.61905.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_crtc.c         |   15 -
 drivers/staging/gma500/mrst_lvds.c         |   10 
 drivers/staging/gma500/psb_bl.c            |    9 
 drivers/staging/gma500/psb_drv.c           |   53 +-
 drivers/staging/gma500/psb_drv.h           |   11 
 drivers/staging/gma500/psb_intel_display.c |   35 +
 drivers/staging/gma500/psb_intel_lvds.c    |   20 -
 drivers/staging/gma500/psb_irq.c           |  176 ++-----
 drivers/staging/gma500/psb_powermgmt.c     |  750 ++++++++--------------------
 drivers/staging/gma500/psb_powermgmt.h     |   55 --
 10 files changed, 363 insertions(+), 771 deletions(-)

diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index 89b9cac..664d0e7 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -174,8 +174,7 @@ static void mrst_crtc_dpms(struct drm_crtc *crtc, int mode)
 
 	PSB_DEBUG_ENTRY("mode = %d, pipe = %d\n", mode, pipe);
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				       OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return;
 
 	/* XXX: When our outputs are all unaware of DPMS modes other than off
@@ -270,7 +269,7 @@ static void mrst_crtc_dpms(struct drm_crtc *crtc, int mode)
 	REG_WRITE(0x70400, REG_READ(0x70400) | 0x4000);
 	/* Must write Bit 14 of the Chicken Bit Register */
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 }
 
 /**
@@ -323,8 +322,7 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 
 	PSB_DEBUG_ENTRY("pipe = 0x%x\n", pipe);
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return 0;
 
 	memcpy(&psb_intel_crtc->saved_mode,
@@ -514,7 +512,7 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 	psb_intel_wait_for_vblank(dev);
 
 mrst_crtc_mode_set_exit:
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 	return 0;
 }
 
@@ -551,8 +549,7 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 		return 0;
 	}
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				       OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return 0;
 
 	Start = mode_dev->bo_offset(dev, psbfb);
@@ -596,7 +593,7 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	}
 
 pipe_set_base_exit:
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 	return ret;
 }
 
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 4628b01..21b9056 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -48,8 +48,7 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
 	PSB_DEBUG_ENTRY("\n");
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return;
 
 	if (on) {
@@ -69,7 +68,7 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 		pm_request_idle(&dev->pdev->dev);
 	}
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 }
 
 static void mrst_lvds_dpms(struct drm_encoder *encoder, int mode)
@@ -99,8 +98,7 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 
 	PSB_DEBUG_ENTRY("\n");
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return;
 
 	/*
@@ -144,7 +142,7 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 	} else /*(v == DRM_MODE_SCALE_FULLSCREEN)*/
 		REG_WRITE(PFIT_CONTROL, PFIT_ENABLE);
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 }
 
 
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index a2729fd..57b9a5e 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -81,7 +81,7 @@ int mrst_set_brightness(struct backlight_device *bd)
 	if (level < 1)
 		level = 1;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, 0)) {
 		/* Calculate and set the brightness value */
 		max_pwm_blc = REG_READ(BLC_PWM_CTL) >> 16;
 		blc_pwm_ctl = level * max_pwm_blc / 100;
@@ -103,7 +103,7 @@ int mrst_set_brightness(struct backlight_device *bd)
 		/* force PWM bit on */
 		REG_WRITE(BLC_PWM_CTL2, (0x80000000 | REG_READ(BLC_PWM_CTL2)));
 		REG_WRITE(BLC_PWM_CTL, (max_pwm_blc << 16) | blc_pwm_ctl);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 	psb_brightness = level;
 	return 0;
@@ -161,8 +161,7 @@ static int device_backlight_init(struct drm_device *dev)
 	value /= bl_max_freq;
 	value /= blc_pwm_precision_factor;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-						OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		if (IS_MRST(dev)) {
 			if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
 				return 2;
@@ -182,7 +181,7 @@ static int device_backlight_init(struct drm_device *dev)
 					(value));
 			}
 		}
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 518b0fb..be8f11d 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -558,7 +558,7 @@ static int psb_driver_unload(struct drm_device *dev)
 		psb_intel_destroy_bios(dev);
 	}
 
-	ospm_power_uninit();
+	gma_power_uninit(dev);
 
 	return 0;
 }
@@ -612,7 +612,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	}
 
 	/* Init OSPM support */
-	ospm_power_init(dev);
+	gma_power_init(dev);
 
 	ret = -ENOMEM;
 
@@ -837,13 +837,12 @@ static int psb_dpst_ioctl(struct drm_device *dev, void *data,
 	uint32_t y;
 	uint32_t reg;
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON))
+	if (!gma_power_begin(dev, 0))
 		return 0;
 
 	reg = PSB_RVDC32(PIPEASRC);
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 
 	/* horizontal is the left 16 bits */
 	x = reg >> 16;
@@ -920,11 +919,10 @@ static int psb_mode_operation_ioctl(struct drm_device *dev, void *data,
 		drm_fb = obj_to_fb(obj);
 		psb_fb = to_psb_fb(drm_fb);
 
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					      OSPM_UHB_ONLY_IF_ON)) {
+		if (gma_power_begin(dev, 0)) {
 			REG_WRITE(DSPASURF, psb_fb->offset);
 			REG_READ(DSPASURF);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		} else {
 			dev_priv->saveDSPASURF = psb_fb->offset;
 		}
@@ -1010,11 +1008,10 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_psb_private *dev_priv = psb_priv(dev);
 	struct drm_psb_register_rw_arg *arg = data;
-	UHBUsage usage =
-	  arg->b_force_hw_on ? OSPM_UHB_FORCE_POWER_ON : OSPM_UHB_ONLY_IF_ON;
+	bool usage = arg->b_force_hw_on ? true : false;
 
 	if (arg->display_write_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			if (arg->display_write_mask & REGRWBITS_PFIT_CONTROLS)
 				PSB_WVDC32(arg->display.pfit_controls,
 					   PFIT_CONTROL);
@@ -1039,7 +1036,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 			if (arg->display_write_mask & REGRWBITS_VTOTAL_B)
 				PSB_WVDC32(arg->display.vtotal_b,
 					   VTOTAL_B);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		} else {
 			if (arg->display_write_mask & REGRWBITS_PFIT_CONTROLS)
 				dev_priv->savePFIT_CONTROL =
@@ -1064,7 +1061,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 	}
 
 	if (arg->display_read_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			if (arg->display_read_mask &
 			    REGRWBITS_PFIT_CONTROLS)
 				arg->display.pfit_controls =
@@ -1085,7 +1082,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 				arg->display.vtotal_a = PSB_RVDC32(VTOTAL_A);
 			if (arg->display_read_mask & REGRWBITS_VTOTAL_B)
 				arg->display.vtotal_b = PSB_RVDC32(VTOTAL_B);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		} else {
 			if (arg->display_read_mask &
 			    REGRWBITS_PFIT_CONTROLS)
@@ -1111,7 +1108,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 	}
 
 	if (arg->overlay_write_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			if (arg->overlay_write_mask & OV_REGRWBITS_OGAM_ALL) {
 				PSB_WVDC32(arg->overlay.OGAMC5, OV_OGAMC5);
 				PSB_WVDC32(arg->overlay.OGAMC4, OV_OGAMC4);
@@ -1162,7 +1159,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 					}
 				}
 			}
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		} else {
 			if (arg->overlay_write_mask & OV_REGRWBITS_OGAM_ALL) {
 				dev_priv->saveOV_OGAMC5 = arg->overlay.OGAMC5;
@@ -1188,7 +1185,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 	}
 
 	if (arg->overlay_read_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			if (arg->overlay_read_mask & OV_REGRWBITS_OGAM_ALL) {
 				arg->overlay.OGAMC5 = PSB_RVDC32(OV_OGAMC5);
 				arg->overlay.OGAMC4 = PSB_RVDC32(OV_OGAMC4);
@@ -1209,7 +1206,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 				arg->overlay.OVADD = PSB_RVDC32(OV_OVADD);
 			if (arg->overlay_read_mask & OVC_REGRWBITS_OVADD)
 				arg->overlay.OVADD = PSB_RVDC32(OVC_OVADD);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		} else {
 			if (arg->overlay_read_mask & OV_REGRWBITS_OGAM_ALL) {
 				arg->overlay.OGAMC5 = dev_priv->saveOV_OGAMC5;
@@ -1235,7 +1232,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 	}
 
 	if (arg->sprite_enable_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			PSB_WVDC32(0x1F3E, DSPARB);
 			PSB_WVDC32(arg->sprite.dspa_control
 					| PSB_RVDC32(DSPACNTR), DSPACNTR);
@@ -1250,22 +1247,22 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 			PSB_WVDC32(arg->sprite.dspc_size, DSPCSIZE);
 			PSB_WVDC32(arg->sprite.dspc_surface, DSPCSURF);
 			PSB_RVDC32(DSPCSURF);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		}
 	}
 
 	if (arg->sprite_disable_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			PSB_WVDC32(0x3F3E, DSPARB);
 			PSB_WVDC32(0x0, DSPCCNTR);
 			PSB_WVDC32(arg->sprite.dspc_surface, DSPCSURF);
 			PSB_RVDC32(DSPCSURF);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		}
 	}
 
 	if (arg->subpicture_enable_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			uint32_t temp;
 			if (arg->subpicture_enable_mask & REGRWBITS_DSPACNTR) {
 				temp =  PSB_RVDC32(DSPACNTR);
@@ -1309,12 +1306,12 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 				PSB_WVDC32(temp, DSPCSURF);
 				PSB_RVDC32(DSPCSURF);
 			}
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		}
 	}
 
 	if (arg->subpicture_disable_mask != 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+		if (gma_power_begin(dev, usage)) {
 			uint32_t temp;
 			if (arg->subpicture_disable_mask & REGRWBITS_DSPACNTR) {
 				temp =  PSB_RVDC32(DSPACNTR);
@@ -1355,7 +1352,7 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 				PSB_WVDC32(temp, DSPCSURF);
 				PSB_RVDC32(DSPCSURF);
 			}
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		}
 	}
 
@@ -1513,8 +1510,8 @@ static struct drm_driver driver = {
 static struct pci_driver psb_pci_driver = {
 	.name = DRIVER_NAME,
 	.id_table = pciidlist,
-	.resume = ospm_power_resume,
-	.suspend = ospm_power_suspend,
+	.resume = gma_power_resume,
+	.suspend = gma_power_suspend,
 	.probe = psb_probe,
 	.remove = psb_remove,
 #ifdef CONFIG_PM
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 7d07c97..c3609e0 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -246,7 +246,6 @@ struct drm_psb_private {
 	uint8_t *vdc_reg;
 	uint32_t gatt_free_offset;
 
-
 	/*
 	 *Fencing / irq.
 	 */
@@ -257,6 +256,14 @@ struct drm_psb_private {
 	spinlock_t irqmask_lock;
 
 	/*
+	 * Power
+         */
+
+	bool suspended;
+	bool display_power;
+	int display_count;
+
+	/*
 	 *Modesetting
 	 */
 	struct psb_intel_mode_device mode_dev;
@@ -527,8 +534,6 @@ extern int psb_irq_disable_dpst(struct drm_device *dev);
 extern void psb_irq_preinstall(struct drm_device *dev);
 extern int psb_irq_postinstall(struct drm_device *dev);
 extern void psb_irq_uninstall(struct drm_device *dev);
-extern void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands);
-extern int psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands);
 extern void psb_irq_turn_on_dpst(struct drm_device *dev);
 extern void psb_irq_turn_off_dpst(struct drm_device *dev);
 
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index d24d0bf..b462f32 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -359,8 +359,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 		return 0;
 	}
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				       OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return 0;
 
 	Start = mode_dev->bo_offset(dev, psbfb);
@@ -405,7 +404,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 
 psb_intel_pipe_set_base_exit:
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 
 	return ret;
 }
@@ -816,8 +815,7 @@ void psb_intel_crtc_load_lut(struct drm_crtc *crtc)
 		return;
 	}
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				      OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		for (i = 0; i < 256; i++) {
 			REG_WRITE(palreg + 4 * i,
 				  ((psb_intel_crtc->lut_r[i] +
@@ -827,7 +825,7 @@ void psb_intel_crtc_load_lut(struct drm_crtc *crtc)
 				  (psb_intel_crtc->lut_b[i] +
 				  psb_intel_crtc->lut_adj[i]));
 		}
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	} else {
 		for (i = 0; i < 256; i++) {
 			dev_priv->save_palette_a[i] =
@@ -1046,11 +1044,10 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		temp = 0;
 		temp |= CURSOR_MODE_DISABLE;
 
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					      OSPM_UHB_ONLY_IF_ON)) {
+        	if (gma_power_begin(dev, false)) {
 			REG_WRITE(control, temp);
 			REG_WRITE(base, 0);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev);
 		}
 
 		/* unpin the old bo */
@@ -1104,11 +1101,10 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	temp |= (pipe << 28);
 	temp |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				      OSPM_UHB_ONLY_IF_ON)) {
+       	if (gma_power_begin(dev, false)) {
 		REG_WRITE(control, temp);
 		REG_WRITE(base, addr);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 
 	/* unpin the old bo */
@@ -1143,11 +1139,10 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 
 	adder = psb_intel_crtc->cursor_addr;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				      OSPM_UHB_ONLY_IF_ON)) {
+       	if (gma_power_begin(dev, false)) {
 		REG_WRITE((pipe == 0) ? CURAPOS : CURBPOS, temp);
 		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, adder);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 	return 0;
 }
@@ -1197,15 +1192,14 @@ static int psb_intel_crtc_clock_get(struct drm_device *dev,
 	bool is_lvds;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				      OSPM_UHB_ONLY_IF_ON)) {
+       	if (gma_power_begin(dev, false)) {
 		dpll = REG_READ((pipe == 0) ? DPLL_A : DPLL_B);
 		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
 			fp = REG_READ((pipe == 0) ? FPA0 : FPB0);
 		else
 			fp = REG_READ((pipe == 0) ? FPA1 : FPB1);
 		is_lvds = (pipe == 1) && (REG_READ(LVDS) & LVDS_PORT_EN);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	} else {
 		dpll = (pipe == 0) ?
 			dev_priv->saveDPLL_A : dev_priv->saveDPLL_B;
@@ -1277,13 +1271,12 @@ struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
 	int vsync;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-				      OSPM_UHB_ONLY_IF_ON)) {
+       	if (gma_power_begin(dev, false)) {
 		htot = REG_READ((pipe == 0) ? HTOTAL_A : HTOTAL_B);
 		hsync = REG_READ((pipe == 0) ? HSYNC_A : HSYNC_B);
 		vtot = REG_READ((pipe == 0) ? VTOTAL_A : VTOTAL_B);
 		vsync = REG_READ((pipe == 0) ? VSYNC_A : VSYNC_B);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	} else {
 		htot = (pipe == 0) ?
 			dev_priv->saveHTOTAL_A : dev_priv->saveHTOTAL_B;
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 1e07f41..28e04a3 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -83,13 +83,12 @@ static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 retVal;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		retVal = ((REG_READ(BLC_PWM_CTL) &
 			  BACKLIGHT_MODULATION_FREQ_MASK) >>
 			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
 
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	} else
 		retVal = ((dev_priv->saveBLC_PWM_CTL &
 			  BACKLIGHT_MODULATION_FREQ_MASK) >>
@@ -200,14 +199,13 @@ static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 blc_pwm_ctl;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		blc_pwm_ctl =
 			REG_READ(BLC_PWM_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
 		REG_WRITE(BLC_PWM_CTL,
 				(blc_pwm_ctl |
 				(level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	} else {
 		blc_pwm_ctl = dev_priv->saveBLC_PWM_CTL &
 				~BACKLIGHT_DUTY_CYCLE_MASK;
@@ -224,8 +222,7 @@ static void psb_intel_lvds_set_power(struct drm_device *dev,
 {
 	u32 pp_status;
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return;
 
 	if (on) {
@@ -248,7 +245,7 @@ static void psb_intel_lvds_set_power(struct drm_device *dev,
 		} while (pp_status & PP_ON);
 	}
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 }
 
 static void psb_intel_lvds_encoder_dpms(struct drm_encoder *encoder, int mode)
@@ -457,8 +454,7 @@ void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 
 	PSB_DEBUG_ENTRY("\n");
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-					OSPM_UHB_FORCE_POWER_ON))
+	if (!gma_power_begin(dev, true))
 		return;
 
 	mode_dev->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
@@ -467,7 +463,7 @@ void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 
 	psb_intel_lvds_set_power(dev, output, false);
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 }
 
 void psb_intel_lvds_commit(struct drm_encoder *encoder)
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 9c2dbe4..9ea37e5 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -88,13 +88,12 @@ psb_enable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask)
 		u32 reg = psb_pipestat(pipe);
 		dev_priv->pipestat[pipe] |= mask;
 		/* Enable the interrupt, clear any pending status */
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+		if (gma_power_begin(dev_priv->dev, false)) {
 			u32 writeVal = PSB_RVDC32(reg);
 			writeVal |= (mask | (mask >> 16));
 			PSB_WVDC32(writeVal, reg);
 			(void) PSB_RVDC32(reg);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev_priv->dev);
 		}
 	}
 }
@@ -105,39 +104,36 @@ psb_disable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask)
 	if ((dev_priv->pipestat[pipe] & mask) != 0) {
 		u32 reg = psb_pipestat(pipe);
 		dev_priv->pipestat[pipe] &= ~mask;
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+		if (gma_power_begin(dev_priv->dev, false)) {
 			u32 writeVal = PSB_RVDC32(reg);
 			writeVal &= ~mask;
 			PSB_WVDC32(writeVal, reg);
 			(void) PSB_RVDC32(reg);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev_priv->dev);
 		}
 	}
 }
 
 void mid_enable_pipe_event(struct drm_psb_private *dev_priv, int pipe)
 {
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev_priv->dev, false)) {
 		u32 pipe_event = mid_pipe_event(pipe);
 		dev_priv->vdc_irq_mask |= pipe_event;
 		PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
 		PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev_priv->dev);
 	}
 }
 
 void mid_disable_pipe_event(struct drm_psb_private *dev_priv, int pipe)
 {
 	if (dev_priv->pipestat[pipe] == 0) {
-		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+		if (gma_power_begin(dev_priv->dev, false)) {
 			u32 pipe_event = mid_pipe_event(pipe);
 			dev_priv->vdc_irq_mask &= ~pipe_event;
 			PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
 			PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
-			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+			gma_power_end(dev_priv->dev);
 		}
 	}
 }
@@ -242,7 +238,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 	vdc_stat &= dev_priv->vdc_irq_mask;
 	spin_unlock(&dev_priv->irqmask_lock);
 
-	if (dsp_int && ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
+	if (dsp_int && gma_power_is_on(dev)) {
 		psb_vdc_interrupt(dev, vdc_stat);
 		handled = 1;
 	}
@@ -271,54 +267,28 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 void psb_irq_preinstall(struct drm_device *dev)
 {
-	psb_irq_preinstall_islands(dev, OSPM_ALL_ISLANDS);
-}
-
-/**
- * FIXME: should I remove display irq enable here??
- */
-void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands)
-{
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
 
-	PSB_DEBUG_ENTRY("\n");
-
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	if (hw_islands & OSPM_DISPLAY_ISLAND) {
-		if (ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
-			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
-			if (dev->vblank_enabled[0])
-				dev_priv->vdc_irq_mask |=
-						_PSB_PIPEA_EVENT_FLAG;
-			if (dev->vblank_enabled[1])
-				dev_priv->vdc_irq_mask |=
-						_MDFLD_PIPEB_EVENT_FLAG;
-			if (dev->vblank_enabled[2])
-				dev_priv->vdc_irq_mask |=
-						_MDFLD_PIPEC_EVENT_FLAG;
-		}
-	}
-/* NO I DONT WANT ANY IRQS GRRR FIXMEAC */
-	if (hw_islands & OSPM_GRAPHICS_ISLAND)
-		dev_priv->vdc_irq_mask |= _PSB_IRQ_SGX_FLAG;
-/* */
+	if (gma_power_is_on(dev))
+		PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
+	if (dev->vblank_enabled[0])
+		dev_priv->vdc_irq_mask |= _PSB_PIPEA_EVENT_FLAG;
+	if (dev->vblank_enabled[1])
+		dev_priv->vdc_irq_mask |= _MDFLD_PIPEB_EVENT_FLAG;
+	if (dev->vblank_enabled[2])
+		dev_priv->vdc_irq_mask |= _MDFLD_PIPEC_EVENT_FLAG;
+
 	/*This register is safe even if display island is off*/
 	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
-
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
 }
 
 int psb_irq_postinstall(struct drm_device *dev)
 {
-	return psb_irq_postinstall_islands(dev, OSPM_ALL_ISLANDS);
-}
-
-int psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands)
-{
-
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
@@ -327,48 +297,31 @@ int psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands)
 
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	/*This register is safe even if display island is off*/
+	/* This register is safe even if display island is off */
 	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
+	PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
 
-	if (hw_islands & OSPM_DISPLAY_ISLAND) {
-		if (true/*powermgmt_is_hw_on(dev->pdev, PSB_DISPLAY_ISLAND)*/) {
-			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
-
-			if (dev->vblank_enabled[0])
-				psb_enable_pipestat(dev_priv, 0,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-			else
-				psb_disable_pipestat(dev_priv, 0,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-
-			if (dev->vblank_enabled[1])
-					psb_enable_pipestat(dev_priv, 1,
-					    PIPE_VBLANK_INTERRUPT_ENABLE);
-			else
-				psb_disable_pipestat(dev_priv, 1,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-
-			if (dev->vblank_enabled[2])
-				psb_enable_pipestat(dev_priv, 2,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-			else
-				psb_disable_pipestat(dev_priv, 2,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-		}
-	}
+	if (dev->vblank_enabled[0])
+		psb_enable_pipestat(dev_priv, 0, PIPE_VBLANK_INTERRUPT_ENABLE);
+	else
+		psb_disable_pipestat(dev_priv, 0, PIPE_VBLANK_INTERRUPT_ENABLE);
 
-	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+	if (dev->vblank_enabled[1])
+		psb_enable_pipestat(dev_priv, 1, PIPE_VBLANK_INTERRUPT_ENABLE);
+	else
+		psb_disable_pipestat(dev_priv, 1, PIPE_VBLANK_INTERRUPT_ENABLE);
 
+	if (dev->vblank_enabled[2])
+		psb_enable_pipestat(dev_priv, 2, PIPE_VBLANK_INTERRUPT_ENABLE);
+	else
+		psb_disable_pipestat(dev_priv, 2, PIPE_VBLANK_INTERRUPT_ENABLE);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
 	return 0;
 }
 
 void psb_irq_uninstall(struct drm_device *dev)
 {
-	psb_irq_uninstall_islands(dev, OSPM_ALL_ISLANDS);
-}
-
-void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands)
-{
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
 	unsigned long irqflags;
@@ -377,39 +330,29 @@ void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands)
 
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	if (hw_islands & OSPM_DISPLAY_ISLAND) {
-		if (true/*powermgmt_is_hw_on(dev->pdev, PSB_DISPLAY_ISLAND)*/) {
-			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
+	PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
 
-			if (dev->vblank_enabled[0])
-				psb_disable_pipestat(dev_priv, 0,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
+	if (dev->vblank_enabled[0])
+		psb_disable_pipestat(dev_priv, 0, PIPE_VBLANK_INTERRUPT_ENABLE);
 
-			if (dev->vblank_enabled[1])
-				psb_disable_pipestat(dev_priv, 1,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
+	if (dev->vblank_enabled[1])
+		psb_disable_pipestat(dev_priv, 1, PIPE_VBLANK_INTERRUPT_ENABLE);
 
-			if (dev->vblank_enabled[2])
-				psb_disable_pipestat(dev_priv, 2,
-				    PIPE_VBLANK_INTERRUPT_ENABLE);
-		}
-		dev_priv->vdc_irq_mask &= _PSB_IRQ_SGX_FLAG |
-					  _PSB_IRQ_MSVDX_FLAG |
-					  _LNC_IRQ_TOPAZ_FLAG;
-	}
-	/*TODO: remove following code*/
-	if (hw_islands & OSPM_GRAPHICS_ISLAND)
-		dev_priv->vdc_irq_mask &= ~_PSB_IRQ_SGX_FLAG;
+	if (dev->vblank_enabled[2])
+		psb_disable_pipestat(dev_priv, 2, PIPE_VBLANK_INTERRUPT_ENABLE);
+
+	dev_priv->vdc_irq_mask &= _PSB_IRQ_SGX_FLAG |
+				  _PSB_IRQ_MSVDX_FLAG |
+				  _LNC_IRQ_TOPAZ_FLAG;
 
-	/*These two registers are safe even if display island is off*/
+	/* These two registers are safe even if display island is off */
 	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
 	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
 
 	wmb();
 
-	/*This register is safe even if display island is off*/
+	/* This register is safe even if display island is off */
 	PSB_WVDC32(PSB_RVDC32(PSB_INT_IDENTITY_R), PSB_INT_IDENTITY_R);
-
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
 }
 
@@ -420,8 +363,7 @@ void psb_irq_turn_on_dpst(struct drm_device *dev)
 	u32 hist_reg;
 	u32 pwm_reg;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		PSB_WVDC32(1 << 31, HISTOGRAM_LOGIC_CONTROL);
 		hist_reg = PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
 		PSB_WVDC32(1 << 31, HISTOGRAM_INT_CONTROL);
@@ -443,7 +385,7 @@ void psb_irq_turn_on_dpst(struct drm_device *dev)
 		PSB_WVDC32(pwm_reg | 0x80010100 | PWM_PHASEIN_ENABLE,
 							PWM_CONTROL_LOGIC);
 
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 }
 
@@ -472,8 +414,7 @@ void psb_irq_turn_off_dpst(struct drm_device *dev)
 	u32 hist_reg;
 	u32 pwm_reg;
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		PSB_WVDC32(0x00000000, HISTOGRAM_INT_CONTROL);
 		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
 
@@ -484,7 +425,7 @@ void psb_irq_turn_off_dpst(struct drm_device *dev)
 							PWM_CONTROL_LOGIC);
 		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
 
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 }
 
@@ -526,18 +467,16 @@ static int psb_vblank_do_wait(struct drm_device *dev,
  */
 int psb_enable_vblank(struct drm_device *dev, int pipe)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
 	uint32_t reg_val = 0;
 	uint32_t pipeconf_reg = mid_pipeconf(pipe);
 
 	PSB_DEBUG_ENTRY("\n");
 
-	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
-							OSPM_UHB_ONLY_IF_ON)) {
+	if (gma_power_begin(dev, false)) {
 		reg_val = REG_READ(pipeconf_reg);
-		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		gma_power_end(dev);
 	}
 
 	if (!(reg_val & PIPEACONF_ENABLE))
@@ -558,8 +497,7 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
  */
 void psb_disable_vblank(struct drm_device *dev, int pipe)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
 
 	PSB_DEBUG_ENTRY("\n");
@@ -601,7 +539,7 @@ u32 psb_get_vblank_counter(struct drm_device *dev, int pipe)
 		return 0;
 	}
 
-	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, false))
+	if (!gma_power_begin(dev, false))
 		return 0;
 
 	reg_val = REG_READ(pipeconf_reg);
@@ -630,7 +568,7 @@ u32 psb_get_vblank_counter(struct drm_device *dev, int pipe)
 
 psb_get_vblank_counter_exit:
 
-	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	gma_power_end(dev);
 
 	return count;
 }
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index 7deb1ba..fc0ed7a 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -24,83 +24,73 @@
  * Authors:
  *    Benjamin Defnet <benjamin.r.defnet@intel.com>
  *    Rajesh Poornachandran <rajesh.poornachandran@intel.com>
- *
+ * Massively reworked
+ *    Alan Cox <alan@linux.intel.com>
  */
 #include "psb_powermgmt.h"
 #include "psb_drv.h"
+#include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
 
-#undef OSPM_GFX_DPK
-
-extern u32 gui32SGXDeviceID;
-extern u32 gui32MRSTDisplayDeviceID;
-extern u32 gui32MRSTMSVDXDeviceID;
-extern u32 gui32MRSTTOPAZDeviceID;
-
-struct drm_device *gpDrmDevice = NULL;
 static struct mutex power_mutex;
-static bool gbSuspendInProgress = false;
-static bool gbResumeInProgress = false;
-static int g_hw_power_status_mask;
-static atomic_t g_display_access_count;
-static atomic_t g_graphics_access_count;
-static atomic_t g_videoenc_access_count;
-static atomic_t g_videodec_access_count;
-int allow_runtime_pm = 0;
-
-void ospm_power_island_up(int hw_islands);
-void ospm_power_island_down(int hw_islands);
-static bool gbSuspended = false;
-bool gbgfxsuspended = false;
 
-/*
- * ospm_power_init
+/**
+ *	gma_power_init		-	initialise power manager
+ *	@dev: our device
  *
- * Description: Initialize this ospm power management module
+ *	Set up for power management tracking of our hardware.
  */
-void ospm_power_init(struct drm_device *dev)
+void gma_power_init(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv = (struct drm_psb_private *)dev->dev_private;
-
-	gpDrmDevice = dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	dev_priv->apm_base = dev_priv->apm_reg & 0xffff;
 	dev_priv->ospm_base &= 0xffff;
 
+	dev_priv->display_power = true;	/* We start active */
+	dev_priv->display_count = 0;	/* Currently no users */
+	dev_priv->suspended = false;	/* And not suspended */
 	mutex_init(&power_mutex);
-	g_hw_power_status_mask = OSPM_ALL_ISLANDS;
-	atomic_set(&g_display_access_count, 0);
-	atomic_set(&g_graphics_access_count, 0);
-	atomic_set(&g_videoenc_access_count, 0);
-	atomic_set(&g_videodec_access_count, 0);
+
+	if (!IS_MRST(dev)) {
+		/* FIXME: wants further review */
+		u32 gating = PSB_RSGX32(PSB_CR_CLKGATECTL);
+		/* Disable 2D clock gating */
+		gating &= ~3;
+		gating |= 1;
+		PSB_WSGX32(gating, PSB_CR_CLKGATECTL);
+		PSB_RSGX32(PSB_CR_CLKGATECTL);
+	}
 }
 
-/*
- * ospm_power_uninit
+/**
+ *	gma_power_uninit	-	end power manager
+ *	@dev: device to end for
  *
- * Description: Uninitialize this ospm power management module
+ *	Undo the effects of gma_power_init
  */
-void ospm_power_uninit(void)
+void gma_power_uninit(struct drm_device *dev)
 {
 	mutex_destroy(&power_mutex);
-    	pm_runtime_disable(&gpDrmDevice->pdev->dev);
-	pm_runtime_set_suspended(&gpDrmDevice->pdev->dev);
+	pm_runtime_disable(&dev->pdev->dev);
+	pm_runtime_set_suspended(&dev->pdev->dev);
 }
 
 
-/*
- * save_display_registers
+/**
+ *	save_display_registers	-	save registers lost on suspend
+ *	@dev: our DRM device
  *
- * Description: We are going to suspend so save current display
- * register state.
+ *	Save the state we need in order to be able to restore the interface
+ *	upon resume from suspend
  */
 static int save_display_registers(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc * crtc;
-	struct drm_connector * connector;
+	struct drm_crtc *crtc;
+	struct drm_connector *connector;
 
 	/* Display arbitration control + watermarks */
 	dev_priv->saveDSPARB = PSB_RVDC32(DSPARB);
@@ -112,37 +102,31 @@ static int save_display_registers(struct drm_device *dev)
 	dev_priv->saveDSPFW6 = PSB_RVDC32(DSPFW6);
 	dev_priv->saveCHICKENBIT = PSB_RVDC32(DSPCHICKENBIT);
 
-	/*save crtc and output state*/
+	/* Save crtc and output state */
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if(drm_helper_crtc_in_use(crtc)) {
+		if (drm_helper_crtc_in_use(crtc))
 			crtc->funcs->save(crtc);
-		}
 	}
 
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
 		connector->funcs->save(connector);
-	}
-	mutex_unlock(&dev->mode_config.mutex);
-
-	/* Interrupt state */
-	/*
-	 * Handled in psb_irq.c
-	 */
 
+	mutex_unlock(&dev->mode_config.mutex);
 	return 0;
 }
 
-/*
- * restore_display_registers
+/**
+ *	restore_display_registers	-	restore lost register state
+ *	@dev: our DRM device
  *
- * Description: We are going to resume so restore display register state.
+ *	Restore register state that was lost during suspend and resume.
  */
 static int restore_display_registers(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc * crtc;
-	struct drm_connector * connector;
+	struct drm_crtc *crtc;
+	struct drm_connector *connector;
 
 	/* Display arbitration + watermarks */
 	PSB_WVDC32(dev_priv->saveDSPARB, DSPARB);
@@ -158,39 +142,57 @@ static int restore_display_registers(struct drm_device *dev)
 	PSB_WVDC32(0x80000000, VGACNTRL);
 
 	mutex_lock(&dev->mode_config.mutex);
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if(drm_helper_crtc_in_use(crtc))
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
+		if (drm_helper_crtc_in_use(crtc))
 			crtc->funcs->restore(crtc);
-	}
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		connector->funcs->restore(connector);
-	}
-	mutex_unlock(&dev->mode_config.mutex);
 
-	/*Interrupt state*/
-	/*
-	 * Handled in psb_irq.c
-	 */
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
+		connector->funcs->restore(connector);
 
+	mutex_unlock(&dev->mode_config.mutex);
 	return 0;
 }
-/*
- * powermgmt_suspend_display
+
+/**
+ *	power_down	-	power down the display island
+ *	@dev: our DRM device
  *
- * Description: Suspend the display hardware saving state and disabling
- * as necessary.
+ *	Power down the display interface of our device
  */
-void ospm_suspend_display(struct drm_device *dev)
+static void power_down(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	int pp_stat, ret=0;
+	u32 pwr_mask ;
+	u32 pwr_sts;
 
-	printk(KERN_ALERT "%s \n", __func__);
+	if (IS_MRST(dev)) {
+		pwr_mask = PSB_PWRGT_DISPLAY_MASK;
+		outl(pwr_mask, dev_priv->ospm_base + PSB_PM_SSC);
 
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "%s \n", __func__);
-#endif
-	if (!(g_hw_power_status_mask & OSPM_DISPLAY_ISLAND))
+		while (true) {
+			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
+			if ((pwr_sts & pwr_mask) == pwr_mask)
+				break;
+			else
+				udelay(10);
+		}
+		dev_priv->display_power = false;
+	}
+}
+
+
+/**
+ *	gma_suspend_display	-	suspend the display logic
+ *	@dev: our DRM device
+ *
+ *	Suspend the display logic of the graphics interface
+ */
+static void gma_suspend_display(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int pp_stat;
+
+	if (dev_priv->suspended)
 		return;
 
 	save_display_registers(dev);
@@ -225,33 +227,55 @@ void ospm_suspend_display(struct drm_device *dev)
 			!= DPI_FIFO_EMPTY);
 		PSB_WVDC32(0, DEVICE_READY_REG);
 			/* turn off panel power */
-		ret = 0;
 	}
-	ospm_power_island_down(OSPM_DISPLAY_ISLAND);
+	power_down(dev);
 }
 
 /*
- * ospm_resume_display
+ * power_up
  *
- * Description: Resume the display hardware restoring state and enabling
- * as necessary.
+ * Description: Restore power to the specified island(s) (powergating)
  */
-void ospm_resume_display(struct pci_dev *pdev)
+static void power_up(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 pwr_mask = PSB_PWRGT_DISPLAY_MASK;
+	u32 pwr_sts, pwr_cnt;
+
+	if (IS_MRST(dev)) {
+		pwr_cnt = inl(dev_priv->ospm_base + PSB_PM_SSC);
+		pwr_cnt &= ~pwr_mask;
+		outl(pwr_cnt, (dev_priv->ospm_base + PSB_PM_SSC));
+
+		while (true) {
+			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
+			if ((pwr_sts & pwr_mask) == 0)
+				break;
+			else
+				udelay(10);
+		}
+	}
+	dev_priv->suspended = false;
+	dev_priv->display_power = true;
+}
+
+/**
+ *	gma_resume_display	-	resume display side logic
+ *
+ *	Resume the display hardware restoring state and enabling
+ *	as necessary.
+ */
+static void gma_resume_display(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct psb_gtt *pg = dev_priv->pg;
 
-	printk(KERN_ALERT "%s \n", __func__);
-
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "%s \n", __func__);
-#endif
-	if (g_hw_power_status_mask & OSPM_DISPLAY_ISLAND)
+	if (dev_priv->suspended == false)
 		return;
 
 	/* turn on the display power island */
-	ospm_power_island_up(OSPM_DISPLAY_ISLAND);
+	power_up(dev);
 
 	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
 	pci_write_config_word(pdev, PSB_GMCH_CTRL,
@@ -267,26 +291,21 @@ void ospm_resume_display(struct pci_dev *pdev)
 	restore_display_registers(dev);
 }
 
-#if 1
-/*
- * ospm_suspend_pci
+/**
+ *	gma_suspend_pci		-	suspend PCI side
+ *	@pdev: PCI device
  *
- * Description: Suspend the pci device saving state and disabling
- * as necessary.
+ *	Perform the suspend processing on our PCI device state
  */
-static void ospm_suspend_pci(struct pci_dev *pdev)
+static void gma_suspend_pci(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	int bsm, vbt;
 
-	if (gbSuspended)
+	if (dev_priv->suspended)
 		return;
 
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "ospm_suspend_pci\n");
-#endif
-
 	pci_save_state(pdev);
 	pci_read_config_dword(pdev, 0x5C, &bsm);
 	dev_priv->saveBSM = bsm;
@@ -298,29 +317,25 @@ static void ospm_suspend_pci(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
-	gbSuspended = true;
-	gbgfxsuspended = true;
+	dev_priv->suspended = true;
 }
 
-/*
- * ospm_resume_pci
+/**
+ *	gma_resume_pci		-	resume helper
+ *	@dev: our PCI device
  *
- * Description: Resume the pci device restoring state and enabling
- * as necessary.
+ *	Perform the resume processing on our PCI device state - rewrite
+ *	register state and re-enable the PCI device
  */
-static bool ospm_resume_pci(struct pci_dev *pdev)
+static bool gma_resume_pci(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	int ret = 0;
+	int ret;
 
-	if (!gbSuspended)
+	if (!dev_priv->suspended)
 		return true;
 
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "ospm_resume_pci\n");
-#endif
-
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	pci_write_config_dword(pdev, 0x5c, dev_priv->saveBSM);
@@ -331,448 +346,131 @@ static bool ospm_resume_pci(struct pci_dev *pdev)
 	ret = pci_enable_device(pdev);
 
 	if (ret != 0)
-		printk(KERN_ALERT "ospm_resume_pci: pci_enable_device failed: %d\n", ret);
+		dev_err(&pdev->dev, "pci_enable failed: %d\n", ret);
 	else
-		gbSuspended = false;
-
-	return !gbSuspended;
-}
-#endif
-/*
- * ospm_power_suspend
- *
- * Description: OSPM is telling our driver to suspend so save state
- * and power down all hardware.
- */
-int ospm_power_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-        int ret = 0;
-        int graphics_access_count;
-        int videoenc_access_count;
-        int videodec_access_count;
-        int display_access_count;
-    	bool suspend_pci = true;
-
-	if(gbSuspendInProgress || gbResumeInProgress)
-        {
-#ifdef OSPM_GFX_DPK
-                printk(KERN_ALERT "OSPM_GFX_DPK: %s system BUSY \n", __func__);
-#endif
-                return  -EBUSY;
-        }
-
-        mutex_lock(&power_mutex);
-
-        if (!gbSuspended) {
-                graphics_access_count = atomic_read(&g_graphics_access_count);
-                videoenc_access_count = atomic_read(&g_videoenc_access_count);
-                videodec_access_count = atomic_read(&g_videodec_access_count);
-                display_access_count = atomic_read(&g_display_access_count);
-
-                if (graphics_access_count ||
-			videoenc_access_count ||
-			videodec_access_count ||
-			display_access_count)
-                        ret = -EBUSY;
-
-                if (!ret) {
-                        gbSuspendInProgress = true;
-
-                        psb_irq_uninstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-                        ospm_suspend_display(gpDrmDevice);
-                        if (suspend_pci == true) {
-				ospm_suspend_pci(pdev);
-                        }
-                        gbSuspendInProgress = false;
-                } else {
-                        printk(KERN_ALERT "ospm_power_suspend: device busy: graphics %d videoenc %d videodec %d display %d\n", graphics_access_count, videoenc_access_count, videodec_access_count, display_access_count);
-                }
-        }
-
-
-        mutex_unlock(&power_mutex);
-        return ret;
+		dev_priv->suspended = false;
+	return !dev_priv->suspended;
 }
 
-/*
- * ospm_power_island_up
+/**
+ *	gma_power_suspend		-	bus callback for suspend
+ *	@pdev: our PCI device
+ *	@state: suspend type
  *
- * Description: Restore power to the specified island(s) (powergating)
+ *	Called back by the PCI layer during a suspend of the system. We
+ *	perform the necessary shut down steps and save enough state that
+ *	we can undo this when resume is called.
  */
-void ospm_power_island_up(int hw_islands)
+int gma_power_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	u32 pwr_cnt = 0;
-	u32 pwr_sts = 0;
-	u32 pwr_mask = 0;
-
-	struct drm_psb_private *dev_priv =
-		(struct drm_psb_private *) gpDrmDevice->dev_private;
-
-
-	if (hw_islands & OSPM_DISPLAY_ISLAND) {
-		pwr_mask = PSB_PWRGT_DISPLAY_MASK;
-
-		pwr_cnt = inl(dev_priv->ospm_base + PSB_PM_SSC);
-		pwr_cnt &= ~pwr_mask;
-		outl(pwr_cnt, (dev_priv->ospm_base + PSB_PM_SSC));
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_psb_private *dev_priv = dev->dev_private;
 
-		while (true) {
-			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
-			if ((pwr_sts & pwr_mask) == 0)
-				break;
-			else
-				udelay(10);
+	mutex_lock(&power_mutex);
+	if (!dev_priv->suspended) {
+		if (dev_priv->display_count) {
+			mutex_unlock(&power_mutex);
+			return -EBUSY;
 		}
+		psb_irq_uninstall(dev);
+		gma_suspend_display(dev);
+		gma_suspend_pci(pdev);
 	}
-
-	g_hw_power_status_mask |= hw_islands;
-}
-
-/*
- * ospm_power_resume
- */
-int ospm_power_resume(struct pci_dev *pdev)
-{
-	if(gbSuspendInProgress || gbResumeInProgress)
-        {
-#ifdef OSPM_GFX_DPK
-                printk(KERN_ALERT "OSPM_GFX_DPK: %s hw_island: Suspend || gbResumeInProgress!!!! \n", __func__);
-#endif
-                return 0;
-        }
-
-        mutex_lock(&power_mutex);
-
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "OSPM_GFX_DPK: ospm_power_resume \n");
-#endif
-
-  	gbResumeInProgress = true;
-
-        ospm_resume_pci(pdev);
-
-	ospm_resume_display(gpDrmDevice->pdev);
-        psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-        psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-
-	gbResumeInProgress = false;
-
-        mutex_unlock(&power_mutex);
-
+	mutex_unlock(&power_mutex);
 	return 0;
 }
 
 
-/*
- * ospm_power_island_down
+/**
+ *	gma_power_resume		-	resume power
+ *	@pdev: PCI device
  *
- * Description: Cut power to the specified island(s) (powergating)
+ *	Resume the PCI side of the graphics and then the displays
  */
-void ospm_power_island_down(int islands)
+int gma_power_resume(struct pci_dev *pdev)
 {
-#if 0
-	u32 pwr_cnt = 0;
-	u32 pwr_mask = 0;
-	u32 pwr_sts = 0;
-
-	struct drm_psb_private *dev_priv =
-		(struct drm_psb_private *) gpDrmDevice->dev_private;
-
-	g_hw_power_status_mask &= ~islands;
-
-	if (islands & OSPM_GRAPHICS_ISLAND) {
-		pwr_cnt |= PSB_PWRGT_GFX_MASK;
-		pwr_mask |= PSB_PWRGT_GFX_MASK;
-		if (dev_priv->graphics_state == PSB_PWR_STATE_ON) {
-			dev_priv->gfx_on_time += (jiffies - dev_priv->gfx_last_mode_change) * 1000 / HZ;
-			dev_priv->gfx_last_mode_change = jiffies;
-			dev_priv->graphics_state = PSB_PWR_STATE_OFF;
-			dev_priv->gfx_off_cnt++;
-		}
-	}
-	if (islands & OSPM_VIDEO_ENC_ISLAND) {
-		pwr_cnt |= PSB_PWRGT_VID_ENC_MASK;
-		pwr_mask |= PSB_PWRGT_VID_ENC_MASK;
-	}
-	if (islands & OSPM_VIDEO_DEC_ISLAND) {
-		pwr_cnt |= PSB_PWRGT_VID_DEC_MASK;
-		pwr_mask |= PSB_PWRGT_VID_DEC_MASK;
-	}
-	if (pwr_cnt) {
-		pwr_cnt |= inl(dev_priv->apm_base);
-		outl(pwr_cnt, dev_priv->apm_base  + PSB_APM_CMD);
-		while (true) {
-			pwr_sts = inl(dev_priv->apm_base + PSB_APM_STS);
-
-			if ((pwr_sts & pwr_mask) == pwr_mask)
-				break;
-			else
-				udelay(10);
-		}
-	}
-
-	if (islands & OSPM_DISPLAY_ISLAND) {
-		pwr_mask = PSB_PWRGT_DISPLAY_MASK;
-
-		outl(pwr_mask, (dev_priv->ospm_base + PSB_PM_SSC));
+	struct drm_device *dev = pci_get_drvdata(pdev);
 
-		while (true) {
-			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
-			if ((pwr_sts & pwr_mask) == pwr_mask)
-				break;
-			else
-				udelay(10);
-		}
-	}
-#endif
+	mutex_lock(&power_mutex);
+	gma_resume_pci(pdev);
+	gma_resume_display(pdev);
+	psb_irq_preinstall(dev);
+	psb_irq_postinstall(dev);
+	mutex_unlock(&power_mutex);
+	return 0;
 }
 
 
-/*
- * ospm_power_is_hw_on
+
+/**
+ *	gma_power_is_on		-	returne true if power is on
+ *	@dev: our DRM device
  *
- * Description: do an instantaneous check for if the specified islands
- * are on.  Only use this in cases where you know the g_state_change_mutex
- * is already held such as in irq install/uninstall.  Otherwise, use
- * ospm_power_using_hw_begin().
+ *	Returns true if the display island power is on at this moment
  */
-bool ospm_power_is_hw_on(int hw_islands)
+bool gma_power_is_on(struct drm_device *dev)
 {
-	return ((g_hw_power_status_mask & hw_islands) == hw_islands) ? true:false;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	return dev_priv->display_power;
 }
 
-/*
- * ospm_power_using_hw_begin
+
+/**
+ *	gma_power_begin		-	begin requiring power
+ *	@dev: our DRM device
+ *	@force_on: true to force power on
  *
- * Description: Notify PowerMgmt module that you will be accessing the
- * specified island's hw so don't power it off.  If force_on is true,
- * this will power on the specified island if it is off.
- * Otherwise, this will return false and the caller is expected to not
- * access the hw.
+ *	Begin an action that requires the display power island is enabled.
+ *	We refcount the islands.
  *
- * NOTE *** If this is called from and interrupt handler or other atomic
- * context, then it will return false if we are in the middle of a
- * power state transition and the caller will be expected to handle that
- * even if force_on is set to true.
+ *	FIXME: locking
  */
-bool ospm_power_using_hw_begin(int hw_island, UHBUsage usage)
+bool gma_power_begin(struct drm_device *dev, bool force_on)
 {
-        return 1;	/*FIXMEAC */
-#if 0
-	bool ret = true;
-	bool island_is_off = false;
-	bool b_atomic = (in_interrupt() || in_atomic());
-	bool locked = true;
-	struct pci_dev *pdev = gpDrmDevice->pdev;
-	u32 deviceID = 0;
-	bool force_on = usage ? true: false;
-	/*quick path, not 100% race safe, but should be enough comapre to current other code in this file */
-	if (!force_on) {
-		if (hw_island & (OSPM_ALL_ISLANDS & ~g_hw_power_status_mask))
-			return false;
-		else {
-			locked = false;
-#ifdef CONFIG_PM_RUNTIME
-			/* increment pm_runtime_refcount */
-			pm_runtime_get(&pdev->dev);
-#endif
-			goto increase_count;
-		}
-	}
-
-
-	if (!b_atomic)
-		mutex_lock(&power_mutex);
-
-	island_is_off = hw_island & (OSPM_ALL_ISLANDS & ~g_hw_power_status_mask);
-
-	if (b_atomic && (gbSuspendInProgress || gbResumeInProgress || gbSuspended) && force_on && island_is_off)
-		ret = false;
-
-	if (ret && island_is_off && !force_on)
-		ret = false;
-
-	if (ret && island_is_off && force_on) {
-		gbResumeInProgress = true;
-
-		ret = ospm_resume_pci(pdev);
-
-		if (ret) {
-			switch(hw_island)
-			{
-			case OSPM_DISPLAY_ISLAND:
-				deviceID = gui32MRSTDisplayDeviceID;
-				ospm_resume_display(pdev);
-				psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-				psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-				break;
-			case OSPM_GRAPHICS_ISLAND:
-				deviceID = gui32SGXDeviceID;
-				ospm_power_island_up(OSPM_GRAPHICS_ISLAND);
-				psb_irq_preinstall_islands(gpDrmDevice, OSPM_GRAPHICS_ISLAND);
-				psb_irq_postinstall_islands(gpDrmDevice, OSPM_GRAPHICS_ISLAND);
-				break;
-#if 1
-			case OSPM_VIDEO_DEC_ISLAND:
-				if(!ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
-					//printk(KERN_ALERT "%s power on display for video decode use\n", __func__);
-					deviceID = gui32MRSTDisplayDeviceID;
-					ospm_resume_display(pdev);
-					psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-					psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-				}
-				else{
-					//printk(KERN_ALERT "%s display is already on for video decode use\n", __func__);
-				}
-
-				if(!ospm_power_is_hw_on(OSPM_VIDEO_DEC_ISLAND)) {
-					//printk(KERN_ALERT "%s power on video decode\n", __func__);
-					deviceID = gui32MRSTMSVDXDeviceID;
-					ospm_power_island_up(OSPM_VIDEO_DEC_ISLAND);
-					psb_irq_preinstall_islands(gpDrmDevice, OSPM_VIDEO_DEC_ISLAND);
-					psb_irq_postinstall_islands(gpDrmDevice, OSPM_VIDEO_DEC_ISLAND);
-				}
-				else{
-					//printk(KERN_ALERT "%s video decode is already on\n", __func__);
-				}
-
-				break;
-			case OSPM_VIDEO_ENC_ISLAND:
-				if(!ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
-					//printk(KERN_ALERT "%s power on display for video encode\n", __func__);
-					deviceID = gui32MRSTDisplayDeviceID;
-					ospm_resume_display(pdev);
-					psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-					psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
-				}
-				else{
-					//printk(KERN_ALERT "%s display is already on for video encode use\n", __func__);
-				}
-
-				if(!ospm_power_is_hw_on(OSPM_VIDEO_ENC_ISLAND)) {
-					//printk(KERN_ALERT "%s power on video encode\n", __func__);
-					deviceID = gui32MRSTTOPAZDeviceID;
-					ospm_power_island_up(OSPM_VIDEO_ENC_ISLAND);
-					psb_irq_preinstall_islands(gpDrmDevice, OSPM_VIDEO_ENC_ISLAND);
-					psb_irq_postinstall_islands(gpDrmDevice, OSPM_VIDEO_ENC_ISLAND);
-				}
-				else{
-					//printk(KERN_ALERT "%s video decode is already on\n", __func__);
-				}
-#endif
-				break;
-
-			default:
-				printk(KERN_ALERT "%s unknown island !!!! \n", __func__);
-				break;
-			}
-
-		}
-
-		if (!ret)
-			printk(KERN_ALERT "ospm_power_using_hw_begin: forcing on %d failed\n", hw_island);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int ret;
 
-		gbResumeInProgress = false;
+	/* Power already on ? */
+	if (dev_priv->display_power) {
+		dev_priv->display_count++;
+		pm_runtime_get(&dev->pdev->dev);
+		return true;
 	}
-increase_count:
-	if (ret) {
-		switch(hw_island)
-		{
-		case OSPM_GRAPHICS_ISLAND:
-			atomic_inc(&g_graphics_access_count);
-			break;
-		case OSPM_VIDEO_ENC_ISLAND:
-			atomic_inc(&g_videoenc_access_count);
-			break;
-		case OSPM_VIDEO_DEC_ISLAND:
-			atomic_inc(&g_videodec_access_count);
-			break;
-		case OSPM_DISPLAY_ISLAND:
-			atomic_inc(&g_display_access_count);
-			break;
-		}
+	if (force_on == false)
+		return false;
+
+	/* Ok power up needed */
+	ret = gma_resume_pci(dev->pdev);
+	if (ret == 0) {
+		psb_irq_preinstall(dev);
+		psb_irq_postinstall(dev);
+		pm_runtime_get(&dev->pdev->dev);
+		dev_priv->display_count++;
+		return true;
 	}
-
-	if (!b_atomic && locked)
-		mutex_unlock(&power_mutex);
-
-	return ret;
-#endif
+	return false;
 }
 
 
-/*
- * ospm_power_using_hw_end
+/**
+ *	gma_power_end		-	end use of power
+ *	@dev: Our DRM device
  *
- * Description: Notify PowerMgmt module that you are done accessing the
- * specified island's hw so feel free to power it off.  Note that this
- * function doesn't actually power off the islands.
+ *	Indicate that one of our gma_power_begin() requested periods when
+ *	the diplay island power is needed has completed.
  */
-void ospm_power_using_hw_end(int hw_island)
-{
-#if 0 /* FIXMEAC */
-	switch(hw_island)
-	{
-	case OSPM_GRAPHICS_ISLAND:
-		atomic_dec(&g_graphics_access_count);
-		break;
-	case OSPM_VIDEO_ENC_ISLAND:
-		atomic_dec(&g_videoenc_access_count);
-		break;
-	case OSPM_VIDEO_DEC_ISLAND:
-		atomic_dec(&g_videodec_access_count);
-		break;
-	case OSPM_DISPLAY_ISLAND:
-		atomic_dec(&g_display_access_count);
-		break;
-	}
-
-	//decrement runtime pm ref count
-	pm_runtime_put(&gpDrmDevice->pdev->dev);
-
-	WARN_ON(atomic_read(&g_graphics_access_count) < 0);
-	WARN_ON(atomic_read(&g_videoenc_access_count) < 0);
-	WARN_ON(atomic_read(&g_videodec_access_count) < 0);
-	WARN_ON(atomic_read(&g_display_access_count) < 0);
-#endif
-}
-
-int ospm_runtime_pm_allow(struct drm_device * dev)
+void gma_power_end(struct drm_device *dev)
 {
-	return 0;
-}
-
-void ospm_runtime_pm_forbid(struct drm_device * dev)
-{
-	struct drm_psb_private * dev_priv = dev->dev_private;
-
-	DRM_INFO("%s\n", __FUNCTION__);
-
-	pm_runtime_forbid(&dev->pdev->dev);
-	dev_priv->rpm_enabled = 0;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	dev_priv->display_count--;
+	WARN_ON(dev_priv->display_count < 0);
+	pm_runtime_put(&dev->pdev->dev);
 }
 
 int psb_runtime_suspend(struct device *dev)
 {
-	pm_message_t state;
-	int ret = 0;
-	state.event = 0;
-
-#ifdef OSPM_GFX_DPK
-	printk(KERN_ALERT "OSPM_GFX_DPK: %s \n", __func__);
-#endif
-        if (atomic_read(&g_graphics_access_count) || atomic_read(&g_videoenc_access_count)
-		|| atomic_read(&g_videodec_access_count) || atomic_read(&g_display_access_count)){
-#ifdef OSPM_GFX_DPK
-                printk(KERN_ALERT "OSPM_GFX_DPK: GFX: %d VEC: %d VED: %d DC: %d DSR: %d \n", atomic_read(&g_graphics_access_count),
-			atomic_read(&g_videoenc_access_count), atomic_read(&g_videodec_access_count), atomic_read(&g_display_access_count));
-#endif
-                return -EBUSY;
-        }
-        else
-		ret = ospm_power_suspend(gpDrmDevice->pdev, state);
-
-	return ret;
+	static pm_message_t dummy;
+	return gma_power_suspend(to_pci_dev(dev), dummy);
 }
 
 int psb_runtime_resume(struct device *dev)
@@ -782,11 +480,11 @@ int psb_runtime_resume(struct device *dev)
 
 int psb_runtime_idle(struct device *dev)
 {
-	/*printk (KERN_ALERT "lvds:%d,mipi:%d\n", dev_priv->is_lvds_on, dev_priv->is_mipi_on);*/
-	if (atomic_read(&g_graphics_access_count) || atomic_read(&g_videoenc_access_count)
-		|| atomic_read(&g_videodec_access_count) || atomic_read(&g_display_access_count))
-		return 1;
-	else
+	struct drm_device *drmdev = pci_get_drvdata(to_pci_dev(dev));
+	struct drm_psb_private *dev_priv = drmdev->dev_private;
+	if (dev_priv->display_count)
 		return 0;
+	else
+		return 1;
 }
 
diff --git a/drivers/staging/gma500/psb_powermgmt.h b/drivers/staging/gma500/psb_powermgmt.h
index bf6f27a..e005229 100644
--- a/drivers/staging/gma500/psb_powermgmt.h
+++ b/drivers/staging/gma500/psb_powermgmt.h
@@ -24,7 +24,8 @@
  * Authors:
  *    Benjamin Defnet <benjamin.r.defnet@intel.com>
  *    Rajesh Poornachandran <rajesh.poornachandran@intel.com>
- *
+ * Massively reworked
+ *    Alan Cox <alan@linux.intel.com>
  */
 #ifndef _PSB_POWERMGMT_H_
 #define _PSB_POWERMGMT_H_
@@ -32,65 +33,35 @@
 #include <linux/pci.h>
 #include <drm/drmP.h>
 
-#define OSPM_GRAPHICS_ISLAND	0x1
-#define OSPM_VIDEO_ENC_ISLAND	0x2
-#define OSPM_VIDEO_DEC_ISLAND	0x4
-#define OSPM_DISPLAY_ISLAND	0x8
-#define OSPM_GL3_CACHE_ISLAND	0x10
-#define OSPM_ALL_ISLANDS	0x1f
-
-/* IPC message and command defines used to enable/disable mipi panel voltages */
-#define IPC_MSG_PANEL_ON_OFF    0xE9
-#define IPC_CMD_PANEL_ON        1
-#define IPC_CMD_PANEL_OFF       0
-
-typedef enum _UHBUsage
-{
-    OSPM_UHB_ONLY_IF_ON = 0,
-    OSPM_UHB_FORCE_POWER_ON,
-} UHBUsage;
-
-/* Use these functions to power down video HW for D0i3 purpose  */
-
-void ospm_power_init(struct drm_device *dev);
-void ospm_power_uninit(void);
-
+void gma_power_init(struct drm_device *dev);
+void gma_power_uninit(struct drm_device *dev);
 
 /*
- * OSPM will call these functions
+ * The kernel bus power management  will call these functions
  */
-int ospm_power_suspend(struct pci_dev *pdev, pm_message_t state);
-int ospm_power_resume(struct pci_dev *pdev);
+int gma_power_suspend(struct pci_dev *pdev, pm_message_t state);
+int gma_power_resume(struct pci_dev *pdev);
 
 /*
  * These are the functions the driver should use to wrap all hw access
  * (i.e. register reads and writes)
  */
-bool ospm_power_using_hw_begin(int hw_island, UHBUsage usage);
-void ospm_power_using_hw_end(int hw_island);
+bool gma_power_begin(struct drm_device *dev, bool force);
+void gma_power_end(struct drm_device *dev);
 
 /*
  * Use this function to do an instantaneous check for if the hw is on.
- * Only use this in cases where you know the g_state_change_mutex
- * is already held such as in irq install/uninstall and you need to
- * prevent a deadlock situation.  Otherwise use ospm_power_using_hw_begin().
+ * Only use this in cases where you know the mutex is already held such
+ * as in irq install/uninstall and you need to
+ * prevent a deadlock situation.  Otherwise use gma_power_begin().
  */
-bool ospm_power_is_hw_on(int hw_islands);
+bool gma_power_is_on(struct drm_device *dev);
 
 /*
- * Power up/down different hw component rails/islands
- */
-void ospm_power_island_down(int hw_islands);
-void ospm_power_island_up(int hw_islands);
-void ospm_suspend_graphics(void);
-/*
  * GFX-Runtime PM callbacks
  */
 int psb_runtime_suspend(struct device *dev);
 int psb_runtime_resume(struct device *dev);
 int psb_runtime_idle(struct device *dev);
-int ospm_runtime_pm_allow(struct drm_device * dev);
-void ospm_runtime_pm_forbid(struct drm_device * dev);
-
 
 #endif /*_PSB_POWERMGMT_H_*/

