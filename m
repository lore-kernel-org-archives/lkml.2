Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1I3BKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:23 -0400
Received: from home.keithp.com ([63.227.221.253]:49855 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1I3BKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 07/21] drm/i915: Check for eDP inside intel_edp_panel_vdd_on/off
Date: Thu, 29 Sep 2011 18:09:39 -0700
Message-Id: <1317344993-24945-8-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleans up code dealing with eDP VDD a bit.  Remove redundant checks in
callers

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index a983d0f..da725d8 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -832,6 +832,8 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
 
+	if (!is_edp(intel_dp))
+		return;
 	/*
 	 * If the panel wasn't on, make sure there's not a currently
 	 * active PP sequence before enabling AUX VDD.
@@ -853,6 +855,8 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
 
+	if (!is_edp(intel_dp))
+		return;
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -1034,15 +1038,13 @@ static void intel_dp_commit(struct drm_encoder *encoder)
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 	struct drm_device *dev = encoder->dev;
 
-	if (is_edp(intel_dp))
-		ironlake_edp_panel_vdd_on(intel_dp);
+	ironlake_edp_panel_vdd_on(intel_dp);
 
 	intel_dp_start_link_train(intel_dp);
 
-	if (is_edp(intel_dp)) {
+	if (is_edp(intel_dp))
 		ironlake_edp_panel_on(intel_dp);
-		ironlake_edp_panel_vdd_off(intel_dp);
-	}
+	ironlake_edp_panel_vdd_off(intel_dp);
 
 	intel_dp_complete_link_train(intel_dp);
 
@@ -1070,15 +1072,13 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);
 	} else {
-		if (is_edp(intel_dp))
-			ironlake_edp_panel_vdd_on(intel_dp);
+		ironlake_edp_panel_vdd_on(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		if (!(dp_reg & DP_PORT_EN)) {
 			intel_dp_start_link_train(intel_dp);
-			if (is_edp(intel_dp)) {
+			if (is_edp(intel_dp))
 				ironlake_edp_panel_on(intel_dp);
-				ironlake_edp_panel_vdd_off(intel_dp);
-			}
+			ironlake_edp_panel_vdd_off(intel_dp);
 			intel_dp_complete_link_train(intel_dp);
 		}
 		if (is_edp(intel_dp))
-- 
1.7.6.3

