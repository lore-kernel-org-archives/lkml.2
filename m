Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2HTD61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:58:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2HTD6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roberto Romer <sildurin@gmail.com>, Daniel Wagner <wagi@monom.org>,
        Keith Packard <keithp@keithp.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 10/32] drm/i915: reorder edp disabling to fix ivb MacBook Air
Date: Sun, 19 Aug 2012 20:57:06 -0700
Message-Id: <20120820035649.314128442@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1156,10 +1156,14 @@ static void ironlake_edp_panel_off(struc
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
 
@@ -1269,11 +1273,9 @@ static void intel_dp_prepare(struct drm_
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
@@ -1308,11 +1310,9 @@ intel_dp_dpms(struct drm_encoder *encode
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


