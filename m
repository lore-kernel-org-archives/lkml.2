Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1DZM21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:28:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57395 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1DZM0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:41 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>, maximilian attems <max@stro.at>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 13/21] drm/ttm: Fix two race conditions + fix busy codepaths" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:37 +0200
Message-Id: <1303820797-3777-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 13/21] drm/ttm: Fix two race conditions + fix busy codepaths

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From abe1b615868ac1a52d195362bc98c3f466dc8ade Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Thu, 30 Sep 2010 12:36:45 +0200
Subject: [PATCH 13/21] drm/ttm: Fix two race conditions + fix busy codepaths

commit 1df6a2ebd75067aefbdf07482bf8e3d0584e04ee upstream.

This fixes a race pointed out by Dave Airlie where we don't take a buffer
object about to be destroyed off the LRU lists properly. It also fixes a rare
case where a buffer object could be destroyed in the middle of an
accelerated eviction.

The patch also adds a utility function that can be used to prematurely
release GPU memory space usage of an object waiting to be destroyed.
For example during eviction or swapout.

The above mentioned commit didn't queue the buffer on the delayed destroy
list under some rare circumstances. It also didn't completely honor the
remove_all parameter.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=615505
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=591061

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ Backported to 2.6.33 -maks ]
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |   84 +++++++++++++++++++++++++++++++++++------
 include/drm/ttm/ttm_bo_api.h |    4 +-
 2 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c7320ce..acbfa27 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -443,6 +443,43 @@ out_err:
 }

 /**
+ * Call bo::reserved and with the lru lock held.
+ * Will release GPU memory type usage on destruction.
+ * This is the place to put in driver specific hooks.
+ * Will release the bo::reserved lock and the
+ * lru lock on exit.
+ */
+
+static void ttm_bo_cleanup_memtype_use(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_global *glob = bo->glob;
+
+	if (bo->ttm) {
+
+		/**
+		 * Release the lru_lock, since we don't want to have
+		 * an atomic requirement on ttm_tt[unbind|destroy].
+		 */
+
+		spin_unlock(&glob->lru_lock);
+		ttm_tt_unbind(bo->ttm);
+		ttm_tt_destroy(bo->ttm);
+		bo->ttm = NULL;
+		spin_lock(&glob->lru_lock);
+	}
+
+	if (bo->mem.mm_node) {
+		drm_mm_put_block(bo->mem.mm_node);
+		bo->mem.mm_node = NULL;
+	}
+
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	spin_unlock(&glob->lru_lock);
+}
+
+
+/**
  * If bo idle, remove from delayed- and lru lists, and unref.
  * If not idle, and already on delayed list, do nothing.
  * If not idle, and not on delayed list, put on delayed list,
@@ -457,6 +494,7 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 	int ret;

 	spin_lock(&bo->lock);
+retry:
 	(void) ttm_bo_wait(bo, false, false, !remove_all);

 	if (!bo->sync_obj) {
@@ -465,32 +503,52 @@ static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
 		spin_unlock(&bo->lock);

 		spin_lock(&glob->lru_lock);
-		put_count = ttm_bo_del_from_lru(bo);
+		ret = ttm_bo_reserve_locked(bo, false, !remove_all, false, 0);
+
+		/**
+		 * Someone else has the object reserved. Bail and retry.
+		 */

-		ret = ttm_bo_reserve_locked(bo, false, false, false, 0);
-		BUG_ON(ret);
-		if (bo->ttm)
-			ttm_tt_unbind(bo->ttm);
+		if (unlikely(ret == -EBUSY)) {
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			goto requeue;
+		}
+
+		/**
+		 * We can re-check for sync object without taking
+		 * the bo::lock since setting the sync object requires
+		 * also bo::reserved. A busy object at this point may
+		 * be caused by another thread starting an accelerated
+		 * eviction.
+		 */
+
+		if (unlikely(bo->sync_obj)) {
+			atomic_set(&bo->reserved, 0);
+			wake_up_all(&bo->event_queue);
+			spin_unlock(&glob->lru_lock);
+			spin_lock(&bo->lock);
+			if (remove_all)
+				goto retry;
+			else
+				goto requeue;
+		}
+
+		put_count = ttm_bo_del_from_lru(bo);

 		if (!list_empty(&bo->ddestroy)) {
 			list_del_init(&bo->ddestroy);
 			++put_count;
 		}
-		if (bo->mem.mm_node) {
-			bo->mem.mm_node->private = NULL;
-			drm_mm_put_block(bo->mem.mm_node);
-			bo->mem.mm_node = NULL;
-		}
-		spin_unlock(&glob->lru_lock);

-		atomic_set(&bo->reserved, 0);
+		ttm_bo_cleanup_memtype_use(bo);

 		while (put_count--)
 			kref_put(&bo->list_kref, ttm_bo_ref_bug);

 		return 0;
 	}
-
+requeue:
 	spin_lock(&glob->lru_lock);
 	if (list_empty(&bo->ddestroy)) {
 		void *sync_obj = bo->sync_obj;
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 81eb9f4..d30dc3c 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -224,9 +224,11 @@ struct ttm_buffer_object {

 	atomic_t reserved;

-
 	/**
 	 * Members protected by the bo::lock
+	 * In addition, setting sync_obj to anything else
+	 * than NULL requires bo::reserved to be held. This allows for
+	 * checking NULL while reserved but not holding bo::lock.
 	 */

 	void *sync_obj_arg;
--
1.7.0.4

