Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1KFTSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:18:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1KFTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:25 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 02/13] drm/i915: rewrite shmem_pwrite_slow to use copy_from_user
Date: Sun,  6 Nov 2011 20:13:49 +0100
Message-Id: <1320606840-21132-3-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... instead of get_user_pages, because that fails on non page-backed
user addresses like e.g. a gtt mapping of a bo.

To get there essentially copy the vfs read path into pagecache. We
can't call that right away because we have to take care of bit17
swizzling. To not deadlock with our own pagefault handler we need
to completely drop struct_mutex, reducing the atomicty-guarantees
of our userspace abi. Implications for racing with other gem ioctl:

- execbuf, pwrite, pread: Due to -EFAULT fallback to slow paths there's
  already the risk of the pwrite call not being atomic, no degration.
- read/write access to mmaps: already fully racy, no degration.
- set_tiling: Calling set_tiling while reading/writing is already
  pretty much undefined, now it just got a bit worse. set_tiling is
  only called by libdrm on unused/new bos, so no problem.
- set_domain: When changing to the gtt domain while copying (without any
  read/write access, e.g. for synchronization), we might leave unflushed
  data in the cpu caches. The clflush_object at the end of pwrite_slow
  takes care of this problem.
- truncating of purgeable objects: the shmem_read_mapping_page call could
  reinstate backing storage for truncated objects. The check at the end
  of pwrite_slow takes care of this.

v2:
- add missing intel_gtt_chipset_flush
- add __ to copy_from_user_swizzled as suggest by Chris Wilson.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |  126 ++++++++++++++++++++-------------------
 1 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 6fa24bc..f9efebb 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -58,6 +58,7 @@ static void i915_gem_free_object_tail(struct drm_i915_gem_object *obj);
 
 static int i915_gem_inactive_shrink(struct shrinker *shrinker,
 				    struct shrink_control *sc);
+static void i915_gem_object_truncate(struct drm_i915_gem_object *obj);
 
 /* some bookkeeping */
 static void i915_gem_info_add_obj(struct drm_i915_private *dev_priv,
@@ -385,6 +386,32 @@ i915_gem_shmem_pread_fast(struct drm_device *dev,
 	return 0;
 }
 
+static inline int
+__copy_from_user_swizzled(char __user *gpu_vaddr, int gpu_offset,
+			  const char *cpu_vaddr,
+			  int length)
+{
+	int ret, cpu_offset = 0;
+
+	while (length > 0) {
+		int cacheline_end = ALIGN(gpu_offset + 1, 64);
+		int this_length = min(cacheline_end - gpu_offset, length);
+		int swizzled_gpu_offset = gpu_offset ^ 64;
+
+		ret = __copy_from_user(gpu_vaddr + swizzled_gpu_offset,
+				       cpu_vaddr + cpu_offset,
+				       this_length);
+		if (ret)
+			return ret + length;
+
+		cpu_offset += this_length;
+		gpu_offset += this_length;
+		length -= this_length;
+	}
+
+	return 0;
+}
+
 /**
  * This is the fallback shmem pread path, which allocates temporary storage
  * in kernel space to copy_to_user into outside of the struct_mutex, so we
@@ -841,71 +868,36 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 			   struct drm_file *file)
 {
 	struct address_space *mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
-	struct mm_struct *mm = current->mm;
-	struct page **user_pages;
 	ssize_t remain;
-	loff_t offset, pinned_pages, i;
-	loff_t first_data_page, last_data_page, num_pages;
-	int shmem_page_offset;
-	int data_page_index,  data_page_offset;
-	int page_length;
-	int ret;
-	uint64_t data_ptr = args->data_ptr;
-	int do_bit17_swizzling;
+	loff_t offset;
+	char __user *user_data;
+	int shmem_page_offset, page_length, ret;
+	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
 
+	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
 
-	/* Pin the user pages containing the data.  We can't fault while
-	 * holding the struct mutex, and all of the pwrite implementations
-	 * want to hold it while dereferencing the user data.
-	 */
-	first_data_page = data_ptr / PAGE_SIZE;
-	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
-	num_pages = last_data_page - first_data_page + 1;
-
-	user_pages = drm_malloc_ab(num_pages, sizeof(struct page *));
-	if (user_pages == NULL)
-		return -ENOMEM;
-
-	mutex_unlock(&dev->struct_mutex);
-	down_read(&mm->mmap_sem);
-	pinned_pages = get_user_pages(current, mm, (uintptr_t)args->data_ptr,
-				      num_pages, 0, 0, user_pages, NULL);
-	up_read(&mm->mmap_sem);
-	mutex_lock(&dev->struct_mutex);
-	if (pinned_pages < num_pages) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	ret = i915_gem_object_set_to_cpu_domain(obj, 1);
-	if (ret)
-		goto out;
-
-	do_bit17_swizzling = i915_gem_object_needs_bit17_swizzle(obj);
+	obj_do_bit17_swizzling = i915_gem_object_needs_bit17_swizzle(obj);
 
 	offset = args->offset;
 	obj->dirty = 1;
 
+	mutex_unlock(&dev->struct_mutex);
+
 	while (remain > 0) {
 		struct page *page;
+		char *vaddr;
 
 		/* Operation in this page
 		 *
 		 * shmem_page_offset = offset within page in shmem file
-		 * data_page_index = page number in get_user_pages return
-		 * data_page_offset = offset with data_page_index page.
 		 * page_length = bytes to copy for this page
 		 */
 		shmem_page_offset = offset_in_page(offset);
-		data_page_index = data_ptr / PAGE_SIZE - first_data_page;
-		data_page_offset = offset_in_page(data_ptr);
 
 		page_length = remain;
 		if ((shmem_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - shmem_page_offset;
-		if ((data_page_offset + page_length) > PAGE_SIZE)
-			page_length = PAGE_SIZE - data_page_offset;
 
 		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
@@ -913,34 +905,44 @@ i915_gem_shmem_pwrite_slow(struct drm_device *dev,
 			goto out;
 		}
 
-		if (do_bit17_swizzling) {
-			slow_shmem_bit17_copy(page,
-					      shmem_page_offset,
-					      user_pages[data_page_index],
-					      data_page_offset,
-					      page_length,
-					      0);
-		} else {
-			slow_shmem_copy(page,
-					shmem_page_offset,
-					user_pages[data_page_index],
-					data_page_offset,
-					page_length);
-		}
+		page_do_bit17_swizzling = (page_to_phys(page) & (1 << 17)) == 0;
+
+		vaddr = kmap(page);
+		if (obj_do_bit17_swizzling && page_do_bit17_swizzling)
+			ret = __copy_from_user_swizzled(vaddr, shmem_page_offset,
+							user_data,
+							page_length);
+		else
+			ret = __copy_from_user(vaddr + shmem_page_offset,
+					       user_data,
+					       page_length);
+		kunmap(page);
 
 		set_page_dirty(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
 
+		if (ret) {
+			ret = -EFAULT;
+			goto out;
+		}
+
 		remain -= page_length;
-		data_ptr += page_length;
+		user_data += page_length;
 		offset += page_length;
 	}
 
 out:
-	for (i = 0; i < pinned_pages; i++)
-		page_cache_release(user_pages[i]);
-	drm_free_large(user_pages);
+	mutex_lock(&dev->struct_mutex);
+	/* Fixup: Kill any reinstated backing storage pages */
+	if (obj->madv == __I915_MADV_PURGED)
+		i915_gem_object_truncate(obj);
+	/* and flush dirty cachelines in case the object isn't in the cpu write
+	 * domain anymore. */
+	if (obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
+		i915_gem_clflush_object(obj);
+		intel_gtt_chipset_flush();
+	}
 
 	return ret;
 }
-- 
1.7.6.4

