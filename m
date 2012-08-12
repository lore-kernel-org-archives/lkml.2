Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2HLSWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 14:22:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36500 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2HLSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 14:22:02 -0400
Date: Sun, 12 Aug 2012 11:21:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Kamal Mostafa <kamal@canonical.com>, Carsten Emde <C.Emde@osadl.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: 3.6-rc1 breaks my laptop graphics (intel)
Message-ID: <20120812182157.GA1949@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.

The 3.6-rc1 kernel breaks my laptop, booting to a black screen when the
i915 driver initializes itself.  I bisected this down to commit
24ded204429fa0f5501d37c63ee35c555c0b75ee (drm/i915: properly enable the
blc controller on the right pipe), and when I revert that, and also
a4f32fc3a37e982fffce8ec583643990ff288419 (drm/i915: don't forget the PCH
backlight registers) which depended on the first patch, my laptop works
just fine.

Below is the combined revert.

Any thoughts?  Any patch I can try out?

thanks,

greg k-h

------
Subject: drm/i915: revert 24ded204429fa0f5501d37c63ee35c555c0b75ee and a4f32fc3a37e982fffce8ec583643990ff288419

24ded204429fa0f5501d37c63ee35c555c0b75ee (drm/i915: properly enable the
blc controller on the right pipe) breaks the boot for my laptop, so
revert it, and a4f32fc3a37e982fffce8ec583643990ff288419 (drm/i915: don't
forget the PCH backlight registers) which depended on it.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 8435355..4e786f2 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -383,8 +383,7 @@ extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
 extern int intel_panel_setup_backlight(struct drm_device *dev);
-extern void intel_panel_enable_backlight(struct drm_device *dev,
-					 enum pipe pipe);
+extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);
 extern void intel_panel_destroy_backlight(struct drm_device *dev);
 extern enum drm_connector_status intel_panel_detect(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index e05c0d3..6547904 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -71,7 +71,6 @@ static struct intel_lvds *intel_attached_lvds(struct drm_connector *connector)
 static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 {
 	struct drm_device *dev = intel_lvds->base.base.dev;
-	struct intel_crtc *intel_crtc = to_intel_crtc(intel_lvds->base.base.crtc);
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 ctl_reg, lvds_reg, stat_reg;
 
@@ -108,7 +107,7 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 	if (wait_for((I915_READ(stat_reg) & PP_ON) != 0, 1000))
 		DRM_ERROR("timed out waiting for panel to power on\n");
 
-	intel_panel_enable_backlight(dev, intel_crtc->pipe);
+	intel_panel_enable_backlight(dev);
 }
 
 static void intel_lvds_disable(struct intel_lvds *intel_lvds)
@@ -1079,14 +1078,35 @@ bool intel_lvds_init(struct drm_device *dev)
 		goto failed;
 
 out:
-	/*
-	 * Unlock registers and just
-	 * leave them unlocked
-	 */
 	if (HAS_PCH_SPLIT(dev)) {
+		u32 pwm;
+
+		pipe = (I915_READ(PCH_LVDS) & LVDS_PIPEB_SELECT) ? 1 : 0;
+
+		/* make sure PWM is enabled and locked to the LVDS pipe */
+		pwm = I915_READ(BLC_PWM_CPU_CTL2);
+		if (pipe == 0 && (pwm & BLM_PIPE_B))
+			I915_WRITE(BLC_PWM_CPU_CTL2, pwm & ~BLM_PWM_ENABLE);
+		if (pipe)
+			pwm |= BLM_PIPE_B;
+		else
+			pwm &= ~BLM_PIPE_B;
+		I915_WRITE(BLC_PWM_CPU_CTL2, pwm | BLM_PWM_ENABLE);
+
+		pwm = I915_READ(BLC_PWM_PCH_CTL1);
+		pwm |= BLM_PCH_PWM_ENABLE;
+		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
+		/*
+		 * Unlock registers and just
+		 * leave them unlocked
+		 */
 		I915_WRITE(PCH_PP_CONTROL,
 			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
 	} else {
+		/*
+		 * Unlock registers and just
+		 * leave them unlocked
+		 */
 		I915_WRITE(PP_CONTROL,
 			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
 	}
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 10c7d39..7180cc8 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -287,24 +287,9 @@ void intel_panel_disable_backlight(struct drm_device *dev)
 
 	dev_priv->backlight_enabled = false;
 	intel_panel_actually_set_backlight(dev, 0);
-
-	if (INTEL_INFO(dev)->gen >= 4) {
-		uint32_t reg, tmp;
-
-		reg = HAS_PCH_SPLIT(dev) ? BLC_PWM_CPU_CTL2 : BLC_PWM_CTL2;
-
-		I915_WRITE(reg, I915_READ(reg) & ~BLM_PWM_ENABLE);
-
-		if (HAS_PCH_SPLIT(dev)) {
-			tmp = I915_READ(BLC_PWM_PCH_CTL1);
-			tmp &= ~BLM_PCH_PWM_ENABLE;
-			I915_WRITE(BLC_PWM_PCH_CTL1, tmp);
-		}
-	}
 }
 
-void intel_panel_enable_backlight(struct drm_device *dev,
-				  enum pipe pipe)
+void intel_panel_enable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
@@ -313,40 +298,6 @@ void intel_panel_enable_backlight(struct drm_device *dev,
 
 	dev_priv->backlight_enabled = true;
 	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
-
-	if (INTEL_INFO(dev)->gen >= 4) {
-		uint32_t reg, tmp;
-
-		reg = HAS_PCH_SPLIT(dev) ? BLC_PWM_CPU_CTL2 : BLC_PWM_CTL2;
-
-
-		tmp = I915_READ(reg);
-
-		/* Note that this can also get called through dpms changes. And
-		 * we don't track the backlight dpms state, hence check whether
-		 * we have to do anything first. */
-		if (tmp & BLM_PWM_ENABLE)
-			return;
-
-		if (dev_priv->num_pipe == 3)
-			tmp &= ~BLM_PIPE_SELECT_IVB;
-		else
-			tmp &= ~BLM_PIPE_SELECT;
-
-		tmp |= BLM_PIPE(pipe);
-		tmp &= ~BLM_PWM_ENABLE;
-
-		I915_WRITE(reg, tmp);
-		POSTING_READ(reg);
-		I915_WRITE(reg, tmp | BLM_PWM_ENABLE);
-
-		if (HAS_PCH_SPLIT(dev)) {
-			tmp = I915_READ(BLC_PWM_PCH_CTL1);
-			tmp |= BLM_PCH_PWM_ENABLE;
-			tmp &= ~BLM_PCH_OVERRIDE_ENABLE;
-			I915_WRITE(BLC_PWM_PCH_CTL1, tmp);
-		}
-	}
 }
 
 static void intel_panel_init_backlight(struct drm_device *dev)
