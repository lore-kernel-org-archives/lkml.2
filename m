Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1KFTQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:16:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1KFTPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:36 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 10/13] drm/i915: don't call shmem_read_mapping unnecessarily
Date: Sun,  6 Nov 2011 20:13:57 +0100
Message-Id: <1320606840-21132-11-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This speeds up pwrite and pread from ~120 µs ro ~100 µs for
reading/writing 1mb on my snb (if the backing storage pages
are already pinned, of course).

v2: Chris Wilson pointed out a claring page reference bug - I've
unconditionally dropped the reference. With that fixed (and the
associated reduction of dirt in dmesg) it's now even a notch faster.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |   42 +++++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 8fd175c..5b8a7c5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -339,6 +339,7 @@ i915_gem_shmem_pread(struct drm_device *dev,
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
 	int hit_slowpath = 0;
 	int needs_clflush = 0;
+	int release_page;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -373,10 +374,16 @@ i915_gem_shmem_pread(struct drm_device *dev,
 		if ((shmem_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - shmem_page_offset;
 
-		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
-		if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
-			goto out;
+		if (obj->pages) {
+			page = obj->pages[offset >> PAGE_SHIFT];
+			release_page = 0;
+		} else {
+			page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
+			if (IS_ERR(page)) {
+				ret = PTR_ERR(page);
+				goto out;
+			}
+			release_page = 1;
 		}
 
 		page_do_bit17_swizzling = (page_to_phys(page) & (1 << 17)) == 0;
@@ -395,6 +402,9 @@ i915_gem_shmem_pread(struct drm_device *dev,
 		}
 
 		hit_slowpath = 1;
+		if (!release_page)
+			page_cache_get(page);
+		release_page = 1;
 
 		mutex_unlock(&dev->struct_mutex);
 
@@ -416,7 +426,8 @@ i915_gem_shmem_pread(struct drm_device *dev,
 		mutex_lock(&dev->struct_mutex);
 next_page:
 		mark_page_accessed(page);
-		page_cache_release(page);
+		if (release_page)
+			page_cache_release(page);
 
 		if (ret) {
 			ret = -EFAULT;
@@ -697,6 +708,7 @@ i915_gem_shmem_pwrite(struct drm_device *dev,
 	int shmem_page_offset, page_length, ret;
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
 	int hit_slowpath = 0;
+	int release_page;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -721,10 +733,16 @@ i915_gem_shmem_pwrite(struct drm_device *dev,
 		if ((shmem_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - shmem_page_offset;
 
-		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
-		if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
-			goto out;
+		if (obj->pages) {
+			page = obj->pages[offset >> PAGE_SHIFT];
+			release_page = 0;
+		} else {
+			page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
+			if (IS_ERR(page)) {
+				ret = PTR_ERR(page);
+				goto out;
+			}
+			release_page = 1;
 		}
 
 		page_do_bit17_swizzling = (page_to_phys(page) & (1 << 17)) == 0;
@@ -741,6 +759,9 @@ i915_gem_shmem_pwrite(struct drm_device *dev,
 		}
 
 		hit_slowpath = 1;
+		if (!release_page)
+			page_cache_get(page);
+		release_page = 1;
 
 		mutex_unlock(&dev->struct_mutex);
 
@@ -759,7 +780,8 @@ i915_gem_shmem_pwrite(struct drm_device *dev,
 next_page:
 		set_page_dirty(page);
 		mark_page_accessed(page);
-		page_cache_release(page);
+		if (release_page)
+			page_cache_release(page);
 
 		if (ret) {
 			ret = -EFAULT;
-- 
1.7.6.4

