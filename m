Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1LITcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:32:24 -0500
Received: from home.keithp.com ([63.227.221.253]:47761 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1LITcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:32:22 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm/i915: Clean up multi-threaded forcewake patch
Date: Fri,  9 Dec 2011 11:33:00 -0800
Message-Id: <1323459180-7198-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We learned that the ECOBUS register was inside the GT power well, and
so *did* need force wake to be read, so it gets removed from the list
of 'doesn't need force wake' registers.

That means the code reading ECOBUS after forcing the mt_force_wake
function to be called needs to use I915_READ_NOTRACE; it doesn't need
to do more force wake fun as it's already done it manually.

This also adds a comment explaining why the MT forcewake testing code
only needs to call mt_forcewake_get/put and not disable RC6 manually
-- the ECOBUS read will return 0 if the device is in RC6 and isn't
using MT forcewake, causing the test to work correctly.

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_drv.c      |    7 -------
 drivers/gpu/drm/i915/i915_drv.h      |    3 +--
 drivers/gpu/drm/i915/intel_display.c |    8 +++++++-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 28836fe..e63a0f0 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -922,13 +922,6 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL and additional rights");
 
-/* We give fast paths for the really cool registers */
-#define NEEDS_FORCE_WAKE(dev_priv, reg) \
-	(((dev_priv)->info->gen >= 6) && \
-	 ((reg) < 0x40000) &&		 \
-	 ((reg) != FORCEWAKE) &&	 \
-	 ((reg) != ECOBUS))
-
 #define __i915_read(x, y) \
 u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
 	u##x val = 0; \
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1421118..bbd0604 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1364,8 +1364,7 @@ void __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv);
 #define NEEDS_FORCE_WAKE(dev_priv, reg) \
 	(((dev_priv)->info->gen >= 6) && \
 	 ((reg) < 0x40000) &&		 \
-	 ((reg) != FORCEWAKE) &&	 \
-	 ((reg) != ECOBUS))
+	 ((reg) != FORCEWAKE))
 
 #define __i915_read(x, y) \
 	u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a03ebf6..5abfc36 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8539,9 +8539,15 @@ static void intel_init_display(struct drm_device *dev)
 		if (IS_IVYBRIDGE(dev)) {
 			u32	ecobus;
 
+			/* A small trick here - if the bios hasn't configured MT forcewake,
+			 * and if the device is in RC6, then force_wake_mt_get will not wake
+			 * the device and the ECOBUS read will return zero. Which will be
+			 * (correctly) interpreted by the test below as MT forcewake being
+			 * disabled.
+			 */
 			mutex_lock(&dev->struct_mutex);
 			__gen6_gt_force_wake_mt_get(dev_priv);
-			ecobus = I915_READ(ECOBUS);
+			ecobus = I915_READ_NOTRACE(ECOBUS);
 			__gen6_gt_force_wake_mt_put(dev_priv);
 			mutex_unlock(&dev->struct_mutex);
 
-- 
1.7.7.3

