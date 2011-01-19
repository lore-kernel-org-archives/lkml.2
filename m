Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1ASQro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:47:44 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:55847 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754634Ab1ASQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:03 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+6W8wiMY26FyWD1pAOBLdNtdu4vE94HTkbmhFjUO
	KcJ+WELFWmSecM
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 03/14] fsnotify: adjust locking in fsnotify_add_[inode|vfsmount]_mark()
Date: Wed, 19 Jan 2011 17:42:06 +0100
Message-Id: <1295455337-20219-4-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust fsnotify_add_[inode|vfsmount]_mark() to new locking order by taking the
inode/mount lock before the mark lock is taken. We also set all mark flags (after
we took the mark lock) in this function.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c    |   24 +++++++++++++++++++-----
 fs/notify/vfsmount_mark.c |   19 ++++++++++++++++---
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4c29fcf..8d35a84 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -188,14 +188,17 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	struct hlist_node *node, *last = NULL;
 	int ret = 0;
 
-	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
-
-	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&group->mark_lock);
+	/* get ref for mark on list */
+	fsnotify_get_mark(mark);
 
 	spin_lock(&inode->i_lock);
+	spin_lock(&mark->lock);
 
-	mark->i.inode = inode;
+	mark->group = group;
+	mark->i.inode = igrab(inode);
+	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
+	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
+	mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
 
 	/* is mark the first mark? */
 	if (hlist_empty(&inode->i_fsnotify_marks)) {
@@ -227,9 +230,20 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	/* mark should be the last entry.  last is the current last entry */
 	hlist_add_after_rcu(last, &mark->i.i_list);
 out:
+	spin_unlock(&mark->lock);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
 
+	if (ret) {
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_INODE;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		iput(mark->i.inode);
+		mark->group = NULL;
+		/* unget ref for mark on list */
+		fsnotify_put_mark(mark);
+	}
+
 	return ret;
 }
 
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 85eebff..35dc586 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -145,14 +145,17 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	struct hlist_node *node, *last = NULL;
 	int ret = 0;
 
-	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 
-	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&group->mark_lock);
+	/* get ref for mark on list */
+	fsnotify_get_mark(mark);
 
 	spin_lock(&mnt->mnt_root->d_lock);
+	spin_lock(&mark->lock);
 
+	mark->group = group;
 	mark->m.mnt = mnt;
+	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
+	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 
 	/* is mark the first mark? */
 	if (hlist_empty(&mnt->mnt_fsnotify_marks)) {
@@ -184,8 +187,18 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	/* mark should be the last entry.  last is the current last entry */
 	hlist_add_after_rcu(last, &mark->m.m_list);
 out:
+	spin_unlock(&mark->lock);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
+	if (ret) {
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		mark->m.mnt = NULL;
+		mark->group = NULL;
+		/* unget ref for mark on list */
+		fsnotify_put_mark(mark);
+	}
+
 	return ret;
 }
-- 
1.5.6.5

