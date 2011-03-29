Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1C2Kql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:46:41 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:53228
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752453Ab1C2Kqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:46:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Disable all outputs early, before KMS takeover
Date: Tue, 29 Mar 2011 11:46:29 +0100
Message-Id: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the outputs are active and continuing to access the GATT when we
teardown the PTEs, then there is a potential for us to hang the GPU.
The hang tends to be a PGTBL_ER with either an invalid host access or
an invalid display plane fetch.

Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_dma.c      |   31 ++++++++++++++++++++++---------
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   17 +++++++++++------
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 7273037..65d5adf 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1176,11 +1176,11 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 	return can_switch;
 }
 
-static int i915_load_modeset_init(struct drm_device *dev)
+static int i915_load_gem_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long prealloc_size, gtt_size, mappable_size;
-	int ret = 0;
+	int ret;
 
 	prealloc_size = dev_priv->mm.gtt->stolen_size;
 	gtt_size = dev_priv->mm.gtt->gtt_total_entries << PAGE_SHIFT;
@@ -1204,7 +1204,7 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	ret = i915_gem_init_ringbuffer(dev);
 	mutex_unlock(&dev->struct_mutex);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* Try to set up FBC with a reasonable compressed buffer size */
 	if (I915_HAS_FBC(dev) && i915_powersave) {
@@ -1222,6 +1222,13 @@ static int i915_load_modeset_init(struct drm_device *dev)
 
 	/* Allow hardware batchbuffers unless told otherwise. */
 	dev_priv->allow_batchbuffer = 1;
+	return 0;
+}
+
+static int i915_load_modeset_init(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int ret;
 
 	ret = intel_parse_bios(dev);
 	if (ret)
@@ -1236,7 +1243,7 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	 */
 	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
 	if (ret && ret != -ENODEV)
-		goto cleanup_ringbuffer;
+		goto out;
 
 	intel_register_dsm_handler();
 
@@ -1257,13 +1264,19 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	if (ret)
 		goto cleanup_vga_switcheroo;
 
+	ret = i915_load_gem_init(dev);
+	if (ret)
+		goto cleanup_irq;
+
+	intel_modeset_gem_init(dev);
+
 	/* Always safe in the mode setting case. */
 	/* FIXME: do pre/post-mode set stuff in core KMS code */
 	dev->vblank_disable_allowed = 1;
 
 	ret = intel_fbdev_init(dev);
 	if (ret)
-		goto cleanup_irq;
+		goto cleanup_gem;
 
 	drm_kms_helper_poll_init(dev);
 
@@ -1272,16 +1285,16 @@ static int i915_load_modeset_init(struct drm_device *dev)
 
 	return 0;
 
+cleanup_gem:
+	mutex_lock(&dev->struct_mutex);
+	i915_gem_cleanup_ringbuffer(dev);
+	mutex_unlock(&dev->struct_mutex);
 cleanup_irq:
 	drm_irq_uninstall(dev);
 cleanup_vga_switcheroo:
 	vga_switcheroo_unregister_client(dev->pdev);
 cleanup_vga_client:
 	vga_client_register(dev->pdev, NULL, NULL, NULL);
-cleanup_ringbuffer:
-	mutex_lock(&dev->struct_mutex);
-	i915_gem_cleanup_ringbuffer(dev);
-	mutex_unlock(&dev->struct_mutex);
 out:
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 359ddce..60ebd79 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1268,6 +1268,7 @@ static inline void intel_unregister_dsm_handler(void) { return; }
 
 /* modesetting */
 extern void intel_modeset_init(struct drm_device *dev);
+extern void intel_modeset_gem_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
 extern int intel_modeset_vga_set_state(struct drm_device *dev, bool state);
 extern void i8xx_disable_fbc(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 432fc04..5c7385b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6497,6 +6497,9 @@ static void intel_setup_outputs(struct drm_device *dev)
 	}
 
 	intel_panel_setup_backlight(dev);
+
+	/* disable all the possible outputs/crtcs before entering KMS mode */
+	drm_helper_disable_unused_functions(dev);
 }
 
 static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
@@ -7432,13 +7435,12 @@ void intel_modeset_init(struct drm_device *dev)
 		intel_crtc_init(dev, i);
 	}
 
+	/* Just disable it once at startup */
+	i915_disable_vga(dev);
 	intel_setup_outputs(dev);
 
 	intel_enable_clock_gating(dev);
 
-	/* Just disable it once at startup */
-	i915_disable_vga(dev);
-
 	if (IS_IRONLAKE_M(dev)) {
 		ironlake_enable_drps(dev);
 		intel_init_emon(dev);
@@ -7447,12 +7449,15 @@ void intel_modeset_init(struct drm_device *dev)
 	if (IS_GEN6(dev))
 		gen6_enable_rps(dev_priv);
 
-	if (IS_IRONLAKE_M(dev))
-		ironlake_enable_rc6(dev);
-
 	INIT_WORK(&dev_priv->idle_work, intel_idle_update);
 	setup_timer(&dev_priv->idle_timer, intel_gpu_idle_timer,
 		    (unsigned long)dev);
+}
+
+void intel_modeset_gem_init(struct drm_device *dev)
+{
+	if (IS_IRONLAKE_M(dev))
+		ironlake_enable_rc6(dev);
 
 	intel_setup_overlay(dev);
 }
-- 
1.7.4.1

