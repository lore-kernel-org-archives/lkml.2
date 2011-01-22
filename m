Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1AVKMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:12:01 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:50551
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752295Ab1AVKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:11:59 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Date: Sat, 22 Jan 2011 10:11:39 +0000
Message-Id: <1295691099-14276-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <:201101220935.03623.chris2553@googlemail.com>
References: <:201101220935.03623.chris2553@googlemail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Chris, does this help?

If you can convert the address to a line number that would pinpoint the
NULL pointer exactly. Though judging by the address and position of the
dereference a NULL crtc looks most likely.
-Chris

---
 drivers/gpu/drm/i915/i915_irq.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index f0c87bd..d999d00 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -274,24 +274,34 @@ int i915_get_crtc_scanoutpos(struct drm_device *dev, int pipe,
 	return ret;
 }
 
-int i915_get_vblank_timestamp(struct drm_device *dev, int crtc,
+int i915_get_vblank_timestamp(struct drm_device *dev, int pipe,
 			      int *max_error,
 			      struct timeval *vblank_time,
 			      unsigned flags)
 {
-	struct drm_crtc *drmcrtc;
+	struct drm_crtc *crtc;
 
-	if (crtc < 0 || crtc >= dev->num_crtcs) {
-		DRM_ERROR("Invalid crtc %d\n", crtc);
+	if (pipe < 0 || pipe >= dev->num_crtcs) {
+		DRM_ERROR("Invalid crtc %d\n", pipe);
 		return -EINVAL;
 	}
 
 	/* Get drm_crtc to timestamp: */
-	drmcrtc = intel_get_crtc_for_pipe(dev, crtc);
+	crtc = intel_get_crtc_for_pipe(dev, pipe);
+	if (crtc == NULL) {
+		DRM_ERROR("Invalid crtc %d\n", pipe);
+		return -EINVAL;
+	}
+
+	if (!crtc->enabled) {
+		DRM_DEBUG_KMS("crtc %d is disabled\n", pipe);
+		return -EBUSY;
+	}
 
 	/* Helper routine in DRM core does all the work: */
-	return drm_calc_vbltimestamp_from_scanoutpos(dev, crtc, max_error,
-						     vblank_time, flags, drmcrtc);
+	return drm_calc_vbltimestamp_from_scanoutpos(dev, pipe, max_error,
+						     vblank_time, flags,
+						     crtc);
 }
 
 /*
-- 
1.7.2.3

