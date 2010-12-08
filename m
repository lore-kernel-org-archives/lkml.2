Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0LHBoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:44:00 -0500
Received: from kroah.org ([198.145.64.141]:48773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab0LHBAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.246712984@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [089/289] drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0ddc1289f3ffd779779ddd3922f26ae7d0a21604 upstream.

Just makes sure that writes are not being aliased by the CPU cache and
do make it out to main memory.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=24977
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_overlay.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1367,6 +1367,12 @@ void intel_setup_overlay(struct drm_devi
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
 						  I915_GEM_PHYS_OVERLAY_REGS,
@@ -1399,6 +1405,8 @@ void intel_setup_overlay(struct drm_devi
 	DRM_INFO("initialized overlay support\n");
 	return;
 
+out_unpin_bo:
+	i915_gem_object_unpin(reg_bo);
 out_free_bo:
 	drm_gem_object_unreference(reg_bo);
 out_free:


