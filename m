Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1ASQrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:47:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60085 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754629Ab1ASQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:06 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+2bJFbmwa2GOq0Bj6CotK6x+kTP7M/0KbbqboNAW
	bsyxxoYpFTxH90
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 05/14] fsnotify: synchronize mark_srcu after a mark has been removed from a fsobject
Date: Wed, 19 Jan 2011 17:42:08 +0100
Message-Id: <1295455337-20219-6-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of synchronizing mark_srcu after when a group is being destroyed,
we call it for each mark that is unlinked from its inode.
Synchronizing ensures that no more readers (callers of fsnotify()) are
referencing the mark when we decrement the marks ref count (and thus
possibly free it).
Since we can call synchronize_srcu without holding a lock, we dont need
to destroy the marks in a dedicated kernel thread any more.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/group.c         |    2 --
 fs/notify/inode_mark.c    |   38 +++++++++++++++++++++++++++++---------
 fs/notify/vfsmount_mark.c |   30 +++++++++++++++++++++++-------
 3 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index cc341d3..0dcf497 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -55,8 +55,6 @@ static void fsnotify_destroy_group(struct fsnotify_group *group)
 	/* clear all inode marks for this group */
 	fsnotify_clear_marks_by_group(group);
 
-	synchronize_srcu(&fsnotify_mark_srcu);
-
 	/* past the point of no return, matches the initial value of 1 */
 	if (atomic_dec_and_test(&group->num_marks))
 		fsnotify_final_destroy_group(group);
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 8d35a84..7403404 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -60,24 +60,44 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 
 void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
 {
-	struct inode *inode = mark->i.inode;
+	struct inode *inode;
 
-	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&mark->group->mark_lock);
+	/* prepare removal from inode */
+	spin_lock(&mark->lock);
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+		spin_unlock(&mark->lock);
+		return;
+	}
+	inode = mark->i.inode;
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	spin_unlock(&mark->lock);
 
+	/* remove mark from inode */
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
+	/* wait until no readers (callers of fsnotify()) reference this
+	   mark any more */
+	synchronize_srcu(&fsnotify_mark_srcu);
+
+	/* do rest of removal */
+	spin_lock(&mark->lock);
+	if (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED) {
+		iput(inode);
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+		mark->i.inode = NULL;
+	}
+	spin_unlock(&mark->lock);
+
+	/* release ref from list */
+	fsnotify_put_mark(mark);
 }
 
 /*
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 35dc586..20286e3 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -84,19 +84,35 @@ void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
 {
-	struct vfsmount *mnt = mark->m.mnt;
+	struct vfsmount *mnt;
 
-	assert_spin_locked(&mark->lock);
-	assert_spin_locked(&mark->group->mark_lock);
+	/* prepare removal from vfsmount */
+	spin_lock(&mark->lock);
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+		spin_unlock(&mark->lock);
+		return;
+	}
+	mnt = mark->m.mnt;
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	spin_unlock(&mark->lock);
 
+	/* remove mark from vfsmount */
 	spin_lock(&mnt->mnt_root->d_lock);
-
 	hlist_del_init_rcu(&mark->m.m_list);
-	mark->m.mnt = NULL;
-
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-
 	spin_unlock(&mnt->mnt_root->d_lock);
+
+	/* wait until no readers (callers of fsnotify()) reference this
+	   mark any more */
+	synchronize_srcu(&fsnotify_mark_srcu);
+
+	/* do rest of removal */
+	spin_lock(&mark->lock);
+	mark->m.mnt = NULL;
+	spin_unlock(&mark->lock);
+
+	/* release ref from list */
+	fsnotify_put_mark(mark);
 }
 
 static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
-- 
1.5.6.5

