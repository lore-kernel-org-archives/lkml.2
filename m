Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1I0GMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:13 -0400
Received: from home.keithp.com ([63.227.221.253]:55086 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1I0GML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
Date: Mon, 26 Sep 2011 23:11:43 -0700
Message-Id: <1317103906-4649-7-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCH refclk settings are global, so we need to look at all of the
encoders, not just the current encoder when deciding how to configure
it. Also, handle systems with more than one panel (any combination of
PCH/non-PCH eDP and LVDS).

Disable SSC clocks when no panels are connected.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |   96 +++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 6039496..f999935 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5113,31 +5113,32 @@ static void ironlake_update_pch_refclk(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_mode_config *mode_config = &dev->mode_config;
-	struct drm_crtc *crtc;
 	struct intel_encoder *encoder;
-	struct intel_encoder *has_edp_encoder = NULL;
 	u32 temp;
 	bool has_lvds = false;
+	bool has_cpu_edp = false;
+	bool has_pch_edp = false;
+	bool has_panel = false;
 
 	/* We need to take the global config into account */
-	list_for_each_entry(crtc, &mode_config->crtc_list, head) {
-		if (!crtc->enabled)
-			continue;
-
-		list_for_each_entry(encoder, &mode_config->encoder_list,
-				    base.head) {
-			if (encoder->base.crtc != crtc)
-				continue;
-
-			switch (encoder->type) {
-			case INTEL_OUTPUT_LVDS:
-				has_lvds = true;
-			case INTEL_OUTPUT_EDP:
-				has_edp_encoder = encoder;
-				break;
-			}
+	list_for_each_entry(encoder, &mode_config->encoder_list,
+			    base.head) {
+		switch (encoder->type) {
+		case INTEL_OUTPUT_LVDS:
+			has_panel = true;
+			has_lvds = true;
+			break;
+		case INTEL_OUTPUT_EDP:
+			has_panel = true;
+			if (intel_encoder_is_pch_edp(&encoder->base))
+				has_pch_edp = true;
+			else
+				has_cpu_edp = true;
+			break;
 		}
 	}
+	DRM_DEBUG_KMS("has_panel %d has_lvds %d has_pch_edp %d has_cpu_edp %d\n",
+		      has_panel, has_lvds, has_pch_edp, has_cpu_edp);
 
 	/* Ironlake: try to setup display ref clock before DPLL
 	 * enabling. This is only under driver's control after
@@ -5148,36 +5149,57 @@ static void ironlake_update_pch_refclk(struct drm_device *dev)
 	/* Always enable nonspread source */
 	temp &= ~DREF_NONSPREAD_SOURCE_MASK;
 	temp |= DREF_NONSPREAD_SOURCE_ENABLE;
-	temp &= ~DREF_SSC_SOURCE_MASK;
-	temp |= DREF_SSC_SOURCE_ENABLE;
-	I915_WRITE(PCH_DREF_CONTROL, temp);
 
-	POSTING_READ(PCH_DREF_CONTROL);
-	udelay(200);
+	if (has_panel) {
+		temp &= ~DREF_SSC_SOURCE_MASK;
+		temp |= DREF_SSC_SOURCE_ENABLE;
 
-	if (has_edp_encoder) {
+		/* SSC must be turned on before enabling the CPU output  */
 		if (intel_panel_use_ssc(dev_priv)) {
+			DRM_DEBUG_KMS("Using SSC on panel\n");
 			temp |= DREF_SSC1_ENABLE;
-			I915_WRITE(PCH_DREF_CONTROL, temp);
-
-			POSTING_READ(PCH_DREF_CONTROL);
-			udelay(200);
 		}
+
+		/* Get SSC going before enabling the outputs */
+		I915_WRITE(PCH_DREF_CONTROL, temp);
+		POSTING_READ(PCH_DREF_CONTROL);
+		udelay(200);
+
 		temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
 
 		/* Enable CPU source on CPU attached eDP */
-		if (!intel_encoder_is_pch_edp(&has_edp_encoder->base)) {
-			if (intel_panel_use_ssc(dev_priv))
+		if (has_cpu_edp) {
+			if (intel_panel_use_ssc(dev_priv)) {
+				DRM_DEBUG_KMS("Using SSC on eDP\n");
 				temp |= DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
+			}
 			else
 				temp |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
-		} else {
-			/* Enable SSC on PCH eDP if needed */
-			if (intel_panel_use_ssc(dev_priv)) {
-				DRM_ERROR("enabling SSC on PCH\n");
-				temp |= DREF_SUPERSPREAD_SOURCE_ENABLE;
-			}
-		}
+		} else
+			temp |= DREF_CPU_SOURCE_OUTPUT_DISABLE;
+
+		I915_WRITE(PCH_DREF_CONTROL, temp);
+		POSTING_READ(PCH_DREF_CONTROL);
+		udelay(200);
+	} else {
+		DRM_DEBUG_KMS("Disabling SSC entirely\n");
+
+		temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
+
+		/* Turn off CPU output */
+		temp |= DREF_CPU_SOURCE_OUTPUT_DISABLE;
+
+		I915_WRITE(PCH_DREF_CONTROL, temp);
+		POSTING_READ(PCH_DREF_CONTROL);
+		udelay(200);
+
+		/* Turn off the SSC source */
+		temp &= ~DREF_SSC_SOURCE_MASK;
+		temp |= DREF_SSC_SOURCE_DISABLE;
+
+		/* Turn off SSC1 */
+		temp &= ~ DREF_SSC1_ENABLE;
+
 		I915_WRITE(PCH_DREF_CONTROL, temp);
 		POSTING_READ(PCH_DREF_CONTROL);
 		udelay(200);
-- 
1.7.6.3

