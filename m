Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2IQBPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:15:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33669 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab2IQAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:26 -0400
Message-Id: <20120917003637.437735422@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Timo Aaltonen <timo.aaltonen@canonical.com>
Subject: [ 081/135] drm/i915: Wait for all pending operations to the fb before  disabling the pipe
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

During modeset we have to disable the pipe to reconfigure its timings
and maybe its size. Userspace may have queued up command buffers that
depend upon the pipe running in a certain configuration and so the
commands may become confused across the modeset. At the moment, we use a
less than satisfactory kick-scanline-waits should the GPU hang during
the modeset. It should be more reliable to wait for the pending
operations to complete first, even though we still have a window for
userspace to submit a broken command buffer during the modeset.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
(cherry picked from commit 0f91128d88bbb8b0a8e7bb93df2c40680871d45a)

Signed-off-by: Timo Aaltonen <timo.aaltonen@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index cc75c4b..ae74df7 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2852,16 +2852,14 @@ static void intel_clear_scanline_wait(struct drm_device *dev)
 
 static void intel_crtc_wait_for_pending_flips(struct drm_crtc *crtc)
 {
-	struct drm_i915_gem_object *obj;
-	struct drm_i915_private *dev_priv;
+	struct drm_device *dev = crtc->dev;
 
 	if (crtc->fb == NULL)
 		return;
 
-	obj = to_intel_framebuffer(crtc->fb)->obj;
-	dev_priv = crtc->dev->dev_private;
-	wait_event(dev_priv->pending_flip_queue,
-		   atomic_read(&obj->pending_flip) == 0);
+	mutex_lock(&dev->struct_mutex);
+	intel_finish_fb(crtc->fb);
+	mutex_unlock(&dev->struct_mutex);
 }
 
 static bool intel_crtc_driving_pch(struct drm_crtc *crtc)
@@ -3322,23 +3320,6 @@ static void intel_crtc_disable(struct drm_crtc *crtc)
 	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
 	struct drm_device *dev = crtc->dev;
 
-	/* Flush any pending WAITs before we disable the pipe. Note that
-	 * we need to drop the struct_mutex in order to acquire it again
-	 * during the lowlevel dpms routines around a couple of the
-	 * operations. It does not look trivial nor desirable to move
-	 * that locking higher. So instead we leave a window for the
-	 * submission of further commands on the fb before we can actually
-	 * disable it. This race with userspace exists anyway, and we can
-	 * only rely on the pipe being disabled by userspace after it
-	 * receives the hotplug notification and has flushed any pending
-	 * batches.
-	 */
-	if (crtc->fb) {
-		mutex_lock(&dev->struct_mutex);
-		intel_finish_fb(crtc->fb);
-		mutex_unlock(&dev->struct_mutex);
-	}
-
 	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
 
 	if (crtc->fb) {
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe stable" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




