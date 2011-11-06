Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1KFTPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1KFTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:33 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 07/13] drm/i915: move clflushing into shmem_pread
Date: Sun,  6 Nov 2011 20:13:54 +0100
Message-Id: <1320606840-21132-8-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is obviously gonna slow down pread. But for a half-way realistic
micro-benchmark, it doesn't matter: Non-broken userspace reads back
data from the gpu once before the gpu again dirties it.

So all this ranged clflush tracking is just a waste of time.

No pread performance change (neglecting the dumb benchmark of
constantly reading the same data) measured.

As an added bonus, this avoids clflush on read on coherent objects.
Which means that partial preads on snb are now roughly 4x as fast.
This will be usefull for e.g. the libva encoder - when I finally get
around to fix that up.

v2: Properly sync with the gpu on LLC machines.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 5eec933..0e9cc81 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -342,12 +342,25 @@ i915_gem_shmem_pread(struct drm_device *dev,
 	int shmem_page_offset, page_length, ret;
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
 	int hit_slowpath = 0;
+	int needs_clflush = 0;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
 
 	obj_do_bit17_swizzling = i915_gem_object_needs_bit17_swizzle(obj);
 
+	if (!(obj->base.read_domains & I915_GEM_DOMAIN_CPU)) {
+		/* If we're not in the cpu read domain, set ourself into the gtt
+		 * read domain and manually flush cachelines (if required). This
+		 * optimizes for the case when the gpu will dirty the data
+		 * anyway again before the next pread happens. */
+		if (obj->cache_level == I915_CACHE_NONE)
+			needs_clflush = 1;
+		ret = i915_gem_object_set_to_gtt_domain(obj, false);
+		if (ret)
+			return ret;
+	}
+
 	offset = args->offset;
 
 	while (remain > 0) {
@@ -374,6 +387,9 @@ i915_gem_shmem_pread(struct drm_device *dev,
 
 		if (!obj_do_bit17_swizzling || !page_do_bit17_swizzling) {
 			vaddr = kmap_atomic(page);
+			if (needs_clflush)
+				drm_clflush_virt_range(vaddr + shmem_page_offset,
+						       page_length);
 			ret = __copy_to_user_inatomic(user_data,
 						      vaddr + shmem_page_offset,
 						      page_length);
@@ -387,6 +403,10 @@ i915_gem_shmem_pread(struct drm_device *dev,
 		mutex_unlock(&dev->struct_mutex);
 
 		vaddr = kmap(page);
+		if (needs_clflush)
+			drm_clflush_virt_range(vaddr + shmem_page_offset,
+					       page_length);
+
 		if (obj_do_bit17_swizzling && page_do_bit17_swizzling)
 			ret = __copy_to_user_swizzled(user_data,
 						      vaddr, shmem_page_offset,
@@ -467,12 +487,6 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 
 	trace_i915_gem_object_pread(obj, args->offset, args->size);
 
-	ret = i915_gem_object_set_cpu_read_domain_range(obj,
-							args->offset,
-							args->size);
-	if (ret)
-		goto out;
-
 	ret = i915_gem_shmem_pread(dev, obj, args, file);
 
 out:
-- 
1.7.6.4

