Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1ASQqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46508 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754604Ab1ASQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:05 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1844DY/5kk4mMDkFEF8CLc8nOWW45CUwet/YMhg/x
	3ULbwo5Ddfly/C
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 04/14] fsnotify: simplify fsnotify_destroy_mark()
Date: Wed, 19 Jan 2011 17:42:07 +0100
Message-Id: <1295455337-20219-5-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce fsnotify_destroy_mark() to remove a mark from an inode or a vfsmount.
We dont put a mark on the destroy_list any more.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c |   68 +----------------------------------------------------
 1 files changed, 2 insertions(+), 66 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 247cbdf..916a291 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -110,74 +110,10 @@ static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
  */
 void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 {
-	struct fsnotify_group *group;
-	struct inode *inode = NULL;
-
-	spin_lock(&mark->lock);
-
-	group = mark->group;
-
-	/* something else already called this function on this mark */
-	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
-		spin_unlock(&mark->lock);
-		return;
-	}
-
-	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
-
-	/* 1 from caller and 1 for being on i_list/g_list */
-	BUG_ON(atomic_read(&mark->refcnt) < 2);
-
-	spin_lock(&group->mark_lock);
-
-	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
-		inode = mark->i.inode;
-		fsnotify_destroy_inode_mark(mark);
-	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
+	if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
 		fsnotify_destroy_vfsmount_mark(mark);
 	else
-		BUG();
-
-	list_del_init(&mark->g_list);
-
-	spin_unlock(&group->mark_lock);
-	spin_unlock(&mark->lock);
-
-	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
-	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
-
-	/*
-	 * Some groups like to know that marks are being freed.  This is a
-	 * callback to the group function to let it know that this mark
-	 * is being freed.
-	 */
-	if (group->ops->freeing_mark)
-		group->ops->freeing_mark(mark, group);
-
-	/*
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
-	 * it's possible that this group tried to destroy itself, but this
-	 * this mark was simultaneously being freed by inode.  If that's the
-	 * case, we finish freeing the group here.
-	 */
-	if (unlikely(atomic_dec_and_test(&group->num_marks)))
-		fsnotify_final_destroy_group(group);
+		fsnotify_destroy_inode_mark(mark);
 }
 
 void fsnotify_set_mark_mask_locked(struct fsnotify_mark *mark, __u32 mask)
-- 
1.5.6.5

