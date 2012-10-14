Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2JNOnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663Ab2JNOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:04 -0400
Message-Id: <20121014143545.831783440@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 089/147] drm/i915: Flush the pending flips on the CRTC before modification
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5bb61643f6a70d48de9cfe91ad0fee0d618b6816 upstream.

This was meant to be the purpose of the
intel_crtc_wait_for_pending_flips() function which is called whilst
preparing the CRTC for a modeset or before disabling. However, as Ville
Syrjala pointed out, we set the pending flip notification on the old
framebuffer that is no longer attached to the CRTC by the time we come
to flush the pending operations. Instead, we can simply wait on the
pending unpin work to be finished on this CRTC, knowning that the
hardware has therefore finished modifying the registers, before proceeding
with our direct access.

Fixes i-g-t/flip_test on non-pch platforms. pch platforms simply
schedule the flip immediately when the pipe is disabled, leading
to other funny issues.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Added i-g-t note and cc: stable]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2850,13 +2850,34 @@ static void intel_clear_scanline_wait(st
 		I915_WRITE_CTL(ring, tmp);
 }
 
+static bool intel_crtc_has_pending_flip(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long flags;
+	bool pending;
+
+	if (atomic_read(&dev_priv->mm.wedged))
+		return false;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	pending = to_intel_crtc(crtc)->unpin_work != NULL;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return pending;
+}
+
 static void intel_crtc_wait_for_pending_flips(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	if (crtc->fb == NULL)
 		return;
 
+	wait_event(dev_priv->pending_flip_queue,
+		   !intel_crtc_has_pending_flip(crtc));
+
 	mutex_lock(&dev->struct_mutex);
 	intel_finish_fb(crtc->fb);
 	mutex_unlock(&dev->struct_mutex);
@@ -6952,9 +6973,8 @@ static void do_intel_finish_page_flip(st
 
 	atomic_clear_mask(1 << intel_crtc->plane,
 			  &obj->pending_flip.counter);
-	if (atomic_read(&obj->pending_flip) == 0)
-		wake_up(&dev_priv->pending_flip_queue);
 
+	wake_up(&dev_priv->pending_flip_queue);
 	schedule_work(&work->work);
 
 	trace_i915_flip_complete(intel_crtc->plane, work->pending_flip_obj);


