Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1BKKkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35489 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755973Ab1BKKkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:43 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+Ff3JX3BqFK8oz8/fMP3BDb+dMpH24pdM6L08F0G
	1XDZWmnpLVYPnj
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 4/7] fsnotify: replace most calls of fsnotify_destroy_mark() with fsnotify_remove_mark()
Date: Fri, 11 Feb 2011 11:36:40 +0100
Message-Id: <1297420603-11715-5-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces all calls of fsnotify_destroy_mark with calls to
fsnotify_remove_mark(). The exception is for fsnotify_clear_marks_by[inode|mount]()
where we dont have a group argumente in the caller available.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c          |    4 ++--
 fs/notify/fanotify/fanotify_user.c   |    4 ++--
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 fs/notify/inotify/inotify_user.c     |    2 +-
 kernel/audit_tree.c                  |   10 +++++-----
 kernel/audit_watch.c                 |    4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 89ec7e0..5dfd35a 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -200,7 +200,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	/* nothing else could have found us thanks to the dnotify_group mutex */
 	if (dn_mark->dn == NULL)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark(fsn_mark, dnotify_group);
 
 	mutex_unlock(&dnotify_group->mutex);
 
@@ -384,7 +384,7 @@ out:
 	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark(fsn_mark, dnotify_group);
 
 	mutex_unlock(&dnotify_group->mutex);
 	fsnotify_put_mark(fsn_mark);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 848648f..c441b91 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -556,7 +556,7 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark(fsn_mark, group);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & mnt->mnt_fsnotify_mask)
@@ -586,7 +586,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark);
+		fsnotify_remove_mark(fsn_mark, group);
 
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index a91b69a..c999fd3 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -131,7 +131,7 @@ static int inotify_handle_event(struct fsnotify_group *group,
 	}
 
 	if (inode_mark->mask & IN_ONESHOT)
-		fsnotify_destroy_mark(inode_mark);
+		fsnotify_remove_mark(inode_mark, group);
 
 	return ret;
 }
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4cd5d5d..1637820 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -830,7 +830,7 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 
 	ret = 0;
 
-	fsnotify_destroy_mark(&i_mark->fsn_mark);
+	fsnotify_remove_mark(&i_mark->fsn_mark, group);
 
 	/* match ref taken by inotify_idr_find */
 	fsnotify_put_mark(&i_mark->fsn_mark);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 37b2bea..07078ba 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -255,7 +255,7 @@ static void untag_chunk(struct node *p)
 		list_del_rcu(&chunk->hash);
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark(entry);
+		fsnotify_remove_mark(entry, audit_tree_group);
 		fsnotify_put_mark(entry);
 		goto out;
 	}
@@ -298,7 +298,7 @@ static void untag_chunk(struct node *p)
 		owner->root = new;
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
-	fsnotify_destroy_mark(entry);
+	fsnotify_remove_mark(entry, audit_tree_group);
 	fsnotify_put_mark(entry);
 	goto out;
 
@@ -338,7 +338,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark(entry);
+		fsnotify_remove_mark(entry, audit_tree_group);
 		fsnotify_put_mark(entry);
 		return 0;
 	}
@@ -418,7 +418,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
-		fsnotify_destroy_mark(chunk_entry);
+		fsnotify_remove_mark(chunk_entry, audit_tree_group);
 
 		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
@@ -449,7 +449,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&hash_lock);
 	spin_unlock(&chunk_entry->lock);
 	spin_unlock(&old_entry->lock);
-	fsnotify_destroy_mark(old_entry);
+	fsnotify_remove_mark(old_entry, audit_tree_group);
 	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
 	fsnotify_put_mark(old_entry); /* and kill it */
 	return 0;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index d2e3c78..b50c857 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -349,7 +349,7 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 	}
 	mutex_unlock(&audit_filter_mutex);
 
-	fsnotify_destroy_mark(&parent->mark);
+	fsnotify_remove_mark(&parent->mark, audit_watch_group);
 }
 
 /* Get path information necessary for adding watches. */
@@ -496,7 +496,7 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 
 		if (list_empty(&parent->watches)) {
 			audit_get_parent(parent);
-			fsnotify_destroy_mark(&parent->mark);
+			fsnotify_remove_mark(&parent->mark, audit_watch_group);
 			audit_put_parent(parent);
 		}
 	}
-- 
1.5.6.5

