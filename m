Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1BURht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:37:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34223 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753303Ab1BURhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:46 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18pDYMdnHIp2T/y7/Jc/lXmyEvojWXq6HvhOMFjLy
	QsGpkvKIRbZ0kJ
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/5] fsnotify: grab inode ref in add_inode_mark() instead of add_mark()
Date: Mon, 21 Feb 2011 18:33:25 +0100
Message-Id: <1298309609-19218-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the type of a mark is checked in fsnotify_add_mark() and if its an
inode mark a ref is grabbed. Since this part is only needed for inode marks it
is shiftet to add_inode_mark().
Beside this the fsobject is assigned to the mark outside of the fsobject lock.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c    |   12 +++++++++---
 fs/notify/mark.c          |    2 --
 fs/notify/vfsmount_mark.c |    9 ++++++---
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index d438f11..168a242 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -188,13 +188,12 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	int ret = 0;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
+	mark->i.inode = igrab(inode);
+	mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
 
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&inode->i_lock);
-
-	mark->i.inode = inode;
-
 	/* is mark the first mark? */
 	if (hlist_empty(&inode->i_fsnotify_marks)) {
 		hlist_add_head_rcu(&mark->i.i_list, &inode->i_fsnotify_marks);
@@ -228,6 +227,13 @@ out:
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
 
+	if (ret) {
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+		iput(mark->i.inode);
+		mark->i.inode = NULL;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_INODE;
+	}
+
 	return ret;
 }
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 11cfedc..422de6e 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -219,8 +219,6 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 		BUG();
 	if (ret)
 		goto err;
-	/* this will pin the object if appropriate */
-	fsnotify_set_mark_mask_locked(mark, mark->mask);
 
 	spin_unlock(&mark->lock);
 
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 04f5929..c43c310 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -145,13 +145,11 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	int ret = 0;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
+	mark->m.mnt = mnt;
 
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-
-	mark->m.mnt = mnt;
-
 	/* is mark the first mark? */
 	if (hlist_empty(&mnt->mnt_fsnotify_marks)) {
 		hlist_add_head_rcu(&mark->m.m_list, &mnt->mnt_fsnotify_marks);
@@ -185,5 +183,10 @@ out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
+	if (ret) {
+		mark->m.mnt = NULL;
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
+	}
+
 	return ret;
 }
-- 
1.7.1

