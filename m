Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2DBJMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:12:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44096 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2DBJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:12:43 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Tony Vroon <tony@linx.net>
Subject: [PATCH] drm/i915: disable ppgtt on snb when dmar is enabled
Date: Mon,  2 Apr 2012 10:08:35 +0200
Message-Id: <1333354115-2430-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Totally unexpected that this regressed. Luckily it sounds like we just
need to have dmar disable on the igfx, not the entire system. At least
that's what a few days of testing between Tony Vroon and me indicates.

Reported-by: Tony Vroon <tony@linx.net>
Cc: Tony Vroon <tony@linx.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43024
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/char/agp/intel-gtt.c    |    1 -
 drivers/gpu/drm/i915/i915_dma.c |   17 ++++++++++++++++-
 drivers/gpu/drm/i915/i915_drv.c |    4 ++--
 drivers/gpu/drm/i915/i915_drv.h |    2 +-
 include/drm/intel-gtt.h         |    4 ++++
 5 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 7e223a2..e086fa5 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1204,7 +1204,6 @@ static inline int needs_idle_maps(void)
 {
 #ifdef CONFIG_INTEL_IOMMU
 	const unsigned short gpu_devid = intel_private.pcidev->device;
-	extern int intel_iommu_gfx_mapped;
 
 	/* Query intel_iommu to see if we need the workaround. Presumably that
 	 * was loaded first.
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 4636391..ee06241 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1189,6 +1189,21 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 	return can_switch;
 }
 
+static bool
+intel_enable_ppgtt(struct drm_device *dev)
+{
+	if (i915_enable_ppgtt >= 0)
+		return i915_enable_ppgtt;
+
+#ifdef CONFIG_INTEL_IOMMU
+	/* Disable ppgtt on SNB if VT-d is on. */
+	if (INTEL_INFO(dev)->gen == 6 && intel_iommu_gfx_mapped)
+		return false;
+#endif
+
+	return true;
+}
+
 static int i915_load_gem_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -1203,7 +1218,7 @@ static int i915_load_gem_init(struct drm_device *dev)
 	drm_mm_init(&dev_priv->mm.stolen, 0, prealloc_size);
 
 	mutex_lock(&dev->struct_mutex);
-	if (i915_enable_ppgtt && HAS_ALIASING_PPGTT(dev)) {
+	if (intel_enable_ppgtt(dev) && HAS_ALIASING_PPGTT(dev)) {
 		/* PPGTT pdes are stolen from global gtt ptes, so shrink the
 		 * aperture accordingly when using aliasing ppgtt. */
 		gtt_size -= I915_PPGTT_PD_ENTRIES*PAGE_SIZE;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 0efc02e..c65907e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -109,8 +109,8 @@ MODULE_PARM_DESC(enable_hangcheck,
 		"WARNING: Disabling this can cause system wide hangs. "
 		"(default: true)");
 
-bool i915_enable_ppgtt __read_mostly = 1;
-module_param_named(i915_enable_ppgtt, i915_enable_ppgtt, bool, 0600);
+int i915_enable_ppgtt __read_mostly = -1;
+module_param_named(i915_enable_ppgtt, i915_enable_ppgtt, int, 0600);
 MODULE_PARM_DESC(i915_enable_ppgtt,
 		"Enable PPGTT (default: true)");
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b617cd5..1c8c440 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1088,7 +1088,7 @@ extern int i915_vbt_sdvo_panel_type __read_mostly;
 extern int i915_enable_rc6 __read_mostly;
 extern int i915_enable_fbc __read_mostly;
 extern bool i915_enable_hangcheck __read_mostly;
-extern bool i915_enable_ppgtt __read_mostly;
+extern int i915_enable_ppgtt __read_mostly;
 
 extern int i915_suspend(struct drm_device *dev, pm_message_t state);
 extern int i915_resume(struct drm_device *dev);
diff --git a/include/drm/intel-gtt.h b/include/drm/intel-gtt.h
index 0a0001b..923afb5 100644
--- a/include/drm/intel-gtt.h
+++ b/include/drm/intel-gtt.h
@@ -44,4 +44,8 @@ void intel_gtt_insert_pages(unsigned int first_entry, unsigned int num_entries,
 /* flag for GFDT type */
 #define AGP_USER_CACHED_MEMORY_GFDT (1 << 3)
 
+#ifdef CONFIG_INTEL_IOMMU
+extern int intel_iommu_gfx_mapped;
+#endif
+
 #endif
-- 
1.7.7.6

