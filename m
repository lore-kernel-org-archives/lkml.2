Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1BURiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:38:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45252 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753303Ab1BURhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:51 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18gNx0PcGUg2yobbnpVWyO6Kloqfn5JKrFToREvyc
	cNZNo4uJV30ps+
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 4/5] fsnotify: dont call fsnotify_destroy_[inode|vfsmount]_mark() with mark lock held.
Date: Mon, 21 Feb 2011 18:33:28 +0100
Message-Id: <1298309609-19218-5-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dont call fsnotify_destroy_[inode|vfsmount]_mark() with the mark lock already held,
but take the lock within these functions.

Also dont put inode in mark_destroy() but in inode_mark_destroy().

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c    |   27 ++++++++++++++---
 fs/notify/mark.c          |   72 +++++++++++++-------------------------------
 fs/notify/vfsmount_mark.c |   10 +++---
 3 files changed, 48 insertions(+), 61 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index b357e4b..ea015c7 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -61,21 +61,38 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark,
 				 struct inode *inode)
 {
-	assert_spin_locked(&mark->lock);
+	spin_lock(&mark->lock);
 
 	spin_lock(&inode->i_lock);
-
 	hlist_del_init_rcu(&mark->i.i_list);
-	mark->i.inode = NULL;
-
 	/*
 	 * this mark is now off the inode->i_fsnotify_marks list and we
 	 * hold the inode->i_lock, so this is the perfect time to update the
 	 * inode->i_fsnotify_mask
 	 */
 	fsnotify_recalc_inode_mask_locked(inode);
-
 	spin_unlock(&inode->i_lock);
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED) {
+		/*
+		 * __fsnotify_update_child_dentry_flags(inode);
+		 *
+		 * I really want to call that, but we can't, we have no idea if
+		 * the inode still exists the second we drop the mark->lock.
+		 *
+		 * The next time an event arrive to this inode from one of it's
+		 * children
+		 * __fsnotify_parent will see that the inode doesn't care about
+		 * it's children and will update all of these flags then.  So
+		 * really this is just a lazy update (and could be a perf
+		 * win...)
+		 */
+		iput(inode);
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+	}
+	mark->i.inode = NULL;
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_INODE;
+	spin_unlock(&mark->lock);
 }
 
 /*
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 57f8dd6..8743532 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -112,6 +112,7 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 {
 	struct fsnotify_group *group;
 	struct inode *inode = NULL;
+	struct vfsmount *mnt = NULL;
 
 	spin_lock(&mark->lock);
 	/* something else already called this function on this mark */
@@ -119,27 +120,26 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 		spin_unlock(&mark->lock);
 		return;
 	}
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE)
+		inode = mark->i.inode;
+	else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
+		mnt = mark->m.mnt;
+	else
+		BUG();
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	group = mark->group;
 	spin_unlock(&mark->lock);
 
 	mutex_lock(&group->mark_mutex);
-	spin_lock(&mark->lock);
-
 	/* 1 from caller and 1 for being on i_list/g_list */
 	BUG_ON(atomic_read(&mark->refcnt) < 2);
 
-	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
-		inode = mark->i.inode;
+	if (inode)
 		fsnotify_destroy_inode_mark(mark, inode);
-	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
-		fsnotify_destroy_vfsmount_mark(mark, mark->m.mnt);
-	else
-		BUG();
-	spin_unlock(&mark->lock);
+	else /* mount */
+		fsnotify_destroy_vfsmount_mark(mark, mnt);
 
 	list_del_init(&mark->g_list);
-
 	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
@@ -156,21 +156,6 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 		group->ops->freeing_mark(mark, group);
 
 	/*
-	 * __fsnotify_update_child_dentry_flags(inode);
-	 *
-	 * I really want to call that, but we can't, we have no idea if the inode
-	 * still exists the second we drop the mark->lock.
-	 *
-	 * The next time an event arrive to this inode from one of it's children
-	 * __fsnotify_parent will see that the inode doesn't care about it's
-	 * children and will update all of these flags then.  So really this
-	 * is just a lazy update (and could be a perf win...)
-	 */
-
-	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
-		iput(inode);
-
-	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
 	 * case, we finish freeing the group here.
@@ -217,7 +202,6 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 	if (ret)
 		goto err;
 
-
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
 
@@ -265,29 +249,30 @@ void fsnotify_remove_mark_locked(struct fsnotify_mark *mark,
 				 struct fsnotify_group *group)
 {
 	struct inode *inode = NULL;
+	struct vfsmount *mnt = NULL;
 
 	spin_lock(&mark->lock);
-
 	/* something else already called this function on this mark */
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
 		spin_unlock(&mark->lock);
 		return;
 	}
-
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE)
+		inode = mark->i.inode;
+	else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
+		mnt = mark->m.mnt;
+	else
+		BUG();
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	spin_unlock(&mark->lock);
 
 	/* 1 from caller and 1 for being on i_list/g_list */
 	BUG_ON(atomic_read(&mark->refcnt) < 2);
 
-
-	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
-		inode = mark->i.inode;
+	if (inode)
 		fsnotify_destroy_inode_mark(mark, inode);
-	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
-		fsnotify_destroy_vfsmount_mark(mark, mark->m.mnt);
-	else
-		BUG();
-	spin_unlock(&mark->lock);
+	else  /* mount */
+		fsnotify_destroy_vfsmount_mark(mark, mnt);
 
 	list_del_init(&mark->g_list);
 
@@ -305,21 +290,6 @@ void fsnotify_remove_mark_locked(struct fsnotify_mark *mark,
 		group->ops->freeing_mark(mark, group);
 
 	/*
-	 * __fsnotify_update_child_dentry_flags(inode);
-	 *
-	 * I really want to call that, but we can't, we have no idea if the inode
-	 * still exists the second we drop the mark->lock.
-	 *
-	 * The next time an event arrive to this inode from one of it's children
-	 * __fsnotify_parent will see that the inode doesn't care about it's
-	 * children and will update all of these flags then.  So really this
-	 * is just a lazy update (and could be a perf win...)
-	 */
-
-	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
-		iput(inode);
-
-	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
 	 * case, we finish freeing the group here.
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index a6fe562..71b6f64 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -85,16 +85,16 @@ void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark,
 				    struct vfsmount *mnt)
 {
-	assert_spin_locked(&mark->lock);
+	spin_lock(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-
 	hlist_del_init_rcu(&mark->m.m_list);
-	mark->m.mnt = NULL;
-
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-
 	spin_unlock(&mnt->mnt_root->d_lock);
+
+	mark->m.mnt = NULL;
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
+	spin_unlock(&mark->lock);
 }
 
 static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
-- 
1.7.1

