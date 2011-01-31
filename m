Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1AaK5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:57:54 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:59056
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752137Ab1AaK5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:57:53 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Suppress spurious vblank interrupts
Date: Mon, 31 Jan 2011 10:57:42 +0000
Message-Id: <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <849307$bc24ct@azsmga001.ch.intel.com>
References: <849307$bc24ct@azsmga001.ch.intel.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins found that characters in xterm were going missing and oft
delayed. Being the curious type, he managed to associate this with the
new high-precision vblank patches; disabling these he found, restored
the orderliness of his characters.

The oddness begins when one realised that Hugh was not using vblanks at
all on his system (fvwm and some xterms). Instead, all he had to go on
were warning of a pipe underrun, curiously enough at around 60Hz. He
poked and found that in addition to the underrun warning, the hardware
was flagging the start of a new frame, a vblank, which in turn was
kicking off the pending vblank processing code.

There is little we can do for the underruns on Hugh's machine, a
Crestline [965GM], which must have its FIFO watermarks set to 8.
However, we do not need to process the vblank if we know that they are
disabled...

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/drm_irq.c       |    7 ++++---
 drivers/gpu/drm/i915/i915_irq.c |    8 ++++----
 include/drm/drmP.h              |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 0054e95..3dadfa2 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -1250,7 +1250,7 @@ void drm_handle_vblank_events(struct drm_device *dev, int crtc)
  * Drivers should call this routine in their vblank interrupt handlers to
  * update the vblank counter and send any signals that may be pending.
  */
-void drm_handle_vblank(struct drm_device *dev, int crtc)
+bool drm_handle_vblank(struct drm_device *dev, int crtc)
 {
 	u32 vblcount;
 	s64 diff_ns;
@@ -1258,7 +1258,7 @@ void drm_handle_vblank(struct drm_device *dev, int crtc)
 	unsigned long irqflags;
 
 	if (!dev->num_crtcs)
-		return;
+		return false;
 
 	/* Need timestamp lock to prevent concurrent execution with
 	 * vblank enable/disable, as this would cause inconsistent
@@ -1269,7 +1269,7 @@ void drm_handle_vblank(struct drm_device *dev, int crtc)
 	/* Vblank irq handling disabled. Nothing to do. */
 	if (!dev->vblank_enabled[crtc]) {
 		spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
-		return;
+		return false;
 	}
 
 	/* Fetch corresponding timestamp for this vblank interval from
@@ -1311,5 +1311,6 @@ void drm_handle_vblank(struct drm_device *dev, int crtc)
 	drm_handle_vblank_events(dev, crtc);
 
 	spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
+	return true;
 }
 EXPORT_SYMBOL(drm_handle_vblank);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index d388bbb..1a33aea 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1202,18 +1202,18 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 				intel_finish_page_flip_plane(dev, 1);
 		}
 
-		if (pipea_stats & vblank_status) {
+		if (pipea_stats & vblank_status &&
+		    drm_handle_vblank(dev, 0)) {
 			vblank++;
-			drm_handle_vblank(dev, 0);
 			if (!dev_priv->flip_pending_is_done) {
 				i915_pageflip_stall_check(dev, 0);
 				intel_finish_page_flip(dev, 0);
 			}
 		}
 
-		if (pipeb_stats & vblank_status) {
+		if (pipeb_stats & vblank_status &&
+		    drm_handle_vblank(dev, 1)) {
 			vblank++;
-			drm_handle_vblank(dev, 1);
 			if (!dev_priv->flip_pending_is_done) {
 				i915_pageflip_stall_check(dev, 1);
 				intel_finish_page_flip(dev, 1);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index a4694c6..fe29aad 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1367,7 +1367,7 @@ extern int drm_vblank_wait(struct drm_device *dev, unsigned int *vbl_seq);
 extern u32 drm_vblank_count(struct drm_device *dev, int crtc);
 extern u32 drm_vblank_count_and_time(struct drm_device *dev, int crtc,
 				     struct timeval *vblanktime);
-extern void drm_handle_vblank(struct drm_device *dev, int crtc);
+extern bool drm_handle_vblank(struct drm_device *dev, int crtc);
 extern int drm_vblank_get(struct drm_device *dev, int crtc);
 extern void drm_vblank_put(struct drm_device *dev, int crtc);
 extern void drm_vblank_off(struct drm_device *dev, int crtc);
-- 
1.7.2.3

