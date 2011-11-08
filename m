Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1KHAHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:07:11 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:39871 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KHAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:07:08 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>, stable@kernel.org
Subject: [PATCH 1/2] drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
Date: Mon,  7 Nov 2011 16:07:04 -0800
Message-Id: <1320710825-3408-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes rendering failures in Unigine Tropics and Sanctuary and the mesa
"fire" demo.

Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    9 +++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8adb560..6ba7ea6 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3397,6 +3397,9 @@
 #define  GT_FIFO_FREE_ENTRIES			0x120008
 #define    GT_FIFO_NUM_RESERVED_ENTRIES		20
 
+#define GEN6_UCGCTL2				0x9404
+# define GEN6_RCPBUNIT_CLOCK_GATE_DISABLE		(1 << 12)
+
 #define GEN6_RPNSWREQ				0xA008
 #define   GEN6_TURBO_DISABLE			(1<<31)
 #define   GEN6_FREQUENCY(x)			((x)<<25)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 04411ad..fde7c42 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7850,6 +7850,15 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);
 
+	/* According to the BSpec vol1g, bit 12 (RCPBUNIT) clock
+	 * gating disable must be set.  Failure to set it results in
+	 * flickering pixels due to Z write ordering failures after
+	 * some amount of runtime in the Mesa "fire" demo, and Unigine
+	 * Sanctuary and Tropics, and apparently anything else with
+	 * alpha test or pixel discard.
+	 */
+	I915_WRITE(GEN6_UCGCTL2, GEN6_RCPBUNIT_CLOCK_GATE_DISABLE);
+
 	/*
 	 * According to the spec the following bits should be
 	 * set in order to enable memory self-refresh and fbc:
-- 
1.7.7

