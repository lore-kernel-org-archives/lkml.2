Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2JKAPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:15:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40267 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932834Ab2JKAPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:15:06 -0400
X-Sasl-enc: pUfQtV08/w/+Ld3l9J9MGuuyduZdplnW84U1R4F4fyQw 1349914504
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 097/133] drm/i915: Flush the pending flips on the CRTC before modification
Date: Thu, 11 Oct 2012 07:52:03 +0900
Message-Id: <20121010224911.966967490@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2641,13 +2641,34 @@ static void ironlake_fdi_disable(struct
 	udelay(100);
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
@@ -5916,9 +5937,8 @@ static void do_intel_finish_page_flip(st
 
 	atomic_clear_mask(1 << intel_crtc->plane,
 			  &obj->pending_flip.counter);
-	if (atomic_read(&obj->pending_flip) == 0)
-		wake_up(&dev_priv->pending_flip_queue);
 
+	wake_up(&dev_priv->pending_flip_queue);
 	schedule_work(&work->work);
 
 	trace_i915_flip_complete(intel_crtc->plane, work->pending_flip_obj);


