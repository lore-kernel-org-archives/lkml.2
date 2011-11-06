Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1KFTPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1KFTPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:41 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 13/13] drm/i915: don't clobber userspace memory before commiting to the pread
Date: Sun,  6 Nov 2011 20:14:00 +0100
Message-Id: <1320606840-21132-14-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pagemap.h prefault helpers do the prefaulting by simply writing
some data into every page. Hence we should not prefault when we're not
yet commited to to actually writing data to userspace. The problem is
now that
- we can't prefault while holding dev->struct_mutex for we could
  deadlock with our own pagefault handler
- we need to grab dev->struct_mutex before copying to sync up with any
  outsanding gpu writes.

Therefore only prefault when we're dropping the lock the first time in
the pread slowpath - at that point we're committed to the write, don't
wait on the gpu anymore and hence won't return early (with e.g.
-EINTR).

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0a374e1..ebaa0f0 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -338,6 +338,7 @@ i915_gem_shmem_pread(struct drm_device *dev,
 	int shmem_page_offset, page_length, ret;
 	int obj_do_bit17_swizzling, page_do_bit17_swizzling;
 	int hit_slowpath = 0;
+	int prefaulted = 0;
 	int needs_clflush = 0;
 	int release_page;
 
@@ -408,6 +409,16 @@ i915_gem_shmem_pread(struct drm_device *dev,
 
 		mutex_unlock(&dev->struct_mutex);
 
+		if (!prefaulted) {
+			ret = fault_in_pages_writeable(user_data, remain);
+			/* Userspace is tricking us, but we've already clobbered
+			 * its pages with the prefault and promised to write the
+			 * data up to the first fault. Hence ignore any errors
+			 * and just continue. */
+			(void)ret;
+			prefaulted = 1;
+		}
+
 		vaddr = kmap(page);
 		if (needs_clflush)
 			drm_clflush_virt_range(vaddr + shmem_page_offset,
@@ -470,11 +481,6 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 		       args->size))
 		return -EFAULT;
 
-	ret = fault_in_pages_writeable((char __user *)(uintptr_t)args->data_ptr,
-				       args->size);
-	if (ret)
-		return -EFAULT;
-
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		return ret;
-- 
1.7.6.4

