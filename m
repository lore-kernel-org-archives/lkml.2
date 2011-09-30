Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1I3BKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:34 -0400
Received: from home.keithp.com ([63.227.221.253]:49891 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab1I3BKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:30 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 20/21] drm/i915: Restrict ILK-specific eDP power hack to ILK
Date: Thu, 29 Sep 2011 18:09:52 -0700
Message-Id: <1317344993-24945-21-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates a fairly long delay when power sequencing newer
hardware

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   51 +++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 7120ba7..f223504 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -986,10 +986,12 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
 
-	/* ILK workaround: disable reset around power sequence */
-	pp &= ~PANEL_POWER_RESET;
-	I915_WRITE(PCH_PP_CONTROL, pp);
-	POSTING_READ(PCH_PP_CONTROL);
+	if (IS_GEN5(dev)) {
+		/* ILK workaround: disable reset around power sequence */
+		pp &= ~PANEL_POWER_RESET;
+		I915_WRITE(PCH_PP_CONTROL, pp);
+		POSTING_READ(PCH_PP_CONTROL);
+	}
 
 	pp |= POWER_TARGET_ON;
 	I915_WRITE(PCH_PP_CONTROL, pp);
@@ -1000,9 +1002,11 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 		DRM_ERROR("panel on wait timed out: 0x%08x\n",
 			  I915_READ(PCH_PP_STATUS));
 
-	pp |= PANEL_POWER_RESET; /* restore panel reset bit */
-	I915_WRITE(PCH_PP_CONTROL, pp);
-	POSTING_READ(PCH_PP_CONTROL);
+	if (IS_GEN5(dev)) {
+		pp |= PANEL_POWER_RESET; /* restore panel reset bit */
+		I915_WRITE(PCH_PP_CONTROL, pp);
+		POSTING_READ(PCH_PP_CONTROL);
+	}
 }
 
 static void ironlake_edp_panel_off_sync(struct intel_dp *intel_dp)
@@ -1019,23 +1023,28 @@ static void ironlake_edp_panel_off_sync(struct intel_dp *intel_dp)
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
 
-	/* ILK workaround: disable reset around power sequence */
-	pp &= ~PANEL_POWER_RESET;
-	I915_WRITE(PCH_PP_CONTROL, pp);
-	POSTING_READ(PCH_PP_CONTROL);
+	if (IS_GEN5(dev)) {
+		/* ILK workaround: disable reset around power sequence */
+		pp &= ~PANEL_POWER_RESET;
+		I915_WRITE(PCH_PP_CONTROL, pp);
+		POSTING_READ(PCH_PP_CONTROL);
+	}
 
-	pp &= ~POWER_TARGET_ON;
-	I915_WRITE(PCH_PP_CONTROL, pp);
-	POSTING_READ(PCH_PP_CONTROL);
+	intel_dp->panel_off_jiffies = jiffies;
 
-	if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
-		DRM_ERROR("panel off wait timed out: 0x%08x\n",
-			  I915_READ(PCH_PP_STATUS));
+	if (IS_GEN5(dev)) {
+		pp &= ~POWER_TARGET_ON;
+		I915_WRITE(PCH_PP_CONTROL, pp);
+		POSTING_READ(PCH_PP_CONTROL);
 
-	pp |= PANEL_POWER_RESET; /* restore panel reset bit */
-	I915_WRITE(PCH_PP_CONTROL, pp);
-	POSTING_READ(PCH_PP_CONTROL);
-	intel_dp->panel_off_jiffies = jiffies;
+		if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
+			DRM_ERROR("panel off wait timed out: 0x%08x\n",
+				  I915_READ(PCH_PP_STATUS));
+
+		pp |= PANEL_POWER_RESET; /* restore panel reset bit */
+		I915_WRITE(PCH_PP_CONTROL, pp);
+		POSTING_READ(PCH_PP_CONTROL);
+	}
 }
 
 static void ironlake_edp_panel_off(struct drm_encoder *encoder, bool sync)
-- 
1.7.6.3

