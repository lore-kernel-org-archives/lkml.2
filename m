Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0IZVHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:07:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:15990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0IZVHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:07:39 -0400
Message-Id: <8u3s8d$jmkug0@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,239,1283756400"; 
   d="scan'208";a="661289472"
Date: Sun, 26 Sep 2010 22:07:34 +0100
To: linux-kernel@vger.kernel.org, Hugh Dickens <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: How best to pin pages in physical memory?
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning I came to the sickening conclusion that there is
nothing in the drm/i915 driver that prevents the VM from swapping out
pages mapped into the GTT (i.e. pages that are currently being written
to or read from the GPU).

The following patch is what I hastily threw together after grepping the
sources for likely methods. A couple of considerations that need to be
taken into account are:

1. Not all pages allocated through the shmfs get_pages() allocator that
backs each GEM buffer object is mapped into the GTT. Though the actual
quantity of such pages are small and temporary

2. The GTT may be as large as 2GiB + a separate 2GiB that can be used
for a per-process GTT.

3. Forced eviction is currently the shrinker, which may wait upon the
GPU to finish and then unbind the pages from the GTT (and attempt to
return the memory to the system). It might be useful to throttle the GPU
and return the pages earlier to prevent the system from swapping?

If this looks like the continuation of the memory corruption saga caused
by i915.ko during suspend, it is.
-Chris

---
>From b3844cc3bd6fcbee7bbad640c91323f26904c1ce Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 26 Sep 2010 10:11:53 +0100
Subject: [PATCH] drm/i915: Mark pages mapped into the GTT as unevictable

If the GPU is currently reading and writing to pages, we need to prevent
the VM from swapping those out to disk...

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9f547ab..5fa6227 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1532,6 +1532,23 @@ i915_gem_mmap_gtt_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
+static void
+i915_gem_object_lock_pages(struct drm_i915_gem_object *obj, bool lock)
+{
+	struct address_space *mapping;
+	struct inode *inode;
+
+	inode = obj->base.filp->f_path.dentry->d_inode;
+	mapping = inode->i_mapping;
+
+	if (lock) {
+		mapping_set_unevictable(mapping);
+	} else {
+		mapping_clear_unevictable(mapping);
+		scan_mapping_unevictable_pages(mapping);
+	}
+}
+
 void
 i915_gem_object_put_pages(struct drm_gem_object *obj)
 {
@@ -2150,6 +2167,7 @@ i915_gem_object_unbind(struct drm_gem_object *obj)
 
 	list_del_init(&obj_priv->list);
 
+	i915_gem_object_lock_pages(obj_priv, false);
 	if (i915_gem_object_is_purgeable(obj_priv))
 		i915_gem_object_truncate(obj);
 
@@ -2751,6 +2769,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj,
 
 	obj_priv->mappable =
 		obj_priv->gtt_offset + obj->size <= dev_priv->mm.gtt_mappable_end;
+	i915_gem_object_lock_pages(obj_priv, true);
 
 	return 0;
 }
-- 
1.7.1

-- 
Chris Wilson, Intel Open Source Technology Centre
