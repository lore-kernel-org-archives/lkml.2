Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1ASQ47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:56:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60435 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753028Ab1ASQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:56:57 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX190aC8Q4uZ02JT+WFSX64A4HNqCp4Lfc0Hc4ASNIe
	SzVTKx90i0I1Xu
Date: Wed, 19 Jan 2011 17:53:46 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 13/14] fsnotify: replace the group mutex with a groups
	mark_mutex
Message-ID: <20110119165346.GD20335@lsanfilippo.unix.rd.tt.avira.com>
Reply-To: 1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We dont need a dedicated mutex to synchronize addition and removal of a groups marks
any more, since we now can use mark_mutex for this purpose.
This patch replaces the group mutex with the mark_mutex.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c          |    8 ++++----
 fs/notify/fanotify/fanotify_user.c   |   16 ++++++++--------
 fs/notify/group.c                    |    1 -
 fs/notify/inotify/inotify_fsnotify.c |    4 ++--
 fs/notify/inotify/inotify_user.c     |    4 ++--
 include/linux/fsnotify_backend.h     |    1 -
 kernel/audit_tree.c                  |   20 ++++++++++----------
 kernel/audit_watch.c                 |    8 ++++----
 8 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 3dc1f25..9909104 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -182,7 +182,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_group->mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -202,7 +202,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	if (dn_mark->dn == NULL)
 		fsnotify_remove_mark_locked(fsn_mark);
 
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
@@ -387,7 +387,7 @@ out:
 	if (destroy)
 		fsnotify_remove_mark_locked(fsn_mark);
 
-	mutex_unlock(&dnotify_group->mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index afc2bb0..f65a5dc 100644
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
@@ -563,7 +563,7 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
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
@@ -710,7 +710,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 err2:
 	fsnotify_put_mark(fsn_mark);
 err:
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
 
diff --git a/fs/notify/group.c b/fs/notify/group.c
index d24ab1e..fb01b8f 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -81,7 +81,6 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	atomic_set(&group->refcnt, 1);
 	atomic_set(&group->num_marks, 0);
 
-	mutex_init(&group->mutex);
 	mutex_init(&group->notification_mutex);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index dec8b94..73f965c 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -131,9 +131,9 @@ static int inotify_handle_event(struct fsnotify_group *group,
 	}
 
 	if (inode_mark->mask & IN_ONESHOT) {
-		mutex_lock(&group->mutex);
+		mutex_lock(&group->mark_mutex);
 		fsnotify_remove_mark_locked(&i_mark->fsn_mark);
-		mutex_unlock(&group->mutex);
+		mutex_unlock(&group->mark_mutex);
 	}
 
 	return ret;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bd31742..813fa49 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -831,9 +831,9 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 
 	ret = 0;
 
-	mutex_lock(&group->mutex);
+	mutex_lock(&group->mark_mutex);
 	fsnotify_remove_mark_locked(&i_mark->fsn_mark);
-	mutex_unlock(&group->mutex);
+	mutex_unlock(&group->mark_mutex);
 
 	/* match ref taken by inotify_idr_find */
 	fsnotify_put_mark(&i_mark->fsn_mark);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3d270c2..5a7c2f6 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -125,7 +125,6 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
-	struct mutex mutex;
 	/* needed to send notification to userspace */
 	struct mutex notification_mutex;	/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 1c3ce71..cba611c 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -256,9 +256,9 @@ static void untag_chunk(struct node *p)
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
 
-		mutex_lock(&audit_tree_group->mutex);
+		mutex_lock(&audit_tree_group->mark_mutex);
 		fsnotify_remove_mark_locked(entry);
-		mutex_unlock(&audit_tree_group->mutex);
+		mutex_unlock(&audit_tree_group->mark_mutex);
 
 		fsnotify_put_mark(entry);
 		goto out;
@@ -304,9 +304,9 @@ static void untag_chunk(struct node *p)
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
 
-	mutex_lock(&audit_tree_group->mutex);
+	mutex_lock(&audit_tree_group->mark_mutex);
 	fsnotify_remove_mark_locked(entry);
-	mutex_unlock(&audit_tree_group->mutex);
+	mutex_unlock(&audit_tree_group->mark_mutex);
 
 	fsnotify_put_mark(entry);
 	goto out;
@@ -348,9 +348,9 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
 
-		mutex_lock(&audit_tree_group->mutex);
+		mutex_lock(&audit_tree_group->mark_mutex);
 		fsnotify_remove_mark_locked(entry);
-		mutex_unlock(&audit_tree_group->mutex);
+		mutex_unlock(&audit_tree_group->mark_mutex);
 
 		fsnotify_put_mark(entry);
 		return 0;
@@ -432,9 +432,9 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
-		mutex_lock(&audit_tree_group->mutex);
+		mutex_lock(&audit_tree_group->mark_mutex);
 		fsnotify_remove_mark_locked(chunk_entry);
-		mutex_unlock(&audit_tree_group->mutex);
+		mutex_unlock(&audit_tree_group->mark_mutex);
 
 		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
@@ -466,9 +466,9 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&chunk_entry->lock);
 	spin_unlock(&old_entry->lock);
 
-	mutex_lock(&audit_tree_group->mutex);
+	mutex_lock(&audit_tree_group->mark_mutex);
 	fsnotify_remove_mark_locked(old_entry);
-	mutex_unlock(&audit_tree_group->mutex);
+	mutex_unlock(&audit_tree_group->mark_mutex);
 
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
 	fsnotify_put_mark(old_entry); /* and kill it */
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index d859ec0..cdb55b2 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -350,9 +350,9 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 	}
 	mutex_unlock(&audit_filter_mutex);
 
-	mutex_lock(&audit_watch_group->mutex);
+	mutex_lock(&audit_watch_group->mark_mutex);
 	fsnotify_remove_mark_locked(&parent->mark);
-	mutex_unlock(&audit_watch_group->mutex);
+	mutex_unlock(&audit_watch_group->mark_mutex);
 }
 
 /* Get path information necessary for adding watches. */
@@ -500,9 +500,9 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 		if (list_empty(&parent->watches)) {
 			audit_get_parent(parent);
 
-			mutex_lock(&audit_watch_group->mutex);
+			mutex_lock(&audit_watch_group->mark_mutex);
 			fsnotify_remove_mark_locked(&parent->mark);
-			mutex_unlock(&audit_watch_group->mutex);
+			mutex_unlock(&audit_watch_group->mark_mutex);
 
 			audit_put_parent(parent);
 		}
-- 
1.5.6.5

