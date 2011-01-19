Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1ASQq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57217 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754744Ab1ASQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:25 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18Lthl3CggLok52IWw6zpujYH56fMHN6m3dObpKul
	wbX1Xo1+RYpKS6
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 10/14] fanotify,dnotify,inotify,audit: replace destroy_mark() with remove_mark_locked()
Date: Wed, 19 Jan 2011 17:42:13 +0100
Message-Id: <1295455337-20219-11-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify_destroy_mark() does not any longer remove a mark from its group. It
also does not any longer decrease the groups number of marks.
Thus all callers that used to call destroy_mark() should now call remove_mark_locked() 
with the group mutex held.
This patch replaces destroy_mark() with remove_mark_locked() and locks the
group mutex if needed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c          |    4 ++--
 fs/notify/fanotify/fanotify_user.c   |    4 ++--
 fs/notify/inotify/inotify_fsnotify.c |    7 +++++--
 fs/notify/inotify/inotify_user.c     |    4 +++-
 kernel/audit_tree.c                  |   28 +++++++++++++++++++++++-----
 kernel/audit_watch.c                 |   10 ++++++++--
 6 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index a81e97f..3dc1f25 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -200,7 +200,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	/* nothing else could have found us thanks to the dnotify_group mutex */
 	if (dn_mark->dn == NULL)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark_locked(fsn_mark);
 
 	mutex_unlock(&dnotify_group->mutex);
 
@@ -385,7 +385,7 @@ out:
 	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark_locked(fsn_mark);
 
 	mutex_unlock(&dnotify_group->mutex);
 	fsnotify_put_mark(fsn_mark);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index a8d93e1..afc2bb0 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -556,7 +556,7 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark_locked(fsn_mark);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & mnt->mnt_fsnotify_mask)
@@ -586,7 +586,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark_locked(fsn_mark);
 
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index a91b69a..dec8b94 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -130,8 +130,11 @@ static int inotify_handle_event(struct fsnotify_group *group,
 			ret = PTR_ERR(added_event);
 	}
 
-	if (inode_mark->mask & IN_ONESHOT)
-		fsnotify_destroy_mark(inode_mark);
+	if (inode_mark->mask & IN_ONESHOT) {
+		mutex_lock(&group->mutex);
+		fsnotify_remove_mark_locked(&i_mark->fsn_mark);
+		mutex_unlock(&group->mutex);
+	}
 
 	return ret;
 }
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bb91b53..bd31742 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -831,7 +831,9 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 
 	ret = 0;
 
-	fsnotify_destroy_mark(&i_mark->fsn_mark);
+	mutex_lock(&group->mutex);
+	fsnotify_remove_mark_locked(&i_mark->fsn_mark);
+	mutex_unlock(&group->mutex);
 
 	/* match ref taken by inotify_idr_find */
 	fsnotify_put_mark(&i_mark->fsn_mark);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 4b50ccc..1c3ce71 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -255,7 +255,11 @@ static void untag_chunk(struct node *p)
 		list_del_rcu(&chunk->hash);
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark(entry);
+
+		mutex_lock(&audit_tree_group->mutex);
+		fsnotify_remove_mark_locked(entry);
+		mutex_unlock(&audit_tree_group->mutex);
+
 		fsnotify_put_mark(entry);
 		goto out;
 	}
@@ -299,7 +303,11 @@ static void untag_chunk(struct node *p)
 		owner->root = new;
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
-	fsnotify_destroy_mark(entry);
+
+	mutex_lock(&audit_tree_group->mutex);
+	fsnotify_remove_mark_locked(entry);
+	mutex_unlock(&audit_tree_group->mutex);
+
 	fsnotify_put_mark(entry);
 	goto out;
 
@@ -339,7 +347,11 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark(entry);
+
+		mutex_lock(&audit_tree_group->mutex);
+		fsnotify_remove_mark_locked(entry);
+		mutex_unlock(&audit_tree_group->mutex);
+
 		fsnotify_put_mark(entry);
 		return 0;
 	}
@@ -420,7 +432,9 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
-		fsnotify_destroy_mark(chunk_entry);
+		mutex_lock(&audit_tree_group->mutex);
+		fsnotify_remove_mark_locked(chunk_entry);
+		mutex_unlock(&audit_tree_group->mutex);
 
 		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
@@ -451,7 +465,11 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&hash_lock);
 	spin_unlock(&chunk_entry->lock);
 	spin_unlock(&old_entry->lock);
-	fsnotify_destroy_mark(old_entry);
+
+	mutex_lock(&audit_tree_group->mutex);
+	fsnotify_remove_mark_locked(old_entry);
+	mutex_unlock(&audit_tree_group->mutex);
+
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
 	fsnotify_put_mark(old_entry); /* and kill it */
 	return 0;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 6a57231..d859ec0 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -350,7 +350,9 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 	}
 	mutex_unlock(&audit_filter_mutex);
 
-	fsnotify_destroy_mark(&parent->mark);
+	mutex_lock(&audit_watch_group->mutex);
+	fsnotify_remove_mark_locked(&parent->mark);
+	mutex_unlock(&audit_watch_group->mutex);
 }
 
 /* Get path information necessary for adding watches. */
@@ -497,7 +499,11 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 
 		if (list_empty(&parent->watches)) {
 			audit_get_parent(parent);
-			fsnotify_destroy_mark(&parent->mark);
+
+			mutex_lock(&audit_watch_group->mutex);
+			fsnotify_remove_mark_locked(&parent->mark);
+			mutex_unlock(&audit_watch_group->mutex);
+
 			audit_put_parent(parent);
 		}
 	}
-- 
1.5.6.5

