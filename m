Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0KIRTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:19:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36668 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752658Ab0KIRTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:19:52 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18r99g22H0rC0Cdg1zDpLCJeOxhy+xMNYUaj9QSVk
	+j5xhX9jHhtaw0
Date: Tue, 9 Nov 2010 18:18:16 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fanotify: correct broken ref counting in case adding a
	mark failed
Message-ID: <20101109171816.GB14516@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    If adding a mount or inode mark failed fanotify_free_mark() is called explicitly.
    But at this time the mark has already been put into the destroy list of the
    fsnotify_mark kernel thread. If the thread is too slow it will try to decrease
    the reference of a mark, that has already been freed by fanotify_free_mark().
    (If its fast enough it will only decrease the marks ref counter from 2 to 1 - note
    that the counter has been increased to 2 in add_mark() - which has practically no
    effect.)
    This patch fixes the ref counting by not calling free_mark() explicitly, but
    decreasing the ref counter and rely on the fsnotify_mark thread to cleanup in
    case adding the mark has failed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
This patch applies against commit 02478ec882e057e33fbdd8f1ba245fdfa5a355fb
of branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index a7a9d84..090790a 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -605,11 +605,10 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
+	int ret = 0;
 
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		int ret;
-
 		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
 			return -ENOSPC;
 
@@ -619,17 +618,16 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
 		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
-		if (ret) {
-			fanotify_free_mark(fsn_mark);
-			return ret;
-		}
+		if (ret) 
+			goto err;
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
-	fsnotify_put_mark(fsn_mark);
+
 	if (added & ~mnt->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
-
-	return 0;
+err:
+	fsnotify_put_mark(fsn_mark);
+	return ret;
 }
 
 static int fanotify_add_inode_mark(struct fsnotify_group *group,
@@ -638,6 +636,7 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
+	int ret = 0;
 
 	pr_debug("%s: group=%p inode=%p\n", __func__, group, inode);
 
@@ -653,8 +652,6 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		int ret;
-
 		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
 			return -ENOSPC;
 
@@ -664,16 +661,16 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
 		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
-		if (ret) {
-			fanotify_free_mark(fsn_mark);
-			return ret;
-		}
+		if (ret) 
+			goto err;
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
-	fsnotify_put_mark(fsn_mark);
+
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
-	return 0;
+err:
+	fsnotify_put_mark(fsn_mark);
+	return ret;
 }
 
 /* fanotify syscalls */
