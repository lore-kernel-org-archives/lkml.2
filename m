Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2GASWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab2GASQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:39 -0400
Message-Id: <20120701172008.391612565@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Francis Leblanc <Francis.Leblanc-Lebeau@verint.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Timo Aaltonen <timo.aaltonen@canonical.com>
Subject: [ 12/48] drm/i915: Finish any pending operations on the framebuffer  before disabling
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

Similar to the case where we are changing from one framebuffer to
another, we need to be sure that there are no pending WAIT_FOR_EVENTs on
the pipe for the current framebuffer before switching. If we disable the
pipe, and then try to execute a WAIT_FOR_EVENT it will block
indefinitely and cause a GPU hang.

We attempted to fix this in commit 85345517fe6d4de27b0d6ca19fef9d28ac947c4a
(drm/i915: Retire any pending operations on the old scanout when switching)
for the case of mode switching, but this leaves the condition where we
are switching off the pipe vulnerable.

There still remains the race condition were a display may be unplugged,
switched off by the core, a uevent sent to notify the DDX and the DDX
may issue a WAIT_FOR_EVENT before it processes the uevent. This window
does not exist if the pipe is only switched off in response to the
uevent. Time to make sure that is so...

Reported-by: Francis Leblanc <Francis.Leblanc-Lebeau@verint.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=36515
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=45413
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
[danvet: fixup spelling in comment, noticed by Eugeni.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
(cherry picked from commit 14667a4bde4361b7ac420d68a2e9e9b9b2df5231)
Signed-off-by: Timo Aaltonen <timo.aaltonen@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   65 ++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7f90cbd..8580d82 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2187,6 +2187,33 @@ intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 }
 
 static int
+intel_finish_fb(struct drm_framebuffer *old_fb)
+{
+	struct drm_i915_gem_object *obj = to_intel_framebuffer(old_fb)->obj;
+	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
+	bool was_interruptible = dev_priv->mm.interruptible;
+	int ret;
+
+	wait_event(dev_priv->pending_flip_queue,
+		   atomic_read(&dev_priv->mm.wedged) ||
+		   atomic_read(&obj->pending_flip) == 0);
+
+	/* Big Hammer, we also need to ensure that any pending
+	 * MI_WAIT_FOR_EVENT inside a user batch buffer on the
+	 * current scanout is retired before unpinning the old
+	 * framebuffer.
+	 *
+	 * This should only fail upon a hung GPU, in which case we
+	 * can safely continue.
+	 */
+	dev_priv->mm.interruptible = false;
+	ret = i915_gem_object_finish_gpu(obj);
+	dev_priv->mm.interruptible = was_interruptible;
+
+	return ret;
+}
+
+static int
 intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		    struct drm_framebuffer *old_fb)
 {
@@ -2224,25 +2251,8 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		return ret;
 	}
 
-	if (old_fb) {
-		struct drm_i915_private *dev_priv = dev->dev_private;
-		struct drm_i915_gem_object *obj = to_intel_framebuffer(old_fb)->obj;
-
-		wait_event(dev_priv->pending_flip_queue,
-			   atomic_read(&dev_priv->mm.wedged) ||
-			   atomic_read(&obj->pending_flip) == 0);
-
-		/* Big Hammer, we also need to ensure that any pending
-		 * MI_WAIT_FOR_EVENT inside a user batch buffer on the
-		 * current scanout is retired before unpinning the old
-		 * framebuffer.
-		 *
-		 * This should only fail upon a hung GPU, in which case we
-		 * can safely continue.
-		 */
-		ret = i915_gem_object_finish_gpu(obj);
-		(void) ret;
-	}
+	if (old_fb)
+		intel_finish_fb(old_fb);
 
 	ret = intel_pipe_set_base_atomic(crtc, crtc->fb, x, y,
 					 LEAVE_ATOMIC_MODE_SET);
@@ -3312,6 +3322,23 @@ static void intel_crtc_disable(struct drm_crtc *crtc)
 	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
 	struct drm_device *dev = crtc->dev;
 
+	/* Flush any pending WAITs before we disable the pipe. Note that
+	 * we need to drop the struct_mutex in order to acquire it again
+	 * during the lowlevel dpms routines around a couple of the
+	 * operations. It does not look trivial nor desirable to move
+	 * that locking higher. So instead we leave a window for the
+	 * submission of further commands on the fb before we can actually
+	 * disable it. This race with userspace exists anyway, and we can
+	 * only rely on the pipe being disabled by userspace after it
+	 * receives the hotplug notification and has flushed any pending
+	 * batches.
+	 */
+	if (crtc->fb) {
+		mutex_lock(&dev->struct_mutex);
+		intel_finish_fb(crtc->fb);
+		mutex_unlock(&dev->struct_mutex);
+	}
+
 	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
 
 	if (crtc->fb) {


