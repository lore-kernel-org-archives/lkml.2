Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1HFRyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:54:19 -0400
Received: from home.keithp.com ([63.227.221.253]:41187 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab1HFRyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:54:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/4] drm/i915: Wait for LVDS panel power sequence
Date: Sat,  6 Aug 2011 10:54:05 -0700
Message-Id: <1312653248-3487-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312653248-3487-1-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During mode setting, check to make sure the panel power sequencing has
completed before doing further operations on the device. This
uncovered errors with DPMS not turning the device off as it was left locked.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 2e8ddfc..6985e42 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -72,14 +72,16 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 {
 	struct drm_device *dev = intel_lvds->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 ctl_reg, lvds_reg;
+	u32 ctl_reg, lvds_reg, stat_reg;
 
 	if (HAS_PCH_SPLIT(dev)) {
 		ctl_reg = PCH_PP_CONTROL;
 		lvds_reg = PCH_LVDS;
+		stat_reg = PCH_PP_STATUS;
 	} else {
 		ctl_reg = PP_CONTROL;
 		lvds_reg = LVDS;
+		stat_reg = PP_STATUS;
 	}
 
 	I915_WRITE(lvds_reg, I915_READ(lvds_reg) | LVDS_PORT_EN);
@@ -105,6 +107,8 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
 
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
 	POSTING_READ(lvds_reg);
+	if (wait_for((I915_READ(stat_reg) & PP_ON) != 0, 1000))
+		DRM_ERROR("timed out waiting for panel to power on\n");
 
 	intel_panel_enable_backlight(dev);
 }
@@ -113,19 +117,24 @@ static void intel_lvds_disable(struct intel_lvds *intel_lvds)
 {
 	struct drm_device *dev = intel_lvds->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 ctl_reg, lvds_reg;
+	u32 ctl_reg, lvds_reg, stat_reg;
 
 	if (HAS_PCH_SPLIT(dev)) {
 		ctl_reg = PCH_PP_CONTROL;
 		lvds_reg = PCH_LVDS;
+		stat_reg = PCH_PP_STATUS;
 	} else {
 		ctl_reg = PP_CONTROL;
 		lvds_reg = LVDS;
+		stat_reg = PP_STATUS;
 	}
 
 	intel_panel_disable_backlight(dev);
 
 	I915_WRITE(ctl_reg, I915_READ(ctl_reg) & ~POWER_TARGET_ON);
+	if (wait_for((I915_READ(stat_reg) & PP_ON) == 0, 1000))
+		DRM_ERROR("timed out waiting for panel to power off status 0x%08x control 0x%08x\n",
+			  I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
 
 	if (intel_lvds->pfit_control) {
 		if (wait_for((I915_READ(PP_STATUS) & PP_ON) == 0, 1000))
-- 
1.7.5.4

