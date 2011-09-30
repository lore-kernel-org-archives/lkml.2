Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab1I3BN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:13:27 -0400
Received: from home.keithp.com ([63.227.221.253]:49860 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab1I3BKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 13/21] drm/i915: Place long delays after each eDP VDD operation
Date: Thu, 29 Sep 2011 18:09:45 -0700
Message-Id: <1317344993-24945-14-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that the panel power sequencing is complete before
attempting to communicate over the aux channel.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index a091a18..fbc19e4 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -842,12 +842,15 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 
 	if (!is_edp(intel_dp))
 		return;
+	DRM_DEBUG_KMS("Turn eDP VDD on\n");
 	/*
 	 * If the panel wasn't on, make sure there's not a currently
 	 * active PP sequence before enabling AUX VDD.
 	 */
-	if (!(I915_READ(PCH_PP_STATUS) & PP_ON))
+	if (!(I915_READ(PCH_PP_STATUS) & PP_ON)) {
+		DRM_DEBUG_KMS("eDP VDD was not on\n");
 		msleep(dev_priv->panel_t3);
+	}
 
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
@@ -855,6 +858,9 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	pp |= EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
+	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
+		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
+	msleep(1000);
 }
 
 static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
@@ -865,6 +871,7 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 
 	if (!is_edp(intel_dp))
 		return;
+	DRM_DEBUG_KMS("Turn eDP VDD off\n");
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -874,6 +881,9 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 
 	/* Make sure sequencer is idle before allowing subsequent activity */
 	msleep(dev_priv->panel_t12);
+	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
+		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
+	msleep(1000);
 }
 
 /* Returns true if the panel was already on when called */
-- 
1.7.6.3

