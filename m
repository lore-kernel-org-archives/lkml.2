Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1BPT1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:27:17 -0500
Received: from mout7.freenet.de ([195.4.92.97]:40867 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab1BPT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:27:14 -0500
Date: Wed, 16 Feb 2011 20:26:58 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix backlight brightness on intel LVDS panel after
	reopening lid
Message-ID: <20110216192658.GA7225@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>

---
Linus Torvalds, Wed, Feb 16, 2011 05:16:01 +0100:
> Most of the changes are pretty spread out and small, with drivers/gpu
> (radeon and i915) somewhat standing out from the pack. ... 

The backlight level on this Dell XPS M1330 reduces every time I reopen the
lid, and BIOS does not seem to know anything about that (the keyboard
shortcuts to set backlight brightness cause it to jump to the level next to
the one set before closing the lid).

Maybe i915 code for LVDS panels have lost some parts of the backlight
enable/disable balancing patch by Chris Wilson? Or maybe it just got broken
along the way...

This part of the patch by Chris helped here, but I afraid it might be not
complete or just wrong (for instance, the original patch didn't have to remove
the i915_read_blc_pwm_ctl function).

 drivers/gpu/drm/i915/intel_panel.c |   65 ++++++++++--------------------------
 1 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index c65992d..c4b1ca4 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -125,55 +125,15 @@ static int is_backlight_combination_mode(struct drm_device *dev)
 	return 0;
 }
 
-static u32 i915_read_blc_pwm_ctl(struct drm_i915_private *dev_priv)
-{
-	u32 val;
-
-	/* Restore the CTL value if it lost, e.g. GPU reset */
-
-	if (HAS_PCH_SPLIT(dev_priv->dev)) {
-		val = I915_READ(BLC_PWM_PCH_CTL2);
-		if (dev_priv->saveBLC_PWM_CTL2 == 0) {
-			dev_priv->saveBLC_PWM_CTL2 = val;
-		} else if (val == 0) {
-			I915_WRITE(BLC_PWM_PCH_CTL2,
-				   dev_priv->saveBLC_PWM_CTL);
-			val = dev_priv->saveBLC_PWM_CTL;
-		}
-	} else {
-		val = I915_READ(BLC_PWM_CTL);
-		if (dev_priv->saveBLC_PWM_CTL == 0) {
-			dev_priv->saveBLC_PWM_CTL = val;
-			dev_priv->saveBLC_PWM_CTL2 = I915_READ(BLC_PWM_CTL2);
-		} else if (val == 0) {
-			I915_WRITE(BLC_PWM_CTL,
-				   dev_priv->saveBLC_PWM_CTL);
-			I915_WRITE(BLC_PWM_CTL2,
-				   dev_priv->saveBLC_PWM_CTL2);
-			val = dev_priv->saveBLC_PWM_CTL;
-		}
-	}
-
-	return val;
-}
-
 u32 intel_panel_get_max_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 max;
 
-	max = i915_read_blc_pwm_ctl(dev_priv);
-	if (max == 0) {
-		/* XXX add code here to query mode clock or hardware clock
-		 * and program max PWM appropriately.
-		 */
-		printk_once(KERN_WARNING "fixme: max PWM is zero.\n");
-		return 1;
-	}
-
 	if (HAS_PCH_SPLIT(dev)) {
-		max >>= 16;
+		max = I915_READ(BLC_PWM_PCH_CTL2) >> 16;
 	} else {
+		max = I915_READ(BLC_PWM_CTL);
 		if (IS_PINEVIEW(dev)) {
 			max >>= 17;
 		} else {
@@ -186,6 +146,14 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
 			max *= 0xff;
 	}
 
+	if (max == 0) {
+		/* XXX add code here to query mode clock or hardware clock
+		 * and program max PWM appropriately.
+		 */
+		DRM_ERROR("fixme: max PWM is zero.\n");
+		max = 1;
+	}
+
 	DRM_DEBUG_DRIVER("max backlight PWM = %d\n", max);
 	return max;
 }
@@ -255,11 +223,11 @@ void intel_panel_disable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	if (dev_priv->backlight_enabled) {
-		dev_priv->backlight_level = intel_panel_get_backlight(dev);
-		dev_priv->backlight_enabled = false;
-	}
+	if (!dev_priv->backlight_enabled)
+		return;
 
+	dev_priv->backlight_enabled = false;
+	dev_priv->backlight_level = intel_panel_get_backlight(dev);
 	intel_panel_set_backlight(dev, 0);
 }
 
@@ -267,6 +235,9 @@ void intel_panel_enable_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	if (dev_priv->backlight_enabled)
+		return;
+
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
 
@@ -278,6 +249,6 @@ void intel_panel_setup_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	dev_priv->backlight_level = intel_panel_get_backlight(dev);
+	dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
 	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }
-- 
1.7.4.27.gf5729
