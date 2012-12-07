Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2LGOyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:54:44 -0500
Received: from mail.tpi.com ([70.99.223.143]:2991 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2LGOyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:54:43 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: jani.nikula@linux.intel.com, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH v2 linux-next] i915: intel_set_mode: Reduce stack allocation from 500 bytes to 2 pointers
Date: Fri,  7 Dec 2012 07:54:26 -0700
Message-Id: <1354892066-30256-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <87zk1qm6cd.fsf@intel.com>
References: <87zk1qm6cd.fsf@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch warning:

drivers/gpu/drm/i915/intel_display.c:7019 intel_set_mode() warn: function puts
500 bytes on stack

Refactor so that saved_mode and saved_hwmode are dynamically allocated as opposed
to being automatic variables. 500 bytes seems like it could run the potential for blowing
the kernel stack.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

V2 - spaces around '*', use kmalloc instead of kzalloc(). Missed
error return that would have orphaned memory.

 drivers/gpu/drm/i915/intel_display.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index de51489..c15b21b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7739,11 +7739,18 @@ bool intel_set_mode(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_display_mode *adjusted_mode, saved_mode, saved_hwmode;
+	struct drm_display_mode *adjusted_mode, *saved_mode, *saved_hwmode;
 	struct intel_crtc *intel_crtc;
 	unsigned disable_pipes, prepare_pipes, modeset_pipes;
 	bool ret = true;
 
+	saved_mode = kmalloc(2 * sizeof(*saved_mode), GFP_KERNEL);
+	if (!saved_mode) {
+		DRM_ERROR("i915: Could not allocate saved display mode.\n");
+		return false;
+	}
+	saved_hwmode = saved_mode + 1;
+
 	intel_modeset_affected_pipes(crtc, &modeset_pipes,
 				     &prepare_pipes, &disable_pipes);
 
@@ -7753,8 +7760,8 @@ bool intel_set_mode(struct drm_crtc *crtc,
 	for_each_intel_crtc_masked(dev, disable_pipes, intel_crtc)
 		intel_crtc_disable(&intel_crtc->base);
 
-	saved_hwmode = crtc->hwmode;
-	saved_mode = crtc->mode;
+	*saved_hwmode = crtc->hwmode;
+	*saved_mode = crtc->mode;
 
 	/* Hack: Because we don't (yet) support global modeset on multiple
 	 * crtcs, we don't keep track of the new mode for more than one crtc.
@@ -7765,7 +7772,8 @@ bool intel_set_mode(struct drm_crtc *crtc,
 	if (modeset_pipes) {
 		adjusted_mode = intel_modeset_adjusted_mode(crtc, mode);
 		if (IS_ERR(adjusted_mode)) {
-			return false;
+			ret = false;
+			goto out;
 		}
 	}
 
@@ -7817,12 +7825,14 @@ bool intel_set_mode(struct drm_crtc *crtc,
 done:
 	drm_mode_destroy(dev, adjusted_mode);
 	if (!ret && crtc->enabled) {
-		crtc->hwmode = saved_hwmode;
-		crtc->mode = saved_mode;
+		crtc->hwmode = *saved_hwmode;
+		crtc->mode = *saved_mode;
 	} else {
 		intel_modeset_check_state(dev);
 	}
 
+out:
+	kfree(saved_mode);
 	return ret;
 }
 
-- 
1.7.9.5

