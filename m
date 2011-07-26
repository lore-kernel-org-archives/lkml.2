Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1GZGgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:36:49 -0400
Received: from home.keithp.com ([63.227.221.253]:48622 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1GZGgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:43 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 3/5] drm/i915: In intel_dp_init, replace read of DPCD with intel_dp_get_dpcd
Date: Mon, 25 Jul 2011 23:36:32 -0700
Message-Id: <1311662194-4050-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminates an open-coded read and also gains the retry behaviour of
intel_dp_get_dpcd, which seems like a good idea.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 41674e1..9f134d2 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2015,7 +2015,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 
 	/* Cache some DPCD data in the eDP case */
 	if (is_edp(intel_dp)) {
-		int ret;
+		bool ret;
 		u32 pp_on, pp_div;
 
 		pp_on = I915_READ(PCH_PP_ON_DELAYS);
@@ -2028,11 +2028,9 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		dev_priv->panel_t12 *= 100; /* t12 in 100ms units */
 
 		ironlake_edp_panel_vdd_on(intel_dp);
-		ret = intel_dp_aux_native_read(intel_dp, DP_DPCD_REV,
-					       intel_dp->dpcd,
-					       sizeof(intel_dp->dpcd));
+		ret = intel_dp_get_dpcd(intel_dp);
 		ironlake_edp_panel_vdd_off(intel_dp);
-		if (ret == sizeof(intel_dp->dpcd)) {
+		if (ret) {
 			if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11)
 				dev_priv->no_aux_handshake =
 					intel_dp->dpcd[DP_MAX_DOWNSPREAD] &
-- 
1.7.5.4

