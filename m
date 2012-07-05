Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2GERsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:48:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2GERsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:48:17 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Li Peng <peng.li@linux.intel.com>
Cc: Li Peng <peng.li@intel.com>, Eric Anholt <eric@anholt.net>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Add CxSR support on Pineview DDR3" has been added to staging queue
Date: Thu,  5 Jul 2012 19:48:13 +0200
Message-Id: <1341510493-19036-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Add CxSR support on Pineview DDR3

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 1f5a0728bf0774af7db20613d5e2d902c95ae511 Mon Sep 17 00:00:00 2001
From: Li Peng <peng.li@linux.intel.com>
Date: Tue, 18 May 2010 18:58:44 +0800
Subject: [PATCH 2/2] drm/i915: Add CxSR support on Pineview DDR3

BugLink: http://bugs.launchpad.net/bugs/1004707

Pineview with DDR3 memory has different latencies to enable CxSR.
This patch updates CxSR latency table to add Pineview DDR3 latency
configuration. It also adds one flag "is_ddr3" for checking DDR3
setting in MCHBAR.

Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Li Peng <peng.li@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>

(cherry picked from commit 9553426372eef71c849499fb1d232f4b0577c0f9)
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c      |    4 ++
 drivers/gpu/drm/i915/i915_drv.h      |    2 +-
 drivers/gpu/drm/i915/i915_reg.h      |    4 ++
 drivers/gpu/drm/i915/intel_display.c |   72 +++++++++++++++++++++-------------
 4 files changed, 53 insertions(+), 29 deletions(-)

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
index f87963c..d9ad8db 100644
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
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 72ce100..c83c36f 100644
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
@@ -2555,8 +2569,8 @@ static void pineview_update_wm(struct drm_device *dev,  int planea_clock,
 	struct cxsr_latency *latency;
 	int sr_clock;

-	latency = intel_get_cxsr_latency(IS_PINEVIEW_G(dev), dev_priv->fsb_freq,
-					 dev_priv->mem_freq);
+	latency = intel_get_cxsr_latency(IS_PINEVIEW_G(dev), dev_priv->is_ddr3,
+					 dev_priv->fsb_freq, dev_priv->mem_freq);
 	if (!latency) {
 		DRM_DEBUG_KMS("Unknown FSB/MEM found, disable CxSR\n");
 		pineview_disable_cxsr(dev);
@@ -4821,11 +4835,13 @@ static void intel_init_display(struct drm_device *dev)
 		dev_priv->display.update_wm = NULL;
 	else if (IS_PINEVIEW(dev)) {
 		if (!intel_get_cxsr_latency(IS_PINEVIEW_G(dev),
+					    dev_priv->is_ddr3,
 					    dev_priv->fsb_freq,
 					    dev_priv->mem_freq)) {
 			DRM_INFO("failed to find known CxSR latency "
-				 "(found fsb freq %d, mem freq %d), "
+				 "(found ddr%s fsb freq %d, mem freq %d), "
 				 "disabling CxSR\n",
+				 (dev_priv->is_ddr3 == 1) ? "3": "2",
 				 dev_priv->fsb_freq, dev_priv->mem_freq);
 			/* Disable CxSR and never update its watermark again */
 			pineview_disable_cxsr(dev);
--
1.7.9.5

