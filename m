Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab2FGEWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:22:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab2FGEWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:10 -0400
Message-Id: <20120607040348.515747863@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:58 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vincent Frentzel <zcecc22@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 82/82] drm/i915: enable vdd when switching off the eDP panel
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1148,11 +1148,10 @@ static void ironlake_edp_panel_off(struc
 
 	DRM_DEBUG_KMS("Turn eDP power off\n");
 
-	WARN(intel_dp->want_panel_vdd, "Cannot turn power off while VDD is on\n");
-	ironlake_panel_vdd_off_sync(intel_dp); /* finish any pending work */
+	WARN(!intel_dp->want_panel_vdd, "Need VDD to turn off panel\n");
 
 	pp = ironlake_get_pp_control(dev_priv);
-	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);
+	pp &= ~(POWER_TARGET_ON | PANEL_POWER_RESET | EDP_BLC_ENABLE);
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
@@ -1260,18 +1259,16 @@ static void intel_dp_prepare(struct drm_
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
@@ -1303,10 +1300,11 @@ intel_dp_dpms(struct drm_encoder *encode
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


