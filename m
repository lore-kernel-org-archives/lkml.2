Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1BKKkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43057 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755922Ab1BKKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:41 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18L3kICveQLqqGxZjEfOwZq/d5KOofThmAxRdGRll
	rHTtsYg+Pz7b7H
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 3/7] fsnotify: introduce fsnotify_remove_mark()
Date: Fri, 11 Feb 2011 11:36:39 +0100
Message-Id: <1297420603-11715-4-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces fsnotify_remove_mark() which is the counterpart to
fsnotify_add_mark().
The implementation is equal to that of fsnotify_destroy_mark() with the difference
that the group is passed as a function argument and the group lock is taken first.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c                 |   74 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    3 ++
 2 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 1ac0447..3b00203 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -262,6 +262,80 @@ err:
 }
 
 /*
+ * Remove a mark from a given group and the fsobject.
+ * Must not be called for a mark that is not on the groups mark list.
+ */
+void fsnotify_remove_mark(struct fsnotify_mark *mark,
+			  struct fsnotify_group *group)
+{
+	struct inode *inode = NULL;
+
+	spin_lock(&group->mark_lock);
+	spin_lock(&mark->lock);
+
+	/* something else already called this function on this mark */
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+		spin_unlock(&mark->lock);
+		spin_unlock(&group->mark_lock);
+		return;
+	}
+
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+
+	/* 1 from caller and 1 for being on i_list/g_list */
+	BUG_ON(atomic_read(&mark->refcnt) < 2);
+
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
+		inode = mark->i.inode;
+		fsnotify_destroy_inode_mark(mark);
+	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
+		fsnotify_destroy_vfsmount_mark(mark);
+	else
+		BUG();
+	spin_unlock(&mark->lock);
+
+	list_del_init(&mark->g_list);
+	spin_unlock(&group->mark_lock);
+
+	spin_lock(&destroy_lock);
+	list_add(&mark->destroy_list, &destroy_list);
+	spin_unlock(&destroy_lock);
+	wake_up(&destroy_waitq);
+
+	/*
+	 * Some groups like to know that marks are being freed.  This is a
+	 * callback to the group function to let it know that this mark
+	 * is being freed.
+	 */
+	if (group->ops->freeing_mark)
+		group->ops->freeing_mark(mark, group);
+
+	/*
+	 * __fsnotify_update_child_dentry_flags(inode);
+	 *
+	 * I really want to call that, but we can't, we have no idea if the inode
+	 * still exists the second we drop the mark->lock.
+	 *
+	 * The next time an event arrive to this inode from one of it's children
+	 * __fsnotify_parent will see that the inode doesn't care about it's
+	 * children and will update all of these flags then.  So really this
+	 * is just a lazy update (and could be a perf win...)
+	 */
+
+	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
+		iput(inode);
+
+	/*
+	 * it's possible that this group tried to destroy itself, but this
+	 * this mark was simultaneously being freed by inode.  If that's the
+	 * case, we finish freeing the group here.
+	 */
+	if (unlikely(atomic_dec_and_test(&group->num_marks)))
+		fsnotify_final_destroy_group(group);
+}
+
+/*
  * clear any marks in a group in which mark->flags & flags is true
  */
 void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 6a3c660..c7bfee6 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -404,6 +404,9 @@ extern void fsnotify_set_mark_mask_locked(struct fsnotify_mark *mark, __u32 mask
 /* attach the mark to both the group and the inode */
 extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group,
 			     struct inode *inode, struct vfsmount *mnt, int allow_dups);
+/* remove a mark from a given group and fsobject */
+extern void fsnotify_remove_mark(struct fsnotify_mark *mark,
+				 struct fsnotify_group *group);
 /* given a mark, flag it to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and clear all of the vfsmount marks */
-- 
1.5.6.5

