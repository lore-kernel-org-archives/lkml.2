Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0KISUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:20:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753025Ab0KISUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:20:38 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19uzlI4Y9RuiniLFz16D7xqBB2SCIGyiWhgPE8LLi
	4F0fy+nKrGXqum
Date: Tue, 9 Nov 2010 19:19:04 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fanotify: Do check against max_marks and increase number
	of group marks atomically
Message-ID: <20101109181904.GB5867@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    
    The number of group marks is checked against max_marks and increased afterwards
    in a non atomic way. This may result in 2 or more processes passing the check
    at the same time and increasing the number of group marks above the max_marks
    limit afterwards.
    With this patch the check against max_marks is done in fsnotify_add_mark(),
    after the group lock has been aquired to ensure that concurrent processes
    cant exceed the group marks limit.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
This patch applies against  branch 'origin/for-next' from 
git.infradead.org/users/eparis/notify.git and depends on the patch "correct 
broken ref counting in case adding a mark failed" i have sent before. 

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 090790a..05095e5 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -609,9 +609,6 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
-			return -ENOSPC;
-
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
 		if (!fsn_mark)
 			return -ENOMEM;
@@ -652,9 +649,6 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
-			return -ENOSPC;
-
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
 		if (!fsn_mark)
 			return -ENOMEM;
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index efe16e4..12d09f8 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -220,21 +220,27 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	spin_lock(&mark->lock);
 	spin_lock(&group->mark_lock);
 
+	fsnotify_get_mark(mark); /* for i_list and g_list */
+
+	if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+		ret = -ENOSPC;
+		goto err;
+	}
+
 	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
 
 	mark->group = group;
 	list_add(&mark->g_list, &group->marks_list);
 	atomic_inc(&group->num_marks);
-	fsnotify_get_mark(mark); /* for i_list and g_list */
 
 	if (inode) {
 		ret = fsnotify_add_inode_mark(mark, group, inode, allow_dups);
 		if (ret)
-			goto err;
+			goto err2;
 	} else if (mnt) {
 		ret = fsnotify_add_vfsmount_mark(mark, group, mnt, allow_dups);
 		if (ret)
-			goto err;
+			goto err2;
 	} else {
 		BUG();
 	}
@@ -250,12 +256,12 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 		__fsnotify_update_child_dentry_flags(inode);
 
 	return ret;
-err:
+err2:
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 	list_del_init(&mark->g_list);
 	mark->group = NULL;
 	atomic_dec(&group->num_marks);
-
+err:
 	spin_unlock(&group->mark_lock);
 	spin_unlock(&mark->lock);
 
