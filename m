Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936703Ab2C3W50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:57:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47253 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934920Ab2C3VFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:46 -0400
Message-Id: <20120330195729.586439086@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 052/108] drm/radeon: Restrict offset for legacy hardware cursor.
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit c4353016dac10133fa5d8535af83f0c4845a2915 upstream.

The hardware only takes 27 bits for the offset, so larger offsets are
truncated, and the hardware cursor shows random bits other than the intended
ones.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=46796

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>

---
 drivers/gpu/drm/radeon/radeon_cursor.c |   13 +++++++++++--
 drivers/gpu/drm/radeon/radeon_object.c |   18 +++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_object.h |    2 ++
 3 files changed, 30 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -151,7 +151,9 @@ int radeon_crtc_cursor_set(struct drm_cr
 			   uint32_t height)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct radeon_device *rdev = crtc->dev->dev_private;
 	struct drm_gem_object *obj;
+	struct radeon_bo *robj;
 	uint64_t gpu_addr;
 	int ret;
 
@@ -173,7 +175,15 @@ int radeon_crtc_cursor_set(struct drm_cr
 		return -ENOENT;
 	}
 
-	ret = radeon_gem_object_pin(obj, RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
+	robj = gem_to_radeon_bo(obj);
+	ret = radeon_bo_reserve(robj, false);
+	if (unlikely(ret != 0))
+		goto fail;
+	/* Only 27 bit offset for legacy cursor */
+	ret = radeon_bo_pin_restricted(robj, RADEON_GEM_DOMAIN_VRAM,
+				       ASIC_IS_AVIVO(rdev) ? 0 : 1 << 27,
+				       &gpu_addr);
+	radeon_bo_unreserve(robj);
 	if (ret)
 		goto fail;
 
@@ -181,7 +191,6 @@ int radeon_crtc_cursor_set(struct drm_cr
 	radeon_crtc->cursor_height = height;
 
 	radeon_lock_cursor(crtc, true);
-	/* XXX only 27 bit offset for legacy cursor */
 	radeon_set_cursor(crtc, obj, gpu_addr);
 	radeon_show_cursor(crtc);
 	radeon_lock_cursor(crtc, false);
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -204,7 +204,8 @@ void radeon_bo_unref(struct radeon_bo **
 		*bo = NULL;
 }
 
-int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr)
+int radeon_bo_pin_restricted(struct radeon_bo *bo, u32 domain, u64 max_offset,
+			     u64 *gpu_addr)
 {
 	int r, i;
 
@@ -212,6 +213,7 @@ int radeon_bo_pin(struct radeon_bo *bo,
 		bo->pin_count++;
 		if (gpu_addr)
 			*gpu_addr = radeon_bo_gpu_offset(bo);
+		WARN_ON_ONCE(max_offset != 0);
 		return 0;
 	}
 	radeon_ttm_placement_from_domain(bo, domain);
@@ -219,6 +221,15 @@ int radeon_bo_pin(struct radeon_bo *bo,
 		/* force to pin into visible video ram */
 		bo->placement.lpfn = bo->rdev->mc.visible_vram_size >> PAGE_SHIFT;
 	}
+	if (max_offset) {
+		u64 lpfn = max_offset >> PAGE_SHIFT;
+
+		if (!bo->placement.lpfn)
+			bo->placement.lpfn = bo->rdev->mc.gtt_size >> PAGE_SHIFT;
+
+		if (lpfn < bo->placement.lpfn)
+			bo->placement.lpfn = lpfn;
+	}
 	for (i = 0; i < bo->placement.num_placement; i++)
 		bo->placements[i] |= TTM_PL_FLAG_NO_EVICT;
 	r = ttm_bo_validate(&bo->tbo, &bo->placement, false, false, false);
@@ -232,6 +243,11 @@ int radeon_bo_pin(struct radeon_bo *bo,
 	return r;
 }
 
+int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr)
+{
+	return radeon_bo_pin_restricted(bo, domain, 0, gpu_addr);
+}
+
 int radeon_bo_unpin(struct radeon_bo *bo)
 {
 	int r, i;
--- a/drivers/gpu/drm/radeon/radeon_object.h
+++ b/drivers/gpu/drm/radeon/radeon_object.h
@@ -144,6 +144,8 @@ extern int radeon_bo_kmap(struct radeon_
 extern void radeon_bo_kunmap(struct radeon_bo *bo);
 extern void radeon_bo_unref(struct radeon_bo **bo);
 extern int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr);
+extern int radeon_bo_pin_restricted(struct radeon_bo *bo, u32 domain,
+				    u64 max_offset, u64 *gpu_addr);
 extern int radeon_bo_unpin(struct radeon_bo *bo);
 extern int radeon_bo_evict_vram(struct radeon_device *rdev);
 extern void radeon_bo_force_delete(struct radeon_device *rdev);


