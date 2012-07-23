Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2GWQAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:00:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2GWQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:00:06 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.59+drm33.25
Date: Mon, 23 Jul 2012 17:59:59 +0200
Message-Id: <1343059199-27636-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.59+drm33.25 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/i915: Attempt to fix watermark setup on 85x (v2)
* drm/i915: Move Pineview CxSR and watermark code into update_wm hook.
* drm/i915: Add CxSR support on Pineview DDR3
* Linux 2.6.32.59+drm33.25

 Makefile                             |    2 +-
 drivers/gpu/drm/i915/i915_dma.c      |    4 +
 drivers/gpu/drm/i915/i915_drv.h      |    2 +-
 drivers/gpu/drm/i915/i915_reg.h      |   13 ++
 drivers/gpu/drm/i915/intel_display.c |  230 +++++++++++++++++++---------------
 5 files changed, 145 insertions(+), 106 deletions(-)

diff --git a/Makefile b/Makefile
index bcc7d99..7667dad 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .59+drm33.24
+EXTRAVERSION = .59+drm33.25
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index be27acc..c5b25f5 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1362,6 +1362,10 @@ static void i915_get_mem_freq(struct drm_device *dev)
 		dev_priv->mem_freq = 800;
 		break;
 	}
+
+	/* detect pineview DDR3 setting */
+	tmp = I915_READ(CSHRDDR3CTL);
+	dev_priv->is_ddr3 = (tmp & CSHRDDR3CTL_DDR3) ? 1 : 0;
 }

 /**
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index e0acd00..2a5793a 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -298,7 +298,7 @@ typedef struct drm_i915_private {
 	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */
 	int num_fence_regs; /* 8 on pre-965, 16 otherwise */

-	unsigned int fsb_freq, mem_freq;
+	unsigned int fsb_freq, mem_freq, is_ddr3;

 	spinlock_t error_lock;
 	struct drm_i915_error_state *first_error;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b463a0b..d9ad8db 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -841,6 +841,10 @@
 #define DCC_CHANNEL_XOR_DISABLE				(1 << 10)
 #define DCC_CHANNEL_XOR_BIT_17				(1 << 9)

+/** Pineview MCH register contains DDR3 setting */
+#define CSHRDDR3CTL            0x101a8
+#define CSHRDDR3CTL_DDR3       (1 << 2)
+
 /** 965 MCH register controlling DRAM channel configuration */
 #define C0DRB3			0x10206
 #define C1DRB3			0x10606
@@ -1890,15 +1894,24 @@

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
index 4899596..b4c1dd3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2395,6 +2395,7 @@ static unsigned long intel_calculate_wm(unsigned long clock_in_khz,

 struct cxsr_latency {
 	int is_desktop;
+	int is_ddr3;
 	unsigned long fsb_freq;
 	unsigned long mem_freq;
 	unsigned long display_sr;
@@ -2404,33 +2405,45 @@ struct cxsr_latency {
 };

 static struct cxsr_latency cxsr_latency_table[] = {
-	{1, 800, 400, 3382, 33382, 3983, 33983},    /* DDR2-400 SC */
-	{1, 800, 667, 3354, 33354, 3807, 33807},    /* DDR2-667 SC */
-	{1, 800, 800, 3347, 33347, 3763, 33763},    /* DDR2-800 SC */
-
-	{1, 667, 400, 3400, 33400, 4021, 34021},    /* DDR2-400 SC */
-	{1, 667, 667, 3372, 33372, 3845, 33845},    /* DDR2-667 SC */
-	{1, 667, 800, 3386, 33386, 3822, 33822},    /* DDR2-800 SC */
-
-	{1, 400, 400, 3472, 33472, 4173, 34173},    /* DDR2-400 SC */
-	{1, 400, 667, 3443, 33443, 3996, 33996},    /* DDR2-667 SC */
-	{1, 400, 800, 3430, 33430, 3946, 33946},    /* DDR2-800 SC */
-
-	{0, 800, 400, 3438, 33438, 4065, 34065},    /* DDR2-400 SC */
-	{0, 800, 667, 3410, 33410, 3889, 33889},    /* DDR2-667 SC */
-	{0, 800, 800, 3403, 33403, 3845, 33845},    /* DDR2-800 SC */
-
-	{0, 667, 400, 3456, 33456, 4103, 34106},    /* DDR2-400 SC */
-	{0, 667, 667, 3428, 33428, 3927, 33927},    /* DDR2-667 SC */
-	{0, 667, 800, 3443, 33443, 3905, 33905},    /* DDR2-800 SC */
-
-	{0, 400, 400, 3528, 33528, 4255, 34255},    /* DDR2-400 SC */
-	{0, 400, 667, 3500, 33500, 4079, 34079},    /* DDR2-667 SC */
-	{0, 400, 800, 3487, 33487, 4029, 34029},    /* DDR2-800 SC */
+	{1, 0, 800, 400, 3382, 33382, 3983, 33983},    /* DDR2-400 SC */
+	{1, 0, 800, 667, 3354, 33354, 3807, 33807},    /* DDR2-667 SC */
+	{1, 0, 800, 800, 3347, 33347, 3763, 33763},    /* DDR2-800 SC */
+	{1, 1, 800, 667, 6420, 36420, 6873, 36873},    /* DDR3-667 SC */
+	{1, 1, 800, 800, 5902, 35902, 6318, 36318},    /* DDR3-800 SC */
+
+	{1, 0, 667, 400, 3400, 33400, 4021, 34021},    /* DDR2-400 SC */
+	{1, 0, 667, 667, 3372, 33372, 3845, 33845},    /* DDR2-667 SC */
+	{1, 0, 667, 800, 3386, 33386, 3822, 33822},    /* DDR2-800 SC */
+	{1, 1, 667, 667, 6438, 36438, 6911, 36911},    /* DDR3-667 SC */
+	{1, 1, 667, 800, 5941, 35941, 6377, 36377},    /* DDR3-800 SC */
+
+	{1, 0, 400, 400, 3472, 33472, 4173, 34173},    /* DDR2-400 SC */
+	{1, 0, 400, 667, 3443, 33443, 3996, 33996},    /* DDR2-667 SC */
+	{1, 0, 400, 800, 3430, 33430, 3946, 33946},    /* DDR2-800 SC */
+	{1, 1, 400, 667, 6509, 36509, 7062, 37062},    /* DDR3-667 SC */
+	{1, 1, 400, 800, 5985, 35985, 6501, 36501},    /* DDR3-800 SC */
+
+	{0, 0, 800, 400, 3438, 33438, 4065, 34065},    /* DDR2-400 SC */
+	{0, 0, 800, 667, 3410, 33410, 3889, 33889},    /* DDR2-667 SC */
+	{0, 0, 800, 800, 3403, 33403, 3845, 33845},    /* DDR2-800 SC */
+	{0, 1, 800, 667, 6476, 36476, 6955, 36955},    /* DDR3-667 SC */
+	{0, 1, 800, 800, 5958, 35958, 6400, 36400},    /* DDR3-800 SC */
+
+	{0, 0, 667, 400, 3456, 33456, 4103, 34106},    /* DDR2-400 SC */
+	{0, 0, 667, 667, 3428, 33428, 3927, 33927},    /* DDR2-667 SC */
+	{0, 0, 667, 800, 3443, 33443, 3905, 33905},    /* DDR2-800 SC */
+	{0, 1, 667, 667, 6494, 36494, 6993, 36993},    /* DDR3-667 SC */
+	{0, 1, 667, 800, 5998, 35998, 6460, 36460},    /* DDR3-800 SC */
+
+	{0, 0, 400, 400, 3528, 33528, 4255, 34255},    /* DDR2-400 SC */
+	{0, 0, 400, 667, 3500, 33500, 4079, 34079},    /* DDR2-667 SC */
+	{0, 0, 400, 800, 3487, 33487, 4029, 34029},    /* DDR2-800 SC */
+	{0, 1, 400, 667, 6566, 36566, 7145, 37145},    /* DDR3-667 SC */
+	{0, 1, 400, 800, 6042, 36042, 6584, 36584},    /* DDR3-800 SC */
 };

-static struct cxsr_latency *intel_get_cxsr_latency(int is_desktop, int fsb,
-						   int mem)
+static struct cxsr_latency *intel_get_cxsr_latency(int is_desktop, int is_ddr3,
+						   int fsb, int mem)
 {
 	int i;
 	struct cxsr_latency *latency;
@@ -2441,6 +2454,7 @@ static struct cxsr_latency *intel_get_cxsr_latency(int is_desktop, int fsb,
 	for (i = 0; i < ARRAY_SIZE(cxsr_latency_table); i++) {
 		latency = &cxsr_latency_table[i];
 		if (is_desktop == latency->is_desktop &&
+		    is_ddr3 == latency->is_ddr3 &&
 		    fsb == latency->fsb_freq && mem == latency->mem_freq)
 			return latency;
 	}
@@ -2462,66 +2476,6 @@ static void pineview_disable_cxsr(struct drm_device *dev)
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
@@ -2606,6 +2560,71 @@ static int i830_get_fifo_size(struct drm_device *dev, int plane)
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
+	latency = intel_get_cxsr_latency(IS_PINEVIEW_G(dev), dev_priv->is_ddr3,
+					 dev_priv->fsb_freq, dev_priv->mem_freq);
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
@@ -2886,12 +2905,6 @@ static void intel_update_watermarks(struct drm_device *dev)
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
@@ -4822,21 +4835,37 @@ static void intel_init_display(struct drm_device *dev)
 	/* For FIFO watermark updates */
 	if (HAS_PCH_SPLIT(dev))
 		dev_priv->display.update_wm = NULL;
-	else if (IS_G4X(dev))
+	else if (IS_PINEVIEW(dev)) {
+		if (!intel_get_cxsr_latency(IS_PINEVIEW_G(dev),
+					    dev_priv->is_ddr3,
+					    dev_priv->fsb_freq,
+					    dev_priv->mem_freq)) {
+			DRM_INFO("failed to find known CxSR latency "
+				 "(found ddr%s fsb freq %d, mem freq %d), "
+				 "disabling CxSR\n",
+				 (dev_priv->is_ddr3 == 1) ? "3": "2",
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
-	else if (IS_I9XX(dev) || IS_MOBILE(dev)) {
+	else if (IS_I9XX(dev)) {
 		dev_priv->display.update_wm = i9xx_update_wm;
 		dev_priv->display.get_fifo_size = i9xx_get_fifo_size;
+	} else if (IS_I85X(dev)) {
+		dev_priv->display.update_wm = i9xx_update_wm;
+		dev_priv->display.get_fifo_size = i85x_get_fifo_size;
 	} else {
-		if (IS_I85X(dev))
-			dev_priv->display.get_fifo_size = i85x_get_fifo_size;
-		else if (IS_845G(dev))
+		dev_priv->display.update_wm = i830_update_wm;
+		if (IS_845G(dev))
 			dev_priv->display.get_fifo_size = i845_get_fifo_size;
 		else
 			dev_priv->display.get_fifo_size = i830_get_fifo_size;
-		dev_priv->display.update_wm = i830_update_wm;
 	}
 }

@@ -4897,13 +4926,6 @@ void intel_modeset_init(struct drm_device *dev)
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
