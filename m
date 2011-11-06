Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1KFTPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40579 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1KFTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:30 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 05/13] drm/i915: merge shmem_pread slow&fast-path
Date: Sun,  6 Nov 2011 20:13:52 +0100
Message-Id: <1320606840-21132-6-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous rewrite, they've become essential identical.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |  108 ++++++++++-----------------------------
 1 files changed, 27 insertions(+), 81 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 52fc0b5..5eec933 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -277,66 +277,6 @@ slow_shmem_copy(struct page *dst_page,
 	kunmap(dst_page);
 }
 
-/**
- * This is the fast shmem pread path, which attempts to copy_from_user directly
- * from the backing pages of the object to the user's address space.  On a
- * fault, it fails so we can fall back to i915_gem_shmem_pwrite_slow().
- */
-static int
-i915_gem_shmem_pread_fast(struct drm_device *dev,
-			  struct drm_i915_gem_object *obj,
-			  struct drm_i915_gem_pread *args,
-			  struct drm_file *file)
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
-		ret = __copy_to_user_inatomic(user_data,
-					      vaddr + page_offset,
-					      page_length);
-		kunmap_atomic(vaddr);
-
-		mark_page_accessed(page);
-		page_cache_release(page);
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
 static inline int
 __copy_to_user_swizzled(char __user *cpu_vaddr,
 			const char *gpu_vaddr, int gpu_offset,
@@ -389,17 +329,11 @@ __copy_from_user_swizzled(char __user *gpu_vaddr, int gpu_offset,
 	return 0;
 }
 
-/**
- * This is the fallback shmem pread path, which allocates temporary storage
- * in kernel space to copy_to_user into outside of the struct_mutex, so we
- * can copy out of the object's backing pages while holding the struct mutex
- * and not take page faults.
- */
 static int
-i915_gem_shmem_pread_slow(struct drm_device *dev,
-			  struct drm_i915_gem_object *obj,
-			  struct drm_i915_gem_pread *args,
-			  struct drm_file *file)
+i915_gem_shmem_pread(struct drm_device *dev,
+		     struct drm_i915_gem_object *obj,
+		     struct drm_i915_gem_pread *args,
+		     struct drm_file *file)
 {
 	struct address_space *mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
 	char __user *user_data;
@@ -407,6 +341,7 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 	loff_t offset;
 	int shmem_page_offset, page_length, ret;
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
+	int hit_slowpath = 0;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -415,8 +350,6 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 
 	offset = args->offset;
 
-	mutex_unlock(&dev->struct_mutex);
-
 	while (remain > 0) {
 		struct page *page;
 		char *vaddr;
@@ -439,6 +372,20 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 
 		page_do_bit17_swizzling = (page_to_phys(page) & (1 << 17)) == 0;
 
+		if (!obj_do_bit17_swizzling || !page_do_bit17_swizzling) {
+			vaddr = kmap_atomic(page);
+			ret = __copy_to_user_inatomic(user_data,
+						      vaddr + shmem_page_offset,
+						      page_length);
+			kunmap_atomic(vaddr);
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
 			ret = __copy_to_user_swizzled(user_data,
@@ -450,6 +397,8 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 					     page_length);
 		kunmap(page);
 
+		mutex_lock(&dev->struct_mutex);
+next_page:
 		mark_page_accessed(page);
 		page_cache_release(page);
 
@@ -464,10 +413,11 @@ i915_gem_shmem_pread_slow(struct drm_device *dev,
 	}
 
 out:
-	mutex_lock(&dev->struct_mutex);
-	/* Fixup: Kill any reinstated backing storage pages */
-	if (obj->madv == __I915_MADV_PURGED)
-		i915_gem_object_truncate(obj);
+	if (hit_slowpath) {
+		/* Fixup: Kill any reinstated backing storage pages */
+		if (obj->madv == __I915_MADV_PURGED)
+			i915_gem_object_truncate(obj);
+	}
 
 	return ret;
 }
@@ -523,11 +473,7 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 	if (ret)
 		goto out;
 
-	ret = -EFAULT;
-	if (!i915_gem_object_needs_bit17_swizzle(obj))
-		ret = i915_gem_shmem_pread_fast(dev, obj, args, file);
-	if (ret == -EFAULT)
-		ret = i915_gem_shmem_pread_slow(dev, obj, args, file);
+	ret = i915_gem_shmem_pread(dev, obj, args, file);
 
 out:
 	drm_gem_object_unreference(&obj->base);
-- 
1.7.6.4

