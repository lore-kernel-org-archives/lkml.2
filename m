Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1BURik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:38:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58854 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754955Ab1BURhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:48 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+nle05US+nWaqNp4RIKl+k0VYD/kmpWLJ+lCuIvj
	OuF8SGbgTTv7XK
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/5] fsnotify: pass inode/mount as a parameter to fsnotify_destroy_[inode|vfsmount]_mark()
Date: Mon, 21 Feb 2011 18:33:26 +0100
Message-Id: <1298309609-19218-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the fsobject (inode/mount) as a parameter to fsnotify_destroy_[inode|vfsmount]_mark()
instead of taking it from the passed mark.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fsnotify.h      |    6 ++++--
 fs/notify/inode_mark.c    |    5 ++---
 fs/notify/mark.c          |    8 ++++----
 fs/notify/vfsmount_mark.c |    5 ++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 85e7d2b..8e2fc42 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -27,9 +27,11 @@ extern int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
 
 /* vfsmount specific destruction of a mark */
-extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
+extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark,
+					   struct vfsmount *mnt);
 /* inode specific destruction of a mark */
-extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
+extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark,
+					struct inode *inode);
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 /* run the list of all marks associated with vfsmount and flag them to be freed */
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 168a242..a9b8661 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -58,10 +58,9 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 	__fsnotify_update_child_dentry_flags(inode);
 }
 
-void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
+void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark,
+				 struct inode *inode)
 {
-	struct inode *inode = mark->i.inode;
-
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&inode->i_lock);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 422de6e..6d9bf1d 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -131,9 +131,9 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = mark->i.inode;
-		fsnotify_destroy_inode_mark(mark);
+		fsnotify_destroy_inode_mark(mark, inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
-		fsnotify_destroy_vfsmount_mark(mark);
+		fsnotify_destroy_vfsmount_mark(mark, mark->m.mnt);
 	else
 		BUG();
 	spin_unlock(&mark->lock);
@@ -290,9 +290,9 @@ void fsnotify_remove_mark_locked(struct fsnotify_mark *mark,
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = mark->i.inode;
-		fsnotify_destroy_inode_mark(mark);
+		fsnotify_destroy_inode_mark(mark, inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
-		fsnotify_destroy_vfsmount_mark(mark);
+		fsnotify_destroy_vfsmount_mark(mark, mark->m.mnt);
 	else
 		BUG();
 	spin_unlock(&mark->lock);
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index c43c310..b33e78b 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -82,10 +82,9 @@ void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 	spin_unlock(&mnt->mnt_root->d_lock);
 }
 
-void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
+void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark,
+				    struct vfsmount *mnt)
 {
-	struct vfsmount *mnt = mark->m.mnt;
-
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-- 
1.7.1

