Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab1BKKkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34669 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756083Ab1BKKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:45 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+AkEcQRpSALPSyNqBkCncC9rtbvAyXJFoRX3u3ov
	x+lPD98BRl7IXW
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 5/7] fsnotify: use a mutex instead of a spinlock to protect a groups mark list
Date: Fri, 11 Feb 2011 11:36:41 +0100
Message-Id: <1297420603-11715-6-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces the groups mark_lock spinlock with a mutex. Using a mutex instead
of a spinlock results in more flexibility (i.e it allows to sleep while the
lock is held).

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/group.c                |    2 +-
 fs/notify/inode_mark.c           |    2 --
 fs/notify/mark.c                 |   20 ++++++++++----------
 fs/notify/vfsmount_mark.c        |    2 --
 include/linux/fsnotify_backend.h |    2 +-
 5 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index cc341d3..a45bbfb 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -96,7 +96,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	init_waitqueue_head(&group->notification_waitq);
 	group->max_events = UINT_MAX;
 
-	spin_lock_init(&group->mark_lock);
+	mutex_init(&group->mark_mutex);
 	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4c29fcf..d438f11 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -63,7 +63,6 @@ void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
 	struct inode *inode = mark->i.inode;
 
 	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&mark->group->mark_lock);
 
 	spin_lock(&inode->i_lock);
 
@@ -191,7 +190,6 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
 
 	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&group->mark_lock);
 
 	spin_lock(&inode->i_lock);
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 3b00203..30b72b2 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -123,7 +123,7 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 	group = mark->group;
 	spin_unlock(&mark->lock);
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	spin_lock(&mark->lock);
 
 	/* 1 from caller and 1 for being on i_list/g_list */
@@ -140,7 +140,7 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 
 	list_del_init(&mark->g_list);
 
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -216,7 +216,7 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	 * group->mark_lock
 	 * inode->i_lock
 	 */
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	spin_lock(&mark->lock);
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
@@ -238,7 +238,7 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	fsnotify_set_mark_mask_locked(mark, mark->mask);
 
 	spin_unlock(&mark->lock);
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
@@ -251,7 +251,7 @@ err:
 	atomic_dec(&group->num_marks);
 
 	spin_unlock(&mark->lock);
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -270,13 +270,13 @@ void fsnotify_remove_mark(struct fsnotify_mark *mark,
 {
 	struct inode *inode = NULL;
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	spin_lock(&mark->lock);
 
 	/* something else already called this function on this mark */
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
 		spin_unlock(&mark->lock);
-		spin_unlock(&group->mark_lock);
+		mutex_unlock(&group->mark_mutex);
 		return;
 	}
 
@@ -296,7 +296,7 @@ void fsnotify_remove_mark(struct fsnotify_mark *mark,
 	spin_unlock(&mark->lock);
 
 	list_del_init(&mark->g_list);
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -344,7 +344,7 @@ void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
 	struct fsnotify_mark *lmark, *mark;
 	LIST_HEAD(free_list);
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
 		if (mark->flags & flags) {
 			list_add(&mark->free_g_list, &free_list);
@@ -352,7 +352,7 @@ void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
 			fsnotify_get_mark(mark);
 		}
 	}
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 
 	list_for_each_entry_safe(mark, lmark, &free_list, free_g_list) {
 		fsnotify_destroy_mark(mark);
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 85eebff..04f5929 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -87,7 +87,6 @@ void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
 	struct vfsmount *mnt = mark->m.mnt;
 
 	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&mark->group->mark_lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
 
@@ -148,7 +147,6 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 
 	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&group->mark_lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index c7bfee6..29ed5f8 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -142,7 +142,7 @@ struct fsnotify_group {
 	unsigned int priority;
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
-	spinlock_t mark_lock;		/* protect marks_list */
+	struct mutex mark_mutex;	/* protect marks_list */
 	atomic_t num_marks;		/* 1 for each mark and 1 for not being
 					 * past the point of no return when freeing
 					 * a group */
-- 
1.5.6.5

