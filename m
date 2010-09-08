Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0IHQco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0IHQcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:32:42 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: [PATCH] i915: Add native backlight control
Date: Wed,  8 Sep 2010 12:32:18 -0400
Message-Id: <1283963539-4039-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1283963539-4039-1-git-send-email-mjg@redhat.com>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.57.107
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all systems expose a firmware or platform mechanism for changing the
backlight intensity on i915, so add native driver support.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>
---
 drivers/gpu/drm/i915/i915_drv.h      |    3 +
 drivers/gpu/drm/i915/i915_opregion.c |   60 +-----------
 drivers/gpu/drm/i915/intel_drv.h     |    3 +
 drivers/gpu/drm/i915/intel_lvds.c    |  177 ++++++++++++++++++++++++++++++----
 4 files changed, 170 insertions(+), 73 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index af4a263..36c4b407 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -34,6 +34,7 @@
 #include "intel_bios.h"
 #include "intel_ringbuffer.h"
 #include <linux/io-mapping.h>
+#include <linux/backlight.h>
 
 /* General customization:
  */
@@ -663,6 +664,8 @@ typedef struct drm_i915_private {
 
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
+
+	struct backlight_device *backlight;
 } drm_i915_private_t;
 
 /** driver private structure attached to each drm_gem_object */
diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index ea5d3fe..de199dd 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -31,9 +31,9 @@
 #include "drmP.h"
 #include "i915_drm.h"
 #include "i915_drv.h"
+#include "intel_drv.h"
 
 #define PCI_ASLE 0xe4
-#define PCI_LBPC 0xf4
 #define PCI_ASLS 0xfc
 
 #define OPREGION_SZ            (8*1024)
@@ -147,8 +147,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct opregion_asle *asle = dev_priv->opregion.asle;
-	u32 blc_pwm_ctl, blc_pwm_ctl2;
-	u32 max_backlight, level, shift;
+	u32 max = intel_lvds_get_max_backlight(dev);
 
 	if (!(bclp & ASLE_BCLP_VALID))
 		return ASLE_BACKLIGHT_FAILED;
@@ -157,27 +156,8 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 	if (bclp < 0 || bclp > 255)
 		return ASLE_BACKLIGHT_FAILED;
 
-	blc_pwm_ctl = I915_READ(BLC_PWM_CTL);
-	blc_pwm_ctl2 = I915_READ(BLC_PWM_CTL2);
-
-	if (IS_I965G(dev) && (blc_pwm_ctl2 & BLM_COMBINATION_MODE))
-		pci_write_config_dword(dev->pdev, PCI_LBPC, bclp);
-	else {
-		if (IS_PINEVIEW(dev)) {
-			blc_pwm_ctl &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
-			max_backlight = (blc_pwm_ctl & BACKLIGHT_MODULATION_FREQ_MASK) >> 
-					BACKLIGHT_MODULATION_FREQ_SHIFT;
-			shift = BACKLIGHT_DUTY_CYCLE_SHIFT + 1;
-		} else {
-			blc_pwm_ctl &= ~BACKLIGHT_DUTY_CYCLE_MASK;
-			max_backlight = ((blc_pwm_ctl & BACKLIGHT_MODULATION_FREQ_MASK) >> 
-					BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
-			shift = BACKLIGHT_DUTY_CYCLE_SHIFT;
-		}
-		level = (bclp * max_backlight) / 255;
-		I915_WRITE(BLC_PWM_CTL, blc_pwm_ctl | (level << shift));
-	}
-	asle->cblv = (bclp*0x64)/0xff | ASLE_CBLV_VALID;
+	asle->cblv = (bclp * 100 / 255) | ASLE_CBLV_VALID;
+	intel_lvds_set_backlight(dev, max * bclp / 255);
 
 	return 0;
 }
@@ -243,36 +223,6 @@ void opregion_asle_intr(struct drm_device *dev)
 	asle->aslc = asle_stat;
 }
 
-static u32 asle_set_backlight_ironlake(struct drm_device *dev, u32 bclp)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_asle *asle = dev_priv->opregion.asle;
-	u32 cpu_pwm_ctl, pch_pwm_ctl2;
-	u32 max_backlight, level;
-
-	if (!(bclp & ASLE_BCLP_VALID))
-		return ASLE_BACKLIGHT_FAILED;
-
-	bclp &= ASLE_BCLP_MSK;
-	if (bclp < 0 || bclp > 255)
-		return ASLE_BACKLIGHT_FAILED;
-
-	cpu_pwm_ctl = I915_READ(BLC_PWM_CPU_CTL);
-	pch_pwm_ctl2 = I915_READ(BLC_PWM_PCH_CTL2);
-	/* get the max PWM frequency */
-	max_backlight = (pch_pwm_ctl2 >> 16) & BACKLIGHT_DUTY_CYCLE_MASK;
-	/* calculate the expected PMW frequency */
-	level = (bclp * max_backlight) / 255;
-	/* reserve the high 16 bits */
-	cpu_pwm_ctl &= ~(BACKLIGHT_DUTY_CYCLE_MASK);
-	/* write the updated PWM frequency */
-	I915_WRITE(BLC_PWM_CPU_CTL, cpu_pwm_ctl | level);
-
-	asle->cblv = (bclp*0x64)/0xff | ASLE_CBLV_VALID;
-
-	return 0;
-}
-
 void ironlake_opregion_gse_intr(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -296,7 +246,7 @@ void ironlake_opregion_gse_intr(struct drm_device *dev)
 	}
 
 	if (asle_req & ASLE_SET_BACKLIGHT)
-		asle_stat |= asle_set_backlight_ironlake(dev, asle->bclp);
+		asle_stat |= asle_set_backlight(dev, asle->bclp);
 
 	if (asle_req & ASLE_SET_PFIT) {
 		DRM_DEBUG_DRIVER("Pfit is not supported\n");
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index ad312ca..a0f870f 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -201,6 +201,9 @@ extern void intel_dvo_init(struct drm_device *dev);
 extern void intel_tv_init(struct drm_device *dev);
 extern void intel_mark_busy(struct drm_device *dev, struct drm_gem_object *obj);
 extern void intel_lvds_init(struct drm_device *dev);
+extern u32 intel_lvds_get_max_backlight(struct drm_device *dev);
+extern u32 intel_lvds_get_backlight(struct drm_device *dev);
+extern void intel_lvds_set_backlight(struct drm_device *dev, int level);
 extern void intel_dp_init(struct drm_device *dev, int dp_reg);
 void
 intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b819c10..0ab5891 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -39,6 +39,7 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 #include <linux/acpi.h>
+#include <linux/backlight.h>
 
 /* Private structure for the integrated LVDS support */
 struct intel_lvds {
@@ -54,42 +55,178 @@ static struct intel_lvds *enc_to_intel_lvds(struct drm_encoder *encoder)
 }
 
 /**
- * Sets the backlight level.
- *
- * \param level backlight level, from 0 to intel_lvds_get_max_backlight().
+ * Returns the maximum level of the backlight duty cycle field.
  */
-static void intel_lvds_set_backlight(struct drm_device *dev, int level)
+u32 intel_lvds_get_max_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 blc_pwm_ctl, reg;
+	u32 reg;
+	int value;
+	bool combo;
 
-	if (HAS_PCH_SPLIT(dev))
-		reg = BLC_PWM_CPU_CTL;
+	if (IS_I965G(dev))
+		combo = I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
+	else
+		combo = I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
+
+	if (IS_IRONLAKE(dev))
+		reg = BLC_PWM_PCH_CTL2;
 	else
 		reg = BLC_PWM_CTL;
 
-	blc_pwm_ctl = I915_READ(reg) & ~BACKLIGHT_DUTY_CYCLE_MASK;
-	I915_WRITE(reg, (blc_pwm_ctl |
-				 (level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
+	value = ((I915_READ(reg) & BACKLIGHT_MODULATION_FREQ_MASK) >>
+		 BACKLIGHT_MODULATION_FREQ_SHIFT);
+
+	if (!IS_PINEVIEW(dev))
+		value *= 2;
+
+	if (combo) {
+		value *= 0xff;
+		value /= 2;
+	}
+
+	return value;
 }
 
 /**
- * Returns the maximum level of the backlight duty cycle field.
+ * Returns the level of the backlight duty cycle field.
  */
-static u32 intel_lvds_get_max_backlight(struct drm_device *dev)
+u32 intel_lvds_get_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 reg;
+	u8 lbpc;
+	int value;
+	bool combo;
 
-	if (HAS_PCH_SPLIT(dev))
-		reg = BLC_PWM_PCH_CTL2;
+	if (IS_I965G(dev))
+		combo = I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
+	else
+		combo = I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
+
+	if (IS_IRONLAKE(dev))
+		reg = BLC_PWM_CPU_CTL;
+	else
+		reg = BLC_PWM_CTL;
+
+	value = I915_READ(reg) & BACKLIGHT_DUTY_CYCLE_MASK;
+
+	if (IS_PINEVIEW(dev))
+		value /= 2;
+
+	if (combo) {
+		value &= ~0x1;
+		pci_read_config_byte(dev->pdev, LBB, &lbpc);
+		value *= lbpc;
+		value /= 2;
+	}
+
+	return value;
+}
+
+/**
+ * Sets the backlight level.
+  *
+  * \param level backlight level, from 0 to intel_lvds_get_max_backlight().
+  */
+void intel_lvds_set_backlight(struct drm_device *dev, int level)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 blc_pwm_ctl, reg;
+	bool combo;
+	u8 lbpc;
+
+	if (IS_I965G(dev))
+		combo = I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
+	else
+		combo = I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
+
+	if (IS_IRONLAKE(dev))
+		reg = BLC_PWM_CPU_CTL;
 	else
 		reg = BLC_PWM_CTL;
 
-	return ((I915_READ(reg) & BACKLIGHT_MODULATION_FREQ_MASK) >>
-		BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+	if (combo) {
+		int maximum = intel_lvds_get_max_backlight(dev);
+		lbpc = level * 0xfe / maximum;
+		lbpc += 1;
+		pci_write_config_byte(dev->pdev, LBB, lbpc);
+		level /= lbpc;
+		level <<= 1;
+	}
+
+	if (IS_PINEVIEW(dev)) {
+		blc_pwm_ctl = I915_READ(reg) & ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
+		I915_WRITE(reg, (blc_pwm_ctl |
+			 (level << (BACKLIGHT_DUTY_CYCLE_SHIFT + 1))));
+	} else {
+		blc_pwm_ctl = I915_READ(reg) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+		I915_WRITE(reg, blc_pwm_ctl |
+		   (level << BACKLIGHT_DUTY_CYCLE_SHIFT));
+	}
 }
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+static int intel_lvds_update_status(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	intel_lvds_set_backlight(dev, bd->props.brightness);
+	return 0;
+}
+
+static int intel_lvds_get_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	return intel_lvds_get_backlight(dev);
+}
+
+static const struct backlight_ops intel_lvds_bl_ops = {
+	.update_status = intel_lvds_update_status,
+	.get_brightness = intel_lvds_get_brightness,
+};
+
+static int intel_lvds_backlight_setup(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
+
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = intel_lvds_get_max_backlight(dev);
+	dev_priv->backlight =
+		backlight_device_register("intel_backlight",
+					  &dev_priv->int_lvds_connector->kdev,
+					  dev,
+					  &intel_lvds_bl_ops,
+					  &props);
+
+	if (IS_ERR(dev_priv->backlight)) {
+		DRM_ERROR("Failed to register backlight: %ld\n",
+			  PTR_ERR(dev_priv->backlight));
+		dev_priv->backlight = NULL;
+		return -ENODEV;
+	}
+	dev_priv->backlight->props.brightness = intel_lvds_get_backlight(dev);
+	return 0;
+}
+
+static void intel_lvds_backlight_destroy(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	if (dev_priv->backlight)
+		backlight_device_unregister(dev_priv->backlight);
+}
+#else
+static int intel_lvds_backlight_setup(struct drm_device *dev)
+{
+	return 0;
+}
+
+static void intel_lvds_backlight_destroy(struct drm_device *dev)
+{
+	return;
+}
+#endif
+
 /**
  * Sets the power state for the panel.
  */
@@ -394,8 +531,7 @@ static void intel_lvds_prepare(struct drm_encoder *encoder)
 		reg = BLC_PWM_CTL;
 
 	dev_priv->saveBLC_PWM_CTL = I915_READ(reg);
-	dev_priv->backlight_duty_cycle = (dev_priv->saveBLC_PWM_CTL &
-				       BACKLIGHT_DUTY_CYCLE_MASK);
+	dev_priv->backlight_duty_cycle = intel_lvds_get_backlight(dev);
 
 	intel_lvds_set_power(dev, false);
 }
@@ -573,6 +709,8 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_lvds_backlight_destroy(dev);
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -992,6 +1130,9 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
+
+	intel_lvds_backlight_setup(dev);
+
 	return;
 
 failed:
-- 
1.7.2.1

