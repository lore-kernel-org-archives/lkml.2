Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1BKKkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44002 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755973Ab1BKKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:47 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX198pQxJsA18LcFMM92yBGmA9ZCDSFXzlczj5dNtAv
	2xMwDWL8oC9CDm
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 6/7] fsnotify: introduce locked versions of fsnotify_add_mark() and fsnotify_remove_mark()
Date: Fri, 11 Feb 2011 11:36:42 +0100
Message-Id: <1297420603-11715-7-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces fsnotify_add_mark_locked() and fsnotify_remove_mark_locked()
which are essentially the same as fsnotify_add_mark and fsnotify_remove_mark() but
assume that the caller has already taken the groups mark mutex.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c                 |   69 +++++++++++++++++++++++---------------
 include/linux/fsnotify_backend.h |    6 +++
 2 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 30b72b2..11cfedc 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -196,27 +196,12 @@ void fsnotify_set_mark_ignored_mask_locked(struct fsnotify_mark *mark, __u32 mas
 	mark->ignored_mask = mask;
 }
 
-/*
- * Attach an initialized mark to a given group and fs object.
- * These marks may be used for the fsnotify backend to determine which
- * event types should be delivered to which group.
- */
-int fsnotify_add_mark(struct fsnotify_mark *mark,
-		      struct fsnotify_group *group, struct inode *inode,
-		      struct vfsmount *mnt, int allow_dups)
+int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
+			     struct fsnotify_group *group, struct inode *inode,
+			     struct vfsmount *mnt, int allow_dups)
 {
 	int ret;
 
-	BUG_ON(inode && mnt);
-	BUG_ON(!inode && !mnt);
-
-	/*
-	 * LOCKING ORDER!!!!
-	 * mark->lock
-	 * group->mark_lock
-	 * inode->i_lock
-	 */
-	mutex_lock(&group->mark_mutex);
 	spin_lock(&mark->lock);
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
@@ -238,7 +223,6 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	fsnotify_set_mark_mask_locked(mark, mark->mask);
 
 	spin_unlock(&mark->lock);
-	mutex_unlock(&group->mark_mutex);
 
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
@@ -251,7 +235,6 @@ err:
 	atomic_dec(&group->num_marks);
 
 	spin_unlock(&mark->lock);
-	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -262,21 +245,42 @@ err:
 }
 
 /*
- * Remove a mark from a given group and the fsobject.
- * Must not be called for a mark that is not on the groups mark list.
+ * Attach an initialized mark to a given group and fs object.
+ * These marks may be used for the fsnotify backend to determine which
+ * event types should be delivered to which group.
  */
-void fsnotify_remove_mark(struct fsnotify_mark *mark,
-			  struct fsnotify_group *group)
+int fsnotify_add_mark(struct fsnotify_mark *mark,
+		      struct fsnotify_group *group, struct inode *inode,
+		      struct vfsmount *mnt, int allow_dups)
 {
-	struct inode *inode = NULL;
+	int ret;
+
+	BUG_ON(inode && mnt);
+	BUG_ON(!inode && !mnt);
 
+	/*
+	 * LOCKING ORDER!!!!
+	 * mark->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
 	mutex_lock(&group->mark_mutex);
+	ret = fsnotify_add_mark_locked(mark, group, inode, mnt, allow_dups);
+	mutex_unlock(&group->mark_mutex);
+
+	return ret;
+}
+
+void fsnotify_remove_mark_locked(struct fsnotify_mark *mark,
+				 struct fsnotify_group *group)
+{
+	struct inode *inode = NULL;
+
 	spin_lock(&mark->lock);
 
 	/* something else already called this function on this mark */
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
 		spin_unlock(&mark->lock);
-		mutex_unlock(&group->mark_mutex);
 		return;
 	}
 
@@ -296,7 +300,6 @@ void fsnotify_remove_mark(struct fsnotify_mark *mark,
 	spin_unlock(&mark->lock);
 
 	list_del_init(&mark->g_list);
-	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -336,6 +339,18 @@ void fsnotify_remove_mark(struct fsnotify_mark *mark,
 }
 
 /*
+ * Remove a mark from a given group and the fsobject.
+ * Must not be called for a mark that is not on the groups mark list.
+ */
+void fsnotify_remove_mark(struct fsnotify_mark *mark,
+			  struct fsnotify_group *group)
+{
+	mutex_lock(&group->mark_mutex);
+	fsnotify_remove_mark_locked(mark, group);
+	mutex_unlock(&group->mark_mutex);
+}
+
+/*
  * clear any marks in a group in which mark->flags & flags is true
  */
 void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 29ed5f8..073f6a9 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -404,9 +404,15 @@ extern void fsnotify_set_mark_mask_locked(struct fsnotify_mark *mark, __u32 mask
 /* attach the mark to both the group and the inode */
 extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group,
 			     struct inode *inode, struct vfsmount *mnt, int allow_dups);
+extern int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
+				    struct fsnotify_group *group,
+				    struct inode *inode, struct vfsmount *mnt,
+				    int allow_dups);
 /* remove a mark from a given group and fsobject */
 extern void fsnotify_remove_mark(struct fsnotify_mark *mark,
 				 struct fsnotify_group *group);
+extern void fsnotify_remove_mark_locked(struct fsnotify_mark *mark,
+					struct fsnotify_group *group);
 /* given a mark, flag it to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and clear all of the vfsmount marks */
-- 
1.5.6.5

