Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1KFTPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:35 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40579 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1KFTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:33 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 08/13] drm/i915: kill ranged cpu read domain support
Date: Sun,  6 Nov 2011 20:13:55 +0100
Message-Id: <1320606840-21132-9-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer needed.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_drv.h |    7 --
 drivers/gpu/drm/i915/i915_gem.c |  117 ---------------------------------------
 2 files changed, 0 insertions(+), 124 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 25036f5..fe4b680 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -861,13 +861,6 @@ struct drm_i915_gem_object {
 	/** Record of address bit 17 of each page at last unbind. */
 	unsigned long *bit_17;
 
-
-	/**
-	 * If present, while GEM_DOMAIN_CPU is in the read domain this array
-	 * flags which individual pages are valid.
-	 */
-	uint8_t *page_cpu_valid;
-
 	/** User space pin count and filp owning the pin */
 	uint32_t user_pin_count;
 	struct drm_file *pin_filp;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0e9cc81..0048917 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -41,10 +41,6 @@ static void i915_gem_object_flush_gtt_write_domain(struct drm_i915_gem_object *o
 static void i915_gem_object_flush_cpu_write_domain(struct drm_i915_gem_object *obj);
 static __must_check int i915_gem_object_set_to_cpu_domain(struct drm_i915_gem_object *obj,
 							  bool write);
-static __must_check int i915_gem_object_set_cpu_read_domain_range(struct drm_i915_gem_object *obj,
-								  uint64_t offset,
-								  uint64_t size);
-static void i915_gem_object_set_to_full_cpu_read_domain(struct drm_i915_gem_object *obj);
 static __must_check int i915_gem_object_bind_to_gtt(struct drm_i915_gem_object *obj,
 						    unsigned alignment,
 						    bool map_and_fenceable);
@@ -2964,11 +2960,6 @@ i915_gem_object_set_to_cpu_domain(struct drm_i915_gem_object *obj, bool write)
 
 	i915_gem_object_flush_gtt_write_domain(obj);
 
-	/* If we have a partially-valid cache of the object in the CPU,
-	 * finish invalidating it and free the per-page flags.
-	 */
-	i915_gem_object_set_to_full_cpu_read_domain(obj);
-
 	old_write_domain = obj->base.write_domain;
 	old_read_domains = obj->base.read_domains;
 
@@ -2999,113 +2990,6 @@ i915_gem_object_set_to_cpu_domain(struct drm_i915_gem_object *obj, bool write)
 	return 0;
 }
 
-/**
- * Moves the object from a partially CPU read to a full one.
- *
- * Note that this only resolves i915_gem_object_set_cpu_read_domain_range(),
- * and doesn't handle transitioning from !(read_domains & I915_GEM_DOMAIN_CPU).
- */
-static void
-i915_gem_object_set_to_full_cpu_read_domain(struct drm_i915_gem_object *obj)
-{
-	if (!obj->page_cpu_valid)
-		return;
-
-	/* If we're partially in the CPU read domain, finish moving it in.
-	 */
-	if (obj->base.read_domains & I915_GEM_DOMAIN_CPU) {
-		int i;
-
-		for (i = 0; i <= (obj->base.size - 1) / PAGE_SIZE; i++) {
-			if (obj->page_cpu_valid[i])
-				continue;
-			drm_clflush_pages(obj->pages + i, 1);
-		}
-	}
-
-	/* Free the page_cpu_valid mappings which are now stale, whether
-	 * or not we've got I915_GEM_DOMAIN_CPU.
-	 */
-	kfree(obj->page_cpu_valid);
-	obj->page_cpu_valid = NULL;
-}
-
-/**
- * Set the CPU read domain on a range of the object.
- *
- * The object ends up with I915_GEM_DOMAIN_CPU in its read flags although it's
- * not entirely valid.  The page_cpu_valid member of the object flags which
- * pages have been flushed, and will be respected by
- * i915_gem_object_set_to_cpu_domain() if it's called on to get a valid mapping
- * of the whole object.
- *
- * This function returns when the move is complete, including waiting on
- * flushes to occur.
- */
-static int
-i915_gem_object_set_cpu_read_domain_range(struct drm_i915_gem_object *obj,
-					  uint64_t offset, uint64_t size)
-{
-	uint32_t old_read_domains;
-	int i, ret;
-
-	if (offset == 0 && size == obj->base.size)
-		return i915_gem_object_set_to_cpu_domain(obj, 0);
-
-	ret = i915_gem_object_flush_gpu_write_domain(obj);
-	if (ret)
-		return ret;
-
-	ret = i915_gem_object_wait_rendering(obj);
-	if (ret)
-		return ret;
-
-	i915_gem_object_flush_gtt_write_domain(obj);
-
-	/* If we're already fully in the CPU read domain, we're done. */
-	if (obj->page_cpu_valid == NULL &&
-	    (obj->base.read_domains & I915_GEM_DOMAIN_CPU) != 0)
-		return 0;
-
-	/* Otherwise, create/clear the per-page CPU read domain flag if we're
-	 * newly adding I915_GEM_DOMAIN_CPU
-	 */
-	if (obj->page_cpu_valid == NULL) {
-		obj->page_cpu_valid = kzalloc(obj->base.size / PAGE_SIZE,
-					      GFP_KERNEL);
-		if (obj->page_cpu_valid == NULL)
-			return -ENOMEM;
-	} else if ((obj->base.read_domains & I915_GEM_DOMAIN_CPU) == 0)
-		memset(obj->page_cpu_valid, 0, obj->base.size / PAGE_SIZE);
-
-	/* Flush the cache on any pages that are still invalid from the CPU's
-	 * perspective.
-	 */
-	for (i = offset / PAGE_SIZE; i <= (offset + size - 1) / PAGE_SIZE;
-	     i++) {
-		if (obj->page_cpu_valid[i])
-			continue;
-
-		drm_clflush_pages(obj->pages + i, 1);
-
-		obj->page_cpu_valid[i] = 1;
-	}
-
-	/* It should now be out of any other write domains, and we can update
-	 * the domain values for our changes.
-	 */
-	BUG_ON((obj->base.write_domain & ~I915_GEM_DOMAIN_CPU) != 0);
-
-	old_read_domains = obj->base.read_domains;
-	obj->base.read_domains |= I915_GEM_DOMAIN_CPU;
-
-	trace_i915_gem_object_change_domain(obj,
-					    old_read_domains,
-					    obj->base.write_domain);
-
-	return 0;
-}
-
 /* Throttle our rendering by waiting until the ring has completed our requests
  * emitted over 20 msec ago.
  *
@@ -3521,7 +3405,6 @@ static void i915_gem_free_object_tail(struct drm_i915_gem_object *obj)
 	drm_gem_object_release(&obj->base);
 	i915_gem_info_remove_obj(dev_priv, obj->base.size);
 
-	kfree(obj->page_cpu_valid);
 	kfree(obj->bit_17);
 	kfree(obj);
 }
-- 
1.7.6.4

