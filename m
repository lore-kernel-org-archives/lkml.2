Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1GZGhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:37:06 -0400
Received: from home.keithp.com ([63.227.221.253]:48648 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1GZGgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:50 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 5/5] drm/i915: DP_PIPE_ENABLED must check transcoder on CPT
Date: Mon, 25 Jul 2011 23:36:34 -0700
Message-Id: <1311662194-4050-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display port pipe selection on CPT is not done with a bit in the
output register, rather it is controlled by a couple of bits in the
separate transcoder register which indicate which display port output
is connected to the transcoder.

This patch replaces the simplistic macro DP_PIPE_ENABLED with the
rather more complicated function dp_pipe_enabled which checks the
output register to see if that is enabled, and then goes on to either
check the output register pipe selection bit (on non-CPT) or the
transcoder DP selection bits (on CPT).

Before this patch, any time the mode of pipe A was changed, any
display port outputs on pipe B would get disabled as
intel_disable_pch_ports would ensure that the mode setting operation
could occur on pipe A without interference from other outputs
connected to that pch port

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    3 --
 drivers/gpu/drm/i915/intel_display.c |   45 +++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5d5def7..f731565 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2083,9 +2083,6 @@
 #define   DP_PIPEB_SELECT		(1 << 30)
 #define   DP_PIPE_MASK			(1 << 30)
 
-#define DP_PIPE_ENABLED(V, P) \
-	(((V) & (DP_PIPE_MASK | DP_PORT_EN)) == ((P) << 30 | DP_PORT_EN))
-
 /* Link training mode - select a suitable mode for each stage */
 #define   DP_LINK_TRAIN_PAT_1		(0 << 28)
 #define   DP_LINK_TRAIN_PAT_2		(1 << 28)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5609c06..fc26cb4 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -979,11 +979,29 @@ static void assert_transcoder_disabled(struct drm_i915_private *dev_priv,
 	     pipe_name(pipe));
 }
 
+static bool dp_pipe_enabled(struct drm_i915_private *dev_priv, enum pipe pipe,
+			    int reg, u32 port_sel, u32 val)
+{
+	if ((val & DP_PORT_EN) == 0)
+		return false;
+
+	if (HAS_PCH_CPT(dev_priv->dev)) {
+		u32	trans_dp_ctl_reg = TRANS_DP_CTL(pipe);
+		u32	trans_dp_ctl = I915_READ(trans_dp_ctl_reg);
+		if ((trans_dp_ctl & TRANS_DP_PORT_SEL_MASK) != port_sel)
+			return false;
+	} else {
+		if ((val & DP_PIPE_MASK) != (pipe << 30))
+			return false;
+	}
+	return true;
+}
+
 static void assert_pch_dp_disabled(struct drm_i915_private *dev_priv,
-				   enum pipe pipe, int reg)
+				   enum pipe pipe, int reg, u32 port_sel)
 {
 	u32 val = I915_READ(reg);
-	WARN(DP_PIPE_ENABLED(val, pipe),
+	WARN(dp_pipe_enabled(dev_priv, pipe, reg, port_sel, val),
 	     "PCH DP (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
@@ -1003,9 +1021,9 @@ static void assert_pch_ports_disabled(struct drm_i915_private *dev_priv,
 	int reg;
 	u32 val;
 
-	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_B);
-	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_C);
-	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_D);
+	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_B, TRANS_DP_PORT_SEL_B);
+	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_C, TRANS_DP_PORT_SEL_C);
+	assert_pch_dp_disabled(dev_priv, pipe, PCH_DP_D, TRANS_DP_PORT_SEL_D);
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
@@ -1334,19 +1352,24 @@ static void intel_disable_plane(struct drm_i915_private *dev_priv,
 }
 
 static void disable_pch_dp(struct drm_i915_private *dev_priv,
-			   enum pipe pipe, int reg)
+			   enum pipe pipe, int reg, u32 port_sel)
 {
 	u32 val = I915_READ(reg);
-	if (DP_PIPE_ENABLED(val, pipe))
+	if (dp_pipe_enabled(dev_priv, pipe, reg, port_sel, val)) {
+		DRM_DEBUG_KMS("Disabling pch dp %x on pipe %d\n", reg, pipe);
 		I915_WRITE(reg, val & ~DP_PORT_EN);
+	}
 }
 
 static void disable_pch_hdmi(struct drm_i915_private *dev_priv,
 			     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	if (HDMI_PIPE_ENABLED(val, pipe))
+	if (HDMI_PIPE_ENABLED(val, pipe)) {
+		DRM_DEBUG_KMS("Disabling pch HDMI %x on pipe %d\n",
+			      reg, pipe);
 		I915_WRITE(reg, val & ~PORT_ENABLE);
+	}
 }
 
 /* Disable any ports connected to this transcoder */
@@ -1358,9 +1381,9 @@ static void intel_disable_pch_ports(struct drm_i915_private *dev_priv,
 	val = I915_READ(PCH_PP_CONTROL);
 	I915_WRITE(PCH_PP_CONTROL, val | PANEL_UNLOCK_REGS);
 
-	disable_pch_dp(dev_priv, pipe, PCH_DP_B);
-	disable_pch_dp(dev_priv, pipe, PCH_DP_C);
-	disable_pch_dp(dev_priv, pipe, PCH_DP_D);
+	disable_pch_dp(dev_priv, pipe, PCH_DP_B, TRANS_DP_PORT_SEL_B);
+	disable_pch_dp(dev_priv, pipe, PCH_DP_C, TRANS_DP_PORT_SEL_C);
+	disable_pch_dp(dev_priv, pipe, PCH_DP_D, TRANS_DP_PORT_SEL_D);
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
-- 
1.7.5.4

