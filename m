Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1HFRyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:54:52 -0400
Received: from home.keithp.com ([63.227.221.253]:41194 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab1HFRyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:54:18 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
Date: Sat,  6 Aug 2011 10:54:06 -0700
Message-Id: <1312653248-3487-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312653248-3487-1-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to relock them; it just makes operations more
complex. This fixes DPMS where the panel registers were locked making
the disable not work.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   46 +++++++++++++++---------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 6985e42..cc85618 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -414,46 +414,32 @@ static void intel_lvds_prepare(struct drm_encoder *encoder)
 	/* We try to do the minimum that is necessary in order to unlock
 	 * the registers for mode setting.
 	 *
-	 * On Ironlake, this is quite simple as we just set the unlock key
-	 * and ignore all subtleties. (This may cause some issues...)
+	 * On Ironlake, this is quite simple as we just set the unlock
+	 * key in the driver init code and ignore all subtleties.
+	 * (This may cause some issues...)
 	 *
 	 * Prior to Ironlake, we must disable the pipe if we want to adjust
 	 * the panel fitter. However at all other times we can just reset
 	 * the registers regardless.
 	 */
 
-	if (HAS_PCH_SPLIT(dev)) {
-		I915_WRITE(PCH_PP_CONTROL,
-			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
-	} else if (intel_lvds->pfit_dirty) {
-		I915_WRITE(PP_CONTROL,
-			   (I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS)
-			   & ~POWER_TARGET_ON);
-	} else {
-		I915_WRITE(PP_CONTROL,
-			   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
+	if (!HAS_PCH_SPLIT(dev)) {
+		if (intel_lvds->pfit_dirty) {
+			I915_WRITE(PP_CONTROL,
+				   (I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS)
+				   & ~POWER_TARGET_ON);
+		} else {
+			I915_WRITE(PP_CONTROL,
+				   I915_READ(PP_CONTROL) | PANEL_UNLOCK_REGS);
+		}
 	}
+	intel_lvds_disable(intel_lvds);
 }
 
 static void intel_lvds_commit(struct drm_encoder *encoder)
 {
-	struct drm_device *dev = encoder->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
 
-	/* Undo any unlocking done in prepare to prevent accidental
-	 * adjustment of the registers.
-	 */
-	if (HAS_PCH_SPLIT(dev)) {
-		u32 val = I915_READ(PCH_PP_CONTROL);
-		if ((val & PANEL_UNLOCK_REGS) == PANEL_UNLOCK_REGS)
-			I915_WRITE(PCH_PP_CONTROL, val & 0x3);
-	} else {
-		u32 val = I915_READ(PP_CONTROL);
-		if ((val & PANEL_UNLOCK_REGS) == PANEL_UNLOCK_REGS)
-			I915_WRITE(PP_CONTROL, val & 0x3);
-	}
-
 	/* Always do a full power on as we do not know what state
 	 * we were left in.
 	 */
@@ -1049,6 +1035,12 @@ out:
 		pwm = I915_READ(BLC_PWM_PCH_CTL1);
 		pwm |= PWM_PCH_ENABLE;
 		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
+		/*
+		 * Unlock registers and just
+		 * leave them unlocked
+		 */
+		I915_WRITE(PCH_PP_CONTROL,
+			   I915_READ(PCH_PP_CONTROL) | PANEL_UNLOCK_REGS);
 	}
 	dev_priv->lid_notifier.notifier_call = intel_lid_notify;
 	if (acpi_lid_notifier_register(&dev_priv->lid_notifier)) {
-- 
1.7.5.4

