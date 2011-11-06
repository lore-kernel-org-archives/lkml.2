Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1KFTPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1KFTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:24 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 01/13] drm/i915: fall through pwrite_gtt_slow to the shmem slow path
Date: Sun,  6 Nov 2011 20:13:48 +0100
Message-Id: <1320606840-21132-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gtt_pwrite slowpath grabs the userspace memory with
get_user_pages. This will not work for non-page backed memory, like a
gtt mmapped gem object. Hence fall throuh to the shmem paths if we hit
-EFAULT in the gtt paths.

Now the shmem paths have exactly the same problem, but this way we
only need to rearrange the code in one write path.

v2: v1 accidentaly falls back to shmem pwrite for phys objects. Fixed.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index a838597..6fa24bc 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -996,10 +996,11 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	 * pread/pwrite currently are reading and writing from the CPU
 	 * perspective, requiring manual detiling by the client.
 	 */
-	if (obj->phys_obj)
+	if (obj->phys_obj) {
 		ret = i915_gem_phys_pwrite(dev, obj, args, file);
-	else if (obj->gtt_space &&
-		 obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
+		goto out;
+	} else if (obj->gtt_space &&
+		   obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
 		ret = i915_gem_object_pin(obj, 0, true);
 		if (ret)
 			goto out;
@@ -1018,18 +1019,24 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 
 out_unpin:
 		i915_gem_object_unpin(obj);
-	} else {
-		ret = i915_gem_object_set_to_cpu_domain(obj, 1);
-		if (ret)
-			goto out;
 
-		ret = -EFAULT;
-		if (!i915_gem_object_needs_bit17_swizzle(obj))
-			ret = i915_gem_shmem_pwrite_fast(dev, obj, args, file);
-		if (ret == -EFAULT)
-			ret = i915_gem_shmem_pwrite_slow(dev, obj, args, file);
+		if (ret != -EFAULT)
+			goto out;
+		/* Fall through to the shmfs paths because the gtt paths might
+		 * fail with non-page-backed user pointers (e.g. gtt mappings
+		 * when moving data between textures). */
 	}
 
+	ret = i915_gem_object_set_to_cpu_domain(obj, 1);
+	if (ret)
+		goto out;
+
+	ret = -EFAULT;
+	if (!i915_gem_object_needs_bit17_swizzle(obj))
+		ret = i915_gem_shmem_pwrite_fast(dev, obj, args, file);
+	if (ret == -EFAULT)
+		ret = i915_gem_shmem_pwrite_slow(dev, obj, args, file);
+
 out:
 	drm_gem_object_unreference(&obj->base);
 unlock:
-- 
1.7.6.4

