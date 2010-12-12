Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0LLXp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0LLXps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:48 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: chris@chris-wilson.co.uk, ak@linux.intel.com, daniel.vetter@ffwll.ch,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [50/223] drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.
Message-Id: <20101212234547.8F7AAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0ddc1289f3ffd779779ddd3922f26ae7d0a21604 upstream.

Just makes sure that writes are not being aliased by the CPU cache and
do make it out to main memory.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=24977
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_overlay.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/drivers/gpu/drm/i915/intel_overlay.c
===================================================================
--- linux.orig/drivers/gpu/drm/i915/intel_overlay.c
+++ linux/drivers/gpu/drm/i915/intel_overlay.c
@@ -1364,6 +1364,12 @@ void intel_setup_overlay(struct drm_devi
                         goto out_free_bo;
                 }
 		overlay->flip_addr = overlay->reg_bo->gtt_offset;
+
+		ret = i915_gem_object_set_to_gtt_domain(reg_bo, true);
+		if (ret) {
+                        DRM_ERROR("failed to move overlay register bo into the GTT\n");
+                        goto out_unpin_bo;
+                }
 	} else {
 		ret = i915_gem_attach_phys_object(dev, reg_bo,
 				I915_GEM_PHYS_OVERLAY_REGS);
@@ -1395,6 +1401,8 @@ void intel_setup_overlay(struct drm_devi
 	DRM_INFO("initialized overlay support\n");
 	return;
 
+out_unpin_bo:
+	i915_gem_object_unpin(reg_bo);
 out_free_bo:
 	drm_gem_object_unreference(reg_bo);
 out_free:
