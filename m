Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1BPA2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:28:51 -0500
Received: from kroah.org ([198.145.64.141]:49911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732Ab1BPAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:51 2011
Message-Id: <20110216001450.965208429@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [259/272] drm/i915/panel: Only record the backlight level when it is enabled
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 47356eb67285014527a5ab87543ba1fae3d1e10a upstream.

By tracking the current status of the backlight we can prevent recording
the value of the current backlight when we have disabled it. And so
prevent restoring it to 'off' after an unbalanced sequence of
intel_lvds_disable/enable.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=22672
Tested-by: Alex Riesen <raa.lkml@gmail.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    2 ++
 drivers/gpu/drm/i915/intel_drv.h     |    3 +++
 drivers/gpu/drm/i915/intel_lvds.c    |   10 ++--------
 drivers/gpu/drm/i915/intel_panel.c   |   31 +++++++++++++++++++++++++++++++
 5 files changed, 39 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -329,6 +329,7 @@ typedef struct drm_i915_private {
 
 	/* LVDS info */
 	int backlight_level;  /* restore backlight to this value */
+	bool backlight_enabled;
 	struct drm_display_mode *panel_fixed_mode;
 	struct drm_display_mode *lfp_lvds_vbt_mode; /* if any */
 	struct drm_display_mode *sdvo_lvds_vbt_mode; /* if any */
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5498,6 +5498,8 @@ static void intel_setup_outputs(struct d
 		encoder->base.possible_clones =
 			intel_encoder_clones(dev, encoder->clone_mask);
 	}
+
+	intel_panel_setup_backlight(dev);
 }
 
 static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -256,6 +256,9 @@ extern void intel_pch_panel_fitting(stru
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
+extern void intel_panel_setup_backlight(struct drm_device *dev);
+extern void intel_panel_enable_backlight(struct drm_device *dev);
+extern void intel_panel_disable_backlight(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_encoder_prepare (struct drm_encoder *encoder);
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -106,7 +106,7 @@ static void intel_lvds_enable(struct int
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
 	POSTING_READ(lvds_reg);
 
-	intel_panel_set_backlight(dev, dev_priv->backlight_level);
+	intel_panel_enable_backlight(dev);
 }
 
 static void intel_lvds_disable(struct intel_lvds *intel_lvds)
@@ -123,8 +123,7 @@ static void intel_lvds_disable(struct in
 		lvds_reg = LVDS;
 	}
 
-	dev_priv->backlight_level = intel_panel_get_backlight(dev);
-	intel_panel_set_backlight(dev, 0);
+	intel_panel_disable_backlight(dev);
 
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) & ~POWER_TARGET_ON);
 
@@ -395,8 +394,6 @@ static void intel_lvds_prepare(struct dr
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
 
-	dev_priv->backlight_level = intel_panel_get_backlight(dev);
-
 	/* We try to do the minimum that is necessary in order to unlock
 	 * the registers for mode setting.
 	 *
@@ -427,9 +424,6 @@ static void intel_lvds_commit(struct drm
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
 
-	if (dev_priv->backlight_level == 0)
-		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
-
 	/* Undo any unlocking done in prepare to prevent accidental
 	 * adjustment of the registers.
 	 */
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -218,3 +218,34 @@ void intel_panel_set_backlight(struct dr
 		tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
 }
+
+void intel_panel_disable_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (dev_priv->backlight_enabled) {
+		dev_priv->backlight_level = intel_panel_get_backlight(dev);
+		dev_priv->backlight_enabled = false;
+	}
+
+	intel_panel_set_backlight(dev, 0);
+}
+
+void intel_panel_enable_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (dev_priv->backlight_level == 0)
+		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+
+	intel_panel_set_backlight(dev, dev_priv->backlight_level);
+	dev_priv->backlight_enabled = true;
+}
+
+void intel_panel_setup_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
+}


