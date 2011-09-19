Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab1ISWXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:23:22 -0400
Received: from home.keithp.com ([63.227.221.253]:41890 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab1ISWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:24 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 5/9] drm/i915: Unlock PCH_PP_CONTROL always
Date: Mon, 19 Sep 2011 15:21:59 -0700
Message-Id: <1316470923-27832-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid any question about locked registers by just writing the unlock
pattern with every write to the register.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h |    1 +
 drivers/gpu/drm/i915/intel_dp.c |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b7fbb74..5596e8e 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3311,6 +3311,7 @@
 #define PCH_PP_STATUS		0xc7200
 #define PCH_PP_CONTROL		0xc7204
 #define  PANEL_UNLOCK_REGS	(0xabcd << 16)
+#define  PANEL_UNLOCK_MASK	(0xffff << 16)
 #define  EDP_FORCE_VDD		(1 << 3)
 #define  EDP_BLC_ENABLE		(1 << 2)
 #define  PANEL_POWER_RESET	(1 << 1)
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 3b29a6f..a983d0f 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -840,6 +840,8 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 		msleep(dev_priv->panel_t3);
 
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 	pp |= EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
@@ -852,6 +854,8 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 	u32 pp;
 
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 	pp &= ~EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
@@ -871,13 +875,15 @@ static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
 		return true;
 
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 
 	/* ILK workaround: disable reset around power sequence */
 	pp &= ~PANEL_POWER_RESET;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
-	pp |= PANEL_UNLOCK_REGS | POWER_TARGET_ON;
+	pp |= POWER_TARGET_ON;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
@@ -900,6 +906,8 @@ static void ironlake_edp_panel_off (struct drm_device *dev)
 		PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK;
 
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 
 	/* ILK workaround: disable reset around power sequence */
 	pp &= ~PANEL_POWER_RESET;
@@ -926,6 +934,8 @@ static void ironlake_edp_backlight_on (struct drm_device *dev)
 
 	DRM_DEBUG_KMS("\n");
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 	pp |= EDP_BLC_ENABLE;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 }
@@ -937,6 +947,8 @@ static void ironlake_edp_backlight_off (struct drm_device *dev)
 
 	DRM_DEBUG_KMS("\n");
 	pp = I915_READ(PCH_PP_CONTROL);
+	pp &= ~PANEL_UNLOCK_MASK;
+	pp |= PANEL_UNLOCK_REGS;
 	pp &= ~EDP_BLC_ENABLE;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 }
-- 
1.7.6.3

