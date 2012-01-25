Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2AYQQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:16:43 -0500
Received: from home.keithp.com ([63.227.221.253]:33806 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AYQQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:16:41 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>,
        Lubos Kolouch <lubos.kolouch@gmail.com>,
        Adam Jackson <ajax@redhat.com>
Subject: [PATCH 1/2] drm/i915: Force explicit bpp selection for intel_dp_link_required
Date: Wed, 25 Jan 2012 08:16:25 -0800
Message-Id: <1327508186-26704-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327508186-26704-1-git-send-email-keithp@keithp.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is never correct to use intel_crtc->bpp in intel_dp_link_required,
so instead pass an explicit bpp in to this function. This patch
only supports 18bpp and 24bpp modes, which means that 10bpc modes will
be computed incorrectly. Fixing that will require more extensive
changes, and so must be addressed separately from this bugfix.

intel_dp_link_required is called from intel_dp_mode_valid and
intel_dp_mode_fixup.

* intel_dp_mode_valid is called to list supported modes; in this case,
  the current crtc values cannot be relevant as the modes in question
  may never be selected. Thus, using intel_crtc->bpp is never right.

* intel_dp_mode_fixup is called during mode setting, but it is run
  well before ironlake_crtc_mode_set is called to set intel_crtc->bpp,
  so using intel_crtc-bpp in this path can only ever get a stale
  value.

Cc: Lubos Kolouch <lubos.kolouch@gmail.com>
Cc: Adam Jackson <ajax@redhat.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index db3b461..94f860c 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -208,17 +208,8 @@ intel_dp_link_clock(uint8_t link_bw)
  */
 
 static int
-intel_dp_link_required(struct intel_dp *intel_dp, int pixel_clock, int check_bpp)
+intel_dp_link_required(int pixel_clock, int bpp)
 {
-	struct drm_crtc *crtc = intel_dp->base.base.crtc;
-	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
-	int bpp = 24;
-
-	if (check_bpp)
-		bpp = check_bpp;
-	else if (intel_crtc)
-		bpp = intel_crtc->bpp;
-
 	return (pixel_clock * bpp + 9) / 10;
 }
 
@@ -245,12 +236,11 @@ intel_dp_mode_valid(struct drm_connector *connector,
 			return MODE_PANEL;
 	}
 
-	mode_rate = intel_dp_link_required(intel_dp, mode->clock, 0);
+	mode_rate = intel_dp_link_required(mode->clock, 24);
 	max_rate = intel_dp_max_data_rate(max_link_clock, max_lanes);
 
 	if (mode_rate > max_rate) {
-			mode_rate = intel_dp_link_required(intel_dp,
-							   mode->clock, 18);
+			mode_rate = intel_dp_link_required(mode->clock, 18);
 			if (mode_rate > max_rate)
 				return MODE_CLOCK_HIGH;
 			else
@@ -683,7 +673,7 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 	int lane_count, clock;
 	int max_lane_count = intel_dp_max_lane_count(intel_dp);
 	int max_clock = intel_dp_max_link_bw(intel_dp) == DP_LINK_BW_2_7 ? 1 : 0;
-	int bpp = mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 0;
+	int bpp = mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
 	static int bws[2] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };
 
 	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
@@ -701,7 +691,7 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		for (clock = 0; clock <= max_clock; clock++) {
 			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
 
-			if (intel_dp_link_required(intel_dp, mode->clock, bpp)
+			if (intel_dp_link_required(mode->clock, bpp)
 					<= link_avail) {
 				intel_dp->link_bw = bws[clock];
 				intel_dp->lane_count = lane_count;
-- 
1.7.8.3

