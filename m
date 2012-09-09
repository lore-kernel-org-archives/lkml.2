Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2IIXg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:36:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab2IIXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:51 -0400
Message-Id: <20120909224154.696258117@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Roberto Romer <sildurin@gmail.com>, Daniel Wagner <wagi@monom.org>,
        Keith Packard <keithp@keithp.com>
Subject: [ 28/95] drm/i915: reorder edp disabling to fix ivb MacBook Air
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 35a38556d900b9cb5dfa2529c93944b847f8a8a4 upstream.

eDP is tons of fun. It turns out that at least the new MacBook Air 5,1
model absolutely doesn't like the new force vdd dance we've introduced
in

commit 6cb49835da0426f69a2931bc2a0a8156344b0e41
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun May 20 17:14:50 2012 +0200

    drm/i915: enable vdd when switching off the eDP panel

But that patch also tried to fix some neat edp sequence issue with the
force_vdd timings. Closer inspection reveals that we've raised
force_vdd only to do the aux channel communication dp_sink_dpms. If we
move the edp_panel_off below that, we don't need any force_vdd for the
disable sequence, which makes the Air happy.

Unfortunately the reporter of the original bug that the above commit
fixed is travelling, so we can't test whether this regresses things.
But my theory is that since we don't check for any power-off ->
force_vdd-on delays in edp_panel_vdd_on, this was the actual
root-cause of this failure. With that force_vdd dance completely
eliminated, I'm hopeful the original bug stays fixed, too.

For reference the old bug, which hopefully doesn't get broken by this:

https://bugzilla.kernel.org/show_bug.cgi?id=43163

In any case, regression fixers win over plain bugfixes, so this needs
to go in asap.

v2: The crucial pieces seems to be to clear the force_vdd flag
uncoditionally, too, in edp_panel_off. Looks like this is left behind
by the firmware somehow.

v3: The Apple firmware seems to switch off the panel on it's own, hence
we still need to keep force_vdd on, but properly clear it when switching
the panel off.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45671
Tested-by: Roberto Romer <sildurin@gmail.com>
Tested-by: Daniel Wagner <wagi@monom.org>
Tested-by: Keith Packard <keithp@keithp.com>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dp.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 0a56b9a..a6c426a 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1174,10 +1174,14 @@ static void ironlake_edp_panel_off(struct intel_dp *intel_dp)
 	WARN(!intel_dp->want_panel_vdd, "Need VDD to turn off panel\n");
 
 	pp = ironlake_get_pp_control(dev_priv);
-	pp &= ~(POWER_TARGET_ON | PANEL_POWER_RESET | EDP_BLC_ENABLE);
+	/* We need to switch off panel power _and_ force vdd, for otherwise some
+	 * panels get very unhappy and cease to work. */
+	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
+	intel_dp->want_panel_vdd = false;
+
 	ironlake_wait_panel_off(intel_dp);
 }
 
@@ -1287,11 +1291,9 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 	 * ensure that we have vdd while we switch off the panel. */
 	ironlake_edp_panel_vdd_on(intel_dp);
 	ironlake_edp_backlight_off(intel_dp);
-	ironlake_edp_panel_off(intel_dp);
-
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+	ironlake_edp_panel_off(intel_dp);
 	intel_dp_link_down(intel_dp);
-	ironlake_edp_panel_vdd_off(intel_dp, false);
 }
 
 static void intel_dp_commit(struct drm_encoder *encoder)
@@ -1326,11 +1328,9 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		/* Switching the panel off requires vdd. */
 		ironlake_edp_panel_vdd_on(intel_dp);
 		ironlake_edp_backlight_off(intel_dp);
-		ironlake_edp_panel_off(intel_dp);
-
 		intel_dp_sink_dpms(intel_dp, mode);
+		ironlake_edp_panel_off(intel_dp);
 		intel_dp_link_down(intel_dp);
-		ironlake_edp_panel_vdd_off(intel_dp, false);
 
 		if (is_cpu_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);


