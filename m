Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1CKBfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:35:50 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:57723 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1CKBfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:35:48 -0500
Message-ID: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
Date: Fri, 11 Mar 2011 02:35:45 +0100 (CET)
Subject: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
From: "Indan Zupancic" <indan@nul.nu>
To: "Keith Packard" <keithp@keithp.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 4c1f0696016754537de762f13eb96caa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm/i915: Fix DPMS and suspend interaction for intel_panel.c

When suspending intel_panel_disable_backlight() is never called,
but intel_panel_enable_backlight() is called at resume. With the
effect that if the brightness was ever changed after screen
blanking, the wrong brightness gets restored at resume time.

Nothing guarantees that those calls will be balanced, so having
backlight_enabled makes no sense, as the real state can change
without the panel code noticing. So keep things as stateless as
possible.

Signed-off-by: Indan Zupancic <indan@nul.nu>

---

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 456f404..4a3d9ed 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -333,7 +333,6 @@ typedef struct drm_i915_private {

 	/* LVDS info */
 	int backlight_level;  /* restore backlight to this value */
-	bool backlight_enabled;
 	struct drm_display_mode *panel_fixed_mode;
 	struct drm_display_mode *lfp_lvds_vbt_mode; /* if any */
 	struct drm_display_mode *sdvo_lvds_vbt_mode; /* if any */
@@ -1220,10 +1219,6 @@ void i915_debugfs_cleanup(struct drm_minor *minor);
 extern int i915_save_state(struct drm_device *dev);
 extern int i915_restore_state(struct drm_device *dev);

-/* i915_suspend.c */
-extern int i915_save_state(struct drm_device *dev);
-extern int i915_restore_state(struct drm_device *dev);
-
 /* intel_i2c.c */
 extern int intel_setup_gmbus(struct drm_device *dev);
 extern void intel_teardown_gmbus(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 49fb54f..1b5a32d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5924,8 +5924,6 @@ static void intel_setup_outputs(struct drm_device *dev)
 		encoder->base.possible_clones =
 			intel_encoder_clones(dev, encoder->clone_mask);
 	}
-
-	intel_panel_setup_backlight(dev);
 }

 static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 2c43104..70e8b82 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -257,7 +257,6 @@ extern void intel_pch_panel_fitting(struct drm_device *dev,
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
-extern void intel_panel_setup_backlight(struct drm_device *dev);
 extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index d860abe..b05631a 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -217,12 +255,11 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 void intel_panel_disable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 level = intel_panel_get_backlight(dev);

-	if (dev_priv->backlight_enabled) {
-		dev_priv->backlight_level = intel_panel_get_backlight(dev);
-		dev_priv->backlight_enabled = false;
-	}
-
+	if (level == 0)
+		return;
+	dev_priv->backlight_level = level;
 	intel_panel_set_backlight(dev, 0);
 }

@@ -230,17 +267,9 @@ void intel_panel_enable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;

+	if (intel_panel_get_backlight(dev))
+		return;
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
-
 	intel_panel_set_backlight(dev, dev_priv->backlight_level);
-	dev_priv->backlight_enabled = true;
-}
-
-void intel_panel_setup_backlight(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	dev_priv->backlight_level = intel_panel_get_backlight(dev);
-	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }


