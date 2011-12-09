Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1LIXxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:53:19 -0500
Received: from home.keithp.com ([63.227.221.253]:59598 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1LIXxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:53:13 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, Ted Phelps <phelps@gnusto.com>,
        Peter <pab1612@gmail.com>, Lukas Hejtmanek <xhejtman@fi.muni.cz>,
        Andrew Lutomirski <luto@mit.edu>
Subject: [PATCH 2/2] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
Date: Fri,  9 Dec 2011 15:53:49 -0800
Message-Id: <1323474829-2501-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323474829-2501-1-git-send-email-keithp@keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <1323474829-2501-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RC6 should always work on IVB, and should work on SNB whenever IO
remapping is disabled. RC6 never works on Ironlake. Make the default
value for the parameter follow these guidelines. Setting the value
to either 0 or 1 will force the specified behavior.

Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38567
Cc: Ted Phelps <phelps@gnusto.com>
Cc: Peter <pab1612@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Cc: Andrew Lutomirski <luto@mit.edu>
---
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/i915_drv.h      |    2 +-
 drivers/gpu/drm/i915/intel_display.c |   33 ++++++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 28836fe..47a42eb 100644
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
+		"Enable power-saving render C-state 6 (default: -1 (use per-chip default)");
 
 int i915_enable_fbc __read_mostly = -1;
 module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1421118..bb82ef8 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1008,7 +1008,7 @@ extern unsigned int i915_semaphores __read_mostly;
 extern unsigned int i915_lvds_downclock __read_mostly;
 extern int i915_panel_use_ssc __read_mostly;
 extern int i915_vbt_sdvo_panel_type __read_mostly;
-extern unsigned int i915_enable_rc6 __read_mostly;
+extern int i915_enable_rc6 __read_mostly;
 extern int i915_enable_fbc __read_mostly;
 extern bool i915_enable_hangcheck __read_mostly;
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a03ebf6..3097104 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -38,8 +38,8 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "drm_dp_helper.h"
-
 #include "drm_crtc_helper.h"
+#include <linux/dma_remapping.h>
 
 #define HAS_eDP (intel_pipe_has_type(crtc, INTEL_OUTPUT_EDP))
 
@@ -7928,6 +7928,33 @@ void intel_init_emon(struct drm_device *dev)
 	dev_priv->corr = (lcfuse & LCFUSE_HIV_MASK);
 }
 
+static bool intel_enable_rc6(struct drm_device *dev)
+{
+	/*
+	 * Respect the kernel parameter if it is set
+	 */
+	if (i915_enable_rc6 >= 0)
+		return i915_enable_rc6;
+
+	/*
+	 * Disable RC6 on Ironlake
+	 */
+	if (INTEL_INFO(dev)->gen == 5)
+		return 0;
+
+	/*
+	 * Enable rc6 on Sandybridge if DMA remapping is disabled
+	 */
+	if (INTEL_INFO(dev)->gen == 6) {
+		DRM_DEBUG_DRIVER("Sandybridge: intel_iommu_enabled %s -- RC6 %sabled\n",
+				 intel_iommu_enabled ? "true" : "false",
+				 !intel_iommu_enabled ? "en" : "dis");
+		return !intel_iommu_enabled;
+	}
+	DRM_DEBUG_DRIVER("RC6 enabled\n");
+	return 1;
+}
+
 void gen6_enable_rps(struct drm_i915_private *dev_priv)
 {
 	u32 rp_state_cap = I915_READ(GEN6_RP_STATE_CAP);
@@ -7964,7 +7991,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
-	if (i915_enable_rc6)
+	if (intel_enable_rc6(dev_priv->dev))
 		rc6_mask = GEN6_RC_CTL_RC6p_ENABLE |
 			GEN6_RC_CTL_RC6_ENABLE;
 
@@ -8413,7 +8440,7 @@ void ironlake_enable_rc6(struct drm_device *dev)
 	/* rc6 disabled by default due to repeated reports of hanging during
 	 * boot and resume.
 	 */
-	if (!i915_enable_rc6)
+	if (!intel_enable_rc6(dev))
 		return;
 
 	mutex_lock(&dev->struct_mutex);
-- 
1.7.7.3

