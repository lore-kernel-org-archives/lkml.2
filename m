Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0LBKFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:05:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48850 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752838Ab0LBKFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:05:48 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19lctY6IZFlNo4Rw5fq4CsWHVz4SsLREjGxW1mmRu
	1BBvLOritZFTVG
Date: Thu, 2 Dec 2010 11:03:43 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/6] fanotify: synchronize adding/removing a mark by means
	of group mutex
Message-ID: <20101202100343.GC5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When removing flags from the mask of a mark the mask may go to 0 and the mark should
be destroyed. But right before we destroy it there is a race which allows a
concurrent process to add flags to the mask of the same marks that we are going to destroy.
Thus we might end up destroying a mark that has not all flags cleared in its mask.

This patch uses the group mutex to serialize the access to a mark, so that a concurrent
concurrent process can no longer access it if it is going to be destroyed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   60 ++++++++++++++++++++++++++---------
 1 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5d2e683..c9cd1b9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -540,15 +540,21 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark = NULL;
 	__u32 removed;
+	int ret = 0;
 
+	mutex_lock(&group->mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
-	if (!fsn_mark)
-		return -ENOENT;
+	if (!fsn_mark) {
+		ret = -ENOENT;
+		goto err;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags);
 	fsnotify_put_mark(fsn_mark);
 	if (removed & mnt->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
+err:
+	mutex_unlock(&group->mutex);
 
 	return 0;
 }
@@ -559,16 +565,22 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark = NULL;
 	__u32 removed;
+	int ret = 0;
 
+	mutex_lock(&group->mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
-	if (!fsn_mark)
-		return -ENOENT;
+	if (!fsn_mark) {
+		ret = -ENOENT;
+		goto err;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags);
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
 	if (removed & inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
+err:
+	mutex_unlock(&group->mutex);
 
 	return 0;
 }
@@ -608,26 +620,34 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 	__u32 added;
 	int ret = 0;
 
+	mutex_lock(&group->mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
-			return -ENOSPC;
+		if (atomic_read(&group->num_marks) >
+		    group->fanotify_data.max_marks) {
+			ret = -ENOSPC;
+			goto err;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
-			return -ENOMEM;
+		if (!fsn_mark) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
 		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
 		if (ret)
-			goto err;
+			goto err2;
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
 
 	if (added & ~mnt->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
-err:
+err2:
 	fsnotify_put_mark(fsn_mark);
+err:
+	mutex_unlock(&group->mutex);
 	return ret;
 }
 
@@ -651,26 +671,34 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 	    (atomic_read(&inode->i_writecount) > 0))
 		return 0;
 
+	mutex_lock(&group->mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
-			return -ENOSPC;
+		if (atomic_read(&group->num_marks) >
+		    group->fanotify_data.max_marks) {
+			ret = -ENOSPC;
+			goto err;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
-			return -ENOMEM;
+		if (!fsn_mark) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
 		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
 		if (ret)
-			goto err;
+			goto err2;
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
 
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
-err:
+err2:
 	fsnotify_put_mark(fsn_mark);
+err:
+	mutex_unlock(&group->mutex);
 	return ret;
 }
 
-- 
1.5.6.5

