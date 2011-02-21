Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1BURhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:37:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46373 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755484Ab1BURhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:37:53 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18bSOJH2t4b3GQb/TFmrs/WF64XZ80uxxfzsgjSR4
	e7bnMAmroAk9vo
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 5/5] fsnotify: dont lock fsobject with mark lock held
Date: Mon, 21 Feb 2011 18:33:29 +0100
Message-Id: <1298309609-19218-6-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch we dont lock a fsobject (inode/vfsmount) as long as we hold
the mark lock. Thus there is no strict locking order

1. mark lock
2. fsobject lock

any more.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c    |    7 ++++---
 fs/notify/vfsmount_mark.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index ea015c7..245828a 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -61,8 +61,6 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark,
 				 struct inode *inode)
 {
-	spin_lock(&mark->lock);
-
 	spin_lock(&inode->i_lock);
 	hlist_del_init_rcu(&mark->i.i_list);
 	/*
@@ -73,6 +71,7 @@ void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark,
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
 
+	spin_lock(&mark->lock);
 	if (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED) {
 		/*
 		 * __fsnotify_update_child_dentry_flags(inode);
@@ -209,6 +208,7 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
 	mark->i.inode = igrab(inode);
 	mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+	spin_unlock(&mark->lock);
 
 	spin_lock(&inode->i_lock);
 	/* is mark the first mark? */
@@ -245,14 +245,15 @@ out:
 	spin_unlock(&inode->i_lock);
 
 	if (ret) {
+		spin_lock(&mark->lock);
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
 		iput(mark->i.inode);
 		mark->i.inode = NULL;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_INODE;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 		mark->group = NULL;
+		spin_unlock(&mark->lock);
 	}
-	spin_unlock(&mark->lock);
 
 	return ret;
 }
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 71b6f64..bf50de1 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -85,13 +85,12 @@ void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark,
 				    struct vfsmount *mnt)
 {
-	spin_lock(&mark->lock);
-
 	spin_lock(&mnt->mnt_root->d_lock);
 	hlist_del_init_rcu(&mark->m.m_list);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
+	spin_lock(&mark->lock);
 	mark->m.mnt = NULL;
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
 	spin_unlock(&mark->lock);
@@ -148,6 +147,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 	mark->m.mnt = mnt;
+	spin_unlock(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
 	/* is mark the first mark? */
@@ -184,12 +184,13 @@ out:
 	spin_unlock(&mnt->mnt_root->d_lock);
 
 	if (ret) {
+		spin_lock(&mark->lock);
 		mark->m.mnt = NULL;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_VFSMOUNT;
 		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 		mark->group = NULL;
+		spin_unlock(&mark->lock);
 	}
-	spin_unlock(&mark->lock);
 
 	return ret;
 }
-- 
1.7.1

