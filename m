Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab1JEKy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:54:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab1JEKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:54:27 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.46+drm33.20
Date: Wed,  5 Oct 2011 12:54:24 +0200
Message-Id: <1317812064-10425-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.46+drm33.20 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/i915: Remove BUG_ON from i915_gem_evict_something
* drm/i915: Hold a reference to the object whilst unbinding the eviction list
* drm/i915: Fix refleak during eviction.
* drm/ttm: fix ttm_bo_add_ttm(user) failure path
* Linux 2.6.32.46+drm33.20

 Makefile                              |    2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c |   21 ++++++++++-----------
 drivers/gpu/drm/ttm/ttm_bo.c          |    4 +++-
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index cff7033..51931a6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .46+drm33.19
+EXTRAVERSION = .46+drm33.20
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 9c1ec78..9e7f9c6 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -52,6 +52,7 @@ mark_free(struct drm_i915_gem_object *obj_priv,
 	   struct list_head *unwind)
 {
 	list_add(&obj_priv->evict_list, unwind);
+	drm_gem_object_reference(obj_priv->obj);
 	return drm_mm_scan_add_block(obj_priv->gtt_space);
 }

@@ -64,7 +65,7 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct list_head eviction_list, unwind_list;
-	struct drm_i915_gem_object *obj_priv, *tmp_obj_priv;
+	struct drm_i915_gem_object *obj_priv;
 	struct list_head *iter;
 	int ret = 0;

@@ -143,6 +144,7 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 		BUG_ON(ret);

 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

 	/* We expect the caller to unpin, evict all and try again, or give up.
@@ -155,13 +157,16 @@ found:
 	 * scanning, therefore store to be evicted objects on a
 	 * temporary list. */
 	INIT_LIST_HEAD(&eviction_list);
-	list_for_each_entry_safe(obj_priv, tmp_obj_priv,
-				 &unwind_list, evict_list) {
+	while (!list_empty(&unwind_list)) {
+		obj_priv = list_first_entry(&unwind_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
 		if (drm_mm_scan_remove_block(obj_priv->gtt_space)) {
 			list_move(&obj_priv->evict_list, &eviction_list);
 			continue;
 		}
 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

 	/* Unbinding will emit any required flushes */
@@ -173,16 +178,10 @@ found:
 			ret = i915_gem_object_unbind(obj_priv->obj);

 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

-	/* The just created free hole should be on the top of the free stack
-	 * maintained by drm_mm, so this BUG_ON actually executes in O(1).
-	 * Furthermore all accessed data has just recently been used, so it
-	 * should be really fast, too. */
-	BUG_ON(!drm_mm_search_free(&dev_priv->mm.gtt_space, min_size,
-				   alignment, 0));
-
-	return 0;
+	return ret;
 }

 int
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index acbfa27..94706ef 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -343,8 +343,10 @@ static int ttm_bo_add_ttm(struct ttm_buffer_object *bo, bool zero_alloc)

 		ret = ttm_tt_set_user(bo->ttm, current,
 				      bo->buffer_start, bo->num_pages);
-		if (unlikely(ret != 0))
+		if (unlikely(ret != 0)) {
 			ttm_tt_destroy(bo->ttm);
+			bo->ttm = NULL;
+		}
 		break;
 	default:
 		printk(KERN_ERR TTM_PFX "Illegal buffer object type\n");
