Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1I3BOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:14:17 -0400
Received: from home.keithp.com ([63.227.221.253]:49833 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab1I3BKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 17/21] drm/i915: Create helper functions to determine eDP power state
Date: Thu, 29 Sep 2011 18:09:49 -0700
Message-Id: <1317344993-24945-18-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check eDP VDD force and panel on in several places, so
create some simple helper functions to avoid duplicating code.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 56146a2..c7ccb46 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -280,20 +280,34 @@ intel_hrawclk(struct drm_device *dev)
 	}
 }
 
+static bool ironlake_edp_have_panel_power(struct intel_dp *intel_dp)
+{
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	return (I915_READ(PCH_PP_STATUS) & PP_ON) != 0;
+}
+
+static bool ironlake_edp_have_panel_vdd(struct intel_dp *intel_dp)
+{
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	return (I915_READ(PCH_PP_CONTROL) & EDP_FORCE_VDD) != 0;
+}
+
 static void
 intel_dp_check_edp(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp_status, pp_control;
+
 	if (!is_edp(intel_dp))
 		return;
-	pp_status = I915_READ(PCH_PP_STATUS);
-	pp_control = I915_READ(PCH_PP_CONTROL);
-	if ((pp_status & PP_ON) == 0 && (pp_control & EDP_FORCE_VDD) == 0) {
+	if (!ironlake_edp_have_panel_power(intel_dp) && !ironlake_edp_have_panel_vdd(intel_dp)) {
 		WARN(1, "eDP powered off while attempting aux channel communication.\n");
 		DRM_DEBUG_KMS("Status 0x%08x Control 0x%08x\n",
-			      pp_status,
+			      I915_READ(PCH_PP_STATUS),
 			      I915_READ(PCH_PP_CONTROL));
 	}
 }
@@ -838,16 +852,11 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp, pp_status;
+	u32 pp;
 
 	if (!is_edp(intel_dp))
 		return;
 	DRM_DEBUG_KMS("Turn eDP VDD on\n");
-	/*
-	 * If the panel wasn't on, make sure there's not a currently
-	 * active PP sequence before enabling AUX VDD.
-	 */
-	pp_status = I915_READ(PCH_PP_STATUS);
 
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
@@ -857,7 +866,11 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	POSTING_READ(PCH_PP_CONTROL);
 	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
-	if (!(pp_status & PP_ON)) {
+
+	/*
+	 * If the panel wasn't on, delay before accessing aux channel
+	 */
+	if (!ironlake_edp_have_panel_power(intel_dp)) {
 		msleep(intel_dp->panel_power_up_delay);
 		DRM_DEBUG_KMS("eDP VDD was not on\n");
 	}
@@ -892,7 +905,7 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_on_mask = PP_ON | PP_SEQUENCE_STATE_ON_IDLE;
 
-	if (I915_READ(PCH_PP_STATUS) & PP_ON)
+	if (ironlake_edp_have_panel_power(intel_dp))
 		return;
 
 	pp = I915_READ(PCH_PP_CONTROL);
-- 
1.7.6.3

