Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1ASQqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33717 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754692Ab1ASQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:07 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18z+ft3UMMzmRoNHhxIOeLyjGaGb1+efKbXN3iqvt
	ldtnc/RPCpK6YO
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 06/14] fsnotify:  clear fsobject marks with object lock held
Date: Wed, 19 Jan 2011 17:42:09 +0100
Message-Id: <1295455337-20219-7-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now possible to lock a mark with the fsobject lock held. So instead of
iterating the marks list of an inode/vfsmount and putting all marks on a temporary
free list and freeing that list afterwards, the marks are already freed
while the list is iterated.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inode_mark.c           |   28 +++++++++++++------
 fs/notify/vfsmount_mark.c        |   55 ++++++++++++++++++++-----------------
 include/linux/fsnotify_backend.h |    2 -
 3 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 7403404..35bd4e3 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -105,22 +105,32 @@ void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
  */
 void fsnotify_clear_marks_by_inode(struct inode *inode)
 {
-	struct fsnotify_mark *mark, *lmark;
+	struct fsnotify_mark *mark;
 	struct hlist_node *pos, *n;
-	LIST_HEAD(free_list);
 
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry_safe(mark, pos, n, &inode->i_fsnotify_marks, i.i_list) {
-		list_add(&mark->i.free_i_list, &free_list);
-		hlist_del_init_rcu(&mark->i.i_list);
-		fsnotify_get_mark(mark);
-	}
-	spin_unlock(&inode->i_lock);
+		spin_lock(&mark->lock);
+		if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+			spin_unlock(&mark->lock);
+			continue;
+		}
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		mark->i.inode = NULL;
 
-	list_for_each_entry_safe(mark, lmark, &free_list, i.free_i_list) {
-		fsnotify_destroy_mark(mark);
+		if (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED) {
+			iput(inode);
+			mark->flags &= ~FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+		}
+		spin_unlock(&mark->lock);
+
+		/* remove mark from inode */
+		hlist_del_init_rcu(&mark->i.i_list);
+		/* release ref from list */
 		fsnotify_put_mark(mark);
 	}
+	fsnotify_recalc_inode_mask_locked(inode);
+	spin_unlock(&inode->i_lock);
 }
 
 /*
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 20286e3..d253a39 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -30,31 +30,6 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
-{
-	struct fsnotify_mark *mark, *lmark;
-	struct hlist_node *pos, *n;
-	LIST_HEAD(free_list);
-
-	spin_lock(&mnt->mnt_root->d_lock);
-	hlist_for_each_entry_safe(mark, pos, n, &mnt->mnt_fsnotify_marks, m.m_list) {
-		list_add(&mark->m.free_m_list, &free_list);
-		hlist_del_init_rcu(&mark->m.m_list);
-		fsnotify_get_mark(mark);
-	}
-	spin_unlock(&mnt->mnt_root->d_lock);
-
-	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
-		fsnotify_destroy_mark(mark);
-		fsnotify_put_mark(mark);
-	}
-}
-
-void fsnotify_clear_vfsmount_marks_by_group(struct fsnotify_group *group)
-{
-	fsnotify_clear_marks_by_group_flags(group, FSNOTIFY_MARK_FLAG_VFSMOUNT);
-}
-
 /*
  * Recalculate the mask of events relevant to a given vfsmount locked.
  */
@@ -71,6 +46,36 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
 	mnt->mnt_fsnotify_mask = new_mask;
 }
 
+void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+	struct hlist_node *pos, *n;
+
+	spin_lock(&mnt->mnt_root->d_lock);
+	hlist_for_each_entry_safe(mark, pos, n, &mnt->mnt_fsnotify_marks, m.m_list) {
+		spin_lock(&mark->lock);
+		if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+			spin_unlock(&mark->lock);
+			continue;
+		}
+		mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+		mark->m.mnt = NULL;
+		spin_unlock(&mark->lock);
+
+		/* remove mark from vfsmount*/
+		hlist_del_init_rcu(&mark->m.m_list);
+		/* release ref from list */
+		fsnotify_put_mark(mark);
+	}
+	fsnotify_recalc_vfsmount_mask_locked(mnt);
+	spin_unlock(&mnt->mnt_root->d_lock);
+}
+
+void fsnotify_clear_vfsmount_marks_by_group(struct fsnotify_group *group)
+{
+	fsnotify_clear_marks_by_group_flags(group, FSNOTIFY_MARK_FLAG_VFSMOUNT);
+}
+
 /*
  * Recalculate the mnt->mnt_fsnotify_mask, or the mask of all FS_* event types
  * any notifier is interested in hearing for this mount point
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b018e78..f6891f9 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -255,7 +255,6 @@ struct fsnotify_event {
 struct fsnotify_inode_mark {
 	struct inode *inode;		/* inode this mark is associated with */
 	struct hlist_node i_list;	/* list of marks by inode->i_fsnotify_marks */
-	struct list_head free_i_list;	/* tmp list used when freeing this mark */
 };
 
 /*
@@ -264,7 +263,6 @@ struct fsnotify_inode_mark {
 struct fsnotify_vfsmount_mark {
 	struct vfsmount *mnt;		/* vfsmount this mark is associated with */
 	struct hlist_node m_list;	/* list of marks by inode->i_fsnotify_marks */
-	struct list_head free_m_list;	/* tmp list used when freeing this mark */
 };
 
 /*
-- 
1.5.6.5

