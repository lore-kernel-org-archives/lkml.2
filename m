Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2GERsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:48:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2GERsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:48:17 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Move Pineview CxSR and watermark code into" has been added to staging queue
Date: Thu,  5 Jul 2012 19:48:11 +0200
Message-Id: <1341510491-19000-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Move Pineview CxSR and watermark code into

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 96e1603c0fa43329252e119945a9bc2b527605f4 Mon Sep 17 00:00:00 2001
From: Zhao Yakui <yakui.zhao@intel.com>
Date: Mon, 22 Mar 2010 22:45:36 +0800
Subject: [PATCH 1/2] drm/i915: Move Pineview CxSR and watermark code into
 update_wm hook.

BugLink: http://bugs.launchpad.net/bugs/1004707

Previously, after setting up the Pineview CxSR state, i9xx_update_wm would
get called and overwrite our state.

BTW: We will disable the self-refresh and never enable it any more if we
can't find the appropriate the latency on pineview plaftorm. In such case
the update_wm callback will be NULL.

The bitmask macro is also defined to access the corresponding fifo
watermark register.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>

(cherry picked from commit d4294342fd4b94a3297867da00c1c5e929c28d4f)
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    9 ++
 drivers/gpu/drm/i915/intel_display.c |  153 ++++++++++++++++++----------------
 2 files changed, 88 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b463a0b..f87963c 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1890,15 +1890,24 @@

 #define DSPFW1			0x70034
 #define   DSPFW_SR_SHIFT	23
+#define   DSPFW_SR_MASK 	(0x1ff<<23)
 #define   DSPFW_CURSORB_SHIFT	16
+#define   DSPFW_CURSORB_MASK	(0x3f<<16)
 #define   DSPFW_PLANEB_SHIFT	8
+#define   DSPFW_PLANEB_MASK	(0x7f<<8)
+#define   DSPFW_PLANEA_MASK	(0x7f)
 #define DSPFW2			0x70038
 #define   DSPFW_CURSORA_MASK	0x00003f00
 #define   DSPFW_CURSORA_SHIFT	8
+#define   DSPFW_PLANEC_MASK	(0x7f)
 #define DSPFW3			0x7003c
 #define   DSPFW_HPLL_SR_EN	(1<<31)
 #define   DSPFW_CURSOR_SR_SHIFT	24
 #define   PINEVIEW_SELF_REFRESH_EN	(1<<30)
+#define   DSPFW_CURSOR_SR_MASK		(0x3f<<24)
+#define   DSPFW_HPLL_CURSOR_SHIFT	16
+#define   DSPFW_HPLL_CURSOR_MASK	(0x3f<<16)
+#define   DSPFW_HPLL_SR_MASK		(0x1ff)

 /* FIFO watermark sizes etc */
 #define G4X_FIFO_LINE_SIZE	64
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 900ed14..72ce100 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2462,66 +2462,6 @@ static void pineview_disable_cxsr(struct drm_device *dev)
 	DRM_INFO("Big FIFO is disabled\n");
 }

-static void pineview_enable_cxsr(struct drm_device *dev, unsigned long clock,
-				 int pixel_size)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 reg;
-	unsigned long wm;
-	struct cxsr_latency *latency;
-
-	latency = intel_get_cxsr_latency(IS_PINEVIEW_G(dev), dev_priv->fsb_freq,
-		dev_priv->mem_freq);
-	if (!latency) {
-		DRM_DEBUG_KMS("Unknown FSB/MEM found, disable CxSR\n");
-		pineview_disable_cxsr(dev);
-		return;
-	}
-
-	/* Display SR */
-	wm = intel_calculate_wm(clock, &pineview_display_wm, pixel_size,
-				latency->display_sr);
-	reg = I915_READ(DSPFW1);
-	reg &= 0x7fffff;
-	reg |= wm << 23;
-	I915_WRITE(DSPFW1, reg);
-	DRM_DEBUG_KMS("DSPFW1 register is %x\n", reg);
-
-	/* cursor SR */
-	wm = intel_calculate_wm(clock, &pineview_cursor_wm, pixel_size,
-				latency->cursor_sr);
-	reg = I915_READ(DSPFW3);
-	reg &= ~(0x3f << 24);
-	reg |= (wm & 0x3f) << 24;
-	I915_WRITE(DSPFW3, reg);
-
-	/* Display HPLL off SR */
-	wm = intel_calculate_wm(clock, &pineview_display_hplloff_wm,
-		latency->display_hpll_disable, I915_FIFO_LINE_SIZE);
-	reg = I915_READ(DSPFW3);
-	reg &= 0xfffffe00;
-	reg |= wm & 0x1ff;
-	I915_WRITE(DSPFW3, reg);
-
-	/* cursor HPLL off SR */
-	wm = intel_calculate_wm(clock, &pineview_cursor_hplloff_wm, pixel_size,
-				latency->cursor_hpll_disable);
-	reg = I915_READ(DSPFW3);
-	reg &= ~(0x3f << 16);
-	reg |= (wm & 0x3f) << 16;
-	I915_WRITE(DSPFW3, reg);
-	DRM_DEBUG_KMS("DSPFW3 register is %x\n", reg);
-
-	/* activate cxsr */
-	reg = I915_READ(DSPFW3);
-	reg |= PINEVIEW_SELF_REFRESH_EN;
-	I915_WRITE(DSPFW3, reg);
-
-	DRM_INFO("Big FIFO is enabled\n");
-
-	return;
-}
-
 /*
  * Latency for FIFO fetches is dependent on several factors:
  *   - memory configuration (speed, channels)
@@ -2606,6 +2546,71 @@ static int i830_get_fifo_size(struct drm_device *dev, int plane)
 	return size;
 }

+static void pineview_update_wm(struct drm_device *dev,  int planea_clock,
+			  int planeb_clock, int sr_hdisplay, int pixel_size)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 reg;
+	unsigned long wm;
+	struct cxsr_latency *latency;
+	int sr_clock;
+
+	latency = intel_get_cxsr_latency(IS_PINEVIEW_G(dev), dev_priv->fsb_freq,
+					 dev_priv->mem_freq);
+	if (!latency) {
+		DRM_DEBUG_KMS("Unknown FSB/MEM found, disable CxSR\n");
+		pineview_disable_cxsr(dev);
+		return;
+	}
+
+	if (!planea_clock || !planeb_clock) {
+		sr_clock = planea_clock ? planea_clock : planeb_clock;
+
+		/* Display SR */
+		wm = intel_calculate_wm(sr_clock, &pineview_display_wm,
+					pixel_size, latency->display_sr);
+		reg = I915_READ(DSPFW1);
+		reg &= ~DSPFW_SR_MASK;
+		reg |= wm << DSPFW_SR_SHIFT;
+		I915_WRITE(DSPFW1, reg);
+		DRM_DEBUG_KMS("DSPFW1 register is %x\n", reg);
+
+		/* cursor SR */
+		wm = intel_calculate_wm(sr_clock, &pineview_cursor_wm,
+					pixel_size, latency->cursor_sr);
+		reg = I915_READ(DSPFW3);
+		reg &= ~DSPFW_CURSOR_SR_MASK;
+		reg |= (wm & 0x3f) << DSPFW_CURSOR_SR_SHIFT;
+		I915_WRITE(DSPFW3, reg);
+
+		/* Display HPLL off SR */
+		wm = intel_calculate_wm(sr_clock, &pineview_display_hplloff_wm,
+					pixel_size, latency->display_hpll_disable);
+		reg = I915_READ(DSPFW3);
+		reg &= ~DSPFW_HPLL_SR_MASK;
+		reg |= wm & DSPFW_HPLL_SR_MASK;
+		I915_WRITE(DSPFW3, reg);
+
+		/* cursor HPLL off SR */
+		wm = intel_calculate_wm(sr_clock, &pineview_cursor_hplloff_wm,
+					pixel_size, latency->cursor_hpll_disable);
+		reg = I915_READ(DSPFW3);
+		reg &= ~DSPFW_HPLL_CURSOR_MASK;
+		reg |= (wm & 0x3f) << DSPFW_HPLL_CURSOR_SHIFT;
+		I915_WRITE(DSPFW3, reg);
+		DRM_DEBUG_KMS("DSPFW3 register is %x\n", reg);
+
+		/* activate cxsr */
+		reg = I915_READ(DSPFW3);
+		reg |= PINEVIEW_SELF_REFRESH_EN;
+		I915_WRITE(DSPFW3, reg);
+		DRM_DEBUG_KMS("Self-refresh is enabled\n");
+	} else {
+		pineview_disable_cxsr(dev);
+		DRM_DEBUG_KMS("Self-refresh is disabled\n");
+	}
+}
+
 static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
 			  int planeb_clock, int sr_hdisplay, int pixel_size)
 {
@@ -2886,12 +2891,6 @@ static void intel_update_watermarks(struct drm_device *dev)
 	if (enabled <= 0)
 		return;

-	/* Single plane configs can enable self refresh */
-	if (enabled == 1 && IS_PINEVIEW(dev))
-		pineview_enable_cxsr(dev, sr_clock, pixel_size);
-	else if (IS_PINEVIEW(dev))
-		pineview_disable_cxsr(dev);
-
 	dev_priv->display.update_wm(dev, planea_clock, planeb_clock,
 				    sr_hdisplay, pixel_size);
 }
@@ -4820,7 +4819,20 @@ static void intel_init_display(struct drm_device *dev)
 	/* For FIFO watermark updates */
 	if (HAS_PCH_SPLIT(dev))
 		dev_priv->display.update_wm = NULL;
-	else if (IS_G4X(dev))
+	else if (IS_PINEVIEW(dev)) {
+		if (!intel_get_cxsr_latency(IS_PINEVIEW_G(dev),
+					    dev_priv->fsb_freq,
+					    dev_priv->mem_freq)) {
+			DRM_INFO("failed to find known CxSR latency "
+				 "(found fsb freq %d, mem freq %d), "
+				 "disabling CxSR\n",
+				 dev_priv->fsb_freq, dev_priv->mem_freq);
+			/* Disable CxSR and never update its watermark again */
+			pineview_disable_cxsr(dev);
+			dev_priv->display.update_wm = NULL;
+		} else
+			dev_priv->display.update_wm = pineview_update_wm;
+	} else if (IS_G4X(dev))
 		dev_priv->display.update_wm = g4x_update_wm;
 	else if (IS_I965G(dev))
 		dev_priv->display.update_wm = i965_update_wm;
@@ -4895,13 +4907,6 @@ void intel_modeset_init(struct drm_device *dev)
 		    (unsigned long)dev);

 	intel_setup_overlay(dev);
-
-	if (IS_PINEVIEW(dev) && !intel_get_cxsr_latency(IS_PINEVIEW_G(dev),
-							dev_priv->fsb_freq,
-							dev_priv->mem_freq))
-		DRM_INFO("failed to find known CxSR latency "
-			 "(found fsb freq %d, mem freq %d), disabling CxSR\n",
-			 dev_priv->fsb_freq, dev_priv->mem_freq);
 }

 void intel_modeset_cleanup(struct drm_device *dev)
--
1.7.9.5

