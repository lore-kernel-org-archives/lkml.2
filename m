Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab1KSGlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 01:41:51 -0500
Received: from home.keithp.com ([63.227.221.253]:36879 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1KSGlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 01:41:50 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
Date: Fri, 18 Nov 2011 22:41:29 -0800
Message-Id: <1321684889-18691-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RC6 should always work on IVB, and should work on SNB whenever IO
remapping is disabled. Make the default value for the parameter turn
it on in these cases. Setting the value to either 0 or 1 will force
the specified behavior.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/i915_drv.h      |    2 +-
 drivers/gpu/drm/i915/intel_display.c |   26 +++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 15bfa91..cf5c1bd 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -63,10 +63,10 @@ module_param_named(semaphores, i915_semaphores, int, 0600);
 MODULE_PARM_DESC(semaphores,
 		"Use semaphores for inter-ring sync (default: false)");
 
-unsigned int i915_enable_rc6 __read_mostly = 0;
+int i915_enable_rc6 __read_mostly = -1;
 module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
 MODULE_PARM_DESC(i915_enable_rc6,
-		"Enable power-saving render C-state 6 (default: true)");
+		"Enable power-saving render C-state 6 (default: -1 (false when VT-d enabled)");
 
 int i915_enable_fbc __read_mostly = -1;
 module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 4a9c1b9..172b022 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1002,7 +1002,7 @@ extern unsigned int i915_semaphores __read_mostly;
 extern unsigned int i915_lvds_downclock __read_mostly;
 extern int i915_panel_use_ssc __read_mostly;
 extern int i915_vbt_sdvo_panel_type __read_mostly;
-extern unsigned int i915_enable_rc6 __read_mostly;
+extern int i915_enable_rc6 __read_mostly;
 extern int i915_enable_fbc __read_mostly;
 extern bool i915_enable_hangcheck __read_mostly;
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e77a863..13fd4c0 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -38,8 +38,11 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "drm_dp_helper.h"
-
 #include "drm_crtc_helper.h"
+#ifdef CONFIG_INTEL_IOMMU
+#include <linux/dma_remapping.h>
+#include <linux/dmar.h>
+#endif
 
 #define HAS_eDP (intel_pipe_has_type(crtc, INTEL_OUTPUT_EDP))
 
@@ -7887,6 +7890,23 @@ void intel_init_emon(struct drm_device *dev)
 	dev_priv->corr = (lcfuse & LCFUSE_HIV_MASK);
 }
 
+static bool intel_enable_rc6(struct drm_device *dev)
+{
+	if (i915_enable_rc6 >= 0)
+		return i915_enable_rc6;
+	if (INTEL_INFO(dev)->gen >= 7)
+		return 1;
+#ifdef CONFIG_INTEL_IOMMU
+	/*
+	 * Only enable RC6 if all dma remapping is disabled, or if
+	 * there's no iommu present in the machine.
+	 */
+	if (INTEL_INFO(dev)->gen == 6)
+		return no_iommu || dmar_disabled;
+#endif
+	return 0;
+}
+
 void gen6_enable_rps(struct drm_i915_private *dev_priv)
 {
 	u32 rp_state_cap = I915_READ(GEN6_RP_STATE_CAP);
@@ -7923,7 +7943,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
-	if (i915_enable_rc6)
+	if (intel_enable_rc6(dev_priv->dev))
 		rc6_mask = GEN6_RC_CTL_RC6p_ENABLE |
 			GEN6_RC_CTL_RC6_ENABLE;
 
@@ -8372,7 +8392,7 @@ void ironlake_enable_rc6(struct drm_device *dev)
 	/* rc6 disabled by default due to repeated reports of hanging during
 	 * boot and resume.
 	 */
-	if (!i915_enable_rc6)
+	if (!intel_enable_rc6(dev))
 		return;
 
 	mutex_lock(&dev->struct_mutex);
-- 
1.7.7.3

