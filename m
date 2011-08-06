Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1HFRyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:54:23 -0400
Received: from home.keithp.com ([63.227.221.253]:41206 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1HFRyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:54:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 3/4] drm/i915: Fix PCH port pipe select in CPT disable paths
Date: Sat,  6 Aug 2011 10:54:07 -0700
Message-Id: <1312653248-3487-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312653248-3487-1-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPT pipe select is different from previous generations (using two bits
instead of one). All of the paths from intel_disable_pch_ports were
not making this distinction.

Mode setting with pipe A turned off would then also force all outputs
on pipe B to get turned off as the disable code would mistakenly
decide that all of these outputs were on pipe A and turn them off.

This is an extension of the CPT DP disable fix (why didn't I fix this then?)

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |   13 ++-----
 drivers/gpu/drm/i915/intel_display.c |   60 ++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index d1331f7..5baaef4 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1318,6 +1318,7 @@
 #define   ADPA_PIPE_SELECT_MASK	(1<<30)
 #define   ADPA_PIPE_A_SELECT	0
 #define   ADPA_PIPE_B_SELECT	(1<<30)
+#define   ADPA_PIPE_SELECT(pipe) ((pipe) << 30)
 #define   ADPA_USE_VGA_HVPOLARITY (1<<15)
 #define   ADPA_SETS_HVPOLARITY	0
 #define   ADPA_VSYNC_CNTL_DISABLE (1<<11)
@@ -1460,6 +1461,7 @@
 /* Selects pipe B for LVDS data.  Must be set on pre-965. */
 #define   LVDS_PIPEB_SELECT		(1 << 30)
 #define   LVDS_PIPE_MASK		(1 << 30)
+#define   LVDS_PIPE(pipe)		((pipe) << 30)
 /* LVDS dithering flag on 965/g4x platform */
 #define   LVDS_ENABLE_DITHER		(1 << 25)
 /* LVDS sync polarity flags. Set to invert (i.e. negative) */
@@ -1499,9 +1501,6 @@
 #define   LVDS_B0B3_POWER_DOWN		(0 << 2)
 #define   LVDS_B0B3_POWER_UP		(3 << 2)
 
-#define LVDS_PIPE_ENABLED(V, P) \
-	(((V) & (LVDS_PIPE_MASK | LVDS_PORT_EN)) == ((P) << 30 | LVDS_PORT_EN))
-
 /* Video Data Island Packet control */
 #define VIDEO_DIP_DATA		0x61178
 #define VIDEO_DIP_CTL		0x61170
@@ -3256,14 +3255,12 @@
 #define  ADPA_CRT_HOTPLUG_VOLREF_475MV  (1<<17)
 #define  ADPA_CRT_HOTPLUG_FORCE_TRIGGER (1<<16)
 
-#define ADPA_PIPE_ENABLED(V, P) \
-	(((V) & (ADPA_TRANS_SELECT_MASK | ADPA_DAC_ENABLE)) == ((P) << 30 | ADPA_DAC_ENABLE))
-
 /* or SDVOB */
 #define HDMIB   0xe1140
 #define  PORT_ENABLE    (1 << 31)
 #define  TRANSCODER_A   (0)
 #define  TRANSCODER_B   (1 << 30)
+#define  TRANSCODER(pipe)	((pipe) << 30)
 #define  TRANSCODER_MASK   (1 << 30)
 #define  COLOR_FORMAT_8bpc      (0)
 #define  COLOR_FORMAT_12bpc     (3 << 26)
@@ -3280,9 +3277,6 @@
 #define  HSYNC_ACTIVE_HIGH      (1 << 3)
 #define  PORT_DETECTED          (1 << 2)
 
-#define HDMI_PIPE_ENABLED(V, P) \
-	(((V) & (TRANSCODER_MASK | PORT_ENABLE)) == ((P) << 30 | PORT_ENABLE))
-
 /* PCH SDVOB multiplex with HDMIB */
 #define PCH_SDVOB	HDMIB
 
@@ -3349,6 +3343,7 @@
 #define  PORT_TRANS_B_SEL_CPT	(1<<29)
 #define  PORT_TRANS_C_SEL_CPT	(2<<29)
 #define  PORT_TRANS_SEL_MASK	(3<<29)
+#define  PORT_TRANS_SEL_CPT(pipe)	((pipe) << 29)
 
 #define TRANS_DP_CTL_A		0xe0300
 #define TRANS_DP_CTL_B		0xe1300
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 35364e6..4c4c903 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -998,6 +998,53 @@ static bool dp_pipe_enabled(struct drm_i915_private *dev_priv, enum pipe pipe,
 	return true;
 }
 
+static bool hdmi_pipe_enabled(struct drm_i915_private *dev_priv,
+			      enum pipe pipe, u32 val)
+{
+	if ((val & PORT_ENABLE) == 0)
+		return false;
+
+	if (HAS_PCH_CPT(dev_priv->dev)) {
+		if ((val & PORT_TRANS_SEL_MASK) != PORT_TRANS_SEL_CPT(pipe))
+			return false;
+	} else {
+		if ((val & TRANSCODER_MASK) != TRANSCODER(pipe))
+			return false;
+	}
+	return true;
+}
+
+static bool lvds_pipe_enabled(struct drm_i915_private *dev_priv,
+			      enum pipe pipe, u32 val)
+{
+	if ((val & LVDS_PORT_EN) == 0)
+		return false;
+
+	if (HAS_PCH_CPT(dev_priv->dev)) {
+		if ((val & PORT_TRANS_SEL_MASK) != PORT_TRANS_SEL_CPT(pipe))
+			return false;
+	} else {
+		if ((val & LVDS_PIPE_MASK) != LVDS_PIPE(pipe))
+			return false;
+	}
+	return true;
+}
+
+static bool adpa_pipe_enabled(struct drm_i915_private *dev_priv,
+			      enum pipe pipe, u32 val)
+{
+	if ((val & ADPA_DAC_ENABLE) == 0)
+		return false;
+	if (HAS_PCH_CPT(dev_priv->dev)) {
+		if ((val & PORT_TRANS_SEL_MASK) != PORT_TRANS_SEL_CPT(pipe))
+			return false;
+	} else {
+		if ((val & ADPA_PIPE_SELECT_MASK) != ADPA_PIPE_SELECT(pipe))
+			return false;
+	}
+	return true;
+}
+
 static void assert_pch_dp_disabled(struct drm_i915_private *dev_priv,
 				   enum pipe pipe, int reg, u32 port_sel)
 {
@@ -1011,7 +1058,7 @@ static void assert_pch_hdmi_disabled(struct drm_i915_private *dev_priv,
 				     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	WARN(HDMI_PIPE_ENABLED(val, pipe),
+	WARN(hdmi_pipe_enabled(dev_priv, val, pipe),
 	     "PCH DP (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
@@ -1028,13 +1075,13 @@ static void assert_pch_ports_disabled(struct drm_i915_private *dev_priv,
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
-	WARN(ADPA_PIPE_ENABLED(val, pipe),
+	WARN(adpa_pipe_enabled(dev_priv, val, pipe),
 	     "PCH VGA enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
 
 	reg = PCH_LVDS;
 	val = I915_READ(reg);
-	WARN(LVDS_PIPE_ENABLED(val, pipe),
+	WARN(lvds_pipe_enabled(dev_priv, val, pipe),
 	     "PCH LVDS enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
 
@@ -1370,7 +1417,7 @@ static void disable_pch_hdmi(struct drm_i915_private *dev_priv,
 			     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	if (HDMI_PIPE_ENABLED(val, pipe)) {
+	if (hdmi_pipe_enabled(dev_priv, val, pipe)) {
 		DRM_DEBUG_KMS("Disabling pch HDMI %x on pipe %d\n",
 			      reg, pipe);
 		I915_WRITE(reg, val & ~PORT_ENABLE);
@@ -1392,12 +1439,13 @@ static void intel_disable_pch_ports(struct drm_i915_private *dev_priv,
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
-	if (ADPA_PIPE_ENABLED(val, pipe))
+	if (adpa_pipe_enabled(dev_priv, val, pipe))
 		I915_WRITE(reg, val & ~ADPA_DAC_ENABLE);
 
 	reg = PCH_LVDS;
 	val = I915_READ(reg);
-	if (LVDS_PIPE_ENABLED(val, pipe)) {
+	if (lvds_pipe_enabled(dev_priv, val, pipe)) {
+		DRM_DEBUG_KMS("disable lvds on pipe %d val 0x%08x\n", pipe, val);
 		I915_WRITE(reg, val & ~LVDS_PORT_EN);
 		POSTING_READ(reg);
 		udelay(100);
-- 
1.7.5.4

