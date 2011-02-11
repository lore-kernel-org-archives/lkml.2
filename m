Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1BKKlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:41:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41116 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756147Ab1BKKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:49 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX193utEBGod3LjIqjWUuAEjZqiVtkGxfs7q1kUF6lZ
	QfxDF0HfUWZO6r
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 7/7] fsnotify: replace the groups mutex with the groups mark list mutex
Date: Fri, 11 Feb 2011 11:36:43 +0100
Message-Id: <1297420603-11715-8-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the group mutex with the group mark_mutex to ensure
race-free addition and removal of marks to/from groups.
It also replaces calls to fsnotify_[add|remove]_mark() with calls to
fsnotify_[add|remove]_mark_locked() whenever the group mark_mutex is already
held.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c        |   13 +++++++------
 fs/notify/fanotify/fanotify_user.c |   24 ++++++++++++------------
 fs/notify/group.c                  |    1 -
 include/linux/fsnotify_backend.h   |    1 -
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 5dfd35a..9aa4ccd 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -182,7 +182,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_group->mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -200,9 +200,9 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	/* nothing else could have found us thanks to the dnotify_group mutex */
 	if (dn_mark->dn == NULL)
-		fsnotify_remove_mark(fsn_mark, dnotify_group);
+		fsnotify_remove_mark_locked(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_group->mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
 }
@@ -325,7 +325,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
-	mutex_lock(&dnotify_group->mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	/* add the new_fsn_mark or find an old one. */
 	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
@@ -333,7 +333,8 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 		dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 		spin_lock(&fsn_mark->lock);
 	} else {
-		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, NULL, 0);
+		fsnotify_add_mark_locked(new_fsn_mark, dnotify_group, inode,
+					 NULL, 0);
 		spin_lock(&new_fsn_mark->lock);
 		fsn_mark = new_fsn_mark;
 		dn_mark = new_dn_mark;
@@ -386,7 +387,7 @@ out:
 	if (destroy)
 		fsnotify_remove_mark(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_group->mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c441b91..f52b47b 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -547,7 +547,7 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	int destroy_mark;
 	int ret;
 
-	mutex_lock(&group->mutex);
+	mutex_lock(&group->mark_mutex);
 	ret = -ENOENT;
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark)
@@ -556,14 +556,14 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_remove_mark(fsn_mark, group);
+		fsnotify_remove_mark_locked(fsn_mark, group);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & mnt->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
 	ret = 0;
 err:
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 
 	return ret;
 }
@@ -577,7 +577,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	int destroy_mark;
 	int ret;
 
-	mutex_lock(&group->mutex);
+	mutex_lock(&group->mark_mutex);
 	ret = -ENOENT;
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
@@ -586,7 +586,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_remove_mark(fsn_mark, group);
+		fsnotify_remove_mark_locked(fsn_mark, group);
 
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
@@ -594,7 +594,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 		fsnotify_recalc_inode_mask(inode);
 	ret = 0;
 err:
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 
 	return ret;
 }
@@ -634,7 +634,7 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 	__u32 added;
 	int ret;
 
-	mutex_lock(&group->mutex);
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
 		ret = -ENOSPC;
@@ -648,7 +648,7 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 			goto err;
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
+		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
 		if (ret)
 			goto err2;
 	}
@@ -660,7 +660,7 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 err2:
 	fsnotify_put_mark(fsn_mark);
 err:
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
 
@@ -684,7 +684,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 	    (atomic_read(&inode->i_writecount) > 0))
 		return 0;
 
-	mutex_lock(&group->mutex);
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
 		ret = -ENOSPC;
@@ -698,7 +698,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 			goto err;
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
+		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
 		if (ret)
 			goto err2;
 	}
@@ -710,7 +710,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 err2:
 	fsnotify_put_mark(fsn_mark);
 err:
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
 
diff --git a/fs/notify/group.c b/fs/notify/group.c
index a45bbfb..c86e3fb 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -90,7 +90,6 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	 */
 	atomic_set(&group->num_marks, 1);
 
-	mutex_init(&group->mutex);
 	mutex_init(&group->notification_mutex);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 073f6a9..e4100db 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -125,7 +125,6 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
-	struct mutex mutex;
 	/* needed to send notification to userspace */
 	struct mutex notification_mutex;	/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
-- 
1.5.6.5

