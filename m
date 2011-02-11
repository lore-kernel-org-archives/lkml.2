Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1BKKkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755329Ab1BKKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:38 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18QyX1JU2sQqUG5OkKrAEQ3ZF0raZMBX7Hgygx16n
	6qGIfbH+CWDMqB
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/7] fanotify: add an extra flag to mark_remove_from_mask that indicates wheather a mark could be destroyed
Date: Fri, 11 Feb 2011 11:36:38 +0100
Message-Id: <1297420603-11715-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an extra flag to mark_remove_from_mask() to inform the caller if
all masks of a mark have been cleared and the mark could be destroyed.
With this we dont destroy the mark implicitly in the function itself any more
but let the caller handle it.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2d4925b..848648f 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -516,7 +516,8 @@ out:
 
 static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    __u32 mask,
-					    unsigned int flags)
+					    unsigned int flags,
+					    int *destroy)
 {
 	__u32 oldmask;
 	int destroy_mark;
@@ -532,8 +533,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 	destroy_mark = (!fsn_mark->mask && !fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
 
-	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark);
+	*destroy = destroy_mark;
 
 	return mask & oldmask;
 }
@@ -544,6 +544,7 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark = NULL;
 	__u32 removed;
+	int destroy_mark;
 	int ret;
 
 	mutex_lock(&group->mutex);
@@ -552,7 +553,11 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	if (!fsn_mark)
 		goto err;
 
-	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags);
+	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
+						 &destroy_mark);
+	if (destroy_mark)
+		fsnotify_destroy_mark(fsn_mark);
+
 	fsnotify_put_mark(fsn_mark);
 	if (removed & mnt->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
@@ -569,6 +574,7 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark = NULL;
 	__u32 removed;
+	int destroy_mark;
 	int ret;
 
 	mutex_lock(&group->mutex);
@@ -577,7 +583,11 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	if (!fsn_mark)
 		goto err;
 
-	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags);
+	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
+						 &destroy_mark);
+	if (destroy_mark)
+		fsnotify_destroy_mark(fsn_mark);
+
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
 	if (removed & inode->i_fsnotify_mask)
-- 
1.5.6.5

