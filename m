Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1KFTRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:17:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1KFTP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:28 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 04/13] drm/i915: merge shmem_pwrite slow&fast-path
Date: Sun,  6 Nov 2011 20:13:51 +0100
Message-Id: <1320606840-21132-5-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous rewrite, they've become essential identical.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |  126 ++++++++++----------------------------
 1 files changed, 33 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index be1dd4f..52fc0b5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -728,84 +728,11 @@ out_unpin_pages:
 	return ret;
 }
 
-/**
- * This is the fast shmem pwrite path, which attempts to directly
- * copy_from_user into the kmapped pages backing the object.
- */
-static int
-i915_gem_shmem_pwrite_fast(struct drm_device *dev,
-			   struct drm_i915_gem_object *obj,
-			   struct drm_i915_gem_pwrite *args,
-			   struct drm_file *file)
-{
-	struct address_space *mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
-	ssize_t remain;
-	loff_t offset;
-	char __user *user_data;
-	int page_offset, page_length;
-
-	user_data = (char __user *) (uintptr_t) args->data_ptr;
-	remain = args->size;
-
-	offset = args->offset;
-	obj->dirty = 1;
-
-	while (remain > 0) {
-		struct page *page;
-		char *vaddr;
-		int ret;
-
-		/* Operation in this page
-		 *
-		 * page_offset = offset within page
-		 * page_length = bytes to copy for this page
-		 */
-		page_offset = offset_in_page(offset);
-		page_length = remain;
-		if ((page_offset + remain) > PAGE_SIZE)
-			page_length = PAGE_SIZE - page_offset;
-
-		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
-
-		vaddr = kmap_atomic(page);
-		ret = __copy_from_user_inatomic(vaddr + page_offset,
-						user_data,
-						page_length);
-		kunmap_atomic(vaddr);
-
-		set_page_dirty(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
-
-		/* If we get a fault while copying data, then (presumably) our
-		 * source page isn't available.  Return the error and we'll
-		 * retry in the slow path.
-		 */
-		if (ret)
-			return -EFAULT;
-
-		remain -= page_length;
-		user_data += page_length;
-		offset += page_length;
-	}
-
-	return 0;
-}
-
-/**
- * This is the fallback shmem pwrite path, which uses get_user_pages to pin
- * the memory and maps it using kmap_atomic for copying.
- *
- * This avoids taking mmap_sem for faulting on the user's address while the
- * struct_mutex is held.
- */
 static int
-i915_gem_shmem_pwrite_slow(struct drm_device *dev,
-			   struct drm_i915_gem_object *obj,
-			   struct drm_i915_gem_pwrite *args,
-			   struct drm_file *file)
+i915_gem_shmem_pwrite(struct drm_device *dev,
+		      struct drm_i915_gem_object *obj,
+		      struct drm_i915_gem_pwrite *args,
+		      struct drm_file *file)
 {
 	struct address_space *mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
 	ssize_t remain;
@@ -813,6 +740,7 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 	char __user *user_data;
 	int shmem_page_offset, page_length, ret;
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
+	int hit_slowpath = 0;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -822,8 +750,6 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 	offset = args->offset;
 	obj->dirty = 1;
 
-	mutex_unlock(&dev->struct_mutex);
-
 	while (remain > 0) {
 		struct page *page;
 		char *vaddr;
@@ -847,6 +773,21 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 
 		page_do_bit17_swizzling = (page_to_phys(page) & (1 << 17)) == 0;
 
+		if (!obj_do_bit17_swizzling || !page_do_bit17_swizzling) {
+			vaddr = kmap_atomic(page);
+			ret = __copy_from_user_inatomic(vaddr + shmem_page_offset,
+							user_data,
+							page_length);
+			kunmap_atomic(vaddr);
+
+			if (ret == 0) 
+				goto next_page;
+		}
+
+		hit_slowpath = 1;
+
+		mutex_unlock(&dev->struct_mutex);
+
 		vaddr = kmap(page);
 		if (obj_do_bit17_swizzling && page_do_bit17_swizzling)
 			ret = __copy_from_user_swizzled(vaddr, shmem_page_offset,
@@ -858,6 +799,8 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 					       page_length);
 		kunmap(page);
 
+		mutex_lock(&dev->struct_mutex);
+next_page:
 		set_page_dirty(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
@@ -873,15 +816,16 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 	}
 
 out:
-	mutex_lock(&dev->struct_mutex);
-	/* Fixup: Kill any reinstated backing storage pages */
-	if (obj->madv == __I915_MADV_PURGED)
-		i915_gem_object_truncate(obj);
-	/* and flush dirty cachelines in case the object isn't in the cpu write
-	 * domain anymore. */
-	if (obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
-		i915_gem_clflush_object(obj);
-		intel_gtt_chipset_flush();
+	if (hit_slowpath) {
+		/* Fixup: Kill any reinstated backing storage pages */
+		if (obj->madv == __I915_MADV_PURGED)
+			i915_gem_object_truncate(obj);
+		/* and flush dirty cachelines in case the object isn't in the cpu write
+		 * domain anymore. */
+		if (obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
+			i915_gem_clflush_object(obj);
+			intel_gtt_chipset_flush();
+		}
 	}
 
 	return ret;
@@ -973,11 +917,7 @@ out_unpin:
 	if (ret)
 		goto out;
 
-	ret = -EFAULT;
-	if (!i915_gem_object_needs_bit17_swizzle(obj))
-		ret = i915_gem_shmem_pwrite_fast(dev, obj, args, file);
-	if (ret == -EFAULT)
-		ret = i915_gem_shmem_pwrite_slow(dev, obj, args, file);
+	ret = i915_gem_shmem_pwrite(dev, obj, args, file);
 
 out:
 	drm_gem_object_unreference(&obj->base);
-- 
1.7.6.4

