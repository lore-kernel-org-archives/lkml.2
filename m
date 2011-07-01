Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1GAJTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:19:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33163 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1GAJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:18:25 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 07/10] drm/i915/evict: Ensure we completely cleanup on failure" has been added to staging queue
Date: Fri,  1 Jul 2011 10:18:22 +0100
Message-Id: <1309511902-3080-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 07/10] drm/i915/evict: Ensure we completely cleanup on failure

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 2f4f8bc3da84232a25e0ced165d4bb5643d3aaad Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 17 Jun 2011 10:04:22 -0500
Subject: [PATCH 07/10] drm/i915/evict: Ensure we completely cleanup on failure

BugLink: http://bugs.launchpad.net/bugs/599017

... and not leave the objects in a inconsistent state.

[seth.forshee@canonical.com: Also backported similar cleanups in success
 path from commit e39a01501b228e1be2037d5bddccae2a820af902]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org
(backported from commit 092de6f225638ec300936bfcbdc67805733cc78c upstream)

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_evict.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 84ed1a7..9c1ec78 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -134,9 +134,15 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 	}

 	/* Nothing found, clean up and bail out! */
-	list_for_each_entry(obj_priv, &unwind_list, evict_list) {
+	while (!list_empty(&unwind_list)) {
+		obj_priv = list_first_entry(&unwind_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
+
 		ret = drm_mm_scan_remove_block(obj_priv->gtt_space);
 		BUG_ON(ret);
+
+		list_del_init(&obj_priv->evict_list);
 	}

 	/* We expect the caller to unpin, evict all and try again, or give up.
@@ -145,26 +151,28 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 	return -ENOSPC;

 found:
+	/* drm_mm doesn't allow any other other operations while
+	 * scanning, therefore store to be evicted objects on a
+	 * temporary list. */
 	INIT_LIST_HEAD(&eviction_list);
 	list_for_each_entry_safe(obj_priv, tmp_obj_priv,
 				 &unwind_list, evict_list) {
 		if (drm_mm_scan_remove_block(obj_priv->gtt_space)) {
-			/* drm_mm doesn't allow any other other operations while
-			 * scanning, therefore store to be evicted objects on a
-			 * temporary list. */
 			list_move(&obj_priv->evict_list, &eviction_list);
+			continue;
 		}
+		list_del_init(&obj_priv->evict_list);
 	}

 	/* Unbinding will emit any required flushes */
-	list_for_each_entry_safe(obj_priv, tmp_obj_priv,
-				 &eviction_list, evict_list) {
-#if WATCH_LRU
-		DRM_INFO("%s: evicting %p\n", __func__, obj);
-#endif
-		ret = i915_gem_object_unbind(obj_priv->obj);
-		if (ret)
-			return ret;
+	while (!list_empty(&eviction_list)) {
+		obj_priv = list_first_entry(&eviction_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
+		if (ret == 0)
+			ret = i915_gem_object_unbind(obj_priv->obj);
+
+		list_del_init(&obj_priv->evict_list);
 	}

 	/* The just created free hole should be on the top of the free stack
--
1.7.4.1

