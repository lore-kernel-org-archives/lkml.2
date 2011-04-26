Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1DZMa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:30:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57234 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1DZM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:28 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 06/21] drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing." has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:26 +0200
Message-Id: <1303820786-3552-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 06/21] drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From cb5ba94f9c8bb5e6b9c7c955aca94a84881bfbc0 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 12 Aug 2010 09:35:00 +0100
Subject: [PATCH 06/21] drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.

commit 0ddc1289f3ffd779779ddd3922f26ae7d0a21604 upstream.

Just makes sure that writes are not being aliased by the CPU cache and
do make it out to main memory.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=24977
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_overlay.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index ed4058e..f240e17 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1371,6 +1371,12 @@ void intel_setup_overlay(struct drm_device *dev)
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
@@ -1402,6 +1408,8 @@ void intel_setup_overlay(struct drm_device *dev)
 	DRM_INFO("initialized overlay support\n");
 	return;

+out_unpin_bo:
+	i915_gem_object_unpin(reg_bo);
 out_free_bo:
 	drm_gem_object_unreference(reg_bo);
 out_free:
--
1.7.0.4

