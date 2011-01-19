Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1ASQsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:48:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60263 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754623Ab1ASQqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:02 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+/RgdqxxO/FvXa+9Sq9aP8WHDPhNd42f3bX6zMS1
	is5zF1Ckv/X20c
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 02/14] fsnotify: rename fsnotify_add_mark() to fsnotify_add_mark_locked()
Date: Wed, 19 Jan 2011 17:42:05 +0100
Message-Id: <1295455337-20219-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assume that the caller of fsnotify_add_mark() has taken the group->mark_lock
itself, so we should rename the function to fsnotify_add_mark_locked().

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c        |    3 ++-
 fs/notify/fanotify/fanotify_user.c |    4 ++--
 fs/notify/inotify/inotify_user.c   |    3 ++-
 fs/notify/mark.c                   |    7 ++++---
 include/linux/fsnotify_backend.h   |    6 ++++--
 kernel/audit_tree.c                |    8 +++++---
 kernel/audit_watch.c               |    3 ++-
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 89ec7e0..a81e97f 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
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
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2d4925b..41bfdfd 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -638,7 +638,7 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 			goto err;
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
+		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
 		if (ret)
 			goto err2;
 	}
@@ -688,7 +688,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 			goto err;
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
+		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
 		if (ret)
 			goto err2;
 	}
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4cd5d5d..bb91b53 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -656,7 +656,8 @@ static int inotify_new_watch(struct fsnotify_group *group,
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, NULL, 0);
+	ret = fsnotify_add_mark_locked(&tmp_i_mark->fsn_mark, group, inode,
+				       NULL, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index a677af0..247cbdf 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -201,10 +201,11 @@ void fsnotify_set_mark_ignored_mask_locked(struct fsnotify_mark *mark, __u32 mas
  * Attach an initialized mark to a given group and fs object.
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group.
+ * Requires groups mark_lock to be held.
  */
-int fsnotify_add_mark(struct fsnotify_mark *mark,
-		      struct fsnotify_group *group, struct inode *inode,
-		      struct vfsmount *mnt, int allow_dups)
+int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
+			     struct fsnotify_group *group, struct inode *inode,
+			     struct vfsmount *mnt, int allow_dups)
 {
 	int ret;
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6a3c660..b018e78 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -402,8 +402,10 @@ extern void fsnotify_set_mark_ignored_mask_locked(struct fsnotify_mark *mark, __
 /* set the mask of a mark (might pin the object into memory */
 extern void fsnotify_set_mark_mask_locked(struct fsnotify_mark *mark, __u32 mask);
 /* attach the mark to both the group and the inode */
-extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group,
-			     struct inode *inode, struct vfsmount *mnt, int allow_dups);
+extern int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
+				    struct fsnotify_group *group,
+				    struct inode *inode, struct vfsmount *mnt,
+				    int allow_dups);
 /* given a mark, flag it to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and clear all of the vfsmount marks */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 37b2bea..4b50ccc 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -264,7 +264,8 @@ static void untag_chunk(struct node *p)
 		goto Fallback;
 
 	fsnotify_duplicate_mark(&new->mark, entry);
-	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, NULL, 1)) {
+	if (fsnotify_add_mark_locked(&new->mark, new->mark.group,
+				     new->mark.i.inode, NULL, 1)) {
 		free_chunk(new);
 		goto Fallback;
 	}
@@ -327,7 +328,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		return -ENOMEM;
 
 	entry = &chunk->mark;
-	if (fsnotify_add_mark(entry, audit_tree_group, inode, NULL, 0)) {
+	if (fsnotify_add_mark_locked(entry, audit_tree_group, inode, NULL, 0)) {
 		free_chunk(chunk);
 		return -ENOSPC;
 	}
@@ -400,7 +401,8 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	}
 
 	fsnotify_duplicate_mark(chunk_entry, old_entry);
-	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, NULL, 1)) {
+	if (fsnotify_add_mark_locked(chunk_entry, chunk_entry->group,
+				     chunk_entry->i.inode, NULL, 1)) {
 		spin_unlock(&old_entry->lock);
 		free_chunk(chunk);
 		fsnotify_put_mark(old_entry);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index d2e3c78..6a57231 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -158,7 +158,8 @@ static struct audit_parent *audit_init_parent(struct nameidata *ndp)
 
 	fsnotify_init_mark(&parent->mark, audit_watch_free_mark);
 	parent->mark.mask = AUDIT_FS_WATCH;
-	ret = fsnotify_add_mark(&parent->mark, audit_watch_group, inode, NULL, 0);
+	ret = fsnotify_add_mark_locked(&parent->mark, audit_watch_group, inode,
+				       NULL, 0);
 	if (ret < 0) {
 		audit_free_parent(parent);
 		return ERR_PTR(ret);
-- 
1.5.6.5

