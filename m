Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745Ab2FHFKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:10:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761154Ab2FHFHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:34 -0400
Message-Id: <20120608041842.237707277@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Vincent Frentzel <zcecc22@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 10/82] drm/i915: enable vdd when switching off the eDP panel
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6cb49835da0426f69a2931bc2a0a8156344b0e41 upstream.

We have one bug report from a validation team that we get the eDP
panel sequencing still somewhat wrong: We need to enable VDD while
switching off the panel and backlight. Unfortunately that reporter
seems to have fallen off the earth :(

For another reporter this actually fixes a black panel issue because
without this the backlight/panel gets confused and doesn't light up
again.

v2: I've forgotten to remove the vdd_off call in panel_off which is
now bogus. This essentially reverts

commit 17038de5f16569a25343cf68668f3b657eafb00e
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Apr 16 22:43:42 2012 +0100

    drm/i915/dp: Flush any outstanding work to turn the VDD off

v3: the current panel_off code forces off the vdd power, too. Which is
bogus and resulted in some funny warnings later on when we've tried to
do aux channel communications with just the vdd forced on. Fix this,
too.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=46312
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43163
Tested-by: Vincent Frentzel <zcecc22@gmail.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: nothing to revert here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dp.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1149,10 +1149,10 @@
 
 	DRM_DEBUG_KMS("Turn eDP power off\n");
 
-	WARN(intel_dp->want_panel_vdd, "Cannot turn power off while VDD is on\n");
+	WARN(!intel_dp->want_panel_vdd, "Need VDD to turn off panel\n");
 
 	pp = ironlake_get_pp_control(dev_priv);
-	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);
+	pp &= ~(POWER_TARGET_ON | PANEL_POWER_RESET | EDP_BLC_ENABLE);
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
@@ -1260,18 +1260,16 @@
 {
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
+
+	/* Make sure the panel is off before trying to change the mode. But also
+	 * ensure that we have vdd while we switch off the panel. */
+	ironlake_edp_panel_vdd_on(intel_dp);
 	ironlake_edp_backlight_off(intel_dp);
 	ironlake_edp_panel_off(intel_dp);
 
-	/* Wake up the sink first */
-	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
 	intel_dp_link_down(intel_dp);
 	ironlake_edp_panel_vdd_off(intel_dp, false);
-
-	/* Make sure the panel is off before trying to
-	 * change the mode
-	 */
 }
 
 static void intel_dp_commit(struct drm_encoder *encoder)
@@ -1303,10 +1301,11 @@
 	uint32_t dp_reg = I915_READ(intel_dp->output_reg);
 
 	if (mode != DRM_MODE_DPMS_ON) {
+		/* Switching the panel off requires vdd. */
+		ironlake_edp_panel_vdd_on(intel_dp);
 		ironlake_edp_backlight_off(intel_dp);
 		ironlake_edp_panel_off(intel_dp);
 
-		ironlake_edp_panel_vdd_on(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
 		ironlake_edp_panel_vdd_off(intel_dp, false);


