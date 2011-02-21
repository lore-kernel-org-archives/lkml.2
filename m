Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1BURhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:37:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:32993 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755082Ab1BURht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:49 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18kIlhWBuwk2p9JiApDfV9SoyOj4pO0949VUoDSYE
	0MUs+IK/AaFx4t
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 3/5] fsnotify: dont call fsnotify_add_[inode|vfsmount]_mark() with mark lock held.
Date: Mon, 21 Feb 2011 18:33:27 +0100
Message-Id: <1298309609-19218-4-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dont call fsnotify_add_[inode|vfsmount]_mark() with the mark lock already held,
but take the lock in these functions.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c    |    8 ++++++--
 fs/notify/mark.c          |    8 --------
 fs/notify/vfsmount_mark.c |    8 ++++++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index a9b8661..b357e4b 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -186,12 +186,13 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	struct hlist_node *node, *last = NULL;
 	int ret = 0;
 
+	spin_lock(&mark->lock);
+	mark->group = group;
+	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
 	mark->i.inode = igrab(inode);
 	mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
 
-	assert_spin_locked(&mark->lock);
-
 	spin_lock(&inode->i_lock);
 	/* is mark the first mark? */
 	if (hlist_empty(&inode->i_fsnotify_marks)) {
@@ -231,7 +232,10 @@ out:
 		iput(mark->i.inode);
 		mark->i.inode = NULL;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_INODE;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		mark->group = NULL;
 	}
+	spin_unlock(&mark->lock);
 
 	return ret;
 }
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 6d9bf1d..57f8dd6 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -202,10 +202,7 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 {
 	int ret;
 
-	spin_lock(&mark->lock);
 
-	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
-	mark->group = group;
 	list_add(&mark->g_list, &group->marks_list);
 	fsnotify_get_mark(mark); /* for i_list and g_list */
 	atomic_inc(&group->num_marks);
@@ -220,20 +217,15 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 	if (ret)
 		goto err;
 
-	spin_unlock(&mark->lock);
 
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
 
 	return 0;
 err:
-	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	list_del_init(&mark->g_list);
-	mark->group = NULL;
 	atomic_dec(&group->num_marks);
 
-	spin_unlock(&mark->lock);
-
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
 	spin_unlock(&destroy_lock);
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index b33e78b..a6fe562 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -143,11 +143,12 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	struct hlist_node *node, *last = NULL;
 	int ret = 0;
 
+	spin_lock(&mark->lock);
+	mark->group = group;
+	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 	mark->m.mnt = mnt;
 
-	assert_spin_locked(&mark->lock);
-
 	spin_lock(&mnt->mnt_root->d_lock);
 	/* is mark the first mark? */
 	if (hlist_empty(&mnt->mnt_fsnotify_marks)) {
@@ -185,7 +186,10 @@ out:
 	if (ret) {
 		mark->m.mnt = NULL;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		mark->group = NULL;
 	}
+	spin_unlock(&mark->lock);
 
 	return ret;
 }
-- 
1.7.1

